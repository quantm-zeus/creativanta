---
layer: quality_ops
canonical: true
last_updated: 2026-10-30
status: SPECIFIED
---

# CI/CD Pipeline — Evidence-Gated Delivery

## 1. Scope and prerequisites

This is the canonical implementation pipeline contract. The docs-only checkout runs `python3 tooling/check_docs.py`; it does not have an application to compile or deploy. P0 must create the app/toolchain/transport/migration artifacts below and make their jobs fail if any required input is absent. Missing future-phase code is not a reason to report a passing runtime check.

Each job checks out the same commit, installs exact toolchain/dependency versions from committed version files and lockfiles, and uses its own initialized workspace. Never rely on a previous runner's disk or use untrusted PR code/secrets on the production/self-hosted deployment host. PR tests run on isolated hosted/ephemeral runners. Deployment runs only for protected reviewed commits, after required tests succeed.

## 2. Required stages and commands

| Stage | Required work | Pass condition |
|---|---|---|
| Docs | `python3 tooling/check_docs.py` | Zero static contract/link/coverage violations |
| Toolchain | Validate Node/pnpm/Go/Flutter/protoc/buf and image digests against committed manifest; frozen lockfile installs | Every version fixed; no unreviewed latest image/model/action |
| Lint | in apps/api: test -z "$(gofmt -l .)"; go vet ./...; govulncheck ./...; web/admin check+lint; flutter analyze | Every touched platform passes |
| Transport | buf lint; buf breaking against base revision; generate current-slice Go/TS/Dart bindings; git diff --exit-code on generated paths | Compiles all three targets; no drift; packet has typed messages and permission bindings |
| Unit | in apps/api: go test -race -count=1 ./...; pnpm --dir apps/web test; pnpm --dir apps/admin test; flutter test in apps/mobile | Required domain/decimal/state tests pass |
| Integration | Isolated PostgreSQL 17 with vector/Timescale extensions; apply exact migrations and seed twice; runtime-role RLS/grants/FK checks; outbox/inbox/reservation/provider-replay fixtures | All D2/D3 tests pass, not just superuser fixtures |
| UI/E2E | Playwright web/admin and mobile integration tests for current slice, five QA paths, a11y/i18n | Actual implemented routes/actions/roles match packet |
| Build | Build immutable API/web/admin/worker/mobile artifacts and containers, generate SBOM and record digests | Same reviewed commit/digests tested in staging |
| Staging migration | Snapshot/backup; expand-compatible PostgreSQL migrations; apply versioned ClickHouse DDL if slice uses it | Schema versions and representative reads/writes match expected version |
| Staging deploy | Separate staging Compose project/env/volumes/secrets; deploy candidate slot, readiness and business smoke | Failed health/business smoke fails stage; old service remains routable |
| Production | Explicit protected-environment approval; repeat compatible migration/deploy using tested digests; authenticated business smoke | All release gates and external access evidence pass |

Commands requiring app code run only after that phase creates the named project. P0 commits exact repository commands; wrappers are accepted only if failures propagate and logs prove each required check ran. A conditional `echo` or test-file existence check cannot replace transport, migration or integration work.

## 3. Contract and dependency synchronization

The docs gate verifies inventory-to-permission bindings and selected schema invariants. It cannot establish typed RPC completeness. For each implemented RPC, validate the slice packet's exact `.proto` messages, validation/permission/state/replay tests and response projection. Schema revisions update Goose SQL migrations/fixtures before sqlc generation. Run sqlc generate in apps/api and fail on generated diff. Run go mod verify and fail on changes after go mod tidy; commit go.mod/go.sum and pinned tool/generator versions. Build cmd/api, cmd/admin-api, cmd/worker, cmd/outbox and cmd/migrate from the same Go module. Commit lockfiles and pin container digests; document every provider/model/API/engine version and verification expiry.

## 4. Deployment and rollback

Docker Compose alone does not guarantee rolling or zero-downtime updates. The P0 release implementation must support blue/green slots behind the proxy: create candidate slot, wait for readiness, run business smoke, switch upstream atomically, drain old slot, retain previous image/config digest. Never call `up --remove-orphans` against a shared production/staging project. Slot/project names and ports are distinct.

Use expand → deploy compatible readers/writers → backfill → verify → later contract migration. A code rollback must remain compatible with the expanded schema. Do not automatically reverse a destructive data migration. Backups/restores must be exercised before release; restore only through an approved incident procedure with reconciliation of external effects.

ClickHouse is a financial read projection, never credit/ledger authority. Commit and apply versioned ClickHouse DDL and required backfill before switching code that reads it. Check schema version and a known aggregate fixture, not only `/ping`. An `echo` about DDL is not a migration.

## 5. Mandatory business smoke

The release script MUST use `set -euo pipefail`, bounded timeouts and failing exit codes. Check `/health` and `/ready`, then an **implemented** read endpoint from the release packet. Do not invent a GetPublicStatus RPC to make a smoke test seem business-aware.

For a release containing finance, an authenticated dedicated smoke workspace query checks its known seeded balance/profit and currency/source labels. Public endpoints cannot validate tenant data. Credentials come from a protected file/secret and must never appear in shell trace/logs. Verify expected JSON fields/values as well as HTTP success. Any curl failure, invalid response, unauthorized response or wrong aggregate fails deployment and prevents proxy switch; no `|| echo`, unconditional success, or warning-only bypass.

## 6. Environment and secrets

Staging and production have separate databases, credentials, buckets, callback URLs, Compose project names, backup prefixes and provider test/live access records. Runtime uses app_user, isolated admin service uses admin_user, migrations use their owner role, and outbox poller uses only its dedicated role. No runtime process receives all four credentials. Production secrets live in Infisical; GitHub Secrets bootstrap CI/deploy only.

## 7. Required release packet

Record commit/artifact digests, accepted slice manifests, migration/schema versions, backup/restore check, rollback slot, provider/model/rate/edition evidence, entitlement flags, actual test output, smoke identity and results, performance/accessibility/security checks, known external gates and protected approval. No blanket launch readiness is inferred from this document or a docs-only CI pass.
