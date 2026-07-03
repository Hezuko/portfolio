-- Met à jour KellyTravelService : vrais visuels du site (héro + formulaire),
-- dates du projet (déc. 2024 → janv. 2025), et retire le nom du client.
BEGIN;

UPDATE projects SET
  main_image = '/images/projects/kellytravelservice/hero.jpg',
  images = ARRAY['/images/projects/kellytravelservice/reservation.jpg']::text[],
  start_date = '2024-12-01',
  end_date = '2025-01-31',
  context = 'Un chauffeur VTC prenait ses réservations par téléphone, au risque de manquer des appels et de perdre des clients. Il voulait un site simple où ses clients réservent en autonomie, à toute heure, et où lui reçoit chaque demande instantanément. J''ai conçu et développé ce site de bout en bout.',
  updated_at = now()
WHERE slug = 'kellytravelservice';

COMMIT;
