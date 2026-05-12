# Portfolio

Application web de portfolio en Node.js, Express, EJS et PostgreSQL, avec une vision publique Visiteur et une vision Admin protegee.

## Ce que contient le projet

- Une interface publique accessible sans connexion.
- Une page d'accueil moderne avec profil, projets, parcours et competences.
- Des pages publiques pour projets, etudes, experiences, competences et contact.
- Une interface Admin separee sur `/admin`.
- Des CRUD Admin pour projets, etudes, jobs, ecoles, entreprises et competences.
- Un modele PostgreSQL normalise et restaurable depuis `backup.sql`.
- Des tests Jest/Supertest pour la vision visiteur, la protection admin et un CRUD admin.

## Stack

- Node.js / Express
- EJS avec `express-ejs-layouts`
- PostgreSQL avec `pg` et sessions stockées via `connect-pg-simple`
- Bootstrap 5 et Sass
- Jest, Supertest et Cheerio pour les tests

## Installation

```sh
npm install
cp .env.example .env
```

Renseigner ensuite `.env`.

Variables principales :

```env
DB_URL=postgres://postgres:postgres@localhost:5432/portfolio
DB_SSL=false
SESSION_SECRET=change-moi-en-local
CLOUDINARY_URL=cloudinary://api_key:api_secret@cloud_name
MAIL_USER=
MAIL_PASS=
MAIL_TO=
```

## Medias prives Cloudinary

Les images et videos gerees depuis l'admin sont uploadees avec le delivery type Cloudinary `authenticated`.
Elles ne doivent donc pas etre accessibles via une URL Cloudinary publique non signee.

Configuration a faire :

1. Creer un compte Cloudinary.
2. Recuperer l'API Environment variable dans le dashboard Cloudinary.
3. La mettre dans `.env` :

```env
CLOUDINARY_URL=cloudinary://api_key:api_secret@cloud_name
```

Ensuite :

- aller sur `/admin/media` ;
- uploader les images/videos ;
- retourner dans Projets, Ecoles, Entreprises ou Parametres ;
- selectionner le media dans le champ Logo, Image principale, Galerie ou `profile_photo`.

Pour changer la photo de profil de l'accueil :

1. Uploader l'image dans `/admin/media` avec l'utilisation `Profil`.
2. Aller dans `/admin/settings`.
3. Modifier le parametre `profile_photo`.
4. Selectionner l'image uploadee, puis enregistrer.

Important : un media affiche dans le navigateur utilise une URL signee. Cette URL peut etre copiee pendant qu'elle est valide. Le gain principal est qu'aucun asset n'est publie en URL Cloudinary non signee et devinable.

Pour une base PostgreSQL locale :

```sh
createdb portfolio
psql -h localhost -p 5433 -U henocmkb -d portfolio -f backup.sql
```

Si tu utilises une base distante qui impose SSL, retire `DB_SSL=false` ou mets `DB_SSL=true`.

## Lancer le projet

En production locale simple :

```sh
npm start
```

En développement avec rechargement automatique :

```sh
npm run dev
```

Le serveur écoute par défaut sur :

```text
http://localhost:3000
```

Identifiants Admin locaux :

```text
pseudo: admin
mot de passe: 0000
```

L'interface Admin est disponible sur :

```text
http://localhost:3000/admin
```

Tu peux changer le port avec :

```sh
PORT=3001 npm start
```

## CSS

Le fichier source Sass est `public/stylesheets/custom.scss`.

Pour le compiler en continu :

```sh
npm run sass
```

## Tests

```sh
npm test
```

Les tests nécessitent une base PostgreSQL disponible avec les tables et données attendues, notamment l'utilisateur `admin` avec le mot de passe `0000`.
