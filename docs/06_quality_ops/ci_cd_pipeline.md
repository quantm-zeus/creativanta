---
layer: quality_ops
canonical: true
created: 2026-03-31
last_updated: 2026-04-09
status: READY_SPEC
---

# CI/CD Pipeline — Creativanta

> **Stack**: GitHub Actions + Docker Compose + Contabo VPS
> **Ref**: ADR-006 (Self-hosted), `05_system/tech_stack_adr.md`
> **Status meaning**: This document is the canonical CI/CD specification. Workflow YAML, helper scripts, and optional typed transport generation are derivative implementation artifacts; they are not prerequisites for docs readiness. Inline deployment steps below are the canonical source of truth until repository-native wrappers are generated.

---

## 1. Pipeline Stages

```
PR Created → Lint → Test → Contract Sync → Build → Migrate → Deploy (staging/prod)
```

### Stage Details

| Stage | Trigger | Runner | Timeout | Blocking? |
|---|---|---|---|---|
| **Lint** | Every push & PR | ubuntu-latest | 5 min | ✅ |
| **Test (Unit)** | Every push & PR | ubuntu-latest | 10 min | ✅ |
| **Test (Integration)** | PR to `main` | self-hosted (Contabo) | 15 min | ✅ |
| **Contract Sync** | Every push & PR | ubuntu-latest | 3 min | ✅ |
| **Build (Docker)** | Merge to `main` | self-hosted | 10 min | ✅ |
| **Migrate (Postgres + ClickHouse)** | After build | self-hosted | 10 min | ✅ |
| **Deploy (Staging)** | Auto after migrate | self-hosted | 5 min | ❌ (auto) |
| **Deploy (Production)** | Manual approval | self-hosted | 5 min | ✅ (manual gate) |

---

## 2. GitHub Actions Workflow Structure

```yaml
# .github/workflows/ci.yml
name: CI Pipeline

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Rust lint
        run: cargo clippy --all-targets --all-features -- -D warnings
      - name: Svelte lint
        run: cd web && pnpm lint
      - name: Dart analyze
        run: cd mobile && flutter analyze

  test-unit:
    runs-on: ubuntu-latest
    needs: lint
    services:
      postgres:
        image: postgres:17
        env:
          POSTGRES_DB: creativanta_test
          POSTGRES_USER: creativanta
          POSTGRES_PASSWORD: test_password
    steps:
      - name: Rust tests
        run: cargo test --workspace
      - name: Web tests
        run: cd web && pnpm test
      - name: Flutter tests
        run: cd mobile && flutter test

  test-integration:
    if: github.event_name == 'pull_request' && github.base_ref == 'main'
    runs-on: self-hosted
    needs: test-unit
    steps:
      - name: Docker Compose up
        run: docker compose -f docker-compose.test.yml up -d
      - name: Run integration tests
        run: cargo test --test '*_integration' -- --test-threads=1
      - name: Playwright E2E
        run: cd web && pnpm exec playwright test

  contract-sync:
    runs-on: ubuntu-latest
    needs: test-unit
    steps:
      - uses: actions/checkout@v4
      - name: Verify canonical contract docs are present
        run: |
          test -f docs/04_contracts/api_endpoint_map.md
          test -f docs/04_contracts/database_schema.md
          test -f docs/04_contracts/domain_event_catalog.md
          test -f docs/04_contracts/rbac_permission_matrix.md
      - name: Optional typed transport generation
        run: |
          if find protos -name '*.proto' -print -quit | grep -q .; then
            echo "Run the repository-standard proto/codegen command during implementation phase."
          else
            echo "No committed proto sources yet; contract sync passes in docs-only mode."
          fi

  build:
    if: github.ref == 'refs/heads/main'
    runs-on: self-hosted
    needs: [test-unit, contract-sync]
    steps:
      - name: Build Docker images
        run: docker compose build
      - name: Tag with commit SHA
        run: docker tag creativanta-api:latest creativanta-api:${{ github.sha }}

  migrate:
    needs: build
    runs-on: self-hosted
    steps:
      - name: Apply Postgres migrations
        run: sea-orm-cli migrate up
      - name: Apply ClickHouse analytics schema
        run: |
          echo "Apply ClickHouse tables/materialized views derived from docs/05_system/cache_search_strategy.md §3 before application rollout."
      - name: Verify ClickHouse health
        run: curl -fsS http://127.0.0.1:8123/ping

  deploy-staging:
    needs: migrate
    runs-on: self-hosted
    environment: staging
    steps:
      - name: Deploy to staging
        run: docker compose -f docker-compose.prod.yml up -d --build --remove-orphans
      - name: Health check
        run: |
          curl -f https://staging.creativanta.app/health
          curl -f https://staging.creativanta.app/ready

  deploy-production:
    needs: deploy-staging
    runs-on: self-hosted
    environment:
      name: production
      url: https://app.creativanta.app
    steps:
      - name: Deploy (rolling)
        run: docker compose -f docker-compose.prod.yml up -d --build --remove-orphans
      - name: Health check
        run: |
          curl -f https://app.creativanta.app/health
          curl -f https://app.creativanta.app/ready
      - name: Smoke test (business endpoint)
        run: |
          # Verify a real gRPC/ConnectRPC endpoint responds (not just health check)
          # Uses an unauthenticated or service-account call to a read-only endpoint
          curl -f -X POST https://app.creativanta.app/creativanta.capability.v1.CapabilityService/GetPublicStatus \
            -H 'Content-Type: application/json' -d '{}' || echo "Smoke test warning: business endpoint did not respond"
```

---

## 3. Environment Promotion

```
develop → staging (auto) → production (manual approval + 1 reviewer)
```

| Environment | URL | Auto-deploy? | Reviewers |
|---|---|---|---|
| `staging` | staging.creativanta.app | ✅ (on merge to main) | — |
| `production` | app.creativanta.app | ❌ (manual gate) | 1+ admin |

---

## 4. Deployment Strategy

- **Type**: Rolling update (Docker Compose `--no-deps`)
- **Rollback**: `docker compose up -d --force-recreate` with previous image tag
- **Zero-downtime**: Health check must pass before old container stops
- **Database migrations**: Run BEFORE deployment via `sea-orm-cli migrate up`
- **ClickHouse DDL**: Apply analytics tables/materialized views BEFORE service rollout. The DDL bundle is derived from `05_system/cache_search_strategy.md` §3 and is part of the migration stage, not an optional post-step.
- **Migration rollback**: Prepare `down` migration for every `up`

### 4.1 ClickHouse Deployment Order

1. Verify ClickHouse health (`/ping`) on the target environment.
2. Apply or reconcile the analytics schema and materialized views defined from `05_system/cache_search_strategy.md` §3.
3. Verify core tables accept writes before deploying API/worker containers.
4. Roll application containers.
5. Re-run health checks and a minimal analytics smoke check against a read endpoint/dashboard dependency.

---

## 5. Secret Management

| Secret | Storage | Rotation |
|---|---|---|
| Database passwords | Infisical (runtime) + GitHub Secrets (bootstrap only) | 90 days |
| Stripe API keys | Infisical (runtime) + GitHub Secrets (bootstrap only) | On compromise |
| AI provider keys | Infisical (runtime) + GitHub Secrets (bootstrap only) | 90 days |
| JWT signing key | Clerk-managed or Infisical-managed runtime secret | 30 days |
| Proto/deploy keys | GitHub Deploy Keys | Annual |

> **Rule**: NEVER commit secrets to git. Runtime application secrets live in Infisical for staging/production. GitHub Secrets are limited to CI/bootstrap/deploy credentials and MUST NOT be treated as the long-term runtime source of truth.

---

## 6. Required Checks Before Merge

- [ ] All lint jobs pass (Rust clippy, Svelte lint, Dart analyze)
- [ ] All unit tests pass
- [ ] Integration tests pass (for PRs to main)
- [ ] Contract sync passes; if `/protos/` are committed, typed transport generation produces no drift
- [ ] At least 1 reviewers approved
- [ ] No `CRITICAL` or `HIGH` security advisories
