var express = require('express');
var router = express.Router();
const fs = require('fs');
const path = require('path');
var diplome = require('../model/diplome.js');
var certification = require('../model/certification.js');
const rateLimit = require("express-rate-limit");

// 🛑 Limitation du nombre de requêtes pour éviter les attaques DoS
const limiter = rateLimit({
  windowMs: 1 * 60 * 1000, // 1 minute
  max: 1000, // Maximum 10 requêtes par minute par IP
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

router.get('/', async function(req, res, next) {
  try {
    // Récupérer les diplômes et certifications
    const [diplomes, certifications] = await Promise.all([
      diplome.getDiplomes(),
      certification.getCertifications()
    ]);

    res.render('home', { 
      title: 'Mon portfolio',
      diplomes: diplomes,
      certifications: certifications,
      description: description, // Utilisation du cache
      henoc_photo: 'https://res.cloudinary.com/portfolio-hezuko/image/upload/v1740309643/henoc_r0fiwi.jpg',
    });

  } catch(err) {
    console.error("❌ Erreur lors de la récupération des données :", err);
    next(err);
  }
});

module.exports = router;
