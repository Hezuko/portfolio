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
    fields: ["name", "category", "description", "icon", "level"],
  },
  technologies: {
    table: "technologies",
    orderBy: "category ASC NULLS LAST, name ASC",
    fields: ["name", "category"],
  },
  course_categories: {
    table: "course_categories",
    orderBy: "display_order ASC NULLS LAST, name ASC",
    fields: ["name", "description", "skills_summary", "display_order"],
  },
  courses: {
    table: "courses",
    orderBy: "category_id ASC NULLS LAST, display_order ASC NULLS LAST, code ASC",
    fields: ["code", "title", "formation_year", "semester", "hours", "ects", "description", "skills_summary", "category_id", "display_order"],
  },
  settings: {
    table: "site_settings",
    orderBy: "setting_key ASC",
    fields: ["setting_key", "setting_value", "description"],
  },
  educations: {
    table: "educations",
    orderBy: "display_order ASC NULLS LAST, start_date DESC NULLS LAST, title ASC",
    fields: ["title", "school_id", "degree", "field", "description", "context", "program_summary", "program_distribution", "key_subjects", "personal_contribution", "start_date", "end_date", "status", "display_order"],
  },
  jobs: {
    table: "jobs",
    orderBy: "start_date DESC NULLS LAST, title ASC",
    fields: ["title", "company_id", "contract_type", "location", "remote_type", "start_date", "end_date", "status", "description", "short_summary", "lab_name", "supervision", "function_title", "exact_dates", "company_context", "mission_context", "product_context", "first_year_summary", "first_year_tasks", "first_year_achievements", "first_year_tools", "first_year_skills", "second_year_summary", "second_year_tasks", "second_year_achievements", "second_year_tools", "second_year_skills", "problem_statement", "system_architecture", "missions", "achievements", "technical_challenges", "technologies", "tools", "methods", "results", "results_list", "personal_contribution", "personal_contribution_list", "skills_developed", "document_title", "document_url", "document_description", "project_ids"],
  },
  projects: {
    table: "projects",
    orderBy: "start_date DESC NULLS LAST, name ASC",
    fields: ["name", "slug", "main_image", "images", "short_description", "long_description", "context", "goal", "features", "architecture", "technologies", "challenges", "results", "future_improvements", "github_url", "demo_url", "start_date", "end_date", "status", "category", "school_id", "company_id", "job_id"],
  },
  project_sections: {
    table: "project_sections",
    orderBy: "project_id ASC, display_order ASC NULLS LAST, id ASC",
    fields: ["project_id", "title", "subtitle", "body", "section_type", "layout", "display_order", "is_visible", "media_id", "media_position", "media_caption", "media_alt_text"],
  },
};

const ARRAY_FIELDS = new Set(["technologies", "skills", "features", "images", "missions", "achievements", "technical_challenges", "methods", "skills_developed", "key_subjects", "project_ids", "first_year_tasks", "first_year_achievements", "first_year_tools", "first_year_skills", "second_year_tasks", "second_year_achievements", "second_year_tools", "second_year_skills", "tools", "results_list", "personal_contribution_list"]);
const INTEGER_FIELDS = new Set(["school_id", "company_id", "job_id", "category_id", "project_id", "media_id"]);
const INTEGER_ARRAY_FIELDS = new Set(["project_ids", "technology_ids", "skill_ids", "course_ids"]);
const BOOLEAN_FIELDS = new Set(["is_visible"]);
const PROJECT_SECTION_MEDIA_FIELDS = new Set(["media_id", "media_position", "media_caption", "media_alt_text"]);
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
  course_ids: {
    table: "education_courses",
    column: "course_id",
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
  if (BOOLEAN_FIELDS.has(field)) {
    if (value === true || value === "true" || value === "on" || value === "1") return true;
    if (value === false || value === "false" || value === "0") return false;
    return null;
  }
  return value === "" || value === undefined ? null : value;
}

function normalizePayload(entity, body) {
  const config = ENTITY_CONFIG[entity];
  const payload = {};

  for (const field of config.fields) {
    if (entity === "project_sections" && PROJECT_SECTION_MEDIA_FIELDS.has(field)) continue;
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
  if (entity === "project_sections") return listProjectSections();
  const config = ENTITY_CONFIG[entity];
  const result = await pool.query(`SELECT * FROM ${config.table} ORDER BY ${config.orderBy}`);
  return signMediaFields(result.rows);
}

async function findById(entity, id) {
  if (entity === "educations") return findEducationById(id);
  if (entity === "project_sections") return findProjectSectionById(id);
  const config = ENTITY_CONFIG[entity];
  const result = await pool.query(`SELECT * FROM ${config.table} WHERE id = $1`, [id]);
  return signMediaFields(result.rows)[0] || null;
}

async function getEducationDetail(id) {
  const educations = await listEducations();
  const education = educations.find((item) => Number(item.id) === Number(id)) || null;
  if (!education) return null;
  education.program = await getEducationProgram(id);
  return education;
}

async function getJobDetail(id) {
  const result = await pool.query(
    `SELECT j.*,
            c.name AS company_name,
            c.logo AS company_logo,
            c.city AS company_city,
            c.country AS company_country,
            c.website AS company_website,
            c.description AS company_description,
            c.industry AS company_industry,
            c.size AS company_size,
            c.type AS company_type,
            COALESCE(
              array_agg(other_jobs.title ORDER BY other_jobs.start_date DESC NULLS LAST)
              FILTER (WHERE other_jobs.id IS NOT NULL),
              '{}'
            ) AS company_job_titles
     FROM jobs j
     LEFT JOIN companies c ON c.id = j.company_id
     LEFT JOIN jobs other_jobs ON other_jobs.company_id = c.id
     WHERE j.id = $1
     GROUP BY j.id, c.id`,
    [id]
  );
  const job = signMediaFields(result.rows)[0] || null;
  if (!job) return null;
  if (Array.isArray(job.project_ids) && job.project_ids.length) {
    const projects = await pool.query(
      `SELECT id, name, slug, short_description
       FROM projects
       WHERE id = ANY($1::int[])
       ORDER BY start_date DESC NULLS LAST, name ASC`,
      [job.project_ids]
    );
    job.projects = projects.rows;
  } else {
    job.projects = [];
  }
  return job;
}

async function findProjectBySlug(slug) {
  const result = await pool.query(
    `SELECT p.*,
            s.name AS school_name,
            s.logo AS school_logo,
            s.city AS school_city,
            s.country AS school_country,
            s.website AS school_website,
            c.name AS company_name,
            c.logo AS company_logo,
            c.city AS company_city,
            c.country AS company_country,
            c.website AS company_website,
            c.industry AS company_industry,
            j.title AS job_title
     FROM projects p
     LEFT JOIN schools s ON s.id = p.school_id
     LEFT JOIN companies c ON c.id = p.company_id
     LEFT JOIN jobs j ON j.id = p.job_id
     WHERE p.slug = $1`,
    [slug]
  );
  const project = signMediaFields(result.rows)[0] || null;
  if (!project) return null;
  const [educations, sections] = await Promise.all([
    pool.query(
    `SELECT e.id, e.title, s.name AS school_name
     FROM education_projects ep
     JOIN educations e ON e.id = ep.education_id
     LEFT JOIN schools s ON s.id = e.school_id
     WHERE ep.project_id = $1
     ORDER BY e.display_order ASC NULLS LAST, e.start_date DESC NULLS LAST`,
    [project.id]
    ),
    getProjectSections(project.id),
  ]);
  project.educations = educations.rows;
  project.sections = sections;
  return project;
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
  if (entity === "project_sections") {
    await syncProjectSectionMedia(result.rows[0].id, body);
    return findProjectSectionById(result.rows[0].id);
  }
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
  if (entity === "project_sections" && result.rows[0]) {
    await syncProjectSectionMedia(id, body);
    return findProjectSectionById(id);
  }
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
    pool.query(`SELECT j.*,
                       c.name AS company_name,
                       c.logo AS company_logo,
                       c.city AS company_city,
                       c.country AS company_country,
                       c.website AS company_website,
                       c.description AS company_description,
                       c.industry AS company_industry,
                       c.size AS company_size,
                       c.type AS company_type,
                       COALESCE(
                         array_agg(other_jobs.title ORDER BY other_jobs.start_date DESC NULLS LAST)
                         FILTER (WHERE other_jobs.id IS NOT NULL),
                         '{}'
                       ) AS company_job_titles
                FROM jobs j
                LEFT JOIN companies c ON c.id = j.company_id
                LEFT JOIN jobs other_jobs ON other_jobs.company_id = c.id
                GROUP BY j.id, c.id
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
  // Laisse passer les URLs absolues et les chemins statiques locaux (/images/...).
  // Le reste est traité comme un public_id Cloudinary à signer.
  if (!value || /^(https?:\/\/|\/)/.test(String(value))) return value;
  return media.signedUrl({ public_id: value, resource_type: "image" });
}

function signMediaFields(rows) {
  return rows.map((row) => {
    const signed = { ...row };
    if (signed.logo) signed.logo_url = signMediaValue(signed.logo);
    if (signed.school_logo) signed.school_logo_url = signMediaValue(signed.school_logo);
    if (signed.company_logo) signed.company_logo_url = signMediaValue(signed.company_logo);
    if (signed.main_image) signed.main_image_url = signMediaValue(signed.main_image);
    if (Array.isArray(signed.images)) {
      signed.image_urls = signed.images.map(signMediaValue).filter(Boolean);
    }
    return signed;
  });
}

function signProjectSectionMedia(rows) {
  return rows.map((row) => {
    const signed = { ...row };
    if (signed.media_public_id) {
      signed.media_url = media.signedUrl({
        public_id: signed.media_public_id,
        resource_type: signed.media_resource_type,
        version: signed.media_version,
      });
      signed.media_alt_text = signed.media_alt_text || signed.media_default_alt_text || signed.title || signed.media_display_name || "";
      signed.media_caption = signed.media_caption || signed.media_default_caption || "";
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
            s.website AS school_website,
            s.description AS school_description,
            COALESCE(
              array_agg(DISTINCT school_educations.title)
              FILTER (WHERE school_educations.id IS NOT NULL),
              '{}'
            ) AS school_education_titles,
            COALESCE(array_agg(DISTINCT t.name) FILTER (WHERE t.id IS NOT NULL), '{}') AS technologies,
            COALESCE(
              jsonb_agg(DISTINCT jsonb_build_object('id', t.id, 'name', t.name, 'category', t.category))
              FILTER (WHERE t.id IS NOT NULL),
              '[]'::jsonb
            ) AS technology_details,
            COALESCE(array_agg(DISTINCT sk.name) FILTER (WHERE sk.id IS NOT NULL), '{}') AS skills,
            COALESCE(
              jsonb_agg(DISTINCT jsonb_build_object('id', sk.id, 'name', sk.name, 'category', sk.category, 'level', sk.level))
              FILTER (WHERE sk.id IS NOT NULL),
              '[]'::jsonb
            ) AS skill_details,
            COALESCE(array_agg(DISTINCT p.name) FILTER (WHERE p.id IS NOT NULL), '{}') AS project_names,
            COALESCE(
              jsonb_agg(DISTINCT jsonb_build_object('id', p.id, 'name', p.name, 'slug', p.slug))
              FILTER (WHERE p.id IS NOT NULL),
              '[]'::jsonb
            ) AS projects
     FROM educations e
     LEFT JOIN schools s ON s.id = e.school_id
     LEFT JOIN educations school_educations ON school_educations.school_id = s.id
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
            COALESCE(array_agg(DISTINCT ep.project_id) FILTER (WHERE ep.project_id IS NOT NULL), '{}') AS project_ids,
            COALESCE(array_agg(DISTINCT ec.course_id) FILTER (WHERE ec.course_id IS NOT NULL), '{}') AS course_ids
     FROM educations e
     LEFT JOIN education_technologies et ON et.education_id = e.id
     LEFT JOIN education_skills es ON es.education_id = e.id
     LEFT JOIN education_projects ep ON ep.education_id = e.id
     LEFT JOIN education_courses ec ON ec.education_id = e.id
     WHERE e.id = $1
     GROUP BY e.id`,
    [id]
  );
  return result.rows[0] || null;
}

async function getEducationProgram(educationId) {
  const result = await pool.query(
    `SELECT c.id,
            c.code,
            c.title,
            c.formation_year,
            c.semester,
            c.hours,
            c.ects,
            c.description,
            c.skills_summary,
            c.display_order,
            cc.id AS category_id,
            cc.name AS category_name,
            cc.description AS category_description,
            cc.skills_summary AS category_skills_summary,
            cc.display_order AS category_order
     FROM education_courses ec
     JOIN courses c ON c.id = ec.course_id
     LEFT JOIN course_categories cc ON cc.id = c.category_id
     WHERE ec.education_id = $1
     ORDER BY cc.display_order ASC NULLS LAST, cc.name ASC, c.display_order ASC NULLS LAST, c.code ASC`,
    [educationId]
  );

  const groups = [];
  const byCategory = new Map();
  for (const course of result.rows) {
    const key = course.category_id || "uncategorized";
    if (!byCategory.has(key)) {
      byCategory.set(key, {
        id: course.category_id,
        name: course.category_name || "Programme",
        description: course.category_description || "",
        skills_summary: course.category_skills_summary || "",
        order: course.category_order,
        courses: [],
      });
      groups.push(byCategory.get(key));
    }
    byCategory.get(key).courses.push(course);
  }
  return groups;
}

async function listProjectSections() {
  const result = await pool.query(
    `SELECT ps.*,
            p.name AS project_name,
            p.slug AS project_slug,
            p.name || ' — ' || ps.title AS admin_title,
            psm.media_id,
            psm.display_mode AS media_position,
            psm.caption AS media_caption,
            psm.alt_text AS media_alt_text,
            ma.public_id AS media_public_id,
            ma.resource_type AS media_resource_type,
            ma.format AS media_format,
            ma.version AS media_version,
            ma.alt_text AS media_default_alt_text,
            ma.caption AS media_default_caption,
            ma.display_name AS media_display_name,
            ma.original_filename AS media_original_filename
     FROM project_sections ps
     JOIN projects p ON p.id = ps.project_id
     LEFT JOIN project_section_media psm ON psm.section_id = ps.id
     LEFT JOIN media_assets ma ON ma.id = psm.media_id
     ORDER BY p.name ASC, ps.display_order ASC NULLS LAST, ps.id ASC`
  );
  return signProjectSectionMedia(result.rows);
}

async function findProjectSectionById(id) {
  const result = await pool.query(
    `SELECT ps.*,
            p.name AS project_name,
            p.slug AS project_slug,
            psm.media_id,
            psm.display_mode AS media_position,
            psm.caption AS media_caption,
            psm.alt_text AS media_alt_text,
            ma.public_id AS media_public_id,
            ma.resource_type AS media_resource_type,
            ma.format AS media_format,
            ma.version AS media_version,
            ma.alt_text AS media_default_alt_text,
            ma.caption AS media_default_caption,
            ma.display_name AS media_display_name,
            ma.original_filename AS media_original_filename
     FROM project_sections ps
     JOIN projects p ON p.id = ps.project_id
     LEFT JOIN project_section_media psm ON psm.section_id = ps.id
     LEFT JOIN media_assets ma ON ma.id = psm.media_id
     WHERE ps.id = $1`,
    [id]
  );
  return signProjectSectionMedia(result.rows)[0] || null;
}

async function getProjectSections(projectId) {
  const result = await pool.query(
    `SELECT ps.*,
            psm.media_id,
            psm.display_mode AS media_position,
            psm.caption AS media_caption,
            psm.alt_text AS media_alt_text,
            ma.public_id AS media_public_id,
            ma.resource_type AS media_resource_type,
            ma.format AS media_format,
            ma.version AS media_version,
            ma.alt_text AS media_default_alt_text,
            ma.caption AS media_default_caption,
            ma.display_name AS media_display_name,
            ma.original_filename AS media_original_filename
     FROM project_sections ps
     LEFT JOIN project_section_media psm ON psm.section_id = ps.id
     LEFT JOIN media_assets ma ON ma.id = psm.media_id
     WHERE ps.project_id = $1
       AND ps.is_visible = true
       AND (NULLIF(ps.title, '') IS NOT NULL OR NULLIF(ps.body, '') IS NOT NULL OR ma.id IS NOT NULL)
     ORDER BY ps.display_order ASC NULLS LAST, ps.id ASC`,
    [projectId]
  );
  return signProjectSectionMedia(result.rows);
}

async function syncProjectSectionMedia(sectionId, body) {
  const mediaId = normalizeValue("media_id", body.media_id);
  await pool.query("DELETE FROM project_section_media WHERE section_id = $1", [sectionId]);
  if (!mediaId) return;
  await pool.query(
    `INSERT INTO project_section_media (section_id, media_id, display_order, display_mode, caption, alt_text)
     VALUES ($1, $2, 1, $3, $4, $5)`,
    [
      sectionId,
      mediaId,
      body.media_position || "right",
      body.media_caption || null,
      body.media_alt_text || null,
    ]
  );
}

async function attachMediaToProjectSection(sectionId, mediaId, body = {}) {
  await syncProjectSectionMedia(sectionId, {
    media_id: mediaId,
    media_position: body.media_position || "right",
    media_caption: body.media_caption || body.caption || null,
    media_alt_text: body.media_alt_text || body.alt_text || null,
  });
  return findProjectSectionById(sectionId);
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

async function getSkillDetails(idOrName) {
  const byId = Number.isInteger(Number.parseInt(idOrName, 10));
  const skillResult = await pool.query(
    `SELECT * FROM skills WHERE ${byId ? "id = $1" : "lower(name) = lower($1)"} LIMIT 1`,
    [idOrName]
  );
  const skill = skillResult.rows[0] || null;
  if (!skill) return null;
  return buildKnowledgeDetails("skill", skill);
}

async function getTechnologyDetails(idOrName) {
  const byId = Number.isInteger(Number.parseInt(idOrName, 10));
  const technologyResult = await pool.query(
    `SELECT * FROM technologies WHERE ${byId ? "id = $1" : "lower(name) = lower($1)"} LIMIT 1`,
    [idOrName]
  );
  const technology = technologyResult.rows[0] || null;
  if (!technology) return null;
  return buildKnowledgeDetails("technology", technology);
}

async function getKnowledgeDetailsByName(name) {
  return (await getSkillDetails(name)) || (await getTechnologyDetails(name)) || getAdHocKnowledgeDetails(name);
}

async function buildKnowledgeDetails(kind, item) {
  const name = item.name;
  const educationRelation = kind === "technology"
    ? `JOIN education_technologies rel ON rel.education_id = e.id AND rel.technology_id = $1`
    : `JOIN education_skills rel ON rel.education_id = e.id AND rel.skill_id = $1`;

  const [projects, educations, jobs] = await Promise.all([
    pool.query(
      `SELECT id, name, slug, short_description
       FROM projects
       WHERE EXISTS (SELECT 1 FROM unnest(technologies) AS value WHERE lower(value) = lower($1))
       ORDER BY start_date DESC NULLS LAST, name ASC`,
      [name]
    ),
    pool.query(
      `SELECT e.id, e.title, e.degree, e.field, s.name AS school_name
       FROM educations e
       ${educationRelation}
       LEFT JOIN schools s ON s.id = e.school_id
       ORDER BY e.display_order ASC NULLS LAST, e.start_date DESC NULLS LAST`,
      [item.id]
    ),
    pool.query(
      `SELECT j.id, j.title, c.name AS company_name
       FROM jobs j
       LEFT JOIN companies c ON c.id = j.company_id
       WHERE EXISTS (SELECT 1 FROM unnest(j.technologies) AS value WHERE lower(value) = lower($1))
       ORDER BY j.start_date DESC NULLS LAST, j.title ASC`,
      [name]
    ),
  ]);

  return {
    type: kind,
    id: item.id,
    name: item.name,
    category: item.category || null,
    level: item.level || null,
    description: item.description || null,
    projects: projects.rows,
    studies: educations.rows,
    experiences: jobs.rows,
  };
}

async function getAdHocKnowledgeDetails(name) {
  const [projects, jobs] = await Promise.all([
    pool.query(
      `SELECT id, name, slug, short_description
       FROM projects
       WHERE EXISTS (SELECT 1 FROM unnest(technologies) AS value WHERE lower(value) = lower($1))
       ORDER BY start_date DESC NULLS LAST, name ASC`,
      [name]
    ),
    pool.query(
      `SELECT j.id, j.title, c.name AS company_name
       FROM jobs j
       LEFT JOIN companies c ON c.id = j.company_id
       WHERE EXISTS (SELECT 1 FROM unnest(j.technologies) AS value WHERE lower(value) = lower($1))
       ORDER BY j.start_date DESC NULLS LAST, j.title ASC`,
      [name]
    ),
  ]);

  if (!projects.rows.length && !jobs.rows.length) return null;

  return {
    type: "technology",
    id: null,
    name,
    category: null,
    level: null,
    description: null,
    projects: projects.rows,
    studies: [],
    experiences: jobs.rows,
  };
}

module.exports = {
  ENTITY_CONFIG,
  create,
  attachMediaToProjectSection,
  findById,
  findProjectBySlug,
  getAdminStats,
  getEducationDetail,
  getJobDetail,
  getPublicData,
  getKnowledgeDetailsByName,
  getSettingsMap,
  getSkillDetails,
  getTechnologyDetails,
  list,
  remove,
  signMediaValue,
  slugify,
  update,
};
