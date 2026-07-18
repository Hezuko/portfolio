// Statistiques de visite intégrées — philosophie Plausible : pas de cookies,
// pas d'IP stockée. Un visiteur = sha256(secret + jour + ip + user-agent)
// tronqué : impossible à inverser, et l'identifiant change chaque jour.
const crypto = require("crypto");
const pool = require("../model/db");

let geoip = null;
try {
  geoip = require("geoip-lite");
} catch (e) {
  console.warn("⚠️  geoip-lite indisponible — les stats n'auront pas le pays.");
}

const BOT_RE = /bot|crawl|spider|slurp|preview|scan|curl|wget|python-requests|axios|headless|lighthouse|pingdom|uptime|monitor|facebookexternalhit|whatsapp|telegram/i;

// Pages à ne jamais compter : back-office, santé, fichiers statiques.
function shouldTrack(req) {
  if (req.method !== "GET") return false;
  const p = req.path;
  if (/^\/(admin|authentification|health|desauthentification)/.test(p)) return false;
  if (p.includes(".")) return false; // assets (css, js, images, sitemap.xml…)
  const ua = req.get("user-agent") || "";
  if (!ua || BOT_RE.test(ua)) return false;
  return true;
}

function visitorHash(req) {
  const day = new Date().toISOString().slice(0, 10);
  const secret = process.env.SESSION_SECRET || "dev";
  const ip = req.ip || "";
  const ua = req.get("user-agent") || "";
  return crypto.createHash("sha256").update(`${secret}|${day}|${ip}|${ua}`).digest("hex").slice(0, 16);
}

function referrerHost(req) {
  try {
    const ref = req.get("referer");
    if (!ref) return null;
    const host = new URL(ref).hostname.replace(/^www\./, "");
    // trafic interne = navigation sur le site, pas une source
    if (host === "henocmukumbi.com" || host === "localhost") return null;
    return host.slice(0, 100);
  } catch (e) {
    return null;
  }
}

function countryOf(req) {
  if (!geoip) return null;
  const ip = (req.ip || "").replace(/^::ffff:/, "");
  const hit = ip && geoip.lookup(ip);
  return hit && hit.country ? hit.country : null;
}

// Middleware : enregistre la vue APRÈS la réponse (statut 2xx uniquement),
// en fire-and-forget — une erreur d'insert ne doit jamais casser une page.
function middleware(req, res, next) {
  if (!shouldTrack(req)) return next();
  res.on("finish", () => {
    if (res.statusCode < 200 || res.statusCode >= 300) return;
    const ua = req.get("user-agent") || "";
    pool
      .query(
        "INSERT INTO page_views (path, referrer_host, country, visitor_hash, is_mobile) VALUES ($1, $2, $3, $4, $5)",
        [req.path.slice(0, 200), referrerHost(req), countryOf(req), visitorHash(req), /Mobi|Android|iPhone/i.test(ua)]
      )
      .catch((e) => console.error("stats non enregistrées :", e.message));
  });
  next();
}

// Agrégats pour la page /admin/stats.
async function getStats() {
  const [totals, topPages, topReferrers, topCountries, daily, devices] = await Promise.all([
    pool.query(`SELECT
        COUNT(*) FILTER (WHERE ts::date = CURRENT_DATE)::int AS views_today,
        COUNT(DISTINCT visitor_hash) FILTER (WHERE ts::date = CURRENT_DATE)::int AS visitors_today,
        COUNT(*) FILTER (WHERE ts > now() - interval '7 days')::int AS views_7d,
        COUNT(DISTINCT (ts::date, visitor_hash)) FILTER (WHERE ts > now() - interval '7 days')::int AS visitors_7d,
        COUNT(*) FILTER (WHERE ts > now() - interval '30 days')::int AS views_30d,
        COUNT(DISTINCT (ts::date, visitor_hash)) FILTER (WHERE ts > now() - interval '30 days')::int AS visitors_30d
      FROM page_views`),
    pool.query(`SELECT path, COUNT(*)::int AS views FROM page_views
      WHERE ts > now() - interval '30 days' GROUP BY path ORDER BY views DESC LIMIT 10`),
    pool.query(`SELECT COALESCE(referrer_host, 'Accès direct') AS source, COUNT(*)::int AS views
      FROM page_views WHERE ts > now() - interval '30 days' GROUP BY source ORDER BY views DESC LIMIT 10`),
    pool.query(`SELECT COALESCE(country, '??') AS country, COUNT(DISTINCT (ts::date, visitor_hash))::int AS visitors
      FROM page_views WHERE ts > now() - interval '30 days' GROUP BY country ORDER BY visitors DESC LIMIT 10`),
    pool.query(`SELECT ts::date AS day, COUNT(DISTINCT visitor_hash)::int AS visitors, COUNT(*)::int AS views
      FROM page_views WHERE ts > now() - interval '14 days' GROUP BY day ORDER BY day`),
    pool.query(`SELECT is_mobile, COUNT(*)::int AS views FROM page_views
      WHERE ts > now() - interval '30 days' GROUP BY is_mobile`),
  ]);
  const dev = { mobile: 0, desktop: 0 };
  devices.rows.forEach((r) => (r.is_mobile ? (dev.mobile = r.views) : (dev.desktop = r.views)));
  return {
    totals: totals.rows[0],
    topPages: topPages.rows,
    topReferrers: topReferrers.rows,
    topCountries: topCountries.rows,
    daily: daily.rows,
    devices: dev,
  };
}

module.exports = { middleware, getStats, shouldTrack, visitorHash, referrerHost };
