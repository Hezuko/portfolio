require("dotenv").config();
var express = require("express");
var path = require("path");
var cookieParser = require("cookie-parser");
var logger = require("morgan");
var expressLayouts = require("express-ejs-layouts");
var compression = require("compression");
var session = require("./config/session");
var portfolioRepository = require("./model/portfolioRepository");
var { formatContractType, formatDateRange, formatLevel, formatProjectCategory, formatStatus } = require("./utils/formatters");
var { techIconUrl } = require("./utils/techIcons");
var { cloudinaryUrl, cloudinarySrcset } = require("./utils/cloudinary");
var { techFamily, FAMILY_ORDER } = require("./utils/techFamily");
const csrf = require("csurf");

// Version d'assets : stable par release (hash git court, fallback version package).
// Casse le cache navigateur seulement à un nouveau déploiement, pas à chaque redémarrage.
const ASSET_VERSION = (() => {
  try {
    return require("child_process").execSync("git rev-parse --short HEAD", { stdio: ["ignore", "pipe", "ignore"] }).toString().trim();
  } catch (e) {
    try { return require("./package.json").version || "1"; } catch (_) { return "1"; }
  }
})();

// Import des routes
var publicRouter = require("./routes/public");
var adminRouter = require("./routes/admin");
var authentificationRouter = require("./routes/authentification");

var app = express();

// Garde-fou déploiement : sans SITE_URL en prod, canonical/OG/JSON-LD/sitemap retombent
// sur l'hôte de la requête (risque d'indexer une mauvaise origine).
if (process.env.NODE_ENV === "production" && !process.env.SITE_URL) {
  console.warn("⚠️  SITE_URL non défini en production — les URLs absolues (canonical, OG, JSON-LD, sitemap) utiliseront l'hôte de la requête. Définir SITE_URL=https://<domaine>.");
}

// Derrière un reverse-proxy (Caddy) : req.protocol reflète https, canonical/OG corrects
app.set("trust proxy", 1);

// SEO : une seule forme d'URL. On retire le slash final (hors racine) en 301 → pas de doublon.
app.use((req, res, next) => {
  if (req.method === "GET" && req.path.length > 1 && req.path.endsWith("/")) {
    return res.redirect(301, req.path.slice(0, -1) + req.url.slice(req.path.length));
  }
  next();
});

// 🟢 Configuration du moteur de vue
app.set("views", path.join(__dirname, "views"));
app.set("view engine", "ejs");

// 🟢 Activer les layouts
app.use(expressLayouts);
app.set("layout", "layout");

// 📦 Compression gzip/br de toutes les réponses (HTML/CSS/JS) — gros gain réseau
app.use(compression());

// 🟢 Fichiers statiques servis AVANT session/CSRF/locals : un asset (CSS/JS/police/favicon)
// ne paie ni le token CSRF, ni le cookie, ni la chaîne de rendu des vues.
app.use(express.static(path.join(__dirname, "public"), { maxAge: "7d" }));
app.get("/favicon.ico", (req, res) => res.status(204).end());
app.use("/css", express.static(path.join(__dirname, "node_modules/bootstrap/dist/css"), { immutable: true, maxAge: "30d" }));
app.use("/js", express.static(path.join(__dirname, "node_modules/bootstrap/dist/js"), { immutable: true, maxAge: "30d" }));

// 🛡️ Initialiser la session avant CSRF
app.use(session.initSession());

// 🟢 Middlewares
app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser()); // ✅ Doit être AVANT `csurf()`

// 🛡️ Protection CSRF pour toutes les requêtes (pas seulement POST)
const csrfProtection = csrf({ cookie: true });
app.use(csrfProtection);

// 🔹 Ajouter le token CSRF dans toutes les vues
app.use((req, res, next) => {
  res.locals.csrfToken = req.csrfToken();
  res.locals.currentPath = req.path;
  res.locals.formatDate = (date) => {
    if (!date) return "Aujourd'hui";
    return new Intl.DateTimeFormat("fr-FR", { month: "short", year: "numeric" }).format(new Date(date));
  };
  res.locals.formatList = (value) => {
    if (Array.isArray(value)) return value.filter(Boolean);
    if (!value) return [];
    return String(value)
      .split(/\r?\n|,/)
      .map((item) => item.trim())
      .filter(Boolean);
  };
  res.locals.formatDateRange = formatDateRange;
  res.locals.formatContractType = formatContractType;
  res.locals.formatLevel = formatLevel;
  res.locals.formatProjectCategory = formatProjectCategory;
  res.locals.formatStatus = formatStatus;
  res.locals.techIconUrl = techIconUrl;
  res.locals.cloudinaryUrl = cloudinaryUrl;
  res.locals.cloudinarySrcset = cloudinarySrcset;
  res.locals.techFamily = techFamily;
  res.locals.familyOrder = FAMILY_ORDER;
  res.locals.assetVersion = ASSET_VERSION;
  // Peau caméléon par catégorie (whitelist : pas de classe muette pour une catégorie inconnue)
  res.locals.skinClass = (cat) => {
    const c = String(cat || "").toLowerCase();
    return ["web", "mobile", "ai", "robotics", "electronique"].includes(c) ? "skin-" + c : "";
  };

  // 🔎 SEO / partage : valeurs par défaut, surchargeables par chaque route.
  const host = req.get("host");
  res.locals.siteUrl = process.env.SITE_URL || `${req.protocol}://${host}`;
  res.locals.canonicalUrl = res.locals.siteUrl + (req.path === "/" ? "" : req.path);
  res.locals.description =
    "Henoc Mukumbi, ingénieur systèmes embarqués. Je conçois l'électronique et le logiciel qui tourne dessus : du circuit imprimé au cloud, de l'app mobile au coach IA.";
  res.locals.ogImage =
    "https://res.cloudinary.com/portfolio-hezuko/image/upload/f_auto,q_auto,w_1200,h_630,c_fill,g_face/v1740309643/henoc_r0fiwi.jpg";
  // Portrait FIXE du Person (JSON-LD) — découplé de l'og:image qui varie par page (sinon
  // l'image d'un projet deviendrait "la photo de Henoc" dans les données structurées).
  res.locals.personImage =
    "https://res.cloudinary.com/portfolio-hezuko/image/upload/f_auto,q_auto,w_640,h_640,c_fill,g_face/v1740309643/henoc_r0fiwi.jpg";
  res.locals.robots = /^\/(admin|authentification)/.test(req.path) ? "noindex,nofollow" : "index,follow";
  res.locals.ogType = "website";
  res.locals.currentPath = req.path;
  next();
});

app.use(async (req, res, next) => {
  const defaultName = "Henoc Mukumbi";
  try {
    const settings = await portfolioRepository.getSettingsMap();
    const name = settings.profile_name || defaultName;
    res.locals.siteProfile = {
      name,
      footerText: settings.profile_tagline || "Ingénieur systèmes embarqués — du circuit imprimé au cloud.",
      email: settings.contact_email || "h.mukumbi100@gmail.com",
      github: settings.github_url || "https://github.com/Hezuko",
      linkedin: settings.linkedin_url || "https://www.linkedin.com/in/henocmukumbi",
      cv: settings.cv_url || "https://hezuko.github.io/resume/resume.pdf",
    };
  } catch (err) {
    res.locals.siteProfile = {
      name: defaultName,
      footerText: "Portfolio personnel, projets, parcours et experiences.",
      email: "h.mukumbi100@gmail.com",
      github: "https://github.com/Hezuko",
      linkedin: "https://www.linkedin.com/in/henocmukumbi",
      cv: "https://hezuko.github.io/resume/resume.pdf",
    };
  }
  next();
});

// 🟢 Définition de l'utilisateur global pour les vues
app.use((req, res, next) => {
  res.locals.user = req.session?.user || null;
  next();
});

app.use((err, req, res, next) => {
  if (err.code === "EBADCSRFTOKEN") {
      console.error("❌ Erreur CSRF détectée :", err.message);
      return res.status(403).send("Invalid CSRF token.");
  }
  next(err); // Passe aux autres gestionnaires d'erreur
});


// 🔒 Restriction d'accès au back-office par IP (configurable, sûr par défaut).
// ADMIN_IP_ALLOWLIST = IP autorisées séparées par des virgules (ex. "1.2.3.4,5.6.7.8").
// Vide / non défini = AUCUNE restriction (évite de se verrouiller avant configuration).
const { parseAllowlist, normalizeIp, isAllowed } = require("./utils/ipAllowlist");
const adminIpAllowlist = parseAllowlist(process.env.ADMIN_IP_ALLOWLIST);

app.use(["/authentification", "/admin"], (req, res, next) => {
  if (isAllowed(adminIpAllowlist, req.ip)) return next();
  // IP non autorisée → 404 furtif (le back-office fait comme s'il n'existait pas)
  console.warn(`⛔ Back-office refusé depuis ${normalizeIp(req.ip)} (${req.method} ${req.originalUrl})`);
  return res.status(404).render("errors/404", { title: "Erreur 404", robots: "noindex,nofollow" });
});

// 🛠️ Définition des routes
app.use("/authentification", authentificationRouter);
app.use("/admin", adminRouter);
app.use("/", publicRouter);

// 🚨 Gestion des erreurs

// ❌ 404 - Page non trouvée (la protection /admin est gérée dans adminRouter)
app.use((req, res, next) => {
  res.status(404).render("errors/404", { title: "Erreur 404", robots: "noindex,nofollow" });
});

// ❌ 500 - Erreur interne du serveur
app.use((err, req, res, next) => {
  console.error("🚨 Erreur serveur :", err.stack);
  res.status(500).render("errors/500", { title: "Erreur 500", robots: "noindex,nofollow" });
});

module.exports = app;
