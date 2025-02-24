var express = require('express');
var router = express.Router();
var validator = require('validator');
var contact = require('../model/contact');
var nodemailer = require('nodemailer');

var transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'h.mukumbi100@gmail.com',
        pass: 'urrb fvjm xrcy xlol' 
    }
});

router.get('/', async function(req, res, next) {
    res.render('contact', {
        title: 'Contact'
    });
});

router.post('/', async function(req, res, next) {
    let { nom, prenom, objet, email, texte } = req.body;

    const maxNomPrenomLength = 50;
    const maxObjetLength = 100;
    const maxTexteLength = 500;

    nom     = validator.escape(nom.trim());
    prenom  = validator.escape(prenom.trim());
    objet   = validator.escape(objet.trim());
    email   = validator.normalizeEmail(email.trim());
    texte   = validator.escape(texte.trim());

    if (!validator.isEmail(email)) {
        return res.status(400).send('Adresse email invalide.');
    }

    if (!nom || !prenom || !objet || !email || !texte) {
        return res.status(400).send('Tous les champs sont requis.');
    }

    if (nom.length > maxNomPrenomLength || prenom.length > maxNomPrenomLength) {
        return res.status(400).send(`Le nom et le prénom ne doivent pas dépasser ${maxNomPrenomLength} caractères.`);
    }

    if (objet.length > maxObjetLength) {
        return res.status(400).send(`L'objet ne doit pas dépasser ${maxObjetLength} caractères.`);
    }

    if (texte.length > maxTexteLength) {
        return res.status(400).send(`Le texte ne doit pas dépasser ${maxTexteLength} caractères.`);
    }

    console.log('Les données du formulaire sécurisées :', { nom, prenom, objet, email, texte });

    var mailOptions = {
        from: 'h.mukumbi100@gmail.com',
        to: 'h.mukumbi100@gmail.com',
        subject: `Portfolio en savoir Plus : ${objet}`,
        text: `Vous avez reçu un nouveau message de contact.\n\nNom: ${nom}\nPrénom: ${prenom}\nEmail: ${email}\nMessage:\n${texte}`
    };
    

    transporter.sendMail(mailOptions, function(error, info){
        if (error) {
            console.log('Erreur lors de l\'envoi de l\'e-mail :', error);
        } else {
            console.log('E-mail envoyé : ' + info.response);
        }
    });

    try {
        const contactAjoute = await contact.AddContact(nom, prenom, objet, email, texte);
        console.log("✅ Contact ajouté en base :", contactAjoute);

        req.session.messageSent = true; 

        res.redirect('/confirmation');
    } catch (err) {
        console.error("❌ Erreur lors de l'ajout du contact :", err);
        next(err);
    }
    
});

module.exports = router;