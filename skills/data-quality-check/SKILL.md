---
name: data-quality-check
description: Skill conversacional que audita un dataset contra los 10 errores comunes. Hace preguntas sobre uso, período y expectativas ANTES de auditar.
---

# /data-quality-check — Conversacional

## Pattern

1. **Acoge** — confirma dataset
2. **Diagnose** — 3 preguntas
3. **Confirma** — espejo
4. **Produce** — verdict por cada uno de los 10 errores + recomendación
5. **Itera** — ¿corregimos antes de seguir?

## Flujo

### Q1 · Para qué vas a usarlo
*"¿Dashboard público · análisis interno · modelo predictivo · report board?"*
→ Nivel de exigencia varía

### Q2 · Período que importa
*"¿Todo el dataset o últimos N meses?"*

### Q3 · Qué esperas ver
*"¿Algún patrón que esperas confirmar?"* → sesgo confirmación a buscar activamente

### Produce

Tabla con los 10 errores:
| # | Error | Verdict | Detalle | Recomendación |
|---|---|---|---|---|
| 1 | Asumir datos limpios | ✅/⚠️/❌ | ... | ... |
| 2 | No normalizar | ... | ... | ... |
| 3 | Excluir outliers sin razón | ... | ... | ... |
| 4 | Incluir outliers sin etiquetar | ... | ... | ... |
| 5 | Ignorar estacionalidad | ... | ... | ... |
| 6 | Ignorar tamaño punto partida | ... | ... | ... |
| 7 | Vomitar datos | ... | ... | ... |
| 8 | Métricas que asustan sin contexto | ... | ... | ... |
| 9 | No mezclar fuentes para validar | ... | ... | ... |
| 10 | Enfocarse en ruido | ... | ... | ... |

+ Lista priorizada de qué corregir antes de seguir.

### Itera

*"¿Corregimos los críticos antes de /dashboard-builder o /info-vs-insight? ¿Te genero CSV limpio?"*

## Reglas

- Los 10 SIEMPRE evaluados
- Verdict explícito: ✅ ok · ⚠️ revisar · ❌ corregir
- Si ❌ crítico → no avanzar hasta corregir
- NUNCA inventes datos

## Ejemplo HC

**Input**: maestro.xlsx · uso "dashboard público" · últimos 12 meses · expectativa "Meta es trampa"

**Output**:
- ✅ Asumir limpios — todas las celdas pobladas
- ⚠️ Estacionalidad — Agosto cae 50% (incluirla explícita)
- ❌ Distractores — 7 columnas de vanidad (excluir antes de chartear)
- ⚠️ Punto partida — TikTok arrancó semana 20 (no comparar con canales de 104 semanas)
