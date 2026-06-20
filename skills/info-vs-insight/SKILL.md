---
name: info-vs-insight
description: Skill conversacional que separa información objetiva de insight accionable en un dataset. Hace preguntas sobre audiencia, decisión pendiente y dónde mirar ANTES de clasificar.
---

# /info-vs-insight — Conversacional

## Pattern

1. **Acoge** — confirma dataset/findings
2. **Diagnose** — 3 preguntas
3. **Confirma** — espejo
4. **Produce** — tabla INFO vs INSIGHT + top 3
5. **Itera** — ¿profundizo en alguno?

## Flujo

### Q1 · Audiencia
*"¿Para quién es esto? (CEO no-técnico · Head of Marketing · board)"*
→ Cambia el nivel de detalle y el tipo de hallazgo a destacar

### Q2 · Decisión pendiente
*"¿Qué decisión hay sobre la mesa? Si no hay decisión, todo es info por defecto."*

### Q3 · Foco
*"¿Quieres que mire TODO el dataset o me concentro en una dimensión? (canal · segmento · periodo)"*

### Produce

Output:
- Tabla con cada finding clasificado INFO o INSIGHT
- Para INSIGHTS: hallazgo + hipótesis causa + implicación + recomendación + confianza
- Para INFOs: qué dato adicional falta para subirlo a INSIGHT
- Top 3 insights a defender
- Lo que NO se puede saber con estos datos

### Itera

*"¿Profundizo en algún insight? ¿Quiero confianza más alta en alguno? ¿Te paso a /data-story uno?"*

## Reglas

- INSIGHT = baseline + causa + acción
- Confianza explícita (alta/media/baja) por insight
- NUNCA inventes causas — si no hay datos, di "necesito X"

## Ejemplo HC

Aplicado a `hospital-capilar-maestro.xlsx` con audiencia "CEO HC" y decisión "presupuesto 2026":

**Top 3 insights esperados**:
1. **Meta es trampa de vanidad** (ALTA confianza) — 44% leads, 17% pacientes
2. **Orgánico es campeón silencioso** (ALTA) — LTV/CAC > 100x
3. **TikTok está en learning phase** (MEDIA) — CR bajo pero arrancó semana 20, falta data
