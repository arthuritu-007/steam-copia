# Steam Copia (Proyecto personal)

Clon educativo inspirado en Steam: tienda, biblioteca y compras.

## Stack

- Frontend: Flutter
- Backend: Spring Boot (API REST + JWT)
- Base de datos: PostgreSQL (migraciones con Flyway)

## Estructura

- `backend/`: API Spring Boot
- `frontend/`: App Flutter
- `infra/`: Docker Compose (Postgres)

## Arranque rápido (local)

1. Levanta Postgres:

   - `docker compose -f infra/docker-compose.yml up -d`

2. Backend:

   - Configura variables de entorno (ver `backend/src/main/resources/application.yml`)
   - Ejecuta el backend con Maven/IDE.

3. Frontend:

   - Configura `API_BASE_URL` dentro de la app (ver `frontend/lib/config.dart`)
   - Ejecuta con `flutter run`.

