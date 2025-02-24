var express = require('express');
var router = express.Router();
var projet = require('../model/projet');


router.get('/', async function(req, res, next) {
    try {
        var projets = await projet.getProjets();

        res.render('projets', { 
            projets: projets,
            title: 'Mes Projets',
            csrfToken: req.csrfToken() 
        });
    } catch (err) {
        next(err);
    }
});

router.post("/ajouter", async function(req, res) {
    try {
        const { titre, description, adresse, date_debut, date_fin, document, etat, partenaire, iconpath } = req.body;

        if (!titre || !description || !adresse || !date_debut || !date_fin || !etat) {
            return res.status(400).json({ message: "Veuillez remplir tous les champs obligatoires." });
        }

        console.log("📌 Données du projet à insérer :", {
            titre, description, adresse, date_debut, date_fin, document, etat, partenaire, iconpath
        });

        // Appeler la fonction avec les valeurs individuelles
        await projet.addProjet(
            titre,
            description,
            adresse,
            date_debut,
            date_fin,
            document || null, 
            etat,
            partenaire || null, 
            iconpath || null
        );

        // ✅ Rediriger vers la liste des projets après ajout
        res.status(201).redirect("/projets");

    }  catch (error) {
        console.error("❌ Erreur lors de l'ajout du projet :", error);
        res.status(500).render("projets", { 
            message: "Une erreur est survenue lors de l'ajout du projet.",
            success: false
        });
    }
});


router.post("/modifier", async function (req, res) {
    try {
        // Récupération des données du formulaire
        const { id, titre, description, adresse, date_debut, date_fin, document, etat, partenaire, iconpath } = req.body;


        if (!id) {
            console.error("❌ Erreur : ID non fourni !");
            return res.status(400).render("projets", { 
                message: "ID du projet manquant.",
                success: false
            });
        }

        const existingProject = await projet.getProjetById(id);
        if (!existingProject) {
            return res.status(400).json({ message: "Projet introuvable." }); // 🔴 Rejette un projet inexistant
        }

        // Vérification des champs obligatoires
        if (!id || !titre || !description || !adresse || !date_debut || !date_fin || !etat) {
            return res.status(400).json({ message: "Veuillez remplir tous les champs obligatoires." });
        }

        console.log("📌 Données du projet à modifier :", {
            id, titre, description, adresse, date_debut, date_fin, document, etat, partenaire, iconpath
        });

        // Mise à jour du projet dans la base de données
        await projet.updateProjet(
            id,
            titre,
            description,
            adresse,
            date_debut,
            date_fin,
            document || null,  // Si pas fourni, mettre NULL
            etat,
            partenaire || null, // Optionnel
            iconpath || null    // Optionnel
        );

        // Redirection ou réponse JSON selon le besoin
        res.status(200).redirect("/projets"); // Redirige vers la liste des projets après modification

    } catch (error) {
        console.error("❌ Erreur lors de la modification du projet :", error);
        res.status(500).render("projets", { 
            message: "Une erreur est survenue lors de la modification du projet.",
            success: false
        });
    }
});


router.post("/supprimer/:id", async function (req, res) {
    try {
        console.log("📌 ID reçu via req.params :", req.params.id);

        const id = req.params.id;


        const existingProject = await projet.getProjetById(id);
        if (!existingProject) {
            return res.status(400).json({ message: "Projet introuvable." }); // 🔴 Rejette un projet inexistant
        }


        if (!id) {
            console.error("❌ Erreur : ID non fourni !");
            return res.status(400).render("projets", { 
                message: "ID du projet manquant.",
                success: false
            });
        }

        console.log("✅ L'ID du projet à supprimer est :", id);


        await projet.deleteProjet(id);

        res.status(200).redirect("/projets"); // Redirige vers la liste des projets après modification

    } catch (error) {
        console.error("❌ Erreur lors de la suppression du projet :", error);
        res.status(500).render("projets", { 
            message: "Une erreur est survenue lors de la suppression du projet.",
            success: false
        });
    }
});




module.exports = router;
