DROP TABLE IF EXISTS session;
DROP TABLE IF EXISTS contacts;
DROP TABLE IF EXISTS media_assets;
DROP TABLE IF EXISTS education_projects;
DROP TABLE IF EXISTS education_skills;
DROP TABLE IF EXISTS education_technologies;
DROP TABLE IF EXISTS projects;
DROP TABLE IF EXISTS educations;
DROP TABLE IF EXISTS jobs;
DROP TABLE IF EXISTS technologies;
DROP TABLE IF EXISTS skills;
DROP TABLE IF EXISTS site_settings;
DROP TABLE IF EXISTS schools;
DROP TABLE IF EXISTS companies;
DROP TABLE IF EXISTS utilisateurs;

CREATE TABLE utilisateurs (
    id SERIAL PRIMARY KEY,
    pseudo VARCHAR(100) NOT NULL UNIQUE,
    mot_de_passe VARCHAR(255) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'admin'
);

CREATE TABLE schools (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    logo TEXT,
    city VARCHAR(120),
    country VARCHAR(120),
    website TEXT,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE companies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    logo TEXT,
    city VARCHAR(120),
    country VARCHAR(120),
    website TEXT,
    description TEXT,
    industry VARCHAR(180),
    size VARCHAR(80),
    type VARCHAR(60) DEFAULT 'company',
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE jobs (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    company_id INTEGER REFERENCES companies(id) ON DELETE SET NULL,
    contract_type VARCHAR(80),
    location VARCHAR(180),
    remote_type VARCHAR(40),
    start_date DATE,
    end_date DATE,
    status VARCHAR(40) DEFAULT 'done',
    description TEXT,
    missions TEXT[] DEFAULT '{}',
    technologies TEXT[] DEFAULT '{}',
    project_ids INTEGER[] DEFAULT '{}',
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE educations (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    school_id INTEGER REFERENCES schools(id) ON DELETE SET NULL,
    degree VARCHAR(255),
    field VARCHAR(255),
    description TEXT,
    start_date DATE,
    end_date DATE,
    status VARCHAR(40) DEFAULT 'done',
    display_order INTEGER,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) NOT NULL UNIQUE,
    main_image TEXT,
    images TEXT[] DEFAULT '{}',
    short_description TEXT,
    long_description TEXT,
    goal TEXT,
    features TEXT[] DEFAULT '{}',
    technologies TEXT[] DEFAULT '{}',
    github_url TEXT,
    demo_url TEXT,
    start_date DATE,
    end_date DATE,
    status VARCHAR(40) DEFAULT 'in_progress',
    category VARCHAR(80),
    school_id INTEGER REFERENCES schools(id) ON DELETE SET NULL,
    company_id INTEGER REFERENCES companies(id) ON DELETE SET NULL,
    job_id INTEGER REFERENCES jobs(id) ON DELETE SET NULL,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE skills (
    id SERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    category VARCHAR(120) NOT NULL,
    description TEXT,
    icon VARCHAR(120),
    level VARCHAR(40),
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE technologies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE,
    category VARCHAR(120),
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE education_technologies (
    education_id INTEGER NOT NULL REFERENCES educations(id) ON DELETE CASCADE,
    technology_id INTEGER NOT NULL REFERENCES technologies(id) ON DELETE CASCADE,
    PRIMARY KEY (education_id, technology_id)
);

CREATE TABLE education_skills (
    education_id INTEGER NOT NULL REFERENCES educations(id) ON DELETE CASCADE,
    skill_id INTEGER NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
    PRIMARY KEY (education_id, skill_id)
);

CREATE TABLE education_projects (
    education_id INTEGER NOT NULL REFERENCES educations(id) ON DELETE CASCADE,
    project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    PRIMARY KEY (education_id, project_id)
);

CREATE TABLE site_settings (
    id SERIAL PRIMARY KEY,
    setting_key VARCHAR(120) NOT NULL UNIQUE,
    setting_value TEXT,
    description TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE contacts (
    id SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    objet VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL,
    texte TEXT NOT NULL,
    date_submitted TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE media_assets (
    id SERIAL PRIMARY KEY,
    provider VARCHAR(40) NOT NULL DEFAULT 'cloudinary',
    public_id TEXT NOT NULL UNIQUE,
    resource_type VARCHAR(20) NOT NULL CHECK (resource_type IN ('image', 'video')),
    delivery_type VARCHAR(40) NOT NULL DEFAULT 'authenticated',
    format VARCHAR(40),
    version BIGINT,
    display_name TEXT,
    original_filename TEXT,
    bytes INTEGER,
    width INTEGER,
    height INTEGER,
    entity_type VARCHAR(60) NOT NULL DEFAULT 'general',
    alt_text TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now()
);

-- Mot de passe hache avec bcrypt (jamais en clair). Le mot de passe reel est
-- defini hors du depot ; remplacez ce hash par le votre via model/utilisateur.hashMotDePasse().
INSERT INTO utilisateurs (pseudo, mot_de_passe, role)
VALUES ('admin', '$2b$10$wxVX4Dp4T0jnK6Ab5eZhU.t58r/7bDlbil.smkEtfz92hOzJfe5WO', 'admin');

INSERT INTO schools (name, slug, logo, city, country, website, description)
VALUES
('UTC', 'utc', 'https://res.cloudinary.com/portfolio-hezuko/image/upload/v1740308748/nothing-here.webp', 'Compiegne', 'France', 'https://www.utc.fr', 'Etablissement d enseignement superieur oriente ingenierie, informatique et projets techniques.');

INSERT INTO companies (name, logo, city, country, website, description, industry, size, type)
VALUES
('Portfolio Studio', 'https://res.cloudinary.com/portfolio-hezuko/image/upload/v1740308748/nothing-here.webp', 'Paris', 'France', NULL, 'Contexte de démonstration pour structurer les expériences professionnelles.', 'Software', '1-10', 'company');

INSERT INTO educations (title, school_id, degree, field, description, start_date, end_date, status, display_order)
VALUES
('Parcours informatique', 1, 'Diplome d ingenieur', 'Developpement logiciel', 'Formation centree sur la conception, le developpement et la livraison de projets applicatifs.', '2024-09-01', NULL, 'in_progress', 1);

INSERT INTO jobs (title, company_id, contract_type, location, remote_type, start_date, end_date, status, description, missions, technologies)
VALUES
('Développeur web', 1, 'personal', 'Paris', 'hybrid', '2025-01-01', NULL, 'in_progress', 'Création et amélioration d’applications web orientées données.', ARRAY['Backend Express','Interface admin','Modélisation PostgreSQL'], ARRAY['Express','EJS','PostgreSQL']);

INSERT INTO projects (name, slug, main_image, short_description, long_description, goal, features, technologies, github_url, demo_url, start_date, end_date, status, category, school_id, company_id, job_id)
VALUES
('Portfolio administrable', 'portfolio-administrable', 'https://res.cloudinary.com/portfolio-hezuko/image/upload/v1740309644/hero_1_djkmjs.jpg', 'Refonte d’un portfolio avec vision visiteur et espace admin.', 'Application Express/EJS connectée à PostgreSQL pour gérer projets, formations, expériences, écoles et entreprises.', 'Créer un portfolio maintenable sans modifier le code à chaque ajout de contenu.', ARRAY['Vision visiteur','Dashboard admin','CRUD complet','Relations entre données'], ARRAY['Node.js','Express','EJS','PostgreSQL'], 'https://github.com/Hezuko/portfolio', NULL, '2025-02-01', NULL, 'in_progress', 'web', 1, 1, 1);

INSERT INTO skills (name, category, icon, level)
VALUES
('JavaScript', 'Frontend', 'js', 'avance'),
('Node.js', 'Backend', 'node', 'avance'),
('Express', 'Backend', 'express', 'avance'),
('PostgreSQL', 'Base de donnees', 'database', 'intermediaire'),
('Docker', 'DevOps', 'docker', 'intermediaire'),
('Git', 'Outils', 'git', 'avance'),
('Conception', 'Formation', NULL, NULL),
('Travail en equipe', 'Formation', NULL, NULL),
('Analyse', 'Formation', NULL, NULL);

INSERT INTO technologies (name, category)
VALUES
('Node.js', 'Langage'),
('PostgreSQL', 'Base de donnees'),
('JavaScript', 'Langage'),
('C', 'Langage'),
('C++', 'Langage'),
('Python', 'Langage'),
('Electronique', 'Matiere'),
('Microcontroleurs', 'Electronique'),
('FPGA', 'Electronique'),
('VHDL', 'Langage'),
('Automatisme', 'Matiere'),
('Mathematiques', 'Matiere'),
('Physique', 'Matiere'),
('Systemes embarques', 'Systeme'),
('Linux embarque', 'Systeme'),
('CAN', 'Protocole'),
('UART', 'Protocole'),
('SPI', 'Protocole'),
('I2C', 'Protocole');

INSERT INTO education_technologies (education_id, technology_id)
SELECT 1, id FROM technologies WHERE name IN ('Node.js', 'PostgreSQL', 'JavaScript');

INSERT INTO education_skills (education_id, skill_id)
SELECT 1, id FROM skills WHERE name IN ('Conception', 'Travail en equipe', 'Analyse');

INSERT INTO education_projects (education_id, project_id)
SELECT 1, id FROM projects WHERE slug = 'portfolio-administrable';

INSERT INTO site_settings (setting_key, setting_value, description)
VALUES
('profile_name', 'Henoc Mukumbi', 'Nom affiche dans la navigation, l accueil et le footer'),
('profile_title', 'Developpeur web et ingenieur logiciel', 'Titre principal affiche sur le portfolio'),
('profile_tagline', 'Je construis des applications claires, utiles et maintenables, avec un interet fort pour le backend, les systemes et les produits bien finis.', 'Phrase d accroche de la page d accueil'),
('profile_about', '', 'Texte de presentation plus complet affiche sur la page d accueil'),
('profile_photo', '', 'Media prive utilise comme photo de profil sur la page d accueil'),
('contact_email', 'h.mukumbi100@gmail.com', 'Email public de contact'),
('github_url', 'https://github.com/Hezuko', 'Lien vers le profil GitHub public'),
('linkedin_url', 'https://www.linkedin.com/in/henocmukumbi', 'Lien vers le profil LinkedIn public'),
('cv_url', '', 'Lien vers le CV PDF'),
('legal_site_name', 'Portfolio Henoc Mukumbi', 'Nom du site affiche dans les mentions legales'),
('legal_publisher_name', 'Henoc Mukumbi', 'Editeur du site'),
('legal_publisher_status', 'Particulier - a adapter si le site est rattache a une activite professionnelle', 'Statut legal de l editeur'),
('legal_publication_director', 'Henoc Mukumbi', 'Directeur de la publication'),
('legal_hosting_provider', 'Hebergeur a completer avant mise en production', 'Nom de l hebergeur utilise en production'),
('legal_hosting_address', 'Adresse de l hebergeur a completer', 'Adresse officielle de l hebergeur'),
('legal_hosting_website', '', 'Site web officiel de l hebergeur'),
('legal_data_controller', 'Henoc Mukumbi', 'Responsable du traitement des donnees personnelles'),
('legal_retention_contact', 'Les messages de contact sont conserves le temps necessaire au traitement de la demande, puis supprimes ou archives selon leur utilite.', 'Duree de conservation des messages de contact'),
('legal_last_updated', '12 mai 2026', 'Date de derniere mise a jour des pages legales');
