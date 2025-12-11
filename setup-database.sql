-- ============================================
-- Markdrop Database Setup Script
-- ============================================
-- Execute este script no SQL Editor do Supabase
-- Dashboard > SQL Editor > New Query > Cole este script > Run
-- ============================================

-- ============================================
-- 1. Criar tabela de pastas (folders)
-- ============================================
CREATE TABLE IF NOT EXISTS public.folders (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    parent_folder_id UUID REFERENCES public.folders(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Índices para a tabela folders
CREATE INDEX IF NOT EXISTS folders_user_id_idx ON public.folders(user_id);
CREATE INDEX IF NOT EXISTS folders_parent_folder_id_idx ON public.folders(parent_folder_id);

-- ============================================
-- 2. Criar tabela de documentos markdown
-- ============================================
CREATE TABLE IF NOT EXISTS public.markdowns (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    content TEXT DEFAULT '',
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    folder_id UUID REFERENCES public.folders(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Índices para a tabela markdowns
CREATE INDEX IF NOT EXISTS markdowns_user_id_idx ON public.markdowns(user_id);
CREATE INDEX IF NOT EXISTS markdowns_folder_id_idx ON public.markdowns(folder_id);
CREATE INDEX IF NOT EXISTS markdowns_updated_at_idx ON public.markdowns(updated_at DESC);

-- ============================================
-- 3. Criar tabela de templates
-- ============================================
CREATE TABLE IF NOT EXISTS public.templates (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    description TEXT,
    category TEXT,
    content TEXT DEFAULT '',
    thumbnail TEXT,
    images JSONB DEFAULT '[]'::jsonb,
    tags JSONB DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Índices para a tabela templates
CREATE INDEX IF NOT EXISTS templates_category_idx ON public.templates(category);
CREATE INDEX IF NOT EXISTS templates_created_at_idx ON public.templates(created_at DESC);

-- ============================================
-- 4. Habilitar Row Level Security (RLS)
-- ============================================
ALTER TABLE public.folders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.markdowns ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.templates ENABLE ROW LEVEL SECURITY;

-- ============================================
-- 5. Políticas RLS para folders
-- ============================================

-- Usuários podem ver apenas suas próprias pastas
CREATE POLICY "Users can view their own folders"
    ON public.folders FOR SELECT
    USING (auth.uid() = user_id);

-- Usuários podem criar suas próprias pastas
CREATE POLICY "Users can create their own folders"
    ON public.folders FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Usuários podem atualizar suas próprias pastas
CREATE POLICY "Users can update their own folders"
    ON public.folders FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Usuários podem deletar suas próprias pastas
CREATE POLICY "Users can delete their own folders"
    ON public.folders FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================
-- 6. Políticas RLS para markdowns
-- ============================================

-- Usuários podem ver apenas seus próprios documentos
CREATE POLICY "Users can view their own markdowns"
    ON public.markdowns FOR SELECT
    USING (auth.uid() = user_id);

-- Usuários podem criar seus próprios documentos
CREATE POLICY "Users can create their own markdowns"
    ON public.markdowns FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Usuários podem atualizar seus próprios documentos
CREATE POLICY "Users can update their own markdowns"
    ON public.markdowns FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Usuários podem deletar seus próprios documentos
CREATE POLICY "Users can delete their own markdowns"
    ON public.markdowns FOR DELETE
    USING (auth.uid() = user_id);

-- ============================================
-- 7. Políticas RLS para templates
-- ============================================

-- Templates são públicos para leitura (qualquer usuário autenticado pode ver)
CREATE POLICY "Anyone can view templates"
    ON public.templates FOR SELECT
    USING (true);

-- Apenas usuários autenticados podem criar templates
CREATE POLICY "Authenticated users can create templates"
    ON public.templates FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

-- Apenas usuários autenticados podem atualizar templates
CREATE POLICY "Authenticated users can update templates"
    ON public.templates FOR UPDATE
    USING (auth.role() = 'authenticated')
    WITH CHECK (auth.role() = 'authenticated');

-- Apenas usuários autenticados podem deletar templates
CREATE POLICY "Authenticated users can delete templates"
    ON public.templates FOR DELETE
    USING (auth.role() = 'authenticated');

-- ============================================
-- 8. Função para atualizar updated_at automaticamente
-- ============================================
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers para atualizar updated_at automaticamente
CREATE TRIGGER update_folders_updated_at
    BEFORE UPDATE ON public.folders
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER update_markdowns_updated_at
    BEFORE UPDATE ON public.markdowns
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

CREATE TRIGGER update_templates_updated_at
    BEFORE UPDATE ON public.templates
    FOR EACH ROW
    EXECUTE FUNCTION public.handle_updated_at();

-- ============================================
-- 9. Comentários nas tabelas (opcional, mas útil)
-- ============================================
COMMENT ON TABLE public.folders IS 'Armazena as pastas organizacionais dos usuários';
COMMENT ON TABLE public.markdowns IS 'Armazena os documentos markdown dos usuários';
COMMENT ON TABLE public.templates IS 'Armazena templates públicos de markdown';

-- ============================================
-- FIM DO SCRIPT
-- ============================================
-- 
-- PRÓXIMOS PASSOS:
-- 
-- 1. Storage Bucket (opcional - será criado automaticamente se necessário):
--    - Vá em Storage no dashboard do Supabase
--    - Clique em "New bucket"
--    - Nome: "markdrop-files"
--    - Marque como público (public)
--    - Clique em "Create bucket"
--    Nota: O código criará automaticamente se não existir
--
-- 2. Verificar se tudo funcionou:
--    - Vá em Table Editor
--    - Você deve ver as tabelas: folders, markdowns, templates
--
-- ============================================

