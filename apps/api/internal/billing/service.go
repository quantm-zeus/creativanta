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
	SubscriptionID    string
	PeriodKey         string
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
		periodEnd := now.Add(30 * 24 * time.Hour)
		if interval == "annual" {
			periodEnd = now.Add(365 * 24 * time.Hour)
		}
		if st.Subscription != nil {
			subID = st.Subscription.SubscriptionID
			if effectiveMode == "end_of_period" && !st.Subscription.CurrentPeriodEnd.IsZero() {
				periodEnd = st.Subscription.CurrentPeriodEnd
			}
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
			CurrentPeriodStart: now,
			CurrentPeriodEnd:   periodEnd,
			CancelAtPeriodEnd:  false,
			Addons:             append([]string{}, req.GetAddons()...),
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
				"previous_plan":  currentTier.TierCode,
				"target_plan":    targetTier.TierCode,
				"effective_mode": effectiveMode,
			},
			CreatedAt: now,
		})

		resp = &adminv1.ChangePlanResponse{
			Subscription:      subscriptionRowToProto(*st.Subscription),
			EffectiveMode:     effectiveMode,
			CheckoutSessionId: "cs_plan_" + req.GetContext().GetIdempotencyKey(),
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
	var subSummary *adminv1.SubscriptionSummary
	err = s.engine.store.WithWorkspaceTx(pctx.WorkspaceID, func(st *WorkspaceBillingState) error {
		tier, ok := LookupTier(st.SubscriptionTier)
		if !ok {
			tier, _ = LookupTier("free")
		}
		if req.GetPauseInstead() {
			if !tier.PauseEligible {
				return ErrPlanFeatureNotAllowed
			}
			if req.GetPauseMonths() < 1 || req.GetPauseMonths() > 3 {
				return fmt.Errorf("%w: pause_months must be between 1 and 3", ErrInvalidBillingInput)
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

		if req.GetPauseInstead() {
			st.Subscription.Status = "paused"
		} else {
			st.Subscription.CancelAtPeriodEnd = true
			t := now
			st.Subscription.CanceledAt = &t
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
		subSummary = subscriptionRowToProto(*st.Subscription)
		return nil
	})
	if err != nil {
		return nil, err
	}
	return &adminv1.CancelSubscriptionResponse{Subscription: subSummary}, nil
}

// UpdatePaymentMethod implements AdminBillingService/UpdatePaymentMethod (workspace:billing:manage, Owner-only).
// Enforces EC-M23-001: blocks removing the last payment method while on an active paid plan (BILLING_CONFLICT_001).
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
				PaymentMethods: paymentMethodsToProto(st.PaymentMethods),
			}
			return nil
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
			newPM := tenantdb.PaymentMethodRow{
				PaymentMethodID:       s.engine.store.nextUUID("91000000"),
				WorkspaceID:           pctx.WorkspaceID,
				StripePaymentMethodID: pmStripeID,
				Type:                  "card",
				CardBrand:             "visa",
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
		resp = &adminv1.UpdatePaymentMethodResponse{
			PaymentMethod:  paymentMethodRowToProto(*target),
			PaymentMethods: paymentMethodsToProto(st.PaymentMethods),
		}
		return nil
	})
	return resp, err
}

// SettleStripeWebhook processes a verified Stripe webhook event idempotently.
// Credits and subscription period allocations are granted ONLY upon verified webhook settlement.
func (s *Service) SettleStripeWebhook(evt StripeWebhookEvent) (WebhookSettlementResult, error) {
	if strings.TrimSpace(evt.EventID) == "" || strings.TrimSpace(evt.WorkspaceID) == "" {
		return WebhookSettlementResult{}, ErrInvalidBillingInput
	}
	now := evt.OccurredAt
	if now.IsZero() {
		now = s.clock()
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
		st.ProcessedWebhooks[evt.EventID] = now

		switch evt.EventType {
		case "checkout.session.completed":
			sess, ok := st.CheckoutSessions[evt.CheckoutSessionID]
			if !ok {
				return fmt.Errorf("%w: unknown checkout_session_id %q", ErrInvalidBillingInput, evt.CheckoutSessionID)
			}
			if sess.Status == "settled" {
				out = WebhookSettlementResult{
					EventID:   evt.EventID,
					Duplicate: true,
					Status:    "session_already_settled",
				}
				return nil
			}
			pack, ok := LookupCreditPack(sess.PackCode)
			if !ok {
				return fmt.Errorf("%w: invalid pack_code %q on session", ErrInvalidBillingInput, sess.PackCode)
			}

			grantKey := "stripe_pack:" + sess.SessionID
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
				StripeInvoiceID:  "in_" + sess.SessionID,
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
			out = WebhookSettlementResult{
				EventID:    evt.EventID,
				Duplicate:  false,
				Status:     "settled_credit_pack",
				GrantedLot: &lot,
				Invoice:    &inv,
			}
			return nil

		case "invoice.payment_failed":
			if st.Subscription != nil {
				st.Subscription.Status = "past_due"
				st.Subscription.UpdatedAt = now
			}
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
			subProto = subscriptionRowToProto(*st.Subscription)
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

func hasDefaultPM(pms []tenantdb.PaymentMethodRow) bool {
	for _, pm := range pms {
		if pm.IsDefault {
			return true
		}
	}
	return false
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
