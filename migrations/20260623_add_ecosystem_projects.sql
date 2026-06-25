-- Migration auto-générée : intégration des projets JoyTrain (app), Bora (RAG), vitrine JoyTrain et MManima.
-- Idempotente : upsert par slug (projects) et par (project_id, title) (sections).
BEGIN;

-- ===================== JoyTrain — Application fitness, nutrition & coach IA =====================
INSERT INTO projects (name, slug, category, status, short_description, long_description, goal, context, architecture, challenges, results, future_improvements, github_url, demo_url, start_date, end_date, features, technologies)
VALUES (
  'JoyTrain — Application fitness, nutrition & coach IA',
  'joytrain',
  'mobile',
  'in_progress',
  'Application mobile fitness, nutrition et coach IA bâtie sur un monorepo Flutter + FastAPI, avec scan de repas par vision, coach data-aware branché à un moteur RAG, couche sociale complète et déploiement Docker auto-hébergé en UE.',
  'JoyTrain (package Flutter "joyfit", monorepo "MakasiFit") est une application mobile fitness/nutrition complète que je développe de bout en bout : app Flutter, backend FastAPI et back-office React. Le backend regroupe une trentaine de modules métier (entraînements, routines, programmes, cardio, records personnels, recettes et nutrition adossées à la base Ciqual 2020, suppléments, plans hebdomadaires, médias, quotas) doublés d''une vraie couche sociale (posts, commentaires, likes, amis, messagerie, communauté, notifications temps réel, badges, signalements/modération). Côté IA, "Bora" est un coach data-aware qui répond aux questions de l''utilisateur en s''appuyant sur son contexte personnel et sur un moteur RAG hébergé dans un dépôt séparé, le tout exécuté de façon asynchrone dans un worker arq avec streaming des tokens vers le mobile par WebSocket. Le scan de repas par photo combine un modèle de vision (Gemini par défaut, replis Mistral et Ollama qwen2.5vl) et un matching sémantique d''ingrédients via des embeddings bge-m3 calculés en local par Ollama et une recherche vectorielle pgvector. L''app est pensée offline-first : une file d''écriture durable (drift/SQLite) rejoue les mutations au retour réseau avec des clés d''idempotence côté serveur pour éviter doublons et pertes. L''ensemble se déploie sur une VM OVH en UE via Docker Compose et Caddy (HTTPS automatique), avec un CD GitHub Actions qui teste, déploie par SSH, applique les migrations Alembic et vérifie la santé du service. Techniquement, le projet est intéressant par sa surface fonctionnelle, son architecture multi-services (web/worker/RAG/embeddings/deux bases pgvector) et son souci constant de RGPD et de robustesse réseau.',
  'Offrir une application mobile tout-en-un — entraînement, nutrition et coach IA personnalisé — accompagnée d''une couche sociale, en maîtrisant l''intégralité de la chaîne technique du mobile jusqu''au déploiement auto-hébergé en UE.',
  'JoyTrain est mon projet phare de fitness mobile, organisé en monorepo "MakasiFit" (app Flutter "joyfit", backend FastAPI, back-office React). Il s''inscrit dans un écosystème de trois projets liés que je développe : (1) l''application JoyTrain elle-même (mobile + backend), (2) "Bora", le moteur RAG/IA hébergé dans le dépôt séparé RAG_JoyTrain qui alimente le coach data-aware, et (3) le site vitrine du produit dans le dépôt joytrain-website. Le projet est en cours, avec des sorties prévues sur les stores (TestFlight iOS et Play Console Android) et une infrastructure de test déjà déployée en UE.',
  'Monorepo à trois applications. Frontend : app mobile Flutter/Dart (riverpod pour l''état, dio + intercepteurs pour l''API, go_router pour la navigation, fl_chart pour les graphiques, flutter_body_atlas pour l''atlas musculaire, drift/SQLite pour le cache et la file offline, flutter_secure_storage pour les jetons, flutter_local_notifications, web_socket_channel pour le temps réel). Backend : FastAPI/uvicorn (environ 338 fichiers Python) structuré en une trentaine de modules métier, SQLAlchemy 2 asynchrone (asyncpg) + Alembic (63 migrations), PostgreSQL avec extension pgvector, Redis (cache, pub/sub temps réel, rate limiting slowapi, file de jobs). Un worker async "arq" exécute Bora (génération de programmes et réponses du coach) hors du cycle requête/réponse et pousse les tokens par WebSocket via un canal Redis pub/sub multi-instance. Stockage des médias abstrait (disque local ou S3-compatible R2/Scaleway/OVH/MinIO) avec URLs signées. Monitoring d''erreurs Sentry optionnel. Back-office : SPA React 18 + Vite + MUI (admin/modération/stats) pointant sur l''API. IA : modèle de vision pour le scan de repas (Gemini par défaut, replis Mistral et Ollama qwen2.5vl), embeddings bge-m3 via Ollama pour le matching sémantique d''ingrédients, et le coach Bora branché au service RAG externe. Déploiement : une VM OVH en UE, Docker Compose orchestrant Caddy (reverse-proxy + HTTPS Let''s Encrypt auto), backend, worker, admin, service RAG, Ollama, deux PostgreSQL pgvector (app + RAG) et Redis — seuls les ports 80/443 sont exposés, le reste communique sur le réseau Docker privé.',
  'Le principal défi fonctionnel a été le mode offline-first : permettre à l''utilisateur d''enregistrer ses séances sans réseau, puis de rejouer les mutations à la reconnexion sans créer de doublons ni perdre les identifiants générés côté serveur. J''ai résolu cela avec une file d''écriture durable (Outbox en drift) côté Flutter et un mécanisme d''idempotence côté FastAPI : le client envoie une clé d''idempotence stable, le serveur mémorise (user, clé) → réponse sérialisée et renvoie le résultat à l''identique sur rejeu, en exposant aussi les id des entités imbriquées (ex. les séries d''un workout) pour que le client remappe ses id temporaires. Côté IA, faire répondre Bora sans bloquer l''API a imposé de sortir les appels longs dans un worker arq, avec streaming SSE depuis le RAG converti en tokens WebSocket et un pseudo-streaming de repli si l''endpoint streaming n''existe pas. Le scan de repas a demandé d''orchestrer plusieurs fournisseurs de vision avec replis et un matching sémantique robuste (embeddings bge-m3 + recherche pgvector) tout en gardant les données en local pour le RGPD. Enfin, l''auto-hébergement multi-services (deux bases pgvector, Ollama, RAG, worker) sur une seule VM a nécessité un déploiement idempotent : migrations Alembic en conteneur jetable avant bascule, seeds additifs qui ne détruisent pas les éditions admin, reload Caddy explicite et healthcheck actif.',
  'L''application est fonctionnelle et riche : une trentaine de modules backend couvrant entraînement, nutrition (base Ciqual 2020), social et IA, une app Flutter offline-first et un back-office de modération. La chaîne CI/CD est opérationnelle (tests Flutter + pytest sur une base Postgres pgvector éphémère, puis déploiement continu par SSH sur la VM OVH avec migrations et healthcheck). L''infrastructure de test est déployée en UE derrière Caddy (HTTPS automatique) sur api.joytrain.app et admin.joytrain.app, avec le coach Bora, le scan de repas par vision et le temps réel en place. Le projet est prêt pour une phase de test sur stores.',
  '- Publier l''app sur les stores : TestFlight iOS et Google Play Console.
- Approfondir le moteur RAG "Bora" (dépôt RAG_JoyTrain) et son ancrage sur le contexte personnel de l''utilisateur.
- Mettre en place le paiement et l''activation réelle du plan premium au-delà du système de quotas et d''entitlements déjà présent.
- Renforcer le passage vision 100 % UE (Mistral en primaire) pour le scan de repas.
- Étendre la couverture des tests automatisés au-delà du sous-ensemble portable exécuté en CI.',
  'https://github.com/Hezuko/MakasiFit',
  NULL,
  DATE '2026-05-11',
  NULL,
  ARRAY['Suivi d''entraînement complet : exercices, muscles, routines, programmes, séances actives et records personnels', 'Génération de programmes par l''IA Bora (data-aware) exécutée en worker asynchrone', 'Coach IA conversationnel Bora branché à un moteur RAG, avec réponses streamées en temps réel par WebSocket', 'Scan de repas par photo via un modèle de vision (Gemini par défaut, replis Mistral et Ollama qwen2.5vl)', 'Matching sémantique d''ingrédients par embeddings bge-m3 (Ollama) et recherche vectorielle pgvector', 'Module nutrition adossé à la base alimentaire Ciqual 2020 (catalogue d''ingrédients et macros)', 'Recettes, suppléments, plans hebdomadaires, cardio et récapitulatifs', 'Couche sociale : posts, commentaires, likes, amis, communauté, blocages et mutes', 'Messagerie et notifications temps réel via Redis pub/sub et WebSocket multi-instance', 'Système de badges et de gamification', 'Signalements et modération via un back-office React dédié', 'Système de quotas et d''entitlements (limites gratuites vs premium) sur Bora, scans et programmes', 'Mode offline-first : file d''écriture durable (drift/SQLite) rejouée au retour réseau avec idempotence serveur', 'Atlas musculaire interactif, graphiques de progression et journaux de poids', 'Stockage de médias abstrait (disque local ou S3-compatible) avec URLs signées temporaires', 'Déploiement auto-hébergé en UE via Docker Compose + Caddy (HTTPS auto) et CD GitHub Actions']::text[],
  ARRAY['Flutter', 'Dart', 'Riverpod', 'dio', 'go_router', 'drift', 'fl_chart', 'FastAPI', 'Python', 'SQLAlchemy 2', 'Alembic', 'PostgreSQL', 'pgvector', 'Redis', 'arq', 'Ollama', 'bge-m3', 'Gemini', 'Mistral', 'React', 'Vite', 'MUI', 'Docker Compose', 'Caddy', 'GitHub Actions', 'Sentry']::text[]
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
  future_improvements = EXCLUDED.future_improvements,
  github_url = EXCLUDED.github_url,
  demo_url = EXCLUDED.demo_url,
  start_date = EXCLUDED.start_date,
  end_date = EXCLUDED.end_date,
  features = EXCLUDED.features,
  technologies = EXCLUDED.technologies,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Un monorepo, trois applications', 'Mobile, backend et back-office', 'Le dépôt MakasiFit regroupe trois applications que je développe ensemble :
- L''app mobile Flutter/Dart (package "joyfit") : riverpod pour l''état, dio pour l''API, go_router pour la navigation, fl_chart pour les graphiques de progression et flutter_body_atlas pour l''atlas musculaire.
- Le backend FastAPI (environ 338 fichiers Python) découpé en une trentaine de modules métier, avec SQLAlchemy 2 asynchrone, Alembic (63 migrations) et PostgreSQL/pgvector.
- Le back-office web React 18 + Vite + MUI, dédié à l''administration, à la modération et aux statistiques, qui pointe sur l''API.
Cette organisation me permet de garder une cohérence forte entre les contrats d''API, le mobile et l''outillage d''admin.', 'architecture', 'text_only', 1, true
FROM projects WHERE slug = 'joytrain'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Écosystème JoyTrain', 'Trois dépôts liés', 'JoyTrain fait partie d''un ensemble de trois projets que je conçois comme un produit unique :
- L''application JoyTrain (ce dépôt MakasiFit) : l''app mobile Flutter et son backend FastAPI, qui portent toute l''expérience utilisateur.
- Bora : le moteur RAG/IA, hébergé dans le dépôt séparé RAG_JoyTrain (joytrain_rag_collector). C''est lui qui alimente le coach conversationnel ; le backend l''appelle en HTTP/SSE depuis le worker pour répondre aux questions de l''utilisateur.
- Le site vitrine, dans le dépôt joytrain-website, qui présente le produit publiquement.
Dans le docker-compose de production, le service RAG est d''ailleurs construit directement depuis le dépôt RAG_JoyTrain et tourne aux côtés du backend, ce qui matérialise le lien technique entre les trois projets.', 'text', 'text_only', 2, true
FROM projects WHERE slug = 'joytrain'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Bora, le coach IA data-aware', 'RAG, worker asynchrone et streaming', 'Bora est le coach IA de JoyTrain. Pour ne jamais bloquer l''API pendant les appels longs, je l''exécute dans un worker arq (file de jobs Redis), séparé du process web.
- Le worker interroge le moteur RAG externe et tente d''abord un streaming SSE ; si l''endpoint de streaming n''existe pas, il bascule sur un pseudo-streaming de repli.
- Les tokens générés sont poussés vers le mobile en temps réel via WebSocket, relayés sur un canal Redis pub/sub pour fonctionner en multi-instance.
- Bora s''appuie sur le contexte personnel de l''utilisateur pour les questions personnelles, et sert aussi à générer des programmes d''entraînement.
- Un système de quotas et d''entitlements encadre l''usage (limites gratuites vs premium) avec remboursement du quota en cas d''échec.', 'step', 'text_only', 3, true
FROM projects WHERE slug = 'joytrain'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Scan de repas et nutrition Ciqual', 'Vision multimodale et recherche vectorielle', 'Le scan de repas combine plusieurs briques :
- Un modèle de vision analyse la photo (Gemini 2.5 Flash par défaut, avec replis Mistral et Ollama qwen2.5vl), avec garde-fous sur le type et la taille d''image.
- Les libellés détectés sont vectorisés par des embeddings bge-m3 calculés en local via Ollama, puis appariés aux ingrédients par recherche vectorielle pgvector — sans envoyer de données à un service externe pour cette étape.
- Le catalogue d''ingrédients et les valeurs nutritionnelles proviennent en grande partie de la base alimentaire française Ciqual 2020, importée via des scripts dédiés, avec préservation des codes et constituants bruts pour la traçabilité.
L''utilisateur obtient ainsi une estimation des macros à partir d''une simple photo.', 'step', 'text_only', 4, true
FROM projects WHERE slug = 'joytrain'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Offline-first et idempotence', 'Robustesse réseau côté mobile et serveur', 'L''app est pensée pour fonctionner sans réseau, ce qui m''a demandé un travail particulier sur la fiabilité des écritures :
- Côté Flutter, une file d''écriture durable (Outbox, stockée en drift/SQLite) enregistre chaque mutation faite hors-ligne ; un moteur de synchronisation la draine au retour réseau, avec gestion de dépendances entre opérations et id temporaires locaux.
- Côté FastAPI, chaque opération porte une clé d''idempotence (UUID) stable. Une route personnalisée (IdempotentRoute) mémorise (user, clé) → réponse sérialisée : tout rejeu renvoie la réponse à l''identique sans ré-exécuter le handler, et expose les id des entités imbriquées (ex. les séries d''un workout) pour permettre au client de remapper ses id temporaires.
Résultat : pas de doublon, pas de perte de données, même si une réponse réseau est perdue.', 'challenge', 'text_only', 5, true
FROM projects WHERE slug = 'joytrain'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Déploiement auto-hébergé en UE', 'Docker Compose, Caddy et CD GitHub Actions', 'Toute la stack tourne sur une VM OVH en UE, orchestrée par Docker Compose :
- Caddy fait office de reverse-proxy avec HTTPS automatique (Let''s Encrypt) sur api.joytrain.app et admin.joytrain.app ; seuls les ports 80/443 sont exposés, tout le reste communique sur le réseau Docker privé.
- Les services : backend, worker arq, back-office admin, service RAG, Ollama (embeddings bge-m3), deux PostgreSQL pgvector (app et RAG) et Redis.
- Le CD GitHub Actions lance d''abord les tests (Flutter + pytest sur une base Postgres pgvector éphémère), puis, sur la branche principale et uniquement si le backend/deploy a changé, déploie par SSH.
- Le script deploy.sh est idempotent : build des images, migrations Alembic dans un conteneur jetable avant bascule, seeds additifs qui préservent les éditions admin, reload explicite de Caddy et healthcheck actif sur /health.
Le choix UE et la non-fuite de données perso (Sentry sans PII, médias privés signés) traduisent une prise en compte du RGPD.', 'result', 'text_only', 6, true
FROM projects WHERE slug = 'joytrain'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

-- ===================== Bora — Moteur RAG du coach IA JoyTrain =====================
INSERT INTO projects (name, slug, category, status, short_description, long_description, goal, context, architecture, challenges, results, future_improvements, github_url, demo_url, start_date, end_date, features, technologies)
VALUES (
  'Bora — Moteur RAG du coach IA JoyTrain',
  'bora-rag-joytrain',
  'ai',
  'in_progress',
  'Bora est le moteur RAG en Python qui alimente le coach IA de JoyTrain : un pipeline qui collecte des sources fitness, nutrition et santé de référence, les vectorise avec BAAI/bge-m3 et les sert via une recherche hybride BM25 + pgvector.',
  'Bora est le système de Retrieval-Augmented Generation construit pour donner au coach IA de JoyTrain des réponses ancrées dans des sources fiables (OMS, ISSN, OpenStax, ACSM...) plutôt que dans les hallucinations d''un LLM. Le projet est un pipeline Python complet : collecte de documents publics (PDF et HTML) avec respect du robots.txt et suivi des métadonnées de licence, extraction du texte (trafilatura pour le HTML, PyMuPDF pour le PDF), découpage en chunks de ~1200 caractères avec 180 de recouvrement et coupures intelligentes sur les frontières de paragraphes et de phrases. Chaque chunk porte des métadonnées riches (titre, éditeur, sujet, catégorie, audience, priorité RAG, statut de licence). Les chunks sont vectorisés avec le modèle open source multilingue BAAI/bge-m3 (1024 dimensions, embeddings normalisés, exécuté en local via sentence-transformers et PyTorch, sur CPU, CUDA ou MPS) puis stockés dans PostgreSQL avec l''extension pgvector et des métadonnées JSONB. La recherche existe en deux modes : sémantique pure par distance cosinus, et hybride qui fusionne BM25 (rank-bm25) et le vectoriel par Reciprocal Rank Fusion, ce qui rattrape les termes exacts comme « créatine », « leucine » ou « 1RM » que le vectoriel seul rate parfois. L''ensemble est validé par des modèles Pydantic, traçable via manifest/summary/errors JSON, évaluable par un script de recall sur un petit jeu de questions étiquetées, et reproductible grâce à Docker Compose (image pgvector). Tout est conçu pour rester éthique : pas de contournement de paywall, de DRM ni d''authentification, et can_redistribute reste à false tant qu''une licence ne l''autorise pas explicitement.',
  'Doter le coach IA de JoyTrain d''une base de connaissances fitness, nutrition et santé fiable et citable, en construisant un pipeline RAG open source de bout en bout (collecte, extraction, chunking, embeddings, indexation pgvector et recherche hybride) sans dépendre d''API propriétaires.',
  'Bora est l''un des trois projets de l''écosystème JoyTrain, qui comprend aussi l''application JoyTrain elle-même (app mobile Flutter et son backend) et le site vitrine JoyTrain. Le coach IA de l''application avait besoin de répondre à des questions d''entraînement et de nutrition sans inventer : toute la couche « connaissance » a donc été isolée dans ce dépôt dédié, autour du sous-dossier joytrain_rag_collector. L''objectif était d''avoir un moteur de récupération autonome, alimenté par des sources de référence reconnues, qui se branche ensuite sur le backend du coach. Le projet est en cours et a été amorcé fin mai 2026.',
  'L''architecture suit un pipeline linéaire en étapes scriptées, chacune dans un module Python dédié. La validation (validate_sources.py) contrôle le fichier sources.json avec Pydantic. La collecte (collect_rag_sources.py) télécharge chaque ressource via le downloader (retries à backoff exponentiel et délai configurable), vérifie optionnellement le robots.txt via urllib.robotparser (option --respect-robots), déduplique par sha256, refuse les pages à paywall évident, puis détecte le type (PDF/HTML). L''extraction est déléguée à PyMuPDF (fitz) pour les PDF — avec détection des PDF scannés via un flag needs_ocr lorsque le texte extrait est trop faible — et à trafilatura pour le HTML, avec un repli BeautifulSoup (parseur lxml) si trafilatura échoue. Le chunker découpe le texte en fenêtres glissantes (chunk_size 1200, overlap 180) en cherchant la meilleure coupe sur un paragraphe, sinon une phrase, sinon un espace. Chaque chunk devient un objet Pydantic Chunk avec toutes ses métadonnées, et la collecte produit un manifest.json, un summary.json, un errors.json et un rag_chunks_all.json. L''export (export_for_pgvector.py) transforme les chunks en JSONL { source_id, chunk_index, text, metadata }. L''import (embed_and_import_pgvector.py) charge le modèle d''embedding via une abstraction de provider (local sentence-transformers par défaut, OpenAI en option, Ollama réservé), crée la table avec une colonne embedding vector(1024), des colonnes typées et un metadata JSONB, des index B-tree (source_id, topic, category) et GIN (metadata), gère l''idempotence via UNIQUE(source_id, chunk_index) et un id UUID5 stable. La recherche sémantique (search_rag.py) s''appuie sur l''opérateur de distance pgvector <=>, et hybrid_search.py combine ce résultat avec un classement BM25 (rank-bm25) calculé en mémoire sur title/publisher/topic/category/text, les deux listes étant fusionnées par Reciprocal Rank Fusion (rrf_k=60). PostgreSQL + pgvector tournent via Docker Compose (image pgvector/pgvector:pg16).',
  'Le principal défi était de capter à la fois le sens et les termes techniques exacts : un embedding seul rate souvent des mots rares mais critiques (« créatine », « leucine », « 1RM », noms d''organismes), d''où une recherche hybride BM25 + vectorielle fusionnée par Reciprocal Rank Fusion. Deuxième difficulté : rester légalement et éthiquement propre — modéliser finement les statuts d''accès et de licence (open_access, check_before_use, reference_only...), forcer manual_review_required quand la licence l''exige via un validateur Pydantic, garder can_redistribute=false par défaut, refuser les pages à paywall détecté et respecter le robots.txt sans jamais contourner paywalls, DRM ou authentification. Troisième point : la portabilité matérielle des embeddings, avec une résolution automatique du device (CUDA, MPS sur Apple Silicon, sinon CPU) et une validation systématique de la dimension 1024 pour éviter toute incohérence entre le modèle et le schéma de la table. Enfin, garantir l''idempotence de l''import (UUID5 stable, ON CONFLICT, détection d''une table existante de dimension différente) pour pouvoir relancer le pipeline sans dupliquer ni casser la base.',
  'Le pipeline est fonctionnel de bout en bout : sur le lot de sources de référence, la collecte a produit 546 chunks issus des documents collectés avec succès — principalement l''OMS (367 chunks, PDF des recommandations sur l''activité physique), l''ISSN (163 chunks, position stand protéines), OpenStax (12 chunks d''anatomie et physiologie) et une source ACSM placée en revue manuelle (4 chunks) ; plusieurs autres sources (NSCA, CDC, NIH, BJSM) ont échoué au téléchargement et sont tracées dans errors.json. Les chunks sont exportés puis indexables dans PostgreSQL/pgvector avec leurs métadonnées. La recherche sémantique et la recherche hybride BM25 + RRF sont opérationnelles et interrogeables en ligne de commande, avec sortie JSON exploitable par une application. Un script d''évaluation mesure le recall@k sur un jeu de questions fitness étiquetées. L''environnement est reproductible via Docker Compose, et toute la chaîne fonctionne sans clé API grâce aux embeddings locaux BAAI/bge-m3. Le moteur est destiné à être consommé par le backend du coach IA de JoyTrain.',
  'Plusieurs pistes restent ouvertes : exposer la recherche derrière une API HTTP plutôt qu''en seul CLI pour faciliter la consommation par le backend du coach ; ajouter un index vectoriel approché (IVFFlat/HNSW) pour passer à l''échelle au lieu du scan exact actuel ; déplacer le scoring BM25 côté base (full-text PostgreSQL) au lieu du calcul en mémoire qui recharge tout le corpus à chaque requête ; ajouter l''OCR pour les PDF scannés (aujourd''hui simplement signalés par needs_ocr) ; implémenter le provider d''embeddings Ollama, aujourd''hui réservé mais non encore codé ; fiabiliser la collecte des sources actuellement en erreur (NSCA, CDC, NIH, BJSM) ; et élargir le jeu d''évaluation pour suivre la qualité de retrieval dans le temps.',
  'https://github.com/Hezuko/RAG_JoyTrain',
  NULL,
  DATE '2026-05-26',
  NULL,
  ARRAY['Collecte de documents publics PDF et HTML à partir d''un fichier de sources structuré', 'Respect optionnel du robots.txt avant téléchargement (urllib.robotparser, option --respect-robots)', 'Suivi des métadonnées de licence et d''accès (license_status, access_status, can_redistribute, manual_review_required)', 'Téléchargement résilient avec retries à backoff exponentiel, délai configurable et déduplication par sha256', 'Refus des pages à paywall détecté, sans contournement de paywall, DRM ni authentification', 'Extraction de texte HTML via trafilatura avec repli BeautifulSoup (parseur lxml)', 'Extraction de texte PDF via PyMuPDF avec détection des PDF scannés (flag needs_ocr)', 'Chunking intelligent ~1200 caractères / 180 de recouvrement avec coupures sur paragraphes, phrases puis espaces', 'Métadonnées riches par chunk (titre, éditeur, sujet, catégorie, audience, priorité RAG, statut de licence)', 'Validation des données par modèles Pydantic (Source, Chunk, ManifestItem)', 'Embeddings locaux open source BAAI/bge-m3 (1024 dimensions, multilingues, normalisés) via sentence-transformers', 'Sélection automatique du device d''inférence (CUDA / MPS / CPU)', 'Stockage vectoriel dans PostgreSQL + pgvector avec métadonnées JSONB et index B-tree/GIN', 'Recherche sémantique par distance cosinus pgvector (opérateur <=>)', 'Recherche hybride BM25 + vectorielle fusionnée par Reciprocal Rank Fusion (rrf_k=60)', 'Import idempotent (UUID5 stable, ON CONFLICT, contrôle de la dimension de la table existante)', 'Manifest, summary et errors en JSON pour la traçabilité de chaque collecte', 'Script d''évaluation du recall@k sur un jeu de questions fitness étiquetées', 'Environnement reproductible via Docker Compose (image pgvector/pgvector:pg16)', 'Abstraction de provider d''embeddings (local par défaut, OpenAI en option, Ollama réservé), sans clé API requise par défaut']::text[],
  ARRAY['Python', 'BAAI/bge-m3', 'sentence-transformers', 'PyTorch', 'PostgreSQL', 'pgvector', 'psycopg', 'Pydantic', 'trafilatura', 'PyMuPDF', 'BeautifulSoup', 'lxml', 'rank-bm25', 'Reciprocal Rank Fusion', 'NumPy', 'Docker Compose', 'python-slugify', 'tqdm', 'python-dotenv', 'requests']::text[]
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
  future_improvements = EXCLUDED.future_improvements,
  github_url = EXCLUDED.github_url,
  demo_url = EXCLUDED.demo_url,
  start_date = EXCLUDED.start_date,
  end_date = EXCLUDED.end_date,
  features = EXCLUDED.features,
  technologies = EXCLUDED.technologies,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Le pipeline de bout en bout', 'De l''URL au vecteur interrogeable', 'Bora est organisé en étapes scriptées et indépendantes, ce qui rend chaque maillon testable et rejouable :
- Validation des sources : validate_sources.py contrôle le fichier sources.json avec Pydantic avant toute collecte.
- Collecte : collect_rag_sources.py télécharge chaque ressource (retries, délai configurable), vérifie optionnellement le robots.txt, déduplique par sha256 et détecte PDF vs HTML.
- Extraction : PyMuPDF pour les PDF, trafilatura (avec repli BeautifulSoup) pour le HTML.
- Chunking : découpage en fenêtres de ~1200 caractères avec 180 de recouvrement, sur des frontières propres.
- Export : export_for_pgvector.py génère un JSONL { source_id, chunk_index, text, metadata }.
- Embeddings + import : embed_and_import_pgvector.py vectorise et insère dans PostgreSQL/pgvector.
- Recherche : search_rag.py (sémantique) et hybrid_search.py (hybride BM25 + vectoriel).', 'step', 'text_only', 1, true
FROM projects WHERE slug = 'bora-rag-joytrain'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Embeddings et stockage vectoriel', 'BAAI/bge-m3 local + PostgreSQL/pgvector', 'Le choix s''est porté sur un modèle d''embedding open source, multilingue et exécutable en local, pour ne dépendre d''aucune API payante :
- Modèle : BAAI/bge-m3, 1024 dimensions, chargé via sentence-transformers et normalisé à l''encodage.
- Matériel : une fonction resolve_device choisit automatiquement CUDA, puis MPS (Apple Silicon), sinon CPU.
- Abstraction : une interface EmbeddingProvider permet de basculer vers OpenAI en option (Ollama est réservé mais non implémenté), le provider local restant le défaut.
- Base : table avec une colonne embedding vector(1024), des colonnes typées (source_id, title, url, publisher, topic, category...), un champ metadata JSONB, des index B-tree sur source_id/topic/category et un index GIN sur metadata.
- Robustesse : la dimension est validée à chaque étape pour éviter toute incohérence entre le modèle et le schéma.', 'architecture', 'text_only', 2, true
FROM projects WHERE slug = 'bora-rag-joytrain'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Recherche hybride BM25 + vectorielle', 'Reciprocal Rank Fusion pour capter le sens ET les termes exacts', 'La recherche purement sémantique passe parfois à côté de termes rares mais décisifs. La recherche hybride combine deux signaux puis les fusionne :
- Sémantique : pgvector classe les chunks par distance cosinus (opérateur <=>) sur l''embedding de la requête.
- Lexical : un BM25Okapi (rank-bm25) est calculé en mémoire sur les champs title, publisher, topic, category et text.
- Fusion : les deux classements sont combinés par Reciprocal Rank Fusion avec une constante de lissage rrf_k=60.
Ce mélange rattrape les requêtes contenant des termes exacts comme créatine, leucine, 1RM, caféine ou les noms d''organismes, là où le vectoriel seul est moins précis. La sortie est disponible en format lisible ou en JSON directement exploitable par une application.', 'challenge', 'text_only', 3, true
FROM projects WHERE slug = 'bora-rag-joytrain'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Collecte data-aware et éthique', 'Licences, robots.txt et zéro contournement', 'Construire une base de connaissances à partir de sources externes impose un cadre légal strict, modélisé dans le code :
- Chaque source porte un access_status et un license_status (open_access, check_before_use, reference_only...).
- Quand la licence l''impose, manual_review_required passe automatiquement à true via un validateur Pydantic.
- can_redistribute reste à false par défaut tant qu''une licence ne l''autorise pas explicitement.
- Le collecteur respecte le robots.txt (urllib.robotparser, option --respect-robots) et marque les URL interdites en skipped_robots_txt.
- Refus des pages à paywall détecté, aucun contournement de paywall, de DRM ni d''authentification, et pas de scraping agressif (délai configurable entre requêtes).
Les sources visées couvrent des références reconnues : OMS, ACSM, NSCA, CDC, OpenStax, NIH, ISSN, IOC.', 'text', 'text_only', 4, true
FROM projects WHERE slug = 'bora-rag-joytrain'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Traçabilité, évaluation et reproductibilité', 'Manifest, recall@k et Docker', 'Chaque exécution laisse une trace exploitable et la qualité de récupération est mesurable :
- manifest.json (un item par source avec status, sha256, chemins, nombre de chunks), summary.json (statistiques globales) et errors.json.
- Sur le lot de référence, la collecte a produit 546 chunks à partir des documents collectés avec succès (OMS, ISSN, OpenStax et une source ACSM en revue manuelle), les autres sources étant tracées en erreur.
- evaluate_retrieval.py calcule un recall@k sur un petit jeu de questions fitness étiquetées (catégories, sujets, mots-clés attendus).
- L''import est idempotent : id UUID5 stable, contrainte UNIQUE(source_id, chunk_index), ON CONFLICT et détection d''une table existante de dimension différente.
- PostgreSQL + pgvector tournent via Docker Compose (image pgvector/pgvector:pg16), pour un environnement reproductible.', 'result', 'text_only', 5, true
FROM projects WHERE slug = 'bora-rag-joytrain'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Écosystème JoyTrain', 'Trois projets liés autour du coach sportif', 'Bora ne vit pas seul : il est le moteur de connaissance d''un ensemble de trois projets pensés comme complémentaires.
- L''application JoyTrain : l''app mobile (Flutter) et son backend, où l''utilisateur final dialogue avec le coach sportif.
- Bora : ce projet, le moteur RAG / IA qui fournit au coach des réponses ancrées dans des sources fitness, nutrition et santé fiables et citables.
- Le site vitrine JoyTrain : la présence web qui présente le produit.
Dans cet ensemble, Bora joue le rôle de couche de connaissance : conçu comme un service de récupération autonome, alimenté par des sources de référence, il est destiné à être interrogé par le backend du coach pour enrichir ses réponses sans hallucination.', 'text', 'text_only', 6, true
FROM projects WHERE slug = 'bora-rag-joytrain'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

-- ===================== JoyTrain — Site vitrine =====================
INSERT INTO projects (name, slug, category, status, short_description, long_description, goal, context, architecture, challenges, results, future_improvements, github_url, demo_url, start_date, end_date, features, technologies)
VALUES (
  'JoyTrain — Site vitrine',
  'joytrain-site-vitrine',
  'web',
  'in_progress',
  'Landing marketing 100% statique de l''application fitness JoyTrain : HTML5 + Tailwind via CDN, sept vraies captures dans un cadre téléphone CSS, animations au scroll, et pages légales RGPD prêtes pour les stores.',
  'JoyTrain — Site vitrine est la landing page marketing de l''application fitness JoyTrain, accompagnée des pages légales obligatoires pour la publication sur les stores. Tout le site est écrit en HTML5 pur, sans aucune étape de build ni dépendance npm : le styling repose sur Tailwind CSS chargé via son CDN officiel, la typographie sur Google Fonts (Inter) et l''iconographie sur des SVG inline. La page d''accueil présente l''app à travers trois piliers (musculation, cardio/routines, nutrition), six sections fonctionnelles détaillées et une présentation de Bora, le coach IA. Techniquement, le site est intéressant par sa sobriété assumée : les animations (blobs flottants, apparition des blocs au scroll) sont obtenues uniquement avec des keyframes CSS et un IntersectionObserver en JavaScript natif, sans framework. Les sept vraies captures de l''app sont normalisées en écran seul et insérées dans un cadre de téléphone entièrement reconstruit en CSS, avec un visuel de repli si l''image manque. Le déploiement vise un hébergement statique gratuit via Netlify (configuration prête), avec redirection www vers l''apex et en-têtes de sécurité. Les pages de confidentialité (RGPD), CGU et contact sont rédigées en collant au fonctionnement réel de l''app. Le site fait partie d''un écosystème de trois projets liés autour de la marque JoyTrain.',
  'Offrir une vitrine web publique et crédible à l''application JoyTrain, présenter ses fonctionnalités avec de vrais écrans, et fournir les URLs légales (confidentialité, CGU, contact) exigées par l''App Store et Google Play.',
  'Ce site vitrine est l''un des trois projets de l''écosystème JoyTrain : (1) l''application JoyTrain elle-même (app mobile Flutter avec son backend), (2) « Bora », le moteur RAG/IA qui alimente le coach intégré à l''app, et (3) ce site vitrine. Avant de publier l''application sur les stores, il fallait une présence web : une landing marketing pour présenter le produit et, surtout, des pages légales accessibles publiquement (politique de confidentialité, CGU, contact) car Apple et Google les exigent. J''ai choisi une approche 100% statique pour un déploiement gratuit et sans maintenance. Le domaine joytrain.app a été retenu (joytrain.com étant pris depuis 1999, et l''extension .app force le HTTPS, cohérent avec l''API de l''app sur api.joytrain.app) ; le domaine reste à réserver et la mise en ligne en attente.',
  'Le projet est un ensemble de fichiers HTML statiques servis tels quels, sans serveur applicatif ni étape de compilation. À la racine : index.html (la landing), confidentialite.html, cgu.html et contact.html (pages légales et support), plus les assets de marque (logo.svg, logo-complet.svg, appicon.svg, og-image.png). Le styling combine Tailwind CSS chargé via le CDN officiel (cdn.tailwindcss.com) et un bloc <style> embarqué qui définit la palette de marque en variables CSS (--brand orange #FF5E3A, --bora violet #9B5DE5, --cyan, --green) ainsi que les composants sur-mesure (cadre .device du téléphone, classes .grad, .reveal, .card, keyframes float/bob). La typographie Inter vient de Google Fonts (avec preconnect). Le seul JavaScript est inline dans index.html : un IntersectionObserver qui ajoute la classe .in aux éléments .reveal lorsqu''ils entrent dans le viewport, plus l''année courante du footer. Les icônes SVG sont définies une fois dans un bloc <defs> caché et réutilisées via <use href>. Les captures (dossier screens/) sont des écrans seuls normalisés (540×1170), habillés par le cadre CSS. Le déploiement est piloté par netlify.toml (publish = ".", redirection 301 www->apex forcée, en-têtes X-Frame-Options/X-Content-Type-Options/Referrer-Policy).',
  'Le principal défi était de montrer une app pas encore publiée de façon crédible, sans tomber dans la maquette inventée : j''ai donc utilisé uniquement de vraies captures, normalisées à l''écran seul puis encadrées en CSS, avec un visuel de repli (attribut onerror qui retire l''image manquante) si un fichier est absent — le fil social et l''écran « Analyser mon repas » sont décrits textuellement faute de capture propre. Autre contrainte : rester 100% statique et sans build tout en obtenant un rendu moderne (gradients, blobs animés, apparition au scroll, responsive complet), ce qui m''a poussé à m''appuyer sur Tailwind via CDN, des keyframes CSS et un simple IntersectionObserver plutôt que sur une chaîne d''outils. Enfin, les pages légales devaient décrire fidèlement le comportement réel de l''application (données collectées, droits RGPD, export JSON, suppression de compte) tout en restant des modèles à compléter (champs entre crochets) et à faire valider juridiquement avant publication.',
  'Le site est fonctionnel et complet : une landing riche (header sticky, hero, trois piliers, six sections fonctionnelles, présentation de Bora, social, avantages, CTA, footer) intégrant sept vraies captures de l''app dans un cadre téléphone CSS, plus trois pages légales (confidentialité RGPD, CGU, contact). La configuration Netlify est en place (redirection www->apex, en-têtes de sécurité). Le domaine joytrain.app a été retenu. Le tout tient en quelques fichiers HTML, sans dépendance npm ni build. La mise en ligne reste à effectuer.',
  '- Réserver le domaine joytrain.app, finaliser la mise en ligne sur Netlify et brancher le DNS et le HTTPS.
- Compléter les champs entre crochets des pages légales (raison sociale, adresse, SIRET, date) et les faire valider par un professionnel du droit avant publication.
- Configurer les emails de marque (contact@ / support@joytrain.app) et l''enregistrement DMARC.
- Ajouter les captures manquantes (fil social, écran d''analyse de repas) une fois disponibles.
- Mettre à jour les boutons App Store / Google Play avec les liens réels au lancement de l''app.',
  'https://github.com/Hezuko/joytrain-website',
  NULL,
  DATE '2026-06-04',
  NULL,
  ARRAY['Landing page marketing 100% statique en HTML5, sans build ni dépendance npm', 'Styling via Tailwind CSS chargé par CDN, complété d''un bloc CSS de marque', 'Palette de marque en variables CSS (orange, violet Bora, cyan, vert)', 'Typographie Inter chargée depuis Google Fonts avec preconnect', 'Icônes SVG inline définies une fois dans un <defs> et réutilisées via <use>', 'Cadre de téléphone entièrement reconstruit en CSS pour afficher de vraies captures', 'Intégration de sept vraies captures d''écran de l''app, écran seul normalisé (540×1170)', 'Visuel de repli (onerror) affiché si une capture est absente', 'Animations CSS natives : blobs flottants (keyframes float) et badges (bob)', 'Apparition des sections au scroll via IntersectionObserver en JS natif', 'Header sticky avec navigation ancrée et fond translucide (backdrop-blur)', 'Mise en page entièrement responsive (grilles md:, breakpoints Tailwind)', 'Six sections fonctionnelles : musculation, programmes, cardio, routines, nutrition + scan IA, coach Bora', 'Pages légales séparées : confidentialité RGPD, CGU (avertissement santé, tolérance zéro), contact & support', 'Balises Open Graph et meta description pour le partage social et le SEO', 'Déploiement Netlify configuré : redirection 301 www vers apex et en-têtes de sécurité']::text[],
  ARRAY['HTML5', 'CSS3', 'JavaScript', 'Tailwind CSS (CDN)', 'Google Fonts (Inter)', 'SVG', 'IntersectionObserver API', 'CSS Keyframes', 'CSS Custom Properties', 'Open Graph', 'Netlify', 'netlify.toml', 'Git']::text[]
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
  future_improvements = EXCLUDED.future_improvements,
  github_url = EXCLUDED.github_url,
  demo_url = EXCLUDED.demo_url,
  start_date = EXCLUDED.start_date,
  end_date = EXCLUDED.end_date,
  features = EXCLUDED.features,
  technologies = EXCLUDED.technologies,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Une vitrine sans build, par choix', 'Approche statique assumée', 'J''ai délibérément écarté tout framework et toute chaîne d''outils : le site est constitué de fichiers HTML servis tels quels, sans étape de compilation ni dépendance npm à installer.

- Le styling repose sur Tailwind CSS chargé via son CDN officiel (cdn.tailwindcss.com), complété d''un bloc <style> embarqué pour les composants sur-mesure.
- La palette de marque est définie en variables CSS (--brand orange #FF5E3A, --bora violet #9B5DE5, --cyan, --green), réutilisée partout via Tailwind et le CSS custom.
- La typographie Inter vient de Google Fonts, avec preconnect pour accélérer le chargement.
- Le seul JavaScript est inline : aucun bundle, aucun runtime. Résultat : un hébergement statique gratuit, rapide et sans maintenance technique.', 'architecture', 'text_only', 1, true
FROM projects WHERE slug = 'joytrain-site-vitrine'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Montrer une app pas encore publiée, sans tricher', 'Vraies captures dans un cadre CSS', 'Le défi central était de présenter l''application de façon crédible alors qu''elle n''est pas encore en ligne, en m''interdisant toute maquette inventée.

- Les sept captures utilisées sont de vrais écrans de l''app, normalisés en écran seul (540×1170, sans cadre d''appareil) puis insérés dans un cadre de téléphone entièrement reconstruit en CSS (classe .device).
- Chaque slot d''image a un visuel de repli : un attribut onerror retire l''image manquante pour laisser apparaître un placeholder positionné dessous, ce qui évite toute case vide.
- Les écrans sans capture propre disponible (fil social, analyse d''un repas par photo) sont décrits uniquement par du texte, jamais illustrés par un faux écran.', 'challenge', 'text_only', 2, true
FROM projects WHERE slug = 'joytrain-site-vitrine'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Des animations sans la moindre librairie', 'Keyframes CSS + IntersectionObserver', 'Le rendu vivant de la page est obtenu sans aucune bibliothèque d''animation.

- Des blobs en arrière-plan flottent en continu via une keyframe CSS (float), et des badges flottants oscillent avec une keyframe bob, le tout décalé dans le temps par animation-delay.
- L''apparition progressive des sections au scroll repose sur un unique IntersectionObserver en JavaScript natif : chaque élément portant la classe .reveal reçoit la classe .in quand il entre dans le viewport, déclenchant une transition d''opacité et de translation, puis cesse d''être observé.
- Le défilement est lissé en CSS (scroll-behavior: smooth) et la mise en page reste entièrement responsive grâce aux grilles et breakpoints de Tailwind.', 'step', 'text_only', 3, true
FROM projects WHERE slug = 'joytrain-site-vitrine'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Pages légales prêtes pour les stores', 'Confidentialité RGPD, CGU, contact', 'Au-delà du marketing, le site existe surtout pour fournir les pages légales exigées par Apple et Google avant la publication d''une application.

- confidentialite.html : politique de confidentialité conforme au RGPD, qui décrit fidèlement les données réellement collectées par l''app (compte, profil, données de bien-être, entraînement, nutrition, compléments) et les droits associés.
- cgu.html : conditions générales d''utilisation, incluant un avertissement santé et une clause de règles de communauté en « tolérance zéro ».
- contact.html : points de contact dédiés (support, demandes RGPD, modération/signalement, presse & partenariats).
- Ces documents sont des modèles fidèles au comportement réel de l''app mais comportent encore des champs à compléter et doivent être validés juridiquement avant mise en ligne.', 'text', 'text_only', 4, true
FROM projects WHERE slug = 'joytrain-site-vitrine'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Déploiement Netlify et domaine', 'Statique, HTTPS forcé, en-têtes de sécurité', 'Le déploiement est piloté par un fichier netlify.toml minimal mais complet.

- publish = "." : le dossier racine est servi directement, sans build.
- Une redirection 301 forcée envoie www.joytrain.app vers le domaine canonique joytrain.app.
- Des en-têtes de sécurité de base sont appliqués à toutes les routes : X-Frame-Options (SAMEORIGIN), X-Content-Type-Options (nosniff) et Referrer-Policy (strict-origin-when-cross-origin).
- Le domaine joytrain.app a été retenu car joytrain.com est pris depuis 1999, et l''extension .app force nativement le HTTPS, cohérent avec l''API de l''app (api.joytrain.app). La réservation du domaine et la mise en ligne restent à effectuer.', 'result', 'text_only', 5, true
FROM projects WHERE slug = 'joytrain-site-vitrine'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Écosystème JoyTrain', 'Trois projets liés autour de la marque', 'Ce site vitrine n''est qu''une des trois briques d''un même produit. Les trois projets sont conçus pour fonctionner ensemble :

- L''application JoyTrain : l''app mobile Flutter (et son backend) qui réunit musculation, cardio, routines de mobilité et nutrition, avec scan de repas par photo et suivi des records. C''est le cœur du produit, et le site en montre les vrais écrans.
- Bora : le moteur RAG/IA qui alimente le coach intégré à l''application. C''est lui qui produit les réponses rédigées, sourcées et affichées en streaming, ainsi que la génération de programmes — le site présente Bora dans une section dédiée.
- JoyTrain — Site vitrine (ce projet) : la couche web publique, qui assure la présence marketing et héberge les pages légales nécessaires à la publication de l''app sur les stores.

Le site fait donc le lien entre l''app et son public, en s''appuyant sur l''identité de marque commune (logo, palette, icône) partagée par les trois projets.', 'text', 'text_only', 6, true
FROM projects WHERE slug = 'joytrain-site-vitrine'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

-- ===================== MManima — Gestion de crypto-actifs & ML quantitatif =====================
INSERT INTO projects (name, slug, category, status, short_description, long_description, goal, context, architecture, challenges, results, future_improvements, github_url, demo_url, start_date, end_date, features, technologies)
VALUES (
  'MManima — Gestion de crypto-actifs & ML quantitatif',
  'mmanima',
  'ai',
  'in_progress',
  'Plateforme de gestion de crypto-actifs (FastAPI + Flutter) doublée d''un bras R&D ML quantitatif (PyTorch, TFT, LightGBM) dont l''analyse rigoureuse a redéfini la stratégie : pas de prédiction directionnelle miracle, mais du carry delta-neutre et de la protection prouvés par backtest.',
  'MManima est un système en deux dépôts liés qui couvre toute la chaîne, de la recherche quantitative jusqu''à l''application multiplateforme. Le premier dépôt (MManima) est une plateforme de suivi et de gestion de crypto-actifs : un backend FastAPI (PostgreSQL, Redis, APScheduler) connecté à Binance, avec authentification JWT, chiffrement Fernet des clés API, notifications push Firebase, et un frontend Flutter qui affiche graphiques et bougies. Le scheduler évalue en continu une douzaine de types d''alertes techniques (RSI, MACD, Bandes de Bollinger, croisements EMA, seuils et variations de prix) et déclenche des signaux. Le second dépôt (MManima-ML) est le laboratoire de recherche : un pipeline en PyTorch « brut » entraînant un ensemble TFT + CNN-LSTM + LightGBM sur une soixantaine de features (indicateurs techniques, funding, open interest, sentiment Fear & Greed, multi-timeframe), avec labeling triple-barrière, walk-forward cross-validation purgée, tuning Optuna et tracking MLflow. L''intérêt technique majeur du projet tient à sa rigueur scientifique : j''ai détecté puis corrigé une fuite de données, et un test de permutation a prouvé qu''il n''existe pas d''edge directionnel net après coûts sur ces marchés liquides. Cette honnêteté a déclenché un pivot assumé vers des stratégies structurelles réellement prouvées par backtest — carry delta-neutre encaissant le funding (~5 %/an, market-neutral) et hedge dynamique de protection (long spot + short perp sous la MA50). Les conclusions de la recherche ont ensuite été réinjectées dans l''application sous forme de jobs de signaux concrets (alerte MA50, alerte carry). Le vrai actif construit ici n''est pas une machine à cash mais un pipeline ML honnête, anti-fuite et adversarialement vérifié.',
  'Construire une plateforme complète de gestion de crypto-actifs et un moteur de recherche ML capable de générer des signaux de marché fiables, puis valider scientifiquement quelles stratégies tiennent réellement après coûts avant de les industrialiser dans l''application.',
  'Projet personnel mené en parallèle d''un suivi de portefeuille crypto réel (spot, futures, earn sur Binance). Partant de l''idée d''une IA prédictive long/short, j''ai séparé l''effort en deux dépôts : une application opérationnelle (MManima) et un bras R&D distinct (MManima-ML) pour expérimenter sans polluer la prod. La recherche a fini par recadrer entièrement la stratégie produit.',
  'Architecture en deux dépôts. Côté application (MManima) : backend FastAPI structuré en couches (api / core / models SQLAlchemy / schemas Pydantic / services), persistance PostgreSQL avec migrations Alembic, cache de marché Redis, et un scheduler APScheduler lancé au démarrage de FastAPI qui orchestre plusieurs jobs (évaluation des alertes toutes les 30 s, jobs cron quotidiens pour le hedge spot et le carry, collecte de données Telegram/macro). L''intégration Binance passe par des services dédiés (compte, spot, earn, market, portfolio, symboles) avec signature HMAC-SHA256 maison, les clés secrètes étant chiffrées avec Fernet avant stockage. Les notifications push transitent par Firebase Cloud Messaging et l''enregistrement des appareils. Le frontend Flutter/Dart est multiplateforme (Android, iOS, web, desktop) et consomme l''API en HTTP, stocke le JWT dans flutter_secure_storage et trace les graphiques avec fl_chart et les chandelles avec k_chart_plus. Le tout est conteneurisé via Docker Compose (backend + PostgreSQL + Redis). Côté recherche (MManima-ML) : un pipeline d''ingestion (CCXT/Binance futures USD-M, yfinance en fallback, Telethon pour whale/news Telegram, Coinglass, données macro), un module de feature engineering (~66 features sur 1h/4h/1d, indicateurs codés à la main), un labeling triple-barrière par ATR, et un entraînement PyTorch « brut » (boucle d''optimisation maison, AMP, gradient clipping) d''un ensemble TFT + CNN-LSTM + LightGBM avec walk-forward folds purgés (embargo), Optuna et MLflow, suivi d''un moteur de backtest intégrant frais, slippage, spread et funding.',
  'Le défi central a été méthodologique avant d''être technique. Une fuite de données subtile (la feature de ratio EMA50 journalière corrélée à 0,57 avec le rendement futur, à cause d''une bougie journalière horodatée à minuit mais contenant la clôture du jour entier, propagée par ffill) gonflait l''accuracy à 0,62-0,93 et donnait des backtests à Sharpe 9-14 — tous faux. La corriger via un shift sur les blocs 4h/1d a fait chuter l''accuracy honnête à ~0,48-0,52. Le second défi a été d''accepter et de prouver l''absence d''edge directionnel : un test de permutation (5000 tirages, biais short reproduit) a montré que les « bons » résultats étaient du beta, pas du skill (p > 0,05). Le troisième défi a été le mur des coûts : des signaux structurels réels mais d''amplitude inférieure au péage retail (~0,32 %/jambe). Enfin, gérer le biais « tout short » des modèles entraînés sur une période baissière a imposé un ré-entraînement sur 5 ans pour rééquilibrer longs et shorts.',
  'L''application est fonctionnelle de bout en bout : authentification, connexion Binance chiffrée, suivi de portefeuille spot/futures/earn, watchlists, douzaine de types d''alertes techniques évaluées toutes les 30 s, notifications push, export CSV, paper-trading et simulation live. Côté recherche, neuf modèles par symbole ont été entraînés (folds CNN-LSTM, folds TFT, plus LightGBM et un méta-modèle) avec un pipeline anti-fuite et walk-forward purgé. Surtout, la recherche a livré des conclusions chiffrées et adversarialement vérifiées : le carry delta-neutre rapporte ~5 %/an sans drawdown, et le hedge dynamique bat le buy & hold sur les périodes baissières testées (ex. 992 € contre 679 € en hold sur 1000 € sur une fenêtre bear). Ces deux stratégies ont été intégrées dans l''app sous forme de jobs de signaux (alerte MA50 quotidienne, alerte carry). Le poste « futures levier » a été honnêtement rejeté par les données (levier sans edge = ruine chiffrée, drawdown jusqu''à −86 % en simulation).',
  'Finaliser le ré-entraînement des modèles sur 5 ans (BTC et ETH en cours) pour confirmer un comportement équilibré longs/shorts, puis redéployer en prod les modèles honnêtes (anti-fuite) à la place des versions encore leaky. Construire un bot de carry automatisé (maintien du hedge delta-neutre et encaissement du funding) et la poche futures trend-following en paper-trading d''abord, avec coupe-circuit obligatoire. Côté app : confirmer la livraison effective des push FCM en conditions réelles et étoffer la couverture de tests backend. Modéliser plus finement les coûts de rééquilibrage delta-neutre et de marge, signalés comme non couverts par les simulations actuelles.',
  'https://github.com/Hezuko/MManima',
  NULL,
  DATE '2025-02-26',
  NULL,
  ARRAY['Authentification utilisateur par JWT (python-jose, mots de passe hashés bcrypt_sha256 via passlib)', 'Connexion d''un compte Binance avec stockage chiffré de la clé secrète (Fernet / cryptography)', 'Suivi de portefeuille Binance spot, futures et earn (balances, ordres ouverts, historique)', 'Douzaine de types d''alertes techniques : prix, variation de prix, RSI, MACD, Bandes de Bollinger, croisements EMA', 'Scheduler APScheduler évaluant les alertes actives toutes les 30 secondes et générant des signaux', 'Notifications push via Firebase Cloud Messaging avec enregistrement des appareils', 'Watchlists personnelles avec ajout/suppression de symboles', 'Données de marché (prix, historiques, klines, ticker 24h) avec cache Redis', 'Signature HMAC-SHA256 maison des requêtes privées Binance', 'Frontend Flutter multiplateforme avec graphiques fl_chart et chandelles k_chart_plus', 'Stratégie de hedge dynamique de protection (long spot + short perp sous la MA50) intégrée comme job quotidien', 'Stratégie de carry delta-neutre (funding annualisé par crypto) avec alerte de seuil', 'Paper-trading et simulation live des stratégies', 'Export CSV des données', 'Pipeline ML : feature engineering ~66 features (technique, funding, open interest, sentiment Fear & Greed, multi-timeframe), indicateurs codés à la main', 'Labeling triple-barrière (ATR) façon Lopez de Prado', 'Ensemble de modèles TFT + CNN-LSTM + LightGBM entraînés en walk-forward purgé (embargo) avec Optuna et tracking MLflow', 'Moteur de backtest avec frais, slippage, spread et funding réels', 'Détection de fuite de données et test de permutation (alpha vs beta) dans le pipeline de recherche', 'Déploiement conteneurisé via Docker Compose (backend, PostgreSQL, Redis)']::text[],
  ARRAY['Python', 'FastAPI', 'SQLAlchemy', 'Alembic', 'PostgreSQL', 'Redis', 'APScheduler', 'Pydantic', 'JWT (python-jose)', 'Fernet (cryptography)', 'Firebase Cloud Messaging', 'Binance API', 'Flutter', 'Dart', 'fl_chart', 'k_chart_plus', 'PyTorch', 'Temporal Fusion Transformer (TFT)', 'CNN-LSTM', 'LightGBM', 'Optuna', 'MLflow', 'scikit-learn', 'pandas', 'CCXT', 'yfinance', 'Telethon', 'Docker', 'Docker Compose']::text[]
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
  future_improvements = EXCLUDED.future_improvements,
  github_url = EXCLUDED.github_url,
  demo_url = EXCLUDED.demo_url,
  start_date = EXCLUDED.start_date,
  end_date = EXCLUDED.end_date,
  features = EXCLUDED.features,
  technologies = EXCLUDED.technologies,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Une plateforme et un laboratoire, deux dépôts', 'Séparer la prod de la recherche', 'J''ai volontairement scindé le projet en deux dépôts liés pour ne jamais mélanger l''expérimentation et l''opérationnel :

- MManima : l''application réelle. Backend FastAPI connecté à Binance, frontend Flutter multiplateforme. C''est ce que l''utilisateur voit et utilise au quotidien pour suivre son portefeuille et recevoir des alertes.
- MManima-ML : le bras R&D. Un terrain de jeu PyTorch isolé pour entraîner des modèles, faire des backtests et tester des hypothèses sans risquer de casser la production.

Cette séparation s''est révélée décisive : elle m''a permis de mener une analyse quantitative agressive et adversariale dans le dépôt de recherche, puis de ne réinjecter dans l''app que ce qui était réellement prouvé.', 'architecture', 'text_only', 1, true
FROM projects WHERE slug = 'mmanima'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Le backend FastAPI et son scheduler', 'Alertes en continu et intégration Binance', 'Le backend est structuré en couches (api / core / models SQLAlchemy / schemas Pydantic / services) avec PostgreSQL pour la persistance, Alembic pour les migrations et Redis pour le cache de marché.

Le cœur temps réel est un scheduler APScheduler démarré avec FastAPI :

- évaluation des alertes actives toutes les 30 secondes, qui génère des signaux quand une condition devient vraie ;
- jobs cron quotidiens dédiés aux stratégies issues de la recherche (hedge spot, carry, trend-futures) ;
- collecte périodique de données (Telegram, news, macro).

L''intégration Binance passe par des services dédiés (compte, spot, earn, market, portfolio, symboles), les requêtes privées étant signées en HMAC-SHA256. La sécurité repose sur du JWT (python-jose), des mots de passe hashés (passlib / bcrypt_sha256) et surtout le chiffrement Fernet des clés API secrètes avant stockage en base : la clé n''est jamais persistée en clair.', 'step', 'text_only', 2, true
FROM projects WHERE slug = 'mmanima'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'La détection de la fuite de données', 'Quand des résultats trop beaux cachent un bug', 'Le tournant du projet a été la découverte d''une fuite de données dans le pipeline ML. Les premiers modèles affichaient une accuracy de 0,62 à 0,93 et des backtests au Sharpe 9-14 : trop beau pour être vrai.

L''enquête a remonté à une feature précise, le ratio EMA50 journalier, corrélée à 0,57 avec le rendement futur (contre ~0,03 pour les autres). La cause : la bougie journalière horodatée à minuit contenait en réalité la clôture du jour entier (donc une information future), propagée sur les 24 heures par un forward-fill. À minuit, le modèle « voyait » déjà la clôture du soir.

Le correctif a consisté à décaler d''un pas (shift) les blocs 4h et 1d, à la fois côté entraînement et côté inférence live. La corrélation suspecte est tombée et, avec elle, l''illusion de performance.', 'challenge', 'text_only', 3, true
FROM projects WHERE slug = 'mmanima'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Prouver l''absence d''edge plutôt que la masquer', 'Test de permutation : alpha contre beta', 'Une fois la fuite retirée, l''accuracy directionnelle honnête est retombée à ~0,48-0,52 sur tous les horizons : pile ou face, espérance nette de coûts proche de zéro ou négative.

Pour éviter de me raconter une histoire, j''ai écrit un test de permutation explicite (permutation_test.py) : à chemin de prix et dates d''entrée identiques, je reconstruis le PnL avec les vraies directions, puis je randomise 5000 fois les directions en reproduisant le biais short observé.

Verdict : un modèle aléatoire short-biaisé reproduit les « bons » résultats (p > 0,05). Les gains passés étaient donc du beta (des shorts dans un marché baissier), pas du skill. J''ai aussi vérifié le mur des coûts : les signaux structurels existent vraiment mais leur amplitude brute reste sous le coût retail (~0,32 % par jambe).', 'result', 'text_only', 4, true
FROM projects WHERE slug = 'mmanima'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Le pivot : carry delta-neutre et protection', 'Garder ce qui tient après coûts', 'Plutôt que de forcer une prédiction directionnelle qui n''existe pas, j''ai pivoté vers deux mécanismes prouvés par backtest, intégrés sous forme de jobs dans l''application :

- Carry delta-neutre : long spot + short perp en permanence pour encaisser le funding. Rendement mesuré ~5 %/an, market-neutral, sans drawdown. Le montant dépend du capital, pas de la sophistication.
- Hedge de protection : long spot + short perp uniquement quand le prix passe sous la MA50. En période baissière, la simulation donne 992 € contre 679 € en buy & hold sur 1000 €. La protection évite le krach même si elle traîne pendant les rallyes.

Leçon centrale : l''IA ne gagne pas par la prédiction, mais elle protège (elle se met à plat ou shorte en baisse), et le carry rapporte sans prédire. À l''inverse, j''ai rejeté honnêtement le futures à levier : sans edge, le levier n''amplifie que la perte (jusqu''à −86 % de drawdown dans les simulations).', 'result', 'text_only', 5, true
FROM projects WHERE slug = 'mmanima'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

INSERT INTO project_sections (project_id, title, subtitle, body, section_type, layout, display_order, is_visible)
SELECT id, 'Le pipeline ML de recherche', 'Features, modèles et backtest réaliste', 'Le dépôt MManima-ML met en place une chaîne quantitative complète :

- Ingestion multi-sources : Binance via CCXT (futures USD-M), yfinance en fallback, Telethon pour les flux Telegram (whale/news), Coinglass et données macro.
- Feature engineering : ~66 features sur 1h/4h/1d (indicateurs techniques codés à la main, volume, funding rates, open interest, sentiment Fear & Greed), avec élagage des features colinéaires calculé sur la seule portion d''entraînement (anti-leak).
- Labeling triple-barrière par ATR (méthode Lopez de Prado) : barrières haute/basse/temps pour étiqueter BUY/HOLD/SELL.
- Modèles : ensemble Temporal Fusion Transformer + CNN-LSTM + LightGBM, entraîné en PyTorch « brut » (boucle maison, AMP, gradient clipping), walk-forward folds purgés, tuning Optuna et tracking MLflow.
- Backtest réaliste : frais, slippage, demi-spread et funding réels débités sur les positions, seuil de confiance et autorisation de short configurables.

Le livrable le plus durable n''est pas un modèle gagnant mais ce pipeline honnête, anti-fuite et adversarialement vérifié.', 'code', 'text_only', 6, true
FROM projects WHERE slug = 'mmanima'
ON CONFLICT (project_id, lower(title)) DO UPDATE SET
  subtitle = EXCLUDED.subtitle,
  body = EXCLUDED.body,
  section_type = EXCLUDED.section_type,
  layout = EXCLUDED.layout,
  display_order = EXCLUDED.display_order,
  is_visible = true,
  updated_at = now();

-- ===================== Catalogue technologies =====================
INSERT INTO technologies (name, category)
SELECT v.name, v.category FROM (VALUES
  ('Dart', 'Langage'),
  ('Python', 'Langage'),
  ('Flutter', 'Outil'),
  ('Riverpod', 'Outil'),
  ('dio', 'Outil'),
  ('drift', 'Outil'),
  ('FastAPI', 'Outil'),
  ('SQLAlchemy 2', 'Outil'),
  ('Alembic', 'Outil'),
  ('arq', 'Outil'),
  ('React', 'Outil'),
  ('Vite', 'Outil'),
  ('MUI', 'Outil'),
  ('Caddy', 'Outil'),
  ('Sentry', 'Outil'),
  ('PostgreSQL', 'Systeme'),
  ('pgvector', 'Systeme'),
  ('Redis', 'Systeme'),
  ('Docker Compose', 'Systeme'),
  ('GitHub Actions', 'Systeme'),
  ('Ollama', 'Systeme'),
  ('WebSocket', 'Protocole'),
  ('bge-m3', 'Autre'),
  ('Gemini', 'Autre'),
  ('Mistral', 'Autre'),
  ('BAAI/bge-m3', 'Autre'),
  ('sentence-transformers', 'Outil'),
  ('PyTorch', 'Outil'),
  ('psycopg', 'Outil'),
  ('Pydantic', 'Outil'),
  ('trafilatura', 'Outil'),
  ('PyMuPDF', 'Outil'),
  ('BeautifulSoup', 'Outil'),
  ('lxml', 'Outil'),
  ('rank-bm25', 'Outil'),
  ('Reciprocal Rank Fusion', 'Autre'),
  ('RAG', 'Autre'),
  ('NumPy', 'Outil'),
  ('robots.txt', 'Protocole'),
  ('HTML5', 'Langage'),
  ('CSS3', 'Langage'),
  ('JavaScript', 'Langage'),
  ('Tailwind CSS', 'Outil'),
  ('Google Fonts (Inter)', 'Outil'),
  ('SVG', 'Outil'),
  ('IntersectionObserver API', 'Outil'),
  ('CSS Keyframes', 'Systeme'),
  ('CSS Custom Properties', 'Systeme'),
  ('Open Graph', 'Protocole'),
  ('Netlify', 'Systeme'),
  ('Git', 'Outil'),
  ('SQLAlchemy', 'Outil'),
  ('APScheduler', 'Outil'),
  ('fl_chart', 'Outil'),
  ('k_chart_plus', 'Outil'),
  ('LightGBM', 'Outil'),
  ('Optuna', 'Outil'),
  ('MLflow', 'Outil'),
  ('scikit-learn', 'Outil'),
  ('CCXT', 'Outil'),
  ('Telethon', 'Outil'),
  ('Temporal Fusion Transformer (TFT)', 'Autre'),
  ('CNN-LSTM', 'Autre'),
  ('Firebase Cloud Messaging', 'Systeme'),
  ('JWT', 'Protocole'),
  ('Binance API', 'Protocole'),
  ('Fernet (cryptography)', 'Autre')
) AS v(name, category)
ON CONFLICT (name) DO UPDATE SET
  category = COALESCE(technologies.category, EXCLUDED.category),
  updated_at = now();

COMMIT;
