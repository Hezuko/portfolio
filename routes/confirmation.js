var express = require('express');
var router = express.Router();

router.get('/', function(req, res) {
    res.render('confirmation', { title: 'Confirmation' });
});

module.exports = router;
