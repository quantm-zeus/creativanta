package finance

import (
	"context"
	"crypto/sha512"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"sort"
	"strings"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// CanonicalTaxResponsibilityMode and disclaimer per business_rules.md BIZ-007.
const (
	CanonicalTaxResponsibilityMode = "creator_responsible"
	CanonicalTaxDisclaimer         = "creator_responsible: Creativanta cung cấp dữ liệu tổng hợp doanh thu và chi phí đối soát tham khảo; nhà sáng tạo/doanh nghiệp tự chịu trách nhiệm kê khai và nộp thuế theo quy định pháp luật hiện hành."
)

// ReportTemplateSummary describes a standard financial report template (W087).
type ReportTemplateSummary struct {
	TemplateCode string
	Title        string
	Description  string
}

var canonicalReportTemplates = []ReportTemplateSummary{
	{
		TemplateCode: "pnl_statement",
		Title:        "P&L Statement",
		Description:  "Báo cáo kết quả kinh doanh: Doanh thu - Giá vốn (COGS) - Chi phí vận hành = Lợi nhuận ròng.",
	},
	{
		TemplateCode: "revenue_by_channel",
		Title:        "Revenue by Channel",
		Description:  "Phân tích doanh thu theo nền tảng và kênh bán hàng kèm nhãn độ tin cậy dữ liệu.",
	},
	{
		TemplateCode: "cost_analysis",
		Title:        "Cost Analysis",
		Description:  "Phân tích cơ cấu chi phí vận hành (phí sàn, vận chuyển, quảng cáo, AI credits, hoa hồng, seeding).",
	},
	{
		TemplateCode: "margin_trend",
		Title:        "Margin Trend",
		Description:  "Xu hướng biên lợi nhuận gộp và biên lợi nhuận ròng theo kỳ.",
	},
	{
		TemplateCode: "tax_summary",
		Title:        "Tax Summary",
		Description:  "Tổng hợp doanh thu và chi phí khấu trừ phục vụ tham khảo kê khai thuế (BIZ-007 creator_responsible).",
	},
	{
		TemplateCode: "product_pnl",
		Title:        "Product P&L",
		Description:  "Lợi nhuận ròng và giá vốn chi tiết theo từng sản phẩm / SKU.",
	},
}

// FinancialReportLineItem represents a line in a generated financial report (W087).
type FinancialReportLineItem struct {
	Key          string
	Label        string
	Amount       tenantdb.ExactDecimal
	Currency     string
	PctOfRevenue string
	SourceClass  string
	Confidence   string
	IsSubtotal   bool
}

// FinancialReport represents a materialized financial report with trust annotations and optional cohort economics.
type FinancialReport struct {
	ReportID              string
	WorkspaceID           string
	ReportType            string
	PeriodStart           string
	PeriodEnd             string
	GroupBy               string
	Currency              string
	LineItems             []FinancialReportLineItem
	Snapshot              *ProfitSnapshot
	ReconciledCoveragePct string
	LowTrustWarning       bool
	TaxDisclaimer         string
	CohortEconomics       *CohortEconomicsSummary
	GeneratedAt           time.Time
}

// ReportExportResult captures a tier-gated report export artifact and SHA-512 hash.
type ReportExportResult struct {
	ExportID              string
	Format                string
	FileURL               string
	ContentHashSHA512     string
	MonthlyExportsUsed    int
	MonthlyExportsLimit   int // -1 for unlimited
	TaxResponsibilityMode string
	TaxDisclaimer         string
	Report                *FinancialReport
}

// CohortWorkspaceObservation records workspace activation, first-value timing, and retention activity
// for analytics_event_taxonomy.md §6.
type CohortWorkspaceObservation struct {
	WorkspaceID            string
	IsDemo                 bool
	IsTest                 bool
	IsInternal             bool
	EligibleForWeekN       bool
	CensoredBeforeWeekN    bool
	Activated              bool
	FirstValueSeconds      *int64 // nil if workspace never reached first_value
	RealDomainActionsCount int64  // real domain mutations (orders, scripts, reconciliations, etc.)
	EvidenceReviewsCount   int64  // evidence/proof reviews
	LoginOrPageViewsCount  int64  // logins/page views alone do NOT count as operator retention
}

// CohortOperatingLoopObservation records a linked content/publish loop for weekly_proofed_operating_loops.
type CohortOperatingLoopObservation struct {
	PublishItemID               string
	WorkspaceID                 string
	IsDemo                      bool
	HasAttributedCompletedOrder bool
	HasVersionedProfitSnapshot  bool
	HasReviewedEvidence         bool
	HasUnresolvedGap            bool // if true, excluded from proof-complete subset
}

// CohortImportBatchObservation records an imported batch/report for repair_burden.
type CohortImportBatchObservation struct {
	BatchID                      string
	WorkspaceID                  string
	IsDemo                       bool
	OperatorRepairSeconds        *int64 // nil if time tracking is unavailable -> remains unknown, never zero
	UnresolvedRequiredComponents int64
}

// CohortGenerationAttemptObservation records a production attempt for usable_production_yield & cost_per_accepted_output.
type CohortGenerationAttemptObservation struct {
	OperationID        string
	WorkspaceID        string
	IsDemo             bool
	Mode               string
	Provider           string
	QuoteVersion       string
	IsPreview          bool // previews excluded from usable_production_yield denominator
	IsTerminal         bool // true for completed or failed terminal attempts
	IsCancelled        bool // cancellations tracked separately
	IsAcceptedUsable   bool
	ActualProviderCost tenantdb.ExactDecimal // includes failed paid attempts!
	RenderStorageCost  tenantdb.ExactDecimal
}

// CohortEconomicsInput aggregates observations for a billing/operating cohort.
type CohortEconomicsInput struct {
	CohortID                        string
	ObservationWindow               string
	Currency                        string
	AllocationMethod                string
	Workspaces                      []CohortWorkspaceObservation
	OperatingLoops                  []CohortOperatingLoopObservation
	ImportBatches                   []CohortImportBatchObservation
	GenerationAttempts              []CohortGenerationAttemptObservation
	RecognizedSubscriptionRevenue   tenantdb.ExactDecimal
	RecognizedTopUpRevenue          tenantdb.ExactDecimal
	AllocatedComputeStorageCost     tenantdb.ExactDecimal
	AllocatedPaymentRefundCost      tenantdb.ExactDecimal
	AttributedSupportCost           tenantdb.ExactDecimal
	AdditionalUnknownCostItemsCount int64
}

// CohortEconomicsSummary holds the 7 canonical product validation & cohort economics metrics
// defined in docs/06_quality_ops/analytics_event_taxonomy.md §6.
type CohortEconomicsSummary struct {
	CohortID                          string
	ObservationWindow                 string
	Currency                          string
	EligibleWorkspacesCount           int64
	CensoredWorkspacesCount           int64
	ExcludedDemoTestInternalCount     int64
	MedianFirstValueSeconds           string
	WeeklyProofedOperatingLoops       int64
	WeeklyOperatorRetentionPct        string
	MedianRepairBurdenSeconds         string
	IsRepairTimeUnknown               bool
	UnresolvedRequiredComponentsCount int64
	UsableProductionYieldPct          string
	AcceptedOutputsCount              int64
	TerminalGenerationAttemptsCount   int64
	CostPerAcceptedOutput             tenantdb.ExactDecimal
	IsCostPerAcceptedOutputUndefined  bool
	RecognizedRevenue                 tenantdb.ExactDecimal
	AllocatedProviderCost             tenantdb.ExactDecimal
	AllocatedComputeStorageCost       tenantdb.ExactDecimal
	AllocatedPaymentRefundSupportCost tenantdb.ExactDecimal
	NetUnitEconomics                  tenantdb.ExactDecimal
	AllocationMethod                  string
	UnknownCostItemsCount             int64
}

var (
	reportStateMu sync.Mutex
	savedReports  = make(map[string][]FinancialReport) // workspaceID -> reports
	exportCounts  = make(map[string]int)               // workspaceID:YYYY-MM -> count
)

// GetCanonicalReportTemplates returns the 6 standard financial report templates (W087).
func (s *Service) GetCanonicalReportTemplates() []ReportTemplateSummary {
	out := make([]ReportTemplateSummary, len(canonicalReportTemplates))
	copy(out, canonicalReportTemplates)
	return out
}

// MonthlyReportExportLimit returns the canonical monthly report export limit for a subscription tier
// per docs/01_business/pricing_and_credits.md §1.2:
//   - Free: 0
//   - Starter: 5/mo
//   - Pro / Business / Enterprise: -1 (Unlimited)
func MonthlyReportExportLimit(tier string) int {
	switch strings.ToLower(strings.TrimSpace(tier)) {
	case "free":
		return 0
	case "starter":
		return 5
	case "pro", "business", "enterprise":
		return -1
	default:
		return -1
	}
}

// GenerateFinancialReport generates a P&L, channel, cost, margin, tax, or product report with trust annotations.
func (s *Service) GenerateFinancialReport(
	ctx context.Context,
	workspaceID string,
	reportType string,
	periodStart string,
	periodEnd string,
	groupBy string,
	cohortInput *CohortEconomicsInput,
) (*FinancialReport, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, ErrMissingTenant
	}
	if periodStart != "" && periodEnd != "" && periodEnd < periodStart {
		return nil, ErrInvalidReportPeriod
	}
	if reportType == "" {
		reportType = "pnl_statement"
	}
	if groupBy == "" {
		groupBy = "monthly"
	}

	snap, err := s.GetOrComputeProfitSnapshot(ctx, workspaceID, "workspace", workspaceID, periodStart, periodEnd, false)
	if err != nil {
		return nil, err
	}

	hundred := tenantdb.MustParseExactDecimal("100")
	pctOfRev := func(amt tenantdb.ExactDecimal) string {
		if snap.GrossRevenue.IsZero() {
			return "0.000000"
		}
		absAmt := amt
		if absAmt.IsNegative() {
			absAmt = absAmt.Neg()
		}
		num, err := absAmt.Mul(hundred)
		if err != nil {
			return "0.000000"
		}
		q, err := num.QuoRoundHalfUp(snap.GrossRevenue)
		if err != nil {
			return "0.000000"
		}
		return q.Fixed6String()
	}

	grossProfit, _ := snap.GrossRevenue.Sub(snap.COGS)
	totalOpEx, _ := snap.PlatformFees.Add(snap.ShippingCosts)
	totalOpEx, _ = totalOpEx.Add(snap.AffiliateCommissions)
	totalOpEx, _ = totalOpEx.Add(snap.AdsSpend)
	totalOpEx, _ = totalOpEx.Add(snap.AICreditCosts)
	totalOpEx, _ = totalOpEx.Add(snap.SeedingCosts)
	totalOpEx, _ = totalOpEx.Add(snap.RefundDeductions)
	totalOpEx, _ = totalOpEx.Add(snap.OtherCosts)

	lineItems := []FinancialReportLineItem{
		{
			Key:          "revenue",
			Label:        "Doanh thu gộp (Gross Revenue)",
			Amount:       snap.GrossRevenue,
			Currency:     snap.Currency,
			PctOfRevenue: pctOfRev(snap.GrossRevenue),
			SourceClass:  SourceClassOfficial,
			Confidence:   snap.Confidence,
			IsSubtotal:   false,
		},
		{
			Key:          "cogs",
			Label:        "Giá vốn hàng bán (COGS)",
			Amount:       snap.COGS.Neg(),
			Currency:     snap.Currency,
			PctOfRevenue: pctOfRev(snap.COGS),
			SourceClass:  SourceClassImported,
			Confidence:   snap.Confidence,
			IsSubtotal:   false,
		},
		{
			Key:          "gross_profit",
			Label:        "Lợi nhuận gộp (Gross Profit)",
			Amount:       grossProfit,
			Currency:     snap.Currency,
			PctOfRevenue: pctOfRev(grossProfit),
			SourceClass:  SourceClassOfficial,
			Confidence:   snap.Confidence,
			IsSubtotal:   true,
		},
		{
			Key:          "platform_fee",
			Label:        "Phí nền tảng (Platform Fees)",
			Amount:       snap.PlatformFees.Neg(),
			Currency:     snap.Currency,
			PctOfRevenue: pctOfRev(snap.PlatformFees),
			SourceClass:  SourceClassOfficial,
			Confidence:   snap.Confidence,
			IsSubtotal:   false,
		},
		{
			Key:          "shipping",
			Label:        "Chi phí vận chuyển (Shipping Costs)",
			Amount:       snap.ShippingCosts.Neg(),
			Currency:     snap.Currency,
			PctOfRevenue: pctOfRev(snap.ShippingCosts),
			SourceClass:  SourceClassOfficial,
			Confidence:   snap.Confidence,
			IsSubtotal:   false,
		},
		{
			Key:          "ai_credits",
			Label:        "Chi phí AI Credits (AI Credit Costs)",
			Amount:       snap.AICreditCosts.Neg(),
			Currency:     snap.Currency,
			PctOfRevenue: pctOfRev(snap.AICreditCosts),
			SourceClass:  SourceClassOfficial,
			Confidence:   snap.Confidence,
			IsSubtotal:   false,
		},
		{
			Key:          "operating_expenses",
			Label:        "Tổng chi phí vận hành (Operating Expenses)",
			Amount:       totalOpEx.Neg(),
			Currency:     snap.Currency,
			PctOfRevenue: pctOfRev(totalOpEx),
			SourceClass:  SourceClassOfficial,
			Confidence:   snap.Confidence,
			IsSubtotal:   true,
		},
		{
			Key:          "net_profit",
			Label:        "Lợi nhuận ròng (Net Profit)",
			Amount:       snap.NetProfit,
			Currency:     snap.Currency,
			PctOfRevenue: pctOfRev(snap.NetProfit),
			SourceClass:  SourceClassOfficial,
			Confidence:   snap.Confidence,
			IsSubtotal:   true,
		},
	}

	// Compute reconciled coverage percentage from SourceClassMix.
	reconciledPct := tenantdb.MustParseExactDecimal("100")
	lowTrust := snap.IsIncomplete || snap.Confidence == ConfidenceLow || snap.Confidence == ConfidenceLowMedium
	if len(snap.SourceClassMix) > 0 {
		estPct := tenantdb.ZeroDecimal()
		if v, ok := snap.SourceClassMix[SourceClassEstimated]; ok {
			estPct, _ = estPct.Add(v)
		}
		if v, ok := snap.SourceClassMix[SourceClassUnreconciled]; ok {
			estPct, _ = estPct.Add(v)
		}
		rem, err := hundred.Sub(estPct)
		if err == nil && !rem.IsNegative() {
			reconciledPct = rem
		}
		if estPct.Cmp(tenantdb.MustParseExactDecimal("30")) > 0 {
			lowTrust = true
		}
	}

	disclaimer := ""
	if reportType == "tax_summary" {
		disclaimer = CanonicalTaxDisclaimer
	}

	var cohortSummary *CohortEconomicsSummary
	if cohortInput != nil {
		cs, err := ComputeCohortEconomics(*cohortInput)
		if err != nil {
			return nil, err
		}
		cohortSummary = cs
	}

	now := time.Now().UTC()
	rep := FinancialReport{
		ReportID:              fmt.Sprintf("rep_%s_%d", workspaceID, now.UnixNano()),
		WorkspaceID:           workspaceID,
		ReportType:            reportType,
		PeriodStart:           periodStart,
		PeriodEnd:             periodEnd,
		GroupBy:               groupBy,
		Currency:              snap.Currency,
		LineItems:             lineItems,
		Snapshot:              snap,
		ReconciledCoveragePct: reconciledPct.Fixed6String(),
		LowTrustWarning:       lowTrust,
		TaxDisclaimer:         disclaimer,
		CohortEconomics:       cohortSummary,
		GeneratedAt:           now,
	}

	reportStateMu.Lock()
	savedReports[workspaceID] = append(savedReports[workspaceID], rep)
	reportStateMu.Unlock()

	return &rep, nil
}

// ListSavedFinancialReports returns generated reports cached for a workspace.
func (s *Service) ListSavedFinancialReports(workspaceID string) []FinancialReport {
	reportStateMu.Lock()
	defer reportStateMu.Unlock()
	list := savedReports[workspaceID]
	out := make([]FinancialReport, len(list))
	copy(out, list)
	return out
}

// ExportFinancialReport enforces tier report export quotas (Free=0, Starter=5/mo, Pro+=Unlimited)
// and generates a verifiable export artifact with SHA-512 content hash.
func (s *Service) ExportFinancialReport(
	ctx context.Context,
	workspaceID string,
	reportType string,
	format string,
	periodStart string,
	periodEnd string,
	subscriptionTier string,
	isTaxExport bool,
) (*ReportExportResult, error) {
	if strings.TrimSpace(workspaceID) == "" {
		return nil, ErrMissingTenant
	}
	limit := MonthlyReportExportLimit(subscriptionTier)
	if limit == 0 {
		return nil, ErrReportExportTierForbidden
	}

	if format == "" {
		format = "csv"
	}
	if isTaxExport {
		reportType = "tax_summary"
	}

	rep, err := s.GenerateFinancialReport(ctx, workspaceID, reportType, periodStart, periodEnd, "monthly", nil)
	if err != nil {
		return nil, err
	}
	if isTaxExport && rep.TaxDisclaimer == "" {
		rep.TaxDisclaimer = CanonicalTaxDisclaimer
	}

	monthKey := time.Now().UTC().Format("2006-01")
	if len(periodStart) >= 7 {
		monthKey = periodStart[:7]
	}
	quotaKey := workspaceID + ":" + monthKey

	reportStateMu.Lock()
	used := exportCounts[quotaKey]
	if limit > 0 && used >= limit {
		reportStateMu.Unlock()
		return nil, ErrReportExportQuotaExceeded
	}
	used++
	exportCounts[quotaKey] = used
	reportStateMu.Unlock()

	payloadBytes, _ := json.Marshal(struct {
		ReportID              string                  `json:"report_id"`
		WorkspaceID           string                  `json:"workspace_id"`
		ReportType            string                  `json:"report_type"`
		Format                string                  `json:"format"`
		PeriodStart           string                  `json:"period_start"`
		PeriodEnd             string                  `json:"period_end"`
		NetProfit             string                  `json:"net_profit"`
		ReconciledCoveragePct string                  `json:"reconciled_coverage_pct"`
		TaxResponsibilityMode string                  `json:"tax_responsibility_mode"`
		TaxDisclaimer         string                  `json:"tax_disclaimer"`
		LineItemsCount        int                     `json:"line_items_count"`
		SourceClassMix        map[string]ExactDecimal `json:"-"`
	}{
		ReportID:              rep.ReportID,
		WorkspaceID:           workspaceID,
		ReportType:            rep.ReportType,
		Format:                format,
		PeriodStart:           periodStart,
		PeriodEnd:             periodEnd,
		NetProfit:             rep.Snapshot.NetProfit.Fixed6String(),
		ReconciledCoveragePct: rep.ReconciledCoveragePct,
		TaxResponsibilityMode: CanonicalTaxResponsibilityMode,
		TaxDisclaimer:         rep.TaxDisclaimer,
		LineItemsCount:        len(rep.LineItems),
	})
	sum512 := sha512.Sum512(payloadBytes)
	hashHex := hex.EncodeToString(sum512[:])

	exportID := fmt.Sprintf("exp_%s_%d", workspaceID, time.Now().UTC().UnixNano())
	fileURL := fmt.Sprintf("https://exports.creativanta.internal/%s/%s.%s", workspaceID, exportID, format)

	return &ReportExportResult{
		ExportID:              exportID,
		Format:                format,
		FileURL:               fileURL,
		ContentHashSHA512:     hashHex,
		MonthlyExportsUsed:    used,
		MonthlyExportsLimit:   limit,
		TaxResponsibilityMode: CanonicalTaxResponsibilityMode,
		TaxDisclaimer:         CanonicalTaxDisclaimer,
		Report:                rep,
	}, nil
}

type ExactDecimal = tenantdb.ExactDecimal

// ComputeCohortEconomics computes the 7 canonical product validation & cohort economics metrics
// from docs/06_quality_ops/analytics_event_taxonomy.md §6 using exact NUMERIC(18,6) arithmetic.
//
// Rules enforced:
//  1. Excludes demo, test, and internal accounts from all customer cohort metrics.
//  2. Deduplicates workspaces by WorkspaceID, operating loops by PublishItemID, and generation attempts by OperationID.
//  3. Login/page-view activity alone does NOT count as weekly_operator_retention.
//  4. Missing operator repair time tracking remains IsRepairTimeUnknown = true ("unknown"), never zero.
//  5. Zero accepted outputs results in IsCostPerAcceptedOutputUndefined = true, never zero cost.
//  6. Net unit economics subtracts provider, compute/storage, payment/refund, and attributed support costs from
//     net recognized subscription + top-up revenue and surfaces allocation method and unknown cost counts.
func ComputeCohortEconomics(in CohortEconomicsInput) (*CohortEconomicsSummary, error) {
	currency := strings.TrimSpace(in.Currency)
	if currency == "" {
		currency = "USD"
	}
	allocMethod := strings.TrimSpace(in.AllocationMethod)
	if allocMethod == "" {
		allocMethod = "direct_workspace_meter_plus_cohort_pro_rata"
	}

	var (
		eligibleWorkspaces   int64
		censoredWorkspaces   int64
		excludedDemoTestIntl int64
		retainedWorkspaces   int64
		firstValueSamples    []int64
	)

	seenWorkspaces := make(map[string]bool)
	demoWorkspaces := make(map[string]bool)

	for _, w := range in.Workspaces {
		wsID := strings.TrimSpace(w.WorkspaceID)
		if wsID == "" || seenWorkspaces[wsID] {
			continue
		}
		seenWorkspaces[wsID] = true

		if w.IsDemo || w.IsTest || w.IsInternal {
			excludedDemoTestIntl++
			demoWorkspaces[wsID] = true
			continue
		}
		if w.CensoredBeforeWeekN {
			censoredWorkspaces++
		}
		if w.Activated && w.FirstValueSeconds != nil && *w.FirstValueSeconds >= 0 {
			firstValueSamples = append(firstValueSamples, *w.FirstValueSeconds)
		}
		if w.Activated && w.EligibleForWeekN && !w.CensoredBeforeWeekN {
			eligibleWorkspaces++
			// Only real domain actions or evidence reviews count for retention (never login/page views alone!).
			if w.RealDomainActionsCount > 0 || w.EvidenceReviewsCount > 0 {
				retainedWorkspaces++
			}
		}
	}

	medianFirstValue := "unknown"
	if len(firstValueSamples) > 0 {
		medianFirstValue = computeMedianInt64AsFixed6(firstValueSamples)
	}

	hundred := tenantdb.MustParseExactDecimal("100")
	retentionPct := "0.000000"
	if eligibleWorkspaces > 0 {
		num, err := tenantdb.NewExactDecimalFromInt64(retainedWorkspaces).Mul(hundred)
		if err == nil {
			q, err := num.QuoRoundHalfUp(tenantdb.NewExactDecimalFromInt64(eligibleWorkspaces))
			if err == nil {
				retentionPct = q.Fixed6String()
			}
		}
	}

	// 2. weekly_proofed_operating_loops: deduplicate by PublishItemID; exclude demo and unresolved gaps.
	seenLoops := make(map[string]bool)
	var proofedLoops int64
	for _, loop := range in.OperatingLoops {
		pid := strings.TrimSpace(loop.PublishItemID)
		if pid == "" || seenLoops[pid] {
			continue
		}
		seenLoops[pid] = true
		if loop.IsDemo || demoWorkspaces[loop.WorkspaceID] {
			continue
		}
		if loop.HasAttributedCompletedOrder &&
			loop.HasVersionedProfitSnapshot &&
			loop.HasReviewedEvidence &&
			!loop.HasUnresolvedGap {
			proofedLoops++
		}
	}

	// 4. repair_burden: median operator repair seconds + unresolved required components.
	seenBatches := make(map[string]bool)
	var (
		repairTimeSamples        []int64
		unresolvedComponentsSum  int64
		missingRepairTimeBatches int64
	)
	for _, b := range in.ImportBatches {
		bid := strings.TrimSpace(b.BatchID)
		if bid == "" || seenBatches[bid] {
			continue
		}
		seenBatches[bid] = true
		if b.IsDemo || demoWorkspaces[b.WorkspaceID] {
			continue
		}
		unresolvedComponentsSum += b.UnresolvedRequiredComponents
		if b.OperatorRepairSeconds != nil && *b.OperatorRepairSeconds >= 0 {
			repairTimeSamples = append(repairTimeSamples, *b.OperatorRepairSeconds)
		} else {
			missingRepairTimeBatches++
		}
	}

	isRepairTimeUnknown := len(repairTimeSamples) == 0
	medianRepairSeconds := "unknown"
	if !isRepairTimeUnknown {
		medianRepairSeconds = computeMedianInt64AsFixed6(repairTimeSamples)
	}

	// 5 & 6. usable_production_yield & cost_per_accepted_output.
	seenOps := make(map[string]bool)
	var (
		acceptedOutputs  int64
		terminalAttempts int64
		totalProvider    = tenantdb.ZeroDecimal()
		totalRenderStore = tenantdb.ZeroDecimal()
	)
	for _, att := range in.GenerationAttempts {
		opID := strings.TrimSpace(att.OperationID)
		if opID == "" || seenOps[opID] {
			continue
		}
		seenOps[opID] = true
		if att.IsDemo || demoWorkspaces[att.WorkspaceID] {
			continue
		}
		// Always accumulate actual provider & render/storage costs (including failed paid attempts).
		var err error
		totalProvider, err = totalProvider.Add(att.ActualProviderCost)
		if err != nil {
			return nil, err
		}
		totalRenderStore, err = totalRenderStore.Add(att.RenderStorageCost)
		if err != nil {
			return nil, err
		}

		// Previews and non-terminal/cancelled attempts are excluded from usable_production_yield denominator.
		if att.IsPreview || att.IsCancelled || !att.IsTerminal {
			continue
		}
		terminalAttempts++
		if att.IsAcceptedUsable {
			acceptedOutputs++
		}
	}

	yieldPct := "0.000000"
	if terminalAttempts > 0 {
		num, err := tenantdb.NewExactDecimalFromInt64(acceptedOutputs).Mul(hundred)
		if err == nil {
			q, err := num.QuoRoundHalfUp(tenantdb.NewExactDecimalFromInt64(terminalAttempts))
			if err == nil {
				yieldPct = q.Fixed6String()
			}
		}
	}

	totalOutputAllocatedCost, err := totalProvider.Add(totalRenderStore)
	if err != nil {
		return nil, err
	}
	costPerAccepted := tenantdb.ZeroDecimal()
	isCostUndefined := acceptedOutputs == 0
	if !isCostUndefined {
		costPerAccepted, err = totalOutputAllocatedCost.QuoRoundHalfUp(tenantdb.NewExactDecimalFromInt64(acceptedOutputs))
		if err != nil {
			return nil, err
		}
	}

	// 7. net_unit_economics:
	// RecognizedRevenue = RecognizedSubscriptionRevenue + RecognizedTopUpRevenue
	recognizedRev, err := in.RecognizedSubscriptionRevenue.Add(in.RecognizedTopUpRevenue)
	if err != nil {
		return nil, err
	}
	computeStorageCost, err := totalRenderStore.Add(in.AllocatedComputeStorageCost)
	if err != nil {
		return nil, err
	}
	payRefundSupportCost, err := in.AllocatedPaymentRefundCost.Add(in.AttributedSupportCost)
	if err != nil {
		return nil, err
	}
	totalCohortCost, err := totalProvider.Add(computeStorageCost)
	if err != nil {
		return nil, err
	}
	totalCohortCost, err = totalCohortCost.Add(payRefundSupportCost)
	if err != nil {
		return nil, err
	}
	netUnitEcon, err := recognizedRev.Sub(totalCohortCost)
	if err != nil {
		return nil, err
	}

	return &CohortEconomicsSummary{
		CohortID:                          in.CohortID,
		ObservationWindow:                 in.ObservationWindow,
		Currency:                          currency,
		EligibleWorkspacesCount:           eligibleWorkspaces,
		CensoredWorkspacesCount:           censoredWorkspaces,
		ExcludedDemoTestInternalCount:     excludedDemoTestIntl,
		MedianFirstValueSeconds:           medianFirstValue,
		WeeklyProofedOperatingLoops:       proofedLoops,
		WeeklyOperatorRetentionPct:        retentionPct,
		MedianRepairBurdenSeconds:         medianRepairSeconds,
		IsRepairTimeUnknown:               isRepairTimeUnknown,
		UnresolvedRequiredComponentsCount: unresolvedComponentsSum,
		UsableProductionYieldPct:          yieldPct,
		AcceptedOutputsCount:              acceptedOutputs,
		TerminalGenerationAttemptsCount:   terminalAttempts,
		CostPerAcceptedOutput:             costPerAccepted,
		IsCostPerAcceptedOutputUndefined:  isCostUndefined,
		RecognizedRevenue:                 recognizedRev,
		AllocatedProviderCost:             totalProvider,
		AllocatedComputeStorageCost:       computeStorageCost,
		AllocatedPaymentRefundSupportCost: payRefundSupportCost,
		NetUnitEconomics:                  netUnitEcon,
		AllocationMethod:                  allocMethod,
		UnknownCostItemsCount:             in.AdditionalUnknownCostItemsCount + missingRepairTimeBatches,
	}, nil
}

func computeMedianInt64AsFixed6(samples []int64) string {
	cp := make([]int64, len(samples))
	copy(cp, samples)
	sort.Slice(cp, func(i, j int) bool { return cp[i] < cp[j] })
	n := len(cp)
	if n%2 == 1 {
		return tenantdb.NewExactDecimalFromInt64(cp[n/2]).Fixed6String()
	}
	sum := cp[n/2-1] + cp[n/2]
	num := tenantdb.NewExactDecimalFromInt64(sum)
	q, err := num.QuoRoundHalfUp(tenantdb.NewExactDecimalFromInt64(2))
	if err != nil {
		return tenantdb.NewExactDecimalFromInt64(cp[n/2]).Fixed6String()
	}
	return q.Fixed6String()
}
