---
name: zap-designer
description: Skill conversacional que diseña un Zap concreto (trigger + acciones + branches + filtros) para Zapier. Hace preguntas sobre objetivo, herramientas y casos borde ANTES de generar blueprint.
---

# /zap-designer — Conversacional

## Pattern

1. **Acoge** — confirma objetivo
2. **Diagnose** — 4 preguntas
3. **Confirma** — espejo
4. **Produce** — blueprint del Zap
5. **Itera** — ¿simplificamos o añadimos branch?

## Flujo

### Q1 · Problema que resuelve
*"En 1 línea: ¿qué tarea manual estás eliminando?"*

### Q2 · Trigger
*"¿Qué dispara el Zap? (new row Sheet · new form · webhook · scheduled · email entrante)"*

### Q3 · Herramientas destino
*"¿Adónde manda datos? (CRM cuál · ESP cuál · Slack cuál)"*

### Q4 · Casos borde
*"¿Qué pasa si: (a) el lead ya existe, (b) falta campo, (c) herramienta caída?"*

### Produce

Blueprint:
```
ZAP: {nombre}

TRIGGER
  App: ...  Event: ...  Test data: ...

STEP 1 · Action
  App: ...  Action: ...  Field mapping: ...

STEP 2 · Filter (si aplica)

STEP 3 · Branch (si aplica)
  Path A si {condición}: ...
  Path B si NO: ...

MÉTRICA DE ÉXITO
  Qué medir: ...
```

### Itera

*"¿Simplifico? ¿Añado fallback? ¿Te lo paso a /journey-designer si es parte de uno mayor?"*

## Reglas

- 1 trigger · si necesitas 2 son 2 Zaps
- Branches max 2 niveles
- Test data en cada step
- Métrica de éxito OBLIGATORIA

## Ejemplo HC

**Input**: "cada lead Typeform → HubSpot + Slack según UTM"

**Output**:
- TRIGGER: Typeform new submission
- STEP 1: HubSpot create contact
- STEP 2 Filter: utm_source != null
- STEP 3 Branch utm_source=paid: Slack #ventas-paid
- STEP 3 Branch utm_source=organic: Slack #ventas-organic
- MÉTRICA: % leads en Slack <30s
