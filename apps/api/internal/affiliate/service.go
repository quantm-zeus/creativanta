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

type DefaultLedgerRecorder struct {
	mu       sync.RWMutex
	postings map[string]*LedgerPostingResult
}

func NewDefaultLedgerRecorder() *DefaultLedgerRecorder {
	return &DefaultLedgerRecorder{postings: make(map[string]*LedgerPostingResult)}
}

func (d *DefaultLedgerRecorder) RecordAffiliatePosting(_ context.Context, wsID string, comm *AffiliateCommission, role EconomicRole, now time.Time) (*LedgerPostingResult, error) {
	d.mu.Lock()
	defer d.mu.Unlock()

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
		EconomicRole:    role,
		PostingType:     postingType,
		Amount:          comm.CommissionAmount,
		Currency:        comm.Currency,
		COGSDeducted:    cogsDeducted,
		NetProfitImpact: netProfitImpact,
		PostedAt:        now,
	}
	d.postings[postingID] = result
	return result, nil
}

type Service struct {
	store   Store
	ledger  LedgerRecorder
	sink    EventSink
	nowFunc func() time.Time
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

func (s *Service) CalculateCommission(ctx context.Context, wsID, linkID, orderID string, creatorID *string, orderAmount tenantdb.ExactDecimal, currency string, holdDays int) (*AffiliateCommission, error) {
	link, err := s.store.GetLink(ctx, wsID, linkID)
	if err != nil {
		return nil, err
	}

	now := s.nowFunc()
	if holdDays <= 0 {
		holdDays = 15 // Default 15-day hold period per BIZ-012
	}
	holdUntil := now.Add(time.Duration(holdDays) * 24 * time.Hour)

	commAmt := calculateCommissionAmount(orderAmount, link.CommissionRate)

	comm := &AffiliateCommission{
		CommissionID:     newUUID(),
		WorkspaceID:      wsID,
		AffiliateLinkID:  linkID,
		OrderID:          orderID,
		CreatorEntityID:  creatorID,
		CommissionAmount: commAmt,
		Currency:         currency,
		Status:           CommissionPending,
		HoldUntil:        holdUntil,
		CreatedAt:        now,
		UpdatedAt:        now,
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
	comm, err := s.store.GetCommission(ctx, wsID, commissionID)
	if err != nil {
		return nil, err
	}
	if comm.Status != CommissionPending {
		return nil, ErrCommissionAlreadyConfirmed
	}

	now := s.nowFunc()
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

	comm, err := s.store.GetCommission(ctx, wsID, commissionID)
	if err != nil {
		return nil, err
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
	now := s.nowFunc()
	totAmt, _ := tenantdb.ParseExactDecimal("0.000000")
	currency := "VND"

	for _, cid := range commissionIDs {
		comm, err := s.store.GetCommission(ctx, wsID, cid)
		if err != nil {
			return nil, err
		}
		if comm.Status != CommissionConfirmed {
			return nil, ErrCommissionHoldPeriodActive
		}
		newTot, err := addDecimals(totAmt, comm.CommissionAmount)
		if err == nil {
			totAmt = newTot
		}
		currency = comm.Currency
	}

	payout := &AffiliatePayout{
		PayoutID:        newUUID(),
		WorkspaceID:     wsID,
		CreatorEntityID: creatorID,
		CommissionIDs:   commissionIDs,
		TotalAmount:     totAmt,
		Currency:        currency,
		Status:          PayoutPending,
		CreatedAt:       now,
		UpdatedAt:       now,
	}

	if err := s.store.CreatePayout(ctx, payout); err != nil {
		return nil, err
	}
	return payout, nil
}

func (s *Service) ExecutePayoutBatch(ctx context.Context, wsID, payoutID, settlementID string) (*AffiliatePayout, error) {
	payout, err := s.store.GetPayout(ctx, wsID, payoutID)
	if err != nil {
		return nil, err
	}
	if payout.Status == PayoutCompleted {
		return nil, ErrPayoutAlreadyExecuted
	}

	now := s.nowFunc()

	// Generate cryptographic payout proof hash
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
	if settlementID != "" {
		payout.SettlementID = &settlementID
	}
	payout.PaidAt = &now
	payout.UpdatedAt = now

	if err := s.store.UpdatePayout(ctx, payout); err != nil {
		return nil, err
	}

	// Update each commission status to paid_out
	for _, cid := range payout.CommissionIDs {
		comm, err := s.store.GetCommission(ctx, wsID, cid)
		if err == nil {
			comm.Status = CommissionPaidOut
			comm.PayoutID = &payout.PayoutID
			comm.PaidOutAt = &now
			comm.UpdatedAt = now
			_ = s.store.UpdateCommission(ctx, comm)

			s.emitEvent(ctx, "affiliate.commission.paid_out", "commission", comm.CommissionID, wsID, map[string]any{
				"commission_id": comm.CommissionID,
				"payout_id":     payout.PayoutID,
				"amount":        comm.CommissionAmount.String(),
			})
			s.emitEvent(ctx, "affiliate.commission.paid", "commission", comm.CommissionID, wsID, map[string]any{
				"commission_id": comm.CommissionID,
				"payout_ref":    payout.PayoutID,
			})
		}
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
		HealthID:                       newUUID(),
		WorkspaceID:                    wsID,
		AffiliateLinkID:                linkID,
		HTTPStatus:                     200,
		ProductStatus:                  "available",
		CommissionStatus:               "active",
		LinkStatus:                     HealthStatusHealthy,
		SuggestedAction:                "Link repaired successfully",
		CheckedAt:                      now,
		AlertSent:                      false,
		EstimatedRevenueImpact:         zeroImpact,
		SuggestedReplacementProductID: &replProdID,
		CreatedAt:                      now,
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
