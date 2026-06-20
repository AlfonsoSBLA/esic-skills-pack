# Setup esic-skills-pack para Cursor

Cursor no tiene un sistema nativo de "skills" como Claude Code, pero puedes usar las 14 skills de este repo de 2 formas:

## Opción 1 · Composer Notepads (recomendado)

1. En Cursor, abre Composer (⌘I)
2. Haz click en el icono `+` → "New Notepad"
3. Pega el contenido completo de `skills/<nombre-skill>/SKILL.md`
4. Guarda con el nombre de la skill (ej. `data-questions`)
5. Cuando quieras invocarla en Composer, escribe `@data-questions` y selecciónala

Tendrás los 14 notepads disponibles para invocar.

## Opción 2 · Rules for AI (global)

1. Cursor Settings → Rules for AI
2. Pega el contenido de los SKILL.md que más uses
3. Cursor las aplicará a todo prompt

⚠️ Limitación: solo cabe ~5-6 skills en Rules sin saturar contexto.

## Opción 3 · Workspace .cursorrules

1. Crea `.cursorrules` en raíz del repo del cliente
2. Lista las skills disponibles con su pattern conversacional
3. Cursor las leerá automáticamente

```
# .cursorrules ejemplo
Tienes acceso a las siguientes skills conversacionales:
- /data-questions — refina preguntas vagas (Acoge → Diagnose 4Q → Confirma → Produce → Itera)
- /info-vs-insight — clasifica info vs insight
... (las 14)

Cuando el usuario invoque /<skill>, sigue el pattern de skills/<skill>/SKILL.md
```

## Recomendación

Para el curso ESIC: si solo tienes Cursor, usa **Composer Notepads** (Opción 1). Es lo más cercano al pattern conversacional de Claude Code.
