# Notes de déploiement — Portfolio (et stratégie sites clients)

> Synthèse des décisions prises pour mettre le portfolio en ligne et préparer
> l'hébergement des futurs sites clients (activité web). À reprendre quand on
> passe à la mise en ligne.

## Contrainte de départ

Le portfolio est une app **Node.js / Express + PostgreSQL** (sessions stockées
en base via `connect-pg-simple`, médias sur Cloudinary). Il lui faut donc :
- un **process Node qui tourne en continu** (pas du statique, pas du PHP) ;
- une base **PostgreSQL**.

➡️ **L'hébergement mutualisé OVH (« Webhosting S », PHP + MySQL, pas de root/Docker)
ne convient PAS.** Il sert pour WordPress / PHP / sites statiques / mail.

## Choix retenu : un VPS OVH + Docker + Caddy

Même pattern que l'app **JoyTrain** (repo `Hezuko/MakasiFit`) déjà en prod sur OVH :
Docker Compose + **Caddy** (HTTPS automatique Let's Encrypt), seuls 80/443 exposés,
le reste sur le réseau Docker privé.

- Système à choisir à la commande : **Debian** ou **Ubuntu**. Datacenter **France**
  (Gravelines / Roubaix / Strasbourg).
- Lien offres : https://www.ovhcloud.com/fr/vps/

| Modèle | Prix | vCore | RAM | Disque | Pour |
|---|---|---|---|---|---|
| **VPS-1** | 3,81 € HT (~4,57 € TTC)/mo | 2 | 4 Go | 40 Go NVMe | Approche Caddy/Compose, portfolio + 3–6 vitrines |
| **VPS-2** | 7,21 € HT/mo | 4 | 8 Go | 75 Go NVMe | Si on veut le panneau **Coolify** (qui mange ~1–1,5 Go à lui seul) |

On peut **redimensionner en 1 clic** plus tard, ou ajouter un 2ᵉ VPS.

## Combien de sites sur VPS-1 (4 Go → ~3 Go utiles)

| Type | RAM/site | Nb |
|---|---|---|
| Statique (HTML / SPA buildée) | ~20–50 Mo | 20–50+ |
| Node comme le portfolio (app + base dédiée) | ~200–300 Mo | 5–8 |
| WordPress (PHP + MySQL) | ~300–500 Mo | 4–6 |
| Dynamiques avec **base partagée** (1 Postgres, 1 *database* par site) | ~100–150 Mo | 10–15+ |

**Astuce capacité** : un seul Postgres/MySQL partagé (1 database par client) au lieu
d'une base par site → on loge bien plus de sites. Médias lourds → Cloudinary/objet, pas le disque.

## Tout gérer d'un seul endroit

```
Cloudflare (tous les domaines, DNS gratuit)
        │  enregistrement A → IP du VPS
        ▼
   VPS OVH ── Caddy (HTTPS auto, aiguille par nom de domaine)
        ├─ henoc-mukumbi.com   → portfolio (Node + Postgres)
        ├─ site-client-1.fr    → WordPress / statique
        └─ …                     (1 IP = nombre illimité de domaines)
```

- **Domaines** : achetés où on veut (Cloudflare au prix coûtant, ou OVH/Gandi côté FR,
  ~8–12 €/an). On centralise le **DNS sur Cloudflare**. Une seule IP sert N domaines.
- **Routage + HTTPS** : un seul `Caddyfile` liste tous les domaines (approche fichiers/git),
  OU **Coolify/Dokploy** = tableau de bord web (ajout site/domaine/base/SSL au clic) — demande VPS-2.

## Isolation : portfolio vs sites clients

- **Portfolio** : OK sur la VM JoyTrain existante **si elle a de la marge RAM** (avec un
  Postgres dédié + une limite mémoire sur le conteneur). C'est le nôtre, faible trafic.
- **Sites clients** : ⚠️ **VPS séparé recommandé**. Ne pas mélanger le produit JoyTrain
  (vrais utilisateurs, données RGPD : emails, photos, mensurations) avec du travail client
  (WordPress = cible d'attaques). Risques : contention ressources, rayon d'impact, sécurité.
- Reco : garder la VM JoyTrain pour le produit, prendre un **VPS « vitrines/clients »**
  pour le portfolio + les sites clients.
- Pour décider si la VM actuelle a de la place : sur la VM, `free -h`, `uptime`,
  `docker stats --no-stream`, `df -h /`.

## Avant la mise en ligne (rappels sécurité déjà traités côté code)

- Mot de passe admin **haché bcrypt** ✅ (fait). Mettre un **SESSION_SECRET** fort
  dans le `.env` de prod (`node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"`).
- **NODE_ENV=production** + servir en **HTTPS** (Caddy le fournit) → cookie session en `secure`.
- **DB_SSL=true** si base distante.
- Ne jamais committer le `.env` (déjà gitignoré).

## Prochaines étapes (à préparer côté repo quand on s'y met)

1. `Dockerfile` du portfolio.
2. Service `postgres` + service `portfolio` dans un `docker-compose` (avec limite mémoire).
3. Entrée de domaine dans le `Caddyfile`.
4. `.env` de prod (modèle) + procédure d'application des migrations.
5. Choix final : **VPS-1 (Caddy/Compose)** ou **VPS-2 (Coolify)**.
