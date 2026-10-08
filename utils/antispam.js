// 🛡️ Anti-spam du formulaire de contact.
//
// Principe : ne jamais perdre un vrai message. Un envoi jugé suspect est quand
// même enregistré (consultable dans l'admin, onglet indésirables) mais il ne
// déclenche aucune notification email, et le robot reçoit la page de succès
// habituelle — sans retour d'erreur, il n'a rien à ajuster pour repasser.

// Scripts non latins : un visiteur du portfolio écrit en français ou en anglais.
// Les campagnes automatisées arrivent en cyrillique, géorgien, CJK, arabe…
// Plages Unicode des écritures non latines. Listées en clair plutôt qu'en
// classe de caractères : plus lisible, et sans ambiguïté sur les caractères
// combinants que contiennent certaines de ces plages.
const NON_LATIN_BLOCKS = [
  [0x0370, 0x03ff], // grec
  [0x0400, 0x052f], // cyrillique
  [0x0530, 0x058f], // arménien
  [0x0590, 0x05ff], // hébreu
  [0x0600, 0x074f], // arabe, syriaque
  [0x0900, 0x0dff], // écritures indiennes
  [0x0e00, 0x0e7f], // thaï
  [0x10a0, 0x10ff], // géorgien
  [0x1200, 0x137f], // éthiopien
  [0x3040, 0x30ff], // kana
  [0x4e00, 0x9fff], // han
  [0xac00, 0xd7af], // hangûl
];
const URL_RE = /\b(?:https?:\/\/|www\.)\S+/gi;
const CHEAP_TLD_RE = /\b[a-z0-9-]+\.(?:ru|cn|top|xyz|club|online|site|shop|icu|buzz|loan|work)\b/i;

// Vocabulaire type des campagnes reçues (SEO, crypto, backlinks, services web).
const SPAM_KEYWORDS = [
  "seo", "backlink", "guest post", "link building", "domain authority",
  "search engine ranking", "rank your website", "web design services",
  "mobile app development", "crypto", "bitcoin", "forex", "casino", "betting",
  "viagra", "payday loan", "make money online", "increase your traffic",
  "we noticed your website", "i visited your website", "unsubscribe",
  "boost your sales", "digital marketing services", "cheap price offer",
];

// Seuil : au-delà, le message part en indésirable (pas d'email).
const SPAM_THRESHOLD = 4;

function countNonLatin(text) {
  let count = 0;
  for (const char of String(text || "")) {
    const cp = char.codePointAt(0);
    if (NON_LATIN_BLOCKS.some(([from, to]) => cp >= from && cp <= to)) count += 1;
  }
  return count;
}

// Analyse le contenu soumis et renvoie { spam, score, reasons }.
// `signals` porte les indices côté formulaire (temps de remplissage…) calculés
// par la route, pour les additionner au score de contenu.
function scoreContact(fields, signals) {
  const { nom = "", prenom = "", objet = "", email = "", texte = "" } = fields || {};
  const reasons = [];
  let score = 0;
  const add = (points, reason) => { score += points; reasons.push(reason); };

  const body = `${objet} ${texte}`;
  const nonLatin = countNonLatin(`${nom} ${prenom} ${body}`);
  // Quelques caractères isolés (Δ, Ω…) restent plausibles dans un message
  // technique : on ne déclenche qu'au-delà de 3 caractères, ou de 10 % du texte.
  if (nonLatin >= 3 || (nonLatin > 0 && nonLatin / Math.max(body.length, 1) > 0.1)) {
    add(4, "alphabet non latin");
  }

  const links = body.match(URL_RE) || [];
  if (links.length >= 2) add(4, "plusieurs liens");
  else if (links.length === 1) add(2, "lien dans le message");
  if (/\[url[=\]]|\[link[=\]]|<a\s/i.test(body)) add(4, "balises de lien");
  if (CHEAP_TLD_RE.test(body)) add(2, "domaine à risque");

  const haystack = body.toLowerCase();
  const hits = SPAM_KEYWORDS.filter((k) => haystack.includes(k));
  if (hits.length) add(Math.min(4, 2 * hits.length), `mots-clés (${hits.slice(0, 3).join(", ")})`);

  // Adresse jetable générée : longue, plusieurs chiffres, et des chiffres
  // insérés au milieu des lettres (joshuaguerrero2v7t40d@…).
  const local = String(email).split("@")[0].toLowerCase();
  const digits = (local.match(/\d/g) || []).length;
  if (local.length >= 12 && digits >= 3 && /\d[a-z]/.test(local)) add(2, "adresse email générée");

  // Majuscule au milieu d'un nom (BillyUnlotGM) : fréquent sur les noms générés.
  // Volontairement léger, des patronymes réels s'écrivent ainsi (McDonald, LeRoy).
  if (/[a-zà-öø-ÿ][A-ZÀ-ÖØ-Þ]/.test(`${nom} ${prenom}`)) add(2, "majuscule au milieu du nom");

  if (/(.)\1{6,}/.test(texte)) add(3, "caractères répétés");

  for (const signal of (signals || [])) add(signal.points, signal.reason);

  return { spam: score >= SPAM_THRESHOLD, score, reasons };
}

module.exports = { scoreContact, countNonLatin, SPAM_THRESHOLD };
