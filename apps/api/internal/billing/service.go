package billing

import (
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"fmt"
	"strings"
	"time"

	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"google.golang.org/protobuf/types/known/timestamppb"
)

var (
	// ErrInvalidWebhookSignature indicates a Stripe webhook failed HMAC-SHA256 verification.
	ErrInvalidWebhookSignature = errors.New("BILLING_FORBIDDEN_001: invalid Stripe webhook signature")
	// ErrInvalidBillingInput indicates malformed billing/credit command arguments.
	ErrInvalidBillingInput = errors.New("AI_INVALID_001: invalid billing or credit request parameters")
)

// StripeWebhookEvent represents an inbound payment/subscription webhook event from Stripe.
type StripeWebhookEvent struct {
	EventID           string
	EventType         string // "checkout.session.completed", "invoice.paid", "invoice.payment_failed"
	WorkspaceID       string
	CheckoutSessionID string
	StripeInvoiceID   string
	SubscriptionID    string
	StripePriceID     string
	TargetPlan        string
	BillingInterval   string
	Currency          string
	AmountPaid        tenantdb.ExactDecimal
	PeriodKey         string
	PaymentStatus     string // optional; when set on payment/invoice events, must be "paid"
	NextPeriodEnd     time.Time
	OccurredAt        time.Time
}

// WebhookSettlementResult reports the outcome of processing a StripeWebhookEvent.
type WebhookSettlementResult struct {
	EventID    string
	Duplicate  bool
	Status     string
	GrantedLot *tenantdb.CreditLotRow
	Invoice    *tenantdb.InvoiceRow
}

// Service implements RBAC-enforced handlers for AdminBillingService, CreditService,
// and BillingService, plus the verified Stripe webhook settlement sandbox.
type Service struct {
	rbac          *rbac.Registry
	engine        *Engine
	webhookSecret string
	clock         func() time.Time
}

// NewService constructs a billing Service bound to the canonical RBAC registry and credit Engine.
func NewService(reg *rbac.Registry, engine *Engine, webhookSecret string) *Service {
	if engine == nil {
		engine = NewEngine(NewMemoryStore(time.Now().UTC()))
	}
	return &Service{
		rbac:          reg,
		engine:        engine,
		webhookSecret: webhookSecret,
		clock:         func() time.Time { return time.Now().UTC() },
	}
}

// SetClock overrides the service clock for deterministic time-based tests.
func (s *Service) SetClock(clockFn func() time.Time) {
	if clockFn != nil {
		s.clock = clockFn
	}
}

// Engine returns the underlying credit & billing Engine.
func (s *Service) Engine() *Engine {
	return s.engine
}

func (s *Service) requirePermission(ctx context.Context, rpcName string, targetWorkspaceID string) (rbac.PolicyContext, error) {
	if s.rbac == nil {
		return rbac.PolicyContext{}, rbac.ErrPermissionDenied
	}
	pctx, ok := rbac.PolicyContextFromContext(ctx)
	if !ok {
		return rbac.PolicyContext{}, rbac.ErrPermissionDenied
	}
	if strings.TrimSpace(targetWorkspaceID) != "" && targetWorkspaceID != pctx.WorkspaceID {
		return rbac.PolicyContext{}, tenantdb.ErrScopeMismatch
	}
	if err := s.rbac.Require(ctx, rpcName, pctx.WorkspaceID); err != nil {
		return rbac.PolicyContext{}, err
	}
	return pctx, nil
}

// ComputeStripeSignature computes an HMAC-SHA256 hex digest over payload using secret.
func ComputeStripeSignature(payload []byte, secret string) string {
	mac := hmac.New(sha256.New, []byte(secret))
	mac.Write(payload)
	return hex.EncodeToString(mac.Sum(nil))
}

// VerifyStripeSignature verifies a webhook signature using constant-time HMAC comparison.
func (s *Service) VerifyStripeSignature(payload []byte, signatureHex string) error {
	if strings.TrimSpace(s.webhookSecret) == "" {
		return ErrInvalidWebhookSignature
	}
	expected := ComputeStripeSignature(payload, s.webhookSecret)
	if !hmac.Equal([]byte(strings.ToLower(strings.TrimSpace(signatureHex))), []byte(expected)) {
		return ErrInvalidWebhookSignature
	}
	return nil
}

// EstimateCost implements AdminBillingService/EstimateCost (credits:view_balance).
// Computes and persists a versioned cost-based CreditQuote.
func (s *Service) EstimateCost(ctx context.Context, req *adminv1.EstimateCostRequest) (*adminv1.EstimateCostResponse, error) {
	wsID := ""
	if req.GetContext().GetWorkspaceId() != nil {
		wsID = req.GetContext().GetWorkspaceId().GetValue()
	}
	pctx, err := s.requirePermission(ctx, "AdminBillingService/EstimateCost", wsID)
	if err != nil {
		return nil, err
	}
	now := s.clock()

	quoteRow, err := s.engine.CreateQuote(QuoteInput{
		WorkspaceID:         pctx.WorkspaceID,
		OperationType:       req.GetOperationType(),
		Provider:            req.GetProvider(),
		ModelID:             req.GetModelId(),
		FallbackProvider:    req.GetFallbackProvider(),
		FallbackModelID:     req.GetFallbackModelId(),
		MaxProviderAttempts: req.GetMaxProviderAttempts(),
		MeasuredUnits:       req.GetMeasuredUnits(),
	}, now)
	if err != nil {
		return nil, err
	}

	bal, err := s.engine.GetBalance(pctx.WorkspaceID, now)
	if err != nil {
		return nil, err
	}

	return &adminv1.EstimateCostResponse{
		Quote: &adminv1.CreditQuote{
			QuoteId:           &commonv1.UUID{Value: quoteRow.QuoteID},
			OperationType:     quoteRow.OperationType,
			RateVersion:       quoteRow.RateVersion,
			RequestHash:       quoteRow.RequestHash,
			CostCeilingUsd:    quoteRow.CostCeilingUSD.Fixed6String(),
			UsdPerCreditFloor: quoteRow.USDPerCreditFloor.Fixed6String(),
			GrossMarginFloor:  quoteRow.GrossMarginFloor.String(),
			QuotedCredits:     quoteRow.QuotedCredits.String(),
			ExpiresAt:         timestamppb.New(quoteRow.ExpiresAt),
			ProviderPlanJson:  string(quoteRow.ProviderPlanJSON),
		},
		CurrentBalance:    bal.ToProto(),
		SufficientCredits: bal.Available.Cmp(quoteRow.QuotedCredits) >= 0,
	}, nil
}

// GetCreditBalance implements AdminBillingService/GetCreditBalance (credits:view_balance).
func (s *Service) GetCreditBalance(ctx context.Context, req *adminv1.GetCreditBalanceRequest) (*adminv1.GetCreditBalanceResponse, error) {
	pctx, err := s.requirePermission(ctx, "AdminBillingService/GetCreditBalance", req.GetWorkspaceId().GetValue())
	if err != nil {
		return nil, err
	}
	bal, err := s.engine.GetBalance(pctx.WorkspaceID, s.clock())
	if err != nil {
		return nil, err
	}
	return &adminv1.GetCreditBalanceResponse{Balance: bal.ToProto()}, nil
}

// GetBalance implements CreditService/GetBalance (credits:view_balance).
func (s *Service) GetBalance(ctx context.Context, req *adminv1.GetBalanceRequest) (*adminv1.GetBalanceResponse, error) {
	pctx, err := s.requirePermission(ctx, "CreditService/GetBalance", req.GetWorkspaceId().GetValue())
	if err != nil {
		return nil, err
	}
	bal, err := s.engine.GetBalance(pctx.WorkspaceID, s.clock())
	if err != nil {
		return nil, err
	}
	return &adminv1.GetBalanceResponse{Balance: bal.ToProto()}, nil
}

// ListPlans implements BillingService/ListPlans (workspace:billing:read).
func (s *Service) ListPlans(ctx context.Context, _ *adminv1.ListPlansRequest) (*adminv1.ListPlansResponse, error) {
	if _, err := s.requirePermission(ctx, "BillingService/ListPlans", ""); err != nil {
		return nil, err
	}
	tiers := ListTierSpecs()
	plans := make([]*adminv1.PlanCatalogEntry, 0, len(tiers))
	for _, t := range tiers {
		plans = append(plans, t.ToProtoPlanCatalogEntry())
	}
	addonSpecs := ListAddonSpecs()
	addons := make([]*adminv1.AddonCatalogEntry, 0, len(addonSpecs))
	for _, a := range addonSpecs {
		addons = append(addons, a.ToProtoAddonCatalogEntry())
	}
	return &adminv1.ListPlansResponse{
		Plans:            plans,
		Addons:           addons,
		PricebookVersion: PricebookVersion,
	}, nil
}

// ListPackages implements CreditService/ListPackages (credits:view_balance).
func (s *Service) ListPackages(ctx context.Context, _ *adminv1.ListPackagesRequest) (*adminv1.ListPackagesResponse, error) {
	if _, err := s.requirePermission(ctx, "CreditService/ListPackages", ""); err != nil {
		return nil, err
	}
	packs := ListCreditPackSpecs()
	out := make([]*adminv1.CreditPackEntry, 0, len(packs))
	for _, p := range packs {
		out = append(out, p.ToProtoCreditPackEntry())
	}
	return &adminv1.ListPackagesResponse{
		Packages:         out,
		PricebookVersion: PricebookVersion,
	}, nil
}

// PurchaseCredits implements AdminBillingService/PurchaseCredits (credits:top_up, Owner-only).
// Creates a pending checkout session; credits are NEVER granted until verified webhook settlement.
func (s *Service) PurchaseCredits(ctx context.Context, req *adminv1.PurchaseCreditsRequest) (*adminv1.PurchaseCreditsResponse, error) {
	wsID := ""
	if req.GetContext().GetWorkspaceId() != nil {
		wsID = req.GetContext().GetWorkspaceId().GetValue()
	}
	pctx, err := s.requirePermission(ctx, "AdminBillingService/PurchaseCredits", wsID)
	if err != nil {
		return nil, err
	}
	return s.createPackCheckout(pctx, req.GetContext().GetIdempotencyKey(), req.GetPackCode(), req.GetCurrency())
}

// Purchase implements CreditService/Purchase (credits:top_up, Owner-only).
func (s *Service) Purchase(ctx context.Context, req *adminv1.PurchaseRequest) (*adminv1.PurchaseResponse, error) {
	wsID := ""
	if req.GetContext().GetWorkspaceId() != nil {
		wsID = req.GetContext().GetWorkspaceId().GetValue()
	}
	pctx, err := s.requirePermission(ctx, "CreditService/Purchase", wsID)
	if err != nil {
		return nil, err
	}
	res, err := s.createPackCheckout(pctx, req.GetContext().GetIdempotencyKey(), req.GetPackCode(), req.GetCurrency())
	if err != nil {
		return nil, err
	}
	return &adminv1.PurchaseResponse{
		CheckoutSessionId: res.GetCheckoutSessionId(),
		CheckoutUrl:       res.GetCheckoutUrl(),
		Status:            res.GetStatus(),
		Pack:              res.GetPack(),
	}, nil
}

func (s *Service) createPackCheckout(pctx rbac.PolicyContext, idempotencyKey, packCode, currency string) (*adminv1.PurchaseCreditsResponse, error) {
	if strings.TrimSpace(idempotencyKey) == "" {
		return nil, fmt.Errorf("%w: idempotency_key is required", ErrInvalidBillingInput)
	}
	pack, ok := LookupCreditPack(packCode)
	if !ok {
		return nil, fmt.Errorf("%w: unknown credit pack %q", ErrInvalidBillingInput, packCode)
	}
	curr := strings.ToUpper(strings.TrimSpace(currency))
	if curr == "" {
		curr = "USD"
	}
	if curr != "USD" && curr != "VND" {
		return nil, fmt.Errorf("%w: unsupported billing currency %q", ErrInvalidBillingInput, curr)
	}
	price := pack.PriceUSD
	if curr == "VND" {
		price = pack.PriceVND
	}

	now := s.clock()
	sessionID := "cs_pack_" + idempotencyKey
	err := s.engine.store.WithWorkspaceTx(pctx.WorkspaceID, func(st *WorkspaceBillingState) error {
		if _, exists := st.CheckoutSessions[sessionID]; exists {
			return nil
		}
		st.CheckoutSessions[sessionID] = &CheckoutSessionRecord{
			SessionID:   sessionID,
			WorkspaceID: pctx.WorkspaceID,
			UserID:      pctx.ActorUserID,
			Kind:        "credit_pack",
			PackCode:    pack.PackCode,
			Currency:    curr,
			Amount:      price,
			Status:      "pending",
			CreatedAt:   now,
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return &adminv1.PurchaseCreditsResponse{
		CheckoutSessionId: sessionID,
		CheckoutUrl:       "https://checkout.stripe.com/pay/" + sessionID,
		Status:            "pending_webhook_settlement",
		Pack:              pack.ToProtoCreditPackEntry(),
	}, nil
}

// ChangePlan implements AdminBillingService/ChangePlan (workspace:billing:manage, Owner-only).
func (s *Service) ChangePlan(ctx context.Context, req *adminv1.ChangePlanRequest) (*adminv1.ChangePlanResponse, error) {
	wsID := ""
	if req.GetContext().GetWorkspaceId() != nil {
		wsID = req.GetContext().GetWorkspaceId().GetValue()
	}
	if req.GetStartTrial() {
		subSummary, err := s.StartProTrial(ctx, wsID)
		if err != nil {
			return nil, err
		}
		return &adminv1.ChangePlanResponse{
			Subscription:      subSummary,
			EffectiveMode:     "trial_started_14d",
			CheckoutSessionId: "cs_trial_" + req.GetContext().GetIdempotencyKey(),
		}, nil
	}

	pctx, err := s.requirePermission(ctx, "AdminBillingService/ChangePlan", wsID)
	if err != nil {
		return nil, err
	}
	if strings.TrimSpace(req.GetContext().GetIdempotencyKey()) == "" {
		return nil, fmt.Errorf("%w: idempotency_key is required", ErrInvalidBillingInput)
	}
	targetTier, ok := LookupTier(req.GetTargetPlan())
	if !ok {
		return nil, fmt.Errorf("%w: unknown subscription plan %q", ErrInvalidBillingInput, req.GetTargetPlan())
	}
	interval := strings.ToLower(strings.TrimSpace(req.GetBillingInterval()))
	if interval == "" {
		interval = "monthly"
	}
	if interval != "monthly" && interval != "annual" {
		return nil, fmt.Errorf("%w: billing_interval must be monthly or annual", ErrInvalidBillingInput)
	}
	curr := strings.ToUpper(strings.TrimSpace(req.GetCurrency()))
	if curr == "" {
		curr = "USD"
	}
	if curr != "USD" && curr != "VND" {
		return nil, fmt.Errorf("%w: currency must be USD or VND", ErrInvalidBillingInput)
	}

	// Validate add-ons against target tier eligibility.
	for _, addonCode := range req.GetAddons() {
		addon, addonOK := LookupAddon(addonCode)
		if !addonOK {
			return nil, fmt.Errorf("%w: unknown add-on %q", ErrInvalidBillingInput, addonCode)
		}
		eligible := false
		for _, el := range addon.EligibleTiers {
			if el == targetTier.TierCode {
				eligible = true
				break
			}
		}
		if !eligible {
			return nil, fmt.Errorf("%w: add-on %q is not eligible on tier %q", ErrPlanFeatureNotAllowed, addonCode, targetTier.TierCode)
		}
	}

	now := s.clock()
	var resp *adminv1.ChangePlanResponse
	err = s.engine.store.WithWorkspaceTx(pctx.WorkspaceID, func(st *WorkspaceBillingState) error {
		currentTier, ok := LookupTier(st.SubscriptionTier)
		if !ok {
			currentTier, _ = LookupTier("free")
		}

		// Downgrade usage validation (reporting_admin_billing.md §5).
		if targetTier.Rank < currentTier.Rank {
			if st.SeatsUsed > targetTier.MaxSeats || st.ChannelsUsed > targetTier.MaxChannels || st.StorageUsedGB > targetTier.MaxStorageGB {
				return fmt.Errorf(
					"%w: workspace usage (seats=%d/%d, channels=%d/%d, storage=%d/%d GB) exceeds %s tier limits",
					ErrPlanDowngradeUsageExceedsLimit,
					st.SeatsUsed, targetTier.MaxSeats,
					st.ChannelsUsed, targetTier.MaxChannels,
					st.StorageUsedGB, targetTier.MaxStorageGB,
					targetTier.TierCode,
				)
			}
		}

		if req.GetAcceptOverageTerms() {
			st.OverageTermsAccepted = true
		}

		amount := targetTier.MonthlyPriceUSD
		if curr == "USD" && interval == "annual" {
			amount = targetTier.AnnualPriceUSD
		} else if curr == "VND" && interval == "monthly" {
			amount = targetTier.MonthlyPriceVND
		} else if curr == "VND" && interval == "annual" {
			amount = targetTier.AnnualPriceVND
		}

		effectiveMode := "immediate_prorated"
		if targetTier.Rank < currentTier.Rank {
			effectiveMode = "end_of_period"
		}

		subID := "90000000-0000-4000-8000-000000000001"
		periodStart := now
		periodEnd := now.Add(30 * 24 * time.Hour)
		if interval == "annual" {
			periodEnd = now.Add(365 * 24 * time.Hour)
		}
		var existingAddons []string
		if st.Subscription != nil {
			subID = st.Subscription.SubscriptionID
			existingAddons = append(existingAddons, st.Subscription.Addons...)
			if !st.Subscription.CurrentPeriodStart.IsZero() && !st.Subscription.CurrentPeriodEnd.IsZero() && st.Subscription.CurrentPeriodEnd.After(now) {
				periodStart = st.Subscription.CurrentPeriodStart
				periodEnd = st.Subscription.CurrentPeriodEnd
			}
		}

		// Compute mid-cycle proration for newly added add-ons (pricing_and_credits.md §1.2).
		existingAddonSet := make(map[string]bool, len(existingAddons))
		for _, a := range existingAddons {
			existingAddonSet[a] = true
		}
		totalDays := int(periodEnd.Sub(periodStart).Hours() / 24)
		if totalDays <= 0 {
			totalDays = 30
		}
		remainingDays := int(periodEnd.Sub(now).Hours() / 24)
		if remainingDays <= 0 {
			remainingDays = totalDays
		}
		proratedAddonTotal := tenantdb.ZeroDecimal()
		mergedAddons := append([]string{}, existingAddons...)
		newlyAddedAddonCount := 0
		for _, addonCode := range req.GetAddons() {
			if !existingAddonSet[addonCode] {
				mergedAddons = append(mergedAddons, addonCode)
				existingAddonSet[addonCode] = true
				newlyAddedAddonCount++
				if addonSpec, aOK := LookupAddon(addonCode); aOK {
					prorated, pErr := ComputeAddonProration(addonSpec, interval, curr, remainingDays, totalDays)
					if pErr == nil {
						proratedAddonTotal, _ = proratedAddonTotal.Add(prorated)
					}
				}
			}
		}

		// Schedule add-on removals for the next billing cycle (pricing_and_credits.md §1.2:
		// removed add-ons remain active until current_period_end, no partial refund).
		if len(req.GetRemoveAddons()) > 0 {
			schedSet := make(map[string]bool, len(st.ScheduledAddonRemovals))
			for _, r := range st.ScheduledAddonRemovals {
				schedSet[r] = true
			}
			for _, rem := range req.GetRemoveAddons() {
				if !schedSet[rem] {
					st.ScheduledAddonRemovals = append(st.ScheduledAddonRemovals, rem)
					schedSet[rem] = true
				}
			}
		}

		requiresPaidSettlement := (targetTier.Rank > currentTier.Rank && targetTier.TierCode != "free") || newlyAddedAddonCount > 0
		sessID := "cs_plan_" + strings.TrimSpace(req.GetContext().GetIdempotencyKey())

		if requiresPaidSettlement {
			// F06: Paid tier upgrades and paid add-on additions NEVER activate immediately in ChangePlan.
			// Record a pending CheckoutSessionRecord; activation occurs only upon verified webhook settlement.
			checkoutTotal := proratedAddonTotal
			if targetTier.Rank > currentTier.Rank && targetTier.TierCode != "free" {
				checkoutTotal, _ = amount.Add(proratedAddonTotal)
			}
			sessionSubID := ""
			if st.Subscription != nil && st.Subscription.SubscriptionID != "" {
				sessionSubID = st.Subscription.SubscriptionID
			}
			priceID := fmt.Sprintf("price_%s_%s_%s", targetTier.TierCode, interval, strings.ToLower(curr))
			st.CheckoutSessions[sessID] = &CheckoutSessionRecord{
				SessionID:           sessID,
				WorkspaceID:         pctx.WorkspaceID,
				UserID:              pctx.ActorUserID,
				SubscriptionID:      sessionSubID,
				StripePriceID:       priceID,
				Kind:                "subscription_plan",
				TargetPlan:          targetTier.TierCode,
				Interval:            interval,
				Currency:            curr,
				BaseAmount:          amount,
				ProratedAddonCharge: proratedAddonTotal,
				Amount:              checkoutTotal,
				Addons:              mergedAddons,
				AcceptOverageTerms:  req.GetAcceptOverageTerms(),
				Status:              "pending",
				CreatedAt:           now,
			}

			pendingSummary := subscriptionStateToProto(st)
			if pendingSummary == nil {
				pendingSummary = &adminv1.SubscriptionSummary{
					SubscriptionId:  &commonv1.UUID{Value: subID},
					WorkspaceId:     &commonv1.UUID{Value: pctx.WorkspaceID},
					Plan:            currentTier.TierCode,
					Status:          adminv1.SubscriptionStatus_SUBSCRIPTION_STATUS_INCOMPLETE,
					BillingInterval: interval,
					Amount:          &commonv1.Money{Amount: amount.String(), Currency: curr},
				}
			}

			resp = &adminv1.ChangePlanResponse{
				Subscription:           pendingSummary,
				EffectiveMode:          "pending_payment",
				CheckoutSessionId:      sessID,
				CheckoutUrl:            "https://checkout.stripe.com/c/pay/" + sessID,
				ProratedAddonCharge:    &commonv1.Money{Amount: proratedAddonTotal.String(), Currency: curr},
				ScheduledAddonRemovals: append([]string{}, st.ScheduledAddonRemovals...),
			}
			return nil
		}

		if effectiveMode == "immediate_prorated" {
			st.SubscriptionTier = targetTier.TierCode
		}
		st.Subscription = &tenantdb.SubscriptionRow{
			SubscriptionID:     subID,
			WorkspaceID:        pctx.WorkspaceID,
			Plan:               targetTier.TierCode,
			BillingInterval:    interval,
			Status:             "active",
			Amount:             amount,
			Currency:           curr,
			CurrentPeriodStart: periodStart,
			CurrentPeriodEnd:   periodEnd,
			CancelAtPeriodEnd:  false,
			Addons:             mergedAddons,
			CreatedAt:          now,
			UpdatedAt:          now,
		}

		st.OutboxEvents = append(st.OutboxEvents, EmittedEvent{
			EventType:      EventBillingPlanChanged,
			WorkspaceID:    pctx.WorkspaceID,
			AggregateType:  "subscription",
			AggregateID:    subID,
			IdempotencyKey: "evt:plan_change:" + req.GetContext().GetIdempotencyKey(),
			Payload: map[string]any{
				"previous_plan":         currentTier.TierCode,
				"target_plan":           targetTier.TierCode,
				"effective_mode":        effectiveMode,
				"prorated_addon_charge": proratedAddonTotal.String(),
			},
			CreatedAt: now,
		})

		resp = &adminv1.ChangePlanResponse{
			Subscription:           subscriptionStateToProto(st),
			EffectiveMode:          effectiveMode,
			CheckoutSessionId:      sessID,
			ProratedAddonCharge:    &commonv1.Money{Amount: proratedAddonTotal.String(), Currency: curr},
			ScheduledAddonRemovals: append([]string{}, st.ScheduledAddonRemovals...),
		}
		return nil
	})
	return resp, err
}

// CancelSubscription implements AdminBillingService/CancelSubscription (workspace:billing:manage, Owner-only).
func (s *Service) CancelSubscription(ctx context.Context, req *adminv1.CancelSubscriptionRequest) (*adminv1.CancelSubscriptionResponse, error) {
	wsID := ""
	if req.GetContext().GetWorkspaceId() != nil {
		wsID = req.GetContext().GetWorkspaceId().GetValue()
	}
	pctx, err := s.requirePermission(ctx, "AdminBillingService/CancelSubscription", wsID)
	if err != nil {
		return nil, err
	}
	now := s.clock()
	var resp *adminv1.CancelSubscriptionResponse
	err = s.engine.store.WithWorkspaceTx(pctx.WorkspaceID, func(st *WorkspaceBillingState) error {
		tier, ok := LookupTier(st.SubscriptionTier)
		if !ok {
			tier, _ = LookupTier("free")
		}
		if req.GetAcceptRetentionOffer() && st.RetentionOfferApplied {
			return ErrRetentionOfferAlreadyUsed
		}
		if req.GetPauseInstead() {
			if !tier.PauseEligible {
				return ErrPlanFeatureNotAllowed
			}
			pauseDays := req.GetPauseDays()
			if pauseDays == 0 && req.GetPauseMonths() > 0 {
				pauseDays = req.GetPauseMonths() * 30
			}
			if pauseDays < 1 || pauseDays > 90 {
				return fmt.Errorf("%w: pause duration must be between 1 and 90 days (1 to 3 months)", ErrInvalidBillingInput)
			}
		}

		if st.Subscription == nil {
			st.Subscription = &tenantdb.SubscriptionRow{
				SubscriptionID:     "90000000-0000-4000-8000-000000000001",
				WorkspaceID:        pctx.WorkspaceID,
				Plan:               tier.TierCode,
				BillingInterval:    "monthly",
				Status:             "active",
				Amount:             tier.MonthlyPriceUSD,
				Currency:           "USD",
				CurrentPeriodStart: now,
				CurrentPeriodEnd:   now.Add(30 * 24 * time.Hour),
				CreatedAt:          now,
			}
		}

		if req.GetAcceptRetentionOffer() {
			// Apply 30% discount for 3 months (max 1 per workspace lifetime; reporting_admin_billing.md §5).
			st.RetentionOfferApplied = true
			st.RetentionOfferDiscountPct = "30"
			st.RetentionOfferMonths = 3
			discounted, dErr := st.Subscription.Amount.Mul(tenantdb.MustParseExactDecimal("0.70"))
			if dErr == nil {
				st.Subscription.Amount = discounted
			}
			st.Subscription.Status = "active"
			st.Subscription.CancelAtPeriodEnd = false
			st.Subscription.CanceledAt = nil
			st.RetentionPhase = RetentionPhaseActive
		} else if req.GetPauseInstead() {
			pauseDays := req.GetPauseDays()
			if pauseDays == 0 {
				pauseDays = req.GetPauseMonths() * 30
			}
			t := now.UTC()
			resumeAt := t.Add(time.Duration(pauseDays) * 24 * time.Hour)
			st.Subscription.Status = "paused"
			st.PausedAt = &t
			st.PauseAutoResumesAt = &resumeAt
			st.ReadOnlyMode = true
			st.ReadOnlyReason = "subscription_paused"
			st.RetentionPhase = "paused_read_only"
		} else {
			// Voluntary cancellation: subscription remains active until current_period_end (cancel_scheduled).
			// Unlike dunning (which enters read-only grace at Day 7 and downgrades to Free at Day 14),
			// voluntary cancellation keeps full paid tier features active until current_period_end,
			// and then enters the 30d/60d/90d retention quarantine schedule (Acceptance Target #1).
			st.Subscription.CancelAtPeriodEnd = true
			t := now
			st.Subscription.CanceledAt = &t
			st.ReadOnlyMode = false
			st.ReadOnlyReason = ""
			st.RetentionPhase = "cancel_scheduled"
			st.OutboxEvents = append(st.OutboxEvents, EmittedEvent{
				EventType:      EventBillingSubscriptionCancel,
				WorkspaceID:    pctx.WorkspaceID,
				AggregateType:  "subscription",
				AggregateID:    st.Subscription.SubscriptionID,
				IdempotencyKey: "evt:sub_cancel:" + req.GetContext().GetIdempotencyKey(),
				Payload: map[string]any{
					"reason":               req.GetCancellationReason(),
					"cancel_at_period_end": true,
				},
				CreatedAt: now,
			})
		}
		st.Subscription.UpdatedAt = now
		subSummary := subscriptionStateToProto(st)
		resp = &adminv1.CancelSubscriptionResponse{
			Subscription:            subSummary,
			RetentionOfferApplied:   st.RetentionOfferApplied,
			RetentionDiscountPct:    st.RetentionOfferDiscountPct,
			RetentionDiscountMonths: st.RetentionOfferMonths,
			RetentionPhase:          st.RetentionPhase,
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return resp, nil
}

// UpdatePaymentMethod implements AdminBillingService/UpdatePaymentMethod (workspace:billing:manage, Owner-only).
// Enforces:
//   - Payment method access gates (card enabled by default; bank_transfer, momo, zalopay, vnpay, paypal behind access gates).
//   - EC-M23-001: blocks removing the last payment method while on an active paid plan (BILLING_CONFLICT_001).
func (s *Service) UpdatePaymentMethod(ctx context.Context, req *adminv1.UpdatePaymentMethodRequest) (*adminv1.UpdatePaymentMethodResponse, error) {
	wsID := ""
	if req.GetContext().GetWorkspaceId() != nil {
		wsID = req.GetContext().GetWorkspaceId().GetValue()
	}
	pctx, err := s.requirePermission(ctx, "AdminBillingService/UpdatePaymentMethod", wsID)
	if err != nil {
		return nil, err
	}
	pmStripeID := strings.TrimSpace(req.GetStripePaymentMethodId())
	if pmStripeID == "" {
		return nil, fmt.Errorf("%w: stripe_payment_method_id is required", ErrInvalidBillingInput)
	}

	now := s.clock()
	var resp *adminv1.UpdatePaymentMethodResponse
	err = s.engine.store.WithWorkspaceTx(pctx.WorkspaceID, func(st *WorkspaceBillingState) error {
		if req.GetRemove() {
			isPaidPlan := st.SubscriptionTier != "" && st.SubscriptionTier != "free"
			isActiveSub := st.Subscription == nil || (st.Subscription.Status != "canceled" && !st.Subscription.CancelAtPeriodEnd)
			if isPaidPlan && isActiveSub && len(st.PaymentMethods) <= 1 {
				return ErrLastPaymentMethodOnPaidPlan
			}
			var remaining []tenantdb.PaymentMethodRow
			for _, pm := range st.PaymentMethods {
				if pm.StripePaymentMethodID != pmStripeID {
					remaining = append(remaining, pm)
				}
			}
			if len(remaining) > 0 && !hasDefaultPM(remaining) {
				remaining[0].IsDefault = true
			}
			st.PaymentMethods = remaining
			resp = &adminv1.UpdatePaymentMethodResponse{
				PaymentMethods:    paymentMethodsToProto(st.PaymentMethods),
				MethodAccessGates: evaluatePaymentMethodGatesOnState(st),
			}
			return nil
		}

		// Validate payment method access gate before adding or updating.
		gateSpec, gateErr := isPaymentMethodAllowedOnState(st, req.GetMethodType())
		if gateErr != nil {
			return gateErr
		}

		// Add or set default payment method.
		var target *tenantdb.PaymentMethodRow
		for idx := range st.PaymentMethods {
			if req.GetSetDefault() {
				st.PaymentMethods[idx].IsDefault = false
			}
			if st.PaymentMethods[idx].StripePaymentMethodID == pmStripeID {
				if req.GetSetDefault() {
					st.PaymentMethods[idx].IsDefault = true
				}
				st.PaymentMethods[idx].UpdatedAt = now
				target = &st.PaymentMethods[idx]
			}
		}
		if target == nil {
			isDef := req.GetSetDefault() || len(st.PaymentMethods) == 0
			if isDef {
				for idx := range st.PaymentMethods {
					st.PaymentMethods[idx].IsDefault = false
				}
			}
			last4 := "4242"
			if len(pmStripeID) >= 4 {
				last4 = pmStripeID[len(pmStripeID)-4:]
			}
			brand := "visa"
			if gateSpec.MethodType != "card" {
				brand = gateSpec.MethodType
			}
			newPM := tenantdb.PaymentMethodRow{
				PaymentMethodID:       s.engine.store.nextUUID("91000000"),
				WorkspaceID:           pctx.WorkspaceID,
				StripePaymentMethodID: pmStripeID,
				Type:                  gateSpec.MethodType,
				CardBrand:             brand,
				CardLast4:             last4,
				CardExpMonth:          12,
				CardExpYear:           2029,
				IsDefault:             isDef,
				CreatedAt:             now,
				UpdatedAt:             now,
			}
			st.PaymentMethods = append(st.PaymentMethods, newPM)
			target = &st.PaymentMethods[len(st.PaymentMethods)-1]
		}
		pmProto := paymentMethodRowToProto(*target)
		pmProto.AccessGateStatus = "granted"
		pmProto.BillingName = req.GetBillingName()
		pmProto.BillingEmail = req.GetBillingEmail()
		resp = &adminv1.UpdatePaymentMethodResponse{
			PaymentMethod:     pmProto,
			PaymentMethods:    paymentMethodsToProto(st.PaymentMethods),
			MethodAccessGates: evaluatePaymentMethodGatesOnState(st),
		}
		return nil
	})
	return resp, err
}

// GetPaymentMethod implements AdminBillingService/GetPaymentMethod (workspace:billing:read).
func (s *Service) GetPaymentMethod(ctx context.Context, req *adminv1.GetPaymentMethodRequest) (*adminv1.GetPaymentMethodResponse, error) {
	pctx, err := s.requirePermission(ctx, "AdminBillingService/GetPaymentMethod", req.GetWorkspaceId().GetValue())
	if err != nil {
		return nil, err
	}
	var resp *adminv1.GetPaymentMethodResponse
	err = s.engine.store.WithWorkspaceTx(pctx.WorkspaceID, func(st *WorkspaceBillingState) error {
		var defPM *adminv1.PaymentMethodSummary
		for _, pm := range st.PaymentMethods {
			if pm.IsDefault {
				defPM = paymentMethodRowToProto(pm)
				break
			}
		}
		resp = &adminv1.GetPaymentMethodResponse{
			DefaultPaymentMethod: defPM,
			PaymentMethods:       paymentMethodsToProto(st.PaymentMethods),
			MethodAccessGates:    evaluatePaymentMethodGatesOnState(st),
		}
		return nil
	})
	return resp, err
}

// SettleStripeWebhook processes a verified Stripe webhook event idempotently.
// Credits and subscription period allocations are granted ONLY upon verified webhook settlement.
// Enforces P1-05 Acceptance Target #3 ("Payment replay cannot double-grant"):
//   - Deduplicates by Stripe EventID AND by underlying economic grant identity
//     (external_grant_key on ai_credit_lots, idempotency_key on ai_credit_transactions,
//     stripe_invoice_id on invoices, and checkout_session_id settlement status).
//   - Replaying the same EventID, replaying with a new EventID for the same checkout session,
//     invoice, or subscription billing period, or cross-event delivery (checkout.session.completed
//     followed by invoice.paid for the same session/period) never double-grants credits or
//     creates duplicate ledger transactions or invoices.
func (s *Service) SettleStripeWebhook(evt StripeWebhookEvent) (WebhookSettlementResult, error) {
	if strings.TrimSpace(evt.EventID) == "" || strings.TrimSpace(evt.WorkspaceID) == "" {
		return WebhookSettlementResult{}, ErrInvalidBillingInput
	}
	now := evt.OccurredAt
	if now.IsZero() {
		now = s.clock()
	}

	findLotByGrantKey := func(st *WorkspaceBillingState, grantKey string) *tenantdb.CreditLotRow {
		if strings.TrimSpace(grantKey) == "" {
			return nil
		}
		for i := range st.Lots {
			if st.Lots[i].ExternalGrantKey == grantKey {
				lotCopy := st.Lots[i]
				return &lotCopy
			}
		}
		return nil
	}

	findInvoiceByStripeID := func(st *WorkspaceBillingState, stripeInvID string) *tenantdb.InvoiceRow {
		if strings.TrimSpace(stripeInvID) == "" {
			return nil
		}
		for i := range st.Invoices {
			if st.Invoices[i].StripeInvoiceID == stripeInvID {
				invCopy := st.Invoices[i]
				return &invCopy
			}
		}
		return nil
	}

	hasTxWithIdempotencyKey := func(st *WorkspaceBillingState, idempKey string) bool {
		if strings.TrimSpace(idempKey) == "" {
			return false
		}
		for i := range st.Transactions {
			if st.Transactions[i].IdempotencyKey == idempKey {
				return true
			}
		}
		return false
	}

	recordBillingEventOnce := func(st *WorkspaceBillingState, rec BillingEventRecord) {
		for i := range st.BillingEvents {
			if rec.StripeEventID != "" && st.BillingEvents[i].StripeEventID == rec.StripeEventID {
				return
			}
		}
		st.BillingEvents = append(st.BillingEvents, rec)
	}

	validateWebhookAgainstSession := func(sess *CheckoutSessionRecord) error {
		if sess == nil {
			return fmt.Errorf("%w: checkout session not found", ErrInvalidBillingInput)
		}
		if sess.WorkspaceID != "" && sess.WorkspaceID != evt.WorkspaceID {
			return fmt.Errorf("%w: checkout session %q belongs to a different workspace", ErrInvalidBillingInput, sess.SessionID)
		}
		if strings.TrimSpace(evt.Currency) != "" && !strings.EqualFold(strings.TrimSpace(evt.Currency), sess.Currency) {
			return fmt.Errorf("%w: webhook currency %q does not match session currency %q", ErrInvalidBillingInput, evt.Currency, sess.Currency)
		}
		if evt.AmountPaid.IsNegative() || (!evt.AmountPaid.IsZero() && evt.AmountPaid.Cmp(sess.Amount) != 0) {
			return fmt.Errorf("%w: webhook amount_paid %s does not match session amount %s", ErrInvalidBillingInput, evt.AmountPaid.String(), sess.Amount.String())
		}
		if sess.Kind == "subscription_plan" {
			if strings.TrimSpace(evt.TargetPlan) != "" && !strings.EqualFold(strings.TrimSpace(evt.TargetPlan), sess.TargetPlan) {
				return fmt.Errorf("%w: webhook target_plan %q does not match session target_plan %q", ErrInvalidBillingInput, evt.TargetPlan, sess.TargetPlan)
			}
			if strings.TrimSpace(evt.BillingInterval) != "" && !strings.EqualFold(strings.TrimSpace(evt.BillingInterval), sess.Interval) {
				return fmt.Errorf("%w: webhook billing_interval %q does not match session interval %q", ErrInvalidBillingInput, evt.BillingInterval, sess.Interval)
			}
			if strings.TrimSpace(evt.StripePriceID) != "" && sess.StripePriceID != "" && !strings.EqualFold(strings.TrimSpace(evt.StripePriceID), sess.StripePriceID) {
				return fmt.Errorf("%w: webhook stripe_price_id %q does not match session price_id %q", ErrInvalidBillingInput, evt.StripePriceID, sess.StripePriceID)
			}
			if strings.TrimSpace(evt.SubscriptionID) != "" && sess.SubscriptionID != "" && strings.TrimSpace(evt.SubscriptionID) != sess.SubscriptionID {
				return fmt.Errorf("%w: webhook subscription_id %q does not match session subscription_id %q", ErrInvalidBillingInput, evt.SubscriptionID, sess.SubscriptionID)
			}
		}
		return nil
	}

	settleCreditPackSession := func(st *WorkspaceBillingState, sess *CheckoutSessionRecord) (WebhookSettlementResult, error) {
		if err := validateWebhookAgainstSession(sess); err != nil {
			return WebhookSettlementResult{}, err
		}
		grantKey := "stripe_pack:" + sess.SessionID
		stripeInvID := strings.TrimSpace(evt.StripeInvoiceID)
		if stripeInvID == "" {
			stripeInvID = "in_" + sess.SessionID
		}

		existingLot := findLotByGrantKey(st, grantKey)
		existingInv := findInvoiceByStripeID(st, stripeInvID)
		if existingInv == nil {
			existingInv = findInvoiceByStripeID(st, "in_"+sess.SessionID)
		}
		if sess.Status == "settled" || existingLot != nil || hasTxWithIdempotencyKey(st, "grant:"+grantKey) || existingInv != nil {
			st.ProcessedWebhooks[evt.EventID] = now
			return WebhookSettlementResult{
				EventID:    evt.EventID,
				Duplicate:  true,
				Status:     "session_already_settled",
				GrantedLot: existingLot,
				Invoice:    existingInv,
			}, nil
		}

		pack, ok := LookupCreditPack(sess.PackCode)
		if !ok {
			return WebhookSettlementResult{}, fmt.Errorf("%w: invalid pack_code %q on session", ErrInvalidBillingInput, sess.PackCode)
		}

		lotID := s.engine.store.nextUUID("31000000")
		lot := tenantdb.CreditLotRow{
			LotID:            lotID,
			WorkspaceID:      evt.WorkspaceID,
			SourceType:       SourcePurchased,
			GrantedCredits:   pack.Credits,
			RemainingCredits: pack.Credits,
			ReservedCredits:  tenantdb.ZeroDecimal(),
			ExpiresAt:        nil, // Purchased credits NEVER expire
			ExternalGrantKey: grantKey,
			CreatedAt:        now,
		}
		st.Lots = append(st.Lots, lot)
		sortLotsInConsumptionOrder(st.Lots)

		bal := computeBalanceFromState(st, now)
		txRow := tenantdb.CreditTransactionRow{
			TransactionID:  s.engine.store.nextUUID("41000000"),
			WorkspaceID:    evt.WorkspaceID,
			UserID:         sess.UserID,
			OperationType:  "credit_purchase",
			CreditsDelta:   pack.Credits,
			BalanceAfter:   bal.Available,
			Source:         SourcePurchased,
			LotID:          lotID,
			IdempotencyKey: "grant:" + grantKey,
			Description:    fmt.Sprintf("Purchased %s (%s credits)", pack.DisplayName, pack.Credits.String()),
			CreatedAt:      now,
		}
		st.Transactions = append([]tenantdb.CreditTransactionRow{txRow}, st.Transactions...)

		inv := tenantdb.InvoiceRow{
			InvoiceID:        s.engine.store.nextUUID("92000000"),
			WorkspaceID:      evt.WorkspaceID,
			StripeInvoiceID:  stripeInvID,
			InvoiceNumber:    fmt.Sprintf("INV-%d", len(st.Invoices)+1001),
			Status:           "paid",
			Currency:         sess.Currency,
			Subtotal:         sess.Amount,
			DiscountAmount:   tenantdb.ZeroDecimal(),
			TaxAmount:        tenantdb.ZeroDecimal(),
			Total:            sess.Amount,
			AmountPaid:       sess.Amount,
			AmountDue:        tenantdb.ZeroDecimal(),
			InvoicePDFURL:    "https://pay.stripe.com/invoice/" + sess.SessionID + "/pdf",
			HostedInvoiceURL: "https://invoice.stripe.com/i/" + sess.SessionID,
			PaidAt:           &now,
			CreatedAt:        now,
			UpdatedAt:        now,
		}
		st.Invoices = append([]tenantdb.InvoiceRow{inv}, st.Invoices...)

		sess.Status = "settled"
		sess.SettledAt = &now
		st.ProcessedWebhooks[evt.EventID] = now

		recordBillingEventOnce(st, BillingEventRecord{
			BillingEventID:   s.engine.store.nextUUID("93000000"),
			WorkspaceID:      evt.WorkspaceID,
			EventType:        evt.EventType,
			StripeEventID:    evt.EventID,
			Amount:           sess.Amount,
			Currency:         sess.Currency,
			SubscriptionTier: st.SubscriptionTier,
			CreditsChange:    pack.Credits,
			Description:      txRow.Description,
			Metadata: map[string]any{
				"checkout_session_id": sess.SessionID,
				"pack_code":           sess.PackCode,
				"grant_key":           grantKey,
			},
			CreatedAt: now,
		})

		st.OutboxEvents = append(st.OutboxEvents,
			EmittedEvent{
				EventType:      EventCreditsPurchased,
				WorkspaceID:    evt.WorkspaceID,
				AggregateType:  "credit_lot",
				AggregateID:    lotID,
				IdempotencyKey: "evt:purchased:" + sess.SessionID,
				Payload: map[string]any{
					"pack_code": sess.PackCode,
					"credits":   pack.Credits.String(),
					"lot_id":    lotID,
				},
				CreatedAt: now,
			},
			EmittedEvent{
				EventType:      EventBillingPaymentSucceeded,
				WorkspaceID:    evt.WorkspaceID,
				AggregateType:  "invoice",
				AggregateID:    inv.InvoiceID,
				IdempotencyKey: "evt:payment_ok:" + sess.SessionID,
				Payload: map[string]any{
					"invoice_id": inv.InvoiceID,
					"amount":     sess.Amount.String(),
					"currency":   sess.Currency,
				},
				CreatedAt: now,
			},
		)
		return WebhookSettlementResult{
			EventID:    evt.EventID,
			Duplicate:  false,
			Status:     "settled_credit_pack",
			GrantedLot: &lot,
			Invoice:    &inv,
		}, nil
	}

	settleSubscriptionPlanSession := func(st *WorkspaceBillingState, sess *CheckoutSessionRecord) (WebhookSettlementResult, error) {
		if err := validateWebhookAgainstSession(sess); err != nil {
			return WebhookSettlementResult{}, err
		}
		if sess.Status == "expired" || sess.Status == "failed" {
			return WebhookSettlementResult{}, fmt.Errorf("%w: checkout session %q is %s and cannot be settled", ErrInvalidBillingInput, sess.SessionID, sess.Status)
		}
		stripeInvID := strings.TrimSpace(evt.StripeInvoiceID)
		if stripeInvID == "" {
			stripeInvID = "in_" + sess.SessionID
		}
		existingInv := findInvoiceByStripeID(st, stripeInvID)
		if existingInv == nil {
			existingInv = findInvoiceByStripeID(st, "in_"+sess.SessionID)
		}
		if sess.Status == "settled" || existingInv != nil {
			st.ProcessedWebhooks[evt.EventID] = now
			return WebhookSettlementResult{
				EventID:   evt.EventID,
				Duplicate: true,
				Status:    "session_already_settled",
				Invoice:   existingInv,
			}, nil
		}

		targetTier, ok := LookupTier(sess.TargetPlan)
		if !ok {
			return WebhookSettlementResult{}, fmt.Errorf("%w: invalid target_plan %q on session", ErrInvalidBillingInput, sess.TargetPlan)
		}
		prevTier := st.SubscriptionTier
		st.SubscriptionTier = targetTier.TierCode
		if sess.AcceptOverageTerms {
			st.OverageTermsAccepted = true
		}

		subID := strings.TrimSpace(evt.SubscriptionID)
		if subID == "" && sess.SubscriptionID != "" {
			subID = sess.SubscriptionID
		}
		if subID == "" && st.Subscription != nil && st.Subscription.SubscriptionID != "" {
			subID = st.Subscription.SubscriptionID
		}
		if subID == "" {
			subID = "90000000-0000-4000-8000-000000000001"
		}
		sess.SubscriptionID = subID
		periodStart := now.UTC()
		periodEnd := now.UTC().Add(30 * 24 * time.Hour)
		if sess.Interval == "annual" {
			periodEnd = now.UTC().Add(365 * 24 * time.Hour)
		}
		if st.Subscription != nil && st.Subscription.Status == "active" && !st.Subscription.CurrentPeriodStart.IsZero() && st.Subscription.CurrentPeriodEnd.After(now) {
			periodStart = st.Subscription.CurrentPeriodStart
			periodEnd = st.Subscription.CurrentPeriodEnd
		}
		baseAmt := sess.BaseAmount
		if baseAmt.IsZero() {
			baseAmt = sess.Amount
		}
		st.Subscription = &tenantdb.SubscriptionRow{
			SubscriptionID:     subID,
			WorkspaceID:        evt.WorkspaceID,
			Plan:               targetTier.TierCode,
			BillingInterval:    sess.Interval,
			Status:             "active",
			Amount:             baseAmt,
			Currency:           sess.Currency,
			CurrentPeriodStart: periodStart,
			CurrentPeriodEnd:   periodEnd,
			CancelAtPeriodEnd:  false,
			Addons:             append([]string{}, sess.Addons...),
			CreatedAt:          now.UTC(),
			UpdatedAt:          now.UTC(),
		}

		inv := tenantdb.InvoiceRow{
			InvoiceID:        s.engine.store.nextUUID("92000000"),
			WorkspaceID:      evt.WorkspaceID,
			SubscriptionID:   subID,
			StripeInvoiceID:  stripeInvID,
			InvoiceNumber:    fmt.Sprintf("INV-%d", len(st.Invoices)+1001),
			Status:           "paid",
			Currency:         sess.Currency,
			Subtotal:         sess.Amount,
			DiscountAmount:   tenantdb.ZeroDecimal(),
			TaxAmount:        tenantdb.ZeroDecimal(),
			Total:            sess.Amount,
			AmountPaid:       sess.Amount,
			AmountDue:        tenantdb.ZeroDecimal(),
			InvoicePDFURL:    "https://pay.stripe.com/invoice/" + sess.SessionID + "/pdf",
			HostedInvoiceURL: "https://invoice.stripe.com/i/" + sess.SessionID,
			PaidAt:           &now,
			CreatedAt:        now,
			UpdatedAt:        now,
		}
		st.Invoices = append([]tenantdb.InvoiceRow{inv}, st.Invoices...)

		sess.Status = "settled"
		sess.SettledAt = &now
		st.ProcessedWebhooks[evt.EventID] = now

		recordBillingEventOnce(st, BillingEventRecord{
			BillingEventID:   s.engine.store.nextUUID("93000000"),
			WorkspaceID:      evt.WorkspaceID,
			EventType:        evt.EventType,
			StripeEventID:    evt.EventID,
			Amount:           sess.Amount,
			Currency:         sess.Currency,
			SubscriptionTier: st.SubscriptionTier,
			CreditsChange:    tenantdb.ZeroDecimal(),
			Description:      fmt.Sprintf("Activated %s subscription plan via verified checkout session %s", targetTier.TierCode, sess.SessionID),
			Metadata: map[string]any{
				"checkout_session_id": sess.SessionID,
				"previous_plan":       prevTier,
				"target_plan":         targetTier.TierCode,
			},
			CreatedAt: now,
		})

		st.OutboxEvents = append(st.OutboxEvents,
			EmittedEvent{
				EventType:      EventBillingPlanChanged,
				WorkspaceID:    evt.WorkspaceID,
				AggregateType:  "subscription",
				AggregateID:    subID,
				IdempotencyKey: "evt:plan_change:" + sess.SessionID,
				Payload: map[string]any{
					"previous_plan":         prevTier,
					"target_plan":           targetTier.TierCode,
					"effective_mode":        "immediate_prorated",
					"prorated_addon_charge": sess.ProratedAddonCharge.String(),
				},
				CreatedAt: now,
			},
			EmittedEvent{
				EventType:      EventBillingPaymentSucceeded,
				WorkspaceID:    evt.WorkspaceID,
				AggregateType:  "invoice",
				AggregateID:    inv.InvoiceID,
				IdempotencyKey: "evt:payment_ok:" + sess.SessionID,
				Payload: map[string]any{
					"invoice_id": inv.InvoiceID,
					"amount":     sess.Amount.String(),
					"currency":   sess.Currency,
				},
				CreatedAt: now,
			},
		)
		return WebhookSettlementResult{
			EventID:   evt.EventID,
			Duplicate: false,
			Status:    "settled_subscription_plan",
			Invoice:   &inv,
		}, nil
	}

	var out WebhookSettlementResult
	err := s.engine.store.WithWorkspaceTx(evt.WorkspaceID, func(st *WorkspaceBillingState) error {
		if _, already := st.ProcessedWebhooks[evt.EventID]; already {
			out = WebhookSettlementResult{
				EventID:   evt.EventID,
				Duplicate: true,
				Status:    "duplicate_ignored",
			}
			return nil
		}

		// Verify payment status is settled when explicitly provided on a grant-producing event.
		if (evt.EventType == "checkout.session.completed" || evt.EventType == "invoice.paid") &&
			strings.TrimSpace(evt.PaymentStatus) != "" &&
			strings.ToLower(strings.TrimSpace(evt.PaymentStatus)) != "paid" {
			return fmt.Errorf("%w: unsettled payment_status %q cannot grant credits", ErrInvalidBillingInput, evt.PaymentStatus)
		}

		switch evt.EventType {
		case "checkout.session.completed":
			sess, ok := st.CheckoutSessions[evt.CheckoutSessionID]
			if !ok {
				return fmt.Errorf("%w: unknown checkout_session_id %q", ErrInvalidBillingInput, evt.CheckoutSessionID)
			}
			if sess.Kind == "subscription_plan" {
				res, err := settleSubscriptionPlanSession(st, sess)
				if err != nil {
					return err
				}
				out = res
				return nil
			}
			res, err := settleCreditPackSession(st, sess)
			if err != nil {
				return err
			}
			out = res
			return nil

		case "checkout.session.expired":
			if sess, ok := st.CheckoutSessions[evt.CheckoutSessionID]; ok && sess.Status == "pending" {
				sess.Status = "expired"
			}
			st.ProcessedWebhooks[evt.EventID] = now
			out = WebhookSettlementResult{
				EventID:   evt.EventID,
				Duplicate: false,
				Status:    "checkout_session_expired",
			}
			return nil

		case "invoice.paid":
			// 1. If this invoice explicitly binds a checkout_session_id, settle only that exact session (fail closed if unknown).
			if strings.TrimSpace(evt.CheckoutSessionID) != "" {
				sess, ok := st.CheckoutSessions[strings.TrimSpace(evt.CheckoutSessionID)]
				if !ok {
					return fmt.Errorf("%w: unknown checkout_session_id %q", ErrInvalidBillingInput, evt.CheckoutSessionID)
				}
				if sess.Kind == "subscription_plan" {
					res, err := settleSubscriptionPlanSession(st, sess)
					if err != nil {
						return err
					}
					out = res
					return nil
				}
				res, err := settleCreditPackSession(st, sess)
				if err != nil {
					return err
				}
				out = res
				return nil
			}

			// 2. Check duplicate invoice / billing period BEFORE mutating any subscription or pending session state (R01).
			subID := strings.TrimSpace(evt.SubscriptionID)
			if subID == "" && st.Subscription != nil {
				subID = st.Subscription.SubscriptionID
			}
			if subID == "" {
				subID = "default_sub"
			}
			periodKey := strings.TrimSpace(evt.PeriodKey)
			if periodKey == "" && strings.TrimSpace(evt.StripeInvoiceID) != "" {
				periodKey = "inv:" + strings.TrimSpace(evt.StripeInvoiceID)
			}
			if periodKey == "" {
				return fmt.Errorf("%w: invoice.paid requires period_key or stripe_invoice_id", ErrInvalidBillingInput)
			}

			grantKey := fmt.Sprintf("sub_alloc:%s:%s", subID, periodKey)
			stripeInvID := strings.TrimSpace(evt.StripeInvoiceID)
			if stripeInvID == "" {
				stripeInvID = fmt.Sprintf("in_sub_%s_%s", subID, periodKey)
			}

			existingLot := findLotByGrantKey(st, grantKey)
			existingInv := findInvoiceByStripeID(st, stripeInvID)
			if existingInv != nil || (existingLot != nil && strings.TrimSpace(evt.StripeInvoiceID) == "") {
				st.ProcessedWebhooks[evt.EventID] = now
				out = WebhookSettlementResult{
					EventID:    evt.EventID,
					Duplicate:  true,
					Status:     "invoice_already_settled",
					GrantedLot: existingLot,
					Invoice:    existingInv,
				}
				return nil
			}

			// 3. Determine whether this invoice.paid authorizes a pending subscription_plan session or renews an active subscription (R01).
			hasActivePaidSub := st.Subscription != nil &&
				st.Subscription.Plan != "" &&
				!strings.EqualFold(st.Subscription.Plan, "free") &&
				st.Subscription.Status != "incomplete"

			var pendingPlanSessions []*CheckoutSessionRecord
			for _, sess := range st.CheckoutSessions {
				if sess != nil && sess.Kind == "subscription_plan" && sess.Status == "pending" {
					pendingPlanSessions = append(pendingPlanSessions, sess)
				}
			}

			var authorizedPendingSess *CheckoutSessionRecord
			if hasActivePaidSub {
				// On an already-active paid subscription, an invoice without CheckoutSessionID NEVER activates an abandoned pending
				// plan session unless the webhook explicitly proves the exact subscription_id, target_plan/price_id, amount_paid, and currency of that pending session.
				if strings.TrimSpace(evt.SubscriptionID) != "" &&
					st.Subscription.SubscriptionID != "" &&
					strings.TrimSpace(evt.SubscriptionID) != st.Subscription.SubscriptionID {
					return fmt.Errorf("%w: invoice subscription_id %q does not match workspace subscription_id %q",
						ErrInvalidBillingInput, evt.SubscriptionID, st.Subscription.SubscriptionID)
				}

				hasExplicitUpgradeProof := strings.TrimSpace(evt.SubscriptionID) != "" &&
					(strings.TrimSpace(evt.TargetPlan) != "" || strings.TrimSpace(evt.StripePriceID) != "") &&
					!evt.AmountPaid.IsZero() &&
					strings.TrimSpace(evt.Currency) != ""

				if hasExplicitUpgradeProof {
					var matched []*CheckoutSessionRecord
					for _, sess := range pendingPlanSessions {
						if validateWebhookAgainstSession(sess) == nil {
							matched = append(matched, sess)
						}
					}
					if len(matched) > 1 {
						return fmt.Errorf("%w: ambiguous pending subscription checkout sessions; checkout_session_id required", ErrInvalidBillingInput)
					}
					if len(matched) == 1 {
						authorizedPendingSess = matched[0]
					}
				}

				if authorizedPendingSess == nil {
					// Validate renewal invoice attributes against the active subscription (fail closed on plan/interval/currency/amount mismatch).
					if strings.TrimSpace(evt.TargetPlan) != "" && !strings.EqualFold(strings.TrimSpace(evt.TargetPlan), st.Subscription.Plan) {
						return fmt.Errorf("%w: invoice target_plan %q does not match active subscription plan %q",
							ErrInvalidBillingInput, evt.TargetPlan, st.Subscription.Plan)
					}
					if strings.TrimSpace(evt.BillingInterval) != "" && st.Subscription.BillingInterval != "" &&
						!strings.EqualFold(strings.TrimSpace(evt.BillingInterval), st.Subscription.BillingInterval) {
						return fmt.Errorf("%w: invoice billing_interval %q does not match active subscription interval %q",
							ErrInvalidBillingInput, evt.BillingInterval, st.Subscription.BillingInterval)
					}
					if strings.TrimSpace(evt.Currency) != "" && st.Subscription.Currency != "" &&
						!strings.EqualFold(strings.TrimSpace(evt.Currency), st.Subscription.Currency) {
						return fmt.Errorf("%w: invoice currency %q does not match active subscription currency %q",
							ErrInvalidBillingInput, evt.Currency, st.Subscription.Currency)
					}
					if evt.AmountPaid.IsNegative() || (!evt.AmountPaid.IsZero() && !st.Subscription.Amount.IsZero() && evt.AmountPaid.Cmp(st.Subscription.Amount) != 0) {
						return fmt.Errorf("%w: invoice amount_paid %s does not match active subscription amount %s",
							ErrInvalidBillingInput, evt.AmountPaid.String(), st.Subscription.Amount.String())
					}
				}
			} else {
				// Workspace has no active paid subscription yet.
				if len(pendingPlanSessions) == 1 {
					if err := validateWebhookAgainstSession(pendingPlanSessions[0]); err != nil {
						return err
					}
					authorizedPendingSess = pendingPlanSessions[0]
				} else if len(pendingPlanSessions) > 1 {
					// Disambiguate only if explicit plan/price binding uniquely identifies one pending session.
					if strings.TrimSpace(evt.TargetPlan) == "" && strings.TrimSpace(evt.StripePriceID) == "" {
						return fmt.Errorf("%w: multiple pending subscription checkout sessions; checkout_session_id required", ErrInvalidBillingInput)
					}
					var matched []*CheckoutSessionRecord
					for _, sess := range pendingPlanSessions {
						if validateWebhookAgainstSession(sess) == nil {
							matched = append(matched, sess)
						}
					}
					if len(matched) != 1 {
						return fmt.Errorf("%w: ambiguous or unmatched pending subscription checkout sessions; checkout_session_id required", ErrInvalidBillingInput)
					}
					authorizedPendingSess = matched[0]
				} else if st.Subscription == nil && (st.SubscriptionTier == "" || strings.EqualFold(st.SubscriptionTier, "free")) {
					return fmt.Errorf("%w: invoice.paid received for workspace without active subscription or pending checkout session", ErrInvalidBillingInput)
				}
			}

			if authorizedPendingSess != nil {
				targetTier, tOK := LookupTier(authorizedPendingSess.TargetPlan)
				if !tOK {
					return fmt.Errorf("%w: invalid target_plan %q on session", ErrInvalidBillingInput, authorizedPendingSess.TargetPlan)
				}
				prevTier := st.SubscriptionTier
				st.SubscriptionTier = targetTier.TierCode
				if authorizedPendingSess.AcceptOverageTerms {
					st.OverageTermsAccepted = true
				}
				subIDForPlan := strings.TrimSpace(evt.SubscriptionID)
				if subIDForPlan == "" && authorizedPendingSess.SubscriptionID != "" {
					subIDForPlan = authorizedPendingSess.SubscriptionID
				}
				if subIDForPlan == "" && st.Subscription != nil && st.Subscription.SubscriptionID != "" {
					subIDForPlan = st.Subscription.SubscriptionID
				}
				if subIDForPlan == "" {
					subIDForPlan = "90000000-0000-4000-8000-000000000001"
				}
				subID = subIDForPlan
				authorizedPendingSess.SubscriptionID = subIDForPlan
				baseAmt := authorizedPendingSess.BaseAmount
				if baseAmt.IsZero() {
					baseAmt = authorizedPendingSess.Amount
				}
				st.Subscription = &tenantdb.SubscriptionRow{
					SubscriptionID:     subIDForPlan,
					WorkspaceID:        evt.WorkspaceID,
					Plan:               targetTier.TierCode,
					BillingInterval:    authorizedPendingSess.Interval,
					Status:             "active",
					Amount:             baseAmt,
					Currency:           authorizedPendingSess.Currency,
					CurrentPeriodStart: now.UTC(),
					CurrentPeriodEnd:   now.UTC().Add(30 * 24 * time.Hour),
					CancelAtPeriodEnd:  false,
					Addons:             append([]string{}, authorizedPendingSess.Addons...),
					CreatedAt:          now.UTC(),
					UpdatedAt:          now.UTC(),
				}
				authorizedPendingSess.Status = "settled"
				authorizedPendingSess.SettledAt = &now
				st.OutboxEvents = append(st.OutboxEvents, EmittedEvent{
					EventType:      EventBillingPlanChanged,
					WorkspaceID:    evt.WorkspaceID,
					AggregateType:  "subscription",
					AggregateID:    subIDForPlan,
					IdempotencyKey: "evt:plan_change:" + authorizedPendingSess.SessionID,
					Payload: map[string]any{
						"previous_plan":         prevTier,
						"target_plan":           targetTier.TierCode,
						"effective_mode":        "immediate_prorated",
						"prorated_addon_charge": authorizedPendingSess.ProratedAddonCharge.String(),
					},
					CreatedAt: now,
				})
			}

			tierCode := st.SubscriptionTier
			if st.Subscription != nil && st.Subscription.Plan != "" {
				tierCode = st.Subscription.Plan
			}
			tierSpec, ok := LookupTier(tierCode)
			if !ok {
				tierSpec, _ = LookupTier("free")
			}

			nextExp := evt.NextPeriodEnd.UTC()
			if nextExp.IsZero() {
				nextExp = now.UTC().Add(30 * 24 * time.Hour)
			}

			// F21: Execute cycle boundary close (reservation sweep, prior-lot expiration, 20% rollover grant)
			// and monthly allocation idempotently so invoice.paid arriving before RunCycleBoundary never drops rollover.
			_, allocLot, _, err := processCycleBoundaryOnState(s.engine.store, st, evt.WorkspaceID, subID, periodKey, nextExp, now)
			if err != nil {
				return err
			}

			invAmount := tierSpec.MonthlyPriceUSD
			invCurrency := "USD"
			if st.Subscription != nil {
				if !st.Subscription.Amount.IsZero() {
					invAmount = st.Subscription.Amount
				}
				if st.Subscription.Currency != "" {
					invCurrency = st.Subscription.Currency
				}
				st.Subscription.Status = "active"
				st.Subscription.CurrentPeriodStart = now.UTC()
				st.Subscription.CurrentPeriodEnd = nextExp
				st.Subscription.UpdatedAt = now.UTC()
			}

			inv := tenantdb.InvoiceRow{
				InvoiceID:        s.engine.store.nextUUID("92000000"),
				WorkspaceID:      evt.WorkspaceID,
				SubscriptionID:   subID,
				StripeInvoiceID:  stripeInvID,
				InvoiceNumber:    fmt.Sprintf("INV-%d", len(st.Invoices)+1001),
				Status:           "paid",
				Currency:         invCurrency,
				Subtotal:         invAmount,
				DiscountAmount:   tenantdb.ZeroDecimal(),
				TaxAmount:        tenantdb.ZeroDecimal(),
				Total:            invAmount,
				AmountPaid:       invAmount,
				AmountDue:        tenantdb.ZeroDecimal(),
				InvoicePDFURL:    "https://pay.stripe.com/invoice/" + stripeInvID + "/pdf",
				HostedInvoiceURL: "https://invoice.stripe.com/i/" + stripeInvID,
				PaidAt:           &now,
				CreatedAt:        now,
				UpdatedAt:        now,
			}
			st.Invoices = append([]tenantdb.InvoiceRow{inv}, st.Invoices...)
			st.ProcessedWebhooks[evt.EventID] = now

			recordBillingEventOnce(st, BillingEventRecord{
				BillingEventID:   s.engine.store.nextUUID("93000000"),
				WorkspaceID:      evt.WorkspaceID,
				EventType:        evt.EventType,
				StripeEventID:    evt.EventID,
				Amount:           invAmount,
				Currency:         invCurrency,
				SubscriptionTier: tierSpec.TierCode,
				CreditsChange:    tierSpec.MonthlyCredits,
				Description:      fmt.Sprintf("Monthly subscription credit allocation for period %s (%s tier)", periodKey, tierSpec.TierCode),
				Metadata: map[string]any{
					"subscription_id":   subID,
					"period_key":        periodKey,
					"stripe_invoice_id": stripeInvID,
					"grant_key":         grantKey,
				},
				CreatedAt: now,
			})

			st.OutboxEvents = append(st.OutboxEvents, EmittedEvent{
				EventType:      EventBillingPaymentSucceeded,
				WorkspaceID:    evt.WorkspaceID,
				AggregateType:  "invoice",
				AggregateID:    inv.InvoiceID,
				IdempotencyKey: "evt:payment_ok:" + stripeInvID,
				Payload: map[string]any{
					"invoice_id":      inv.InvoiceID,
					"subscription_id": subID,
					"period_key":      periodKey,
					"amount":          invAmount.String(),
					"currency":        invCurrency,
				},
				CreatedAt: now,
			})

			out = WebhookSettlementResult{
				EventID:    evt.EventID,
				Duplicate:  false,
				Status:     "settled_subscription_invoice",
				GrantedLot: allocLot,
				Invoice:    &inv,
			}
			return nil

		case "invoice.payment_failed":
			if strings.TrimSpace(evt.CheckoutSessionID) != "" {
				if sess, ok := st.CheckoutSessions[evt.CheckoutSessionID]; ok && sess.Status == "pending" {
					sess.Status = "failed"
				}
			}
			st.ProcessedWebhooks[evt.EventID] = now
			if st.Subscription != nil && st.Subscription.Status == "active" {
				st.Subscription.Status = "past_due"
				st.Subscription.UpdatedAt = now
			}
			recordBillingEventOnce(st, BillingEventRecord{
				BillingEventID:   s.engine.store.nextUUID("93000000"),
				WorkspaceID:      evt.WorkspaceID,
				EventType:        evt.EventType,
				StripeEventID:    evt.EventID,
				Currency:         "USD",
				SubscriptionTier: st.SubscriptionTier,
				CreditsChange:    tenantdb.ZeroDecimal(),
				Description:      "Invoice payment failed; subscription moved to past_due",
				Metadata:         map[string]any{"event_id": evt.EventID},
				CreatedAt:        now,
			})
			st.OutboxEvents = append(st.OutboxEvents, EmittedEvent{
				EventType:      EventBillingPaymentFailed,
				WorkspaceID:    evt.WorkspaceID,
				AggregateType:  "workspace",
				AggregateID:    evt.WorkspaceID,
				IdempotencyKey: "evt:payment_failed:" + evt.EventID,
				Payload:        map[string]any{"event_id": evt.EventID},
				CreatedAt:      now,
			})
			out = WebhookSettlementResult{
				EventID:   evt.EventID,
				Duplicate: false,
				Status:    "dunning_past_due",
			}
			return nil

		default:
			st.ProcessedWebhooks[evt.EventID] = now
			out = WebhookSettlementResult{
				EventID:   evt.EventID,
				Duplicate: false,
				Status:    "ignored_event_type",
			}
			return nil
		}
	})
	return out, err
}

// GetBillingSummary implements AdminBillingService/GetBillingSummary (workspace:billing:read, Manager+).
func (s *Service) GetBillingSummary(ctx context.Context, req *adminv1.GetBillingSummaryRequest) (*adminv1.GetBillingSummaryResponse, error) {
	pctx, err := s.requirePermission(ctx, "AdminBillingService/GetBillingSummary", req.GetWorkspaceId().GetValue())
	if err != nil {
		return nil, err
	}
	now := s.clock()
	var resp *adminv1.GetBillingSummaryResponse
	err = s.engine.store.WithWorkspaceTx(pctx.WorkspaceID, func(st *WorkspaceBillingState) error {
		bal := computeBalanceFromState(st, now)
		var subProto *adminv1.SubscriptionSummary
		if st.Subscription != nil {
			subProto = subscriptionStateToProto(st)
		}
		var defPM *adminv1.PaymentMethodSummary
		for _, pm := range st.PaymentMethods {
			if pm.IsDefault {
				defPM = paymentMethodRowToProto(pm)
				break
			}
		}
		invs := make([]*adminv1.InvoiceSummary, 0, len(st.Invoices))
		for _, inv := range st.Invoices {
			invs = append(invs, invoiceRowToProto(inv))
		}
		resp = &adminv1.GetBillingSummaryResponse{
			Subscription:         subProto,
			CreditBalance:        bal.ToProto(),
			DefaultPaymentMethod: defPM,
			RecentInvoices:       invs,
			PricebookVersion:     PricebookVersion,
		}
		return nil
	})
	return resp, err
}

// GetCreditLedger implements AdminBillingService/GetCreditLedger (workspace:billing:read, Manager+).
func (s *Service) GetCreditLedger(ctx context.Context, req *adminv1.GetCreditLedgerRequest) (*adminv1.GetCreditLedgerResponse, error) {
	pctx, err := s.requirePermission(ctx, "AdminBillingService/GetCreditLedger", req.GetWorkspaceId().GetValue())
	if err != nil {
		return nil, err
	}
	var entries []*adminv1.CreditTransactionEntry
	err = s.engine.store.WithWorkspaceTx(pctx.WorkspaceID, func(st *WorkspaceBillingState) error {
		for _, tx := range st.Transactions {
			if req.GetOperationTypeFilter() != "" && tx.OperationType != req.GetOperationTypeFilter() {
				continue
			}
			if req.GetSourceFilter() != "" && tx.Source != req.GetSourceFilter() {
				continue
			}
			entries = append(entries, creditTxRowToProto(tx))
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	total := int64(len(entries))
	return &adminv1.GetCreditLedgerResponse{
		Entries: entries,
		PageInfo: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    false,
		},
	}, nil
}

// ListSubscriptions implements AdminBillingService/ListSubscriptions (workspace:billing:read).
func (s *Service) ListSubscriptions(ctx context.Context, req *adminv1.ListSubscriptionsRequest) (*adminv1.ListSubscriptionsResponse, error) {
	pctx, err := s.requirePermission(ctx, "AdminBillingService/ListSubscriptions", req.GetWorkspaceId().GetValue())
	if err != nil {
		return nil, err
	}
	var subs []*adminv1.SubscriptionSummary
	err = s.engine.store.WithWorkspaceTx(pctx.WorkspaceID, func(st *WorkspaceBillingState) error {
		if st.Subscription != nil {
			subs = append(subs, subscriptionStateToProto(st))
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	total := int64(len(subs))
	return &adminv1.ListSubscriptionsResponse{
		Subscriptions: subs,
		PageInfo: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    false,
		},
	}, nil
}

// GetUsageReport implements AdminBillingService/GetUsageReport (workspace:billing:read).
func (s *Service) GetUsageReport(ctx context.Context, req *adminv1.GetUsageReportRequest) (*adminv1.GetUsageReportResponse, error) {
	pctx, err := s.requirePermission(ctx, "AdminBillingService/GetUsageReport", req.GetWorkspaceId().GetValue())
	if err != nil {
		return nil, err
	}
	now := s.clock()
	var resp *adminv1.GetUsageReportResponse
	err = s.engine.store.WithWorkspaceTx(pctx.WorkspaceID, func(st *WorkspaceBillingState) error {
		tierSpec, ok := LookupTier(st.SubscriptionTier)
		if !ok {
			tierSpec, _ = LookupTier("free")
		}
		bal := computeBalanceFromState(st, now)
		byOp := make(map[string]tenantdb.ExactDecimal)
		countsByOp := make(map[string]int64)
		for _, tx := range st.Transactions {
			if tx.CreditsDelta.IsNegative() && tx.OperationType != "credit_expiration" {
				pos, _ := tenantdb.ZeroDecimal().Sub(tx.CreditsDelta)
				byOp[tx.OperationType], _ = byOp[tx.OperationType].Add(pos)
				countsByOp[tx.OperationType]++
			}
		}
		breakdown := make([]*adminv1.OperationUsageBreakdown, 0, len(byOp))
		for op, cred := range byOp {
			breakdown = append(breakdown, &adminv1.OperationUsageBreakdown{
				OperationType:  op,
				CreditsUsed:    cred.String(),
				OperationCount: countsByOp[op],
			})
		}
		maxOverage := tenantdb.ZeroDecimal()
		if tierSpec.OverageEligible {
			maxOverage, _ = tierSpec.MonthlyCredits.Mul(tenantdb.MustParseExactDecimal("0.10"))
		}
		overageUSD, _ := st.OverageUsedCredits.Mul(tenantdb.MustParseExactDecimal("0.025"))
		var alerts []string
		if !st.OverageUsedCredits.IsZero() {
			alerts = append(alerts, "100_pct")
			if !maxOverage.IsZero() && st.OverageUsedCredits.Cmp(maxOverage) >= 0 {
				alerts = append(alerts, "110_pct_hard_cap")
			}
		}
		resp = &adminv1.GetUsageReportResponse{
			Balance:                  bal.ToProto(),
			Breakdown:                breakdown,
			OverageCreditsUsed:       st.OverageUsedCredits.String(),
			OverageLimitCredits:      maxOverage.String(),
			OverageChargeUsd:         &commonv1.Money{Amount: overageUSD.String(), Currency: "USD"},
			TriggeredThresholdAlerts: alerts,
		}
		return nil
	})
	return resp, err
}

// GetInvoiceHistory implements AdminBillingService/GetInvoiceHistory (workspace:billing:read).
func (s *Service) GetInvoiceHistory(ctx context.Context, req *adminv1.GetInvoiceHistoryRequest) (*adminv1.GetInvoiceHistoryResponse, error) {
	pctx, err := s.requirePermission(ctx, "AdminBillingService/GetInvoiceHistory", req.GetWorkspaceId().GetValue())
	if err != nil {
		return nil, err
	}
	var invs []*adminv1.InvoiceSummary
	err = s.engine.store.WithWorkspaceTx(pctx.WorkspaceID, func(st *WorkspaceBillingState) error {
		for _, inv := range st.Invoices {
			invs = append(invs, invoiceRowToProto(inv))
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	total := int64(len(invs))
	return &adminv1.GetInvoiceHistoryResponse{
		Invoices: invs,
		PageInfo: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    false,
		},
	}, nil
}

// DownloadInvoice implements AdminBillingService/DownloadInvoice (workspace:billing:read).
func (s *Service) DownloadInvoice(ctx context.Context, req *adminv1.DownloadInvoiceRequest) (*adminv1.DownloadInvoiceResponse, error) {
	wsID := ""
	if req.GetContext().GetWorkspaceId() != nil {
		wsID = req.GetContext().GetWorkspaceId().GetValue()
	}
	pctx, err := s.requirePermission(ctx, "AdminBillingService/DownloadInvoice", wsID)
	if err != nil {
		return nil, err
	}
	targetID := req.GetInvoiceId().GetValue()
	var found *tenantdb.InvoiceRow
	err = s.engine.store.WithWorkspaceTx(pctx.WorkspaceID, func(st *WorkspaceBillingState) error {
		for idx := range st.Invoices {
			if st.Invoices[idx].InvoiceID == targetID {
				cp := st.Invoices[idx]
				found = &cp
				return nil
			}
		}
		return fmt.Errorf("%w: invoice %q not found", ErrInvalidBillingInput, targetID)
	})
	if err != nil {
		return nil, err
	}
	return &adminv1.DownloadInvoiceResponse{
		Invoice:          invoiceRowToProto(*found),
		InvoicePdfUrl:    found.InvoicePDFURL,
		HostedInvoiceUrl: found.HostedInvoiceURL,
	}, nil
}

// ListBillingEvents implements AdminBillingService/ListBillingEvents (workspace:billing:read).
func (s *Service) ListBillingEvents(ctx context.Context, req *adminv1.ListBillingEventsRequest) (*adminv1.ListBillingEventsResponse, error) {
	pctx, err := s.requirePermission(ctx, "AdminBillingService/ListBillingEvents", req.GetWorkspaceId().GetValue())
	if err != nil {
		return nil, err
	}
	var events []*adminv1.BillingEventEntry
	err = s.engine.store.WithWorkspaceTx(pctx.WorkspaceID, func(st *WorkspaceBillingState) error {
		for _, ev := range st.BillingEvents {
			if req.GetEventTypeFilter() != "" && ev.EventType != req.GetEventTypeFilter() {
				continue
			}
			events = append(events, &adminv1.BillingEventEntry{
				BillingEventId:   &commonv1.UUID{Value: ev.BillingEventID},
				WorkspaceId:      &commonv1.UUID{Value: ev.WorkspaceID},
				EventType:        ev.EventType,
				StripeEventId:    ev.StripeEventID,
				Amount:           &commonv1.Money{Amount: ev.Amount.String(), Currency: ev.Currency},
				SubscriptionTier: ev.SubscriptionTier,
				CreditsChange:    ev.CreditsChange.String(),
				Description:      ev.Description,
				CreatedAt:        timestamppb.New(ev.CreatedAt),
			})
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	total := int64(len(events))
	return &adminv1.ListBillingEventsResponse{
		Events: events,
		PageInfo: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    false,
		},
	}, nil
}

func hasDefaultPM(pms []tenantdb.PaymentMethodRow) bool {
	for _, pm := range pms {
		if pm.IsDefault {
			return true
		}
	}
	return false
}

func subscriptionStateToProto(st *WorkspaceBillingState) *adminv1.SubscriptionSummary {
	if st.Subscription == nil {
		return nil
	}
	summary := subscriptionRowToProto(*st.Subscription)
	if st.TrialEndsAt != nil {
		summary.TrialEndsAt = timestamppb.New(*st.TrialEndsAt)
	}
	if st.PausedAt != nil {
		summary.PausedAt = timestamppb.New(*st.PausedAt)
	}
	if st.PauseAutoResumesAt != nil {
		summary.PauseAutoResumesAt = timestamppb.New(*st.PauseAutoResumesAt)
	}
	if st.GracePeriodEndsAt != nil {
		summary.GracePeriodEndsAt = timestamppb.New(*st.GracePeriodEndsAt)
	}
	summary.DunningDay = st.DunningDay
	summary.DunningAttempt = st.DunningAttempt
	summary.ReadOnlyMode = st.ReadOnlyMode
	summary.ReadOnlyReason = st.ReadOnlyReason
	phase := st.RetentionPhase
	if phase == "" {
		phase = RetentionPhaseActive
	}
	summary.RetentionPhase = phase
	summary.RetentionOfferApplied = st.RetentionOfferApplied
	summary.ScheduledAddonRemovals = append([]string{}, st.ScheduledAddonRemovals...)
	summary.OverageTermsAccepted = st.OverageTermsAccepted
	summary.OverageUsedCredits = st.OverageUsedCredits.String()
	summary.PreservedPurchasedCredits = sumPreservedPurchasedCredits(st).String()
	return summary
}

func subscriptionRowToProto(row tenantdb.SubscriptionRow) *adminv1.SubscriptionSummary {
	var status adminv1.SubscriptionStatus
	switch row.Status {
	case "active":
		status = adminv1.SubscriptionStatus_SUBSCRIPTION_STATUS_ACTIVE
	case "past_due":
		status = adminv1.SubscriptionStatus_SUBSCRIPTION_STATUS_PAST_DUE
	case "canceled":
		status = adminv1.SubscriptionStatus_SUBSCRIPTION_STATUS_CANCELED
	case "trialing":
		status = adminv1.SubscriptionStatus_SUBSCRIPTION_STATUS_TRIALING
	case "incomplete":
		status = adminv1.SubscriptionStatus_SUBSCRIPTION_STATUS_INCOMPLETE
	case "paused":
		status = adminv1.SubscriptionStatus_SUBSCRIPTION_STATUS_PAUSED
	default:
		status = adminv1.SubscriptionStatus_SUBSCRIPTION_STATUS_UNSPECIFIED
	}
	var canceledAt *timestamppb.Timestamp
	if row.CanceledAt != nil {
		canceledAt = timestamppb.New(*row.CanceledAt)
	}
	return &adminv1.SubscriptionSummary{
		SubscriptionId:     &commonv1.UUID{Value: row.SubscriptionID},
		WorkspaceId:        &commonv1.UUID{Value: row.WorkspaceID},
		Plan:               row.Plan,
		BillingInterval:    row.BillingInterval,
		Status:             status,
		Amount:             &commonv1.Money{Amount: row.Amount.String(), Currency: row.Currency},
		CurrentPeriodStart: timestamppb.New(row.CurrentPeriodStart),
		CurrentPeriodEnd:   timestamppb.New(row.CurrentPeriodEnd),
		CancelAtPeriodEnd:  row.CancelAtPeriodEnd,
		CanceledAt:         canceledAt,
		Addons:             append([]string{}, row.Addons...),
	}
}

func paymentMethodRowToProto(row tenantdb.PaymentMethodRow) *adminv1.PaymentMethodSummary {
	return &adminv1.PaymentMethodSummary{
		PaymentMethodId:       &commonv1.UUID{Value: row.PaymentMethodID},
		StripePaymentMethodId: row.StripePaymentMethodID,
		Type:                  row.Type,
		CardBrand:             row.CardBrand,
		CardLast4:             row.CardLast4,
		CardExpMonth:          row.CardExpMonth,
		CardExpYear:           row.CardExpYear,
		IsDefault:             row.IsDefault,
	}
}

func paymentMethodsToProto(rows []tenantdb.PaymentMethodRow) []*adminv1.PaymentMethodSummary {
	out := make([]*adminv1.PaymentMethodSummary, 0, len(rows))
	for _, r := range rows {
		out = append(out, paymentMethodRowToProto(r))
	}
	return out
}

func invoiceRowToProto(row tenantdb.InvoiceRow) *adminv1.InvoiceSummary {
	var st adminv1.InvoiceStatus
	switch row.Status {
	case "draft":
		st = adminv1.InvoiceStatus_INVOICE_STATUS_DRAFT
	case "open":
		st = adminv1.InvoiceStatus_INVOICE_STATUS_OPEN
	case "paid":
		st = adminv1.InvoiceStatus_INVOICE_STATUS_PAID
	case "void":
		st = adminv1.InvoiceStatus_INVOICE_STATUS_VOID
	case "uncollectible":
		st = adminv1.InvoiceStatus_INVOICE_STATUS_UNCOLLECTIBLE
	default:
		st = adminv1.InvoiceStatus_INVOICE_STATUS_UNSPECIFIED
	}
	var paidAt *timestamppb.Timestamp
	if row.PaidAt != nil {
		paidAt = timestamppb.New(*row.PaidAt)
	}
	return &adminv1.InvoiceSummary{
		InvoiceId:        &commonv1.UUID{Value: row.InvoiceID},
		InvoiceNumber:    row.InvoiceNumber,
		Status:           st,
		Subtotal:         &commonv1.Money{Amount: row.Subtotal.String(), Currency: row.Currency},
		DiscountAmount:   &commonv1.Money{Amount: row.DiscountAmount.String(), Currency: row.Currency},
		TaxAmount:        &commonv1.Money{Amount: row.TaxAmount.String(), Currency: row.Currency},
		Total:            &commonv1.Money{Amount: row.Total.String(), Currency: row.Currency},
		AmountPaid:       &commonv1.Money{Amount: row.AmountPaid.String(), Currency: row.Currency},
		AmountDue:        &commonv1.Money{Amount: row.AmountDue.String(), Currency: row.Currency},
		InvoicePdfUrl:    row.InvoicePDFURL,
		HostedInvoiceUrl: row.HostedInvoiceURL,
		PaidAt:           paidAt,
		CreatedAt:        timestamppb.New(row.CreatedAt),
	}
}

func creditTxRowToProto(row tenantdb.CreditTransactionRow) *adminv1.CreditTransactionEntry {
	costStr := ""
	if row.ProviderCostUSD != nil {
		costStr = row.ProviderCostUSD.Fixed6String()
	}
	return &adminv1.CreditTransactionEntry{
		TransactionId:          &commonv1.UUID{Value: row.TransactionID},
		WorkspaceId:            &commonv1.UUID{Value: row.WorkspaceID},
		UserId:                 &commonv1.UUID{Value: row.UserID},
		OperationType:          row.OperationType,
		CreditsDelta:           row.CreditsDelta.String(),
		BalanceAfter:           row.BalanceAfter.String(),
		Source:                 row.Source,
		ReferenceId:            &commonv1.UUID{Value: row.ReferenceID},
		ReservationId:          &commonv1.UUID{Value: row.ReservationID},
		LotId:                  &commonv1.UUID{Value: row.LotID},
		QuoteId:                &commonv1.UUID{Value: row.QuoteID},
		ReferenceTransactionId: &commonv1.UUID{Value: row.ReferenceTransactionID},
		ProviderCostUsd:        costStr,
		RateVersion:            row.RateVersion,
		IdempotencyKey:         row.IdempotencyKey,
		Description:            row.Description,
		CreatedAt:              timestamppb.New(row.CreatedAt),
	}
}
