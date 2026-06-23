ALTER TABLE course_categories ADD COLUMN IF NOT EXISTS skills_summary TEXT;

INSERT INTO course_categories (name, description, skills_summary, display_order) VALUES
('Électronique et systèmes électroniques', 'Enseignements centrés sur l’analyse, la conception et la validation de circuits électroniques analogiques et numériques, avec une progression vers des systèmes plus rapides et plus complexes.', 'Électronique, analyse de circuits, composants électroniques, électronique analogique, électronique numérique, signaux électriques, mesures, instrumentation, schématique électronique, validation électronique.', 101),
('Automatisme, microcontrôleurs et informatique embarquée', 'Enseignements liés aux systèmes automatisés, à la commande, aux microcontrôleurs et à l’utilisation de Linux dans un contexte d’informatique embarquée.', 'Automatisme, microcontrôleurs, informatique embarquée, Linux, Linux embarqué, GPIO, entrées/sorties, timers, interruptions, ADC, PWM, programmation embarquée, C embarqué, commande de systèmes.', 102),
('Énergie électrique et physique appliquée', 'Enseignements portant sur les grandeurs physiques, l’énergie électrique, la conversion d’énergie et l’application des principes physiques aux systèmes électriques et électroniques.', 'Énergie électrique, physique appliquée, conversion d’énergie, mesures physiques, systèmes électriques, modélisation, expérimentation, analyse de résultats.', 103),
('Génie logiciel, informatique industrielle et réseaux', 'Enseignements orientés programmation, développement logiciel, informatique industrielle et réseaux utilisés dans les environnements techniques.', 'C, programmation, algorithmique, développement logiciel, génie logiciel, tests, informatique industrielle, réseaux industriels, supervision, protocoles, communication machine.', 104),
('Mathématiques et outils scientifiques', 'Enseignements destinés à consolider les outils mathématiques et logiciels nécessaires à l’analyse, la modélisation et la résolution de problèmes techniques.', 'Mathématiques appliquées, modélisation, calcul scientifique, simulation, analyse de données, résolution de problèmes, préparation aux écoles d’ingénieurs.', 105),
('Robotique, projets techniques et SAE', 'Mises en situation et projets techniques permettant d’appliquer les connaissances en électronique, automatisme, informatique, robotique et systèmes embarqués.', 'Robotique, projets techniques, SAE, intégration système, électronique, automatisme, C, programmation, capteurs, actionneurs, tests, validation, conception, travail en équipe, documentation technique.', 106),
('Communication, anglais et projet professionnel', 'Enseignements liés à la communication écrite et orale, à l’anglais technique, à la vie professionnelle et à la construction du projet personnel.', 'Communication, anglais technique, rédaction, présentation orale, projet professionnel, insertion, valorisation du parcours, autonomie.', 107),
('Stage, portfolio et professionnalisation', 'Éléments de professionnalisation visant à valoriser les compétences acquises, construire un portfolio technique et appliquer les savoirs dans un contexte professionnel.', 'Portfolio, valorisation professionnelle, documentation, expérience professionnelle, stage, autonomie, synthèse du parcours, application des compétences techniques.', 108)
ON CONFLICT (name) DO UPDATE SET
    description = EXCLUDED.description,
    skills_summary = EXCLUDED.skills_summary,
    display_order = EXCLUDED.display_order,
    updated_at = now();

WITH category AS (SELECT id FROM course_categories WHERE name = 'Électronique et systèmes électroniques')
INSERT INTO courses (code, title, description, skills_summary, category_id, display_order) VALUES
('EG1R109E', 'Électronique S1', 'Introduction aux bases de l’électronique, à l’analyse de circuits, aux composants électroniques et aux premiers montages analogiques ou numériques. Cette matière permet de comprendre le comportement des signaux et des composants utilisés dans les systèmes électriques et électroniques.', 'Électronique, analyse de circuits, composants électroniques, signaux électriques, mesures, schématique électronique.', (SELECT id FROM category), 1),
('EG1R208E', 'Électronique S2', 'Approfondissement des notions d’électronique vues au premier semestre, avec étude de circuits électroniques, mesures, validation expérimentale et compréhension du fonctionnement de systèmes électroniques plus complets.', 'Électronique analogique, électronique numérique, mesures électriques, validation de circuits, instrumentation, oscilloscope, multimètre.', (SELECT id FROM category), 2),
('EG1R308E', 'Électronique S3', 'Étude avancée des circuits électroniques dans un contexte de systèmes industriels et embarqués. Cette matière renforce la capacité à analyser, dimensionner, tester et valider des fonctions électroniques.', 'Conception électronique, analyse de circuits, tests électroniques, oscilloscope, validation fonctionnelle, schématique électronique.', (SELECT id FROM category), 3),
('EG1R310E', 'Électronique rapide S3', 'Étude de phénomènes liés aux signaux rapides, aux temps de commutation, aux contraintes de transmission, aux perturbations et aux comportements dynamiques des circuits électroniques.', 'Signaux rapides, intégrité du signal, commutation, électronique haute vitesse, mesures temporelles, oscilloscope.', (SELECT id FROM category), 4),
('EG1R410E', 'Électronique rapide S4', 'Approfondissement de l’électronique rapide et des contraintes associées aux circuits fonctionnant avec des temps de réponse courts. Cette matière permet de mieux comprendre les phénomènes de commutation, de propagation et de perturbation dans les systèmes électroniques.', 'Électronique rapide, signaux, mesures, perturbations, validation électronique, analyse de signaux.', (SELECT id FROM category), 5)
ON CONFLICT (code) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, skills_summary = EXCLUDED.skills_summary, category_id = EXCLUDED.category_id, display_order = EXCLUDED.display_order, updated_at = now();

WITH category AS (SELECT id FROM course_categories WHERE name = 'Automatisme, microcontrôleurs et informatique embarquée')
INSERT INTO courses (code, title, description, skills_summary, category_id, display_order) VALUES
('EG1R107E', 'Automatisme S1', 'Introduction aux systèmes automatisés, à la logique de commande, aux capteurs, actionneurs et séquences de fonctionnement utilisées dans les systèmes industriels.', 'Automatisme, logique de commande, capteurs, actionneurs, systèmes industriels, analyse fonctionnelle.', (SELECT id FROM category), 1),
('EG1R206E', 'Automatisme et microcontrôleurs S2', 'Étude des systèmes automatisés et des microcontrôleurs pour piloter des entrées/sorties, gérer des séquences, acquérir des informations et commander des systèmes électroniques ou industriels.', 'Automatisme, microcontrôleurs, GPIO, entrées/sorties, timers, interruptions, ADC, PWM, programmation embarquée, C embarqué, commande de systèmes.', (SELECT id FROM category), 2),
('EG1R306E', 'Automatique S3', 'Étude des systèmes dynamiques, de la modélisation et de la commande de systèmes physiques. Cette matière permet d’aborder les notions d’asservissement, de stabilité et de contrôle.', 'Automatique, asservissement, modélisation, stabilité, commande, systèmes dynamiques, analyse de systèmes.', (SELECT id FROM category), 3),
('EG1R307_LINUX_E', 'Linux et informatique embarquée S3', 'Introduction à l’utilisation de Linux dans un contexte technique et embarqué. Cette matière permet de manipuler un environnement système, des commandes, des outils de développement et des notions utiles à l’informatique embarquée.', 'Linux, Linux embarqué, informatique embarquée, système d’exploitation, ligne de commande, développement embarqué, programmation bas niveau.', (SELECT id FROM category), 4)
ON CONFLICT (code) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, skills_summary = EXCLUDED.skills_summary, category_id = EXCLUDED.category_id, display_order = EXCLUDED.display_order, updated_at = now();

WITH category AS (SELECT id FROM course_categories WHERE name = 'Énergie électrique et physique appliquée')
INSERT INTO courses (code, title, description, skills_summary, category_id, display_order) VALUES
('EG1R121E', 'Énergie et physique appliquée S1', 'Étude des grandeurs physiques et électriques nécessaires à la compréhension des systèmes énergétiques, électroniques et industriels.', 'Énergie, physique appliquée, électricité, grandeurs physiques, systèmes électriques, mesures physiques.', (SELECT id FROM category), 1),
('EG1R221E', 'Énergie et physique appliquée S2', 'Approfondissement des phénomènes physiques et énergétiques appliqués aux systèmes électriques et électroniques. Cette matière permet de relier les notions théoriques aux mesures et applications techniques.', 'Physique appliquée, énergie électrique, mesures, systèmes électriques, modélisation physique, expérimentation.', (SELECT id FROM category), 2),
('EG1SEP2E', 'SAE Énergie et Physique S2', 'Mise en situation pratique autour de problématiques liées à l’énergie et à la physique appliquée. L’objectif est d’utiliser les connaissances théoriques pour analyser, mesurer et valider un système réel.', 'Énergie, mesures physiques, expérimentation, analyse de résultats, validation, travail en équipe.', (SELECT id FROM category), 3)
ON CONFLICT (code) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, skills_summary = EXCLUDED.skills_summary, category_id = EXCLUDED.category_id, display_order = EXCLUDED.display_order, updated_at = now();

WITH category AS (SELECT id FROM course_categories WHERE name = 'Génie logiciel, informatique industrielle et réseaux')
INSERT INTO courses (code, title, description, skills_summary, category_id, display_order) VALUES
('EG1R108E', 'Génie logiciel S1', 'Introduction à la programmation, à la structuration du code, à la logique algorithmique et aux méthodes de développement logiciel appliquées à des problèmes techniques.', 'C, programmation, algorithmique, structuration du code, développement logiciel, logique informatique.', (SELECT id FROM category), 1),
('EG1R207E', 'Génie logiciel S2', 'Approfondissement du développement logiciel avec mise en œuvre de programmes plus structurés, de méthodes de conception et d’outils de développement.', 'C, développement logiciel, programmation, algorithmique, conception logicielle, tests, résolution de problèmes.', (SELECT id FROM category), 2),
('EG1SIN2E', 'SAE Informatique S2', 'Mise en pratique des compétences informatiques à travers un projet ou une situation d’apprentissage intégrant programmation, traitement de données ou développement d’outils logiciels.', 'C, programmation, projet informatique, développement logiciel, résolution de problèmes, tests, documentation.', (SELECT id FROM category), 3),
('EG1R307_RES_E', 'Réseaux de l’informatique industrielle S3', 'Étude des réseaux utilisés dans les environnements industriels pour permettre la communication entre équipements, systèmes embarqués, automates, capteurs et outils de supervision.', 'Réseaux industriels, communication machine, protocoles, supervision, systèmes distribués, bus de communication, protocoles industriels.', (SELECT id FROM category), 4)
ON CONFLICT (code) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, skills_summary = EXCLUDED.skills_summary, category_id = EXCLUDED.category_id, display_order = EXCLUDED.display_order, updated_at = now();

WITH category AS (SELECT id FROM course_categories WHERE name = 'Mathématiques et outils scientifiques')
INSERT INTO courses (code, title, description, skills_summary, category_id, display_order) VALUES
('EG1R104E', 'Mathématiques S1', 'Bases mathématiques nécessaires à l’analyse des systèmes électriques, électroniques et automatisés.', 'Mathématiques appliquées, calcul, modélisation, résolution de problèmes.', (SELECT id FROM category), 1),
('EGR204E', 'Mathématiques S2', 'Approfondissement des outils mathématiques utiles à l’analyse, la modélisation et la résolution de problèmes techniques en génie électrique et informatique industrielle.', 'Mathématiques appliquées, modélisation, analyse, calcul scientifique.', (SELECT id FROM category), 2),
('EG1R304E', 'Outil mathématique S3', 'Utilisation d’outils mathématiques pour analyser des systèmes, résoudre des problèmes techniques et accompagner la modélisation de phénomènes électriques, électroniques ou industriels.', 'Outils mathématiques, modélisation, calcul, analyse de systèmes.', (SELECT id FROM category), 3),
('EG1R404E', 'Outils mathématiques et logiciels S4', 'Utilisation combinée d’outils mathématiques et logiciels pour résoudre des problèmes techniques, simuler des systèmes et analyser des résultats.', 'Outils mathématiques, logiciels techniques, simulation, analyse de données, modélisation.', (SELECT id FROM category), 4),
('S3_OPT_MATHS', 'Option Mathématiques expertes / poursuite d’études', 'Cours complémentaire destiné à renforcer les bases mathématiques en vue d’une poursuite d’études, notamment en école d’ingénieurs.', 'Mathématiques avancées, raisonnement scientifique, préparation école d’ingénieurs, modélisation.', (SELECT id FROM category), 5)
ON CONFLICT (code) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, skills_summary = EXCLUDED.skills_summary, category_id = EXCLUDED.category_id, display_order = EXCLUDED.display_order, updated_at = now();

WITH category AS (SELECT id FROM course_categories WHERE name = 'Robotique, projets techniques et SAE')
INSERT INTO courses (code, title, description, skills_summary, category_id, display_order) VALUES
('EG1S107E', 'SAE Automatisme S1', 'Projet de mise en situation autour de l’automatisme, permettant d’appliquer les notions de logique de commande, de séquencement et d’analyse de systèmes automatisés.', 'Automatisme, logique de commande, projet technique, analyse fonctionnelle, validation, travail en équipe.', (SELECT id FROM category), 1),
('EG1S109E', 'SAE Électronique S1', 'Projet pratique d’électronique permettant d’appliquer les connaissances en circuits, composants et mesures.', 'Électronique, montage, mesures, validation, expérimentation, tests électroniques.', (SELECT id FROM category), 2),
('EG1SR01', 'SAE Robot S1', 'Projet robotique de première année permettant d’appliquer des notions d’électronique, d’automatisme, de programmation et de conception de système.', 'Robotique, électronique, automatisme, C, programmation, intégration système, capteurs, actionneurs.', (SELECT id FROM category), 3),
('EG1SR01EC', 'SAE Robot Concevoir S1', 'Mise en œuvre d’une démarche de conception autour d’un système robotique : analyse du besoin, choix techniques, conception et validation.', 'Conception, robotique, cahier des charges, choix techniques, projet en équipe, documentation technique.', (SELECT id FROM category), 4),
('EG1SR01EV', 'SAE Robot Vérifier S1', 'Vérification du fonctionnement d’un système robotique à travers des tests, mesures et validations fonctionnelles.', 'Tests, validation, robotique, mesures, diagnostic, validation fonctionnelle.', (SELECT id FROM category), 5),
('EG1SEL2E', 'SAE Électronique et robotique S2', 'Projet intégrant des notions d’électronique et de robotique, avec mise en œuvre de circuits, de capteurs, d’actionneurs ou de programmes de commande.', 'Électronique, robotique, capteurs, actionneurs, programmation, C, intégration, tests.', (SELECT id FROM category), 6),
('EG1SAE3E_ROB', 'SAE Robotique S3', 'Projet robotique avancé permettant de mobiliser les compétences en électronique, informatique embarquée, automatisme et intégration système.', 'Robotique, systèmes embarqués, électronique, automatisme, programmation, C embarqué, tests, intégration système.', (SELECT id FROM category), 7),
('EG1SAE4E_ROB', 'SAE Robotique S4', 'Projet robotique de semestre 4 visant à approfondir la conception, l’intégration, le test et la validation d’un système robotique.', 'Robotique, intégration système, validation, conception, projet technique, travail en équipe, documentation.', (SELECT id FROM category), 8),
('EG1SPT1E', 'Projets tutorés S1', 'Premiers projets techniques réalisés en équipe pour appliquer les connaissances vues en formation et développer une démarche de projet.', 'Projet technique, travail en équipe, organisation, documentation, présentation.', (SELECT id FROM category), 9),
('EG1SPT2E', 'Projets tutorés S2', 'Réalisation de projets techniques plus avancés permettant de mobiliser les compétences en électronique, informatique, automatisme ou énergie.', 'Gestion de projet, conception, réalisation, tests, documentation technique, travail en équipe.', (SELECT id FROM category), 10),
('EG1SPT3E', 'Projets tutorés S3', 'Projet technique de semestre 3 permettant d’approfondir la démarche d’ingénierie, l’analyse du besoin, la conception et la validation d’une solution.', 'Projet technique, conception, validation, autonomie, travail en équipe, documentation technique.', (SELECT id FROM category), 11)
ON CONFLICT (code) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, skills_summary = EXCLUDED.skills_summary, category_id = EXCLUDED.category_id, display_order = EXCLUDED.display_order, updated_at = now();

WITH category AS (SELECT id FROM course_categories WHERE name = 'Communication, anglais et projet professionnel')
INSERT INTO courses (code, title, description, skills_summary, category_id, display_order) VALUES
('EG1R101E', 'Anglais S1', 'Développement des compétences en compréhension et expression anglaise dans un contexte général et technique.', 'Anglais, compréhension écrite, expression orale, vocabulaire technique.', (SELECT id FROM category), 1),
('EG1R201E', 'Anglais S2', 'Approfondissement de l’anglais appliqué aux situations professionnelles et techniques.', 'Anglais technique, communication professionnelle, expression orale, rédaction.', (SELECT id FROM category), 2),
('EG1R301E', 'Anglais S3', 'Utilisation de l’anglais dans des contextes techniques, académiques et professionnels.', 'Anglais technique, communication, présentation orale, compréhension professionnelle.', (SELECT id FROM category), 3),
('EG1R401E', 'Anglais S4', 'Renforcement de l’anglais professionnel et technique, utile pour la poursuite d’études et l’intégration dans un environnement international.', 'Anglais professionnel, anglais technique, communication orale, rédaction.', (SELECT id FROM category), 4),
('EG1R102E', 'Culture et Communication S1', 'Développement de la communication écrite et orale, de la synthèse, de l’expression et de la capacité à présenter un travail technique.', 'Communication, rédaction, synthèse, présentation orale, argumentation.', (SELECT id FROM category), 5),
('EG1R202E', 'Culture et Communication S2', 'Approfondissement des compétences de communication dans un contexte universitaire et professionnel.', 'Communication professionnelle, rédaction, présentation, expression orale.', (SELECT id FROM category), 6),
('EG1R302E', 'Culture et Communication S3', 'Travail sur la communication technique, la rédaction professionnelle et la présentation de projets.', 'Communication technique, rédaction professionnelle, présentation de projet.', (SELECT id FROM category), 7),
('EG1R402E', 'Culture et Communication, Vie de l’entreprise, PPP S4', 'Préparation à l’environnement professionnel, à la compréhension de l’entreprise, à la communication professionnelle et à la valorisation du parcours.', 'Communication professionnelle, vie de l’entreprise, projet professionnel, insertion, valorisation des compétences.', (SELECT id FROM category), 8),
('EG1R105E', 'Projet Personnel et Professionnel S1', 'Construction progressive du projet professionnel, réflexion sur les compétences, les objectifs de poursuite d’études et les métiers visés.', 'Projet professionnel, orientation, autonomie, réflexion parcours, insertion.', (SELECT id FROM category), 9),
('EG1R205E', 'Projet Personnel et Professionnel S2', 'Approfondissement du projet professionnel et préparation à la poursuite d’études ou à l’insertion professionnelle.', 'Projet professionnel, poursuite d’études, autonomie, communication professionnelle.', (SELECT id FROM category), 10)
ON CONFLICT (code) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, skills_summary = EXCLUDED.skills_summary, category_id = EXCLUDED.category_id, display_order = EXCLUDED.display_order, updated_at = now();

WITH category AS (SELECT id FROM course_categories WHERE name = 'Stage, portfolio et professionnalisation')
INSERT INTO courses (code, title, description, skills_summary, category_id, display_order) VALUES
('EG1SPO1E', 'Portfolio S1', 'Mise en valeur des compétences acquises, des travaux réalisés et de la progression dans la formation.', 'Portfolio, valorisation des compétences, documentation, réflexion personnelle.', (SELECT id FROM category), 1),
('EG1SPO2E', 'Portfolio S2', 'Poursuite de la construction du portfolio de compétences et mise en avant des réalisations techniques.', 'Portfolio, compétences, documentation, présentation du parcours.', (SELECT id FROM category), 2),
('EG1SPO4E', 'Portfolio S4', 'Finalisation et valorisation des compétences développées pendant la formation, en lien avec les projets, le stage et la poursuite d’études.', 'Portfolio, valorisation professionnelle, compétences techniques, synthèse du parcours.', (SELECT id FROM category), 3),
('EG1STG4E_ESE', 'Stage S4', 'Expérience professionnelle permettant d’appliquer les compétences acquises en formation dans un environnement réel, technique ou industriel.', 'Expérience professionnelle, autonomie, application des compétences, travail en entreprise, rapport technique.', (SELECT id FROM category), 4)
ON CONFLICT (code) DO UPDATE SET title = EXCLUDED.title, description = EXCLUDED.description, skills_summary = EXCLUDED.skills_summary, category_id = EXCLUDED.category_id, display_order = EXCLUDED.display_order, updated_at = now();

WITH iut_educations AS (
    SELECT e.id
    FROM educations e
    LEFT JOIN schools s ON s.id = e.school_id
    WHERE lower(COALESCE(s.name, '')) LIKE '%iut de cachan%'
       OR lower(COALESCE(s.name, '')) LIKE '%paris-saclay%'
       OR lower(COALESCE(e.title, '')) LIKE '%génie électrique%'
       OR lower(COALESCE(e.title, '')) LIKE '%genie electrique%'
       OR lower(COALESCE(e.title, '')) LIKE '%geii%'
),
iut_courses AS (
    SELECT id FROM courses
    WHERE code IN (
        'EG1R109E','EG1R208E','EG1R308E','EG1R310E','EG1R410E',
        'EG1R107E','EG1R206E','EG1R306E','EG1R307_LINUX_E',
        'EG1R121E','EG1R221E','EG1SEP2E',
        'EG1R108E','EG1R207E','EG1SIN2E','EG1R307_RES_E',
        'EG1R104E','EGR204E','EG1R304E','EG1R404E','S3_OPT_MATHS',
        'EG1S107E','EG1S109E','EG1SR01','EG1SR01EC','EG1SR01EV','EG1SEL2E','EG1SAE3E_ROB','EG1SAE4E_ROB','EG1SPT1E','EG1SPT2E','EG1SPT3E',
        'EG1R101E','EG1R201E','EG1R301E','EG1R401E','EG1R102E','EG1R202E','EG1R302E','EG1R402E','EG1R105E','EG1R205E',
        'EG1SPO1E','EG1SPO2E','EG1SPO4E','EG1STG4E_ESE'
    )
)
INSERT INTO education_courses (education_id, course_id)
SELECT iut_educations.id, iut_courses.id
FROM iut_educations
CROSS JOIN iut_courses
ON CONFLICT DO NOTHING;

UPDATE educations
SET context = COALESCE(
    context,
    'Le parcours GEII — Électronique et Systèmes Embarqués à l’IUT de Cachan m’a permis d’acquérir des bases solides en électronique, électrotechnique, automatisme, informatique industrielle et systèmes embarqués. La formation s’est appuyée sur des enseignements théoriques, des travaux pratiques, des projets tutorés et des SAE autour de la robotique, de l’électronique, de l’énergie, des microcontrôleurs et des réseaux industriels. Elle a constitué une étape déterminante dans mon orientation vers les systèmes embarqués, la conception électronique et la validation de systèmes techniques.'
)
WHERE id IN (
    SELECT e.id
    FROM educations e
    LEFT JOIN schools s ON s.id = e.school_id
    WHERE lower(COALESCE(s.name, '')) LIKE '%iut de cachan%'
       OR lower(COALESCE(s.name, '')) LIKE '%paris-saclay%'
       OR lower(COALESCE(e.title, '')) LIKE '%génie électrique%'
       OR lower(COALESCE(e.title, '')) LIKE '%genie electrique%'
       OR lower(COALESCE(e.title, '')) LIKE '%geii%'
);
