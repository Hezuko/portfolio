const pool = require("./db");

// 🟢 Récupérer toutes les certifications
async function getCertifications() {
    try {
        const res = await pool.query("SELECT * FROM certification ORDER BY id DESC");
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
async function addCertification(titre, delivrepar) {
    try {
        const res = await pool.query(
            "INSERT INTO certification (titre, delivrepar) VALUES ($1, $2) RETURNING *",
            [titre, delivrepar]
        );
        return res.rows[0];
    } catch (err) {
        console.error("❌ Erreur lors de l'ajout de la certification :", err);
        throw err;
    }
}

// 🟢 Mettre à jour une certification
async function updateCertification(id, titre, delivrepar) {
    try {
        const res = await pool.query(
            "UPDATE certification SET titre=$1, delivrepar=$2 WHERE id=$3 RETURNING *",
            [titre, delivrepar, id]
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
        await pool.query("DELETE FROM certification WHERE id = $1", [id]);
        return { message: "✅ Certification supprimée avec succès" };
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
