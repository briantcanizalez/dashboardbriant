# Arquitectura · SMB ERP

Cómo está construido el dashboard, para quien tenga que mantenerlo o extenderlo.

## 1. Visión general

**Una sola página, un solo archivo.** Todo (HTML, CSS y JS) vive en `index.html` (~350 KB). No hay build, ni bundler, ni dependencias npm: se edita el archivo y se publica.

```
Navegador
 ├─ index.html  (app completa)
 ├─ config.js   (URL + anon key de Supabase)
 ├─ Chart.js    (CDN)
 └─ supabase-js (CDN)
        │  upsert/select (debounce 700 ms)
        ▼
Supabase · tabla dashboards (1 fila = 1 usuario = todo su estado en JSONB, con RLS)
        ▲
localStorage (espejo local, clave 'odoo_factura_dashboard_v1')
```

- **Hosting**: Vercel (proyecto `odoodash`), estático, deploy automático desde `main` del repo GitHub.
- **Auth**: Supabase Auth (correo/contraseña). Sin sesión → pantalla de login. Sin `config.js` válido → **modo local** (sin login, datos solo en el navegador).

## 2. Estado

Todo el estado es **un solo objeto JSON** (`state`), definido por `defaultState` y saneado por `normalize()`:

```js
state = {
  tasks, sales, services, prospects, campaigns, projects, history,   // arreglos
  contadores,                       // red de contadores referidores (con hist)
  lineSales: { vendi: [], comandi: [] },   // ventas de las líneas Stradia
  config: { ...metas, flags de seeds, comisiones }
}
```

El detalle campo por campo está en [MODELO-DE-DATOS.md](MODELO-DE-DATOS.md).

### Persistencia y sincronización
- `save()` → snapshot mensual a `history` → `localStorage` → si hay nube, `queueCloudSave()` (debounce 700 ms) → `upsert` a `dashboards`.
- Al iniciar sesión se carga la fila del usuario; si no existe y hay datos locales, **se migran solos** a la nube.
- **La clave `STORE_KEY` ('odoo_factura_dashboard_v1') no debe cambiarse**: cambiaría "dónde" busca los datos locales.
- `normalize()` mezcla el estado guardado con `defaultState` (los campos nuevos aparecen solos) y garantiza que cada colección sea un arreglo. **Toda clave nueva del estado debe agregarse a `defaultState` y, si es colección, a la lista de `normalize()`.**

## 3. Seeds / migraciones de datos (patrón one-shot)

Las cargas y correcciones de datos se hacen con funciones `seedXxx()` que corren **una sola vez** por usuario:

```js
function seedAlgoV1(){
  if(state.config.seededAlgoV1) return;   // flag en config
  /* ... upsert de datos, idempotente ... */
  state.config.seededAlgoV1 = true;
  save();
}
```

- Se registran en `initApp()` (se ejecutan al abrir la app, tras cargar el estado).
- El flag correspondiente se declara en `defaultState.config` (en `false`).
- Regla: **upsert por nombre/id, nunca duplicar**; preferir corregir el registro existente.

Seeds activos (en orden de ejecución): `seedOdooBatch1`, `seedBookV3`, `seedAnnualBookV1`, `seedComercialV1/V2`, `seedProspectsV1/V2`, `seedClosesV1`, `seedWonV1`, `seedOriginV1/V2`, `seedCampaignLinkV1`, `seedRestoreAireV1`, `seedCampaignDaysV1`, `seedChurnV1`, `seedRestoreDetV1`, `seedFixBautistaV1`, `seedJulyBriantV1/V2`, `seedFixIdaliaV1`, `seedAugBriantV1` (ventas de agosto), `seedContadoresV1` (36 contadores / 205 clientes).

## 4. Catálogos y constantes de negocio

| Constante | Qué es |
|---|---|
| `PLANS` | Libro de precios **vigente** de Factura IA (desde 2026-08-01) |
| `LEGACY_PLAN_PRICES` | Precios **anteriores** (starter $9.99, professional $19.99, …) |
| `PRICE_CUTOVER` = `'2026-08-01'` | Ventas con inicio ≥ esta fecha usan precio nuevo, salvo `priceBook` explícito |
| `SERVICE_PRICES` | Tarifas de servicios especiales |
| `LINE_PLANS` | Tarifario Stradia (Vendi/Comandi): Emprende/Crece/Profesional/Empresarial/Corporativo |
| `LINES` | Config de cada línea Stradia: color, metas por defecto, escalera mensual y mezcla meta |
| `FIA_SMB_MILESTONES` | Escalera de recurrente de Factura IA (sep–dic) |
| `FIA_SMB_ALTAS` | Escalera de altas 52/79/96/105 (332 del período) |
| `CANAL_SMB` | Meta del canal de contadores: 55 altas/mes, 220 período, $4,620 a dic |
| `SEED_CONTADORES` | Dataset embebido de la red (36 contadores, 205 clientes) — copia en `data/contadores-seed.json` |

## 5. Sistema de vistas

- Cada vista es un `<section class="view" id="view-XXX">`; `go('XXX')` la activa, actualiza topbar/nav y llama a su render (mapa dentro de `go()`).
- Registro de una vista nueva: sección HTML + entrada en `VIEWS` (título, subtítulo, botón de acción) + render en el mapa de `go()` + botón en el sidebar (`data-view`).
- El **selector de línea** (`#line-seg`) resalta Factura IA/Vendi/Comandi según la vista activa.
- `refreshSalesViews()` re-renderiza las vistas dependientes de ventas cuando algo cambia.

## 6. Gráficas

- Chart.js con instancias guardadas en el objeto global `charts{}`; antes de re-crear una gráfica se destruye la instancia previa.
- Colores del tema: `CGRID` (#23233a) y `CTXT` (#b2b2c6). Paleta de planes de contadores en `CT_PLAN_COLORS`.

## 7. Módulo de contadores

- `state.contadores[]`: `{id, nombre, tel, mail, hist[], createdAt}` — `hist` es la cartera histórica importada.
- Las ventas nuevas se vinculan con `sale.contadorId` (elegido cuando el origen es *Alianza Contable* o *Referido*, desde prospecto o venta; `syncWonSale` lo hereda al ganar).
- `ctCli(contador)` une `hist` + ventas vinculadas en un formato común (`{planNombre, plan, rr, impl, alta, nuevo}`) — de ahí salen MRR/ARR/Año 1 y todas las gráficas del panel.

## 8. Reglas de cálculo clave

- `saleBook(s)`: `priceBook` explícito gana; si no, fecha ≥ `PRICE_CUTOVER` → nuevo.
- `saleMonthly/saleImpl`: precio del libro correspondiente; `customMonthly/customImpl` lo sobreescriben; **`implGratis` fuerza implementación $0**.
- MRR: solo ventas **mensuales** con ≥ `RECURRING_START_MONTH` meses (3); anuales van a `annualCollected`.
- Líneas Stradia: `lineSaleMonthly` (anual = mensual × 0.9), `lineSaleImpl` (anual o promo → $0).
- Comisiones: base = implementación + 1ª mensualidad; escalones 20/25/30%; anual paga 2% del año; retención 10%.

## 9. Seguridad

- La **anon key** de Supabase es pública por diseño; la protección real es Auth + políticas RLS (`db/supabase-schema.sql`).
- `vercel.json` agrega `X-Frame-Options`, `nosniff`, `noindex` y `Referrer-Policy`.
- No hay secretos en el repo.

---

*SMB ERP · Grupo Consiti · Documento interno confidencial*
