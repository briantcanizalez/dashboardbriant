# Modelo de datos · SMB ERP

Todas las entidades del estado, sus campos y las fórmulas de cálculo. El estado completo es **un documento JSON por usuario** (tabla `dashboards` en Supabase + espejo en `localStorage`).

## 1. Entidades

### `sales[]` — ventas de Factura IA
| Campo | Tipo | Notas |
|---|---|---|
| `id` | string | aleatorio (`uid()`) |
| `client` | string | nombre del cliente |
| `plan` | string | clave de `PLANS`: `starter`, `basicoMensual`, `professional`, `advanced`, `deluxe`, `enterprise`, `basicoAnual`, `starterAnual`, `professionalIncrize`, `especial` |
| `mode` | `'mensual'` \| `'anual'` | anual = pago adelantado del año |
| `start` | `AAAA-MM-DD` | fecha de alta (define el mes del cierre) |
| `priceBook` | `'legacy'` \| `'v2026-08'` \| ausente | libro de precios forzado; ausente → por fecha vs `PRICE_CUTOVER` (2026-08-01) |
| `origen` | string | Campaña · Referido · Alianza Contable · Directo · Otro |
| `contadorId` | string? | contador referidor (si origen es Alianza Contable/Referido) |
| `implGratis` | true? | 🎁 promo: implementación $0 |
| `customMonthly` / `customImpl` | number? | sobreescriben el precio de lista (casos especiales) |
| `comercial` | string | vendedor (Briant Canizalez por defecto) |
| `campaignId` | string? | campaña de origen |
| `churned` / `churnDate` | bool / fecha | baja (deja de contar clientes y MRR) |
| `legacy` | true? | cliente existente previo al dashboard (MRR inmediato) |
| `seed` / `prospectId` | string | trazabilidad: qué seed la creó / prospecto que la generó (`seed:'won'`) |

### `prospects[]` — pipeline
`id, client, plan, priceBook?, stage` (Lead · Contactado · Demo · Negociación · Ganada · Perdida · Basura), `bant {b,a,n,t}`, `nextStep, nextDate, medio, origen, contadorId?, implGratis?, comercial, campaignId, trashReason, note, createdAt, updatedAt`.

Al pasar a **Ganada** → `syncWonSale()` crea la venta (hereda plan, libro, origen mapeado, contador y promo). Al salir de Ganada → se elimina esa venta.

### `contadores[]` — red de referidores
| Campo | Notas |
|---|---|
| `id` | slug (`fatima-duran`) o `uid()` para nuevos |
| `nombre`, `tel`, `mail` | datos de contacto |
| `hist[]` | cartera histórica: `{empresa, contacto?, planNombre, plan: 'mensual'|'anual', rr, impl, alta: 'AAAA-MM', nota?}` — **en anual, `rr` es el monto del año** |
| `createdAt` | timestamp |

La cartera "viva" de un contador = `hist` + ventas con `contadorId` = su id.

### `lineSales.vendi[]` / `lineSales.comandi[]` — líneas Stradia
`id, client, plan` (clave de `LINE_PLANS`: `emprende|crece|profesional|empresarial|corporativo`), `mode ('mensual'|'anual')`, `start, origen, implGratis?, churned?, createdAt`.

### `campaigns[]`
`id, name, start, end?, budget` ($/día), `spent?` (gasto real total), `plannedDays?, notes`. Derivados: gasto, leads (prospectos vinculados), CAC, ROI a 12 meses.

### `services[]` — servicios especiales
`id, client, type, amount, commissionPct, date, comercial`. No suman MRR ni clientes.

### `tasks[]` / `projects[]`
`tasks`: `id, title, project, priority, start, due, status` (Pendiente·En curso·Finalizada), `recurrence?, ms` (tiempo acumulado), `runningSince?`.

### `history[]`
Snapshot mensual automático: `{m: 'AAAA-MM', clients, mrr}` (alimenta la evolución de Metas).

### `config` — configuración y metas
| Clave | Default | Qué es |
|---|---|---|
| `baseClients` / `baseRecurring` | 494 / $7,151.23 | punto de partida (cartera previa al dashboard) |
| `goalClients` / `goalRecurring` | 1,000 / $25,000 | metas personales de largo plazo |
| `annualPayments` | $11,988.18 | pagos anuales previos |
| `mrrMesMeta` | $1,000 | meta de MRR nuevo por mes (Pulso) |
| `salaryBase`, `bono`, `metaMes` | — | esquema de comisiones |
| `fiaMetaSMB` | **$18,928** | meta SMB de Factura IA (dic-2026) |
| `vendiMetaMRR` / `vendiMetaCli` | **$6,921 / 30** | meta SMB de Vendi |
| `comandiMetaMRR` / `comandiMetaCli` | **$4,582 / 18** | meta SMB de Comandi |
| `seededXxx` (≈20 flags) | false | seeds ya ejecutados (no tocar) |
| `lastBackup` | — | fecha del último respaldo exportado |

## 2. Libros de precios de Factura IA

| Plan | Nuevo (≥ 1-ago-2026) | Anterior |
|---|---|---|
| Starter | $14.99 / impl $40 | $9.99 / impl $30 |
| Plan Básico Mensual | $5 / impl $30 | — |
| Professional | $24.99 / impl $50 | $19.99 / impl $40 |
| Advanced | $34.99 / impl $60 | $29.99 / impl $50 |
| Deluxe | $59.99 / impl $70 | $49.99 / impl $60 |
| Enterprise | $150 / impl $100 | $100 / impl $100 |
| Básico Anual · Starter Anual · Professional Incrize | $5 · $9.99 · $20 (solo anual) | — |

Copia de referencia: [`data/planes-factura-ia.json`](../data/planes-factura-ia.json).

## 3. Tarifario Stradia (Vendi y Comandi)

Misma lista para ambas líneas — ver [`data/tarifario-stradia.json`](../data/tarifario-stradia.json): Emprende $50 *(no publicado)* · Crece $99 · Profesional $299 ⭐ · Empresarial $499 · Corporativo $899, con implementaciones $50/$99/$490/$990/$1,900. Anual adelantado = 10% dcto + implementación bonificada. Excedente $0.10/conversación; local extra $25/mes.

## 4. Metas SMB 2026 (Plan Línea SMB · 14-ago-2026)

Referencia completa: [`data/metas-smb-2026.json`](../data/metas-smb-2026.json).

| Línea | Meta dic-2026 | Escalera (sep · oct · nov · dic) |
|---|---|---|
| Factura IA · recurrente | $18,928/mes | $10,638 · $13,341 · $16,195 · $18,928 |
| Factura IA · altas | 332 en el período | 52 · 79 · 96 · 105 |
| Canal contadores | 220 altas · $4,620/mes | 55 · 55 · 55 · 55 |
| Vendi | $6,921/mes · 30 clientes | $349 · $1,642 · $3,832 · $6,921 |
| Comandi | $4,582/mes · 18 restaurantes | $0 · $895 · $2,289 · $4,582 |

Mezcla meta a diciembre (cartera): Vendi = 1 Emprende · 14 Crece · 12 Profesional · 2 Empresarial · 1 Corporativo. Comandi = 9 Crece · 6 Profesional · 2 Empresarial · 1 Corporativo.

## 5. Fórmulas

| Cálculo | Fórmula |
|---|---|
| Libro de una venta | `priceBook` explícito; si no: `start ≥ 2026-08-01` → nuevo |
| Mensualidad / implementación | precio del libro; `customMonthly/customImpl` sobreescriben; **`implGratis` → impl $0** |
| Clientes activos | `baseClients` + ventas sin baja |
| MRR | `baseRecurring` + mensualidades de ventas **mensuales** con ≥ 3 meses (las `legacy` cuentan desde ya) |
| Pagos anuales | `annualPayments` + Σ (mensualidad × 12) de ventas anuales activas |
| Implementación cobrada | Σ `saleImpl` de **todas** las ventas (incluye bajas: la impl se cobró al cierre) |
| Línea Stradia · MRR | mensual → precio de lista; anual → precio × 0.9 |
| Contadores · MRR de un cliente | mensual → `rr`; anual → `rr / 12` |
| Contadores · ARR / Año 1 | ARR = MRR × 12 · Año 1 = implementaciones + ARR |
| Comisión del canal | 1 mes de servicio por alta activada (~$21 al ticket post-aumento) |
| Comisión Briant/René | base = **solo la implementación** × escalón (por # de cierres del mes: 1–10 → 20%, 11–15 → 25%, 16+ → 30%); las anuales suman además 2% del valor del año; los servicios especiales comisionan con su propio %; al bruto total se le aplica **10% de retención de renta**. La 1ª mensualidad **no** entra a la base |
| Rotación | bajas / (activas + bajas) |

---

*SMB ERP · Grupo Consiti · Documento interno confidencial*
