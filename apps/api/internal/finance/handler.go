package finance

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"

	"connectrpc.com/connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	financev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/finance/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/finance/v1/financev1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
	"google.golang.org/protobuf/types/known/timestamppb"
)

func resolveTenantContext(ctx context.Context, cmdCtx *commonv1.CommandContext) (string, error) {
	if session, ok := transportauth.PrincipalFromContext(ctx); ok && session.WorkspaceID != "" {
		if cmdCtx != nil && cmdCtx.WorkspaceId != nil && cmdCtx.WorkspaceId.Value != "" {
			if cmdCtx.WorkspaceId.Value != session.WorkspaceID && !session.InternalAdmin {
				return "", connect.NewError(connect.CodePermissionDenied, tenantdb.ErrScopeMismatch)
			}
		}
		return session.WorkspaceID, nil
	}
	if cmdCtx != nil && cmdCtx.WorkspaceId != nil && cmdCtx.WorkspaceId.Value != "" {
		return cmdCtx.WorkspaceId.Value, nil
	}
	return "", connect.NewError(connect.CodeUnauthenticated, ErrMissingTenant)
}

func toProtoConfidenceBand(band string) commonv1.ConfidenceBand {
	switch band {
	case ConfidenceHigh:
		return commonv1.ConfidenceBand_CONFIDENCE_BAND_HIGH
	case ConfidenceMediumHigh:
		return commonv1.ConfidenceBand_CONFIDENCE_BAND_MEDIUM_HIGH
	case ConfidenceMedium:
		return commonv1.ConfidenceBand_CONFIDENCE_BAND_MEDIUM
	case ConfidenceLowMedium:
		return commonv1.ConfidenceBand_CONFIDENCE_BAND_LOW_MEDIUM
	case ConfidenceLow:
		return commonv1.ConfidenceBand_CONFIDENCE_BAND_LOW
	default:
		return commonv1.ConfidenceBand_CONFIDENCE_BAND_UNSPECIFIED
	}
}

func toProtoSourceClass(sc string) commonv1.SourceClass {
	switch sc {
	case SourceClassOfficial:
		return commonv1.SourceClass_SOURCE_CLASS_OFFICIAL
	case SourceClassImported:
		return commonv1.SourceClass_SOURCE_CLASS_IMPORTED
	case SourceClassInferred:
		return commonv1.SourceClass_SOURCE_CLASS_INFERRED
	case SourceClassEstimated:
		return commonv1.SourceClass_SOURCE_CLASS_ESTIMATED
	case SourceClassUnreconciled:
		return commonv1.SourceClass_SOURCE_CLASS_UNRECONCILED
	default:
		return commonv1.SourceClass_SOURCE_CLASS_UNSPECIFIED
	}
}

func fromProtoConfidenceBand(band commonv1.ConfidenceBand) string {
	switch band {
	case commonv1.ConfidenceBand_CONFIDENCE_BAND_HIGH:
		return ConfidenceHigh
	case commonv1.ConfidenceBand_CONFIDENCE_BAND_MEDIUM_HIGH:
		return ConfidenceMediumHigh
	case commonv1.ConfidenceBand_CONFIDENCE_BAND_MEDIUM:
		return ConfidenceMedium
	case commonv1.ConfidenceBand_CONFIDENCE_BAND_LOW_MEDIUM:
		return ConfidenceLowMedium
	case commonv1.ConfidenceBand_CONFIDENCE_BAND_LOW:
		return ConfidenceLow
	default:
		return ConfidenceMedium
	}
}

func fromProtoSourceClass(sc commonv1.SourceClass) string {
	switch sc {
	case commonv1.SourceClass_SOURCE_CLASS_OFFICIAL:
		return SourceClassOfficial
	case commonv1.SourceClass_SOURCE_CLASS_IMPORTED:
		return SourceClassImported
	case commonv1.SourceClass_SOURCE_CLASS_INFERRED:
		return SourceClassInferred
	case commonv1.SourceClass_SOURCE_CLASS_ESTIMATED:
		return SourceClassEstimated
	case commonv1.SourceClass_SOURCE_CLASS_UNRECONCILED:
		return SourceClassUnreconciled
	default:
		return SourceClassImported
	}
}

func toProtoReconciliationState(state string) financev1.ReconciliationState {
	switch state {
	case ReconciliationImportedOnly:
		return financev1.ReconciliationState_RECONCILIATION_STATE_IMPORTED_ONLY
	case ReconciliationAwaitingEvidence:
		return financev1.ReconciliationState_RECONCILIATION_STATE_AWAITING_EVIDENCE
	case ReconciliationInferredPendingConfirmation:
		return financev1.ReconciliationState_RECONCILIATION_STATE_INFERRED_PENDING_CONFIRMATION
	case ReconciliationPartiallyReconciled:
		return financev1.ReconciliationState_RECONCILIATION_STATE_PARTIALLY_RECONCILED
	case ReconciliationFullyReconciled:
		return financev1.ReconciliationState_RECONCILIATION_STATE_FULLY_RECONCILED
	case ReconciliationConflictDetected:
		return financev1.ReconciliationState_RECONCILIATION_STATE_CONFLICT_DETECTED
	case ReconciliationManuallyOverridden:
		return financev1.ReconciliationState_RECONCILIATION_STATE_MANUALLY_OVERRIDDEN
	default:
		return financev1.ReconciliationState_RECONCILIATION_STATE_UNSPECIFIED
	}
}

func toProtoSettlementState(state string) financev1.SettlementState {
	switch state {
	case SettlementStateImported:
		return financev1.SettlementState_SETTLEMENT_STATE_IMPORTED
	case SettlementStateNormalized:
		return financev1.SettlementState_SETTLEMENT_STATE_NORMALIZED
	case SettlementStateReadyForMatching:
		return financev1.SettlementState_SETTLEMENT_STATE_READY_FOR_MATCHING
	case SettlementStateArchived:
		return financev1.SettlementState_SETTLEMENT_STATE_ARCHIVED
	default:
		return financev1.SettlementState_SETTLEMENT_STATE_UNSPECIFIED
	}
}

func toProtoCostState(state string) financev1.CostState {
	switch state {
	case CostStateRecorded:
		return financev1.CostState_COST_STATE_RECORDED
	case CostStatePendingEvidence:
		return financev1.CostState_COST_STATE_PENDING_EVIDENCE
	case CostStateReconciled:
		return financev1.CostState_COST_STATE_RECONCILED
	case CostStateEstimated:
		return financev1.CostState_COST_STATE_ESTIMATED
	case CostStateSuperseded:
		return financev1.CostState_COST_STATE_SUPERSEDED
	default:
		return financev1.CostState_COST_STATE_UNSPECIFIED
	}
}

func toProtoSnapshot(s *ProfitSnapshot) *financev1.ProfitSnapshot {
	if s == nil {
		return nil
	}
	mixJSON, _ := json.Marshal(s.SourceClassMix)
	marginStr := ""
	if s.MarginPct != nil {
		marginStr = s.MarginPct.String()
	}

	return &financev1.ProfitSnapshot{
		SnapshotId:                     s.SnapshotID,
		WorkspaceId:                    s.WorkspaceID,
		ScopeType:                      s.ScopeType,
		ScopeId:                        s.ScopeID,
		PeriodStart:                    s.PeriodStart,
		PeriodEnd:                      s.PeriodEnd,
		GrossRevenue:                   &commonv1.Money{Amount: s.GrossRevenue.Fixed6String(), Currency: s.Currency},
		PlatformFees:                   &commonv1.Money{Amount: s.PlatformFees.Fixed6String(), Currency: s.Currency},
		ShippingCosts:                  &commonv1.Money{Amount: s.ShippingCosts.Fixed6String(), Currency: s.Currency},
		AffiliateCommissions:           &commonv1.Money{Amount: s.AffiliateCommissions.Fixed6String(), Currency: s.Currency},
		RefundDeductions:               &commonv1.Money{Amount: s.RefundDeductions.Fixed6String(), Currency: s.Currency},
		Cogs:                           &commonv1.Money{Amount: s.COGS.Fixed6String(), Currency: s.Currency},
		AdsSpend:                       &commonv1.Money{Amount: s.AdsSpend.Fixed6String(), Currency: s.Currency},
		AiCreditCosts:                  &commonv1.Money{Amount: s.AICreditCosts.Fixed6String(), Currency: s.Currency},
		SeedingCosts:                   &commonv1.Money{Amount: s.SeedingCosts.Fixed6String(), Currency: s.Currency},
		OtherCosts:                     &commonv1.Money{Amount: s.OtherCosts.Fixed6String(), Currency: s.Currency},
		NetProfit:                      &commonv1.Money{Amount: s.NetProfit.Fixed6String(), Currency: s.Currency},
		MarginPct:                      marginStr,
		SourceClassMixJson:             string(mixJSON),
		Confidence:                     toProtoConfidenceBand(s.Confidence),
		FreshnessAt:                    timestamppb.New(s.FreshnessAt),
		Currency:                       s.Currency,
		CreatedAt:                      timestamppb.New(s.CreatedAt),
		IsIncomplete:                   s.IsIncomplete,
		UnknownRequiredComponentsCount: int32(s.UnknownRequiredComponentsCount),
		PendingRevenue:                 &commonv1.Money{Amount: s.PendingRevenue.Fixed6String(), Currency: s.Currency},
		UnreconciledAmount:             &commonv1.Money{Amount: s.UnreconciledAmount.Fixed6String(), Currency: s.Currency},
		UnreconciledCount:              int32(s.UnreconciledCount),
	}
}

func toProtoSettlementLine(l *SettlementLine) *financev1.SettlementLine {
	if l == nil {
		return nil
	}
	return &financev1.SettlementLine{
		LineId:              l.LineID,
		WorkspaceId:         l.WorkspaceID,
		SettlementId:        l.SettlementID,
		ExternalLineId:      l.ExternalLineID,
		ExternalOrderId:     l.ExternalOrderID,
		OrderId:             l.OrderID,
		GrossAmount:         &commonv1.Money{Amount: l.GrossAmount.Fixed6String(), Currency: l.Currency},
		FeeAmount:           &commonv1.Money{Amount: l.FeeAmount.Fixed6String(), Currency: l.Currency},
		RefundAmount:        &commonv1.Money{Amount: l.RefundAmount.Fixed6String(), Currency: l.Currency},
		NetAmount:           &commonv1.Money{Amount: l.NetAmount.Fixed6String(), Currency: l.Currency},
		MatchedAmount:       &commonv1.Money{Amount: l.MatchedAmount.Fixed6String(), Currency: l.Currency},
		Currency:            l.Currency,
		ReconciliationState: toProtoReconciliationState(l.ReconciliationState),
		CreatedAt:           timestamppb.New(l.CreatedAt),
	}
}

func toProtoSettlement(s *Settlement) *financev1.Settlement {
	if s == nil {
		return nil
	}
	feesJSON, _ := json.Marshal(s.Fees)
	dedJSON, _ := json.Marshal(s.Deductions)

	var protoLines []*financev1.SettlementLine
	for _, l := range s.Lines {
		protoLines = append(protoLines, toProtoSettlementLine(&l))
	}

	return &financev1.Settlement{
		SettlementId:         s.SettlementID,
		WorkspaceId:          s.WorkspaceID,
		SourceClass:          toProtoSourceClass(s.SourceClass),
		SourcePlatform:       s.SourcePlatform,
		ExternalSettlementId: s.ExternalSettlementID,
		ConnectedAccountId:   s.ConnectedAccountID,
		ExchangeRate: &financev1.ExchangeRateSnapshot{
			BaseCurrency:  s.ExchangeRateSnapshot.BaseCurrency,
			QuoteCurrency: s.ExchangeRateSnapshot.QuoteCurrency,
			RateToBase:    s.ExchangeRateSnapshot.RateToBase,
			Provider:      s.ExchangeRateSnapshot.Provider,
			CapturedAt:    timestamppb.New(s.ExchangeRateSnapshot.CapturedAt),
			EffectiveAt:   timestamppb.New(s.ExchangeRateSnapshot.EffectiveAt),
			SourceClass:   toProtoSourceClass(s.ExchangeRateSnapshot.SourceClass),
		},
		ImportFingerprint:   s.ImportFingerprint,
		GrossAmount:         &commonv1.Money{Amount: s.GrossAmount.Fixed6String(), Currency: s.Currency},
		NetAmount:           &commonv1.Money{Amount: s.NetAmount.Fixed6String(), Currency: s.Currency},
		FeesJson:            string(feesJSON),
		DeductionsJson:      string(dedJSON),
		Currency:            s.Currency,
		SettlementState:     toProtoSettlementState(s.SettlementState),
		ReconciliationState: toProtoReconciliationState(s.ReconciliationState),
		RelatedOrderIds:     s.RelatedOrderIDs,
		EffectiveDate:       s.EffectiveDate,
		CreatedAt:           timestamppb.New(s.CreatedAt),
		UpdatedAt:           timestamppb.New(s.UpdatedAt),
		Lines:               protoLines,
	}
}

func toProtoCostItem(item *CostItem) *financev1.CostItem {
	if item == nil {
		return nil
	}
	return &financev1.CostItem{
		CostItemId:       item.CostItemID,
		WorkspaceId:      item.WorkspaceID,
		CostType:         item.CostType,
		Amount:           &commonv1.Money{Amount: item.Amount.Fixed6String(), Currency: item.Currency},
		Description:      item.Description,
		RelatedScopeType: item.RelatedScopeType,
		RelatedScopeId:   item.RelatedScopeID,
		SourceClass:      toProtoSourceClass(item.SourceClass),
		EvidenceId:       item.EvidenceID,
		ConfidenceReason: item.ConfidenceReason,
		CostState:        toProtoCostState(item.CostState),
		EffectiveDate:    item.EffectiveDate,
		CreatedAt:        timestamppb.New(item.CreatedAt),
		UpdatedAt:        timestamppb.New(item.UpdatedAt),
	}
}

// ============================================================================
// ProfitService Handler
// ============================================================================

type ProfitHandler struct {
	service *Service
}

func NewProfitHandler(service *Service) *ProfitHandler {
	return &ProfitHandler{service: service}
}

var _ financev1connect.ProfitServiceHandler = (*ProfitHandler)(nil)

func (h *ProfitHandler) GetSummary(ctx context.Context, req *connect.Request[financev1.ProfitServiceGetSummaryRequest]) (*connect.Response[financev1.ProfitServiceGetSummaryResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, nil)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}

	snap, err := h.service.GetOrComputeProfitSnapshot(ctx, wsID, req.Msg.ScopeType, req.Msg.ScopeId, req.Msg.PeriodStart, req.Msg.PeriodEnd, false)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	compBreakdown := map[string]string{
		"gross_revenue":         snap.GrossRevenue.Fixed6String(),
		"platform_fees":         snap.PlatformFees.Fixed6String(),
		"shipping_costs":        snap.ShippingCosts.Fixed6String(),
		"cogs":                  snap.COGS.Fixed6String(),
		"ai_credit_costs":       snap.AICreditCosts.Fixed6String(),
		"affiliate_commissions": snap.AffiliateCommissions.Fixed6String(),
		"ads_spend":             snap.AdsSpend.Fixed6String(),
		"seeding_costs":         snap.SeedingCosts.Fixed6String(),
		"refund_deductions":     snap.RefundDeductions.Fixed6String(),
		"other_costs":           snap.OtherCosts.Fixed6String(),
		"net_profit":            snap.NetProfit.Fixed6String(),
	}

	return connect.NewResponse(&financev1.ProfitServiceGetSummaryResponse{
		Snapshot:           toProtoSnapshot(snap),
		ComponentBreakdown: compBreakdown,
	}), nil
}

func (h *ProfitHandler) DrillDown(ctx context.Context, req *connect.Request[financev1.ProfitServiceDrillDownRequest]) (*connect.Response[financev1.ProfitServiceDrillDownResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, nil)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}

	snap, err := h.service.GetOrComputeProfitSnapshot(ctx, wsID, req.Msg.ScopeType, req.Msg.ScopeId, req.Msg.PeriodStart, req.Msg.PeriodEnd, false)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var items []*financev1.ProfitDrillDownItem
	// Provide drilldown by cost types
	costItems := []struct {
		key, label string
		amount     tenantdb.ExactDecimal
	}{
		{"platform_fee", "Platform Fees", snap.PlatformFees},
		{"shipping", "Shipping Costs", snap.ShippingCosts},
		{"cogs", "Cost of Goods Sold", snap.COGS},
		{"ai_credits", "AI Credits", snap.AICreditCosts},
		{"commission", "Affiliate Commissions", snap.AffiliateCommissions},
		{"ads_spend", "Advertising", snap.AdsSpend},
		{"seeding", "Seeding & Samples", snap.SeedingCosts},
		{"refund", "Refund Deductions", snap.RefundDeductions},
	}

	for _, ci := range costItems {
		items = append(items, &financev1.ProfitDrillDownItem{
			Key:                ci.key,
			Label:              ci.label,
			Revenue:            &commonv1.Money{Amount: "0.000000", Currency: snap.Currency},
			Costs:              &commonv1.Money{Amount: ci.amount.Fixed6String(), Currency: snap.Currency},
			NetProfit:          &commonv1.Money{Amount: "-" + ci.amount.Fixed6String(), Currency: snap.Currency},
			Confidence:         toProtoConfidenceBand(snap.Confidence),
			PrimarySourceClass: commonv1.SourceClass_SOURCE_CLASS_OFFICIAL,
		})
	}

	return connect.NewResponse(&financev1.ProfitServiceDrillDownResponse{
		Items:    items,
		Currency: snap.Currency,
	}), nil
}

func (h *ProfitHandler) GetAnomalies(ctx context.Context, req *connect.Request[financev1.ProfitServiceGetAnomaliesRequest]) (*connect.Response[financev1.ProfitServiceGetAnomaliesResponse], error) {
	return connect.NewResponse(&financev1.ProfitServiceGetAnomaliesResponse{
		Anomalies: []*financev1.ProfitAnomaly{},
	}), nil
}

func (h *ProfitHandler) GetSnapshot(ctx context.Context, req *connect.Request[financev1.ProfitServiceGetSnapshotRequest]) (*connect.Response[financev1.ProfitServiceGetSnapshotResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, nil)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}

	if req.Msg.SnapshotId != "" {
		snap, err := h.service.store.GetSnapshot(ctx, wsID, req.Msg.SnapshotId)
		if err != nil {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return connect.NewResponse(&financev1.ProfitServiceGetSnapshotResponse{
			Snapshot: toProtoSnapshot(snap),
		}), nil
	}

	snap, err := h.service.GetOrComputeProfitSnapshot(ctx, wsID, req.Msg.ScopeType, req.Msg.ScopeId, req.Msg.PeriodStart, req.Msg.PeriodEnd, false)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}

	return connect.NewResponse(&financev1.ProfitServiceGetSnapshotResponse{
		Snapshot: toProtoSnapshot(snap),
	}), nil
}

func (h *ProfitHandler) RefreshSnapshot(ctx context.Context, req *connect.Request[financev1.ProfitServiceRefreshSnapshotRequest]) (*connect.Response[financev1.ProfitServiceRefreshSnapshotResponse], error) {
	wsID, err := resolveTenantContext(ctx, req.Msg.Context)
	if err != nil {
		return nil, err
	}

	snap, err := h.service.GetOrComputeProfitSnapshot(ctx, wsID, req.Msg.ScopeType, req.Msg.ScopeId, req.Msg.PeriodStart, req.Msg.PeriodEnd, true)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&financev1.ProfitServiceRefreshSnapshotResponse{
		Snapshot: toProtoSnapshot(snap),
	}), nil
}

func toProtoCohortEconomics(ce *CohortEconomicsSummary) *financev1.CohortEconomicsSummary {
	if ce == nil {
		return nil
	}
	costPerAccepted, _ := ce.CostPerAcceptedOutput.ToProtoMoney(ce.Currency, false)
	recRev, _ := ce.RecognizedRevenue.ToProtoMoney(ce.Currency, true)
	provCost, _ := ce.AllocatedProviderCost.ToProtoMoney(ce.Currency, false)
	compCost, _ := ce.AllocatedComputeStorageCost.ToProtoMoney(ce.Currency, false)
	payCost, _ := ce.AllocatedPaymentRefundSupportCost.ToProtoMoney(ce.Currency, false)
	netEcon, _ := ce.NetUnitEconomics.ToProtoMoney(ce.Currency, true)
	return &financev1.CohortEconomicsSummary{
		CohortId:                          ce.CohortID,
		ObservationWindow:                 ce.ObservationWindow,
		EligibleWorkspacesCount:           ce.EligibleWorkspacesCount,
		CensoredWorkspacesCount:           ce.CensoredWorkspacesCount,
		ExcludedDemoTestInternalCount:     ce.ExcludedDemoTestInternalCount,
		MedianFirstValueSeconds:           ce.MedianFirstValueSeconds,
		WeeklyProofedOperatingLoops:       ce.WeeklyProofedOperatingLoops,
		WeeklyOperatorRetentionPct:        ce.WeeklyOperatorRetentionPct,
		MedianRepairBurdenSeconds:         ce.MedianRepairBurdenSeconds,
		IsRepairTimeUnknown:               ce.IsRepairTimeUnknown,
		UnresolvedRequiredComponentsCount: ce.UnresolvedRequiredComponentsCount,
		UsableProductionYieldPct:          ce.UsableProductionYieldPct,
		AcceptedOutputsCount:              ce.AcceptedOutputsCount,
		TerminalGenerationAttemptsCount:   ce.TerminalGenerationAttemptsCount,
		CostPerAcceptedOutput:             costPerAccepted,
		IsCostPerAcceptedOutputUndefined:  ce.IsCostPerAcceptedOutputUndefined,
		RecognizedRevenue:                 recRev,
		AllocatedProviderCost:             provCost,
		AllocatedComputeStorageCost:       compCost,
		AllocatedPaymentRefundSupportCost: payCost,
		NetUnitEconomics:                  netEcon,
		AllocationMethod:                  ce.AllocationMethod,
		UnknownCostItemsCount:             ce.UnknownCostItemsCount,
	}
}

func toProtoFinancialReport(r *FinancialReport) *financev1.FinancialReport {
	if r == nil {
		return nil
	}
	var lines []*financev1.FinancialReportLineItem
	for _, li := range r.LineItems {
		amtMoney, _ := li.Amount.ToProtoMoney(li.Currency, true)
		lines = append(lines, &financev1.FinancialReportLineItem{
			Key:          li.Key,
			Label:        li.Label,
			Amount:       amtMoney,
			PctOfRevenue: li.PctOfRevenue,
			SourceClass:  toProtoSourceClass(li.SourceClass),
			Confidence:   toProtoConfidenceBand(li.Confidence),
			IsSubtotal:   li.IsSubtotal,
		})
	}
	return &financev1.FinancialReport{
		ReportId:              r.ReportID,
		WorkspaceId:           r.WorkspaceID,
		ReportType:            r.ReportType,
		PeriodStart:           r.PeriodStart,
		PeriodEnd:             r.PeriodEnd,
		GroupBy:               r.GroupBy,
		Currency:              r.Currency,
		LineItems:             lines,
		Snapshot:              toProtoSnapshot(r.Snapshot),
		ReconciledCoveragePct: r.ReconciledCoveragePct,
		LowTrustWarning:       r.LowTrustWarning,
		TaxDisclaimer:         r.TaxDisclaimer,
		CohortEconomics:       toProtoCohortEconomics(r.CohortEconomics),
		GeneratedAt:           timestamppb.New(r.GeneratedAt),
	}
}

func (h *ProfitHandler) GenerateReport(ctx context.Context, req *connect.Request[financev1.ProfitServiceGenerateReportRequest]) (*connect.Response[financev1.ProfitServiceGenerateReportResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, req.Msg.Context)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}
	rep, err := h.service.GenerateFinancialReport(
		ctx,
		wsID,
		req.Msg.ReportType,
		req.Msg.PeriodStart,
		req.Msg.PeriodEnd,
		req.Msg.GroupBy,
		nil,
	)
	if err != nil {
		if errors.Is(err, ErrInvalidReportPeriod) {
			return nil, connect.NewError(connect.CodeInvalidArgument, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(&financev1.ProfitServiceGenerateReportResponse{
		Report: toProtoFinancialReport(rep),
	}), nil
}

func (h *ProfitHandler) ExportReport(ctx context.Context, req *connect.Request[financev1.ProfitServiceExportReportRequest]) (*connect.Response[financev1.ProfitServiceExportReportResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, req.Msg.Context)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}
	res, err := h.service.ExportFinancialReport(
		ctx,
		wsID,
		req.Msg.ReportType,
		req.Msg.Format,
		req.Msg.PeriodStart,
		req.Msg.PeriodEnd,
		req.Msg.SubscriptionTier,
		false,
	)
	if err != nil {
		if errors.Is(err, ErrReportExportTierForbidden) {
			return nil, connect.NewError(connect.CodePermissionDenied, err)
		}
		if errors.Is(err, ErrReportExportQuotaExceeded) {
			return nil, connect.NewError(connect.CodeResourceExhausted, err)
		}
		if errors.Is(err, ErrInvalidReportPeriod) {
			return nil, connect.NewError(connect.CodeInvalidArgument, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(&financev1.ProfitServiceExportReportResponse{
		ExportId:            res.ExportID,
		Format:              res.Format,
		FileUrl:             res.FileURL,
		ContentHashSha512:   res.ContentHashSHA512,
		MonthlyExportsUsed:  int32(res.MonthlyExportsUsed),
		MonthlyExportsLimit: int32(res.MonthlyExportsLimit),
		Report:              toProtoFinancialReport(res.Report),
	}), nil
}

func (h *ProfitHandler) ExportTaxReport(ctx context.Context, req *connect.Request[financev1.ProfitServiceExportTaxReportRequest]) (*connect.Response[financev1.ProfitServiceExportTaxReportResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, req.Msg.Context)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}
	res, err := h.service.ExportFinancialReport(
		ctx,
		wsID,
		"tax_summary",
		req.Msg.Format,
		req.Msg.PeriodStart,
		req.Msg.PeriodEnd,
		req.Msg.SubscriptionTier,
		true,
	)
	if err != nil {
		if errors.Is(err, ErrReportExportTierForbidden) {
			return nil, connect.NewError(connect.CodePermissionDenied, err)
		}
		if errors.Is(err, ErrReportExportQuotaExceeded) {
			return nil, connect.NewError(connect.CodeResourceExhausted, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(&financev1.ProfitServiceExportTaxReportResponse{
		ExportId:              res.ExportID,
		Format:                res.Format,
		FileUrl:               res.FileURL,
		TaxResponsibilityMode: res.TaxResponsibilityMode,
		TaxDisclaimer:         res.TaxDisclaimer,
		ContentHashSha512:     res.ContentHashSHA512,
		Report:                toProtoFinancialReport(res.Report),
	}), nil
}

func (h *ProfitHandler) ExportToSheets(ctx context.Context, req *connect.Request[financev1.ProfitServiceExportToSheetsRequest]) (*connect.Response[financev1.ProfitServiceExportToSheetsResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, req.Msg.Context)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}
	res, err := h.service.ExportFinancialReport(
		ctx,
		wsID,
		"pnl_statement",
		"sheets",
		"",
		"",
		req.Msg.SubscriptionTier,
		false,
	)
	if err != nil {
		if errors.Is(err, ErrReportExportTierForbidden) {
			return nil, connect.NewError(connect.CodePermissionDenied, err)
		}
		if errors.Is(err, ErrReportExportQuotaExceeded) {
			return nil, connect.NewError(connect.CodeResourceExhausted, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(&financev1.ProfitServiceExportToSheetsResponse{
		ExportId:       res.ExportID,
		SpreadsheetUrl: fmt.Sprintf("https://docs.google.com/spreadsheets/d/%s", res.ExportID),
		Status:         "completed",
	}), nil
}

func (h *ProfitHandler) GetReportTemplates(ctx context.Context, req *connect.Request[financev1.ProfitServiceGetReportTemplatesRequest]) (*connect.Response[financev1.ProfitServiceGetReportTemplatesResponse], error) {
	templates := h.service.GetCanonicalReportTemplates()
	var protoTemplates []*financev1.ReportTemplateSummary
	for _, t := range templates {
		protoTemplates = append(protoTemplates, &financev1.ReportTemplateSummary{
			TemplateCode: t.TemplateCode,
			Title:        t.Title,
			Description:  t.Description,
		})
	}
	return connect.NewResponse(&financev1.ProfitServiceGetReportTemplatesResponse{
		Templates: protoTemplates,
	}), nil
}

func (h *ProfitHandler) GetSavedReports(ctx context.Context, req *connect.Request[financev1.ProfitServiceGetSavedReportsRequest]) (*connect.Response[financev1.ProfitServiceGetSavedReportsResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, nil)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}
	saved := h.service.ListSavedFinancialReports(wsID)
	var protoReports []*financev1.FinancialReport
	for i := range saved {
		protoReports = append(protoReports, toProtoFinancialReport(&saved[i]))
	}
	return connect.NewResponse(&financev1.ProfitServiceGetSavedReportsResponse{
		Reports: protoReports,
	}), nil
}

// ============================================================================
// SettlementService Handler
// ============================================================================

type SettlementHandler struct {
	service *Service
}

func NewSettlementHandler(service *Service) *SettlementHandler {
	return &SettlementHandler{service: service}
}

var _ financev1connect.SettlementServiceHandler = (*SettlementHandler)(nil)

func (h *SettlementHandler) Import(ctx context.Context, req *connect.Request[financev1.SettlementServiceImportRequest]) (*connect.Response[financev1.SettlementServiceImportResponse], error) {
	wsID, err := resolveTenantContext(ctx, req.Msg.Context)
	if err != nil {
		return nil, err
	}
	msg := req.Msg

	gross, err := tenantdb.ParseExactDecimal(msg.GrossAmount.GetAmount())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}
	net, err := tenantdb.ParseExactDecimal(msg.NetAmount.GetAmount())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	fx := ExchangeRateSnapshot{
		BaseCurrency:  msg.Currency,
		QuoteCurrency: msg.Currency,
		RateToBase:    "1",
		SourceClass:   SourceClassOfficial,
	}
	if msg.ExchangeRate != nil {
		fx.BaseCurrency = msg.ExchangeRate.BaseCurrency
		fx.QuoteCurrency = msg.ExchangeRate.QuoteCurrency
		fx.RateToBase = msg.ExchangeRate.RateToBase
		fx.Provider = msg.ExchangeRate.Provider
	}

	sment := &Settlement{
		WorkspaceID:          wsID,
		SourceClass:          SourceClassImported,
		SourcePlatform:       msg.SourcePlatform,
		ExternalSettlementID: msg.ExternalSettlementId,
		ConnectedAccountID:   msg.ConnectedAccountId,
		ExchangeRateSnapshot: fx,
		ImportFingerprint:    msg.ImportFingerprint,
		GrossAmount:          gross,
		NetAmount:            net,
		Currency:             msg.Currency,
		SettlementState:      SettlementStateImported,
		ReconciliationState:  ReconciliationImportedOnly,
		EffectiveDate:        msg.EffectiveDate,
	}

	var lines []SettlementLine
	for _, l := range msg.Lines {
		lg, _ := tenantdb.ParseExactDecimal(l.GrossAmount.GetAmount())
		lf, _ := tenantdb.ParseExactDecimal(l.FeeAmount.GetAmount())
		lr, _ := tenantdb.ParseExactDecimal(l.RefundAmount.GetAmount())
		ln, _ := tenantdb.ParseExactDecimal(l.NetAmount.GetAmount())
		lines = append(lines, SettlementLine{
			ExternalLineID:      l.ExternalLineId,
			ExternalOrderID:     l.ExternalOrderId,
			GrossAmount:         lg,
			FeeAmount:           lf,
			RefundAmount:        lr,
			NetAmount:           ln,
			Currency:            msg.Currency,
			ReconciliationState: ReconciliationImportedOnly,
		})
	}

	result, err := h.service.ImportSettlement(ctx, sment, lines)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&financev1.SettlementServiceImportResponse{
		Settlement:         toProtoSettlement(result),
		ImportedLinesCount: int32(len(result.Lines)),
		AlreadyExisted:     false,
	}), nil
}

func (h *SettlementHandler) List(ctx context.Context, req *connect.Request[financev1.SettlementServiceListRequest]) (*connect.Response[financev1.SettlementServiceListResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, nil)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}

	limit := 50
	offset := 0
	if req.Msg.Pagination != nil && req.Msg.Pagination.PageSize > 0 {
		limit = int(req.Msg.Pagination.PageSize)
	}

	filter := SettlementFilter{
		SourcePlatform: req.Msg.SourcePlatform,
	}
	sments, total, err := h.service.store.ListSettlements(ctx, wsID, filter, limit, offset)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoSments []*financev1.Settlement
	for i := range sments {
		protoSments = append(protoSments, toProtoSettlement(&sments[i]))
	}

	return connect.NewResponse(&financev1.SettlementServiceListResponse{
		Settlements: protoSments,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    int64(offset+len(sments)) < total,
		},
	}), nil
}

func (h *SettlementHandler) Get(ctx context.Context, req *connect.Request[financev1.SettlementServiceGetRequest]) (*connect.Response[financev1.SettlementServiceGetResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, nil)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}

	sment, err := h.service.store.GetSettlement(ctx, wsID, req.Msg.SettlementId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}

	return connect.NewResponse(&financev1.SettlementServiceGetResponse{
		Settlement: toProtoSettlement(sment),
	}), nil
}

// ============================================================================
// CostService Handler
// ============================================================================

type CostHandler struct {
	service *Service
}

func NewCostHandler(service *Service) *CostHandler {
	return &CostHandler{service: service}
}

var _ financev1connect.CostServiceHandler = (*CostHandler)(nil)

func (h *CostHandler) Create(ctx context.Context, req *connect.Request[financev1.CostServiceCreateRequest]) (*connect.Response[financev1.CostServiceCreateResponse], error) {
	wsID, err := resolveTenantContext(ctx, req.Msg.Context)
	if err != nil {
		return nil, err
	}
	msg := req.Msg

	amt, err := tenantdb.ParseExactDecimal(msg.Amount.GetAmount())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	item := &CostItem{
		WorkspaceID:      wsID,
		CostType:         msg.CostType,
		Amount:           amt,
		Currency:         msg.Amount.GetCurrency(),
		Description:      msg.Description,
		RelatedScopeType: msg.RelatedScopeType,
		RelatedScopeID:   msg.RelatedScopeId,
		SourceClass:      SourceClassEstimated,
		EvidenceID:       msg.EvidenceId,
		ConfidenceReason: msg.ConfidenceReason,
		CostState:        CostStateRecorded,
		EffectiveDate:    msg.EffectiveDate,
	}

	created, err := h.service.CreateCostItem(ctx, item)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&financev1.CostServiceCreateResponse{
		CostItem: toProtoCostItem(created),
	}), nil
}

func (h *CostHandler) List(ctx context.Context, req *connect.Request[financev1.CostServiceListRequest]) (*connect.Response[financev1.CostServiceListResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, nil)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}

	limit := 50
	offset := 0
	if req.Msg.Pagination != nil && req.Msg.Pagination.PageSize > 0 {
		limit = int(req.Msg.Pagination.PageSize)
	}

	filter := CostItemFilter{
		CostType:         req.Msg.CostType,
		RelatedScopeType: req.Msg.RelatedScopeType,
		RelatedScopeID:   req.Msg.RelatedScopeId,
		PeriodStart:      req.Msg.PeriodStart,
		PeriodEnd:        req.Msg.PeriodEnd,
	}

	items, total, err := h.service.ListCostItems(ctx, wsID, filter, limit, offset)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoItems []*financev1.CostItem
	for i := range items {
		protoItems = append(protoItems, toProtoCostItem(&items[i]))
	}

	return connect.NewResponse(&financev1.CostServiceListResponse{
		CostItems: protoItems,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    int64(offset+len(items)) < total,
		},
	}), nil
}

func (h *CostHandler) Update(ctx context.Context, req *connect.Request[financev1.CostServiceUpdateRequest]) (*connect.Response[financev1.CostServiceUpdateResponse], error) {
	wsID, err := resolveTenantContext(ctx, req.Msg.Context)
	if err != nil {
		return nil, err
	}
	msg := req.Msg

	existing, err := h.service.store.GetCostItem(ctx, wsID, msg.CostItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, err)
	}

	if msg.Amount != nil && msg.Amount.GetAmount() != "" {
		amt, err := tenantdb.ParseExactDecimal(msg.Amount.GetAmount())
		if err != nil {
			return nil, connect.NewError(connect.CodeInvalidArgument, err)
		}
		existing.Amount = amt
	}
	if msg.Description != "" {
		existing.Description = msg.Description
	}
	if msg.CostType != "" {
		existing.CostType = msg.CostType
	}

	updated, err := h.service.UpdateCostItem(ctx, existing)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&financev1.CostServiceUpdateResponse{
		CostItem: toProtoCostItem(updated),
	}), nil
}

func (h *CostHandler) Delete(ctx context.Context, req *connect.Request[financev1.CostServiceDeleteRequest]) (*connect.Response[financev1.CostServiceDeleteResponse], error) {
	wsID, err := resolveTenantContext(ctx, req.Msg.Context)
	if err != nil {
		return nil, err
	}

	if err := h.service.DeleteCostItem(ctx, wsID, req.Msg.CostItemId); err != nil {
		if errors.Is(err, ErrCostItemNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&financev1.CostServiceDeleteResponse{
		Success: true,
	}), nil
}

// ----------------------------------------------------------------------------
// Model to Proto Converters
// ----------------------------------------------------------------------------

func toProtoVerificationStatus(status string) financev1.VerificationStatus {
	switch status {
	case VerificationStatusPending:
		return financev1.VerificationStatus_VERIFICATION_STATUS_PENDING
	case VerificationStatusVerified:
		return financev1.VerificationStatus_VERIFICATION_STATUS_VERIFIED
	case VerificationStatusReVerify:
		return financev1.VerificationStatus_VERIFICATION_STATUS_RE_VERIFY
	case VerificationStatusFailed:
		return financev1.VerificationStatus_VERIFICATION_STATUS_FAILED
	default:
		return financev1.VerificationStatus_VERIFICATION_STATUS_UNSPECIFIED
	}
}

func toProtoReconciliationRecord(r *ReconciliationRecord) *financev1.ReconciliationRecord {
	if r == nil {
		return nil
	}
	protoRec := &financev1.ReconciliationRecord{
		RecordId:             r.RecordID,
		WorkspaceId:          r.WorkspaceID,
		ScopeType:            r.ScopeType,
		ScopeDescription:     r.ScopeDescription,
		RelatedOrderIds:      r.RelatedOrderIDs,
		RelatedSettlementIds: r.RelatedSettlementIDs,
		DiscrepancyReason:    r.DiscrepancyReason,
		ReconciliationState:  toProtoReconciliationState(r.ReconciliationState),
		Currency:             r.Currency,
		MismatchesJson:       r.MismatchesJSON,
		OverrideReason:       r.OverrideReason,
		OverrideBy:           r.OverrideBy,
		PeriodStart:          r.PeriodStart,
		PeriodEnd:            r.PeriodEnd,
		CreatedAt:            timestamppb.New(r.CreatedAt),
		UpdatedAt:            timestamppb.New(r.UpdatedAt),
	}
	if !r.MatchedAmount.IsZero() {
		protoRec.MatchedAmount, _ = r.MatchedAmount.ToProtoMoney(r.Currency, false)
	}
	if !r.DiscrepancyAmount.IsZero() {
		protoRec.DiscrepancyAmount, _ = r.DiscrepancyAmount.ToProtoMoney(r.Currency, true)
	}
	if r.OverrideAt != nil {
		protoRec.OverrideAt = timestamppb.New(*r.OverrideAt)
	}
	return protoRec
}

func toProtoReconciliationMatch(m *ReconciliationMatch) *financev1.ReconciliationMatch {
	if m == nil {
		return nil
	}
	match := &financev1.ReconciliationMatch{
		MatchId:      m.MatchID,
		WorkspaceId:  m.WorkspaceID,
		RecordId:     m.RecordID,
		SettlementId: m.SettlementID,
		LineId:       m.LineID,
		OrderId:      m.OrderID,
		Currency:     m.Currency,
		CreatedAt:    timestamppb.New(m.CreatedAt),
	}
	match.AllocatedAmount, _ = m.AllocatedAmount.ToProtoMoney(m.Currency, false)
	return match
}

func toProtoEvidenceObject(e *EvidenceObject) *financev1.EvidenceObject {
	if e == nil {
		return nil
	}
	var refs []*financev1.ObjectRef
	for _, r := range e.RelatedObjectRefs {
		refs = append(refs, &financev1.ObjectRef{
			Type: r.Type,
			Id:   r.ID,
		})
	}
	return &financev1.EvidenceObject{
		EvidenceId:         e.EvidenceID,
		WorkspaceId:        e.WorkspaceID,
		EvidenceType:       e.EvidenceType,
		SourceProvenance:   e.SourceProvenance,
		ContentHash:        e.ContentHash,
		FileUrl:            e.FileURL,
		PayloadJson:        e.PayloadJSON,
		CollectedAt:        timestamppb.New(e.CollectedAt),
		VerificationStatus: toProtoVerificationStatus(e.VerificationStatus),
		RelatedObjectRefs:  refs,
		CreatedAt:          timestamppb.New(e.CreatedAt),
	}
}

func toProtoProofBundle(pb *ProofBundle) *financev1.ProofBundle {
	if pb == nil {
		return nil
	}
	ctxBytes, _ := json.Marshal(pb.SourceClassContext)
	return &financev1.ProofBundle{
		ProofBundleId:          pb.ProofBundleID,
		WorkspaceId:            pb.WorkspaceID,
		ClaimScope:             pb.ClaimScope,
		ClaimSummary:           pb.ClaimSummary,
		SupportingEvidenceIds:  pb.SupportingEvidenceIDs,
		SourceClassContextJson: string(ctxBytes),
		Confidence:             toProtoConfidenceBand(pb.Confidence),
		CoverageSummary:        pb.CoverageSummary,
		UnresolvedGaps:         pb.UnresolvedGaps,
		CreatedAt:              timestamppb.New(pb.CreatedAt),
		UpdatedAt:              timestamppb.New(pb.UpdatedAt),
	}
}

func toProtoDataGapItem(item *DataGapItem) *financev1.DataGapItem {
	if item == nil {
		return nil
	}
	protoItem := &financev1.DataGapItem{
		GapId:              item.GapID,
		GapType:            item.GapType,
		Severity:           item.Severity,
		Title:              item.Title,
		Description:        item.Description,
		RelatedObjectType:  item.RelatedObjectType,
		RelatedObjectId:    item.RelatedObjectID,
		UnresolvedSince:    timestamppb.New(item.UnresolvedSince),
		RepairCtaLabel:     item.RepairCTALabel,
		RepairCtaRoute:     item.RepairCTARoute,
		RequiredPermission: item.RequiredPermission,
	}
	protoItem.MonetaryAmount, _ = item.MonetaryAmount.ToProtoMoney("VND", false)
	return protoItem
}

// ============================================================================
// ReconciliationService Handler
// ============================================================================

type ReconciliationHandler struct {
	service  *Service
	bindings *rbac.Registry
}

func NewReconciliationHandler(service *Service, bindings ...*rbac.Registry) *ReconciliationHandler {
	var b *rbac.Registry
	if len(bindings) > 0 {
		b = bindings[0]
	}
	return &ReconciliationHandler{service: service, bindings: b}
}

var _ financev1connect.ReconciliationServiceHandler = (*ReconciliationHandler)(nil)

func (h *ReconciliationHandler) authorize(ctx context.Context, rpcName, wsID string) error {
	if h.bindings == nil {
		return nil
	}
	pctx, ok := rbac.PolicyContextFromContext(ctx)
	if !ok {
		return nil
	}
	if pctx.WorkspaceID != "" && pctx.WorkspaceID != wsID {
		return connect.NewError(connect.CodePermissionDenied, tenantdb.ErrScopeMismatch)
	}
	pctx.WorkspaceID = wsID
	_, err := h.bindings.Authorize(rpcName, pctx)
	if err != nil {
		return connect.NewError(connect.CodePermissionDenied, err)
	}
	return nil
}

func (h *ReconciliationHandler) Queue(ctx context.Context, req *connect.Request[financev1.ReconciliationServiceQueueRequest]) (*connect.Response[financev1.ReconciliationServiceQueueResponse], error) {
	wsID, err := resolveTenantContext(ctx, req.Msg.Context)
	if err != nil {
		return nil, err
	}
	if err := h.authorize(ctx, "ReconciliationService/Queue", wsID); err != nil {
		return nil, err
	}
	msg := req.Msg

	rec := &ReconciliationRecord{
		WorkspaceID:          wsID,
		ScopeType:            msg.ScopeType,
		ScopeDescription:     msg.ScopeDescription,
		RelatedOrderIDs:      msg.OrderIds,
		RelatedSettlementIDs: msg.SettlementIds,
		PeriodStart:          msg.PeriodStart,
		PeriodEnd:            msg.PeriodEnd,
		ReconciliationState:  ReconciliationImportedOnly,
		Currency:             "VND",
	}

	created, err := h.service.QueueReconciliationBatch(ctx, rec)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&financev1.ReconciliationServiceQueueResponse{
		Record: toProtoReconciliationRecord(created),
	}), nil
}

func (h *ReconciliationHandler) Match(ctx context.Context, req *connect.Request[financev1.ReconciliationServiceMatchRequest]) (*connect.Response[financev1.ReconciliationServiceMatchResponse], error) {
	wsID, err := resolveTenantContext(ctx, req.Msg.Context)
	if err != nil {
		return nil, err
	}
	if err := h.authorize(ctx, "ReconciliationService/Match", wsID); err != nil {
		return nil, err
	}
	msg := req.Msg

	allocAmt, err := tenantdb.ParseExactDecimal(msg.AllocationAmount.GetAmount())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	line, order, match, err := h.service.Match(ctx, wsID, msg.SettlementId, msg.LineId, msg.OrderId, msg.RecordId, allocAmt)
	if err != nil {
		if errors.Is(err, ErrCapacityExceeded) || errors.Is(err, ErrOrderCapacityExceeded) {
			return nil, connect.NewError(connect.CodeFailedPrecondition, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	lineRem, _ := line.NetAmount.Sub(line.MatchedAmount)
	orderRem, _ := order.Amount.Sub(order.MatchedAmount)
	lineRemMoney, _ := lineRem.ToProtoMoney(line.Currency, false)
	orderRemMoney, _ := orderRem.ToProtoMoney(order.Currency, false)

	var protoRec *financev1.ReconciliationRecord
	if msg.RecordId != "" {
		if rec, _, err := h.service.GetReconciliationRecord(ctx, wsID, msg.RecordId); err == nil {
			protoRec = toProtoReconciliationRecord(rec)
		}
	}

	return connect.NewResponse(&financev1.ReconciliationServiceMatchResponse{
		Success:                  true,
		Line:                     toProtoSettlementLine(line),
		OrderReconciliationState: toProtoReconciliationState(order.ReconciliationState),
		LineRemainingCapacity:    lineRemMoney,
		OrderRemainingCapacity:   orderRemMoney,
		Record:                   protoRec,
		Match:                    toProtoReconciliationMatch(match),
	}), nil
}

func (h *ReconciliationHandler) ManualMatch(ctx context.Context, req *connect.Request[financev1.ReconciliationServiceManualMatchRequest]) (*connect.Response[financev1.ReconciliationServiceManualMatchResponse], error) {
	wsID, err := resolveTenantContext(ctx, req.Msg.Context)
	if err != nil {
		return nil, err
	}
	if err := h.authorize(ctx, "ReconciliationService/ManualMatch", wsID); err != nil {
		return nil, err
	}
	msg := req.Msg

	allocAmt, err := tenantdb.ParseExactDecimal(msg.AllocationAmount.GetAmount())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	actorID := ""
	if session, ok := transportauth.PrincipalFromContext(ctx); ok {
		actorID = session.UserID
	}

	line, order, match, err := h.service.ManualMatch(ctx, wsID, msg.SettlementId, msg.LineId, msg.OrderId, msg.RecordId, allocAmt, "manual_override", actorID)
	if err != nil {
		if errors.Is(err, ErrCapacityExceeded) || errors.Is(err, ErrOrderCapacityExceeded) {
			return nil, connect.NewError(connect.CodeFailedPrecondition, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	lineRem, _ := line.NetAmount.Sub(line.MatchedAmount)
	orderRem, _ := order.Amount.Sub(order.MatchedAmount)
	lineRemMoney, _ := lineRem.ToProtoMoney(line.Currency, false)
	orderRemMoney, _ := orderRem.ToProtoMoney(order.Currency, false)

	var protoRec *financev1.ReconciliationRecord
	if msg.RecordId != "" {
		if rec, _, err := h.service.GetReconciliationRecord(ctx, wsID, msg.RecordId); err == nil {
			protoRec = toProtoReconciliationRecord(rec)
		}
	}

	return connect.NewResponse(&financev1.ReconciliationServiceManualMatchResponse{
		Success:                  true,
		Line:                     toProtoSettlementLine(line),
		OrderReconciliationState: toProtoReconciliationState(order.ReconciliationState),
		LineRemainingCapacity:    lineRemMoney,
		OrderRemainingCapacity:   orderRemMoney,
		Record:                   protoRec,
		Match:                    toProtoReconciliationMatch(match),
	}), nil
}

func (h *ReconciliationHandler) Override(ctx context.Context, req *connect.Request[financev1.ReconciliationServiceOverrideRequest]) (*connect.Response[financev1.ReconciliationServiceOverrideResponse], error) {
	wsID, err := resolveTenantContext(ctx, req.Msg.Context)
	if err != nil {
		return nil, err
	}
	if err := h.authorize(ctx, "ReconciliationService/Override", wsID); err != nil {
		return nil, err
	}
	msg := req.Msg

	actorID := ""
	if session, ok := transportauth.PrincipalFromContext(ctx); ok {
		actorID = session.UserID
	}

	rec, err := h.service.OverrideReconciliation(ctx, wsID, msg.RecordId, msg.Decision, msg.Reason, actorID, msg.EvidenceIds)
	if err != nil {
		if errors.Is(err, ErrRecordNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&financev1.ReconciliationServiceOverrideResponse{
		Record: toProtoReconciliationRecord(rec),
	}), nil
}

func (h *ReconciliationHandler) GetRecord(ctx context.Context, req *connect.Request[financev1.ReconciliationServiceGetRecordRequest]) (*connect.Response[financev1.ReconciliationServiceGetRecordResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, nil)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}
	if err := h.authorize(ctx, "ReconciliationService/GetRecord", wsID); err != nil {
		return nil, err
	}

	rec, matches, err := h.service.GetReconciliationRecord(ctx, wsID, req.Msg.RecordId)
	if err != nil {
		if errors.Is(err, ErrRecordNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoMatches []*financev1.ReconciliationMatch
	for i := range matches {
		protoMatches = append(protoMatches, toProtoReconciliationMatch(&matches[i]))
	}

	return connect.NewResponse(&financev1.ReconciliationServiceGetRecordResponse{
		Record:  toProtoReconciliationRecord(rec),
		Matches: protoMatches,
	}), nil
}

func (h *ReconciliationHandler) ListRecords(ctx context.Context, req *connect.Request[financev1.ReconciliationServiceListRecordsRequest]) (*connect.Response[financev1.ReconciliationServiceListRecordsResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, nil)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}
	if err := h.authorize(ctx, "ReconciliationService/ListRecords", wsID); err != nil {
		return nil, err
	}

	limit := 50
	offset := 0
	if req.Msg.Pagination != nil && req.Msg.Pagination.PageSize > 0 {
		limit = int(req.Msg.Pagination.PageSize)
	}

	filter := ReconciliationFilter{
		PeriodStart: req.Msg.PeriodStart,
		PeriodEnd:   req.Msg.PeriodEnd,
	}

	records, total, err := h.service.ListReconciliationRecords(ctx, wsID, filter, limit, offset)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoRecords []*financev1.ReconciliationRecord
	for i := range records {
		protoRecords = append(protoRecords, toProtoReconciliationRecord(&records[i]))
	}

	return connect.NewResponse(&financev1.ReconciliationServiceListRecordsResponse{
		Records: protoRecords,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    int64(offset+len(records)) < total,
		},
	}), nil
}

func (h *ReconciliationHandler) ListPending(ctx context.Context, req *connect.Request[financev1.ReconciliationServiceListPendingRequest]) (*connect.Response[financev1.ReconciliationServiceListPendingResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, nil)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}

	callerRole := ""
	if pctx, ok := rbac.PolicyContextFromContext(ctx); ok {
		callerRole = pctx.Role
	}

	// CRITICAL ACCEPTANCE TARGET: Finance gaps do not leak to Viewer
	if callerRole == "viewer" || callerRole == rbac.RoleViewer {
		return connect.NewResponse(&financev1.ReconciliationServiceListPendingResponse{
			Items:                   nil,
			Pagination:              &commonv1.PaginatedResponse{},
			MissingComponentsCount:  0,
			TotalUnreconciledAmount: nil,
			UnreconciledCount:       0,
		}), nil
	}

	if err := h.authorize(ctx, "ReconciliationService/ListPending", wsID); err != nil {
		return nil, err
	}

	limit := 50
	offset := 0
	if req.Msg.Pagination != nil && req.Msg.Pagination.PageSize > 0 {
		limit = int(req.Msg.Pagination.PageSize)
	}

	filter := DataGapFilter{
		Severity:    req.Msg.Severity,
		GapType:     req.Msg.GapType,
		PeriodStart: req.Msg.PeriodStart,
		PeriodEnd:   req.Msg.PeriodEnd,
		ProductID:   req.Msg.ProductId,
	}

	items, total, missingCount, unreconciledAmt, unreconciledCount, err := h.service.ListPendingGaps(ctx, wsID, callerRole, filter, limit, offset)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoItems []*financev1.DataGapItem
	for i := range items {
		protoItems = append(protoItems, toProtoDataGapItem(&items[i]))
	}

	unreconciledMoney, _ := unreconciledAmt.ToProtoMoney("VND", false)

	return connect.NewResponse(&financev1.ReconciliationServiceListPendingResponse{
		Items: protoItems,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    int64(offset+len(items)) < total,
		},
		MissingComponentsCount:  missingCount,
		TotalUnreconciledAmount: unreconciledMoney,
		UnreconciledCount:       unreconciledCount,
	}), nil
}

// ============================================================================
// EvidenceService Handler
// ============================================================================

type EvidenceHandler struct {
	service  *Service
	bindings *rbac.Registry
}

func NewEvidenceHandler(service *Service, bindings ...*rbac.Registry) *EvidenceHandler {
	var b *rbac.Registry
	if len(bindings) > 0 {
		b = bindings[0]
	}
	return &EvidenceHandler{service: service, bindings: b}
}

var _ financev1connect.EvidenceServiceHandler = (*EvidenceHandler)(nil)

func (h *EvidenceHandler) authorize(ctx context.Context, rpcName, wsID string) error {
	if h.bindings == nil {
		return nil
	}
	pctx, ok := rbac.PolicyContextFromContext(ctx)
	if !ok {
		return nil
	}
	if pctx.WorkspaceID != "" && pctx.WorkspaceID != wsID {
		return connect.NewError(connect.CodePermissionDenied, tenantdb.ErrScopeMismatch)
	}
	pctx.WorkspaceID = wsID
	_, err := h.bindings.Authorize(rpcName, pctx)
	if err != nil {
		return connect.NewError(connect.CodePermissionDenied, err)
	}
	return nil
}

func (h *EvidenceHandler) Submit(ctx context.Context, req *connect.Request[financev1.EvidenceServiceSubmitRequest]) (*connect.Response[financev1.EvidenceServiceSubmitResponse], error) {
	wsID, err := resolveTenantContext(ctx, req.Msg.Context)
	if err != nil {
		return nil, err
	}
	if err := h.authorize(ctx, "EvidenceService/Submit", wsID); err != nil {
		return nil, err
	}
	msg := req.Msg

	var refs []ObjectRef
	for _, r := range msg.RelatedObjectRefs {
		refs = append(refs, ObjectRef{
			Type: r.Type,
			ID:   r.Id,
		})
	}

	ev := &EvidenceObject{
		WorkspaceID:        wsID,
		EvidenceType:       msg.EvidenceType,
		SourceProvenance:   msg.SourceProvenance,
		ContentHash:        msg.ContentHash,
		FileURL:            msg.FileUrl,
		PayloadJSON:        msg.PayloadJson,
		RelatedObjectRefs:  refs,
		VerificationStatus: VerificationStatusPending,
	}

	created, err := h.service.SubmitEvidence(ctx, ev, msg.RawContent)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&financev1.EvidenceServiceSubmitResponse{
		Evidence: toProtoEvidenceObject(created),
	}), nil
}

func (h *EvidenceHandler) Get(ctx context.Context, req *connect.Request[financev1.EvidenceServiceGetRequest]) (*connect.Response[financev1.EvidenceServiceGetResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, nil)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}
	if err := h.authorize(ctx, "EvidenceService/Get", wsID); err != nil {
		return nil, err
	}

	ev, err := h.service.GetEvidence(ctx, wsID, req.Msg.EvidenceId)
	if err != nil {
		if errors.Is(err, ErrEvidenceNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&financev1.EvidenceServiceGetResponse{
		Evidence: toProtoEvidenceObject(ev),
	}), nil
}

func (h *EvidenceHandler) List(ctx context.Context, req *connect.Request[financev1.EvidenceServiceListRequest]) (*connect.Response[financev1.EvidenceServiceListResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, nil)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}
	if err := h.authorize(ctx, "EvidenceService/List", wsID); err != nil {
		return nil, err
	}

	limit := 50
	offset := 0
	if req.Msg.Pagination != nil && req.Msg.Pagination.PageSize > 0 {
		limit = int(req.Msg.Pagination.PageSize)
	}

	filter := EvidenceFilter{
		EvidenceType:       req.Msg.EvidenceType,
		VerificationStatus: req.Msg.VerificationStatus,
	}

	items, total, err := h.service.ListEvidence(ctx, wsID, filter, limit, offset)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoItems []*financev1.EvidenceObject
	for i := range items {
		protoItems = append(protoItems, toProtoEvidenceObject(&items[i]))
	}

	return connect.NewResponse(&financev1.EvidenceServiceListResponse{
		Items: protoItems,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    int64(offset+len(items)) < total,
		},
	}), nil
}

// ============================================================================
// ProofService Handler
// ============================================================================

type ProofHandler struct {
	service  *Service
	bindings *rbac.Registry
}

func NewProofHandler(service *Service, bindings ...*rbac.Registry) *ProofHandler {
	var b *rbac.Registry
	if len(bindings) > 0 {
		b = bindings[0]
	}
	return &ProofHandler{service: service, bindings: b}
}

var _ financev1connect.ProofServiceHandler = (*ProofHandler)(nil)

func (h *ProofHandler) authorize(ctx context.Context, rpcName, wsID string) error {
	if h.bindings == nil {
		return nil
	}
	pctx, ok := rbac.PolicyContextFromContext(ctx)
	if !ok {
		return nil
	}
	if pctx.WorkspaceID != "" && pctx.WorkspaceID != wsID {
		return connect.NewError(connect.CodePermissionDenied, tenantdb.ErrScopeMismatch)
	}
	pctx.WorkspaceID = wsID
	_, err := h.bindings.Authorize(rpcName, pctx)
	if err != nil {
		return connect.NewError(connect.CodePermissionDenied, err)
	}
	return nil
}

func (h *ProofHandler) Assemble(ctx context.Context, req *connect.Request[financev1.ProofServiceAssembleRequest]) (*connect.Response[financev1.ProofServiceAssembleResponse], error) {
	wsID, err := resolveTenantContext(ctx, req.Msg.Context)
	if err != nil {
		return nil, err
	}
	if err := h.authorize(ctx, "ProofService/Assemble", wsID); err != nil {
		return nil, err
	}
	msg := req.Msg

	pb := &ProofBundle{
		WorkspaceID:           wsID,
		ClaimScope:            msg.ClaimScope,
		ClaimSummary:          msg.ClaimSummary,
		SupportingEvidenceIDs: msg.SupportingEvidenceIds,
		CoverageSummary:       msg.CoverageSummary,
		UnresolvedGaps:        msg.UnresolvedGaps,
	}

	assembled, err := h.service.AssembleProofBundle(ctx, pb)
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	return connect.NewResponse(&financev1.ProofServiceAssembleResponse{
		ProofBundle: toProtoProofBundle(assembled),
	}), nil
}

func (h *ProofHandler) Get(ctx context.Context, req *connect.Request[financev1.ProofServiceGetRequest]) (*connect.Response[financev1.ProofServiceGetResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, nil)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}
	if err := h.authorize(ctx, "ProofService/Get", wsID); err != nil {
		return nil, err
	}

	pb, err := h.service.GetProofBundle(ctx, wsID, req.Msg.ProofBundleId)
	if err != nil {
		if errors.Is(err, ErrProofBundleNotFound) {
			return nil, connect.NewError(connect.CodeNotFound, err)
		}
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&financev1.ProofServiceGetResponse{
		ProofBundle: toProtoProofBundle(pb),
	}), nil
}

func (h *ProofHandler) List(ctx context.Context, req *connect.Request[financev1.ProofServiceListRequest]) (*connect.Response[financev1.ProofServiceListResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, nil)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}
	if err := h.authorize(ctx, "ProofService/List", wsID); err != nil {
		return nil, err
	}

	limit := 50
	offset := 0
	if req.Msg.Pagination != nil && req.Msg.Pagination.PageSize > 0 {
		limit = int(req.Msg.Pagination.PageSize)
	}

	filter := ProofBundleFilter{
		ClaimScope: req.Msg.ClaimScope,
	}

	bundles, total, err := h.service.ListProofBundles(ctx, wsID, filter, limit, offset)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoBundles []*financev1.ProofBundle
	for i := range bundles {
		protoBundles = append(protoBundles, toProtoProofBundle(&bundles[i]))
	}

	return connect.NewResponse(&financev1.ProofServiceListResponse{
		ProofBundles: protoBundles,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    int64(offset+len(bundles)) < total,
		},
	}), nil
}

// ============================================================================
// ContentRevenueService Handler
// ============================================================================

type ContentRevenueHandler struct {
	service  *Service
	bindings *rbac.Registry
}

func NewContentRevenueHandler(service *Service, bindings ...*rbac.Registry) *ContentRevenueHandler {
	var b *rbac.Registry
	if len(bindings) > 0 {
		b = bindings[0]
	}
	return &ContentRevenueHandler{service: service, bindings: b}
}

var _ financev1connect.ContentRevenueServiceHandler = (*ContentRevenueHandler)(nil)

func (h *ContentRevenueHandler) authorize(ctx context.Context, rpcName, wsID string) error {
	if h.bindings == nil {
		return nil
	}
	pctx, ok := rbac.PolicyContextFromContext(ctx)
	if !ok {
		return nil
	}
	if pctx.WorkspaceID != "" && pctx.WorkspaceID != wsID {
		return connect.NewError(connect.CodePermissionDenied, tenantdb.ErrScopeMismatch)
	}
	pctx.WorkspaceID = wsID
	_, err := h.bindings.Authorize(rpcName, pctx)
	if err != nil {
		return connect.NewError(connect.CodePermissionDenied, err)
	}
	return nil
}

func (h *ContentRevenueHandler) GetAttribution(ctx context.Context, req *connect.Request[financev1.ContentRevenueServiceGetAttributionRequest]) (*connect.Response[financev1.ContentRevenueServiceGetAttributionResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, nil)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}
	if err := h.authorize(ctx, "ContentRevenueService/GetAttribution", wsID); err != nil {
		return nil, err
	}

	contentRev, matchingAttrs, summary, err := h.service.AttributionEngine().GetContentRevenueAttribution(ctx, wsID, req.Msg.ContentId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoRecords []*financev1.ContentAttributionRecord
	for _, a := range matchingAttrs {
		protoRecords = append(protoRecords, ConvertEntityToProto(a))
	}

	return connect.NewResponse(&financev1.ContentRevenueServiceGetAttributionResponse{
		Attribution:        contentRev,
		AttributionRecords: protoRecords,
		WorkspaceSummary:   summary,
	}), nil
}

// ============================================================================
// AttributionService Handler
// ============================================================================

type AttributionHandler struct {
	service  *Service
	bindings *rbac.Registry
}

func NewAttributionHandler(service *Service, bindings ...*rbac.Registry) *AttributionHandler {
	var b *rbac.Registry
	if len(bindings) > 0 {
		b = bindings[0]
	}
	return &AttributionHandler{service: service, bindings: b}
}

var _ financev1connect.AttributionServiceHandler = (*AttributionHandler)(nil)

func (h *AttributionHandler) authorize(ctx context.Context, rpcName, wsID string) error {
	if h.bindings == nil {
		return nil
	}
	pctx, ok := rbac.PolicyContextFromContext(ctx)
	if !ok {
		return nil
	}
	if pctx.WorkspaceID != "" && pctx.WorkspaceID != wsID {
		return connect.NewError(connect.CodePermissionDenied, tenantdb.ErrScopeMismatch)
	}
	pctx.WorkspaceID = wsID
	_, err := h.bindings.Authorize(rpcName, pctx)
	if err != nil {
		return connect.NewError(connect.CodePermissionDenied, err)
	}
	return nil
}

func (h *AttributionHandler) GetByContent(ctx context.Context, req *connect.Request[financev1.AttributionServiceGetByContentRequest]) (*connect.Response[financev1.AttributionServiceGetByContentResponse], error) {
	wsID := req.Msg.WorkspaceId
	if wsID == "" {
		resolved, err := resolveTenantContext(ctx, nil)
		if err != nil {
			return nil, err
		}
		wsID = resolved
	}
	if err := h.authorize(ctx, "AttributionService/GetByContent", wsID); err != nil {
		return nil, err
	}

	contentID := req.Msg.PublishItemId
	if contentID == "" {
		contentID = req.Msg.ChannelPostId
	}

	contentRev, matchingAttrs, _, err := h.service.AttributionEngine().GetContentRevenueAttribution(ctx, wsID, contentID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var protoRecords []*financev1.ContentAttributionRecord
	for _, a := range matchingAttrs {
		protoRecords = append(protoRecords, ConvertEntityToProto(a))
	}

	var summary *financev1.ContentAttributionSummary
	if contentRev != nil {
		summary = &financev1.ContentAttributionSummary{
			PublishItemId:          contentID,
			TotalRecords:           int64(len(matchingAttrs)),
			UniqueOrders:           contentRev.DirectOrderCount,
			TotalAttributedRevenue: contentRev.AttributedRevenue,
			Confidence:             contentRev.Confidence,
			SourceClassMixSummary:  contentRev.Status,
		}
	}

	total := int64(len(protoRecords))
	return connect.NewResponse(&financev1.AttributionServiceGetByContentResponse{
		Records: protoRecords,
		Summary: summary,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    false,
		},
	}), nil
}

func (h *AttributionHandler) RecordAttribution(ctx context.Context, req *connect.Request[financev1.AttributionServiceRecordAttributionRequest]) (*connect.Response[financev1.AttributionServiceRecordAttributionResponse], error) {
	wsID, err := resolveTenantContext(ctx, req.Msg.Context)
	if err != nil {
		if req.Msg.WorkspaceId != "" {
			wsID = req.Msg.WorkspaceId
		} else {
			return nil, err
		}
	}
	if err := h.authorize(ctx, "AttributionService/RecordAttribution", wsID); err != nil {
		return nil, err
	}

	amount, err := tenantdb.ParseExactDecimal(req.Msg.RevenueAttributed.GetAmount())
	if err != nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("invalid revenue amount: %w", err))
	}

	sourceClass := fromProtoSourceClass(req.Msg.SourceClass)
	confidence := fromProtoConfidenceBand(req.Msg.Confidence)

	// Check if live API authenticated caller
	isLiveAPI := false
	if sub, ok := transportauth.PrincipalFromContext(ctx); ok && sub.InternalAdmin {
		isLiveAPI = true
	}

	entity := &ContentAttributionEntity{
		WorkspaceID:       wsID,
		PublishItemID:     req.Msg.PublishItemId,
		ChannelPostID:     req.Msg.ChannelPostId,
		OrderID:           req.Msg.OrderId,
		AttributionType:   req.Msg.AttributionType,
		RevenueAttributed: amount,
		SourceClass:       sourceClass,
		Confidence:        confidence,
		UTMSource:         req.Msg.UtmSource,
		UTMMedium:         req.Msg.UtmMedium,
		UTMCampaign:       req.Msg.UtmCampaign,
	}

	recorded, err := h.service.AttributionEngine().RecordAttribution(ctx, entity, isLiveAPI)
	if err != nil {
		if errors.Is(err, ErrAttributionCapacityExceeded) {
			return nil, connect.NewError(connect.CodeFailedPrecondition, err)
		}
		if errors.Is(err, ErrImportedProofCannotBeOfficial) {
			return nil, connect.NewError(connect.CodeInvalidArgument, err)
		}
		return nil, connect.NewError(connect.CodeInvalidArgument, err)
	}

	order, hasOrder := h.service.AttributionEngine().GetCanonicalOrder(recorded.OrderID)
	var totalRev, allocatedRev, remCap *commonv1.Money
	if hasOrder {
		totalRev = &commonv1.Money{Amount: order.NetRevenue.Fixed6String(), Currency: order.Currency}
		alloc, cap := h.service.AttributionEngine().GetOrderAllocationStatus(recorded.OrderID)
		allocatedRev = &commonv1.Money{Amount: alloc.Fixed6String(), Currency: order.Currency}
		remCap = &commonv1.Money{Amount: cap.Fixed6String(), Currency: order.Currency}
	}

	return connect.NewResponse(&financev1.AttributionServiceRecordAttributionResponse{
		Record:                 ConvertEntityToProto(recorded),
		OrderRecognized:        hasOrder,
		OrderTotalRevenue:      totalRev,
		OrderAllocatedRevenue:  allocatedRev,
		OrderRemainingCapacity: remCap,
	}), nil
}
