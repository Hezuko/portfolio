// Injecte des transformations à la volée dans une URL Cloudinary
// (f_auto = WebP/AVIF selon le navigateur, q_auto = qualité auto, w_/h_/c_ = taille/cadrage)
// afin de servir des images légères et au bon format. No-op sur toute URL non Cloudinary.
function cloudinaryUrl(url, opts = {}) {
  if (!url || typeof url !== "string") return url;
  if (!/res\.cloudinary\.com\/[^/]+\/image\/upload\//.test(url)) return url;
  // Déjà transformée ? on ne double pas.
  if (/\/image\/upload\/[^/]*(f_auto|q_auto|w_\d)/.test(url)) return url;
  const parts = ["f_auto", "q_auto"];
  if (opts.w) parts.push("w_" + opts.w);
  if (opts.h) parts.push("h_" + opts.h);
  if (opts.c) parts.push("c_" + opts.c);
  return url.replace(/\/image\/upload\//, `/image/upload/${parts.join(",")}/`);
}

module.exports = { cloudinaryUrl };
