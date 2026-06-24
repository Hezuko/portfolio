-- Projets embarqués IUT Cachan : Base mobile (Hackathon) + Stage MPQ (PIC). Upsert par slug.
BEGIN;

-- ===== Base mobile robotique — Hackathon IUT Cachan =====
INSERT INTO projects (name, slug, category, status, short_description, long_description, goal, context, architecture, challenges, results, technologies, main_image, images, start_date, end_date, school_id)
VALUES (
  'Base mobile robotique — Hackathon IUT Cachan',
  'base-mobile-robot-hackathon',
  'robotics',
  'done',
  'Une base mobile robotique pédagogique conçue de A à Z avec mon équipe à l''IUT de Cachan : carte mère sur-mesure, sept types de capteurs et asservissement PID, destinée aux TP et à la coupe de robotique GEII.',
  'Une base mobile robotique pédagogique conçue de A à Z avec mon équipe à l''IUT de Cachan : carte mère sur-mesure, sept types de capteurs et asservissement PID, destinée aux TP et à la coupe de robotique GEII.',
  'Livrer une base mobile fiable et facile à programmer, équipée des capteurs imposés et pilotable sans fil, pour que de futurs étudiants apprennent la robotique dessus.',
  'Projet de fin de cycle à l''IUT de Cachan, dans la continuité de notre année : concevoir un robot mobile complet qui servirait d''outil pédagogique aux étudiants suivants (travaux pratiques et coupe de robotique GEII). On a commencé par de la rétro-ingénierie d''un robot existant pour le comprendre à fond — électronique, mécanique, programmation — avant de le refaire et de l''améliorer. Un vrai projet d''équipe (à trois) qui m''a plongé dans le système embarqué de bout en bout.',
  'Le cœur est un Nucleo STM32 F429ZI relié à une carte mère que nous avons conçue (Altium), exposant des emplacements MikroBUS standardisés. Chaque fonction est un module : encodeurs AS5047P (SPI) pour l''odométrie, ultrasons VMA306, caméra Pixy, boussole BMM150, capteurs de ligne CNY70, et deux étages de puissance IFX9021 pour les moteurs. Le tout est programmé en C++ (mbed), avec un asservissement PID en boucle fermée sur les encodeurs et une interface Qt pour le pilotage.',
  'Le plus délicat a été l''asservissement : obtenir un déplacement précis a demandé de régler le correcteur PID à partir du retour vitesse des encodeurs, puis d''enchaîner avec des profils de vitesse en trapèze pour des trajectoires propres.',
  'Une base mobile fonctionnelle et complète — elle suit un objet, suit une ligne, évite les obstacles et se pilote sans fil — prête à servir de support de TP et pour la coupe GEII. Le projet m''a fait toucher à toute la chaîne embarquée : électronique, PCB, mécanique, firmware et asservissement, en équipe.',
  ARRAY['STM32 Nucleo F429ZI', 'C++', 'ARM mbed', 'Altium Designer', 'SolidWorks', 'Qt Creator', 'MikroBUS', 'SPI', 'UART', 'I2C', 'Bluetooth HC-06', 'Caméra Pixy', 'Encodeur AS5047P', 'Ultrason VMA306', 'Magnétomètre BMM150', 'Capteur optique CNY70', 'Driver moteur IFX9021', 'Asservissement PID', 'Odométrie']::text[],
  '/images/projects/base-mobile-robot-hackathon/carte-mere.png',
  ARRAY['/images/projects/base-mobile-robot-hackathon/suivi-objet.mp4', '/images/projects/base-mobile-robot-hackathon/synoptique.png', '/images/projects/base-mobile-robot-hackathon/asservissement-pid.png', '/images/projects/base-mobile-robot-hackathon/asservissement.mp4', '/images/projects/base-mobile-robot-hackathon/ultrason.mp4', '/images/projects/base-mobile-robot-hackathon/synoptique-pixy.png', '/images/projects/base-mobile-robot-hackathon/synoptique-moteur.png']::text[],
  DATE '2022-09-01',
  DATE '2023-06-30',
  3
)
ON CONFLICT (slug) DO UPDATE SET
  name = EXCLUDED.name,
  category = EXCLUDED.category,
  status = EXCLUDED.status,
  short_description = EXCLUDED.short_description,
  long_description = EXCLUDED.long_description,
  goal = EXCLUDED.goal,
  context = EXCLUDED.context,
  architecture = EXCLUDED.architecture,
  challenges = EXCLUDED.challenges,
  results = EXCLUDED.results,
  technologies = EXCLUDED.technologies,
  main_image = EXCLUDED.main_image,
  images = EXCLUDED.images,
  start_date = EXCLUDED.start_date,
  end_date = EXCLUDED.end_date,
  school_id = EXCLUDED.school_id,
  updated_at = now();

-- ===== Système embarqué sans fil sur PIC — Stage au laboratoire MPQ =====
INSERT INTO projects (name, slug, category, status, short_description, long_description, goal, context, architecture, challenges, results, technologies, main_image, images, start_date, end_date, school_id)
VALUES (
  'Système embarqué sans fil sur PIC — Stage au laboratoire MPQ',
  'systeme-embarque-pic-stage-mpq',
  'robotics',
  'done',
  'Stage en laboratoire de recherche (CNRS / MPQ) : j''ai conçu une carte électronique sans fil de mesure de température pour des salles d''expériences quantiques — du schéma au PCB multicouche, du prototype Arduino jusqu''au PIC.',
  'Stage en laboratoire de recherche (CNRS / MPQ) : j''ai conçu une carte électronique sans fil de mesure de température pour des salles d''expériences quantiques — du schéma au PCB multicouche, du prototype Arduino jusqu''au PIC.',
  'Concevoir un système embarqué sans fil capable de mesurer précisément la température de plusieurs salles et de transmettre les données de façon fiable, sur une carte robuste pensée pour un usage en laboratoire.',
  'Stage de 2e année (IUT de Cachan) au pôle technique du laboratoire MPQ — Matériaux et Phénomènes Quantiques, une unité de recherche CNRS / Université Paris Cité. La mission : fiabiliser la mesure de température des salles d''expériences, où la précision est critique pour la physique quantique. Un vrai projet de terrain, du besoin réel jusqu''à une carte fonctionnelle livrée au labo.',
  'Le système repose sur un microcontrôleur Microchip PIC18F26J11 (réaffectation de broches PPS pour optimiser le routage) qui lit plusieurs capteurs de température (DHT22, thermistance, PT100) et transmet les mesures par radiofréquence avec un contrôle CRC. J''ai d''abord prototypé et validé toute la chaîne sous Arduino, puis migré l''ensemble vers le PIC sous MPLAB. La carte a été étudiée sous Multisim, routée en multicouche sous Ultiboard, puis fabriquée, câblée et déboguée.',
  'La migration d''Arduino vers le PIC a été le vrai défi : reprendre toute la logique (lecture des capteurs, RF, CRC) sur une cible bien moins assistée, en réglant des problèmes concrets de bas niveau — appel de courant et stabilité du module RF, reset du microcontrôleur, téléversement.',
  'Une carte de mesure de température sans fil fonctionnelle, livrée au laboratoire pour fiabiliser ses salles d''expériences. Le stage m''a fait vivre tout le cycle d''un produit embarqué en contexte recherche : étude des datasheets, schéma, routage PCB multicouche, programmation Arduino puis PIC, étalonnage et débogage matériel.',
  ARRAY['PIC18F26J11', 'Microchip MPLAB', 'Arduino', 'Langage C', 'Multisim', 'Ultiboard', 'PCB multicouche', 'Radiofréquence (RF)', 'CRC', 'SPI', 'UART', 'DHT22', 'Thermistance', 'Sonde PT100', 'Étalonnage capteurs', 'PPS (Peripheral Pin Select)']::text[],
  '/images/projects/systeme-embarque-pic-stage-mpq/pcb-routage.png',
  ARRAY['/images/projects/systeme-embarque-pic-stage-mpq/pcb-top.png', '/images/projects/systeme-embarque-pic-stage-mpq/pcb-bottom.png', '/images/projects/systeme-embarque-pic-stage-mpq/pcb-inner1.png', '/images/projects/systeme-embarque-pic-stage-mpq/pcb-inner2.png']::text[],
  DATE '2023-04-01',
  DATE '2023-07-31',
  3
)
ON CONFLICT (slug) DO UPDATE SET
  name = EXCLUDED.name,
  category = EXCLUDED.category,
  status = EXCLUDED.status,
  short_description = EXCLUDED.short_description,
  long_description = EXCLUDED.long_description,
  goal = EXCLUDED.goal,
  context = EXCLUDED.context,
  architecture = EXCLUDED.architecture,
  challenges = EXCLUDED.challenges,
  results = EXCLUDED.results,
  technologies = EXCLUDED.technologies,
  main_image = EXCLUDED.main_image,
  images = EXCLUDED.images,
  start_date = EXCLUDED.start_date,
  end_date = EXCLUDED.end_date,
  school_id = EXCLUDED.school_id,
  updated_at = now();

COMMIT;
