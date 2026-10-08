-- Anti-spam du formulaire de contact : les messages jugés indésirables sont
-- enregistrés comme les autres mais marqués, pour ne jamais perdre un vrai
-- message en cas de faux positif (relecture possible depuis l'admin).
BEGIN;

ALTER TABLE contacts ADD COLUMN IF NOT EXISTS spam BOOLEAN NOT NULL DEFAULT false;
ALTER TABLE contacts ADD COLUMN IF NOT EXISTS spam_score INTEGER NOT NULL DEFAULT 0;
ALTER TABLE contacts ADD COLUMN IF NOT EXISTS spam_reasons TEXT;

CREATE INDEX IF NOT EXISTS idx_contacts_spam ON contacts (spam, date_submitted DESC);

COMMIT;
