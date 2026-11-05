# Creativanta CI/CD - Execution Limitations & Deferred Gates

**Canonical Reference:** `docs/00_index/BUILD_EXECUTION_CONTRACT.md` & `docs/06_quality_ops/ci_cd_pipeline.md`
**Current Phase:** P0-01 (Repository, Toolchain & CI Bootstrap)

---

## 1. What Cannot Run in P0-01 and Why

Per the Build Execution Contract and Agent Task Catalog, early slices must not greenwash tests whose prerequisites belong to downstream tasks. The following test suites are explicitly documented as deferred:

### A. Android Emulator & Mobile E2E Tests
* **Current Status:** DEFERRED (Blocked on mobile shell and runner hardware acceleration)
* **Required Dependency:** P0-02 / P0-03 / P8
* **Technical Reason:**
  - Standard GitHub Actions hosted Linux runners (`ubuntu-latest`) lack nested KVM virtualization by default, preventing performant Android emulator execution within standard CI timeouts.
  - Native mobile E2E requires assembled APK/AAB binaries and live Connect/gRPC endpoints that connect to the backend.
* **Interim Verification:** `flutter analyze --fatal-infos` and headless `flutter test` running on Linux runner. Full device matrix executes on dedicated mobile test farms during P8 release hardening.

### B. PostgreSQL 17 Multi-Tenant RLS & Role-Isolation Tests
* **Current Status:** DEFERRED to P0-04
* **Required Dependency:** Task P0-04 (*Tenant schema, RBAC và private projections*)
* **Technical Reason:**
  - Database schema migrations (via Goose), role isolation (`app_user`, `admin_user`, `creativanta_migrator`), and PostgreSQL Row Level Security (RLS) policies are authored and delivered in task **P0-04**.
  - P0-01 establishes the CI pipeline, toolchain pins, and base Go test harness. Running live multi-tenant injection fixtures before P0-04 migrations exist would violate the dependency contract.
* **Target Activation:** P0-04 exit gate requires two-tenant isolation, direct-junction attack denial, and transaction-local `set_config` tests with non-superuser roles.

### C. Outbox/Inbox Durable Leases & External Effect De-duplication
* **Current Status:** DEFERRED to P0-05
* **Required Dependency:** Task P0-05 (*Outbox, inbox và unknown external effects*)
* **Technical Reason:**
  - Transactional outbox polling, inbox idempotency keys, and crash recovery mechanics require schema and daemon components implemented in P0-05.
* **Target Activation:** P0-05 exit gate requires crash-before-commit and duplicate webhook replay fixtures.

### D. Live External AI & Payment Provider Routes
* **Current Status:** GATED (Runs only against deterministic local fixtures / mocks)
* **Required Dependency:** External Gates (Stripe sandbox, TikTok open platform, ElevenLabs/Kling credentials)
* **Technical Reason:**
  - External credentials cannot be committed or created by editing code/docs (Section 5 of `BUILD_EXECUTION_CONTRACT.md`).
  - Capabilities start in `manual`/`unsupported` mode until verified credential records exist.
* **Interim Verification:** Deterministic mock adapters with fixed response fixtures.

### E. ClickHouse OLAP Aggregation Fixtures
* **Current Status:** DEFERRED to P1
* **Required Dependency:** Task P1-01 / P1-02 (Profit OS and commerce ledger)
* **Technical Reason:**
  - ClickHouse is a financial read projection, not the primary ledger authority. Versioned ClickHouse DDL and sync workers are introduced in Phase P1.

---

## 2. Hard Gate Compliance

| Stage | P0-01 Status | Enforcement |
|---|---|---|
| D0 Documentation | ACTIVE | `tooling/check_docs.py` mandatory in CI |
| Toolchain Pinning | ACTIVE | Strict verification of Go 1.27.3, Flutter 3.47.9, Node 24, pnpm 10.34.9, Buf 1.75.0 |
| Static Lint & Format | ACTIVE | `gofmt -l`, `go vet`, `flutter analyze`, `pnpm check/lint` |
| Unit & Race Tests | ACTIVE | `go test -race`, `pnpm test`, `flutter test` |
| Fail-Closed Smoke | ACTIVE | `/healthz` (200) vs `/readyz` (503 prior to dependencies) must be verified against actual Go process |
| Failure Propagation | ACTIVE | `self_test_failure.sh` proves non-zero exit on test failures |
| Multi-tenant RLS | ACTIVE | `tooling/ci/check_identity.sh` runs against PostgreSQL 17.10 in CI |
| Browser Responsive & WCAG | ACTIVE | `.github/workflows/readiness-browser.yml` pinned on `ubuntu-24.04` with zero skipped gates |
| Mobile Emulator E2E | DEFERRED | P8 release hardening gate |

---

## 3. P8 Readiness PostgreSQL Domain Suite Coverage (`IQ-04` / `IQ-05`)

- `tooling/ci/check_identity.sh` executes both the P0 foundation PostgreSQL suites and the later domain PostgreSQL integration suites (`product`, `inventory`, `order`, `affiliate`, `monetization`, `livecommerce`) against the live PostgreSQL 17.10 service container.
- A targeted symlink helper (`$ROOT/apps/infra -> $ROOT/infra`, cleaned up on exit) resolves `filepath.Join("..", "..", "..", "infra", "migrations")` for `inventory`, `order`, and `finance` without modifying unowned domain test files.
- **Cross-Lane Owner Dependencies**:
  - `apps/api/internal/finance/store.go` (`CreateCostItem` / `CreateSettlement` empty-string UUID parameter casts and `DATE` scan into `string`) and `apps/api/internal/seeding/seeding_postgres_test.go` (`sample_request_id` vs canonical PK `request_id` in migration `00034`) are owned by the **commerce-finance** lane.
  - `apps/api/internal/product/service.go` (`ListProducts` cursor pagination `R12`) is owned by the **publish-product** lane.
  - `apps/mobile/android/app/src/main/AndroidManifest.xml` (`INTERNET` permission `IQ-08`) and `apps/web` UI components (`UF-01..UF-12`) are owned by the **frontend** lane.
