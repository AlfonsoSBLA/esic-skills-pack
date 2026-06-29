---
name: publish-pages
description: Skill conversacional que publica un HTML self-contained en Netlify con URL pública via drag-and-drop. Hace preguntas sobre site name, dominio personalizado y permisos ANTES de publicar. Antes apuntaba a GitHub Pages · renombrada conceptualmente en v4 (stack v4 usa Netlify porque alumnos no tienen GitHub Pro).
---

# /publish-pages — Conversacional

## Pattern

1. **Acoge** — confirma archivo a publicar (debe ser HTML self-contained · dame el path o sube el zip)
2. **Diagnose** — 3 preguntas
3. **Confirma** — espejo
4. **Produce** — instrucciones de drag-and-drop + URL final
5. **Itera** — ¿iteramos HTML antes de compartir?

## Flujo

### Q1 · Site name
*"¿Qué site name quieres? (ej: hc-adquisicion-2025 · xly-mix-canales-q4)"*
→ El nombre va al subdominio: `{site-name}.netlify.app`

### Q2 · Dominio personalizado
*"¿Vas a usar dominio propio (ej. dashboard.empresa.com) o vale el subdominio Netlify?"*
→ Si vale el de Netlify, saltamos config DNS.

### Q3 · Permisos
*"¿Público sin login (default) o privado con Netlify Identity?"*
→ Para el curso, default = público (los dashboards se enseñan al CEO sin fricciones).

### Produce

Instrucciones paso a paso (drag-and-drop · 30 segundos):

```
1. Asegurar HTML self-contained
   - index.html debe contener TODO (CSS inline · JS inline o CDN)
   - Cero deps externas locales
   - Si hay imágenes: zip con `index.html` + `/assets/`

2. Empaquetar
   - Carpeta con `index.html` (mínimo)
   - Comprimir a .zip si hay más assets

3. Drag-and-drop
   - Abrir https://app.netlify.com
   - Login (o sign up free · sin tarjeta)
   - Arrastrar la carpeta o .zip al área "Drag and drop your site folder"
   - Esperar 30 segundos

4. Personalizar URL
   - Site settings → Change site name
   - Poner el site name elegido en Q1
   - URL final: https://{site-name}.netlify.app

5. (Opcional) Dominio personalizado
   - Domain management → Add custom domain
   - Configurar CNAME en tu DNS apuntando a Netlify
   - Esperar propagación 5-30 min

6. Verificar
   - Abrir URL en incógnito
   - Test en móvil (los CEOs revisan dashboards desde móvil)
   - Compartir URL
```

### Itera

*"¿La URL funciona en móvil? ¿Necesitas iterar el HTML? Para iterar: editas el HTML local + vuelves a hacer drag-and-drop al MISMO site (Netlify lo sobrescribe · misma URL · cero downtime). Para publicar a otro Netlify de un compañero del grupo: dale acceso desde Site settings → Members."*

## Reglas

- HTML debe ser **self-contained** · si llama assets externos locales, fallará
- Site name único en Netlify (si está cogido, Netlify te avisa)
- Free tier: 100 GB bandwidth/mes · sobra para los dashboards del curso
- Para iterar: drag-and-drop al MISMO site reescribe el deploy (no crea uno nuevo)
- Cero costes mientras no necesites: SSL custom domain · server-side rendering · forms backend

## Failure modes comunes

| Error | Causa | Fix |
|---|---|---|
| "Page not found" tras drop | Falta `index.html` en raíz | Verificar que `index.html` está en la raíz del zip/carpeta · NO dentro de una subcarpeta |
| Charts vacíos | Chart.js sin CDN o ad-blocker | Verificar `<script src="https://cdn.jsdelivr.net/npm/chart.js">` |
| CSS no aplica | Estilos en archivo aparte no incluido | Inlinearlos con `<style>` |
| URL "stupendous-tapir-12345" | No has cambiado el site name | Site settings → Change site name |
| Cambios no se ven | Cache navegador | `Cmd+Shift+R` o ventana incógnita |
| 401 unexpectedly | Has activado Netlify Identity sin querer | Site settings → Identity → disable |

## Ejemplo Xuan Lan Yoga (Ángulo 1)

**Input**:
- Archivo: `dashboard-xly-mix-canales.html` (generado por `/dashboard-builder`)
- Site name: `xly-mix-canales-q4-2025`
- Sin dominio propio
- Público

**Output**:
- URL final: `https://xly-mix-canales-q4-2025.netlify.app`
- Tiempo deploy: ~30 segundos
- Compartible al CEO de Xuan Lan en 1 click

## Ejemplo Hospital Capilar (one-shot)

**Input**:
- Archivo: `dashboard-hc-adquisicion.html`
- Site name: `hc-adquisicion-2025`
- Sin dominio propio · público

**Output**: `https://hc-adquisicion-2025.netlify.app` en 2-3 min

## Nota stack v4

- Stack del curso: **Netlify free** (no GitHub Pages · alumnos no tienen GitHub Pro · Netlify es drag-and-drop sin git)
- El workflow tradicional con repo + Pages sigue siendo válido si el alumno YA tiene el repo · esta skill recomienda Netlify por velocidad y simplicidad
- Compatible con: Vercel · Cloudflare Pages · Surge.sh · cualquier static host con drag-and-drop

## Handoff típico

→ Una vez con URL pública, si quieres VALIDAR si el dashboard es bueno (¿se entiende? ¿el insight salta?), pasa a `/dashboard-judge`.
→ Si quieres iterar el contenido del dashboard tras feedback, vuelve a `/dashboard-builder`.
