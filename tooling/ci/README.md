# Creativanta CI/CD Tooling

This directory contains executable scripts and test harnesses powering both local pre-commit validation and GitHub Actions CI pipelines for Creativanta.

All scripts adhere strictly to **docs/00_index/BUILD_EXECUTION_CONTRACT.md** and **docs/06_quality_ops/ci_cd_pipeline.md**.

---

## Zero Greenwashing Invariant

1. **No Silent Swallowing:** Scripts use `set -euo pipefail`. Any failed command terminates the process immediately with a non-zero exit code.
2. **No Masking Patterns:** `|| true`, `|| exit 0`, or unconditional `echo PASS` statements are prohibited and audited by `self_test_failure.sh`.
3. **Missing Check Means Fail:** If an application workspace directory (`apps/api`, `apps/web`, `apps/admin`, `apps/mobile`) or required configuration file is missing, the check fails immediately instead of skipping.
4. **Fail-Closed API Smoke:** The API readiness probe (`/readyz`) MUST respond with HTTP 503 until all backing dependencies are initialized. Returning 200 prematurely causes smoke verification to fail.

---

## Script Inventory

| Script | Purpose | Key Invariants / Tools |
|---|---|---|
| `check_env.sh` | Verifies pinned versions across toolchains | Go 1.27.3, Flutter 3.47.9, Node 24, pnpm 10.34.9, Buf 1.75.0 |
| `check_d0.sh` | Runs D0 documentation static invariant checks | `python3 tooling/check_docs.py` |
| `check_entrypoints.sh` | Tests unimplemented worker, outbox, migrate exit non-zero, no fake success | 3 compiled Go binaries |
| `check_go.sh` | Go format, module verification, static analysis, unit race tests | `gofmt -l`, `go vet`, `govulncheck v1.9.0`, `go test -race` in `apps/api` |
| `check_node.sh` | Web & Admin frontend installation, build, lint, and tests | `pnpm --frozen-lockfile` in `apps/web`, `apps/admin` |
| `check_web_smoke.sh` | Real built SvelteKit SSR smoke on localhost | Five Web routes, isolated Admin deny page, unknown route 404 |
| `check_flutter.sh` | Flutter mobile analysis and unit tests | `flutter analyze`, `flutter test` in `apps/mobile` |
| `check_proto.sh` | Buf linting and contract drift checking | `buf lint`, `buf breaking` |
| `smoke_test.sh` | Live smoke probe testing liveness and fail-closed readiness | Validates HTTP 200 on `/healthz` and HTTP 503 on `/readyz` |
| `self_test_failure.sh` | Harness proving intentional failure yields non-zero exit | Audits scripts, simulates assertion and smoke failures |
| `LIMITATIONS.md` | Explicit documentation of deferred testing gates | Android emulator, PostgreSQL RLS in P0-04, provider gates |

---

## Local Execution

Run all checks locally:

```bash
# 1. Self-test to verify failure propagation
./tooling/ci/self_test_failure.sh

# 2. D0 documentation check
./tooling/ci/check_d0.sh

# 3. Live smoke test building and running real Go API binary
./tooling/ci/smoke_test.sh
```
