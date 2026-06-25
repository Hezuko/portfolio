-- Lien public joytrain.app sur les projets de l'écosystème JoyTrain + vidéo du robot Gamel.
BEGIN;

UPDATE projects
SET demo_url = 'https://joytrain.app', updated_at = now()
WHERE slug IN ('joytrain', 'bora-rag-joytrain', 'joytrain-site-vitrine');

UPDATE projects
SET images = ARRAY[
  '/images/projects/robot-suiveur-de-ligne-gamel-trophy/robot-en-action.mp4',
  '/images/projects/robot-suiveur-de-ligne-gamel-trophy/vue-c.jpg',
  '/images/projects/robot-suiveur-de-ligne-gamel-trophy/pcb-carte-moteur.png',
  '/images/projects/robot-suiveur-de-ligne-gamel-trophy/robot-1.jpg',
  '/images/projects/robot-suiveur-de-ligne-gamel-trophy/schema-kicad.png',
  '/images/projects/robot-suiveur-de-ligne-gamel-trophy/vue-a.jpg',
  '/images/projects/robot-suiveur-de-ligne-gamel-trophy/schema-synoptique.png',
  '/images/projects/robot-suiveur-de-ligne-gamel-trophy/robot-5.jpg',
  '/images/projects/robot-suiveur-de-ligne-gamel-trophy/robot-2.jpg',
  '/images/projects/robot-suiveur-de-ligne-gamel-trophy/robot-3.jpg',
  '/images/projects/robot-suiveur-de-ligne-gamel-trophy/robot-4.jpg',
  '/images/projects/robot-suiveur-de-ligne-gamel-trophy/vue-b.jpg'
]::text[], updated_at = now()
WHERE slug = 'robot-suiveur-de-ligne-gamel-trophy';

COMMIT;
