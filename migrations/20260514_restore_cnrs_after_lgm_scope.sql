UPDATE jobs j
SET company_context = NULL,
    product_context = NULL,
    first_year_summary = NULL,
    first_year_tasks = '{}',
    first_year_achievements = '{}',
    first_year_tools = '{}',
    first_year_skills = '{}',
    second_year_summary = NULL,
    second_year_tasks = '{}',
    second_year_achievements = '{}',
    second_year_tools = '{}',
    second_year_skills = '{}',
    tools = '{}',
    results_list = '{}',
    personal_contribution_list = '{}',
    document_title = CASE
      WHEN document_title = 'Rapport professionnel — Première année d’apprentissage LGM Ingénierie' THEN NULL
      ELSE document_title
    END,
    updated_at = now()
WHERE EXISTS (
  SELECT 1
  FROM companies c
  WHERE c.id = j.company_id
    AND lower(c.name) LIKE '%cnrs%'
);
