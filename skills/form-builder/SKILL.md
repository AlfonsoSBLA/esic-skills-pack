---
name: form-builder
description: Skill que genera un Google Apps Script (`.gs`) ejecutable que materializa UN Google Form completo con los campos correctos para captación de leads. El alumno pega el `.gs` en script.google.com, ejecuta `crearForm()`, y obtiene un Google Form real con título/descripción/campos validados/desplegables + Sheet vinculada automática. Mucho más demostrable en clase que abrir forms.new y crear los campos a mano.
---

# /form-builder — Conversacional

## Cuándo aplica

Después de `/landing-builder` (la pieza 2 del stack acquisition). O cualquier momento en que necesites un Google Form pre-configurado con campos validados, desplegables, y conexión nativa a una Sheet.

## Pattern

1. **Acoge** — confirma cliente + lista campos
2. **Diagnose** — 3 preguntas
3. **Confirma** — espejo
4. **Produce** — `.gs` con función `crearForm()` + instrucciones de cómo ejecutarlo
5. **Itera** — ¿añado campo · cambio destino · activo email confirmación?

## Flujo

### Acoge

*"¿Para qué cliente? ¿Qué quieres capturar como mínimo? Defaults HC: Nombre + Email validado + Teléfono + Tratamiento (dropdown) + Ciudad (dropdown) + Origen (dropdown)."*

### Q1 · Lista de campos final

Espejo de los campos definitivos:

| # | Campo | Tipo | Required | Opciones |
|---|---|---|---|---|
| 1 | Nombre y apellido | Texto corto | Sí | — |
| 2 | Email | Texto + validación email | Sí | — |
| 3 | Teléfono | Texto corto | Sí | — |
| 4 | Tratamiento | Dropdown | No | (lista personalizada) |
| 5 | Ciudad | Dropdown | No | Madrid · Barcelona · Valencia · Sevilla · Bilbao · Otra |
| 6 | Origen | Dropdown | No | Google · Instagram · TikTok · Recomendación · Otra |

### Q2 · Sheet destino

*"¿Vinculamos a Sheet existente (dame URL) o creamos una nueva con nombre `[Cliente] · Solicitudes valoración`?"*

### Q3 · Mensaje de confirmación

*"Qué ve el usuario tras enviar. Default: 'Gracias. Te llamamos en menos de 24h.'"*

### Produce

Genera `crear-form.gs` siguiendo el template de abajo, sustituyendo `{{...}}`. Adjunta también las **instrucciones de ejecución** (al final del `.gs` y en respuesta al user).

**Template** (Apps Script v8):

```javascript
/**
 * {{CLIENTE_NOMBRE}} · Crear Google Form para captación de leads
 *
 * Cómo ejecutar:
 *   1. Abre script.google.com → "Nuevo proyecto"
 *   2. Borra todo, pega este archivo
 *   3. Guarda con nombre "Crear Form {{CLIENTE_SLUG}}"
 *   4. Pulsa ▶ Ejecutar sobre la función crearForm
 *   5. Autoriza permisos (primera vez)
 *   6. Ver → Registros (Cmd+Enter) → copia los 3 URLs que aparecen
 */
function crearForm() {
  const form = FormApp.create('{{FORM_TITULO}}')
    .setDescription('{{FORM_DESCRIPCION}}')
    .setCollectEmail(false)
    .setConfirmationMessage('{{MENSAJE_CONFIRMACION}}')
    .setShowLinkToRespondAgain(false);

  form.addTextItem().setTitle('Nombre y apellido').setRequired(true);

  form.addTextItem()
    .setTitle('Email')
    .setHelpText('Necesitamos un email válido.')
    .setRequired(true)
    .setValidation(FormApp.createTextValidation().requireTextIsEmail().build());

  form.addTextItem()
    .setTitle('Teléfono')
    .setHelpText('Te llamamos en menos de 24h.')
    .setRequired(true);

  form.addListItem()
    .setTitle('¿Qué tratamiento te interesa?')
    .setChoiceValues({{TRATAMIENTO_OPCIONES_JSON}});

  form.addListItem()
    .setTitle('¿Desde qué ciudad escribes?')
    .setChoiceValues(['Madrid', 'Barcelona', 'Valencia', 'Sevilla', 'Bilbao', 'Otra']);

  form.addListItem()
    .setTitle('¿Cómo nos conociste?')
    .setChoiceValues(['Google', 'Instagram', 'TikTok', 'Recomendación', 'Otra']);

  const sheet = SpreadsheetApp.create('{{SHEET_NOMBRE}}');
  form.setDestination(FormApp.DestinationType.SPREADSHEET, sheet.getId());

  Logger.log('Form público URL: ' + form.getPublishedUrl());
  Logger.log('Form ID (para iframe src): ' + form.getId());
  Logger.log('Embed URL: https://docs.google.com/forms/d/e/' + form.getId() + '/viewform?embedded=true');
  Logger.log('Sheet vinculada URL: ' + sheet.getUrl());
  Logger.log('Sheet ID (para Make scenario): ' + sheet.getId());
}
```

**Instrucciones (al user en respuesta)**:

```
1. Abre script.google.com (loguéate con la cuenta donde quieras el Form/Sheet).
2. "Nuevo proyecto" → borra todo lo de Code.gs.
3. Pega el contenido del .gs generado.
4. Guarda (Cmd+S).
5. Pulsa ▶ "Ejecutar" sobre crearForm.
6. Autoriza permisos a Forms + Drive + Sheets (primera vez).
7. Ver → Registros (Cmd+Enter) → copia el Form ID y el Sheet ID.
8. Pásamelos para que el siguiente paso (/landing-deploy y /make-scenario-builder) los use.
```

### Itera

*"¿Añado un campo más? ¿Cambio orden? ¿Activo email confirmación al usuario? ¿Te paso a `/landing-deploy` con el Form ID?"*

## Reglas

- SIEMPRE Apps Script (.gs) · NO instrucciones manuales de "abre forms.new y haz click"
- Email field SIEMPRE con validación de email · obligatorio
- Teléfono required = Sí por defecto (lead capture sin tel no vale)
- Sheet destino SIEMPRE vinculada (sin Sheet el Form no sirve downstream)
- Mensaje confirmación NUNCA vacío · default amable
- `Logger.log` al final con los 3 URLs · clave para handoff a /landing-deploy y /make-scenario-builder
- NO inventar API keys ni IDs · son placeholders o se calculan dentro del script

## Output

Un único archivo `crear-form.gs` (~80 líneas) listo para pegar en script.google.com.

## Ejemplo HC (canónico)

**Input**:
- Cliente: HC
- 6 campos default
- Sheet nueva `HC · Solicitudes valoración`
- Confirmación: *"Gracias. Te llamamos en menos de 24h con la opinión de uno de nuestros doctores."*
- Tratamiento opciones: `['FUE 2000 folículos', 'FUE 3000 folículos', 'FUE 4500 folículos', 'Mesoterapia capilar', 'DHI 1500', 'No estoy seguro · quiero valoración']`

**Output**: `crear-form.gs` con ~80 líneas Apps Script.

**Tras ejecutar en script.google.com** el alumno obtiene:
- Google Form en su Drive con los 6 campos correctos
- Sheet vinculada vacía con headers automáticos
- 3 URLs en logs (Form público + Form ID + Sheet URL)

## Handoff típico

→ Tras ejecutar el `.gs` y obtener el Form ID, pasa a `/landing-deploy` (re-deploy con Form embebido funcional).
→ Tras eso, pasa a `/make-scenario-builder` con la URL del Sheet.

## Ver también

- Skill orquestadora: `/hc-demo-build`
- Skill anterior: `/landing-builder`
- Skill siguiente: `/landing-deploy`
