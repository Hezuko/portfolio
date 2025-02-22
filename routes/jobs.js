var express = require('express');
var router = express.Router();
var job = require('../model/job');


router.get('/', async function(req, res, next) {

    try {
        var jobs = await job.getJobs();

        res.render('jobs', { 
            jobs: jobs,
            title : 'Mes Jobs'
        });
    } catch(err) {
        next(err);
    }
  
});

module.exports = router;
