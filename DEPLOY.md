# 🚀 Desplegar el Dashboard en Vercel + Supabase

Tu dashboard ya está listo para la nube. Solo necesitas conectar **tu** proyecto de
Supabase (base de datos + login) y subirlo a **Vercel**. Toma ~15 minutos.

> Tus datos quedan protegidos con login (correo/contraseña) y reglas RLS: aunque la
> URL de Vercel sea pública, **solo tú** (con tu cuenta) puedes ver y editar tus datos.

---

## Paso 1 · Crear la base de datos en Supabase

1. Entra a tu proyecto en [supabase.com](https://supabase.com) → **SQL Editor** → **New query**.
2. Abre el archivo **`supabase-schema.sql`** (está en esta misma carpeta), copia todo su
   contenido, pégalo y pulsa **Run**.
3. Debe decir *Success*. Eso crea la tabla `dashboards` con seguridad RLS.

## Paso 2 · Permitir el login sin fricción (recomendado)

Para que puedas entrar al instante sin confirmar correo cada vez:

- **Opción A (más fácil):** Supabase → **Authentication → Users → Add user** →
  escribe tu correo y contraseña, marca **Auto Confirm User** → **Create user**.
  Esa será tu cuenta de acceso.
- **Opción B:** Supabase → **Authentication → Providers → Email** → desactiva
  *"Confirm email"*. Así podrás crear tu cuenta desde la propia pantalla de login del
  dashboard (botón *"Crear mi cuenta"*).

## Paso 3 · Copiar tus llaves de API

1. Supabase → **Project Settings → API**.
2. Copia el **Project URL** (ej. `https://abcd1234.supabase.co`).
3. Copia la **anon public key** (empieza con `eyJ...`). *Es pública por diseño, no pasa nada
   si se ve; la seguridad la da el login + RLS.*
4. Abre el archivo **`config.js`** de esta carpeta y pega ambos valores:

```js
window.SUPABASE_CONFIG = {
  url: "https://abcd1234.supabase.co",
  anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6..."
};
```

Guarda el archivo.

## Paso 4 · Subir a Vercel

El código ya está en GitHub: **https://github.com/briantcanizalez/dashboardbriant**
(los archivos están en la raíz del repo).

**Opción A — Desde la web de Vercel (sin comandos):**
1. En Vercel: **Add New → Project → Import Git Repository** → elige `dashboardbriant`.
2. **Root Directory:** déjalo en la raíz (`./`). **Framework Preset:** *Other*. No hay build.
3. → **Deploy**.

**Opción B — Con Vercel CLI:**
```bash
cd dashboard-ejecutivo
vercel        # primera vez: vincula el proyecto
vercel --prod # publica a producción
```

## Paso 5 · Entrar

1. Abre la URL que te da Vercel.
2. Verás la pantalla de **inicio de sesión**. Entra con el correo/contraseña del Paso 2.
3. La primera vez, si ya tenías datos en local, se **migran solos** a la nube.
4. Arriba a la derecha verás el indicador **"Guardado"** cada vez que algo se sincroniza.

¡Listo! Ya puedes entrar desde tu compu, tu celular o cualquier lado — los datos viven en Supabase.

---

## Notas

- **Modo local:** si `config.js` queda con los valores `TU_...`, el dashboard funciona
  igual pero solo en ese navegador (sin nube). Útil para probar.
- **Respaldo:** además de la nube, sigue disponible *Ajustes → Exportar respaldo (JSON)*.
- **Cerrar sesión:** botón al final del menú lateral.
- **Multiusuario:** si en el futuro quieres que tu equipo tenga cuentas, cada quien con su
  correo verá solo sus propios datos (la tabla ya está aislada por usuario con RLS).
- **¿La anon key es segura de publicar?** Sí. Está diseñada para el navegador. Lo que
  protege tus datos es el login + las políticas RLS que creaste en el Paso 1.
