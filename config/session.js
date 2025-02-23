require('dotenv').config();
var session = require("express-session");
var pgSession = require("connect-pg-simple")(session);
const pool = require("../model/db"); 
const { TRUE } = require('sass');

// 🟢 Initialiser la session avec PostgreSQL
function initSession() {
    return session({
        store: new pgSession({
            pool: pool, // Stocker les sessions dans PostgreSQL
            tableName: "session", // Nom de la table des sessions
            createTableIfMissing: true
        }),
        secret: process.env.SESSION_SECRET, // Clé secrète pour signer la session
        resave: false,
        saveUninitialized: false,
        cookie: {
            secure: process.env.NODE_ENV === 'production', // Activé uniquement en production
            httpOnly: true, // Empêche l'accès au cookie via JavaScript
            sameSite: 'strict', // Empêche les attaques CSRF
            maxAge: 3600 * 1000 // Expiration après 1 heure
        },
    });
}

// 🟢 Créer une session utilisateur après connexion
async function createSession(req, user) {
    req.session.userid = user.id;
    req.session.role = user.role;
    req.session.user = user;
}

// 🟢 Vérifier si un utilisateur est connecté
async function isConnected(req) {
    return req.session && req.session.userid !== undefined;
}

// 🟢 Supprimer la session (déconnexion)
async function deleteSession(req) {
    return new Promise((resolve, reject) => {
        req.session.destroy((err) => {
            if (err) {
                console.error("❌ Erreur lors de la suppression de la session :", err);
                reject(err);
            } else {
                resolve({ message: "✅ Déconnexion réussie" });
            }
        });
    });
}

module.exports = {
    initSession,
    createSession,
    isConnected,
    deleteSession
};
