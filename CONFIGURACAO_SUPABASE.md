# 🔧 Guia de Configuração do Supabase

Este guia explica como configurar as variáveis de ambiente do Supabase para o projeto Markdrop.

## 📋 Pré-requisitos

- Conta no [Supabase](https://supabase.com) (gratuita)
- Projeto criado no Supabase

## 🚀 Passo a Passo

### 1. Criar um Projeto no Supabase

1. Acesse [https://supabase.com](https://supabase.com)
2. Faça login ou crie uma conta gratuita
3. Clique em **"New Project"**
4. Preencha os dados do projeto:
   - **Name**: Nome do seu projeto (ex: "markdrop")
   - **Database Password**: Escolha uma senha forte (guarde bem!)
   - **Region**: Escolha a região mais próxima de você
5. Clique em **"Create new project"** e aguarde a criação (pode levar alguns minutos)

### 2. Obter as Credenciais

1. No dashboard do seu projeto, vá para **Settings** (ícone de engrenagem no menu lateral)
2. Clique em **API** no menu de configurações
3. Você verá duas informações importantes:
   - **Project URL**: URL do seu projeto (ex: `https://xxxxx.supabase.co`)
   - **anon public key**: Chave pública anônima (uma string longa)

### 3. Configurar o Arquivo .env

1. No diretório raiz do projeto Markdrop, abra ou crie o arquivo `.env`
2. Adicione as seguintes variáveis com os valores que você copiou:

```bash
VITE_SUPABASE_URL=https://seu-projeto.supabase.co
VITE_SUPABASE_ANON_KEY=sua_chave_anon_public_aqui
```

**Exemplo real:**

```bash
VITE_SUPABASE_URL=https://abcdefghijklmnop.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiY2RlZmdoaWprbG1ub3AiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTYxNjIzOTAyMiwiZXhwIjoxOTMxODE1MDIyfQ.exemplo_chave_aqui
```

### 4. Configurar o Banco de Dados

Para que o projeto funcione completamente, você precisa executar o script SQL que cria as tabelas necessárias:

1. No dashboard do Supabase, vá para **SQL Editor** (ícone de banco de dados no menu lateral)
2. Clique em **"New query"**
3. Abra o arquivo `setup-database.sql` na raiz do projeto Markdrop
4. Copie todo o conteúdo do arquivo
5. Cole no editor SQL do Supabase
6. Clique em **"Run"** ou pressione `Ctrl + Enter` (ou `Cmd + Enter` no Mac)
7. Aguarde a execução (deve mostrar "Success. No rows returned")

**O que o script faz:**

- ✅ Cria as tabelas: `folders`, `markdowns`, `templates`
- ✅ Configura Row Level Security (RLS) para segurança
- ✅ Cria políticas de acesso para cada tabela
- ✅ Adiciona índices para melhor performance
- ✅ Configura triggers para atualizar `updated_at` automaticamente

### 5. Configurar Storage Bucket (Opcional)

Para upload de imagens e arquivos:

1. No dashboard do Supabase, vá para **Storage** (ícone de pasta no menu lateral)
2. Clique em **"New bucket"**
3. Configure:
   - **Name**: `markdrop-files`
   - **Public bucket**: ✅ Marque como público
4. Clique em **"Create bucket"**

**Nota:** O bucket será criado automaticamente pelo código quando necessário, mas você pode criá-lo manualmente também.

### 6. Reiniciar o Servidor de Desenvolvimento

Após configurar o arquivo `.env` e o banco de dados, você precisa reiniciar o servidor:

```bash
# Pare o servidor (Ctrl + C)
# Depois inicie novamente:
npm run dev
```

## ⚠️ Importante

- **NUNCA** commite o arquivo `.env` no Git (ele já está no `.gitignore`)
- Mantenha suas credenciais seguras e privadas
- A chave `anon public` é segura para uso no frontend, mas não compartilhe publicamente

## ✅ Verificação

Após configurar, o projeto deve:

- ✅ Carregar normalmente sem tela em branco
- ✅ Permitir autenticação de usuários
- ✅ Salvar dados na nuvem
- ✅ Criar pastas e documentos markdown
- ✅ Acessar templates

**Para verificar se o banco está configurado:**

1. No Supabase, vá para **Table Editor**
2. Você deve ver as tabelas: `folders`, `markdowns`, `templates`

## 🆘 Problemas Comuns

### Tela em branco

- Verifique se o arquivo `.env` está na raiz do projeto
- Confirme que as variáveis começam com `VITE_`
- Reinicie o servidor após criar/modificar o `.env`

### Erro de autenticação

- Verifique se copiou a chave completa (ela é muito longa)
- Confirme que não há espaços extras nas variáveis
- Certifique-se de que o projeto no Supabase está ativo

### Erro "Database tables not found"

- Execute o script `setup-database.sql` no SQL Editor do Supabase
- Verifique se todas as tabelas foram criadas no Table Editor
- Certifique-se de que as políticas RLS foram criadas corretamente

## 📚 Recursos Adicionais

- [Documentação do Supabase](https://supabase.com/docs)
- [Guia de Autenticação](https://supabase.com/docs/guides/auth)
