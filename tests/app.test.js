const request = require("supertest");
const cheerio = require("cheerio");
const he = require("he");
const app = require("../app");

describe("🔍 Tests de l'application", () => {
    let agent;

    beforeEach(() => {
        agent = request.agent(app); // Crée un agent pour stocker la session
    });

    // ✅ Test connexion utilisateur authentifié
    it("🔐 Devrait permettre l'accès à l'accueil après authentification", async () => {
        const getLoginPage = await agent.get("/authentification");
        expect(getLoginPage.statusCode).toBe(200);

        const $ = cheerio.load(getLoginPage.text);
        const csrfToken = $('input[name="_csrf"]').val();
        expect(csrfToken).toBeDefined();

        const rawCookies = getLoginPage.headers["set-cookie"];
        expect(rawCookies).toBeDefined();
        const cookies = rawCookies.map(cookie => cookie.split(";")[0]).join("; ");

        const loginResponse = await agent
            .post("/authentification")
            .set("Cookie", cookies)  
            .set("X-CSRF-Token", csrfToken)
            .send({ pseudo: "admin", password: "0000", _csrf: csrfToken });

        expect(loginResponse.statusCode).toBe(302); // 🔄 Redirection après login

        const homeResponse = await agent.get("/");
        expect(homeResponse.statusCode).toBe(200); // ✅ Accès autorisé
    });

    // ✅ Test accès en tant que visiteur
    it("🛠️ Devrait permettre l'accès en tant que visiteur", async () => {
        const visitorResponse = await agent.get("/authentification/visiteur");
        expect(visitorResponse.statusCode).toBe(302);

        const homeResponse = await agent.get("/");
        expect(homeResponse.statusCode).toBe(200);
    });

    // ❌ Test échec d'authentification avec mot de passe incorrect
    it("🔴 Devrait refuser l'authentification avec un mauvais mot de passe", async () => {
        const getLoginPage = await agent.get("/authentification");
        const $ = cheerio.load(getLoginPage.text);
        const csrfToken = $('input[name="_csrf"]').val();
        expect(csrfToken).toBeDefined();

        const rawCookies = getLoginPage.headers["set-cookie"];
        expect(rawCookies).toBeDefined();
        const cookies = rawCookies.map(cookie => cookie.split(";")[0]).join("; ");

        const loginResponse = await agent
            .post("/authentification")
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({ pseudo: "admin", password: "wrongpassword", _csrf: csrfToken });

        expect(loginResponse.statusCode).toBe(200); // ❌ Pas de redirection
        const decodedText = he.decode(loginResponse.text);
        expect(decodedText).toContain("Identifiant ou code d'accès incorrect");
    });

    // ❌ Test accès refusé à une page sans être connecté
    it("🔒 Devrait refuser l'accès aux pages protégées sans connexion", async () => {
        const response = await agent.get("/projets");
        expect(response.statusCode).toBe(302); // 🔄 Redirigé vers /authentification
        expect(response.headers.location).toBe("/authentification");
    });

    // ✅ Test de navigation avec utilisateur authentifié
    it("🔐 Devrait permettre la navigation entre les onglets projets, etudtes, jobs et contact", async () => {
        const getLoginPage = await agent.get("/authentification");
        expect(getLoginPage.statusCode).toBe(200);

        const $ = cheerio.load(getLoginPage.text);
        const csrfToken = $('input[name="_csrf"]').val();
        expect(csrfToken).toBeDefined();

        const rawCookies = getLoginPage.headers["set-cookie"];
        expect(rawCookies).toBeDefined();
        const cookies = rawCookies.map(cookie => cookie.split(";")[0]).join("; ");

        const loginResponse = await agent
            .post("/authentification")
            .set("Cookie", cookies)  
            .set("X-CSRF-Token", csrfToken)
            .send({ pseudo: "admin", password: "0000", _csrf: csrfToken });

        expect(loginResponse.statusCode).toBe(302); // 🔄 Redirection après login

        const homeResponse = await agent.get("/");
        expect(homeResponse.statusCode).toBe(200); // ✅ Accès autorisé

        const projetResponse = await agent.get("/projets");
        expect(projetResponse.statusCode).toBe(200); // ✅ Accès autorisé

        const etudeResponse = await agent.get("/etudes");
        expect(etudeResponse.statusCode).toBe(200); // ✅ Accès autorisé

        const jobResponse = await agent.get("/jobs");
        expect(jobResponse.statusCode).toBe(200); // ✅ Accès autorisé

        const contactResponse = await agent.get("/contact");
        expect(contactResponse.statusCode).toBe(200); // ✅ Accès autorisé

    });
});


describe("📝 Tests du formulaire de contact", () => {
    let agent;
    let csrfToken;
    let cookies;

    beforeEach(async () => {
        agent = request.agent(app); // Crée un agent pour stocker la session

        // 🔹 1. Récupérer la page d'authentification
        const getLoginPage = await agent.get("/authentification");
        expect(getLoginPage.statusCode).toBe(200);

        // 🔹 2. Extraire le CSRF token
        const $ = cheerio.load(getLoginPage.text);
        csrfToken = $('input[name="_csrf"]').val();
        expect(csrfToken).toBeDefined();

        // 🔹 3. Extraire les cookies
        const rawCookies = getLoginPage.headers["set-cookie"];
        expect(rawCookies).toBeDefined();
        cookies = rawCookies.map(cookie => cookie.split(";")[0]).join("; ");

        // 🔹 4. Simuler une connexion
        const loginResponse = await agent
            .post("/authentification")
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({ pseudo: "admin", password: "0000", _csrf: csrfToken });

        expect(loginResponse.statusCode).toBe(302);

        // 🔹 5. Accéder au formulaire de contact après connexion
        const getContactPage = await agent.get("/contact").set("Cookie", cookies);
        expect(getContactPage.statusCode).toBe(200);

        // 🔹 6. Extraire le CSRF token de la page contact
        const $$ = cheerio.load(getContactPage.text);
        csrfToken = $$('input[name="_csrf"]').val();
        expect(csrfToken).toBeDefined();
    });

    it("✅ Devrait soumettre le formulaire avec succès", async () => {
        const response = await agent
            .post("/contact")
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({
                nom: "Doe",
                prenom: "John",
                objet: "Demande d'information",
                email: "johndoe@example.com",
                texte: "Bonjour, je voudrais en savoir plus sur votre projet.",
                _csrf: csrfToken
            });

        expect(response.statusCode).toBe(302); // ✅ Redirection vers /confirmation
        expect(response.headers.location).toBe("/confirmation"); 
    });

    it("❌ Devrait refuser un email invalide", async () => {
        const response = await agent
            .post("/contact")
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({
                nom: "Doe",
                prenom: "John",
                objet: "Demande d'information",
                email: "email-invalide",
                texte: "Bonjour, je voudrais en savoir plus.",
                _csrf: csrfToken
            });

        expect(response.statusCode).toBe(400); 
        expect(response.text).toContain("Adresse email invalide."); 
    });

    it("❌ Devrait refuser une soumission avec des champs vides", async () => {
        const response = await agent
            .post("/contact")
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({
                nom: "",
                prenom: "",
                objet: "",
                email: "",
                texte: "",
                _csrf: csrfToken
            });

        expect(response.statusCode).toBe(400);
    });

    it("❌ Devrait refuser un message trop long", async () => {
        const longMessage = "A".repeat(501); // Un message de 501 caractères (limite : 500)

        const response = await agent
            .post("/contact")
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({
                nom: "Doe",
                prenom: "John",
                objet: "Problème technique",
                email: "johndoe@example.com",
                texte: longMessage,
                _csrf: csrfToken
            });

        expect(response.statusCode).toBe(400);
        expect(response.text).toContain("Le texte ne doit pas dépasser 500 caractères.");
    });

    it("❌ Devrait refuser une soumission sans CSRF token", async () => {
        const response = await agent
            .post("/contact")
            .set("Cookie", cookies) // ✅ On garde les cookies mais pas le token CSRF
            .send({
                nom: "Doe",
                prenom: "John",
                objet: "Problème technique",
                email: "johndoe@example.com",
                texte: "Je veux un support technique."
            });

        expect(response.statusCode).toBe(403); // 🔴 CSRF Token manquant
        expect(response.text).toContain("Invalid CSRF token.");
    });
});
