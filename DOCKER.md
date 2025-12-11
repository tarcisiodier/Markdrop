# 🐳 Guia Docker - Markdrop

Este guia explica como usar Docker para executar o Markdrop em diferentes ambientes.

## 📋 Pré-requisitos

- Docker instalado (versão 20.10 ou superior)
- Docker Compose instalado (versão 2.0 ou superior)

## 🚀 Uso Rápido

### Produção

```bash
# Build e iniciar em produção
docker-compose up -d

# A aplicação estará disponível em: http://localhost:8080
```

### Desenvolvimento

```bash
# Usar docker-compose.dev.yml
docker-compose -f docker-compose.dev.yml up

# Ou usar o profile dev
docker-compose --profile dev up app-dev

# A aplicação estará disponível em: http://localhost:3000
```

## 📝 Comandos Úteis

### Build

```bash
# Build da imagem de produção
docker-compose build

# Build da imagem de desenvolvimento
docker-compose -f docker-compose.dev.yml build

# Build sem cache
docker-compose build --no-cache
```

### Executar

```bash
# Iniciar em background (produção)
docker-compose up -d

# Iniciar em foreground (ver logs)
docker-compose up

# Parar containers
docker-compose down

# Parar e remover volumes
docker-compose down -v
```

### Logs

```bash
# Ver logs
docker-compose logs -f

# Ver logs do serviço específico
docker-compose logs -f app
```

### Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto:

```bash
VITE_SUPABASE_URL=https://seu-projeto.supabase.co
VITE_SUPABASE_ANON_KEY=sua_chave_aqui
```

As variáveis serão automaticamente carregadas pelo docker-compose.

## 🔧 Configuração

### Portas

- **Produção**: `8080` (mapeado para porta 80 do container)
- **Desenvolvimento**: `3000` (mapeado para porta 3000 do container)

Para alterar as portas, edite o `docker-compose.yml`:

```yaml
ports:
  - "SUA_PORTA:80"  # Para produção
  - "SUA_PORTA:3000"  # Para desenvolvimento
```

### Nginx

A configuração do Nginx está em `nginx.conf`. Você pode personalizar:

- Cache de arquivos estáticos
- Headers de segurança
- Compressão Gzip
- Redirecionamentos

## 🏗️ Estrutura do Dockerfile

O Dockerfile usa multi-stage build:

1. **Stage 1 (builder)**: Instala dependências e builda a aplicação
2. **Stage 2 (production)**: Serve a aplicação com Nginx
3. **Stage 3 (development)**: Ambiente de desenvolvimento com hot-reload

## 🐛 Troubleshooting

### Container não inicia

```bash
# Ver logs de erro
docker-compose logs app

# Verificar se a porta está em uso
lsof -i :8080  # Para produção
lsof -i :3000  # Para desenvolvimento
```

### Problemas com permissões

```bash
# No Linux, pode ser necessário ajustar permissões
sudo chown -R $USER:$USER .
```

### Rebuild completo

```bash
# Remover tudo e reconstruir
docker-compose down -v
docker-compose build --no-cache
docker-compose up -d
```

### Limpar imagens não utilizadas

```bash
# Remover imagens antigas
docker system prune -a
```

## 📦 Build Manual

Se preferir buildar manualmente:

```bash
# Build da imagem de produção
docker build -t markdrop:latest --target production .

# Executar container
docker run -d \
  -p 8080:80 \
  -e VITE_SUPABASE_URL=seu_url \
  -e VITE_SUPABASE_ANON_KEY=sua_chave \
  --name markdrop \
  markdrop:latest
```

## 🔍 Verificar Status

```bash
# Ver containers em execução
docker-compose ps

# Ver uso de recursos
docker stats

# Health check
curl http://localhost:8080/health
```

## 📚 Recursos Adicionais

- [Documentação Docker](https://docs.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)
- [Nginx Documentation](https://nginx.org/en/docs/)

