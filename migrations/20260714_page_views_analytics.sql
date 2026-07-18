-- Statistiques de visite intégrées (sans cookies, sans IP stockée).
-- Chaque page vue publique = 1 ligne : chemin, référent, pays, hash visiteur
-- anonyme (sha256 secret+jour+ip+ua — l'IP n'est ni stockée ni retrouvable).
BEGIN;

CREATE TABLE IF NOT EXISTS page_views (
  id BIGSERIAL PRIMARY KEY,
  ts TIMESTAMPTZ NOT NULL DEFAULT now(),
  path TEXT NOT NULL,
  referrer_host TEXT,          -- hôte du référent (linkedin.com, google.com…), NULL = direct
  country CHAR(2),             -- code pays (géolocalisation locale, approximative)
  visitor_hash CHAR(16) NOT NULL, -- identifiant anonyme, rotatif par jour
  is_mobile BOOLEAN NOT NULL DEFAULT false
);

-- (index d'expression sur ts::date refusé : cast non IMMUTABLE en timestamptz ;
--  au volume d'un portfolio, l'index simple sur ts couvre tous les agrégats)
CREATE INDEX IF NOT EXISTS idx_page_views_ts ON page_views (ts DESC);

COMMIT;
