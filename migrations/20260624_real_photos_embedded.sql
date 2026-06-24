-- Vraies photos extraites des rapports : robot réel (Hackathon) et carte réelle (MPQ) en héro + galeries enrichies.
BEGIN;

-- Hackathon : héro = robot réel ; galerie = carte mère annotée + carte mère réelle + vidéos + schémas
UPDATE projects SET
  main_image = '/images/projects/base-mobile-robot-hackathon/robot-reel.png',
  images = ARRAY[
    '/images/projects/base-mobile-robot-hackathon/carte-mere.png',
    '/images/projects/base-mobile-robot-hackathon/carte-mere-reelle.jpg',
    '/images/projects/base-mobile-robot-hackathon/suivi-objet.mp4',
    '/images/projects/base-mobile-robot-hackathon/asservissement-pid.png',
    '/images/projects/base-mobile-robot-hackathon/asservissement.mp4',
    '/images/projects/base-mobile-robot-hackathon/ultrason.mp4',
    '/images/projects/base-mobile-robot-hackathon/synoptique.png'
  ]::text[],
  updated_at = now()
WHERE slug = 'base-mobile-robot-hackathon';

-- Stage MPQ : héro = carte fabriquée réelle ; galerie = verso réel + rendus PCB + module RF + Arduino (migration)
UPDATE projects SET
  main_image = '/images/projects/systeme-embarque-pic-stage-mpq/carte-reelle.png',
  images = ARRAY[
    '/images/projects/systeme-embarque-pic-stage-mpq/carte-reelle-verso.png',
    '/images/projects/systeme-embarque-pic-stage-mpq/pcb-routage.png',
    '/images/projects/systeme-embarque-pic-stage-mpq/pcb-top.png',
    '/images/projects/systeme-embarque-pic-stage-mpq/pcb-bottom.png',
    '/images/projects/systeme-embarque-pic-stage-mpq/pcb-inner1.png',
    '/images/projects/systeme-embarque-pic-stage-mpq/pcb-inner2.png',
    '/images/projects/systeme-embarque-pic-stage-mpq/module-rf-si4432.jpg',
    '/images/projects/systeme-embarque-pic-stage-mpq/arduino-prototype.png'
  ]::text[],
  updated_at = now()
WHERE slug = 'systeme-embarque-pic-stage-mpq';

COMMIT;
