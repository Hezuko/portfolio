-- Projet MPQ : les 5 visuels photographiés/exportés en portrait (héro + 4 calques
-- PCB) sont tournés de 270° via Cloudinary pour s'afficher à l'horizontale.
-- Sens vérifié sur les images : a_270 remet la sérigraphie lisible à l'endroit.
-- La transformation est insérée dans l'URL stockée ; cloudinaryUrl() chaîne
-- ensuite ses propres transformations (f_auto, q_auto, largeur).
BEGIN;

UPDATE projects SET
  main_image = replace(main_image, '/image/upload/', '/image/upload/a_270/'),
  images = ARRAY(
    SELECT CASE
      WHEN img LIKE '%pcb-top.png' OR img LIKE '%pcb-bottom.png'
        OR img LIKE '%pcb-inner1.png' OR img LIKE '%pcb-inner2.png'
      THEN replace(img, '/image/upload/', '/image/upload/a_270/')
      ELSE img
    END
    FROM unnest(images) AS img
  ),
  updated_at = now()
WHERE slug = 'systeme-embarque-pic-stage-mpq'
  AND main_image NOT LIKE '%/a_270/%';

COMMIT;
