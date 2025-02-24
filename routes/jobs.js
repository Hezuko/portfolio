var express = require('express');
var router = express.Router();
var job = require('../model/job');


router.get('/', async function(req, res, next) {

    try {
        var jobs = await job.getJobs();

        res.render('jobs', { 
            jobs: jobs,
            title : 'Mes Jobs',
            csrfToken: req.csrfToken()
        });
    } catch(err) {
        next(err);
    }
  
});

router.post("/ajouter", async function (req, res) {
    try {
        const { titre, description,	employeur,	adresse, date_debut,	date_fin,	document, partenaire,	iconpath } = req.body;

        if(!titre || !description || !employeur || !description || !adresse || !date_debut || !date_fin) {
            return res.status(400).json({message : "Veuillez remplir tous les champs obligatoires." });
        }

        console.log("Donnée du job à insérer :", {
            titre, description,	employeur,	adresse, date_debut,	date_fin,	document, partenaire,	iconpath
        })

        await job.addJob(
            titre,
            description,
            employeur,
            adresse,
            date_debut,
            date_fin,
            document || null,
            partenaire || null,
            iconpath || null
        );

        res.status(201).redirect("/jobs");
    } catch(error) {
        console.error("❌ Erreur lors de l'ajout du Job :", error);
        res.status(500).render("jobs", {
            message: "Une erreur est survenue lors de l'ajout du job.",
            success: false
        });
    }
    
});

router.post("/modifier", async function (req, res) {
    try {
        const { id, titre, description,	employeur,	adresse, date_debut,	date_fin,	document, partenaire,	iconpath } = req.body;

        if(!id) {
            console.error("Erreur : ID non fourni !");
            return res.status(400).render("jobs", {
                message: "ID du job manquant",
                success: false
            });
        }

        const existingJob = await job.getJobById(id);
        if(!existingJob) {
            return res.status(400).json({message: "Job introuvable"});

        }

        if(!id || !titre || !description || !employeur || !description || !adresse || !date_debut || !date_fin) {
            return res.status(400).json({message : "Veuillez remplir tous les champs." });
        }

        console.log("Donnée du job à insérer :", {
            id, titre, description,	employeur,	adresse, date_debut,	date_fin,	document, partenaire,	iconpath
        })

        await job.updateJob(
            id,
            titre,
            description,
            employeur,
            adresse,
            date_debut,
            date_fin,
            document || null,
            partenaire || null,
            iconpath || null
        );

        res.status(201).redirect("/jobs");
    } catch(error) {
        console.error("❌ Erreur lors de l'ajout du Job :", error);
        res.status(500).render("jobs", {
            message: "Une erreur est survenue lors de l'ajout du job.",
            success: false
        });
    }
    
});


router.post("/supprimer/:id", async function (req, res) {
    try {
        console.log("📌 ID reçu via req.params :", req.params.id);

        const id = req.params.id;


        const existingProject = await job.getJobById(id);
        if (!existingProject) {
            return res.status(400).json({ message: "Job introuvable." }); // 🔴 Rejette un Job inexistant
        }


        if (!id) {
            console.error("❌ Erreur : ID non fourni !");
            return res.status(400).render("Jobs", { 
                message: "ID du Job manquant.",
                success: false
            });
        }

        console.log("✅ L'ID du Job à supprimer est :", id);


        await job.deleteJob(id);

        res.status(200).redirect("/jobs"); // Redirige vers la liste des Jobs après modification

    } catch (error) {
        console.error("❌ Erreur lors de la suppression du Job :", error);
        res.status(500).render("Jobs", { 
            message: "Une erreur est survenue lors de la suppression du Job.",
            success: false
        });
    }
});




module.exports = router;
