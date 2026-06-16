# ADR-003: Implementación de Autenticación mediante JWT

**Estado:** Aceptado  
**Fecha:** 2026-06-16  
**Decisores:** Leonardo Ferreira  
**Relacionado:** #17, #18  

## Contexto
El Sistema de Gestión de Eventos Académicos (SGEA) requiere un esquema de autenticación robusto y desacoplado para comunicar el Frontend (Next.js 14) con el Backend (Django Rest Framework). Necesitamos asegurar que el control de acceso sea eficiente y "stateless" (sin estado) para no sobrecargar el servidor backend ni la base de datos PostgreSQL con sesiones persistentes tradicionales ante ráfagas concurrentes de usuarios.

## Decisión
Se decide implementar un sistema de autenticación basado en **JSON Web Tokens (JWT)**. Cada vez que un usuario (Organizador, Disertante o Participante) inicie sesión con éxito, el servidor backend generará un par de tokens (Access Token de corta duración y Refresh Token de larga duración) firmados criptográficamente. El cliente almacenará estos tokens de forma segura y los enviará en el encabezado `Authorization: Bearer <token>` en cada petición.

## Alternativas consideradas
* **Opción A: Autenticación tradicional basada en Sesiones (Cookies de Django):** Ofrece buena seguridad nativa, pero dificulta la escalabilidad horizontal y rompe el paradigma desacoplado de una API REST pura al obligar al servidor a mantener el estado de cada sesión en memoria o base de datos.
* **Opción B: API Keys estáticas:** Descartado por representar un riesgo crítico de seguridad en aplicaciones del lado del cliente, ya que si una clave es interceptada, el acceso no expira automáticamente.

## Consecuencias
* **Beneficios esperados:** Escalabilidad mejorada en el backend, desacoplamiento absoluto de la API y compatibilidad nativa con múltiples plataformas.
* **Costos o riesgos que se aceptan:** Se introduce la necesidad de gestionar de manera estricta la seguridad de los tokens en el cliente para prevenir ataques XSS (Cross-Site Scripting) mediante el uso de cookies HttpOnly.

## Plan de implementación
1. Instalar la librería `djangorestframework-simplejwt` en el entorno de desarrollo.
2. Configurar las variables del ciclo de vida del token en el archivo `settings.py`.
3. Crear los endpoints correspondientes para el login, actualización de token y cierre de sesión.

## Métrica de éxito
Validación inmediata del token en el backend sin necesidad de realizar consultas extras a la base de datos PostgreSQL, manteniendo los tiempos de respuesta por debajo de los 40ms por petición.
