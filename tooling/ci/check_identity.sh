#!/usr/bin/env bash
# P0-03 integration gate requires real PostgreSQL rather than a skipped test.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
if [[ -z "${CREATIVANTA_TEST_POSTGRES_DSN:-}" ]]; then
  echo 'P0-03 FAIL: local/test PostgreSQL DSN is required' >&2
  exit 2
fi
command -v go >/dev/null
log="$(mktemp)"
trap 'rm -f "$log"' EXIT
(
 cd "$ROOT/apps/api"
 GOTOOLCHAIN=local go test -race -count=1 -v ./internal/identity ./internal/transportauth
) | tee "$log"
grep -q -- '--- PASS: TestPostgresMembershipUsesCurrentCanonicalState' "$log" || {
 echo 'P0-03 FAIL: database integration was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestPostgresNonOwnerWorkspaceDiscovery' "$log" || {
 echo 'P0-03 FAIL: non-owner workspace discovery was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestEndToEndJWTSessionMembershipOnConnect' "$log" || {
 echo 'P0-03 FAIL: authenticated Connect integration was skipped' >&2
 exit 1
}
echo 'P0-03_TESTS_PASS: JWT, revocation, workspace and PostgreSQL'
