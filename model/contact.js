var db = require('./db.js');

// 🟢 Ajouter un contact
// `flags` porte le verdict anti-spam ({ spam, score, reasons }) : un message
// indésirable est stocké comme les autres, simplement marqué, pour rester
// relisible dans l'admin en cas de faux positif.
async function AddContact(nom, prenom, objet, email, texte, flags = {}) {
    try {
        const query = `
            INSERT INTO contacts (nom, prenom, objet, email, texte, spam, spam_score, spam_reasons) 
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8) 
            RETURNING *`;
        const values = [
            nom, prenom, objet, email, texte,
            Boolean(flags.spam),
            Number(flags.score) || 0,
            (flags.reasons || []).join(", ") || null,
        ];

        const res = await db.query(query, values);
        return res.rows;
    } catch (err) {
        console.error("❌ Erreur lors de l'ajout du contact :", err);
        throw err;
    }
}

// 🟢 Lister les messages reçus (plus récents d'abord)
// `spam` : true = uniquement les indésirables, false = uniquement les légitimes,
// undefined = tout (compatibilité avec les appels existants).
async function listContacts(spam) {
    if (spam === undefined) {
        const res = await db.query("SELECT * FROM contacts ORDER BY date_submitted DESC, id DESC");
        return res.rows;
    }
    const res = await db.query(
        "SELECT * FROM contacts WHERE spam = $1 ORDER BY date_submitted DESC, id DESC",
        [Boolean(spam)]
    );
    return res.rows;
}

// 🟢 Supprimer un message
async function deleteContact(id) {
    await db.query("DELETE FROM contacts WHERE id = $1", [id]);
}

// 🟢 Vider la corbeille des indésirables d'un coup
async function deleteSpam() {
    const res = await db.query("DELETE FROM contacts WHERE spam = true");
    return res.rowCount;
}

// 🟢 Requalifier un message marqué à tort (faux positif)
async function markNotSpam(id) {
    await db.query("UPDATE contacts SET spam = false WHERE id = $1", [id]);
}

module.exports = {
    AddContact,
    listContacts,
    deleteContact,
    deleteSpam,
    markNotSpam
};
