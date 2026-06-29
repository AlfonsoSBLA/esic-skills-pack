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

## Ejemplo 1 · Hospital Capilar (one-shot)

**Input**: maximizar revenue · one-shot 3.500€ · capacidad 200 ops/mes · guardrails CAC<1000€, NPS>50

**Output**:
- NS: Pacientes nuevos cerrados / mes
- ÁRBOL: NS = Tráfico × CR_landing × CR_form × % cualif × CR_cierre
- GUARDRAILS: CAC < 1000€ · NPS > 50 · capacidad < 200/mes

## Ejemplo 2 · Xuan Lan Yoga (suscripción B2C)

**Input**: maximizar revenue · suscripción mensual/anual · sin límite operativo (digital) · guardrails LTV/CAC > 3.0 · churn M1 < 35% · NPS > 40

**Output**:
- NS: **Active Paying Users (APU) / fin de mes**
- Justificación: APU captura simultáneamente nuevos activos + retención + reactivaciones. Es el número que mueve el MRR de forma directa. Revenue se mira aparte pero APU es la palanca.
- ÁRBOL multiplicativo:
  ```
  APU_fin_mes = APU_inicio_mes
                + Nuevos_activos (= Tráfico × CR_signup_to_trial × CR_trial_to_paid)
                + Reactivados (= Cancelados_M-1 × tasa_winback)
                − Churned (= APU_inicio_mes × churn_rate_mensual)
  ```
- INPUTS clave:
  - **Tráfico**: spend × CPC_efectivo (por canal) + orgánico
  - **CR signup→trial**: fricción del onboarding (UX + onboarding emails)
  - **CR trial→paid**: valor percibido del producto en los primeros 14 días + pricing del paid
  - **Tasa winback**: efectividad de las campañas de re-engagement
  - **Churn mensual**: salud del producto + competencia + estacionalidad
- GUARDRAILS:
  - LTV/CAC > 3.0 (umbral salud unit economics)
  - Churn M1 < 35% (umbral activation OK · si peor, problema serio de onboarding)
  - NPS > 40 (proxy salud experiencia)
  - Annual share > 30% del MRR (concentración riesgo en mensual = malo)

## Diferencias clave one-shot vs suscripción

| Aspecto | One-shot (HC) | Suscripción (XLY) |
|---|---|---|
| NS típica | Clientes cerrados / mes | Active Paying Users (APU) / mes |
| Árbol | Multiplicativo simple (4-5 inputs) | Multiplicativo + términos de cohort (suma de altas, restas de churn) |
| Restricción | Operativa (capacidad médica, agentes) | Producto (engagement, churn) |
| Tiempo en NS | Por mes (corto plazo) | Por mes Y por cohort (LTV a 12-24m) |
| Guardrail crítico | CAC techo | LTV/CAC ratio mínimo |
