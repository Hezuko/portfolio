const pool = require("./db");

// 🟢 Récupérer toutes les études
async function getEtudes() {
    try {
        const res = await pool.query("SELECT * FROM etude ORDER BY date_debut DESC");
        return res.rows;
    } catch (err) {
        console.error("❌ Erreur lors de la récupération des études :", err);
        throw err;
    }
}

// 🟢 Récupérer une étude par ID
async function getEtudeById(id) {
    try {
        const res = await pool.query("SELECT * FROM etude WHERE id = $1", [id]);
        return res.rows[0];
    } catch (err) {
        console.error("❌ Erreur lors de la récupération de l'étude :", err);
        throw err;
    }
}

// 🟢 Ajouter une étude
async function addEtude(titre, description, adresse, date_debut, date_fin, document, etat, iconpath, buildingpath) {
    try {
        // Remplace les valeurs vides par NULL
        document = document || null;
        iconpath = iconpath || null;
        buildingpath = buildingpath || null;

        console.log(`📌 Requête SQL exécutée : 
            INSERT INTO etude (titre, description, adresse, date_debut, date_fin, document, etat, iconpath, buildingpath) 
            VALUES ('${titre}', '${description}', '${adresse}', '${date_debut}', '${date_fin}', '${document}', '${etat}', '${iconpath}', '${buildingpath}')`);

        const res = await pool.query(
            `INSERT INTO etude (titre, description, adresse, date_debut, date_fin, document, etat, iconpath, buildingpath) 
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) 
             RETURNING *`, 
            [titre, description, adresse, date_debut, date_fin, document, etat, iconpath, buildingpath]
        );        
        return res.rows[0]; // Retourne l'élément inséré
    } catch (err) {
        console.error("❌ Erreur lors de l'ajout du projet :", err);
        throw err;
    }
}

// 🟢 Mettre à jour une étude
async function updateEtude(id, titre, description, adresse, date_debut, date_fin, document, etat, iconpath, buildingpath) {
    try {
        const res = await pool.query(
            "UPDATE etude SET titre=$1, description=$2, adresse=$3, date_debut=$4, date_fin=$5, document=$6, etat=$7, iconpath=$8, buildingpath=$9 WHERE id=$10 RETURNING *",
            [titre, description, adresse, date_debut, date_fin, document, etat, iconpath, buildingpath, id]
        );
        return res.rows[0];
    } catch (err) {  
        console.error("❌ Erreur lors de la mise à jour de l'étude :", err);
        throw err;
    }
}

// 🟢 Supprimer une étude
async function deleteEtude(id) {
    try {
        await pool.query("DELETE FROM etude WHERE id = $1", [id]);
        return { message: "✅ Étude supprimée avec succès" };
    } catch (err) {
        console.error("❌ Erreur lors de la suppression de l'étude :", err);
        throw err;
    }
}

module.exports = {
    getEtudes,
    getEtudeById,
    addEtude,
    updateEtude,
    deleteEtude
};
