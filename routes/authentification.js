var express = require("express");
var router = express.Router();
var utilisateur = require("../model/utilisateur"); 
var sessionManager = require("../config/session"); 
const { v4: uuidv4 } = require("uuid");
var { preventAuthAccess } = require("../middlewares/auth");

// 🔹 Afficher la page de connexion
router.get("/", preventAuthAccess, async function (req, res) {
    res.render("authentification", { 
        title: "Authentification", 
        error: null 
    });
});

// 🔹 Connexion de l'utilisateur
router.post("/", async function (req, res) { 
    try {
        const { pseudo, password } = req.body;

        const user = await utilisateur.verifyUtilisateur(pseudo, password);


        if (!user) {
            return res.render("authentification", { 
                title: "Authentification", 
                error: "Pseudo ou mot de passe incorrect" 
            });
        }

        // Enregistrer en session
        sessionManager.createSession(req, user);

        res.redirect("/");
    } catch (err) {
        console.error("❌ Erreur de connexion :", err);
        res.status(500).render("authentification", { 
            title: "Authentification", 
            error: "Erreur serveur" 
        });
    }
});

router.get("/visiteur", preventAuthAccess, async function (req, res) {
    try {
        const visiteur = {
            id: `visiteur-${uuidv4()}`,
            pseudo: `Visiteur-${Math.floor(Math.random() * 10000)}`, 
            role: "visiteur"
        };

        // 🔹 Enregistrer la session pour le visiteur
        sessionManager.createSession(req, visiteur);

        res.redirect("/");
    } catch (err) {
        console.error("❌ Erreur lors de la création de la session visiteur :", err);
        res.status(500).render("authentification", { 
            title: "Authentification", 
            error: "Erreur serveur" 
        });
    }
});


module.exports = router;
