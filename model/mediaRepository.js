const pool = require("./db");
const cloudinary = require("../config/cloudinary");

function isConfigured() {
  return Boolean(process.env.CLOUDINARY_URL);
}

function getFolder(entityType) {
  const safeType = String(entityType || "general").replace(/[^a-z0-9_-]/gi, "-").toLowerCase();
  return `portfolio/private/${safeType}`;
}

function getResourceType(mimetype) {
  return mimetype && mimetype.startsWith("video/") ? "video" : "image";
}

function cleanDisplayName(value, fallback) {
  const cleaned = String(value || "").trim();
  return cleaned || fallback || null;
}

function label(asset) {
  return asset?.display_name || asset?.original_filename || asset?.public_id || "";
}

function signedUrl(asset) {
  if (!asset?.public_id) return null;
  return cloudinary.url(asset.public_id, {
    resource_type: asset.resource_type,
    type: "authenticated",
    secure: true,
    sign_url: true,
    version: asset.version || undefined,
  });
}

async function list(filters = {}) {
  const values = [];
  const clauses = [];

  if (filters.entityType) {
    values.push(filters.entityType);
    clauses.push(`entity_type = $${values.length}`);
  }

  const result = await pool.query(
    `SELECT * FROM media_assets ${clauses.length ? `WHERE ${clauses.join(" AND ")}` : ""} ORDER BY created_at DESC`,
    values
  );

  return result.rows.map((asset) => ({
    ...asset,
    label: label(asset),
    signed_url: signedUrl(asset),
  }));
}

async function findByPublicId(publicId) {
  const result = await pool.query("SELECT * FROM media_assets WHERE public_id = $1", [publicId]);
  const asset = result.rows[0] || null;
  return asset ? { ...asset, label: label(asset), signed_url: signedUrl(asset) } : null;
}

async function upload(file, body) {
  if (!isConfigured()) {
    throw new Error("CLOUDINARY_URL est requis pour uploader des medias prives.");
  }

  const resourceType = getResourceType(file.mimetype);
  const dataUri = `data:${file.mimetype};base64,${file.buffer.toString("base64")}`;
  let uploadResult;

  try {
    uploadResult = await cloudinary.uploader.upload(dataUri, {
      resource_type: resourceType,
      type: "authenticated",
      folder: getFolder(body.entity_type),
      tags: ["portfolio", "private-media", body.entity_type || "general"].filter(Boolean),
      use_filename: true,
      unique_filename: true,
      overwrite: false,
    });
  } catch (err) {
    const message = err?.message || err?.error?.message || JSON.stringify(err);
    const wrapped = new Error(`Upload Cloudinary impossible : ${message}`);
    wrapped.cause = err;
    throw wrapped;
  }

  const result = await pool.query(
    `INSERT INTO media_assets
      (provider, public_id, resource_type, delivery_type, format, version, display_name, original_filename, bytes, width, height, entity_type, alt_text)
     VALUES
      ('cloudinary', $1, $2, 'authenticated', $3, $4, $5, $6, $7, $8, $9, $10, $11)
     RETURNING *`,
    [
      uploadResult.public_id,
      uploadResult.resource_type,
      uploadResult.format || null,
      uploadResult.version || null,
      cleanDisplayName(body.display_name, file.originalname),
      file.originalname,
      uploadResult.bytes || null,
      uploadResult.width || null,
      uploadResult.height || null,
      body.entity_type || "general",
      body.alt_text || null,
    ]
  );

  const asset = result.rows[0];
  return { ...asset, label: label(asset), signed_url: signedUrl(asset) };
}

async function remove(id) {
  const result = await pool.query("DELETE FROM media_assets WHERE id = $1 RETURNING *", [id]);
  const asset = result.rows[0];
  if (asset && isConfigured()) {
    await cloudinary.uploader.destroy(asset.public_id, {
      resource_type: asset.resource_type,
      type: "authenticated",
      invalidate: true,
    });
  }
}

async function rename(id, displayName) {
  const result = await pool.query(
    `UPDATE media_assets
     SET display_name = $1, updated_at = now()
     WHERE id = $2
     RETURNING *`,
    [cleanDisplayName(displayName), id]
  );
  const asset = result.rows[0] || null;
  return asset ? { ...asset, label: label(asset), signed_url: signedUrl(asset) } : null;
}

module.exports = {
  findByPublicId,
  isConfigured,
  label,
  list,
  rename,
  remove,
  signedUrl,
  upload,
};
