const request = require("supertest");
const cheerio = require("cheerio");
const app = require("../app");
const pool = require("../model/db");
const { scoreContact } = require("../utils/antispam");
const turnstile = require("../utils/turnstile");

// Message légitime type (français, pas de lien, email nominatif).
const LEGIT = {
  nom: "Dupont",
  prenom: "Marie",
  objet: "Mission systèmes embarqués",
  email: "marie.dupont@entreprise.fr",
  texte: "Bonjour Hénoc, nous cherchons un ingénieur pour un projet STM32 avec une contrainte Δt de 2 ms. Disponible pour un échange cette semaine ?",
};

describe("scoreContact (heuristiques)", () => {
  it("laisse passer un message légitime, même avec un symbole technique", () => {
    expect(scoreContact(LEGIT, []).spam).toBe(false);
  });

  it("classe le spam reçu en alphabet non latin avec email généré", () => {
    const verdict = scoreContact({
      nom: "RobertUnlot",
      prenom: "BillyUnlotGM",
      objet: "Prise de contact",
      email: "joshuaguerrero2v7t40d@gmail.com",
      texte: "Hi, მინდოდა ვიცოდე თქვენი ფასი.",
    }, []);
    expect(verdict.spam).toBe(true);
    expect(verdict.reasons).toContain("alphabet non latin");
  });

  it("classe les campagnes SEO / backlinks", () => {
    const verdict = scoreContact({
      nom: "Smith", prenom: "John", objet: "Offer", email: "j@x.com",
      texte: "We noticed your website could rank higher. Our SEO and backlink service: http://cheap-seo.xyz",
    }, []);
    expect(verdict.spam).toBe(true);
  });

  it("classe un formulaire rempli instantanément (signal de la route)", () => {
    const verdict = scoreContact(LEGIT, [{ points: 4, reason: "formulaire rempli en moins de 3 s" }]);
    expect(verdict.spam).toBe(true);
  });

  it("ne classe pas sur le seul signal « formulaire non affiché »", () => {
    expect(scoreContact(LEGIT, [{ points: 2, reason: "formulaire non affiché avant l'envoi" }]).spam).toBe(false);
  });
});

describe("POST /contact (filtrage de bout en bout)", () => {
  // `humanDelay` simule le temps de saisie : sans lui, l'envoi part en moins de
  // 3 s et le piège temporel le classe (à raison) comme robot.
  async function submit(fields, humanDelay = 0) {
    const agent = request.agent(app);
    const page = await agent.get("/contact");
    const csrf = cheerio.load(page.text)('input[name="_csrf"]').val();
    if (humanDelay) await new Promise((r) => setTimeout(r, humanDelay));
    return agent.post("/contact").send(Object.assign({ _csrf: csrf }, fields));
  }

  afterAll(async () => {
    await pool.query("DELETE FROM contacts WHERE email LIKE '%jest-antispam%' OR email = 'joshuaguerrero2v7t40d@gmail.com'");
  });

  it("enregistre un message de robot en indésirable, sans notification", async () => {
    const r = await submit({
      nom: "RobertUnlot", prenom: "BillyUnlotGM", objet: "Prise de contact",
      email: "joshuaguerrero2v7t40d@gmail.com", texte: "Hi, მინდოდა ვიცოდე თქვენი ფასი.",
    });
    expect(r.statusCode).toBe(200); // le robot voit la page de succès habituelle
    const { rows } = await pool.query(
      "SELECT spam, spam_score FROM contacts WHERE email = 'joshuaguerrero2v7t40d@gmail.com' ORDER BY id DESC LIMIT 1"
    );
    expect(rows[0].spam).toBe(true);
    expect(rows[0].spam_score).toBeGreaterThanOrEqual(4);
  });

  it("ignore silencieusement une soumission qui remplit un honeypot", async () => {
    const r = await submit({
      nom: "Bot", prenom: "Bot", objet: "Hello",
      email: "hp-jest-antispam@example.com", texte: "message", website: "http://spam.example",
    });
    expect(r.statusCode).toBe(200);
    const { rowCount } = await pool.query("SELECT 1 FROM contacts WHERE email = 'hp-jest-antispam@example.com'");
    expect(rowCount).toBe(0); // rien n'est enregistré
  });

  it("accepte un message légitime et ne le marque pas", async () => {
    const r = await submit(Object.assign({}, LEGIT, { email: "marie.jest-antispam@entreprise.fr" }), 3200);
    expect(r.statusCode).toBe(200);
    const { rows } = await pool.query(
      "SELECT spam FROM contacts WHERE email LIKE '%jest-antispam%' AND nom = 'Dupont' ORDER BY id DESC LIMIT 1"
    );
    expect(rows[0].spam).toBe(false);
  }, 15000);

  it("classe un envoi immédiat, sans temps de saisie plausible", async () => {
    const r = await submit(Object.assign({}, LEGIT, { nom: "Rapide", email: "flash.jest-antispam@entreprise.fr" }));
    expect(r.statusCode).toBe(200);
    const { rows } = await pool.query(
      "SELECT spam, spam_reasons FROM contacts WHERE email = 'flash.jest-antispam@entreprise.fr' ORDER BY id DESC LIMIT 1"
    );
    expect(rows[0].spam).toBe(true);
    expect(rows[0].spam_reasons).toContain("moins de 3 s");
  });
});

describe("turnstile (CAPTCHA optionnel)", () => {
  const envBackup = { ...process.env };
  afterEach(() => { process.env = { ...envBackup }; });

  it("est désactivé tant que les deux clés ne sont pas définies", async () => {
    delete process.env.TURNSTILE_SITE_KEY;
    delete process.env.TURNSTILE_SECRET_KEY;
    expect(turnstile.isEnabled()).toBe(false);
    // Désactivé : on ne bloque rien, le formulaire fonctionne comme avant.
    await expect(turnstile.verify(undefined)).resolves.toMatchObject({ ok: true, skipped: true });

    process.env.TURNSTILE_SITE_KEY = "0x-site";
    expect(turnstile.isEnabled()).toBe(false); // clé secrète manquante
  });

  it("refuse une soumission sans jeton quand il est configuré", async () => {
    process.env.TURNSTILE_SITE_KEY = "0x-site";
    process.env.TURNSTILE_SECRET_KEY = "0x-secret";
    expect(turnstile.isEnabled()).toBe(true);
    await expect(turnstile.verify("")).resolves.toMatchObject({ ok: false });
  });
});
