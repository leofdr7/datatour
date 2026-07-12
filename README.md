# DataTour       -------------REGISTRA TOUR-----------------

Infraestructura de datos turísticos compartida para El Salvador.

En vez de construir otra app final para el turista, DataTour centraliza la información dispersa de lugares, eventos y microemprendedores turísticos en una base de datos estándar con una API REST que cualquier aplicación de turismo puede consumir.

## El problema

En El Salvador, los datos turísticos están dispersos en Excel, PDFs, formularios y redes sociales, sin ningún estándar común. Cada nuevo proyecto de turismo debe empezar desde cero recolectando y limpiando los mismos datos, dejando fuera a los microemprendedores que no tienen forma de aparecer digitalmente en ningún lado.

## La solución

Una base de datos centralizada con esquema estándar (lugares, eventos, emprendedores) y una API REST simple, más un canal de registro por WhatsApp para incluir a microemprendedores sin conocimientos técnicos.

## ¿Para quién es esto?

| Actor | Valor que recibe |
|---|---|
| Equipos del hackathon y startups de turismo | Ahorran el trabajo de conseguir, limpiar y estructurar datos turísticos, consumiendo la API directamente. |
| Gobiernos locales e instituciones | Tienen un espacio donde subir datos turísticos y ver que se reutilizan en múltiples soluciones. |
| Microemprendedores turísticos | Logran estar presentes en el hub con una ficha estándar, incluso sin saber programar, solo escribiendo por WhatsApp. |

## Stack técnico

- **Backend:** Supabase (Postgres + Edge Functions)
- **Automatización:** n8n + Twilio WhatsApp Sandbox + Anthropic API Key Claude Haiku 4.5
- **Control de versiones:** GitHub — repositorio `datatour`
- **Frontend demo:** React + Tailwind CSS, consumiendo directamente los endpoints de producción

## Esquema de base de datos

### `places`
Lugares turísticos: cultura, ecoturismo, gastronomía, creativo.

`id, nombre, tipo, descripcion_corta, ciudad, lat, long, horario, precio_aproximado, accesibilidad, tags, nivel_confianza, ultima_verificacion, created_at`

### `events`
Eventos y actividades vinculadas a un lugar.

`id, nombre, fecha_hora, place_id, tipo_actividad, cupo, organizador, created_at`

### `providers`
Microemprendedores turísticos registrados, principalmente vía WhatsApp.

`id, nombre, contacto, redes_sociales, servicios, nivel_visibilidad, place_id, created_at`

### `feedback_log`
Registro de señales de actualización sobre un lugar (confirmado abierto, reportado cerrado, info desactualizada).

`id, place_id, senial, fuente_app, created_at`

> Un trigger recalcula automáticamente el `nivel_confianza` del lugar según los reportes de los últimos 30 días.

### `pending_registrations`
Memoria conversacional temporal para completar el registro de un emprendedor por WhatsApp cuando falta información.

`from_number, datos_parciales, updated_at`

> Se combina con cada mensaje nuevo del mismo número hasta que el registro tenga nombre y servicios completos, momento en el cual se inserta en `providers` y se elimina de esta tabla.

**Seguridad:** Row Level Security habilitado en todas las tablas, con políticas públicas de lectura y de inserción/actualización donde corresponde.

## API

**Base URL:**
```
https://erojbnboasliaellrlsf.supabase.co/functions/v1/
```

**Autenticación:** header `Authorization: Bearer <ANON_KEY>` requerido en todos los endpoints.

| Método | Ruta | Parámetros / Body | Estado |
|---|---|---|---|
| GET | `/lugares` | `categoria`, `ciudad` | En producción |
| GET | `/eventos` | `fecha` | En producción |
| GET | `/emprendimientos` | `tipo`, `nivel_visibilidad` | En producción |
| POST | `/feedback` | `place_id`, `senial`, `fuente_app` | En producción |

### Ejemplo de uso

```bash
curl -X GET \
  "https://erojbnboasliaellrlsf.supabase.co/functions/v1/lugares?ciudad=San+Salvador" \
  -H "Authorization: Bearer <ANON_KEY>"
```

## Registro de emprendedores por WhatsApp

Un emprendedor escribe una descripción de su negocio en lenguaje natural por WhatsApp. El sistema normaliza esa descripción al esquema de `providers` y, si falta el nombre o los servicios, responde pidiendo específicamente esa información antes de completar el registro.

**Flujo:**

1. El mensaje llega por el webhook de WhatsApp y se filtran duplicados.
2. Se busca si existe un registro pendiente previo para ese número.
3. Se normaliza el mensaje combinando la información previa con el mensaje nuevo, sin perder datos ya confirmados.
4. Si el registro queda completo, se guarda como un nuevo emprendedor y se elimina el pendiente.
5. Si falta información, se guarda como pendiente y se le pide al usuario específicamente lo que falta.
6. En ambos casos se envía una respuesta breve y amigable en español, sin lenguaje técnico.

**Reglas de respuesta:**

- El mensaje final al usuario es siempre texto plano, sin JSON ni formato técnico visible.
- Si el registro está completo, se confirma mencionando el nombre del negocio, sin pedir información adicional.
- Si falta información esencial, se pide únicamente lo que falta, de forma cálida y natural.

**Limitación actual:** el canal usa un número de pruebas de WhatsApp con límite de mensajes diarios y expiración por inactividad; pasar a un número de producción requeriría verificación de negocio con Meta.

## Estado actual

**Completado**
- [x] Diseño del esquema de base de datos
- [x] Base de datos y datos de ejemplo
- [x] Los 4 endpoints de la API desplegados y probados
- [x] Sistema de confianza/feedback en producción
- [x] Registro de emprendedores por WhatsApp con memoria conversacional, validado de punta a punta
- [x] Implementación con el frontend de la hackatón 
- [x] Cooperación y coworking de la hackatón con feedback y opiniones cooperativas de los mentores

