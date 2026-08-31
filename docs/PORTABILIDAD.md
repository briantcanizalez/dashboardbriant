# Portabilidad · montar SMB ERP en otra infraestructura

Esta guía es para quien quiera sacar el sistema de Vercel + Supabase y llevarlo a otro lado: un servidor propio, otro proveedor, o incluso sin backend.

## De qué depende realmente la app

Solo de **tres cosas**, y ninguna está acoplada al proveedor:

| Capa | Qué necesita | Hoy |
|---|---|---|
| **1. Servir archivos** | Alojar 4 archivos estáticos (`index.html`, `config.js`, `favicon.svg`, `vercel.json`). Sin build, sin Node en el servidor, sin variables de entorno | Vercel |
| **2. Autenticar** | Saber quién entra (correo/contraseña) | Supabase Auth |
| **3. Guardar un documento JSON** | Leer y escribir **un JSON por usuario**. Nada más: sin tablas relacionales, sin migraciones | Supabase (Postgres) |

Las capas son independientes: se puede cambiar solo el hosting, solo la base, o las dos.

---

## Escenarios

### A · Solo cambiar el hosting (30 minutos, cero código)

La app son archivos estáticos, así que sirve **cualquier** hosting: Nginx o Apache en un VPS, IIS, Cloudflare Pages, Netlify, GitHub Pages, S3 + CloudFront, o una carpeta en la red interna.

```bash
# ejemplo con Nginx
scp index.html config.js favicon.svg servidor:/var/www/smberp/
```

```nginx
server {
    server_name smberp.consiti.com;
    root /var/www/smberp;
    index index.html;
    add_header X-Frame-Options SAMEORIGIN;
    add_header X-Content-Type-Options nosniff;
    add_header X-Robots-Tag "noindex, nofollow";
}
```

Supabase sigue siendo la base y **no hay que tocar nada del código**. Único requisito: servir por **HTTPS** (Supabase Auth guarda la sesión en el navegador).

### B · Cambiar la base a un PostgreSQL propio

Ver [`../db/README.md`](../db/README.md). Resumen: el esquema es Postgres estándar salvo la referencia a `auth.users` y las políticas RLS con `auth.uid()`. Se sustituyen por la tabla de usuarios propia y por el control de acceso del backend que se ponga delante (escenario C).

### C · Todo on-premise, sin Supabase (medio día de trabajo)

Aquí sí hay que escribir un adaptador, pero es pequeño: la app toca Supabase en **7 lugares**, todos al final de `index.html`.

#### El contrato a implementar

| Función actual | Qué debe hacer el reemplazo |
|---|---|
| `initSupabase()` | Devolver `true` si hay backend configurado |
| `supa.auth.getSession()` | Devolver la sesión activa o `null` |
| `supa.auth.signInWithPassword({email,password})` | Iniciar sesión |
| `supa.auth.signUp({email,password})` | Crear cuenta (opcional, se puede deshabilitar) |
| `supa.auth.signOut()` | Cerrar sesión |
| `loadCloud()` → `select data from dashboards where user_id` | Devolver el JSON del usuario (o vacío si no existe) |
| `pushCloud(state)` → `upsert dashboards` | Guardar el JSON del usuario |

Es decir: **dos endpoints de datos y tres de sesión**.

#### Backend de referencia (Node + Express + PostgreSQL)

```js
// server.js — npm i express pg bcrypt jsonwebtoken cookie-parser
const express=require('express'), {Pool}=require('pg'), bcrypt=require('bcrypt'),
      jwt=require('jsonwebtoken'), cookie=require('cookie-parser');
const db=new Pool({connectionString:process.env.DATABASE_URL});
const SECRET=process.env.JWT_SECRET;
const app=express(); app.use(express.json({limit:'10mb'})); app.use(cookie());
app.use(express.static('public'));                       // sirve index.html

const auth=(req,res,next)=>{ try{ req.user=jwt.verify(req.cookies.t,SECRET); next(); }
                             catch{ res.status(401).json({error:'no autorizado'}); } };

app.post('/api/login', async (req,res)=>{
  const {rows}=await db.query('select id,pass from usuarios where email=$1',[req.body.email]);
  if(!rows[0] || !await bcrypt.compare(req.body.password,rows[0].pass))
    return res.status(401).json({error:'credenciales inválidas'});
  res.cookie('t', jwt.sign({uid:rows[0].id},SECRET,{expiresIn:'30d'}),
             {httpOnly:true,secure:true,sameSite:'lax'}).json({ok:true});
});
app.post('/api/logout', (_,res)=>res.clearCookie('t').json({ok:true}));
app.get ('/api/session', auth, (req,res)=>res.json({user:req.user.uid}));

app.get('/api/data', auth, async (req,res)=>{
  const {rows}=await db.query('select data from dashboards where user_id=$1',[req.user.uid]);
  res.json(rows[0]?.data || {});
});
app.put('/api/data', auth, async (req,res)=>{
  await db.query(`insert into dashboards (user_id,data,updated_at) values ($1,$2,now())
                  on conflict (user_id) do update set data=excluded.data, updated_at=now()`,
                 [req.user.uid, req.body]);
  res.json({ok:true});
});
app.listen(3000);
```

#### El adaptador en el front

En `index.html`, reemplazar las funciones de sincronización por estas (misma firma, así el resto de la app no cambia):

```js
function initSupabase(){ return true; }                       // hay backend propio
async function loadCloud(){
  const r = await fetch('/api/data', {credentials:'include'});
  const d = await r.json();
  if (d && Object.keys(d).length){ setSync('saved'); return normalize(d); }
  const l = localStorage.getItem(STORE_KEY);
  const s = l ? normalize(JSON.parse(l)) : structuredClone(defaultState);
  await pushCloud(s); return s;
}
async function pushCloud(s){
  if(!cloud) return;
  try{
    const r = await fetch('/api/data', {method:'PUT', credentials:'include',
      headers:{'Content-Type':'application/json'}, body:JSON.stringify(s)});
    setSync(r.ok ? 'saved' : 'error');
  }catch(e){ setSync('error'); }
}
```

Y en el bloque de login/`boot()`, cambiar las tres llamadas de `supa.auth.*` por `fetch` a `/api/login`, `/api/logout` y `/api/session`. **Nada más del código se toca**: KPIs, gráficas, seeds y vistas son agnósticos del backend.

#### Esquema mínimo (Postgres propio)

```sql
create table usuarios (
  id    uuid primary key default gen_random_uuid(),
  email text unique not null,
  pass  text not null                     -- hash bcrypt
);
create table dashboards (
  user_id    uuid primary key references usuarios(id) on delete cascade,
  data       jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
```

El aislamiento por usuario aquí lo da el backend (el `where user_id = req.user.uid`), no las políticas RLS.

### D · Sin backend (5 minutos)

Si va a usarlo **una sola persona en un solo equipo**, no hace falta ninguna infraestructura: deja `config.js` con los valores placeholder y la app corre en **modo local**, guardando todo en el navegador.

```js
window.SUPABASE_CONFIG = { url: "TU_URL", anonKey: "TU_KEY" };
```

Sin login, sin nube, cero costo. El respaldo se lleva con *Ajustes → Exportar respaldo (JSON)*. Es el modo que se usa para probar cambios sin tocar producción.

---

## Llevarse los datos

Cualquiera sea el destino, los datos viajan de dos formas equivalentes:

1. **SQL** — [`../db/restore-datos-2026-08-31.sql`](../db/restore-datos-2026-08-31.sql) inserta el documento completo.
2. **Desde la app** — *Ajustes → Importar respaldo* con el JSON de [`../backups/`](../backups/). Funciona en cualquier backend, porque el import escribe por la misma vía que usa la app.

> Ambos contienen exactamente el mismo estado: 528 clientes activos, 555 ventas, 175 prospectos, 36 contadores y sus carteras.

## Lo que hay que respetar sí o sí

- **HTTPS**, si se usa autenticación con cookies o tokens.
- **El documento JSON entero se lee y escribe completo** (no por partes). Pesa ~350 KB; si el backend limita el tamaño del body, subir el límite (en el ejemplo: `express.json({limit:'10mb'})`).
- **Aislamiento por usuario**: cada quien solo debe ver su documento. En Supabase lo hace RLS; en un backend propio, el `where user_id`.
- **`STORE_KEY` no se cambia** (`odoo_factura_dashboard_v1`): es la clave del espejo en localStorage y cambiarla haría "perder" los datos locales.

---

*SMB ERP · Grupo Consiti · Documento interno confidencial*
