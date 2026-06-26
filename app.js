require("dotenv").config();
var createError = require("http-errors");
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

// Version d'assets : change à chaque démarrage → casse le cache navigateur après un déploiement
const ASSET_VERSION = Date.now().toString(36);

// Import des routes
var publicRouter = require("./routes/public");
var adminRouter = require("./routes/admin");
var authentificationRouter = require("./routes/authentification");

var app = express();

// Valeurs par défaut utilisées par le layout, même si la session échoue.
app.use((req, res, next) => {
  res.locals.user = null;
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
  res.locals.robots = /^\/(admin|authentification)/.test(req.path) ? "noindex,nofollow" : "index,follow";
  next();
});

// 🟢 Servir les fichiers statiques (cache long : les assets changent peu)
app.use(express.static(path.join(__dirname, "public"), { maxAge: "7d" }));
app.get("/favicon.ico", (req, res) => res.status(204).end());

// 🟢 Routes pour Bootstrap CSS & JS
app.use(
  "/css",
  express.static(path.join(__dirname, "node_modules/bootstrap/dist/css"))
);
app.use(
  "/js",
  express.static(path.join(__dirname, "node_modules/bootstrap/dist/js"))
);

app.use(async (req, res, next) => {
  const defaultName = "Henoc Mukumbi";
  try {
    const settings = await portfolioRepository.getSettingsMap();
    const name = settings.profile_name || defaultName;
    res.locals.siteProfile = {
      name,
      footerText: settings.profile_tagline || "Ingénieur systèmes embarqués — du circuit imprimé au cloud.",
    };
  } catch (err) {
    res.locals.siteProfile = {
      name: defaultName,
      footerText: "Portfolio personnel, projets, parcours et experiences.",
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


// 🛠️ Définition des routes
app.use("/authentification", authentificationRouter);
app.use("/admin", adminRouter);
app.use("/", publicRouter);

// 🚨 Gestion des erreurs

// ❌ Catch 403 - Accès interdit
app.use((req, res, next) => {
  if (req.url.includes("/admin") && !req.user) {
    return res.status(403).render("errors/403", { title: "Erreur 403" });
  }
  next();
});

// ❌ Catch 404 - Page non trouvée
app.use((req, res, next) => {
  res.status(404).render("errors/404", { title: "Erreur 404", robots: "noindex,nofollow" });
});

// ❌ Catch 500 - Erreur interne du serveur
app.use((err, req, res, next) => {
  console.error("🚨 Erreur serveur :", err.stack);
  res.status(500).render("errors/500", { title: "Erreur 500", robots: "noindex,nofollow" });
});

// ❌ Gestion des autres erreurs
app.use(function (err, req, res, next) {
  res.locals.message = err.message;
  res.locals.error = req.app.get("env") === "development" ? err : {};

  res.status(err.status || 500);
  res.render("error", {
    message: err.message,
    error: err,
    title: "Erreur",
  });
});

module.exports = app;
