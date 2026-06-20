# Hospital Capilar — Contexto de negocio (anonimizado)

## Qué es

Clínica de **injertos capilares FUE** (técnica de extracción folicular). Sector ticket alto, decisión emocional + racional, ciclo de venta largo (3-12 semanas desde primer contacto).

- **Mercado**: España, sede principal en Madrid + delegaciones en Barcelona y Sevilla
- **Servicio principal**: trasplante capilar FUE (3.000-7.000€ por intervención)
- **Servicio secundario**: tratamientos farmacológicos (Minoxidil, Finasteride) y mesoterapia
- **Equipo médico**: 4 cirujanos, 12 técnicos de injerto, 3 asesores comerciales

## Modelo de negocio

```
Lead (formulario web / WhatsApp / llamada)
    ↓
Lead cualificado (asesor comercial valida que es candidato real)
    ↓
Cita presencial (diagnóstico médico gratuito)
    ↓
Presupuesto (3-7k€ según número de injertos)
    ↓
Paciente cerrado (paga reserva del 30%)
    ↓
Intervención (3-12 semanas tras cerrar)
    ↓
Postoperatorio (12 meses de seguimiento)
```

**Ticket medio**: 3.500€  ·  **Margen bruto**: ~60%  ·  **LTV ~3-12 meses**

## Canales de adquisición actuales

| Canal | Naturaleza | Comentario |
|-------|------------|------------|
| **Google Ads** | Performance, búsqueda intencional | "trasplante capilar madrid", "FUE precio" |
| **Meta Ads** | Awareness + retargeting, audiencia amplia | Imagen + video, mucho volumen pero conversión variable |
| **Orgánico** | SEO + content marketing + boca-oreja | Blog, casos de éxito, referidos pacientes |

## Equipo y estructura

- **CMO**: dirige marketing (estrategia + ejecución agencia)
- **Agencia externa**: gestiona Google Ads y Meta Ads
- **Content manager interno**: blog + SEO + redes sociales
- **3 asesores comerciales**: gestionan leads, validan calidad, cierran ventas
- **CRM**: HubSpot Pro

## Estacionalidad típica del sector

- **Enero-Marzo**: baseline (gente pensando en cambios año nuevo)
- **Abril-Mayo**: ligera subida (pre-verano, pero solo si la intervención cabe antes de junio)
- **Junio-Julio**: caída (vacaciones, no quieren operarse en verano por sol)
- **Agosto**: mínimo (todo cerrado, gente en vacaciones)
- **Septiembre-Octubre**: **pico anual** (vuelta vacaciones, ventana ideal para ver resultados en febrero)
- **Noviembre**: secundario alto
- **Diciembre**: bajada navideña

## KPIs que el CEO mira cada mes

1. Pacientes nuevos cerrados
2. Revenue total
3. CAC blended (gasto marketing / pacientes nuevos)
4. % cierre de leads cualificados → pacientes
5. Ratio LTV/CAC por canal (objetivo: 3x mínimo)

## Lo que NO está en el dataset mini

El dataset `hospital-capilar-mini.csv` incluye solo agregados mensuales por canal (leads, pacientes, gasto, ingresos). **NO incluye**:

- Datos del funnel intermedio (cualificación, citas, presupuestos)
- Datos demográficos de pacientes
- Datos de competencia
- Datos de retención / segunda intervención
- Reviews / NPS
- Datos del equipo comercial (qué asesor cierra mejor)

Esto es **intencional** — parte del ejercicio en S1 es que detectéis qué datos os faltan para responder según vuestro objetivo.
