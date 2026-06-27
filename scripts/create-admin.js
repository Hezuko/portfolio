#!/usr/bin/env node
/**
 * Crée (ou met à jour) le compte admin. La base seedée ne contient AUCUN
 * utilisateur ; ce script sert à initialiser l'accès au back-office en prod.
 *
 *   node scripts/create-admin.js <pseudo> <motdepasse>
 *   ADMIN_USER=henoc ADMIN_PASSWORD=… node scripts/create-admin.js
 *
 * En Docker :
 *   docker compose -f docker-compose.prod.yml exec portfolio \
 *     node scripts/create-admin.js monpseudo 'MonMotDePasseFort!'
 */
require("dotenv").config();
const bcrypt = require("bcryptjs");
const { Pool } = require("pg");

const pseudo = process.argv[2] || process.env.ADMIN_USER;
const password = process.argv[3] || process.env.ADMIN_PASSWORD;

if (!pseudo || !password) {
  console.error("Usage : node scripts/create-admin.js <pseudo> <motdepasse>  (ou ADMIN_USER / ADMIN_PASSWORD)");
  process.exit(1);
}
if (!process.env.DB_URL) {
  console.error("✗ DB_URL est requis (cf. .env).");
  process.exit(1);
}

(async () => {
  const pool = new Pool({
    connectionString: process.env.DB_URL,
    ssl: process.env.DB_SSL === "false" ? false : { rejectUnauthorized: false },
  });
  try {
    const hash = await bcrypt.hash(password, 10);
    await pool.query(
      `INSERT INTO utilisateurs (pseudo, mot_de_passe, role)
       VALUES ($1, $2, 'admin')
       ON CONFLICT (pseudo) DO UPDATE SET mot_de_passe = EXCLUDED.mot_de_passe, role = 'admin'`,
      [pseudo, hash]
    );
    console.log(`✓ Compte admin « ${pseudo} » créé / mis à jour.`);
  } catch (err) {
    console.error("✗ Échec :", err.message);
    process.exitCode = 1;
  } finally {
    await pool.end();
  }
})();
