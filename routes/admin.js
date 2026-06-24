var express = require("express");
var router = express.Router();
var multer = require("multer");
var repo = require("../model/portfolioRepository");
var media = require("../model/mediaRepository");
var contact = require("../model/contact");
var { requireAdmin } = require("../middlewares/adminAuth");
var upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 50 * 1024 * 1024 },
  fileFilter: (req, file, cb) => {
    const allowed = new Set(["image/jpeg", "image/png", "image/webp", "video/mp4", "video/webm", "video/quicktime"]);
    if (!allowed.has(file.mimetype)) {
      return cb(new Error("Formats acceptes : jpg, jpeg, png, webp, mp4, webm, mov."));
    }
    cb(null, true);
  },
});

const ENTITY_META = {
  projects: {
    label: "Projets",
    singular: "Projet",
    fields: [
      ["name", "Nom", "text"],
      ["slug", "Slug", "text"],
      ["main_image", "Image principale", "media"],
      ["images", "Galerie d'images", "media-multiple"],
      ["short_description", "Description courte", "textarea"],
      ["long_description", "Description longue", "textarea"],
      ["context", "Contexte du projet", "textarea"],
      ["goal", "Objectif", "textarea"],
      ["features", "Fonctionnalites", "textarea"],
      ["architecture", "Architecture / fonctionnement", "textarea"],
      ["technologies", "Technologies", "textarea"],
      ["challenges", "Difficultes et choix techniques", "textarea"],
      ["results", "Resultats", "textarea"],
      ["future_improvements", "Ameliorations futures", "textarea"],
      ["github_url", "Lien GitHub", "url"],
      ["demo_url", "Lien demo", "url"],
      ["start_date", "Date de debut", "date"],
      ["end_date", "Date de fin", "date"],
      ["status", "Statut", "select:planned,in_progress,done,abandoned"],
      ["category", "Categorie", "select:web,mobile,embedded,electronics,robotics,ia,crypto,drone,other"],
      ["school_id", "Ecole associee", "school"],
      ["company_id", "Entreprise associee", "company"],
      ["job_id", "Experience associee", "job"],
    ],
  },
  project_sections: {
    label: "Sections projets",
    singular: "Section projet",
    fields: [
      ["project_id", "Projet associe", "project"],
      ["title", "Titre de section", "text"],
      ["subtitle", "Sous-titre", "text"],
      ["body", "Contenu", "textarea"],
      ["section_type", "Type de section", "select:text,image,video,gallery,step,result,challenge,architecture,code"],
      ["layout", "Mise en page", "select:text_only,media_right,media_left,media_top,media_bottom,media_full"],
      ["display_order", "Ordre d'affichage", "number"],
      ["is_visible", "Visible", "select:true,false"],
      ["media_id", "Media associe", "media-any"],
      ["media_position", "Position du media", "select:right,left,top,bottom,full"],
      ["media_caption", "Legende du media", "textarea"],
      ["media_alt_text", "Texte alternatif", "text"],
    ],
  },
  educations: {
    label: "Etudes",
    singular: "Formation",
    fields: [
      ["title", "Titre de la formation", "text"],
      ["school_id", "Ecole associee", "school"],
      ["degree", "Diplome", "text"],
      ["field", "Domaine", "text"],
      ["description", "Description", "textarea"],
      ["context", "Contexte de la formation", "textarea"],
      ["program_summary", "Resume du programme suivi", "textarea"],
      ["program_distribution", "Repartition des enseignements", "textarea"],
      ["key_subjects", "Matieres principales", "textarea"],
      ["personal_contribution", "Apport dans le parcours", "textarea"],
      ["start_date", "Date de debut", "date"],
      ["end_date", "Date de fin", "date"],
      ["status", "Statut", "select:planned,in_progress,done,abandoned"],
      ["display_order", "Ordre d'affichage", "number"],
      ["technology_ids", "Technologies / matieres", "technologies"],
      ["skill_ids", "Competences acquises", "skills-multiple"],
      ["project_ids", "Projets lies", "projects-multiple"],
      ["course_ids", "Programme suivi / UV", "courses-multiple"],
    ],
  },
  jobs: {
    label: "Experiences",
    singular: "Experience",
    fieldGroups: [
      {
        title: "Informations generales",
        fields: [
      ["title", "Titre du poste", "text"],
      ["company_id", "Entreprise associee", "company"],
      ["contract_type", "Type de contrat", "select:internship,apprenticeship,cdi,cdd,freelance,personal,other"],
      ["location", "Lieu", "text"],
      ["remote_type", "Teletravail", "select:no,hybrid,yes"],
      ["start_date", "Date de debut", "date"],
      ["end_date", "Date de fin", "date"],
      ["status", "Statut", "select:planned,in_progress,done"],
      ["description", "Description", "textarea"],
      ["short_summary", "Resume court", "textarea"],
      ["lab_name", "Laboratoire / service", "text"],
      ["supervision", "Tutelle / rattachement", "text"],
      ["function_title", "Fonction", "text"],
      ["exact_dates", "Dates exactes", "text"],
        ],
      },
      {
        title: "Contexte entreprise",
        fields: [
      ["company_context", "Contexte entreprise", "textarea"],
        ],
      },
      {
        title: "Contexte de mission",
        fields: [
      ["mission_context", "Contexte de mission", "textarea"],
        ],
      },
      {
        title: "Produit / systeme travaille",
        fields: [
      ["product_context", "Produit / systeme travaille", "textarea"],
      ["problem_statement", "Problematique technique", "textarea"],
      ["system_architecture", "Architecture du systeme", "textarea"],
        ],
      },
      {
        title: "Premiere annee",
        fields: [
      ["first_year_summary", "Resume premiere annee", "textarea"],
      ["first_year_tasks", "Missions premiere annee", "textarea"],
      ["first_year_achievements", "Realisations premiere annee", "textarea"],
      ["first_year_tools", "Outils premiere annee", "textarea"],
      ["first_year_skills", "Competences premiere annee", "textarea"],
        ],
      },
      {
        title: "Deuxieme annee",
        fields: [
      ["second_year_summary", "Resume deuxieme annee", "textarea"],
      ["second_year_tasks", "Missions deuxieme annee", "textarea"],
      ["second_year_achievements", "Realisations deuxieme annee", "textarea"],
      ["second_year_tools", "Outils deuxieme annee", "textarea"],
      ["second_year_skills", "Competences deuxieme annee", "textarea"],
        ],
      },
      {
        title: "Missions et realisations",
        fields: [
      ["missions", "Missions principales", "textarea"],
      ["achievements", "Realisations concretes", "textarea"],
        ],
      },
      {
        title: "Difficultes et resolution",
        fields: [
      ["technical_challenges", "Difficultes et resolutions", "textarea"],
        ],
      },
      {
        title: "Technologies et outils",
        fields: [
      ["technologies", "Technologies", "textarea"],
      ["tools", "Outils", "textarea"],
      ["methods", "Methodes de travail", "textarea"],
        ],
      },
      {
        title: "Resultats et apports",
        fields: [
      ["results", "Resultats et apports", "textarea"],
      ["results_list", "Resultats detailles", "textarea"],
      ["personal_contribution", "Apports personnels", "textarea"],
      ["personal_contribution_list", "Apports personnels detailles", "textarea"],
      ["skills_developed", "Competences developpees", "textarea"],
        ],
      },
      {
        title: "Documents lies",
        fields: [
      ["document_title", "Document lie - titre", "text"],
      ["document_url", "Document lie - URL", "url"],
      ["document_description", "Document lie - description", "textarea"],
      ["project_ids", "IDs projets lies", "textarea"],
        ],
      },
    ],
  },
  schools: {
    label: "Ecoles",
    singular: "Ecole",
    fields: [
      ["name", "Nom de l'ecole", "text"],
      ["slug", "Slug", "text"],
      ["logo", "Logo", "media"],
      ["city", "Ville", "text"],
      ["country", "Pays", "text"],
      ["website", "Site web", "url"],
      ["description", "Description", "textarea"],
    ],
  },
  companies: {
    label: "Entreprises",
    singular: "Entreprise",
    fields: [
      ["name", "Nom", "text"],
      ["logo", "Logo", "media"],
      ["city", "Ville", "text"],
      ["country", "Pays", "text"],
      ["website", "Site web", "url"],
      ["description", "Description", "textarea"],
      ["industry", "Secteur", "text"],
      ["size", "Taille", "text"],
      ["type", "Type", "select:company,startup,association,laboratory,other"],
    ],
  },
  skills: {
    label: "Competences",
    singular: "Competence",
    fields: [
      ["name", "Nom", "text"],
      ["category", "Categorie", "select:Frontend,Backend,Base de donnees,DevOps,Systemes embarques,IA / Machine Learning,Outils"],
      ["description", "Description", "textarea"],
      ["icon", "Icone", "text"],
      ["level", "Niveau", "select:debutant,intermediaire,avance,expert"],
    ],
  },
  technologies: {
    label: "Technologies",
    singular: "Technologie",
    fields: [
      ["name", "Nom", "text"],
      ["category", "Categorie", "select:Langage,Matiere,Electronique,Protocole,Outil,Systeme,Autre"],
    ],
  },
  course_categories: {
    label: "Categories UV",
    singular: "Categorie UV",
    fields: [
      ["name", "Nom", "text"],
      ["description", "Resume affiche dans le programme", "textarea"],
      ["skills_summary", "Competences principales", "textarea"],
      ["display_order", "Ordre d'affichage", "number"],
    ],
  },
  courses: {
    label: "UV / Cours",
    singular: "UV",
    fields: [
      ["code", "Code", "text"],
      ["title", "Intitule", "text"],
      ["formation_year", "Annee de formation", "text"],
      ["semester", "Semestre", "text"],
      ["hours", "Volume horaire", "text"],
      ["ects", "ECTS", "text"],
      ["description", "Description courte", "textarea"],
      ["skills_summary", "Competences associees", "textarea"],
      ["category_id", "Categorie", "course-category"],
      ["display_order", "Ordre d'affichage", "number"],
    ],
  },
  settings: {
    label: "Parametres",
    singular: "Parametre",
    descriptions: {
      profile_title: {
        label: "Titre du profil",
        help: "Texte affiche sous ton nom sur la page d'accueil.",
        placeholder: "Exemple : Developpeur web et ingenieur logiciel",
      },
      profile_name: {
        label: "Nom affiche",
        help: "Nom principal affiche dans la navbar, le footer et le titre de l'accueil.",
        placeholder: "Exemple : Henoc Mukumbi",
      },
      profile_tagline: {
        label: "Phrase d'accroche",
        help: "Court texte affiche dans le hero de la page d'accueil.",
        placeholder: "Explique en une ou deux phrases ce que tu fais.",
      },
      profile_about: {
        label: "Texte de presentation",
        help: "Texte plus complet affiche dans la section de presentation de l'accueil.",
        placeholder: "Presente ton parcours, ton approche et tes objectifs.",
      },
      profile_photo: {
        label: "Photo de profil",
        help: "Image principale affichee dans le hero de la page d'accueil.",
        placeholder: "Selectionne une image privee deja uploadee.",
      },
      contact_email: {
        label: "Email de contact",
        help: "Adresse email publique utilisee pour te contacter.",
        placeholder: "Exemple : h.mukumbi100@gmail.com",
      },
      github_url: {
        label: "Lien GitHub",
        help: "URL vers ton profil GitHub public.",
        placeholder: "https://github.com/...",
      },
      linkedin_url: {
        label: "Lien LinkedIn",
        help: "URL vers ton profil LinkedIn public.",
        placeholder: "https://www.linkedin.com/in/...",
      },
      cv_url: {
        label: "Lien du CV",
        help: "URL du CV affichee sur l'accueil. Peut pointer vers un PDF heberge.",
        placeholder: "https://...",
      },
      legal_site_name: {
        label: "Nom legal du site",
        help: "Nom affiche dans les mentions legales.",
        placeholder: "Portfolio Henoc Mukumbi",
      },
      legal_publisher_name: {
        label: "Editeur du site",
        help: "Personne ou structure responsable du site.",
        placeholder: "Henoc Mukumbi",
      },
      legal_publisher_status: {
        label: "Statut legal",
        help: "Statut de l'editeur : particulier, auto-entrepreneur, societe, etc.",
        placeholder: "Particulier",
      },
      legal_publication_director: {
        label: "Directeur de publication",
        help: "Personne responsable de la publication du site.",
        placeholder: "Henoc Mukumbi",
      },
      legal_hosting_provider: {
        label: "Hebergeur",
        help: "Nom de l'hebergeur utilise en production.",
        placeholder: "Exemple : Render, Railway, OVH, Vercel...",
      },
      legal_hosting_address: {
        label: "Adresse hebergeur",
        help: "Adresse officielle de l'hebergeur.",
        placeholder: "Adresse postale de l'hebergeur",
      },
      legal_hosting_website: {
        label: "Site de l'hebergeur",
        help: "URL du site officiel de l'hebergeur.",
        placeholder: "https://...",
      },
      legal_data_controller: {
        label: "Responsable des donnees",
        help: "Personne responsable du traitement des donnees personnelles.",
        placeholder: "Henoc Mukumbi",
      },
      legal_retention_contact: {
        label: "Conservation des messages",
        help: "Texte expliquant combien de temps les messages de contact sont conserves.",
        placeholder: "Les messages sont conserves le temps necessaire au traitement de la demande.",
      },
      legal_last_updated: {
        label: "Date de mise a jour legale",
        help: "Date affichee en bas des pages legales.",
        placeholder: "12 mai 2026",
      },
    },
    fields: [
      ["setting_key", "Cle", "text"],
      ["setting_value", "Valeur", "textarea"],
      ["description", "Description", "textarea"],
    ],
  },
};

Object.values(ENTITY_META).forEach((meta) => {
  if (meta.fieldGroups && !meta.fields) {
    meta.fields = meta.fieldGroups.flatMap((group) => group.fields);
  }
});

router.use(requireAdmin);

async function formOptions() {
  const [schools, companies, jobs, projects, projectSections, skills, technologies, courseCategories, courses, mediaAssets] = await Promise.all([
    repo.list("schools"),
    repo.list("companies"),
    repo.list("jobs"),
    repo.list("projects"),
    repo.list("project_sections"),
    repo.list("skills"),
    repo.list("technologies"),
    repo.list("course_categories"),
    repo.list("courses"),
    media.list(),
  ]);
  return { schools, companies, jobs, projects, projectSections, skills, technologies, courseCategories, courses, mediaAssets };
}

function adminReturnTo(value, fallback) {
  const target = String(value || "");
  if ((target.startsWith("/admin/") || target.startsWith("/projets/")) && !target.startsWith("//")) return target;
  return fallback;
}

router.get("/", async function (req, res, next) {
  try {
    const stats = await repo.getAdminStats();
    res.render("admin/dashboard", { title: "Admin", stats, entities: ENTITY_META });
  } catch (err) {
    next(err);
  }
});

// Boîte de réception : messages reçus via le formulaire de contact
router.get("/messages", async function (req, res, next) {
  try {
    const messages = await contact.listContacts();
    res.render("admin/messages", { title: "Messages reçus", entities: ENTITY_META, messages });
  } catch (err) {
    next(err);
  }
});

router.post("/messages/:id/delete", async function (req, res, next) {
  try {
    await contact.deleteContact(req.params.id);
    res.redirect("/admin/messages");
  } catch (err) {
    next(err);
  }
});

router.get("/media", async function (req, res, next) {
  try {
    const assets = await media.list({ entityType: req.query.type });
    res.render("admin/media", {
      title: "Medias prives",
      entities: ENTITY_META,
      assets,
      cloudinaryConfigured: media.isConfigured(),
      selectedType: req.query.type || "",
      error: req.query.error || null,
      success: req.query.success || null,
    });
  } catch (err) {
    next(err);
  }
});

router.post("/media", upload.single("media"), async function (req, res, next) {
  try {
    if (!req.file) return res.redirect("/admin/media?error=missing-file");
    await media.upload(req.file, req.body);
    res.redirect("/admin/media?success=uploaded");
  } catch (err) {
    console.error("Erreur upload media :", err.message, err.cause || "");
    res.redirect(`/admin/media?error=${encodeURIComponent(err.message || "upload-failed")}`);
  }
});

router.post("/media/:id/delete", async function (req, res, next) {
  try {
    await media.remove(req.params.id);
    res.redirect("/admin/media?success=deleted");
  } catch (err) {
    next(err);
  }
});

router.post("/media/:id/rename", async function (req, res, next) {
  try {
    await media.rename(req.params.id, req.body.display_name);
    res.redirect("/admin/media?success=renamed");
  } catch (err) {
    next(err);
  }
});

router.post("/project_sections/:id/media", upload.single("media"), async function (req, res, next) {
  const fallback = `/admin/project_sections/${req.params.id}/edit`;
  try {
    const returnTo = adminReturnTo(req.body.return_to, fallback);
    if (!req.file) return res.redirect(`${returnTo}?error=missing-file`);
    const asset = await media.upload(req.file, { ...req.body, entity_type: "project_sections" });
    await repo.attachMediaToProjectSection(req.params.id, asset.id, req.body);
    res.redirect(`${returnTo}?success=media-uploaded`);
  } catch (err) {
    console.error("Erreur upload media section projet :", err.message, err.cause || "");
    res.redirect(`${fallback}?error=${encodeURIComponent(err.message || "upload-failed")}`);
  }
});

router.get("/:entity", async function (req, res, next) {
  try {
    const meta = ENTITY_META[req.params.entity];
    if (!meta) return res.status(404).render("errors/404", { title: "Section introuvable" });
    const items = await repo.list(req.params.entity);
    res.render("admin/list", { title: meta.label, entity: req.params.entity, meta, items, entities: ENTITY_META });
  } catch (err) {
    next(err);
  }
});

router.get("/:entity/new", async function (req, res, next) {
  try {
    const meta = ENTITY_META[req.params.entity];
    if (!meta) return res.status(404).render("errors/404", { title: "Section introuvable" });
    const item = req.params.entity === "project_sections" && req.query.project_id
      ? { project_id: Number.parseInt(req.query.project_id, 10) }
      : {};
    res.render("admin/form", { title: `Créer ${meta.singular}`, entity: req.params.entity, meta, item, options: await formOptions(), entities: ENTITY_META });
  } catch (err) {
    next(err);
  }
});

router.post("/:entity", async function (req, res, next) {
  try {
    await repo.create(req.params.entity, req.body);
    res.redirect(adminReturnTo(req.body.return_to, `/admin/${req.params.entity}?success=created`));
  } catch (err) {
    next(err);
  }
});

router.get("/:entity/:id/edit", async function (req, res, next) {
  try {
    const meta = ENTITY_META[req.params.entity];
    const item = meta ? await repo.findById(req.params.entity, req.params.id) : null;
    if (!meta || !item) return res.status(404).render("errors/404", { title: "Element introuvable" });
    res.render("admin/form", { title: `Modifier ${meta.singular}`, entity: req.params.entity, meta, item, options: await formOptions(), entities: ENTITY_META });
  } catch (err) {
    next(err);
  }
});

router.post("/:entity/:id", async function (req, res, next) {
  try {
    await repo.update(req.params.entity, req.params.id, req.body);
    res.redirect(adminReturnTo(req.body.return_to, `/admin/${req.params.entity}?success=updated`));
  } catch (err) {
    next(err);
  }
});

router.post("/:entity/:id/delete", async function (req, res, next) {
  try {
    await repo.remove(req.params.entity, req.params.id);
    res.redirect(adminReturnTo(req.body.return_to, `/admin/${req.params.entity}?success=deleted`));
  } catch (err) {
    next(err);
  }
});

module.exports = router;
