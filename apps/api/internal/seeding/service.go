package seeding

import (
	"context"
	"fmt"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

func mulExactByInt(dec tenantdb.ExactDecimal, qty int32) tenantdb.ExactDecimal {
	if qty <= 0 || dec.IsZero() {
		return tenantdb.ZeroDecimal()
	}
	qtyDec, err := tenantdb.ParseExactDecimal(fmt.Sprintf("%d.000000", qty))
	if err != nil {
		return tenantdb.ZeroDecimal()
	}
	res, err := dec.MulFloor(qtyDec)
	if err != nil {
		return tenantdb.ZeroDecimal()
	}
	return res
}

func toFloat(d tenantdb.ExactDecimal) float64 {
	f, _ := strconv.ParseFloat(d.String(), 64)
	return f
}

type EventPublisher interface {
	Publish(ctx context.Context, eventType string, payload any) error
}

type NoopPublisher struct{}

func (n *NoopPublisher) Publish(ctx context.Context, eventType string, payload any) error {
	return nil
}

type Service struct {
	store     Store
	publisher EventPublisher

	idempotencyMu sync.Mutex
	idempotency   map[string]any // key -> response
}

func NewService(store Store, publisher EventPublisher) *Service {
	if publisher == nil {
		publisher = &NoopPublisher{}
	}
	return &Service{
		store:       store,
		publisher:   publisher,
		idempotency: make(map[string]any),
	}
}

// CreateSample creates a new sample request with separate lifecycle, outcome, and follow-up states.
func (s *Service) CreateSample(ctx context.Context, req *SampleRequest, idempotencyKey string) (*SampleRequest, bool, error) {
	if req.WorkspaceID == "" {
		return nil, false, fmt.Errorf("seeding: workspace_id required")
	}
	if req.ProductID == "" {
		return nil, false, ErrProductNotFound
	}
	if req.CreatorEntityID == "" {
		return nil, false, ErrCreatorEntityNotFound
	}
	if req.Quantity <= 0 {
		return nil, false, ErrQuantityNonPositive
	}

	if idempotencyKey != "" {
		s.idempotencyMu.Lock()
		if prev, exists := s.idempotency[idempotencyKey]; exists {
			s.idempotencyMu.Unlock()
			if cached, ok := prev.(*SampleRequest); ok {
				return cached, true, nil
			}
		}
		s.idempotencyMu.Unlock()
	}

	// Check for duplicate pending requests (EC-M18-004)
	isDuplicate, _ := s.store.CheckDuplicateRequest(ctx, req.WorkspaceID, req.CreatorEntityID, req.ProductID)

	if req.RequestID == "" {
		req.RequestID = newUUID()
	}
	// Target 1: Initialize states separately
	req.Status = RequestStatusRequested
	req.OutcomeStatus = OutcomeStatusPending
	req.FollowUpStatus = FollowUpPending
	now := time.Now().UTC()
	req.CreatedAt = now
	req.UpdatedAt = now

	if err := s.store.CreateRequest(ctx, req); err != nil {
		return nil, false, err
	}

	_ = s.publisher.Publish(ctx, "sample_request.created", map[string]any{
		"request_id":        req.RequestID,
		"campaign_id":       req.CampaignID,
		"product_id":        req.ProductID,
		"creator_entity_id": req.CreatorEntityID,
	})

	created, err := s.store.GetRequest(ctx, req.WorkspaceID, req.RequestID)
	if err != nil {
		return req, isDuplicate, nil
	}

	if idempotencyKey != "" {
		s.idempotencyMu.Lock()
		s.idempotency[idempotencyKey] = created
		s.idempotencyMu.Unlock()
	}

	return created, isDuplicate, nil
}

func (s *Service) GetSample(ctx context.Context, workspaceID, requestID string) (*SampleRequest, error) {
	return s.store.GetRequest(ctx, workspaceID, requestID)
}

func (s *Service) ListSamples(ctx context.Context, workspaceID string, campaignID, productID, creatorID *string, status *SampleRequestStatus, outcomeStatus *SampleOutcomeStatus, followUpStatus *FollowUpStatus, limit, offset int) ([]*SampleRequest, int, map[string]int32, error) {
	items, total, err := s.store.ListRequests(ctx, workspaceID, campaignID, productID, creatorID, status, outcomeStatus, followUpStatus, limit, offset)
	if err != nil {
		return nil, 0, nil, err
	}

	// Compute pipeline summary for UI
	all, _, err := s.store.ListRequests(ctx, workspaceID, campaignID, nil, nil, nil, nil, nil, 10000, 0)
	counts := map[string]int32{
		"requested":        0,
		"approved":         0,
		"shipped":          0,
		"received":         0,
		"review_published": 0,
	}
	if err == nil {
		for _, item := range all {
			switch item.Status {
			case RequestStatusRequested:
				counts["requested"]++
			case RequestStatusApproved:
				counts["approved"]++
			case RequestStatusFulfilled:
				counts["received"]++
			}
			if item.Shipment != nil && item.Shipment.Status == ShipmentStatusShipped {
				counts["shipped"]++
			}
			if item.OutcomeStatus == OutcomeStatusLogged {
				counts["review_published"]++
			}
		}
	}

	return items, total, counts, nil
}

// ApproveSample transitions status to approved, creates provisional M19 cost_item, and ensures replay idempotency (Target 3).
func (s *Service) ApproveSample(ctx context.Context, workspaceID, requestID, actorID, idempotencyKey string) (*SampleRequest, *CostItemSummary, bool, error) {
	req, err := s.store.GetRequest(ctx, workspaceID, requestID)
	if err != nil {
		return nil, nil, false, err
	}

	// Acceptance Target 3: Replay idempotency - no duplicate sample cost
	if idempotencyKey != "" {
		s.idempotencyMu.Lock()
		if prev, ok := s.idempotency[idempotencyKey]; ok {
			s.idempotencyMu.Unlock()
			if cachedResp, ok := prev.(struct {
				Req  *SampleRequest
				Cost *CostItemSummary
			}); ok {
				return cachedResp.Req, cachedResp.Cost, true, nil
			}
		}
		s.idempotencyMu.Unlock()
	}

	// Check if already approved
	if req.Status == RequestStatusApproved || req.Status == RequestStatusFulfilled {
		existingCost, _ := s.store.GetCostItemForRequest(ctx, workspaceID, requestID)
		if existingCost != nil {
			return req, existingCost, true, nil
		}
	}

	if req.Status != RequestStatusRequested {
		return nil, nil, false, fmt.Errorf("%w: cannot approve sample in %s status", ErrInvalidLifecycleTransition, req.Status)
	}

	// Fetch product COGS (M13 integration)
	prod, err := s.store.GetProduct(ctx, workspaceID, req.ProductID)
	var unitCOGS tenantdb.ExactDecimal
	confidenceReason := "Product COGS configured"
	if err == nil && prod != nil {
		unitCOGS = prod.COGS
	}
	if unitCOGS.IsZero() {
		// EC-M18-003: COGS not configured in M13
		confidenceReason = "COGS not configured for product in M13"
	}

	totalCOGS := mulExactByInt(unitCOGS, req.Quantity)

	// Create provisional cost item in M19 ledger per RULE-M18-005
	costItem := &CostItemSummary{
		CostItemID:       newUUID(),
		WorkspaceID:      workspaceID,
		CostType:         "seeding",
		Amount:           totalCOGS,
		Currency:         "VND",
		Description:      fmt.Sprintf("Provisional seeding cost: %d x product %s (%s)", req.Quantity, req.ProductID, confidenceReason),
		RelatedScopeType: "sample_request",
		RelatedScopeID:   req.RequestID,
		SourceClass:      string(SourceClassEstimated),
		CostState:        "recorded",
		EffectiveDate:    time.Now().UTC(),
	}

	if err := s.store.UpsertCostItemForRequest(ctx, costItem); err != nil {
		return nil, nil, false, fmt.Errorf("seeding: failed to record cost item: %w", err)
	}

	req.Status = RequestStatusApproved
	req.UpdatedAt = time.Now().UTC()
	if err := s.store.UpdateRequest(ctx, req); err != nil {
		return nil, nil, false, err
	}

	_ = s.publisher.Publish(ctx, "sample_request.approved", map[string]any{
		"request_id":  req.RequestID,
		"approved_by": actorID,
	})

	updated, err := s.store.GetRequest(ctx, workspaceID, requestID)
	if err != nil {
		updated = req
	}

	if idempotencyKey != "" {
		s.idempotencyMu.Lock()
		s.idempotency[idempotencyKey] = struct {
			Req  *SampleRequest
			Cost *CostItemSummary
		}{Req: updated, Cost: costItem}
		s.idempotencyMu.Unlock()
	}

	return updated, costItem, false, nil
}

// DeclineSample transitions status to declined with mandatory reason per RULE-M18-001.
func (s *Service) DeclineSample(ctx context.Context, workspaceID, requestID, reason string) (*SampleRequest, error) {
	if strings.TrimSpace(reason) == "" {
		return nil, ErrDeclineReasonRequired
	}
	req, err := s.store.GetRequest(ctx, workspaceID, requestID)
	if err != nil {
		return nil, err
	}
	if req.Status != RequestStatusRequested {
		return nil, fmt.Errorf("%w: cannot decline sample in %s status", ErrInvalidLifecycleTransition, req.Status)
	}

	req.Status = RequestStatusDeclined
	req.DeclineReason = &reason
	req.UpdatedAt = time.Now().UTC()
	if err := s.store.UpdateRequest(ctx, req); err != nil {
		return nil, err
	}

	_ = s.publisher.Publish(ctx, "sample_request.declined", map[string]any{
		"request_id": req.RequestID,
		"reason":     reason,
	})

	return s.store.GetRequest(ctx, workspaceID, requestID)
}

func (s *Service) CancelSample(ctx context.Context, workspaceID, requestID, reason string) (*SampleRequest, error) {
	req, err := s.store.GetRequest(ctx, workspaceID, requestID)
	if err != nil {
		return nil, err
	}
	if req.Status == RequestStatusDeclined || req.Status == RequestStatusFulfilled {
		return nil, fmt.Errorf("%w: cannot cancel request in %s status", ErrInvalidLifecycleTransition, req.Status)
	}

	req.Status = RequestStatusCancelled
	req.Notes = req.Notes + " [Cancelled: " + reason + "]"
	req.UpdatedAt = time.Now().UTC()
	if err := s.store.UpdateRequest(ctx, req); err != nil {
		return nil, err
	}

	return s.store.GetRequest(ctx, workspaceID, requestID)
}

// ShipSample creates/updates sample shipment and updates M19 seeding cost without duplicating cost items (Target 3).
func (s *Service) ShipSample(ctx context.Context, workspaceID, requestID, carrier, trackingNumber string, shippingCost tenantdb.ExactDecimal, idempotencyKey string) (*SampleRequest, *SampleShipment, bool, error) {
	if strings.TrimSpace(carrier) == "" || strings.TrimSpace(trackingNumber) == "" {
		return nil, nil, false, ErrMissingCarrierOrTracking
	}

	req, err := s.store.GetRequest(ctx, workspaceID, requestID)
	if err != nil {
		return nil, nil, false, err
	}

	if req.Status != RequestStatusApproved && req.Status != RequestStatusFulfilled {
		return nil, nil, false, fmt.Errorf("%w: request must be approved before shipping", ErrInvalidLifecycleTransition)
	}

	// Target 3: Replay idempotency check
	if idempotencyKey != "" {
		s.idempotencyMu.Lock()
		if prev, ok := s.idempotency[idempotencyKey]; ok {
			s.idempotencyMu.Unlock()
			if cached, ok := prev.(struct {
				Req  *SampleRequest
				Ship *SampleShipment
			}); ok {
				return cached.Req, cached.Ship, true, nil
			}
		}
		s.idempotencyMu.Unlock()
	}

	existingShipment, _ := s.store.GetShipmentByRequest(ctx, workspaceID, requestID)
	now := time.Now().UTC()

	var shipment *SampleShipment
	if existingShipment != nil {
		existingShipment.Carrier = carrier
		existingShipment.TrackingNumber = trackingNumber
		existingShipment.ShippingCost = shippingCost
		existingShipment.Status = ShipmentStatusShipped
		existingShipment.ShippedAt = &now
		if err := s.store.UpdateShipment(ctx, existingShipment); err != nil {
			return nil, nil, false, err
		}
		shipment = existingShipment
	} else {
		shipment = &SampleShipment{
			ShipmentID:     newUUID(),
			RequestID:      requestID,
			WorkspaceID:    workspaceID,
			TrackingNumber: trackingNumber,
			Carrier:        carrier,
			ShippingCost:   shippingCost,
			ShippedAt:      &now,
			Status:         ShipmentStatusShipped,
			CreatedAt:      now,
			UpdatedAt:      now,
		}
		if err := s.store.CreateShipment(ctx, shipment); err != nil {
			return nil, nil, false, err
		}
	}

	// Target 3: Update existing M19 cost item rather than creating duplicate cost item
	costItem, _ := s.store.GetCostItemForRequest(ctx, workspaceID, requestID)
	if costItem != nil {
		// New total = prior COGS + actual shipping cost
		prod, _ := s.store.GetProduct(ctx, workspaceID, req.ProductID)
		var cogs tenantdb.ExactDecimal
		if prod != nil {
			cogs = mulExactByInt(prod.COGS, req.Quantity)
		}
		totalWithShipping, _ := cogs.Add(shippingCost)
		costItem.Amount = totalWithShipping
		costItem.Description = fmt.Sprintf("Seeding cost: %d x product %s + shipping %s", req.Quantity, req.ProductID, shippingCost.Fixed6String())
		costItem.SourceClass = string(SourceClassImported) // actual shipping is imported/recorded
		_ = s.store.UpsertCostItemForRequest(ctx, costItem)
	}

	_ = s.publisher.Publish(ctx, "sample.shipped", map[string]any{
		"shipment_id": shipment.ShipmentID,
		"request_id":  requestID,
		"tracking":    trackingNumber,
	})

	updatedReq, err := s.store.GetRequest(ctx, workspaceID, requestID)
	if err != nil {
		updatedReq = req
	}

	if idempotencyKey != "" {
		s.idempotencyMu.Lock()
		s.idempotency[idempotencyKey] = struct {
			Req  *SampleRequest
			Ship *SampleShipment
		}{Req: updatedReq, Ship: shipment}
		s.idempotencyMu.Unlock()
	}

	return updatedReq, shipment, false, nil
}

// MarkReceived confirms physical delivery of sample.
// Target 1: Request transitions to fulfilled, follow-up starts, outcome remains pending!
func (s *Service) MarkReceived(ctx context.Context, workspaceID, requestID string) (*SampleRequest, *SampleShipment, error) {
	req, err := s.store.GetRequest(ctx, workspaceID, requestID)
	if err != nil {
		return nil, nil, err
	}

	shipment, err := s.store.GetShipmentByRequest(ctx, workspaceID, requestID)
	if err != nil {
		return nil, nil, err
	}

	now := time.Now().UTC()
	shipment.Status = ShipmentStatusDelivered
	shipment.DeliveredAt = &now
	if err := s.store.UpdateShipment(ctx, shipment); err != nil {
		return nil, nil, err
	}

	// Request logistics is fulfilled
	req.Status = RequestStatusFulfilled
	// Post-delivery follow-up state starts
	req.FollowUpStatus = FollowUpPending
	// IMPORTANT TARGET 1: outcome_status remains pending!
	// It is NOT failed, NOT 0 revenue, NOT logged yet.
	if req.OutcomeStatus == "" {
		req.OutcomeStatus = OutcomeStatusPending
	}
	req.UpdatedAt = now

	if err := s.store.UpdateRequest(ctx, req); err != nil {
		return nil, nil, err
	}

	_ = s.publisher.Publish(ctx, "sample.delivered", map[string]any{
		"shipment_id": shipment.ShipmentID,
		"request_id":  requestID,
	})

	updatedReq, _ := s.store.GetRequest(ctx, workspaceID, requestID)
	return updatedReq, shipment, nil
}

// UpdateFollowUp transitions follow-up status per RULE-M18-006.
func (s *Service) UpdateFollowUp(ctx context.Context, workspaceID, requestID string, newStatus FollowUpStatus, notes string) (*SampleRequest, error) {
	req, err := s.store.GetRequest(ctx, workspaceID, requestID)
	if err != nil {
		return nil, err
	}

	req.FollowUpStatus = newStatus
	if notes != "" {
		req.Notes = req.Notes + " [Follow-up: " + notes + "]"
	}
	req.UpdatedAt = time.Now().UTC()

	if err := s.store.UpdateRequest(ctx, req); err != nil {
		return nil, err
	}
	return s.store.GetRequest(ctx, workspaceID, requestID)
}

// LinkContent logs content and conversion outcomes per RULE-M18-002, RULE-M18-003, RULE-M18-004.
func (s *Service) LinkContent(ctx context.Context, workspaceID, requestID string, outcome SampleOutcome) (*SampleRequest, error) {
	req, err := s.store.GetRequest(ctx, workspaceID, requestID)
	if err != nil {
		return nil, err
	}

	// Target 2 / RULE-M18-002: Ensure accurate provenance tagging
	// If outcome is manually entered without verified affiliate link, cannot claim official!
	if outcome.SourceClass == SourceClassOfficial && outcome.PublishItemID == "" {
		outcome.SourceClass = SourceClassImported
	}
	if outcome.SourceClass == "" {
		outcome.SourceClass = SourceClassImported
	}
	if outcome.ConfidenceLevel == "" {
		if outcome.SourceClass == SourceClassOfficial {
			outcome.ConfidenceLevel = ConfidenceHigh
		} else if outcome.SourceClass == SourceClassImported {
			outcome.ConfidenceLevel = ConfidenceMedium
		} else {
			outcome.ConfidenceLevel = ConfidenceLow
		}
	}
	outcome.LoggedAt = time.Now().UTC()

	req.OutcomeStatus = OutcomeStatusLogged
	req.Outcome = outcome
	req.UpdatedAt = time.Now().UTC()

	if err := s.store.UpdateRequest(ctx, req); err != nil {
		return nil, err
	}

	return s.store.GetRequest(ctx, workspaceID, requestID)
}

// GetReport computes campaign/workspace seeding ROI, costs, and qualification of missing outcomes (Target 2).
func (s *Service) GetReport(ctx context.Context, workspaceID, campaignID string) (*SeedingReport, error) {
	var campPtr *string
	if campaignID != "" {
		campPtr = &campaignID
	}

	requests, _, err := s.store.ListRequests(ctx, workspaceID, campPtr, nil, nil, nil, nil, nil, 10000, 0)
	if err != nil {
		return nil, err
	}

	report := &SeedingReport{
		CampaignID:  campaignID,
		WorkspaceID: workspaceID,
		Currency:    "VND",
	}

	var totalCOGS tenantdb.ExactDecimal
	var totalShipping tenantdb.ExactDecimal
	var totalAttributableRevenue tenantdb.ExactDecimal

	lowestConfidence := ConfidenceHigh

	for _, r := range requests {
		report.TotalSamplesRequested++
		if r.Status == RequestStatusApproved || r.Status == RequestStatusFulfilled {
			report.TotalSamplesApproved++
		}
		if r.Shipment != nil {
			if r.Shipment.Status == ShipmentStatusShipped || r.Shipment.Status == ShipmentStatusDelivered {
				report.TotalSamplesShipped++
			}
			if r.Shipment.Status == ShipmentStatusDelivered {
				report.TotalSamplesDelivered++
			}
			totalShipping, _ = totalShipping.Add(r.Shipment.ShippingCost)
		}

		// Calculate COGS
		cogs := mulExactByInt(r.ProductCOGS, r.Quantity)
		totalCOGS, _ = totalCOGS.Add(cogs)

		// Target 1 & Target 2: Outcome tracking
		if r.OutcomeStatus == OutcomeStatusLogged {
			report.OutcomesLoggedCount++
			totalAttributableRevenue, _ = totalAttributableRevenue.Add(r.Outcome.AttributableRevenue)
			if r.Outcome.ConfidenceLevel == ConfidenceLow {
				lowestConfidence = ConfidenceLow
			} else if r.Outcome.ConfidenceLevel == ConfidenceMedium && lowestConfidence != ConfidenceLow {
				lowestConfidence = ConfidenceMedium
			}
		}
	}

	totalCost, _ := totalCOGS.Add(totalShipping)
	report.TotalCOGS = totalCOGS
	report.TotalShipping = totalShipping
	report.TotalCost = totalCost
	report.AttributableRevenue = totalAttributableRevenue

	// Target 2: Missing outcome NOT definitive zero
	if report.TotalSamplesDelivered > report.OutcomesLoggedCount {
		report.PendingOutcomesCount = report.TotalSamplesDelivered - report.OutcomesLoggedCount
		report.IsMissingOutcomePending = true
		// Cannot be high confidence if outcomes are missing
		if lowestConfidence == ConfidenceHigh {
			lowestConfidence = ConfidenceMedium
		}
		report.ConfidenceNotes = fmt.Sprintf("%d delivered sample(s) have pending content/conversion outcomes; missing data is not counted as zero revenue", report.PendingOutcomesCount)
	} else if report.TotalSamplesDelivered == 0 {
		report.ConfidenceNotes = "No samples delivered yet; pending shipment and creator receipt"
		lowestConfidence = ConfidenceMedium
	} else {
		report.ConfidenceNotes = "All delivered samples have verified outcomes"
	}

	report.OverallConfidence = lowestConfidence

	// Coverage rate
	if report.TotalSamplesDelivered > 0 {
		pct := (float64(report.OutcomesLoggedCount) / float64(report.TotalSamplesDelivered)) * 100
		report.OutcomeCoverageRate = fmt.Sprintf("%.1f%%", pct)
	} else {
		report.OutcomeCoverageRate = "0.0%"
	}

	// ROI calculation
	if !totalCost.IsZero() {
		// Net gain = revenue - cost
		netGain, _ := totalAttributableRevenue.Sub(totalCost)
		// ROI percentage = (netGain / totalCost) * 100
		netFloat := toFloat(netGain)
		costFloat := toFloat(totalCost)
		roiPct := (netFloat / costFloat) * 100
		report.ROIPercentage = fmt.Sprintf("%.1f%%", roiPct)
	} else {
		report.ROIPercentage = "0.0%"
	}

	return report, nil
}

// Campaign and assignment management
func (s *Service) CreateCampaign(ctx context.Context, camp *SeedingCampaign) error {
	return s.store.CreateCampaign(ctx, camp)
}

func (s *Service) GetCampaign(ctx context.Context, workspaceID, campaignID string) (*SeedingCampaign, error) {
	return s.store.GetCampaign(ctx, workspaceID, campaignID)
}

func (s *Service) ListCampaigns(ctx context.Context, workspaceID, status string, limit, offset int) ([]*SeedingCampaign, int, error) {
	return s.store.ListCampaigns(ctx, workspaceID, status, limit, offset)
}

func (s *Service) CreateAssignment(ctx context.Context, workspaceID, campaignID, creatorID, productID, notes string) (string, error) {
	return s.store.CreateAssignment(ctx, workspaceID, campaignID, creatorID, productID, notes)
}

func (s *Service) RemoveAssignment(ctx context.Context, workspaceID, assignmentID string) error {
	return s.store.RemoveAssignment(ctx, workspaceID, assignmentID)
}

func (s *Service) ListAssignments(ctx context.Context, workspaceID, campaignID string, limit, offset int) ([]*SampleRequest, int, error) {
	return s.store.ListAssignments(ctx, workspaceID, campaignID, limit, offset)
}
