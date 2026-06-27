# Portfolio — app Node.js/Express. Image légère, deps de prod uniquement.
FROM node:20-slim

WORKDIR /app

# Installer d'abord les deps (cache Docker tant que package*.json ne change pas)
COPY package*.json ./
RUN npm ci --omit=dev

# Code applicatif
COPY . .

ENV NODE_ENV=production
ENV PORT=3000
EXPOSE 3000

# Healthcheck simple sur la page d'accueil (l'app sert sur 0.0.0.0:3000)
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/', r => process.exit(r.statusCode < 500 ? 0 : 1)).on('error', () => process.exit(1))"

CMD ["node", "./bin/www"]
