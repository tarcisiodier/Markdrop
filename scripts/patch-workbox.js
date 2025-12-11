#!/usr/bin/env node

/**
 * Script para aplicar patch no arquivo workbox gerado
 * Corrige o bug na função canConstructResponseFromBodyStream()
 * 
 * Uso: node scripts/patch-workbox.js
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

function findWorkboxFiles(dir) {
  const files = [];
  try {
    const entries = fs.readdirSync(dir, { withFileTypes: true });
    for (const entry of entries) {
      const fullPath = path.join(dir, entry.name);
      if (entry.isFile() && entry.name.startsWith('workbox-') && entry.name.endsWith('.js')) {
        files.push(fullPath);
      }
    }
  } catch (error) {
    // Diretório não existe, ignorar
  }
  return files;
}

function patchWorkboxFile(filePath) {
  try {
    let content = fs.readFileSync(filePath, 'utf8');
    
    // Padrão a ser substituído (bug): supportStatus = false; após o bloco if sem else
    const bugPattern = /(if \('body' in testResponse\) \{[^}]+try \{[^}]+\} catch \(error\) \{[^}]+\}\s+\})\s+supportStatus = false;/s;
    
    // Verificar se o bug existe
    if (bugPattern.test(content)) {
      // Substituir pelo padrão corrigido
      content = content.replace(
        bugPattern,
        (match, ifBlock) => {
          return `${ifBlock}\n        } else {\n          supportStatus = false;\n        }`;
        }
      );
      
      fs.writeFileSync(filePath, content, 'utf8');
      console.log(`✅ Patch aplicado em: ${filePath}`);
      return true;
    } else {
      // Verificar se já está corrigido
      if (content.includes('} else {\n          supportStatus = false;')) {
        console.log(`ℹ️  Arquivo já está corrigido: ${filePath}`);
        return false;
      } else {
        console.log(`⚠️  Padrão não encontrado em: ${filePath}`);
        return false;
      }
    }
  } catch (error) {
    console.error(`❌ Erro ao processar ${filePath}:`, error.message);
    return false;
  }
}

// Buscar arquivos workbox nos diretórios de build
const rootDir = path.resolve(__dirname, '..');
const searchDirs = ['dev-dist', 'dist'];

let allFiles = [];
searchDirs.forEach(dir => {
  const fullPath = path.join(rootDir, dir);
  const files = findWorkboxFiles(fullPath);
  allFiles.push(...files);
});

if (allFiles.length === 0) {
  console.log('ℹ️  Nenhum arquivo workbox encontrado.');
  console.log('   Execute o build primeiro: npm run build');
  process.exit(0);
}

let patched = 0;
allFiles.forEach(file => {
  if (patchWorkboxFile(file)) {
    patched++;
  }
});

if (patched > 0) {
  console.log(`\n✅ ${patched} arquivo(s) corrigido(s) com sucesso!`);
} else {
  console.log('\nℹ️  Nenhum arquivo precisou ser corrigido.');
}

