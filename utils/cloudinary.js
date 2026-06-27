const cloudinary = require("../config/cloudinary");

// Injecte des transformations Cloudinary (f_auto = WebP/AVIF selon le navigateur,
// q_auto = qualité auto, w_/h_/c_ = taille/cadrage) pour servir des images légères.
// - URL 'upload' publique : insertion de chaîne (rapide, sans SDK).
// - URL 'authenticated' signée : on RE-SIGNE avec la transfo via le SDK — la signature
//   couvre alors les transfos (pas de 401, contrairement à une insertion brute).
// No-op sur toute URL non Cloudinary.

// Extrait { resourceType, publicId } d'une URL Cloudinary 'authenticated' signée.
// Format : .../<resource>/authenticated/s--SIG--/[transfos/]v123/<public_id>[.ext][?query]
function parseAuthenticated(url) {
  const m = url.match(
    /res\.cloudinary\.com\/[^/]+\/(image|video)\/authenticated\/s--[^/]+\/(?:.+?\/)?v\d+\/([^?]+?)(?:\.[a-zA-Z0-9]+)?(?:\?.*)?$/
  );
  return m ? { resourceType: m[1], publicId: m[2] } : null;
}

function buildTransform(opts = {}) {
  const t = { fetch_format: opts.fmt || "auto", quality: "auto" };
  if (opts.w) t.width = opts.w;
  if (opts.h) t.height = opts.h;
  if (opts.c) t.crop = opts.c;
  return t;
}

function authTransformedUrl(url, opts) {
  const parsed = parseAuthenticated(url);
  if (!parsed) return url;
  try {
    return cloudinary.url(parsed.publicId, {
      resource_type: parsed.resourceType,
      type: "authenticated",
      secure: true,
      sign_url: true,
      transformation: [buildTransform(opts)],
    });
  } catch (e) {
    return url; // SDK non configuré : on ne casse rien
  }
}

function cloudinaryUrl(url, opts = {}) {
  if (!url || typeof url !== "string") return url;

  // URL upload publique : insertion de chaîne
  if (/res\.cloudinary\.com\/[^/]+\/image\/upload\//.test(url)) {
    if (/\/image\/upload\/[^/]*(f_auto|f_avif|f_webp|q_auto|w_\d)/.test(url)) return url; // déjà transformée
    const parts = [opts.fmt ? "f_" + opts.fmt : "f_auto", "q_auto"];
    if (opts.w) parts.push("w_" + opts.w);
    if (opts.h) parts.push("h_" + opts.h);
    if (opts.c) parts.push("c_" + opts.c);
    return url.replace(/\/image\/upload\//, `/image/upload/${parts.join(",")}/`);
  }

  // URL authenticated signée : re-signature avec la transfo
  if (/\/image\/authenticated\/s--/.test(url)) {
    return authTransformedUrl(url, opts);
  }

  return url;
}

// Construit un srcset Cloudinary (plusieurs largeurs) pour les images responsives.
// opts.fmt force le format (ex. 'avif' pour une <source> dans un <picture>).
function cloudinarySrcset(url, widths, opts = {}) {
  if (!url || typeof url !== "string") return "";
  if (!/res\.cloudinary\.com\/[^/]+\/image\/(upload|authenticated)\//.test(url)) return "";
  return (widths || [400, 600, 900, 1200]).map((w) => `${cloudinaryUrl(url, { ...opts, w })} ${w}w`).join(", ");
}

module.exports = { cloudinaryUrl, cloudinarySrcset };
