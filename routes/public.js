var express = require("express");
var router = express.Router();
var validator = require("validator");
var contact = require("../model/contact");
var mailer = require("../model/mailer");
var repo = require("../model/portfolioRepository");
var { formatLevel } = require("../utils/formatters");
var { cloudinaryUrl } = require("../utils/cloudinary");

function shortText(value, max = 300) {
  const s = String(value || "").replace(/\s+/g, " ").trim();
  if (s.length <= max) return s;
  const cut = s.slice(0, max - 1);
  const lastSpace = cut.lastIndexOf(" ");
  // On coupe sur la dernière frontière de mot pour un snippet propre (pas de mot tronqué).
  return (lastSpace > max * 0.6 ? cut.slice(0, lastSpace) : cut).trimEnd() + "…";
}

// Anti-spam : limiteur simple en mémoire (5 envois / 10 min / IP), sans dépendance externe.
const contactHits = new Map();
function contactRateLimited(ip) {
  const now = Date.now();
  const windowMs = 10 * 60 * 1000;
  const max = 5;
  const hits = (contactHits.get(ip) || []).filter((t) => now - t < windowMs);
  if (hits.length >= max) {
    contactHits.set(ip, hits);
    return true;
  }
  hits.push(now);
  contactHits.set(ip, hits);
  if (contactHits.size > 5000) { // garde-fou mémoire : purge des IP expirées
    for (const [k, v] of contactHits) if (!v.some((t) => now - t < windowMs)) contactHits.delete(k);
  }
  return false;
}

const profile = {
  name: "Henoc Mukumbi",
  role: "Ingénieur architecte en systèmes embarqués",
  tagline: "Ingénieur architecte en systèmes embarqués — je conçois un produit de A à Z, du circuit imprimé au cloud.",
  about:
    "Si je devais me définir : ingénieur-architecte en systèmes embarqués. Ce que j'aime, c'est concevoir un produit de A à Z — du schéma électronique jusqu'à la ligne de code qui le fait vivre.",
  email: "h.mukumbi100@gmail.com",
  github: "https://github.com/Hezuko",
  linkedin: "https://www.linkedin.com/in/henocmukumbi",
  cv: "https://hezuko.github.io/resume/resume.pdf",
  availability: "",
  photo: "https://res.cloudinary.com/portfolio-hezuko/image/upload/v1740309643/henoc_r0fiwi.jpg",
};

function buildProfile(settings = {}) {
  return {
    ...profile,
    name: settings.profile_name || profile.name,
    role: settings.profile_title || profile.role,
    tagline: settings.profile_tagline || profile.tagline,
    about: settings.profile_about || profile.about,
    availability: settings.profile_availability || profile.availability,
    email: settings.contact_email || profile.email,
    github: settings.github_url || profile.github,
    linkedin: settings.linkedin_url || profile.linkedin,
    cv: settings.cv_url || profile.cv,
    photo: repo.signMediaValue(settings.profile_photo) || profile.photo,
  };
}

const legal = {
  siteName: "Portfolio Henoc Mukumbi",
  publisherName: "Henoc Mukumbi",
  publisherStatus: "Particulier - a adapter si le site est rattache a une activite professionnelle",
  publisherEmail: profile.email,
  publicationDirector: "Henoc Mukumbi",
  hostingProvider: "Hebergeur a completer avant mise en production",
  hostingAddress: "Adresse de l'hebergeur a completer",
  hostingWebsite: "",
  dataController: "Henoc Mukumbi",
  contactEmail: profile.email,
  retentionContact: "Les messages de contact sont conserves le temps necessaire au traitement de la demande, puis supprimes ou archives selon leur utilite.",
  lastUpdated: "12 mai 2026",
};

function normalizeTerm(value) {
  return String(value || "")
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase();
}

function classifyDomain(category = "", name = "") {
  const value = normalizeTerm(`${category} ${name}`);
  if (/embarque|stm32|firmware|micro|pic|temps reel|vhdl|fpga/.test(value)) return "Systèmes embarqués";
  if (/electron|pcb|kicad|altium|ultiboard|capteur|oscillo|instrument/.test(value)) return "Électronique & instrumentation";
  if (/test|validation|can|lin|canoe|rtrt|tracabilite|qualite/.test(value)) return "Test & validation";
  if (/backend|base|postgres|node|express|django|python|logiciel/.test(value)) return "Développement logiciel";
  if (/front|javascript|react|html|css/.test(value)) return "Frontend";
  if (/devops|docker|git|linux|github|gitlab|outil/.test(value)) return "DevOps & outils";
  if (/matlab|simulink|solidworks|robot|ros|vision|cao|simulation/.test(value)) return "Simulation & robotique";
  return category || "Autres compétences";
}

function buildLegal(settings = {}, currentProfile = buildProfile(settings)) {
  return {
    ...legal,
    siteName: settings.legal_site_name || `Portfolio ${currentProfile.name}`,
    publisherName: settings.legal_publisher_name || currentProfile.name,
    publisherStatus: settings.legal_publisher_status || legal.publisherStatus,
    publisherEmail: currentProfile.email,
    publicationDirector: settings.legal_publication_director || currentProfile.name,
    hostingProvider: settings.legal_hosting_provider || legal.hostingProvider,
    hostingAddress: settings.legal_hosting_address || legal.hostingAddress,
    hostingWebsite: settings.legal_hosting_website || legal.hostingWebsite,
    dataController: settings.legal_data_controller || currentProfile.name,
    contactEmail: currentProfile.email,
    retentionContact: settings.legal_retention_contact || legal.retentionContact,
    lastUpdated: settings.legal_last_updated || legal.lastUpdated,
  };
}

router.get("/", async function (req, res, next) {
  try {
    const data = await repo.getPublicData();
    res.render("public/home", { title: "Henoc Mukumbi — Ingénieur systèmes embarqués", profile: buildProfile(settingsToMap(data.settings)), ...data });
  } catch (err) {
    next(err);
  }
});

router.get("/projets", async function (req, res, next) {
  try {
    const data = await repo.getPublicData();
    res.render("public/projects", { title: "Projets", description: "Les projets de Henoc Mukumbi : systèmes embarqués (PIC, STM32), robotique, et JoyTrain — app fitness avec coach IA et moteur RAG. Du circuit imprimé au cloud.", profile: buildProfile(settingsToMap(data.settings)), projects: data.projects });
  } catch (err) {
    next(err);
  }
});

router.get("/projets/:slug", async function (req, res, next) {
  try {
    const project = await repo.findProjectBySlug(req.params.slug);
    if (!project) return res.status(404).render("errors/404", { title: "Projet introuvable" });
    const settings = await repo.getSettingsMap();
    const projImg = project.main_image_url || project.main_image;
    res.render("public/project-detail", {
      title: project.name,
      description: shortText(project.short_description || project.goal || project.context) || res.locals.description,
      ogImage: projImg ? cloudinaryUrl(projImg, { w: 1200, h: 630, c: "fill" }) : res.locals.ogImage,
      ogType: "article",
      profile: buildProfile(settings),
      project,
    });
  } catch (err) {
    next(err);
  }
});

router.get("/etudes", async function (req, res, next) {
  try {
    const data = await repo.getPublicData();
    res.render("public/timeline", {
      title: "Études",
      description: "Le parcours de formation de Henoc Mukumbi en électronique, systèmes embarqués et ingénierie logicielle (ESIEE Paris).",
      heading: "Études et formations",
      intro: "Un parcours structuré autour de l'électronique, des systèmes embarqués et de l'apprentissage continu.",
      items: data.educations,
      type: "education",
    });
  } catch (err) {
    next(err);
  }
});

router.get("/etudes/:id", async function (req, res, next) {
  try {
    const item = await repo.getEducationDetail(req.params.id);
    if (!item) return res.status(404).render("errors/404", { title: "Formation introuvable" });
    res.render("public/timeline-detail", {
      title: item.title,
      description: shortText(item.context || item.description) || res.locals.description,
      ogType: "article",
      item,
      type: "education",
    });
  } catch (err) {
    next(err);
  }
});

router.get("/jobs", async function (req, res, next) {
  try {
    const data = await repo.getPublicData();
    res.render("public/timeline", {
      title: "Expériences",
      description: "Les expériences professionnelles de Henoc Mukumbi : validation logicielle embarquée, tests calculateurs automobiles (CAN/LIN), R&D électronique.",
      heading: "Expériences professionnelles",
      intro: "Les missions, environnements et projets qui ont construit mon expérience d'ingénieur.",
      items: data.jobs,
      type: "job",
    });
  } catch (err) {
    next(err);
  }
});

router.get(["/jobs/:id", "/experiences/:id"], async function (req, res, next) {
  try {
    // URL canonique unique : /experiences/:id. /jobs/:id redirige (301) pour éviter le contenu dupliqué.
    if (req.path.startsWith("/jobs/")) {
      return res.redirect(301, `/experiences/${req.params.id}`);
    }
    const item = await repo.getJobDetail(req.params.id);
    if (!item) return res.status(404).render("errors/404", { title: "Experience introuvable" });
    res.render("public/timeline-detail", {
      title: item.title,
      description: shortText(item.short_summary || item.mission_context || item.description) || res.locals.description,
      ogType: "article",
      item,
      type: "job",
    });
  } catch (err) {
    next(err);
  }
});

router.get("/competences", async function (req, res, next) {
  try {
    const [skills, technologies] = await Promise.all([repo.list("skills"), repo.list("technologies")]);
    const knowledge = await Promise.all([
      ...skills.map((skill) => repo.getSkillDetails(skill.id)),
      ...technologies.map((technology) => repo.getTechnologyDetails(technology.id)),
    ]);
    const groups = knowledge
      .filter(Boolean)
      .reduce((map, item) => {
        const domain = classifyDomain(item.category, item.name);
        map[domain] = map[domain] || [];
        map[domain].push(item);
        return map;
      }, {});
    res.render("public/skills", { title: "Domaines techniques", description: "Les domaines techniques de Henoc Mukumbi : électronique, systèmes embarqués temps réel, développement logiciel, IA appliquée et cloud.", groups });
  } catch (err) {
    next(err);
  }
});

router.get("/api/skills/:id", async function (req, res, next) {
  try {
    const skill = await repo.getSkillDetails(req.params.id);
    if (!skill) return res.status(404).json({ error: "Competence introuvable" });
    res.json({ ...skill, level_label: formatLevel(skill.level) });
  } catch (err) {
    next(err);
  }
});

router.get("/api/technologies/:id", async function (req, res, next) {
  try {
    const technology = await repo.getTechnologyDetails(req.params.id);
    if (!technology) return res.status(404).json({ error: "Technologie introuvable" });
    res.json({ ...technology, level_label: formatLevel(technology.level) });
  } catch (err) {
    next(err);
  }
});

router.get("/api/knowledge/:name", async function (req, res, next) {
  try {
    const knowledge = await repo.getKnowledgeDetailsByName(req.params.name);
    if (!knowledge) return res.status(404).json({ error: "Element introuvable" });
    res.json({ ...knowledge, level_label: formatLevel(knowledge.level) });
  } catch (err) {
    next(err);
  }
});

router.get("/contact", async function (req, res, next) {
  try {
    const settings = await repo.getSettingsMap();
    res.render("public/contact", { title: "Contact", description: "Contacter Henoc Mukumbi, ingénieur systèmes embarqués — pour une mission, une alternance ou une collaboration. Réponse sous 48 h.", profile: buildProfile(settings), messageSent: false, error: null });
  } catch (err) {
    next(err);
  }
});

router.get("/mentions-legales", async function (req, res, next) {
  try {
    const settings = await repo.getSettingsMap();
    res.render("public/legal-notice", { title: "Mentions légales", legal: buildLegal(settings) });
  } catch (err) {
    next(err);
  }
});

router.get("/confidentialite", async function (req, res, next) {
  try {
    const settings = await repo.getSettingsMap();
    res.render("public/privacy", { title: "Politique de confidentialité", legal: buildLegal(settings) });
  } catch (err) {
    next(err);
  }
});

router.get("/cookies", async function (req, res, next) {
  try {
    const settings = await repo.getSettingsMap();
    res.render("public/cookies", { title: "Cookies", legal: buildLegal(settings) });
  } catch (err) {
    next(err);
  }
});

router.post("/desauthentification", function (req, res, next) {
  req.session.destroy((err) => {
    if (err) return next(err);
    res.redirect("/");
  });
});

router.post("/contact", async function (req, res, next) {
  try {
    const currentProfile = buildProfile(await repo.getSettingsMap());

    // Anti-spam : champ honeypot (invisible). Rempli = bot -> on simule l'envoi sans rien traiter.
    if ((req.body.website || "").trim()) {
      return res.render("public/contact", { title: "Contact", profile: currentProfile, messageSent: true, error: null });
    }

    // Anti-spam : limite le nombre d'envois par IP pour ne pas noyer la boîte de réception.
    if (contactRateLimited(req.ip || "unknown")) {
      return res.status(429).render("public/contact", { title: "Contact", profile: currentProfile, messageSent: false, error: "Trop de tentatives d'envoi. Merci de réessayer dans quelques minutes." });
    }

    let { nom, prenom, objet, email, texte } = req.body;
    nom = (nom || "").trim();
    prenom = (prenom || "").trim();
    objet = (objet || "").trim();
    email = (email || "").trim();
    texte = (texte || "").trim();

    const fail = (msg) => res.status(400).render("public/contact", { title: "Contact", profile: currentProfile, messageSent: false, error: msg });
    if (!nom || !prenom || !email || !texte) return fail("Le nom, le prénom, l'email et le message sont requis.");
    if (!objet) objet = "Prise de contact";
    if (!validator.isEmail(email)) return fail("Adresse email invalide.");
    if (nom.length > 80 || prenom.length > 80) return fail("Le nom et le prénom sont trop longs (80 caractères maximum).");
    if (objet.length > 140) return fail("L'objet est trop long (140 caractères maximum).");
    if (texte.length > 4000) return fail("Le message est trop long (4000 caractères maximum).");

    const normalizedEmail = validator.normalizeEmail(email) || email;
    const data = { nom, prenom, objet, email: normalizedEmail, texte };

    // On enregistre le message en base (valeurs brutes, échappées à l'affichage),
    // puis on notifie par email sans bloquer la réponse si l'envoi échoue.
    await contact.AddContact(nom, prenom, objet, normalizedEmail, texte);
    mailer.sendContactEmail(data).catch((e) => console.error("Email de contact non envoyé :", e.message));

    res.render("public/contact", { title: "Contact", profile: currentProfile, messageSent: true, error: null });
  } catch (err) {
    next(err);
  }
});

router.get("/a-propos", async function (req, res, next) {
  try {
    const settings = await repo.getSettingsMap();
    res.render("public/about", { title: "À propos", description: "À propos de Henoc Mukumbi, ingénieur systèmes embarqués : électronique, systèmes embarqués, logiciel et IA.", profile: buildProfile(settings) });
  } catch (err) {
    next(err);
  }
});

function siteUrlOf(req) {
  return process.env.SITE_URL || `${req.protocol}://${req.get("host")}`;
}

router.get("/robots.txt", function (req, res) {
  const base = siteUrlOf(req);
  res.type("text/plain").send(
    ["User-agent: *", "Allow: /", "Disallow: /admin", "Disallow: /authentification", "", `Sitemap: ${base}/sitemap.xml`, ""].join("\n")
  );
});

router.get("/sitemap.xml", async function (req, res, next) {
  try {
    const base = siteUrlOf(req);
    const data = await repo.getPublicData();
    const lastmodOf = (entity) => {
      const d = entity.updated_at || entity.end_date || entity.start_date;
      if (!d) return null;
      const t = new Date(d);
      return Number.isNaN(t.getTime()) ? null : t.toISOString().slice(0, 10);
    };
    const entries = [
      { loc: "/" }, { loc: "/a-propos" }, { loc: "/projets" }, { loc: "/etudes" },
      { loc: "/jobs" }, { loc: "/competences" }, { loc: "/contact" },
      ...(data.projects || []).filter((p) => p.slug).map((p) => ({ loc: `/projets/${p.slug}`, lastmod: lastmodOf(p) })),
      ...(data.educations || []).map((e) => ({ loc: `/etudes/${e.id}`, lastmod: lastmodOf(e) })),
      ...(data.jobs || []).map((j) => ({ loc: `/experiences/${j.id}`, lastmod: lastmodOf(j) })),
    ];
    const body = entries.map((e) => {
      const loc = `${base}${e.loc === "/" ? "" : e.loc}`;
      return `  <url><loc>${loc}</loc>${e.lastmod ? `<lastmod>${e.lastmod}</lastmod>` : ""}</url>`;
    }).join("\n");
    res.type("application/xml").send(
      `<?xml version="1.0" encoding="UTF-8"?>\n<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n${body}\n</urlset>\n`
    );
  } catch (err) {
    next(err);
  }
});

function settingsToMap(settings = []) {
  return settings.reduce((map, setting) => {
    map[setting.setting_key] = setting.setting_value;
    return map;
  }, {});
}

module.exports = router;
