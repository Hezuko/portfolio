var express = require("express");
var router = express.Router();
var utilisateur = require("../model/utilisateur"); 
var sessionManager = require("../config/session"); 
const { v4: uuidv4 } = require("uuid");
var { preventAuthAccess } = require("../middlewares/auth");
const rateLimit = require("express-rate-limit");


// 🔹 Limiteur de requêtes : max 5 tentatives par minute
const loginLimiter = rateLimit({
    windowMs: 60 * 1000, 
    max: 1000, 
    message: "⛔ Trop de tentatives de connexion. Réessayez plus tard.",
    standardHeaders: true, 
    legacyHeaders: false, 
});

// 🔹 Afficher la page de connexion
router.get("/", preventAuthAccess, async function (req, res) {
    res.render("authentification", { 
        title: "Authentification", 
        error: null 
    });
});

// Appliquer le limiter uniquement à la route de connexion
router.post("/", loginLimiter, async function (req, res) { 
    try {
        const { pseudo, password } = req.body;

        const user = await utilisateur.verifyUtilisateur(pseudo, password);

        if (!user) {
            return res.render("authentification", { 
                title: "Authentification", 
                error: "Identifiant ou code d'accès incorrect" // Envoie de l'erreur à la vue
            });
        }

        // Enregistrer en session
        sessionManager.createSession(req, user);

        res.redirect(user.role === "admin" ? "/admin" : "/");
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
