---
name: dashboard-from-sheet
description: Extiende /dashboard-builder con la capa "conectar a Google Sheet vivo via endpoint público gviz". Toma un HTML de dashboard ya generado (o lo recibe del propio /dashboard-builder), una URL de Sheet y los campos a leer, y devuelve el mismo HTML pero auto-alimentado por fetch + PapaParse + Chart.js, con refresh automático cada 60 min, indicador de freshness y botón "↻ Forzar refresh". Sin backend, sin Make, sin nada que escribir al Sheet — solo lectura pública. Si el Sheet es privado o gviz falla, fallback a /pub?output=csv.
---

# /dashboard-from-sheet — Conversacional

## Cuándo aplica

Tras `/dashboard-builder` (que genera un dashboard HTML self-contained con datos hardcodeados). O cualquier momento en que tengas un dashboard estático y quieras enchufarlo a un Google Sheet vivo sin meter backend en medio.

Si todavía no tienes el HTML del dashboard, primero invoca `/dashboard-builder` y luego esta skill encima.

## Pre-requisitos

- HTML del dashboard (de `/dashboard-builder` o escrito a mano) con `<canvas>` y funciones `drawHero`, `drawChart1/2/3` (o equivalentes).
- Google Sheet con los datos. Idealmente con "Cualquiera con el enlace" en compartir (para que gviz responda CORS abierto). Si privado → fallback a publicar como web (`Archivo → Compartir → Publicar en la web → solo esta hoja → CSV`).
- Pestaña concreta del Sheet con headers limpios en la primera fila (sin espacios al inicio, sin caracteres raros).

## Pattern

1. **Acoge** — qué dashboard + qué Sheet
2. **Diagnose** — 3-4 preguntas
3. **Confirma** — espejo con la URL gviz montada
4. **Produce** — HTML modificado + snippet JS + instrucciones de verificación
5. **Itera** — ¿cambio refresh interval · añado más charts · cambio fallback?

## Flujo

### Acoge

*"Voy a enchufar tu dashboard a un Sheet vivo. Lectura directa via endpoint público gviz · cero backend · refresh cada 60 min por defecto. Necesito 3-4 cosas."*

### Q1 · URL del Sheet + pestaña concreta

*"Pásame:*
- *URL del Sheet completo (de Drive · forma `https://docs.google.com/spreadsheets/d/{SHEET_ID}/edit`)*
- *Nombre exacto de la pestaña a leer (ej. `leads_with_rfm`)*
- *¿Está compartido como 'Cualquiera con el enlace puede ver'? Si NO → te paso a publicar como web (alternativa B)."*

Extraigo el SHEET_ID del URL (entre `/d/` y `/edit`). Compongo el endpoint:

```
https://docs.google.com/spreadsheets/d/{SHEET_ID}/gviz/tq?tqx=out:csv&sheet={SHEET_NAME}
```

### Q2 · Qué campos lee del Sheet

*"¿Qué columnas del Sheet voy a usar? Pásame los nombres EXACTOS de los headers (case-sensitive). Por cada campo, dime cómo se usa:*

| Header del Sheet | Usado en | Tipo |
|---|---|---|
| `email` | filtrar filas no vacías | string |
| `last_visit` | hero KPI · cohorts | date |
| `RFM_SEGMENT` | donut RFM | enum |
| `signup_month` | line cohorts | date |
| `treatment` | filtro tratamiento | enum |
| `city` | filtro ciudad | enum |

*Si algún header tiene variantes (ej. `email` vs `Email` vs `EMAIL`), avísame · uso defensive coding (`r.email ?? r.Email ?? r.EMAIL`)."*

### Q3 · Qué charts dibuja (validación de continuidad con /dashboard-builder)

*"Confirmo de tu dashboard:*
- *Hero KPI = `{KPI_HERO}` (ej. pacientes valorados/mes)*
- *Chart 1 = `{CHART_1}` (ej. funnel horizontal bar)*
- *Chart 2 = `{CHART_2}` (ej. donut RFM)*
- *Chart 3 = `{CHART_3}` (ej. line cohorts)*

*¿Algún chart NO depende del Sheet (queda con datos estáticos)? ¿O todos se alimentan del fetch?"*

### Q4 · Refresh + fallback

*"Defaults:*
- *Refresh automático cada 60 min (`setInterval(loadData, 3600000)`) + botón manual ↻*
- *Si fetch falla → usa datos sintéticos hardcodeados (los del /dashboard-builder original) · el dashboard NUNCA muestra pantalla en blanco*
- *Span 'Última actualización: {timestamp}' visible siempre*

*¿Cambio algo? ¿15 min en vez de 60? ¿Sin fallback?"*

### Confirma

Tabla espejo con la URL final + campos + charts + refresh + fallback. Si OK → produce.

### Produce

1 modificación del HTML existente: reemplaza el `<script>` con el snippet de abajo (adaptado a los campos del Q2). Si no hay HTML previo, devuelve un HTML completo con la estructura de `/dashboard-builder` + este script.

**Template JS reutilizable** (sustituir `{{SHEET_URL}}`, `{{FIELDS}}`, `{{FALLBACK_DATA}}`):

```javascript
// ============================================================
// dashboard-from-sheet · runtime
// ============================================================

const SHEET_URL = '{{SHEET_URL}}';
const REFRESH_INTERVAL_MS = 60 * 60 * 1000; // 60 min

// Datos sintéticos de fallback si fetch falla (sheet privado, red caída, etc.)
const FALLBACK_DATA = {{FALLBACK_DATA}};

let currentData = [];

async function loadData() {
  document.body.classList.add('loading');
  try {
    const res = await fetch(SHEET_URL, { cache: 'no-store' });
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const csv = await res.text();
    const parsed = Papa.parse(csv, { header: true, dynamicTyping: true, skipEmptyLines: true });
    currentData = parsed.data.filter(r => r.email ?? r.Email ?? r.EMAIL);
    if (!currentData.length) throw new Error('Sheet vacío');
    document.getElementById('source-label')?.classList.remove('fallback');
  } catch (err) {
    console.warn('Fetch del Sheet falló · usando datos sintéticos:', err.message);
    currentData = FALLBACK_DATA;
    document.getElementById('source-label')?.classList.add('fallback');
  }
  drawAll(currentData);
  document.getElementById('updated').textContent = new Date().toLocaleString('es-ES');
  document.body.classList.remove('loading');
}

function drawAll(data) {
  const filtered = applyFilters(data);
  drawHero(filtered);
  drawChart1(filtered);
  drawChart2(filtered);
  drawChart3(filtered);
}

function applyFilters(data) {
  const mes = document.getElementById('filter-mes')?.value || 'todos';
  const trat = document.getElementById('filter-trat')?.value || 'todos';
  const ciudad = document.getElementById('filter-ciudad')?.value || 'todas';
  return data.filter(r => {
    if (mes !== 'todos' && !(r.last_visit ?? '').toString().startsWith(mes)) return false;
    if (trat !== 'todos' && (r.treatment ?? r.tratamiento) !== trat) return false;
    if (ciudad !== 'todas' && (r.city ?? r.ciudad) !== ciudad) return false;
    return true;
  });
}

// Cableado UI: filtros + botón refresh
document.querySelectorAll('select[id^="filter-"]').forEach(s =>
  s.addEventListener('change', () => drawAll(currentData))
);
document.getElementById('refresh')?.addEventListener('click', loadData);

// Bootstrap
loadData();
setInterval(loadData, REFRESH_INTERVAL_MS);
```

**Instrucciones de verificación** (al user en respuesta):

```
Test local (1 min):
1. Abre el HTML en navegador: `open dashboard/index.html`
2. Inspector → Network → ver fetch al endpoint gviz
   - 200 OK + cuerpo CSV → ✅ funciona
   - 404 / login redirect → Sheet privado · publica como web (alternativa B)
   - CORS error → Sheet no es "Cualquiera con el enlace" · cambia compartir
3. Si fetch falla → dashboard muestra datos sintéticos (clase `.fallback` en label)
4. Cambia un valor en el Sheet → click ↻ Forzar refresh → verifica que el dashboard refleja el cambio

Alternativa B (si gviz no funciona):
- Sheet → Archivo → Compartir → Publicar en la web → seleccionar pestaña concreta → CSV → Publicar
- Copia la URL larga (forma `https://docs.google.com/spreadsheets/d/e/2PACX-.../pub?gid=XXX&single=true&output=csv`)
- Reemplaza el SHEET_URL en el script
- Más estable pero requiere re-publicar si cambias estructura
```

### Itera

*"¿Cambio el refresh interval? ¿Añado más campos al fetch? ¿Cambio el comportamiento del fallback? ¿O lo paso a `/dashboard-judge` para auditar el resultado?"*

## Reglas

- **Defensive coding** siempre: cada campo opcional con `r.field ?? r.Field ?? r.FIELD ?? defaultValue`. Headers de Google Sheets cambian mucho (espacios, mayúsculas) y rompen el dashboard si lo hardcodeas.
- **CORS** del endpoint `gviz` viene abierto por defecto cuando el Sheet es "Cualquiera con el enlace". Si no, el navegador bloquea y verás `CORS error` en consola — fallback a publicar como web.
- **Mobile-first**: filtros deben hacer wrap en móvil y los charts apilarse vertical. Verificar en DevTools responsive antes de publicar.
- **Fallback NUNCA opcional**: el dashboard SIEMPRE debe abrir y dibujar algo, aunque el fetch reviente. Datos sintéticos hardcodeados son la red de seguridad. Razón: el dashboard se enseña en clase / proyector — pantalla en blanco = pánico.
- **No escribir al Sheet jamás** desde el dashboard. Solo lectura. Esta skill no toca Google Sheets API write — solo `fetch()` público.
- **Cache busting** con `cache: 'no-store'`: si no, el navegador cachea el CSV durante minutos y el "↻ Forzar refresh" no hace nada.
- **API keys**: ninguna. El endpoint gviz es público. No metas tokens ni service accounts — si el Sheet necesita auth, esto NO es la skill correcta (cambia a backend).

## Output

1 pieza:
- `dashboard/index.html` modificado (o nuevo) con el `<script>` reemplazado por el runtime de arriba

## Ejemplo HC (canónico)

**Input**:
- Dashboard: el generado por `/dashboard-builder` para Hospital Capilar (hero pacientes valorados/mes + funnel + donut RFM + line cohorts)
- Sheet URL: `https://docs.google.com/spreadsheets/d/1AbCdEfGhIjKlMn.../edit`
- Pestaña: `leads_with_rfm`
- Campos: `email`, `last_visit`, `RFM_SEGMENT`, `signup_month`, `treatment`, `city`
- Refresh: 60 min · fallback ON

**Output**: `dashboard/index.html` con script reemplazado · endpoint final `https://docs.google.com/spreadsheets/d/1AbCdEfGhIjKlMn.../gviz/tq?tqx=out:csv&sheet=leads_with_rfm`

**Verificación**: abrir local → fetch a Sheet → 186 leads cargan → hero = "186" → donut con 8 segmentos RFM → cohorts retención M0→M6.

## Ejemplo XLY (alumno)

**Input**:
- Dashboard: el generado por `/dashboard-builder` para Xuan Lan Yoga · ángulo "valor del orgánico"
- Sheet URL: el del ángulo del alumno (datos sintéticos del Kit Starter)
- Pestaña: `attribution_log`
- Campos: `email`, `source`, `revenue`, `signup_date`
- Refresh: 60 min · fallback ON

**Output**: dashboard del alumno alimentado por SU Sheet · 1 KPI hero (% revenue orgánico) + 3 charts.

## Handoff típico

→ Tras conectar el Sheet, el dashboard ya respira solo. Siguiente paso = `/publish-pages` (drag-drop Netlify · URL pública).
→ Tras publicar, `/dashboard-judge` audita pre-share al CEO.
→ Si el Sheet cambia headers en el futuro → re-invocar esta skill para actualizar el mapping de campos.

## Ver también

- Skill anterior: `/dashboard-builder` (genera el HTML base)
- Skill siguiente: `/publish-pages` (deploy Netlify)
- Skill auditora: `/dashboard-judge` (pre-share)
- Skill orquestadora: `/hc-demo-build`
