# 🔒 Como Tornar o Fork Privado no GitHub

## 📍 Localização da Opção

1. **Acesse seu repositório:**
   ```
   https://github.com/tarcisiodier/Markdrop
   ```

2. **Clique na aba "Settings"** (ícone de engrenagem ⚙️ no topo do repositório)

3. **Role até o final da página** até encontrar a seção **"Danger Zone"**

4. **Clique em "Change visibility"**

5. **Selecione "Make private"**

6. **Confirme** digitando: `tarcisiodier/Markdrop`

7. **Clique em "I understand, change visibility"**

## ⚠️ Importante

### Requisito: GitHub Pro
- Repositórios privados requerem **GitHub Pro** (pago)
- Se você não tiver GitHub Pro, a opção não aparecerá
- GitHub Free permite apenas repositórios públicos

### Alternativas (se não tiver GitHub Pro)

#### Opção 1: Manter Público mas Trabalhar Localmente
- Fork público no GitHub (para backup)
- Trabalhe principalmente localmente
- Suas modificações na branch `custom` ficam públicas, mas é comum ter forks públicos

#### Opção 2: Repositório Privado Separado
Crie um repositório privado novo apenas para suas modificações:

```bash
# 1. Criar repositório privado no GitHub (via interface web)
# 2. Adicionar como novo remote
git remote add private https://github.com/tarcisiodier/Markdrop-Private.git

# 3. Enviar sua branch custom
git push private custom
```

#### Opção 3: Usar GitHub Student Pack
- Se você é estudante, pode ter GitHub Pro grátis
- Acesse: https://education.github.com/pack

## 🔍 Verificar se é Privado

Após tornar privado, você verá:
- 🔒 Ícone de cadeado ao lado do nome do repositório
- Apenas você (e colaboradores) podem ver o repositório

## 📝 Nota sobre Branches

- Tornar o repositório privado afeta **todas as branches**
- Não é possível ter algumas branches públicas e outras privadas
- É tudo ou nada: repositório inteiro público ou privado

## 🆘 Se não encontrar a opção

1. Verifique se você tem **acesso de administrador** ao repositório
2. Verifique se tem **GitHub Pro** ativo
3. A opção fica no final da página Settings, na seção "Danger Zone"

