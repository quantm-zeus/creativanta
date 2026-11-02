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
 GOTOOLCHAIN=local go test -race -count=1 -v ./internal/identity ./internal/clerkwebhook ./internal/invitations ./internal/transportauth
) | tee "$log"
grep -q -- '--- PASS: TestPostgresMembershipUsesCurrentCanonicalState' "$log" || {
 echo 'P0-03 FAIL: database integration was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestPostgresNonOwnerWorkspaceDiscovery' "$log" || {
 echo 'P0-03 FAIL: non-owner workspace discovery was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestPostgresSynchronousUserUpsertSurvivesDelayedWebhook' "$log" || {
 echo 'P0-03 FAIL: delayed user webhook synchronous upsert test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestPostgresPersonalOnboardingCannotMutateWorkspaceSettings' "$log" || {
 echo 'P0-03 FAIL: personal onboarding workspace isolation test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestPostgresClerkWebhookMembershipAndUserReconciliation' "$log" || {
 echo 'P0-03 FAIL: Clerk webhook SQL reconciliation test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestRecoveryRevokesAllActiveSessionsAndRejectsExpiredOrReplayedChallenge' "$log" || {
 echo 'P0-03 FAIL: password recovery session revocation test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestEndToEndJWTSessionMembershipOnConnect' "$log" || {
 echo 'P0-03 FAIL: authenticated Connect integration was skipped' >&2
 exit 1
}
echo 'P0-03_TESTS_PASS: JWT, revocation, workspace, onboarding, invitations, webhooks and PostgreSQL'

log_p004="$(mktemp)"
trap 'rm -f "$log" "$log_p004"' EXIT
(
 cd "$ROOT/apps/api"
 CREATIVANTA_TEST_DATABASE_URL="$CREATIVANTA_TEST_POSTGRES_DSN" \
   GOTOOLCHAIN=local go test -p 1 -race -count=1 -v ./internal/migrate ./internal/tenantdb ./internal/rbac ./internal/workspace
) | tee "$log_p004"
grep -q -- '--- PASS: TestPostgresLiveMigrationAndAppUserRLS' "$log_p004" || {
 echo 'P0-04 FAIL: live PostgreSQL Goose migration and app_user RLS test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestPostgresLiveWithTxIsolationAndRollback' "$log_p004" || {
 echo 'P0-04 FAIL: live PostgreSQL WithTx isolation and rollback test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestPostgresLiveWorkspaceOwnerProtectionRevocationAndProjections' "$log_p004" || {
 echo 'P0-04 FAIL: live PostgreSQL workspace owner protection and revocation test was skipped' >&2
 exit 1
}
echo 'P0-04_TESTS_PASS: Goose migrations, app_user RLS, direct-junction composite FKs, WithTx, RBAC, last-owner protection, member revocation and private projections'
