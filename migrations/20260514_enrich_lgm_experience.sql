ALTER TABLE jobs ADD COLUMN IF NOT EXISTS company_context TEXT;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS product_context TEXT;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS first_year_summary TEXT;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS first_year_tasks TEXT[] DEFAULT '{}';
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS first_year_achievements TEXT[] DEFAULT '{}';
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS first_year_tools TEXT[] DEFAULT '{}';
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS first_year_skills TEXT[] DEFAULT '{}';
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS second_year_summary TEXT;
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS second_year_tasks TEXT[] DEFAULT '{}';
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS second_year_achievements TEXT[] DEFAULT '{}';
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS second_year_tools TEXT[] DEFAULT '{}';
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS second_year_skills TEXT[] DEFAULT '{}';
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS tools TEXT[] DEFAULT '{}';
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS results_list TEXT[] DEFAULT '{}';
ALTER TABLE jobs ADD COLUMN IF NOT EXISTS personal_contribution_list TEXT[] DEFAULT '{}';

UPDATE companies
SET description = $$LGM Ingénierie est une filiale du groupe LGM spécialisée dans l’ingénierie électronique et logicielle, les bancs de test, l’intégration, la validation, la qualification et le traitement d’obsolescence. L’entreprise intervient notamment dans les secteurs de l’aéronautique, de la défense, de l’énergie, des transports et de l’automobile.$$,
    industry = 'Ingénierie électronique, logiciel embarqué, validation automobile',
    type = 'company',
    city = 'Vélizy-Villacoublay',
    country = 'France',
    updated_at = now()
WHERE lower(name) LIKE '%lgm%';

UPDATE jobs
SET title = 'Apprenti Développeur Systèmes Embarqués',
    contract_type = 'apprenticeship',
    location = 'Vélizy-Villacoublay, France',
    start_date = DATE '2023-08-01',
    end_date = DATE '2025-08-31',
    status = 'done',
    short_summary = $$Validation logicielle embarquée, tests de calculateurs automobiles, tests unitaires en C et automatisation de la traçabilité.$$,
    supervision = 'Groupe LGM',
    lab_name = 'ENPS — Embedded Networks Products & Services',
    function_title = 'Apprenti Développeur / Ingénieur Systèmes Embarqués',
    exact_dates = 'août 2023 — août 2025',
    description = $$Alternance de deux ans chez LGM Ingénierie dans un environnement automobile, centrée sur la validation logicielle embarquée, les tests unitaires en C, les tests sur cible et la validation de calculateurs automobiles. Cette expérience m’a permis de travailler sur OCEAN, une pile de protocoles embarqués utilisée pour la communication entre calculateurs, puis d’élargir mon périmètre vers les tests physiques CAN/LIN, l’analyse d’incidents, la traçabilité et l’automatisation de rapports avec Python/Django.$$,
    company_context = $$LGM Ingénierie est une filiale du groupe LGM spécialisée dans l’ingénierie électronique et logicielle, les bancs de test, l’intégration, la validation, la qualification et le traitement d’obsolescence. L’entreprise intervient notamment dans les secteurs de l’aéronautique, de la défense, de l’énergie, des transports et de l’automobile.

Mon alternance s’est déroulée au sein de la Business Line ENPS — Embedded Networks Products & Services, rattachée aux activités de conception et développement. Cette Business Line travaille sur des produits et services liés aux réseaux embarqués, aux protocoles de communication et à la validation de calculateurs automobiles.$$,
    mission_context = $$Pendant cette alternance, j’ai travaillé dans un environnement automobile orienté logiciel embarqué, protocoles de communication et validation de calculateurs. Le produit principal sur lequel j’ai été formé est OCEAN, une pile de protocoles embarqués configurable permettant aux calculateurs automobiles, ou ECU, de communiquer à travers différents réseaux.

La première année a été principalement consacrée à la compréhension de l’environnement LGM, du produit OCEAN, du cycle en V et des méthodes de vérification et validation logicielle. Le cœur de la mission était la mise en œuvre de tests unitaires sur des fonctions d’OCEAN à l’aide de IBM Rational Test RealTime.

La deuxième année a élargi le périmètre vers la validation de calculateurs automobiles, les tests sur cible, l’analyse des communications CAN/LIN, l’utilisation d’instruments de mesure et l’automatisation des rapports de validation et de la traçabilité avec Python/Django.$$,
    product_context = $$OCEAN est une solution logicielle embarquée configurable utilisée pour permettre la communication entre différents calculateurs automobiles. Elle prend en charge plusieurs protocoles de communication comme CAN, CAN FD, LIN, LVDS ou J1939. Le produit s’intègre dans des architectures automobiles complexes et permet la transmission, la réception, le diagnostic et la gestion des échanges entre calculateurs.

Le produit repose sur des drivers de communication, des couches d’interaction, des couches de transport, des services de diagnostic, de la gestion réseau et une couche d’abstraction du système d’exploitation.

Le travail réalisé autour d’OCEAN s’inscrit dans une logique de validation logicielle embarquée, avec un objectif de conformité entre les spécifications fonctionnelles, les diagrammes et le comportement réel du code.$$,
    first_year_summary = $$La première année d’alternance a été consacrée à la montée en compétence sur les produits et méthodes de LGM Ingénierie. L’objectif était de comprendre le fonctionnement d’OCEAN, le rôle des calculateurs automobiles, les protocoles de communication embarqués et les méthodes de validation logicielle.

J’ai principalement travaillé sur la mise en œuvre de tests unitaires sur des fonctions d’OCEAN avec IBM Rational Test RealTime. Ces tests s’inscrivaient dans le cycle en V, avec pour objectif de vérifier que les fonctions testées respectaient les diagrammes fonctionnels et les spécifications attendues.

Cette année m’a permis de réaliser plus de 200 tests unitaires sur différents modules d’OCEAN, certains simples et rapides, d’autres nécessitant plusieurs jours d’analyse à cause de la complexité des fonctions, des dépendances ou des incohérences entre diagrammes et code.$$,
    first_year_tasks = ARRAY[
      'Découvrir le laboratoire de validation, les calculateurs automobiles et les couches basses.',
      'Comprendre le rôle des ECU et la communication entre calculateurs.',
      'Analyser des diagrammes fonctionnels et identifier les chemins d’exécution.',
      'Créer des cas de test unitaires avec IBM Rational Test RealTime.',
      'Mettre en place les stubs, test harness, test suites et ressources de test.',
      'Analyser les résultats et générer des rapports exploitables.',
      'Remonter les incohérences entre diagrammes et code via l’outil interne basé sur Redmine.'
    ],
    first_year_achievements = ARRAY[
      'Réalisation de plus de 200 tests unitaires sur différents modules d’OCEAN.',
      'Mise en place d’environnements de test structurés avec Test_Resources, External_Includes, Report, Stubs, Test_Cases, Test_Harness, Test_Suites, Unit_Under_Test et Unit_Dependencies.',
      'Application d’une méthodologie de couverture MC/DC pour vérifier l’influence indépendante des conditions logiques.',
      'Création de variables locales et initialisation correcte de pointeurs pour résoudre des erreurs de gestion mémoire dans les tests.',
      'Identification et documentation d’écarts entre diagrammes fonctionnels et comportement réel du code.'
    ],
    first_year_tools = ARRAY['C','IBM Rational Test RealTime','RTRT','GitLab','Fork','Redmine','Neness','Pack Office'],
    first_year_skills = ARRAY['Tests unitaires','Couverture MC/DC','Test cases','Test suites','Test harness','Stubs','C','Pointeurs','Gestion mémoire','Analyse de diagrammes','Vérification logicielle','Validation logicielle','Cycle en V','Rigueur méthodologique'],
    second_year_summary = $$La deuxième année a élargi mon périmètre vers une approche plus système et industrielle. En plus des tests unitaires et sur cible en C, j’ai participé à la validation et aux tests de calculateurs automobiles, notamment autour des communications CAN et LIN.

Cette période m’a permis de travailler avec des outils de validation comme CANoe, des instruments de mesure comme l’oscilloscope et le multimètre, ainsi que des bancs de test. J’ai également contribué à l’analyse d’incidents, à la rédaction de rapports qualité, à l’amélioration des procédures de validation et au développement d’outils Python/Django pour automatiser les rapports et améliorer la traçabilité.$$,
    second_year_tasks = ARRAY[
      'Participer à la validation de calculateurs automobiles.',
      'Réaliser des tests physiques sur bus CAN et LIN.',
      'Observer et analyser les communications avec CANoe.',
      'Utiliser oscilloscopes, multimètres et bancs de test.',
      'Développer et exécuter des tests unitaires et des tests sur cible en C.',
      'Analyser les écarts et incidents détectés pendant les campagnes de test.',
      'Automatiser des rapports de validation et améliorer la traçabilité avec Python/Django.',
      'Contribuer à la documentation, aux procédures de test et à l’amélioration continue.'
    ],
    second_year_achievements = ARRAY[
      'Participation à la validation de calculateurs automobiles selon les spécifications.',
      'Analyse de communications CAN/LIN et de trames avec CANoe.',
      'Exécution de tests sur cible et génération de rapports de validation.',
      'Contribution à des rapports qualité et à l’analyse d’incidents.',
      'Développement d’outils internes Python/Django pour réduire les tâches répétitives et améliorer le reporting technique.',
      'Amélioration de la lisibilité des résultats et de la traçabilité des essais.'
    ],
    second_year_tools = ARRAY['C','Python','Django','SQL','IBM Rational Test RealTime','CANoe','Oscilloscope','Multimètre','Bancs de test','GitLab','Fork','Redmine'],
    second_year_skills = ARRAY['Validation de calculateurs','Tests sur cible','Tests physiques','CAN','LIN','Analyse de trames','Diagnostic automobile','Qualification logicielle','Automatisation','Reporting','Traçabilité','Documentation technique','Rapports qualité','Amélioration continue','Collaboration transverse'],
    missions = ARRAY[
      'Validation logicielle embarquée sur OCEAN.',
      'Développement et exécution de tests unitaires en C avec IBM Rational Test RealTime.',
      'Analyse de diagrammes fonctionnels, conditions logiques, boucles et scénarios de test.',
      'Validation de calculateurs automobiles et tests physiques CAN/LIN.',
      'Tests sur cible, analyse des résultats et qualification logicielle embarquée.',
      'Analyse d’incidents, rédaction de rapports de validation et rapports qualité.',
      'Automatisation de rapports et de la traçabilité avec Python/Django.'
    ],
    achievements = ARRAY[
      'Plus de 200 tests unitaires réalisés sur différents modules d’OCEAN.',
      'Mise en œuvre de tests avec stubs, test harness, test suites et génération de rapports.',
      'Utilisation de CANoe et d’instruments de mesure pour analyser des communications et comportements calculateurs.',
      'Contribution à l’automatisation de rapports et au suivi des campagnes de validation.',
      'Amélioration de procédures de test, de documentation et de traçabilité.'
    ],
    technical_challenges = ARRAY[
      'Erreurs liées à la gestion mémoire|Problème : certaines erreurs apparaissaient lorsque des pointeurs ou structures n’étaient pas correctement initialisés dans les cas de test.|Cause : certains paramètres de fonctions étaient des pointeurs initialisés à NULL ou sans zone mémoire valide.|Solution : création de variables locales adaptées, puis initialisation des pointeurs avec l’adresse de ces variables dans les blocs de test.|Compétences : C, pointeurs, gestion mémoire, débogage, tests unitaires, analyse d’erreurs.',
      'Incohérences entre diagrammes et code|Problème : certains diagrammes fonctionnels ne correspondaient plus au comportement réel du code.|Cause : le code avait parfois évolué sans mise à jour du diagramme associé.|Solution : création d’un ticket sur l’outil de suivi interne basé sur Redmine, explication de l’écart, modification du diagramme dans Neness, puis envoi des corrections sur GitLab avec Fork.|Compétences : analyse d’anomalies, Redmine, Neness, GitLab, Fork, documentation technique, communication technique, vérification fonctionnelle.'
    ],
    technologies = ARRAY[
      'C','Python','Django','SQL','Logiciel embarqué','Systèmes embarqués','OCEAN','Piles de protocoles','Tests unitaires','Tests sur cible','IBM Rational Test RealTime','RTRT','MC/DC','Cycle en V','Stubs','Test harness','Test suites','Test cases','ECU','Calculateurs automobiles','CAN','CAN FD','LIN','LVDS','J1939','UDS','OBD','Diagnostic automobile','Protocoles embarqués','CANoe','Oscilloscope','Multimètre','Bancs de test','Validation fonctionnelle','Tests physiques','Analyse de trames','Traçabilité','Documentation technique','Amélioration continue'
    ],
    tools = ARRAY['C','Python','Django','SQL','IBM Rational Test RealTime','RTRT','CANoe','Oscilloscope','Multimètre','Bancs de test','GitLab','Fork','Redmine','Neness','Git','Pack Office'],
    methods = ARRAY[
      'Travail dans le cycle en V avec vérification des fonctions par rapport aux spécifications et diagrammes.',
      'Analyse des chemins d’exécution, conditions simples ou combinées, boucles et scénarios de test.',
      'Recherche de couverture MC/DC pour les fonctions critiques.',
      'Tests reproductibles, documentés et exploitables par les équipes de développement, validation, qualité et méthodes.',
      'Remontée structurée des anomalies et écarts de documentation.',
      'Amélioration continue des procédures de test, de reporting et de traçabilité.'
    ],
    results = $$Cette alternance m’a permis de progresser progressivement d’une phase de découverte du produit OCEAN et des tests unitaires vers une activité plus large de validation de calculateurs, de tests sur cible, d’analyse d’incidents et d’automatisation. J’ai pu comprendre les exigences d’un environnement industriel automobile, où la qualité, la traçabilité et la rigueur documentaire sont essentielles.$$,
    results_list = ARRAY[
      'Réalisation de plus de 200 tests unitaires sur différents modules d’OCEAN.',
      'Montée en compétence sur IBM Rational Test RealTime.',
      'Compréhension des protocoles CAN/LIN et du fonctionnement des calculateurs automobiles.',
      'Participation à la validation de calculateurs.',
      'Utilisation de CANoe et d’instruments de mesure.',
      'Contribution à des rapports de validation et qualité.',
      'Automatisation de rapports avec Python/Django.',
      'Amélioration de la traçabilité et des procédures de test.'
    ],
    personal_contribution = $$Cette expérience m’a fait passer d’une approche principalement logicielle et unitaire à une vision plus complète de la validation automobile, intégrant logiciel embarqué, cible matérielle, communication réseau, qualité, traçabilité et outillage interne.$$,
    personal_contribution_list = ARRAY[
      'Compréhension du cycle en V.',
      'Rigueur dans la validation logicielle.',
      'Montée en compétence en logiciel embarqué automobile.',
      'Progression en analyse de code C.',
      'Meilleure capacité à diagnostiquer des anomalies.',
      'Amélioration de la communication technique.',
      'Capacité à travailler avec des équipes R&D, qualité, méthodes et validation.'
    ],
    skills_developed = ARRAY[
      'C','Python','Django','SQL','Logiciel embarqué','Systèmes embarqués','Validation logicielle','Vérification logicielle','Tests unitaires','Tests sur cible','IBM Rational Test RealTime','RTRT','MC/DC','Cycle en V','OCEAN','Piles de protocoles','ECU','Calculateurs automobiles','CAN','CAN FD','LIN','Diagnostic automobile','CANoe','Oscilloscope','Multimètre','Bancs de test','Stubs','Test harness','Analyse de diagrammes','Redmine','Neness','GitLab','Fork','Analyse d’incidents','Rapports de validation','Traçabilité','Documentation technique','Amélioration continue','Collaboration transverse'
    ],
    document_title = COALESCE(document_title, 'Rapport professionnel — Première année d’apprentissage LGM Ingénierie'),
    document_description = COALESCE(document_description, $$Rapport détaillant le contexte de LGM Ingénierie, la Business Line ENPS, le produit OCEAN, la découverte du laboratoire de validation, la méthodologie de tests unitaires avec IBM Rational Test RealTime, les difficultés rencontrées et les résultats de la première année d’alternance.$$),
    updated_at = now()
WHERE id IN (
  SELECT j.id
  FROM jobs j
  LEFT JOIN companies c ON c.id = j.company_id
  WHERE lower(c.name) LIKE '%lgm%'
     OR lower(j.title) LIKE '%lgm%'
     OR lower(j.title) LIKE '%ocean%'
);
