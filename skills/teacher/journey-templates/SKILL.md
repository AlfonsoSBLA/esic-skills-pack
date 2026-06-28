---
name: journey-templates
description: Skill que genera 3-4 templates HTML email (uno por segmento canónico priorizado · Champion / At Risk / Lost · opcional Loyal) listos para subir a Brevo como Email Templates + las specs de las Automations Brevo correspondientes (trigger lista, secuencia, waits, conditions, if/else). Output = `champion.html`, `at-risk.html`, `lost.html` self-contained + `setup-instructions.md` con la receta paso a paso de crear las automations. Es la pareja directa de /rfm-scenario-builder: ese genera el motor, esta genera el contenido y las automations que dispara.
---

# /journey-templates — Conversacional

## Cuándo aplica

Tras `/journey-designer` (cuando ya has decidido la lógica narrativa: triggers, waits, ramas) y en paralelo o tras `/rfm-scenario-builder` (que crea las listas Brevo que disparan estos workflows). Es la última pieza del stack de retención: el motor ya enruta, ahora hace falta el contenido.

## Pre-requisitos

- Cuenta Brevo (free tier admite 1 workflow · plan Lite gratuito o Starter para correr 3+ en paralelo)
- Las 4 listas ya creadas en Brevo (`Cliente · Champion`, `· At Risk`, `· Hibernating`, `· Lost`)
- Los 8 atributos custom ya creados (R, F, M, RFM_SCORE, RFM_SEGMENT, LAST_VISIT, LTV, N_VISITS, FIRSTNAME)
- Una propuesta de oferta por segmento (decidida con `/journey-designer`): para Champion suele ser touch humano + descuento alto, para At Risk oferta caducidad medio, para Lost última oferta agresiva

## Pattern

1. **Acoge** — confirma cuántos segmentos (default: 3 priorizados Champion + At Risk + Lost)
2. **Diagnose** — 3 preguntas (marca · ofertas · canal)
3. **Confirma** — espejo
4. **Produce** — 3 archivos `.html` self-contained + `setup-instructions.md`
5. **Itera** — ¿añadimos Loyal · cambio paleta · ajusto subject · acorto cuerpo?

## Lo que genera la skill

3 archivos HTML self-contained (CSS inline, listos para pegar en Brevo Code Editor):

| Archivo | Segmento | Subject sugerido | Carácter |
|---|---|---|---|
| `champion.html` | Champion | "{{FIRSTNAME}}, sesión 1:1 con el director · 50% OFF" | VIP · touch humano · descuento alto |
| `at-risk.html` | At Risk | "{{FIRSTNAME}}, te echamos de menos · 25% (7 días)" | Caducidad media · honestidad |
| `lost.html` | Lost | "{{FIRSTNAME}}, una última oferta antes de despedirnos" | Last chance · 35% + regalo |

Más `setup-instructions.md` con la spec paso a paso de las 3 Automations Brevo (trigger → email → wait → if-else → end).

## Flujo

### Acoge

*"¿3 templates clásicos? Default = Champion + At Risk + Lost (los 3 que justifican el ROI del demo). Hibernating NO necesita template (se silencia con `pause_emails=true` desde el scenario Make). ¿Añadimos Loyal o nos quedamos en los 3?"*

### Q1 · Marca y paleta

*"Necesito 4 cosas de marca:*
- *Color primario (ej. azul HC #0d2c50)*
- *Color acento CTA (ej. teal HC #4CA994)*
- *Nombre de marca (ej. Hospital Capilar)*
- *Tono: corporativo / cercano / directo / lujo (afecta copy de los botones y firma)"*

### Q2 · Ofertas reales por segmento

Tabla espejo:

| Segmento | Oferta principal | Oferta secundaria | CTA texto |
|---|---|---|---|
| Champion | Sesión 1:1 con director · gratis | -50% próximo tratamiento si reserva | Reservar mi sesión 1:1 |
| At Risk | -25% en próximo tratamiento | Videoconsulta gratuita 15 min | Activar mi 25% antes de 7 días |
| Lost | -35% + regalo de bienvenida | Videoconsulta gratuita con director | Activar mi oferta antes de cerrar |

*"¿Te valen estas ofertas como template? Si cambian, dímelas ahora antes de generar."*

### Q3 · Personalización avanzada

*"¿Usamos las variables Brevo además del FIRSTNAME?*
- *{{contact.LTV}} para mostrar ‘has invertido X€ con nosotros’*
- *{{contact.LAST_VISIT}} para ‘hace N días desde tu última visita’*
- *{{contact.RFM_SCORE}} en footer técnico solo (no marketing)*

*Si no especificas, uso solo FIRSTNAME (lo más seguro · siempre rellena con default ‘Hola’)."*

### Produce

#### Template `champion.html` (resumen estructura · el archivo completo se genera con copy real)

```html
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Sesión 1:1 · {{NOMBRE_MARCA}}</title>
</head>
<body style="margin:0; padding:0; background:#F0F7F6; font-family: -apple-system, BlinkMacSystemFont, sans-serif; color:#1f2937;">
  <table role="presentation" cellspacing="0" cellpadding="0" border="0" width="100%">
    <tr><td align="center" style="padding: 32px 16px;">

      <!-- Card -->
      <table role="presentation" width="600" style="max-width:600px; background:#fff; border-radius:12px;">

        <!-- Hero · VIP badge + título personalizado -->
        <tr><td style="background: linear-gradient(135deg, {{COLOR_PRIMARIO}}, ...); padding: 40px 32px;">
          <div style="background: {{COLOR_ACENTO}}; color: #fff; padding: 6px 14px; border-radius: 999px;">VIP · Champion</div>
          <h1 style="color: #fff; font-size: 30px;">Una sesión 1:1 con el director, solo para ti, {{contact.FIRSTNAME|default:"hola"}}</h1>
        </td></tr>

        <!-- Cuerpo · agradecimiento + invitación + bullets -->
        <tr><td style="padding: 32px;">
          <p>Gracias por confiar en {{NOMBRE_MARCA}}...</p>
          <ul>
            <li>Revisión del estado actual</li>
            <li>Plan a 12 meses</li>
            <li>...</li>
          </ul>

          <!-- Bloque oferta · acento color -->
          <table style="background: {{COLOR_PRIMARIO_SOFT}}; border-left: 4px solid {{COLOR_ACENTO}}; border-radius: 8px;">
            <tr><td style="padding: 22px 24px;">
              <p style="text-transform: uppercase; color: {{COLOR_ACENTO}};">Tu regalo VIP</p>
              <p style="font-size: 18px; color: {{COLOR_PRIMARIO}};">–50% sobre tarifa próximo tratamiento</p>
            </td></tr>
          </table>

          <!-- CTA principal -->
          <a href="https://...?utm_campaign=s4_champion" style="background: {{COLOR_ACENTO}}; color: #fff; padding: 16px 36px; border-radius: 8px;">{{CTA_TEXTO}} →</a>
        </td></tr>

        <!-- Footer · unsubscribe + privacidad -->
        <tr><td style="background: {{COLOR_PRIMARIO}}; padding: 24px 32px; color: rgba(255,255,255,0.7);">
          <a href="{{ unsubscribe }}">Darse de baja</a>
        </td></tr>

      </table>
    </td></tr>
  </table>
</body>
</html>
```

(Los 3 templates completos · 200-400 líneas cada uno · con copy real en español, paleta del cliente, variables Brevo cableadas, footer legal, RFM segment tag oculto en spacer final · se generan inline igual que en `champion.html`, `at-risk.html`, `lost.html` del demo HC.)

#### `setup-instructions.md` (resumen · el archivo completo es el de la sección de la skill)

```
1. Crear las 4 listas en Brevo (Champion / At Risk / Hibernating / Lost)
2. Crear los 8 atributos custom (R, F, M Number · RFM_SCORE, RFM_SEGMENT Text · LAST_VISIT Date · LTV, N_VISITS Number)
3. Subir los 3 templates HTML como Email Templates (Code Editor)
4. Crear las 3 Automations:

   Champion:
     Trigger: Contact added to list HC·Champion
     Step 1: Send email · template "Champion · sesión 1:1"
     Step 2: Wait 3 days
     Step 3: If opened Step 1 = yes → End · else → Send reminder
     End

   At Risk:
     Trigger: Contact added to list HC·At Risk
     Step 1: Send email · template "At Risk · -25% 7 días"
     Step 2: Wait 7 days
     Step 3: If opened = no → SMS opcional · else → End
     End

   Lost:
     Trigger: Contact added to list HC·Lost
     Step 1: Send email · template "Lost · última oferta"
     Step 2: Update attribute email_quemado=true (no volver a contactar 12 meses)
     End

5. Test E2E: editar fila Sheet → Run once en Make → ver contacto entrar en lista → ver email recibido.
```

### Itera

*"¿Añado Loyal (4º template)? ¿Cambio paleta a otra marca? ¿Acorto el cuerpo de Champion (parece largo)? ¿Cambio CTA texto? ¿Sustituyo SMS de At Risk por WhatsApp vía Brevo?"*

## Reglas

- HTML self-contained: TODO el CSS inline · NUNCA `<style>` externo (Gmail lo come)
- Tablas para layout · NUNCA `flex`/`grid` (clientes Outlook viejos no los soportan)
- Imágenes opcionales: si las metes, host externo público (no base64 · pesa) · siempre con `alt`
- Variables Brevo: `{{contact.FIRSTNAME|default:"Hola"}}` (con default · si no, queda hueco feo)
- Subject siempre con personalización ({{FIRSTNAME}}) + valor claro · 50-65 caracteres max
- Footer SIEMPRE con `{{ unsubscribe }}` (GDPR) + link a privacidad
- CTA único principal · uno solo. Si quieres ofrecer 2 opciones (videoconsulta vs reserva directa), una grande + una textual debajo
- Preheader oculto en `<div style="display:none">` los primeros 80-120 caracteres · es lo que se ve en el preview de la bandeja
- Mobile-first: width 600px máximo · padding generoso · font 16-18px en body · CTA ≥44px alto

## Output

4 piezas en folder `brevo/`:
1. `email-templates/champion.html` (~200-400 líneas)
2. `email-templates/at-risk.html` (~200-400 líneas)
3. `email-templates/lost.html` (~200-400 líneas)
4. `setup-instructions.md` (paso a paso para crear listas + atributos + templates + automations)

## Ejemplos

### Ejemplo HC (canónico de la demo S4)

**Input**:
- Marca: Hospital Capilar
- Paleta: #0d2c50 (azul) + #4CA994 (teal)
- Tono: cercano-profesional, primera persona, honestidad sobre la oferta
- 3 templates: Champion (sesión 1:1 con dr. Mendoza + 50%), At Risk (25% 7 días + videoconsulta), Lost (35% + regalo + dr. Mendoza)
- Variables usadas: FIRSTNAME + RFM_SCORE en footer técnico

**Output**: 3 HTMLs en `demos/s4-retention-stack/brevo/email-templates/` + `setup-instructions.md`. Tras subir y activar las 3 Automations, los Champions reciben email VIP 0 minutos después de entrar a la lista (Brevo lo dispara inmediato).

### Ejemplo XLY (Xuan Lan Yoga · ángulo retención del alumno)

**Input**:
- Marca: Xuan Lan Yoga
- Paleta: blanco / negro / dorado suave (#D4AF37)
- Tono: zen, espiritual, no presional
- 3 templates adaptados:
  - Champion (Yogi VIP): "Una clase 1:1 con Xuan Lan + acceso al retiro próximo gratis"
  - At Risk: "Tu práctica te echa de menos · 20% off en el próximo curso"
  - Lost: "Antes de despedirnos · 30 días de acceso premium gratis"
- Variables: FIRSTNAME

**Output**: mismos 3 archivos con copy yoga, paleta dorada, sin urgencia agresiva (incompatible con el tono). La maquinaria de Brevo Automations es idéntica · cambia solo el contenido.

## Handoff típico

→ Tras crear templates + automations, todo el stack S4 está vivo. Hacer el test E2E del README (`Run once` en Make + verificar email llega en bandeja test).
→ Si Brevo Free solo permite 1 workflow → activar solo Champion (el de mayor revenue impact) y dejar At Risk + Lost en `Draft` para enseñar pero no correr.

## Ver también

- `/journey-designer` (decide la lógica narrativa ANTES de generar los HTML)
- `/rfm-scenario-builder` (crea el motor Make que enruta · pareja directa de esta skill)
- `/rfm-segment` (genera el dataset y los segmentos · la pieza más upstream)
- `/landing-builder` (si el template tiene un CTA externo a una landing nueva, generarla aquí primero)
