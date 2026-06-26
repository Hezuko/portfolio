// Regroupe une technologie brute en une "famille" signifiante pour le filtre projets.
// Retourne null pour le bruit (dépendances, fichiers de config) -> exclu du filtre
// (mais toujours visible dans la fiche technique détaillée du projet).
const norm = (s) =>
  String(s || "")
    .normalize("NFD")
    .replace(/[̀-ͯ]/g, "")
    .toLowerCase();

const RULES = [
  ["Embarqué & électronique", /stm32|\bpic\b|microcontr|firmware|embarqu|kicad|altium|pcb|capteur|\brf\b|arduino|electroniq|soudure|oscillo|carte|\bcan\b|\blin\b|vhdl|fpga/],
  ["Mobile (Flutter)", /flutter|dart|riverpod|go_router|\bdrift\b|\bdio\b|fl_chart/],
  ["IA / Machine Learning", /pytorch|tensorflow|scikit|sklearn|numpy|pandas|\brag\b|ollama|mistral|gemini|\bllm\b|bge|sentence-?transformers|pgvector|machine learning|deep learning|\bia\b|\bml\b/],
  ["Python / Back-end", /python|fastapi|django|flask|sqlalchemy|alembic|\barq\b|uvicorn|pydantic/],
  ["Web / Front-end", /react|javascript|typescript|\bhtml|\bcss|tailwind|\bvite\b|\bmui\b|bootstrap|next|vue/],
  ["Node / Express", /node|express|\bejs\b|nestjs/],
  ["Bases de données", /postgres|postgresql|sqlite|\bredis\b|mysql|mongo/],
  ["Tests & validation", /canoe|rtrt|test|validation|jest|cypress|pytest|tracabilite/],
  ["DevOps & outils", /docker|\bgit\b|github|gitlab|caddy|nginx|linux|\bci\b|github actions|sentry|netlify(?!\.)|vercel|cloud/],
];

function techFamily(name) {
  const v = norm(name);
  if (!v) return null;
  for (const [label, re] of RULES) {
    if (re.test(v)) return label;
  }
  return null; // bruit (bcrypt, dotenv, netlify.toml, connect-pg-simple, …)
}

// Ordre d'affichage stable des familles
const FAMILY_ORDER = [
  "Embarqué & électronique",
  "Mobile (Flutter)",
  "IA / Machine Learning",
  "Python / Back-end",
  "Node / Express",
  "Web / Front-end",
  "Bases de données",
  "Tests & validation",
  "DevOps & outils",
];

module.exports = { techFamily, FAMILY_ORDER };
