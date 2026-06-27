#!/usr/bin/env node
/**
 * Runner de migrations SQL.
 *
 *   npm run migrate            -> applique les migrations non encore appliquées (ordre chronologique)
 *   npm run migrate -- --status   -> liste appliquées / en attente
 *   npm run migrate -- --baseline -> marque TOUTES les migrations actuelles comme appliquées
 *                                    SANS les exécuter (pour adopter le suivi sur une base déjà peuplée)
 *
 * Chaque migration tourne dans une transaction ; un échec annule (ROLLBACK) et stoppe.
 * Le suivi est stocké dans la table schema_migrations (filename, applied_at).
 */
require("dotenv").config();
const fs = require("fs");
const path = require("path");
const { Pool } = require("pg");

if (!process.env.DB_URL) {
  console.error("✗ DB_URL est requis (cf. .env).");
  process.exit(1);
}

const MIGRATIONS_DIR = path.join(__dirname, "..", "migrations");
const pool = new Pool({
  connectionString: process.env.DB_URL,
  ssl: process.env.DB_SSL === "false" ? false : { rejectUnauthorized: false },
});

function listFiles() {
  return fs
    .readdirSync(MIGRATIONS_DIR)
    .filter((f) => f.endsWith(".sql"))
    .sort(); // noms datés YYYYMMDD_* -> tri lexical = chronologique
}

async function ensureTable(client) {
  await client.query(
    `CREATE TABLE IF NOT EXISTS schema_migrations (
       filename text PRIMARY KEY,
       applied_at timestamptz NOT NULL DEFAULT now()
     )`
  );
}

async function appliedSet(client) {
  const { rows } = await client.query("SELECT filename FROM schema_migrations");
  return new Set(rows.map((r) => r.filename));
}

async function run() {
  const arg = process.argv[2];
  const client = await pool.connect();
  try {
    await ensureTable(client);
    const files = listFiles();
    const applied = await appliedSet(client);
    const pending = files.filter((f) => !applied.has(f));

    if (arg === "--status") {
      console.log(`\n${files.length} migration(s) — ${applied.size} appliquée(s), ${pending.length} en attente :`);
      files.forEach((f) => console.log(`  ${applied.has(f) ? "✓" : "·"} ${f}`));
      return;
    }

    if (arg === "--baseline") {
      for (const f of pending) {
        await client.query("INSERT INTO schema_migrations (filename) VALUES ($1) ON CONFLICT DO NOTHING", [f]);
      }
      console.log(`✓ Baseline : ${pending.length} migration(s) marquée(s) appliquée(s) sans exécution.`);
      return;
    }

    if (!pending.length) {
      console.log("✓ Aucune migration en attente, la base est à jour.");
      return;
    }

    console.log(`→ ${pending.length} migration(s) à appliquer…`);
    for (const f of pending) {
      const sql = fs.readFileSync(path.join(MIGRATIONS_DIR, f), "utf8");
      try {
        await client.query("BEGIN");
        await client.query(sql);
        await client.query("INSERT INTO schema_migrations (filename) VALUES ($1)", [f]);
        await client.query("COMMIT");
        console.log(`  ✓ ${f}`);
      } catch (err) {
        await client.query("ROLLBACK");
        console.error(`  ✗ ÉCHEC sur ${f} : ${err.message}`);
        console.error("    (migration annulée — corrige puis relance ; les précédentes restent appliquées)");
        process.exitCode = 1;
        return;
      }
    }
    console.log("✓ Migrations appliquées.");
  } finally {
    client.release();
    await pool.end();
  }
}

run().catch((err) => {
  console.error("✗ Erreur :", err.message);
  process.exit(1);
});
