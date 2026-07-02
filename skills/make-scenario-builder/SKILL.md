---
name: make-scenario-builder
description: Genera un blueprint JSON de Make.com listo para importar (Make → Scenarios → Create a new scenario → menú ⋯ → Import blueprint), para automatizar el pipeline del curso sin arrastrar módulos a mano. Por defecto: "Google Sheets (nueva fila = respuesta de tu Form) → Brevo (crear/actualizar contacto) → WhatsApp (aviso de nuevo lead)". Devuelve el archivo .json + las instrucciones de importar, conectar las cuentas y activar. Úsala en el bonus de Make cuando prefieras importar el flujo hecho en vez de montarlo click a click con /manual-guide.
---

# /make-scenario-builder · Conversacional

Materializa la automatización como un **blueprint JSON de Make** que solo tienes que importar. Es la vía rápida del **bonus de Make** — la alternativa a montarlo a mano con `/manual-guide`.

## Pattern

Acoge → Diagnose → Confirma → Produce → Itera

## Flujo

### Acoge
*"¿Qué automatización? Por defecto la del curso: Google Sheets (respuestas de tu Form) → Brevo (crear/actualizar contacto) → WhatsApp (aviso de nuevo lead)."*

### Diagnose (3 preguntas)

**Q1 · IDs** — *"Necesito: el enlace o ID de la hoja de respuestas de tu Form, y el List ID de Brevo donde añadir contactos (Brevo → Contacts → Lists → abre la lista → el número que sale en la URL)."*
**Q2 · Mapeo de campos** — espejo columna del Sheet → atributo Brevo (Email → EMAIL, Nombre → FIRSTNAME, y los campos extra como atributos custom).
**Q3 · Aviso** — *"¿A qué número/beneficiario mando el WhatsApp de aviso de nuevo lead?"*

### Confirma
Espejo del flujo + IDs + mapeo antes de generar.

### Produce

1. Genera un **blueprint JSON válido de Make** con los módulos en orden:
   - *Google Sheets · Watch Rows* (o *Watch Responses* del Form) — schedule cada 15 min.
   - *Brevo · Create/Update a contact* — con el mapeo de la Q2 y el List ID.
   - *Send WhatsApp* (Teros/WhatsApp) — mensaje de aviso "Nuevo lead: {Nombre} · {Email}".
2. Guarda el `.json` y entrega las instrucciones de importar:
```
IMPORTAR EN MAKE
1. Make → Scenarios → Create a new scenario.
2. Menú ⋯ (arriba a la derecha) → Import blueprint → sube el .json.
3. En cada módulo, crea/elige la Connection (Google, Brevo, WhatsApp): las
   credenciales NO viajan en el JSON, se ponen aquí al importar.
4. Revisa el mapeo de campos y el List ID de Brevo.
5. Activa el scenario (toggle ON) y pulsa "Run once" para probar.
```
3. Verificación: *"Run once → los módulos se ponen verdes → el contacto aparece en la lista de Brevo y te llega el WhatsApp."*

### Itera
*"¿Añado un módulo (Hunter, un filtro por canal…)? ¿Cambio el mapeo? ¿Activamos el schedule?"*

## Reglas

- **Las credenciales NUNCA van en el JSON.** Se crean como Connection al importar. El blueprint solo lleva la estructura y el mapeo — nunca API keys.
- **Blueprint válido para "Import blueprint"** (estructura de Make: `flow` + `metadata`). Si no conoces el nombre exacto de un módulo/campo, deja el mapeo y avisa de revisarlo en la UI (no lo inventes).
- **Schedule cada 15 min** por defecto. ⚠ Recuérdale al alumno **apagar el scenario** al terminar el ejercicio (si no, sigue consumiendo ops).

## Cuándo NO usar

- Si prefieres **aprender montándolo a mano** en la UI de Make → usa `/manual-guide`.
- Si solo quieres el **diseño lógico** (sin JSON ni UI) → usa `/workflow-designer`.

## Handoff

→ Tras importar, si un módulo no cuadra en la UI, pásate a `/manual-guide` para ese paso concreto.
