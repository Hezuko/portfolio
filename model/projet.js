var db = require('./db.js');

const getProjets = async () => {
    try {
        const res = await db.query('SELECT * FROM Projet ORDER BY date_debut DESC');
        return res.rows;
    } catch (err) {
        console.error('Erreur lors de la récupération des projets', err);
        throw err;
    }
};


module.exports = {
    getProjets
};
