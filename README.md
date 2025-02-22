# 🎨 Portfolio

Bienvenue sur mon projet **Portfolio** ! Ce site web permet d'afficher mes **diplômes**, **certifications** et **expériences professionnelles** de manière organisée et élégante. 🚀

---

## 📌 **Table des matières**
- [🌜 Description](#-description)
- [🛠️ Installation](#️-installation)
- [📾 Architecture du projet](#-architecture-du-projet)
- [🔧 Technologies utilisées](#-technologies-utilisées)
- [🚀 Lancer le projet](#-lancer-le-projet)
- [📩 Contact](#-contact)

---

## 🌜 **Description**
Vous pourrez découvrir :
- 📚 **Mon parcours scolaire** (diplômes, certifications)
- 💼 **Mes expériences professionnelles**
- 🏭️ **Les projets sur lesquels j’ai travaillé**
- 📩 **Une page de contact**

Le site est conçu avec **Node.js**, **Express.js** et utilise **PostgreSQL** comme base de données.

---

## 🛠️ **Installation**
```sh
# 1️⃣ Cloner le projet
git clone https://github.com/Hezuko/portfolio.git
cd portfolio

# 2️⃣ Installer les dépendances
npm install

# 3️⃣ Configurer la base de données
# Le projet utilise PostgreSQL pour stocker les données.
# Créer une base de données "portfolio" et ajouter les tables.
psql -U postgres -h localhost -c "CREATE DATABASE portfolio;"

# Importer les données depuis `backup.sql`
psql -U postgres -d portfolio -f backup.sql
```

---

## 📾 **Architecture du projet**

Le projet suit le modèle **MVC (Modèle - Vue - Contrôleur)** pour une meilleure organisation et maintenabilité du code.

### 🛠️ Modèle (model/)
- Gère la connexion à la base de données et les interactions avec les tables PostgreSQL.
- Exemple : `db.js` contient les fonctions pour exécuter des requêtes SQL.

### 🚦 Contrôleur (routes/)
- Gère la logique métier et les interactions entre la base de données et les vues.
- Exemple : `etudes.js` récupère les diplômes et les envoie à la vue.

### 🎨 Vue (views/)
- Contient les fichiers **EJS** pour afficher les données dynamiquement sur le site.
- Exemple : `index.ejs` affiche les informations du portfolio.

---

## 🔧 **Technologies utilisées**

- **Node.js** - Environnement JavaScript côté serveur
- **Express.js** - Framework web minimaliste
- **EJS** - Moteur de template pour générer du HTML dynamique
- **PostgreSQL** - Base de données relationnelle
- **Multer** - Middleware pour gérer l'upload de fichiers
- **Bootstrap** - Framework CSS pour le design
- **Morgan** - Logger HTTP pour voir les requêtes
- **Serve-favicon** - Gestion du favicon
- **Cookie-parser** - Gestion des cookies
- **Express-ejs-layouts** - Gestion des layouts dans Express

---

## 🚀 **Lancer le projet**
```sh
npm start
# Le serveur démarre sur http://localhost:3000
```

---

## 📩 **Contact**
Si vous avez des questions ou suggestions, contactez-moi via mon portfolio ! 😊

- 💎 **Email** : h.mukumbi100@gmail.com
- 🌐 **Site Web** : en cours d'implémentation

