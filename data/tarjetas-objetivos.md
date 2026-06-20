# Tarjetas de objetivos vagos — Hands-on B (S1)

Hay 6 tarjetas para los 6 grupos. **Una tarjeta por grupo**, asignada al azar (caja o reparto del profesor).

Cada grupo recibe su objetivo vago y debe:
1. Aplicar `/data-questions` para refinarlo en 3-5 preguntas concretas
2. Aplicar `/info-vs-insight` con `data/hospital-capilar-mini.csv` para separar info de insight
3. Identificar **qué dato falta** para responder bien la pregunta (no todos los objetivos se resuelven con este dataset — eso es parte del aprendizaje)

---

## Tarjeta 1 · El CEO comercial

> *"Tenemos que conseguir más pacientes nuevos. ¿Por dónde tiramos?"*

**Pista del profesor (si el grupo se atasca)**: cuál canal escalaría más fácil sin reventar el ratio LTV/CAC.

---

## Tarjeta 2 · El pesimista

> *"Algo va mal con el marketing. No sé qué pero las cosas no van."*

**Pista**: mirar evolución temporal por canal. ¿Hay degradación silenciosa de algo?

---

## Tarjeta 3 · El equipo comercial cabreado

> *"Los asesores comerciales se quejan de que los leads que llegan no son de calidad. Pierden el tiempo."*

**Pista**: % de cierre lead → paciente, por canal. ¿De dónde vienen los leads malos?

---

## Tarjeta 4 · El CFO en presupuestos

> *"Tenemos que justificar el presupuesto de marketing del año que viene. El CEO me pide número."*

**Pista**: ROI por canal. ¿Cuál merece más inversión? ¿Cuál merece menos?

---

## Tarjeta 5 · El head de ventas

> *"La gente nos pregunta el precio pero no acaba reservando consulta. Algo en el funnel está roto."*

**Pista (truco)**: este objetivo NO se puede responder con el dataset mini — falta el funnel intermedio (lead → cualificado → cita). Buena oportunidad para que `/data-questions` pida los datos que faltan.

---

## Tarjeta 6 · El estratega ansioso

> *"Estamos perdiendo cuota frente a las clínicas low-cost. Hay que reaccionar."*

**Pista (truco)**: este objetivo tampoco se responde con el dataset mini — falta benchmark de competencia y datos de pricing. `/data-questions` debería pedir esa info.

---

## Cómo el profesor presenta el ejercicio

1. **Imprimir las 6 tarjetas** (una por tarjeta, papel grueso, A6 o similar)
2. **Reparto al azar** — meter en sobre o caja, cada grupo saca una
3. **NO dar las pistas** salvo que el grupo lleve 5+ min atascado
4. **30 min** para aplicar las 2 skills + preparar 1 frase de presentación
5. **Cierre (5 min)**: 1 grupo voluntario presenta su refinamiento al resto. Si nadie sale → llamas al grupo con la tarjeta 5 o 6 (las "truco") porque son las que mejor enseñan el límite de los datos.

## Outputs esperados por grupo

Al final del hands-on B, cada grupo entrega (verbal o en sticky):

- **3-5 preguntas refinadas** (output de `/data-questions`)
- **2-3 insights del dataset** (output de `/info-vs-insight`)
- **1 dato adicional que necesitarían** para tener respuesta completa
- **1 frase de "qué propondría al CEO" con lo que tienen ahora**
