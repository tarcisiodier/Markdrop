#!/bin/bash

# Script para atualizar o fork com as últimas mudanças do repositório original

echo "🔄 Atualizando do repositório original (upstream)..."

# Salvar branch atual
CURRENT_BRANCH=$(git branch --show-current)

# Atualizar main
echo "📥 Mudando para branch main..."
git checkout main

echo "⬇️  Buscando atualizações do upstream..."
git fetch upstream

echo "🔀 Mesclando atualizações..."
git merge upstream/main

if [ $? -eq 0 ]; then
    echo "✅ Main atualizada com sucesso!"
else
    echo "❌ Erro ao mesclar. Resolva os conflitos manualmente."
    exit 1
fi

# Voltar para branch custom e mesclar
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo ""
    echo "🔄 Mesclando atualizações na branch $CURRENT_BRANCH..."
    git checkout "$CURRENT_BRANCH"
    git merge main
    
    if [ $? -eq 0 ]; then
        echo "✅ $CURRENT_BRANCH atualizada com sucesso!"
        echo ""
        echo "⚠️  Verifique se há conflitos:"
        echo "   git status"
        echo "   git diff"
    else
        echo "⚠️  Conflitos detectados! Resolva manualmente:"
        echo "   1. Edite os arquivos em conflito"
        echo "   2. git add arquivos-resolvidos"
        echo "   3. git commit"
    fi
else
    echo "ℹ️  Você está na branch main. Para trabalhar, mude para custom:"
    echo "   git checkout custom"
fi

echo ""
echo "📊 Status atual:"
git status --short

