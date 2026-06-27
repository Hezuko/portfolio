require('dotenv').config();
const { Pool } = require('pg');

if (!process.env.DB_URL) {
    throw new Error("La variable d'environnement DB_URL est requise pour se connecter à PostgreSQL.");
}

const pool = new Pool({
    connectionString: process.env.DB_URL,
    ssl: process.env.DB_SSL === "false" ? false : { rejectUnauthorized: false }
});

// Un client PG inactif qui reçoit une erreur (redémarrage DB, coupure réseau) émettrait
// un 'error' non géré qui ferait tomber tout le process. On le loggue sans crasher.
pool.on("error", (err) => {
    console.error("⚠️  Erreur sur un client PG inactif :", err.message);
});

module.exports = pool;
