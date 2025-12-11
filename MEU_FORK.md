# 🎯 Guia Rápido - Meu Fork do Markdrop

## ✅ O que já foi configurado

- ✅ `upstream` → Repositório original (rakheOmar/Markdrop)
- ✅ Branch `custom` → Suas modificações pessoais
- ✅ Branch `main` → Versão original (limpa)

## 📝 Próximos Passos

### 1. Criar seu Fork no GitHub (se ainda não tiver)

1. Acesse: <https://github.com/rakheOmar/Markdrop>
2. Clique no botão **"Fork"** (canto superior direito)
3. Isso criará uma cópia em: `https://github.com/SEU-USUARIO/Markdrop`

### 2. Adicionar seu Fork como `origin`

```bash
git remote add origin https://github.com/SEU-USUARIO/Markdrop.git
```

**Substitua `SEU-USUARIO` pelo seu nome de usuário do GitHub!**

### 3. Verificar configuração

```bash
git remote -v
```

Deve mostrar:

```
origin    https://github.com/SEU-USUARIO/Markdrop.git (fetch)
origin    https://github.com/SEU-USUARIO/Markdrop.git (push)
upstream  https://github.com/rakheOmar/Markdrop.git (fetch)
upstream  https://github.com/rakheOmar/Markdrop.git (push)
```

### 4. Commitar suas modificações atuais

```bash
# Adicionar arquivos modificados
git add src/context/AuthContext.jsx src/lib/supabase.js CONFIGURACAO_SUPABASE.md setup-database.sql

# Commitar
git commit -m "feat: configurações locais e correções para funcionar sem Supabase"

# Enviar para seu fork (após adicionar origin)
git push -u origin custom
```

## 🔄 Como Receber Atualizações do Projeto Original

```bash
# 1. Voltar para main
git checkout main

# 2. Buscar atualizações
git fetch upstream

# 3. Mesclar atualizações
git merge upstream/main

# 4. Voltar para sua branch custom
git checkout custom

# 5. Mesclar atualizações na sua branch
git merge main

# 6. Resolver conflitos se houver (editar arquivos manualmente)
# 7. Commitar
git commit -m "merge: atualizar com upstream/main"

# 8. Enviar para seu fork
git push origin custom
```

## 📋 Estrutura de Branches

```
main   → Versão original (sempre sincronizada com upstream)
custom → Suas modificações pessoais
```

## ⚠️ Regras Importantes

1. **NUNCA modifique a branch `main` diretamente**
   - Use `main` apenas para receber atualizações
   - Todas as suas mudanças vão na branch `custom`

2. **Sempre trabalhe na branch `custom`**

   ```bash
   git checkout custom
   # ... fazer modificações ...
   git add .
   git commit -m "feat: minha modificação"
   git push origin custom
   ```

3. **Para receber atualizações:**

   ```bash
   git checkout main
   git fetch upstream
   git merge upstream/main
   git checkout custom
   git merge main
   ```

## 🚀 Script Rápido de Atualização

Crie um arquivo `atualizar.sh`:

```bash
#!/bin/bash
echo "🔄 Atualizando do repositório original..."
git checkout main
git fetch upstream
git merge upstream/main
echo "✅ Main atualizada!"

echo "🔄 Mesclando na branch custom..."
git checkout custom
git merge main
echo "✅ Custom atualizada!"
echo "⚠️  Verifique se há conflitos e resolva se necessário"
```

Torne executável:

```bash
chmod +x atualizar.sh
```

Execute:

```bash
./atualizar.sh
```

## 📚 Comandos Úteis

```bash
# Ver em qual branch está
git branch

# Ver diferenças entre custom e main
git diff main..custom

# Ver histórico
git log --oneline --graph --all

# Desfazer mudanças não commitadas
git restore arquivo.js
```

## 🎯 Resumo do Workflow

1. **Trabalhar**: Sempre na branch `custom`
2. **Receber updates**: Atualizar `main` do `upstream`, depois mesclar em `custom`
3. **Salvar**: Push para seu `origin` (seu fork)
