# AGENTS.md — esic-skills-pack

Meta-índice de las 19 skills del curso ESIC MUDM0024. Convención compatible con múltiples clientes AI (Claude Code, Codex, Cursor, Teros, manual).

## Pattern conversacional común

Todas las skills siguen el mismo pattern: **Acoge → Diagnose (2-4 preguntas) → Confirma → Produce → Itera**.

## Inventario · 19 skills

### Bloque base (14 skills · análisis · funnel · journey · dashboard)

| Nombre | Sesión | Para qué sirve |
|---|---|---|
| `/data-questions` | S1 | Refina una pregunta vaga en 3-5 preguntas concretas + métrica |
| `/info-vs-insight` | S2 | Clasifica findings como INFO (descriptivo) vs INSIGHT (accionable) |
| `/data-story` | S2 | Estructura narrativa 5 pasos: Contexto → Hallazgo → Implicación → Recomendación → Próximo paso |
| `/prioritize-macro-micro` | S2 | Prioriza palancas: Macro (etapa funnel) + Micro (Quick/Slow × Big/Small) |
| `/funnel-mapper` | S3 | Mapea funnel del cliente con touchpoints + fuentes de datos por etapa |
| `/zap-designer` | S3 | Diseña 1 Zap concreto (trigger + acciones + branches) · *DEPRECATED · usar /make-scenario-builder* |
| `/journey-designer` | S3 / S4 | Diseña journey lifecycle (welcome → onboarding → win-back) |
| `/data-quality-check` | S3 | Audita dataset contra los 10 errores comunes |
| `/north-star-tree` | S3 / S5 | North-star metric + árbol de inputs multiplicativos + guardrails |
| `/dashboard-builder` | S3 / S5 | Genera index.html con Chart.js publicable (4 preguntas: KPI hero, eje X, comparativa, filtros) |
| `/publish-pages` | S3 / S5 | Publica index.html en Netlify drag-and-drop con URL pública |
| `/rfm-segment` | S4 | Segmenta clientes en 8 segmentos RFM canónicos + cruce con canal de adquisición |
| `/growth-loop` | S4 | Identifica loop principal + sub-loops + input que escala + guardrail |
| `/dashboard-judge` | S5 | Lee dashboard + devuelve hallazgos + hipótesis + palancas + experimento sí/no |

### Bloque demo S3 acquisition (5 skills · construyen el stack end-to-end en vivo)

| Nombre | Sesión | Para qué sirve |
|---|---|---|
| `/landing-builder` | S3 (demo profesor) | Genera `index.html` self-contained de captación con look&feel del cliente (paleta + secciones + iframe Google Form con placeholder) |
| `/form-builder` | S3 (demo profesor) | Genera Apps Script `.gs` que crea Google Form con campos validados + Sheet vinculada |
| `/landing-deploy` | S3 (demo profesor) | Reemplaza Form ID en HTML + deploy a Netlify producción (vía CLI/MCP del runtime) |
| `/make-scenario-builder` | S3 (demo profesor) | Genera blueprint JSON Make importable (default Sheets → Brevo) + instrucciones de import |
| `/hc-demo-build` | S3 (demo profesor) | **Orquestador**: encadena las 4 anteriores con pausas para que el alumno ejecute Apps Script en script.google.com y blueprint en Make.com. ~18 min para stack completo |

## Cómo cargar las skills en tu cliente

| Cliente | Setup |
|---|---|
| **Claude Code** | `bash setup/claude-code.sh` (crea symlink `.claude/skills/`) |
| **Codex** | `bash setup/codex.sh` (adapta a `.codex/agents/`) |
| **Cursor** | Lee `setup/cursor.md` (opciones: Notepads, Rules, .cursorrules) |
| **Teros** | Skills neutras al runtime · cargar directamente desde `skills/` (Teros consume `SKILL.md` con frontmatter `name`/`description`) |
| **Otros (Claude.ai web, ChatGPT, Gemini, Mistral)** | Lee `setup/manual.md` (copy-paste por sesión) |

## Estructura del repo

```
esic-skills-pack/
├── README.md                ← punto de entrada
├── AGENTS.md                ← este archivo (índice meta)
├── skills/                  ← LA FUENTE DE VERDAD
│   ├── data-questions/SKILL.md
│   ├── info-vs-insight/SKILL.md
│   ├── ... (las 14)
├── setup/                   ← adaptadores por cliente
│   ├── claude-code.sh
│   ├── codex.sh
│   ├── cursor.md
│   └── manual.md
├── data/                    ← datasets Hospital Capilar
└── endpoints/               ← mocks para Zapier/MCP
```

## Filosofía

Las skills son **markdown puro con frontmatter**. Cada cliente las consume diferente, pero el contenido es uno solo.

Si mañana sale un cliente nuevo (Claude 6, Codex 3, lo que sea), añades `setup/<nuevo>.sh` o `setup/<nuevo>.md` sin tocar ni una skill.

## Pre-requisitos del alumno

- Un cliente AI con acceso a un LLM bueno (GPT-4o · Claude Sonnet 4.x · Gemini 1.5 Pro o superior · Teros con modelo similar)
- `git` instalado
- Cuenta Netlify gratis (para publicar landings y dashboards)
- Cuenta Make.com gratis (para hands-on S3 · 1.000 ops/mes free tier)
- Cuenta Brevo gratis (para email marketing · 300 emails/día free tier)
- Cuenta Google (para Forms + Sheets + Apps Script)
- Cuenta Hunter.io gratis (opcional · enrichment de email · 25+50/mes free)
