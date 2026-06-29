---
name: dashboard-builder
description: Skill conversacional que genera un dashboard HTML self-contained con Chart.js a partir de un dataset + KPIs. Hace preguntas sobre KPI hero, eje, comparativa y filtros ANTES de generar. Output listo para drag-and-drop a Netlify.
---

# /dashboard-builder — Conversacional

## Pattern (cumple `feedback_esic-skills-conversational`)

1. **Acoge** — confirma dataset + KPIs disponibles
2. **Diagnose** — 4 preguntas
3. **Confirma** — espejo
4. **Produce** — index.html self-contained con Chart.js
5. **Itera** — ¿ajustamos visual o publicamos?

## Flujo

### Q1 · KPI hero
*"¿Cuál es el UN número grande que el CEO mira primero? (LTV/CAC · pacientes nuevos · MRR · churn rate)"*
→ Va en banda hero arriba, font 96pt. Si tienes 2 → no entiendes la pregunta, pídete uno.

### Q2 · Eje X principal
*"¿Sobre qué eje cuentas la historia? (tiempo · canal · cohort · segmento · ciudad)"*
→ Tiempo es default. Cohort cambia el chart a heatmap. Canal cambia a barras.

### Q3 · Comparativa
*"¿Contra qué comparas para que el número signifique algo? (vs target · vs período anterior · vs benchmark sector · vs canal medio)"*
→ Sin comparativa, un número no significa nada. Obligatorio.

### Q4 · Filtros mínimos
*"¿Qué filtros activan al usuario? (canal · trimestre · país · segmento RFM)"*
→ Max 3 filtros. Si necesitas más, son 2 dashboards.

### Produce

Output: archivo `index.html` self-contained con esta estructura:

```html
<!DOCTYPE html>
<html>
<head>
  <title>{Dashboard name}</title>
  <style>/* CSS inline · responsive · móvil-first */</style>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
  <!-- BANDA HERO · 1 KPI gigante -->
  <section class="hero">
    <span class="eyebrow">{contexto}</span>
    <h1>{KPI hero value}</h1>
    <p class="comparison">{vs target X · +Y% vs Q anterior}</p>
  </section>

  <!-- FILTROS · max 3 -->
  <nav class="filters">
    <select id="filter-1">...</select>
    <select id="filter-2">...</select>
  </nav>

  <!-- CHART PRINCIPAL · evolución del KPI hero -->
  <section class="chart-main">
    <h2>Evolución</h2>
    <canvas id="chart-evo"></canvas>
  </section>

  <!-- TABLA COMPARATIVA · max 4 cols × 8 rows -->
  <section class="table-comp">
    <h2>Por {eje X}</h2>
    <table>...</table>
  </section>

  <!-- INSIGHT TEXTUAL · 1 frase debajo -->
  <aside class="insight">
    <p>{1 frase que un CEO entiende}</p>
  </aside>

  <script>
    /* Datos hardcoded del dataset + Chart.js render */
  </script>
</body>
</html>
```

### Itera

*"¿Cambio KPI hero? ¿Añado segundo eje? ¿Quito 1 filtro? ¿Te paso a /publish-pages para subir a Netlify?"*

## Reglas

- **1 KPI hero** gigante (96pt+ font) · solo uno · arriba del fold
- **Max 3 charts** (1 principal + 2 secundarios) · más es ruido
- **Max 3 filtros** · más rompe la usabilidad móvil
- **Responsive móvil obligatorio** · el CEO lo abre desde el móvil entre reuniones
- **Self-contained** · `<style>` inline + Chart.js via CDN · cero deps adicionales · cero build step
- **Comparativa SIEMPRE** · un número sin comparar no significa nada
- **Insight textual obligatorio** · 1 frase debajo que un no-técnico entiende
- **Sin librerías de fechas** · si necesitas fechas, format ISO antes de meter al chart
- **Colores accesibles** · contraste AA mínimo · daltónico-friendly (no rojo/verde solo)

## Ejemplos por ángulo del curso ESIC (Xuan Lan Yoga)

Cada ángulo del trabajo grupal tiene un KPI hero + tipo de chart específico. La skill cubre los 6 sin necesitar adaptación.

### Ángulo 1 · Mix de canales pagados

- **KPI hero**: LTV/CAC ratio blended (ej. "2.4x" vs target 3.0x · −20%)
- **Eje X**: canal · **Chart**: barras horizontales ordenadas por ratio
- **Tabla**: canal × (spend · LTV · CAC · ratio)
- **Insight**: "Email Marketing infrainvertido: ratio 5.2x con solo 4.700€/año vs Paid Search 1.8x con 22.500€/año"
- **Filtros**: trimestre · canal específico

### Ángulo 2 · Content + email loops

- **KPI hero**: ratio leads orgánicos / coste contenido (ej. "8.3 leads/€100 invertidos" vs benchmark sector 5.0)
- **Eje X**: tiempo + breakdown por origen (orgánico SEO · YouTube · Email · social)
- **Chart**: stacked area chart mostrando proporción orgánica creciendo MoM
- **Tabla**: post evergreen × (sessions · CR signup · CR signup→paid · revenue atribuido)
- **Insight**: "YouTube canal infrautilizado: 8.486 sessions/mes vs blog 4.000 pero genera 40% menos signups"
- **Filtros**: tipo de contenido · trimestre

### Ángulo 3 · Drop-off form → conversión paid

- **KPI hero**: CR signup→paid global (ej. "63.9%" vs target 58% · +6pp)
- **Eje X**: cohort semanal de trial · **Chart**: funnel chart con drop-off por paso (signup → activation D1 → 3 clases → paid)
- **Tabla**: paso del funnel × (volumen · CR step · drop-off %)
- **Insight**: "CR sano (+6pp vs target) pero volumen trials cae 15% · problema en visita→trial, no en trial→paid"
- **Filtros**: canal de origen · tipo de plan (mensual/anual)

### Ángulo 4 · Re-engagement RFM de cancelados

- **KPI hero**: % reactivados a 30d × LTV recuperado (ej. "8.2% · 412€ recuperados/usuario")
- **Eje X**: segmento RFM (Champions perdidos · At Risk · Lost · etc.) · **Chart**: heatmap cohort retention M0-M6 + barras por segmento
- **Tabla**: 8 segmentos canónicos × (volumen · CR reactivación · revenue medio recuperado · ROI campaña)
- **Insight**: "Champions perdidos (4% del total) reactivan al 18% · valen 6× más que el segmento Lost · concentrar ahí"
- **Filtros**: canal origen · meses desde cancelación

### Ángulo 5 · Anual vs Mensual · cuál promocionar más

- **KPI hero**: % anual del nuevo mix (ej. "8.0%" · target 18%) + LTV anual / LTV mensual ratio (~6x)
- **Eje X**: tiempo · **Chart**: split chart · línea % anual nuevos VS barras de revenue por plan VS curva de churn por plan
- **Tabla**: plan × (ARPU · LTV ajustado a churn · % del mix nuevo · % del MRR)
- **Insight**: "Cada switch mensual→anual vale +265€ LTV. Mover mix del 8% al 18% anual = +21k€ MRR adicional/mes"
- **Filtros**: cohort de signup · canal origen

### Ángulo 6 · Mix de productos · suscripción vs programas vs Master vs tienda

- **KPI hero**: % multi-product cohort (ej. "9.2% de usuarios compran 2+ líneas" · target 25%) + ARPU multi-product vs mono-product (~3x)
- **Eje X**: línea de producto · **Chart**: donut chart de revenue por línea + barras de spend marketing por línea (mostrar el gap)
- **Tabla**: línea × (% revenue · % spend · ARPU · LTV · CR cross-sell)
- **Insight**: "Master 108 genera 15% del revenue con solo 2% del spend (ratio 7.5x). Suscripción consume 90% del spend para 60% del revenue (ratio 0.67x). Reasignar 10% del spend a Master = +X€/mes esperado"
- **Filtros**: línea de producto · cohort de primera compra

## Ejemplo Hospital Capilar (one-shot · histórico)

- **KPI hero**: pacientes nuevos cerrados / mes (ej. "142" vs target 165 · −14%)
- **Eje X**: tiempo (12 meses) · **Chart**: line chart con banda target
- **Tabla**: tratamiento × (pacientes · ticket medio · ingresos)
- **Insight**: "DHI 1500 cae 23% MoM · FUE 2000 estable · investigar caída en consultas DHI"

## Handoff típico

→ Tras generar el HTML, pasa a `/publish-pages` para drag-and-drop a Netlify y obtener URL pública.
→ Si en la itera el alumno quiere VALIDAR si el dashboard es bueno, pasa a `/dashboard-judge`.

## Estado de la skill

**Versión 2 · 2026-06-28**: enriquecida con ejemplos específicos por cada uno de los 6 ángulos del curso ESIC. Skill funcional y aplicable a los 6 ángulos · NO es STUB (referencias previas a "STUB" en walkthroughs antiguos están desactualizadas · ignorar).
