---
name: rfm-scenario-builder
description: Skill que genera un blueprint JSON de Make.com (importable vía Make → Scenarios → ··· → Import blueprint) para un pipeline RFM end-to-end. Default = "Sheet con leads + last_visit + n_visits + ltv → scoring R/F/M 1-5 → clasificación segmento canónico → Router 4 ramas → Brevo (lista por segmento) + opcional WhatsApp alert si Champion". Output = `.json` listo para importar + instrucciones paso a paso. Extiende lo que /make-scenario-builder hace para acquisition al caso de retención.
---

# /rfm-scenario-builder — Conversacional

## Cuándo aplica

Tras `/rfm-segment` (cuando ya tienes un dataset RFM en Sheet) o tras `/journey-designer` (cuando ya has decidido qué tres-cuatro journeys de retención disparar). Es el equivalente "retención" de `/make-scenario-builder`.

## Pre-requisitos

- Cuenta Make.com (free tier 1.000 ops/mes · ojo: este scenario consume ~7 ops/lead, ver sección Coste abajo)
- Cuenta Brevo (free tier 300 emails/día) con conexión configurada en Make (la misma de `/make-scenario-builder` si ya hiciste S3)
- Sheet ya en formato canónico RFM: columnas `email`, `nombre`, `last_visit`, `n_visits`, `ltv` (mínimo · puede tener más)
- Opcional: endpoint Teros (o cualquier gateway WhatsApp) con auth Bearer para la rama Champion

## Pattern

1. **Acoge** — confirma escenario (default: RFM scoring + 4 ramas Brevo + WhatsApp Champion)
2. **Diagnose** — 3-4 preguntas
3. **Confirma** — espejo
4. **Produce** — `.json` blueprint + instrucciones import + activación
5. **Itera** — ¿añadimos rama Loyal · ajustamos schedule · enchufamos Slack en vez de WhatsApp?

## Lo que genera la skill

Un scenario Make con **8 módulos + 1 Router de 4 ramas**:

```
[1] Google Sheets · Watch new rows (pestaña leads_with_rfm)
  │
  ├─ [2] SetVariable R_score  (días desde last_visit · 5/4/3/2/1)
  ├─ [3] SetVariable F_score  (n_visits · 5/4/3/2/1)
  ├─ [4] SetVariable M_score  (ltv en € · 5/4/3/2/1)
  │
  ├─ [5] SetVariable RFM_SEGMENT (if encadenado · 6 buckets simplificados)
  │
  ├─ [6] Brevo Update Contact (R, F, M, RFM_SCORE, RFM_SEGMENT, LAST_VISIT, LTV, N_VISITS)
  │
  └─ [7] Router · 4 ramas
       ├─ Champion  → [8] Brevo Add to list HC·Champion + [9] HTTP WhatsApp Teros
       ├─ At Risk   → [10] Brevo Add to list HC·At Risk
       ├─ Hibernating → [11] Brevo Update Contact pause_emails=true (sin lista)
       └─ Lost      → [12] Brevo Add to list HC·Lost
```

Schedule recomendado: `Every 1 day` (interval 86400) en free tier.

## Flujo

### Acoge

*"¿Construimos el scenario RFM clásico? Default: Sheet → scoring R/F/M → Router 4 ramas (Champion · At Risk · Hibernating · Lost) → Brevo lista + WhatsApp si Champion. ¿O variante (solo email · sin WhatsApp · más ramas · Slack en vez de WhatsApp)?"*

### Q1 · IDs concretos

*"Para conectar todo necesito 5 cosas:*
- *URL del Sheet con la pestaña RFM (ej `leads_with_rfm`) — sacaré el ID*
- *4 List IDs de Brevo (Champion · At Risk · Hibernating · Lost) — Brevo → Contacts → Lists*
- *Si quieres rama WhatsApp Champion: endpoint POST + token Bearer + tu móvil E.164*
- *API key Brevo v3 — NO va al blueprint, va en la Connection que configuras en Make UI*
- *Que los 8 atributos custom existan en Brevo: R, F, M, RFM_SCORE, RFM_SEGMENT, LAST_VISIT, LTV, N_VISITS"*

### Q2 · Thresholds de scoring

*"Defaults canónicos (industria · suelen funcionar):*
- *R: <30d=5, <60d=4, <90d=3, <180d=2, else 1*
- *F: ≥6=5, ≥4=4, ≥3=3, ≥2=2, else 1*
- *M: ≥3000=5, ≥2000=4, ≥1000=3, ≥500=2, else 1*

*¿Los cambias? Tip: si tu negocio es alta frecuencia (e-commerce semanal), F necesita umbrales más altos."*

### Q3 · Schedule

*"¿Cada cuánto corre el scanner del Sheet? Default = 1 día (86400 seg). En clase para demo puedes ejecutar Run once manual. En free tier (~7 ops/lead × N leads), 1 vez/día con 50 leads = ~10k ops/mes que NO cabe → opciones: bajar a 1×/semana, limitar Limit a 10, o upgrade Make Core $9."*

### Q4 · ¿Rama WhatsApp Champion?

*"Tres opciones:*
1. *Sí · WhatsApp Teros (endpoint que confirme Pablo durante el curso)*
2. *Sí · pero con otro canal (Slack webhook, Telegram bot, email a ti mismo)*
3. *No · solo email vía Brevo (más sencillo, free tier siempre)*

*Si Champion = revenue alto · merece touch humano · recomiendo opción 1 ó 2."*

### Produce

**Template completo del blueprint** (sustituir los 7 `REEMPLAZA_POR_*` desde la UI de Make antes del primer run):

```json
{
  "name": "{{CLIENTE_NOMBRE}} · RFM classifier",
  "flow": [
    {
      "id": 1,
      "module": "google-sheets:watchRows",
      "version": 4,
      "parameters": {
        "__IMTCONN__": "REEMPLAZA_POR_TU_GOOGLE_SHEETS_CONNECTION",
        "mode": "select",
        "spreadsheetId": "REEMPLAZA_POR_TU_SHEET_ID",
        "sheetId": "leads_with_rfm",
        "includesHeaders": true,
        "limit": 50,
        "valueRenderOption": "UNFORMATTED_VALUE",
        "dateTimeRenderOption": "FORMATTED_STRING"
      },
      "mapper": {},
      "metadata": { "designer": { "x": 0, "y": 0 } }
    },
    {
      "id": 2,
      "module": "util:SetVariable",
      "version": 1,
      "mapper": {
        "name": "R_score",
        "scope": "roundtrip",
        "value": "{{if(formatNumber(dateDifference(now; parseDate(1.last_visit; \"YYYY-MM-DD\"); \"days\"); 0; \".\"; \"\") < 30; 5; if(formatNumber(dateDifference(now; parseDate(1.last_visit; \"YYYY-MM-DD\"); \"days\"); 0; \".\"; \"\") < 60; 4; if(formatNumber(dateDifference(now; parseDate(1.last_visit; \"YYYY-MM-DD\"); \"days\"); 0; \".\"; \"\") < 90; 3; if(formatNumber(dateDifference(now; parseDate(1.last_visit; \"YYYY-MM-DD\"); \"days\"); 0; \".\"; \"\") < 180; 2; 1))))}}"
      },
      "metadata": { "designer": { "x": 300, "y": 0 } }
    },
    {
      "id": 3,
      "module": "util:SetVariable",
      "version": 1,
      "mapper": {
        "name": "F_score",
        "scope": "roundtrip",
        "value": "{{if(1.n_visits >= 6; 5; if(1.n_visits >= 4; 4; if(1.n_visits >= 3; 3; if(1.n_visits >= 2; 2; 1))))}}"
      },
      "metadata": { "designer": { "x": 600, "y": 0 } }
    },
    {
      "id": 4,
      "module": "util:SetVariable",
      "version": 1,
      "mapper": {
        "name": "M_score",
        "scope": "roundtrip",
        "value": "{{if(1.ltv >= 3000; 5; if(1.ltv >= 2000; 4; if(1.ltv >= 1000; 3; if(1.ltv >= 500; 2; 1))))}}"
      },
      "metadata": { "designer": { "x": 900, "y": 0 } }
    },
    {
      "id": 5,
      "module": "util:SetVariable",
      "version": 1,
      "mapper": {
        "name": "RFM_SEGMENT",
        "scope": "roundtrip",
        "value": "{{if(2.R_score >= 4 and 3.F_score >= 4 and 4.M_score >= 4; \"Champion\"; if(2.R_score >= 4 and 3.F_score >= 3; \"Loyal\"; if(2.R_score >= 3 and 3.F_score >= 3; \"Need Attention\"; if(2.R_score <= 2 and 3.F_score >= 4 and 4.M_score >= 4; \"At Risk\"; if(2.R_score <= 2; \"Hibernating\"; \"Lost\")))))}}"
      },
      "metadata": { "designer": { "x": 1200, "y": 0 } }
    },
    {
      "id": 6,
      "module": "sendinblue:updateContact",
      "version": 1,
      "parameters": { "__IMTCONN__": "REEMPLAZA_POR_TU_BREVO_CONNECTION" },
      "mapper": {
        "email": "{{1.email}}",
        "attributes": {
          "FIRSTNAME": "{{1.nombre}}",
          "R": "{{2.R_score}}",
          "F": "{{3.F_score}}",
          "M": "{{4.M_score}}",
          "RFM_SCORE": "{{2.R_score}}{{3.F_score}}{{4.M_score}}",
          "RFM_SEGMENT": "{{5.RFM_SEGMENT}}",
          "LAST_VISIT": "{{1.last_visit}}",
          "LTV": "{{1.ltv}}",
          "N_VISITS": "{{1.n_visits}}"
        }
      },
      "metadata": { "designer": { "x": 1500, "y": 0 } }
    },
    {
      "id": 7,
      "module": "builtin:BasicRouter",
      "version": 1,
      "metadata": { "designer": { "x": 1800, "y": 0 } },
      "routes": [
        {
          "flow": [
            {
              "id": 8,
              "module": "sendinblue:addContactToList",
              "version": 1,
              "parameters": { "__IMTCONN__": "REEMPLAZA_POR_TU_BREVO_CONNECTION" },
              "filter": {
                "name": "Champion",
                "conditions": [[{ "a": "{{5.RFM_SEGMENT}}", "o": "text:equal", "b": "Champion" }]]
              },
              "mapper": { "listId": "REEMPLAZA_POR_LIST_ID_CHAMPION", "emails": ["{{1.email}}"] }
            },
            {
              "id": 9,
              "module": "http:ActionSendData",
              "version": 3,
              "mapper": {
                "url": "https://api.teros.run/whatsapp/send",
                "method": "post",
                "headers": [
                  { "name": "Authorization", "value": "Bearer REEMPLAZA_POR_TEROS_TOKEN" },
                  { "name": "Content-Type", "value": "application/json" }
                ],
                "bodyType": "raw",
                "contentType": "application/json",
                "data": "{\"to\":\"REEMPLAZA_POR_MOVIL_E164\",\"message\":\"🏆 Champion detectado · {{1.nombre}} · LTV {{1.ltv}}€ · {{1.n_visits}} visitas · regalo VIP recomendado\"}",
                "parseResponse": true
              }
            }
          ]
        },
        {
          "flow": [
            {
              "id": 10,
              "module": "sendinblue:addContactToList",
              "version": 1,
              "parameters": { "__IMTCONN__": "REEMPLAZA_POR_TU_BREVO_CONNECTION" },
              "filter": {
                "name": "At Risk",
                "conditions": [[{ "a": "{{5.RFM_SEGMENT}}", "o": "text:equal", "b": "At Risk" }]]
              },
              "mapper": { "listId": "REEMPLAZA_POR_LIST_ID_AT_RISK", "emails": ["{{1.email}}"] }
            }
          ]
        },
        {
          "flow": [
            {
              "id": 11,
              "module": "sendinblue:updateContact",
              "version": 1,
              "parameters": { "__IMTCONN__": "REEMPLAZA_POR_TU_BREVO_CONNECTION" },
              "filter": {
                "name": "Hibernating",
                "conditions": [[{ "a": "{{5.RFM_SEGMENT}}", "o": "text:equal", "b": "Hibernating" }]]
              },
              "mapper": { "email": "{{1.email}}", "attributes": { "pause_emails": "true" } }
            }
          ]
        },
        {
          "flow": [
            {
              "id": 12,
              "module": "sendinblue:addContactToList",
              "version": 1,
              "parameters": { "__IMTCONN__": "REEMPLAZA_POR_TU_BREVO_CONNECTION" },
              "filter": {
                "name": "Lost",
                "conditions": [[{ "a": "{{5.RFM_SEGMENT}}", "o": "text:equal", "b": "Lost" }]]
              },
              "mapper": { "listId": "REEMPLAZA_POR_LIST_ID_LOST", "emails": ["{{1.email}}"] }
            }
          ]
        }
      ]
    }
  ],
  "metadata": {
    "instant": false,
    "version": 1,
    "scenario": {
      "roundtrips": 1, "maxErrors": 3, "autoCommit": true, "autoCommitTriggerLast": true,
      "sequential": false, "confidential": false, "dataloss": false, "dlq": false, "freshVariables": false
    },
    "zone": "eu1.make.com"
  },
  "schedule": { "type": "interval", "interval": 86400 }
}
```

**Instrucciones de import** (al user en respuesta):

```
Antes de importar (15 min en Brevo):
1. Crea 4 listas: Cliente·Champion, ·At Risk, ·Hibernating, ·Lost. Apunta List IDs.
2. Crea 8 atributos custom: R, F, M (Number) · RFM_SCORE, RFM_SEGMENT (Text) · LAST_VISIT (Date) · LTV, N_VISITS (Number).
3. Reutiliza API key v3 + connection Make ya existente (si hiciste /make-scenario-builder).

Antes de importar (5 min en Sheet):
4. Crea pestaña nueva 'leads_with_rfm' en el Sheet ya existente.
5. Pega tu CSV RFM (columnas: email, nombre, last_visit, n_visits, ltv + opcionales).
6. Apunta el GID de la pestaña (URL #gid=XXX).

Antes de importar (opcional · WhatsApp Champion):
7. Pide a tu proveedor (Teros/Twilio/etc) endpoint POST + token Bearer.
8. Apunta tu móvil en E.164 (+34XXXXXXXXX).

Importar (3 min):
9. Make → Scenarios → + Create new → ··· → Import blueprint
10. Reemplaza los 7 placeholders REEMPLAZA_POR_* en cada módulo (UI de Make)
11. Run once con la primera fila test
12. Verifica Inspector: 50 contactos actualizados · cada uno enrutado a su rama
13. Schedule → Every 1 day · Toggle ON
```

### Itera

*"¿Cambio thresholds (RFM más estrictos)? ¿Añado rama Loyal (5ª ruta)? ¿Cambio WhatsApp por Slack/Telegram? ¿Bajo schedule a 1×/semana para caber en free tier?"*

## Reglas

- API keys / tokens NUNCA en el blueprint JSON · siempre placeholders REEMPLAZA_POR_*
- Schedule default = 24h · NO inventar real-time (el free tier no lo soporta y el caso de uso retención no lo necesita)
- Los 8 atributos custom Brevo DEBEN existir antes del primer run · sino el módulo `Update Contact` da 400
- Las 4 listas Brevo DEBEN existir antes del primer run · sino los módulos `Add to list` dan 404
- Router con filters case-sensitive · usar mayúscula inicial estricta: `Champion`, `At Risk`, `Hibernating`, `Lost`
- Si el cliente no quiere WhatsApp, dejar el módulo 9 deshabilitado (click derecho → Disable) en vez de borrarlo · así sigue editable si cambia de idea

## Output

2 piezas:
1. `rfm-scenario-blueprint.json` (importable directo)
2. `IMPORT-INSTRUCTIONS.md` paso a paso (modelo: el de `/make-scenario-builder`)

## Ejemplos

### Ejemplo HC (canónico de la demo S4)

**Input**:
- Sheet: `HC · Solicitudes valoración` · pestaña `leads_with_rfm` (50 leads sintéticos)
- 4 Brevo lists: HC · Champion / At Risk / Hibernating / Lost
- WhatsApp Teros: sí (URL placeholder hasta que Pablo confirme)
- Schedule: 24h

**Output**: blueprint ~8 KB + instrucciones ~80 líneas. Tras importar, scenario `HC · RFM classifier` activo · cada noche reclasifica los leads del Sheet · Champions reciben email VIP + WhatsApp a Alfonso.

### Ejemplo XLY (Xuan Lan Yoga · ángulo retención del alumno)

**Input**:
- Sheet: Income Report ya enriquecido con RFM (cada fila = transacción agregada por email)
- 4 Brevo lists: XLY · Yogi Champion / At Risk / Hibernating / Lost
- WhatsApp: no (el alumno va por email-only en demo)
- Schedule: 24h

**Output**: mismo blueprint con nombres adaptados y módulo 9 (HTTP) **disabled**. El alumno enseña que la maquinaria es la misma · el contenido del journey (los emails) es lo que adapta al ángulo. Mismo patrón, otro caso.

## Handoff típico

→ Tras importar y activar, el alumno tiene el motor RFM corriendo. Siguiente paso natural: `/journey-templates` para generar los 3-4 emails HTML que Brevo va a enviar por segmento (Champion / At Risk / Lost).
→ Si el alumno aún no tiene dataset RFM, regresar a `/rfm-segment` primero.

## Ver también

- `/rfm-segment` (genera el dataset y el scoring inicial)
- `/journey-designer` (diseña el lifecycle de cada segmento ANTES de hacer los emails)
- `/journey-templates` (genera los HTML emails que este scenario dispara vía Brevo)
- `/make-scenario-builder` (hermano · escenario acquisition más simple)
