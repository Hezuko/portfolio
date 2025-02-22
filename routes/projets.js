var express = require('express');
var router = express.Router();
var projet = require('../model/projet');


router.get('/', async function(req, res, next) {

    try {
        var projets = await projet.getProjets();

        res.render('projets', { 
            projets: projets,
            title : 'Mes Projets'
        });
    } catch(err) {
        next(err);
    }
});

module.exports = router;
