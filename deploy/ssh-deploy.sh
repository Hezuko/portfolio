#!/usr/bin/env bash
# Déploiement du portfolio, déclenché par GitHub Actions via SSH.
#
# Sécurité : à utiliser en "forced command" dans ~/.ssh/authorized_keys pour
# que la clé de déploiement ne puisse RIEN faire d'autre que ce script :
#   command="/srv/portfolio/deploy/ssh-deploy.sh",no-port-forwarding,no-agent-forwarding,no-pty ssh-ed25519 AAAA... github-deploy
set -euo pipefail

cd /srv/portfolio
git pull --ff-only origin develop
docker compose up -d --build portfolio
echo "✓ Déploiement terminé : $(git rev-parse --short HEAD)"
