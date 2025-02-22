var db = require('./db.js');

const getCertification = async () => {
    try {
        const res = await db.query('SELECT * FROM Certification ORDER BY id DESC');
        return res.rows;
    } catch (err) {
        console.error('Erreur lors de la récupération des diplômes', err);
        throw err;
    }
};


module.exports = {
    getCertification
};
