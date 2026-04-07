---
layer: quality_ops
canonical: true
created: 2026-03-31
last_updated: 2026-04-06
status: READY_SPEC
---

# CI/CD Pipeline — Creativanta

> **Stack**: GitHub Actions + Docker Compose + Contabo VPS
> **Ref**: ADR-006 (Self-hosted), `05_system/tech_stack_adr.md`
> **Status meaning**: This document is the canonical CI/CD specification. Workflow YAML and helper scripts are generated/implemented from this spec during code scaffolding; they are not a prerequisite for starting application development.

---

## 1. Pipeline Stages

```
PR Created → Lint → Test → Proto-Gen → Build → Deploy (staging/prod)
```

### Stage Details

| Stage | Trigger | Runner | Timeout | Blocking? |
|---|---|---|---|---|
| **Lint** | Every push & PR | ubuntu-latest | 5 min | ✅ |
| **Test (Unit)** | Every push & PR | ubuntu-latest | 10 min | ✅ |
| **Test (Integration)** | PR to `main` | self-hosted (Contabo) | 15 min | ✅ |
| **Proto-Gen** | Every push & PR | ubuntu-latest | 3 min | ✅ |
| **Build (Docker)** | Merge to `main` | self-hosted | 10 min | ✅ |
| **Deploy (Staging)** | Auto after build | self-hosted | 5 min | ❌ (auto) |
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

  proto-gen:
    runs-on: ubuntu-latest
    needs: test-unit
    steps:
      - name: Generate Rust, TypeScript, Dart from .proto
        run: ./tooling/proto-gen.sh
      - name: Verify no drift
        run: git diff --exit-code -- **/generated/

  build:
    if: github.ref == 'refs/heads/main'
    runs-on: self-hosted
    needs: [test-unit, proto-gen]
    steps:
      - name: Build Docker images
        run: docker compose build
      - name: Tag with commit SHA
        run: docker tag creativanta-api:latest creativanta-api:${{ github.sha }}

  deploy-staging:
    needs: build
    runs-on: self-hosted
    environment: staging
    steps:
      - name: Deploy to staging
        run: ./scripts/deploy.sh staging ${{ github.sha }}
      - name: Health check
        run: curl -f https://staging.creativanta.app/health

  deploy-production:
    needs: deploy-staging
    runs-on: self-hosted
    environment:
      name: production
      url: https://app.creativanta.app
    steps:
      - name: Deploy (rolling)
        run: ./scripts/deploy.sh production ${{ github.sha }}
      - name: Health check
        run: curl -f https://app.creativanta.app/health
      - name: Smoke test
        run: ./scripts/smoke-test.sh production
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
- **Migration rollback**: Prepare `down` migration for every `up`

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
- [ ] Proto-gen produces no drift
- [ ] At least 1 reviewers approved
- [ ] No `CRITICAL` or `HIGH` security advisories
