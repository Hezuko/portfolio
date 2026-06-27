// Restriction d'accès par IP — logique pure, testable sans serveur ni base.

// "1.2.3.4, 5.6.7.8" -> ["1.2.3.4", "5.6.7.8"]
function parseAllowlist(raw) {
  return (raw || "")
    .split(",")
    .map((s) => s.trim())
    .filter(Boolean);
}

// Retire le préfixe IPv6-mapped IPv4 ("::ffff:1.2.3.4" -> "1.2.3.4")
function normalizeIp(ip) {
  return (ip || "").replace(/^::ffff:/, "");
}

// Liste vide = aucune restriction (sûr par défaut). Sinon, l'IP doit être listée.
function isAllowed(allowlist, ip) {
  if (!allowlist || allowlist.length === 0) return true;
  return allowlist.includes(normalizeIp(ip));
}

module.exports = { parseAllowlist, normalizeIp, isAllowed };
