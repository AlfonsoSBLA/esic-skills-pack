---
name: rfm-segment
description: Skill conversacional que segmenta clientes con RFM (Recency, Frequency, Monetary) → 8 segmentos canónicos + acción recomendada. Hace preguntas sobre ventana, definición de compra y distribución ANTES de scoring.
---

# /rfm-segment — Conversacional

## Pattern

1. **Acoge** — confirma dataset clientes
2. **Diagnose** — 3 preguntas
3. **Confirma** — espejo
4. **Produce** — score 1-5 por eje + 8 segmentos + acción
5. **Itera** — ¿afinamos thresholds?

## Flujo

### Q1 · Ventana temporal
*"¿Recency contra qué fecha? (hoy · cierre Q · 30 días atrás)"*

### Q2 · Definición de "compra"
*"¿Qué cuenta como 'compra'? (transacción · sesión · login · uso feature key)"*
→ HC: 1 paciente = 1 intervención. SaaS: 1 mes activo

### Q3 · Distribución esperada
*"¿Esperas Pareto fuerte (20/80) o distribución plana?"* → cambia thresholds

### Produce

```
SCORING (cada cliente)
  R · score 1-5  F · score 1-5  M · score 1-5

SEGMENTOS CANÓNICOS (% del total)
  Champions (555): N% — acción: mimar, VIP
  Loyal (454): N% — acción: cross-sell, referidos
  Promising (333): N% — acción: nurturing
  New (511): N% — acción: onboarding fuerte
  Need Attention (343): N% — acción: re-engagement
  At Risk (143): N% — acción: oferta personalizada
  About to Sleep (133): N% — acción: win-back urgente
  Lost (111): N% — acción: descartar o última oferta

TOP 3 SEGMENTOS A PRIORIZAR
```

### Itera

*"¿Cambio thresholds? ¿Te paso a /journey-designer para el journey por segmento?"*

## Reglas

- 3 ejes siempre (R, F, M)
- Scores 1-5 (canon industria)
- 8 segmentos canónicos · no inventes nuevos
- Acción SIEMPRE por segmento

## Ejemplo HC

**Input**: dataset clientes · ventana hoy · compra = intervención cerrada · Pareto sí

**Output**:
- 12% Champions — mimar
- 24% Loyal — pedir referidos
- 18% Promising — nurturing
- 8% New — onboarding
- 14% Need Attention — re-engagement
- 9% At Risk — oferta
- 8% About to Sleep — win-back
- 7% Lost — descartar

TOP 3: Champions · At Risk · Promising
