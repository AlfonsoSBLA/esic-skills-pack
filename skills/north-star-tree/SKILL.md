---
name: north-star-tree
description: Skill conversacional que devuelve north-star metric + árbol de inputs + guardrails. Hace preguntas sobre objetivo, modelo y restricciones ANTES de proponer.
---

# /north-star-tree — Conversacional

## Pattern

1. **Acoge** — confirma negocio + objetivos
2. **Diagnose** — 4 preguntas
3. **Confirma** — espejo
4. **Produce** — north-star + árbol multiplicativo + guardrails
5. **Itera** — ¿ajustamos guardrails?

## Flujo

### Q1 · ¿Qué quieres maximizar?
*"En 1 frase: ¿qué tiene que crecer? (revenue · pacientes · usage · retention)"*

### Q2 · Cómo cobras
*"¿Modelo? (one-shot · suscripción · marketplace · ads)"*

### Q3 · Restricciones
*"¿Límites? (operativa máxima · capacidad equipo · regulación)"*

### Q4 · Qué NO puedes romper
*"¿Guardrails? (CAC techo · churn techo · NPS suelo · % refunds)"*

### Produce

```
NORTH STAR: {métrica}
Justificación: ...

ÁRBOL INPUTS (multiplicativo)
NS = Input1 × Input2 × Input3 × Input4

INPUT 1: {nombre}
  Fuentes: ...  Lever: ...
INPUT 2: ...

GUARDRAILS
- {guardrail 1}: umbral X
- {guardrail 2}: umbral Y
```

### Itera

*"¿Cambio north-star? ¿Añado guardrail? ¿Te paso a /dashboard-builder?"*

## Reglas

- 1 sola north-star · si tienes 2 → no entiendes el negocio
- Inputs multiplicativos
- Min 2 guardrails (uno calidad, uno eficiencia)
- Tiempo explícito en NS (por mes, etc.)

## Ejemplo HC

**Input**: maximizar revenue · one-shot 3.500€ · capacidad 200 ops/mes · guardrails CAC<1000€, NPS>50

**Output**:
- NS: Pacientes nuevos cerrados / mes
- ÁRBOL: NS = Tráfico × CR_landing × CR_form × % cualif × CR_cierre
- GUARDRAILS: CAC < 1000€ · NPS > 50 · capacidad < 200/mes
