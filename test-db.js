const pool = require('./model/db');

(async () => {
    try {
        const res = await pool.query('SELECT NOW()');
        console.log("✅ Connexion réussie à PostgreSQL !", res.rows);
    } catch (err) {
        console.error("❌ Erreur de connexion PostgreSQL :", err);
    }
})();
