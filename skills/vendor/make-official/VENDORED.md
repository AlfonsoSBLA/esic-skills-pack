# Make — Skills oficiales (vendored)

Copia **verbatim** de las skills oficiales de Make.com (org `integromat`), incluidas aquí
como material de referencia profundo para el bloque de Marketing Automation del curso.

## Procedencia (pin)

| Campo | Valor |
|---|---|
| Upstream | https://github.com/integromat/make-skills |
| Commit | `f0857261fcb645bddc5dffdc92f564170a4e6719` |
| Versión | `0.1.7` |
| Fecha upstream | 2026-06-17 |
| Vendored el | 2026-06-29 |
| Licencia | MIT (ver `LICENSE`) — © 2026 Make |

> ⚠️ **Es una copia congelada.** Make publica versiones nuevas con frecuencia (van por `0.1.x`).
> Esto NO se actualiza solo. Para refrescar: vuelve a clonar el upstream, copia `skills/` + `LICENSE`
> aquí, y actualiza el commit/versión de esta tabla.

## Las 5 skills

| Skill | Para qué |
|---|---|
| `make-scenario-building` | QUÉ módulos usar y POR QUÉ: routing, branching, filtering, iterations, aggregations, blueprints, error handling, scheduling. La referencia más densa (incluye 10 templates populares en `examples/`). |
| `make-module-configuring` | CÓMO configurar cada módulo: connections, data stores, webhooks, mapping, expresiones IML, agregadores, AI agents. |
| `make-mcp-reference` | El servidor MCP de Make: conexión, scopes, token/OAuth, "scenario as tool", troubleshooting. |
| `make-api-shell-connection-workflow` | Workflow vía API/MCP: app discovery, connection requests, ejecución, sanitización y compartición de blueprints. |
| `make-e2b-code-execution` | Ejecución de código (E2B) dentro de escenarios Make. Avanzado / dev. |

## ⚠️ Asumen MCP — relación con las skills propias del pack

Estas skills oficiales están pensadas para un agente con el **servidor MCP de Make conectado**
(`https://mcp.make.com`). En el curso, los alumnos en free tier con clientes copy-paste
(ChatGPT / Gemini / Cursor) **no tendrán MCP**, así que:

- **Alumno sin MCP** → usa las skills propias del pack, que son **MCP-free** y emiten blueprint
  JSON importable: `/make-scenario-builder` (S3) y `/rfm-scenario-builder` (S4).
- **Referencia profunda / con MCP** → estas 6 oficiales. Úsalas para entender el PORQUÉ de la
  arquitectura de un escenario, IML, routing, y para construir vía MCP cuando esté disponible.

No se solapan: las propias son generadores prácticos para clase; estas son la doctrina oficial de Make.
