---
name: form-builder
description: Skill conversacional que define LA ESPECIFICACIÓN de UN Google Form de captación de leads (campos, tipos, obligatorios, opciones de desplegable, Sheet destino, mensaje de confirmación) y entrega instrucciones para crearlo A MANO en forms.new. NO genera Apps Script ni automatiza la creación — crear el Form manualmente es parte del aprendizaje del curso. Output = tabla de spec + checklist de creación manual. USA esta skill cuando Alfonso pida "define el form HC", "qué campos lleva el formulario", "spec del Google Form" o "haz el formulario para [cliente]".
---

# /form-builder · Conversacional (solo-spec)

## Cuándo aplica

Después de `/landing-builder` (la pieza 2 del stack). O cualquier momento en que necesites fijar **qué Google Form** crear: campos validados, desplegables, Sheet destino. La creación del Form es **manual** (forms.new) — esta skill produce la receta, no el artefacto.

> ⚠️ Esta skill NO genera Apps Script. El atajo `.gs` (`crearForm()`) se retiró: en el curso el Form se crea a mano y eso es parte del aprendizaje. El "qué crear" canónico vive en `../../canvas/google-form-questions.md`.

## Pattern

1. **Acoge** — confirma cliente + lista campos
2. **Diagnose** — 3 preguntas
3. **Confirma** — espejo
4. **Produce** — tabla de spec + checklist de creación manual en forms.new
5. **Itera** — ¿añado campo · cambio destino · activo response email?

## Flujo

### Acoge

*"¿Para qué cliente? ¿Qué quieres capturar como mínimo? Defaults HC: Nombre + Email validado + Teléfono + Tratamiento (dropdown) + Ciudad (dropdown) + Origen (dropdown)."*

### Q1 · Lista de campos final

Espejo de los campos definitivos (nombre del campo, tipo, requerido sí/no, opciones si es dropdown). Una tabla así:

| # | Campo | Tipo | Required | Opciones |
|---|---|---|---|---|
| 1 | Nombre y apellido | Texto corto | Sí | — |
| 2 | Email | Texto + validación email | Sí | — |
| 3 | Teléfono | Texto corto | Sí | — |
| 4 | Tratamiento | Dropdown | No | FUE 2000, FUE 3000, FUE 4500, Mesoterapia, DHI 1500, No estoy seguro |
| 5 | Ciudad | Dropdown | No | Madrid, Barcelona, Valencia, Sevilla, Bilbao, Otra |
| 6 | Origen | Dropdown | No | Google, Instagram, TikTok, Recomendación, Otra |

### Q2 · Sheet destino

*"¿Vinculamos a Sheet existente (dame URL) o creamos una nueva con nombre `[Cliente] · Solicitudes valoración`?"*

### Q3 · Mensaje de confirmación

*"Qué ve el usuario tras enviar. Default: 'Gracias. Te llamamos en menos de 24h.'"*

### Produce

Entrega DOS cosas:

**1. Tabla de spec** (la de Q1, ya confirmada) — copiable a `canvas/google-form-questions.md` si hay cambios.

**2. Checklist de creación manual** en forms.new:

```
1. Abre forms.new (loguéate con la cuenta donde quieras el Form).
2. Título: "[Cliente] · Solicita tu valoración…" · Descripción: el gancho.
3. Por cada campo de la tabla:
   - Texto corto para Nombre y Teléfono (marca "Obligatorio").
   - Email: Texto corto → ⋮ → Validación de respuesta → Texto → Dirección
     de correo electrónico (marca "Obligatorio").
   - Desplegables (Tratamiento · Ciudad · Origen): tipo "Desplegable",
     pega las opciones de la columna Opciones.
4. Configuración → Presentación → Mensaje de confirmación: el de Q3.
5. Respuestas → ⋮ → "Seleccionar destino de las respuestas" → Sheet
   (nueva con el nombre de Q2, o vincula la existente).
6. Enviar → pestaña <> (insertar) → copia el Form ID (la cadena entre
   /e/ y /viewform) → pásalo a /landing-deploy para el iframe.
```

### Itera

*"¿Añado un campo más? ¿Cambio orden? ¿Activo el recibo de respuesta al usuario? ¿Te paso a `/landing-deploy` con el Form ID para subir la landing actualizada?"*

## Reglas

- NO Apps Script · NO automatización · creación **manual** en forms.new (parte del aprendizaje)
- Email field SIEMPRE con validación de email · obligatorio
- Teléfono required = Sí por defecto (es lead capture, sin tel el lead no vale)
- Sheet destino SIEMPRE vinculada (sin Sheet el Form no es útil downstream)
- Mensaje confirmación NUNCA vacío · default amable
- El entregable es la **spec + checklist**, no un archivo ejecutable
- NO inventar API keys ni IDs · el Form ID se obtiene tras crear el Form a mano

## Output

Respuesta en chat con la tabla de spec + el checklist manual. Si cambia el set de campos canónico, refleja el cambio en `../../canvas/google-form-questions.md`.

## Ejemplo HC (canónico)

**Input**:
- Cliente: HC
- 6 campos (default)
- Sheet nueva con nombre `HC · Solicitudes valoración`
- Confirmación: *"Gracias. Te llamamos en menos de 24h con la opinión de uno de nuestros doctores."*

**Output**: tabla de los 6 campos + checklist forms.new. Alfonso crea el Form a mano, obtiene el Form ID, y sigue a `/landing-deploy`.

## Handoff típico

→ Tras crear el Form a mano y tener el Form ID, pasa a `/landing-deploy` (Form ID embedded + re-deploy Netlify).
→ Tras eso, pasa a `/make-scenario-builder` con la URL del Sheet.

## Ver también

- Skill orquestadora: `/hc-demo-build`
- Spec canónica de campos HC: `../../canvas/google-form-questions.md`
