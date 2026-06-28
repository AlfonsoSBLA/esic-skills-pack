---
name: hc-demo-build
description: Skill orquestadora que ejecuta las 4 skills atómicas del demo de adquisición en orden (`/landing-builder` → `/landing-deploy` → `/form-builder` → `/landing-deploy` re-deploy → `/make-scenario-builder`) con confirmaciones entre pasos. Pausa para que el alumno ejecute el Apps Script en script.google.com y vuelva con el Form ID, y para que importe el blueprint en Make. Output final = URL pública Netlify con form funcional + scenario Make activo.
---

# /hc-demo-build — Orquestador

## Cuándo aplica

S3 del curso (bloque 1, demo profesor en vivo, 15-20 min). O para regenerar el demo completo si algo se rompe o se rehace.

## Stack que construye

```
   ┌─────────────────────────────┐
   │  Landing HTML (Netlify)     │ ← /landing-builder + /landing-deploy
   └────────┬────────────────────┘
            │ iframe embed
            ▼
   ┌─────────────────────────────┐
   │  Google Form                │ ← /form-builder (Apps Script · materializa Form + Sheet)
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
   │  Brevo · lista              │ (pre-creada por el alumno · 5 min en Brevo UI)
   └─────────────────────────────┘
```

## Pre-requisitos

- Tu runtime debe tener tools/MCPs para: Netlify (deploy), Apps Script (opcional · ejecución de .gs), Make.com (opcional · import blueprint), Brevo (opcional · ya creada la lista)
- Cuenta Google (para Forms/Sheets/Apps Script)
- Cuenta Brevo con lista creada + List ID conocido + API key v3
- Cuenta Make.com con connections Google Sheets y Brevo configuradas

## Pattern

1. **Acoge** — confirma defaults o cliente alternativo
2. **Plan** — muestra los 5 pasos con tiempos
3. **Ejecuta pasos 1-5** secuencial, con CONFIRM entre cada uno
4. **Reporta E2E** — URLs y siguientes acciones

## Flujo

### Acoge

*"Voy a montar el demo entero del stack acquisition. Defaults: cliente HC, look&feel `diagnostico.hospitalcapilar.com/que-me-pasa`. ¿Confirmas o ajustamos?"*

### Plan (espejo al user)

| Paso | Skill | Output | Tiempo aprox |
|---|---|---|---|
| 1 | `/landing-builder` | `index.html` con FORM_ID_PLACEHOLDER | 1 min |
| 2 | `/landing-deploy` (sin Form ID) | URL pública con form vacío | 30 s |
| 3 | `/form-builder` | `crear-form.gs` + instrucciones | 1 min + **5 min tú en script.google.com** |
| 4 | `/landing-deploy` (con Form ID real) | URL pública con form funcional | 30 s |
| 5 | `/make-scenario-builder` | `scenario-blueprint.json` + instrucciones | 1 min + **10 min tú en Make.com** |

**Tiempo total**: ~3 min de skills + ~15 min de intervención del alumno = ~18 min para tener el stack completo y vivo.

*"¿Empezamos por el Paso 1?"*

### Ejecuta · Paso 1 (landing-builder)

Invoca `/landing-builder` con defaults HC. Confirma con el alumno el HTML generado.

### Ejecuta · Paso 2 (landing-deploy SIN Form ID)

Invoca `/landing-deploy` con `FORM_ID_PLACEHOLDER` intacto. Output: URL pública con form gris vacío. *"La landing ya está pública. Ahora generamos el Form."*

### Ejecuta · Paso 3 (form-builder)

Invoca `/form-builder` con defaults HC. Genera `crear-form.gs`. **PAUSA**:

*"He generado el Apps Script. Ahora tú haces esto (5 min):*
1. *Abre `script.google.com` → Nuevo proyecto*
2. *Pega TODO el `crear-form.gs`*
3. *Pulsa ▶ Ejecutar sobre `crearForm`*
4. *Autoriza permisos*
5. *Ver → Registros (Cmd+Enter) → copia el Form ID y el Sheet ID*
6. *Vuelve y pásamelos"*

**WAIT for user response** con el Form ID + Sheet ID.

### Ejecuta · Paso 4 (landing-deploy CON Form ID)

Invoca `/landing-deploy` con el Form ID del Paso 3. Reemplaza el placeholder + re-deploy. Output: URL pública con form embebido funcional.

*"La landing ya tiene el form embebido y funcionando. Si rellenas el form ahora, llega al Sheet vinculado. Ahora montamos el flujo Sheet → Brevo."*

### Ejecuta · Paso 5 (make-scenario-builder)

Invoca `/make-scenario-builder` con la URL del Sheet (del Paso 3) + List ID de Brevo. Genera `scenario-blueprint.json`. **PAUSA**:

*"He generado el blueprint Make. Ahora tú haces esto (10 min):*
1. *Abre `make.com` → My Apps → crea Connection Google Sheets + Connection Brevo*
2. *Scenarios → Create new → ··· → Import blueprint → selecciona `scenario-blueprint.json`*
3. *En cada módulo, edita Connection y selecciona las que creaste*
4. *Reemplaza los 3 placeholders REEMPLAZA_POR_... con tus IDs reales*
5. *Run once → verifica verde*
6. *Schedule = Every 15 minutes · Toggle ON*"

### Reporta E2E

```
✅ Stack acquisition demo completo

   Landing pública:    https://<slug>.netlify.app
   Form Google:        <URL público del Form>
   Sheet vinculada:    <URL del Sheet>
   Brevo lista:        [Cliente] · Solicitudes valoración (List ID: <N>)
   Make scenario:      [Cliente] · Sheets to Brevo (cada 15 min)

   Test E2E ahora:
   1. Abre la URL Netlify → rellena el form
   2. Fila aparece instantánea en el Sheet
   3. En ≤15 min, contacto aparece en Brevo

   Lo que muestras en clase (proyector):
   - URL Netlify en pantalla
   - Voluntario rellena form en su móvil
   - Refresh Sheet · llega la fila
   - Refresh Brevo · llega el contacto
```

## Reglas

- Pausas en Paso 3 y Paso 5 SON OBLIGATORIAS · esas piezas las ejecuta el alumno, no la skill
- Si el alumno interrumpe, retomar desde el paso que faltaba (no rehacer los anteriores)
- Defaults HC SIEMPRE proponer · cualquier cliente alternativo requiere args explícitos en /landing-builder
- Pasos 1-2 se pueden saltar si el site ya está deployado
- Pasos 3-4 se pueden saltar si el Form ID ya existe
- Paso 5 se puede saltar si Make ya está configurado
- Reportar E2E al final SIEMPRE · es lo que el alumno necesita para verificar

## Output

URL final pública + URLs intermedias (Form, Sheet, Brevo lista, Make scenario). Persistir todo en memoria del runtime.

## Ejemplo HC (canónico · 18 min total)

**Input**: ninguno (defaults HC).

**Output**:
- `index.html` (~390 líneas)
- `crear-form.gs` (~80 líneas)
- `scenario-blueprint.json` (~3 KB)
- URL pública Netlify viva con form funcional + scenario Make corriendo

**En clase**: el profesor invoca `/hc-demo-build` al inicio de S3 bloque 1, mientras explica cada pieza. Los alumnos ven las skills ejecutarse + los outputs aparecer. Después, el ejercicio constructor del Ángulo de cada grupo (bloque 3) ya tienen el patrón claro.

## Variantes

- `/hc-demo-build skip-landing` — si Netlify ya está
- `/hc-demo-build skip-make` — solo landing + form
- `/hc-demo-build cliente=XLY` — sustituye HC por XLY en defaults (regenera con paleta XLY)

## Ver también

- Skills atómicas: `/landing-builder` · `/form-builder` · `/landing-deploy` · `/make-scenario-builder`
