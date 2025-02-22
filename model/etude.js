var db = require('./db.js');

const getEtudes = async () => {
    try {
        const res = await db.query('SELECT * FROM Etude ORDER BY date_debut DESC');
        return res.rows;
    } catch (err) {
        console.error('Erreur lors de la récupération des études', err);
        throw err;
    }
};


module.exports = {
    getEtudes
};
