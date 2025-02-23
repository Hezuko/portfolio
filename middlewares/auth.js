// Middleware pour empêcher l'accès à /authentification si déjà connecté
function preventAuthAccess(req, res, next) {
    if (req.session && req.session.userid) {
        return res.redirect("/"); 
    }
    next();
}

module.exports = { preventAuthAccess };
