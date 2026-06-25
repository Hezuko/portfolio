require('dotenv').config();
const { Pool } = require('pg');

if (!process.env.DB_URL) {
    throw new Error("La variable d'environnement DB_URL est requise pour se connecter à PostgreSQL.");
}

const pool = new Pool({
    connectionString: process.env.DB_URL,
    ssl: process.env.DB_SSL === "false" ? false : { rejectUnauthorized: false }
});

module.exports = pool;
