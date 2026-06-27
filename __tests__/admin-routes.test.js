const request = require("supertest");
const cheerio = require("cheerio");
const app = require("../app");
const pool = require("../model/db");
const utilisateur = require("../model/utilisateur");

const TEST_ADMIN = { pseudo: "admin-test-jest-admin", password: "Jest-Admin-Passw0rd!" };

async function loginAdmin() {
  const agent = request.agent(app);
  const page = await agent.get("/authentification");
  const csrf = cheerio.load(page.text)('input[name="_csrf"]').val();
  await agent.post("/authentification").send({ pseudo: TEST_ADMIN.pseudo, password: TEST_ADMIN.password, _csrf: csrf });
  return agent;
}

beforeAll(async () => {
  const hash = await utilisateur.hashMotDePasse(TEST_ADMIN.password);
  await pool.query(
    `INSERT INTO utilisateurs (pseudo, mot_de_passe, role) VALUES ($1,$2,'admin')
     ON CONFLICT (pseudo) DO UPDATE SET mot_de_passe = EXCLUDED.mot_de_passe, role='admin'`,
    [TEST_ADMIN.pseudo, hash]
  );
});

describe("authentification", () => {
  it("verifyUtilisateur valide le bon mot de passe et rejette le mauvais", async () => {
    const ok = await utilisateur.verifyUtilisateur(TEST_ADMIN.pseudo, TEST_ADMIN.password);
    expect(ok).toBeTruthy();
    const ko = await utilisateur.verifyUtilisateur(TEST_ADMIN.pseudo, "mauvais-mdp");
    expect(ko).toBeFalsy();
  });

  it("refuse une connexion avec un mauvais mot de passe", async () => {
    const agent = request.agent(app);
    const page = await agent.get("/authentification");
    const csrf = cheerio.load(page.text)('input[name="_csrf"]').val();
    const r = await agent.post("/authentification").send({ pseudo: TEST_ADMIN.pseudo, password: "faux", _csrf: csrf });
    const dash = await agent.get("/admin");
    expect(dash.statusCode).toBe(302); // non connecté -> redirigé
  });
});

describe("pages admin (connecté, GET 200)", () => {
  const pages = ["/admin", "/admin/messages", "/admin/media", "/admin/projects", "/admin/jobs", "/admin/educations", "/admin/skills", "/admin/skills/new"];
  it.each(pages)("GET %s -> 200", async (path) => {
    const agent = await loginAdmin();
    const r = await agent.get(path);
    expect(r.statusCode).toBe(200);
  });

  it("GET /admin/skills/:id/edit -> 200 (compétence existante)", async () => {
    const { rows } = await pool.query("SELECT id FROM skills LIMIT 1");
    if (!rows.length) return; // pas de compétence -> on saute
    const agent = await loginAdmin();
    const r = await agent.get(`/admin/skills/${rows[0].id}/edit`);
    expect(r.statusCode).toBe(200);
  });
});

afterAll(async () => {
  await pool.query("DELETE FROM utilisateurs WHERE pseudo = $1", [TEST_ADMIN.pseudo]);
  await pool.end();
});
