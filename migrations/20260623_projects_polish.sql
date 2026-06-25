-- Polish : retrait GitHub (privés), logo caméléon + nouveau pourquoi portfolio, technos complètes, preuve backtest MManima.
BEGIN;

-- Retire tous les liens GitHub (repos privés pour le moment)
UPDATE projects SET github_url = NULL, updated_at = now();

-- Palette technique complète (montrer la largeur de compétences)
UPDATE projects SET technologies = ARRAY['Flutter', 'Dart', 'Riverpod', 'dio', 'go_router', 'drift', 'fl_chart', 'FastAPI', 'Python', 'SQLAlchemy 2', 'Alembic', 'PostgreSQL', 'pgvector', 'Redis', 'arq', 'Ollama', 'bge-m3', 'Gemini', 'Mistral', 'React', 'Vite', 'MUI', 'Docker Compose', 'Caddy', 'GitHub Actions', 'Sentry']::text[], updated_at = now() WHERE slug = 'joytrain';
UPDATE projects SET technologies = ARRAY['Python', 'BAAI/bge-m3', 'sentence-transformers', 'PyTorch', 'PostgreSQL', 'pgvector', 'psycopg', 'Pydantic', 'trafilatura', 'PyMuPDF', 'BeautifulSoup', 'lxml', 'rank-bm25', 'Reciprocal Rank Fusion', 'NumPy', 'Docker Compose', 'python-slugify', 'tqdm', 'python-dotenv', 'requests']::text[], updated_at = now() WHERE slug = 'bora-rag-joytrain';
UPDATE projects SET technologies = ARRAY['HTML5', 'CSS3', 'JavaScript', 'Tailwind CSS (CDN)', 'Google Fonts (Inter)', 'SVG', 'IntersectionObserver API', 'CSS Keyframes', 'CSS Custom Properties', 'Open Graph', 'Netlify', 'netlify.toml', 'Git']::text[], updated_at = now() WHERE slug = 'joytrain-site-vitrine';
UPDATE projects SET technologies = ARRAY['Python', 'FastAPI', 'SQLAlchemy', 'Alembic', 'PostgreSQL', 'Redis', 'APScheduler', 'Pydantic', 'JWT (python-jose)', 'Fernet (cryptography)', 'Firebase Cloud Messaging', 'Binance API', 'Flutter', 'Dart', 'fl_chart', 'k_chart_plus', 'PyTorch', 'Temporal Fusion Transformer (TFT)', 'CNN-LSTM', 'LightGBM', 'Optuna', 'MLflow', 'scikit-learn', 'pandas', 'CCXT', 'yfinance', 'Telethon', 'Docker', 'Docker Compose']::text[], updated_at = now() WHERE slug = 'mmanima';
UPDATE projects SET technologies = ARRAY['Node.js', 'Express', 'EJS', 'JavaScript', 'PostgreSQL', 'SQL', 'Bootstrap 5', 'Sass', 'Cloudinary', 'express-session', 'connect-pg-simple', 'CSRF', 'bcrypt', 'Multer', 'Nodemailer', 'Jest', 'Supertest', 'Docker', 'Caddy', 'Git']::text[], updated_at = now() WHERE slug = 'portfolio-personnel';

-- Portfolio : logo caméléon en héro + pourquoi reformulé (présenter qui je suis)
UPDATE projects SET main_image = '/images/came.png', images = '{}'::text[], context = 'Je voulais un endroit clair pour présenter qui je suis, ce que je fais et ce que j''ai réalisé, à toute personne qui souhaite mieux me connaître. Et pouvoir tout mettre à jour moi-même — ajouter un projet, modifier mon parcours, changer une image — sans jamais retoucher au code.', goal = 'Rassembler en un seul site mon profil, mes projets et mon parcours, avec un espace privé pour tout gérer en autonomie.', updated_at = now() WHERE slug = 'portfolio-personnel';

-- MManima : graphe de backtest (preuve vérifiable) + résultats chiffrés honnêtes
UPDATE projects SET images = ARRAY['/images/projects/mmanima/backtest.png','/images/projects/mmanima/strategie.svg']::text[], results = 'Backtest 2021-2026 (panier BTC/ETH/XRP/SOL, données Binance réelles, frais inclus) : la couverture par moyenne mobile amortit le krach — +34 %/an pour la crypto couverte, contre +10 %/an en achat simple et +12 %/an pour le S&P 500. À lire comme un résultat sur une période passée favorable (et portée par SOL), pas une promesse : le graphe permet de le vérifier soi-même.', updated_at = now() WHERE slug = 'mmanima';

COMMIT;
