const request = require("supertest");
const cheerio = require("cheerio");
const app = require("../app");
const pool = require("../model/db");
const utilisateur = require("../model/utilisateur");
const { shouldTrack, visitorHash, referrerHost } = require("../utils/analytics");

const TEST_ADMIN = { pseudo: "admin-test-jest-stats", password: "Jest-Stats-Passw0rd!" };

function fakeReq({ method = "GET", path = "/", ua = "Mozilla/5.0 (Macintosh)", referer, ip = "1.2.3.4" } = {}) {
  const headers = { "user-agent": ua, referer };
  return { method, path, ip, get: (h) => headers[h.toLowerCase()] };
}

describe("analytics — unités", () => {
  it("shouldTrack : suit les pages publiques, ignore admin/health/assets/bots/POST", () => {
    expect(shouldTrack(fakeReq({ path: "/projets" }))).toBe(true);
    expect(shouldTrack(fakeReq({ path: "/admin" }))).toBe(false);
    expect(shouldTrack(fakeReq({ path: "/health" }))).toBe(false);
    expect(shouldTrack(fakeReq({ path: "/stylesheets/custom.css" }))).toBe(false);
    expect(shouldTrack(fakeReq({ path: "/", ua: "Googlebot/2.1" }))).toBe(false);
    expect(shouldTrack(fakeReq({ path: "/", method: "POST" }))).toBe(false);
  });

  it("visitorHash : stable pour la même IP+UA, différent pour une autre IP, sans l'IP en clair", () => {
    const a1 = visitorHash(fakeReq({ ip: "9.9.9.9" }));
    const a2 = visitorHash(fakeReq({ ip: "9.9.9.9" }));
    const b = visitorHash(fakeReq({ ip: "8.8.8.8" }));
    expect(a1).toBe(a2);
    expect(a1).not.toBe(b);
    expect(a1).toHaveLength(16);
    expect(a1).not.toContain("9.9.9.9");
  });

  it("referrerHost : extrait l'hôte, ignore l'interne et le vide", () => {
    expect(referrerHost(fakeReq({ referer: "https://www.linkedin.com/feed/" }))).toBe("linkedin.com");
    expect(referrerHost(fakeReq({ referer: "https://henocmukumbi.com/projets" }))).toBe(null);
    expect(referrerHost(fakeReq({}))).toBe(null);
  });
});

describe("analytics — intégration", () => {
  beforeAll(async () => {
    const hash = await utilisateur.hashMotDePasse(TEST_ADMIN.password);
    await pool.query(
      `INSERT INTO utilisateurs (pseudo, mot_de_passe, role) VALUES ($1,$2,'admin')
       ON CONFLICT (pseudo) DO UPDATE SET mot_de_passe = EXCLUDED.mot_de_passe, role='admin'`,
      [TEST_ADMIN.pseudo, hash]
    );
  });

  afterAll(async () => {
    await pool.query("DELETE FROM utilisateurs WHERE pseudo = $1", [TEST_ADMIN.pseudo]);
    await pool.query("DELETE FROM page_views WHERE path = '/__test-analytics__' OR path = '/projets'");
  });

  it("une visite publique GET 200 crée une ligne page_views", async () => {
    await pool.query("DELETE FROM page_views WHERE path = '/projets'");
    await request(app).get("/projets").set("User-Agent", "Mozilla/5.0 (Jest)").set("Referer", "https://www.linkedin.com/feed/");
    // l'insert est asynchrone (res.on finish) — petite attente
    await new Promise((r) => setTimeout(r, 150));
    const { rows } = await pool.query("SELECT * FROM page_views WHERE path = '/projets' ORDER BY id DESC LIMIT 1");
    expect(rows).toHaveLength(1);
    expect(rows[0].referrer_host).toBe("linkedin.com");
    expect(rows[0].visitor_hash).toHaveLength(16);
  });

  it("GET /admin/stats affiche la page (connecté)", async () => {
    const agent = request.agent(app);
    const page = await agent.get("/authentification");
    const csrf = cheerio.load(page.text)('input[name="_csrf"]').val();
    await agent.post("/authentification").send({ pseudo: TEST_ADMIN.pseudo, password: TEST_ADMIN.password, _csrf: csrf });
    const r = await agent.get("/admin/stats");
    expect(r.statusCode).toBe(200);
    expect(r.text).toContain("Statistiques de visite");
    expect(r.text).toContain("Sources (30 j)");
  });

  it("GET /admin/stats sans connexion redirige", async () => {
    const r = await request(app).get("/admin/stats");
    expect(r.statusCode).toBe(302);
  });
});
