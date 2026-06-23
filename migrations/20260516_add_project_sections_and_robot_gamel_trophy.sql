ALTER TABLE media_assets ADD COLUMN IF NOT EXISTS secure_url TEXT;
ALTER TABLE media_assets ADD COLUMN IF NOT EXISTS caption TEXT;
ALTER TABLE media_assets ADD COLUMN IF NOT EXISTS duration NUMERIC;

CREATE TABLE IF NOT EXISTS project_sections (
    id SERIAL PRIMARY KEY,
    project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    subtitle VARCHAR(255),
    body TEXT,
    section_type VARCHAR(60) NOT NULL DEFAULT 'text',
    layout VARCHAR(60) NOT NULL DEFAULT 'text_only',
    display_order INTEGER,
    is_visible BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS project_section_media (
    id SERIAL PRIMARY KEY,
    section_id INTEGER NOT NULL REFERENCES project_sections(id) ON DELETE CASCADE,
    media_id INTEGER NOT NULL REFERENCES media_assets(id) ON DELETE CASCADE,
    display_order INTEGER NOT NULL DEFAULT 1,
    display_mode VARCHAR(60) NOT NULL DEFAULT 'right',
    caption TEXT,
    alt_text TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE UNIQUE INDEX IF NOT EXISTS project_sections_project_title_unique
ON project_sections(project_id, lower(title));

CREATE UNIQUE INDEX IF NOT EXISTS project_section_media_section_media_unique
ON project_section_media(section_id, media_id);

INSERT INTO schools (name, slug, city, country, website, description)
SELECT 'IUT de Cachan — Université Paris-Saclay',
       'iut-de-cachan-universite-paris-saclay',
       'Cachan',
       'France',
       'https://www.iut-cachan.universite-paris-saclay.fr',
       'Institut universitaire de technologie orienté génie électrique, informatique industrielle, électronique, automatisme et projets techniques.'
WHERE NOT EXISTS (
  SELECT 1 FROM schools
  WHERE lower(name) LIKE '%iut%cachan%'
     OR slug IN ('iut-cachan', 'iut-de-cachan-universite-paris-saclay')
);

WITH school AS (
  SELECT id
  FROM schools
  WHERE lower(name) LIKE '%iut%cachan%'
     OR slug IN ('iut-cachan', 'iut-de-cachan-universite-paris-saclay')
  ORDER BY id
  LIMIT 1
), upsert_project AS (
  INSERT INTO projects (
    name, slug, main_image, short_description, long_description, goal, features,
    technologies, start_date, end_date, status, category, school_id
  )
  SELECT
    'Robot suiveur de ligne — Gamel Trophy',
    'robot-suiveur-de-ligne-gamel-trophy',
    NULL,
    'Robot autonome suiveur de ligne conçu en équipe à l’IUT de Cachan dans le cadre du Gamel Trophy, avec conception de carte moteur, routage PCB, tests électroniques, programmation C++ et participation à une compétition robotique.',
    'Projet de robotique réalisé en équipe à l’IUT de Cachan dans le cadre du Gamel Trophy. L’objectif était de concevoir un robot autonome capable de suivre une piste, contourner les obstacles, détecter les raccourcis et atteindre l’arrivée le plus rapidement possible, tout en respectant un cahier des charges imposé. Ma contribution principale a porté sur la conception, la réalisation et la validation de la carte moteur simple, ainsi que sur la programmation et les tests du robot.',
    'Concevoir et valider un robot autonome capable de suivre une ligne blanche, de gérer les virages, d’exploiter les raccourcis et de participer à une compétition de vitesse robotique.',
    ARRAY[
      'Démarrage du robot au retrait du jack.',
      'Arrêt par bouton frontal.',
      'Lecture des capteurs de ligne.',
      'Suivi autonome d’une piste.',
      'Commande différenciée des moteurs gauche et droit.',
      'Ajustement de la vitesse par potentiomètre.',
      'Détection de raccourcis.',
      'Correction de trajectoire par automate d’états.',
      'Validation électronique de la carte moteur.',
      'Participation au Gamel Trophy.'
    ],
    ARRAY[
      'KiCad','PCB','Routage PCB','Schématique électronique','Électronique','Carte moteur','Soudure','Perçage PCB',
      'Tests de continuité','Test d’isolation','Test statique','Test fonctionnel','Ohmmètre','Voltmètre','Générateur de signaux',
      'C++','Robotique','Robot suiveur de ligne','Capteurs CNY70','Moteurs DC','Potentiomètre','Automate d’états',
      'Suivi de ligne','Détection de raccourcis','Travail en équipe','Gestion de projet technique','Documentation technique','Tests et validation'
    ],
    DATE '2021-09-01',
    DATE '2022-06-30',
    'done',
    'robotics',
    school.id
  FROM school
  ON CONFLICT (slug) DO UPDATE
  SET name = EXCLUDED.name,
      short_description = EXCLUDED.short_description,
      long_description = EXCLUDED.long_description,
      goal = EXCLUDED.goal,
      features = EXCLUDED.features,
      technologies = EXCLUDED.technologies,
      start_date = EXCLUDED.start_date,
      end_date = EXCLUDED.end_date,
      status = EXCLUDED.status,
      category = EXCLUDED.category,
      school_id = COALESCE(projects.school_id, EXCLUDED.school_id),
      updated_at = now()
  RETURNING id
), project AS (
  SELECT id FROM upsert_project
  UNION
  SELECT id FROM projects WHERE slug = 'robot-suiveur-de-ligne-gamel-trophy'
)
INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT project.id, section.title, section.subtitle, section.body, section.section_type, section.layout, section.display_order, true
FROM project
CROSS JOIN (VALUES
  (1, 'Contexte et cahier des charges', NULL, 'Chaque année à l’IUT de Cachan, le Gamel Trophy permet aux étudiants de concevoir un robot autonome appelé “gamelle”. L’objectif est de créer un robot rapide, fiable et conforme au cahier des charges, capable de suivre une piste, contourner les plots, détecter les raccourcis et franchir l’arrivée correctement.

Le robot devait :
- être construit avec des composants imposés ;
- démarrer lorsque le jack est retiré ;
- suivre la piste de manière autonome ;
- contourner les plots ;
- éviter les collisions ;
- détecter les raccourcis ;
- faire tomber la première barre d’arrivée sans toucher la seconde.', 'step', 'media_right'),
  (2, 'Organisation du projet en équipe', NULL, 'Le projet a été réalisé en équipe de quatre étudiants. Pour optimiser le temps de développement, les tâches ont été réparties entre les membres du groupe autour des cartes capteurs et moteurs.

Répartition :
- carte capteur parallèle ;
- carte capteur série ;
- carte moteur simple ;
- carte moteur amplifiée.

Ma contribution principale : conception et réalisation de la carte moteur simple.', 'step', 'media_left'),
  (3, 'Ma contribution : carte moteur simple', NULL, 'Ma partie principale du projet consistait à concevoir la carte moteur simple. Cette carte avait pour rôle de piloter les moteurs du robot à partir des informations fournies par les cartes capteurs et du programme embarqué. Elle devait permettre d’actionner les moteurs de manière fiable afin que le robot puisse avancer, tourner, corriger sa trajectoire et suivre la ligne.', 'step', 'media_right'),
  (4, 'Conception électronique', NULL, 'La conception a commencé par un schéma réalisé sur papier, puis validé avant d’être reproduit sous KiCad. Les composants nécessaires ont été intégrés dans le schéma : résistances, diodes, alimentation, connecteurs et éléments nécessaires au pilotage des moteurs.

Après la schématisation, le PCB a été conçu sous KiCad. Cette phase a demandé de placer correctement les composants, d’éviter les croisements de pistes, de respecter les règles de routage et d’obtenir une carte propre, lisible et fabricable.', 'architecture', 'media_left'),
  (5, 'Fabrication et assemblage de la carte', NULL, 'Après validation du PCB, la carte a été fabriquée puis préparée manuellement. Les étapes comprenaient le perçage, l’insertion des composants, la soudure et les premières vérifications électriques.

Cette étape m’a permis de découvrir les contraintes concrètes de fabrication d’une carte électronique, notamment la précision nécessaire au perçage, l’importance du sens des composants et la qualité de la soudure.', 'step', 'media_right'),
  (6, 'Tests et validation électronique', NULL, 'Plusieurs tests ont été réalisés avant d’intégrer la carte dans le robot :
- test de continuité ;
- test d’isolation ;
- test statique ;
- test fonctionnel.

Le test de continuité permettait de vérifier que les connexions prévues étaient bien présentes. Le test d’isolation permettait de vérifier l’absence de courts-circuits. Le test statique consistait à alimenter la carte en 12 V et à vérifier les tensions attendues au voltmètre. Enfin, le test fonctionnel permettait de vérifier que la carte pouvait effectivement commander les moteurs.', 'challenge', 'media_left'),
  (7, 'Programmation du robot', NULL, 'La programmation du robot a été réalisée en C++. Plusieurs fonctions ont été développées pour gérer le comportement du robot :
- lecture de la valeur du potentiomètre pour ajuster la vitesse ;
- marche et arrêt avec automate à trois états ;
- lecture des capteurs de ligne ;
- commande des moteurs gauche et droit ;
- correction de trajectoire ;
- suivi de ligne avec automate à cinq états ;
- détection de raccourcis avec automate à huit états.

La logique de suivi de ligne reposait sur l’état des capteurs. Les moteurs étaient ajustés selon la position du robot par rapport à la bande blanche, afin de corriger la trajectoire en temps réel.', 'code', 'media_right'),
  (8, 'Stratégie de suivi de ligne et raccourcis', NULL, 'Le robot devait suivre la ligne tout en limitant les oscillations. Pour cela, un automate d’états a été utilisé afin d’adapter la trajectoire selon les valeurs détectées par les capteurs.

La détection des raccourcis était une partie stratégique du projet. L’objectif était de distinguer un vrai raccourci d’un simple croisement, notamment en vérifiant l’absence de piste sur la droite du robot. Cette logique devait permettre au robot de gagner du temps sans quitter le circuit.', 'architecture', 'media_left'),
  (9, 'Résultats', NULL, 'Le robot a réussi à suivre la piste et à participer au Gamel Trophy. Il s’est qualifié pour les phases finales avec un chrono de 46 secondes. L’équipe a ensuite été éliminée au premier tour de la phase finale face à un robot plus performant.

Résultat :
- robot fonctionnel ;
- qualification en phase finale ;
- chrono : 46 s ;
- validation de la carte moteur ;
- expérience complète de conception, réalisation, test et compétition.', 'result', 'media_right'),
  (10, 'Bilan personnel', NULL, 'Ce projet m’a permis de découvrir toutes les étapes d’un projet électronique et robotique : analyse du cahier des charges, conception de carte, routage PCB, fabrication, soudure, tests, programmation et intégration. Il m’a aussi permis de développer ma rigueur, mon autonomie, ma capacité à résoudre des problèmes techniques et mon travail en équipe.

Ce projet a été une première expérience marquante dans la conception d’un système embarqué complet, associant électronique, logiciel et mécanique.', 'result', 'media_bottom')
) AS section(display_order, title, subtitle, body, section_type, layout)
ON CONFLICT (project_id, lower(title)) DO UPDATE
SET body = EXCLUDED.body,
    section_type = EXCLUDED.section_type,
    layout = EXCLUDED.layout,
    display_order = EXCLUDED.display_order,
    is_visible = true,
    updated_at = now();

INSERT INTO technologies (name, category)
SELECT value.name, value.category
FROM (VALUES
  ('KiCad','Outil'),('PCB','Electronique'),('Routage PCB','Electronique'),('Schématique électronique','Electronique'),
  ('Électronique','Electronique'),('Carte moteur','Electronique'),('Soudure','Electronique'),('Perçage PCB','Electronique'),
  ('Tests de continuité','Outil'),('Test d’isolation','Outil'),('Test statique','Outil'),('Test fonctionnel','Outil'),
  ('Ohmmètre','Outil'),('Voltmètre','Outil'),('Générateur de signaux','Outil'),('C++','Langage'),
  ('Robotique','Systeme'),('Robot suiveur de ligne','Systeme'),('Capteurs CNY70','Electronique'),('Moteurs DC','Electronique'),
  ('Potentiomètre','Electronique'),('Automate d’états','Systeme'),('Suivi de ligne','Systeme'),('Détection de raccourcis','Systeme'),
  ('Travail en équipe','Autre'),('Gestion de projet technique','Autre'),('Documentation technique','Autre'),('Tests et validation','Outil')
) AS value(name, category)
ON CONFLICT (name) DO UPDATE
SET category = COALESCE(technologies.category, EXCLUDED.category),
    updated_at = now();
