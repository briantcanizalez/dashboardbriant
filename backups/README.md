# Respaldos · SMB ERP

Copias de seguridad del estado completo del sistema, en el mismo formato que exporta e importa la app (*Ajustes → Exportar/Importar respaldo*).

## Archivos

| Archivo | Qué contiene |
|---|---|
| **`smb-erp-respaldo-2026-08-31-post-conciliacion.json`** | ⭐ **El respaldo de referencia.** Estado real al 31-ago-2026 **después** de conciliar con Odoo: 528 clientes activos, $7,531.09 de recurrente mensual, $13,060.95 de prepago anual, 175 prospectos, 36 contadores y 2 campañas |
| `smb-erp-respaldo-2026-08-31.json` | Estado real **antes** de la conciliación (se conserva como punto de comparación) |
| `respaldo-sistema-2026-08-31.json` | Estado canónico generado solo desde las semillas del código, sin lo capturado a mano |
| `conciliacion-odoo-2026-08-31.xlsx` | Cruce contra el export `sale.order` de Odoo: resumen, faltantes, verificar/baja y montos distintos |

## La conciliación del 31-ago-2026

Se cruzaron las 527 suscripciones activas de Odoo contra el dashboard. Resultado final: **528 clientes en ambos lados**, recurrente mensual con 2 centavos de diferencia por redondeo y prepago anual **exacto**.

Correcciones aplicadas al dashboard (migraciones `seedSyncOdooV1` a `V6`, ver `index.html`):

| Cliente | Cambio |
|---|---|
| Medina Cuéllar, José Alberto | dejó el Básico Anual → mensual $9.99 |
| Rosales López · Inversiones Locales · Inversiones y Servicios Los 4 · Grupo Inlosa | Starter mensual → **Básico Anual $60/año** |
| Ramírez, Ana Ruth | Starter mensual → **Starter Anual $113.87/año** |
| Castro Barraza, Marco Tulio | → Básico Anual $60/año (también en la cartera del contador Luis Avalos) |
| Bautista Renderos, Miguel Ángel | estaba como **mensual $180** → anual $180/año |
| Javier Larreynaga Ayala | → Básico Anual $60/año |
| Lilián Verónica García | marcada de baja |

Corregido en **Odoo** por Briant: Castro Barraza, Erick Ruano y Javier Larreynaga tenían plan Básico Anual etiquetado como "Mensual", más el plan de Mayra Figueroa.

**Fechas de próxima factura lejanas que NO son error:** clientes VIP (Servicios de Transformación Digital, Karla Rivas) y clientes mensuales que pagan meses por adelantado (Mayora Re, Be So Creative, José Mauricio Loza).

## Cómo restaurar

1. Dashboard → **Ajustes y Datos → Importar respaldo**.
2. Elige el `.json` de esta carpeta (normalmente el `-post-conciliacion`).
3. Todo el estado se reemplaza y se sincroniza a la nube al instante.

## Cómo agregar un respaldo nuevo

**Ajustes → Exportar respaldo (JSON)** descarga `smb-erp-respaldo-AAAA-MM-DD.json` con todo tu estado real. Guárdalo aquí y súbelo:

```bash
git add backups/ && git commit -m "Respaldo AAAA-MM-DD" && git push
```

> Sugerencia: exporta un respaldo al cierre de cada mes, junto con los cinco números de la cadencia del plan SMB.

---

*SMB ERP · Grupo Consiti · Documento interno confidencial*
