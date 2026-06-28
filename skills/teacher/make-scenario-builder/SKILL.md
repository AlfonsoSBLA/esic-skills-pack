---
name: make-scenario-builder
description: Skill que genera un blueprint JSON de Make.com (importable vía Make → Scenarios → ··· → Import blueprint) para automatizar un pipeline simple. Default = "Sheets new row → Brevo create/update contact" (la automation de la demo HC). Output = `.json` listo para importar + instrucciones paso a paso de cómo conectar las cuentas y activar el scenario. Mucho más demostrable en clase que arrastrar módulos en la UI Make.
---

# /make-scenario-builder — Conversacional

## Cuándo aplica

Tras `/landing-deploy` (pieza 4 del stack acquisition). O cualquier momento en que necesites materializar una automation Make sin clicks manuales en la UI.

## Pre-requisito

- Cuenta Make.com (free tier 1.000 ops/mes, suficiente para demo y alumnos)
- Cuenta destino (Brevo / WhatsApp / Slack / etc.) con API key disponible

## Pattern

1. **Acoge** — qué automation (default: Sheets → Brevo)
2. **Diagnose** — 3 preguntas
3. **Confirma** — espejo
4. **Produce** — `.json` blueprint + instrucciones import + activación
5. **Itera** — ¿añado módulo · cambio filter · activamos schedule?

## Catálogo de automations soportadas

| Automation | Trigger | Acción(es) | Ops/run | Estado |
|---|---|---|---|---|
| **Sheets → Brevo** *(default)* | Google Sheets · Watch new rows | Brevo · Create/update contact + add to list | 2 | template completo en esta skill |
| Sheets → WhatsApp Teros | Sheets · Watch | Teros · Send WhatsApp message | 2 | pendiente template |
| Sheets → Hunter → Brevo | Sheets · Watch | Hunter · Verify + Brevo · Add | 3-4 | pendiente template |
| Sheets → router por canal → Brevo | Sheets · Watch | Router por `canal_origen` → Brevo distintas listas | 3-5 | pendiente template |

## Flujo

### Acoge

*"¿Qué automation? Default = Sheets → Brevo (la del demo HC: lead nuevo en Sheet → contacto nuevo en lista Brevo). ¿O alguna del catálogo (WhatsApp · Hunter · Router)?"*

### Q1 · IDs concretos

*"Para Sheets → Brevo necesito 3 cosas:*
- *URL del Sheet (de /form-builder) — sacaré el ID interno*
- *List ID de Brevo (numérico, ej `7`) — Brevo → Contacts → Lists → click en la lista → ID en URL*
- *API key de Brevo v3 (NO se guarda en el blueprint, va en Connection Make) — Brevo → Settings → SMTP & API → API keys → Generate"*

### Q2 · Mapeo de campos

Tabla espejo:

| Sheet column | Brevo attribute | Notas |
|---|---|---|
| Email | EMAIL | clave del contacto |
| Nombre y apellido | FIRSTNAME | nativo Brevo |
| Teléfono | SMS | nativo Brevo |
| Tratamiento | TRATAMIENTO | custom · crear en Brevo si no existe |
| Ciudad | CIUDAD | custom |
| Origen | ORIGEN | custom |

### Q3 · Schedule

*"¿Cada cuánto escanea el Sheet? Default = 15 min (mínimo en free tier). En clase para demo puedes ejecutar 'Run once' manual."*

### Produce

**Template del blueprint** (Sheets → Brevo · sustituir los 3 `REEMPLAZA_POR_...` antes de importar):

```json
{
  "name": "{{CLIENTE_NOMBRE}} · Sheets to Brevo",
  "flow": [
    {
      "id": 1,
      "module": "google-sheets:watchRows",
      "version": 4,
      "parameters": {
        "__IMTCONN__": "REEMPLAZA_POR_TU_GOOGLE_SHEETS_CONNECTION",
        "mode": "select",
        "spreadsheetId": "REEMPLAZA_POR_TU_SHEET_ID",
        "sheetId": "Respuestas de formulario 1",
        "includesHeaders": true,
        "limit": 10
      },
      "mapper": {},
      "metadata": { "designer": { "x": 0, "y": 0 } }
    },
    {
      "id": 2,
      "module": "sendinblue:createOrUpdateContact",
      "version": 1,
      "parameters": { "__IMTCONN__": "REEMPLAZA_POR_TU_BREVO_CONNECTION" },
      "mapper": {
        "email": "{{1.`Email`}}",
        "attributes": {
          "FIRSTNAME": "{{1.`Nombre y apellido`}}",
          "SMS": "{{1.`Teléfono`}}",
          "TRATAMIENTO": "{{1.`¿Qué tratamiento te interesa?`}}",
          "CIUDAD": "{{1.`¿Desde qué ciudad escribes?`}}",
          "ORIGEN": "{{1.`¿Cómo nos conociste?`}}"
        },
        "listIds": ["REEMPLAZA_POR_LIST_ID_BREVO"],
        "updateEnabled": true
      },
      "metadata": { "designer": { "x": 300, "y": 0 } }
    }
  ],
  "metadata": {
    "instant": false,
    "version": 1,
    "scenario": {
      "roundtrips": 1,
      "maxErrors": 3,
      "autoCommit": true,
      "autoCommitTriggerLast": true,
      "sequential": false,
      "confidential": false,
      "dataloss": false,
      "dlq": false
    },
    "zone": "eu1.make.com"
  },
  "schedule": { "type": "interval", "interval": 900 }
}
```

**Instrucciones de import** (al user en respuesta):

```
Antes de importar (5 min en Brevo):
1. Crea lista "[Cliente] · Solicitudes valoración". Apunta List ID numérico.
2. Crea atributos custom TRATAMIENTO, CIUDAD, ORIGEN (Text) si no existen.
3. Genera API key v3 (Settings → SMTP & API).

Antes de importar (3 min en Make.com):
4. Sign up free en make.com.
5. My Apps → + Add → Google Sheets (autoriza) + Brevo (pega API key v3).

Importar (2 min):
6. Scenarios → + Create new → ··· → Import blueprint → selecciona scenario.json
7. En cada módulo edita Connection y elige las creadas en paso 5
8. Módulo 1: spreadsheet → selecciona "[Cliente] · Solicitudes valoración"
9. Módulo 2: Lists IDs → escribe el List ID numérico del paso 1
10. Run once → debería ir verde → contacto aparece en Brevo
11. Schedule → Every 15 minutes → Toggle ON
```

### Itera

*"¿Añadimos un 3er módulo (WhatsApp · Slack · Sheet enriched · etc.)? ¿Cambio filter (solo emails @gmail.com)? ¿Te paso a verificación E2E?"*

## Reglas

- API keys / credentials NUNCA en el blueprint JSON · siempre placeholders o referencias a Connection que el alumno configura en Make UI
- Schedule default = 15 min (free tier limit) · NO inventar "real-time" que no funciona en free
- Module mapping = explícito · NUNCA dejar campos en blanco que Make rellenaría con error
- El alumno debe crear las connections ANTES de importar el blueprint · sino el import falla
- Custom attributes (TRATAMIENTO · CIUDAD · ORIGEN) deben existir en Brevo ANTES del primer run · sino la creación de contacto falla
- "Update enabled" = Yes en Brevo module por defecto · evita duplicados si vuelve el mismo email

## Output

2 piezas:
1. `scenario-blueprint.json` (importable directo en Make)
2. Instrucciones paso a paso (en respuesta al user)

## Ejemplo HC (canónico)

**Input**:
- Automation: Sheets → Brevo (default)
- Sheet URL: la que dio /form-builder
- Brevo List ID: `7`
- API key Brevo: gestionada en Connection Make, NO en blueprint
- Schedule: 15 min

**Output**: `scenario-blueprint.json` (~3 KB) con 2 módulos cableados + instrucciones import (~30 líneas).

**Tras importar en Make** el alumno obtiene:
- Scenario `HC · Sheets to Brevo` activo
- Schedule cada 15 min
- Test E2E: form submission → Sheet → Brevo en ≤15 min

## Handoff típico

→ Tras Make scenario activo, el demo HC completo está vivo. Verifica E2E (rellenar form en URL Netlify, ver contacto en Brevo).
→ Para añadir WhatsApp por encima: re-invocar la skill con automation `Sheets → WhatsApp Teros`.

## Ver también

- Skill orquestadora: `/hc-demo-build`
- Skill anterior: `/landing-deploy`
