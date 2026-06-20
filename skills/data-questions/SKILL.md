---
name: data-questions
description: Skill conversacional que convierte preguntas vagas de negocio en 3-5 preguntas acotadas con métrica + fuente. Hace preguntas sobre objetivo, contexto, decisión y horizonte ANTES de refinar.
---

# /data-questions — Conversacional

## Pattern (cumple `feedback_esic-skills-conversational`)

1. **Acoge** — confirma la pregunta vaga
2. **Diagnose** — 3 preguntas para acotar
3. **Confirma** — espejo
4. **Produce** — 3-5 preguntas refinadas + métrica + fuente
5. **Itera** — ¿priorizamos cuál atacar primero?

## Flujo

### Q1 · Decisión que buscas
*"¿Qué decisión vas a tomar con la respuesta? (presupuesto, prioridad, lanzar/cortar, contratar...)"*

### Q2 · Horizonte temporal
*"¿Cuándo necesitas decidir? (esta semana, próximo Q, antes del board...)"*

### Q3 · Restricciones / segmento
*"¿Hay algún segmento, canal o producto específico, o todo?"*

### Espejo + produce

Output: 3-5 preguntas refinadas, cada una con:
- Pregunta acotada (UNA sola respuesta posible)
- Métrica que la responde
- Fuente de datos (qué tabla, qué columnas)
- Árbol 5-por qués que llegó hasta aquí

### Itera

*"¿Cuál atacamos primero? Priorizo por impacto en tu decisión."*

## Reglas

- Pregunta acotada = tiempo + segmento + métrica
- 5-por qués mínimo, 7 máximo
- NUNCA respondas la pregunta — refínala
- Mínimo 3 preguntas refinadas

## Ejemplo HC

**Input**: *"Tenemos que conseguir más pacientes nuevos"*

**Skill**:
- Q1 → "¿decisión? (escalar canal · cortar canal · meter canal nuevo)"
- Alumno: "escalar canal"
- Q2 → "¿cuándo? (próximo mes · Q4 · 2026)"
- Alumno: "próximo mes"
- Q3 → "¿todos los canales o foco en uno? Veo Meta, Google, Orgánico, TikTok, Email, Referral en tu data"
- Alumno: "todos"

**Output** (3 preguntas refinadas):
1. *¿Qué canal tiene mayor ratio LTV/CAC en los últimos 12 meses?* (métrica: ingresos/gasto por canal, fuente: maestro.xlsx)
2. *¿Cuánto puedo aumentar gasto sin reventar CAC umbral (LTV/CAC < 3x)?* (métrica: elasticidad CAC, fuente: meses alto vs bajo spend)
3. *¿Qué canal cierra mejor lead→paciente?* (métrica: CR_cierre por canal, fuente: pacientes_cerrados / leads)
