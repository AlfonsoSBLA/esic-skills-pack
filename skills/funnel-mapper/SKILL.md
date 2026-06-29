---
name: funnel-mapper
description: Skill conversacional que dibuja el funnel de cliente con touchpoints + fuentes de datos por etapa. Hace preguntas sobre industria, modelo y herramientas ANTES de mapear.
---

# /funnel-mapper — Conversacional

## Pattern

1. **Acoge** — confirma negocio
2. **Diagnose** — 4 preguntas
3. **Confirma** — espejo
4. **Produce** — funnel mapped end-to-end
5. **Itera** — ¿enriquecemos alguna etapa?

## Flujo

### Q1 · Industria
*"¿Sector? (fintech · healthcare · e-commerce · SaaS · servicio profesional · educación)"*

### Q2 · Modelo de negocio
*"¿Cómo cobras? (one-shot · suscripción · marketplace · ads · híbrido)"*

### Q3 · Canales activos hoy
*"¿Por dónde llega gente? Meta · Google · SEO · referidos · cold outbound · partnerships..."*

### Q4 · Stack de herramientas
*"¿Qué herramientas tienes? CRM (cuál) · ESP · analytics · ads · automation..."*

### Produce

Funnel visual stage-by-stage:
```
ETAPA 1: Awareness
├── Touchpoint A · fuente datos · métrica clave
├── Touchpoint B · ...

ETAPA 2: Consideration
├── ...
```
+ Marca explícita dónde se ROMPE el flujo de datos

### Itera

*"¿Profundizo etapa? ¿Te paso a /workflow-designer para conectar? ¿O a /north-star-tree?"*

## Reglas

- 3-5 etapas máximo
- Cada etapa: touchpoint + fuente + métrica (los 3 obligatorios)
- Marca dónde se rompe el flujo (gap manual)

## Ejemplo 1 · Hospital Capilar (one-shot)

**Input**: clínica injerto capilar Madrid · one-shot 3.500€ · Meta+Google+Orgánico · HubSpot+Mailchimp+Typeform

**Output**:
- Awareness: Meta Ads (gasto), Google Ads (gasto), SEO blog (GA)
- Consideration: Landing pricing (sesiones GA), blog técnico (Hotjar)
- Conversion: Typeform (leads), Asesor cualifica (HubSpot), Cita (Calendly)
- Decision: Presupuesto (HubSpot deal), Reserva pagada (Stripe)
- ⚠ ROMPE en: Asesor → Mailchimp (manual)

## Ejemplo 2 · Xuan Lan Yoga (suscripción B2C)

**Input**: app yoga online · suscripción mensual/anual · Paid Search + Paid Social + App Stores + Orgánico (YouTube + SEO) + Email · HubSpot + Brevo + Make.com + GA4 + Mixpanel

**Output**:
- Awareness: Meta Ads · Google Ads · YouTube orgánico · SEO blog · App Stores (búsqueda) · referidos
- Consideration: Landing pricing (sesiones GA), webinar gratis (leads HubSpot), descarga app (App Stores)
- Activation: Sign-up free trial (HubSpot workflow), uso primeras 24h (Mixpanel events)
- Conversion: Free trial → paid (Stripe + Brevo automation)
- Retention M1-MN: Engagement semanal (logins · clases vistas), churn signal (>7 días sin login)
- Revenue: Renovación mensual/anual (Stripe), upsell programas (HubSpot deals), tienda (Shopify)
- ⚠ ROMPE en: App Stores → HubSpot (atribución de canal se pierde) · churn signal → win-back campaign (no automatizado)

## Diferencias clave one-shot vs suscripción

| Aspecto | One-shot (HC) | Suscripción (XLY) |
|---|---|---|
| Etapa decisión | "Conversion" termina el funnel | "Activation" empieza el resto del funnel |
| Métrica clave | CAC + ticket único | LTV/CAC + churn + MRR |
| Etapas críticas post-conversión | NONE (recompra años después) | Activation M0 + Retention M1-MN |
| Funnel completo | 3-4 etapas | 5-6 etapas (con activation + retention) |
| Dato más caro de medir | CR cita→paciente (offline) | Churn por cohort + cohort revenue retention |
