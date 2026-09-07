# CLAUDE.md — SMB ERP (dashboard)

> Contexto obligatorio para Claude Code en esta carpeta. Última actualización: 07/09/2026.
> Responsable: Briant Canizalez — Grupo Consiti S.A. de C.V. (El Salvador).

Dashboard ejecutivo **SMB ERP** en producción en https://odoodash.vercel.app.
Este directorio es un clon git de `briantcanizalez/dashboardbriant`: **push a `main` despliega
a producción en ~30 s**. No suba nada sin autorización de Briant.

Líneas de negocio: **Factura IA · Vendi · Komandi**.

---

## 🔤 Komandi (antes Comandi) — cambio de nombre del 07-sep-2026

El producto de pedidos por WhatsApp de Stradia Labs ya **NO** se llama Comandi.
Se llama **Komandi**, con K. «Comandi» es el nombre anterior, **retirado**.

**Cómo se escribe**

| Contexto | Forma |
|---|---|
| Texto normal | `Komandi` |
| Títulos y nombres de archivo | `KOMANDI` |
| Dominios, handles y claves técnicas | `komandi` |
| ❌ Nunca | *Comandi* |

Si encuentra «Comandi» en un archivo, **es un resto: corríjalo.**

**Etimología:** **Ko**manda + **Mandi**. La K es firma gráfica de la marca.

**Lo que NO cambió:** la mascota sigue siendo **Mandi** (Ko+Mandi), hermana de **Wendi** (Vendi) ·
la paleta (crema `#F5F2E8`, plum `#56243E`, saffron `#FDC555`) · Bricolage Grotesque + Inter ·
el tarifario · el posicionamiento.

**Dónde vive todo**

```
SMB\03-Komandi\                                  negocio, marca y material comercial
SMB\03-Komandi\Agente-Para-Vender-Komandi\       vault del agente (el agente se llama Mandi)
SMB\Blueprints\Blueprint-Komandi.md
```

Dominios: `komandi.stradialabs.com` · `komandi.consiti.com`

**Pendiente — no lo dé por hecho ni lo "arregle" por su cuenta**

- El **wordmark** de los logos todavía dice «Comandi» dibujado. Los **isotipos de Mandi sí sirven**
  tal cual: no llevan texto.
- Los **PDF** (manual de marca y presentación comercial) se regeneran **después** del logo nuevo.
- El **registro CNR** está a nombre de Comandi.
- Faltan renombrar **Fan Page, Instagram, WhatsApp Business** y el producto en **Odoo**.

**Regla de comunicación:** hacia adentro ya es Komandi, sin aclaraciones.
Hacia afuera **no se anuncia** hasta tener logo nuevo y el CNR resuelto.

📄 Detalle completo: `SMB\03-Komandi\00-Contexto\DECISION-Cambio-de-Nombre-Komandi.md`

---

## Cómo está el renombre dentro de este repo

Se renombró **también la clave interna**, con migración automática (07-sep-2026).

| Antes | Ahora |
|---|---|
| `state.lineSales.comandi` | `state.lineSales.komandi` |
| `config.comandiMetaMRR` | `config.komandiMetaMRR` |
| `config.comandiMetaCli` | `config.komandiMetaCli` |
| `data-line="comandi"` · `LINES.comandi` · `VIEWS.comandi` | `...komandi` |

**`migrateComandiToKomandi()` — no la quite.** Corre al inicio de `normalize()`, que es el
**único embudo** por donde entra el estado: `localStorage`, Supabase e importación de respaldo.
Mueve ventas y metas a la clave nueva, borra la vieja, y si existieran las dos las une sin
duplicar por `id`. Ahí es donde va cualquier migración de forma de datos futura.

**No hace falta migración SQL:** Supabase guarda un JSON por usuario (`dashboards.data`),
así que el cambio de forma viaja dentro del mismo documento.

**`backups/` y `db/restore-datos-2026-08-31.sql` están intactos a propósito** — son registros
fechados de lo que el sistema tenía ese día. Si los restaura, la migración los convierte al
cargarlos. No los "corrija".

**Para probar sin tocar producción:** copie la carpeta al scratchpad (`tar --exclude='.git'`),
ponga un `config.js` stub con `url:"TU_URL"` y sírvala en localhost — arranca en modo local,
solo `localStorage`, sin login.
