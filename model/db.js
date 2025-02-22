const { Pool } = require('pg');

const pool = new Pool({
    host: 'monserveur.postgres.database.com',  // 🌍 Adresse du serveur distant
    user: 'monutilisateur',  // 🔑 Identifiant PostgreSQL
    password: 'monmotdepasse',  // 🔒 Mot de passe PostgreSQL
    database: 'portfolio',  // 📂 Nom de la base de données
    port: 5432,  // 📡 Port PostgreSQL (généralement 5432)
    ssl: { rejectUnauthorized: false }  // 🔐 Activer SSL si nécessaire
});

module.exports = pool;
