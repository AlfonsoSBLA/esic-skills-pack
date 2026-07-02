---
name: form-builder
description: Skill conversacional que define tu Google Form de captación (campos, tipos, obligatorios, desplegables, hoja de respuestas y mensaje de confirmación) y te da el paso a paso para crearlo en forms.new. Termina diciéndote cómo coger los DOS enlaces (el PÚBLICO para responder y el PRIVADO de edición), el ID del Form y el enlace de la hoja de respuestas — que necesitarás para la landing y la automatización. Úsala en S3 para crear el Form antes de la landing.
---

# /form-builder · Conversacional

Define tu **Google Form de captación** y te guía para crearlo en forms.new. El Form es la pieza 1 de tu captación: la landing lo embebe y la automatización reacciona a sus respuestas.

## Pattern

Acoge → Diagnose → Confirma → Produce → Itera

## Flujo

### Acoge
*"¿Para qué es el Form y qué quieres capturar? (mínimo Nombre + Email · y Teléfono si la automatización va a mandar WhatsApp)."*

### Diagnose (2-3 preguntas)
**Q1 · Campos** — espejo en tabla: campo · tipo · obligatorio · opciones (si es desplegable).
**Q2 · Confirmación** — *"¿Qué ve el usuario al enviar? (default amable: 'Gracias, te escribimos enseguida')."*

### Confirma
Espejo de campos + hoja destino + mensaje antes de dar el paso a paso.

### Produce
Entrega la **tabla de campos** + el **checklist de creación** en forms.new, terminando SIEMPRE con cómo coger los 4 datos que necesitarás después:

```
CREA EL FORM (forms.new)
1. Abre forms.new con tu cuenta de Google.
2. Ponle título + una descripción corta.
3. Añade cada campo de la tabla:
   - Email → tipo "Respuesta corta" → ⋮ → Validación → Dirección de correo · márcalo Obligatorio.
   - Desplegables → tipo "Desplegable" con sus opciones.
4. Configuración → Presentación → mensaje de confirmación.
5. Respuestas → ⋮ → "Vincular a Hojas de cálculo" (crea la hoja de respuestas).

COGE ESTOS 4 DATOS (los necesitas para la landing y la automatización):
- 🔗 Enlace PÚBLICO (para responder): botón "Enviar" → pestaña del enlace 🔗 → copia (forms.gle/… o …/viewform).
- 🔒 Enlace PRIVADO (de edición): la URL de la barra del navegador mientras editas (…/forms/d/ID/edit). Es el que te deja VOLVER a tocar el Form.
- 🆔 ID del Form: la cadena larga entre /d/ y /edit (o entre /e/ y /viewform).
- 📊 Enlace de la HOJA de respuestas.
```

### Itera
*"¿Añado un campo? ¿Cambio el mensaje? ¿Te paso a /landing-builder con el ID para embeberlo?"*

## Reglas

- **Email siempre** con validación de correo + obligatorio.
- **Teléfono obligatorio si hay WhatsApp.** Si la automatización manda un WhatsApp (como en S3), el Form pide SIEMPRE un campo **Teléfono** (respuesta corta, obligatorio) — sin el número no se puede enviar/identificar el WhatsApp.
- **Hoja de respuestas siempre vinculada**: sin ella, la automatización no tiene de dónde leer.
- **Termina siempre recordando los 4 datos** (los DOS enlaces + ID + hoja). Sin el enlace **privado** no podrás volver a editar el Form; sin el **público** no puedes embeberlo en la landing.
- Creación **manual en forms.new** (parte del aprendizaje) — no inventes IDs ni enlaces.

## Handoff

→ Con el **ID**, pasa a `/landing-builder` para embeber el Form en la landing.
→ Con el enlace de la **hoja de respuestas**, pasa a `/workflow-designer` (o `/make-scenario-builder`) para la automatización.
