// ============================================================
//  CONFIGURACIÓN DE SUPABASE
//  Pega aquí los datos de tu proyecto de Supabase.
//  Los encuentras en: Supabase → Project Settings → API
//
//  Estos dos valores son PÚBLICOS por diseño (la "anon key"
//  está pensada para vivir en el navegador). La seguridad la
//  da el login + las reglas RLS de la base de datos.
//
//  Si dejas los valores como están (TU_...), el dashboard
//  funcionará en MODO LOCAL (solo en este navegador), sin nube.
// ============================================================
window.SUPABASE_CONFIG = {
  url: "TU_SUPABASE_URL",          // ej: https://abcdxyz.supabase.co
  anonKey: "TU_SUPABASE_ANON_KEY"  // ej: eyJhbGciOiJIUzI1NiIsInR5cCI6...
};
