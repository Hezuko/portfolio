var express = require('express');
var router = express.Router();

// Route GET pour afficher la page de confirmation
router.get('/', function(req, res, next) {
    res.render('confirmation'); // Assurez-vous que 'confirmation' correspond bien au nom du fichier EJS dans le dossier views
});

module.exports = router;
