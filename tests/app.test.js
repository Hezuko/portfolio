const request = require("supertest");
const cheerio = require("cheerio");
const he = require("he");
const app = require("../app");
const { raw } = require("express");

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


describe("📝 Tests CRUD des Projets", () => {
    let agent;
    let csrfToken;
    let cookies;
    let projetId; // Stocke l'ID du projet ajouté pour les tests suivants

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
    });

    /**
     * ✅ Test d'ajout de projet
     */
    it("✅ Devrait ajouter un projet avec succès", async () => {
        const response = await agent
            .post("/projets/ajouter")
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({
                titre: "Test Projet",
                description: "Description du projet test",
                adresse: "Adresse fictive",
                date_debut: "2025-01-01",
                date_fin: "2025-12-31",
                etat: "En cours",
                iconpath: "https://example.com/image.jpg",
                _csrf: csrfToken
            });

        expect(response.statusCode).toBe(302); // ✅ Redirection après ajout

        // Récupérer la liste des projets pour obtenir l'ID du projet ajouté
        const projetsResponse = await agent.get("/projets").set("Cookie", cookies);
        expect(projetsResponse.statusCode).toBe(200);

        const $$ = cheerio.load(projetsResponse.text);
        projetId = $$("button[data-id]").attr("data-id"); // Récupérer l'ID du projet ajouté
        expect(projetId).toBeDefined();
    });

    /**
     * ✅ Test de modification de projet
     */
    it("✅ Devrait modifier un projet avec succès", async () => {
        expect(projetId).toBeDefined(); // Vérifie que l'ID du projet existe

        const response = await agent
            .post("/projets/modifier")
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({
                id: projetId,
                titre: "Projet Modifié",
                description: "Nouvelle description",
                adresse: "Nouvelle adresse",
                date_debut: "2025-02-01",
                date_fin: "2025-11-30",
                etat: "Terminé",
                iconpath: "https://example.com/new-image.jpg",
                _csrf: csrfToken
            });

        expect(response.statusCode).toBe(302); // ✅ Redirection après modification

        // Vérifier que le projet a bien été modifié
        const projetsResponse = await agent.get("/projets").set("Cookie", cookies);
        expect(projetsResponse.statusCode).toBe(200);
        const $$ = cheerio.load(projetsResponse.text);
        expect($$("h1.section-h1").text()).toContain("Projet Modifié");
    });

    /**
     * ✅ Test de suppression de projet
     */
    it("✅ Devrait supprimer un projet avec succès", async () => {
        // 🔹 1. Récupérer la liste des projets
        const projetsResponse = await agent.get("/projets").set("Cookie", cookies);
        const $ = cheerio.load(projetsResponse.text);
    
        // 🔹 2. Extraire l'ID du premier projet existant
        const projetId = $("button[data-id]").first().attr("data-id");
    
        expect(projetId).toBeDefined(); // Vérifie que l'ID est bien récupéré
    
        // 🔹 3. Envoyer la requête de suppression
        const response = await agent
            .post(`/projets/supprimer/${projetId}`) // 👉 Ajout de l'ID dans l'URL
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({ _csrf: csrfToken }); // ❌ Plus besoin d'envoyer l'ID dans le body

    
        expect(response.statusCode).toBe(302); // ✅ Vérifie la redirection après suppression
    
        // 🔹 4. Vérifier que le projet n'existe plus
        const projetsResponseAfter = await agent.get("/projets").set("Cookie", cookies);
        const $$ = cheerio.load(projetsResponseAfter.text);
    
        // 🔹 5. Vérifier que l'ID supprimé n'apparaît plus
        const projetExisteEncore = $$(`button[data-id="${projetId}"]`).length > 0;
        expect(projetExisteEncore).toBe(false);
    });
    

    /**
     * ❌ Test suppression d'un projet avec un ID invalide
     */
    it("❌ Devrait refuser de supprimer un projet avec un ID invalide", async () => {
        const response = await agent
                .post(`/projets/supprimer/999`) // 👉 Ajout de l'ID dans l'URL
                .set("Cookie", cookies)
                .set("X-CSRF-Token", csrfToken)
                .send({ _csrf: csrfToken }); // ❌ Plus besoin d'envoyer l'ID dans le body

        expect(response.statusCode).toBe(400); // 🔴 Erreur attendue
    });

    /**
     * ❌ Test modification d'un projet inexistant
     */
    it("❌ Devrait refuser de modifier un projet inexistant", async () => {
        const response = await agent
            .post("/projets/modifier")
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({
                id: "99999",
                titre: "Projet Fictif",
                description: "Nouvelle description",
                adresse: "Nouvelle adresse",
                date_debut: "2025-02-01",
                date_fin: "2025-11-30",
                etat: "Terminé",
                iconpath: "https://example.com/new-image.jpg",
                _csrf: csrfToken
            });

        expect(response.statusCode).toBe(400); // 🔴 Erreur attendue
    });

    /**
     * ❌ Test d'ajout avec un champ manquant
     */
    it("❌ Devrait refuser l'ajout d'un projet sans titre", async () => {
        const response = await agent
            .post("/projets/ajouter")
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({
                description: "Description du projet test",
                adresse: "Adresse fictive",
                date_debut: "2025-01-01",
                date_fin: "2025-12-31",
                etat: "En cours",
                iconpath: "https://example.com/image.jpg",
                _csrf: csrfToken
            });

        expect(response.statusCode).toBe(400);
        expect(response.text).toContain("Veuillez remplir tous les champs obligatoires.");
    });

});


//// Test CRUD des jobs ////


describe("📝 Tests CRUD des jobs", () => {
    let agent;
    let csrfToken;
    let cookies;
    let jobId; // Stocke l'ID du job ajouté pour les tests suivants

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
    });

    /**
     * ✅ Test d'ajout de job
     */
    it("✅ Devrait ajouter un job avec succès", async () => {
        const response = await agent
            .post("/jobs/ajouter")
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({
                titre: "Test job",
                description: "Description du job test",
                employeur:"Le jo de mes rêves",
                adresse: "Adresse fictive",
                date_debut: "2025-01-01",
                date_fin: "2025-12-31",
                document: "https://example.com/image.jpg",
                partenaire: "Léo",
                iconpath: "https://example.com/image.jpg",
                _csrf: csrfToken
            });

        expect(response.statusCode).toBe(302); // ✅ Redirection après ajout

        // Récupérer la liste des jobs pour obtenir l'ID du job ajouté
        const jobsResponse = await agent.get("/jobs").set("Cookie", cookies);
        expect(jobsResponse.statusCode).toBe(200);

        const $$ = cheerio.load(jobsResponse.text);
        jobId = $$("button[data-id]").attr("data-id"); // Récupérer l'ID du job ajouté
        expect(jobId).toBeDefined();
    });

    /**
     * ✅ Test de modification de job
     */
    it("✅ Devrait modifier un job avec succès", async () => {
        expect(jobId).toBeDefined(); // Vérifie que l'ID du job existe

        const response = await agent
            .post("/jobs/modifier")
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({
                id: jobId,
                titre: "job Modifié",
                description: "Nouvelle description",
                employeur: "Le cauchemar",
                adresse: "Nouvelle adresse",
                date_debut: "2025-02-01",
                date_fin: "2025-11-30",
                document: "Terminé",
                partenaire:"Amina",
                iconpath: "https://example.com/new-image.jpg",
                _csrf: csrfToken
            });

        expect(response.statusCode).toBe(302); // ✅ Redirection après modification

        // Vérifier que le job a bien été modifié
        const jobsResponse = await agent.get("/jobs").set("Cookie", cookies);
        expect(jobsResponse.statusCode).toBe(200);
        const $$ = cheerio.load(jobsResponse.text);
        expect($$("h1.section-h1").text()).toContain("job Modifié");
    });

    /**
     * ✅ Test de suppression de job
     */
    it("✅ Devrait supprimer un job avec succès", async () => {
        // 🔹 1. Récupérer la liste des jobs
        const jobsResponse = await agent.get("/jobs").set("Cookie", cookies);
        const $ = cheerio.load(jobsResponse.text);
    
        // 🔹 2. Extraire l'ID du premier job existant
        const jobId = $("button[data-id]").first().attr("data-id");
    
        expect(jobId).toBeDefined(); // Vérifie que l'ID est bien récupéré
    
        // 🔹 3. Envoyer la requête de suppression
        const response = await agent
            .post(`/jobs/supprimer/${jobId}`) // 👉 Ajout de l'ID dans l'URL
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({ _csrf: csrfToken }); // ❌ Plus besoin d'envoyer l'ID dans le body

    
        expect(response.statusCode).toBe(302); // ✅ Vérifie la redirection après suppression
    
        // 🔹 4. Vérifier que le job n'existe plus
        const jobsResponseAfter = await agent.get("/jobs").set("Cookie", cookies);
        const $$ = cheerio.load(jobsResponseAfter.text);
    
        // 🔹 5. Vérifier que l'ID supprimé n'apparaît plus
        const jobExisteEncore = $$(`button[data-id="${jobId}"]`).length > 0;
        expect(jobExisteEncore).toBe(false);
    });
    

    /**
     * ❌ Test suppression d'un job avec un ID invalide
     */
    it("❌ Devrait refuser de supprimer un job avec un ID invalide", async () => {
        const response = await agent
                .post(`/jobs/supprimer/999`) // 👉 Ajout de l'ID dans l'URL
                .set("Cookie", cookies)
                .set("X-CSRF-Token", csrfToken)
                .send({ _csrf: csrfToken }); // ❌ Plus besoin d'envoyer l'ID dans le body

        expect(response.statusCode).toBe(400); // 🔴 Erreur attendue
    });

    /**
     * ❌ Test modification d'un job inexistant
     */
    it("❌ Devrait refuser de modifier un job inexistant", async () => {
        const response = await agent
            .post("/jobs/modifier")
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({
                id: "99999",
                titre: "job Fictif",
                description: "Nouvelle description",
                adresse: "Nouvelle adresse",
                date_debut: "2025-02-01",
                date_fin: "2025-11-30",
                etat: "Terminé",
                iconpath: "https://example.com/new-image.jpg",
                _csrf: csrfToken
            });

        expect(response.statusCode).toBe(400); // 🔴 Erreur attendue
    });

    /**
     * ❌ Test d'ajout avec un champ manquant
     */
    it("❌ Devrait refuser l'ajout d'un job sans titre", async () => {
        const response = await agent
            .post("/jobs/ajouter")
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({
                description: "Description du job test",
                employeur:"Le jo de mes rêves",
                adresse: "Adresse fictive",
                date_debut: "2025-01-01",
                date_fin: "2025-12-31",
                document: "https://example.com/image.jpg",
                partenaire: "Léo",
                iconpath: "https://example.com/image.jpg",
                _csrf: csrfToken
            });

        expect(response.statusCode).toBe(400);
        expect(response.text).toContain("Veuillez remplir tous les champs obligatoires.");
    });

});
describe("📝 Tests CRUD des Études", () => {
    let agent;
    let csrfToken;
    let cookies;
    let etudeId;

    beforeEach(async () => {
        agent = request.agent(app);

        const getLoginPage = await agent.get("/authentification");
        expect(getLoginPage.statusCode).toBe(200);

        const $ = cheerio.load(getLoginPage.text);
        csrfToken = $('input[name="_csrf"]').val();
        expect(csrfToken).toBeDefined();

        const rawCookies = getLoginPage.headers["set-cookie"];
        expect(rawCookies).toBeDefined();
        cookies = rawCookies.map(cookie => cookie.split(";")[0]).join("; ");

        const loginResponse = await agent
            .post("/authentification")
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({ pseudo: "admin", password: "0000", _csrf: csrfToken });

        expect(loginResponse.statusCode).toBe(302);
    });

    /**
     * ✅ Test d'ajout d'une étude
     */
    it("✅ Devrait ajouter une étude avec succès", async () => {
        const response = await agent
            .post("/etudes/ajouter")
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({
                titre: "Université de Technologie de Compiègne",
                description: "Formation en ingénierie informatique",
                adresse: "Compiègne, France",
                date_debut: "2025-01-01",
                date_fin: "2025-12-12",
                document: "https://example.com/document.pdf",
                etat: "En cours",
                iconpath: "https://example.com/image.jpg",
                buildingpath: "https://example.com/building.jpg",
                _csrf: csrfToken
            });

        expect(response.statusCode).toBe(302); // ✅ Redirection après ajout

        // Récupérer la liste des études pour obtenir l'ID de l'étude ajoutée
        const etudeResponse = await agent.get("/etudes").set("Cookie", cookies);
        expect(etudeResponse.statusCode).toBe(200);

        const $$ = cheerio.load(etudeResponse.text);
        etudeId = $$("button[data-id]").attr("data-id"); // Récupérer l'ID de l'étude ajoutée
        expect(etudeId).toBeDefined();
    });

    /**
     * ✅ Test de modification d'une étude
     */
    it("✅ Devrait modifier une étude avec succès", async () => {
        expect(etudeId).toBeDefined(); // Vérifie que l'ID de l'étude existe

        const response = await agent
            .post("/etudes/modifier")
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({
                id: etudeId,
                titre: "Université de Technologie de Compiègne - Modifié",
                description: "Formation avancée en ingénierie informatique",
                adresse: "Compiègne, France",
                date_debut: "2025-02-01",
                date_fin: "2025-11-30",
                document: "https://example.com/new-document.pdf",
                etat: "Terminé",
                iconpath: "https://example.com/new-image.jpg",
                buildingpath: "https://example.com/new-building.jpg",
                _csrf: csrfToken
            });

        expect(response.statusCode).toBe(302); // ✅ Redirection après modification

        // Vérifier que l'étude a bien été modifiée
        const etudesResponse = await agent.get("/etudes").set("Cookie", cookies);
        expect(etudesResponse.statusCode).toBe(200);
        const $$ = cheerio.load(etudesResponse.text);
        expect($$("h1.section-h1").text()).toContain("Université de Technologie de Compiègne - Modifié");
    });

    /**
     * ✅ Test de suppression d'une étude
     */
    it("✅ Devrait supprimer une étude avec succès", async () => {
        expect(etudeId).toBeDefined(); // Vérifie que l'ID de l'étude existe

        const response = await agent
            .post(`/etudes/supprimer/${etudeId}`) // 👉 Ajout de l'ID dans l'URL
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({ _csrf: csrfToken });

        expect(response.statusCode).toBe(302); // ✅ Vérifie la redirection après suppression

        // Vérifier que l'étude n'existe plus
        const etudesResponseAfter = await agent.get("/etudes").set("Cookie", cookies);
        const $$ = cheerio.load(etudesResponseAfter.text);

        // Vérifier que l'ID supprimé n'apparaît plus
        const etudeExisteEncore = $$(`button[data-id="${etudeId}"]`).length > 0;
        expect(etudeExisteEncore).toBe(false);
    });

    /**
     * ❌ Test suppression d'une étude avec un ID invalide
     */
    it("❌ Devrait refuser de supprimer une étude avec un ID invalide", async () => {
        const response = await agent
            .post(`/etudes/supprimer/99999`) // 👉 Ajout de l'ID invalide dans l'URL
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({ _csrf: csrfToken });

        expect(response.statusCode).toBe(400); // 🔴 Erreur attendue
    });

    /**
     * ❌ Test modification d'une étude inexistante
     */
    it("❌ Devrait refuser de modifier une étude inexistante", async () => {
        const response = await agent
            .post("/etudes/modifier")
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({
                id: "99999",
                titre: "Étude Fictive",
                description: "Description fictive",
                adresse: "Lieu fictif",
                date_debut: "2025-02-01",
                date_fin: "2025-11-30",
                document: "https://example.com/fake-document.pdf",
                etat: "Planifié",
                iconpath: "https://example.com/fake-image.jpg",
                buildingpath: "https://example.com/fake-building.jpg",
                _csrf: csrfToken
            });

        expect(response.statusCode).toBe(400); // 🔴 Erreur attendue
    });

    /**
     * ❌ Test d'ajout avec un champ manquant
     */
    it("❌ Devrait refuser l'ajout d'une étude sans titre", async () => {
        const response = await agent
            .post("/etudes/ajouter")
            .set("Cookie", cookies)
            .set("X-CSRF-Token", csrfToken)
            .send({
                description: "Description de l'étude",
                adresse: "Adresse de l'étude",
                date_debut: "2025-01-01",
                date_fin: "2025-12-31",
                document: "https://example.com/document.pdf",
                etat: "En cours",
                iconpath: "https://example.com/image.jpg",
                buildingpath: "https://example.com/building.jpg",
                _csrf: csrfToken
            });

        expect(response.statusCode).toBe(400);
        expect(response.text).toContain("Veuillez remplir tous les champs obligatoires.");
    });
});
