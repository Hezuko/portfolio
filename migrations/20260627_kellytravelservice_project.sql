-- Ajoute le projet client KellyTravelService (site de réservation VTC).
-- Idempotent : n'insère que si le slug n'existe pas déjà.
BEGIN;

INSERT INTO projects (
  name, slug, category, status,
  short_description, long_description, goal, context, architecture, results,
  demo_url, end_date, features, technologies, main_image, images
)
SELECT
  'KellyTravelService — réservation VTC en ligne',
  'kellytravelservice',
  'web',
  'completed',
  'Site de réservation en ligne pour un chauffeur VTC : réserver une course en quelques clics, avec confirmation instantanée par SMS et email.',
  'Site de réservation développé pour un chauffeur VTC. Les clients réservent une course en autonomie, à toute heure, via un formulaire simple ; chaque demande déclenche une confirmation immédiate par SMS et par email, et notifie le chauffeur en temps réel.',
  'Permettre aux clients d''un chauffeur VTC de réserver une course rapidement en ligne, sans appel, avec une confirmation immédiate.',
  'Un chauffeur VTC (Pitchou Katende) prenait ses réservations par téléphone, au risque de manquer des appels et de perdre des clients. Il voulait un site simple où ses clients réservent en autonomie, à toute heure, et où lui reçoit chaque demande instantanément. J''ai conçu et développé ce site de bout en bout.',
  'Application web Node.js / Express rendue côté serveur en EJS, stylée avec Bootstrap et SASS. Les réservations sont stockées en PostgreSQL. À chaque demande, une notification part instantanément par SMS via Twilio et par email via Nodemailer. Les formulaires sont validés côté serveur (express-validator) pour fiabiliser les données, et une partie du code est typée en TypeScript.',
  'Le chauffeur reçoit désormais ses réservations en ligne, automatiquement et en temps réel, sans manquer d''appel. Le projet montre que je sais livrer un site client complet et utile : de la prise de besoin au développement full-stack, jusqu''aux notifications SMS/email et à la mise en ligne.',
  'https://kts-taxi.fr',
  '2026-05-01',
  ARRAY[
    'Réservation d''une course en quelques clics, 24h/24',
    'Confirmation instantanée par SMS (Twilio) et par email',
    'Formulaire simple avec validation des informations',
    'Notification immédiate du chauffeur à chaque demande',
    'Interface responsive, pensée mobile d''abord'
  ]::text[],
  ARRAY[
    'Node.js', 'Express', 'EJS', 'PostgreSQL', 'Bootstrap', 'SASS',
    'Twilio (SMS)', 'Nodemailer', 'TypeScript', 'express-validator'
  ]::text[],
  '/images/projects/kellytravelservice/logo.webp',
  ARRAY[
    '/images/projects/kellytravelservice/tour-eiffel-nuit.webp',
    '/images/projects/kellytravelservice/arc-de-triomphe.webp'
  ]::text[]
WHERE NOT EXISTS (SELECT 1 FROM projects WHERE slug = 'kellytravelservice');

COMMIT;
