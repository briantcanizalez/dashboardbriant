# SMB ERP · Grupo Consiti

**Dashboard ejecutivo de la Línea SMB** — la herramienta de gestión comercial de Briant Canizalez para operar las tres líneas de negocio del plan SMB 2026: **Factura IA** (Grupo Consiti), **Vendi** y **Comandi** (marca Stradia).

> 🌐 **Producción:** https://odoodash.vercel.app
> 📦 **Repo:** https://github.com/briantcanizalez/dashboardbriant
> 🔒 Acceso privado con correo/contraseña (Supabase Auth + RLS)

---

## ¿Qué hace?

| Módulo | Para qué sirve |
|---|---|
| **Inicio** | KPIs del día, meta SMB de Factura IA (recurrente + 332 altas), pulso masivo y agenda |
| **Resumen** | Cómo va el mes vs el anterior, cartera por comercial y Pareto de clientes |
| **Tareas** | Lista/tablero kanban con prioridades, recurrencia y cronómetro de tiempo |
| **Pipeline** | Embudo de prospectos con BANT, contador referidor, promo y auto-conversión a venta |
| **Campañas** | Inversión en pauta, CPL, CAC y ROI por campaña |
| **Ventas** | Registro de ventas con libro de precios (nuevo/anterior), promo de implementación gratis y servicios especiales |
| **Planes** | Cartera por modalidad → plan → cliente |
| **Canales** | Cierres por comercial y por mes |
| **Contadores** | Panel ejecutivo de la red de 36 contadores referidores: valor de cartera Año 1, ranking, gráficas, programa de premiar/impulsar y meta del canal |
| **Calendario** | Inicios de venta y fechas estimadas |
| **Metas y Proyección** | Avance a 1,000 clientes / $25K MRR, forecast y comisiones (Briant y René) |
| **Vendi / Comandi** | Líneas Stradia: tarifario, metas SMB, cartera meta a diciembre y registro de clientes |
| **Ajustes y Datos** | Punto de partida, metas SMB editables, comisiones, respaldos e importación CSV |

## Las tres líneas de negocio

El selector superior cambia entre líneas (los datos de cada una viven separados):

- **Factura IA** — facturación electrónica de Grupo Consiti. 524+ clientes. Meta SMB: **$18,928/mes y 332 altas a diciembre 2026**.
- **Vendi** — agente de IA que vende por WhatsApp 24/7 (Stradia). Meta: **$6,921/mes y 30 clientes**.
- **Comandi** — toma pedidos de restaurantes por WhatsApp (Stradia). Meta: **$4,582/mes y 18 restaurantes**.

Las metas provienen del **Plan Línea SMB 2026** (14-ago-2026) y están fijas en el código (`data/metas-smb-2026.json` es la referencia); las de recurrente pueden ajustarse en *Ajustes y Datos*.

## Estructura del repo

```
├── index.html            ← LA APP COMPLETA (HTML + CSS + JS en un solo archivo)
├── config.js             ← credenciales públicas de Supabase (anon key + RLS)
├── favicon.svg
├── vercel.json           ← headers de seguridad y cleanUrls
├── README.md             ← este archivo
├── CHANGELOG.md          ← historial de cambios
├── docs/
│   ├── MANUAL-DE-USO.md      ← guía de usuario, vista por vista
│   ├── ARQUITECTURA.md       ← cómo está construido (estado, sync, seeds)
│   ├── MODELO-DE-DATOS.md    ← entidades, campos y fórmulas
│   └── DESPLIEGUE.md         ← cómo se publica y cómo probar en local
├── db/
│   └── supabase-schema.sql   ← esquema de la base (ejecutar una vez en Supabase)
└── data/                     ← datasets de referencia (solo lectura)
    ├── metas-smb-2026.json       ← todas las metas del plan SMB
    ├── planes-factura-ia.json    ← libro de precios nuevo + anterior
    ├── tarifario-stradia.json    ← planes de Vendi y Comandi
    └── contadores-seed.json      ← red de contadores (36) y sus 205 clientes
```

## Inicio rápido

**Ver en producción:** abre https://odoodash.vercel.app e inicia sesión.

**Probar en local (sin tocar la nube):**

```bash
# 1) clona el repo
git clone https://github.com/briantcanizalez/dashboardbriant.git
# 2) deja config.js con valores "TU_..." (modo local: solo localStorage, sin login)
# 3) sirve la carpeta con cualquier servidor estático
npx serve .
```

**Publicar un cambio:** haz push a `main` → Vercel despliega solo en ~30 segundos. Detalle en [docs/DESPLIEGUE.md](docs/DESPLIEGUE.md).

## Stack

- **Frontend:** HTML + CSS + JavaScript vanilla, un solo archivo (`index.html`). Sin build, sin dependencias npm.
- **Gráficas:** [Chart.js](https://www.chartjs.org/) (CDN).
- **Datos:** [Supabase](https://supabase.com) — un documento JSON por usuario, con Row Level Security. Respaldo espejo en `localStorage`.
- **Hosting:** [Vercel](https://vercel.com) (proyecto `odoodash`), deploy automático desde `main`.

## Documentación

| Documento | Contenido |
|---|---|
| [docs/MANUAL-DE-USO.md](docs/MANUAL-DE-USO.md) | Cómo usar cada vista, flujos completos y reglas de negocio |
| [docs/ARQUITECTURA.md](docs/ARQUITECTURA.md) | Estado, sincronización, seeds/migraciones y catálogos |
| [docs/MODELO-DE-DATOS.md](docs/MODELO-DE-DATOS.md) | Todas las entidades, campos y fórmulas de cálculo |
| [docs/DESPLIEGUE.md](docs/DESPLIEGUE.md) | Deploy, entorno local y recuperación de datos |
| [CHANGELOG.md](CHANGELOG.md) | Qué se ha construido y cuándo |

---

*SMB ERP · Grupo Consiti S.A. de C.V. · Documento interno confidencial · agosto 2026*
