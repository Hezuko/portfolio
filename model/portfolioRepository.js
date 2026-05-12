const pool = require("./db");
const media = require("./mediaRepository");

const ENTITY_CONFIG = {
  schools: {
    table: "schools",
    orderBy: "name ASC",
    fields: ["name", "slug", "logo", "city", "country", "website", "description"],
  },
  companies: {
    table: "companies",
    orderBy: "name ASC",
    fields: ["name", "logo", "city", "country", "website", "description", "industry", "size", "type"],
  },
  skills: {
    table: "skills",
    orderBy: "category ASC, name ASC",
    fields: ["name", "category", "icon", "level"],
  },
  technologies: {
    table: "technologies",
    orderBy: "category ASC NULLS LAST, name ASC",
    fields: ["name", "category"],
  },
  settings: {
    table: "site_settings",
    orderBy: "setting_key ASC",
    fields: ["setting_key", "setting_value", "description"],
  },
  educations: {
    table: "educations",
    orderBy: "display_order ASC NULLS LAST, start_date DESC NULLS LAST, title ASC",
    fields: ["title", "school_id", "degree", "field", "description", "start_date", "end_date", "status", "display_order"],
  },
  jobs: {
    table: "jobs",
    orderBy: "start_date DESC NULLS LAST, title ASC",
    fields: ["title", "company_id", "contract_type", "location", "remote_type", "start_date", "end_date", "status", "description", "missions", "technologies", "project_ids"],
  },
  projects: {
    table: "projects",
    orderBy: "start_date DESC NULLS LAST, name ASC",
    fields: ["name", "slug", "main_image", "images", "short_description", "long_description", "goal", "features", "technologies", "github_url", "demo_url", "start_date", "end_date", "status", "category", "school_id", "company_id", "job_id"],
  },
};

const ARRAY_FIELDS = new Set(["technologies", "skills", "features", "images", "missions", "project_ids"]);
const INTEGER_FIELDS = new Set(["school_id", "company_id", "job_id"]);
const INTEGER_ARRAY_FIELDS = new Set(["project_ids", "technology_ids", "skill_ids"]);
const EDUCATION_RELATIONS = {
  technology_ids: {
    table: "education_technologies",
    column: "technology_id",
  },
  skill_ids: {
    table: "education_skills",
    column: "skill_id",
  },
  project_ids: {
    table: "education_projects",
    column: "project_id",
  },
};

function toArray(value) {
  if (Array.isArray(value)) return value.map((item) => String(item).trim()).filter(Boolean);
  if (!value) return [];
  return String(value)
    .split(/\r?\n|,/)
    .map((item) => item.trim())
    .filter(Boolean);
}

function normalizeValue(field, value) {
  if (INTEGER_ARRAY_FIELDS.has(field)) {
    return toArray(value).map((item) => Number.parseInt(item, 10)).filter(Number.isInteger);
  }
  if (ARRAY_FIELDS.has(field)) return toArray(value);
  if (INTEGER_FIELDS.has(field)) {
    const parsed = Number.parseInt(value, 10);
    return Number.isInteger(parsed) ? parsed : null;
  }
  if (field === "display_order") {
    const parsed = Number.parseInt(value, 10);
    return Number.isInteger(parsed) ? parsed : null;
  }
  return value === "" || value === undefined ? null : value;
}

function normalizePayload(entity, body) {
  const config = ENTITY_CONFIG[entity];
  const payload = {};

  for (const field of config.fields) {
    payload[field] = normalizeValue(field, body[field]);
  }

  if ((entity === "projects" || entity === "schools") && !payload.slug && payload.name) {
    payload.slug = slugify(payload.name);
  }

  return payload;
}

function slugify(value) {
  return String(value)
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-+|-+$/g, "");
}

async function list(entity) {
  if (entity === "schools") return listSchools();
  if (entity === "educations") return listEducations();
  const config = ENTITY_CONFIG[entity];
  const result = await pool.query(`SELECT * FROM ${config.table} ORDER BY ${config.orderBy}`);
  return signMediaFields(result.rows);
}

async function findById(entity, id) {
  if (entity === "educations") return findEducationById(id);
  const config = ENTITY_CONFIG[entity];
  const result = await pool.query(`SELECT * FROM ${config.table} WHERE id = $1`, [id]);
  return signMediaFields(result.rows)[0] || null;
}

async function findProjectBySlug(slug) {
  const result = await pool.query(
    `SELECT p.*, s.name AS school_name, c.name AS company_name, j.title AS job_title
     FROM projects p
     LEFT JOIN schools s ON s.id = p.school_id
     LEFT JOIN companies c ON c.id = p.company_id
     LEFT JOIN jobs j ON j.id = p.job_id
     WHERE p.slug = $1`,
    [slug]
  );
  return signMediaFields(result.rows)[0] || null;
}

async function create(entity, body) {
  const config = ENTITY_CONFIG[entity];
  const payload = normalizePayload(entity, body);
  const fields = Object.keys(payload);
  const placeholders = fields.map((_, index) => `$${index + 1}`);
  const values = fields.map((field) => payload[field]);
  const result = await pool.query(
    `INSERT INTO ${config.table} (${fields.join(", ")}) VALUES (${placeholders.join(", ")}) RETURNING *`,
    values
  );
  if (entity === "educations") {
    await syncEducationRelations(result.rows[0].id, body);
    return findEducationById(result.rows[0].id);
  }
  return result.rows[0];
}

async function update(entity, id, body) {
  const config = ENTITY_CONFIG[entity];
  const payload = normalizePayload(entity, body);
  const fields = Object.keys(payload);
  const assignments = fields.map((field, index) => `${field} = $${index + 1}`);
  const values = fields.map((field) => payload[field]);
  values.push(id);
  const result = await pool.query(
    `UPDATE ${config.table} SET ${assignments.join(", ")}, updated_at = now() WHERE id = $${values.length} RETURNING *`,
    values
  );
  if (entity === "educations" && result.rows[0]) {
    await syncEducationRelations(id, body);
    return findEducationById(id);
  }
  return result.rows[0] || null;
}

async function remove(entity, id) {
  const config = ENTITY_CONFIG[entity];
  await pool.query(`DELETE FROM ${config.table} WHERE id = $1`, [id]);
}

async function getPublicData() {
  const [projects, educations, jobs, schools, companies, skills, settings] = await Promise.all([
    pool.query(`SELECT p.*, s.name AS school_name, c.name AS company_name
                FROM projects p
                LEFT JOIN schools s ON s.id = p.school_id
                LEFT JOIN companies c ON c.id = p.company_id
                ORDER BY p.start_date DESC NULLS LAST, p.name ASC`),
    listEducations(),
    pool.query(`SELECT j.*, c.name AS company_name, c.logo AS company_logo, c.city AS company_city, c.country AS company_country
                FROM jobs j
                LEFT JOIN companies c ON c.id = j.company_id
                ORDER BY j.start_date DESC NULLS LAST, j.title ASC`),
    listSchools(),
    list("companies"),
    list("skills"),
    list("settings"),
  ]);

  return {
    projects: signMediaFields(projects.rows),
    educations,
    jobs: signMediaFields(jobs.rows),
    schools,
    companies,
    skills,
    settings,
  };
}

async function getSettingsMap() {
  const settings = await list("settings");
  return settings.reduce((map, setting) => {
    map[setting.setting_key] = setting.setting_value;
    return map;
  }, {});
}

async function getAdminStats() {
  const tables = ["projects", "schools", "companies", "jobs", "educations", "skills", "technologies"];
  const counts = {};
  for (const table of tables) {
    const result = await pool.query(`SELECT COUNT(*)::int AS count FROM ${table}`);
    counts[table] = result.rows[0].count;
  }

  const latest = await pool.query(
    `(SELECT 'Projet' AS type, name AS title, updated_at FROM projects)
     UNION ALL
     (SELECT 'Ecole' AS type, name AS title, updated_at FROM schools)
     UNION ALL
     (SELECT 'Entreprise' AS type, name AS title, updated_at FROM companies)
     UNION ALL
     (SELECT 'Experience' AS type, title, updated_at FROM jobs)
     UNION ALL
     (SELECT 'Formation' AS type, title, updated_at FROM educations)
     ORDER BY updated_at DESC
     LIMIT 8`
  );

  return { counts, latest: latest.rows };
}

function signMediaValue(value) {
  if (!value || /^https?:\/\//.test(String(value))) return value;
  return media.signedUrl({ public_id: value, resource_type: "image" });
}

function signMediaFields(rows) {
  return rows.map((row) => {
    const signed = { ...row };
    if (signed.logo) signed.logo_url = signMediaValue(signed.logo);
    if (signed.school_logo) signed.school_logo_url = signMediaValue(signed.school_logo);
    if (signed.main_image) signed.main_image_url = signMediaValue(signed.main_image);
    if (Array.isArray(signed.images)) {
      signed.image_urls = signed.images.map(signMediaValue).filter(Boolean);
    }
    return signed;
  });
}

async function listSchools() {
  const result = await pool.query(
    `SELECT s.*,
            COALESCE(
              array_agg(e.title ORDER BY e.display_order ASC NULLS LAST, e.start_date DESC NULLS LAST)
              FILTER (WHERE e.id IS NOT NULL),
              '{}'
            ) AS education_titles
     FROM schools s
     LEFT JOIN educations e ON e.school_id = s.id
     GROUP BY s.id
     ORDER BY s.name ASC`
  );
  return signMediaFields(result.rows);
}

async function listEducations() {
  const result = await pool.query(
    `SELECT e.*,
            s.name AS school_name,
            s.logo AS school_logo,
            s.city AS school_city,
            s.country AS school_country,
            COALESCE(array_agg(DISTINCT t.name) FILTER (WHERE t.id IS NOT NULL), '{}') AS technologies,
            COALESCE(array_agg(DISTINCT sk.name) FILTER (WHERE sk.id IS NOT NULL), '{}') AS skills,
            COALESCE(array_agg(DISTINCT p.name) FILTER (WHERE p.id IS NOT NULL), '{}') AS project_names,
            COALESCE(
              jsonb_agg(DISTINCT jsonb_build_object('id', p.id, 'name', p.name, 'slug', p.slug))
              FILTER (WHERE p.id IS NOT NULL),
              '[]'::jsonb
            ) AS projects
     FROM educations e
     LEFT JOIN schools s ON s.id = e.school_id
     LEFT JOIN education_technologies et ON et.education_id = e.id
     LEFT JOIN technologies t ON t.id = et.technology_id
     LEFT JOIN education_skills es ON es.education_id = e.id
     LEFT JOIN skills sk ON sk.id = es.skill_id
     LEFT JOIN education_projects ep ON ep.education_id = e.id
     LEFT JOIN projects p ON p.id = ep.project_id
     GROUP BY e.id, s.id
     ORDER BY e.display_order ASC NULLS LAST, e.start_date DESC NULLS LAST, e.title ASC`
  );
  return signMediaFields(result.rows);
}

async function findEducationById(id) {
  const result = await pool.query(
    `SELECT e.*,
            COALESCE(array_agg(DISTINCT et.technology_id) FILTER (WHERE et.technology_id IS NOT NULL), '{}') AS technology_ids,
            COALESCE(array_agg(DISTINCT es.skill_id) FILTER (WHERE es.skill_id IS NOT NULL), '{}') AS skill_ids,
            COALESCE(array_agg(DISTINCT ep.project_id) FILTER (WHERE ep.project_id IS NOT NULL), '{}') AS project_ids
     FROM educations e
     LEFT JOIN education_technologies et ON et.education_id = e.id
     LEFT JOIN education_skills es ON es.education_id = e.id
     LEFT JOIN education_projects ep ON ep.education_id = e.id
     WHERE e.id = $1
     GROUP BY e.id`,
    [id]
  );
  return result.rows[0] || null;
}

async function syncEducationRelations(educationId, body) {
  for (const [field, relation] of Object.entries(EDUCATION_RELATIONS)) {
    const ids = normalizeValue(field, body[field]);
    await pool.query(`DELETE FROM ${relation.table} WHERE education_id = $1`, [educationId]);
    for (const id of ids) {
      await pool.query(
        `INSERT INTO ${relation.table} (education_id, ${relation.column})
         VALUES ($1, $2)
         ON CONFLICT DO NOTHING`,
        [educationId, id]
      );
    }
  }
}

module.exports = {
  ENTITY_CONFIG,
  create,
  findById,
  findProjectBySlug,
  getAdminStats,
  getPublicData,
  getSettingsMap,
  list,
  remove,
  signMediaValue,
  slugify,
  update,
};
