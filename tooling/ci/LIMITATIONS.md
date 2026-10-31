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
| Multi-tenant RLS | DEFERRED | P0-04 required gate |
| Mobile Emulator E2E | DEFERRED | P8 release hardening gate |
