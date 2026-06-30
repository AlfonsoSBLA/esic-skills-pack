---
name: publish-pages
description: Skill conversacional que publica un HTML self-contained (dashboard o landing) en Netlify con URL pública vía Netlify CLI/API — el deploy es programático (lo sube el agente con la API de Netlify), NO drag-and-drop manual. Pregunta site name, dominio y permisos ANTES de publicar. USA esta skill cuando el alumno quiera publicar, subir o desplegar un dashboard o una landing y obtener una URL pública.
---

# /publish-pages — Conversacional

## Qué hace y cómo

Publica un `index.html` self-contained en Netlify y devuelve una URL pública. **El deploy es programático**: vía la **API de Netlify** (tu agente en Teros la llama por su conexión/MCP) o vía **`netlify-cli`** si corres en local. Nada de arrastrar carpetas a mano — el agente sube los archivos por API.

## Pattern

1. **Acoge** — confirma el folder/HTML a publicar (debe ser HTML self-contained · dame el path)
2. **Diagnose** — 3 preguntas
3. **Confirma** — espejo
4. **Produce** — deploy vía Netlify CLI/API + URL final
5. **Itera** — re-deploy al MISMO site (misma URL)

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

Deploy programático a Netlify. Dos caminos según dónde corras:

**A · Vía API de Netlify (alumnos en Teros · preferido)**

El agente sube el sitio con la API de deploys de Netlify:
1. Crea (si no existe) o referencia el site por su `site_id`.
2. Sube el folder (los archivos, o un `.zip` del folder) al endpoint de deploys de Netlify.
3. Netlify responde con la URL pública (`https://{site-name}.netlify.app`).

Necesitas un **Netlify Personal Access Token** (Netlify → User settings → Applications → New access token). Tu agente lo usa como `Authorization: Bearer <token>`. En el curso, la conexión de Netlify se configura en S3 (API keys).

**B · Vía netlify-cli (si corres en local)**

```bash
# primera vez · crear el site:
netlify sites:create --name <site-name>

# desplegar (o re-desplegar) a producción:
netlify deploy --prod --dir=<folder> --site=<site-id>
```

Requiere `netlify-cli` instalado + `netlify login` (o `NETLIFY_AUTH_TOKEN` en el entorno).

**Output (ambos caminos):**
- URL pública: `https://{site-name}.netlify.app`
- Site ID (para re-deploys futuros)
- (CLI) Deploy ID

### Itera

*"¿La URL funciona en móvil? ¿Iteramos el HTML? Para iterar: editas el HTML y vuelves a desplegar al **MISMO `site_id`** (misma URL · Netlify sobrescribe el deploy · cero downtime). No creas un site nuevo cada vez. Para dar acceso a un compañero del grupo: Site settings → Members."*

## Reglas

- HTML debe ser **self-contained** · si llama assets externos locales, fallará
- **Deploy al MISMO `site_id`** para iterar (no crear sites duplicados en cada cambio)
- Credenciales: Netlify **PAT** (API) o `netlify login` / `NETLIFY_AUTH_TOKEN` (CLI). **Nunca** hardcodear el token en el HTML ni commitearlo a git
- Site name único en Netlify (si está cogido, Netlify avisa · prueba `<slug>-2026`)
- Free tier: 100 GB bandwidth/mes · sobra para los dashboards/landings del curso
- Público por defecto · privado = Netlify Identity (Q3)

## Failure modes comunes

| Error | Causa | Fix |
|---|---|---|
| "Page not found" tras deploy | `index.html` no está en la raíz del folder/zip | Verificar que `index.html` está en la raíz · NO dentro de una subcarpeta |
| 401 / 403 al desplegar | Token inválido o sin permisos | Regenera el PAT (API) o re-loguea `netlify login` (CLI) |
| Charts vacíos | Chart.js sin CDN o ad-blocker | Verificar `<script src="https://cdn.jsdelivr.net/npm/chart.js">` |
| CSS no aplica | Estilos en archivo aparte no incluido | Inlinearlos con `<style>` |
| URL "stupendous-tapir-12345" | No fijaste el site name | `sites:create --name <slug>` o Site settings → Change site name |
| Cambios no se ven | Cache navegador | `Cmd+Shift+R` o ventana incógnita |
| 401 al abrir la página | Netlify Identity activado sin querer | Site settings → Identity → disable |

## Ejemplo Xuan Lan Yoga (Ángulo 1)

**Input**:
- Archivo: `dashboard-xly-mix-canales.html` (generado por `/dashboard-builder`)
- Site name: `xly-mix-canales-q4-2025` · sin dominio propio · público

**Output**:
- Deploy vía API Netlify (el agente sube el folder) → URL `https://xly-mix-canales-q4-2025.netlify.app`
- Site ID guardado para re-deploys

## Ejemplo Hospital Capilar (one-shot)

**Input**: `dashboard-hc-adquisicion.html` · site name `hc-adquisicion-2025` · público

**Output**: `https://hc-adquisicion-2025.netlify.app` · deploy por API/CLI

## Nota stack v4

- Hosting del curso: **Netlify free, deploy vía CLI/API** (programático · lo hace el agente, no a mano). **No** GitHub Pages (alumnos sin GitHub Pro). **No** drag-and-drop manual.
- Compatible con Vercel · Cloudflare Pages · Surge.sh · cualquier static host con CLI/API.

## Handoff típico

→ Una vez con URL pública, si quieres VALIDAR si el dashboard es bueno (¿se entiende? ¿el insight salta?), pasa a `/dashboard-judge`.
→ Si quieres iterar el contenido del dashboard tras feedback, vuelve a `/dashboard-builder`.
