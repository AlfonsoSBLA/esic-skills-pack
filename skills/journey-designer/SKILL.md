---
name: journey-designer
description: Skill conversacional que diseña un journey de marketing automation (welcome / onboarding / nurturing / re-engagement / win-back). Hace preguntas sobre stage, segmento y canales ANTES de diseñar.
---

# /journey-designer — Conversacional

## Pattern

1. **Acoge** — confirma stage a diseñar
2. **Diagnose** — 4 preguntas
3. **Confirma** — espejo
4. **Produce** — journey completo con triggers + branches + content + timing
5. **Itera** — ¿simplificamos pasos?

## Flujo

### Q1 · Stage del lifecycle
*"¿Qué stage diseñamos? (welcome · onboarding · nurturing · activación · re-engagement · win-back)"*

### Q2 · Segmento target
*"¿Para qué segmento? (todos · Champions · At Risk · cohorte específica)"*

### Q3 · Canales disponibles
*"¿Qué canales? (email · SMS · push · WhatsApp · llamada asesor · in-app)"*

### Q4 · Métrica de éxito
*"¿Qué tiene que pasar para decir que funcionó? (% open · % click · % conversión · % reduce churn)"*

### Produce

```
JOURNEY: {nombre} para {segmento}
Métrica éxito: ...

DAY 0 · trigger {evento}
  → Channel: email · Subject · CTA

DAY 2 · si no abrió día 0
  → Channel: SMS fallback

DAY 5 · si abrió pero no convirtió
  → Channel: email reminder

DAY 14 · sin acción
  → Mover a segmento "{otro}"
```

### Itera

*"¿Acorto journey? ¿Añado branch Champions vs At Risk? ¿Te lo paso a /workflow-designer?"*

## Reglas

- Max 5 touchpoints · más es spam
- Cada touchpoint: trigger + canal + content + timing
- Branches según comportamiento
- Fallback channel diferente al principal (email → SMS)

## Ejemplo HC

**Input**: welcome journey · segmento "New" · email+SMS · éxito = % cita en 7 días

**Output**:
- DAY 0: email "Bienvenido HC · cita gratis diagnóstico"
- DAY 2 sin open: SMS "Te interesa diagnóstico? Reserva 30s"
- DAY 5 abrió no click: email "5 testimonios reales"
- DAY 7 sin cita: WhatsApp asesor personal
- DAY 14 sin acción: → segmento "Promising"
