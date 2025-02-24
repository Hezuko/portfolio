var pool = require('./db');

async function getProjets() {
    try {
        const res = await pool.query("SELECT * FROM projet ORDER BY date_debut DESC");
        return res.rows;
    } catch (err) {
        console.error("❌ Erreur lors de la récupération des projets :", err);
        throw err;
    }
}


async function getProjetById(id) {
    try {
        const res = await pool.query("SELECT * FROM projet WHERE id = $1", [id]);
        return res.rows[0]; // Retourne le premier projet trouvé ou undefined si non trouvé
    } catch (err) {
        console.error("❌ Erreur lors de la récupération du projet :", err);
        throw err;
    }
}


async function addProjet(titre, description, adresse, date_debut, date_fin, document, etat, partenaire, iconpath) {
    try {
        // Remplace les valeurs vides par NULL
        document = document || null;
        partenaire = partenaire || null;
        iconpath = iconpath || null;

        console.log(`📌 Requête SQL exécutée : 
            INSERT INTO projet (titre, description, adresse, date_debut, date_fin, document, etat, partenaire, iconpath) 
            VALUES ('${titre}', '${description}', '${adresse}', '${date_debut}', '${date_fin}', '${document}', '${etat}', '${partenaire}', '${iconpath}')`);

        const res = await pool.query(
            `INSERT INTO projet (titre, description, adresse, date_debut, date_fin, document, etat, partenaire, iconpath) 
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) 
             RETURNING *`, 
            [titre, description, adresse, date_debut, date_fin, document, etat, partenaire, iconpath]
        );        
        return res.rows[0]; // Retourne l'élément inséré
    } catch (err) {
        console.error("❌ Erreur lors de l'ajout du projet :", err);
        throw err;
    }
}



async function updateProjet(id, titre, description, adresse, date_debut, date_fin, document, etat, partenaire, iconpath) {
    try {
        console.log(`📌 Requête SQL exécutée :
            UPDATE projet 
            SET titre = '${titre}', description = '${description}', adresse = '${adresse}', 
                date_debut = '${date_debut}', date_fin = '${date_fin}', document = '${document}', 
                etat = '${etat}', partenaire = '${partenaire}', iconpath = '${iconpath}'
            WHERE id = ${id}
        `);

        const res = await pool.query(
            `UPDATE projet 
             SET titre = $1, description = $2, adresse = $3, date_debut = $4, date_fin = $5, 
                 document = $6, etat = $7, partenaire = $8, iconpath = $9
             WHERE id = $10
             RETURNING *`, 
            [titre, description, adresse, date_debut, date_fin, document, etat, partenaire, iconpath, id]
        );

        return res.rows[0]; // Retourne l'élément mis à jour
    } catch (err) {
        console.error("❌ Erreur lors de la modification du projet :", err);
        throw err;
    }
}


async function deleteProjet(id) {
    try {
        await pool.query("DELETE FROM projet WHERE id = $1", [id]);
        return { message: "✅ Projet supprimé avec succès" };
    } catch (err) {
        console.error("❌ Erreur lors de la suppression du projet :", err);
        throw err;
    }
}

module.exports = {
    getProjets,
    getProjetById,
    addProjet,
    updateProjet,
    deleteProjet
};