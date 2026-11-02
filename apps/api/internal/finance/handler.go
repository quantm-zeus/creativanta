package finance

import (
	"context"
	"encoding/json"
	"errors"

	"connectrpc.com/connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	financev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/finance/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/finance/v1/financev1connect"
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

func toProtoSettlement(s *Settlement) *financev1.Settlement {
	if s == nil {
		return nil
	}
	feesJSON, _ := json.Marshal(s.Fees)
	dedJSON, _ := json.Marshal(s.Deductions)

	var protoLines []*financev1.SettlementLine
	for _, l := range s.Lines {
		protoLines = append(protoLines, &financev1.SettlementLine{
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
		})
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
