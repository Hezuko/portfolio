var express = require('express');
var router = express.Router();

router.get('/', function(req, res) {
    if(!req.session.messageSent)
    {
        return res.redirect('/contact');
    }

    req.session.messageSent = false;
    
    res.render('confirmation', { title: 'Confirmation' });
});

module.exports = router;
