const pool = require("./db");

// 🟢 Récupérer tous les jobs
async function getJobs() {
    try {
        const res = await pool.query("SELECT * FROM job ORDER BY date_debut DESC");
        return res.rows;
    } catch (err) {
        console.error("❌ Erreur lors de la récupération des jobs :", err);
        throw err;
    }
}

// 🟢 Récupérer un job par ID
async function getJobById(id) {
    try {
        const res = await pool.query("SELECT * FROM job WHERE id = $1", [id]);
        return res.rows[0];
    } catch (err) {
        console.error("❌ Erreur lors de la récupération du job :", err);
        throw err;
    }
}

// 🟢 Ajouter un job
async function addJob(titre, description, employeur, adresse, date_debut, date_fin, document, partenaire, iconpath) {
    try {
        const res = await pool.query(
            "INSERT INTO job (titre, description, employeur, adresse, date_debut, date_fin, document, partenaire, iconpath) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *",
            [titre, description, employeur, adresse, date_debut, date_fin, document, partenaire, iconpath]
        );
        return res.rows[0];
    } catch (err) {
        console.error("❌ Erreur lors de l'ajout du job :", err);
        throw err;
    }
}

// 🟢 Mettre à jour un job
async function updateJob(id, titre, description, employeur, adresse, date_debut, date_fin, document, partenaire, iconpath) {
    try {
        const res = await pool.query(
            "UPDATE job SET titre=$1, description=$2, employeur=$3, adresse=$4, date_debut=$5, date_fin=$6, document=$7, partenaire=$8, iconpath=$9 WHERE id=$10 RETURNING *",
            [titre, description, employeur, adresse, date_debut, date_fin, document, partenaire, iconpath, id]
        );
        return res.rows[0];
    } catch (err) {  
        console.error("❌ Erreur lors de la mise à jour du job :", err);
        throw err;
    }
}

// 🟢 Supprimer un job
async function deleteJob(id) {
    try {
        await pool.query("DELETE FROM job WHERE id = $1", [id]);
        return { message: "✅ Job supprimé avec succès" };
    } catch (err) {
        console.error("❌ Erreur lors de la suppression du job :", err);
        throw err;
    }
}

module.exports = {
    getJobs,
    getJobById,
    addJob,
    updateJob,
    deleteJob
};
