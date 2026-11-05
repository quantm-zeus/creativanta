# Creativanta POST-P8 Runtime, Database & API Security Readiness Report

- **Agent Role**: Runtime / DB / API Security & Real Integration QA (`runtime` — Gemini 4 Argon High)
- **Date**: 2026-11-05
- **Branch**: `feat/readiness-runtime-e2e` (based on `staging` SHA `28e7a2d`)
- **Worktree**: `/home/whaleorcale/evergreen/worktrees/creativanta-readiness/runtime`
- **Verification Classification**: **`STAGING/LOCAL`** (Real OS child processes on ephemeral loopback ports + isolated ephemeral PostgreSQL 17.10 container; **NOT** a live production third-party provider verification)

---

## 1. Executive Summary & Truthfulness Statement

Per `AGENTS.md`, `docs/00_index/BUILD_INDEX.md`, `docs/00_index/OPEN_BLOCKERS.md`, `docs/00_index/CANONICAL_SOURCES.md`, and `docs/00_index/BUILD_EXECUTION_CONTRACT.md`, this POST-P8 readiness slice establishes a reproducible, fail-closed, real-process and real-PostgreSQL 17.10 End-to-End (E2E) verification gate (`tooling/readiness/runtime/check_runtime_e2e.sh` and `apps/api/internal/bootstrap/runtime_readiness_e2e_test.go`) without touching any persistent host databases, shared ports, or external production credentials.

All results in this report are strictly classified as **`STAGING/LOCAL`**. Local cryptographic fixtures and isolated PostgreSQL 17.10 containers prove runtime binary behavior, loopback binding, fail-closed readiness, Connect auth interceptor boundaries, SQL migration repeatability, tenant Row-Level Security (`app_user`), money exactness (`NUMERIC(18,6)`), and replay deduplication—they do **not** substitute for live Clerk production JWKS/webhooks, OAuth partner app approvals, live Stripe merchant webhooks, external legal sign-off (`LEG-H-001`), or multi-node staging load/DR rehearsals.

---

## 2. Defect Found & Fixed (With Regression Verification)

### `apps/api/internal/migrate/migrator_test.go` — Missing 47th `Down` Rollback Step (`v36`) in Live PostgreSQL Suite
- **Finding**: In `TestPostgresLiveMigrationAndAppUserRLS` (`apps/api/internal/migrate/migrator_test.go`), after applying all 47 canonical Goose SQL migrations (`Up`), the test rolled back migrations sequentially from `v47` to `v1` to prove full `Up -> Down -> Up` SQL repeatability on live PostgreSQL 17.10. However, between `Down rollback v37` and `Down rollback v35`, the `Down` call for `v36` (`00036_p7_01_workflows_and_complete_node_model.sql`) was omitted. As a result, only 46 `Down` calls executed, leaving migration `v1` (`00001_p0_04_tenant_schema_rls_and_grants.sql`) still applied before the second `Up` pass, and the return count of the second `Up` pass was not asserted.
- **Fix**: Restored the missing `Down(ctx, adminPool, dir, true)` rollback step for `v36` and added an explicit assertion that `reApplied, err := Up(ctx, adminPool, dir)` returns `len(reApplied) == 47` after rolling back all 47 migrations to zero.
- **Regression Proof**: Verified against live PostgreSQL 17.10 (`go test -p 1 -race -count=1 ./internal/migrate/...` inside `tooling/readiness/runtime/check_runtime_e2e.sh`).

---

## 3. Real-Process & Live-PostgreSQL 17.10 E2E Verification Matrix (`STAGING/LOCAL`)

| Verification Area | Target / Mechanism | Assertions Verified | Classification & Status |
|---|---|---|---|
| **Fail-Closed Gate Self-Test** | `tooling/readiness/runtime/check_runtime_e2e.sh` (`CREATIVANTA_RUNTIME_E2E_FORCE_FAIL`) | Simulated rogue HTTP listener returning `200 OK` on `/readyz` (`bad_readyz`), `200 OK` on `/admin/users` (`bad_forbidden_route`), or `200 OK` on `POST /healthz` (`bad_method`) causes `check_runtime_e2e.sh` to exit non-zero and clean up child PIDs and temp directories. | `STAGING/LOCAL` — **PASS** |
| **Loopback-Only Bind Enforcement** | Compiled `cmd/api` and `cmd/admin-api` binaries | Starting `api` or `admin-api` with `0.0.0.0:<port>` or `localhost:<port>` fails closed immediately (`bootstrap: bind address must be loopback (127.0.0.1 or ::1)`). | `STAGING/LOCAL` — **PASS** |
| **Real Process Health & Fail-Closed Readiness** | Compiled `cmd/api` and `cmd/admin-api` on ephemeral `127.0.0.1` ports | `GET /healthz` returns `200 OK` (`{"status":"alive","role":"api"\|"admin-api"}`); `GET /readyz` returns `503 Service Unavailable` (`{"status":"not_ready"}`) when dependencies are unwired; responses include `Content-Type: application/json`, `Cache-Control: no-store`, and `X-Content-Type-Options: nosniff`; `SIGTERM` triggers clean graceful shutdown (`exit code 0`). | `STAGING/LOCAL` — **PASS** |
| **Negative HTTP Methods & Forbidden Routes** | Compiled `cmd/api` and `cmd/admin-api` | `POST`, `PUT`, `DELETE`, `PATCH`, `OPTIONS`, `HEAD` on `/healthz` and `/readyz` return `405 Method Not Allowed` with `Allow: GET`; unmounted/privileged paths (`/`, `/v1/workspaces`, `/admin/users`, `/internal/admin`, `/metrics`, `/debug/pprof`, `/creativanta.v1.AuthService/GetSession`) return `404 Not Found` (`{"error":"not_found"}`) even with forged `Authorization` and `X-Workspace-ID` headers. | `STAGING/LOCAL` — **PASS** |
| **CLI Daemon Fail-Closed Startup** | Compiled `cmd/worker`, `cmd/outbox`, `cmd/migrate` | Invoking `worker`, `outbox`, or `migrate` without required subcommands and database URL environment variables fails closed with exit code `2` (`not implemented`). | `STAGING/LOCAL` — **PASS** |
| **Connect Auth & Cross-Surface Isolation** | `transportauth.NewServerInterceptor` (`ModeAPI` & `ModeAdminAPI`) + `identity.Resolver` + `SQLMembershipLookup` on live PostgreSQL 17.10 | Valid RS256 JWT + active session + active PostgreSQL `workspace_members` row succeeds on `ModeAPI`; missing/Basic/rogue-kid/expired JWTs fail with `CodeUnauthenticated`; cross-tenant `x-workspace-id` fails with `CodeUnauthenticated`; header vs body workspace mismatch fails with `CodePermissionDenied`; tenant token on `ModeAdminAPI` and admin session on `ModeAPI` both fail with `CodeUnauthenticated`; live session revocation or PostgreSQL `workspace_members.status = 'suspended'` immediately denies subsequent requests before JWT `exp`. | `STAGING/LOCAL` — **PASS** |
| **Canonical 47-Migration Lifecycle & Seed Idempotency** | Compiled `cmd/migrate` CLI + `internal/migrate` against PostgreSQL 17.10 (`postgres@sha256:7958605b...`) | All 47 migrations apply cleanly (`cmd/migrate up` & `cmd/migrate status`), roll back all 47 versions to 0 (`Down`), re-apply all 47 versions (`Up`), and pass two-run `docs/06_quality_ops/seed_data.sql` idempotency (`TestPostgresSeedTwiceIdempotency`). | `STAGING/LOCAL` — **PASS** |
| **Tenant RLS, 6 Operator Modes & Internal Note Stripping** | `tenantdb.WithTx` + `SET LOCAL ROLE app_user` on PostgreSQL 17.10 | Unscoped `app_user` queries return `0` rows; all 6 canonical operator modes (`creator`, `seller`, `affiliate_operator`, `live_operator`, `agency_mcn`, `brand_collaboration`) persist and validate on `home_dashboard_config` while invalid modes fail `CHECK` (`23514`); Tenant B cannot `SELECT`/`UPDATE`/`DELETE`/`INSERT` Tenant A rows (`0` rows / `SQLSTATE 42501`); `support_ticket_messages` hides `is_internal_note = TRUE` from `app_user`; `tenantdb.WithTx` enforces `ErrScopeMismatch` and `ErrMembershipRevokedOrMissing`. | `STAGING/LOCAL` — **PASS** |
| **Replay Deduplication & Money Exactness (`DB-H-001`)** | Live PostgreSQL 17.10 constraints & `information_schema.columns` | Duplicate `(workspace_id, consumer_name, event_id)` in `consumer_inbox`, duplicate `(workspace_id, operation_key)` in `external_effects`, and duplicate `(workspace_id, idempotency_key)` in `ai_credit_reservations` fail closed with `SQLSTATE 23505`; `information_schema.columns` confirms `0` `real`/`double precision`/`float` columns for money or credit fields across all public tables. | `STAGING/LOCAL` — **PASS** |

---

## 4. Exact Commands Executed & Results

1. **Full Runtime & Ephemeral PostgreSQL 17.10 E2E Gate**:
   ```bash
   ./tooling/readiness/runtime/check_runtime_e2e.sh
   ```
   - **Result**: `EXIT 0` (`PASS` across all 6 steps: failure-propagation self-test, 5 binary builds, loopback process probes, ephemeral PostgreSQL 17.10 container startup, `cmd/migrate up` & `status` for all 47 migrations, `tooling/ci/check_identity.sh`, and `go test -p 1 -race -count=1` for `bootstrap`, `transportauth`, `identity`, `tenantdb`, `migrate`, `outbox`, `internaladmin`, and `platformacceptance`).

2. **Existing CI Entrypoint, Failure Self-Test & D0 Contract Checks**:
   ```bash
   ./tooling/ci/check_entrypoints.sh
   ./tooling/ci/self_test_failure.sh
   ./tooling/ci/check_d0.sh
   git diff --check
   ```
   - **Result**: All commands exited `0` (`P0_ENTRYPOINTS_FAIL_CLOSED_PASS`, `NEGATIVE_TESTS_PASS`, `D0 Documentation Invariant Gate: PASS`, and zero whitespace or formatting errors).

---

## 5. External Production Gates & Blockers (`NOT VERIFIED / PENDING`)

In accordance with `docs/00_index/OPEN_BLOCKERS.md` and `build/phase-P8/p8-09/manifest.json`, the following external gates cannot be satisfied in an isolated local/CI environment and remain explicitly **`NOT VERIFIED (PENDING)`**:

| External Gate / Blocker ID | Scope | Current Status | What Remains for Production Cutover |
|---|---|---|---|
| `EXT-GATE-CLERK-PRODUCTION` | Live Clerk production instance, JWKS endpoint, custom JWT claims, and Svix webhook secret verification | **NOT VERIFIED (`PENDING`)** | Provision production Clerk tenant, bind live JWKS URL & Svix signing secret in OpenBao, and execute live login/webhook smoke test. |
| `EXT-GATE-LIVE-PROVIDER-AND-CONNECTOR-VERIFICATION` | Live OAuth partner approvals and sandbox/production API verification (TikTok, TikTok Shop, Shopee, Lazada, YouTube, Instagram, Facebook, Runway, Veo, Kling, ElevenLabs, HeyGen) | **NOT VERIFIED (`PENDING`)** | Complete partner portal app review, provision live OAuth client credentials in OpenBao, and record live sandbox/production verification in `capability_verification_registry`. |
| `EXT-GATE-PAYMENT-STRIPE-LIVE` | Live Stripe merchant account, webhook signing secret, and live VND/USD settlement | **NOT VERIFIED (`PENDING`)** | Activate production Stripe merchant account, configure live webhook endpoint, and run live 1-unit subscription & top-up settlement test. |
| `LEG-H-001` | External legal counsel sign-off on Terms of Service, Privacy Policy, VN PDPL (`Decree 13/2023/ND-CP`), and DMCA safe-harbor workflow | **NOT VERIFIED (`PENDING`)** | Obtain written legal counsel approval before enabling public self-serve signup and real-money checkout. |
| `EXT-GATE-STAGING-LOAD-AND-DR-REHEARSAL` | Multi-node staging k6 load benchmark (`docs/06_quality_ops/performance_benchmarks.md`) and physical VPS WAL-G PITR failover rehearsal (`docs/06_quality_ops/runbook.md` §7.2) | **NOT VERIFIED (`PENDING`)** | Execute full k6 load test against dedicated staging cluster and perform live multi-node PostgreSQL 17 WAL-G restore drill with measured RTO/RPO. |
| `EXT-GATE-ACTIVEPIECES-ENTERPRISE-LICENSE` | Activepieces commercial/enterprise embedding license if embedded piece execution is enabled in production | **NOT VERIFIED (`PENDING`)** | Keep Creativanta-owned Go workflow engine as primary runtime (`ADR-015`), or procure Activepieces enterprise license before enabling any embedded Activepieces surface. |
