const { techIconUrl, slugFor } = require("../utils/techIcons");
const media = require("../model/mediaRepository");
const utilisateur = require("../model/utilisateur");
const contact = require("../model/contact");
const pool = require("../model/db");

describe("utils/techIcons", () => {
  it("mappe une techno connue vers son SVG", () => {
    expect(techIconUrl("Python")).toBe("/images/tech/python.svg");
    expect(slugFor("Docker")).toBe("docker");
    expect(slugFor("C++")).toBe("cplusplus");
  });
  it("retourne null pour l'inconnu / vide", () => {
    expect(techIconUrl("Truc inexistant 42")).toBeNull();
    expect(slugFor("")).toBeNull();
    expect(slugFor(null)).toBeNull();
  });
});

describe("model/mediaRepository (fonctions pures)", () => {
  it("label() retombe sur display_name > filename > public_id", () => {
    expect(media.label({ display_name: "Logo" })).toBe("Logo");
    expect(media.label({ original_filename: "f.png" })).toBe("f.png");
    expect(media.label({ public_id: "p/id" })).toBe("p/id");
    expect(media.label({})).toBe("");
  });
  it("signedUrl() génère une URL authenticated signée avec optimisation", () => {
    const url = media.signedUrl({ public_id: "portfolio/test/x", resource_type: "image" });
    expect(url).toContain("/image/authenticated/");
    expect(url).toContain("portfolio/test/x");
    expect(url).toContain("f_auto");
  });
  it("signedUrl() retourne null sans public_id", () => {
    expect(media.signedUrl({})).toBeNull();
    expect(media.signedUrl(null)).toBeNull();
  });
  it("isConfigured() reflète la présence de CLOUDINARY_URL", () => {
    expect(typeof media.isConfigured()).toBe("boolean");
  });
});

describe("model/utilisateur - hash", () => {
  it("hashMotDePasse() produit un hash bcrypt différent du clair", async () => {
    const hash = await utilisateur.hashMotDePasse("Secret123!");
    expect(typeof hash).toBe("string");
    expect(hash).not.toBe("Secret123!");
    expect(hash).toMatch(/^\$2[aby]\$/); // signature bcrypt
  });
});

describe("model/contact - CRUD", () => {
  let createdId;
  afterAll(async () => {
    if (createdId) await contact.deleteContact(createdId).catch(() => {});
    await pool.end();
  });

  it("AddContact insère puis listContacts le retrouve, deleteContact le retire", async () => {
    await contact.AddContact("JestNom", "JestPrenom", "Test unitaire", "jest-unit@example.com", "Message de test unitaire.");
    const list = await contact.listContacts();
    const found = list.find((c) => c.email === "jest-unit@example.com");
    expect(found).toBeTruthy();
    createdId = found.id;

    await contact.deleteContact(createdId);
    const after = await contact.listContacts();
    expect(after.find((c) => c.id === createdId)).toBeUndefined();
    createdId = null;
  });
});
