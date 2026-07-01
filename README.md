# esic-skills-pack

Skills para el curso **Marketing Intelligence & Marketing Automation** (MUDM0024, ESIC University). Curso impartido por Alfonso Sainz de Baranda (Growth4U).

Cada skill condensa un proceso del curso para que puedas aplicarlo de forma rápida y consistente en tu trabajo real.

> **Repo universal**: las skills son markdown puro y se pueden cargar en **Claude Code**, **Codex**, **Cursor** y cualquier cliente AI vía adaptadores en `setup/`.

---

## Pre-requisitos

- Un cliente AI con acceso a un LLM bueno (**GPT-4o** · **Claude Sonnet 4.x** · **Gemini 1.5 Pro** o superior)
- `git` instalado
- Cuenta Netlify gratis + Personal Access Token (para publicar dashboards y landings vía CLI/API, sin tarjeta)
- Cuenta Make.com gratis (para hands-on de marketing automation en S3)

---

## Instalación

```bash
# 1. Clona este repo
git clone https://github.com/AlfonsoSBLA/esic-skills-pack.git
cd esic-skills-pack

# 2. Setup según tu cliente AI
bash setup/claude-code.sh       # → Claude Code (symlink .claude/skills/)
bash setup/codex.sh             # → OpenAI Codex CLI (.codex/agents/)

# Para Cursor: lee setup/cursor.md
# Para Claude.ai web, ChatGPT, Gemini, otros: lee setup/manual.md

# 3. Lanza tu cliente AI
claude    # o el comando del cliente que uses
```

Después puedes verificar que las skills están disponibles. En Claude Code: `/help`. En otros clientes: consulta `setup/<cliente>.md` o `setup/manual.md`.

---

## Skills disponibles (14)

| Sesión | Skill | Para qué sirve |
|--------|-------|----------------|
| S1 | `/data-questions` | Convierte preguntas vagas en preguntas accionables (5-por qués + acotación) |
| S2 | `/info-vs-insight` | Separa información objetiva de insight accionable en un dataset |
| S2 | `/data-story` | Estructura hallazgos: Contexto → Hallazgo → Implicación → Recomendación → Próximo paso |
| S2 | `/prioritize-macro-micro` | Prioriza palancas Macro (etapa funnel) + Micro (Quick/Slow × Big/Small) |
| S3 | `/funnel-mapper` | Dibuja un funnel de cliente con touchpoints y fuentes de datos por etapa |
| S3 | `/workflow-designer` | Diseña un scenario concreto en Make.com (trigger + acciones + branches) para un objetivo |
| S3 | `/data-quality-check` | Detecta los 10 errores comunes del análisis (sucios, outliers, estacionalidad, etc.) |
| S3 | `/north-star-tree` | A partir de objetivos de negocio, devuelve north-star + árbol de métricas |
| S3 | `/dashboard-builder` | Toma CSV + KPIs y genera un dashboard HTML+Chart.js publicable |
| S3 | `/publish-pages` | Configura y publica un dashboard o landing en Netlify (CLI/API) con URL pública |
| S4 | `/journey-designer` | Diseña un journey de Marketing Automation listo para implementar |
| S4 | `/rfm-segment` | Segmentación RFM (Recency, Frequency, Monetary) con acciones por segmento |
| S4 | `/growth-loop` | Identifica el loop de crecimiento principal y sub-loops |
| S5 | `/dashboard-judge` | Lee un dashboard + contexto y devuelve hallazgos, hipótesis y palancas |

Todas siguen el pattern conversacional: **Acoge → Diagnose → Confirma → Produce → Itera**.

Detalle por skill en [`AGENTS.md`](AGENTS.md).

---

## Datos del curso

El **trabajo grupal y los ejercicios por ángulo** se hacen sobre **Xuan Lan Yoga (XLY)** — una marca pública de yoga online. Sus datasets (uno por ángulo) están en la carpeta Drive del curso.

El caso **Hospital Capilar** (anonimizado, una clínica capilar real del ecosistema Growth4U) se usa como **demo en clase** y como ejemplo trabajado. Sus datasets están en [`data/`](data/) — ver [`data/README.md`](data/README.md) para el detalle.
Endpoints y URLs auxiliares en [`endpoints/`](endpoints/) — ver [`endpoints/README.md`](endpoints/README.md).

---

## Estructura del repo

```
esic-skills-pack/
├── README.md                ← este archivo
├── AGENTS.md                ← índice meta de las 14 skills (convención multi-cliente)
├── skills/                  ← LA FUENTE DE VERDAD · 14 skills en markdown puro
│   ├── data-questions/SKILL.md
│   ├── info-vs-insight/SKILL.md
│   ├── ... (14 directorios)
├── setup/                   ← adaptadores por cliente AI
│   ├── claude-code.sh       ← symlink .claude/skills/ → ../skills/
│   ├── codex.sh             ← adapta a .codex/agents/
│   ├── cursor.md            ← Composer Notepads · Rules · .cursorrules
│   └── manual.md            ← copy-paste para Claude.ai/ChatGPT/Gemini/otros
├── data/                    ← datasets Hospital Capilar anonimizado
└── endpoints/               ← URLs/mocks auxiliares para Zaps y dashboards
```

---

## ¿Por qué un repo universal?

Las skills son **markdown puro con frontmatter** — un formato portable. Cada cliente AI las consume a su manera, pero el contenido es uno solo.

Esto significa:
- **Una sola fuente de verdad** en `skills/`
- **Cambia de cliente** sin perder tus skills (si mañana sale un cliente nuevo, basta con añadir `setup/<nuevo>.sh`)
- **El alumno elige**: Claude Code, ChatGPT Plus + Codex, Cursor Pro, o cualquier LLM con copy-paste manual

---

## Licencia y reutilización

Material desarrollado por Alfonso Sainz de Baranda para ESIC University. Puedes usar las skills en tu trabajo profesional.

Para feedback / mejoras: abre un issue en este repo.
