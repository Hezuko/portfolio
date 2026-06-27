-- Dédoublonnage de contenu + mise au point JoyTrain. Idempotent, réversible (git/backup).
--
-- 1) Expérience LGM (id=2) : « plus de 200 tests unitaires » apparaissait 4 fois.
--    On le garde une seule fois côté visible (results_list) + dans le récit détaillé
--    (first_year_summary, accordéon replié). On retire les 2 puces redondantes.
UPDATE jobs SET
  achievements = (SELECT array_agg(x) FROM unnest(achievements) x WHERE x NOT ILIKE '%200%test%'),
  first_year_achievements = (SELECT array_agg(x) FROM unnest(first_year_achievements) x WHERE x NOT ILIKE '%200%test%')
WHERE id = 2;

-- 2) JoyTrain — Application (id=4) : statut réel = déployé sur VPS (OVH, Docker, HTTPS),
--    bêta avant les stores (App Store/Apple Pay à venir). On lève la contradiction
--    passé/futur (« jusqu'aux stores » / « préparer la mise en ligne »), on remplace
--    l'auto-affirmation par des faits, et on corrige la date (~2 mois → avril 2026).
UPDATE projects SET
  short_description = $t$Une application mobile fitness, nutrition et coach IA que j'ai imaginée, développée et déployée seul — du concept au produit en ligne, bêta avant les stores.$t$,
  long_description  = $t$Une application mobile fitness, nutrition et coach IA que j'ai imaginée, développée et déployée seul — du concept au produit en ligne, bêta avant les stores.$t$,
  results = $t$J'ai porté JoyTrain de bout en bout, seul : penser l'expérience, développer le mobile et le serveur, intégrer l'IA, déployer sur mon VPS (Docker, HTTPS) et préparer la bêta avant les stores.$t$,
  start_date = '2026-04-15'
WHERE id = 4;
