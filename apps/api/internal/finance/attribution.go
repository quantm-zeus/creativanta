package finance

import (
	"context"
	"errors"
	"fmt"
	"math/big"
	"strings"
	"sync"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	financev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/finance/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"google.golang.org/protobuf/types/known/timestamppb"
)

var (
	ErrAttributionCapacityExceeded   = errors.New("finance: attributed revenue exceeds order net recognized revenue capacity")
	ErrImportedProofCannotBeOfficial = errors.New("finance: imported proof cannot be upgraded to official without verified live platform API session")
	ErrMissingDenominator            = errors.New("finance: calculation denominator is missing or unrecorded")
	ErrLowExposureInconclusive       = errors.New("finance: exposure is below threshold for conclusive comparison")
	ErrAttributionNotFound           = errors.New("finance: content attribution record not found")
)

// SafeMetric encapsulates a calculated metric or records an explicit unknown state (Target 2).
type SafeMetric struct {
	Value         string `json:"value,omitempty"`
	IsUnknown     bool   `json:"is_unknown"`
	UnknownReason string `json:"unknown_reason,omitempty"`
	Status        string `json:"status"` // "calculated", "collecting_data", "unknown_denominator", "low_exposure_inconclusive"
}

// CanonicalOrderRecord holds the recognized order details for single-counting checks.
type CanonicalOrderRecord struct {
	OrderID           string
	WorkspaceID       string
	GrossRevenue      tenantdb.ExactDecimal
	RefundDeduction   tenantdb.ExactDecimal
	NetRevenue        tenantdb.ExactDecimal
	Currency          string
	SourceClass       string
	Confidence        string
	LifecycleState    string
	IsRecognizedOrder bool
}

// ContentAttributionEntity models content_attribution_records in persistence and memory.
type ContentAttributionEntity struct {
	AttributionID     string                `json:"attribution_id"`
	WorkspaceID       string                `json:"workspace_id"`
	PublishItemID     string                `json:"publish_item_id,omitempty"`
	ChannelPostID     string                `json:"channel_post_id,omitempty"`
	OrderID           string                `json:"order_id"`
	AttributionType   string                `json:"attribution_type"` // direct_click, utm_match, affiliate, organic
	RevenueAttributed tenantdb.ExactDecimal `json:"revenue_attributed"`
	SourceClass       string                `json:"source_class"`
	Confidence        string                `json:"confidence"`
	UTMSource         string                `json:"utm_source,omitempty"`
	UTMMedium         string                `json:"utm_medium,omitempty"`
	UTMCampaign       string                `json:"utm_campaign,omitempty"`
	Metadata          map[string]any        `json:"metadata,omitempty"`
	CreatedAt         time.Time             `json:"created_at"`
	UpdatedAt         time.Time             `json:"updated_at"`
}

// ChannelPostMetricsSnapshot models metrics synchronized from platform APIs or imports.
type ChannelPostMetricsSnapshot struct {
	MetricID        string    `json:"metric_id"`
	WorkspaceID     string    `json:"workspace_id"`
	ChannelPostID   string    `json:"channel_post_id"`
	Views           *int64    `json:"views,omitempty"`
	Likes           int64     `json:"likes"`
	Comments        int64     `json:"comments"`
	Shares          int64     `json:"shares"`
	Saves           int64     `json:"saves"`
	Clicks          *int64    `json:"clicks,omitempty"`
	IsViewsUnknown  bool      `json:"is_views_unknown"`
	IsClicksUnknown bool      `json:"is_clicks_unknown"`
	UnknownReason   string    `json:"unknown_reason,omitempty"`
	SourceClass     string    `json:"source_class"`
	Confidence      string    `json:"confidence"`
	CapturedAt      time.Time `json:"captured_at"`
}

// ----------------------------------------------------------------------------
// Acceptance Target 1: Workspace Revenue Counted Once & Capacity Enforcement
// ----------------------------------------------------------------------------

// ValidateAttributionCapacity verifies that the sum of attributed revenues for an order
// does not exceed the order's recognized net-of-refund revenue (Financial computation contract §3).
func ValidateAttributionCapacity(
	netRevenue tenantdb.ExactDecimal,
	existingAllocations []tenantdb.ExactDecimal,
	newAllocation tenantdb.ExactDecimal,
) (remainingCapacity tenantdb.ExactDecimal, err error) {
	if newAllocation.IsNegative() {
		return tenantdb.ZeroDecimal(), fmt.Errorf("%w: allocation cannot be negative", ErrInvalidAmount)
	}

	allocatedSum := tenantdb.ZeroDecimal()
	for _, a := range existingAllocations {
		allocatedSum, err = allocatedSum.Add(a)
		if err != nil {
			return tenantdb.ZeroDecimal(), err
		}
	}

	totalWithNew, err := allocatedSum.Add(newAllocation)
	if err != nil {
		return tenantdb.ZeroDecimal(), err
	}

	// Compare totalWithNew vs netRevenue
	cmp := totalWithNew.Cmp(netRevenue)
	if cmp > 0 {
		return tenantdb.ZeroDecimal(), fmt.Errorf("%w: attempted %s total, order net revenue capacity is %s",
			ErrAttributionCapacityExceeded, totalWithNew.String(), netRevenue.String())
	}

	remaining, err := netRevenue.Sub(totalWithNew)
	if err != nil {
		return tenantdb.ZeroDecimal(), err
	}
	return remaining, nil
}

// DeduplicateWorkspaceRevenue implements the canonical rule that workspace revenue
// is counted once by summing distinct recognized orders, never multiple attribution rows.
func DeduplicateWorkspaceRevenue(
	workspaceID string,
	orders map[string]CanonicalOrderRecord,
	attributionRecords []ContentAttributionEntity,
) (*financev1.WorkspaceRevenueDeduplicationSummary, error) {
	uniqueOrderIDs := make(map[string]bool)
	sumAttribution := tenantdb.ZeroDecimal()

	hasImportedOrEstimated := false
	minConfidenceRank := 5

	for _, attr := range attributionRecords {
		uniqueOrderIDs[attr.OrderID] = true
		var err error
		sumAttribution, err = sumAttribution.Add(attr.RevenueAttributed)
		if err != nil {
			return nil, fmt.Errorf("attribution sum overflow: %w", err)
		}

		if attr.SourceClass == SourceClassImported || attr.SourceClass == SourceClassEstimated || attr.SourceClass == SourceClassInferred {
			hasImportedOrEstimated = true
		}
		r := RankConfidence(attr.Confidence)
		if r < minConfidenceRank {
			minConfidenceRank = r
		}
	}

	// Canonical workspace revenue sums recognized orders ONCE
	canonicalRevenue := tenantdb.ZeroDecimal()
	for orderID := range uniqueOrderIDs {
		ord, ok := orders[orderID]
		if !ok {
			continue
		}
		if !ord.IsRecognizedOrder && ord.LifecycleState != "completed" {
			// Pending or cancelled orders do not contribute recognized revenue
			continue
		}
		var err error
		canonicalRevenue, err = canonicalRevenue.Add(ord.NetRevenue)
		if err != nil {
			return nil, fmt.Errorf("canonical revenue addition overflow: %w", err)
		}

		if ord.SourceClass == SourceClassImported || ord.SourceClass == SourceClassEstimated {
			hasImportedOrEstimated = true
		}
		r := RankConfidence(ord.Confidence)
		if r < minConfidenceRank {
			minConfidenceRank = r
		}
	}

	// Cap aggregate confidence at medium if imported/estimated/inferred sources are present
	resolvedBand := BandFromRank(minConfidenceRank)
	if hasImportedOrEstimated && RankConfidence(resolvedBand) > RankConfidence(ConfidenceMedium) {
		resolvedBand = ConfidenceMedium
	}

	caveat := ""
	if hasImportedOrEstimated {
		caveat = "Workspace revenue aggregate includes imported or estimated components."
	}

	currency := "VND"
	for _, ord := range orders {
		if ord.Currency != "" {
			currency = ord.Currency
			break
		}
	}

	return &financev1.WorkspaceRevenueDeduplicationSummary{
		WorkspaceId:                 workspaceID,
		TotalOrdersAttributed:       int64(len(attributionRecords)),
		UniqueOrdersCounted:         int64(len(uniqueOrderIDs)),
		CanonicalWorkspaceRevenue:   &commonv1.Money{Amount: canonicalRevenue.Fixed6String(), Currency: currency},
		SumAttributionLines:         &commonv1.Money{Amount: sumAttribution.Fixed6String(), Currency: currency},
		IsRevenueCountedOnce:        true,
		AggregateConfidence:         toProtoConfidenceBand(resolvedBand),
		IncludesEstimatedOrImported: hasImportedOrEstimated,
		CaveatMessage:               caveat,
	}, nil
}

// ----------------------------------------------------------------------------
// Acceptance Target 2: Missing Denominators Remain Unknown
// ----------------------------------------------------------------------------

// CalculateRPM computes Revenue Per Mille (Revenue / (Views / 1000)).
// If views is nil, unknown, or 0, it leaves the result explicitly UNKNOWN.
// Resolves EXP-2026-02: Exposure < 100 views is marked low_exposure_inconclusive.
func CalculateRPM(revenue tenantdb.ExactDecimal, views *int64, isViewsUnknown bool, reason string) SafeMetric {
	if isViewsUnknown || views == nil {
		if reason == "" {
			reason = "MISSING_DENOMINATOR_VIEWS"
		}
		return SafeMetric{
			IsUnknown:     true,
			UnknownReason: reason,
			Status:        "unknown_denominator",
		}
	}

	v := *views
	if v <= 0 {
		return SafeMetric{
			IsUnknown:     true,
			UnknownReason: "MISSING_DENOMINATOR_VIEWS",
			Status:        "collecting_data",
		}
	}

	// Exact calculation: rpm = (revenue * 1000) / views
	revMicro := revenue.ToPgNumeric().Int
	if revMicro == nil {
		return SafeMetric{IsUnknown: true, UnknownReason: "INVALID_REVENUE_AMOUNT", Status: "unknown_denominator"}
	}

	// Multiply by 1000, then integer divide by views
	scaled := new(big.Int).Mul(revMicro, big.NewInt(1000))
	rpmInt := new(big.Int).Quo(scaled, big.NewInt(v))

	rpmDec, err := tenantdb.FromPgNumeric(pgtype.Numeric{
		Int:   rpmInt,
		Exp:   -tenantdb.MaxDecimalScale,
		Valid: true,
	})
	if err != nil {
		return SafeMetric{IsUnknown: true, UnknownReason: err.Error(), Status: "calculation_error"}
	}

	if v < 100 {
		return SafeMetric{
			Value:         "",
			IsUnknown:     true,
			UnknownReason: "LOW_EXPOSURE_BELOW_THRESHOLD",
			Status:        "low_exposure_inconclusive",
		}
	}

	return SafeMetric{
		Value:  rpmDec.Fixed6String(),
		Status: "calculated",
	}
}

// CalculateCTR computes Click-Through Rate (Clicks / Views).
// If views or clicks are missing/unknown, remains UNKNOWN.
func CalculateCTR(clicks, views *int64, isViewsUnknown, isClicksUnknown bool) SafeMetric {
	if isViewsUnknown || views == nil {
		return SafeMetric{
			IsUnknown:     true,
			UnknownReason: "MISSING_DENOMINATOR_VIEWS",
			Status:        "unknown_denominator",
		}
	}
	if isClicksUnknown || clicks == nil {
		return SafeMetric{
			IsUnknown:     true,
			UnknownReason: "MISSING_NUMERATOR_CLICKS",
			Status:        "unknown_denominator",
		}
	}

	v := *views
	c := *clicks
	if v <= 0 {
		return SafeMetric{
			IsUnknown:     true,
			UnknownReason: "ZERO_EXPOSURE_DENOMINATOR",
			Status:        "collecting_data",
		}
	}

	ctrFloat := float64(c) / float64(v)
	if v < 100 {
		return SafeMetric{
			Value:         fmt.Sprintf("%.4f", ctrFloat),
			IsUnknown:     true,
			UnknownReason: "LOW_EXPOSURE_BELOW_THRESHOLD",
			Status:        "low_exposure_inconclusive",
		}
	}

	return SafeMetric{
		Value:  fmt.Sprintf("%.4f", ctrFloat),
		Status: "calculated",
	}
}

// CalculateConversionRate computes (Orders / Clicks).
// If clicks denominator is missing, remains UNKNOWN.
func CalculateConversionRate(orders int64, clicks *int64, isClicksUnknown bool) SafeMetric {
	if isClicksUnknown || clicks == nil {
		return SafeMetric{
			IsUnknown:     true,
			UnknownReason: "MISSING_DENOMINATOR_CLICKS",
			Status:        "unknown_denominator",
		}
	}
	c := *clicks
	if c <= 0 {
		return SafeMetric{
			IsUnknown:     true,
			UnknownReason: "ZERO_CLICKS_DENOMINATOR",
			Status:        "collecting_data",
		}
	}
	rate := float64(orders) / float64(c)
	return SafeMetric{
		Value:  fmt.Sprintf("%.4f", rate),
		Status: "calculated",
	}
}

// CalculateROI computes Return on Investment: (Revenue - Cost) / Cost.
// If cost is missing, zero, or unrecorded, remains UNKNOWN.
func CalculateROI(revenue, cost tenantdb.ExactDecimal, isCostUnknown bool) SafeMetric {
	if isCostUnknown || cost.IsZero() || cost.IsNegative() {
		return SafeMetric{
			IsUnknown:     true,
			UnknownReason: "MISSING_DENOMINATOR_COST",
			Status:        "unknown_denominator",
		}
	}

	net, err := revenue.Sub(cost)
	if err != nil {
		return SafeMetric{IsUnknown: true, UnknownReason: err.Error(), Status: "calculation_error"}
	}

	// (net / cost) * 100
	costNum := cost.ToPgNumeric().Int
	netNum := net.ToPgNumeric().Int
	if costNum == nil || netNum == nil || costNum.Sign() <= 0 {
		return SafeMetric{IsUnknown: true, UnknownReason: "INVALID_COST_NUMERIC", Status: "unknown_denominator"}
	}

	// net * 100 * 10^6 / cost
	netScaled := new(big.Int).Mul(netNum, big.NewInt(100))
	roiPct := new(big.Int).Quo(netScaled, costNum)

	return SafeMetric{
		Value:  fmt.Sprintf("%s%%", roiPct.String()),
		Status: "calculated",
	}
}

// ----------------------------------------------------------------------------
// Acceptance Target 3: Imported Proof Not Upgraded to Official
// ----------------------------------------------------------------------------

// EnforceSourceClassIntegrity verifies that imported or inferred records can never be
// masqueraded as official without live verified provider API credentials and responses.
func EnforceSourceClassIntegrity(currentClass, requestedClass string, isLiveAPIVerified bool) (string, error) {
	req := strings.ToLower(strings.TrimSpace(requestedClass))
	curr := strings.ToLower(strings.TrimSpace(currentClass))

	if req == SourceClassOfficial && !isLiveAPIVerified {
		if curr == SourceClassImported || curr == SourceClassInferred || curr == SourceClassEstimated {
			return curr, fmt.Errorf("%w: attempted to promote %s proof to official", ErrImportedProofCannotBeOfficial, curr)
		}
		return SourceClassImported, fmt.Errorf("%w: official requires active provider API verification", ErrImportedProofCannotBeOfficial)
	}

	// If the current record is imported, it stays imported even upon manual verification.
	// Manual verification sets reconciliation_state = 'fully_reconciled' or 'manually_overridden',
	// but the source_class remains 'imported' (RULE-M19-001, RULE-M19-007).
	if curr == SourceClassImported && req == SourceClassOfficial {
		return SourceClassImported, ErrImportedProofCannotBeOfficial
	}

	if req == "" {
		if curr != "" {
			return curr, nil
		}
		return SourceClassInferred, nil
	}
	return req, nil
}

// ----------------------------------------------------------------------------
// In-Memory / Thread-Safe Attribution Store & Service Engine
// ----------------------------------------------------------------------------

type AttributionEngine struct {
	mu           sync.RWMutex
	attributions map[string]*ContentAttributionEntity
	metrics      map[string]*ChannelPostMetricsSnapshot
	orders       map[string]CanonicalOrderRecord
}

func NewAttributionEngine() *AttributionEngine {
	return &AttributionEngine{
		attributions: make(map[string]*ContentAttributionEntity),
		metrics:      make(map[string]*ChannelPostMetricsSnapshot),
		orders:       make(map[string]CanonicalOrderRecord),
	}
}

// SeedCanonicalOrder registers or updates a canonical order record in the engine.
func (e *AttributionEngine) SeedCanonicalOrder(order CanonicalOrderRecord) {
	e.mu.Lock()
	defer e.mu.Unlock()
	e.orders[order.OrderID] = order
}

// GetCanonicalOrder returns the tracked canonical order record if present.
func (e *AttributionEngine) GetCanonicalOrder(orderID string) (CanonicalOrderRecord, bool) {
	e.mu.RLock()
	defer e.mu.RUnlock()
	order, exists := e.orders[orderID]
	return order, exists
}

// GetOrderAllocationStatus returns total allocated revenue and remaining capacity for an order.
func (e *AttributionEngine) GetOrderAllocationStatus(orderID string) (allocated tenantdb.ExactDecimal, remaining tenantdb.ExactDecimal) {
	e.mu.RLock()
	defer e.mu.RUnlock()
	allocated = tenantdb.ZeroDecimal()
	order, exists := e.orders[orderID]
	for _, attr := range e.attributions {
		if attr.OrderID == orderID {
			allocated, _ = allocated.Add(attr.RevenueAttributed)
		}
	}
	if !exists {
		return allocated, tenantdb.ZeroDecimal()
	}
	remaining, _ = order.NetRevenue.Sub(allocated)
	if remaining.IsNegative() {
		remaining = tenantdb.ZeroDecimal()
	}
	return allocated, remaining
}

// RecordRefundDeduction updates an order's refund deduction and net revenue.
func (e *AttributionEngine) RecordRefundDeduction(orderID string, refund tenantdb.ExactDecimal) {
	e.mu.Lock()
	defer e.mu.Unlock()
	if order, exists := e.orders[orderID]; exists {
		order.RefundDeduction, _ = order.RefundDeduction.Add(refund)
		order.NetRevenue, _ = order.GrossRevenue.Sub(order.RefundDeduction)
		e.orders[orderID] = order
	}
}

// ListAttributionsForWorkspace returns all recorded content attributions for a workspace.
func (e *AttributionEngine) ListAttributionsForWorkspace(workspaceID string) []ContentAttributionEntity {
	e.mu.RLock()
	defer e.mu.RUnlock()
	var result []ContentAttributionEntity
	for _, attr := range e.attributions {
		if attr != nil && attr.WorkspaceID == workspaceID {
			result = append(result, *attr)
		}
	}
	return result
}

// RecordAttribution records a new content attribution record with full Target 1 and Target 3 checks.
func (e *AttributionEngine) RecordAttribution(
	ctx context.Context,
	attr *ContentAttributionEntity,
	isLiveAPIVerified bool,
) (*ContentAttributionEntity, error) {
	e.mu.Lock()
	defer e.mu.Unlock()

	if attr.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	if attr.OrderID == "" {
		return nil, ErrOrderNotFound
	}

	order, exists := e.orders[attr.OrderID]
	if !exists {
		// Fallback: create default order record if not pre-seeded
		order = CanonicalOrderRecord{
			OrderID:           attr.OrderID,
			WorkspaceID:       attr.WorkspaceID,
			GrossRevenue:      attr.RevenueAttributed,
			RefundDeduction:   tenantdb.ZeroDecimal(),
			NetRevenue:        attr.RevenueAttributed,
			Currency:          "VND",
			SourceClass:       attr.SourceClass,
			Confidence:        attr.Confidence,
			LifecycleState:    "completed",
			IsRecognizedOrder: true,
		}
		e.orders[attr.OrderID] = order
	}

	// Target 3: Validate source class integrity
	validSourceClass, err := EnforceSourceClassIntegrity(attr.SourceClass, attr.SourceClass, isLiveAPIVerified)
	if err != nil {
		return nil, err
	}
	attr.SourceClass = validSourceClass

	// Target 1: Enforce allocation capacity (sum of attributions cannot exceed order net recognized revenue)
	var existingAllocations []tenantdb.ExactDecimal
	for _, existing := range e.attributions {
		if existing.WorkspaceID == attr.WorkspaceID && existing.OrderID == attr.OrderID {
			existingAllocations = append(existingAllocations, existing.RevenueAttributed)
		}
	}

	_, err = ValidateAttributionCapacity(order.NetRevenue, existingAllocations, attr.RevenueAttributed)
	if err != nil {
		return nil, err
	}

	if attr.AttributionID == "" {
		attr.AttributionID = newUUID()
	}
	if attr.CreatedAt.IsZero() {
		attr.CreatedAt = time.Now().UTC()
	}
	attr.UpdatedAt = time.Now().UTC()

	e.attributions[attr.AttributionID] = attr
	return attr, nil
}

// RecordChannelPostMetrics stores post metrics with denominator tracking.
func (e *AttributionEngine) RecordChannelPostMetrics(
	ctx context.Context,
	metric *ChannelPostMetricsSnapshot,
	isLiveAPIVerified bool,
) (*ChannelPostMetricsSnapshot, error) {
	e.mu.Lock()
	defer e.mu.Unlock()

	if metric.WorkspaceID == "" {
		return nil, ErrMissingTenant
	}
	if metric.ChannelPostID == "" {
		return nil, errors.New("finance: channel_post_id required")
	}

	// Target 3: Enforce source class integrity
	validClass, err := EnforceSourceClassIntegrity(metric.SourceClass, metric.SourceClass, isLiveAPIVerified)
	if err != nil {
		return nil, err
	}
	metric.SourceClass = validClass

	// If source class is imported, confidence cannot be High
	if metric.SourceClass == SourceClassImported && RankConfidence(metric.Confidence) > RankConfidence(ConfidenceMedium) {
		metric.Confidence = ConfidenceMedium
	}

	if metric.MetricID == "" {
		metric.MetricID = newUUID()
	}
	if metric.CapturedAt.IsZero() {
		metric.CapturedAt = time.Now().UTC()
	}

	e.metrics[metric.ChannelPostID] = metric
	return metric, nil
}

// GetContentRevenueAttribution computes the performance rollup for a content piece.
func (e *AttributionEngine) GetContentRevenueAttribution(
	ctx context.Context,
	workspaceID, contentID string,
) (*financev1.ContentRevenueAttribution, []*ContentAttributionEntity, *financev1.WorkspaceRevenueDeduplicationSummary, error) {
	e.mu.RLock()
	defer e.mu.RUnlock()

	var matchingAttrs []*ContentAttributionEntity
	var allWorkspaceAttrs []ContentAttributionEntity
	attributedRevenue := tenantdb.ZeroDecimal()
	uniqueOrders := make(map[string]bool)

	sourceCounts := make(map[string]tenantdb.ExactDecimal)
	minConfidence := 5

	for _, a := range e.attributions {
		if a.WorkspaceID != workspaceID {
			continue
		}
		allWorkspaceAttrs = append(allWorkspaceAttrs, *a)

		if a.PublishItemID == contentID || a.ChannelPostID == contentID {
			matchingAttrs = append(matchingAttrs, a)
			uniqueOrders[a.OrderID] = true
			var err error
			attributedRevenue, err = attributedRevenue.Add(a.RevenueAttributed)
			if err != nil {
				return nil, nil, nil, err
			}

			currAmt := sourceCounts[a.SourceClass]
			sourceCounts[a.SourceClass], _ = currAmt.Add(a.RevenueAttributed)

			r := RankConfidence(a.Confidence)
			if r < minConfidence {
				minConfidence = r
			}
		}
	}

	// Find metrics snapshot for post
	metricSnap := e.metrics[contentID]
	var views *int64
	var clicks *int64
	isViewsUnknown := true
	isClicksUnknown := true
	unknownReason := "DATA_NOT_SYNCED_YET"

	if metricSnap != nil {
		views = metricSnap.Views
		clicks = metricSnap.Clicks
		isViewsUnknown = metricSnap.IsViewsUnknown || views == nil
		isClicksUnknown = metricSnap.IsClicksUnknown || clicks == nil
		unknownReason = metricSnap.UnknownReason
	}

	// Safe calculations (Target 2)
	rpmMetric := CalculateRPM(attributedRevenue, views, isViewsUnknown, unknownReason)
	ctrMetric := CalculateCTR(clicks, views, isViewsUnknown, isClicksUnknown)
	convMetric := CalculateConversionRate(int64(len(uniqueOrders)), clicks, isClicksUnknown)

	// Percentages by source class
	pcts := make(map[string]float64)
	if !attributedRevenue.IsZero() {
		totalNum := attributedRevenue.ToPgNumeric().Int
		for sc, amt := range sourceCounts {
			amtNum := amt.ToPgNumeric().Int
			if totalNum != nil && amtNum != nil && totalNum.Sign() > 0 {
				ratio := new(big.Float).Quo(new(big.Float).SetInt(amtNum), new(big.Float).SetInt(totalNum))
				pct, _ := ratio.Float64()
				pcts[sc] = pct * 100.0
			}
		}
	}

	confBand := BandFromRank(minConfidence)
	if sourceCounts[SourceClassImported].IsPositive() || sourceCounts[SourceClassEstimated].IsPositive() {
		if RankConfidence(confBand) > RankConfidence(ConfidenceMedium) {
			confBand = ConfidenceMedium
		}
	}

	attrStatus := "calculated"
	if rpmMetric.IsUnknown {
		attrStatus = rpmMetric.Status
	}

	currency := "VND"
	for _, o := range e.orders {
		if o.Currency != "" {
			currency = o.Currency
			break
		}
	}

	var viewsVal int64
	if views != nil {
		viewsVal = *views
	}
	var clicksVal int64
	if clicks != nil {
		clicksVal = *clicks
	}

	contentRevenue := &financev1.ContentRevenueAttribution{
		ContentId:               contentID,
		PublishItemId:           contentID,
		DirectOrderCount:        int64(len(uniqueOrders)),
		AttributedRevenue:       &commonv1.Money{Amount: attributedRevenue.Fixed6String(), Currency: currency},
		Views:                   viewsVal,
		Clicks:                  clicksVal,
		IsViewsUnknown:          rpmMetric.IsUnknown,
		IsClicksUnknown:         convMetric.IsUnknown,
		UnknownReason:           rpmMetric.UnknownReason,
		Rpm:                     rpmMetric.Value,
		IsRpmUnknown:            rpmMetric.IsUnknown,
		Ctr:                     ctrMetric.Value,
		IsCtrUnknown:            ctrMetric.IsUnknown,
		ConversionRate:          convMetric.Value,
		IsConversionRateUnknown: convMetric.IsUnknown,
		Confidence:              toProtoConfidenceBand(confBand),
		SourceClassPercentages:  pcts,
		Status:                  attrStatus,
	}

	// Target 1: Deduplicate workspace revenue summary
	summary, err := DeduplicateWorkspaceRevenue(workspaceID, e.orders, allWorkspaceAttrs)
	if err != nil {
		return nil, nil, nil, err
	}

	return contentRevenue, matchingAttrs, summary, nil
}

// ConvertEntityToProto converts internal domain attribution entity to protobuf message.
func ConvertEntityToProto(e *ContentAttributionEntity) *financev1.ContentAttributionRecord {
	if e == nil {
		return nil
	}
	return &financev1.ContentAttributionRecord{
		AttributionId:     e.AttributionID,
		WorkspaceId:       e.WorkspaceID,
		PublishItemId:     e.PublishItemID,
		ChannelPostId:     e.ChannelPostID,
		OrderId:           e.OrderID,
		AttributionType:   e.AttributionType,
		RevenueAttributed: &commonv1.Money{Amount: e.RevenueAttributed.Fixed6String(), Currency: "VND"},
		SourceClass:       toProtoSourceClass(e.SourceClass),
		Confidence:        toProtoConfidenceBand(e.Confidence),
		UtmSource:         e.UTMSource,
		UtmMedium:         e.UTMMedium,
		UtmCampaign:       e.UTMCampaign,
		CreatedAt:         timestamppb.New(e.CreatedAt),
	}
}
