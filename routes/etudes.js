var express = require('express');
var router = express.Router();
var etude = require('../model/etude');


router.get('/', async function(req, res, next) {

    try {
        var etudes = await etude.getEtudes();

        res.render('etudes', { 
            etudes: etudes,
            title :'Mes Etudes'
        });

    } catch(err) {
        next(err);
    }
});

module.exports = router;
