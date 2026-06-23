CREATE TABLE IF NOT EXISTS course_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(180) NOT NULL UNIQUE,
    description TEXT,
    display_order INTEGER,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS courses (
    id SERIAL PRIMARY KEY,
    code VARCHAR(40) NOT NULL UNIQUE,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    skills_summary TEXT,
    category_id INTEGER REFERENCES course_categories(id) ON DELETE SET NULL,
    display_order INTEGER,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS education_courses (
    education_id INTEGER NOT NULL REFERENCES educations(id) ON DELETE CASCADE,
    course_id INTEGER NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    PRIMARY KEY (education_id, course_id)
);

INSERT INTO course_categories (name, description, display_order) VALUES
('Bases scientifiques', 'Consolidation des bases mathématiques et statistiques nécessaires à la modélisation, à l’analyse et à la résolution de problèmes d’ingénierie.', 1),
('Informatique, logiciel et systèmes embarqués', 'Formation solide en informatique fondamentale, développement logiciel, architecture des systèmes, bases de données, réseaux, systèmes d’exploitation et systèmes embarqués temps réel.', 2),
('Robotique, capteurs et automatique', 'Cours orientés robotique, perception, capteurs, contrôle, automatique avancée et systèmes intelligents.', 3),
('Données, optimisation et technologies avancées', 'Approfondissement en optimisation, simulation, recherche d’information, technologies avancées et informatique quantique.', 4),
('Entreprise, société et communication', 'Ouverture aux dimensions sociales, juridiques, éthiques, organisationnelles et sociétales du métier d’ingénieur.', 5),
('Anglais et communication internationale', 'Progression en anglais académique, scientifique et professionnel, avec travail sur l’oral, l’écrit et l’interaction.', 6),
('Apprentissage en entreprise', 'Validation des périodes en entreprise, montée en autonomie, analyse des situations professionnelles et construction du métier cible.', 7)
ON CONFLICT (name) DO UPDATE SET
    description = EXCLUDED.description,
    display_order = EXCLUDED.display_order,
    updated_at = now();

WITH category AS (SELECT id FROM course_categories WHERE name = 'Bases scientifiques')
INSERT INTO courses (code, title, description, skills_summary, category_id, display_order) VALUES
('AC01', 'Révision d’analyse et d’algèbre', 'Consolidation des bases scientifiques pour la modélisation mathématique et la résolution numérique : systèmes linéaires, calcul matriciel, fonctions à plusieurs variables, intégrales, équations différentielles.', 'Analyse mathématique, algèbre linéaire, modélisation, calcul numérique.', (SELECT id FROM category), 1),
('AC04', 'Méthodes statistiques pour l’ingénieur', 'Statistiques appliquées avec raisonnement statistique, tests d’hypothèses, régression linéaire, estimation ponctuelle et intervalles de confiance.', 'Statistiques, régression linéaire, tests statistiques, analyse de données.', (SELECT id FROM category), 2)
ON CONFLICT (code) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    skills_summary = EXCLUDED.skills_summary,
    category_id = EXCLUDED.category_id,
    display_order = EXCLUDED.display_order,
    updated_at = now();

WITH category AS (SELECT id FROM course_categories WHERE name = 'Informatique, logiciel et systèmes embarqués')
INSERT INTO courses (code, title, description, skills_summary, category_id, display_order) VALUES
('AI01', 'Algorithmique et structure de données', 'Structures de données de base et algorithmes associés : complexité, structures linéaires, arbres, tris, graphes, tables de hachage.', 'Algorithmique, complexité, structures de données, graphes, tables de hachage.', (SELECT id FROM category), 1),
('AI02', 'Intelligence artificielle : représentation des connaissances', 'Introduction aux concepts de base de l’intelligence artificielle, représentation des connaissances, raisonnement, programmation symbolique et fonctionnelle, réseaux sémantiques, ontologies et logiques de description.', 'IA symbolique, représentation des connaissances, raisonnement, ontologies.', (SELECT id FROM category), 2),
('AI03', 'Méthodes de vérification et validation de logiciels', 'Vérification et validation logicielle, tests fonctionnels et structurels, tests statiques, dynamiques et unitaires.', 'Test logiciel, validation, vérification, qualité logicielle.', (SELECT id FROM category), 3),
('AI05', 'Architecture des réseaux', 'Étude des réseaux informatiques, architectures, protocoles, Internet TCP/IP, réseaux locaux, réseaux sans fil et interconnexion.', 'Réseaux, TCP/IP, architecture réseau, protocoles, LAN, Wi-Fi.', (SELECT id FROM category), 4),
('AI16', 'Conception et développement web', 'Technologies et langages web pour concevoir et développer des applications client/serveur sécurisées et éco-responsables : HTTP, DOM, JavaScript, Ajax, programmation serveur, PHP.', 'Développement web, client/serveur, JavaScript, HTTP, sécurité web, éco-conception.', (SELECT id FROM category), 5),
('AI22', 'Programmation et conception orientées objets', 'Concepts et outils de programmation orientée objet : C++, classes, encapsulation, héritage, design patterns, Qt, UML.', 'POO, C++, UML, design patterns, Qt, conception logicielle.', (SELECT id FROM category), 6),
('AI23', 'Conception de bases de données relationnelles et non relationnelles', 'Conception de bases relationnelles, modèle conceptuel, création et interrogation de bases, transactions, SGBD, bases non relationnelles.', 'SQL, modélisation de données, SGBD, bases relationnelles, NoSQL, transactions.', (SELECT id FROM category), 7),
('AI26', 'Systèmes d’exploitation des concepts à la programmation', 'Architecture des systèmes d’exploitation : processus, interruptions, appels système, multitâche, synchronisation, mémoire virtuelle, multithreading, ordonnancement, interblocage, sécurité et API UNIX.', 'Systèmes d’exploitation, UNIX, processus, threads, mémoire virtuelle, concurrence, C système.', (SELECT id FROM category), 8),
('AI39', 'Systèmes informatiques temps réel et développement embarqué', 'Mise en œuvre de systèmes embarqués avec contraintes temporelles : développement barebones, noyaux temps réel, ordonnancement, synchronisation, systèmes d’exploitation embarqués et multitâche temps réel.', 'Systèmes embarqués, temps réel, C, RTOS, ordonnancement, synchronisation.', (SELECT id FROM category), 9)
ON CONFLICT (code) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    skills_summary = EXCLUDED.skills_summary,
    category_id = EXCLUDED.category_id,
    display_order = EXCLUDED.display_order,
    updated_at = now();

WITH category AS (SELECT id FROM course_categories WHERE name = 'Robotique, capteurs et automatique')
INSERT INTO courses (code, title, description, skills_summary, category_id, display_order) VALUES
('AI06', 'Capteurs pour les systèmes intelligents', 'Principes de mesure et capteurs : ultrasons, caméras, télémètres, accéléromètres, LiDAR, IMU et encodeurs. Mise en pratique avec une plateforme robotique TurtleBot, ROS et Python.', 'Capteurs, robotique, ROS, Python, LiDAR, IMU, vision, systèmes intelligents.', (SELECT id FROM category), 1),
('AI40', 'Automatique pour la robotique', 'Automatique avancée pour robots mobiles, drones, véhicules intelligents et humanoïdes. Contrôle temps réel, observateurs, autonomie décisionnelle, planification, commande optimale, filtre de Kalman et modélisation robotique.', 'Automatique, robotique, drones, commande optimale, observateurs, filtre de Kalman, contrôle non linéaire.', (SELECT id FROM category), 2)
ON CONFLICT (code) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    skills_summary = EXCLUDED.skills_summary,
    category_id = EXCLUDED.category_id,
    display_order = EXCLUDED.display_order,
    updated_at = now();

WITH category AS (SELECT id FROM course_categories WHERE name = 'Données, optimisation et technologies avancées')
INSERT INTO courses (code, title, description, skills_summary, category_id, display_order) VALUES
('AI09', 'Méthodes et outils pour l’optimisation et la simulation', 'Modélisation mathématique et résolution de problèmes d’optimisation combinatoire, programmation linéaire, programmation par contraintes, simulation, heuristiques et solveurs spécialisés.', 'Optimisation combinatoire, simulation, programmation linéaire, heuristiques, solveurs.', (SELECT id FROM category), 1),
('AI29', 'Informatique quantique', 'Concepts de l’informatique quantique : qubits, registres, intrication, portes quantiques, algorithmes de recherche, transformée de Fourier quantique, factorisation et cryptographie.', 'Informatique quantique, qubits, algorithmes quantiques, cryptographie.', (SELECT id FROM category), 2),
('AI31', 'Indexation et recherche d’information', 'Gestion de bases documentaires, indexation de documents, découverte d’index à partir du contenu, traitement automatique des langues et text-mining.', 'Recherche d’information, indexation, NLP/TAL, text-mining, bases documentaires.', (SELECT id FROM category), 3)
ON CONFLICT (code) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    skills_summary = EXCLUDED.skills_summary,
    category_id = EXCLUDED.category_id,
    display_order = EXCLUDED.display_order,
    updated_at = now();

WITH category AS (SELECT id FROM course_categories WHERE name = 'Apprentissage en entreprise')
INSERT INTO courses (code, title, description, skills_summary, category_id, display_order) VALUES
('AE01', 'Période d’apprentissage en entreprise — année 1', 'Validation des périodes passées en entreprise pendant la première année de branche.', 'Expérience professionnelle, intégration en entreprise, application des compétences techniques.', (SELECT id FROM category), 1),
('AE02', 'Période d’apprentissage en entreprise — année 2', 'Validation des périodes passées en entreprise pendant la deuxième année de branche. L’UV met en avant l’autonomie, le métier cible, les compétences et l’analyse des situations professionnelles.', 'Autonomie, analyse de situations professionnelles, compétences métier, montée en responsabilité.', (SELECT id FROM category), 2)
ON CONFLICT (code) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    skills_summary = EXCLUDED.skills_summary,
    category_id = EXCLUDED.category_id,
    display_order = EXCLUDED.display_order,
    updated_at = now();

WITH category AS (SELECT id FROM course_categories WHERE name = 'Anglais et communication internationale')
INSERT INTO courses (code, title, description, skills_summary, category_id, display_order) VALUES
('LH12', 'Anglais niveau II', 'Niveau B1. Compréhension, expression et interaction en anglais à partir d’articles, documents audio/vidéo, entretiens, débats et exposés.', 'Anglais B1, compréhension orale et écrite, expression orale, communication professionnelle.', (SELECT id FROM category), 1),
('LH13', 'Anglais niveau III', 'Niveau B2 nécessaire à la délivrance du diplôme d’ingénieur. Travail sur compréhension, expression et interaction en anglais avec supports presse, audio, vidéo, débats et exposés.', 'Anglais B2, anglais courant et professionnel, rédaction, exposés, débats.', (SELECT id FROM category), 2),
('LH14', 'Anglais niveau IV', 'Présentation claire et détaillée de sujets scientifiques, développement d’arguments et conclusion structurée d’une intervention.', 'Anglais scientifique, anglais technique, présentation orale, communication technique.', (SELECT id FROM category), 3),
('LH16', 'Anglais professionnel', 'Anglais formel et informel, CV, profil professionnel en ligne, lettre de motivation, négociation, diversité culturelle et générationnelle en entreprise et prise de parole.', 'Anglais professionnel, CV anglais, négociation, communication interculturelle, prise de parole.', (SELECT id FROM category), 4)
ON CONFLICT (code) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    skills_summary = EXCLUDED.skills_summary,
    category_id = EXCLUDED.category_id,
    display_order = EXCLUDED.display_order,
    updated_at = now();

WITH category AS (SELECT id FROM course_categories WHERE name = 'Entreprise, société et communication')
INSERT INTO courses (code, title, description, skills_summary, category_id, display_order) VALUES
('SH02', 'Épistémologie et philosophie', 'Outils conceptuels pour comprendre la dynamique des connaissances scientifiques, les relations entre connaissance, information, organisation, cognition, technologie, ainsi que les débats sur travail, technique, valeurs et éthique professionnelle.', 'Éthique de l’ingénieur, philosophie des sciences, recul critique, technologie et société.', (SELECT id FROM category), 1),
('SH10', 'Sociologie du monde de l’entreprise : organisations, travail, capitalismes', 'Fondamentaux de la sociologie du monde économique : fonctionnement réel des organisations, structuration des marchés, rapport au travail, sociologie des organisations, du travail et économique.', 'Sociologie des organisations, compréhension de l’entreprise, travail, marchés, rôle de l’ingénieur.', (SELECT id FROM category), 2),
('SH40', 'Les risques entre technique et société', 'Étude des risques climatiques, météorologiques, technologiques et politiques ; analyse de la production et diffusion des connaissances sur les risques ; cartographie, analyse spatiale, webmapping, datavisualisation et SIG.', 'Gestion des risques, risques technologiques, SIG, cartographie, analyse spatiale, datavisualisation.', (SELECT id FROM category), 3),
('SH42', 'La pluralité du droit dans l’activité de l’ingénieur', 'Notions juridiques utiles à l’ingénieur : système judiciaire français, droit des contrats, responsabilité, droit du travail, propriété intellectuelle et industrielle, brevets.', 'Droit de l’ingénieur, contrats, responsabilité, droit du travail, propriété intellectuelle, brevets.', (SELECT id FROM category), 4)
ON CONFLICT (code) DO UPDATE SET
    title = EXCLUDED.title,
    description = EXCLUDED.description,
    skills_summary = EXCLUDED.skills_summary,
    category_id = EXCLUDED.category_id,
    display_order = EXCLUDED.display_order,
    updated_at = now();

WITH utc_educations AS (
    SELECT e.id
    FROM educations e
    LEFT JOIN schools s ON s.id = e.school_id
    WHERE lower(COALESCE(s.name, '')) LIKE '%utc%'
       OR lower(COALESCE(s.name, '')) LIKE '%technologie de compi%'
       OR lower(COALESCE(e.title, '')) LIKE '%utc%'
       OR lower(COALESCE(e.title, '')) LIKE '%technologie de compi%'
),
utc_courses AS (
    SELECT id FROM courses
    WHERE code IN (
        'AC01','AC04','AI01','AI02','AI03','AI05','AI16','AI22','AI23','AI26','AI39',
        'AI06','AI40','AI09','AI29','AI31','AE01','AE02','LH12','LH13','LH14','LH16',
        'SH02','SH10','SH40','SH42'
    )
)
INSERT INTO education_courses (education_id, course_id)
SELECT utc_educations.id, utc_courses.id
FROM utc_educations
CROSS JOIN utc_courses
ON CONFLICT DO NOTHING;
