# Changelog · SMB ERP

Historial de cambios del dashboard. Formato: fecha · qué cambió.

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
- Checkbox 🎁 destacado (verde punteado) bajo el selector de plan en los tres formularios: venta Factura IA, venta Vendi/Comandi y prospecto.
- La implementación cuenta $0 en todo el dashboard (KPIs, campañas, comisiones, listas) y muestra etiqueta **Gratis**.
- Se hereda del prospecto a la venta; en la tarjeta del tablero aparece "🎁 Impl. gratis".

### Corrección de ventas de agosto (seedAugBriantV1)
- 3 Starter: Corado Cruz a precio **anterior** ($9.99) · UDP Clínicas Green Life y Diversificadora Verde Valle a precio **nuevo** ($14.99).
- 3 Básico Anual a precio de lista ($5/mes anual + $30 impl): Escobar Alvarado, Transporte Brisas del Pacífico, Osorio Quintanilla.

## 2026-08-30 · Líneas de negocio

- **Selector de línea** (Factura IA · Vendi · Comandi) visible en todas las vistas + entradas en menú lateral.
- **Vistas Vendi y Comandi**: KPIs con % de avance, meta de facturación con escalera sep–dic, **tarifario Stradia** (Emprende $50 no publicado · Crece $99 · Profesional $299 ⭐ · Empresarial $499 · Corporativo $899), cartera meta a diciembre (mezcla por plan) y registro de clientes con editar/baja/eliminar.
- Regla anual adelantado: **10% de descuento + implementación bonificada**.
- Metas SMB por línea editables en Ajustes.
- Tarjeta **"Meta SMB · Factura IA"** en Inicio.

## 2026-08 (previo) · Base del dashboard

- Dashboard ejecutivo de Factura IA: Inicio, Resumen, Tareas, Pipeline (BANT + auto-conversión), Campañas (CAC/ROI), Ventas (libro de precios nuevo v2026-08 / anterior, corte 2026-08-01), Planes, Canales, Calendario, Metas y Proyección (comisiones de Briant y René), Ajustes con respaldos e importación CSV.
- Sincronización Supabase (JSON por usuario + RLS) con espejo en localStorage.
- Deploy en Vercel (proyecto `odoodash`) desde GitHub `main`.
