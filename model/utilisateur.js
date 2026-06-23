const pool = require("./db");
const bcrypt = require("bcryptjs");

const SALT_ROUNDS = 10;

// 🔐 Hacher un mot de passe (utilisé pour créer / réinitialiser un compte)
async function hashMotDePasse(mdp) {
    return bcrypt.hash(mdp, SALT_ROUNDS);
}

// 🟢 Récupérer un utilisateur par le pseudo
async function getUtilisateur(pseudo) {
    try {
        const res = await pool.query("SELECT * FROM utilisateurs WHERE pseudo = $1", [pseudo]);
        return res.rows[0];
    } catch (err) {
        console.error("❌ Erreur lors de la récupération de l'utilisateur :", err);
        throw err;
    }
}

async function verifyUtilisateur(pseudo, mdp) {
    try {
        const res = await pool.query("SELECT * FROM utilisateurs WHERE pseudo = $1", [pseudo]);
        const utilisateur = res.rows[0];

        if (!utilisateur) return null;

        const motDePasseValide = await bcrypt.compare(mdp, utilisateur.mot_de_passe);
        if (!motDePasseValide) {
            return null;
        }

        return utilisateur;

    } catch (err) {
        console.error("❌ Erreur lors de la vérification de l'utilisateur :", err);
        throw err;
    }
}


module.exports = {
    getUtilisateur,
    verifyUtilisateur,
    hashMotDePasse
};
