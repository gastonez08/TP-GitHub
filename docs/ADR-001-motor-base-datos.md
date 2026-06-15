# ADR-001: Elección de PostgreSQL como motor de base de datos relacional

* **Estado:** Aceptado
* **Fecha:** 2026-06-15
* **Decisores:** Gaston Romero, Leonardo Ferreira
* **Relacionado:** #17 (Issue), project.md, spec-gestion-eventos

## Contexto
### Qué problema se está resolviendo
Se requiere definir el sistema de almacenamiento persistente para la plataforma de eventos académicos. El sistema debe soportar con seguridad transacciones críticas como la inscripción de participantes con cupos limitados y asignación estricta de roles (organizador, participante, disertante).

### Qué restricciones aplican
* **Negocio:** El presupuesto inicial es limitado (se prefieren tecnologías Open Source con amplio soporte).
* **Técnica:** Es mandatorio asegurar la consistencia total de los datos al momento de reservar cupos concurrentes en eventos de alta demanda.
* **Datos de proyecto:** De acuerdo a las specs, existen relaciones complejas entre usuarios, inscripciones, roles y emisión de certificados.

## Decisión
Se decide utilizar **PostgreSQL** como el motor de base de datos relacional principal del proyecto.

### Alcance
* **Cubre:** Almacenamiento de transacciones de usuarios, eventos, acreditaciones, logs de auditoría y estados de certificados.
* **No cubre:** Almacenamiento de archivos binarios (los certificados PDFs generados irán a un Object Storage independiente).

### Alternativas consideradas
* **Opción A: PostgreSQL**
  * *Pros:* Cumplimiento estricto de propiedades ACID, soporte robusto para consultas SQL complejas necesarias para reportes, excelente manejo de concurrencia mediante MVCC.
  * *Contras:* Escalabilidad horizontal más compleja de configurar inicialmente en comparación con NoSQL.
* **Opción B: MongoDB (NoSQL)**
  * *Pros:* Esquema flexible, escalabilidad horizontal nativa.
  * *Contras:* Dificultades para asegurar transacciones ACID robustas multi-documento de forma nativa sin penalizar el rendimiento, falta de joins eficientes para la generación de reportes matriciales.

## Consecuencias
### Beneficios esperados
* Integridad referencial garantizada para el negocio (evita la sobreventa de cupos).
* Capacidad nativa de realizar consultas SQL ad-hoc complejas para los informes de agenda del evento.

### Costos o riesgos aceptados
* Las migraciones de esquema futuras (*schema migrations*) pueden requerir planificación y ventanas de mantenimiento a medida que el sistema crezca.

## Plan de implementación
### Pasos mínimos para ejecutarla
1. Configurar contenedor Docker oficial de PostgreSQL 16 en el entorno de desarrollo local.
2. Configurar la herramienta de migraciones en el backend para la creación de tablas relacionales iniciales.
### Dependencias
* Driver de conexión del backend/ORM seleccionado.

## Métrica de éxito
* Cero inconsistencias o duplicaciones de registros en inscripciones concurrentes que alcancen el cupo máximo.

## Triggers de revisión
* Necesidad de almacenar volúmenes masivos de datos no estructurados que degraden el rendimiento general de las lecturas transaccionales.
* **Fecha sugerida de revisión:** 2027-01-15