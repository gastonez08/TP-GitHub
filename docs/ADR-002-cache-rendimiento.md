# ADR-002: Mitigación de latencia en consultas mediante Caching con Redis

* **Estado:** Aceptado
* **Fecha:** 2026-06-15
* **Decisores:** Gaston Romero, Leonardo Ferreira
* **Relacionado:** #18 (Issue), ADR-001, spec-informes-agenda

## Contexto
### Qué problema se está resolviendo
Al listar eventos públicos, aplicar filtros masivos de eventos futuros/pasados y renderizar las agendas públicas de congresos multitudinarios, las consultas SQL optimizadas a la base de datos empiezan a presentar latencias altas debido al alto tráfico de lectura recurrente de datos que rara vez cambian durante el día del evento.

### Qué restricciones aplican
* **Técnica:** El tiempo de respuesta de la interfaz web para usuarios anónimos que consultan la cartelera de eventos debe ser inferior a 200ms para asegurar la accesibilidad desde cualquier dispositivo móvil.

## Decisión
Se decide incorporar una capa de caché en memoria utilizando **Redis** implementando la estrategia *Cache-Aside* con un tiempo de vida (TTL) controlado.

### Alcance
* **Cubre:** Listados públicos de eventos, agendas consolidadas de congresos activos y datos públicos de disertantes.
* **No cubre:** El proceso crítico de inscripción ni la generación en tiempo real de certificados.

### Alternativas consideradas
* **Opción A: Redis**
  * *Pros:* Velocidad extrema de lectura (sub-milisegundo), soporte nativo para expiración de llaves (TTL), estructura de datos en memoria madura.
  * *Contras:* Agrega un componente extra a la infraestructura y complejidad de sincronización de datos.
* **Opción B: Incrementar hardware de la DB (Escala Vertical)**
  * *Pros:* Sin cambios en el código de la aplicación.
  * *Contras:* Costo financiero elevado y no resuelve el problema de fondo ante picos de tráfico concurrentes masivos durante el inicio de las jornadas.

## Consecuencias
### Beneficios esperados
* Reducción drástica (superior al 70%) de la carga de lectura en PostgreSQL.
* Latencia de carga de la página principal inferior a los límites establecidos.

### Costos o riesgos aceptados
* Consistencia eventual: si un organizador modifica un dato menor de la agenda, este podría tardar hasta la expiración del TTL en verse reflejado en la web pública si no se dispara una invalidación explícita.

## Plan de implementación
### Pasos mínimos para ejecutarla
1. Levantar instancia de Redis en el entorno de staging/desarrollo.
2. Implementar un decorador o middleware en el backend para interceptar consultas a `/api/v1/eventos/publicos`.
3. Establecer un TTL por defecto de 15 minutos para las búsquedas.
### Dependencias
* Servidor Redis e integración de cliente Redis en el backend.

## Métrica de éxito
* Lograr un *Cache Hit Ratio* superior al 80% en las vistas del listado público de eventos.

## Triggers de revisión
* Errores recurrentes de desincronización crítica de datos informados por los organizadores del evento.
* **Fecha sugerida de revisión:** 2026-12-15