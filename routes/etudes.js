var express = require('express');
var router = express.Router();
var etude = require('../model/etude');


router.get('/', async function(req, res, next) {
    try {
        var etudes = await etude.getEtudes();

        res.render('etudes', { 
            etudes: etudes,
            title: 'Mes Etudes',
            csrfToken: req.csrfToken() 
        });
    } catch (err) {
        next(err);
    }
});

router.post("/ajouter", async function(req, res) {
    try {
        const { titre, description, adresse, date_debut, date_fin, document, etat, iconpath, buildingpath } = req.body;

        if (!titre || !description || !adresse || !date_debut || !date_fin || !etat) {
            return res.status(400).json({ message: "Veuillez remplir tous les champs obligatoires." });
        }

        console.log("📌 Données du etude à insérer :", {
            titre, description, adresse, date_debut, date_fin, document, etat, iconpath, buildingpath
        });

        // Appeler la fonction avec les valeurs individuelles
        await etude.addEtude(
            titre,
            description,
            adresse,
            date_debut,
            date_fin,
            document || null, 
            etat,
            iconpath || null,
            buildingpath || null
        );

        // ✅ Rediriger vers la liste des etudes après ajout
        res.status(201).redirect("/etudes");

    }  catch (error) {
        console.error("❌ Erreur lors de l'ajout du etude :", error);
        res.status(500).render("etudes", { 
            message: "Une erreur est survenue lors de l'ajout du etude.",
            success: false
        });
    }
});


router.post("/modifier", async function (req, res) {
    try {
        // Récupération des données du formulaire
        const { id, titre, description, adresse, date_debut, date_fin, document, etat, iconpath, buildingpath } = req.body;

        if (!id) {
            console.error("❌ Erreur : ID non fourni !");
            return res.status(400).render("etudes", { 
                message: "ID du etude manquant.",
                success: false
            });
        }

        const existingProject = await etude.getEtudeById(id);
        if (!existingProject) {
            return res.status(400).json({ message: "etude introuvable." }); // 🔴 Rejette un etude inexistant
        }

        // Vérification des champs obligatoires
        if (!id || !titre || !description || !adresse || !date_debut || !date_fin || !etat) {
            return res.status(400).json({ message: "Veuillez remplir tous les champs obligatoires." });
        }

        console.log("📌 Données du etude à modifier :", {
            id, titre, description, adresse, date_debut, date_fin, document, etat, iconpath,buildingpath
        });

        // Mise à jour du etude dans la base de données
        await etude.updateEtude(
            id,
            titre,
            description,
            adresse,
            date_debut,
            date_fin,
            document || null, 
            etat,
            iconpath || null,
            buildingpath || null
        );

        // Redirection ou réponse JSON selon le besoin
        res.status(200).redirect("/etudes"); // Redirige vers la liste des etudes après modification

    } catch (error) {
        console.error("❌ Erreur lors de la modification du etude :", error);
        res.status(500).render("etudes", { 
            message: "Une erreur est survenue lors de la modification du etude.",
            success: false
        });
    }
});


router.post("/supprimer/:id", async function (req, res) {
    try {
        console.log("📌 ID reçu via req.params :", req.params.id);

        const id = req.params.id;


        const existingProject = await etude.getEtudeById(id);
        if (!existingProject) {
            return res.status(400).json({ message: "etude introuvable." }); // 🔴 Rejette un etude inexistant
        }


        if (!id) {
            console.error("❌ Erreur : ID non fourni !");
            return res.status(400).render("etudes", { 
                message: "ID du etude manquant.",
                success: false
            });
        }

        console.log("✅ L'ID du etude à supprimer est :", id);


        await etude.deleteEtude(id);

        res.status(200).redirect("/etudes"); // Redirige vers la liste des etudes après modification

    } catch (error) {
        console.error("❌ Erreur lors de la suppression du etude :", error);
        res.status(500).render("etudes", { 
            message: "Une erreur est survenue lors de la suppression du etude.",
            success: false
        });
    }
});




module.exports = router;
