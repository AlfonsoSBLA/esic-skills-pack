---
name: data-story
description: Skill conversacional que estructura findings en narrativa 5 pasos (Contexto → Hallazgo → Implicación → Recomendación → Próximo paso). Hace preguntas sobre audiencia, hallazgo principal y tono ANTES de generar.
---

# /data-story — Conversacional

## Pattern (cumple `feedback_esic-skills-conversational`)

1. **Acoge** — confirma findings
2. **Diagnose** — 3 preguntas
3. **Confirma** — espejo
4. **Produce** — narrativa 5 pasos por insight
5. **Itera** — ¿ajustamos tono?

## Flujo

### Q1 · Audiencia + foro
*"¿Para quién y dónde? (CEO 1:1 · board 30min · slack async · email)"*
→ Cambia longitud, tecnicismo y CTA

### Q2 · Hallazgo principal
*"¿Cuál es el hallazgo TOP? Si tienes varios, dime el orden de importancia."*

### Q3 · Tono
*"¿Optimista, neutro, o señal de alarma?"*
→ Las malas noticias requieren contexto que explica, no minimiza

### Produce

Para CADA insight, narrativa 5 pasos:
1. **CONTEXTO** — qué baseline importa
2. **HALLAZGO** — dato + ventana + comparativa
3. **IMPLICACIÓN** — qué significa en € o pacientes
4. **RECOMENDACIÓN** — UNA acción concreta
5. **PRÓXIMO PASO** — esta semana, con responsable

Output formato: 1 slide por insight + 1 slide cierre con próximos pasos consolidados.

### Itera

*"¿Cambio tono en alguna? ¿Añado anexo técnico? ¿Te paso esto a slides Figma?"*

## Reglas

- 5 pasos OBLIGATORIOS · si falta uno, no es story
- Implicación SIEMPRE en € o pacientes (no en %)
- Recomendación = UNA acción
- Malas noticias: jamás lenguaje de culpa

## Ejemplo HC

**Input**: insight "Meta es trampa vanidad" · audiencia CEO HC · tono neutro

**Output**:
- CONTEXTO: 12 meses gastando 41.000€/año en Meta (44% del budget)
- HALLAZGO: CR Meta 1.2% vs Google 8.7% vs Orgánico 28.5%
- IMPLICACIÓN: 41.000€ → 40 pacientes → CAC efectivo 1.000€ vs umbral 700€
- RECOMENDACIÓN: reducir Meta a 50%, reasignar 20.000€/año a Orgánico
- PRÓXIMO PASO: lunes briefing con agencia · viernes pausar 2 campañas
