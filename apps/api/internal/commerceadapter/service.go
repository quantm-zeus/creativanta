package commerceadapter

import (
	"context"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/finance"
	"github.com/quantm-zeus/creativanta/apps/api/internal/inventory"
	"github.com/quantm-zeus/creativanta/apps/api/internal/order"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// Service orchestrates commerce platform adapters with order, inventory, and finance domains.
type Service struct {
	refundMu sync.Mutex
	orderSvc *order.Service
	invSvc   *inventory.Service
	finSvc   *finance.Service
	tiktok   *TikTokAdapter
	shopee   *ShopeeAdapter
	lazada   *LazadaAdapter
	stripe   *StripeAdapter
	clock    func() time.Time
}

func NewService(
	orderSvc *order.Service,
	invSvc *inventory.Service,
	finSvc *finance.Service,
	clock func() time.Time,
) *Service {
	if clock == nil {
		clock = time.Now
	}
	return &Service{
		orderSvc: orderSvc,
		invSvc:   invSvc,
		finSvc:   finSvc,
		tiktok:   NewTikTokAdapter(),
		shopee:   NewShopeeAdapter(),
		lazada:   NewLazadaAdapter(),
		stripe:   NewStripeAdapter(),
		clock:    clock,
	}
}

// GetPlatformCapability returns native vs manual capability status per connector specs §2 & §6.
func (s *Service) GetPlatformCapability(platform string, hasVerifiedAccess bool) PlatformCapabilityStatus {
	switch platform {
	case PlatformTikTok, PlatformShopee, PlatformLazada, PlatformStripe:
		if hasVerifiedAccess {
			return PlatformCapabilityStatus{
				Platform: platform,
				IsNative: true,
				Status:   "verified",
				Reason:   "Provider account authorized and active",
			}
		}
		return PlatformCapabilityStatus{
			Platform: platform,
			IsNative: false,
			Status:   "manual",
			Reason:   "Provider access unverified; fallback to authorized CSV and manual export under connector specs §2",
		}
	default:
		return PlatformCapabilityStatus{
			Platform: platform,
			IsNative: false,
			Status:   "unsupported",
			Reason:   "Unknown platform",
		}
	}
}

// ProcessOrderWebhook verifies, parses, and ingests an external order webhook from a commerce platform.
func (s *Service) ProcessOrderWebhook(
	ctx context.Context,
	platform, workspaceID, connectedAccountID string,
	rawPayload []byte,
	signature, secret, defaultLocationID string,
) (*order.Order, bool, error) {
	if workspaceID == "" {
		return nil, false, order.ErrMissingTenant
	}
	secret = strings.TrimSpace(secret)
	signature = strings.TrimSpace(signature)
	if secret == "" {
		return nil, false, fmt.Errorf("%w: webhook secret is required", ErrMissingCredentials)
	}
	if signature == "" {
		return nil, false, ErrInvalidSignature
	}

	var parsed *IngestedOrder
	var err error

	switch platform {
	case PlatformTikTok:
		if !s.tiktok.VerifySignature(rawPayload, signature, secret) {
			return nil, false, ErrInvalidSignature
		}
		parsed, err = s.tiktok.ParseOrderWebhook(rawPayload)
	case PlatformShopee:
		if !s.shopee.VerifySignature("https://api.creativanta.local/webhooks/shopee", rawPayload, signature, secret) {
			return nil, false, ErrInvalidSignature
		}
		parsed, err = s.shopee.ParseOrderWebhook(rawPayload)
	case PlatformLazada:
		if !s.lazada.VerifySignature(rawPayload, signature, secret) {
			return nil, false, ErrInvalidSignature
		}
		parsed, err = s.lazada.ParseOrderWebhook(rawPayload)
	case PlatformStripe:
		if !s.stripe.VerifySignature(rawPayload, signature, secret, 10*time.Minute) {
			return nil, false, ErrInvalidSignature
		}
		_, parsed, _, err = s.stripe.ParseWebhook(rawPayload)
		if parsed == nil && err == nil {
			return nil, false, nil // non-order event
		}
	default:
		return nil, false, fmt.Errorf("%w: %s", ErrUnsupportedPlatform, platform)
	}

	if err != nil {
		return nil, false, err
	}

	o := &order.Order{
		WorkspaceID:        workspaceID,
		SourceClass:        order.SourceClassOfficial,
		SourcePlatform:     platform,
		ExternalOrderID:    parsed.ExternalOrderID,
		ConnectedAccountID: connectedAccountID,
		TaxAmount:          parsed.TaxAmount,
		LifecycleState:     parsed.LifecycleState,
		Amount:             parsed.Amount,
		Currency:           parsed.Currency,
		Items:              parsed.Items,
		FeeBreakdown:       parsed.FeeBreakdown,
		OrderedAt:          parsed.OrderedAt,
	}

	createdOrder, created, err := s.orderSvc.IngestOrder(ctx, o, defaultLocationID)
	if err != nil {
		return nil, false, err
	}

	// If order arrives already completed (e.g. historical completed order), complete order
	if parsed.LifecycleState == order.StateCompleted && createdOrder.LifecycleState != order.StateCompleted {
		createdOrder, err = s.orderSvc.CompleteOrder(ctx, workspaceID, createdOrder.OrderID)
		if err != nil {
			return nil, false, err
		}
	}

	return createdOrder, created, nil
}

// ProcessReturnWebhook handles incoming return notifications, updates return lifecycle,
// and triggers physical restocking if goods are received (I05, RULE-M13-006).
func (s *Service) ProcessReturnWebhook(
	ctx context.Context,
	platform, workspaceID, internalOrderID string,
	rawPayload []byte,
	signature, secret, restockLocationID string,
) (*order.Return, error) {
	if workspaceID == "" {
		return nil, order.ErrMissingTenant
	}
	secret = strings.TrimSpace(secret)
	signature = strings.TrimSpace(signature)
	if secret == "" {
		return nil, fmt.Errorf("%w: webhook secret is required", ErrMissingCredentials)
	}
	if signature == "" {
		return nil, ErrInvalidSignature
	}

	var parsed *IngestedReturn
	var err error

	switch platform {
	case PlatformTikTok:
		if !s.tiktok.VerifySignature(rawPayload, signature, secret) {
			return nil, ErrInvalidSignature
		}
		parsed, err = s.tiktok.ParseReturnWebhook(rawPayload)
	case PlatformShopee:
		if !s.shopee.VerifySignature("https://api.creativanta.local/webhooks/shopee", rawPayload, signature, secret) {
			return nil, ErrInvalidSignature
		}
		parsed, err = s.shopee.ParseReturnWebhook(rawPayload)
	case PlatformLazada:
		if !s.lazada.VerifySignature(rawPayload, signature, secret) {
			return nil, ErrInvalidSignature
		}
		parsed, err = s.lazada.ParseReturnWebhook(rawPayload)
	default:
		return nil, fmt.Errorf("%w: %s", ErrUnsupportedPlatform, platform)
	}

	if err != nil {
		return nil, err
	}

	targetOrderID := internalOrderID
	if targetOrderID == "" {
		targetOrderID = parsed.ExternalOrderID
	}

	ret := &order.Return{
		WorkspaceID:    workspaceID,
		OrderID:        targetOrderID,
		ReturnType:     "physical",
		Items:          parsed.Items,
		LifecycleState: parsed.LifecycleState,
		TrackingNumber: parsed.TrackingNumber,
	}

	createdRet, err := s.orderSvc.CreateReturn(ctx, ret)
	if err != nil {
		return nil, err
	}

	// If return status is received/closed, physically restock the returned items
	if parsed.LifecycleState == order.ReturnReceived || parsed.LifecycleState == order.ReturnClosed {
		return s.orderSvc.ReceiveReturn(ctx, workspaceID, createdRet.ReturnID, restockLocationID)
	}

	return createdRet, nil
}

// ProcessRefundWebhook handles financial refund notifications, ensures cumulative bounds,
// and posts negative refund deductions to Finance without restocking goods (RULE-M13-006).
func (s *Service) ProcessRefundWebhook(
	ctx context.Context,
	platform, workspaceID, internalOrderID string,
	rawPayload []byte,
	signature, secret string,
) (*order.Refund, *order.Order, error) {
	if workspaceID == "" {
		return nil, nil, order.ErrMissingTenant
	}
	secret = strings.TrimSpace(secret)
	signature = strings.TrimSpace(signature)
	if secret == "" {
		return nil, nil, fmt.Errorf("%w: webhook secret is required", ErrMissingCredentials)
	}
	if signature == "" {
		return nil, nil, ErrInvalidSignature
	}

	var parsed *IngestedRefund
	var err error

	switch platform {
	case PlatformTikTok:
		if !s.tiktok.VerifySignature(rawPayload, signature, secret) {
			return nil, nil, ErrInvalidSignature
		}
		parsed, err = s.tiktok.ParseRefundWebhook(rawPayload)
	case PlatformShopee:
		if !s.shopee.VerifySignature("https://api.creativanta.local/webhooks/shopee", rawPayload, signature, secret) {
			return nil, nil, ErrInvalidSignature
		}
		parsed, err = s.shopee.ParseRefundWebhook(rawPayload)
	case PlatformLazada:
		if !s.lazada.VerifySignature(rawPayload, signature, secret) {
			return nil, nil, ErrInvalidSignature
		}
		parsed, err = s.lazada.ParseRefundWebhook(rawPayload)
	case PlatformStripe:
		if !s.stripe.VerifySignature(rawPayload, signature, secret, 10*time.Minute) {
			return nil, nil, ErrInvalidSignature
		}
		_, _, parsed, err = s.stripe.ParseWebhook(rawPayload)
	default:
		return nil, nil, fmt.Errorf("%w: %s", ErrUnsupportedPlatform, platform)
	}

	if err != nil {
		return nil, nil, err
	}
	if parsed == nil {
		return nil, nil, fmt.Errorf("%w: missing refund payload", ErrInvalidPayload)
	}

	targetOrderID := internalOrderID
	if targetOrderID == "" {
		targetOrderID = parsed.ExternalOrderID
	}

	s.refundMu.Lock()
	defer s.refundMu.Unlock()

	refundAmount := parsed.Amount
	externalRefundID := parsed.ExternalRefundID

	existingRefunds, err := s.orderSvc.Store().ListRefundsByOrder(ctx, workspaceID, targetOrderID)
	if err != nil {
		return nil, nil, err
	}

	if parsed.IsCumulative {
		bookedTotal := tenantdb.ZeroDecimal()
		var latestRef *order.Refund
		for _, r := range existingRefunds {
			if r.LifecycleState == order.RefundRejected {
				continue
			}
			bookedTotal, err = bookedTotal.Add(r.Amount)
			if err != nil {
				return nil, nil, err
			}
			latestRef = r
		}

		delta, err := parsed.Amount.Sub(bookedTotal)
		if err != nil {
			return nil, nil, err
		}
		if delta.IsNegative() || delta.IsZero() {
			ord, err := s.orderSvc.GetOrder(ctx, workspaceID, targetOrderID)
			if err != nil {
				return nil, nil, err
			}
			return latestRef, ord, nil
		}

		refundAmount = delta
		externalRefundID = fmt.Sprintf("%s:cum:%s", parsed.ExternalRefundID, parsed.Amount.Fixed6String())
	} else if externalRefundID != "" {
		for _, r := range existingRefunds {
			if r.SourcePlatform == platform && r.ExternalRefundID == externalRefundID {
				if r.LifecycleState == order.RefundApproved || r.LifecycleState == order.RefundCompleted {
					ord, err := s.orderSvc.GetOrder(ctx, workspaceID, targetOrderID)
					return r, ord, err
				}
				return s.orderSvc.ApproveRefund(ctx, workspaceID, r.RefundID)
			}
		}
	}

	ref := &order.Refund{
		WorkspaceID:      workspaceID,
		OrderID:          targetOrderID,
		RefundType:       "partial",
		Amount:           refundAmount,
		Currency:         parsed.Currency,
		Reason:           parsed.Reason,
		SourceClass:      order.SourceClassOfficial,
		SourcePlatform:   platform,
		ExternalRefundID: externalRefundID,
	}

	createdRef, _, err := s.orderSvc.RequestRefund(ctx, ref)
	if err != nil {
		return nil, nil, err
	}

	return s.orderSvc.ApproveRefund(ctx, workspaceID, createdRef.RefundID)
}

// SyncPlatformStock computes the delta between external platform stock count and local on_hand balance,
// appending an adjustment movement only when delta != 0 (I10).
func (s *Service) SyncPlatformStock(
	ctx context.Context,
	workspaceID, platform, locationID, skuID string,
	reportedStock int32,
	syncKey string,
) (*StockSyncResult, error) {
	if workspaceID == "" {
		return nil, order.ErrMissingTenant
	}

	mov, err := s.invSvc.PlatformSyncAbsoluteCount(ctx, workspaceID, locationID, skuID, reportedStock, syncKey)
	if err != nil {
		return nil, fmt.Errorf("sync platform stock: %w", err)
	}

	if mov == nil {
		return &StockSyncResult{
			Platform:      platform,
			WorkspaceID:   workspaceID,
			LocationID:    locationID,
			SkuID:         skuID,
			ReportedStock: reportedStock,
			DeltaQuantity: 0,
			IsNoOp:        true,
		}, nil
	}

	return &StockSyncResult{
		Platform:      platform,
		WorkspaceID:   workspaceID,
		LocationID:    locationID,
		SkuID:         skuID,
		ReportedStock: reportedStock,
		DeltaQuantity: mov.Quantity,
		MovementID:    mov.MovementID,
		IsNoOp:        false,
	}, nil
}

// ReconcileSettlementFees updates an order's fee breakdown (from platform settlement)
// and records correcting postings in Finance while preserving proof and audit trail (F06).
func (s *Service) ReconcileSettlementFees(
	ctx context.Context,
	workspaceID, orderID string,
	correctedFees order.FeeBreakdown,
	version, evidenceRef, reason string,
) (*order.Order, error) {
	return s.orderSvc.UpdateFeeBreakdown(ctx, workspaceID, orderID, correctedFees, version, evidenceRef, reason)
}

// ReconcileStockWithBalance compares stock movement ledger and balance projections,
// detecting any discrepancies (I09).
func (s *Service) ReconcileStockWithBalance(
	ctx context.Context,
	workspaceID, skuID, locationID string,
) (*inventory.DiscrepancyReport, error) {
	return s.invSvc.ReconcileLedger(ctx, workspaceID, skuID, locationID)
}
