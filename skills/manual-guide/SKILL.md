---
name: manual-guide
description: Le dices una herramienta y qué quieres conseguir, y la skill LEE la documentación oficial (Web Fetch) y te devuelve una guía manual click a click, con los nombres reales de los botones, lo que necesitas antes de empezar, la verificación final y los errores típicos. Úsala cuando NO hay integración/MCP que lo haga por ti y tienes que montarlo tú a mano en la UI de la herramienta (Make.com, Brevo, Google Sheets, Netlify, Stripe…). Ej: "explícame cómo conectar Google Sheets a Brevo en Make paso a paso". Para diseñar la lógica del scenario (sin montarlo) usa /workflow-designer.
---

# /manual-guide — Conversacional

Convierte "quiero hacer X en [herramienta]" en una **guía manual paso a paso**, leyendo la documentación oficial en vez de inventarse la interfaz. Pensada para cuando no hay automatización/MCP y hay que montarlo a mano en la UI.

## Pattern

Acoge → Diagnose → Confirma → Produce → Itera

## Flujo

### Acoge
"¿Qué herramienta y qué quieres conseguir exactamente?"

### Diagnose (2-3 preguntas)

**Q1 · Objetivo concreto**
*"Descríbelo en una frase de resultado. Ej: en Make.com, que cada fila nueva de una Google Sheet cree o actualice un contacto en una lista de Brevo."*

**Q2 · Punto de partida**
*"¿Qué tienes ya? (cuenta creada, API keys, la Sheet/lista existentes…). Así no repito pasos que ya hiciste."*

**Q3 · Documentación (opcional)**
*"¿Tienes la URL de la doc oficial? Si no, la busco yo antes de escribir la guía."*

### Confirma
Espejo del objetivo + qué documentación voy a leer, antes de producir.

### Produce

1. **Web Fetch de la documentación oficial** de la herramienta para ESE flujo concreto (el módulo/conector exacto, no genérico).
2. Devuelve la guía con esta estructura:

```
ANTES DE EMPEZAR (requisitos)
- cuentas necesarias · dónde sacar cada API key/token · qué debe existir ya

PASO A PASO
1. [acción con el nombre REAL del botón/menú tal como sale en la UI] → resultado esperado
2. ...
   (cuando un paso pide una credencial: dónde encontrarla, literal)

VERIFICAR QUE FUNCIONA
- el test concreto que confirma que quedó bien (ej: "pulsa Run once → el módulo 2 se pone verde")

ERRORES TÍPICOS
- síntoma → causa → arreglo (2-4 de los más comunes de esta herramienta)
```

3. Cierra empujando a la acción: *"Ve haciéndolo en una pestaña y vuelve si algún paso no cuadra con lo que ves — te lo reviso."*

### Itera
*"¿Se te atascó un paso? Pégame lo que ves en pantalla (o un pantallazo) y te digo exactamente dónde estás y qué pulsar."*

## Reglas

- **Solo lo que dice la doc + la UI real.** No inventes nombres de botones ni menús. Si la doc no lo aclara: *"esto la doc no lo detalla · confírmalo en pantalla"*, no lo supongas.
- **Credenciales explícitas.** Cada vez que un paso necesite una API key/token, di exactamente dónde se saca (menú literal). Nunca pongas credenciales inventadas.
- **Nombres reales, no aproximados.** "My Apps → Add" mejor que "el sitio de conexiones".
- **Termina siempre con una verificación concreta.** Sin el test, la guía no está acabada.
- **Numerada y accionable.** Cada paso = 1 acción + resultado esperado. Nada de teoría.
- **Adapta al punto de partida (Q2):** salta lo que el alumno ya tiene hecho.

## Ejemplo · Make.com · Google Sheets → Brevo

**Objetivo**: cada fila nueva del Google Form (que cae en una Sheet) crea/actualiza un contacto en una lista de Brevo.

La skill hace Web Fetch de la doc de Make de los módulos *Google Sheets · Watch Rows* y *Brevo · Create/Update a contact*, y devuelve:
- **Antes**: cuenta Make.com (free), cuenta Brevo con lista creada + List ID + API key v3 (Brevo → Settings → SMTP & API → API keys → Generate).
- **Pasos**: Create a new scenario → *Google Sheets › Watch Rows* (crear connection, elegir spreadsheet + hoja, "table contains headers" = Yes) → *Brevo › Create/Update a contact* (connection con la API key, mapear Email/FIRSTNAME/SMS/atributos, poner el List ID, "Update enabled" = Yes) → Schedule cada 15 min.
- **Verificar**: Run once → módulo 2 en verde → el contacto aparece en la lista de Brevo.
- **Errores típicos**: 401 en Brevo (API key mala → regenera v3) · contacto duplicado ("Update enabled" en No) · no dispara (scenario en OFF o schedule sin activar).

## Cuándo NO usar esta skill

- Si solo quieres el **diseño lógico** del scenario (trigger + acciones + ramas) → usa `/workflow-designer`.
- Si el flujo ya es visible y quieres mapear un recorrido web → usa `/funnel-finder`.
