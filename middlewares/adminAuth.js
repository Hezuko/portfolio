function requireAdmin(req, res, next) {
  if (!req.session?.user || req.session.user.role !== "admin") {
    return res.redirect("/authentification");
  }
  next();
}

module.exports = { requireAdmin };
