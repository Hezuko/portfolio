const { getUtilisateur } = require("../model/utilisateur"); // Importer la fonction

async function testGetUtilisateur() {
    try {
        const pseudo = "admin"; // Remplace par un pseudo existant dans ta base de données
        const utilisateur = await getUtilisateur(pseudo);

        if (utilisateur) {
            console.log("✅ Utilisateur trouvé :", utilisateur);
        } else {
            console.log("⚠️ Aucun utilisateur trouvé avec ce pseudo.");
        }
    } catch (error) {
        console.error("❌ Erreur lors du test de récupération de l'utilisateur :", error);
    }
}

// Exécuter le test
testGetUtilisateur();
