require("dotenv").config();
var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var favicon = require('serve-favicon');
var expressLayouts = require('express-ejs-layouts');
var session = require("./config/session");



var homeRouter = require('./routes/home');
var etudesRouter = require('./routes/etudes');
var projetsRouter = require('./routes/projets');
var jobsRouter = require('./routes/jobs');
var contactRouter = require('./routes/contact');
var confirmationRouter = require('./routes/confirmation');
var authentificationRouter = require('./routes/authentification');

var app = express();

// Configuration du moteur de vue
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

// Activer les layouts
app.use(expressLayouts);
app.set('layout', 'layout');

// Middlewares
app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());

// Servir les fichiers statiques
app.use(express.static(path.join(__dirname, 'public')));

// Routes pour Bootstrap CSS & JS
app.use('/css', express.static(path.join(__dirname, 'node_modules/bootstrap/dist/css')));
app.use('/js', express.static(path.join(__dirname, 'node_modules/bootstrap/dist/js')));

// Initialiser la session
app.use(session.initSession());


app.use((req, res, next) => {
  console.log("🔍 Session actuelle :", req.session);
  res.locals.user = req.session.user || null;
  console.log("🔍 Utilisateur local :", res.locals.user);
  next();
});


// Middleware pour forcer l'authentification ou le mode visiteur
app.use((req, res, next) => {
  if (!req.session.userid && req.path !== "/authentification" && req.path !== "/authentification/visiteur") {
      return res.redirect("/authentification");
  }
  next();
});

app.use((req, res, next) => {
  if (!req.session.userid && req.path !== "/authentification" && req.path !== "/authentification/visiteur") {
      return res.redirect("/authentification");
  }
  next();
});


// Définition des routes
app.use('/', homeRouter);
app.use('/etudes', etudesRouter);
app.use('/projets', projetsRouter);
app.use('/jobs', jobsRouter);
app.use('/contact', contactRouter);
app.use('/confirmation', confirmationRouter);
app.use('/authentification',authentificationRouter);

// Catch 400 - Mauvaise requête
app.use((req, res, next) => {
  if (Object.keys(req.body).length === 0 && Object.keys(req.query).length === 0) {
    return res.status(400).render('errors/400', { title: "Erreur 400" });
  }
  next();
});

// Catch 403 - Accès interdit (si une authentification est nécessaire)
app.use((req, res, next) => {
  if (req.url.includes('/admin') && !req.user) {
    return res.status(403).render('errors/403', { title: "Erreur 403" });
  }
  next();
});

// Catch 404 - Page non trouvée
app.use((req, res, next) => {
  res.status(404).render('errors/404', { title: "Erreur 404" });
});

// Catch 500 - Erreur interne du serveur
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).render('errors/500', { title: "Erreur 500" });
});

// Gestion des autres erreurs
app.use(function(err, req, res, next) {
  res.locals.message = err.message;
  res.locals.error = req.app.get('env') === 'development' ? err : {};

  res.status(err.status || 500);
  res.render('error', { 
    message: err.message, 
    error: err,
    title: "Erreur"
  });
});

module.exports = app;
