const cloudinary = require("../config/cloudinary");

async function testCloudinary() {
    try {
        const result = await cloudinary.api.ping();
        console.log("✅ Cloudinary connecté avec succès !");
        console.log(result);
    } catch (error) {
        console.error("❌ Erreur de connexion à Cloudinary :", error);
    }
}

testCloudinary();
