---
name: dashboard-judge
description: Skill conversacional que lee un dashboard (URL/screenshot) y devuelve hallazgos + hipótesis + palancas + sí/no experimento. La skill que separa al analista del CMO. Hace preguntas sobre contexto, decisión y baseline ANTES de juzgar.
---

# /dashboard-judge — Conversacional

## Pattern

1. **Acoge** — confirma dashboard (URL/screenshot)
2. **Diagnose** — 4 preguntas
3. **Confirma** — espejo
4. **Produce** — hallazgos + hipótesis + palancas + experimento sí/no
5. **Itera** — ¿priorizamos palancas? ¿diseñamos experimento?

## Flujo

### Q1 · Contexto negocio
*"En 2 líneas: ¿qué hace el negocio + qué etapa (early · scale · maduro)?"*

### Q2 · Baseline
*"¿Qué baseline importa? (YoY · benchmark sector · target interno)"*

### Q3 · Decisión sobre la mesa
*"¿Qué decisión vas a tomar? (cortar canal · escalar inversión · pivotear segmento · renegociar pricing)"*

### Q4 · Confianza disponible
*"¿Cuánta data llevas? (semanas · meses · años) y ¿hay eventos atípicos?"*

### Produce

```
DASHBOARD JUDGED · {timestamp}

HALLAZGOS (3-5)
  H1: {dato} · {comparativa baseline} · {confianza alta/media/baja}
  H2: ...

HIPÓTESIS DE CAUSA (por hallazgo)
  H1 causa probable: ... · señales que lo respaldan: ...

PALANCAS POSIBLES (3-5)
  P1 · {palanca} · esperado: ... · esfuerzo: {quick/slow}

¿NECESITAS EXPERIMENTO?
  Por palanca top 3:
    SÍ si: riesgo alto · irreversible · señal ambigua · disputa interna
    NO si: efecto obvio · low-cost reversible

PRÓXIMOS PASOS (5)
  1. {esta semana} · responsable {persona}
```

### Itera

*"¿Priorizo con /prioritize-macro-micro? ¿Diseño experimento de la top? ¿Te lo paso a /data-story?"*

## Reglas

- Hallazgos SOLO con baseline
- Confianza explícita
- Hipótesis con señales en el data, no opinión
- Palancas accionables esta semana (no 'mejorar marca')
- Experimento sí/no por palanca

## Ejemplo HC

**Input**: URL dashboard adquisición HC · scale · baseline YoY · decisión budget 2026 · 24 meses data

**Output**:
- H1: Meta CR_paciente bajó 30% YoY (alta)
- H1 hipótesis: fatiga audiencia + cambio algoritmo Q3
- P1: reducir Meta 50% + escalar Orgánico (Quick+Big) — alto retorno
- P1 experimento: NO (efecto obvio, reversible)
- P2: lanzar LinkedIn (Slow+Medium) — SÍ experimentar (nuevo, ambiguo)
- Próximos pasos: lunes pausa 2 Meta · viernes brief SEO senior
