---
name: landing-builder
description: Skill conversacional que crea UNA landing HTML self-contained de captación con el look & feel de la marca (por defecto Xuan Lan Yoga · yoga online: tonos calma, verde suave, mucho aire). Incluye hero + barra de confianza + secciones de beneficios + un formulario de captura embebido (Google Form en un iframe) + testimonios + cierre, y un banner de "demo educativa ESIC". ANTES de publicar, la previsualiza y pide feedback al alumno (logo real, colores, mejoras de UX). Output = un index.html listo para publicar con /publish-pages. Úsala cuando necesites crear la página de captación de tu funnel en S3. Para publicarla en Netlify usa /publish-pages; para descubrir el recorrido del cliente usa /funnel-finder.
---

# /landing-builder · Conversacional

Crea la **página de captación** (landing) de tu funnel: una web sencilla, bonita y autocontenida (un solo `index.html`) con un formulario que recoge al lead. Por defecto sigue el estilo de **Xuan Lan Yoga** (yoga online: calma, verde suave, mucho espacio en blanco), pero admite cualquier marca de referencia.

Clave: el formulario de captura es un **Google Form embebido** (un `<iframe>`). Así el lead cae directo en una hoja de Google Sheets y tu scenario de Make puede reaccionar a cada respuesta. Crea el Google Form ANTES (o pídeselo a Iria) y ten a mano su **ID** (está en la URL del Form: `.../forms/d/e/XXXX/viewform`).

## Pattern

Acoge → Diagnose → Confirma → Produce → Itera

## Flujo

### Acoge
*"¿Para qué marca? (por defecto Xuan Lan Yoga · yoga online). ¿Tienes ya el Google Form de captura y su ID?"*

### Diagnose (4 preguntas)

**Q1 · Hero** — *"¿Frase principal y el deseo/dolor del visitante?"* (ej XLY: *"Tu práctica de yoga, cada día, desde casa"*)
**Q2 · Confianza** — *"3 datos que den confianza (número grande + etiqueta corta)."* (ej: 2M+ alumnos · 500+ clases · 7 días gratis)
**Q3 · Secciones** — *"¿Qué va entre el hero y el formulario? Por defecto: Beneficios (3 cards) + Cómo funciona + Formulario + Testimonios + Cierre."*
**Q4 · CTA** — *"Texto del botón principal."* (ej: *"Empieza tu prueba gratis"*)

### Confirma
Espejo de marca + hero + secciones + Form ID.

### Produce
Un `index.html` autocontenido (CSS inline, sin dependencias) con:
- **Banner amarillo** "Demo educativa · ESIC MUDM0024 · no es el sitio real" (siempre, porque replica una marca que no es tuya).
- **Hero**: eyebrow + h1 + subtítulo + botón CTA que baja al formulario.
- **Barra de confianza** con los 3 datos.
- **Secciones intermedias** (beneficios en cards, cómo funciona…).
- **Sección de formulario** con el Google Form embebido: `<iframe src="https://docs.google.com/forms/d/e/FORM_ID/viewform?embedded=true">` (sustituye `FORM_ID` por el real).
- **Testimonios + cierre + footer** con disclaimer ESIC.
- **Responsive** (media query móvil: menos padding, iframe más alto).

Paleta por defecto (Xuan Lan · yoga online):
```css
:root{ --verde:#7BA890; --verde-oscuro:#4E6E5D; --crema:#F5F1E8; --tinta:#2E332E; --suave:#EDF2ED; }
```
(Cambia la paleta si la marca es otra.)

### Previsualiza y pide feedback (ANTES de publicar)
Enseña la landing renderizada al alumno (**preview en Teros**) y pídele feedback concreto — no la publiques a la primera. Pregunta al menos:
- *"¿Pongo el **logo real** de la marca? Pásame el archivo o el enlace y lo coloco en el header."*
- *"¿Ajusto colores, tipografía o el copy de alguna sección?"*
- *"¿Algo de **UX** que mejorar? (el formulario más arriba · el CTA más visible · quitar una sección que sobra · el orden de las secciones · el texto del botón)."*
Itera sobre el HTML hasta que dé el visto bueno. **Solo entonces** pasa a `/publish-pages`.

### Itera
*"¿Otro cambio? Cuando esté a tu gusto, la subo a Netlify con /publish-pages."*

## Reglas

- **Autocontenida**: cero dependencias externas salvo el iframe del Google Form. CSS inline.
- **Banner de demo SIEMPRE** cuando replica una marca real que no posees (XLY, etc.), y disclaimer en el footer. No es el sitio oficial.
- **Sustituye `FORM_ID`** por el ID real del Google Form. Si aún no lo tienes, deja `FORM_ID` como marcador y dilo claramente para cambiarlo después.
- **Ligera y clara**: 1 idea por sección, tipografía grande, mucho aire. Es una pieza de aprendizaje, no un sitio de producción.
- **Móvil**: los Google Forms se ven más largos → sube el `min-height` del iframe en la media query.
- **Enseña antes de publicar.** Nunca saltes directo a `/publish-pages`: primero muestra la landing y pide feedback (logo real, UX). Publicar es el último paso, cuando el alumno da el OK.

## Ejemplo · Xuan Lan Yoga (yoga online)

**Input**: marca XLY · hero *"Tu práctica de yoga, cada día, desde casa"* · confianza 2M+ alumnos / 500+ clases / 7 días gratis · secciones por defecto · CTA *"Empieza tu prueba gratis"* · Form ID del Google Form de captura.

**Output**: `index.html` (~250-350 líneas, autocontenido) con el Google Form embebido, listo para `/publish-pages`.

## Handoff

→ Tras crear el HTML, pasa a `/publish-pages` para subirlo a Netlify y obtener la URL pública.
→ El scenario que reacciona a las respuestas del Form se monta con `/workflow-designer`.
