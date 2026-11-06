package diagnostics

import (
	"context"
	"crypto/rand"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"sync"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"
	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1/adminv1connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/outbox"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/timestamppb"
)

var (
	// ErrUnauthenticated is returned when ActorContext is missing or invalid.
	ErrUnauthenticated = errors.New("diagnostics: unauthenticated request")
	// ErrInvalidInput is returned when request fields fail validation.
	ErrInvalidInput = errors.New("diagnostics: invalid request input (VALIDATION_ERROR_001)")
	// ErrIdempotencyConflict is returned when an idempotency key is reused with a different request payload.
	ErrIdempotencyConflict = errors.New("diagnostics: idempotency key reused with different payload (SYSTEM_CONFLICT_001)")
	// ErrIssueNotFound is returned when a diagnostic issue does not exist in the caller's workspace.
	ErrIssueNotFound = errors.New("diagnostics: diagnostic issue not found in workspace")
	// ErrRepairVerificationRequired is returned when Step 3 (FIX) on an unknown external effect lacks verification_reference.
	ErrRepairVerificationRequired = errors.New("diagnostics: resolving an unknown external effect requires verification_reference proof")
)

// ActorContext carries the authenticated caller's workspace membership role for domain/Connect calls.
type ActorContext struct {
	UserID           string
	WorkspaceID      string
	WorkspaceRole    string
	WorkspaceActive  bool
	MembershipActive bool
}

type actorContextKey struct{}

// WithActorContext attaches an ActorContext to ctx.
func WithActorContext(ctx context.Context, actor ActorContext) context.Context {
	return context.WithValue(ctx, actorContextKey{}, actor)
}

// ActorFromContext extracts ActorContext from ctx.
func ActorFromContext(ctx context.Context) (ActorContext, bool) {
	if ctx == nil {
		return ActorContext{}, false
	}
	a, ok := ctx.Value(actorContextKey{}).(ActorContext)
	return a, ok
}

// Canonical 8 diagnostic categories for W125 (Web Diagnostics Center) & M059 (Mobile Diagnostics).
type CategoryMeta struct {
	Key         string
	DisplayName string
	DefaultDesc string
}

var CanonicalCategories = []CategoryMeta{
	{Key: "connected_accounts", DisplayName: "Tài khoản kết nối", DefaultDesc: "OAuth token và quyền truy cập nền tảng ổn định."},
	{Key: "publish_pipeline", DisplayName: "Luồng đăng bài & lịch phát", DefaultDesc: "Hàng đợi đăng bài hoạt động bình thường."},
	{Key: "order_inventory_sync", DisplayName: "Đồng bộ đơn hàng & tồn kho", DefaultDesc: "Đồng bộ đơn hàng và giữ chỗ tồn kho khớp dữ liệu."},
	{Key: "webhook_delivery", DisplayName: "Webhook & Public API", DefaultDesc: "Webhook inbound/outbound xử lý đúng hạn."},
	{Key: "ai_generation_credits", DisplayName: "AI Studio & Hạn mức Credits", DefaultDesc: "Nhà cung cấp AI và sổ cái Credits hoạt động tốt."},
	{Key: "workflow_automation", DisplayName: "Quy trình tự động hóa", DefaultDesc: "Workflow trigger và các bước chạy ổn định."},
	{Key: "reconciliation_settlement", DisplayName: "Đối soát & Thanh toán", DefaultDesc: "Chứng từ đối soát không có sai lệch chưa xử lý."},
	{Key: "outbox_external_effects", DisplayName: "Hàng đợi bền vững & Tác vụ ngoài", DefaultDesc: "Outbox/Inbox và external effects đã đồng bộ."},
}

var rawTechnicalPatterns = []string{
	"select ",
	"insert into ",
	"update ",
	"delete from ",
	"sqlstate",
	"goroutine ",
	"panic:",
	"access_token",
	"refresh_token",
	"signing_secret",
}

// SanitizeUserFacingText enforces RULE-M23-A04: user-facing diagnostic messages must never expose
// raw SQL queries, stack traces, or credentials/tokens.
func SanitizeUserFacingText(text string) string {
	trimmed := strings.TrimSpace(text)
	lower := strings.ToLower(trimmed)
	for _, pat := range rawTechnicalPatterns {
		if strings.Contains(lower, pat) {
			return "Hệ thống phát hiện sự cố kỹ thuật trên thành phần này. Vui lòng sử dụng Trình sửa lỗi 4 bước để kiểm tra và khắc phục an toàn."
		}
	}
	if trimmed == "" {
		return "Hệ thống ghi nhận cảnh báo cần kiểm tra."
	}
	return trimmed
}

type cachedCommandResult struct {
	requestHash string
	response    any
}

// Service implements DiagnosticsService (M23) and satisfies adminv1connect.DiagnosticsServiceHandler.
type Service struct {
	adminv1connect.UnimplementedDiagnosticsServiceHandler

	mu          sync.Mutex
	Bindings    *rbac.Registry
	Beginner    tenantdb.TxBeginner
	EffectGuard *outbox.ExternalEffectGuard
	DLQ         *outbox.DLQManager
	IDGenerator func() string
	Now         func() time.Time

	issues      map[string]map[string]*tenantdb.DiagnosticRecordRow // workspaceID -> diagnosticsID -> row
	idempotency map[string]cachedCommandResult
	audits      []outbox.AuditLogEntry
}

// NewService constructs a DiagnosticsService.
func NewService(bindings *rbac.Registry, effectGuard *outbox.ExternalEffectGuard, dlq *outbox.DLQManager) *Service {
	if effectGuard == nil {
		effectGuard = outbox.NewExternalEffectGuard()
	}
	if dlq == nil {
		dlq = outbox.NewDLQManager(effectGuard)
	}
	return &Service{
		Bindings:    bindings,
		EffectGuard: effectGuard,
		DLQ:         dlq,
		IDGenerator: generateUUIDv4,
		Now:         func() time.Time { return time.Now().UTC() },
		issues:      make(map[string]map[string]*tenantdb.DiagnosticRecordRow),
		idempotency: make(map[string]cachedCommandResult),
	}
}

func generateUUIDv4() string {
	var b [16]byte
	if _, err := rand.Read(b[:]); err != nil {
		panic(fmt.Sprintf("diagnostics: crypto/rand failed: %v", err))
	}
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x", b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

func hashIdempotencyPayload(parts ...string) string {
	h := sha256.New()
	for _, p := range parts {
		h.Write([]byte(p))
		h.Write([]byte{0})
	}
	return hex.EncodeToString(h.Sum(nil))
}

func (s *Service) authorize(ctx context.Context, rpcName, requestedWorkspaceID string) (ActorContext, error) {
	actor, ok := ActorFromContext(ctx)
	if !ok || !tenantdb.IsValidNonZeroUUID(actor.UserID) || !tenantdb.IsValidNonZeroUUID(actor.WorkspaceID) {
		return ActorContext{}, ErrUnauthenticated
	}
	if !actor.WorkspaceActive || !actor.MembershipActive {
		return ActorContext{}, rbac.ErrPermissionDenied
	}
	if requestedWorkspaceID != "" && requestedWorkspaceID != actor.WorkspaceID {
		return ActorContext{}, tenantdb.ErrScopeMismatch
	}
	if s.Bindings == nil {
		return ActorContext{}, errors.New("diagnostics: missing RBAC registry")
	}
	_, err := s.Bindings.Authorize(rpcName, rbac.PolicyContext{
		ActorUserID: actor.UserID,
		WorkspaceID: actor.WorkspaceID,
		Role:        actor.WorkspaceRole,
	})
	if err != nil {
		return ActorContext{}, err
	}
	return actor, nil
}

// SeedIssue registers a diagnostic issue in the workspace (and persists to PostgreSQL if Beginner is configured).
func (s *Service) SeedIssue(ctx context.Context, row tenantdb.DiagnosticRecordRow) (tenantdb.DiagnosticRecordRow, error) {
	if !tenantdb.IsValidNonZeroUUID(row.WorkspaceID) {
		return tenantdb.DiagnosticRecordRow{}, tenantdb.ErrInvalidTenantScope
	}
	if !tenantdb.IsValidNonZeroUUID(row.DiagnosticsID) {
		row.DiagnosticsID = s.IDGenerator()
	}
	row.UserFacingExplanation = SanitizeUserFacingText(row.UserFacingExplanation)
	if len(row.LikelyCauses) == 0 {
		row.LikelyCauses = []string{"Cấu hình kết nối hoặc phản hồi từ nền tảng đối tác thay đổi."}
	}
	if len(row.SuggestedActions) == 0 {
		row.SuggestedActions = []string{"Mở Trình sửa lỗi 4 bước để xác minh và khắc phục."}
	}
	if row.Status == "" {
		row.Status = "open"
	}
	now := s.Now()
	if row.DetectedAt.IsZero() {
		row.DetectedAt = now
	}
	row.CreatedAt = now
	row.UpdatedAt = now

	s.mu.Lock()
	wsIssues, ok := s.issues[row.WorkspaceID]
	if !ok {
		wsIssues = make(map[string]*tenantdb.DiagnosticRecordRow)
		s.issues[row.WorkspaceID] = wsIssues
	}
	cp := row
	wsIssues[row.DiagnosticsID] = &cp
	s.mu.Unlock()

	if s.Beginner != nil {
		if actor, ok := ActorFromContext(ctx); ok && actor.WorkspaceID == row.WorkspaceID {
			var persisted tenantdb.DiagnosticRecordRow
			err := tenantdb.WithTx(ctx, s.Beginner, tenantdb.Scope{
				WorkspaceID:             actor.WorkspaceID,
				UserID:                  actor.UserID,
				RequireActiveMembership: true,
			}, func(txCtx context.Context, q *tenantdb.Queries) error {
				var txErr error
				persisted, txErr = q.InsertDiagnosticRecord(txCtx, tenantdb.InsertDiagnosticRecordParams{
					DiagnosticsID:         row.DiagnosticsID,
					WorkspaceID:           row.WorkspaceID,
					ScopeType:             row.ScopeType,
					ScopeID:               row.ScopeID,
					ErrorType:             row.ErrorType,
					Severity:              row.Severity,
					UserFacingExplanation: row.UserFacingExplanation,
					OperatorExplanation:   row.OperatorExplanation,
					LikelyCauses:          row.LikelyCauses,
					SuggestedActions:      row.SuggestedActions,
					RepairPath:            row.RepairPath,
					Status:                row.Status,
				})
				return txErr
			})
			if err != nil {
				return tenantdb.DiagnosticRecordRow{}, err
			}
			return persisted, nil
		}
	}
	return cp, nil
}

func (s *Service) loadWorkspaceDiagnosticsState(ctx context.Context, actor ActorContext) ([]tenantdb.DiagnosticRecordRow, int32, int32, error) {
	if s.Beginner != nil {
		var records []tenantdb.DiagnosticRecordRow
		var unknownCount, dlqCount int32
		err := tenantdb.WithTx(ctx, s.Beginner, tenantdb.Scope{
			WorkspaceID:             actor.WorkspaceID,
			UserID:                  actor.UserID,
			RequireActiveMembership: true,
		}, func(txCtx context.Context, q *tenantdb.Queries) error {
			var txErr error
			records, txErr = q.ListDiagnosticRecords(txCtx, actor.WorkspaceID)
			if txErr != nil {
				return txErr
			}
			unknownCount, txErr = q.CountUnknownExternalEffects(txCtx, actor.WorkspaceID)
			if txErr != nil {
				return txErr
			}
			dlqCount, txErr = q.CountPendingDLQEntries(txCtx, actor.WorkspaceID)
			return txErr
		})
		if err != nil {
			return nil, 0, 0, err
		}
		return records, unknownCount, dlqCount, nil
	}

	s.mu.Lock()
	wsIssues := s.issues[actor.WorkspaceID]
	records := make([]tenantdb.DiagnosticRecordRow, 0, len(wsIssues))
	for _, iss := range wsIssues {
		records = append(records, *iss)
	}
	s.mu.Unlock()

	unknownCount := int32(s.EffectGuard.CountUnknownEffects(actor.WorkspaceID))
	dlqCount := int32(s.DLQ.CountPendingByWorkspace(actor.WorkspaceID))
	return records, unknownCount, dlqCount, nil
}

// GetOverview implements DiagnosticsService/GetOverview (requires diagnostics:read).
func (s *Service) GetOverview(
	ctx context.Context,
	req *connect.Request[adminv1.GetOverviewRequest],
) (*connect.Response[adminv1.GetOverviewResponse], error) {
	wsID := ""
	if req.Msg != nil && req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	actor, err := s.authorize(ctx, "DiagnosticsService/GetOverview", wsID)
	if err != nil {
		return nil, toConnectError(err)
	}

	records, unknownCount, dlqCount, err := s.loadWorkspaceDiagnosticsState(ctx, actor)
	if err != nil {
		return nil, toConnectError(err)
	}

	var activeCount, criticalCount, warningCount int32
	affectedCategories := make(map[string]struct{})
	for _, iss := range records {
		if iss.Status == "resolved" || iss.Status == "closed" {
			continue
		}
		activeCount++
		affectedCategories[mapScopeToCategory(iss.ScopeType)] = struct{}{}
		switch iss.Severity {
		case "critical", "error":
			criticalCount++
		case "warning":
			warningCount++
		}
	}

	if unknownCount > 0 {
		affectedCategories["outbox_external_effects"] = struct{}{}
	}
	if dlqCount > 0 {
		affectedCategories["outbox_external_effects"] = struct{}{}
	}

	totalCats := int32(len(CanonicalCategories))
	healthyCats := totalCats - int32(len(affectedCategories))
	if healthyCats < 0 {
		healthyCats = 0
	}

	overall := adminv1.DiagnosticHealthStatus_DIAGNOSTIC_HEALTH_STATUS_HEALTHY
	if criticalCount > 0 {
		overall = adminv1.DiagnosticHealthStatus_DIAGNOSTIC_HEALTH_STATUS_CRITICAL
	} else if warningCount > 0 || unknownCount > 0 || dlqCount > 0 {
		overall = adminv1.DiagnosticHealthStatus_DIAGNOSTIC_HEALTH_STATUS_WARNING
	}

	resp := &adminv1.GetOverviewResponse{
		WorkspaceId:                 &commonv1.UUID{Value: actor.WorkspaceID},
		OverallStatus:               overall,
		ActiveIssuesCount:           activeCount,
		CriticalIssuesCount:         criticalCount,
		WarningIssuesCount:          warningCount,
		HealthyCategoriesCount:      healthyCats,
		TotalCategoriesCount:        totalCats,
		UnknownExternalEffectsCount: unknownCount,
		PendingDlqCount:             dlqCount,
		LastCheckedAt:               timestamppb.New(s.Now()),
	}
	return connect.NewResponse(resp), nil
}

// GetHealthGrid implements DiagnosticsService/GetHealthGrid (requires diagnostics:read).
func (s *Service) GetHealthGrid(
	ctx context.Context,
	req *connect.Request[adminv1.GetHealthGridRequest],
) (*connect.Response[adminv1.GetHealthGridResponse], error) {
	wsID := ""
	if req.Msg != nil && req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	actor, err := s.authorize(ctx, "DiagnosticsService/GetHealthGrid", wsID)
	if err != nil {
		return nil, toConnectError(err)
	}

	records, unknownCount, dlqCount, err := s.loadWorkspaceDiagnosticsState(ctx, actor)
	if err != nil {
		return nil, toConnectError(err)
	}

	now := s.Now()
	cards := buildCategoryCardsFromState(records, unknownCount, dlqCount, now)
	return connect.NewResponse(&adminv1.GetHealthGridResponse{
		WorkspaceId: &commonv1.UUID{Value: actor.WorkspaceID},
		Categories:  cards,
		GeneratedAt: timestamppb.New(now),
	}), nil
}

// ListIssues implements DiagnosticsService/ListIssues (requires diagnostics:read).
func (s *Service) ListIssues(
	ctx context.Context,
	req *connect.Request[adminv1.ListIssuesRequest],
) (*connect.Response[adminv1.ListIssuesResponse], error) {
	wsID := ""
	if req.Msg != nil && req.Msg.GetWorkspaceId() != nil {
		wsID = req.Msg.GetWorkspaceId().GetValue()
	}
	actor, err := s.authorize(ctx, "DiagnosticsService/ListIssues", wsID)
	if err != nil {
		return nil, toConnectError(err)
	}

	records, _, _, err := s.loadWorkspaceDiagnosticsState(ctx, actor)
	if err != nil {
		return nil, toConnectError(err)
	}

	var out []*adminv1.DiagnosticIssue
	for _, iss := range records {
		protoIss := toProtoIssue(iss)
		if req.Msg != nil {
			if req.Msg.GetSeverityFilter() != adminv1.DiagnosticSeverity_DIAGNOSTIC_SEVERITY_UNSPECIFIED &&
				protoIss.GetSeverity() != req.Msg.GetSeverityFilter() {
				continue
			}
			if req.Msg.GetStatusFilter() != adminv1.DiagnosticIssueStatus_DIAGNOSTIC_ISSUE_STATUS_UNSPECIFIED &&
				protoIss.GetStatus() != req.Msg.GetStatusFilter() {
				continue
			}
			if sf := strings.TrimSpace(req.Msg.GetScopeTypeFilter()); sf != "" && iss.ScopeType != sf {
				continue
			}
		}
		out = append(out, protoIss)
	}

	total := int64(len(out))
	return connect.NewResponse(&adminv1.ListIssuesResponse{
		Issues: out,
		Pagination: &commonv1.PaginatedResponse{
			TotalCount: &total,
			HasMore:    false,
		},
	}), nil
}

// RunFullCheck implements DiagnosticsService/RunFullCheck (requires workspace:settings:manage).
func (s *Service) RunFullCheck(
	ctx context.Context,
	req *connect.Request[adminv1.RunFullCheckRequest],
) (*connect.Response[adminv1.RunFullCheckResponse], error) {
	if req.Msg == nil || req.Msg.GetContext() == nil {
		return nil, toConnectError(ErrInvalidInput)
	}
	cmdCtx := req.Msg.GetContext()
	idemKey := strings.TrimSpace(cmdCtx.GetIdempotencyKey())
	if idemKey == "" || len(idemKey) > 255 {
		return nil, toConnectError(fmt.Errorf("%w: idempotency_key is required", ErrInvalidInput))
	}
	wsID := ""
	if cmdCtx.GetWorkspaceId() != nil {
		wsID = cmdCtx.GetWorkspaceId().GetValue()
	}
	actor, err := s.authorize(ctx, "DiagnosticsService/RunFullCheck", wsID)
	if err != nil {
		return nil, toConnectError(err)
	}

	reqHash := hashIdempotencyPayload("RunFullCheck", actor.WorkspaceID, cmdCtx.GetReason())
	cacheKey := actor.WorkspaceID + "::" + actor.UserID + "::DiagnosticsService/RunFullCheck::" + idemKey

	s.mu.Lock()
	if prev, ok := s.idempotency[cacheKey]; ok {
		s.mu.Unlock()
		if prev.requestHash != reqHash {
			return nil, toConnectError(ErrIdempotencyConflict)
		}
		cloned := proto.Clone(prev.response.(*adminv1.RunFullCheckResponse)).(*adminv1.RunFullCheckResponse)
		cloned.Replayed = true
		return connect.NewResponse(cloned), nil
	}
	s.mu.Unlock()

	records, unknownEffects, dlqCount, err := s.loadWorkspaceDiagnosticsState(ctx, actor)
	if err != nil {
		return nil, toConnectError(err)
	}

	now := s.Now()
	cards := buildCategoryCardsFromState(records, unknownEffects, dlqCount, now)

	var openIssues int32
	overall := adminv1.DiagnosticHealthStatus_DIAGNOSTIC_HEALTH_STATUS_HEALTHY
	for _, c := range cards {
		openIssues += c.GetOpenIssuesCount()
		if c.GetStatus() == adminv1.DiagnosticHealthStatus_DIAGNOSTIC_HEALTH_STATUS_CRITICAL {
			overall = adminv1.DiagnosticHealthStatus_DIAGNOSTIC_HEALTH_STATUS_CRITICAL
		} else if c.GetStatus() == adminv1.DiagnosticHealthStatus_DIAGNOSTIC_HEALTH_STATUS_WARNING &&
			overall == adminv1.DiagnosticHealthStatus_DIAGNOSTIC_HEALTH_STATUS_HEALTHY {
			overall = adminv1.DiagnosticHealthStatus_DIAGNOSTIC_HEALTH_STATUS_WARNING
		}
	}

	checkID := s.IDGenerator()
	if s.Beginner != nil {
		if err := tenantdb.WithTx(ctx, s.Beginner, tenantdb.Scope{
			WorkspaceID:             actor.WorkspaceID,
			UserID:                  actor.UserID,
			RequireActiveMembership: true,
		}, func(txCtx context.Context, q *tenantdb.Queries) error {
			return q.InsertAuditEvent(txCtx, tenantdb.AuditEventParams{
				AuditEventID: checkID,
				WorkspaceID:  actor.WorkspaceID,
				ActorUserID:  actor.UserID,
				ActorType:    "user",
				Action:       "diagnostics.full_check_completed",
				ResourceType: "workspace",
				ResourceID:   actor.WorkspaceID,
				Reason:       cmdCtx.GetReason(),
			})
		}); err != nil {
			return nil, toConnectError(err)
		}
	}

	resp := &adminv1.RunFullCheckResponse{
		CheckRunId:             &commonv1.UUID{Value: checkID},
		OverallStatus:          overall,
		IssuesDetected:         openIssues,
		UnknownEffectsDetected: unknownEffects,
		Categories:             cards,
		CompletedAt:            timestamppb.New(now),
		Replayed:               false,
	}

	s.mu.Lock()
	s.idempotency[cacheKey] = cachedCommandResult{
		requestHash: reqHash,
		response:    resp,
	}
	s.audits = append(s.audits, outbox.AuditLogEntry{
		AuditEventID: checkID,
		WorkspaceID:  actor.WorkspaceID,
		ActorID:      actor.UserID,
		ActorType:    "user",
		Action:       "diagnostics.full_check_completed",
		ResourceType: "workspace",
		ResourceID:   actor.WorkspaceID,
		Reason:       cmdCtx.GetReason(),
		CreatedAt:    now,
	})
	s.mu.Unlock()

	return connect.NewResponse(resp), nil
}

// ExecuteRepairStep implements DiagnosticsService/ExecuteRepairStep (requires workspace:settings:manage).
// Enforces the 4-step wizard flow (VERIFY -> DIAGNOSE -> FIX -> CONFIRM) and refuses to resolve
// an unknown external effect without explicit verification_reference proof.
func (s *Service) ExecuteRepairStep(
	ctx context.Context,
	req *connect.Request[adminv1.ExecuteRepairStepRequest],
) (*connect.Response[adminv1.ExecuteRepairStepResponse], error) {
	if req.Msg == nil || req.Msg.GetContext() == nil || req.Msg.GetDiagnosticsId() == nil {
		return nil, toConnectError(ErrInvalidInput)
	}
	cmdCtx := req.Msg.GetContext()
	idemKey := strings.TrimSpace(cmdCtx.GetIdempotencyKey())
	diagID := strings.TrimSpace(req.Msg.GetDiagnosticsId().GetValue())
	step := req.Msg.GetStep()
	if idemKey == "" || !tenantdb.IsValidNonZeroUUID(diagID) || step == adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_UNSPECIFIED {
		return nil, toConnectError(ErrInvalidInput)
	}

	wsID := ""
	if cmdCtx.GetWorkspaceId() != nil {
		wsID = cmdCtx.GetWorkspaceId().GetValue()
	}
	actor, err := s.authorize(ctx, "DiagnosticsService/ExecuteRepairStep", wsID)
	if err != nil {
		return nil, toConnectError(err)
	}

	reqHash := hashIdempotencyPayload(
		"ExecuteRepairStep",
		actor.WorkspaceID,
		diagID,
		step.String(),
		req.Msg.GetActionKey(),
		req.Msg.GetVerificationReference(),
	)
	cacheKey := actor.WorkspaceID + "::" + actor.UserID + "::DiagnosticsService/ExecuteRepairStep::" + idemKey

	s.mu.Lock()
	if prev, ok := s.idempotency[cacheKey]; ok {
		s.mu.Unlock()
		if prev.requestHash != reqHash {
			return nil, toConnectError(ErrIdempotencyConflict)
		}
		cloned := proto.Clone(prev.response.(*adminv1.ExecuteRepairStepResponse)).(*adminv1.ExecuteRepairStepResponse)
		cloned.Replayed = true
		return connect.NewResponse(cloned), nil
	}
	s.mu.Unlock()

	var issueCopy tenantdb.DiagnosticRecordRow
	if s.Beginner != nil {
		err := tenantdb.WithTx(ctx, s.Beginner, tenantdb.Scope{
			WorkspaceID:             actor.WorkspaceID,
			UserID:                  actor.UserID,
			RequireActiveMembership: true,
		}, func(txCtx context.Context, q *tenantdb.Queries) error {
			var txErr error
			issueCopy, txErr = q.GetDiagnosticRecord(txCtx, actor.WorkspaceID, diagID)
			if errors.Is(txErr, pgx.ErrNoRows) {
				return ErrIssueNotFound
			}
			return txErr
		})
		if err != nil {
			return nil, toConnectError(err)
		}
	} else {
		s.mu.Lock()
		wsIssues := s.issues[actor.WorkspaceID]
		issue, exists := wsIssues[diagID]
		if !exists {
			s.mu.Unlock()
			return nil, toConnectError(ErrIssueNotFound)
		}
		issueCopy = *issue
		s.mu.Unlock()
	}

	now := s.Now()
	var nextStep adminv1.RepairWizardStep
	var newStatus string
	var userMessage string
	resolved := false

	requiresManualReconcile := strings.HasPrefix(issueCopy.RepairPath, "reconcile_external_effect:") ||
		issueCopy.ErrorType == "external_effect_outcome_unknown"

	var reconcileOpKey string
	var reconcileTargetStatus string
	var reconcileVerRef string

	switch step {
	case adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_VERIFY:
		nextStep = adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_DIAGNOSE
		newStatus = "acknowledged"
		userMessage = "Bước 1/4 (Xác minh): Đã kiểm tra trạng thái hiện tại của thành phần gặp sự cố."
	case adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_DIAGNOSE:
		nextStep = adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_FIX
		newStatus = "acknowledged"
		if requiresManualReconcile {
			userMessage = "Bước 2/4 (Chẩn đoán): Tác vụ bên ngoài đang ở trạng thái chưa xác định (unknown). Cần mã xác minh đối chiếu trước khi xác nhận hoàn tất."
		} else {
			userMessage = "Bước 2/4 (Chẩn đoán): Đã xác định nguyên nhân gốc và sẵn sàng thực hiện bước sửa lỗi."
		}
	case adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_FIX:
		if requiresManualReconcile {
			verRef := strings.TrimSpace(req.Msg.GetVerificationReference())
			if verRef == "" {
				return nil, toConnectError(ErrRepairVerificationRequired)
			}
			reconcileVerRef = verRef
			opKey := strings.TrimPrefix(issueCopy.RepairPath, "reconcile_external_effect:")
			if opKey != "" && opKey != issueCopy.RepairPath {
				reconcileOpKey = opKey
				reconcileTargetStatus = "succeeded"
				mode := outbox.ReconcileConfirmedSucceeded
				if req.Msg.GetActionKey() == "confirm_not_executed" {
					reconcileTargetStatus = "failed"
					mode = outbox.ReconcileConfirmedNotExecuted
				}
				if s.Beginner == nil {
					if _, err := s.EffectGuard.ReconcileUnknownEffect(ctx, outbox.ReconcileRequest{
						WorkspaceID:           actor.WorkspaceID,
						OperationKey:          opKey,
						ActorID:               actor.UserID,
						Mode:                  mode,
						VerificationReference: verRef,
						Now:                   now,
					}); err != nil {
						return nil, toConnectError(err)
					}
				} else if s.EffectGuard != nil {
					_, _ = s.EffectGuard.ReconcileUnknownEffect(ctx, outbox.ReconcileRequest{
						WorkspaceID:           actor.WorkspaceID,
						OperationKey:          opKey,
						ActorID:               actor.UserID,
						Mode:                  mode,
						VerificationReference: verRef,
						Now:                   now,
					})
				}
			}
		}
		nextStep = adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_CONFIRM
		newStatus = "resolving"
		userMessage = "Bước 3/4 (Khắc phục): Đã áp dụng biện pháp khắc phục an toàn mà không gây trùng lặp tác vụ."
	case adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_CONFIRM:
		if requiresManualReconcile && issueCopy.Status != "resolving" && issueCopy.Status != "resolved" {
			return nil, toConnectError(ErrRepairVerificationRequired)
		}
		nextStep = adminv1.RepairWizardStep_REPAIR_WIZARD_STEP_UNSPECIFIED
		newStatus = "resolved"
		resolved = true
		userMessage = "Bước 4/4 (Xác nhận): Sự cố đã được khắc phục và trạng thái hệ thống đã ổn định."
	default:
		return nil, toConnectError(ErrInvalidInput)
	}

	auditID := s.IDGenerator()
	if s.Beginner != nil {
		err := tenantdb.WithTx(ctx, s.Beginner, tenantdb.Scope{
			WorkspaceID:             actor.WorkspaceID,
			UserID:                  actor.UserID,
			RequireActiveMembership: true,
		}, func(txCtx context.Context, q *tenantdb.Queries) error {
			if reconcileOpKey != "" {
				if _, err := q.ReconcileUnknownExternalEffect(txCtx, actor.WorkspaceID, reconcileOpKey, reconcileTargetStatus, reconcileVerRef); err != nil {
					return err
				}
			}
			if _, err := q.UpdateDiagnosticRecordStatus(txCtx, actor.WorkspaceID, diagID, newStatus); err != nil {
				return err
			}
			return q.InsertAuditEvent(txCtx, tenantdb.AuditEventParams{
				AuditEventID: auditID,
				WorkspaceID:  actor.WorkspaceID,
				ActorUserID:  actor.UserID,
				ActorType:    "user",
				Action:       "diagnostics.repair_step:" + step.String(),
				ResourceType: "diagnostics_record",
				ResourceID:   diagID,
				Reason:       req.Msg.GetVerificationReference(),
			})
		})
		if err != nil {
			return nil, toConnectError(err)
		}
	}

	s.mu.Lock()
	if wsIssues, ok := s.issues[actor.WorkspaceID]; ok {
		if issue, exists := wsIssues[diagID]; exists {
			issue.Status = newStatus
			issue.UpdatedAt = now
			if resolved {
				issue.ResolvedAt = &now
			}
		}
	}
	resp := &adminv1.ExecuteRepairStepResponse{
		DiagnosticsId:    &commonv1.UUID{Value: diagID},
		CompletedStep:    step,
		NextStep:         nextStep,
		IssueStatus:      toProtoIssueStatus(newStatus),
		UserFacingResult: SanitizeUserFacingText(userMessage),
		Resolved:         resolved,
		Replayed:         false,
		UpdatedAt:        timestamppb.New(now),
	}
	s.idempotency[cacheKey] = cachedCommandResult{
		requestHash: reqHash,
		response:    resp,
	}
	s.audits = append(s.audits, outbox.AuditLogEntry{
		AuditEventID: auditID,
		WorkspaceID:  actor.WorkspaceID,
		ActorID:      actor.UserID,
		ActorType:    "user",
		Action:       "diagnostics.repair_step:" + step.String(),
		ResourceType: "diagnostics_record",
		ResourceID:   diagID,
		Reason:       req.Msg.GetVerificationReference(),
		CreatedAt:    now,
	})
	s.mu.Unlock()

	return connect.NewResponse(resp), nil
}

func buildCategoryCardsFromState(records []tenantdb.DiagnosticRecordRow, unk, dlq int32, now time.Time) []*adminv1.HealthCategoryCard {
	countsByCat := make(map[string]int32)
	worstByCat := make(map[string]adminv1.DiagnosticHealthStatus)

	for _, iss := range records {
		if iss.Status == "resolved" || iss.Status == "closed" {
			continue
		}
		cat := mapScopeToCategory(iss.ScopeType)
		countsByCat[cat]++
		st := severityToHealthStatus(iss.Severity)
		if st > worstByCat[cat] {
			worstByCat[cat] = st
		}
	}

	if unk+dlq > 0 {
		countsByCat["outbox_external_effects"] += unk + dlq
		if worstByCat["outbox_external_effects"] < adminv1.DiagnosticHealthStatus_DIAGNOSTIC_HEALTH_STATUS_WARNING {
			worstByCat["outbox_external_effects"] = adminv1.DiagnosticHealthStatus_DIAGNOSTIC_HEALTH_STATUS_WARNING
		}
	}

	cards := make([]*adminv1.HealthCategoryCard, 0, len(CanonicalCategories))
	for _, meta := range CanonicalCategories {
		st := worstByCat[meta.Key]
		if st == adminv1.DiagnosticHealthStatus_DIAGNOSTIC_HEALTH_STATUS_UNSPECIFIED {
			st = adminv1.DiagnosticHealthStatus_DIAGNOSTIC_HEALTH_STATUS_HEALTHY
		}
		openCnt := countsByCat[meta.Key]
		summary := meta.DefaultDesc
		if openCnt > 0 {
			summary = fmt.Sprintf("Có %d vấn đề cần kiểm tra trong mục %s.", openCnt, meta.DisplayName)
		}
		cards = append(cards, &adminv1.HealthCategoryCard{
			CategoryKey:     meta.Key,
			DisplayName:     meta.DisplayName,
			Status:          st,
			Summary:         SanitizeUserFacingText(summary),
			OpenIssuesCount: openCnt,
			LastCheckedAt:   timestamppb.New(now),
		})
	}
	return cards
}

func (s *Service) buildHealthCategoryCards(workspaceID string, now time.Time) []*adminv1.HealthCategoryCard {
	s.mu.Lock()
	wsIssues := s.issues[workspaceID]
	records := make([]tenantdb.DiagnosticRecordRow, 0, len(wsIssues))
	for _, iss := range wsIssues {
		records = append(records, *iss)
	}
	s.mu.Unlock()
	unk := int32(s.EffectGuard.CountUnknownEffects(workspaceID))
	dlq := int32(s.DLQ.CountPendingByWorkspace(workspaceID))
	return buildCategoryCardsFromState(records, unk, dlq, now)
}

func mapScopeToCategory(scopeType string) string {
	switch strings.ToLower(strings.TrimSpace(scopeType)) {
	case "connected_account", "oauth", "connector":
		return "connected_accounts"
	case "publish_job", "publish_item", "publish":
		return "publish_pipeline"
	case "order", "inventory", "stock_reservation":
		return "order_inventory_sync"
	case "webhook", "webhook_subscription", "api_key":
		return "webhook_delivery"
	case "generation_job", "ai_credit":
		return "ai_generation_credits"
	case "workflow", "workflow_run", "agent_run":
		return "workflow_automation"
	case "reconciliation", "settlement":
		return "reconciliation_settlement"
	default:
		return "outbox_external_effects"
	}
}

func severityToHealthStatus(sev string) adminv1.DiagnosticHealthStatus {
	switch strings.ToLower(strings.TrimSpace(sev)) {
	case "critical":
		return adminv1.DiagnosticHealthStatus_DIAGNOSTIC_HEALTH_STATUS_CRITICAL
	case "error":
		return adminv1.DiagnosticHealthStatus_DIAGNOSTIC_HEALTH_STATUS_ERROR
	case "warning":
		return adminv1.DiagnosticHealthStatus_DIAGNOSTIC_HEALTH_STATUS_WARNING
	default:
		return adminv1.DiagnosticHealthStatus_DIAGNOSTIC_HEALTH_STATUS_HEALTHY
	}
}

func toProtoSeverity(sev string) adminv1.DiagnosticSeverity {
	switch strings.ToLower(strings.TrimSpace(sev)) {
	case "critical":
		return adminv1.DiagnosticSeverity_DIAGNOSTIC_SEVERITY_CRITICAL
	case "error":
		return adminv1.DiagnosticSeverity_DIAGNOSTIC_SEVERITY_ERROR
	case "warning":
		return adminv1.DiagnosticSeverity_DIAGNOSTIC_SEVERITY_WARNING
	default:
		return adminv1.DiagnosticSeverity_DIAGNOSTIC_SEVERITY_INFO
	}
}

func toProtoIssueStatus(st string) adminv1.DiagnosticIssueStatus {
	switch strings.ToLower(strings.TrimSpace(st)) {
	case "open":
		return adminv1.DiagnosticIssueStatus_DIAGNOSTIC_ISSUE_STATUS_OPEN
	case "acknowledged":
		return adminv1.DiagnosticIssueStatus_DIAGNOSTIC_ISSUE_STATUS_ACKNOWLEDGED
	case "resolving":
		return adminv1.DiagnosticIssueStatus_DIAGNOSTIC_ISSUE_STATUS_RESOLVING
	case "resolved":
		return adminv1.DiagnosticIssueStatus_DIAGNOSTIC_ISSUE_STATUS_RESOLVED
	case "closed":
		return adminv1.DiagnosticIssueStatus_DIAGNOSTIC_ISSUE_STATUS_CLOSED
	default:
		return adminv1.DiagnosticIssueStatus_DIAGNOSTIC_ISSUE_STATUS_OPEN
	}
}

func toProtoIssue(row tenantdb.DiagnosticRecordRow) *adminv1.DiagnosticIssue {
	reqManual := strings.HasPrefix(row.RepairPath, "reconcile_external_effect:") ||
		row.ErrorType == "external_effect_outcome_unknown"
	iss := &adminv1.DiagnosticIssue{
		DiagnosticsId:                &commonv1.UUID{Value: row.DiagnosticsID},
		WorkspaceId:                  &commonv1.UUID{Value: row.WorkspaceID},
		ScopeType:                    row.ScopeType,
		ErrorType:                    row.ErrorType,
		Severity:                     toProtoSeverity(row.Severity),
		UserFacingExplanation:        SanitizeUserFacingText(row.UserFacingExplanation),
		LikelyCauses:                 row.LikelyCauses,
		SuggestedActions:             row.SuggestedActions,
		RepairPath:                   row.RepairPath,
		Status:                       toProtoIssueStatus(row.Status),
		RequiresManualReconciliation: reqManual,
		DetectedAt:                   timestamppb.New(row.DetectedAt),
	}
	if tenantdb.IsValidNonZeroUUID(row.ScopeID) {
		iss.ScopeId = &commonv1.UUID{Value: row.ScopeID}
	}
	if row.ResolvedAt != nil {
		iss.ResolvedAt = timestamppb.New(*row.ResolvedAt)
	}
	return iss
}

func toConnectError(err error) error {
	switch {
	case errors.Is(err, ErrUnauthenticated):
		return connect.NewError(connect.CodeUnauthenticated, err)
	case errors.Is(err, rbac.ErrPermissionDenied), errors.Is(err, tenantdb.ErrScopeMismatch), errors.Is(err, tenantdb.ErrMembershipRevokedOrMissing):
		return connect.NewError(connect.CodePermissionDenied, err)
	case errors.Is(err, ErrIssueNotFound):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, ErrIdempotencyConflict):
		return connect.NewError(connect.CodeAborted, err)
	case errors.Is(err, ErrRepairVerificationRequired), errors.Is(err, outbox.ErrExternalOutcomeUnresolved), errors.Is(err, outbox.ErrReconciliationProofRequired):
		return connect.NewError(connect.CodeFailedPrecondition, err)
	case errors.Is(err, ErrInvalidInput), errors.Is(err, tenantdb.ErrInvalidTenantScope):
		return connect.NewError(connect.CodeInvalidArgument, err)
	default:
		return connect.NewError(connect.CodeUnavailable, err)
	}
}

// ExportJSONSnapshot serializes a diagnostic overview for CLI/worker health reporting.
func (s *Service) ExportJSONSnapshot(workspaceID string) ([]byte, error) {
	cards := s.buildHealthCategoryCards(workspaceID, s.Now())
	return json.Marshal(cards)
}
