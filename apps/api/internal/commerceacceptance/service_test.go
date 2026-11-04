package commerceacceptance

import (
	"context"
	"fmt"
	"sync"
	"testing"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestP609_Target1_NoFunctionLostBetweenModules(t *testing.T) {
	t.Parallel()
	ctx := context.Background()
	svc := NewService(nil)
	wsID := "ws-p6-acceptance-01"

	res, err := svc.VerifyCrossModuleIntegrity(ctx, wsID)
	require.NoError(t, err)
	require.NotNil(t, res)

	assert.Equal(t, wsID, res.WorkspaceID)
	assert.True(t, res.AllModulesConnected, "All 11 P6 modules must be connected")
	assert.True(t, res.ZeroFunctionLost, "Acceptance Target 1: No function lost between modules")
	assert.True(t, res.LineageIntegrityPass, "Lineage integrity must pass")
	assert.Empty(t, res.BrokenLinks, "No broken links allowed")
	assert.NotEmpty(t, res.VerifiedLinks, "Must have verified cross-module links")

	// Ensure each required module is accounted for
	expectedModules := map[ModuleID]bool{
		ModuleM04: false,
		ModuleM05: false,
		ModuleM09: false,
		ModuleM12: false,
		ModuleM13: false,
		ModuleM14: false,
		ModuleM15: false,
		ModuleM16: false,
		ModuleM17: false,
		ModuleM18: false,
		ModuleS16: false,
		ModuleM19: false,
	}

	for _, mod := range res.ModuleSummaries {
		if _, ok := expectedModules[mod.ModuleID]; ok {
			expectedModules[mod.ModuleID] = true
			assert.Equal(t, "HEALTHY", mod.Status)
			assert.GreaterOrEqual(t, mod.ConnectedLinks, 1, "Module %s must have connected links", mod.ModuleID)
		}
	}

	for modID, found := range expectedModules {
		assert.True(t, found, "Module %s must be present in integrity summary", modID)
	}
}

func TestP609_Target2_PartialAndUnreconciledOutcomesVisible(t *testing.T) {
	t.Parallel()
	ctx := context.Background()
	svc := NewService(nil)
	wsID := "ws-p6-commerce"

	outcomes, err := svc.GetPartialAndUnreconciledOutcomes(ctx, wsID, "")
	require.NoError(t, err)
	require.NotEmpty(t, outcomes, "Must surface unreconciled and partial outcomes")

	var foundPartialRefund, foundReturnOnly, foundStockDiscrepancy, foundPendingSeeding, foundUnmatchedAffiliate, foundDisputedDeal bool

	for _, item := range outcomes {
		assert.NotEmpty(t, item.ID)
		assert.NotEmpty(t, item.Domain)
		assert.NotEmpty(t, item.SourceClass)
		assert.Greater(t, item.ConfidenceScore, 0.0)

		switch item.ID {
		case "unrec-refund-001":
			foundPartialRefund = true
			assert.Equal(t, "partially_refunded", item.Status)
			assert.Equal(t, "200000.000000", item.RefundedAmountExact.Fixed6String())
			assert.Equal(t, "500000.000000", item.OriginalCapturedExact.Fixed6String())
			assert.Equal(t, "not_returned", item.PhysicalReturnState)

		case "unrec-return-002":
			foundReturnOnly = true
			assert.Equal(t, "returned", item.Status)
			assert.Equal(t, "0.000000", item.RefundedAmountExact.Fixed6String(), "RULE-M13-006: Return without money refund is valid")
			assert.Equal(t, "returned", item.PhysicalReturnState)

		case "unrec-stock-003":
			foundStockDiscrepancy = true
			assert.Equal(t, "stock_discrepancy", item.Status)
			assert.Equal(t, SourceClassUnreconciled, item.SourceClass)
			assert.True(t, item.RequiresAuditReason, "EC-M13-004: Stock adjustment requires audit reason")

		case "unrec-seeding-004":
			foundPendingSeeding = true
			assert.Equal(t, "pending_outcome", item.Status)
			assert.Equal(t, SourceClassEstimated, item.SourceClass, "RULE-M18-002: Missing proof must not be claimed as definitive")

		case "unrec-affiliate-005":
			foundUnmatchedAffiliate = true
			assert.Equal(t, "unmatched_statement_item", item.Status)
			assert.Equal(t, SourceClassUnreconciled, item.SourceClass)

		case "unrec-deal-006":
			foundDisputedDeal = true
			assert.Equal(t, "disputed_deliverable", item.Status)
		}
	}

	assert.True(t, foundPartialRefund, "Must surface partial refund item")
	assert.True(t, foundReturnOnly, "Must surface physical return only item (RULE-M13-006)")
	assert.True(t, foundStockDiscrepancy, "Must surface stock discrepancy (EC-M13-004)")
	assert.True(t, foundPendingSeeding, "Must surface pending seeding outcome with honest confidence (RULE-M18-002)")
	assert.True(t, foundUnmatchedAffiliate, "Must surface unmatched affiliate statement items")
	assert.True(t, foundDisputedDeal, "Must surface disputed brand deal deliverable")
}

func TestP609_Target2_OperationalRepairsRequireAuditReason(t *testing.T) {
	t.Parallel()
	ctx := context.Background()
	svc := NewService(nil)
	wsID := "ws-p6-commerce"

	// 1. Audit reason missing fails closed
	repairReqNoReason := OperationalRepairRequest{
		WorkspaceID:    wsID,
		UnreconciledID: "unrec-stock-003",
		RepairType:     "reconcile_stock_adjustment",
		AuditReason:    "", // Missing
		ActorID:        "user-manager-01",
		ActorRole:      "manager",
	}
	_, err := svc.ApplyOperationalRepair(ctx, repairReqNoReason)
	assert.ErrorIs(t, err, ErrAuditReasonRequired, "Operational repair must fail closed if audit reason is omitted")

	// 2. Successful repair with valid audit reason
	repairReqValid := OperationalRepairRequest{
		WorkspaceID:    wsID,
		UnreconciledID: "unrec-stock-003",
		RepairType:     "reconcile_stock_adjustment",
		AuditReason:    "Hàng mẫu seeding #smp-01 gửi đi được đối soát thủ công và trừ kho chính thức",
		ActorID:        "user-manager-01",
		ActorRole:      "manager",
	}
	result, err := svc.ApplyOperationalRepair(ctx, repairReqValid)
	require.NoError(t, err)
	assert.True(t, result.Success)
	assert.Equal(t, "unrec-stock-003", result.UnreconciledID)
	assert.NotEmpty(t, result.LedgerPostingID, "Must generate ledger posting for repair")
	assert.NotEmpty(t, result.AuditLogEntryID, "Must generate audit log entry")

	// 3. Second repair attempt on same item fails closed (replay protection)
	_, err = svc.ApplyOperationalRepair(ctx, repairReqValid)
	assert.ErrorIs(t, err, ErrRepairAlreadyApplied, "Duplicate repair must be blocked")

	// 4. Verify item updated to resolved
	outcomes, err := svc.GetPartialAndUnreconciledOutcomes(ctx, wsID, "stock_movement")
	require.NoError(t, err)
	var resolvedItem *UnreconciledOutcome
	for _, o := range outcomes {
		if o.ID == "unrec-stock-003" {
			resolvedItem = &o
			break
		}
	}
	require.NotNil(t, resolvedItem)
	assert.True(t, resolvedItem.Resolved)
	assert.Equal(t, "reconciled", resolvedItem.Status)
	assert.Equal(t, SourceClassOfficial, resolvedItem.SourceClass)
	assert.Equal(t, 1.0, resolvedItem.ConfidenceScore)
}

func TestP609_Target3_ShippingCarrierGateAndHMACVerification(t *testing.T) {
	t.Parallel()
	adapter := NewShippingAdapter()

	// 1. Register parcel
	cost := tenantdb.MustParseExactDecimal("35000.000000")
	parcel, err := adapter.RegisterParcel(CarrierGHN, "order-test-01", "", 450, "Da Nang", cost)
	require.NoError(t, err)
	require.NotNil(t, parcel)
	assert.Equal(t, TrackingCreated, parcel.State)
	assert.Equal(t, CarrierGHN, parcel.Carrier)

	// 2. Prepare valid webhook payload and signature
	payload := []byte(fmt.Sprintf(`{"tracking_number":"%s","status":"in_transit"}`, parcel.TrackingNumber))
	validSig := adapter.ComputeSignature(CarrierGHN, payload)

	// 3. Ingest webhook with valid signature
	updated, err := adapter.IngestCarrierWebhook(CarrierGHN, parcel.TrackingNumber, TrackingInTransit, payload, validSig, "nonce-001")
	require.NoError(t, err)
	assert.Equal(t, TrackingInTransit, updated.State)
	assert.True(t, updated.SignatureVerified)

	// 4. Webhook with forged/tampered signature fails closed
	badSig := "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"
	_, err = adapter.IngestCarrierWebhook(CarrierGHN, parcel.TrackingNumber, TrackingOutForDelivery, payload, badSig, "nonce-002")
	assert.ErrorIs(t, err, ErrInvalidCarrierSignature, "Tampered carrier signature must fail closed")

	// 5. Invalid state transition fails closed (e.g. InTransit -> Created is invalid regression)
	outPayload := []byte(fmt.Sprintf(`{"tracking_number":"%s","status":"created"}`, parcel.TrackingNumber))
	outSig := adapter.ComputeSignature(CarrierGHN, outPayload)
	_, err = adapter.IngestCarrierWebhook(CarrierGHN, parcel.TrackingNumber, TrackingCreated, outPayload, outSig, "nonce-003")
	assert.ErrorIs(t, err, ErrInvalidTrackingState, "Regressive state transitions must be rejected")

	// 6. Valid transition to out_for_delivery then delivered
	delPayload := []byte(fmt.Sprintf(`{"tracking_number":"%s","status":"out_for_delivery"}`, parcel.TrackingNumber))
	delSig := adapter.ComputeSignature(CarrierGHN, delPayload)
	updated, err = adapter.IngestCarrierWebhook(CarrierGHN, parcel.TrackingNumber, TrackingOutForDelivery, delPayload, delSig, "nonce-004")
	require.NoError(t, err)
	assert.Equal(t, TrackingOutForDelivery, updated.State)

	finPayload := []byte(fmt.Sprintf(`{"tracking_number":"%s","status":"delivered"}`, parcel.TrackingNumber))
	finSig := adapter.ComputeSignature(CarrierGHN, finPayload)
	finalParcel, err := adapter.IngestCarrierWebhook(CarrierGHN, parcel.TrackingNumber, TrackingDelivered, finPayload, finSig, "nonce-005")
	require.NoError(t, err)
	assert.Equal(t, TrackingDelivered, finalParcel.State)

	// 7. Duplicate webhook replay on same nonce is idempotent
	replayed, err := adapter.IngestCarrierWebhook(CarrierGHN, parcel.TrackingNumber, TrackingDelivered, finPayload, finSig, "nonce-005")
	require.NoError(t, err)
	assert.Equal(t, TrackingDelivered, replayed.State)
}

func TestP609_Target3_ProviderAndShippingGateTruth(t *testing.T) {
	t.Parallel()
	ctx := context.Background()
	svc := NewService(nil)
	wsID := "ws-p6-gates-01"

	summary, err := svc.VerifyProviderAndShippingGates(ctx, wsID)
	require.NoError(t, err)
	require.NotNil(t, summary)

	assert.Equal(t, wsID, summary.WorkspaceID)
	assert.NotEmpty(t, summary.PaymentGates)
	assert.NotEmpty(t, summary.ShippingGates)
	assert.NotEmpty(t, summary.ExternalGates)

	// Verify Payment Gates exist for all 4 platforms
	providers := make(map[string]bool)
	for _, pg := range summary.PaymentGates {
		providers[pg.Provider] = true
		assert.True(t, pg.Configured)
		assert.True(t, pg.WebhookHMACVerified, "HMAC signature must be verified locally")
		assert.True(t, pg.ReplayDeduplicated, "Replay deduplication must be enforced")
		assert.True(t, pg.LatePaymentRecovery, "Late payment recovery must be supported")
	}
	assert.True(t, providers["stripe"])
	assert.True(t, providers["tiktok_shop"])
	assert.True(t, providers["shopee"])
	assert.True(t, providers["lazada"])

	// Verify External Gates explicitly record honest status
	gatesMap := make(map[string]string)
	for _, eg := range summary.ExternalGates {
		gatesMap[eg.GateID] = eg.Status
	}
	assert.Equal(t, "PENDING_PRODUCTION_KEY", gatesMap["EXT-GATE-PAYMENT-STRIPE-LIVE"])
	assert.Equal(t, "PENDING_EXTERNAL_PROVIDER_APPROVAL", gatesMap["EXT-GATE-PLATFORM-TIKTOK-PARTNER"])
	assert.Equal(t, "PENDING_CARRIER_PRODUCTION_KEY", gatesMap["EXT-GATE-SHIPPING-CARRIER-API"])
	assert.Equal(t, "PENDING_CI_LIVE_POSTGRES", gatesMap["EXT-GATE-POSTGRES-LIVE-RLS"])
}

func TestP609_ConcurrencyAndRaceProtection(t *testing.T) {
	t.Parallel()
	ctx := context.Background()
	svc := NewService(nil)
	wsID := "ws-p6-concurrency"

	const goroutines = 20
	var wg sync.WaitGroup
	wg.Add(goroutines)

	for i := 0; i < goroutines; i++ {
		go func(idx int) {
			defer wg.Done()

			// Add dynamic unreconciled item
			itemID := fmt.Sprintf("unrec-dyn-%d", idx)
			svc.AddUnreconciledOutcome(&UnreconciledOutcome{
				ID:                   itemID,
				WorkspaceID:          wsID,
				Domain:               "order_refund",
				EntityID:             fmt.Sprintf("order-%d", idx),
				Title:                fmt.Sprintf("Concurrent Item %d", idx),
				SourceClass:          SourceClassInferred,
				ConfidenceScore:      0.75,
				Status:               "partially_refunded",
				FinancialImpactExact: tenantdb.MustParseExactDecimal("50000.000000"),
				RequiresAuditReason:  true,
				CreatedAt:            time.Now().UTC(),
			})

			// Query outcomes concurrently
			outcomes, err := svc.GetPartialAndUnreconciledOutcomes(ctx, wsID, "")
			assert.NoError(t, err)
			assert.NotEmpty(t, outcomes)

			// Apply repair concurrently
			req := OperationalRepairRequest{
				WorkspaceID:    wsID,
				UnreconciledID: itemID,
				RepairType:     "settle_partial_refund",
				AuditReason:    fmt.Sprintf("Concurrent repair reason %d", idx),
				ActorID:        fmt.Sprintf("user-%d", idx),
				ActorRole:      "manager",
			}
			res, err := svc.ApplyOperationalRepair(ctx, req)
			assert.NoError(t, err)
			assert.True(t, res.Success)

			// Query gates concurrently
			gates, err := svc.VerifyProviderAndShippingGates(ctx, wsID)
			assert.NoError(t, err)
			assert.NotNil(t, gates)
		}(i)
	}

	wg.Wait()
}
