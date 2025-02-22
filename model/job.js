var db = require('./db.js');

const getJobs = async () => {
    try {
        const res = await db.query('SELECT * FROM Job ORDER BY date_debut DESC');
        return res.rows;
    } catch (err) {
        console.error('Erreur lors de la récupération des jobs', err);
        throw err;
    }
};


module.exports = {
    getJobs
};
