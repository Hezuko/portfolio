ALTER TABLE jobs ADD COLUMN IF NOT EXISTS short_summary TEXT;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS lab_name VARCHAR(255);
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS supervision VARCHAR(255);
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS function_title VARCHAR(180);
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS exact_dates VARCHAR(120);
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS problem_statement TEXT;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS system_architecture TEXT;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS technical_challenges TEXT[] DEFAULT '{}';
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS personal_contribution TEXT;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS skills_developed TEXT[] DEFAULT '{}';
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS document_title TEXT;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS document_url TEXT;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS document_description TEXT;

UPDATE companies
SET description = 'Le CNRS est un organisme public français de recherche scientifique, reconnu pour ses activités dans de nombreux domaines scientifiques et technologiques. Le stage s’est déroulé au laboratoire MPQ — Matériaux et Phénomènes Quantiques, une unité mixte de recherche associant le CNRS et l’Université Paris Cité. Le pôle technique du laboratoire apporte un soutien en électronique, informatique, instrumentation, mécanique, vide et cryogénie aux équipes de recherche.',
    industry = 'Recherche scientifique et instrumentation',
    size = 'Grande organisation',
    type = 'laboratory',
    city = 'Paris',
    country = 'France',
    updated_at = now()
WHERE lower(name) LIKE '%cnrs%';

UPDATE jobs
SET title = 'Stagiaire Systèmes Embarqués & Électronique',
    contract_type = 'internship',
    location = 'Paris, France',
    start_date = DATE '2023-04-17',
    end_date = DATE '2023-06-23',
    status = 'done',
    short_summary = 'Régulation en température de salles d’expériences — instrumentation scientifique, électronique embarquée et communication radiofréquence.',
    lab_name = 'Laboratoire MPQ — Matériaux et Phénomènes Quantiques',
    supervision = 'Université Paris Cité — CNRS',
    function_title = 'Assistant Ingénieur',
    exact_dates = '17/04/2023 au 23/06/2023',
    description = 'Stage en électronique et systèmes embarqués au laboratoire MPQ — Université Paris Cité — CNRS, orienté instrumentation scientifique. Le projet portait sur la conception et le prototypage d’un système de mesure et de transmission radiofréquence de températures pour des salles d’expériences, avec cartes maître/esclave, capteurs, microcontrôleurs, routage PCB, firmware embarqué et validation expérimentale.',
    mission_context = 'Le projet confié portait sur la régulation en température de salles d’expériences. Dans un environnement de recherche expérimentale, les fluctuations thermiques peuvent perturber les dispositifs optiques et les expériences sensibles, notamment les alignements de faisceaux laser ou les cavités optiques. L’objectif était de développer un système capable de mesurer la température en différents points d’une salle d’expérience, de transmettre ces mesures sans fil vers une unité maître, puis de préparer une future régulation de température par actionnement de vannes ou d’électrovannes.',
    problem_statement = 'La problématique principale était de concevoir et valider un prototype électronique capable de mesurer des températures avec plusieurs types de capteurs, puis de transmettre les données de manière fiable par radiofréquence vers une carte maître. Les contraintes portaient sur l’acquisition analogique et numérique, la communication RF, le routage de cartes maître/esclave, l’assemblage de composants traversants et CMS, la migration Arduino vers PIC18F26J11 et le diagnostic de pannes matérielles et logicielles.',
    system_architecture = 'Le système repose sur une architecture maître/esclave. Les cartes esclaves réalisent les mesures de température en différents points avec une thermistance CTN 10 kΩ, une PT100 et un DHT22/AM2302. L’acquisition utilise le CAN interne 10 bits, un AD7709 16 bits, une liaison numérique pour le DHT22 et le SPI pour l’AD7709 et le module RF SI4432. Les données sont transmises par radiofréquence vers une carte maître, destinée à recevoir les mesures, préparer le traitement côté PC et servir de base à une future régulation thermique par actionneurs.',
    missions = ARRAY[
      'Étudier les schémas électroniques existants et la documentation technique des composants.',
      'Analyser l’architecture maître/esclave du système de mesure.',
      'Concevoir et router des circuits imprimés sous Ultiboard à partir de schémas Multisim.',
      'Préparer les fichiers de fabrication Gerber et Drill.',
      'Assembler et souder des composants traversants et CMS.',
      'Développer et valider les fonctions firmware sur Arduino Pro Mini / ATmega328P.',
      'Programmer les capteurs DHT22, thermistance et PT100.',
      'Configurer l’AD7709 et le module RF SI4432 via SPI.',
      'Mettre en œuvre un contrôle CRC pour fiabiliser les échanges.',
      'Migrer progressivement les fonctions vers le microcontrôleur PIC18F26J11.',
      'Réaliser des tests fonctionnels avec multimètre, oscilloscope, alimentation de laboratoire et bancs de test.',
      'Documenter les choix techniques, les essais, les problèmes rencontrés et les solutions.'
    ],
    achievements = ARRAY[
      'Étude des schémas électroniques sous Multisim, analyse des composants et compréhension de l’architecture maître/esclave.',
      'Routage PCB sous Ultiboard avec placement des composants, modification manuelle des pistes, plans de masse, vérification DRC, export Gerber/Drill et contrôle ViewMate.',
      'Assemblage et câblage de prototypes avec soudure de composants traversants et CMS, vérification des alimentations et correction de défauts de soudure.',
      'Validation firmware sur Arduino Pro Mini : DHT22, thermistance via CAN interne, PT100 via AD7709, SPI, calcul de température, RF SI4432 avec RadioHead et CRC.',
      'Préparation de la migration vers PIC18F26J11 : MPLAB IDE, registres, broches, timers, interruptions, SPI et adaptation des fonctions capteurs/RF.',
      'Tests et débogage : reset Arduino/PIC, stabilité RF, alimentation, courant, capacité des pistes et observation de signaux SPI à l’oscilloscope.'
    ],
    technical_challenges = ARRAY[
      'Problème de téléversement Arduino|Problème : impossible de téléverser le programme vers l’Arduino Pro Mini.|Cause identifiée : la broche reset était maintenue à 0 V à cause d’un mauvais câblage du bouton poussoir.|Solution : vérification des tensions, analyse de la broche reset, correction du bouton poussoir et validation du téléversement.|Compétences : diagnostic électronique, datasheet, multimètre, débogage matériel.',
      'Instabilité du module RF|Problème : la transmission radiofréquence fonctionnait par intermittence.|Cause suspectée : problème matériel ou alimentation du module RF.|Solution : mesure de la tension, passage sur alimentation de laboratoire, observation de la consommation, vérification de la capacité des pistes et ajout de câbles de plus grande section.|Compétences : radiofréquence, alimentation, mesure de courant, validation PCB.',
      'Réinitialisation du PIC18F26J11|Problème : les programmes téléversés sur le PIC18F26J11 ne s’exécutaient pas.|Cause identifiée : la broche MCLR était maintenue à 0 V, gardant le microcontrôleur en reset permanent.|Solution : modification du câblage du bouton reset, ajout d’une résistance de tirage et validation du fonctionnement.|Compétences : PIC18F26J11, MCLR, reset, schéma électronique, debug firmware/hardware.',
      'Soudure de composants CMS|Problème : difficultés de soudure CMS avec pastilles décollées, composants fragiles et soudures insuffisantes.|Solution : progression au câblage CMS avec lunettes binoculaires, lampe loupe, brucelles et station de soudage, puis réalisation d’une seconde carte fonctionnelle.|Compétences : soudure CMS, prototypage, assemblage électronique, rigueur expérimentale.'
    ],
    technologies = ARRAY[
      'C','C++','Arduino','Programmation embarquée','Programmation bas niveau','Registres','Interruptions','Timers',
      'ATmega328P','Arduino Pro Mini','PIC18F26J11','MPLAB IDE','Microcontrôleurs',
      'Multisim','Ultiboard','ViewMate','PCB','Routage PCB','Conception électronique','Gerber','Drill','DRC','Plans de masse','CMS','Soudure','Câblage',
      'PT100','Thermistance CTN','DHT22 / AM2302','AD7709','ADC / CAN','Acquisition analogique','Acquisition numérique','Calibration','Mesure de température','Humidité relative',
      'SPI','RF','SI4432','RadioHead','CRC','GFSK','Transmission radiofréquence',
      'Oscilloscope','Multimètre','Alimentation de laboratoire','Bancs de test','Validation fonctionnelle','Diagnostic','Documentation technique'
    ],
    methods = ARRAY[
      'Lecture de datasheets et analyse de schémas électroniques.',
      'Prototypage progressif avec validation fonction par fonction.',
      'Tests de continuité, mesures électriques et diagnostic matériel.',
      'Documentation des essais, problèmes rencontrés et solutions.',
      'Validation expérimentale sur cartes câblées.'
    ],
    results = 'Ce stage m’a permis de participer à un projet complet d’instrumentation scientifique, depuis l’étude du besoin jusqu’au prototypage et à la validation de fonctions électroniques et embarquées. Les résultats incluent la compréhension de l’architecture maître/esclave, le routage et la préparation de cartes électroniques, l’assemblage de prototypes, l’acquisition de température avec plusieurs capteurs, la communication RF entre cartes, la migration progressive vers PIC18F26J11 et la rédaction d’un rapport technique complet.',
    personal_contribution = 'Cette expérience a constitué ma première expérience professionnelle significative en électronique et systèmes embarqués. Elle m’a fait progresser en instrumentation scientifique, en prototypage électronique, en rigueur de test, mesure et documentation, et a confirmé mon intérêt pour les systèmes embarqués, l’électronique et la validation de systèmes techniques.',
    skills_developed = ARRAY[
      'Systèmes embarqués','Électronique','Conception PCB','Routage PCB','C','C++','Arduino','PIC18F26J11','MPLAB IDE','Microcontrôleurs','SPI','Radiofréquence','SI4432','Capteurs','PT100','Thermistance','DHT22','AD7709','Acquisition de données','ADC / CAN','CRC','Soudure CMS','Câblage','Oscilloscope','Multimètre','Validation fonctionnelle','Diagnostic électronique','Documentation technique','Instrumentation scientifique'
    ],
    document_title = COALESCE(document_title, NULL),
    document_url = COALESCE(document_url, NULL),
    document_description = COALESCE(document_description, 'Rapport détaillant le contexte du stage, l’architecture du système, la conception des cartes électroniques, le développement firmware, les capteurs utilisés, la communication radiofréquence, les phases de débogage et les résultats obtenus.'),
    updated_at = now()
WHERE id = 3
   OR lower(title) LIKE '%cnrs%'
   OR lower(title) LIKE '%systèmes embarqués%électronique%';
