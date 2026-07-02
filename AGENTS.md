# AGENTS.md — esic-skills-pack

Meta-índice de las 19 skills del curso ESIC MUDM0024. Convención compatible con múltiples clientes AI (Claude Code, Codex, Cursor, manual).

## Pattern conversacional común

Todas las skills siguen el mismo pattern: **Acoge → Diagnose (2-4 preguntas) → Confirma → Produce → Itera**.

## Inventario · 19 skills

| Nombre | Sesión | Para qué sirve |
|---|---|---|
| `/data-questions` | S1 | Refina una pregunta vaga en 3-5 preguntas concretas + métrica |
| `/info-vs-insight` | S2 | Clasifica findings como INFO (descriptivo) vs INSIGHT (accionable) |
| `/data-story` | S2 | Estructura narrativa 5 pasos: Contexto → Hallazgo → Implicación → Recomendación → Próximo paso |
| `/prioritize-macro-micro` | S2 | Prioriza palancas: Macro (etapa funnel) + Micro (Quick/Slow × Big/Small) |
| `/funnel-mapper` | S3 | Mapea funnel del cliente con touchpoints + fuentes de datos por etapa (desde lo que sabes, sin URLs) |
| `/funnel-finder` | S3 | Descubre el recorrido real navegando las URLs con Playwright: extrae pasos + pantallazos y marca los que hay que rematar a mano |
| `/form-builder` | S3 | Define tu Google Form + checklist para crearlo; te dice cómo coger los 2 enlaces (público y privado), el ID y la hoja de respuestas |
| `/landing-builder` | S3 | Crea una landing base (por defecto Xuan Lan Yoga) con Google Form embebido; previsualiza y pide feedback (logo real, UX) antes de /publish-pages |
| `/workflow-designer` | S3 | Diseña 1 scenario concreto en Make.com (trigger + acciones + branches) |
| `/manual-guide` | S3 | Lee la doc oficial de una herramienta y guía el montaje manual paso a paso (fallback cuando no hay MCP/integración) |
| `/make-scenario-builder` | S3 | Genera un blueprint JSON de Make importable (Sheets → Brevo → WhatsApp) · vía rápida del bonus de Make |
| `/journey-designer` | S3 / S4 | Diseña journey lifecycle (welcome → onboarding → win-back) |
| `/data-quality-check` | S3 | Audita dataset contra los 10 errores comunes |
| `/north-star-tree` | S3 | North-star metric + árbol de inputs multiplicativos + guardrails |
| `/dashboard-builder` | S3 / S4 | Genera index.html con Chart.js publicable (4 preguntas: KPI hero, eje X, comparativa, filtros) |
| `/publish-pages` | S3 / S4 | Publica index.html en Netlify (CLI/API) con URL pública |
| `/rfm-segment` | S4 | Segmenta clientes en 8 segmentos RFM canónicos + acción por segmento |
| `/growth-loop` | S4 | Identifica loop principal + sub-loops + input que escala + guardrail |
| `/dashboard-judge` | S5 | Lee dashboard + devuelve hallazgos + hipótesis + palancas + experimento sí/no |

## Cómo cargar las skills en tu cliente

| Cliente | Setup |
|---|---|
| **Claude Code** | `bash setup/claude-code.sh` (crea symlink `.claude/skills/`) |
| **Codex** | `bash setup/codex.sh` (adapta a `.codex/agents/`) |
| **Cursor** | Lee `setup/cursor.md` (opciones: Notepads, Rules, .cursorrules) |
| **Otros (Claude.ai web, ChatGPT, Gemini, Mistral)** | Lee `setup/manual.md` (copy-paste por sesión) |

## Estructura del repo

```
esic-skills-pack/
├── README.md                ← punto de entrada
├── AGENTS.md                ← este archivo (índice meta)
├── skills/                  ← LA FUENTE DE VERDAD
│   ├── data-questions/SKILL.md
│   ├── info-vs-insight/SKILL.md
│   ├── ... (las 16)
├── setup/                   ← adaptadores por cliente
│   ├── claude-code.sh
│   ├── codex.sh
│   ├── cursor.md
│   └── manual.md
├── data/                    ← datasets Hospital Capilar
└── endpoints/               ← mocks para Make.com/MCP
```

## Filosofía

Las skills son **markdown puro con frontmatter**. Cada cliente las consume diferente, pero el contenido es uno solo.

Si mañana sale un cliente nuevo (Claude 6, Codex 3, lo que sea), añades `setup/<nuevo>.sh` o `setup/<nuevo>.md` sin tocar ni una skill.

## Pre-requisitos del alumno

- Un cliente AI con acceso a un LLM bueno (GPT-4o · Claude Sonnet 4.x · Gemini 1.5 Pro o superior)
- `git` instalado
- Cuenta Netlify gratis + Personal Access Token (para publicar dashboards y landings vía CLI/API)
- Cuenta Make.com gratis (para hands-on S3)
