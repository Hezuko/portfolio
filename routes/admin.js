var express = require("express");
var router = express.Router();
var multer = require("multer");
var repo = require("../model/portfolioRepository");
var media = require("../model/mediaRepository");
var { requireAdmin } = require("../middlewares/adminAuth");
var upload = multer({
  storage: multer.memoryStorage(),
  limits: { fileSize: 50 * 1024 * 1024 },
  fileFilter: (req, file, cb) => {
    if (!file.mimetype.startsWith("image/") && !file.mimetype.startsWith("video/")) {
      return cb(new Error("Seuls les images et videos sont acceptees."));
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
      ["goal", "Objectif", "textarea"],
      ["features", "Fonctionnalites", "textarea"],
      ["technologies", "Technologies", "textarea"],
      ["github_url", "Lien GitHub", "url"],
      ["demo_url", "Lien demo", "url"],
      ["start_date", "Date de debut", "date"],
      ["end_date", "Date de fin", "date"],
      ["status", "Statut", "select:planned,in_progress,done,abandoned"],
      ["category", "Categorie", "select:web,mobile,embedded,ia,crypto,drone,other"],
      ["school_id", "Ecole associee", "school"],
      ["company_id", "Entreprise associee", "company"],
      ["job_id", "Experience associee", "job"],
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
      ["start_date", "Date de debut", "date"],
      ["end_date", "Date de fin", "date"],
      ["status", "Statut", "select:planned,in_progress,done,abandoned"],
      ["display_order", "Ordre d'affichage", "number"],
      ["technology_ids", "Technologies / matieres", "technologies"],
      ["skill_ids", "Competences acquises", "skills-multiple"],
      ["project_ids", "Projets lies", "projects-multiple"],
    ],
  },
  jobs: {
    label: "Experiences",
    singular: "Experience",
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
      ["missions", "Missions principales", "textarea"],
      ["technologies", "Technologies", "textarea"],
      ["project_ids", "IDs projets lies", "textarea"],
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

router.use(requireAdmin);

async function formOptions() {
  const [schools, companies, jobs, projects, skills, technologies, mediaAssets] = await Promise.all([
    repo.list("schools"),
    repo.list("companies"),
    repo.list("jobs"),
    repo.list("projects"),
    repo.list("skills"),
    repo.list("technologies"),
    media.list(),
  ]);
  return { schools, companies, jobs, projects, skills, technologies, mediaAssets };
}

router.get("/", async function (req, res, next) {
  try {
    const stats = await repo.getAdminStats();
    res.render("admin/dashboard", { title: "Admin", stats, entities: ENTITY_META });
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
    res.render("admin/form", { title: `Créer ${meta.singular}`, entity: req.params.entity, meta, item: {}, options: await formOptions(), entities: ENTITY_META });
  } catch (err) {
    next(err);
  }
});

router.post("/:entity", async function (req, res, next) {
  try {
    await repo.create(req.params.entity, req.body);
    res.redirect(`/admin/${req.params.entity}?success=created`);
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
    res.redirect(`/admin/${req.params.entity}?success=updated`);
  } catch (err) {
    next(err);
  }
});

router.post("/:entity/:id/delete", async function (req, res, next) {
  try {
    await repo.remove(req.params.entity, req.params.id);
    res.redirect(`/admin/${req.params.entity}?success=deleted`);
  } catch (err) {
    next(err);
  }
});

module.exports = router;
