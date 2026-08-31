# Base de datos · SMB ERP

Todo lo necesario para levantar la base desde cero y cargarle los datos, en Supabase o en cualquier PostgreSQL.

## Archivos

| Archivo | Qué hace |
|---|---|
| `supabase-schema.sql` | Crea la tabla `dashboards` y sus políticas de seguridad (RLS). Se ejecuta **una sola vez**. |
| `restore-datos-2026-08-31.sql` | Carga los datos completos al 31-ago-2026 (post-conciliación con Odoo): **528 clientes activos, 555 ventas, 175 prospectos, 36 contadores con sus carteras, 2 campañas y 9 tareas**. Idempotente: si la fila ya existe, la reemplaza. |

## Cómo se guarda la información

Toda la aplicación vive en **una sola tabla**:

```sql
public.dashboards (
  user_id    uuid  primary key → auth.users(id),
  data       jsonb,   -- TODO el estado del usuario en un documento JSON
  updated_at timestamptz
)
```

Una fila por usuario. Dentro de `data` van las colecciones (`sales`, `prospects`, `campaigns`, `services`, `tasks`, `contadores`, `lineSales`, `history`, `config`) — el detalle campo por campo está en [../docs/MODELO-DE-DATOS.md](../docs/MODELO-DE-DATOS.md).

**Por qué así:** el volumen es pequeño (cientos de registros por usuario) y agregar campos nuevos no requiere migraciones SQL. La app hace un `upsert` con *debounce* de 700 ms.

**Seguridad:** Row Level Security activo — cada usuario solo puede leer y escribir su propia fila (`auth.uid() = user_id`). Por eso la *anon key* puede ir pública en el navegador.

---

## Montar el sistema desde cero (~10 minutos)

### 1 · Crear la base
Supabase → **SQL Editor → New query** → pega el contenido de `supabase-schema.sql` → **Run**. Debe decir *Success*.

### 2 · Crear el usuario
Supabase → **Authentication → Users → Add user** → correo y contraseña, marcando **Auto Confirm User**.
*(Alternativa: Authentication → Providers → Email → desactivar "Confirm email" y crear la cuenta desde la pantalla de login de la app.)*

### 3 · Cargar los datos
Abre `restore-datos-2026-08-31.sql`, **reemplaza las 2 apariciones del correo** por el del usuario del paso 2, pégalo en el SQL Editor y ejecútalo. Al final devuelve una fila de verificación con los conteos (ventas 555, prospectos 175, contadores 36).

> El archivo pesa ~235 KB. Si el editor web se pone lento, ejecútalo con `psql`:
> ```bash
> psql "postgresql://postgres:[PASSWORD]@db.[REF].supabase.co:5432/postgres" -f restore-datos-2026-08-31.sql
> ```

### 4 · Apuntar la app a la nueva base
Supabase → **Project Settings → API** → copia el *Project URL* y la *anon public key* a `config.js`:

```js
window.SUPABASE_CONFIG = {
  url: "https://TU-PROYECTO.supabase.co",
  anonKey: "eyJ..."
};
```

Haz push (o despliega donde sea que esté alojado) y entra con el usuario del paso 2.

---

## Ruta alternativa · sin tocar SQL

Si solo se quiere mover los datos y no interesa el detalle de la base:

1. Montar la app apuntando a la base nueva (pasos 1, 2 y 4).
2. Entrar y usar **Ajustes y Datos → Importar respaldo**, eligiendo `../backups/smb-erp-respaldo-2026-08-31-post-conciliacion.json`.

El resultado es el mismo: ese JSON es exactamente el que va embebido en el script SQL.

## Llevarlo a otro PostgreSQL (fuera de Supabase)

El esquema es Postgres estándar salvo dos cosas propias de Supabase: la referencia a `auth.users` y las políticas RLS con `auth.uid()`. Para montarlo en un Postgres común:

- Sustituir `auth.users(id)` por la tabla de usuarios propia (o quitar la llave foránea y usar un `user_id` fijo).
- Quitar o adaptar las políticas RLS al mecanismo de autenticación que se use.
- En el script de datos, cambiar el `select ... from auth.users where email = ...` por el `user_id` que corresponda.

La app en sí solo necesita un endpoint que acepte leer y escribir ese documento JSON. La guía completa —con backend de referencia en Node + Express y el adaptador para el front— está en [../docs/PORTABILIDAD.md](../docs/PORTABILIDAD.md).

---

*SMB ERP · Grupo Consiti · Documento interno confidencial*
