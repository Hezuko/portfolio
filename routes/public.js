var express = require("express");
var router = express.Router();
var validator = require("validator");
var contact = require("../model/contact");
var repo = require("../model/portfolioRepository");
var { formatLevel } = require("../utils/formatters");

const profile = {
  name: "Henoc Mukumbi",
  role: "Developpeur web et ingenieur logiciel",
  tagline: "Je construis des applications claires, utiles et maintenables, avec un interet fort pour le backend, les systemes et les produits bien finis.",
  email: "h.mukumbi100@gmail.com",
  github: "https://github.com/Hezuko",
  linkedin: "https://www.linkedin.com/in/henocmukumbi",
  photo: "https://res.cloudinary.com/portfolio-hezuko/image/upload/v1740309643/henoc_r0fiwi.jpg",
};

function buildProfile(settings = {}) {
  return {
    ...profile,
    name: settings.profile_name || profile.name,
    role: settings.profile_title || profile.role,
    tagline: settings.profile_tagline || profile.tagline,
    about: settings.profile_about || "",
    email: settings.contact_email || profile.email,
    github: settings.github_url || profile.github,
    linkedin: settings.linkedin_url || profile.linkedin,
    cv: settings.cv_url || "",
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
    res.render("public/home", { title: "Portfolio - Henoc Mukumbi", profile: buildProfile(settingsToMap(data.settings)), ...data });
  } catch (err) {
    next(err);
  }
});

router.get("/projets", async function (req, res, next) {
  try {
    const data = await repo.getPublicData();
    res.render("public/projects", { title: "Projets", profile: buildProfile(settingsToMap(data.settings)), projects: data.projects });
  } catch (err) {
    next(err);
  }
});

router.get("/projets/:slug", async function (req, res, next) {
  try {
    const project = await repo.findProjectBySlug(req.params.slug);
    if (!project) return res.status(404).render("errors/404", { title: "Projet introuvable" });
    const settings = await repo.getSettingsMap();
    res.render("public/project-detail", { title: project.name, profile: buildProfile(settings), project });
  } catch (err) {
    next(err);
  }
});

router.get("/etudes", async function (req, res, next) {
  try {
    const data = await repo.getPublicData();
    res.render("public/timeline", {
      title: "Etudes",
      heading: "Etudes et formations",
      intro: "Un parcours structure autour de l'informatique, des projets concrets et de l'apprentissage continu.",
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
      title: "Experiences",
      heading: "Experiences professionnelles",
      intro: "Les missions, environnements et projets qui ont construit mon experience.",
      items: data.jobs,
      type: "job",
    });
  } catch (err) {
    next(err);
  }
});

router.get(["/jobs/:id", "/experiences/:id"], async function (req, res, next) {
  try {
    const item = await repo.getJobDetail(req.params.id);
    if (!item) return res.status(404).render("errors/404", { title: "Experience introuvable" });
    res.render("public/timeline-detail", {
      title: item.title,
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
    res.render("public/skills", { title: "Domaines techniques", groups });
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

router.get("/contact", function (req, res) {
  repo.getSettingsMap()
    .then((settings) => res.render("public/contact", { title: "Contact", profile: buildProfile(settings), messageSent: false, error: null }))
    .catch((err) => res.render("public/contact", { title: "Contact", profile, messageSent: false, error: err.message }));
});

router.get("/mentions-legales", function (req, res) {
  repo.getSettingsMap()
    .then((settings) => res.render("public/legal-notice", { title: "Mentions legales", legal: buildLegal(settings) }))
    .catch((err) => res.render("public/legal-notice", { title: "Mentions legales", legal: { ...legal, error: err.message } }));
});

router.get("/confidentialite", function (req, res) {
  repo.getSettingsMap()
    .then((settings) => res.render("public/privacy", { title: "Politique de confidentialite", legal: buildLegal(settings) }))
    .catch((err) => res.render("public/privacy", { title: "Politique de confidentialite", legal: { ...legal, error: err.message } }));
});

router.get("/cookies", function (req, res) {
  repo.getSettingsMap()
    .then((settings) => res.render("public/cookies", { title: "Cookies", legal: buildLegal(settings) }))
    .catch((err) => res.render("public/cookies", { title: "Cookies", legal: { ...legal, error: err.message } }));
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
    let { nom, prenom, objet, email, texte } = req.body;
    nom = validator.escape((nom || "").trim());
    prenom = validator.escape((prenom || "").trim());
    objet = validator.escape((objet || "").trim());
    email = validator.normalizeEmail((email || "").trim());
    texte = validator.escape((texte || "").trim());

    if (!nom || !prenom || !objet || !email || !texte) {
      return res.status(400).render("public/contact", { title: "Contact", profile: currentProfile, messageSent: false, error: "Tous les champs sont requis." });
    }
    if (!validator.isEmail(email)) {
      return res.status(400).render("public/contact", { title: "Contact", profile: currentProfile, messageSent: false, error: "Adresse email invalide." });
    }

    await contact.AddContact(nom, prenom, objet, email, texte);
    res.render("public/contact", { title: "Contact", profile: currentProfile, messageSent: true, error: null });
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
