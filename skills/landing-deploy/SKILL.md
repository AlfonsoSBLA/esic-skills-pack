---
name: landing-deploy
description: Skill que sube un folder con `index.html` a Netlify producción usando el MCP/CLI de Netlify disponible en tu runtime. Si recibe un Form ID, primero edita el HTML reemplazando `FORM_ID_PLACEHOLDER` por el ID real (sin regenerar el HTML entero). Output = URL pública + admin URL Netlify + site ID. Si el site no existe, lo crea con `sites:create`.
---

# /landing-deploy — Conversacional

## Cuándo aplica

Tras `/landing-builder` (primer deploy con form vacío) o tras `/form-builder` (re-deploy con Form ID embebido). Cualquier momento en que un HTML self-contained necesite ir a producción pública.

## Pre-requisito

Tu runtime debe tener acceso a Netlify (CLI `netlify-cli` o MCP equivalente). Verifica con `netlify status` o el comando análogo de tu runtime. Si no estás autenticado: `netlify login`.

## Pattern

1. **Acoge** — confirma path del folder + site Netlify
2. **Diagnose** — 3 preguntas
3. **Confirma** — espejo + plan
4. **Produce** — (opcional) Edit del Form ID + deploy `--prod`
5. **Itera** — abre URL · cambia algo · re-deploya

## Flujo

### Acoge

*"¿Qué folder despliego? (default: el folder con el `index.html` que generó /landing-builder). ¿Tienes ya site en Netlify o creo uno nuevo?"*

### Q1 · Form ID a embeber

*"¿Tienes ya el Form ID de Google Forms? (la cadena entre `/e/` y `/viewform` del URL del iframe que dio /form-builder). Si NO → deploy con `FORM_ID_PLACEHOLDER` intacto (form aparecerá vacío). Si SÍ → edito el HTML antes del deploy."*

### Q2 · Site nuevo o existente

Si NO existe → *"Nombre del site (slug Netlify, ej `hc-demo-esic`)? ¿Team destino?"*. Crea con `netlify sites:create --name <slug> --account-slug <team>`.

Si SÍ → *"Site ID?"*. Usa `--site=<ID>` para no depender del link automático del folder.

### Q3 · Producción o preview

*"¿`--prod` (URL principal pública) o preview (URL único)? Default = `--prod` para demo educativo."*

### Confirma

Espejo: *"Voy a (1) editar `index.html` reemplazando FORM_ID_PLACEHOLDER por `<ID>`, (2) deploy a `https://<slug>.netlify.app` con `--prod`. ¿Confirmas?"*

### Produce

**Paso A · (opcional) Edit del Form ID**

Reemplaza en `index.html`:
```
"FORM_ID_PLACEHOLDER" → "<form-id-real>"
```
(operación simple de sustitución, no regenera el HTML completo).

**Paso B · Deploy**

```bash
netlify deploy --prod --dir=<folder> --site=<site-id>
```
(si site no existe primero: `netlify sites:create --name <slug> --account-slug <team>`)

**Paso C · Reportar URLs**

```
✅ Deploy live
   URL pública:  https://<slug>.netlify.app
   Admin:        https://app.netlify.com/projects/<slug>
   Site ID:      <id>
   Deploy ID:    <deploy-id>
```

**Paso D · (opcional) Verificación visual**

Si tu runtime tiene capacidad de browser, abre la URL y captura screenshot fullpage para confirmar que el render es correcto.

### Itera

*"¿Abre la URL en navegador? ¿Cambio algo en el HTML y re-deploya? ¿Te paso a `/make-scenario-builder` para automatizar Sheets→Brevo?"*

## Reglas

- SIEMPRE `--site=<ID>` explícito · NUNCA confiar en `.netlify/state.json` (el folder padre puede estar linkado a otro site distinto)
- Edit del placeholder = operación de sustitución simple · NO regenerar el HTML entero
- Antes de deploy: borrar/mover screenshots, READMEs internos, archivos de referencia. Solo debe ir al deploy lo que es parte de la página pública
- Site name debe ser único en Netlify · si choca, sugerir `<slug>-2026` o variante
- Tras crear site nuevo, GUARDAR el site ID + URL en memoria persistente del runtime para futuras re-deploys (re-deploys siempre por ID, no por nombre)
- Mode default = `--prod` · preview sólo si el alumno lo pide explícito

## Output

3 piezas:
1. URL pública (produccción)
2. Admin URL Netlify (para inspeccionar deploys, env vars, dominios)
3. Site ID (para re-deploys futuros)

## Ejemplo HC (canónico)

**Input**:
- Folder: el que generó /landing-builder
- Form ID: `1FAIpQLSc-abc...xyz` (de /form-builder)
- Site ID: `5c8e5e74-1759-43ec-8dfc-bec82226ffeb` (site `hc-demo-esic`, ya creado en team Growth4U)

**Acciones**:
1. Reemplaza `FORM_ID_PLACEHOLDER` → `1FAIpQLSc-abc...xyz` en index.html
2. `netlify deploy --prod --dir=<folder> --site=5c8e5e74-...`
3. Verifica visual de `https://hc-demo-esic.netlify.app`

**Output**:
```
✅ Deploy live · https://hc-demo-esic.netlify.app
   Form embebido funcional · captura → Sheet
   Tiempo: ~3 segundos
```

## Handoff típico

→ Tras deploy con Form embebido funcional, pasa a `/make-scenario-builder` para automatizar Sheet → Brevo.
→ Si quieres ver la pieza viva con un dato test, abre la URL, rellena el form, y verifica que llega al Sheet vinculado.

## Ver también

- Skill orquestadora: `/hc-demo-build`
- Skill anterior: `/landing-builder` (genera el HTML)
- Skill siguiente: `/make-scenario-builder` (automatiza Sheet→Brevo)
