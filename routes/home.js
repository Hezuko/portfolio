var express = require('express');
var router = express.Router();
const fs = require('fs');
const path = require('path');
var diplome = require('../model/diplome.js');
var certification = require('../model/certification.js');
var etude = require('../model/etude.js');
const rateLimit = require("express-rate-limit");

// 🛑 Limitation du nombre de requêtes pour éviter les attaques DoS
const limiter = rateLimit({
  windowMs: 1 * 60 * 1000, // 1 minute
  max: 1000, // Maximum 1000 requêtes par minute par IP
  message: "⛔ Trop de requêtes, veuillez réessayer plus tard."
});

// 📌 Lire le fichier description.txt **une seule fois** au démarrage
const descriptionPath = path.join(__dirname, '../public/document/description.txt');
let description = "";

try {
  description = fs.readFileSync(descriptionPath, 'utf-8');
} catch (err) {
  console.error("❌ Erreur lors de la lecture du fichier description.txt :", err);
}

// 🟢 Appliquer le middleware limitant les requêtes
router.use(limiter);

// 🟢 Route pour afficher les diplômes
router.get('/', async function(req, res, next) {
  try {
    // Récupérer les diplômes, certifications et études
    const [diplomes, certifications, etudes] = await Promise.all([
      diplome.getDiplomes(),
      certification.getCertifications(),
      etude.getEtudes()
    ]);

    res.render('home', { 
      title: 'Mon portfolio',
      diplomes: diplomes,
      certifications: certifications,
      etudes: etudes,
      description: description, // Utilisation du cache
      henoc_photo: 'https://res.cloudinary.com/portfolio-hezuko/image/upload/v1740309643/henoc_r0fiwi.jpg',
    });

  } catch(err) {
    console.error("❌ Erreur lors de la récupération des données :", err);
    next(err);
  }
});

// ✅ Route pour ajouter un diplôme
router.post('/diplome/ajouter', async function(req, res, next) {
  try {
    const { titre, niveau_etude, delivrepar, etudeId, annee_obtention, image_path } = req.body;

    if (!titre || !niveau_etude || !delivrepar || !etudeId || !annee_obtention) {
      return res.status(400).json({ message: "Veuillez remplir tous les champs obligatoires." });
    }

    console.log("Donnée du diplôme à insérer :", {
      titre, niveau_etude, delivrepar, etudeId, annee_obtention, image_path
    });

    await diplome.addDiplome(
      titre,
      niveau_etude,
      delivrepar,
      etudeId,
      image_path || null,
      annee_obtention
    );

    res.status(201).redirect('/');
  } catch (error) {
    console.error("❌ Erreur lors de l'ajout du diplôme :", error);
    res.status(500).render("home", {
      message: "Une erreur est survenue lors de l'ajout du diplôme.",
      success: false
    });
  }
});

// ✅ Route pour modifier un diplôme
router.post('/diplome/modifier', async function(req, res, next) {
  try {
    const { id, titre, niveau_etude, annee_obtention, image_path } = req.body;

    if (!id || !titre || !niveau_etude || !annee_obtention) {
      return res.status(400).json({ message: "Tous les champs sont obligatoires." });
    }

    // Vérifier si le diplôme existe
    const existingDiplome = await diplome.getDiplomeById(id);
    if (!existingDiplome) {
      return res.status(404).json({ message: "Diplôme introuvable." });
    }

    console.log("✅ Données mises à jour :", {
      id, titre, niveau_etude, annee_obtention, image_path
    });

    // Mise à jour du diplôme
    await diplome.updateDiplome(
      id,
      titre,
      niveau_etude,
      annee_obtention
    );

    res.status(200).redirect('/');
  } catch (error) {
    console.error("❌ Erreur lors de la modification du diplôme :", error);
    res.status(500).render("home", {
      message: "Une erreur est survenue lors de la modification du diplôme.",
      success: false
    });
  }
});

// ✅ Route pour supprimer un diplôme
router.post('/diplome/supprimer', async function(req, res, next) {
  try {
    const { id } = req.body;

    if (!id) {
      return res.status(400).json({ message: "ID du diplôme manquant." });
    }

    // Vérifier si le diplôme existe avant de le supprimer
    const existingDiplome = await diplome.getDiplomeById(id);
    if (!existingDiplome) {
      return res.status(404).json({ message: "Diplôme introuvable." });
    }

    console.log("📌 Suppression du diplôme ID :", id);

    await diplome.deleteDiplome(id);

    res.status(200).redirect('/');
  } catch (error) {
    console.error("❌ Erreur lors de la suppression du diplôme :", error);
    res.status(500).render("home", {
      message: "Une erreur est survenue lors de la suppression du diplôme.",
      success: false
    });
  }
});

module.exports = router;
