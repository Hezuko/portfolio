const pool = require("./db");

// 🟢 Récupérer tous les diplômes
async function getDiplomes() {
    try {
        const res = await pool.query("SELECT * FROM diplome ORDER BY id DESC");
        return res.rows;
    } catch (err) {
        console.error("❌ Erreur lors de la récupération des diplômes :", err);
        throw err;
    }
}

// 🟢 Récupérer un diplôme par ID
async function getDiplomeById(id) {
    try {
        const res = await pool.query("SELECT * FROM diplome WHERE id = $1", [id]);
        return res.rows[0];
    } catch (err) {
        console.error("❌ Erreur lors de la récupération du diplôme :", err);
        throw err;
    }
}

// 🟢 Ajouter un diplôme
async function addDiplome(titre, niveau_etude, delivrepar, etude_id, annee_obtention, image_path) {
    try {

        console.log("Les données qui vont êtres insérées :", titre, niveau_etude, delivrepar, etude_id, image_path, annee_obtention);
        
        const res = await pool.query(
            "INSERT INTO diplome (titre, niveau_etude, delivrepar, etude_id, annee_obtention, image_path) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *",
            [titre, niveau_etude, delivrepar, etude_id, annee_obtention, image_path]
        );
        return res.rows[0];
    } catch (err) {
        console.error("❌ Erreur lors de l'ajout du diplôme :", err);
        throw err;
    }
}

// 🟢 Mettre à jour un diplôme
async function updateDiplome(id, titre, niveau_etude, annee_obtention) {
    try {
        const res = await pool.query(
            `UPDATE diplome 
            SET titre = $1, 
                niveau_etude = $2, 
                annee_obtention = $3
            WHERE id = $4 
            RETURNING *`,
            [titre, niveau_etude, annee_obtention, id]
        );

        if (res.rowCount === 0) {
            throw new Error("Diplôme non trouvé !");
        }

        return res.rows[0];
    } catch (err) {  
        console.error("❌ Erreur lors de la mise à jour du diplôme :", err);
        throw err;
    }
}

// 🟢 Supprimer un diplôme
async function deleteDiplome(id) {
    try {
        await pool.query("DELETE FROM diplome WHERE id = $1", [id]);
        return { message: "✅ Diplôme supprimé avec succès" };
    } catch (err) {
        console.error("❌ Erreur lors de la suppression du diplôme :", err);
        throw err;
    }
}

module.exports = {
    getDiplomes,
    getDiplomeById,
    addDiplome,
    updateDiplome,
    deleteDiplome
};
