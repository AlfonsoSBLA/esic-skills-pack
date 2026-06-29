---
name: rfm-segment
description: Skill conversacional que segmenta clientes con RFM (Recency, Frequency, Monetary) → 8 segmentos canónicos + acción recomendada. Hace preguntas sobre ventana, definición de compra y distribución ANTES de scoring. APLICA siempre que haya data a nivel cliente individual (Income Report con UserID · Transaction Date · Gross · Campaign/Origin) — incluido el Ángulo 1 paid mix, donde se cruza RFM × canal de adquisición para responder qué canal trae los segmentos de más valor.
---

# /rfm-segment — Conversacional

## ⚠ Cuándo aplica esta skill

**APLICA cuando**:
- Tienes data a nivel CLIENTE individual (1 fila por transacción · cols con UserID + Transaction Date + Gross + Campaign/Origin)
- El objetivo es segmentar para: campañas de retención, win-back, re-engagement, upsell **O bien** cruzar segmentos con dimensión de adquisición (canal · campaña · cohort de signup) para responder *"¿qué canal trae mayoritariamente Champions vs Lost?"*
- Es S4 del curso (Retención) o cualquier ángulo que tenga acceso al **Income Report** (67.631 transacciones individuales con UserID + Gross + Transaction Date + Campaign + Origin)

**Trampa común**: pensar que RFM solo aplica al "ángulo retención". RFM aplica a **retención + cualquier ángulo que pueda cruzar segmento × dimensión de adquisición**. El Ángulo 1 (Mix canales pagados) entra de pleno **si el grupo tiene acceso al Income Report** — y debería tenerlo, porque ese cruce es justo lo que sostiene la decisión de reasignar budget hacia canales que traen segmentos de mejor valor.

**NO APLICA cuando** (muy raro, ya casi nunca):
- Solo tienes data AGREGADA por canal/mes/cohort (sin Income Report ni equivalente)
- En ese caso o pides el Income Report, o documentas explícitamente que no se hace RFM

### Workaround "RFM-canal" (DEPRECATED)

> **Deprecated**: este workaround solo aplica si NO tienes data a nivel cliente. Con el Income Report (67k filas) ya disponible en el repositorio del curso, usa el flujo canónico directamente. Solo úsalo si llegas a un caso donde literalmente no hay data por cliente.

(Versión histórica del workaround, conservada por completitud: scoring 1-5 por canal en R/F/M agregados · útil pedagógicamente para enseñar el framework, pero NO es RFM canónico.)

## Pattern

1. **Acoge** — confirma acceso al Income Report
2. **Diagnose** — 3 preguntas
3. **Confirma** — espejo
4. **Produce** — score 1-5 por eje + 8 segmentos + acción + (si aplica) cruce con Origin
5. **Itera** — ¿afinamos thresholds · cruzamos con otra dimensión?

## Flujo

### Acoge

*"Antes de scorear: ¿tienes acceso al Income Report (Calculadora LTV, CAC y Cohortes XLY Yoga.xlsx → pestaña Income Report, 67.631 filas con `Transaction_ID · UserID · Campaign · Activation Date · Gross · Net · Transaction Date · Transaction Month · Origin · Product`)? Sin él el RFM canónico no se puede calcular."*

Si no → pedir el Income Report o detener la skill.

### Q1 · Ventana temporal

*"¿Recency contra qué fecha? (hoy · cierre Q · 30 días atrás · última fecha del dataset)"*

### Q2 · Definición de "compra"

*"¿Qué cuenta como 'compra'? (1 fila Income Report = 1 evento · agregamos por mes-cliente · uso feature key · login)"* → en suscripción la regla habitual es: 1 transacción = 1 evento de Frequency, Gross = aporta a Monetary.

### Q3 · Distribución esperada

*"¿Esperas Pareto fuerte (20/80) o distribución plana?"* → cambia thresholds.

### Produce

```
SCORING (cada cliente, calculado desde Income Report agrupando por UserID)
  R · score 1-5 (días desde última Transaction Date)
  F · score 1-5 (nº transacciones en ventana)
  M · score 1-5 (Σ Gross en ventana)

SEGMENTOS CANÓNICOS (% del total)
  Champions (555): N% — acción: mimar, VIP, embajadores
  Loyal (454): N% — acción: cross-sell, pedir referidos
  Promising (333): N% — acción: nurturing, mejorar engagement
  New (511): N% — acción: onboarding fuerte, time-to-value
  Need Attention (343): N% — acción: re-engagement por email
  At Risk (143): N% — acción: oferta personalizada
  About to Sleep (133): N% — acción: win-back urgente
  Lost (111): N% — acción: descartar o última oferta agresiva

TOP 3 SEGMENTOS A PRIORIZAR (por € en juego × ease)
```

#### Cruce RFM × canal de adquisición (Ángulo 1 y similares)

Si tienes Income Report con `Campaign`/`Origin`, después del scoring base haz una **tabla de concentración**:

```
TABLA: segmento × canal_adquisición → % concentración

                Email  PaidSearch  Paid Social  Affiliate  AppleASA  AndroidUAC  ...
Champions       38%    12%         18%          15%        9%        5%
Loyal           25%    18%         22%          12%        12%       8%
Promising       15%    25%         20%          8%         18%       10%
New             8%     20%         15%          5%         28%       22%
At Risk         9%     15%         12%          5%         20%       30%
Lost            5%     10%         13%          55%        13%       25%
```

**Insights típicos a sacar**:
1. ¿Qué canal sobre-indexa en Champions / Loyal? → infrainvertido si tiene poco share de spend.
2. ¿Qué canal sobre-indexa en Lost / At Risk? → fuga · revisar UX onboarding de ese canal.
3. ¿Hay canal con bajo volumen pero altísimo LTV en Champions? → infraexplotado.

### Itera

*"¿Cambio thresholds? ¿Cruzamos por dimensión adicional (cohort de signup · plan mensual vs anual · país)? ¿Te paso a /journey-designer para el journey por segmento?"*

## Reglas

- 3 ejes siempre (R, F, M)
- Scores 1-5 (canon industria)
- 8 segmentos canónicos · no inventes nuevos
- Acción SIEMPRE por segmento
- Si hay dimensión de adquisición (Campaign/Origin) → cruce obligatorio. RFM solo es 50% del valor sin ese cruce.

## Ejemplo Ángulo 1 con Income Report (Xuan Lan Yoga)

**Input alumno**:
- Dataset: Income Report 67.631 filas (UserID + Gross + Transaction Date + Campaign + Origin)
- Ventana: últimos 12 meses contra última fecha del dataset
- 1 transacción = 1 evento de Frequency
- Pareto esperado (suscripción yoga online)

**Output (cifras ilustrativas — el alumno calcula las reales)**:

| Segmento | % usuarios | € en juego | Acción |
|---|---|---|---|
| Champions | 8% | 38% del Gross | Mimar · referidos · plan anual |
| Loyal | 14% | 22% | Cross-sell cursos one-shot |
| Promising | 11% | 9% | Nurturing email + push |
| New | 18% | 6% | Onboarding fuerte D0-D7 |
| Need Attention | 12% | 8% | Re-engagement |
| At Risk | 9% | 7% | Oferta personalizada |
| About to Sleep | 11% | 5% | Win-back |
| Lost | 17% | 5% | Descartar |

**Cruce RFM × Origin (lo que justifica reasignar budget Ángulo 1)**:

3 insights a defender:
1. **Email Marketing trae ~38% de Champions vs ~12% de Paid Search**, pese a que Paid Search es ~4× el spend → Email infrainvertido relativo a la calidad que aporta.
2. **Apple App Store concentra New + Promising**, Android concentra At Risk → investigar UX onboarding Android (no es problema de canal, es problema de producto post-install).
3. **Affiliate/Referidos**: bajo volumen pero ratio Champions desproporcionado → canal infraexplotado, candidato a programa formal.

## Ejemplo HC (canónico retención)

**Input**: dataset clientes · ventana hoy · compra = intervención cerrada · Pareto sí

**Output**:
- 12% Champions — mimar
- 24% Loyal — pedir referidos
- 18% Promising — nurturing
- 8% New — onboarding
- 14% Need Attention — re-engagement
- 9% At Risk — oferta
- 8% About to Sleep — win-back
- 7% Lost — descartar

TOP 3: Champions · At Risk · Promising
