# Respaldos · SMB ERP

Copias de seguridad del estado completo del sistema, en el mismo formato que exporta e importa la app (*Ajustes → Exportar/Importar respaldo*).

## Archivos

| Archivo | Qué contiene |
|---|---|
| `respaldo-sistema-2026-08-31.json` | **Respaldo canónico del sistema** al 31-ago-2026, generado desde las semillas del código en un arranque limpio: 544 ventas de Factura IA (batch Odoo + julio + agosto con sus libros de precios), 27 prospectos, 2 servicios, la red de 36 contadores con sus 205 clientes históricos, y toda la configuración con metas SMB |

## Qué incluye y qué no

- ✅ **Incluye** todo lo que las semillas del código cargan: la cartera histórica completa, las correcciones de datos publicadas y la configuración/metas.
- ⚠️ **No incluye** lo capturado a mano solo en la nube después de esa fecha: tareas, campañas creadas manualmente, prospectos nuevos del pipeline, ventas Vendi/Comandi registradas en producción, etc. Para eso está el **respaldo en vivo** (abajo).

## Cómo restaurar

1. Abre el dashboard → **Ajustes y Datos → Importar respaldo**.
2. Elige el `.json` de esta carpeta.
3. Todo el estado se reemplaza por el del archivo y se sincroniza a la nube al instante.

## Respaldo en vivo (recomendado, 1 clic)

El respaldo más completo siempre es el de tu sesión: **Ajustes → Exportar respaldo (JSON)** descarga `smb-erp-respaldo-AAAA-MM-DD.json` con TODO tu estado real (incluye lo manual). Guárdalo en esta carpeta y súbelo al repo:

```bash
git add backups/ && git commit -m "Respaldo en vivo AAAA-MM-DD" && git push
```

Convención de nombres: `smb-erp-respaldo-AAAA-MM-DD.json` (en vivo) · `respaldo-sistema-AAAA-MM-DD.json` (canónico de semillas).

> Sugerencia: exporta un respaldo en vivo al cierre de cada mes, junto con los cinco números de la cadencia del plan SMB.

---

*SMB ERP · Grupo Consiti · Documento interno confidencial*
