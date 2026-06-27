const request = require("supertest");
const app = require("../app");
const pool = require("../model/db");

// Couverture des routes publiques (GET) : statut + contenu attendu.
// IDs/slugs réels présents en base de dev.

describe("pages publiques (GET 200)", () => {
  const pages = [
    ["/", "Henoc Mukumbi"],
    ["/projets", "Projets"],
    ["/etudes", "Études"],
    ["/jobs", "Expériences"],
    ["/competences", "Domaines techniques"],
    ["/a-propos", "Qui je suis"],
    ["/contact", "Contact"],
    ["/mentions-legales", "Mentions"],
    ["/confidentialite", "confidentialité"],
    ["/cookies", "Cookies"],
  ];

  it.each(pages)("GET %s -> 200", async (path, needle) => {
    const r = await request(app).get(path);
    expect(r.statusCode).toBe(200);
    expect(r.text.toLowerCase()).toContain(String(needle).toLowerCase());
  });
});

describe("pages de détail", () => {
  it("GET /projets/:slug -> 200 (projet existant)", async () => {
    const r = await request(app).get("/projets/joytrain");
    expect(r.statusCode).toBe(200);
    expect(r.text).toContain("JoyTrain");
  });

  it("GET /etudes/:id -> 200", async () => {
    const r = await request(app).get("/etudes/7");
    expect(r.statusCode).toBe(200);
    expect(r.text).toContain("EducationalOccupationalProgram");
  });

  it("GET /experiences/:id -> 200 + JSON-LD CreativeWork", async () => {
    const r = await request(app).get("/experiences/2");
    expect(r.statusCode).toBe(200);
    expect(r.text).toContain("CreativeWork");
  });

  it("GET /projets/slug-inexistant -> 404", async () => {
    const r = await request(app).get("/projets/ce-slug-n-existe-pas-xyz");
    expect(r.statusCode).toBe(404);
  });

  it("GET /etudes/999999 -> 404", async () => {
    const r = await request(app).get("/etudes/999999");
    expect(r.statusCode).toBe(404);
  });
});

describe("SEO : sitemap, robots, redirections", () => {
  it("GET /sitemap.xml -> 200 xml avec urls", async () => {
    const r = await request(app).get("/sitemap.xml");
    expect(r.statusCode).toBe(200);
    expect(r.headers["content-type"]).toMatch(/xml/);
    expect(r.text).toContain("<urlset");
    expect(r.text).toMatch(/<loc>.*\/projets\/joytrain<\/loc>/);
  });

  it("GET /robots.txt -> 200", async () => {
    const r = await request(app).get("/robots.txt");
    expect(r.statusCode).toBe(200);
    expect(r.text).toMatch(/Sitemap:/i);
  });

  it("GET /jobs/:id -> 301 vers /experiences/:id", async () => {
    const r = await request(app).get("/jobs/2");
    expect(r.statusCode).toBe(301);
    expect(r.headers.location).toBe("/experiences/2");
  });

  it("GET /projets/ (slash final) -> 301 sans slash", async () => {
    const r = await request(app).get("/projets/");
    expect(r.statusCode).toBe(301);
    expect(r.headers.location).toBe("/projets");
  });

  it("conserve la query-string lors de la redirection de slash", async () => {
    const r = await request(app).get("/projets/?category=web");
    expect(r.statusCode).toBe(301);
    expect(r.headers.location).toBe("/projets?category=web");
  });
});

describe("API JSON internes", () => {
  it("GET /api/knowledge/:name -> JSON (techno connue)", async () => {
    const r = await request(app).get("/api/knowledge/Python");
    expect([200, 404]).toContain(r.statusCode);
    expect(r.headers["content-type"]).toMatch(/json/);
  });

  it("GET /api/skills/:id introuvable -> 404 JSON", async () => {
    const r = await request(app).get("/api/skills/999999");
    expect(r.statusCode).toBe(404);
    expect(r.headers["content-type"]).toMatch(/json/);
  });

  it("GET /api/technologies/:id introuvable -> 404 JSON", async () => {
    const r = await request(app).get("/api/technologies/999999");
    expect(r.statusCode).toBe(404);
  });
});

describe("page 404 générique", () => {
  it("GET /route-inexistante -> 404 noindex", async () => {
    const r = await request(app).get("/page-qui-nexiste-pas");
    expect(r.statusCode).toBe(404);
    expect(r.text).toMatch(/noindex/);
  });
});

afterAll(async () => {
  await pool.end();
});
