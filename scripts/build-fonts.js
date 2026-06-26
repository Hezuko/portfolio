// Génère public/stylesheets/fonts.css + télécharge les woff2 (latin + latin-ext)
// à partir du CSS Google Fonts récupéré dans /tmp/gfonts.css. Usage ponctuel.
const fs = require("fs");
const https = require("https");
const path = require("path");

const css = fs.readFileSync("/tmp/gfonts.css", "utf8");
const fontsDir = path.join(__dirname, "..", "public", "fonts");
fs.mkdirSync(fontsDir, { recursive: true });

const keep = new Set(["latin", "latin-ext"]);
const re = /\/\*\s*([a-z-]+)\s*\*\/\s*@font-face\s*\{([\s\S]*?)\}/g;
let m;
const out = [];
const downloads = [];

const get = (key, body, field) => {
  const r = body.match(new RegExp(field + ":\\s*([^;]+);"));
  return r ? r[1].trim() : "";
};

while ((m = re.exec(css)) !== null) {
  const subset = m[1];
  if (!keep.has(subset)) continue;
  const body = m[2];
  const family = (get(subset, body, "font-family") || "").replace(/['"]/g, "");
  const weight = get(subset, body, "font-weight");
  const range = get(subset, body, "unicode-range");
  const urlMatch = body.match(/url\((https:[^)]+\.woff2)\)/);
  if (!urlMatch) continue;
  const url = urlMatch[1];
  const fname = family.toLowerCase().replace(/\s+/g, "") + "-" + weight + "-" + subset + ".woff2";
  downloads.push({ url, file: path.join(fontsDir, fname) });
  out.push(
    "@font-face {\n" +
      "  font-family: '" + family + "';\n" +
      "  font-style: normal;\n" +
      "  font-weight: " + weight + ";\n" +
      "  font-display: swap;\n" +
      "  src: url(/fonts/" + fname + ") format('woff2');\n" +
      "  unicode-range: " + range + ";\n}"
  );
}

fs.writeFileSync(path.join(__dirname, "..", "public", "stylesheets", "fonts.css"), out.join("\n\n") + "\n");
console.log("fonts.css : " + out.length + " blocs @font-face");

let done = 0;
downloads.forEach(({ url, file }) => {
  https.get(url, (res) => {
    const ws = fs.createWriteStream(file);
    res.pipe(ws);
    ws.on("finish", () => { ws.close(); if (++done === downloads.length) console.log("✓ " + done + " woff2 téléchargés"); });
  }).on("error", (e) => console.error("✗", url, e.message));
});
