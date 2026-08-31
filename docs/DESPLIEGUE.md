# Despliegue y entorno local · SMB ERP

## Producción (así funciona hoy)

```
editas index.html → push a main (GitHub) → Vercel despliega solo (~30 s)
```

- **URL:** https://odoodash.vercel.app
- **Repo:** https://github.com/briantcanizalez/dashboardbriant (los archivos van en la raíz)
- **Proyecto Vercel:** `odoodash` — importado del repo, framework *Other*, sin build.
- **Base de datos:** Supabase (proyecto de Briant). El esquema está en [`db/supabase-schema.sql`](../db/supabase-schema.sql) y **ya está aplicado**; solo se vuelve a ejecutar si se crea un proyecto de Supabase nuevo.

### Publicar un cambio

```bash
git clone https://github.com/briantcanizalez/dashboardbriant.git
# ... edita index.html ...
git add -A
git commit -m "descripción del cambio"
git push origin main
# Vercel despliega automáticamente; verifica en https://odoodash.vercel.app
```

> El código fuente de trabajo vive en `C:\Trabajo\PROYECTOS\Odoo-Dashboard\` (no es repo git); tras editar ahí, copia `index.html` al clon del repo y haz push.

## Probar en local sin tocar producción

1. Copia la carpeta a un directorio temporal.
2. Deja `config.js` con placeholders para forzar **modo local** (sin login, sin nube):
   ```js
   window.SUPABASE_CONFIG = { url: "TU_URL", anonKey: "TU_KEY" };
   ```
3. Sirve la carpeta con cualquier servidor estático (`npx serve .` o similar) y abre `http://localhost:PORT`.

En modo local los datos viven solo en ese navegador — ideal para probar seeds, vistas y cálculos.

## Configurar desde cero (proyecto de Supabase nuevo)

1. **Base:** Supabase → SQL Editor → pega [`db/supabase-schema.sql`](../db/supabase-schema.sql) → Run. Crea la tabla `dashboards` con RLS.
2. **Usuario:** Authentication → Users → *Add user* (marca **Auto Confirm User**), o desactiva *Confirm email* y crea la cuenta desde la pantalla de login.
3. **Datos:** ejecuta [`db/restore-datos-2026-08-31.sql`](../db/restore-datos-2026-08-31.sql) cambiando el correo por el del usuario del paso 2 — carga los 528 clientes, 175 prospectos y 36 contadores. *(O entra a la app y usa Ajustes → Importar respaldo con el JSON de `backups/`.)*
4. **Llaves:** Project Settings → API → copia el *Project URL* y la *anon public key* a `config.js`. *(La anon key es pública por diseño; la seguridad la dan el login y las políticas RLS.)*
5. Push a `main` → listo.

Guía completa, incluido cómo llevarlo a un PostgreSQL fuera de Supabase: [`db/README.md`](../db/README.md).

## Datos: respaldo y recuperación

- **Respaldo manual:** Ajustes → *Exportar respaldo (JSON)* → guarda `smb-erp-respaldo-AAAA-MM-DD.json`.
- **Restaurar:** Ajustes → *Importar respaldo*.
- **Migración local → nube:** al iniciar sesión por primera vez con datos locales, se suben solos.
- **Correcciones de datos vía código:** patrón *seed one-shot* (ver [ARQUITECTURA.md](ARQUITECTURA.md) §3) — se publican con un deploy y corren una sola vez por usuario.

## Checklist antes de publicar

- [ ] `node -e "new Function(<script de index.html>)"` sin errores de sintaxis (o probar en local).
- [ ] Probado en modo local: la vista tocada renderiza y guarda.
- [ ] No se cambió `STORE_KEY` ni se quitó ningún flag `seededXxx` de `defaultState.config`.
- [ ] Claves nuevas del estado agregadas a `defaultState` y `normalize()`.
- [ ] Verificar en producción tras el deploy (~30 s).

---

*SMB ERP · Grupo Consiti · Documento interno confidencial*
