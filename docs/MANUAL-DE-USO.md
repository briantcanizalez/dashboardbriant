# Manual de uso · SMB ERP

Guía de usuario del dashboard, vista por vista. Producción: **https://odoodash.vercel.app**

---

## 1. Acceso

- Inicia sesión con tu correo y contraseña (cuenta creada en Supabase → Authentication).
- El indicador de la esquina superior derecha muestra el estado de sincronización: **Local** (sin nube), **Guardando…** y **Guardado**.
- **Cerrar sesión**: botón al final del menú lateral.
- Si `config.js` no tiene credenciales, la app corre en **modo local**: sin login y con datos solo en ese navegador (útil para pruebas).

## 2. Selector de línea de negocio

Arriba del contenido hay tres botones que cambian la línea activa:

| Botón | Qué abre |
|---|---|
| **Factura IA** | El dashboard completo (Inicio y todas las vistas del menú "Panel") |
| **Vendi** | La vista de la línea Vendi (Stradia) |
| **Comandi** | La vista de la línea Comandi (Stradia) |

Los datos de cada línea viven separados: las ventas de Vendi/Comandi **no** se mezclan con las de Factura IA ni afectan sus KPIs.

---

## 3. Factura IA

### 3.1 Inicio
- **KPIs**: clientes activos (base + ventas), recurrencia mensual, tareas en curso y horas invertidas.
- **Meta SMB · Factura IA** (siempre visible):
  - **Recurrente**: avance hacia **$18,928/mes a diciembre** con la escalera sep $10,638 · oct $13,341 · nov $16,195 · dic $18,928.
  - **Altas**: avance hacia **332 altas nuevas** del período sep–dic (112 campaña + 220 contadores), escalera mensual **52 / 79 / 96 / 105**. Cada venta registrada cuenta como alta de su mes.
- **Pulso Masivo**: leads de hoy, pipeline, cierres del mes, MRR nuevo del mes (vs meta de Ajustes) y pasos vencidos.
- **Agenda de hoy**: tareas vencidas, en curso y pendientes, con cronómetro.

### 3.2 Resumen
- ¿Cómo va el mes? (selección de mes), comparativa vs mes anterior, KPIs de cartera, cartera por comercial, clientes por plan y Pareto de ingresos.

### 3.3 Tareas
- Lista o tablero kanban. Prioridad (Alta/Media/Baja), proyecto, fechas, recurrencia (diaria/semanal/mensual) y **cronómetro** por tarea (Iniciar/Pausar/Finalizar).

### 3.4 Pipeline
- Embudo: **Lead → Contactado → Demo → Negociación → Ganada / Perdida / Basura** (arrastra las tarjetas o edita el prospecto).
- **Calificación BANT** (Budget · Authority · Need · Timing): con 3 de 4 el prospecto califica como SQL.
- **Origen**: si eliges **"Alianza Contable"** o **"Referido"** aparece el selector de **Contador referidor** — elígelo para que, al cerrar, el cliente alimente la cartera de ese contador.
- **🎁 Implementación GRATIS**: marca la casilla verde (bajo el plan estimado) si el prospecto va con la promo; se hereda a la venta.
- **Al pasar a Ganada** se crea la venta automáticamente (sin duplicar), heredando plan, libro de precios, origen, contador y promo. Si lo regresas de Ganada, la venta generada se quita.
- KPIs del embudo: abiertos, valor potencial, tasa de conversión, ganadas; cierres por origen del mes.

### 3.5 Campañas
- Registra inversión en pauta (presupuesto/día o gasto real) y vincula prospectos/ventas.
- KPIs: inversión total, leads y costo por lead, **CAC**, **ROI global** (ingresos a 12 meses vs inversión).

### 3.6 Ventas
- **Nueva venta**: cliente, plan, modalidad (mensual / anual adelantado), fecha, origen (con selector de contador si aplica), vendedor y campaña.
- **Libro de precios**: las ventas desde el **1-ago-2026** usan el precio **nuevo**; puedes forzar "anterior" o "nuevo" al elegir el plan. La etiqueta **Nuevo** marca las ventas a precio nuevo.
- **🎁 Implementación GRATIS**: casilla verde bajo el plan; la implementación cuenta $0 en KPIs, campañas y comisiones, con etiqueta **Gratis** en la tabla. Desmárcala al editar para quitar la promo.
- **Reglas**: la mensualidad cuenta al MRR **a partir del 3er mes**; las ventas anuales suman a *pagos anuales*, no al MRR. **Baja** deja de contar clientes/MRR (reversible con *Reactivar*).
- **Servicios especiales** (no suman MRR ni clientes; pagan comisión propia): carga de datos $50 · capacitación virtual $50/h · presencial $100.

### 3.7 Planes / Canales / Calendario
- **Planes**: cartera agrupada por modalidad → plan → clientes, con buscador.
- **Canales**: cierres por comercial y clientes por mes.
- **Calendario**: inicios de venta y fechas estimadas de tareas.

### 3.8 Contadores (panel ejecutivo de la red)
- **Hero "Valor de cartera · Año 1"**: implementaciones + ARR de toda la red, con MRR, ARR, % de clientes anuales y ticket ARR promedio.
- **Meta SMB · Canal de contadores** (palanca 3 del plan): **55 altas/mes · 220 en el período · $4,620/mes a diciembre**, con barras de avance y escalera sep–dic. Comisión al contador: un mes de servicio por alta activada (~$21).
- **⚡ Acciones sugeridas**: migrar planes Básico (con el uplift en $), activar contadores de baja cartera, riesgo de concentración (>18% del aporte), contador destacado.
- **Gráficas**: ranking Año 1 (clic en una barra abre los clientes del contador), mezcla de planes y crecimiento de la red (altas/mes + MRR nuevo).
- **Desempeño por contador**: tabla ordenable (clic en encabezados) con medallas top 3, MRR, ARR, participación y última alta. Clic en la fila → lista de clientes (los agregados desde el dashboard salen con etiqueta **Nuevo**).
- **🏆 Programa de referidos**: *a quién premiar* (top por MRR; premio sugerido = 1 mes de su MRR) y *a quién impulsar/reactivar* (⚡ con tracción · ⏰ dormido · 💤 activar).
- **Nuevo contador**: nombre, teléfono/WhatsApp y correo. Editar/eliminar en cada fila (eliminar quita también el vínculo con sus ventas).

### 3.9 Metas y Proyección
- Avance a **1,000 clientes** y **$25,000 recurrentes** (metas personales, editables en Ajustes), proyección al ritmo actual, evolución mensual y composición de ingresos.
- **Comisiones del mes** (Briant y René): escalones 1–10 → 20% · 11–15 → 25% · 16+ → 30%; base = implementación + 1ª mensualidad; anual paga 2% del año; retención 10%. *(Una venta con promo de implementación gratis solo aporta la mensualidad a la base.)*

---

## 4. Vendi y Comandi (marca Stradia)

Cada línea tiene su vista con:

- **KPIs**: clientes cerrados vs meta, facturación recurrente vs meta, cierres del mes e implementación cobrada.
- **Meta de facturación · Plan SMB 2026** con % de avance y escalera:
  - Vendi: sep $349 · oct $1,642 · nov $3,832 · **dic $6,921** (30 clientes).
  - Comandi: sep $0 · oct $895 · nov $2,289 · **dic $4,582** (18 restaurantes).
- **Planes y precios (tarifario Stradia, mismo para ambas)**:

  | Plan | Conversaciones/mes | Locales | Mensual | Implementación |
  |---|---|---|---|---|
  | Emprende *(no publicado)* | 500 | 1 | $50 | $50 |
  | Crece | 1,000 | 1 | $99 | $99 |
  | Profesional ⭐ ancla | 3,000 | 2 | $299 | $490 |
  | Empresarial | 6,000 | 3 | $499 | $990 |
  | Corporativo | 10,000 | 5 | $899 | $1,900 |

  Reglas: excedente $0.10/conversación (nunca se corta el servicio) · local extra $25/mes · contrato 1 año con garantía de 30 días · **anual adelantado = 10% de descuento + implementación bonificada** · sin comisión sobre ventas/pedidos.
- **Cartera meta a diciembre**: la mezcla de planes del plan SMB vs los cerrados.
- **Clientes**: registro con plan, modalidad, origen y 🎁 promo; editar, dar de baja o eliminar.

---

## 5. Ajustes y Datos

- **Punto de partida y metas**: clientes base, metas personales (1,000 clientes / $25K), pagos anuales, meta de MRR nuevo por mes y **metas SMB por línea** (Factura IA / Vendi / Comandi, en $ y clientes).
- **Comisiones**: salario base, bono por meta y meta de clientes/mes.
- **Datos y respaldo**:
  - **Exportar respaldo (JSON)** — descarga todo el estado (`smb-erp-respaldo-AAAA-MM-DD.json`). Hazlo con frecuencia.
  - **Importar respaldo** — restaura un JSON exportado.
  - **Exportar ventas (CSV)** e **Imprimir reporte (PDF)**.
  - **Importar clientes desde CSV** — columnas: `cliente, plan, modalidad, fecha` (plantilla descargable).

## 6. Preguntas frecuentes

- **¿Dónde viven mis datos?** En tu fila de la tabla `dashboards` de Supabase (solo tu usuario puede leerla) y en espejo en el navegador. Ver [ARQUITECTURA.md](ARQUITECTURA.md).
- **¿Por qué una venta no suma al MRR?** Porque tiene menos de 3 meses (madura) o es anual (suma a pagos anuales).
- **¿Cómo quito la promo de una venta?** Edítala y desmarca la casilla 🎁.
- **¿Puedo cambiar las metas SMB?** Las de recurrente sí (Ajustes). Las escaleras mensuales y las de altas (332 / 55·mes) están fijas al plan del 14-ago; cambiarlas requiere editar el código (`FIA_SMB_*`, `CANAL_SMB`, `LINES`).

---

*SMB ERP · Grupo Consiti · Documento interno confidencial*
