-- Lien CV : résumé GitHub Pages téléchargeable
UPDATE site_settings
SET setting_value = 'https://hezuko.github.io/resume/resume.pdf'
WHERE setting_key = 'cv_url';

-- Auto-description : ingénieur-architecte en systèmes embarqués (produit de A à Z)
UPDATE site_settings
SET setting_value = 'Ingénieur architecte en systèmes embarqués'
WHERE setting_key = 'profile_title';
