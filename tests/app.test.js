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

afterAll(async () => {
  await pool.query("DELETE FROM utilisateurs WHERE pseudo = $1", [TEST_ADMIN.pseudo]);
  await pool.end();
});
