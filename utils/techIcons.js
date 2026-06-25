// Correspondance nom de techno (tel que stocké) -> slug Simple Icons.
// Les SVG sont servis en local depuis public/images/tech/<slug>.svg.
const MAP = {
  "c++": "cplusplus",
  "c": "c", "langage c": "c",
  "arduino": "arduino",
  "kicad": "kicad",
  "qt": "qt", "qt creator": "qt",
  "stm32 nucleo f429zi": "stmicroelectronics", "stm32": "stmicroelectronics",
  "python": "python",
  "fastapi": "fastapi",
  "node.js": "nodedotjs",
  "express": "express",
  "postgresql": "postgresql",
  "redis": "redis",
  "docker": "docker", "docker compose": "docker",
  "flutter": "flutter",
  "dart": "dart",
  "firebase cloud messaging": "firebase", "firebase": "firebase",
  "pytorch": "pytorch",
  "scikit-learn": "scikitlearn",
  "pandas": "pandas",
  "numpy": "numpy",
  "ollama": "ollama",
  "mistral": "mistralai",
  "gemini": "googlegemini",
  "react": "react",
  "javascript": "javascript",
  "html5": "html5",
  "css3": "css", "css keyframes": "css", "css custom properties": "css",
  "tailwind css (cdn)": "tailwindcss",
  "bootstrap 5": "bootstrap", "bootstrap": "bootstrap",
  "sass": "sass",
  "vite": "vite",
  "git": "git",
  "github actions": "github",
  "cloudinary": "cloudinary",
  "netlify": "netlify",
  "caddy": "caddy",
  "sqlalchemy": "sqlalchemy", "sqlalchemy 2": "sqlalchemy",
  "mui": "mui",
  "jest": "jest",
  "drift": "sqlite",
  "google fonts (inter)": "googlefonts",
};

function slugFor(name) {
  if (!name) return null;
  return MAP[String(name).trim().toLowerCase()] || null;
}

function techIconUrl(name) {
  const slug = slugFor(name);
  return slug ? `/images/tech/${slug}.svg` : null;
}

module.exports = { techIconUrl, slugFor };
