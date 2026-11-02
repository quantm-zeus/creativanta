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
   GOTOOLCHAIN=local go test -p 1 -race -count=1 -v ./internal/migrate ./internal/tenantdb ./internal/rbac ./internal/workspace ./internal/outbox ./internal/diagnostics ./internal/billing
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

grep -q -- '--- PASS: TestPostgresLiveOutboxInboxAndExternalEffects' "$log_p004" || {
 echo 'P0-05 FAIL: live PostgreSQL outbox/inbox/external_effects test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestKillBeforeAndAfterOutboxLeaseAndConsumerCommitAndAck' "$log_p004" || {
 echo 'P0-05 FAIL: kill before/after commit and ACK test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestDuplicateWebhookHasStrictlyOneEffect' "$log_p004" || {
 echo 'P0-05 FAIL: duplicate webhook idempotency test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestUnresolvedExternalEffectNeverBlindlyRetried' "$log_p004" || {
 echo 'P0-05 FAIL: unresolved external effect guard test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestRuleM23A04SanitizationAndRepairWizardReconcilesUnknownExternalEffect' "$log_p004" || {
 echo 'P0-05 FAIL: DiagnosticsService M23 repair wizard test was skipped' >&2
 exit 1
}
echo 'P0-05_TESTS_PASS: Outbox lease recovery, consumer inbox deduplication, kill before/after commit and ACK, webhook dedup, unknown external effects guard, audit immutability, and M23 DiagnosticsService'

grep -q -- '--- PASS: TestPostgresLiveCreditLotsQuotesAndBilling' "$log_p004" || {
 echo 'P0-06 FAIL: live PostgreSQL credit lots, quotes and billing test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestConcurrentHoldsCannotOverspend' "$log_p004" || {
 echo 'P0-06 FAIL: concurrent holds overspend test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestLateResultAndCycleBoundaryPreserveLots' "$log_p004" || {
 echo 'P0-06 FAIL: late result and cycle boundary lot preservation test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestPaidRetryCannotExceedConfirmedQuote' "$log_p004" || {
 echo 'P0-06 FAIL: paid retry confirmed quote ceiling test was skipped' >&2
 exit 1
}
echo 'P0-06_TESTS_PASS: Versioned pricebook, cost-based quotes, credit lots, concurrent holds, late-result quarantine, cycle boundary rollover/expiry, and billing sandbox'
