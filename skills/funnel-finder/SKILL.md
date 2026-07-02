---
name: funnel-finder
description: Skill conversacional que DESCUBRE el recorrido real de un producto navegando sus URLs con Playwright. Visita cada página, extrae los pasos reales (campos de formulario, CTAs, a dónde enlaza), intenta un pantallazo de cada paso y marca los que no pudo capturar para que los remates a mano. Devuelve la lista de pasos ordenada + los pantallazos conseguidos + el punto flojo, lista para montar un tablero (Miro/FigJam/Slides). Úsala cuando TENGAS URLs reales y quieras mapear el journey a partir de la web, no de tu cabeza. Para diseñar un funnel desde lo que ya sabes (sin URLs), usa /funnel-mapper.
---

# /funnel-finder — Conversacional

Navega la web por ti y reconstruye el **recorrido real** del usuario a partir de URLs.

Es un ejercicio **híbrido a propósito**: lo que Playwright pueda ver y capturar, lo hace la skill; lo que un sitio bloquee (login, CAPTCHA, cookie-wall, o el anti-bot típico de Meta Ads Library, App Store o YouTube) lo marca como "hazlo tú a mano". El aprendizaje está en que **tú** recorras el producto y montes el tablero final con criterio — la skill solo te ahorra el trabajo mecánico y te da una red de seguridad para no dejarte ningún paso.

## Pattern

Acoge → Diagnose → Confirma → Produce → Itera

## Flujo

### Acoge
Confirma qué producto / funnel vamos a recorrer.

### Diagnose (2-3 preguntas)

**Q1 · URLs**
*"Pégame las URLs del recorrido: home, precios, sign-up, blog, ficha de app store, ads library… lo que tengas."*

**Q2 · Qué quieres entender**
*"¿Cuál es tu pregunta? (p. ej. dónde se cae la gente, de qué canal vienen los que pagan…)"*

**Q3 · Pasos esperados (opcional)**
*"¿Tienes una idea de los pasos que crees que existen? Te la cruzo con lo que encuentre para que no se te olvide ninguno."*

### Confirma
Espejo de las URLs + la pregunta antes de navegar.

### Produce

Para **cada URL**, con Playwright:
1. Navega y **lee** la página: qué es, qué pide (campos del formulario), CTAs, a dónde enlaza.
2. Intenta un **pantallazo**. Si el sitio bloquea (login, CAPTCHA, cookie-wall, anti-bot) **no te atasques**: márcalo `📸 pendiente (hazlo tú a mano)` y sigue con la siguiente.

Devuelve:

```
RECORRIDO (paso a paso)
Paso 1 · [qué pasa] · fuente/URL · 📸 capturado | 📸 pendiente
Paso 2 · [qué pasa] · ...
...
⚠ PUNTO FLOJO: [dónde se pierde gente o dónde se rompe el recorrido]
📸 PENDIENTES DE CAPTURAR A MANO: [lista de pasos]
```

Y empuja al humano a cerrar el círculo:
*"Monta el tablero en Miro, FigJam o Google Slides: pega estos pantallazos + los pendientes que saques tú, conéctalos en orden (Paso 1 → Paso 2 → …) y marca en rojo el punto flojo."*

### Itera
*"¿Añadimos más URLs? ¿Te paso a /workflow-designer para automatizar uno de estos pasos?"*

## Reglas

- **Degrada con gracia, nunca bloquees.** Si Playwright falla en una URL (bloqueo, timeout, login), sigue con las demás y marca esa como pendiente. El objetivo es ahorrar trabajo mecánico, no ser perfecto.
- **El tablero lo monta la persona.** La skill entrega materia prima (pasos + capturas + huecos); el tablero final y el criterio del "punto flojo" son del alumno — ahí está el aprendizaje.
- **3-6 pasos.** Cada paso: qué pasa + fuente + estado de captura.
- **No inventes lo que no has visto.** Si parte del journey no es visible desde fuera (p. ej. lo que ocurre dentro de la app tras el login), decláralo como *"no visible desde fuera · confírmalo tú"* en vez de suponerlo.

## Ejemplo · Xuan Lan Yoga (funnel paid)

**Input URLs**: home · `/precios` · botón "prueba gratis" · Meta Ads Library.

**Output**:
- Paso 1 · Anuncio en Meta · Ads Library · 📸 pendiente (Ads Library bloquea el scraping)
- Paso 2 · Landing de precios · `xuanlanyoga.com/precios` · 📸 capturado
- Paso 3 · Sign-up prueba gratis · el form pide email · 📸 capturado
- Paso 4 · Trial dentro de la app · no visible desde fuera · confírmalo tú
- Paso 5 · Cobro el día 8 · no visible desde fuera · confírmalo tú
- ⚠ Punto flojo: quien ve el anuncio y se descarga la app directa → se pierde de qué canal vino
- 📸 pendientes de capturar a mano: Paso 1 (Ads Library) y Paso 4 (dentro de la app)
