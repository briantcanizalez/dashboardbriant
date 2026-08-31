# SMB ERP · Nota técnica para Luis Portillo

**De:** Briant Canizalez · **Fecha:** 31-ago-2026
**Asunto:** Cómo está montado SMB ERP, el dashboard de gestión de la Línea SMB.

Luis: este documento te explica en 10 minutos cómo está construido y operado SMB ERP, qué decisiones técnicas se tomaron y por qué, qué accesos existen y qué habría que saber si Tecnología llega a tocarlo o auditarlo. El detalle fino está en el resto de `docs/`.

---

## 1. Qué es (y qué NO es)

- **Es** la herramienta de gestión comercial de la Línea SMB: pipeline, ventas, campañas, comisiones, la red de contadores referidores y el seguimiento de las metas del Plan SMB 2026 para **Factura IA, Vendi y Comandi**.
- **NO es** parte del producto. No toca Odoo, ni la plataforma de Factura IA, ni los MVP de Vendi/Comandi. No comparte base de datos ni credenciales con nada de producción de Consiti. Es una capa de gestión independiente; si mañana se apaga, ningún cliente lo nota.
- Usuario hoy: Briant (mono-usuario por diseño, aunque la base ya soporta multi-usuario — ver §5).

## 2. Topología

```
┌─────────────────────────────────────────────────────────────┐
│  Navegador (cualquier dispositivo)                           │
│  index.html — TODA la app: HTML + CSS + JS vanilla           │
│  + Chart.js (CDN) + supabase-js (CDN)                        │
└──────────────┬───────────────────────────────┬──────────────┘
               │ HTTPS (upsert/select JSONB)   │ espejo
               ▼                               ▼
   Supabase (proyecto de Briant)         localStorage
   · Auth email/contraseña               (clave 'odoo_factura_
   · tabla `dashboards`:                  dashboard_v1')
     1 fila = 1 usuario = TODO su
     estado en una columna JSONB
   · RLS: cada quien solo su fila

   Hosting estático: Vercel (proyecto `odoodash`)
   Deploy: push a `main` de github.com/briantcanizalez/dashboardbriant
           → deploy automático (~30 s). Sin build, sin CI.
   URL: https://odoodash.vercel.app
```

**No hay backend propio.** Cero servidores que mantener: el "backend" es Supabase (BaaS) y el hosting es un archivo estático.

## 3. Decisiones técnicas y su porqué

| Decisión | Razón |
|---|---|
| **Un solo `index.html`** (~360 KB, sin framework ni build) | Velocidad de iteración y cero cadena de dependencias que mantener. Se edita, se hace push y está en producción en 30 s. El costo (archivo grande) se acepta por ser una herramienta interna de un usuario |
| **Estado = un documento JSON por usuario** | El volumen es pequeño (cientos de registros). Un solo upsert con debounce de 700 ms simplifica todo: sin migraciones SQL, sin ORM. Agregar un campo nuevo no requiere tocar la base |
| **localStorage como espejo** | Funciona offline/local y sirve de respaldo instantáneo; al iniciar sesión, los datos locales migran solos a la nube |
| **Seeds one-shot en el código** | Las cargas y correcciones de datos se publican como funciones `seedXxx()` con bandera en `config` — corren una vez por usuario y son idempotentes (patrón en `docs/ARQUITECTURA.md` §3) |
| **Catálogos de negocio como constantes** | Libro de precios de Factura IA (nuevo/anterior, corte 1-ago-2026), tarifario Stradia y metas SMB viven en el código y en `data/*.json` de referencia. Cambian poco y así quedan versionados en git |

## 4. Seguridad

- **Auth:** Supabase Auth (email/contraseña). Sin sesión no se ve nada.
- **Autorización:** políticas RLS sobre `dashboards` (`db/supabase-schema.sql`) — select/insert/update/delete solo donde `auth.uid() = user_id`.
- **La `anon key` en `config.js` es pública por diseño** (así funciona Supabase en browser); no otorga acceso a datos sin login + RLS.
- **Headers** en `vercel.json`: `nosniff`, `X-Frame-Options: SAMEORIGIN`, `noindex/nofollow`, `Referrer-Policy`.
- No hay secretos en el repo. No hay PII de clientes finales más allá de nombres comerciales y contactos que Briant registra.

## 5. Datos

- **Modelo completo:** `docs/MODELO-DE-DATOS.md` (entidades, campos y fórmulas de MRR/ARR/comisiones).
- **Colecciones principales:** `sales`, `prospects`, `campaigns`, `services`, `tasks`, `contadores` (red de 36 referidores con 205 clientes históricos), `lineSales.vendi/comandi`, `history`, `config`.
- **Respaldo:** exportable a JSON desde la app (Ajustes); restaurable con un clic. Adicional al respaldo natural de Supabase.
- **Para montarlo en tu propia base:** `db/README.md` tiene la guía paso a paso — esquema (`supabase-schema.sql`), carga de datos (`restore-datos-2026-08-31.sql`, con los 528 clientes, 175 prospectos y 36 contadores embebidos) y qué cambiar si se lleva a un PostgreSQL fuera de Supabase.
- **Multi-usuario:** la tabla ya está aislada por usuario vía RLS. Si el equipo comercial crece, basta crear cuentas — cada quien vería su propio dashboard (hoy no hay vista consolidada de equipo; sería desarrollo nuevo).

## 6. Operación

- **Publicar:** editar → commit → push a `main` → Vercel despliega solo. Checklist en `docs/DESPLIEGUE.md`.
- **Probar sin riesgo:** copiar la carpeta, dejar `config.js` con placeholders (`TU_URL`) → modo local puro (sin login, sin nube), servido con cualquier estático.
- **Accesos actuales:**
  - GitHub `briantcanizalez/dashboardbriant` — owner briantcanizalez; la cuenta `Briantz25` tiene ADMIN.
  - Vercel — proyecto `odoodash` en la cuenta de Briant.
  - Supabase — proyecto en la cuenta de Briant (Auth + base).
- **Monitoreo:** ninguno formal (es una herramienta interna). Vercel da logs de despliegue; Supabase, métricas de la base.

## 7. Límites conocidos (transparencia)

1. **Sincronización last-write-wins**: si se edita a la vez en dos dispositivos, gana el último guardado (debounce 700 ms). Aceptable para un usuario; sería lo primero a rediseñar si se vuelve multi-dispositivo intensivo.
2. **Sin tests automatizados**: la validación es chequeo de sintaxis + prueba manual en modo local antes de cada push.
3. **Un archivo grande**: la modularización se sacrificó por velocidad; la guía de `docs/ARQUITECTURA.md` compensa con un mapa claro de secciones.
4. **Datos de contadores embebidos**: la base histórica (36/205) entró como seed versionado; las altas nuevas sí fluyen por la app (pipeline → venta → contador).

## 8. Relación con el Plan SMB 2026

El dashboard **consume** las metas del plan (14-ago-2026): $18,928 y 332 altas de Factura IA, 55 altas/mes del canal de contadores, $6,921/30 de Vendi y $4,582/18 de Comandi — fijas en código y editables las de recurrente en Ajustes. Referencia completa en `data/metas-smb-2026.json`.

Lo que el plan le pide a Tecnología (contador de conversaciones, alertas de cupo, cambio automático de plan, gestión de números de WhatsApp, reverso de garantía) es **del producto Vendi/Comandi, no de este dashboard** — aquí solo se le da seguimiento comercial.

## 9. Si necesitas profundizar

| Documento | Para qué |
|---|---|
| [ARQUITECTURA.md](ARQUITECTURA.md) | Estado, sync, seeds, catálogos, sistema de vistas |
| [MODELO-DE-DATOS.md](MODELO-DE-DATOS.md) | Entidades, campos y todas las fórmulas |
| [DESPLIEGUE.md](DESPLIEGUE.md) | Publicación, entorno local, setup desde cero |
| [PORTABILIDAD.md](PORTABILIDAD.md) | **Sacarlo de Vercel/Supabase**: otro hosting, base propia, backend on-premise (con código de referencia) o sin backend |
| [../db/README.md](../db/README.md) | Montar la base desde cero y cargar los datos |
| [MANUAL-DE-USO.md](MANUAL-DE-USO.md) | La app desde el punto de vista del usuario |
| [../CHANGELOG.md](../CHANGELOG.md) | Qué se construyó y cuándo |

Cualquier duda me buscas — Briant.

---

*SMB ERP · Grupo Consiti S.A. de C.V. · Documento interno confidencial*
