var db = require('./db.js');

// 🟢 Ajouter un contact
async function AddContact(nom, prenom, objet, email, texte) {
    try {
        const query = `
            INSERT INTO contacts (nom, prenom, objet, email, texte) 
            VALUES ($1, $2, $3, $4, $5) 
            RETURNING *`;
        const values = [nom, prenom, objet, email, texte];

        const res = await db.query(query, values);
        return res.rows;
    } catch (err) {
        console.error("❌ Erreur lors de l'ajout du contact :", err);
        throw err;
    }
}

// 🟢 Lister les messages reçus (plus récents d'abord)
async function listContacts() {
    const res = await db.query("SELECT * FROM contacts ORDER BY date_submitted DESC, id DESC");
    return res.rows;
}

// 🟢 Supprimer un message
async function deleteContact(id) {
    await db.query("DELETE FROM contacts WHERE id = $1", [id]);
}

module.exports = {
    AddContact,
    listContacts,
    deleteContact
};
