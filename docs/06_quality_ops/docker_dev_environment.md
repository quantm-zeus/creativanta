---
layer: quality_ops
canonical: true
source_file: impl_b7_docker_dev_environment.md
last_verified: 2026-03-30
last_updated: 2026-10-30
---

# B7 — Docker Local Development Environment

> **Upstream**: Tech Stack ADR v4, Pack 09
> **Strategy**: Local Docker Compose for all services, hot-reload for app code

---

## 1. Architecture

```
┌──────────────────────────────────────────────────────────┐
│                    Local Development                      │
│                                                          │
│  apps/web (SvelteKit)  → localhost:5173 (Vite dev)       │
│  apps/api (Go)       → localhost:3000 (go run ./cmd/api --env-file .env.api.development)    │
│  apps/admin (SvelteKit)→ localhost:5174 (Vite dev)       │
│  apps/mobile (Flutter) → emulator/device                 │
│                                                          │
│  ┌─ Docker Compose ──────────────────────────────────┐   │
│  │  timescaledb-ha:pg17 → localhost:5432              │   │
│  │  dragonfly         → localhost:6379                │   │
│  │  meilisearch       → localhost:7700                │   │
│  │  activepieces      → localhost:8080                │   │
│  │  clickhouse        → localhost:8123 (HTTP)         │   │
│  │  mailpit           → localhost:8025 (UI)           │   │
│  │  jaeger            → localhost:16686 (UI)          │   │
│  │  minio             → localhost:9002 (S3) / 9001 (Console) │   │
│  │  grafana           → localhost:3001 (UI)           │   │
│  └───────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────┘
```

---

## 2. docker-compose.yml

This is the local infrastructure recipe, not a production deployment file. Phase P0 must pin image versions/digests and commit an extracted executable Compose/init/migration setup after a clean-start test; `latest` below is a candidate only and cannot pass the dependency-lock gate. Later-phase services may be behind Compose profiles. Do not use the migration/admin/outbox credential in the API container. API startup must refuse superuser/BYPASSRLS/owner roles and verify required policies/grants.


```yaml
# Note: 'version' field is obsolete in modern Docker Compose (v2+) and can be omitted.
# Retained here for backward compatibility with Docker Compose v1.

services:
  postgres:
    image: timescale/timescaledb-ha:pg17
    container_name: creativanta-db
    ports:
      - "5432:5432"
    environment:
      POSTGRES_USER: creativanta
      POSTGRES_PASSWORD: dev_password_123
      POSTGRES_DB: creativanta_dev
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./infra/init-extensions.sql:/docker-entrypoint-initdb.d/01-extensions.sql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U creativanta"]
      interval: 5s
      timeout: 3s
      retries: 5

  dragonfly:
    image: docker.dragonflydb.io/dragonflydb/dragonfly:latest
    container_name: creativanta-cache
    ports:
      - "6379:6379"
    ulimits:
      memlock: -1

  meilisearch:
    image: getmeili/meilisearch:latest
    container_name: creativanta-search
    ports:
      - "7700:7700"
    environment:
      MEILI_MASTER_KEY: dev_meili_key_123
      MEILI_ENV: development
    volumes:
      - meili_data:/meili_data

  clickhouse:
    image: clickhouse/clickhouse-server:latest
    container_name: creativanta-olap
    ports:
      - "8123:8123"
      - "9000:9000"
    volumes:
      - clickhouse_data:/var/lib/clickhouse

  activepieces:
    image: activepieces/activepieces:latest
    container_name: creativanta-workflows
    ports:
      - "8080:80"
    environment:
      AP_ENGINE_EXECUTABLE_PATH: dist/packages/engine/main.js
      AP_ENVIRONMENT: dev
      AP_FRONTEND_URL: http://localhost:8080
      AP_WEBHOOK_TIMEOUT_SECONDS: 30
      AP_POSTGRES_DATABASE: activepieces_dev
      AP_POSTGRES_HOST: postgres
      AP_POSTGRES_PORT: 5432
      AP_POSTGRES_USERNAME: creativanta
      AP_POSTGRES_PASSWORD: dev_password_123
      AP_REDIS_HOST: dragonfly
      AP_REDIS_PORT: 6379
      AP_ENCRYPTION_KEY: 00000000000000000000000000000000 # local-only hex; inject real secret
      AP_JWT_SECRET: 1111111111111111111111111111111111111111111111111111111111111111 # local only
      AP_EXECUTION_MODE: UNSANDBOXED  # ⚠️ DEV ONLY — production requires a version-verified isolated execution mode and resource/network limits; see activepieces_integration.md.
    depends_on:
      postgres:
        condition: service_healthy
      dragonfly:
        condition: service_started

  mailpit:
    image: axllent/mailpit:latest
    container_name: creativanta-mail
    ports:
      - "1025:1025"
      - "8025:8025"

  jaeger:
    image: jaegertracing/all-in-one:latest
    container_name: creativanta-trace
    ports:
      - "6831:6831/udp"
      - "16686:16686"
      - "4317:4317"
    environment:
      COLLECTOR_OTLP_ENABLED: true

  minio:
    image: minio/minio:latest
    container_name: creativanta-storage
    command: server /data --console-address ":9001"
    ports:
      - "9002:9000" # S3 API on 9002 (9000 used by ClickHouse native protocol)
      - "9001:9001"
    environment:
      MINIO_ROOT_USER: minioadmin
      MINIO_ROOT_PASSWORD: minioadmin
    volumes:
      - minio_data:/data

  grafana:
    image: grafana/grafana:latest
    container_name: creativanta-grafana
    ports:
      - "3001:3000"
    environment:
      GF_SECURITY_ADMIN_PASSWORD: admin
      GF_AUTH_ANONYMOUS_ENABLED: true
    volumes:
      - grafana_data:/var/lib/grafana

volumes:
  postgres_data:
  meili_data:
  clickhouse_data:
  minio_data:
  grafana_data:
```

---

## 3. PostgreSQL Init Script

```sql
-- infra/init-extensions.sql
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
CREATE EXTENSION IF NOT EXISTS "vector";        -- pgvector (included in timescaledb-ha image)
CREATE EXTENSION IF NOT EXISTS "pg_trgm";       -- trigram search
CREATE EXTENSION IF NOT EXISTS "timescaledb";   -- time-series hypertables (Audit v5 — M8: was commented out)

-- Create Activepieces database
CREATE DATABASE activepieces_dev;

-- Local-only credentials; production uses separate injected secrets.
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'app_user') THEN
    CREATE ROLE app_user LOGIN PASSWORD 'dev_app_password' NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOBYPASSRLS;
  END IF;
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'admin_user') THEN
    CREATE ROLE admin_user LOGIN PASSWORD 'dev_admin_password' NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOBYPASSRLS;
  END IF;
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'outbox_poller') THEN
    CREATE ROLE outbox_poller LOGIN PASSWORD 'dev_outbox_password' NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT BYPASSRLS;
  END IF;
END
$$;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
GRANT CONNECT ON DATABASE creativanta_dev TO app_user, admin_user, outbox_poller;
GRANT USAGE ON SCHEMA public TO app_user, admin_user, outbox_poller;
-- No blanket table/default grants. Each migration applies the installed-table
-- allowlist and immutable-record guards owned by database_schema.md §26.

```

---

## 4. Environment Files

### Role-scoped Go process configuration (apps/api)

Go does not automatically load dotenv files. P0 implements an explicit development-only `--env-file` flag in each command; it reads only the named role-specific file and validates the allowed configuration keys/DB role. Production receives injected environment/secrets and rejects development dotenv loading. Never create or source a combined file containing credentials for every role. All env files below are local-only templates, ignored by Git; the implementation commits sanitized examples only.

### .env.api.development (public API / ordinary worker)
```bash
# Database
DATABASE_URL=postgresql://app_user:dev_app_password@localhost:5432/creativanta_dev
DATABASE_POOL_SIZE=20

# Cache
REDIS_URL=redis://localhost:6379

# Search
MEILISEARCH_URL=http://localhost:7700
MEILISEARCH_KEY=dev_meili_key_123

# ClickHouse
CLICKHOUSE_URL=http://localhost:8123
CLICKHOUSE_DB=creativanta_analytics

# Activepieces
ACTIVEPIECES_URL=http://localhost:8080
ACTIVEPIECES_API_KEY=dev_key

# Auth (Clerk)
CLERK_SECRET_KEY=sk_test_xxx
CLERK_PUBLISHABLE_KEY=pk_test_xxx
CLERK_WEBHOOK_SECRET=whsec_xxx

# AI Providers (v1: Gemini primary)
GEMINI_API_KEY=xxx
OPENAI_API_KEY=xxx  # fallback
AI_DEFAULT_PROVIDER=gemini
AI_DEFAULT_MODEL=gemini-2.5-flash

# Storage (local dev uses MinIO as S3-compatible; production uses Cloudflare R2)
S3_ENDPOINT=http://localhost:9002
S3_ACCESS_KEY=minioadmin
S3_SECRET_KEY=minioadmin
S3_BUCKET=creativanta-dev
S3_PUBLIC_URL=http://localhost:9002/creativanta-dev
# Production overrides (R2):
# R2_ACCOUNT_ID=xxx
# R2_ACCESS_KEY=xxx
# R2_SECRET_KEY=xxx
# R2_BUCKET=creativanta-dev
# R2_PUBLIC_URL=https://storage.creativanta.app

# Email (dev → mailpit)
SMTP_HOST=localhost
SMTP_PORT=1025
SMTP_FROM=noreply@creativanta.app

# Observability
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4317
SENTRY_DSN=

# Server
HOST=0.0.0.0
PORT=3000
LOG_LEVEL=debug
ENVIRONMENT=development
```

### .env.migrate.development (migration command only)
```bash
MIGRATION_DATABASE_URL=postgresql://creativanta:dev_password_123@localhost:5432/creativanta_dev
```

### .env.admin.development (internal admin command only)
```bash
ADMIN_DATABASE_URL=postgresql://admin_user:dev_admin_password@localhost:5432/creativanta_dev
HOST=127.0.0.1
PORT=3002
# Inject separate internal-admin identity/MFA and trusted proxy configuration.
```

### .env.outbox.development (dispatcher only)
```bash
OUTBOX_DATABASE_URL=postgresql://outbox_poller:dev_outbox_password@localhost:5432/creativanta_dev
REDIS_URL=redis://localhost:6379
```

### .env.development (apps/web)
```bash
PUBLIC_API_URL=http://localhost:3000
PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_xxx
PUBLIC_POSTHOG_KEY=
PUBLIC_POSTHOG_HOST=
```

---

## 5. Development Commands

All commands below run from a fresh terminal at the repository root unless stated otherwise. P0 creates the named Go module, command packages, configuration flags, Compose file and codegen scripts; these are implementation instructions, not evidence they currently exist. The migration wrapper uses Goose and resolves infra/migrations from the repository root regardless of working directory. Public API supports `/health` and `/ready`; deployment must preserve HTTP/2 for mobile gRPC. The internal admin listener uses port 3002 locally and is never published through the customer API proxy.

```bash
# Start all infrastructure
docker compose up -d

# Run Go API (restart after edits; optional pinned watcher at P0)
cd apps/api && go run ./cmd/api --env-file .env.api.development

# Run other Go processes in separate terminals from apps/api:
# go run ./cmd/worker --env-file .env.api.development
# go run ./cmd/admin-api --env-file .env.admin.development
# go run ./cmd/outbox --env-file .env.outbox.development

# Run SvelteKit web (dev)
cd apps/web && pnpm dev

# Run SvelteKit admin (dev)
cd apps/admin && pnpm dev -- --port 5174

# Run Flutter mobile
cd apps/mobile && flutter run

# Generate protobuf code
./tooling/proto-gen.sh

# Run database migrations
cd apps/api && go run ./cmd/migrate --env-file .env.migrate.development up

# Stop all
docker compose down

# Full reset (data included)
docker compose down -v
```

---

## 6. Makefile Shortcuts

```makefile
.PHONY: up down reset db-migrate proto-gen dev-api dev-web dev-admin dev-mobile

up:
	docker compose up -d

down:
	docker compose down

reset:
	docker compose down -v && docker compose up -d

db-migrate:
	cd apps/api && go run ./cmd/migrate --env-file .env.migrate.development up

proto-gen:
	./tooling/proto-gen.sh

dev-api:
	cd apps/api && go run ./cmd/api --env-file .env.api.development

dev-web:
	cd apps/web && pnpm dev

dev-admin:
	cd apps/admin && pnpm dev -- --port 5174

dev-mobile:
	cd apps/mobile && flutter run

logs:
	docker compose logs -f

status:
	docker compose ps
```

---

## 7. Port Map

| Service | Port | UI |
|---|---|---|
| SvelteKit Web | 5173 | http://localhost:5173 |
| SvelteKit Admin | 5174 | http://localhost:5174 |
| Go API | 3000 | http://localhost:3000 |
| Go internal admin API (private) | 3002 | http://127.0.0.1:3002 |
| PostgreSQL | 5432 | — |
| Dragonfly (Redis) | 6379 | — |
| Meilisearch | 7700 | http://localhost:7700 |
| ClickHouse HTTP | 8123 | — |
| Activepieces | 8080 | http://localhost:8080 |
| Mailpit UI | 8025 | http://localhost:8025 |
| Mailpit SMTP | 1025 | — |
| Jaeger UI | 16686 | http://localhost:16686 |
| OTLP Collector | 4317 | — |
| MinIO S3 API | 9002 | — |
| MinIO Console | 9001 | http://localhost:9001 |
| Grafana | 3001 | http://localhost:3001 |
