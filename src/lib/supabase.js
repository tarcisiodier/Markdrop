import { createClient } from "@supabase/supabase-js";

const supabaseUrl = import.meta.env.VITE_SUPABASE_URL;
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_ANON_KEY;

// Verifica se o Supabase está configurado corretamente
export const isSupabaseConfigured = () => {
  return !!(supabaseUrl && supabaseAnonKey && !supabaseUrl.includes("placeholder"));
};

// Cria um cliente Supabase mesmo sem as variáveis de ambiente
// Isso permite que a aplicação funcione, mas as funcionalidades de autenticação serão limitadas
export const supabase = supabaseUrl && supabaseAnonKey && !supabaseUrl.includes("placeholder")
  ? createClient(supabaseUrl, supabaseAnonKey)
  : createClient("https://placeholder.supabase.co", "placeholder-key");
