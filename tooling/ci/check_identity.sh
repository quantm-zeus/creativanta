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
   GOTOOLCHAIN=local go test -p 1 -race -count=1 -v ./internal/migrate ./internal/tenantdb ./internal/rbac ./internal/workspace ./internal/outbox ./internal/diagnostics ./internal/capability ./internal/internaladmin ./internal/billing ./internal/home ./internal/help ./internal/notification ./internal/serviceidentity
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

grep -q -- '--- PASS: TestUnverifiedStaleReadOnlyAndKilledRoutesCannotExecute' "$log_p004" || {
 echo 'P0-07 FAIL: unverified route execution gate test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestWorkspaceRoleCannotCallAdminListenerAndVPNMFAGate' "$log_p004" || {
 echo 'P0-07 FAIL: workspace role rejected on admin listener test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestImpersonationIsStrictlyReadOnlyAndAutoExpiresAfter30Minutes' "$log_p004" || {
 echo 'P0-07 FAIL: read-only impersonation test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestModerationRulesHardBlockSelfReviewGuardAndKillSwitchHaltsCapability' "$log_p004" || {
 echo 'P0-07 FAIL: moderation hard-block and kill switch test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestEmptyMigrationBundleFailsClosed' "$log_p004" || {
 echo 'P8-08 FAIL: empty migration bundle fail-closed test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestP808SecondPassRegression_ReleaseF4DataF9_DeletedTempFixtureRejected' "$log_p004" || {
 echo 'P8-08 FAIL: persistent PostgreSQL restore rehearsal and temp-fixture rejection test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestP808ThirdPassRegression_ReleaseF1F2F3_AuditIntegrityRollbackAndMigrateCLI' "$log_p004" || {
 echo 'P8-08 FAIL: release smoke audit integrity, rollback failure reporting, and migrate bundle regression test was skipped' >&2
 exit 1
}
echo 'P0-07_TESTS_PASS: Capability verification registry, unverified route block, composite health score, isolated admin listener VPN/MFA gate, read-only impersonation, moderation rules engine, and kill switches'

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

grep -q -- '--- PASS: TestSixModeIdentitiesRetained' "$log_p004" || {
 echo 'P0-08 FAIL: six mode identities test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestUnbuiltActionUnavailableWithExplanation' "$log_p004" || {
 echo 'P0-08 FAIL: unbuilt action unavailable test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestNoDemoDataInCustomerTotals' "$log_p004" || {
 echo 'P0-08 FAIL: no demo data in customer totals test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestScopedAccessAndTenantIsolation' "$log_p004" || {
 echo 'P0-08 FAIL: scoped access and tenant isolation test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestSearchContextualModuleFilter' "$log_p004" || {
 echo 'P0-08 FAIL: contextual module filter help search test was skipped' >&2
 exit 1
}
echo 'P0-08_TESTS_PASS: Six mode identities retained, unbuilt action explanations, no demo data in totals, scoped notifications, and contextual help entry'

grep -q -- '--- PASS: TestPostgresSeedTwiceIdempotency' "$log_p004" || {
 echo 'P0-09 FAIL: live PostgreSQL seed twice idempotency test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestNoFuturePhaseRPCExposed' "$log_p004" || {
 echo 'P0-09 FAIL: no future phase RPC exposed gate test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestPostgresLiveServiceIdentityAndAPIKeys' "$log_p004" || {
 echo 'P0-09 FAIL: live PostgreSQL service identity and API keys test was skipped' >&2
 exit 1
}
echo 'P0-09_TESTS_PASS: Seed twice idempotency, no future-phase RPCs exposed, service identity and API keys isolation'

# IQ-04 & IQ-05: Targeted migration path helper for inventory/order/finance (../../../infra/migrations)
# and execution of later domain PostgreSQL integration suites against the disposable test DB.
# Cross-lane owner-file dependencies recorded (left untouched per lane ownership):
# - apps/api/internal/product/product_postgres_test.go (publish-product): uses SET LOCAL $1 with store.go []byte JSONB params
# - apps/api/internal/finance/postgres_integration_test.go (commerce-finance): uses non-canonical orders.total_amount & payout_records.status
# - apps/api/internal/seeding/seeding_postgres_test.go (commerce-finance): wraps INSERT INTO workspaces inside tenantdb.WithTx
log_domain="$(mktemp)"
ln -sfn "$ROOT/infra" "$ROOT/apps/infra"
trap 'rm -f "$log" "$log_p004" "$log_domain" "$ROOT/apps/infra"' EXIT

if [[ "$CREATIVANTA_TEST_POSTGRES_DSN" == *"?"* ]]; then
 DOMAIN_TEST_DSN="${CREATIVANTA_TEST_POSTGRES_DSN}&default_query_exec_mode=simple_protocol"
else
 DOMAIN_TEST_DSN="${CREATIVANTA_TEST_POSTGRES_DSN}?default_query_exec_mode=simple_protocol"
fi

(
 cd "$ROOT/apps/api"
 CREATIVANTA_TEST_DATABASE_URL="$CREATIVANTA_TEST_POSTGRES_DSN" \
   GOTOOLCHAIN=local go run "$ROOT/tooling/ci/prepare_domain_postgres.go"
 CREATIVANTA_TEST_DATABASE_URL="$CREATIVANTA_TEST_POSTGRES_DSN" \
   GOTOOLCHAIN=local go test -p 1 -race -count=1 -v \
   ./internal/inventory \
   ./internal/order
 CREATIVANTA_TEST_DATABASE_URL="$DOMAIN_TEST_DSN" \
   GOTOOLCHAIN=local go test -p 1 -race -count=1 -v \
   ./internal/affiliate \
   ./internal/monetization \
   ./internal/livecommerce
) | tee "$log_domain"

grep -q -- '--- PASS: TestPostgresLiveInventoryStore' "$log_domain" || {
 echo 'DOMAIN-PG FAIL: live PostgreSQL inventory store test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestPostgresLiveOrderStore' "$log_domain" || {
 echo 'DOMAIN-PG FAIL: live PostgreSQL order store test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestPostgresLiveAffiliateLinksAttributionsAndPayouts' "$log_domain" || {
 echo 'DOMAIN-PG FAIL: live PostgreSQL affiliate links/attributions/payouts test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestPostgresLiveCampaignsCouponsAndMonetization' "$log_domain" || {
 echo 'DOMAIN-PG FAIL: live PostgreSQL monetization campaigns/coupons test was skipped' >&2
 exit 1
}
grep -q -- '--- PASS: TestPostgresLiveCommerceWarRoomAndHighlights' "$log_domain" || {
 echo 'DOMAIN-PG FAIL: live PostgreSQL livecommerce war room and highlights test was skipped' >&2
 exit 1
}
echo 'DOMAIN_POSTGRES_TESTS_PASS: Inventory, Order, Affiliate, Monetization, and LiveCommerce live PostgreSQL suites'
