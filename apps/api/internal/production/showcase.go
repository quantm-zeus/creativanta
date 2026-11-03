package production

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"

	"connectrpc.com/connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	productionv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/production/v1/productionv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// ProductShowcaseManager implements ProductShowcaseServiceHandler ConnectRPC surface (EF-01, api_endpoint_map.md §7.4).
type ProductShowcaseManager struct {
	store   Store
	service *Service
}

var _ productionv1connect.ProductShowcaseServiceHandler = (*ProductShowcaseManager)(nil)

// NewProductShowcaseManager constructs a new ProductShowcaseManager.
func NewProductShowcaseManager(store Store, svc *Service) *ProductShowcaseManager {
	return &ProductShowcaseManager{
		store:   store,
		service: svc,
	}
}

// CanonicalShowcaseStyleName converts ShowcaseStyle enum to canonical string identifier.
func CanonicalShowcaseStyleName(style productionv1.ShowcaseStyle) string {
	switch style {
	case productionv1.ShowcaseStyle_SHOWCASE_STYLE_360_SPIN:
		return "360_spin"
	case productionv1.ShowcaseStyle_SHOWCASE_STYLE_TABLETOP_DEMO:
		return "tabletop_demo"
	case productionv1.ShowcaseStyle_SHOWCASE_STYLE_FLIP_REVEAL:
		return "flip_reveal"
	case productionv1.ShowcaseStyle_SHOWCASE_STYLE_VIRTUAL_TRY_ON:
		return "virtual_try_on"
	case productionv1.ShowcaseStyle_SHOWCASE_STYLE_LIFESTYLE_CONTEXT:
		return "lifestyle_context"
	case productionv1.ShowcaseStyle_SHOWCASE_STYLE_UNBOXING_SIMULATION:
		return "unboxing_simulation"
	case productionv1.ShowcaseStyle_SHOWCASE_STYLE_BEFORE_AFTER:
		return "before_after"
	case productionv1.ShowcaseStyle_SHOWCASE_STYLE_REVIEW_STYLE:
		return "review_style"
	default:
		return "tabletop_demo"
	}
}

// EstimateShowcaseCredits returns estimated credits (8-40) based on showcase style.
func EstimateShowcaseCredits(style productionv1.ShowcaseStyle) tenantdb.ExactDecimal {
	switch style {
	case productionv1.ShowcaseStyle_SHOWCASE_STYLE_360_SPIN:
		return tenantdb.MustParseExactDecimal("25.000000")
	case productionv1.ShowcaseStyle_SHOWCASE_STYLE_VIRTUAL_TRY_ON:
		return tenantdb.MustParseExactDecimal("35.000000")
	case productionv1.ShowcaseStyle_SHOWCASE_STYLE_REVIEW_STYLE:
		return tenantdb.MustParseExactDecimal("30.000000")
	case productionv1.ShowcaseStyle_SHOWCASE_STYLE_LIFESTYLE_CONTEXT:
		return tenantdb.MustParseExactDecimal("20.000000")
	case productionv1.ShowcaseStyle_SHOWCASE_STYLE_UNBOXING_SIMULATION:
		return tenantdb.MustParseExactDecimal("20.000000")
	case productionv1.ShowcaseStyle_SHOWCASE_STYLE_FLIP_REVEAL:
		return tenantdb.MustParseExactDecimal("15.000000")
	case productionv1.ShowcaseStyle_SHOWCASE_STYLE_BEFORE_AFTER:
		return tenantdb.MustParseExactDecimal("15.000000")
	case productionv1.ShowcaseStyle_SHOWCASE_STYLE_TABLETOP_DEMO:
		return tenantdb.MustParseExactDecimal("15.000000")
	default:
		return tenantdb.MustParseExactDecimal("15.000000")
	}
}

// ValidateProductAttributes checks required and optional attributes, returning structured explanations.
func ValidateProductAttributes(style productionv1.ShowcaseStyle, imageCount int, description string, price float64) ([]*productionv1.MissingProductAttribute, bool) {
	var explanations []*productionv1.MissingProductAttribute
	isBlocked := false

	// Image validations
	if imageCount == 0 {
		isBlocked = true
		explanations = append(explanations, &productionv1.MissingProductAttribute{
			Attribute:          "images",
			Level:              "blocking",
			Message:            "Không tìm thấy hình ảnh sản phẩm.",
			ActionableRecovery: "Vui lòng tải lên ít nhất 1-4 hình ảnh sản phẩm để bắt đầu tạo video.",
		})
	} else if style == productionv1.ShowcaseStyle_SHOWCASE_STYLE_360_SPIN && imageCount < 8 {
		isBlocked = true
		explanations = append(explanations, &productionv1.MissingProductAttribute{
			Attribute:          "images",
			Level:              "blocking",
			Message:            fmt.Sprintf("Cần 8+ ảnh cho chế độ 360° (hiện có %d ảnh).", imageCount),
			ActionableRecovery: "Tải lên tối thiểu 8 ảnh chụp quanh các góc 360 độ của sản phẩm hoặc chọn phong cách khác.",
		})
	} else if imageCount < 2 {
		explanations = append(explanations, &productionv1.MissingProductAttribute{
			Attribute:          "images",
			Level:              "warning",
			Message:            "Nên có ít nhất 4 ảnh cho showcase tốt nhất.",
			ActionableRecovery: "Tải lên thêm ảnh chụp chi tiết, bao bì hoặc góc cạnh để video phong phú hơn.",
		})
	}

	// Description validation
	if strings.TrimSpace(description) == "" {
		explanations = append(explanations, &productionv1.MissingProductAttribute{
			Attribute:          "description",
			Level:              "warning",
			Message:            "Sản phẩm chưa có mô tả chi tiết.",
			ActionableRecovery: "Tự động tắt tạo kịch bản tự động; vui lòng nhập kịch bản thủ công hoặc bổ sung mô tả.",
		})
	}

	// Price validation
	if price <= 0 {
		explanations = append(explanations, &productionv1.MissingProductAttribute{
			Attribute:          "price",
			Level:              "warning",
			Message:            "Chưa có thông tin giá sản phẩm hoặc giá = 0.",
			ActionableRecovery: "Tùy chọn hiển thị giá đã tự động tắt trên video showcase.",
		})
	}

	return explanations, isBlocked
}

// Create handles ProductShowcaseService/Create ConnectRPC requests.
func (m *ProductShowcaseManager) Create(ctx context.Context, req *connect.Request[productionv1.ProductShowcaseServiceCreateRequest]) (*connect.Response[productionv1.ProductShowcaseServiceCreateResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if caller.WorkspaceID == "" {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if !caller.HasRole("Editor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	style := req.Msg.GetStyle()
	if style == productionv1.ShowcaseStyle_SHOWCASE_STYLE_UNSPECIFIED {
		style = productionv1.ShowcaseStyle_SHOWCASE_STYLE_TABLETOP_DEMO
	}

	images := req.Msg.GetManualImageUrls()
	desc := req.Msg.GetManualDescription()
	price := 100.0 // Default or extracted

	explanations, isBlocked := ValidateProductAttributes(style, len(images), desc, price)
	if isBlocked {
		return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("production: product showcase validation failed: %s", explanations[0].GetMessage()))
	}

	creditsNeeded := EstimateShowcaseCredits(style)
	bal := m.service.GetWorkspaceBalance(caller.WorkspaceID)
	if bal.Cmp(creditsNeeded) < 0 {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrInsufficientCredits)
	}

	// Deduct credits
	if err := m.service.DeductCredits(caller.WorkspaceID, creditsNeeded); err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to deduct showcase credits: %w", err))
	}

	jobID := fmt.Sprintf("psj-%d", time.Now().UnixNano())
	now := time.Now().UTC()

	customizationBytes, _ := json.Marshal(req.Msg.GetCustomization())

	rec := &ProductShowcaseJobRecord{
		ShowcaseJobID:     jobID,
		WorkspaceID:       caller.WorkspaceID,
		ProductID:         req.Msg.GetProductId(),
		Style:             CanonicalShowcaseStyleName(style),
		CustomizationJSON: string(customizationBytes),
		CharacterID:       req.Msg.GetCharacterId(),
		Status:            "queued",
		CreditsUsed:       creditsNeeded,
		CreatedAt:         now,
		UpdatedAt:         now,
	}

	if err := m.store.CreateShowcaseJob(ctx, rec); err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to store showcase job: %w", err))
	}

	jobProto := &productionv1.ProductShowcaseJob{
		ShowcaseJobId:         rec.ShowcaseJobID,
		WorkspaceId:           rec.WorkspaceID,
		ProductId:             rec.ProductID,
		Style:                 style,
		Customization:         req.Msg.GetCustomization(),
		CharacterId:           rec.CharacterID,
		Status:                rec.Status,
		CreditsUsed:           rec.CreditsUsed.String(),
		AttributeExplanations: explanations,
		CreatedAt:             timestamppb.New(now),
		UpdatedAt:             timestamppb.New(now),
	}

	return connect.NewResponse(&productionv1.ProductShowcaseServiceCreateResponse{
		Job:              jobProto,
		Warnings:         explanations,
		EstimatedCredits: creditsNeeded.String(),
	}), nil
}

// CreateBatch handles ProductShowcaseService/CreateBatch ConnectRPC requests (batch mode up to 20 products).
func (m *ProductShowcaseManager) CreateBatch(ctx context.Context, req *connect.Request[productionv1.ProductShowcaseServiceCreateBatchRequest]) (*connect.Response[productionv1.ProductShowcaseServiceCreateBatchResponse], error) {
	wsID := ""
	if req.Msg.GetContext() != nil && req.Msg.GetContext().GetWorkspaceId() != nil {
		wsID = req.Msg.GetContext().GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if caller.WorkspaceID == "" {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if !caller.HasRole("Editor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	items := req.Msg.GetItems()
	if len(items) == 0 {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("production: batch must contain at least 1 item"))
	}
	if len(items) > 20 {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("production: batch exceeds maximum limit of 20 products per batch"))
	}

	batchID := fmt.Sprintf("batch-showcase-%d", time.Now().UnixNano())
	isDryRun := req.Msg.GetDryRun()

	var results []*productionv1.ProductShowcaseBatchItemResult
	totalCreditsQuoted := tenantdb.MustParseExactDecimal("0.000000")
	validCount := 0
	invalidCount := 0

	for idx, item := range items {
		style := item.GetStyle()
		if style == productionv1.ShowcaseStyle_SHOWCASE_STYLE_UNSPECIFIED {
			style = productionv1.ShowcaseStyle_SHOWCASE_STYLE_TABLETOP_DEMO
		}

		images := item.GetManualImageUrls()
		explanations, isBlocked := ValidateProductAttributes(style, len(images), "Batch product item", 150.0)

		res := &productionv1.ProductShowcaseBatchItemResult{
			ItemIndex:             int32(idx),
			ProductId:             item.GetProductId(),
			AttributeExplanations: explanations,
		}

		if isBlocked {
			invalidCount++
			res.Valid = false
			res.RejectionReason = explanations[0].GetMessage()
			res.CreditsRequired = "0.000000"
		} else {
			validCount++
			res.Valid = true
			cost := EstimateShowcaseCredits(style)
			res.CreditsRequired = cost.String()
			totalCreditsQuoted, _ = totalCreditsQuoted.Add(cost)

			if !isDryRun {
				jobID := fmt.Sprintf("psj-%s-%d", batchID, idx)
				customBytes, _ := json.Marshal(item.GetCustomization())
				rec := &ProductShowcaseJobRecord{
					ShowcaseJobID:     jobID,
					WorkspaceID:       caller.WorkspaceID,
					ProductID:         item.GetProductId(),
					Style:             CanonicalShowcaseStyleName(style),
					CustomizationJSON: string(customBytes),
					BatchID:           batchID,
					CharacterID:       item.GetCharacterId(),
					Status:            "queued",
					CreditsUsed:       cost,
					CreatedAt:         time.Now().UTC(),
					UpdatedAt:         time.Now().UTC(),
				}
				_ = m.store.CreateShowcaseJob(ctx, rec)
				res.ShowcaseJobId = jobID
			}
		}
		results = append(results, res)
	}

	// If not dry run and valid items exist, verify and deduct total credits for valid items only
	if !isDryRun && validCount > 0 {
		bal := m.service.GetWorkspaceBalance(caller.WorkspaceID)
		if bal.Cmp(totalCreditsQuoted) < 0 {
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrInsufficientCredits)
		}
		if err := m.service.DeductCredits(caller.WorkspaceID, totalCreditsQuoted); err != nil {
			return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("failed to deduct batch credits: %w", err))
		}
	}

	return connect.NewResponse(&productionv1.ProductShowcaseServiceCreateBatchResponse{
		BatchId:            batchID,
		IsDryRun:           isDryRun,
		TotalItems:         int32(len(items)),
		ValidItems:         int32(validCount),
		InvalidItems:       int32(invalidCount),
		TotalCreditsQuoted: totalCreditsQuoted.String(),
		Results:            results,
	}), nil
}

// Get handles ProductShowcaseService/Get ConnectRPC requests.
func (m *ProductShowcaseManager) Get(ctx context.Context, req *connect.Request[productionv1.ProductShowcaseServiceGetRequest]) (*connect.Response[productionv1.ProductShowcaseServiceGetResponse], error) {
	wsID := ""
	if req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if caller.WorkspaceID == "" {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if !caller.HasRole("Contributor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	rec, err := m.store.GetShowcaseJob(ctx, caller.WorkspaceID, req.Msg.GetShowcaseJobId())
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrShowcaseJobNotFound)
	}

	jobProto := &productionv1.ProductShowcaseJob{
		ShowcaseJobId: rec.ShowcaseJobID,
		WorkspaceId:   rec.WorkspaceID,
		ProductId:     rec.ProductID,
		CharacterId:   rec.CharacterID,
		BatchId:       rec.BatchID,
		Status:        rec.Status,
		CreditsUsed:   rec.CreditsUsed.String(),
		CreatedAt:     timestamppb.New(rec.CreatedAt),
		UpdatedAt:     timestamppb.New(rec.UpdatedAt),
	}

	return connect.NewResponse(&productionv1.ProductShowcaseServiceGetResponse{
		Job: jobProto,
	}), nil
}

// List handles ProductShowcaseService/List ConnectRPC requests.
func (m *ProductShowcaseManager) List(ctx context.Context, req *connect.Request[productionv1.ProductShowcaseServiceListRequest]) (*connect.Response[productionv1.ProductShowcaseServiceListResponse], error) {
	wsID := ""
	if req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	caller := extractCallerContext(ctx, wsID)
	if caller.WorkspaceID == "" {
		return nil, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}
	if !caller.HasRole("Contributor") {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	records, _, err := m.store.ListShowcaseJobs(ctx, caller.WorkspaceID, req.Msg.GetProductId(), req.Msg.GetBatchId(), int(req.Msg.GetLimit()), 0)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	var jobs []*productionv1.ProductShowcaseJob
	for _, rec := range records {
		jobs = append(jobs, &productionv1.ProductShowcaseJob{
			ShowcaseJobId: rec.ShowcaseJobID,
			WorkspaceId:   rec.WorkspaceID,
			ProductId:     rec.ProductID,
			CharacterId:   rec.CharacterID,
			BatchId:       rec.BatchID,
			Status:        rec.Status,
			CreditsUsed:   rec.CreditsUsed.String(),
			CreatedAt:     timestamppb.New(rec.CreatedAt),
			UpdatedAt:     timestamppb.New(rec.UpdatedAt),
		})
	}

	return connect.NewResponse(&productionv1.ProductShowcaseServiceListResponse{
		Jobs: jobs,
	}), nil
}
