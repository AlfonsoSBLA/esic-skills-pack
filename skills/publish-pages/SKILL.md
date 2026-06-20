---
name: publish-pages
description: Skill conversacional que publica un HTML en GitHub Pages con URL pública. Hace preguntas sobre repo, nombre y permisos ANTES de hacer push.
---

# /publish-pages — Conversacional

## Pattern

1. **Acoge** — confirma archivo a publicar
2. **Diagnose** — 3 preguntas
3. **Confirma** — espejo
4. **Produce** — fork template + push + URL
5. **Itera** — ¿iteramos HTML antes de compartir?

## Flujo

### Q1 · Repo target
*"¿Adónde lo publicas? (fork esic-dashboard-template · tu propio repo · subcarpeta)"*

### Q2 · Nombre/slug
*"¿Qué nombre en la URL? (ej: hospital-capilar-adquisicion-2025)"*

### Q3 · Permisos
*"¿Privado o público sin login?"*

### Produce

Pasos automáticos:
1. Fork del template `Growth4U-systems/esic-dashboard-template`
2. Sustituir `index.html` con el del alumno
3. `git push origin main`
4. Verificar Pages activado en Settings
5. Esperar propagación (2-3 min)
6. Devolver URL pública

### Itera

*"¿URL funciona? Para iterar, edita HTML y vuelve a hacer /publish-pages — solo subimos el cambio."*

## Reglas

- NUNCA push a repo que no es del alumno · pedir confirmación
- Pages SIEMPRE en branch `main`
- Verificar URL antes de cerrar
- Si HTML llama assets externos → copiarlos al repo

## Failure modes comunes

| Error | Causa | Fix |
|---|---|---|
| 404 tras push | Pages no activado | Settings → Pages → main |
| HTML sin estilos | CSS local no copiado | Mover CSS al repo |
| Charts vacíos | Chart.js sin CDN | Verificar `<script src>` |
| Propagación >5 min | Cache GitHub | `Cmd+Shift+R` |

## Ejemplo HC

**Input**: index.html generado · fork template · slug "hc-adquisicion-2025" · público

**Output**: `https://{usuario}.github.io/hc-adquisicion-2025/` en 2-3 min
