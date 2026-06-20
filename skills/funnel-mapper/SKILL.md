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

*"¿Profundizo etapa? ¿Te paso a /zap-designer para conectar? ¿O a /north-star-tree?"*

## Reglas

- 3-5 etapas máximo
- Cada etapa: touchpoint + fuente + métrica (los 3 obligatorios)
- Marca dónde se rompe el flujo (gap manual)

## Ejemplo HC

**Input**: clínica injerto capilar Madrid · one-shot 3.500€ · Meta+Google+Orgánico · HubSpot+Mailchimp+Typeform

**Output**:
- Awareness: Meta Ads (gasto), Google Ads (gasto), SEO blog (GA)
- Consideration: Landing pricing (sesiones GA), blog técnico (Hotjar)
- Conversion: Typeform (leads), Asesor cualifica (HubSpot), Cita (Calendly)
- Decision: Presupuesto (HubSpot deal), Reserva pagada (Stripe)
- ⚠ ROMPE en: Asesor → Mailchimp (manual)
