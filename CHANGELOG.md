# Changelog · SMB ERP

Historial de cambios del dashboard. Formato: fecha · qué cambió.

## 2026-10-03 · Cierres de septiembre 2026 (`seedCierresSep26V1`)

One-shot e idempotente. Sale del CRM (etapa Cierre) y de las suscripciones de Odoo, y lo confirmó Briant.

- **Contadora nueva:** «Lic. Yani» (`lic-yani`). Su teléfono, +503 7874 4953, se carga con `seedYaniTelV1`.
- **Clientes de contadores**, cargados como ventas vinculadas (`origen: Alianza Contable`):
  - **Yessenia Rivera de Rivera** (Variedades Carlitos), de José Ernesto Martínez. Professional a $34.99, implementación $50 cobrada por Consiti, $140 de módulos y carga, primera mensualidad en ene 2027 (3 meses sin costo).
  - **Marroquín Salas, Marjorie Magali** (Farmacia), de Lic. Yani. Deluxe a $79.99, implementación $70 cobrada por Consiti, $430 de implementación empresarial presencial, primera mensualidad en nov 2026.
- **Ventas directas de Briant** por la campaña de Meta (`origen: Campaña`): ESACOL, Vásquez Yan (implementación gratis), Kevin Sandoval y Munari son nuevas. Kevin Flores, SAITEC, Finare, Velado León y Transporte Brisas ya estaban y no se tocaron sus montos. **Corrección (`seedCierresSep26FixV1`):** Kevin Flores y Finare son contadores con FactuIA gratis (sync V9), así que se les quitó el origen «Campaña».
- **Bajas:** el export de oportunidades perdidas del 03-oct no trae nada nuevo. Las 26 que existen en el dashboard ya estaban de baja desde las sincronizaciones V7 y V8. Erick Ventura Umaña y Grupo Soluciones Ambientales también se dieron de baja con fecha 03-oct, por decisión de Briant, aunque en el export de Odoo seguían con suscripción (`seedBajasVenturaSadcoV1`). Diana Pamela Morán Quintanilla, que no tiene suscripción en Odoo, se dio de baja con fecha 03-oct (`seedBajaDianaMoranV1`).
- **Edición desde la cartera:** las ventas vinculadas a un contador ahora se editan desde la cartera con el mismo formulario: extras, totales, primera mensualidad y quién cobra la implementación. Los campos que se guardan en la venta son `ctBase`, `ctExtras`, `implCobra`, `pagoInicial`, `pagaDesde` y `contacto`.

## 2026-10-03 · Contadores: reglas nuevas del Programa de Alianzas Contables

El panel de Contadores sigue las reglas de la landing contadores.factuiasv.com.

- **Solo clientes nuevos:** la comisión aplica únicamente a clientes **cerrados desde sep 2026** (`CT_PROG.desdeAlta`). Los del histórico no llevan comisión, así que Consiti se queda el 100 % de su mensualidad.
- **Comisión:** la implementación es 100 % del contador, y además gana el **20 % de la mensualidad** de cada cliente activo. En anual, el 20 % se calcula sobre el equivalente mensual. Cada cliente guarda quién cobró la implementación (`implCobra`: `contador` o `consiti`). Solo la que cobró Consiti entra en la liquidación.
- **Liquidación mensual** (tarjeta nueva): muestra por contador el 20 % mensual y las implementaciones, con la ventana de pago en los primeros 5 días hábiles del mes siguiente. Se saltan los fines de semana y los feriados fijos de El Salvador, pero no Semana Santa. Hay un botón para marcar el pago (`contador.pagos[YYYY-MM]`). Las liquidaciones empiezan en **sep 2026** (`CT_PROG.inicio`).
- **Primera mensualidad:** cada cliente guarda `pagaDesde`, el mes en que empieza a pagar (por la promo de meses sin costo o por una entrega posterior), tal como sale en la próxima factura de Odoo. El 20 % arranca ese mes y el año 1 cuenta solo los meses pagados.
- **Productos adicionales:** cada cliente lleva una lista `extras` con nombre, cantidad, precio editable y cobro único o mensual. Trae accesos rápidos para módulo adicional $30, carga de productos $50, capacitación presencial $100, capacitación virtual $50, diseño de logo $10 y DTE adicional $10. Los extras mensuales suman a la mensualidad y llevan el 20 %.
- **Totales editables:** el pago inicial y la mensualidad total se calculan solos, pero se pueden sobrescribir. Se muestra el ajuste manual y hay un botón para recalcular. Se guardan `base`, `rr`, `pagoInicial` y `estado`/`baja` (cliente dado de baja).
- **Rentabilidad:** la tabla de desempeño muestra la comisión por mes, el **neto Consiti del año 1** (80 % de la mensualidad × 12 + productos adicionales) y los referidos del mes contra la meta de 3.
- **Precios:** el formulario usa el Tarifario de septiembre 2026 (Starter $14.99 / $170.89 al año / impl. $40 … Enterprise $150 / $1,530 / $100) y suma **Básico Anual $90** (impl. $30), que solo ofrecen los aliados. Los planes viejos de clientes ya cargados se conservan al editarlos.
- **Arreglos:** el formulario de cliente ahora abre encima de la lista de la cartera y no detrás. El aviso «Migrar planes Básico» ya no cuenta a Básico Anual.
- **Sin migración:** los clientes ya cargados funcionan igual. Si no tienen los campos nuevos, se toma que la implementación la cobró el contador, que no tienen extras y que siguen activos.

## 2026-09-26 · Factura IA pasa a llamarse **FactuIA** (solo etiquetas)

Rebrand decidido por Briant el 26-sep-2026. A diferencia de Komandi, **aquí solo cambia lo visible**.

- **Etiquetas visibles:** «Factura IA» → «FactuIA» en selector de línea, pipeline, campañas, metas SMB, Plan SMB, ajustes y comentarios; README, CLAUDE.md y `docs/` actualizados.
- **Clave interna sin cambios, a propósito:** `factura-ia` (valor de `line` en prospectos/campañas, guardado en localStorage y Supabase), `fia`, `fiaMetaSMB`, `FIA_SMB_MILESTONES` y `factura_ia` en `data/metas-smb-2026.json`. No hay migración.
- **Datos intactos:** `data/*.json` (incluye `planes-factura-ia.json` y su campo `producto`), `backups/` y `db/`. Odoo sigue llamando al producto con el nombre viejo hasta que se renombre allá.
- Origen de venta de Vendi/Komandi: la opción se ve como «Venta cruzada FactuIA» pero su `value` sigue siendo «Venta cruzada Factura IA», para que los registros ya guardados sigan coincidiendo.
- Entradas anteriores de este changelog se dejan con el nombre de su fecha.
- **Nombre final: «FactuIA» (junto).** Es el nombre legal, registrado así en Hacienda y en el CNR; la etiqueta intermedia en dos palabras se unificó a «FactuIA». Claves internas y `value` guardados, igual que arriba, sin cambios.

## 2026-09-07 · Comandi pasa a llamarse **Komandi** (con K)

Cambio de nombre de la línea de negocio, decidido el 07-sep-2026. Se renombró tanto lo visible como la **clave interna**, con migración automática para no perder nada de lo ya registrado.

- **Etiquetas visibles:** «Comandi» → «Komandi» en menú, selector de línea, títulos, botones y ajustes.
- **Clave interna:** `comandi` → `komandi` en `state.lineSales`, y `comandiMetaMRR` / `comandiMetaCli` → `komandiMetaMRR` / `komandiMetaCli`.
- **Migración `migrateComandiToKomandi()`**: corre al inicio de `normalize()`, que es el único embudo por donde entra el estado — **localStorage, Supabase e importación de respaldo**. Mueve las ventas y las metas a la clave nueva y borra la vieja; si por alguna razón ya existieran las dos, las une sin duplicar por `id`. Al primer `save()` el estado queda escrito con la clave nueva.
- **No hace falta migración SQL:** Supabase guarda un único JSON por usuario (`dashboards.data`), así que el cambio de forma viaja en el mismo documento.
- **`backups/` y `db/restore-datos-2026-08-31.sql` se dejaron intactos a propósito** — son registros fechados de lo que el sistema tenía ese día. Si se restauran, la migración los convierte al cargarlos.
- Probado en local con un estado de clave vieja (2 ventas + metas) y con el respaldo real del 31-ago: ambos migran completos, sin errores de consola.

## 2026-09-02 · Tres bajas de cartera

- **`seedSyncOdooV7`** (one-shot, confirmada por Briant): se dan de baja al **02-sep-2026** tres clientes mensuales sin suscripción activa, los tres de Briant, del libro anterior y sin contador referidor asociado:
  - **ARC MULTISERVICIOS, S.A.S. de C.V.** — Professional mensual, $19.99/mes (alta 25-mar-2026).
  - **EMPRENDEDORES EN MOVIMIENTO, S.A.S.** — Advanced mensual, $29.99/mes (alta 19-ago-2025).
  - **Mario Ernesto Flores Blanco** — Starter mensual, $9.99/mes (alta 06-jul-2025).
- Impacto: **−3 clientes activos** (528 → 525), **−$59.97 de MRR** y bajas acumuladas 27 → 30 (churn 4.86% → 5.41%). La implementación cobrada no cambia (se cobró al cierre). Reversible con *Reactivar* en *Ventas*.

## 2026-08-31 · Correcciones de comisiones y de fechas

- **El 2% de planes anuales ya no aplica al plan Básico** (confirmado por Briant). Agosto pasa de $43.60 a **$40.00 brutos / $36.00 netos**, que es el cálculo correcto: $200 de implementaciones x 20% - 10% de renta.
- **Bug de zona horaria (UTC vs local)**: `todayISO()` y `curMonth()` usaban `toISOString()`, que es UTC. Como El Salvador es UTC-6, a partir de las **6 PM** el dashboard saltaba al dia (y al mes) siguiente: la comision del mes se veia en $0, las ventas nuevas nacian con la fecha de manana y "vencen hoy" se corria un dia. Ahora todas las fechas se calculan en hora local.
- Documentacion de comisiones actualizada en manual, modelo de datos y arquitectura.

## 2026-08-31 · CRUD completo en la cartera de contadores

- Nuevo modal **cliente referido**: se pueden **agregar, editar y quitar** clientes en la cartera de cualquier contador (antes solo entraban por ventas vinculadas o por la semilla del código). Montos autocompletados por plan y período.
- Botón **➕** en cada fila de la tabla de contadores y **Agregar cliente a esta cartera** dentro de su lista; los clientes que vienen de una venta del dashboard llevan a *Ventas* con **Ver venta →**.
- Documentada la **matriz de funciones** (crear / editar / eliminar por módulo) en `docs/MANUAL-DE-USO.md` §6.

## 2026-08-31 · Conciliación con Odoo

Cruce de las 527 suscripciones activas del export `sale.order` contra el dashboard. Cierre: **528 clientes en ambos lados**, recurrente mensual $7,531.09 (2 centavos de diferencia por redondeo) y prepago anual $13,060.95 **exacto**.

- **Migraciones `seedSyncOdooV1` a `V6`** (one-shot, cada una confirmada por Briant): Medina Cuéllar a mensual · Rosales López, Inversiones Locales, Inversiones y Servicios Los 4 y Grupo Inlosa a Básico Anual $60 · Ana Ruth Ramírez a Starter Anual $113.87 · Castro Barraza a Básico Anual (venta y cartera del contador) · **Bautista Renderos de mensual $180 a anual $180/año** · Javier Larreynaga a Básico Anual · baja de Lilián García.
- **Respaldo de referencia** en `backups/smb-erp-respaldo-2026-08-31-post-conciliacion.json` + reporte `conciliacion-odoo-2026-08-31.xlsx`.
- Aprendizajes registrados en `backups/README.md`: una fecha de próxima factura lejana no implica error (clientes VIP y meses pagados por adelantado); la señal real es un plan "Mensual" cuyo monto equivale a un año.

## 2026-08-31 · SMB ERP v2

### Renombre y documentación
- La app pasa de **"Odoo Task"** a **"SMB ERP"** (título, login, barra lateral, nombre del respaldo).
- Repo reorganizado: `docs/` (manual, arquitectura, modelo de datos, despliegue), `db/` (esquema SQL) y `data/` (datasets de referencia).
- Documentación completa en español.

### Panel de Contadores (estilo panel ejecutivo)
- Hero **"Valor de cartera · Año 1"** (implementaciones + ARR) con mini-stats: MRR, ARR, % anuales y ticket promedio.
- **Acciones sugeridas** con severidad: migrar planes Básico, activar baja cartera, riesgo de concentración, contador destacado.
- Gráficas: **Ranking Año 1** (barras apiladas ARR + implementación, clic abre clientes), **mezcla de planes** (dona) y **crecimiento de la red** (altas/mes + línea de MRR nuevo).
- **Tabla de desempeño** ordenable con avatar, medallas top 3, participación con barra y última alta.
- **Programa de referidos**: a quién premiar (premio = 1 mes de MRR) y a quién impulsar/reactivar (con tracción / dormido / activar).
- Base histórica importada de contadores-referidores-fia.vercel.app: **36 contadores, 205 clientes** (`seedContadoresV1`).

### Metas SMB fijas (Plan Línea SMB 2026 · 14-ago)
- **Inicio · Factura IA**: recurrente ($18,928 a dic, escalera $10,638 → $18,928) **+ 332 altas** del período (escalera 52/79/96/105).
- **Contadores**: 55 altas/mes · 220 del período · aporte $4,620/mes a dic, con barras y escalera sep–dic.

### Vínculo pipeline → contadores
- Con origen **"Alianza Contable"** o **"Referido"** aparece el selector de **contador referidor** (prospecto y venta).
- Al ganar el prospecto, la venta hereda contador, origen y promo — y alimenta la cartera del contador.

### Promo "Implementación gratis"
- Checkbox 🎁 destacado (verde punteado) bajo el selector de plan en los tres formularios: venta Factura IA, venta Vendi/Komandi y prospecto.
- La implementación cuenta $0 en todo el dashboard (KPIs, campañas, comisiones, listas) y muestra etiqueta **Gratis**.
- Se hereda del prospecto a la venta; en la tarjeta del tablero aparece "🎁 Impl. gratis".

### Corrección de ventas de agosto (seedAugBriantV1)
- 3 Starter: Corado Cruz a precio **anterior** ($9.99) · UDP Clínicas Green Life y Diversificadora Verde Valle a precio **nuevo** ($14.99).
- 3 Básico Anual a precio de lista ($5/mes anual + $30 impl): Escobar Alvarado, Transporte Brisas del Pacífico, Osorio Quintanilla.

## 2026-08-30 · Líneas de negocio

- **Selector de línea** (Factura IA · Vendi · Komandi) visible en todas las vistas + entradas en menú lateral.
- **Vistas Vendi y Komandi**: KPIs con % de avance, meta de facturación con escalera sep–dic, **tarifario Stradia** (Emprende $50 no publicado · Crece $99 · Profesional $299 ⭐ · Empresarial $499 · Corporativo $899), cartera meta a diciembre (mezcla por plan) y registro de clientes con editar/baja/eliminar.
- Regla anual adelantado: **10% de descuento + implementación bonificada**.
- Metas SMB por línea editables en Ajustes.
- Tarjeta **"Meta SMB · Factura IA"** en Inicio.

## 2026-08 (previo) · Base del dashboard

- Dashboard ejecutivo de Factura IA: Inicio, Resumen, Tareas, Pipeline (BANT + auto-conversión), Campañas (CAC/ROI), Ventas (libro de precios nuevo v2026-08 / anterior, corte 2026-08-01), Planes, Canales, Calendario, Metas y Proyección (comisiones de Briant y René), Ajustes con respaldos e importación CSV.
- Sincronización Supabase (JSON por usuario + RLS) con espejo en localStorage.
- Deploy en Vercel (proyecto `odoodash`) desde GitHub `main`.
