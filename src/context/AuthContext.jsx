import { createContext, useCallback, useContext, useEffect, useState } from "react";
import { logoutUser } from "@/lib/auth";
import { supabase, isSupabaseConfigured } from "@/lib/supabase";

const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  const fetchUser = useCallback(async () => {
    try {
      // Verifica se o Supabase está configurado corretamente
      if (!isSupabaseConfigured()) {
        setUser(null);
        return;
      }
      
      const {
        data: { user },
      } = await supabase.auth.getUser();
      setUser(user);
    } catch (error) {
      console.error("Error fetching user:", error);
      setUser(null);
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => {
    // Verifica se o Supabase está configurado antes de inicializar
    if (!isSupabaseConfigured()) {
      setUser(null);
      setLoading(false);
      return;
    }

    // Get initial session
    fetchUser();

    // Listen for auth changes (apenas se Supabase estiver configurado)
    // Nota: onAuthStateChange pode ser chamado mesmo com placeholder, mas validamos dentro do callback
    let subscription = null;
    
    try {
      const {
        data: { subscription: authSubscription },
      } = supabase.auth.onAuthStateChange(async (event, session) => {
        // Verifica novamente antes de processar mudanças de autenticação
        // Isso previne processamento de eventos quando Supabase não está configurado
        if (!isSupabaseConfigured()) {
          setUser(null);
          setLoading(false);
          return;
        }
        setUser(session?.user ?? null);
        setLoading(false);
      });
      
      subscription = authSubscription;
    } catch (error) {
      // Se falhar ao criar a subscription (ex: credenciais inválidas), apenas loga o erro
      console.error("Failed to set up auth state listener:", error);
      setLoading(false);
    }

    return () => {
      if (subscription) {
        try {
          subscription.unsubscribe();
        } catch (error) {
          // Ignora erros ao fazer unsubscribe (pode falhar se já foi desinscrito)
          console.warn("Error unsubscribing from auth state:", error);
        }
      }
    };
  }, [fetchUser]);

  const logout = useCallback(async () => {
    try {
      await logoutUser();
    } catch (error) {
      console.error("Logout failed:", error);
    } finally {
      setUser(null);
    }
  }, []);

  return (
    <AuthContext.Provider value={{ user, setUser, loading, logout, refetchUser: fetchUser }}>
      {children}
    </AuthContext.Provider>
  );
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error("useAuth must be used within an AuthProvider");
  }
  return context;
};
