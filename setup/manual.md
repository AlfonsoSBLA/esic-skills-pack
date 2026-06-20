# Setup esic-skills-pack manual (cualquier cliente)

Si tu cliente no tiene integración automática con skills (Claude.ai web, ChatGPT, Gemini, Mistral, etc.) puedes usar las skills manualmente.

## Patrón universal

Cuando quieras usar una skill:

1. Abre el archivo `skills/<nombre-skill>/SKILL.md` en tu editor
2. Copia TODO el contenido (markdown + frontmatter)
3. Pega al inicio de un nuevo chat con tu LLM favorito
4. Añade tu input específico debajo (ej. tu dataset, tu objetivo, etc.)
5. El LLM seguirá el pattern conversacional definido en el SKILL.md

## Ejemplo

```
[PEGA AQUÍ CONTENIDO DE skills/data-questions/SKILL.md]

---

INPUT DEL ALUMNO:
Mi CMO dice "tenemos que mejorar la conversión". ¿Qué pregunto?
```

El LLM responderá siguiendo el pattern: Acoge → Diagnose (4 preguntas) → Confirma → Produce → Itera.

## Tips

- **Conversación**: NO mandes todo de golpe. Espera a que el LLM te haga las 4 preguntas. Es el patrón.
- **Reuso**: una vez has cargado una skill en un chat, puedes hacer múltiples ejercicios sin recargarla (queda en contexto).
- **Calidad**: GPT-4o, Claude Sonnet 4.x, Gemini 1.5 Pro o superior. Modelos pequeños no siguen bien el pattern conversacional.

## Limitación

Sin clientes que carguen skills automáticamente pierdes:
- Invocación rápida (`/skill-name`)
- Cargar múltiples skills en mismo chat
- Memoria entre sesiones

Si esto te limita, usa Claude Code (`bash setup/claude-code.sh`) o Codex (`bash setup/codex.sh`).
