var express = require('express');
var router = express.Router();
const fs = require('fs');
const path = require('path');
var diplome = require('../model/diplome.js');
var certification = require('../model/certification.js');


router.get('/', async function(req, res, next) {

  try {
    //Récupérer les diplômes
    var diplomes = await diplome.getDiplomes();
    var certifications = await certification.getCertifications();

    //Lire le fichier description.txt
    const descriptionPath = path.join(__dirname,'../public/document/description.txt');
    const description = fs.readFileSync(descriptionPath, 'utf-8');

    res.render('home', { 
    title: 'Mon portfolio',
    diplomes: diplomes,
    certifications : certifications,
    description: description,
    henoc_photo: 'https://res.cloudinary.com/portfolio-hezuko/image/upload/v1740309643/henoc_r0fiwi.jpg',
  });
  } catch(err) {
    next(err);
  }
  
});

module.exports = router;
