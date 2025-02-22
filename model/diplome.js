var db = require('./db.js');

const getDiplomes = async () => {
    try {
        const res = await db.query('SELECT * FROM Diplome ORDER BY id DESC');
        return res.rows;
    } catch (err) {
        console.error('Erreur lors de la récupération des diplômes', err);
        throw err;
    }
};


module.exports = {
    getDiplomes
};
