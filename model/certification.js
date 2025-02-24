const pool = require('./db.js');

// 🟢 Récupérer toutes les certifications
async function getCertifications() {
    try {
        const res = await pool.query("SELECT * FROM certification ORDER BY annee_obtention DESC");
        return res.rows;
    } catch (err) {
        console.error("❌ Erreur lors de la récupération des certifications :", err);
        throw err;
    }
}

// 🟢 Récupérer une certification par ID
async function getCertificationById(id) {
    try {
        const res = await pool.query("SELECT * FROM certification WHERE id = $1", [id]);
        return res.rows[0];
    } catch (err) {
        console.error("❌ Erreur lors de la récupération de la certification :", err);
        throw err;
    }
}

// 🟢 Ajouter une certification
async function addCertification(titre, delivrepar, annee_obtention, image_path) {
    try {
        const res = await pool.query(
            "INSERT INTO certification (titre, delivrepar, annee_obtention, image_path) VALUES ($1, $2, $3, $4) RETURNING *",
            [titre, delivrepar, annee_obtention, image_path]
        );
        return res.rows[0];
    } catch (err) {
        console.error("❌ Erreur lors de l'ajout de la certification :", err);
        throw err;
    }
}

// 🟢 Mettre à jour une certification
async function updateCertification(id, titre, delivrepar, annee_obtention, image_path) {
    try {
        const res = await pool.query(
            "UPDATE certification SET titre=$1, delivrepar=$2, annee_obtention=$3, image_path=$4 WHERE id=$5 RETURNING *",
            [titre, delivrepar, annee_obtention, image_path, id]
        );
        return res.rows[0];
    } catch (err) {  
        console.error("❌ Erreur lors de la mise à jour de la certification :", err);
        throw err;
    }
}

// 🟢 Supprimer une certification
async function deleteCertification(id) {
    try {
        const res = await pool.query("DELETE FROM certification WHERE id=$1 RETURNING *", [id]);
        return res.rows[0];
    } catch (err) {
        console.error("❌ Erreur lors de la suppression de la certification :", err);
        throw err;
    }
}

module.exports = {
    getCertifications,
    getCertificationById,
    addCertification,
    updateCertification,
    deleteCertification
};
