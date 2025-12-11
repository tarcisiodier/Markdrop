# ============================================
# Stage 1: Build da aplicação
# ============================================
FROM node:22-alpine AS builder

# Instalar dependências do sistema necessárias
RUN apk add --no-cache libc6-compat

# Definir diretório de trabalho
WORKDIR /app

# Copiar arquivos de dependências
COPY package.json package-lock.json ./

# Instalar dependências
RUN npm ci

# Copiar script de patch necessário para o build
COPY scripts/patch-workbox.js ./scripts/

# Copiar código fonte (scripts/ está no .dockerignore, mas copiamos o necessário acima)
COPY . .

# Build da aplicação
# Nota: Variáveis de ambiente VITE_* devem ser passadas no build time
ARG VITE_SUPABASE_URL
ARG VITE_SUPABASE_ANON_KEY
ENV VITE_SUPABASE_URL=$VITE_SUPABASE_URL
ENV VITE_SUPABASE_ANON_KEY=$VITE_SUPABASE_ANON_KEY

RUN npm run build

# ============================================
# Stage 2: Servir aplicação com Nginx
# ============================================
FROM nginx:alpine AS production

# Copiar arquivos buildados
COPY --from=builder /app/dist /usr/share/nginx/html

# Copiar configuração do Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expor porta
EXPOSE 80

# Healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:80 || exit 1

# Iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]

# ============================================
# Stage 3: Desenvolvimento (opcional)
# ============================================
FROM node:22-alpine AS development

WORKDIR /app

# Copiar arquivos de dependências
COPY package.json package-lock.json ./

# Instalar dependências
RUN npm ci

# Copiar código fonte
COPY . .

# Expor porta do Vite
EXPOSE 3000

# Comando para desenvolvimento
CMD ["npm", "run", "dev"]

