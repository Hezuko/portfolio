-- Aligne le positionnement affiché (titre + tagline) sur « ingénieur systèmes embarqués »
-- au lieu de l'ancien « développeur web / backend ». Corrige aussi les accents.

UPDATE site_settings
SET setting_value = 'Ingénieur systèmes embarqués'
WHERE setting_key = 'profile_title';

UPDATE site_settings
SET setting_value = 'Ingénieur systèmes embarqués. Je conçois l''électronique et le logiciel qui tourne dessus — du circuit imprimé au cloud.'
WHERE setting_key = 'profile_tagline';
