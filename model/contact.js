var db = require('./db.js');

const AddContact = async (nom, prenom, objet, email, texte) => {
    try {
        const query = `
            INSERT INTO contacts (nom, prenom, objet, email, texte) 
            VALUES ($1, $2, $3, $4, $5) 
            RETURNING *`;
        const values = [nom, prenom, objet, email, texte];
        
        const res = await db.query(query, values);
        return res.rows[0]; // Retourne la ligne insérée
    } catch (err) {
        console.error('Erreur lors de l\'ajout du contact', err);
        throw err;
    }
};

module.exports = {
    AddContact
};
