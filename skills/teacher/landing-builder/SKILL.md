---
name: landing-builder
description: Skill conversacional que genera UNA landing HTML self-contained replicando el look&feel de un sitio de referencia. Output = `index.html` con CSS inline, hero + trust bar + secciones de problemas + cards de diferenciación + sección `<iframe>` con FORM_ID_PLACEHOLDER (lo rellena después /landing-deploy) + testimonios + FAQ + closing dark + footer. Pensada para construir EN VIVO la pieza 1 del stack acquisition de S3 (curso ESIC).
---

# /landing-builder — Conversacional

## Cuándo aplica

S3 del curso (bloque 1 · demo profesor) o cualquier momento en que necesites una landing self-contained de captación con form embebido para una demo educativa.

## Pattern

1. **Acoge** — confirma cliente + URL de referencia visual (si la hay)
2. **Diagnose** — 4 preguntas
3. **Confirma** — espejo
4. **Produce** — `index.html` self-contained
5. **Itera** — ¿ajustamos paleta · copy · secciones?

## Flujo

### Acoge

*"¿Para qué cliente? ¿Tienes URL de referencia visual o usamos el design system canónico HC (teal `#4CA994` + dark `#2C3E50` + soft `#F0F7F6`)?"*

Si tu runtime tiene capacidad de navegar y capturar paleta de un sitio real (ej. browser + extracción de `getComputedStyle`), úsala para detectar los colores exactos del sitio referencia. Si no, usa la paleta canónica HC abajo.

### Q1 · Headline y dolor

*"¿Cuál es la frase del hero? ¿Cuál es el dolor del visitante al llegar?"* — ej HC: *"Se te cae el pelo y no sabes por qué"* + *"El 70% de afectados no tiene diagnóstico"*.

### Q2 · 3 stats del trust bar

*"3 números/datos que validen credibilidad. Formato: número grande + label corto."* — ej HC: `70%` no diagnosticados · `20+` años · `3 min`.

### Q3 · Secciones intermedias

*"¿Qué secciones entre hero y form? Por defecto: ¿Te identificas con esto? (4 preguntas check) + ¿Por qué nosotros? (3 cards) + Form + Testimonios + FAQ + Closing dark."*

### Q4 · CTA copy

*"Texto del botón principal."* — ej HC: *"¿Qué me pasa? Descúbrelo en 3 min →"*.

### Produce

Genera un único `index.html` self-contained con esta estructura:

```
<head>
  - title + meta description
  - GA4 opcional (placeholder G-XXXXXXXXXX, se quita si no se quiere)
  - <style> inline con variables CSS para paleta
</head>
<body>
  - .demo-banner (amarillo · "Demo educativa · no es el sitio real")
  - <header> logo + (opcional) teléfono
  - <section .hero> eyebrow + h1 + lead + CTA verde-teal + meta-line
  - <section .trust-bar dark> 3 stats grandes
  - <section .section-gray> "¿Te identificas con esto?" + 4 .q-card check + chevron
  - <section .section-soft> "¿Por qué [cliente] es diferente?" + intro + 3 .why-card
  - <section .form-section #solicitar-cita> .form-inner con h2 + lead + <iframe class=form-embed src="https://docs.google.com/forms/d/e/FORM_ID_PLACEHOLDER/viewform?embedded=true">
  - <section .section> Testimonios 5★
  - <section .section-gray> FAQ con .faq-item desplegable visual
  - <section .closing dark> CTA secundaria
  - <footer> brand + disclaimer educativo
  - <script> postMessage listener para gtag form_submit
</body>
```

Variables CSS canónicas (paleta HC · cambia si referencia distinta):

```css
:root {
  --teal: #4CA994;
  --teal-dark: #3a8a78;
  --dark: #2C3E50;
  --soft: #F0F7F6;
  --gray-50: #F8FAFB;
  --ink: #1f2937;
  --muted: #6b7280;
  --border: #e5e7eb;
  --star: #facc15;
}
```

### Itera

*"¿Cambio el copy del hero? ¿Añado sección X? ¿Ajusto paleta? ¿Te paso a `/landing-deploy` para subir a Netlify?"*

## Reglas

- **Self-contained**: cero deps externas (CSS inline · GA4 opcional como CDN · iframe Google Forms es el único external request post-render)
- **Demo banner amarillo SIEMPRE** si replica un sitio real que el alumno no posee · disclaimer claro en footer también
- `FORM_ID_PLACEHOLDER` en el `<iframe>` src · NO inventar IDs reales · `/landing-deploy` se encarga del replace cuando exista
- Mobile responsive: `@media (max-width: 640px)` con padding reducido + iframe `min-height` aumentado
- Track `form_submit` en GA4 con `window.addEventListener('message')` listener (Google Forms envía `formSubmitted` postMessage al embed parent)
- NO meter vídeo · quote larga del CEO · más de 2 testimoniales. Pieza pedagógica · ligera

## Output

Un único archivo `index.html` self-contained (~12 KB · ~400 líneas).

## Ejemplo HC (canónico)

**Input**:
- Cliente: Hospital Capilar
- URL referencia: `diagnostico.hospitalcapilar.com/que-me-pasa`
- Hero: *"Se te cae el pelo y no sabes por qué"*
- Trust: 70% · 20+ · 3 min
- Secciones: defaults
- CTA: *"¿Qué me pasa? Descúbrelo en 3 min →"*

**Output**: `index.html` self-contained con la estructura de arriba + paleta detectada del sitio referencia (`#4CA994` · `#2C3E50` · `#F0F7F6`).

## Handoff típico

→ Tras producir el HTML, pasa a `/form-builder` para crear el Google Form con campos correctos.
→ Tras crear el Form, pasa a `/landing-deploy` con el Form ID para subir a Netlify con el iframe ya funcionando.

## Ver también

- Skill orquestadora: `/hc-demo-build` (encadena landing-builder + form-builder + landing-deploy + make-scenario-builder)
- Skills siguientes del stack: `/form-builder` · `/landing-deploy` · `/make-scenario-builder`
