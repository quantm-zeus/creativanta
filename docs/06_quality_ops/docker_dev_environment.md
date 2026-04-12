---
layer: quality_ops
canonical: true
source_file: impl_b7_docker_dev_environment.md
last_verified: 2026-03-30
---

# B7 — Docker Local Development Environment

> **Upstream**: Tech Stack ADR v3, Pack 09
> **Strategy**: Local Docker Compose for all services, hot-reload for app code

---

## 1. Architecture

```
┌──────────────────────────────────────────────────────────┐
│                    Local Development                      │
│                                                          │
│  apps/web (SvelteKit)  → localhost:5173 (Vite dev)       │
│  apps/api (Rust)       → localhost:3000 (cargo watch)    │
│  apps/admin (SvelteKit)→ localhost:5174 (Vite dev)       │
│  apps/mobile (Flutter) → emulator/device                 │
│                                                          │
│  ┌─ Docker Compose ──────────────────────────────────┐   │
│  │  postgres:17       → localhost:5432                │   │
│  │  dragonfly         → localhost:6379                │   │
│  │  meilisearch       → localhost:7700                │   │
│  │  activepieces      → localhost:8080                │   │
│  │  clickhouse        → localhost:8123 (HTTP)         │   │
│  │  mailpit           → localhost:8025 (UI)           │   │
│  │  jaeger            → localhost:16686 (UI)          │   │
│  │  minio             → localhost:9001 (Console)      │   │
│  │  grafana           → localhost:3001 (UI)           │   │
│  └───────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────┘
```

---

## 2. docker-compose.yml

```yaml
version: '3.8'

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
      AP_ENCRYPTION_KEY: dev_encryption_key_32chars_here!
      AP_JWT_SECRET: dev_jwt_secret_here_32chars_long!
      AP_EXECUTION_MODE: UNSANDBOXED  # ⚠️ DEV ONLY — production MUST use SANDBOXED mode. See security_threat_model.md.
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
      - "9000:9000"
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

-- Create application roles
DO $$
BEGIN
  IF NOT EXISTS (SELECT FROM pg_roles WHERE rolname = 'app_user') THEN
    CREATE ROLE app_user LOGIN PASSWORD 'dev_password_123';
  END IF;
END
$$;

GRANT ALL PRIVILEGES ON DATABASE creativanta_dev TO app_user;
```

---

## 4. Environment Files

### .env.development (apps/api)
```bash
# Database
DATABASE_URL=postgresql://creativanta:dev_password_123@localhost:5432/creativanta_dev
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
S3_ENDPOINT=http://localhost:9000
S3_ACCESS_KEY=minioadmin
S3_SECRET_KEY=minioadmin
S3_BUCKET=creativanta-dev
S3_PUBLIC_URL=http://localhost:9000/creativanta-dev
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
RUST_LOG=info,creativanta=debug
ENVIRONMENT=development
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

```bash
# Start all infrastructure
docker compose up -d

# Run Rust API (hot-reload)
cd apps/api && cargo watch -x run

# Run SvelteKit web (dev)
cd apps/web && npm run dev

# Run SvelteKit admin (dev)
cd apps/admin && npm run dev -- --port 5174

# Run Flutter mobile
cd apps/mobile && flutter run

# Generate protobuf code
./tooling/proto-gen.sh

# Run database migrations
cd apps/api && cargo run --bin migrate

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
	cd apps/api && cargo run --bin migrate

proto-gen:
	./tooling/proto-gen.sh

dev-api:
	cd apps/api && cargo watch -x run

dev-web:
	cd apps/web && npm run dev

dev-admin:
	cd apps/admin && npm run dev -- --port 5174

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
| Rust API | 3000 | http://localhost:3000 |
| PostgreSQL | 5432 | — |
| Dragonfly (Redis) | 6379 | — |
| Meilisearch | 7700 | http://localhost:7700 |
| ClickHouse HTTP | 8123 | — |
| Activepieces | 8080 | http://localhost:8080 |
| Mailpit UI | 8025 | http://localhost:8025 |
| Mailpit SMTP | 1025 | — |
| Jaeger UI | 16686 | http://localhost:16686 |
| OTLP Collector | 4317 | — |
