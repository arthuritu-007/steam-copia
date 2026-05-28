# Backend (Spring Boot)

## Requisitos

- Java 17+
- Maven (o usar tu IDE con soporte Maven)
- Postgres (recomendado vía Docker Compose en `infra/`)

## Configuración

Variables soportadas (con defaults de desarrollo):

- `DB_URL` (default `jdbc:postgresql://localhost:5432/steam_copia`)
- `DB_USER` (default `steam`)
- `DB_PASSWORD` (default `steam`)
- `JWT_SECRET` (default `change-me-in-dev`, debe tener 32+ caracteres)
- `JWT_ISSUER` (default `steam-copia`)
- `JWT_ACCESS_MINUTES` (default `60`)
- `APP_SEED` (default `false`, si `true` crea un admin y un juego de ejemplo)

## Endpoints (MVP)

- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/store/games`
- `GET /api/store/games/{slug}`
- `POST /api/purchase` (requiere token)
- `GET /api/library` (requiere token)
- `GET /api/wishlist` (requiere token)
- `POST /api/wishlist/{gameId}` (requiere token)
- `DELETE /api/wishlist/{gameId}` (requiere token)
- `POST /api/admin/games` (requiere token admin)

