const request = require("supertest");
const cheerio = require("cheerio");
const app = require("../app");
const pool = require("../model/db");
const utilisateur = require("../model/utilisateur");

// Utilisateur admin dédié aux tests : créé puis supprimé, sans toucher au compte réel.
const TEST_ADMIN = { pseudo: "admin-test-jest", password: "Jest-Admin-Passw0rd!" };

async function loginAdmin() {
  const agent = request.agent(app);
  const loginPage = await agent.get("/authentification");
  const $ = cheerio.load(loginPage.text);
  const csrf = $('input[name="_csrf"]').val();
  await agent.post("/authentification").send({ pseudo: TEST_ADMIN.pseudo, password: TEST_ADMIN.password, _csrf: csrf });
  return agent;
}

beforeAll(async () => {
  const hash = await utilisateur.hashMotDePasse(TEST_ADMIN.password);
  await pool.query(
    `INSERT INTO utilisateurs (pseudo, mot_de_passe, role)
     VALUES ($1, $2, 'admin')
     ON CONFLICT (pseudo) DO UPDATE SET mot_de_passe = EXCLUDED.mot_de_passe, role = 'admin'`,
    [TEST_ADMIN.pseudo, hash]
  );
});

describe("vision visiteur", () => {
  it("affiche l'accueil public sans connexion", async () => {
    const response = await request(app).get("/");
    expect(response.statusCode).toBe(200);
    expect(response.text).toContain("Henoc Mukumbi");
    expect(response.text).toContain("Mes projets");
    expect(response.text).toContain("home-summary-card");
    expect(response.text).toContain("focus-scroll-page");
  });

  it("affiche les projets publics", async () => {
    const response = await request(app).get("/projets");
    expect(response.statusCode).toBe(200);
    expect(response.text).toContain("Projets");
    expect(response.text).toMatch(/project-showcase|Aucun projet n'a encore (été|ete) publié/);
  });

  it("redirige l'admin non connecte vers le login", async () => {
    const response = await request(app).get("/admin");
    expect(response.statusCode).toBe(302);
    expect(response.headers.location).toBe("/authentification");
  });
});

describe("vision admin", () => {
  it("connecte l'admin et affiche le dashboard", async () => {
    const agent = await loginAdmin();
    const response = await agent.get("/admin");
    expect(response.statusCode).toBe(200);
    expect(response.text).toContain("Dashboard");
    expect(response.text).toContain("Projets");
  });

  it("cree, modifie et supprime une competence", async () => {
    const agent = await loginAdmin();
    const page = await agent.get("/admin/skills/new");
    const $ = cheerio.load(page.text);
    const csrf = $('input[name="_csrf"]').val();

    const created = await agent.post("/admin/skills").send({
      _csrf: csrf,
      name: "Test UX",
      category: "Outils",
      icon: "test",
      level: "intermediaire",
    });
    expect(created.statusCode).toBe(302);

    const list = await agent.get("/admin/skills");
    expect(list.text).toContain("Test UX");

    const { rows } = await pool.query("SELECT id FROM skills WHERE name = $1 ORDER BY id DESC LIMIT 1", ["Test UX"]);
    const id = rows[0].id;

    const editPage = await agent.get(`/admin/skills/${id}/edit`);
    const $$ = cheerio.load(editPage.text);
    const editCsrf = $$('input[name="_csrf"]').val();
    const updated = await agent.post(`/admin/skills/${id}`).send({
      _csrf: editCsrf,
      name: "Test UX Admin",
      category: "Outils",
      icon: "test",
      level: "avance",
    });
    expect(updated.statusCode).toBe(302);

    const deletePage = await agent.get("/admin/skills");
    const $$$ = cheerio.load(deletePage.text);
    const deleteCsrf = $$$('input[name="_csrf"]').first().val();
    const removed = await agent.post(`/admin/skills/${id}/delete`).send({ _csrf: deleteCsrf });
    expect(removed.statusCode).toBe(302);
  });
});

describe("routes publiques (SEO + contact)", () => {
  async function contactSession() {
    const agent = request.agent(app);
    const page = await agent.get("/contact");
    const csrf = cheerio.load(page.text)('input[name="_csrf"]').val();
    return { agent, csrf };
  }

  it("sert le sitemap.xml", async () => {
    const r = await request(app).get("/sitemap.xml");
    expect(r.statusCode).toBe(200);
    expect(r.headers["content-type"]).toMatch(/xml/);
    expect(r.text).toContain("<urlset");
    expect(r.text).toContain("/projets");
  });

  it("sert robots.txt (sitemap + disallow admin)", async () => {
    const r = await request(app).get("/robots.txt");
    expect(r.statusCode).toBe(200);
    expect(r.text).toMatch(/Sitemap:/i);
    expect(r.text).toMatch(/Disallow:\s*\/admin/);
  });

  it("redirige /jobs/:id (301) vers /experiences/:id", async () => {
    const r = await request(app).get("/jobs/2");
    expect(r.statusCode).toBe(301);
    expect(r.headers.location).toBe("/experiences/2");
  });

  it("normalise le slash final (301)", async () => {
    const r = await request(app).get("/projets/");
    expect(r.statusCode).toBe(301);
    expect(r.headers.location).toBe("/projets");
  });

  it("POST /contact : champs manquants -> 400", async () => {
    const { agent, csrf } = await contactSession();
    const r = await agent.post("/contact").send({ _csrf: csrf, website: "" });
    expect(r.statusCode).toBe(400);
  });

  it("POST /contact : honeypot rempli -> succès simulé sans traitement", async () => {
    const { agent, csrf } = await contactSession();
    const r = await agent.post("/contact").send({ _csrf: csrf, website: "http://bot.example", nom: "B", prenom: "O", email: "b@o.com", texte: "spam" });
    expect(r.statusCode).toBe(200);
  });

  it("POST /contact : email invalide -> 400", async () => {
    const { agent, csrf } = await contactSession();
    const r = await agent.post("/contact").send({ _csrf: csrf, website: "", nom: "Test", prenom: "User", email: "pas-un-email", texte: "Bonjour" });
    expect(r.statusCode).toBe(400);
  });

  // En dernier : ce test consomme le quota de l'IP de test (rate-limit en mémoire).
  it("POST /contact : rate-limit -> 429 au-delà de la limite", async () => {
    const { agent, csrf } = await contactSession();
    const codes = [];
    for (let i = 0; i < 12; i++) {
      const r = await agent.post("/contact").send({ _csrf: csrf, website: "", nom: "x", prenom: "y", email: "bad", texte: "z" });
      codes.push(r.statusCode);
    }
    expect(codes).toContain(429);
  });
});

afterAll(async () => {
  await pool.query("DELETE FROM utilisateurs WHERE pseudo = $1", [TEST_ADMIN.pseudo]);
  await pool.end();
});
