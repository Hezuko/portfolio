BEGIN;

ALTER TABLE schools ADD COLUMN IF NOT EXISTS slug VARCHAR(255);

UPDATE schools
SET slug = trim(both '-' from regexp_replace(lower(name), '[^a-z0-9]+', '-', 'g')) || '-' || id
WHERE slug IS NULL OR slug = '';

UPDATE schools
SET slug = 'school-' || id
WHERE slug IS NULL OR slug = '' OR slug = '-';

ALTER TABLE schools ALTER COLUMN slug SET NOT NULL;
CREATE UNIQUE INDEX IF NOT EXISTS schools_slug_unique ON schools(slug);

ALTER TABLE educations ADD COLUMN IF NOT EXISTS display_order INTEGER;

CREATE TABLE IF NOT EXISTS technologies (
    id SERIAL PRIMARY KEY,
    name VARCHAR(120) NOT NULL UNIQUE,
    category VARCHAR(120),
    created_at TIMESTAMP NOT NULL DEFAULT now(),
    updated_at TIMESTAMP NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS education_technologies (
    education_id INTEGER NOT NULL REFERENCES educations(id) ON DELETE CASCADE,
    technology_id INTEGER NOT NULL REFERENCES technologies(id) ON DELETE CASCADE,
    PRIMARY KEY (education_id, technology_id)
);

CREATE TABLE IF NOT EXISTS education_skills (
    education_id INTEGER NOT NULL REFERENCES educations(id) ON DELETE CASCADE,
    skill_id INTEGER NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
    PRIMARY KEY (education_id, skill_id)
);

CREATE TABLE IF NOT EXISTS education_projects (
    education_id INTEGER NOT NULL REFERENCES educations(id) ON DELETE CASCADE,
    project_id INTEGER NOT NULL REFERENCES projects(id) ON DELETE CASCADE,
    PRIMARY KEY (education_id, project_id)
);

INSERT INTO technologies (name, category)
VALUES
('C', 'Langage'),
('C++', 'Langage'),
('Python', 'Langage'),
('Electronique', 'Matiere'),
('Microcontroleurs', 'Electronique'),
('FPGA', 'Electronique'),
('VHDL', 'Langage'),
('Automatisme', 'Matiere'),
('Mathematiques', 'Matiere'),
('Physique', 'Matiere'),
('Systemes embarques', 'Systeme'),
('Linux embarque', 'Systeme'),
('CAN', 'Protocole'),
('UART', 'Protocole'),
('SPI', 'Protocole'),
('I2C', 'Protocole')
ON CONFLICT (name) DO NOTHING;

DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'educations' AND column_name = 'technologies'
  ) THEN
    INSERT INTO technologies (name, category)
    SELECT DISTINCT trim(value), 'Formation'
    FROM educations
    CROSS JOIN LATERAL unnest(technologies) AS value
    WHERE trim(value) <> ''
    ON CONFLICT (name) DO NOTHING;

    INSERT INTO education_technologies (education_id, technology_id)
    SELECT DISTINCT e.id, t.id
    FROM educations e
    CROSS JOIN LATERAL unnest(e.technologies) AS value
    JOIN technologies t ON t.name = trim(value)
    WHERE trim(value) <> ''
    ON CONFLICT DO NOTHING;
  END IF;

  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'educations' AND column_name = 'skills'
  ) THEN
    INSERT INTO skills (name, category)
    SELECT DISTINCT trim(value), 'Formation'
    FROM educations
    CROSS JOIN LATERAL unnest(skills) AS value
    WHERE trim(value) <> ''
      AND NOT EXISTS (
        SELECT 1 FROM skills s WHERE lower(s.name) = lower(trim(value))
      );

    INSERT INTO education_skills (education_id, skill_id)
    SELECT DISTINCT e.id, s.id
    FROM educations e
    CROSS JOIN LATERAL unnest(e.skills) AS value
    JOIN skills s ON lower(s.name) = lower(trim(value))
    WHERE trim(value) <> ''
    ON CONFLICT DO NOTHING;
  END IF;

  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'educations' AND column_name = 'project_ids'
  ) THEN
    INSERT INTO education_projects (education_id, project_id)
    SELECT DISTINCT e.id, project_id
    FROM educations e
    CROSS JOIN LATERAL unnest(e.project_ids) AS project_id
    JOIN projects p ON p.id = project_id
    ON CONFLICT DO NOTHING;
  END IF;
END $$;

ALTER TABLE schools DROP COLUMN IF EXISTS start_date;
ALTER TABLE schools DROP COLUMN IF EXISTS end_date;
ALTER TABLE schools DROP COLUMN IF EXISTS degree;
ALTER TABLE schools DROP COLUMN IF EXISTS field;
ALTER TABLE schools DROP COLUMN IF EXISTS status;
ALTER TABLE schools DROP COLUMN IF EXISTS technologies;

ALTER TABLE educations DROP COLUMN IF EXISTS skills;
ALTER TABLE educations DROP COLUMN IF EXISTS technologies;
ALTER TABLE educations DROP COLUMN IF EXISTS project_ids;

COMMIT;
