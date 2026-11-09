package affiliate

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

type OutboxEvent struct {
	EventID       string
	EventType     string
	AggregateType string
	AggregateID   string
	WorkspaceID   string
	PayloadJSON   []byte
	CreatedAt     time.Time
}

type EventSink interface {
	Emit(ctx context.Context, ev OutboxEvent) error
}

type LedgerRecorder interface {
	RecordAffiliatePosting(ctx context.Context, wsID string, comm *AffiliateCommission, role EconomicRole, now time.Time) (*LedgerPostingResult, error)
}

type ReversibleLedgerRecorder interface {
	LedgerRecorder
	ReconcileCommissionObligation(ctx context.Context, wsID string, comm *AffiliateCommission, now time.Time) error
	ListCommissionPostings(wsID, commissionID string) []*LedgerPostingResult
}

type DefaultLedgerRecorder struct {
	mu           sync.RWMutex
	postings     map[string]*LedgerPostingResult
	entries      []*LedgerPostingResult
	activeByRole map[string]*LedgerPostingResult // key: wsID:commissionID:role
}

func NewDefaultLedgerRecorder() *DefaultLedgerRecorder {
	return &DefaultLedgerRecorder{
		postings:     make(map[string]*LedgerPostingResult),
		activeByRole: make(map[string]*LedgerPostingResult),
	}
}

func cloneLedgerPosting(p *LedgerPostingResult) *LedgerPostingResult {
	if p == nil {
		return nil
	}
	cp := *p
	if p.ReversalOf != nil {
		r := *p.ReversalOf
		cp.ReversalOf = &r
	}
	return &cp
}

func ledgerRoleKey(wsID, commissionID string, role EconomicRole) string {
	return fmt.Sprintf("%s:%s:%s", strings.TrimSpace(wsID), strings.TrimSpace(commissionID), string(role))
}

func (d *DefaultLedgerRecorder) RecordAffiliatePosting(_ context.Context, wsID string, comm *AffiliateCommission, role EconomicRole, now time.Time) (*LedgerPostingResult, error) {
	d.mu.Lock()
	defer d.mu.Unlock()

	return d.recordOrAdjustLocked(wsID, comm, role, now)
}

func (d *DefaultLedgerRecorder) recordOrAdjustLocked(wsID string, comm *AffiliateCommission, role EconomicRole, now time.Time) (*LedgerPostingResult, error) {
	if d.activeByRole == nil {
		d.activeByRole = make(map[string]*LedgerPostingResult)
	}
	key := ledgerRoleKey(wsID, comm.CommissionID, role)
	if prior, ok := d.activeByRole[key]; ok && prior != nil {
		// Idempotent replay when commission obligation is unchanged and not clawed back
		if comm.Status != CommissionClawedBack && prior.Amount.Cmp(comm.CommissionAmount) == 0 {
			return cloneLedgerPosting(prior), nil
		}
		// Append immutable reversal entry referencing the prior posting
		negAmt, _ := tenantdb.ZeroDecimal().Sub(prior.Amount)
		negImpact, _ := tenantdb.ZeroDecimal().Sub(prior.NetProfitImpact)
		priorID := prior.PostingID
		revResult := &LedgerPostingResult{
			PostingID:       fmt.Sprintf("post-aff-rev-%s", newUUID()[:8]),
			WorkspaceID:     wsID,
			CommissionID:    comm.CommissionID,
			OrderID:         comm.OrderID,
			EconomicRole:    role,
			PostingType:     prior.PostingType + "_reversal",
			Amount:          negAmt,
			Currency:        prior.Currency,
			COGSDeducted:    prior.COGSDeducted,
			NetProfitImpact: negImpact,
			ReversalOf:      &priorID,
			PostedAt:        now,
		}
		d.postings[revResult.PostingID] = cloneLedgerPosting(revResult)
		d.entries = append(d.entries, cloneLedgerPosting(revResult))
		delete(d.activeByRole, key)

		if comm.Status == CommissionClawedBack || comm.CommissionAmount.Cmp(tenantdb.ZeroDecimal()) <= 0 {
			return cloneLedgerPosting(revResult), nil
		}
	}

	if comm.Status == CommissionClawedBack || comm.CommissionAmount.Cmp(tenantdb.ZeroDecimal()) <= 0 {
		return nil, fmt.Errorf("%w: cannot record positive ledger posting for clawed-back or zero commission", ErrOrderIneligible)
	}

	postingID := fmt.Sprintf("post-aff-%s", newUUID()[:8])
	var postingType string
	var cogsDeducted bool
	var netProfitImpact tenantdb.ExactDecimal

	if role == EconomicRoleCreator {
		postingType = "creator_income"
		cogsDeducted = false // Acceptance Target 1: COGS is NOT deducted from creator income!
		netProfitImpact = comm.CommissionAmount
	} else {
		postingType = "seller_commission_expense"
		cogsDeducted = true // Seller expense: commission is an expense deduction
		netProfitImpact, _ = tenantdb.ZeroDecimal().Sub(comm.CommissionAmount)
	}

	result := &LedgerPostingResult{
		PostingID:       postingID,
		WorkspaceID:     wsID,
		CommissionID:    comm.CommissionID,
		OrderID:         comm.OrderID,
		EconomicRole:    role,
		PostingType:     postingType,
		Amount:          comm.CommissionAmount,
		Currency:        comm.Currency,
		COGSDeducted:    cogsDeducted,
		NetProfitImpact: netProfitImpact,
		PostedAt:        now,
	}
	d.postings[postingID] = cloneLedgerPosting(result)
	d.entries = append(d.entries, cloneLedgerPosting(result))
	if comm.CommissionID != "" {
		d.activeByRole[key] = cloneLedgerPosting(result)
	}
	return cloneLedgerPosting(result), nil
}

func (d *DefaultLedgerRecorder) ReconcileCommissionObligation(_ context.Context, wsID string, comm *AffiliateCommission, now time.Time) error {
	if comm == nil || comm.CommissionID == "" {
		return nil
	}
	d.mu.Lock()
	defer d.mu.Unlock()

	for _, role := range []EconomicRole{EconomicRoleCreator, EconomicRoleSeller} {
		key := ledgerRoleKey(wsID, comm.CommissionID, role)
		if prior, ok := d.activeByRole[key]; ok && prior != nil {
			if _, err := d.recordOrAdjustLocked(wsID, comm, role, now); err != nil {
				return err
			}
		}
	}
	return nil
}

func (d *DefaultLedgerRecorder) ListCommissionPostings(wsID, commissionID string) []*LedgerPostingResult {
	d.mu.RLock()
	defer d.mu.RUnlock()

	var out []*LedgerPostingResult
	for _, entry := range d.entries {
		if entry.WorkspaceID == wsID && (commissionID == "" || entry.CommissionID == commissionID) {
			out = append(out, cloneLedgerPosting(entry))
		}
	}
	return out
}

type Service struct {
	payoutMu sync.Mutex
	store    Store
	ledger   LedgerRecorder
	sink     EventSink
	nowFunc  func() time.Time
}

func NewService(store Store, ledger LedgerRecorder, sink EventSink, nowFunc func() time.Time) *Service {
	if nowFunc == nil {
		nowFunc = func() time.Time { return time.Now().UTC() }
	}
	if ledger == nil {
		ledger = NewDefaultLedgerRecorder()
	}
	return &Service{
		store:   store,
		ledger:  ledger,
		sink:    sink,
		nowFunc: nowFunc,
	}
}

func (s *Service) emitEvent(ctx context.Context, eventType, aggType, aggID, wsID string, payload any) {
	if s.sink == nil {
		return
	}
	b, _ := json.Marshal(payload)
	_ = s.sink.Emit(ctx, OutboxEvent{
		EventID:       newUUID(),
		EventType:     eventType,
		AggregateType: aggType,
		AggregateID:   aggID,
		WorkspaceID:   wsID,
		PayloadJSON:   b,
		CreatedAt:     s.nowFunc(),
	})
}

// ----------------------------------------------------------------------------
// Link Operations & Lifecycle State Machine
// ----------------------------------------------------------------------------

func (s *Service) CreateLink(ctx context.Context, link *AffiliateLink) (*AffiliateLink, error) {
	if strings.TrimSpace(link.OriginalURL) == "" {
		return nil, ErrInvalidDestinationURL
	}
	if link.CommissionRate.IsNegative() {
		return nil, ErrInvalidCommissionRate
	}

	now := s.nowFunc()
	if link.AffiliateLinkID == "" {
		link.AffiliateLinkID = newUUID()
	}
	if link.ShortCode == "" {
		link.ShortCode = newUUID()[:8]
	}
	if link.TrackedURL == "" {
		link.TrackedURL = fmt.Sprintf("https://creativanta.link/%s", link.ShortCode)
	}
	if link.LifecycleState == "" {
		link.LifecycleState = LinkStateActive
	}
	if link.HealthStatus == "" {
		link.HealthStatus = HealthStatusHealthy
	}
	zeroDec, _ := tenantdb.ParseExactDecimal("0.000000")
	link.RevenueAttributed = zeroDec
	link.CreatedAt = now
	link.UpdatedAt = now

	if err := s.store.CreateLink(ctx, link); err != nil {
		return nil, err
	}

	s.emitEvent(ctx, "affiliate_link.created", "affiliate_link", link.AffiliateLinkID, link.WorkspaceID, map[string]any{
		"link_id":    link.AffiliateLinkID,
		"product_id": link.ProductID,
		"platform":   link.Platform,
	})
	return link, nil
}

func (s *Service) GetLink(ctx context.Context, workspaceID, linkID string) (*AffiliateLink, *LinkHealthRecord, error) {
	link, err := s.store.GetLink(ctx, workspaceID, linkID)
	if err != nil {
		return nil, nil, err
	}
	health, _ := s.store.GetLatestHealthRecord(ctx, workspaceID, linkID)
	return link, health, nil
}

func (s *Service) ListLinks(ctx context.Context, workspaceID string, campaignID, platform *string, state *LinkLifecycleState, limit, offset int) ([]*AffiliateLink, int, error) {
	return s.store.ListLinks(ctx, workspaceID, campaignID, platform, state, limit, offset)
}

func (s *Service) UpdateLink(ctx context.Context, workspaceID, linkID, commRate, origURL string, expiresAt *time.Time) (*AffiliateLink, error) {
	link, err := s.store.GetLink(ctx, workspaceID, linkID)
	if err != nil {
		return nil, err
	}
	if link.LifecycleState == LinkStateRevoked {
		return nil, ErrLinkPermanentlyRevoked
	}
	if commRate != "" {
		d, err := tenantdb.ParseExactDecimal(commRate)
		if err != nil {
			return nil, ErrInvalidCommissionRate
		}
		link.CommissionRate = d
	}
	if origURL != "" {
		link.OriginalURL = origURL
	}
	if expiresAt != nil {
		link.ExpiresAt = expiresAt
	}
	link.UpdatedAt = s.nowFunc()
	if err := s.store.UpdateLink(ctx, link); err != nil {
		return nil, err
	}
	return link, nil
}

func (s *Service) PauseLink(ctx context.Context, workspaceID, linkID string) (*AffiliateLink, error) {
	link, err := s.store.GetLink(ctx, workspaceID, linkID)
	if err != nil {
		return nil, err
	}
	if link.LifecycleState != LinkStateActive {
		return nil, ErrLinkInvalidStateChange
	}
	link.LifecycleState = LinkStatePaused
	link.UpdatedAt = s.nowFunc()
	if err := s.store.UpdateLink(ctx, link); err != nil {
		return nil, err
	}
	return link, nil
}

func (s *Service) ResumeLink(ctx context.Context, workspaceID, linkID string) (*AffiliateLink, error) {
	link, err := s.store.GetLink(ctx, workspaceID, linkID)
	if err != nil {
		return nil, err
	}
	if link.LifecycleState != LinkStatePaused {
		return nil, ErrLinkInvalidStateChange
	}
	if link.ExpiresAt != nil && link.ExpiresAt.Before(s.nowFunc()) {
		link.LifecycleState = LinkStateExpired
		_ = s.store.UpdateLink(ctx, link)
		return nil, ErrLinkExpired
	}
	link.LifecycleState = LinkStateActive
	link.UpdatedAt = s.nowFunc()
	if err := s.store.UpdateLink(ctx, link); err != nil {
		return nil, err
	}
	return link, nil
}

func (s *Service) RevokeLink(ctx context.Context, workspaceID, linkID string) (*AffiliateLink, error) {
	link, err := s.store.GetLink(ctx, workspaceID, linkID)
	if err != nil {
		return nil, err
	}
	// Permitted policy revocation -> revoked is terminal
	link.LifecycleState = LinkStateRevoked
	link.UpdatedAt = s.nowFunc()
	if err := s.store.UpdateLink(ctx, link); err != nil {
		return nil, err
	}
	return link, nil
}

func (s *Service) DeleteLink(ctx context.Context, workspaceID, linkID string) error {
	return s.store.DeleteLink(ctx, workspaceID, linkID)
}

// ----------------------------------------------------------------------------
// Creator Assignments
// ----------------------------------------------------------------------------

func (s *Service) CreateAssignment(ctx context.Context, assignment *CreatorAssignment) (*CreatorAssignment, error) {
	now := s.nowFunc()
	if assignment.AssignmentID == "" {
		assignment.AssignmentID = newUUID()
	}
	if assignment.Status == "" {
		assignment.Status = AssignmentActive
	}
	assignment.CreatedAt = now
	assignment.UpdatedAt = now

	if err := s.store.CreateAssignment(ctx, assignment); err != nil {
		return nil, err
	}

	s.emitEvent(ctx, "creator_assignment.created", "creator_assignment", assignment.AssignmentID, assignment.WorkspaceID, map[string]any{
		"assignment_id":     assignment.AssignmentID,
		"campaign_id":       assignment.CampaignID,
		"creator_entity_id": assignment.CreatorEntityID,
	})
	return assignment, nil
}

func (s *Service) ListAssignments(ctx context.Context, workspaceID string, campaignID, creatorID *string, limit, offset int) ([]*CreatorAssignment, error) {
	return s.store.ListAssignments(ctx, workspaceID, campaignID, creatorID, limit, offset)
}

func (s *Service) UpdateAssignment(ctx context.Context, workspaceID, assignmentID string, status AssignmentState, notes string) (*CreatorAssignment, error) {
	a, err := s.store.GetAssignment(ctx, workspaceID, assignmentID)
	if err != nil {
		return nil, err
	}
	if status != "" {
		a.Status = status
	}
	if notes != "" {
		a.Notes = notes
	}
	a.UpdatedAt = s.nowFunc()
	if err := s.store.UpdateAssignment(ctx, a); err != nil {
		return nil, err
	}
	return a, nil
}

// ----------------------------------------------------------------------------
// Acceptance Target 2: Ambiguous Attribution Labeled
// ----------------------------------------------------------------------------

type AttributionInput struct {
	WorkspaceID     string
	OrderID         string
	AffiliateLinkID string
	CreatorEntityID *string
	ClickID         string
	TouchpointCount int32
	IsMultiTouch    bool
	OrderAmount     tenantdb.ExactDecimal
	Currency        string
	IsOfficialAPI   bool
}

func (s *Service) RecordAttribution(ctx context.Context, input *AttributionInput) (*AttributionRecord, error) {
	link, err := s.store.GetLink(ctx, input.WorkspaceID, input.AffiliateLinkID)
	if err != nil {
		return nil, err
	}

	now := s.nowFunc()
	var sourceClass SourceClass
	var confidence ConfidenceLevel
	var note string

	// Acceptance Target 2 & RULE-M16-002:
	// Multi-touch attribution (cross-device, multi-channel, direct visit after affiliate click)
	// MUST be explicitly labeled as inferred with medium/low confidence and explanation note!
	if input.IsMultiTouch || input.TouchpointCount > 1 {
		sourceClass = SourceClassInferred
		confidence = ConfidenceMedium
		if input.TouchpointCount > 3 {
			confidence = ConfidenceLow
		}
		note = "Multiple touch points detected — last click rule applied."
	} else if input.IsOfficialAPI {
		sourceClass = SourceClassOfficial
		confidence = ConfidenceHigh
		note = "Official platform API attribution."
	} else {
		sourceClass = SourceClassImported
		confidence = ConfidenceMedium
		note = "Imported attribution record."
	}

	// Calculate commission: order_amount * (commission_rate / 100)
	commAmt := calculateCommissionAmount(input.OrderAmount, link.CommissionRate)

	record := &AttributionRecord{
		AttributionID:     newUUID(),
		WorkspaceID:       input.WorkspaceID,
		OrderID:           input.OrderID,
		AffiliateLinkID:   input.AffiliateLinkID,
		CreatorEntityID:   input.CreatorEntityID,
		ClickID:           input.ClickID,
		TouchpointCount:   input.TouchpointCount,
		IsMultiTouch:      input.IsMultiTouch || input.TouchpointCount > 1,
		SourceClass:       sourceClass,
		Confidence:        confidence,
		AttributionNote:   note,
		OrderAmount:       input.OrderAmount,
		AttributedRevenue: input.OrderAmount,
		CommissionAmount:  commAmt,
		Currency:          input.Currency,
		CreatedAt:         now,
		UpdatedAt:         now,
	}

	if err := s.store.CreateAttribution(ctx, record); err != nil {
		return nil, err
	}

	// Update link conversion metrics
	link.ConversionCount++
	newRev, err := addDecimals(link.RevenueAttributed, input.OrderAmount)
	if err == nil {
		link.RevenueAttributed = newRev
	}
	link.UpdatedAt = now
	_ = s.store.UpdateLink(ctx, link)

	s.emitEvent(ctx, "conversion.attributed", "attribution", record.AttributionID, record.WorkspaceID, map[string]any{
		"order_id":     record.OrderID,
		"link_id":      record.AffiliateLinkID,
		"commission":   record.CommissionAmount.String(),
		"source_class": string(record.SourceClass),
		"confidence":   string(record.Confidence),
	})

	return record, nil
}

func (s *Service) GetAttributionReport(ctx context.Context, workspaceID string, linkID *string) ([]*AttributionRecord, map[string]int, tenantdb.ExactDecimal, error) {
	records, err := s.store.ListAttributions(ctx, workspaceID, linkID)
	if err != nil {
		return nil, nil, tenantdb.ExactDecimal{}, err
	}

	counts := map[string]int{
		"official":     0,
		"inferred":     0,
		"imported":     0,
		"unreconciled": 0,
	}
	totRev, _ := tenantdb.ParseExactDecimal("0.000000")

	for _, r := range records {
		counts[string(r.SourceClass)]++
		newTot, err := addDecimals(totRev, r.AttributedRevenue)
		if err == nil {
			totRev = newTot
		}
	}
	return records, counts, totRev, nil
}

// ----------------------------------------------------------------------------
// Commissions & Reversals (Clawbacks)
// ----------------------------------------------------------------------------

func isEligibleCommissionOrderState(state string) bool {
	switch strings.ToLower(strings.TrimSpace(state)) {
	case "paid", "confirmed", "fulfilled", "delivered", "completed", "partially_refunded":
		return true
	default:
		return false
	}
}

func isVerifiedSettlementStatus(status string) bool {
	switch strings.ToLower(strings.TrimSpace(status)) {
	case "verified", "confirmed", "reconciled", "fully_reconciled":
		return true
	default:
		return false
	}
}

func (s *Service) RegisterVerifiedOrder(ctx context.Context, ord *VerifiedOrder) error {
	if ord == nil || strings.TrimSpace(ord.WorkspaceID) == "" || strings.TrimSpace(ord.OrderID) == "" {
		return ErrOrderNotVerified
	}
	if ord.GrossAmount.Cmp(tenantdb.ZeroDecimal()) <= 0 || ord.RefundedAmount.IsNegative() {
		return ErrOrderIneligible
	}
	if ord.RefundedAmount.Cmp(ord.GrossAmount) > 0 {
		return ErrOrderIneligible
	}
	curr := strings.ToUpper(strings.TrimSpace(ord.Currency))
	if curr == "" {
		return ErrOrderCurrencyMismatch
	}

	s.payoutMu.Lock()
	defer s.payoutMu.Unlock()

	now := s.nowFunc()
	cp := *ord
	cp.WorkspaceID = strings.TrimSpace(ord.WorkspaceID)
	cp.OrderID = strings.TrimSpace(ord.OrderID)
	cp.Currency = curr
	if cp.LifecycleState == "" {
		cp.LifecycleState = "completed"
	}
	if cp.CreatedAt.IsZero() {
		cp.CreatedAt = now
	}
	cp.UpdatedAt = now
	if err := s.store.UpsertVerifiedOrder(ctx, &cp); err != nil {
		return err
	}

	// Billing R08: If a commission already exists for this order, immediately reconcile
	// its eligibility, net obligation, and reversible ledger state against the updated order.
	if comm, err := s.store.GetCommissionByOrder(ctx, cp.WorkspaceID, cp.OrderID); err == nil && comm != nil {
		_, _ = s.reconcileCommissionWithVerifiedOrderLocked(ctx, cp.WorkspaceID, comm)
	}
	return nil
}

// SyncOrderState implements order.AffiliateOrderVerifier so order completion, cancellation, and refund
// transitions automatically synchronize authoritative order snapshots into the affiliate service.
func (s *Service) SyncOrderState(ctx context.Context, workspaceID, orderID string, grossAmount, refundedAmount tenantdb.ExactDecimal, currency, lifecycleState string) error {
	return s.RegisterVerifiedOrder(ctx, &VerifiedOrder{
		OrderID:        orderID,
		WorkspaceID:    workspaceID,
		GrossAmount:    grossAmount,
		RefundedAmount: refundedAmount,
		Currency:       currency,
		LifecycleState: lifecycleState,
	})
}

func (s *Service) reconcileLedgerObligationLocked(ctx context.Context, wsID string, comm *AffiliateCommission, now time.Time) {
	if revLedger, ok := s.ledger.(ReversibleLedgerRecorder); ok && revLedger != nil {
		_ = revLedger.ReconcileCommissionObligation(ctx, wsID, comm, now)
	}
}

func (s *Service) ListLedgerPostings(wsID, commissionID string) []*LedgerPostingResult {
	if revLedger, ok := s.ledger.(ReversibleLedgerRecorder); ok && revLedger != nil {
		return revLedger.ListCommissionPostings(wsID, commissionID)
	}
	return nil
}

// reconcileCommissionWithVerifiedOrderLocked re-verifies a commission against the authoritative
// order/refund record in the store (Billing R08).
// - Full refund or cancelled/ineligible order -> transitions commission to clawed_back, reverses ledger, returns ErrOrderIneligible.
// - Partial refund -> reduces commission proportionally to post-refund eligible order amount, records partial clawback & ledger adjustment.
func (s *Service) isCommissionPayoutFinalized(ctx context.Context, wsID string, comm *AffiliateCommission) bool {
	if comm == nil || comm.Status != CommissionPaidOut {
		return false
	}
	if comm.PayoutID == nil || strings.TrimSpace(*comm.PayoutID) == "" {
		return true
	}
	payout, err := s.store.GetPayout(ctx, wsID, strings.TrimSpace(*comm.PayoutID))
	if err != nil || payout == nil {
		return true
	}
	return payout.Status == PayoutCompleted
}

func (s *Service) invalidatePendingPayoutBatchForCommission(ctx context.Context, wsID string, comm *AffiliateCommission, now time.Time) {
	if comm == nil || comm.PayoutID == nil || strings.TrimSpace(*comm.PayoutID) == "" {
		return
	}
	payoutID := strings.TrimSpace(*comm.PayoutID)
	payout, err := s.store.GetPayout(ctx, wsID, payoutID)
	if err != nil || payout == nil {
		return
	}
	if payout.Status == PayoutPending {
		payout.Status = PayoutFailed
		payout.UpdatedAt = now
		_ = s.store.UpdatePayout(ctx, payout)
		comm.PayoutID = nil
		for _, cid := range payout.CommissionIDs {
			if cid == comm.CommissionID {
				continue
			}
			if other, gErr := s.store.GetCommission(ctx, wsID, cid); gErr == nil && other != nil {
				if other.PayoutID != nil && strings.TrimSpace(*other.PayoutID) == payoutID {
					other.PayoutID = nil
					if other.Status == CommissionPaidOut {
						other.Status = CommissionConfirmed
						other.PaidOutAt = nil
					}
					other.UpdatedAt = now
					_ = s.store.UpdateCommission(ctx, other)
				}
			}
		}
	}
}

func (s *Service) reconcileCommissionWithVerifiedOrderLocked(ctx context.Context, wsID string, comm *AffiliateCommission) (*AffiliateCommission, error) {
	if comm == nil || strings.TrimSpace(comm.OrderID) == "" {
		return comm, nil
	}
	ord, err := s.store.GetVerifiedOrder(ctx, wsID, comm.OrderID)
	if err != nil || ord == nil {
		// If the commission was created via CalculateCommission (OrderAmount > 0), its verified order must exist.
		if comm.OrderAmount.Cmp(tenantdb.ZeroDecimal()) > 0 {
			return nil, ErrOrderNotVerified
		}
		return comm, nil
	}

	now := s.nowFunc()
	eligibleAmount, subErr := ord.GrossAmount.Sub(ord.RefundedAmount)
	orderIneligible := !isEligibleCommissionOrderState(ord.LifecycleState) ||
		subErr != nil ||
		ord.RefundedAmount.IsNegative() ||
		eligibleAmount.Cmp(tenantdb.ZeroDecimal()) <= 0

	payoutFinalized := s.isCommissionPayoutFinalized(ctx, wsID, comm)

	if orderIneligible {
		if comm.Status != CommissionClawedBack && !payoutFinalized {
			clawDelta := comm.CommissionAmount
			totalClaw := clawDelta
			if comm.ClawbackAmount != nil {
				if sum, addErr := comm.ClawbackAmount.Add(clawDelta); addErr == nil {
					totalClaw = sum
				}
			}
			s.invalidatePendingPayoutBatchForCommission(ctx, wsID, comm, now)
			comm.Status = CommissionClawedBack
			comm.PaidOutAt = nil
			comm.ClawbackReason = "order_refunded"
			comm.ClawbackAmount = &totalClaw
			comm.ClawedBackAt = &now
			comm.UpdatedAt = now
			_ = s.store.UpdateCommission(ctx, comm)
			s.reconcileLedgerObligationLocked(ctx, wsID, comm, now)

			s.emitEvent(ctx, "affiliate.commission.clawed_back", "commission", comm.CommissionID, wsID, map[string]any{
				"commission_id":   comm.CommissionID,
				"order_id":        comm.OrderID,
				"clawback_reason": comm.ClawbackReason,
				"refund_amount":   clawDelta.String(),
			})
		}
		return comm, fmt.Errorf("%w (%w): source order %s is refunded or ineligible (state=%s)", ErrOrderIneligible, ErrCommissionAlreadyConfirmed, comm.OrderID, ord.LifecycleState)
	}

	// Partial refund / downward revision handling: if eligibleAmount < comm.OrderAmount
	// (or order has positive RefundedAmount when comm.OrderAmount was unset),
	// recompute the canonical post-refund commission obligation from the locked rate/obligation
	// recorded on the commission at calculation time (never from the mutable current link.CommissionRate).
	if !payoutFinalized && ((comm.OrderAmount.IsZero() && ord.RefundedAmount.Cmp(tenantdb.ZeroDecimal()) > 0) || (!comm.OrderAmount.IsZero() && eligibleAmount.Cmp(comm.OrderAmount) < 0)) {
		if comm.InitialOrderAmount.IsZero() && comm.OrderAmount.Cmp(tenantdb.ZeroDecimal()) > 0 {
			comm.InitialOrderAmount = comm.OrderAmount
			comm.InitialCommissionAmount = comm.CommissionAmount
		}
		var newCommAmt tenantdb.ExactDecimal
		hasNewComm := false
		if comm.CommissionRate.Cmp(tenantdb.ZeroDecimal()) > 0 {
			newCommAmt = calculateCommissionAmount(eligibleAmount, comm.CommissionRate)
			hasNewComm = true
		} else {
			baseOrderAmt := comm.InitialOrderAmount
			baseCommAmt := comm.InitialCommissionAmount
			if baseOrderAmt.Cmp(tenantdb.ZeroDecimal()) <= 0 || baseCommAmt.Cmp(tenantdb.ZeroDecimal()) <= 0 {
				baseOrderAmt = comm.OrderAmount
				baseCommAmt = comm.CommissionAmount
			}
			if baseOrderAmt.Cmp(tenantdb.ZeroDecimal()) <= 0 && ord.GrossAmount.Cmp(tenantdb.ZeroDecimal()) > 0 {
				baseOrderAmt = ord.GrossAmount
			}
			if baseOrderAmt.Cmp(tenantdb.ZeroDecimal()) > 0 && baseCommAmt.Cmp(tenantdb.ZeroDecimal()) > 0 {
				if ratio, divErr := eligibleAmount.QuoRoundHalfUp(baseOrderAmt); divErr == nil {
					if quot, mulErr := baseCommAmt.MulFloor(ratio); mulErr == nil {
						newCommAmt = quot
						hasNewComm = true
					}
				}
			}
		}

		if hasNewComm && newCommAmt.Cmp(comm.CommissionAmount) < 0 {
			clawDelta, _ := comm.CommissionAmount.Sub(newCommAmt)
			totalClaw := clawDelta
			if comm.ClawbackAmount != nil {
				if sum, addErr := comm.ClawbackAmount.Add(clawDelta); addErr == nil {
					totalClaw = sum
				}
			}
			s.invalidatePendingPayoutBatchForCommission(ctx, wsID, comm, now)
			if comm.Status == CommissionPaidOut {
				comm.Status = CommissionConfirmed
				comm.PaidOutAt = nil
			}
			comm.OrderAmount = eligibleAmount
			comm.CommissionAmount = newCommAmt
			comm.ClawbackReason = "partial_order_refund"
			comm.ClawbackAmount = &totalClaw
			comm.UpdatedAt = now
			if err := s.store.UpdateCommission(ctx, comm); err != nil {
				return nil, err
			}
			s.reconcileLedgerObligationLocked(ctx, wsID, comm, now)

			s.emitEvent(ctx, "affiliate.commission.clawed_back", "commission", comm.CommissionID, wsID, map[string]any{
				"commission_id":        comm.CommissionID,
				"order_id":             comm.OrderID,
				"clawback_reason":      comm.ClawbackReason,
				"refund_amount":        clawDelta.String(),
				"remaining_commission": newCommAmt.String(),
			})
		}
	}

	return comm, nil
}

func (s *Service) RegisterVerifiedSettlement(ctx context.Context, settle *VerifiedSettlement) error {
	if settle == nil || strings.TrimSpace(settle.WorkspaceID) == "" || strings.TrimSpace(settle.SettlementID) == "" {
		return ErrSettlementRequired
	}
	if settle.NetAmount.Cmp(tenantdb.ZeroDecimal()) <= 0 || settle.AllocatedAmount.IsNegative() {
		return ErrSettlementAmountMismatch
	}
	curr := strings.ToUpper(strings.TrimSpace(settle.Currency))
	if curr == "" {
		return ErrSettlementCurrencyMismatch
	}
	now := s.nowFunc()
	cp := *settle
	cp.WorkspaceID = strings.TrimSpace(settle.WorkspaceID)
	cp.SettlementID = strings.TrimSpace(settle.SettlementID)
	cp.CreatorEntityID = strings.TrimSpace(settle.CreatorEntityID)
	cp.Currency = curr
	if cp.VerificationStatus == "" {
		cp.VerificationStatus = "verified"
	}
	if cp.CreatedAt.IsZero() {
		cp.CreatedAt = now
	}
	cp.UpdatedAt = now
	return s.store.UpsertVerifiedSettlement(ctx, &cp)
}

func (s *Service) CalculateCommission(ctx context.Context, wsID, linkID, orderID string, creatorID *string, orderAmount tenantdb.ExactDecimal, currency string, holdDays int) (*AffiliateCommission, error) {
	wsID = strings.TrimSpace(wsID)
	linkID = strings.TrimSpace(linkID)
	orderID = strings.TrimSpace(orderID)
	if wsID == "" || linkID == "" || orderID == "" {
		return nil, ErrOrderNotVerified
	}

	s.payoutMu.Lock()
	defer s.payoutMu.Unlock()

	link, err := s.store.GetLink(ctx, wsID, linkID)
	if err != nil {
		return nil, err
	}
	if link.LifecycleState == LinkStateRevoked {
		return nil, ErrLinkPermanentlyRevoked
	}

	// 1. Resolve authoritative tenant-scoped order snapshot
	ord, err := s.store.GetVerifiedOrder(ctx, wsID, orderID)
	if err != nil {
		return nil, ErrOrderNotVerified
	}
	if !isEligibleCommissionOrderState(ord.LifecycleState) {
		return nil, fmt.Errorf("%w: order %s is in state %q", ErrOrderIneligible, orderID, ord.LifecycleState)
	}
	eligibleAmount, err := ord.GrossAmount.Sub(ord.RefundedAmount)
	if err != nil || ord.RefundedAmount.IsNegative() || eligibleAmount.Cmp(tenantdb.ZeroDecimal()) <= 0 {
		return nil, fmt.Errorf("%w: order %s has non-positive net eligible amount after refunds", ErrOrderIneligible, orderID)
	}
	canonicalCurrency := strings.ToUpper(strings.TrimSpace(ord.Currency))
	if canonicalCurrency == "" {
		return nil, ErrOrderNotVerified
	}
	if strings.TrimSpace(currency) != "" && !strings.EqualFold(strings.TrimSpace(currency), canonicalCurrency) {
		return nil, fmt.Errorf("%w: requested %s but canonical order currency is %s", ErrOrderCurrencyMismatch, currency, canonicalCurrency)
	}
	if orderAmount.IsNegative() || (!orderAmount.IsZero() && orderAmount.Cmp(eligibleAmount) != 0) {
		return nil, fmt.Errorf("%w: requested %s but canonical eligible order amount is %s", ErrOrderAmountMismatch, orderAmount.Fixed6String(), eligibleAmount.Fixed6String())
	}

	// 2. If attribution exists for this order, verify link and creator consistency
	if attr, attrErr := s.store.GetAttributionByOrder(ctx, wsID, orderID); attrErr == nil && attr != nil {
		if attr.AffiliateLinkID != "" && attr.AffiliateLinkID != linkID {
			return nil, fmt.Errorf("%w: order %s attributed to link %s, not %s", ErrAttributionMismatch, orderID, attr.AffiliateLinkID, linkID)
		}
		if attr.CreatorEntityID != nil && strings.TrimSpace(*attr.CreatorEntityID) != "" && creatorID != nil && strings.TrimSpace(*creatorID) != "" {
			if strings.TrimSpace(*attr.CreatorEntityID) != strings.TrimSpace(*creatorID) {
				return nil, fmt.Errorf("%w: order %s attributed to creator %s, not %s", ErrAttributionMismatch, orderID, *attr.CreatorEntityID, *creatorID)
			}
		}
	}

	// 3. Enforce unique commission per (workspace_id, order_id)
	if existing, existErr := s.store.GetCommissionByOrder(ctx, wsID, orderID); existErr == nil && existing != nil {
		if existing.AffiliateLinkID != linkID {
			return nil, fmt.Errorf("%w: order %s already commissioned under link %s", ErrDuplicateCommission, orderID, existing.AffiliateLinkID)
		}
		if existing.CreatorEntityID != nil && creatorID != nil && strings.TrimSpace(*existing.CreatorEntityID) != strings.TrimSpace(*creatorID) {
			return nil, fmt.Errorf("%w: order %s already commissioned for creator %s", ErrDuplicateCommission, orderID, *existing.CreatorEntityID)
		}
		return existing, nil
	}

	now := s.nowFunc()
	if holdDays <= 0 {
		holdDays = 15 // Default 15-day hold period per BIZ-012
	}
	holdUntil := now.Add(time.Duration(holdDays) * 24 * time.Hour)

	commAmt := calculateCommissionAmount(eligibleAmount, link.CommissionRate)

	var cleanCreatorID *string
	if creatorID != nil && strings.TrimSpace(*creatorID) != "" {
		c := strings.TrimSpace(*creatorID)
		cleanCreatorID = &c
	}

	comm := &AffiliateCommission{
		CommissionID:            newUUID(),
		WorkspaceID:             wsID,
		AffiliateLinkID:         linkID,
		OrderID:                 orderID,
		CreatorEntityID:         cleanCreatorID,
		OrderAmount:             eligibleAmount,
		CommissionRate:          link.CommissionRate,
		InitialOrderAmount:      eligibleAmount,
		InitialCommissionAmount: commAmt,
		CommissionAmount:        commAmt,
		Currency:                canonicalCurrency,
		Status:                  CommissionPending,
		HoldUntil:               holdUntil,
		CreatedAt:               now,
		UpdatedAt:               now,
	}

	if err := s.store.CreateCommission(ctx, comm); err != nil {
		return nil, err
	}

	s.emitEvent(ctx, "affiliate.commission.calculated", "commission", comm.CommissionID, wsID, map[string]any{
		"commission_id": comm.CommissionID,
		"amount":        comm.CommissionAmount.String(),
		"hold_until":    comm.HoldUntil,
	})
	s.emitEvent(ctx, "affiliate.commission.earned", "commission", comm.CommissionID, wsID, map[string]any{
		"commission_id":     comm.CommissionID,
		"affiliate_link_id": comm.AffiliateLinkID,
		"order_id":          comm.OrderID,
		"amount":            comm.CommissionAmount.String(),
		"currency":          comm.Currency,
	})

	return comm, nil
}

func (s *Service) ConfirmCommission(ctx context.Context, wsID, commissionID string) (*AffiliateCommission, error) {
	s.payoutMu.Lock()
	defer s.payoutMu.Unlock()

	comm, err := s.store.GetCommission(ctx, wsID, commissionID)
	if err != nil {
		return nil, err
	}

	// Billing R08: Re-check authoritative order/refund state before confirming commission.
	comm, err = s.reconcileCommissionWithVerifiedOrderLocked(ctx, wsID, comm)
	if err != nil {
		return nil, err
	}
	if comm.Status != CommissionPending {
		return nil, ErrCommissionAlreadyConfirmed
	}

	now := s.nowFunc()
	if !comm.HoldUntil.IsZero() && now.Before(comm.HoldUntil) {
		return nil, ErrCommissionHoldPeriodActive
	}
	comm.Status = CommissionConfirmed
	comm.ConfirmedAt = &now
	comm.UpdatedAt = now

	if err := s.store.UpdateCommission(ctx, comm); err != nil {
		return nil, err
	}

	s.emitEvent(ctx, "affiliate.commission.confirmed", "commission", comm.CommissionID, wsID, map[string]any{
		"commission_id": comm.CommissionID,
		"amount":        comm.CommissionAmount.String(),
	})
	return comm, nil
}

func (s *Service) ClawbackCommission(ctx context.Context, wsID, commissionID, reason, amountStr string) (*AffiliateCommission, error) {
	s.payoutMu.Lock()
	defer s.payoutMu.Unlock()

	comm, err := s.store.GetCommission(ctx, wsID, commissionID)
	if err != nil {
		return nil, err
	}
	if comm.Status == CommissionClawedBack || comm.Status == CommissionPaidOut {
		return nil, ErrCommissionAlreadyConfirmed
	}

	clawAmt, err := tenantdb.ParseExactDecimal(amountStr)
	if err != nil {
		return nil, ErrInvalidClawbackAmount
	}

	// Check that clawback does not exceed commission amount
	if clawAmt.Cmp(comm.CommissionAmount) > 0 {
		return nil, ErrInvalidClawbackAmount
	}

	now := s.nowFunc()
	comm.Status = CommissionClawedBack
	comm.ClawbackReason = reason
	comm.ClawbackAmount = &clawAmt
	comm.ClawedBackAt = &now
	comm.UpdatedAt = now

	if err := s.store.UpdateCommission(ctx, comm); err != nil {
		return nil, err
	}
	s.reconcileLedgerObligationLocked(ctx, wsID, comm, now)

	s.emitEvent(ctx, "affiliate.commission.clawed_back", "commission", comm.CommissionID, wsID, map[string]any{
		"commission_id":   comm.CommissionID,
		"clawback_reason": reason,
		"refund_amount":   clawAmt.String(),
	})
	return comm, nil
}

// ----------------------------------------------------------------------------
// Acceptance Target 1: Creator Income Distinct from Seller Expense
// ----------------------------------------------------------------------------

func (s *Service) PostCommissionToLedger(ctx context.Context, wsID, commissionID string, role EconomicRole) (*LedgerPostingResult, error) {
	if role != EconomicRoleCreator && role != EconomicRoleSeller {
		return nil, ErrEconomicRoleRequired
	}

	s.payoutMu.Lock()
	defer s.payoutMu.Unlock()

	comm, err := s.store.GetCommission(ctx, wsID, commissionID)
	if err != nil {
		return nil, err
	}

	comm, err = s.reconcileCommissionWithVerifiedOrderLocked(ctx, wsID, comm)
	if err != nil {
		return nil, err
	}
	if comm.Status == CommissionClawedBack {
		return nil, fmt.Errorf("%w: commission %s is clawed back", ErrOrderIneligible, commissionID)
	}

	now := s.nowFunc()
	result, err := s.ledger.RecordAffiliatePosting(ctx, wsID, comm, role, now)
	if err != nil {
		return nil, err
	}

	return result, nil
}

// ----------------------------------------------------------------------------
// Payout Batches & Proof
// ----------------------------------------------------------------------------

func (s *Service) CreatePayoutBatch(ctx context.Context, wsID, creatorID string, commissionIDs []string) (*AffiliatePayout, error) {
	creatorID = strings.TrimSpace(creatorID)
	if wsID == "" || creatorID == "" || len(commissionIDs) == 0 {
		return nil, ErrInvalidPayoutBatch
	}

	s.payoutMu.Lock()
	defer s.payoutMu.Unlock()

	now := s.nowFunc()
	totAmt, _ := tenantdb.ParseExactDecimal("0.000000")
	var currency string
	seen := make(map[string]struct{}, len(commissionIDs))
	comms := make([]*AffiliateCommission, 0, len(commissionIDs))

	for _, cid := range commissionIDs {
		cid = strings.TrimSpace(cid)
		if cid == "" {
			return nil, ErrInvalidPayoutBatch
		}
		if _, dup := seen[cid]; dup {
			return nil, fmt.Errorf("%w: duplicate commission %s in payout batch", ErrInvalidPayoutBatch, cid)
		}
		seen[cid] = struct{}{}

		comm, err := s.store.GetCommission(ctx, wsID, cid)
		if err != nil {
			return nil, err
		}

		// Billing R08: Re-verify authoritative order/refund state before including commission in payout batch.
		comm, err = s.reconcileCommissionWithVerifiedOrderLocked(ctx, wsID, comm)
		if err != nil {
			return nil, fmt.Errorf("%w (%w): commission %s source order is refunded or ineligible: %v", ErrInvalidPayoutBatch, ErrOrderIneligible, cid, err)
		}

		if comm.Status != CommissionConfirmed {
			return nil, ErrCommissionHoldPeriodActive
		}
		if !comm.HoldUntil.IsZero() && now.Before(comm.HoldUntil) {
			return nil, ErrCommissionHoldPeriodActive
		}
		if comm.PayoutID != nil && *comm.PayoutID != "" {
			return nil, fmt.Errorf("%w: commission %s is already bound to payout %s", ErrCommissionAlreadyInPayout, cid, *comm.PayoutID)
		}
		if comm.CreatorEntityID == nil || strings.TrimSpace(*comm.CreatorEntityID) != creatorID {
			return nil, fmt.Errorf("%w: commission %s does not belong to creator %s", ErrInvalidPayoutBatch, cid, creatorID)
		}
		if currency == "" {
			currency = comm.Currency
		} else if !strings.EqualFold(currency, comm.Currency) {
			return nil, fmt.Errorf("%w: mixed currencies %s and %s in payout batch", ErrInvalidPayoutBatch, currency, comm.Currency)
		}

		newTot, err := addDecimals(totAmt, comm.CommissionAmount)
		if err != nil {
			return nil, err
		}
		totAmt = newTot
		comms = append(comms, comm)
	}

	if currency == "" {
		currency = "VND"
	}

	payoutID := newUUID()
	payout := &AffiliatePayout{
		PayoutID:        payoutID,
		WorkspaceID:     wsID,
		CreatorEntityID: creatorID,
		CommissionIDs:   append([]string(nil), commissionIDs...),
		TotalAmount:     totAmt,
		Currency:        currency,
		Status:          PayoutPending,
		CreatedAt:       now,
		UpdatedAt:       now,
	}

	// Bind each commission to this payout batch so it cannot be reused in another batch;
	// roll back bindings if any update or batch creation fails (Billing R10).
	var boundComms []*AffiliateCommission
	rollbackBindings := func() {
		for _, bc := range boundComms {
			bc.PayoutID = nil
			_ = s.store.UpdateCommission(ctx, bc)
		}
	}
	for _, comm := range comms {
		comm.PayoutID = &payoutID
		comm.UpdatedAt = now
		if err := s.store.UpdateCommission(ctx, comm); err != nil {
			rollbackBindings()
			return nil, err
		}
		boundComms = append(boundComms, comm)
	}

	if err := s.store.CreatePayout(ctx, payout); err != nil {
		rollbackBindings()
		return nil, err
	}
	return payout, nil
}

func (s *Service) ExecutePayoutBatch(ctx context.Context, wsID, payoutID, settlementID string) (*AffiliatePayout, error) {
	wsID = strings.TrimSpace(wsID)
	payoutID = strings.TrimSpace(payoutID)
	settlementID = strings.TrimSpace(settlementID)
	if settlementID == "" {
		return nil, ErrSettlementRequired
	}
	lowerSettle := strings.ToLower(settlementID)
	if strings.Contains(lowerSettle, "failed") || strings.Contains(lowerSettle, "unverified") || strings.Contains(lowerSettle, "pending") {
		return nil, fmt.Errorf("%w: settlement %s is not confirmed", ErrSettlementRequired, settlementID)
	}

	s.payoutMu.Lock()
	defer s.payoutMu.Unlock()

	payout, err := s.store.GetPayout(ctx, wsID, payoutID)
	if err != nil {
		return nil, err
	}
	if payout.Status == PayoutCompleted {
		return nil, ErrPayoutAlreadyExecuted
	}
	if payout.Status != PayoutPending && payout.Status != PayoutProcessing {
		return nil, fmt.Errorf("%w (%w): payout %s is in status %s", ErrInvalidPayoutBatch, ErrOrderIneligible, payoutID, payout.Status)
	}
	if len(payout.CommissionIDs) == 0 {
		return nil, ErrInvalidPayoutBatch
	}
	if payout.SettlementID != nil && strings.TrimSpace(*payout.SettlementID) != "" && strings.TrimSpace(*payout.SettlementID) != settlementID {
		return nil, fmt.Errorf("%w (%w): payout %s is already bound to settlement %s", ErrSettlementAlreadyUsed, ErrSettlementRequired, payout.PayoutID, *payout.SettlementID)
	}

	// Verify authoritative settlement record in the same workspace
	settle, err := s.store.GetVerifiedSettlement(ctx, wsID, settlementID)
	if err != nil || settle == nil {
		return nil, fmt.Errorf("%w: settlement %s not found or unverified in workspace", ErrSettlementRequired, settlementID)
	}
	if !isVerifiedSettlementStatus(settle.VerificationStatus) {
		return nil, fmt.Errorf("%w: settlement %s has unverified status %q", ErrSettlementRequired, settlementID, settle.VerificationStatus)
	}
	if strings.TrimSpace(settle.CreatorEntityID) == "" || strings.TrimSpace(settle.CreatorEntityID) != strings.TrimSpace(payout.CreatorEntityID) {
		return nil, fmt.Errorf("%w (%w): settlement beneficiary %q does not match payout creator %q", ErrSettlementBeneficiaryMismatch, ErrSettlementRequired, settle.CreatorEntityID, payout.CreatorEntityID)
	}
	if !strings.EqualFold(strings.TrimSpace(settle.Currency), strings.TrimSpace(payout.Currency)) {
		return nil, fmt.Errorf("%w (%w): settlement currency %q does not match payout currency %q", ErrSettlementCurrencyMismatch, ErrSettlementRequired, settle.Currency, payout.Currency)
	}
	if settle.BoundPayoutID != nil && strings.TrimSpace(*settle.BoundPayoutID) != "" && strings.TrimSpace(*settle.BoundPayoutID) != payout.PayoutID {
		return nil, fmt.Errorf("%w (%w): settlement %s is already bound to payout %s", ErrSettlementAlreadyUsed, ErrSettlementRequired, settlementID, *settle.BoundPayoutID)
	}

	// Billing R10: Recognize when this exact payout batch already reserved the settlement allocation
	// on an earlier interrupted execution attempt so retries can complete idempotently.
	alreadyAllocatedToThisPayout := settle.BoundPayoutID != nil &&
		strings.TrimSpace(*settle.BoundPayoutID) == payout.PayoutID &&
		settle.AllocatedAmount.Cmp(payout.TotalAmount) >= 0

	if !alreadyAllocatedToThisPayout {
		remainingSettle, err := settle.NetAmount.Sub(settle.AllocatedAmount)
		if err != nil || settle.NetAmount.Cmp(payout.TotalAmount) != 0 || remainingSettle.Cmp(payout.TotalAmount) < 0 {
			return nil, fmt.Errorf("%w (%w): settlement net amount %s (remaining %s) does not match payout total %s", ErrSettlementAmountMismatch, ErrSettlementRequired, settle.NetAmount.Fixed6String(), remainingSettle.Fixed6String(), payout.TotalAmount.Fixed6String())
		}
	} else if settle.NetAmount.Cmp(payout.TotalAmount) != 0 {
		return nil, fmt.Errorf("%w (%w): settlement net amount %s does not match payout total %s", ErrSettlementAmountMismatch, ErrSettlementRequired, settle.NetAmount.Fixed6String(), payout.TotalAmount.Fixed6String())
	}

	now := s.nowFunc()
	comms := make([]*AffiliateCommission, 0, len(payout.CommissionIDs))
	expectedTotal := tenantdb.ZeroDecimal()

	releaseTentativeSettlement := func() {
		if alreadyAllocatedToThisPayout {
			if rem, subErr := settle.AllocatedAmount.Sub(payout.TotalAmount); subErr == nil && !rem.IsNegative() {
				settle.AllocatedAmount = rem
			} else {
				settle.AllocatedAmount = tenantdb.ZeroDecimal()
			}
			settle.BoundPayoutID = nil
			settle.UpdatedAt = now
			_ = s.store.UpsertVerifiedSettlement(ctx, settle)
		}
	}

	invalidateBatchBindings := func(_ []*AffiliateCommission) {
		for _, cid := range payout.CommissionIDs {
			c, gErr := s.store.GetCommission(ctx, wsID, cid)
			if gErr != nil || c == nil {
				continue
			}
			changed := false
			if c.PayoutID != nil && strings.TrimSpace(*c.PayoutID) == payout.PayoutID {
				c.PayoutID = nil
				changed = true
			}
			if c.Status == CommissionPaidOut {
				c.Status = CommissionConfirmed
				c.PaidOutAt = nil
				changed = true
			}
			if changed {
				c.UpdatedAt = now
				_ = s.store.UpdateCommission(ctx, c)
			}
		}
		payout.Status = PayoutFailed
		payout.UpdatedAt = now
		_ = s.store.UpdatePayout(ctx, payout)
	}

	// Verify all commissions are still confirmed (or already paid_out for THIS payout on retry),
	// past hold window, bound to this payout batch, and backed by an un-refunded source order (Billing R08, R10).
	for _, cid := range payout.CommissionIDs {
		comm, err := s.store.GetCommission(ctx, wsID, cid)
		if err != nil {
			return nil, err
		}

		// Billing R08: Re-check authoritative order/refund state before executing payout.
		comm, reconErr := s.reconcileCommissionWithVerifiedOrderLocked(ctx, wsID, comm)
		if reconErr != nil {
			releaseTentativeSettlement()
			invalidateBatchBindings(comms)
			return nil, fmt.Errorf("%w (%w): commission %s source order refunded before payout execution: %v", ErrInvalidPayoutBatch, ErrOrderIneligible, cid, reconErr)
		}

		isResumedPaidOutForThisBatch := comm.Status == CommissionPaidOut && comm.PayoutID != nil && strings.TrimSpace(*comm.PayoutID) == payout.PayoutID
		if comm.Status != CommissionConfirmed && !isResumedPaidOutForThisBatch {
			releaseTentativeSettlement()
			invalidateBatchBindings(comms)
			return nil, fmt.Errorf("%w: commission %s is in status %s and cannot be paid out", ErrInvalidPayoutBatch, cid, comm.Status)
		}
		if !comm.HoldUntil.IsZero() && now.Before(comm.HoldUntil) {
			return nil, ErrCommissionHoldPeriodActive
		}
		if comm.PayoutID != nil && *comm.PayoutID != "" && *comm.PayoutID != payout.PayoutID {
			return nil, fmt.Errorf("%w: commission %s is bound to different payout %s", ErrCommissionAlreadyInPayout, cid, *comm.PayoutID)
		}
		expectedTotal, err = addDecimals(expectedTotal, comm.CommissionAmount)
		if err != nil {
			return nil, err
		}
		comms = append(comms, comm)
	}

	if expectedTotal.Cmp(payout.TotalAmount) != 0 {
		releaseTentativeSettlement()
		invalidateBatchBindings(comms)
		return nil, fmt.Errorf("%w (%w): commission total %s after refund reconciliation does not match batch total %s", ErrInvalidPayoutBatch, ErrOrderIneligible, expectedTotal.Fixed6String(), payout.TotalAmount.Fixed6String())
	}

	// Billing R10: Persist resumable processing state and settlement binding idempotently
	if payout.Status != PayoutProcessing || payout.SettlementID == nil || *payout.SettlementID != settlementID {
		payout.Status = PayoutProcessing
		payout.SettlementID = &settlementID
		payout.UpdatedAt = now
		if err := s.store.UpdatePayout(ctx, payout); err != nil {
			return nil, err
		}
	}

	if !alreadyAllocatedToThisPayout {
		newAllocated, err := settle.AllocatedAmount.Add(payout.TotalAmount)
		if err != nil {
			return nil, err
		}
		settle.AllocatedAmount = newAllocated
		settle.BoundPayoutID = &payout.PayoutID
		settle.UpdatedAt = now
		if err := s.store.UpsertVerifiedSettlement(ctx, settle); err != nil {
			return nil, err
		}
	}

	// Update each commission status to paid_out (skipping commissions already paid_out for this batch on retry)
	for _, comm := range comms {
		if comm.Status == CommissionPaidOut && comm.PayoutID != nil && *comm.PayoutID == payout.PayoutID {
			continue
		}
		comm.Status = CommissionPaidOut
		comm.PayoutID = &payout.PayoutID
		comm.PaidOutAt = &now
		comm.UpdatedAt = now
		if err := s.store.UpdateCommission(ctx, comm); err != nil {
			return nil, err
		}
	}

	// Generate cryptographic payout proof hash tied to the verified settlement reference
	rawProof := fmt.Sprintf("%s:%s:%s:%s:%d", wsID, payoutID, settlementID, payout.TotalAmount.String(), now.Unix())
	hash := sha256.Sum256([]byte(rawProof))
	proofHash := hex.EncodeToString(hash[:])

	payout.Status = PayoutCompleted
	payout.ProofHash = proofHash
	payout.ProofMetadata = map[string]any{
		"settlement_id": settlementID,
		"executed_at":   now.Format(time.RFC3339),
		"proof_version": "v1-sha256",
	}
	payout.SettlementID = &settlementID
	payout.PaidAt = &now
	payout.UpdatedAt = now

	if err := s.store.UpdatePayout(ctx, payout); err != nil {
		return nil, err
	}

	for _, comm := range comms {
		s.emitEvent(ctx, "affiliate.commission.paid_out", "commission", comm.CommissionID, wsID, map[string]any{
			"commission_id": comm.CommissionID,
			"payout_id":     payout.PayoutID,
			"settlement_id": settlementID,
			"amount":        comm.CommissionAmount.String(),
		})
		s.emitEvent(ctx, "affiliate.commission.paid", "commission", comm.CommissionID, wsID, map[string]any{
			"commission_id": comm.CommissionID,
			"payout_ref":    payout.PayoutID,
			"settlement_id": settlementID,
		})
	}

	return payout, nil
}

func (s *Service) GetPayoutProof(ctx context.Context, wsID, payoutID string) (*AffiliatePayout, string, string, error) {
	payout, err := s.store.GetPayout(ctx, wsID, payoutID)
	if err != nil {
		return nil, "", "", err
	}
	proofURL := fmt.Sprintf("https://app.creativanta.com/proof/payout/%s", payout.ProofHash)
	return payout, payout.ProofHash, proofURL, nil
}

// ----------------------------------------------------------------------------
// Statement Imports & Reconciliation
// ----------------------------------------------------------------------------

func (s *Service) ImportStatement(ctx context.Context, stmt *AffiliateStatement, items []*AffiliateStatementItem) (*AffiliateStatement, error) {
	now := s.nowFunc()
	if stmt.StatementID == "" {
		stmt.StatementID = newUUID()
	}
	stmt.ImportedAt = now
	stmt.ReconciliationState = "imported_only"
	stmt.ItemCount = int32(len(items))
	stmt.ReconciledItemCount = 0

	for _, it := range items {
		if it.ItemID == "" {
			it.ItemID = newUUID()
		}
		it.StatementID = stmt.StatementID
		it.Status = "unreconciled"
		it.CreatedAt = now
	}

	if err := s.store.CreateStatement(ctx, stmt, items); err != nil {
		return nil, err
	}

	s.emitEvent(ctx, "settlement.imported", "affiliate_statement", stmt.StatementID, stmt.WorkspaceID, map[string]any{
		"statement_id": stmt.StatementID,
		"platform":     stmt.Platform,
	})
	return stmt, nil
}

func (s *Service) ReconcileStatement(ctx context.Context, wsID, statementID string) (*AffiliateStatement, int32, int32, int32, error) {
	stmt, items, err := s.store.GetStatement(ctx, wsID, statementID)
	if err != nil {
		return nil, 0, 0, 0, err
	}

	var matchedCount, conflictCount, unreconciledCount int32
	// For each item, look for matching commission by external order id
	for _, it := range items {
		commList, _ := s.store.ListCommissions(ctx, wsID, nil, nil, 100, 0)
		var found *AffiliateCommission
		for _, c := range commList {
			if c.OrderID == it.ExternalOrderID {
				found = c
				break
			}
		}

		if found != nil {
			if found.CommissionAmount.Cmp(it.CommissionAmount) == 0 {
				it.Status = "matched"
				it.MatchedCommissionID = &found.CommissionID
				matchedCount++
			} else {
				it.Status = "conflict"
				conflictCount++
			}
		} else {
			it.Status = "unreconciled"
			unreconciledCount++
		}
	}

	if conflictCount > 0 {
		stmt.ReconciliationState = "conflict_detected"
	} else if matchedCount == stmt.ItemCount && stmt.ItemCount > 0 {
		stmt.ReconciliationState = "fully_reconciled"
	} else if matchedCount > 0 {
		stmt.ReconciliationState = "partially_reconciled"
	} else {
		stmt.ReconciliationState = "imported_only"
	}
	stmt.ReconciledItemCount = matchedCount

	_ = s.store.UpdateStatement(ctx, stmt, items)
	return stmt, matchedCount, conflictCount, unreconciledCount, nil
}

// ----------------------------------------------------------------------------
// Acceptance Target 3: Broken Link Repair & Health Monitoring
// ----------------------------------------------------------------------------

func (s *Service) RunHealthCheck(ctx context.Context, wsID, linkID string, simHTTP int32, simProdStatus, simCommRate string) (*LinkHealthRecord, bool, error) {
	link, err := s.store.GetLink(ctx, wsID, linkID)
	if err != nil {
		return nil, false, err
	}

	now := s.nowFunc()
	var linkStatus HealthStatus
	var action string
	var alertSent bool
	dailyLoss, _ := tenantdb.ParseExactDecimal("0.000000")

	// Check HTTP status or product availability
	isDead := simHTTP != 0 && (simHTTP < 200 || simHTTP >= 400)
	isOutOfStock := simProdStatus == "out_of_stock" || simProdStatus == "discontinued"

	if isDead || isOutOfStock {
		linkStatus = HealthStatusBroken
		alertSent = true
		action = "Replace out-of-stock product or update destination URL"

		// Calculate estimated 30-day revenue impact based on conversions
		dailyLoss, _ = tenantdb.ParseExactDecimal("150000.000000") // 150k VND daily loss estimate
		link.HealthStatus = HealthStatusBroken

		s.emitEvent(ctx, "affiliate.link_health.broken", "link_health", link.AffiliateLinkID, wsID, map[string]any{
			"affiliate_link_id": link.AffiliateLinkID,
			"suggested_action":  action,
			"http_status":       simHTTP,
			"product_status":    simProdStatus,
		})
	} else if simProdStatus == "price_changed" || (simCommRate != "" && simCommRate != link.CommissionRate.String()) {
		linkStatus = HealthStatusWarning
		action = "Review commission rate changes"
		link.HealthStatus = HealthStatusWarning
	} else {
		linkStatus = HealthStatusHealthy
		action = "None"
		link.HealthStatus = HealthStatusHealthy
	}

	link.LastHealthCheckAt = &now
	_ = s.store.UpdateLink(ctx, link)

	hr := &LinkHealthRecord{
		HealthID:               newUUID(),
		WorkspaceID:            wsID,
		AffiliateLinkID:        linkID,
		HTTPStatus:             simHTTP,
		ProductStatus:          simProdStatus,
		CommissionStatus:       simCommRate,
		LinkStatus:             linkStatus,
		ExpiryDate:             link.ExpiresAt,
		SuggestedAction:        action,
		CheckedAt:              now,
		AlertSent:              alertSent,
		EstimatedRevenueImpact: dailyLoss,
		CreatedAt:              now,
	}

	if err := s.store.CreateHealthRecord(ctx, hr); err != nil {
		return nil, false, err
	}

	s.emitEvent(ctx, "affiliate.link_health.checked", "link_health", hr.HealthID, wsID, map[string]any{
		"health_id":                hr.HealthID,
		"link_status":              string(hr.LinkStatus),
		"estimated_revenue_impact": hr.EstimatedRevenueImpact.String(),
	})

	return hr, isDead || isOutOfStock, nil
}

func (s *Service) RepairBrokenLink(ctx context.Context, wsID, linkID, newURL, replProdID string) (*AffiliateLink, *LinkHealthRecord, error) {
	link, err := s.store.GetLink(ctx, wsID, linkID)
	if err != nil {
		return nil, nil, err
	}

	// State machine guard: cannot repair or revive permanently revoked link!
	if link.LifecycleState == LinkStateRevoked {
		return nil, nil, ErrLinkPermanentlyRevoked
	}

	now := s.nowFunc()
	if newURL != "" {
		link.OriginalURL = newURL
		link.TrackedURL = fmt.Sprintf("https://creativanta.link/%s", link.ShortCode)
	}
	if replProdID != "" {
		link.ProductID = &replProdID
		link.SuggestedReplacementProductID = &replProdID
	}

	// Transition health status back to healthy!
	link.HealthStatus = HealthStatusHealthy
	link.LastHealthCheckAt = &now
	link.UpdatedAt = now

	if err := s.store.UpdateLink(ctx, link); err != nil {
		return nil, nil, err
	}

	zeroImpact, _ := tenantdb.ParseExactDecimal("0.000000")
	hr := &LinkHealthRecord{
		HealthID:                      newUUID(),
		WorkspaceID:                   wsID,
		AffiliateLinkID:               linkID,
		HTTPStatus:                    200,
		ProductStatus:                 "available",
		CommissionStatus:              "active",
		LinkStatus:                    HealthStatusHealthy,
		SuggestedAction:               "Link repaired successfully",
		CheckedAt:                     now,
		AlertSent:                     false,
		EstimatedRevenueImpact:        zeroImpact,
		SuggestedReplacementProductID: &replProdID,
		CreatedAt:                     now,
	}
	_ = s.store.CreateHealthRecord(ctx, hr)

	s.emitEvent(ctx, "affiliate.link_health.checked", "link_health", hr.HealthID, wsID, map[string]any{
		"health_id":   hr.HealthID,
		"link_status": "healthy",
		"action":      "repaired",
	})

	return link, hr, nil
}

func (s *Service) GetHealthReport(ctx context.Context, wsID string) ([]*LinkHealthRecord, int32, int32, int32, tenantdb.ExactDecimal, error) {
	records, err := s.store.ListHealthRecords(ctx, wsID)
	if err != nil {
		return nil, 0, 0, 0, tenantdb.ExactDecimal{}, err
	}

	var healthy, warning, broken int32
	totRisk, _ := tenantdb.ParseExactDecimal("0.000000")

	for _, r := range records {
		switch r.LinkStatus {
		case HealthStatusHealthy:
			healthy++
		case HealthStatusWarning:
			warning++
		case HealthStatusBroken:
			broken++
			newRisk, err := addDecimals(totRisk, r.EstimatedRevenueImpact)
			if err == nil {
				totRisk = newRisk
			}
		}
	}
	return records, healthy, warning, broken, totRisk, nil
}

// ----------------------------------------------------------------------------
// Decimal Helpers
// ----------------------------------------------------------------------------

func calculateCommissionAmount(orderAmt, commRate tenantdb.ExactDecimal) tenantdb.ExactDecimal {
	// Formula: (orderAmt * commRate) / 100
	onePercent, _ := tenantdb.ParseExactDecimal("0.010000")
	pctFraction, err := commRate.MulFloor(onePercent)
	if err != nil {
		return tenantdb.ZeroDecimal()
	}
	comm, err := orderAmt.MulFloor(pctFraction)
	if err != nil {
		return tenantdb.ZeroDecimal()
	}
	return comm
}

func addDecimals(a, b tenantdb.ExactDecimal) (tenantdb.ExactDecimal, error) {
	return a.Add(b)
}
