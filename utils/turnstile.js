// 🛡️ Cloudflare Turnstile — CAPTCHA invisible, gratuit et sans cookie
// (compatible RGPD, aucun bandeau à ajouter).
//
// Entièrement optionnel : actif seulement si TURNSTILE_SITE_KEY et
// TURNSTILE_SECRET_KEY sont définis. Sans ces clés, le formulaire fonctionne
// exactement comme avant et seules les heuristiques locales filtrent.
// Clés à créer sur https://dash.cloudflare.com → Turnstile (widget « Managed »).

const VERIFY_URL = "https://challenges.cloudflare.com/turnstile/v0/siteverify";
const SCRIPT_ORIGIN = "https://challenges.cloudflare.com";

// Lecture paresseuse : dotenv est chargé par app.js, après le require de ce module.
function siteKey() {
  return process.env.TURNSTILE_SITE_KEY || "";
}
function secretKey() {
  return process.env.TURNSTILE_SECRET_KEY || "";
}
function isEnabled() {
  return Boolean(siteKey() && secretKey());
}

// Vérifie le jeton renvoyé par le widget auprès de Cloudflare.
// Renvoie { ok, reason } ; si Cloudflare est injoignable on laisse passer
// (dégradé) plutôt que de bloquer un visiteur légitime — le score de contenu
// reste en seconde ligne.
async function verify(token, ip) {
  if (!isEnabled()) return { ok: true, skipped: true };
  if (!token) return { ok: false, reason: "jeton manquant" };

  const body = new URLSearchParams({ secret: secretKey(), response: String(token) });
  if (ip) body.set("remoteip", ip);

  try {
    const res = await fetch(VERIFY_URL, {
      method: "POST",
      headers: { "Content-Type": "application/x-www-form-urlencoded" },
      body,
      signal: AbortSignal.timeout(5000),
    });
    const data = await res.json();
    return { ok: Boolean(data.success), reason: (data["error-codes"] || []).join(", ") };
  } catch (err) {
    console.error("Turnstile injoignable :", err.message);
    return { ok: true, degraded: true };
  }
}

module.exports = { isEnabled, siteKey, verify, SCRIPT_ORIGIN };
