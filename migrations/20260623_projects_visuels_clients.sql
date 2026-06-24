-- Projets orientés client : textes resserrés, images (héro + galerie), longues sections masquées.
BEGIN;

-- ===== joytrain =====
UPDATE projects SET
  short_description = 'Une application mobile fitness, nutrition et coach IA que j''ai imaginée, développée et déployée seul, de l''idée jusqu''aux stores.',
  long_description = 'Une application mobile fitness, nutrition et coach IA que j''ai imaginée, développée et déployée seul, de l''idée jusqu''aux stores.',
  context = 'Je fais du sport régulièrement et je cherchais une app qui réunisse tout au même endroit : entraînements, nutrition, progression. Rien ne me convenait, alors je l''ai construite pour moi. En avançant, j''ai vu qu''elle avait un vrai potentiel, assez aboutie pour être partagée. JoyTrain est née comme ça : d''un besoin personnel devenu un produit.',
  goal = 'Concevoir un produit mobile complet et abouti, du premier croquis à la mise en ligne, en maîtrisant seul toute la chaîne, du mobile au serveur.',
  features = ARRAY['Suivi d''entraînement complet : exercices, programmes, cardio et records personnels', 'Coach IA conversationnel "Bora" qui répond et génère des séances sur mesure', 'Scan d''un repas par photo pour estimer automatiquement les apports', 'Journal nutrition adossé à une vraie base alimentaire et ses macros', 'Couche sociale : amis, posts, messagerie et notifications en temps réel', 'Mode hors-ligne : on enregistre ses séances sans réseau, tout se synchronise ensuite', 'Graphiques de progression et atlas musculaire interactif', 'Prête pour les stores (TestFlight iOS et Google Play)']::text[],
  architecture = 'App mobile en Flutter, API en Python (FastAPI) et back-office d''administration en React, le tout pensé hors-ligne et temps réel. Le coach IA s''appuie sur un moteur RAG et le scan de repas sur un modèle de vision. JoyTrain forme un écosystème complet : l''app, le moteur RAG « Bora » et un site vitrine. Je l''ai déployée moi-même sur serveur via Docker, avec HTTPS automatique et déploiement continu.',
  challenges = NULL,
  results = 'JoyTrain prouve ma capacité à porter un produit de bout en bout, seul : penser l''expérience, développer le mobile et le serveur, intégrer l''IA, puis déployer et préparer la mise en ligne. C''est exactement ce que je peux faire pour transformer une idée en application réelle et utilisable.',
  future_improvements = NULL,
  technologies = ARRAY['Flutter', 'Dart', 'Riverpod', 'FastAPI', 'Python', 'PostgreSQL', 'Redis', 'React', 'RAG / IA', 'Vision par photo', 'Docker', 'Caddy', 'GitHub Actions']::text[],
  main_image = '/images/projects/joytrain/appicon.png',
  images = ARRAY['/images/projects/joytrain/screen-accueil.png', '/images/projects/joytrain/screen-seance-muscu.png', '/images/projects/joytrain/screen-programme.png', '/images/projects/joytrain/screen-cardio.png', '/images/projects/joytrain/screen-routine.png', '/images/projects/joytrain/screen-nutrition.png', '/images/projects/joytrain/screen-bora.png']::text[],
  updated_at = now()
WHERE slug = 'joytrain';

-- ===== bora-rag-joytrain =====
UPDATE projects SET
  short_description = 'Le moteur d''IA qui fait répondre le coach JoyTrain à partir de vraies sources reconnues, au lieu d''inventer.',
  long_description = 'Le moteur d''IA qui fait répondre le coach JoyTrain à partir de vraies sources reconnues, au lieu d''inventer.',
  context = 'Un coach IA n''a de valeur que si on peut lui faire confiance. Pour JoyTrain, je refusais que les conseils fitness et nutrition reposent sur des informations inventées par le modèle. J''ai donc construit un moteur qui va d''abord chercher la réponse dans de vraies références (organismes de santé, publications scientifiques) avant de répondre. L''utilisateur reçoit une réponse ancrée dans des sources réelles, pas une affirmation sortie de nulle part.',
  goal = 'Donner au coach IA de JoyTrain une base de connaissances fiable et citable, pour qu''il réponde sur l''entraînement et la nutrition en s''appuyant sur de vraies sources plutôt que d''improviser.',
  features = ARRAY['Réponses appuyées sur de vraies sources reconnues (santé, nutrition, science)', 'Retrouve l''information la plus pertinente pour chaque question posée', 'Tient compte du contexte de l''utilisateur pour mieux cibler la réponse', 'Recherche hybride : comprend le sens ET retrouve les termes techniques exacts', 'Chaque réponse reste rattachée à sa source d''origine', 'Tourne en local, sans dépendre d''une IA propriétaire payante', 'Brique IA de l''écosystème JoyTrain (app + moteur Bora + site vitrine)']::text[],
  architecture = 'Le moteur collecte des documents de référence, les découpe et les indexe. Le sens du texte est capté par des embeddings open source (bge-m3) stockés dans une base vectorielle PostgreSQL/pgvector. La recherche combine mots-clés et sens, fusionnés pour ne rater ni un terme précis comme « créatine » ni une formulation différente.',
  challenges = NULL,
  results = 'Bora prouve que je sais concevoir une IA fiable et traçable, qui s''appuie sur des sources réelles plutôt que d''halluciner. Le pipeline fonctionne de bout en bout et tout tourne en local, sans dépendre d''une API propriétaire : un vrai gage de maîtrise et de souveraineté des données.',
  future_improvements = NULL,
  technologies = ARRAY['Python', 'RAG', 'BAAI/bge-m3', 'sentence-transformers', 'PyTorch', 'PostgreSQL', 'pgvector', 'Recherche hybride (BM25 + vectoriel)', 'Reciprocal Rank Fusion', 'trafilatura', 'PyMuPDF', 'Docker Compose']::text[],
  main_image = '/images/projects/bora-rag-joytrain/coach.png',
  images = ARRAY['/images/projects/bora-rag-joytrain/pipeline.svg']::text[],
  updated_at = now()
WHERE slug = 'bora-rag-joytrain';

-- ===== joytrain-site-vitrine =====
UPDATE projects SET
  short_description = 'Le site vitrine de l''application JoyTrain : rapide, soigné et responsive, pensé pour présenter le produit et donner envie de l''installer.',
  long_description = 'Le site vitrine de l''application JoyTrain : rapide, soigné et responsive, pensé pour présenter le produit et donner envie de l''installer.',
  context = 'Une bonne application sans page qui la présente, c''est personne qui l''installe. JoyTrain, l''app de coaching sportif, avait besoin d''une vitrine où l''on comprend en un coup d''œil ce que fait le produit, et où l''on trouve les pages légales exigées par l''App Store et Google Play. Je voulais un site rapide et propre, qui inspire confiance dès la première seconde. C''est l''une des trois briques de l''écosystème JoyTrain (l''app, le moteur de coaching IA Bora, et ce site vitrine).',
  goal = 'Donner à JoyTrain une vitrine claire et crédible : présenter les fonctionnalités avec de vrais écrans, donner envie d''installer l''app, et fournir les pages légales nécessaires à sa publication sur les stores.',
  features = ARRAY['Une landing claire qui présente l''app et ses fonctionnalités en un coup d''œil', 'De vraies captures de l''app mises en valeur dans un cadre de téléphone élégant', 'Des animations discrètes au scroll qui rendent la page vivante sans l''alourdir', '100% responsive : impeccable du mobile au grand écran', 'Chargement quasi instantané, sans superflu', 'Pages confidentialité, CGU et contact conformes RGPD', 'Une identité de marque cohérente : couleurs, logo, typographie soignée', 'Optimisé pour le partage social et le référencement']::text[],
  architecture = 'Site 100% statique en HTML5 et Tailwind CSS, sans build ni dépendance lourde : ultra-rapide et facile à héberger. Les animations reposent sur de simples keyframes CSS et l''IntersectionObserver natif. Déploiement statique avec HTTPS forcé et en-têtes de sécurité de base.',
  challenges = NULL,
  results = 'Une vitrine légère, rapide et soignée, livrée en quelques fichiers et sans maintenance technique. Le projet montre que je sais concevoir un site qui présente clairement un produit, donne envie d''agir, et reste irréprochable sur la performance comme sur la conformité légale.',
  future_improvements = NULL,
  technologies = ARRAY['HTML5', 'Tailwind CSS', 'JavaScript', 'IntersectionObserver API', 'CSS Keyframes', 'SVG', 'Google Fonts (Inter)', 'Open Graph', 'Responsive design', 'Netlify', 'RGPD']::text[],
  main_image = '/images/projects/joytrain-site-vitrine/og-image.png',
  images = ARRAY['/images/projects/joytrain-site-vitrine/screen-accueil.png', '/images/projects/joytrain-site-vitrine/screen-nutrition.png', '/images/projects/joytrain-site-vitrine/screen-bora.png']::text[],
  updated_at = now()
WHERE slug = 'joytrain-site-vitrine';

-- ===== mmanima =====
UPDATE projects SET
  short_description = 'Une application mobile pour suivre et piloter ses crypto-actifs en temps réel, avec des alertes intelligentes et des stratégies validées par la science plutôt que promises.',
  long_description = 'Une application mobile pour suivre et piloter ses crypto-actifs en temps réel, avec des alertes intelligentes et des stratégies validées par la science plutôt que promises.',
  context = 'J''investis en crypto et je voulais un vrai outil pour suivre mon portefeuille et décider sereinement, sans me fier aux promesses des produits du marché. J''ai donc construit une application mobile connectée à mon compte Binance, doublée d''un laboratoire de recherche pour répondre à la question qui m''obsédait : peut-on réellement prédire le marché ? J''ai cherché la réponse honnêtement, quitte à ce qu''elle ne me plaise pas.',
  goal = 'Me donner un outil complet pour suivre mes crypto-actifs en temps réel, recevoir des alertes pertinentes, et n''utiliser que les stratégies qui tiennent vraiment la route une fois les frais déduits.',
  features = ARRAY['Suivi en temps réel du portefeuille Binance (spot, futures, épargne)', 'Connexion sécurisée du compte avec clés API chiffrées', 'Alertes techniques personnalisables (RSI, MACD, Bollinger, croisements de moyennes)', 'Notifications push instantanées dès qu''un signal se déclenche', 'Graphiques et bougies clairs directement dans l''application', 'Mode simulation et backtests pour tester une stratégie sans risque', 'Stratégies validées intégrées : protection en marché baissier et rendement market-neutral']::text[],
  architecture = 'Application mobile Flutter (Android, iOS, web) sur un backend FastAPI connecté à Binance, avec clés chiffrées, alertes évaluées en continu et notifications push. Un second volet de recherche en machine learning (PyTorch, modèles TFT et CNN-LSTM) avec validation rigoureuse alimente les stratégies intégrées à l''application.',
  challenges = NULL,
  results = 'Plutôt que de promettre une IA miracle, j''ai prouvé scientifiquement (test de permutation, détection de fuite de données) que prédire la direction du marché n''apporte aucun avantage réel une fois les frais payés. J''ai assumé ce constat et pivoté vers des stratégies réellement validées par backtest : couverture en marché baissier et rendement neutre d''environ 5 %/an. Le projet démontre ma rigueur et mon honnêteté intellectuelle face à un sujet complexe.',
  future_improvements = NULL,
  technologies = ARRAY['Flutter', 'Dart', 'FastAPI', 'Python', 'PostgreSQL', 'Redis', 'Binance API', 'Firebase Cloud Messaging', 'PyTorch', 'Temporal Fusion Transformer (TFT)', 'CNN-LSTM', 'LightGBM', 'MLflow', 'Docker']::text[],
  main_image = '/images/projects/mmanima/logo.png',
  images = ARRAY['/images/projects/mmanima/strategie.svg']::text[],
  updated_at = now()
WHERE slug = 'mmanima';

-- ===== robot-suiveur-de-ligne-gamel-trophy =====
UPDATE projects SET
  short_description = 'Un robot autonome qui suit une ligne tout seul, conçu de A à Z avec mon équipe pour une compétition de robotique.',
  long_description = 'Un robot autonome qui suit une ligne tout seul, conçu de A à Z avec mon équipe pour une compétition de robotique.',
  context = 'C''était mon initiation à l''électronique embarquée et au C++, au tout début de mes études. Avec mon équipe à l''IUT, on s''est lancé un vrai défi : concevoir un robot capable de courir seul sur une piste pour une compétition. Pas de tutoriel, juste un cahier des charges, une deadline et l''envie de voir notre machine franchir la ligne d''arrivée.',
  goal = 'Construire de zéro un robot autonome capable de suivre une piste, repérer les raccourcis et la parcourir le plus vite possible, en équipe et dans les délais imposés.',
  features = ARRAY['Robot qui démarre et roule en totale autonomie', 'Suivi de ligne fluide, sans partir dans tous les sens', 'Détection des raccourcis pour gagner du temps sur le circuit', 'Carte électronique maison, conçue et fabriquée de bout en bout', 'Réglage de la vitesse à la volée selon la piste', 'Robot validé sur le terrain, en conditions de course réelles']::text[],
  architecture = 'J''ai pris en charge la carte moteur de bout en bout : schéma et routage du circuit imprimé sous KiCad, gravure, soudure, puis tests au multimètre. Côté logiciel, j''ai programmé le robot en C++ : lecture des capteurs et automates d''états pour le suivi de ligne et la détection des raccourcis. Du premier croquis jusqu''au robot qui roule.',
  challenges = NULL,
  results = 'Le robot a fonctionné et s''est qualifié en phase finale avec un chrono de 46 secondes. Au-delà du résultat, ce projet prouve que je sais mener une réalisation technique complète, du matériel au logiciel, en équipe et jusqu''au bout.',
  future_improvements = NULL,
  technologies = ARRAY['C++', 'KiCad', 'Routage PCB', 'Électronique embarquée', 'Soudure', 'Carte moteur', 'Capteurs CNY70', 'Moteurs DC', 'Automate d''états', 'Robotique', 'Tests et validation', 'Travail en équipe']::text[],
  main_image = '/images/projects/robot-suiveur-de-ligne-gamel-trophy/robot-rendu.jpg',
  images = ARRAY['/images/projects/robot-suiveur-de-ligne-gamel-trophy/vue-c.jpg', '/images/projects/robot-suiveur-de-ligne-gamel-trophy/pcb-carte-moteur.png', '/images/projects/robot-suiveur-de-ligne-gamel-trophy/robot-1.jpg', '/images/projects/robot-suiveur-de-ligne-gamel-trophy/schema-kicad.png', '/images/projects/robot-suiveur-de-ligne-gamel-trophy/vue-a.jpg', '/images/projects/robot-suiveur-de-ligne-gamel-trophy/schema-synoptique.png', '/images/projects/robot-suiveur-de-ligne-gamel-trophy/robot-5.jpg', '/images/projects/robot-suiveur-de-ligne-gamel-trophy/robot-2.jpg', '/images/projects/robot-suiveur-de-ligne-gamel-trophy/robot-3.jpg', '/images/projects/robot-suiveur-de-ligne-gamel-trophy/robot-4.jpg', '/images/projects/robot-suiveur-de-ligne-gamel-trophy/vue-b.jpg']::text[],
  updated_at = now()
WHERE slug = 'robot-suiveur-de-ligne-gamel-trophy';

-- ===== portfolio-personnel =====
UPDATE projects SET
  short_description = 'Mon portfolio : un site vitrine complet que je gère moi-même, de la page d''accueil jusqu''au formulaire de contact.',
  long_description = 'Mon portfolio : un site vitrine complet que je gère moi-même, de la page d''accueil jusqu''au formulaire de contact.',
  context = 'Je voulais un endroit clair pour montrer mon travail et permettre à un client de me contacter facilement. Mais surtout, pouvoir tout mettre à jour seul — ajouter un projet, modifier mon parcours, changer une image — sans jamais retoucher au code. Je l''ai donc conçu comme je le ferais pour un client : une vitrine soignée d''un côté, un espace d''administration privé de l''autre.',
  goal = 'Donner à n''importe quel visiteur une lecture immédiate de qui je suis et de ce que je sais faire, tout en gardant la main pour gérer chaque contenu en autonomie.',
  features = ARRAY['Un site public immersif : accueil, projets, parcours, compétences, contact', 'Un espace d''administration privé pour tout gérer sans toucher au code', 'Ajout, modification et suppression des projets, études et expériences', 'Gestion des images et vidéos directement depuis l''interface', 'Un formulaire de contact qui m''envoie les messages par e-mail', 'Des fiches projet détaillées avec médias et descriptions riches', 'Un accès admin protégé par mot de passe sécurisé']::text[],
  architecture = 'Application web complète en Node.js / Express, vues EJS et base PostgreSQL structurée, avec médias hébergés sur Cloudinary. La sécurité repose sur des sessions persistées, une protection CSRF, des mots de passe hachés (bcrypt) et une limitation des tentatives. Le tout pensé pour un déploiement Docker auto-hébergé.',
  challenges = NULL,
  results = 'Ce projet montre que je livre une application web de bout en bout : l''interface publique que voit le client, le back-office qui la pilote, la base de données qui la structure et le déploiement qui la met en ligne. Un seul interlocuteur, du design à la mise en production.',
  future_improvements = NULL,
  technologies = ARRAY['Node.js', 'Express', 'EJS', 'PostgreSQL', 'Cloudinary', 'Bootstrap 5', 'Sass', 'Sessions / CSRF', 'bcrypt', 'Nodemailer', 'Docker', 'Jest']::text[],
  main_image = '/images/projects/portfolio-personnel/cover.svg',
  images = '{}'::text[],
  updated_at = now()
WHERE slug = 'portfolio-personnel';

-- Masque les longues sections (non destructif, réactivable via l'admin)
UPDATE project_sections SET is_visible = false, updated_at = now()
WHERE project_id IN (SELECT id FROM projects WHERE slug IN ('joytrain', 'bora-rag-joytrain', 'joytrain-site-vitrine', 'mmanima', 'robot-suiveur-de-ligne-gamel-trophy', 'portfolio-personnel'));

COMMIT;
