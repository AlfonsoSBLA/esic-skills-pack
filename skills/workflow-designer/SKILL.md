---
name: workflow-designer
description: Skill conversacional que DISEÑA la lógica de tu automatización (disparador + acciones + mapeo de campos + métrica de éxito) de forma agnóstica de herramienta, y luego te SUGIERE cómo ejecutarla: con Teros directamente (una tarea recurrente que corre Iria) o montándola en Make.com (por JSON con /make-scenario-builder, o a mano con /manual-guide). Úsala en S3 tras crear el Form y la landing, para definir y poner en marcha la automatización que mete el lead en Brevo y te avisa por WhatsApp.
---

# /workflow-designer — Conversacional

Diseña **la lógica** de tu automatización y te ayuda a **ponerla en marcha**. No te ata a una herramienta: primero define QUÉ hace (disparador → acciones), y luego eliges CÓMO ejecutarla — **Teros directo** o **Make**.

## Pattern

Acoge → Diagnose → Confirma → Produce (el diseño) → Elige cómo ejecutarla → Itera

## Flujo

### Acoge
*"¿Qué quieres automatizar? En S3: cada nueva respuesta de tu Google Form → contacto en Brevo + aviso por WhatsApp. ¿Ya tienes el Form creado y una lista de Brevo con su List ID?"*

### Diagnose (3-4 preguntas)
**Q1 · Disparador** — *"¿Qué la dispara? (una nueva respuesta del Form / una nueva fila en la hoja de respuestas / cada N minutos)."*
**Q2 · Acciones en orden** — *"¿Qué pasa con cada lead? (crear/actualizar contacto en Brevo · enviar email de bienvenida · avisarte por WhatsApp · …)."*
**Q3 · Datos** — *"¿Qué campo del Form va a qué? (Email → EMAIL, Nombre → FIRSTNAME…). ¿En qué lista de Brevo? (necesitas el List ID)."*
**Q4 · Éxito** — *"¿Cómo sabes que funciona? (llega el WhatsApp + el contacto aparece en la lista)."*

### Confirma
Espejo del diseño (disparador + pasos + mapeo + lista) antes de producir.

### Produce · el diseño (agnóstico de herramienta)
```
AUTOMATIZACIÓN: {nombre}
Disparador: {p. ej. nueva respuesta en el Google Form}
Paso 1: crear/actualizar contacto en Brevo · lista {List ID} · Email→EMAIL, Nombre→FIRSTNAME
Paso 2: enviar email de bienvenida
Paso 3: WhatsApp → "Nuevo lead: {Nombre} · {Email}"
Métrica de éxito: llega el WhatsApp y el contacto está en la lista
Ojo (idempotencia): "crear/actualizar" (no solo "crear") evita contactos duplicados
```

### Elige cómo ejecutarla (esto es lo importante)
La MISMA automatización, dos caminos — preséntalos siempre así:

**A) Con Teros directamente — camino principal (recomendado para clase).**
Iria la monta como **tarea recurrente**: cada 15 min revisa el Form y, por cada respuesta nueva, hace los pasos. Simple y sin salir de Teros.
> 🔑 **Para no repetir leads** entre ejecuciones, usa una columna **"Procesado"** en la hoja de respuestas: actúa solo sobre las filas que NO estén marcadas y márcalas al terminar. Sin esto, el cron reprocesa TODAS las filas cada 15 min (duplicados + spam).
> ⚠ Es un cron: recuérdale **apagarlo al terminar** (si no, sigue ejecutándose y gastando agente).

**B) Con Make.com — bonus (+5).** *(Iria no monta Make por MCP — la conexión no va; el scenario lo montas tú.)* Dos maneras:
- **Rápida (por JSON)** → `/make-scenario-builder` genera el blueprint y lo importas en Make.
- **A mano (aprendes más)** → `/manual-guide` te da el paso a paso click a click en la UI de Make.

Cierra preguntando: *"¿Cómo lo montamos: Teros directo o Make?"*

### Itera
*"¿Añado un paso (email de seguimiento, aviso si no abre en 2h)? ¿Cambio el mapeo? ¿Lo ponemos en marcha ya?"*

## Reglas

- **Agnóstico primero, herramienta después.** Define la lógica antes de elegir Teros o Make.
- **Ofrece SIEMPRE las dos vías** (Teros directo · Make) y recomienda **Teros** para clase.
- **Prerrequisito Brevo**: la automatización necesita una **lista de contactos ya creada** en Brevo (con su List ID). Crear la lista es **manual** — si no existe, dilo y manda a crearla (Brevo → Contactos → Listas → Crear; el List ID sale en la URL de la lista · `/manual-guide` si se atasca).
- **Mapeo de campos explícito** (qué campo del Form va a qué atributo de Brevo).
- **Idempotencia**: usa "crear/actualizar" para no duplicar contactos.
- **Métrica de éxito obligatoria**: si no se comprueba, no está hecho.
- **Avisa del cron**: si se ejecuta con Teros como tarea recurrente, recuérdale apagarlo al acabar.

## Ejemplo · Xuan Lan Yoga (S3)

**Diseño**:
```
Disparador: nueva respuesta del Google Form
Paso 1: Brevo crear/actualizar contacto (Email→EMAIL, Nombre→FIRSTNAME) en la lista "XLY Leads" (List ID 7)
Paso 2: email de bienvenida
Paso 3: WhatsApp "Nuevo lead: {Nombre} · {Email}"
Éxito: el WhatsApp llega y el contacto está en "XLY Leads"
```
**Ejecución**: Teros directo (tarea recurrente cada 15 min) · o Make (por JSON con `/make-scenario-builder`).

## Handoff

- **Teros directo** → pídeselo a Iria (tarea recurrente); acuérdate de apagarla.
- **Make por JSON** → `/make-scenario-builder`. · **Make a mano** → `/manual-guide`.
- Para descubrir el funnel antes de diseñar → `/funnel-finder`.
