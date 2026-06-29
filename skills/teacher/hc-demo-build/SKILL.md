---
name: hc-demo-build
description: Skill orquestadora que ejecuta las 4 skills atómicas del demo de adquisición HC en orden (`/landing-builder` → `/form-builder` → `/landing-deploy` → `/make-scenario-builder`) con confirmaciones entre pasos. Pensada para que Alfonso muestre EN VIVO en S3 cómo construir el stack completo. Pausa para que Alfonso cree el Google Form A MANO en forms.new (parte del aprendizaje) y vuelva con el Form ID. Output final = URL pública Netlify con form funcional + scenario Make activo. USA esta skill cuando Alfonso diga "monta el demo HC entero", "hazlo todo de un tirón" o "ejecuta el orquestador del demo".
---

# /hc-demo-build · Orquestador

## Cuándo aplica

S3 del curso ESIC, bloque 1 (demo Alfonso, 15-20 min). O para regenerar el demo completo si algo se rompe / se rehace.

## Stack que construye

```
   ┌─────────────────────────────┐
   │  Landing HTML (Netlify)     │ ← /landing-builder + /landing-deploy
   └────────┬────────────────────┘
            │ iframe embed
            ▼
   ┌─────────────────────────────┐
   │  Google Form HC             │ ← /form-builder (spec) · se crea A MANO en forms.new
   └────────┬────────────────────┘
            │ Native link
            ▼
   ┌─────────────────────────────┐
   │  Google Sheets (1 fila/lead)│
   └────────┬────────────────────┘
            │ Watch rows · cada 15 min
            ▼
   ┌─────────────────────────────┐
   │  Make scenario              │ ← /make-scenario-builder (blueprint JSON)
   │  Sheets row → Brevo contact │
   └────────┬────────────────────┘
            ▼
   ┌─────────────────────────────┐
   │  Brevo · lista HC           │ (pre-creada por Alfonso · 5 min en Brevo UI)
   └─────────────────────────────┘
```

## Pre-requisitos

- `netlify-cli` instalado + autenticado (`netlify status`)
- Cuenta Google (para Forms/Sheets · `alfonso@growth4u.io`)
- Cuenta Brevo creada + lista `HC · Solicitudes valoración` con List ID conocido + API key v3
- Cuenta Make.com creada + connections Google Sheets y Brevo configuradas

## Pattern

1. **Acoge** — confirma defaults HC o cliente alternativo
2. **Plan** — muestra los 5 pasos en orden con tiempos
3. **Ejecuta pasos 1-5** secuencial, con CONFIRM entre cada uno
4. **Reporta E2E** — URLs y siguientes acciones

## Flujo

### Acoge

*"Voy a montar el demo entero del stack acquisition. Defaults: cliente HC, look&feel `diagnostico.hospitalcapilar.com/que-me-pasa`, deploy al site `hc-demo-esic` (ID `5c8e5e74-...`). ¿Confirmas o ajustamos algo?"*

### Plan (espejo)

| Paso | Skill | Output | Tiempo aprox |
|---|---|---|---|
| 1 | `/landing-builder` | `landing/index.html` con FORM_ID_PLACEHOLDER | 1 min |
| 2 | `/landing-deploy` (sin Form ID) | URL pública con form vacío | 30 s |
| 3 | `/form-builder` | spec de campos + checklist forms.new | 1 min spec + **5 min tú creando el Form a mano** |
| 4 | `/landing-deploy` (con Form ID real) | URL pública con form funcional | 30 s |
| 5 | `/make-scenario-builder` | `make/scenario-blueprint.json` + instrucciones import | 1 min generar + **10 min tú en Make.com** |

**Tiempo total**: ~3 min de skills + ~15 min de tu intervención = ~18 min para tener el stack completo y vivo.

*"¿Empezamos por el Paso 1?"*

### Ejecuta · Paso 1 (landing-builder)

Invoca `/landing-builder` con defaults HC. Confirma con Alfonso el HTML generado.

### Ejecuta · Paso 2 (landing-deploy SIN Form ID)

Invoca `/landing-deploy` con `--site=5c8e5e74-...` y `FORM_ID_PLACEHOLDER` intacto. Output: URL `hc-demo-esic.netlify.app` con form gris vacío. *"La landing ya está pública. Ahora generamos el Form."*

### Ejecuta · Paso 3 (form-builder)

Invoca `/form-builder` con defaults HC. Entrega la spec de campos + checklist forms.new. **PAUSA**:

*"Aquí tienes la spec del Form. Ahora lo creas tú a mano (5 min · es parte del aprendizaje):*
1. *Abre `forms.new`*
2. *Crea los 6 campos según la tabla (Email con validación, los 3 desplegables con sus opciones)*
3. *Configuración → Mensaje de confirmación · Respuestas → vincula una Sheet destino*
4. *Enviar → pestaña `<>` → copia el Form ID (entre `/e/` y `/viewform`)*
5. *Vuelve y pásamelo*"

**WAIT for user response** con el Form ID.

### Ejecuta · Paso 4 (landing-deploy CON Form ID)

Invoca `/landing-deploy` con el Form ID del Paso 3. Edit del HTML + re-deploy. Output: URL pública con form embedded funcional.

*"La landing ya tiene el form embebido y funcionando. Si rellenas el form ahora, llega al Sheet vinculado. Ahora montamos el flujo Sheet → Brevo."*

### Ejecuta · Paso 5 (make-scenario-builder)

Invoca `/make-scenario-builder` con URL del Sheet (sacada del Apps Script log) + List ID de Brevo (Alfonso lo pasa). Genera `make/scenario-blueprint.json`. **PAUSA**:

*"He generado el blueprint Make. Ahora tú haces esto (10 min):*
1. *Abre `make.com` → My Apps → crea Connection Google Sheets + Connection Brevo*
2. *Scenarios → Create new → ··· → Import blueprint → selecciona `scenario-blueprint.json`*
3. *En cada módulo, edita Connection y selecciona las que creaste*
4. *Run once → verifica verde*
5. *Schedule = Every 15 minutes · Toggle ON*"

### Reporta E2E

```
✅ Stack HC demo completo

   Landing pública:    https://hc-demo-esic.netlify.app
   Form Google:        <URL público del Form>
   Sheet vinculada:    <URL del Sheet>
   Brevo lista:        HC · Solicitudes valoración (List ID: <N>)
   Make scenario:      HC · Sheets to Brevo (cada 15 min)

   Test E2E ahora:
   1. Abre la URL Netlify · rellena el form
   2. Fila aparece instantánea en el Sheet
   3. En ≤15 min, contacto aparece en Brevo

   Lo que muestras en S3 (proyector):
   - URL Netlify en pantalla
   - Voluntario rellena form en su móvil
   - Refresh Sheet · llega la fila
   - Refresh Brevo · llega el contacto
   - Total: 15-20 min de demo en clase
```

## Reglas

- Pausas en Paso 3 y Paso 5 SON OBLIGATORIAS · esas piezas las ejecuta Alfonso, no la skill
- Si Alfonso interrumpe, retomar desde el paso que faltaba (no rehacer los anteriores)
- Defaults HC SIEMPRE proponer · cualquier cliente alternativo requiere `/landing-builder` con args explícitos
- Pasos 1-2 se pueden saltar si el site ya está deployado · usar `skip-landing` arg
- Pasos 3-4 se pueden saltar si el Form ID ya existe · pasar Form ID directo
- Paso 5 se puede skipear si Make ya está configurado · usar `skip-make` arg
- Reportar E2E al final SIEMPRE · es lo que Alfonso necesita para la demo en clase

## Output

URL final pública + URLs intermedias (Form, Sheet, Brevo lista, Make scenario). Persistir todo en memoria `[[hc-demo-esic-netlify]]`.

## Ejemplo HC (canónico · 18 min total)

**Input**: ninguno (defaults HC).

**Output**:
- `landing/index.html` (390 líneas)
- Google Form HC creado a mano en forms.new (spec vía `/form-builder`)
- `make/scenario-blueprint.json` (3 KB)
- URL pública Netlify viva con form funcional + scenario Make corriendo

**En clase**: Alfonso invoca `/hc-demo-build` al inicio de S3 bloque 1, mientras explica cada pieza. Los alumnos ven las skills ejecutarse + los outputs aparecer en sus pantallas. Después, el ejercicio constructor del Ángulo XLY (bloque 3) ya tienen el patrón claro.

## Variantes

- `/hc-demo-build skip-landing` — si Netlify ya está
- `/hc-demo-build skip-make` — solo landing + form
- `/hc-demo-build cliente=XLY` — sustituye HC por XLY en defaults (regenera con paleta XLY)

## Ver también

- Skills atómicas: `/landing-builder` · `/form-builder` · `/landing-deploy` · `/make-scenario-builder`
- Site Netlify del demo: `[[hc-demo-esic-netlify]]`
- Step-by-step manual (para referencia humana): `../STEP-BY-STEP.md`
- Formato S3 opción C: `[[esic-curso-formato-sesiones-c]]`
