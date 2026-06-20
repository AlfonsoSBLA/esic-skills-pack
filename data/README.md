# data/ — Datasets del curso (Hospital Capilar anonimizado)

Todos los datasets son del mismo caso anonimizado, sirven a las 14 skills y a los dos circuitos (adquisición + retención) del trabajo grupal.

## Datasets disponibles

| Archivo | Usado en | Contenido | Estado |
|---------|----------|-----------|--------|
| `hospital-capilar-mini.csv` | S1 | 36 filas (12 meses × 3 canales: Google Ads, Meta Ads, Orgánico). Columnas: mes, canal, leads, pacientes, gasto_eur, ingresos_eur | ✅ Listo |
| `hospital-capilar-context.md` | S1, S5 | Contexto de negocio HC (modelo, canales, estacionalidad, equipo, KPIs CEO) + lo que NO está en el dataset | ✅ Listo |
| `tarjetas-objetivos.md` | S1 | 6 tarjetas de objetivos vagos para hands-on B (una por grupo). Incluye 2 con "truco" (no se resuelven con dataset mini → ejercicio sobre límites de los datos) | ✅ Listo |
| `leads-mock.csv` | S2 | Leads simulados para Zaps (50-100 filas) | 🔴 Pendiente |
| `hospital-capilar-acquisition.csv` | S3 | Funnel adquisición: impresiones, clicks, leads, conversiones por canal y mes (12-24 meses) | 🔴 Pendiente |
| `hospital-capilar-customers.csv` | S4 | Base de clientes: customer_id, last_purchase_date, total_orders, total_spent, source | 🔴 Pendiente |
| `hospital-capilar-cohorts.csv` | S4 | Cohortes mensuales con retención por mes | 🔴 Pendiente |

## Insights enterrados en hospital-capilar-mini.csv (para el profesor)

El dataset tiene varios insights diseñados para que los alumnos los descubran con `/info-vs-insight`:

1. **Meta Ads es trampa de vanidad** — CR_lead_to_paciente del 1.2% (vs Google 8.7%, Orgánico 28.5%). Genera el 44% de los leads pero solo 17% de los pacientes
2. **Orgánico es campeón silencioso** — Ratio LTV/CAC ≈ 280x. Aporta 49% de pacientes con menos de 1% del gasto
3. **Google Ads CAC sube en pico estacional** — De ~2.250€ (ene-mar) a ~2.850€ (sep-oct) por saturación de auction
4. **Estacionalidad clara** — Agosto mínimo (todo cae a la mitad), sep-oct pico (vuelta vacaciones, ventana ideal)
5. **CR Meta cayendo** — Q1: 1.7% medio. Q4: 1.2% medio. Posible fatiga de audiencia

## Trampas de vanidad intencionales

- "Meta generó 3.260 leads" (es vanidad — solo 40 cerraron)
- "Octubre 380 leads de Meta" (es vanidad — CR 1.1%, solo 4 pacientes)
- "Google gastó 283.500€" (sin contexto de retorno no decide nada)

## Reglas de anonimización

- Sin nombres reales de clientes ni emails reales
- IDs reemplazados por UUIDs o secuenciales
- Cifras reales en orden de magnitud (o escaladas por factor constante)
- Fechas desplazadas por offset constante
- Sin información sensible
- Distribuciones realistas (no datos perfectos)

## Origen

Hospital Capilar es cliente activo de Growth4U. Datos exportados de su CRM y dashboards con permiso del equipo HC para uso académico.
