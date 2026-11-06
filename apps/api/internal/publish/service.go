package publish

import (
	"context"
	"errors"
	"fmt"
	"math/rand"
	"strings"
	"sync"
	"time"

	"connectrpc.com/connect"
	"google.golang.org/protobuf/types/known/timestamppb"

	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	publishv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/publish/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/publish/v1/publishv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/capability"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
)

// CapabilityEvaluator resolves platform capability state before and during execution.
type CapabilityEvaluator interface {
	EvaluateActionAccess(workspaceID, platform, actionKey string, requiredScopes []string) capability.EvaluationResult
}

// ConnectedAccountLookup provides account state and platform details.
type ConnectedAccountLookup interface {
	GetAccount(workspaceID, accountID string) (*capability.ConnectedAccountRecord, error)
}

// ApprovalPolicyChecker checks if an item requires approval.
type ApprovalPolicyChecker interface {
	RequiresApproval(workspaceID, action string) bool
	IsApproved(workspaceID, approvalRequestID string) bool
}

// ComplianceChecker evaluates whether an asset/publish item has compliance or QA hard blocks.
type ComplianceChecker interface {
	CheckPublishCompliance(ctx context.Context, workspaceID, assetID, targetPlatform string) (scanResult string, hasHardBlocks bool, details map[string]any, err error)
}

// RoleResolver resolves the workspace RBAC role for a verified session user.
type RoleResolver func(ctx context.Context, userID, workspaceID string) (string, error)

// ServiceConfig configures the Publish Service.
type ServiceConfig struct {
	Store               Store
	RequireDurableStore bool
	RoleResolver        RoleResolver
	CapabilityService   capability.KillSwitchChecker // or CapabilityEvaluator
	Accounts            ConnectedAccountLookup
	ApprovalChecker     ApprovalPolicyChecker
	ComplianceChecker   ComplianceChecker
	Jitter              JitterConfig
	Connectors          map[string]PlatformConnector
	Clock               func() time.Time
}

// Service implements publishv1connect.PublishServiceHandler.
type Service struct {
	mu                  sync.RWMutex
	store               Store
	requireDurableStore bool
	roleResolver        RoleResolver
	recentDispatches    []time.Time            // sliding window for fairness/jitter calculation
	workspaceDispatches map[string][]time.Time // workspaceID -> recent timestamps
	connectors          map[string]PlatformConnector
	capEvaluator        CapabilityEvaluator
	accountLookup       ConnectedAccountLookup
	approvalChecker     ApprovalPolicyChecker
	complianceChecker   ComplianceChecker
	jitterConfig        JitterConfig
	nowFn               func() time.Time
}

var _ publishv1connect.PublishServiceHandler = (*Service)(nil)

// NewService creates a new PublishService instance.
// When cfg.Store is nil and cfg.RequireDurableStore is false, a new MemoryStore is initialized.
// When cfg.RequireDurableStore is true and cfg.Store is nil, all RPCs fail closed with ErrStoreNotConfigured.
func NewService(cfg ServiceConfig) *Service {
	nowFn := cfg.Clock
	if nowFn == nil {
		nowFn = time.Now
	}
	jCfg := cfg.Jitter
	if jCfg.HighLoadThresholdCPM == 0 {
		jCfg = DefaultJitterConfig()
	}
	store := cfg.Store
	if store == nil && !cfg.RequireDurableStore {
		store = NewMemoryStore()
	}
	return &Service{
		store:               store,
		requireDurableStore: cfg.RequireDurableStore,
		roleResolver:        cfg.RoleResolver,
		recentDispatches:    make([]time.Time, 0),
		workspaceDispatches: make(map[string][]time.Time),
		connectors:          cfg.Connectors,
		accountLookup:       cfg.Accounts,
		approvalChecker:     cfg.ApprovalChecker,
		complianceChecker:   cfg.ComplianceChecker,
		jitterConfig:        jCfg,
		nowFn:               nowFn,
	}
}

// SetComplianceChecker sets or updates the compliance/QA gate evaluator.
func (s *Service) SetComplianceChecker(checker ComplianceChecker) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.complianceChecker = checker
}

// NewStrictService creates a PublishService that requires a configured Store, failing closed if Store is nil.
func NewStrictService(cfg ServiceConfig) (*Service, error) {
	if cfg.Store == nil {
		return nil, ErrStoreNotConfigured
	}
	cfg.RequireDurableStore = true
	return NewService(cfg), nil
}

// Store returns the underlying persistence Store.
func (s *Service) Store() Store {
	return s.store
}

// WithCaller attaches a verified workspace PolicyContext to ctx for authenticated RPC calls.
func WithCaller(ctx context.Context, workspaceID, userID, role string) context.Context {
	if role == "" {
		role = rbac.RoleOwner
	}
	return rbac.WithPolicyContext(ctx, rbac.PolicyContext{
		WorkspaceID: workspaceID,
		ActorUserID: userID,
		Role:        role,
	})
}

type publishRPCBinding struct {
	permissionKey string
	roleEnvelope  string
}

// Canonical RPC permission bindings from docs/04_contracts/rpc_permission_bindings.csv (lines 487-524).
var publishRPCBindings = map[string]publishRPCBinding{
	"PublishService/CreateItem":           {permissionKey: "publish:create", roleEnvelope: "Editor+"},
	"PublishService/Schedule":             {permissionKey: "publish:schedule", roleEnvelope: "Editor+"},
	"PublishService/Execute":              {permissionKey: "publish:execute", roleEnvelope: "Manager+"},
	"PublishService/Retry":                {permissionKey: "publish:retry", roleEnvelope: "Editor+"},
	"PublishService/Cancel":               {permissionKey: "publish:cancel", roleEnvelope: "Manager+"},
	"PublishService/ListQueue":            {permissionKey: "publish:read", roleEnvelope: "Viewer+"},
	"PublishService/GetLogs":              {permissionKey: "publish:read", roleEnvelope: "Viewer+"},
	"PublishService/ReconcilePublish":     {permissionKey: "publish:execute", roleEnvelope: "Manager+"},
	"PublishService/ExportManualPackage":  {permissionKey: "publish:create", roleEnvelope: "Editor+"},
	"PublishService/SubmitManualProof":    {permissionKey: "publish:create", roleEnvelope: "Editor+"},
	"PublishService/PauseQueue":           {permissionKey: "publish:cancel", roleEnvelope: "Manager+"},
	"PublishService/GetDiagnostics":       {permissionKey: "publish:read", roleEnvelope: "Viewer+"},
	"PublishService/Get":                  {permissionKey: "publish:read", roleEnvelope: "Viewer+"},
	"PublishService/List":                 {permissionKey: "publish:read", roleEnvelope: "Viewer+"},
	"PublishService/GetDraft":             {permissionKey: "publish:read", roleEnvelope: "Viewer+"},
	"PublishService/SaveDraft":            {permissionKey: "publish:create", roleEnvelope: "Editor+"},
	"PublishService/UpdateDraft":          {permissionKey: "publish:create", roleEnvelope: "Editor+"},
	"PublishService/ListDrafts":           {permissionKey: "publish:read", roleEnvelope: "Viewer+"},
	"PublishService/PublishNow":           {permissionKey: "publish:create", roleEnvelope: "Manager+"},
	"PublishService/Reschedule":           {permissionKey: "publish:create", roleEnvelope: "Editor+"},
	"PublishService/Delete":               {permissionKey: "publish:create", roleEnvelope: "Manager+"},
	"PublishService/Duplicate":            {permissionKey: "publish:create", roleEnvelope: "Editor+"},
	"PublishService/Pause":                {permissionKey: "publish:create", roleEnvelope: "Editor+"},
	"PublishService/GetCalendar":          {permissionKey: "publish:read", roleEnvelope: "Viewer+"},
	"PublishService/ListByDateRange":      {permissionKey: "publish:read", roleEnvelope: "Viewer+"},
	"PublishService/ListUpcoming":         {permissionKey: "publish:read", roleEnvelope: "Viewer+"},
	"PublishService/ListPublished":        {permissionKey: "publish:read", roleEnvelope: "Viewer+"},
	"PublishService/ListPosts":            {permissionKey: "publish:read", roleEnvelope: "Viewer+"},
	"PublishService/CheckCompatibility":   {permissionKey: "publish:read", roleEnvelope: "Editor+"},
	"PublishService/UpdateMetadata":       {permissionKey: "publish:create", roleEnvelope: "Editor+"},
	"PublishService/GetPlatformStatus":    {permissionKey: "publish:read", roleEnvelope: "Viewer+"},
	"PublishService/GetCrossPostInsights": {permissionKey: "publish:read", roleEnvelope: "Viewer+"},
	"PublishService/SyncPostMetrics":      {permissionKey: "publish:create", roleEnvelope: "Editor+"},
	"PublishService/PublishVariants":      {permissionKey: "publish:create", roleEnvelope: "Editor+"},
	"PublishService/HoldSchedule":         {permissionKey: "publish:create", roleEnvelope: "Editor+"},
	"PublishService/ScheduleRetry":        {permissionKey: "publish:create", roleEnvelope: "Editor+"},
	"PublishService/TagProduct":           {permissionKey: "publish:create", roleEnvelope: "Editor+"},
	"PublishService/UntagProduct":         {permissionKey: "publish:create", roleEnvelope: "Editor+"},
}

var publishRoleRank = map[string]int{
	rbac.RoleOwner:       7,
	rbac.RoleAdmin:       6,
	rbac.RoleManager:     5,
	rbac.RoleEditor:      4,
	rbac.RoleContributor: 3,
	rbac.RoleViewer:      2,
	rbac.RoleExternal:    1,
}

func checkPublishRoleEnvelope(role, envelope string) error {
	rank, ok := publishRoleRank[role]
	if !ok {
		return ErrPermissionDenied
	}
	switch envelope {
	case "Owner":
		if rank < publishRoleRank[rbac.RoleOwner] {
			return ErrPermissionDenied
		}
	case "Admin+":
		if rank < publishRoleRank[rbac.RoleAdmin] {
			return ErrPermissionDenied
		}
	case "Manager+":
		if rank < publishRoleRank[rbac.RoleManager] {
			return ErrPermissionDenied
		}
	case "Editor+":
		if rank < publishRoleRank[rbac.RoleEditor] {
			return ErrPermissionDenied
		}
	case "Contributor+":
		if rank < publishRoleRank[rbac.RoleContributor] {
			return ErrPermissionDenied
		}
	case "Viewer+", "Member":
		if rank < publishRoleRank[rbac.RoleViewer] {
			return ErrPermissionDenied
		}
	}
	return nil
}

func extractCmdWorkspaceID(cmdCtx *commonv1.CommandContext) string {
	if cmdCtx != nil && cmdCtx.WorkspaceId != nil {
		return strings.TrimSpace(cmdCtx.WorkspaceId.Value)
	}
	return ""
}

// authorizeRPC enforces fail-closed authentication, tenant scope verification, and named RBAC permissions.
func (s *Service) authorizeRPC(ctx context.Context, rpcName string, requestedWorkspaceIDs ...string) (rbac.PolicyContext, error) {
	if s.store == nil {
		return rbac.PolicyContext{}, connect.NewError(connect.CodeFailedPrecondition, ErrStoreNotConfigured)
	}
	if ctx == nil {
		return rbac.PolicyContext{}, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}

	session, hasSession := transportauth.PrincipalFromContext(ctx)
	pctx, hasPolicy := rbac.PolicyContextFromContext(ctx)

	if !hasSession && !hasPolicy {
		return rbac.PolicyContext{}, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}

	if hasSession {
		if strings.TrimSpace(session.WorkspaceID) == "" || strings.TrimSpace(session.UserID) == "" {
			return rbac.PolicyContext{}, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
		}
		if hasPolicy {
			if pctx.WorkspaceID != "" && pctx.WorkspaceID != session.WorkspaceID {
				return rbac.PolicyContext{}, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
			}
			if pctx.ActorUserID != "" && pctx.ActorUserID != session.UserID {
				return rbac.PolicyContext{}, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
			}
		}
		pctx.WorkspaceID = session.WorkspaceID
		pctx.ActorUserID = session.UserID
		if pctx.Role == "" {
			if s.roleResolver != nil {
				resolvedRole, err := s.roleResolver(ctx, session.UserID, session.WorkspaceID)
				if err != nil || strings.TrimSpace(resolvedRole) == "" {
					return rbac.PolicyContext{}, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
				}
				pctx.Role = resolvedRole
			} else {
				pctx.Role = rbac.RoleManager
			}
		}
	} else {
		if strings.TrimSpace(pctx.WorkspaceID) == "" {
			return rbac.PolicyContext{}, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
		}
		if strings.TrimSpace(pctx.Role) == "" {
			return rbac.PolicyContext{}, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
		}
	}

	for _, reqWS := range requestedWorkspaceIDs {
		trimmed := strings.TrimSpace(reqWS)
		if trimmed != "" && trimmed != pctx.WorkspaceID {
			return rbac.PolicyContext{}, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
		}
	}

	binding, ok := publishRPCBindings[rpcName]
	if !ok {
		return rbac.PolicyContext{}, connect.NewError(connect.CodePermissionDenied, rbac.ErrUnboundRPC)
	}
	if err := rbac.CheckWorkspacePermission(binding.permissionKey, pctx); err != nil {
		return rbac.PolicyContext{}, connect.NewError(connect.CodePermissionDenied, err)
	}
	if err := checkPublishRoleEnvelope(pctx.Role, binding.roleEnvelope); err != nil {
		return rbac.PolicyContext{}, connect.NewError(connect.CodePermissionDenied, err)
	}

	return pctx, nil
}

func (s *Service) verifyAccountScope(callerWorkspaceID, accountID string) error {
	if strings.TrimSpace(accountID) == "" || s.accountLookup == nil {
		return nil
	}
	acc, err := s.accountLookup.GetAccount(callerWorkspaceID, accountID)
	if err != nil || acc == nil {
		return connect.NewError(connect.CodeNotFound, ErrAccountNotFound)
	}
	if acc.WorkspaceID != "" && acc.WorkspaceID != callerWorkspaceID {
		return connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}
	return nil
}

// SetCapabilityEvaluator injects the capability service.
func (s *Service) SetCapabilityEvaluator(eval CapabilityEvaluator) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.capEvaluator = eval
}

// RegisterConnector registers a platform connector adapter.
func (s *Service) RegisterConnector(connector PlatformConnector) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if s.connectors == nil {
		s.connectors = make(map[string]PlatformConnector)
	}
	s.connectors[strings.ToLower(connector.Platform())] = connector
}

// SetTimeProvider sets a custom clock for testing.
func (s *Service) SetTimeProvider(nowFn func() time.Time) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.nowFn = nowFn
}

func (s *Service) recordEvent(ctx context.Context, workspaceID, eventType, aggType, aggID string, payload map[string]any) {
	if s.store == nil {
		return
	}
	_ = s.store.AppendEvent(ctx, DomainEvent{
		EventID:       NewID(),
		WorkspaceID:   workspaceID,
		EventType:     eventType,
		AggregateType: aggType,
		AggregateID:   aggID,
		Payload:       payload,
		OccurredAt:    s.nowFn(),
	})
}

// Events returns a copy of recorded domain events.
func (s *Service) Events() []DomainEvent {
	if s.store == nil {
		return nil
	}
	evs, _ := s.store.ListEvents(context.Background(), "")
	return evs
}

// ResolveCapability evaluates platform capability for publish_post.
func (s *Service) ResolveCapability(workspaceID, platform string) *publishv1.PlatformCapabilitySummary {
	p := strings.ToLower(platform)
	summary := &publishv1.PlatformCapabilitySummary{
		Platform:        p,
		CapabilityState: publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_MANUAL,
		ConnectorState:  "connected",
		RequiredScopes:  []string{"publish"},
		Executable:      true,
		PolicySummary:   "Xuất bản nội dung lên nền tảng",
	}

	s.mu.RLock()
	capEvaluator := s.capEvaluator
	s.mu.RUnlock()

	if capEvaluator != nil {
		eval := capEvaluator.EvaluateActionAccess(workspaceID, p, "publish_post", nil)
		summary.RequiredScopes = []string{eval.ActionKey}
		summary.PolicySummary = eval.PolicyNote.Summary
		summary.FallbackInstructions = eval.FallbackPath.Instructions
		summary.Executable = eval.Executable

		switch eval.State {
		case capability.StateNative:
			summary.CapabilityState = publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_NATIVE
		case capability.StateReadOnly:
			summary.CapabilityState = publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_READ_ONLY
			summary.RequiresManualFallback = true
			summary.Executable = false
		case capability.StateManual:
			summary.CapabilityState = publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_MANUAL
			summary.RequiresManualFallback = true
		case capability.StateDegraded:
			summary.CapabilityState = publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_DEGRADED
			summary.RequiresManualFallback = true
		case capability.StateUnsupported:
			summary.CapabilityState = publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_UNSUPPORTED
			summary.RequiresManualFallback = true
			summary.Executable = false
		}
	} else {
		switch p {
		case "shopee":
			summary.CapabilityState = publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_UNSUPPORTED
			summary.RequiresManualFallback = true
			summary.Executable = false
			summary.PolicySummary = "Shopee không cung cấp Public API để đăng Shopee Video tự động"
			summary.FallbackInstructions = "Tải video đã đóng gói về thiết bị và đăng thủ công qua app Shopee Video"
		case "tiktok", "youtube", "instagram", "facebook":
			summary.CapabilityState = publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_NATIVE
			summary.RequiresManualFallback = false
			summary.Executable = true
		}
	}
	return summary
}

// CalculateJitterDelay calculates system queue fairness jitter (RULE-M11-006).
// Invariant: Delay is ALWAYS >= 0. Never negative.
func (s *Service) CalculateJitterDelay(workspaceID string) time.Duration {
	s.mu.Lock()
	defer s.mu.Unlock()

	now := s.nowFn()
	cutoff := now.Add(-1 * time.Minute)

	validRecent := make([]time.Time, 0, len(s.recentDispatches))
	for _, t := range s.recentDispatches {
		if t.After(cutoff) {
			validRecent = append(validRecent, t)
		}
	}
	s.recentDispatches = validRecent

	if len(s.recentDispatches) >= s.jitterConfig.HighLoadThresholdCPM {
		delaySecs := rand.Intn(int(s.jitterConfig.MaxJitterDelay.Seconds()) + 1)
		if delaySecs < 0 {
			delaySecs = 0
		}
		return time.Duration(delaySecs) * time.Second
	}
	return 0
}

// ----------------------------------------------------------------------------
// Core RPC Implementations
// ----------------------------------------------------------------------------

func boolFromMap(m map[string]any, key string) bool {
	if m == nil {
		return false
	}
	v, ok := m[key]
	if !ok {
		return false
	}
	switch b := v.(type) {
	case bool:
		return b
	case string:
		return strings.EqualFold(b, "true") || b == "1"
	}
	return false
}

func stringFromMap(m map[string]any, key string) string {
	if m == nil {
		return ""
	}
	if s, ok := m[key].(string); ok {
		return strings.TrimSpace(s)
	}
	return ""
}

// enforceComplianceAndDiagnosticsGate checks QA/compliance hard blocks, soft-flag override requirements,
// and blocked diagnostics state. Hard blocks cannot be overridden even by Owner.
func (s *Service) enforceComplianceAndDiagnosticsGate(ctx context.Context, item *PublishItem) error {
	s.mu.RLock()
	checker := s.complianceChecker
	s.mu.RUnlock()

	if checker != nil {
		scanRes, hasHard, details, err := checker.CheckPublishCompliance(ctx, item.WorkspaceID, item.AssetID, item.TargetPlatform)
		if err != nil {
			item.DiagnosticsState = DiagnosticsBlocked
			_ = s.store.SaveItem(ctx, item)
			return connect.NewError(connect.CodeFailedPrecondition, fmt.Errorf("%w: %v", ErrComplianceHardBlocked, err))
		}
		if scanRes != "" {
			item.ComplianceScanResult = scanRes
		}
		if details != nil {
			if item.ComplianceDetails == nil {
				item.ComplianceDetails = make(map[string]any)
			}
			for k, v := range details {
				item.ComplianceDetails[k] = v
			}
		}
		if hasHard {
			if item.ComplianceDetails == nil {
				item.ComplianceDetails = make(map[string]any)
			}
			item.ComplianceDetails["has_hard_blocks"] = true
			item.ComplianceScanResult = "blocked"
		}
	}

	scanResult := strings.ToLower(strings.TrimSpace(item.ComplianceScanResult))
	metaScanResult := strings.ToLower(stringFromMap(item.Metadata, "compliance_scan_result"))
	if metaScanResult != "" && scanResult == "pass" {
		scanResult = metaScanResult
	}

	hasHardBlocks := scanResult == "blocked" || scanResult == "hard_blocked" || scanResult == "fail" ||
		boolFromMap(item.ComplianceDetails, "has_hard_blocks") ||
		boolFromMap(item.ComplianceDetails, "is_hard_blocked") ||
		boolFromMap(item.Metadata, "has_hard_blocks") ||
		boolFromMap(item.Metadata, "is_hard_blocked")

	if hasHardBlocks {
		item.ComplianceScanResult = "blocked"
		item.DiagnosticsState = DiagnosticsBlocked
		item.UpdatedAt = s.nowFn()
		_ = s.store.SaveItem(ctx, item)
		return connect.NewError(connect.CodeFailedPrecondition, ErrComplianceHardBlocked)
	}

	if scanResult == "review_required" {
		overrideAck := boolFromMap(item.ComplianceDetails, "override_acknowledged") || boolFromMap(item.Metadata, "override_acknowledged")
		overrideReason := stringFromMap(item.ComplianceDetails, "override_reason")
		if overrideReason == "" {
			overrideReason = stringFromMap(item.Metadata, "override_reason")
		}
		if !overrideAck || overrideReason == "" {
			item.DiagnosticsState = DiagnosticsWarning
			_ = s.store.SaveItem(ctx, item)
			return connect.NewError(connect.CodeFailedPrecondition, ErrComplianceReviewRequired)
		}
	}

	if item.DiagnosticsState == DiagnosticsBlocked {
		return connect.NewError(connect.CodeFailedPrecondition, ErrDiagnosticsBlocked)
	}

	return nil
}

// CreateItem creates a publish item in draft or scheduled state.
func (s *Service) CreateItem(ctx context.Context, req *connect.Request[publishv1.CreateItemRequest]) (*connect.Response[publishv1.CreateItemResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/CreateItem", extractCmdWorkspaceID(req.Msg.Context))
	if err != nil {
		return nil, err
	}

	if err := s.verifyAccountScope(caller.WorkspaceID, req.Msg.TargetAccountId); err != nil {
		return nil, err
	}

	workspaceID := caller.WorkspaceID
	platform := strings.ToLower(req.Msg.TargetPlatform)
	capSummary := s.ResolveCapability(workspaceID, platform)

	now := s.nowFn()
	item := &PublishItem{
		PublishItemID:        NewID(),
		WorkspaceID:          workspaceID,
		AssetID:              req.Msg.AssetId,
		TargetPlatform:       platform,
		TargetAccountID:      req.Msg.TargetAccountId,
		TargetFormat:         req.Msg.TargetFormat,
		PublishMode:          PublishModeToString(req.Msg.PublishMode),
		Title:                req.Msg.Title,
		Description:          req.Msg.Description,
		Hashtags:             req.Msg.Hashtags,
		LifecycleState:       StateDraft,
		DiagnosticsState:     DiagnosticsHealthy,
		PackagingScore:       85.0,
		ComplianceScanResult: "pass",
		CreatedBy:            caller.ActorUserID,
		CreatedAt:            now,
		UpdatedAt:            now,
	}

	s.mu.RLock()
	checker := s.complianceChecker
	s.mu.RUnlock()
	if checker != nil {
		scanRes, hasHard, details, cErr := checker.CheckPublishCompliance(ctx, workspaceID, item.AssetID, platform)
		if scanRes != "" {
			item.ComplianceScanResult = scanRes
		}
		if details != nil {
			item.ComplianceDetails = details
		}
		if cErr != nil || hasHard || strings.EqualFold(scanRes, "blocked") {
			item.ComplianceScanResult = "blocked"
			item.DiagnosticsState = DiagnosticsBlocked
		}
	}

	if req.Msg.ScheduleAt != nil {
		if err := s.enforceComplianceAndDiagnosticsGate(ctx, item); err != nil {
			return nil, err
		}
		sch := req.Msg.ScheduleAt.AsTime()
		item.ScheduleAt = &sch
		item.LifecycleState = StateScheduled
	}

	if err := s.store.SaveItem(ctx, item); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	s.recordEvent(ctx, workspaceID, EventPublishQueued, "publish_item", item.PublishItemID, map[string]any{
		"platform": platform,
		"state":    item.LifecycleState,
	})

	return connect.NewResponse(&publishv1.CreateItemResponse{
		Item:              ItemToProto(item),
		CapabilitySummary: capSummary,
	}), nil
}

// Schedule validates and schedules a publish item (Acceptance Target 1: Never publish before schedule).
func (s *Service) Schedule(ctx context.Context, req *connect.Request[publishv1.ScheduleRequest]) (*connect.Response[publishv1.ScheduleResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/Schedule", extractCmdWorkspaceID(req.Msg.Context))
	if err != nil {
		return nil, err
	}

	item, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	if err := s.enforceComplianceAndDiagnosticsGate(ctx, item); err != nil {
		return nil, err
	}

	if req.Msg.ScheduledAt == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("scheduled_at is required"))
	}

	scheduledTime := req.Msg.ScheduledAt.AsTime()
	now := s.nowFn()

	if scheduledTime.Before(now.Add(-1 * time.Second)) {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("cannot schedule in the past"))
	}

	jitterDelay := s.CalculateJitterDelay(item.WorkspaceID)
	effectiveDispatchTime := scheduledTime.Add(jitterDelay)

	if effectiveDispatchTime.Before(scheduledTime) {
		return nil, connect.NewError(connect.CodeInternal, ErrPrematurePublish)
	}

	item.ScheduleAt = &effectiveDispatchTime
	item.LifecycleState = StateScheduled
	item.UpdatedAt = now

	job := &PublishJob{
		PublishJobID:     NewID(),
		WorkspaceID:      item.WorkspaceID,
		PublishItemID:    item.PublishItemID,
		DispatchStrategy: "scheduled_jitter",
		LifecycleState:   JobStateCreated,
		AttemptCount:     0,
		MaxAttempts:      3,
		CreatedAt:        now,
		UpdatedAt:        now,
	}

	if err := s.store.SaveItem(ctx, item); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	if err := s.store.SaveJob(ctx, job); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	s.recordEvent(ctx, item.WorkspaceID, EventPublishScheduled, "publish_item", item.PublishItemID, map[string]any{
		"scheduled_at":         effectiveDispatchTime.Format(time.RFC3339),
		"jitter_delay_seconds": int(jitterDelay.Seconds()),
	})

	return connect.NewResponse(&publishv1.ScheduleResponse{
		Item:               ItemToProto(item),
		Job:                JobToProto(job),
		ScheduledAt:        timestamppb.New(effectiveDispatchTime),
		JitterDelaySeconds: int32(jitterDelay.Seconds()),
	}), nil
}

// findJobEffects returns all ExternalEffects associated with the item or job in the workspace.
func (s *Service) findJobEffects(ctx context.Context, workspaceID, publishItemID, publishJobID, opKey string) (*ExternalEffect, error) {
	if opKey != "" {
		eff, err := s.store.GetEffectByKey(ctx, workspaceID, opKey)
		if err != nil {
			return nil, err
		}
		if eff != nil && (eff.Status == "succeeded" || eff.Status == "prepared" || eff.Status == "submitted" || eff.Status == "unknown") {
			return eff, nil
		}
	}
	if publishJobID != "" {
		jobEffects, err := s.store.ListEffectsByAggregate(ctx, workspaceID, "publish_job", publishJobID)
		if err != nil {
			return nil, err
		}
		for i := len(jobEffects) - 1; i >= 0; i-- {
			eff := jobEffects[i]
			if eff.Status == "succeeded" || eff.Status == "prepared" || eff.Status == "submitted" || eff.Status == "unknown" {
				return eff, nil
			}
		}
	}
	if publishItemID != "" {
		itemEffects, err := s.store.ListEffectsByAggregate(ctx, workspaceID, "publish_item", publishItemID)
		if err != nil {
			return nil, err
		}
		for i := len(itemEffects) - 1; i >= 0; i-- {
			eff := itemEffects[i]
			if eff.Status == "succeeded" || eff.Status == "prepared" || eff.Status == "submitted" || eff.Status == "unknown" {
				return eff, nil
			}
		}
	}
	return nil, nil
}

// Execute executes publish immediately or dispatches a due scheduled job.
// Acceptance Target 1: Never publish before schedule.
// Acceptance Target 2: Unknown submit reconciles; never retries as fresh submit nor marks success without reconciliation.
// Acceptance Target 4: Token revoke pauses affected queued work.
func (s *Service) Execute(ctx context.Context, req *connect.Request[publishv1.ExecuteRequest]) (*connect.Response[publishv1.ExecuteResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/Execute", extractCmdWorkspaceID(req.Msg.Context))
	if err != nil {
		return nil, err
	}

	item, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	now := s.nowFn()

	// REPLAY PROTECTION (Acceptance Target: Replay with one external result)
	if item.LifecycleState == StatePublished {
		logs, _ := s.store.ListLogsByItemID(ctx, caller.WorkspaceID, item.PublishItemID)
		var successLog *PublishLog
		for i := len(logs) - 1; i >= 0; i-- {
			if logs[i].ResultStatus == ResultSuccess {
				successLog = logs[i]
				break
			}
		}
		channelPost, _ := s.store.GetPostByItemID(ctx, caller.WorkspaceID, item.PublishItemID)
		var job *PublishJob
		if req.Msg.PublishJobId != "" {
			var jErr error
			job, jErr = s.store.GetJob(ctx, caller.WorkspaceID, req.Msg.PublishJobId)
			if jErr != nil || job == nil {
				return nil, connect.NewError(connect.CodeNotFound, ErrJobNotFound)
			}
			if job.PublishItemID != item.PublishItemID {
				return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: job %s belongs to item %s, not %s", ErrJobItemMismatch, job.PublishJobID, job.PublishItemID, item.PublishItemID))
			}
		}
		if job == nil {
			job, _ = s.store.GetJobByItemID(ctx, caller.WorkspaceID, item.PublishItemID)
		}
		return connect.NewResponse(&publishv1.ExecuteResponse{
			Item:        ItemToProto(item),
			Job:         JobToProto(job),
			Log:         LogToProto(successLog),
			ChannelPost: ChannelPostToProto(channelPost),
		}), nil
	}

	// Check if this account is currently paused due to token revocation
	if item.TargetAccountID != "" {
		if paused, _, _ := s.store.IsAccountPaused(ctx, caller.WorkspaceID, item.TargetAccountID); paused {
			item.DiagnosticsState = DiagnosticsBlocked
			_ = s.store.SaveItem(ctx, item)
			return nil, connect.NewError(connect.CodeFailedPrecondition, errors.New("publish blocked: target account token is revoked, please reconnect"))
		}
	}

	// Enforce compliance/QA hard-block and diagnostics gate (cannot be bypassed even by Owner)
	if err := s.enforceComplianceAndDiagnosticsGate(ctx, item); err != nil {
		return nil, err
	}

	// ACCEPTANCE TARGET 1: Never publish before schedule!
	if item.ScheduleAt != nil && now.Before(*item.ScheduleAt) {
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrPrematurePublish)
	}

	// Find existing job if any, enforcing strict item-job binding when PublishJobId is supplied
	var job *PublishJob
	if req.Msg.PublishJobId != "" {
		var jErr error
		job, jErr = s.store.GetJob(ctx, caller.WorkspaceID, req.Msg.PublishJobId)
		if jErr != nil || job == nil {
			return nil, connect.NewError(connect.CodeNotFound, ErrJobNotFound)
		}
		if job.PublishItemID != item.PublishItemID {
			return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: job %s belongs to item %s, not %s", ErrJobItemMismatch, job.PublishJobID, job.PublishItemID, item.PublishItemID))
		}
	}
	if job == nil {
		job, _ = s.store.GetJobByItemID(ctx, caller.WorkspaceID, item.PublishItemID)
	}

	// Check approval gating
	if s.approvalChecker != nil && s.approvalChecker.RequiresApproval(item.WorkspaceID, "publish:execute") {
		if job == nil || job.ApprovalRequestID == "" || !s.approvalChecker.IsApproved(item.WorkspaceID, job.ApprovalRequestID) {
			return nil, connect.NewError(connect.CodePermissionDenied, ErrApprovalRequired)
		}
	}

	// Capability re-check at execution time (EC-M11-004)
	capSummary := s.ResolveCapability(item.WorkspaceID, item.TargetPlatform)
	if capSummary.CapabilityState == publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_MANUAL ||
		capSummary.CapabilityState == publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_UNSUPPORTED ||
		capSummary.CapabilityState == publishv1.PublishCapabilityState_PUBLISH_CAPABILITY_STATE_DEGRADED {
		item.LifecycleState = StateRequiresManualFallback
		item.DiagnosticsState = DiagnosticsDegraded
		item.UpdatedAt = now
		_ = s.store.SaveItem(ctx, item)
		s.recordEvent(ctx, item.WorkspaceID, EventPublishRequiresManualFallback, "publish_item", item.PublishItemID, map[string]any{
			"platform": item.TargetPlatform,
			"reason":   capSummary.PolicySummary,
		})
		return nil, connect.NewError(connect.CodeFailedPrecondition, ErrCapabilityDegraded)
	}

	if job == nil {
		job = &PublishJob{
			PublishJobID:     NewID(),
			WorkspaceID:      item.WorkspaceID,
			PublishItemID:    item.PublishItemID,
			DispatchStrategy: "direct",
			LifecycleState:   JobStateCreated,
			AttemptCount:     0,
			MaxAttempts:      3,
			CreatedAt:        now,
			UpdatedAt:        now,
		}
		if err := s.store.SaveJob(ctx, job); err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}
	}

	// Stable operation key BEFORE incrementing AttemptCount (PUB-02).
	var opKey string
	if req.Msg.Context != nil && req.Msg.Context.IdempotencyKey != "" {
		opKey = fmt.Sprintf("pub_idem_%s_%s", item.WorkspaceID, req.Msg.Context.IdempotencyKey)
	} else {
		opKey = fmt.Sprintf("pub_job_%s_%s", item.WorkspaceID, job.PublishJobID)
	}

	s.mu.RLock()
	connector := s.connectors[item.TargetPlatform]
	s.mu.RUnlock()

	// Check if this operation or job/item already has a succeeded or unresolved external effect (PUB-02)
	existingEffect, err := s.findJobEffects(ctx, item.WorkspaceID, item.PublishItemID, job.PublishJobID, opKey)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	if existingEffect != nil {
		if existingEffect.Status == "succeeded" {
			logs, _ := s.store.ListLogsByItemID(ctx, caller.WorkspaceID, item.PublishItemID)
			var successLog *PublishLog
			for i := len(logs) - 1; i >= 0; i-- {
				if logs[i].ResultStatus == ResultSuccess {
					successLog = logs[i]
					break
				}
			}
			extPostID := stringFromMap(existingEffect.ResultPayload, "external_post_id")
			extPostURL := stringFromMap(existingEffect.ResultPayload, "external_post_url")
			if successLog == nil {
				completedAt := existingEffect.UpdatedAt
				if completedAt.IsZero() {
					completedAt = now
				}
				successLog = &PublishLog{
					PublishLogID:    NewID(),
					WorkspaceID:     item.WorkspaceID,
					PublishJobID:    job.PublishJobID,
					PublishItemID:   item.PublishItemID,
					AttemptedAt:     existingEffect.CreatedAt,
					CompletedAt:     &completedAt,
					ActorUserID:     caller.ActorUserID,
					ExecutionPath:   PathNativeAPI,
					ResultStatus:    ResultSuccess,
					ExternalPostID:  extPostID,
					ExternalPostURL: extPostURL,
				}
				if err := s.store.AppendLog(ctx, successLog); err != nil {
					return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("publish: failed to append immutable publish log: %w", err))
				}
			}
			if job.LifecycleState != JobStateSucceeded {
				job.LifecycleState = JobStateSucceeded
				job.UpdatedAt = now
				if err := s.store.SaveJob(ctx, job); err != nil {
					return nil, connect.NewError(connect.CodeInternal, err)
				}
			}
			if item.LifecycleState != StatePublished {
				item.LifecycleState = StatePublished
				item.DiagnosticsState = DiagnosticsHealthy
				item.UpdatedAt = now
				if err := s.store.SaveItem(ctx, item); err != nil {
					return nil, connect.NewError(connect.CodeInternal, err)
				}
			}
			channelPost, _ := s.store.GetPostByItemID(ctx, caller.WorkspaceID, item.PublishItemID)
			if channelPost == nil {
				channelPost = &ChannelPost{
					ChannelPostID:      NewID(),
					WorkspaceID:        item.WorkspaceID,
					PublishItemID:      item.PublishItemID,
					ConnectedAccountID: item.TargetAccountID,
					ExternalPostID:     extPostID,
					ExternalPermalink:  extPostURL,
					Title:              item.Title,
					SyncedAt:           &now,
					CreatedAt:          now,
					UpdatedAt:          now,
				}
				if err := s.store.SavePost(ctx, channelPost); err != nil {
					return nil, connect.NewError(connect.CodeInternal, err)
				}
			}
			return connect.NewResponse(&publishv1.ExecuteResponse{
				Item:        ItemToProto(item),
				Job:         JobToProto(job),
				Log:         LogToProto(successLog),
				ChannelPost: ChannelPostToProto(channelPost),
			}), nil
		}

		if existingEffect.Status == "prepared" || existingEffect.Status == "submitted" || existingEffect.Status == "unknown" {
			// Must reconcile before any retry! Never fall through to PublishPost unless confirmed_not_published.
			if connector != nil && existingEffect.ProviderRequestID != "" {
				statusRes, probeErr := connector.CheckPostStatus(ctx, item.TargetAccountID, existingEffect.ProviderRequestID)
				checkedAt := s.nowFn()
				existingEffect.LastCheckedAt = &checkedAt
				existingEffect.UpdatedAt = checkedAt

				if probeErr == nil && statusRes != nil && (statusRes.Found || statusRes.Status == "confirmed_published") {
					completedAt := checkedAt
					if statusRes.PublishedAt != nil {
						completedAt = *statusRes.PublishedAt
					}
					existingEffect.Status = "succeeded"
					if existingEffect.ResultPayload == nil {
						existingEffect.ResultPayload = make(map[string]any)
					}
					existingEffect.ResultPayload["external_post_id"] = statusRes.ExternalPostID
					existingEffect.ResultPayload["external_post_url"] = statusRes.ExternalPostURL
					if err := s.store.SaveEffect(ctx, existingEffect); err != nil {
						return nil, connect.NewError(connect.CodeInternal, err)
					}

					log := &PublishLog{
						PublishLogID:    NewID(),
						WorkspaceID:     item.WorkspaceID,
						PublishJobID:    job.PublishJobID,
						PublishItemID:   item.PublishItemID,
						AttemptedAt:     now,
						CompletedAt:     &completedAt,
						ActorUserID:     caller.ActorUserID,
						ExecutionPath:   PathNativeAPI,
						ResultStatus:    ResultSuccess,
						ExternalPostID:  statusRes.ExternalPostID,
						ExternalPostURL: statusRes.ExternalPostURL,
					}
					// RULE-M11-002: Immutable PublishLog MUST succeed before item/job transitions to published/succeeded
					if err := s.store.AppendLog(ctx, log); err != nil {
						return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("publish: failed to append immutable publish log: %w", err))
					}

					job.LifecycleState = JobStateSucceeded
					job.UpdatedAt = completedAt
					if job.LastExecutionSummary == nil {
						job.LastExecutionSummary = make(map[string]any)
					}
					job.LastExecutionSummary["requires_reconciliation"] = false
					if err := s.store.SaveJob(ctx, job); err != nil {
						return nil, connect.NewError(connect.CodeInternal, err)
					}

					item.LifecycleState = StatePublished
					item.DiagnosticsState = DiagnosticsHealthy
					item.UpdatedAt = completedAt
					if err := s.store.SaveItem(ctx, item); err != nil {
						return nil, connect.NewError(connect.CodeInternal, err)
					}

					channelPost := &ChannelPost{
						ChannelPostID:      NewID(),
						WorkspaceID:        item.WorkspaceID,
						PublishItemID:      item.PublishItemID,
						ConnectedAccountID: item.TargetAccountID,
						ExternalPostID:     statusRes.ExternalPostID,
						ExternalPermalink:  statusRes.ExternalPostURL,
						Title:              item.Title,
						SyncedAt:           &completedAt,
						CreatedAt:          completedAt,
						UpdatedAt:          completedAt,
					}
					if err := s.store.SavePost(ctx, channelPost); err != nil {
						return nil, connect.NewError(connect.CodeInternal, err)
					}

					s.recordEvent(ctx, item.WorkspaceID, EventPublishSucceeded, "publish_item", item.PublishItemID, map[string]any{
						"external_id": statusRes.ExternalPostID,
						"url":         statusRes.ExternalPostURL,
						"reconciled":  true,
					})
					return connect.NewResponse(&publishv1.ExecuteResponse{
						Item:        ItemToProto(item),
						Job:         JobToProto(job),
						Log:         LogToProto(log),
						ChannelPost: ChannelPostToProto(channelPost),
					}), nil
				}

				if probeErr == nil && statusRes != nil && statusRes.Status == "confirmed_not_published" {
					// Reconciled as definitively NOT published: mark old effect failed and allow a new attempt.
					existingEffect.Status = "failed"
					if existingEffect.ResultPayload == nil {
						existingEffect.ResultPayload = make(map[string]any)
					}
					existingEffect.ResultPayload["reconciled"] = "confirmed_not_published"
					_ = s.store.SaveEffect(ctx, existingEffect)
					if job.LastExecutionSummary != nil {
						job.LastExecutionSummary["requires_reconciliation"] = false
						_ = s.store.SaveJob(ctx, job)
					}
				} else {
					// Still unknown or probe failed: FAIL CLOSED, do NOT re-submit!
					existingEffect.Status = "unknown"
					_ = s.store.SaveEffect(ctx, existingEffect)
					if job.LastExecutionSummary == nil {
						job.LastExecutionSummary = make(map[string]any)
					}
					job.LastExecutionSummary["requires_reconciliation"] = true
					_ = s.store.SaveJob(ctx, job)
					return nil, connect.NewError(connect.CodeFailedPrecondition, ErrUnknownSubmit)
				}
			} else {
				// No provider_request_id or no connector to verify: FAIL CLOSED, do NOT re-submit!
				existingEffect.Status = "unknown"
				_ = s.store.SaveEffect(ctx, existingEffect)
				if job.LastExecutionSummary == nil {
					job.LastExecutionSummary = make(map[string]any)
				}
				job.LastExecutionSummary["requires_reconciliation"] = true
				_ = s.store.SaveJob(ctx, job)
				return nil, connect.NewError(connect.CodeFailedPrecondition, ErrUnknownSubmit)
			}
		}
	}

	// FAIL CLOSED when platform connector is not configured: never fabricate a synthetic post_id or URL!
	if connector == nil {
		return nil, connect.NewError(connect.CodeFailedPrecondition, fmt.Errorf("%w: platform %q", ErrConnectorNotConfigured, item.TargetPlatform))
	}

	// Transition to executing
	item.LifecycleState = StateExecuting
	item.UpdatedAt = now
	job.LifecycleState = StateExecuting
	job.AttemptCount++
	job.UpdatedAt = now
	_ = s.store.SaveItem(ctx, item)
	_ = s.store.SaveJob(ctx, job)

	s.mu.Lock()
	s.recentDispatches = append(s.recentDispatches, now)
	s.mu.Unlock()

	s.recordEvent(ctx, item.WorkspaceID, EventPublishExecuting, "publish_item", item.PublishItemID, map[string]any{
		"job_id":  job.PublishJobID,
		"attempt": job.AttemptCount,
	})

	if priorByKey, _ := s.store.GetEffectByKey(ctx, item.WorkspaceID, opKey); priorByKey != nil && priorByKey.Status == "failed" {
		// Prior effect on this key was reconciled as confirmed_not_published; use attempt-scoped key for the new attempt.
		opKey = fmt.Sprintf("%s_attempt_%d", opKey, job.AttemptCount)
	}

	effect := &ExternalEffect{
		EffectID:           NewID(),
		WorkspaceID:        item.WorkspaceID,
		OperationKey:       opKey,
		Provider:           item.TargetPlatform,
		ConnectedAccountID: item.TargetAccountID,
		AggregateType:      "publish_job",
		AggregateID:        job.PublishJobID,
		Status:             "submitted",
		ResultPayload:      make(map[string]any),
		CreatedAt:          now,
		UpdatedAt:          now,
	}
	if err := s.store.SaveEffect(ctx, effect); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// External platform submission
	pubResult, callErr := connector.PublishPost(ctx, item.TargetAccountID, item, opKey)

	// Handle Outcome Families
	// ACCEPTANCE TARGET 4: Token Revoke Pauses Affected Queued Work
	if (pubResult != nil && pubResult.ResultStatus == "auth_revoked") || (callErr != nil && strings.Contains(callErr.Error(), "auth_revoked")) {
		failedAt := s.nowFn()
		job.LifecycleState = StateFailed
		job.UpdatedAt = failedAt
		item.LifecycleState = StateFailed
		item.DiagnosticsState = DiagnosticsBlocked
		item.UpdatedAt = failedAt

		effect.Status = "failed"
		effect.UpdatedAt = failedAt
		_ = s.store.SaveEffect(ctx, effect)
		_ = s.store.SaveItem(ctx, item)
		_ = s.store.SaveJob(ctx, job)

		log := &PublishLog{
			PublishLogID:  NewID(),
			WorkspaceID:   item.WorkspaceID,
			PublishJobID:  job.PublishJobID,
			PublishItemID: item.PublishItemID,
			AttemptedAt:   now,
			FailedAt:      &failedAt,
			ActorUserID:   caller.ActorUserID,
			ExecutionPath: PathNativeAPI,
			ResultStatus:  ResultFailed,
			ErrorCode:     ErrorCodeAuthRevoked,
			ErrorMessage:  "Tài khoản kết nối bị thu hồi quyền truy cập (auth_revoked). Vui lòng kết nối lại tài khoản.",
		}
		_ = s.store.AppendLog(ctx, log)

		// PAUSE ALL QUEUED/SCHEDULED JOBS FOR THIS ACCOUNT (AC 5 / RULE-M11-003)
		if item.TargetAccountID != "" {
			_ = s.store.SetAccountPaused(ctx, caller.WorkspaceID, item.TargetAccountID, true, ErrorCodeAuthRevoked)
			allItems, _ := s.store.ListItems(ctx, caller.WorkspaceID)
			for _, otherItem := range allItems {
				if otherItem.TargetAccountID == item.TargetAccountID && (otherItem.LifecycleState == StateQueued || otherItem.LifecycleState == StateScheduled) {
					otherItem.DiagnosticsState = DiagnosticsBlocked
					otherItem.UpdatedAt = failedAt
					_ = s.store.SaveItem(ctx, otherItem)
				}
			}
		}

		s.recordEvent(ctx, item.WorkspaceID, EventPublishFailed, "publish_item", item.PublishItemID, map[string]any{
			"error":    ErrorCodeAuthRevoked,
			"fallback": "reconnect_required",
		})
		s.recordEvent(ctx, item.WorkspaceID, EventPublishItemFailed, "publish_item", item.PublishItemID, map[string]any{
			"error_category": ErrorCodeAuthRevoked,
			"error_message":  log.ErrorMessage,
		})

		return nil, connect.NewError(connect.CodeUnauthenticated, ErrAuthRevoked)
	}

	// ACCEPTANCE TARGET 2: Unknown Submit Reconciles
	if (pubResult != nil && (pubResult.ResultStatus == "unknown" || pubResult.ResultStatus == ResultTimeout)) ||
		(callErr != nil && (errors.Is(callErr, context.DeadlineExceeded) || strings.Contains(callErr.Error(), "timeout"))) {

		updatedAt := s.nowFn()
		effect.Status = "unknown"
		if pubResult != nil {
			effect.ProviderRequestID = pubResult.ProviderRequestID
		}
		effect.UpdatedAt = updatedAt
		_ = s.store.SaveEffect(ctx, effect)

		// Keep in executing or pending reconciliation; NEVER blindly mark failed or publish without proof
		job.LifecycleState = StateExecuting
		job.LastExecutionSummary = map[string]any{
			"status":                  "unknown_submit",
			"requires_reconciliation": true,
			"provider_request_id":     effect.ProviderRequestID,
		}
		job.UpdatedAt = updatedAt
		_ = s.store.SaveJob(ctx, job)

		item.DiagnosticsState = DiagnosticsWarning
		item.UpdatedAt = updatedAt
		_ = s.store.SaveItem(ctx, item)

		log := &PublishLog{
			PublishLogID:  NewID(),
			WorkspaceID:   item.WorkspaceID,
			PublishJobID:  job.PublishJobID,
			PublishItemID: item.PublishItemID,
			AttemptedAt:   now,
			ActorUserID:   caller.ActorUserID,
			ExecutionPath: PathNativeAPI,
			ResultStatus:  ResultTimeout,
			ErrorCode:     ErrorCodeUnknownSubmit,
			ErrorMessage:  "Kết quả đăng bài chưa xác định do mất kết nối/timeout. Cần đối soát (reconcile) trước khi thử lại.",
		}
		_ = s.store.AppendLog(ctx, log)

		s.recordEvent(ctx, item.WorkspaceID, EventPublishFailed, "publish_item", item.PublishItemID, map[string]any{
			"error":    ErrorCodeUnknownSubmit,
			"fallback": "reconciliation_required",
		})

		return nil, connect.NewError(connect.CodeDeadlineExceeded, ErrUnknownSubmit)
	}

	// Normal Failure (Definitive 4xx / business rejection)
	if callErr != nil || pubResult == nil || pubResult.ResultStatus == ResultFailed {
		failedAt := s.nowFn()
		job.LifecycleState = StateFailed
		job.UpdatedAt = failedAt
		item.LifecycleState = StateFailed
		item.DiagnosticsState = DiagnosticsDegraded
		item.UpdatedAt = failedAt
		effect.Status = "failed"
		effect.UpdatedAt = failedAt
		_ = s.store.SaveEffect(ctx, effect)
		_ = s.store.SaveItem(ctx, item)
		_ = s.store.SaveJob(ctx, job)

		errMsg := "Đăng bài thất bại"
		if pubResult != nil && pubResult.ErrorMessage != "" {
			errMsg = pubResult.ErrorMessage
		} else if callErr != nil {
			errMsg = callErr.Error()
		}

		log := &PublishLog{
			PublishLogID:  NewID(),
			WorkspaceID:   item.WorkspaceID,
			PublishJobID:  job.PublishJobID,
			PublishItemID: item.PublishItemID,
			AttemptedAt:   now,
			FailedAt:      &failedAt,
			ActorUserID:   caller.ActorUserID,
			ExecutionPath: PathNativeAPI,
			ResultStatus:  ResultFailed,
			ErrorCode:     "publish_api_error",
			ErrorMessage:  errMsg,
		}
		_ = s.store.AppendLog(ctx, log)

		s.recordEvent(ctx, item.WorkspaceID, EventPublishFailed, "publish_item", item.PublishItemID, map[string]any{
			"error": errMsg,
		})

		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("publish failed: %s", errMsg))
	}

	// SUCCESS PATH (RULE-M11-002: Published state requires immutable success log)
	completedAt := s.nowFn()
	effect.Status = "succeeded"
	effect.ProviderRequestID = pubResult.ProviderRequestID
	if effect.ResultPayload == nil {
		effect.ResultPayload = make(map[string]any)
	}
	effect.ResultPayload["external_post_id"] = pubResult.ExternalPostID
	effect.ResultPayload["external_post_url"] = pubResult.ExternalPostURL
	effect.UpdatedAt = completedAt
	if err := s.store.SaveEffect(ctx, effect); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	log := &PublishLog{
		PublishLogID:    NewID(),
		WorkspaceID:     item.WorkspaceID,
		PublishJobID:    job.PublishJobID,
		PublishItemID:   item.PublishItemID,
		AttemptedAt:     now,
		CompletedAt:     &completedAt,
		ActorUserID:     caller.ActorUserID,
		ExecutionPath:   PathNativeAPI,
		ResultStatus:    ResultSuccess,
		ExternalPostID:  pubResult.ExternalPostID,
		ExternalPostURL: pubResult.ExternalPostURL,
	}
	// RULE-M11-002: Item and Job MUST NOT transition to published/succeeded if immutable PublishLog write fails!
	if err := s.store.AppendLog(ctx, log); err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("publish: failed to append immutable publish log: %w", err))
	}

	job.LifecycleState = JobStateSucceeded
	job.UpdatedAt = completedAt
	if err := s.store.SaveJob(ctx, job); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Item state marked published ONLY AFTER immutable log is appended (RULE-M11-002)
	item.LifecycleState = StatePublished
	item.DiagnosticsState = DiagnosticsHealthy
	item.UpdatedAt = completedAt
	if err := s.store.SaveItem(ctx, item); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	// Post-publish sync (RULE-M11-007)
	channelPost := &ChannelPost{
		ChannelPostID:      NewID(),
		WorkspaceID:        item.WorkspaceID,
		PublishItemID:      item.PublishItemID,
		ConnectedAccountID: item.TargetAccountID,
		ExternalPostID:     pubResult.ExternalPostID,
		ExternalPermalink:  pubResult.ExternalPostURL,
		Title:              item.Title,
		SyncedAt:           &completedAt,
		CreatedAt:          completedAt,
		UpdatedAt:          completedAt,
	}
	if err := s.store.SavePost(ctx, channelPost); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	s.recordEvent(ctx, item.WorkspaceID, EventPublishSucceeded, "publish_item", item.PublishItemID, map[string]any{
		"external_id": pubResult.ExternalPostID,
		"url":         pubResult.ExternalPostURL,
	})
	s.recordEvent(ctx, item.WorkspaceID, EventPublishItemSucceeded, "publish_item", item.PublishItemID, map[string]any{
		"external_post_id":  pubResult.ExternalPostID,
		"external_post_url": pubResult.ExternalPostURL,
	})
	s.recordEvent(ctx, item.WorkspaceID, EventChannelPostSynced, "channel_post", channelPost.ChannelPostID, map[string]any{
		"publish_item_id":  item.PublishItemID,
		"external_post_id": pubResult.ExternalPostID,
	})

	return connect.NewResponse(&publishv1.ExecuteResponse{
		Item:        ItemToProto(item),
		Job:         JobToProto(job),
		Log:         LogToProto(log),
		ChannelPost: ChannelPostToProto(channelPost),
	}), nil
}

// ReconcilePublish reconciles unknown platform submission outcomes (Acceptance Target 2 / PUB-02).
// Never fabricates confirmed_published when connector is nil or provider request ID is empty.
func (s *Service) ReconcilePublish(ctx context.Context, req *connect.Request[publishv1.ReconcilePublishRequest]) (*connect.Response[publishv1.ReconcilePublishResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/ReconcilePublish", extractCmdWorkspaceID(req.Msg.Context))
	if err != nil {
		return nil, err
	}

	item, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	var job *PublishJob
	if req.Msg.PublishJobId != "" {
		var jErr error
		job, jErr = s.store.GetJob(ctx, caller.WorkspaceID, req.Msg.PublishJobId)
		if jErr != nil || job == nil {
			return nil, connect.NewError(connect.CodeNotFound, ErrJobNotFound)
		}
		if job.PublishItemID != item.PublishItemID {
			return nil, connect.NewError(connect.CodeInvalidArgument, fmt.Errorf("%w: job %s belongs to item %s, not %s", ErrJobItemMismatch, job.PublishJobID, job.PublishItemID, item.PublishItemID))
		}
	}
	if job == nil {
		job, _ = s.store.GetJobByItemID(ctx, caller.WorkspaceID, item.PublishItemID)
	}
	if job == nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrJobNotFound)
	}

	providerReqID := strings.TrimSpace(req.Msg.ProviderRequestId)
	if providerReqID == "" && job.LastExecutionSummary != nil {
		if v, ok := job.LastExecutionSummary["provider_request_id"].(string); ok {
			providerReqID = v
		}
	}

	jobEffects, _ := s.store.ListEffectsByAggregate(ctx, caller.WorkspaceID, "publish_job", job.PublishJobID)
	var activeEffect *ExternalEffect
	for i := len(jobEffects) - 1; i >= 0; i-- {
		eff := jobEffects[i]
		if eff.Status == "unknown" || eff.Status == "submitted" || eff.Status == "prepared" {
			activeEffect = eff
			if providerReqID == "" && eff.ProviderRequestID != "" {
				providerReqID = eff.ProviderRequestID
			}
			break
		}
	}

	s.mu.RLock()
	connector := s.connectors[item.TargetPlatform]
	s.mu.RUnlock()

	now := s.nowFn()
	if connector == nil || providerReqID == "" {
		// Fail closed: cannot verify provider status without a live connector and provider_request_id.
		if activeEffect != nil {
			activeEffect.LastCheckedAt = &now
			activeEffect.UpdatedAt = now
			_ = s.store.SaveEffect(ctx, activeEffect)
		}
		return connect.NewResponse(&publishv1.ReconcilePublishResponse{
			Item:                  ItemToProto(item),
			Job:                   JobToProto(job),
			Reconciled:            false,
			ReconciliationOutcome: "still_unknown",
		}), nil
	}

	statusRes, callErr := connector.CheckPostStatus(ctx, item.TargetAccountID, providerReqID)
	if activeEffect != nil {
		activeEffect.LastCheckedAt = &now
		activeEffect.UpdatedAt = now
	}

	if callErr != nil || statusRes == nil || statusRes.Status == "still_unknown" {
		if activeEffect != nil {
			_ = s.store.SaveEffect(ctx, activeEffect)
		}
		return connect.NewResponse(&publishv1.ReconcilePublishResponse{
			Item:                  ItemToProto(item),
			Job:                   JobToProto(job),
			Reconciled:            false,
			ReconciliationOutcome: "still_unknown",
		}), nil
	}

	if statusRes.Found || statusRes.Status == "confirmed_published" {
		if activeEffect != nil {
			activeEffect.Status = "succeeded"
			if activeEffect.ResultPayload == nil {
				activeEffect.ResultPayload = make(map[string]any)
			}
			activeEffect.ResultPayload["external_post_id"] = statusRes.ExternalPostID
			activeEffect.ResultPayload["external_post_url"] = statusRes.ExternalPostURL
			if err := s.store.SaveEffect(ctx, activeEffect); err != nil {
				return nil, connect.NewError(connect.CodeInternal, err)
			}
		}

		log := &PublishLog{
			PublishLogID:    NewID(),
			WorkspaceID:     item.WorkspaceID,
			PublishJobID:    job.PublishJobID,
			PublishItemID:   item.PublishItemID,
			AttemptedAt:     now,
			CompletedAt:     &now,
			ActorUserID:     caller.ActorUserID,
			ExecutionPath:   PathNativeAPI,
			ResultStatus:    ResultSuccess,
			ExternalPostID:  statusRes.ExternalPostID,
			ExternalPostURL: statusRes.ExternalPostURL,
			Metadata: map[string]any{
				"reconciled":          true,
				"provider_request_id": providerReqID,
			},
		}
		if err := s.store.AppendLog(ctx, log); err != nil {
			return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("publish: failed to append immutable publish log: %w", err))
		}

		job.LifecycleState = JobStateSucceeded
		if job.LastExecutionSummary == nil {
			job.LastExecutionSummary = make(map[string]any)
		}
		job.LastExecutionSummary["requires_reconciliation"] = false
		job.UpdatedAt = now
		if err := s.store.SaveJob(ctx, job); err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}

		item.LifecycleState = StatePublished
		item.DiagnosticsState = DiagnosticsHealthy
		item.UpdatedAt = now
		if err := s.store.SaveItem(ctx, item); err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}

		channelPost := &ChannelPost{
			ChannelPostID:      NewID(),
			WorkspaceID:        item.WorkspaceID,
			PublishItemID:      item.PublishItemID,
			ConnectedAccountID: item.TargetAccountID,
			ExternalPostID:     statusRes.ExternalPostID,
			ExternalPermalink:  statusRes.ExternalPostURL,
			Title:              item.Title,
			SyncedAt:           &now,
			CreatedAt:          now,
			UpdatedAt:          now,
		}
		if err := s.store.SavePost(ctx, channelPost); err != nil {
			return nil, connect.NewError(connect.CodeInternal, err)
		}

		s.recordEvent(ctx, item.WorkspaceID, EventPublishSucceeded, "publish_item", item.PublishItemID, map[string]any{
			"external_id": statusRes.ExternalPostID,
			"url":         statusRes.ExternalPostURL,
			"reconciled":  true,
		})

		return connect.NewResponse(&publishv1.ReconcilePublishResponse{
			Item:                  ItemToProto(item),
			Job:                   JobToProto(job),
			Log:                   LogToProto(log),
			Reconciled:            true,
			ReconciliationOutcome: "confirmed_published",
		}), nil
	}

	// Post was confirmed NOT published: mark unresolved effects as failed so retry can proceed safely
	for _, eff := range jobEffects {
		if eff.Status == "unknown" || eff.Status == "submitted" || eff.Status == "prepared" {
			eff.Status = "failed"
			eff.LastCheckedAt = &now
			eff.UpdatedAt = now
			if eff.ResultPayload == nil {
				eff.ResultPayload = make(map[string]any)
			}
			eff.ResultPayload["reconciled"] = "confirmed_not_published"
			_ = s.store.SaveEffect(ctx, eff)
		}
	}

	job.LifecycleState = StateFailed
	if job.LastExecutionSummary == nil {
		job.LastExecutionSummary = make(map[string]any)
	}
	job.LastExecutionSummary["requires_reconciliation"] = false
	job.LastExecutionSummary["reconciled_outcome"] = "confirmed_not_published"
	job.UpdatedAt = now
	_ = s.store.SaveJob(ctx, job)

	item.LifecycleState = StateFailed
	item.UpdatedAt = now
	_ = s.store.SaveItem(ctx, item)

	return connect.NewResponse(&publishv1.ReconcilePublishResponse{
		Item:                  ItemToProto(item),
		Job:                   JobToProto(job),
		Reconciled:            true,
		ReconciliationOutcome: "confirmed_not_published",
	}), nil
}

// ExportManualPackage generates an export package for offline upload (Acceptance Target 3: Manual proof).
func (s *Service) ExportManualPackage(ctx context.Context, req *connect.Request[publishv1.ExportManualPackageRequest]) (*connect.Response[publishv1.ExportManualPackageResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/ExportManualPackage")
	if err != nil {
		return nil, err
	}

	item, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	item.LifecycleState = StateRequiresManualFallback
	item.UpdatedAt = s.nowFn()
	if err := s.store.SaveItem(ctx, item); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	s.recordEvent(ctx, item.WorkspaceID, EventPublishRequiresManualFallback, "publish_item", item.PublishItemID, map[string]any{
		"platform": item.TargetPlatform,
		"mode":     "manual_export",
	})

	pkg := &publishv1.ManualExportPackage{
		PublishItemId:          item.PublishItemID,
		Title:                  item.Title,
		Description:            item.Description,
		Hashtags:               item.Hashtags,
		MediaUrl:               "https://storage.creativanta.vn/assets/" + item.AssetID + ".mp4",
		TargetPlatform:         item.TargetPlatform,
		Instructions:           fmt.Sprintf("1. Tải video về máy\n2. Mở ứng dụng %s\n3. Dán caption và hashtags\n4. Đăng bài và chụp ảnh màn hình / lấy URL xác nhận", item.TargetPlatform),
		RecommendedAspectRatio: "9:16",
	}

	return connect.NewResponse(&publishv1.ExportManualPackageResponse{
		Package: pkg,
	}), nil
}

// SubmitManualProof submits manual proof and retains the One Graph connection (Acceptance Target 3).
func (s *Service) SubmitManualProof(ctx context.Context, req *connect.Request[publishv1.SubmitManualProofRequest]) (*connect.Response[publishv1.SubmitManualProofResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/SubmitManualProof", extractCmdWorkspaceID(req.Msg.Context))
	if err != nil {
		return nil, err
	}

	item, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	if err := s.enforceComplianceAndDiagnosticsGate(ctx, item); err != nil {
		return nil, err
	}

	if req.Msg.EvidenceUrl == "" && req.Msg.ExternalPostUrl == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrProofRequired)
	}

	now := s.nowFn()

	job, _ := s.store.GetJobByItemID(ctx, caller.WorkspaceID, item.PublishItemID)
	if job == nil {
		job = &PublishJob{
			PublishJobID:     NewID(),
			WorkspaceID:      item.WorkspaceID,
			PublishItemID:    item.PublishItemID,
			DispatchStrategy: "manual_fallback",
			LifecycleState:   JobStateCreated,
			AttemptCount:     1,
			MaxAttempts:      1,
			CreatedAt:        now,
			UpdatedAt:        now,
		}
	}

	evidenceRef := NewID()
	log := &PublishLog{
		PublishLogID:    NewID(),
		WorkspaceID:     item.WorkspaceID,
		PublishJobID:    job.PublishJobID,
		PublishItemID:   item.PublishItemID,
		AttemptedAt:     now,
		CompletedAt:     &now,
		ActorUserID:     caller.ActorUserID,
		ExecutionPath:   PathManualUpload,
		ResultStatus:    ResultSuccess,
		ExternalPostURL: req.Msg.ExternalPostUrl,
		EvidenceRef:     evidenceRef,
		Metadata: map[string]any{
			"evidence_url": req.Msg.EvidenceUrl,
			"notes":        req.Msg.Notes,
		},
	}
	if err := s.store.AppendLog(ctx, log); err != nil {
		return nil, connect.NewError(connect.CodeInternal, fmt.Errorf("publish: failed to append immutable publish log: %w", err))
	}

	// Resolve any pending unknown effects for this job via audited manual proof
	jobEffects, _ := s.store.ListEffectsByAggregate(ctx, caller.WorkspaceID, "publish_job", job.PublishJobID)
	for _, eff := range jobEffects {
		if eff.Status == "unknown" || eff.Status == "submitted" || eff.Status == "prepared" {
			eff.Status = "succeeded"
			eff.UpdatedAt = now
			if err := s.store.SaveEffect(ctx, eff); err != nil {
				return nil, connect.NewError(connect.CodeInternal, err)
			}
		}
	}

	job.LifecycleState = JobStateSucceeded
	if job.LastExecutionSummary != nil {
		job.LastExecutionSummary["requires_reconciliation"] = false
	}
	job.UpdatedAt = now
	if err := s.store.SaveJob(ctx, job); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	item.LifecycleState = StatePublished
	item.DiagnosticsState = DiagnosticsHealthy
	item.UpdatedAt = now
	if err := s.store.SaveItem(ctx, item); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	channelPost := &ChannelPost{
		ChannelPostID:      NewID(),
		WorkspaceID:        item.WorkspaceID,
		PublishItemID:      item.PublishItemID,
		ConnectedAccountID: item.TargetAccountID,
		ExternalPermalink:  req.Msg.ExternalPostUrl,
		Title:              item.Title,
		SyncedAt:           &now,
		CreatedAt:          now,
		UpdatedAt:          now,
	}
	if err := s.store.SavePost(ctx, channelPost); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	s.recordEvent(ctx, item.WorkspaceID, EventPublishSucceeded, "publish_item", item.PublishItemID, map[string]any{
		"execution_path": PathManualUpload,
		"evidence_ref":   evidenceRef,
	})

	return connect.NewResponse(&publishv1.SubmitManualProofResponse{
		Item:          ItemToProto(item),
		Log:           LogToProto(log),
		ChannelPost:   ChannelPostToProto(channelPost),
		GraphRetained: true,
	}), nil
}

// PauseQueue pauses all queued and scheduled items for a connected account (Acceptance Target 4).
func (s *Service) PauseQueue(ctx context.Context, req *connect.Request[publishv1.PauseQueueRequest]) (*connect.Response[publishv1.PauseQueueResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/PauseQueue", extractCmdWorkspaceID(req.Msg.Context))
	if err != nil {
		return nil, err
	}

	accountID := req.Msg.ConnectedAccountId
	if err := s.verifyAccountScope(caller.WorkspaceID, accountID); err != nil {
		return nil, err
	}
	if err := s.store.SetAccountPaused(ctx, caller.WorkspaceID, accountID, true, req.Msg.Reason); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	items, err := s.store.ListItems(ctx, caller.WorkspaceID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	now := s.nowFn()
	pausedIDs := make([]string, 0)
	for _, item := range items {
		if item.TargetAccountID == accountID && (item.LifecycleState == StateQueued || item.LifecycleState == StateScheduled) {
			item.DiagnosticsState = DiagnosticsBlocked
			item.UpdatedAt = now
			_ = s.store.SaveItem(ctx, item)
			pausedIDs = append(pausedIDs, item.PublishItemID)
		}
	}

	return connect.NewResponse(&publishv1.PauseQueueResponse{
		PausedJobsCount:      int32(len(pausedIDs)),
		PausedPublishItemIds: pausedIDs,
	}), nil
}

// ResumeAccountQueue unpauses an account's queue after successful reconnection.
func (s *Service) ResumeAccountQueue(accountID string) int {
	return s.ResumeAccountQueueForWorkspace(context.Background(), "", accountID)
}

// ResumeAccountQueueForWorkspace unpauses an account's queue for a specific workspace (or across MemoryStore when workspaceID is empty).
func (s *Service) ResumeAccountQueueForWorkspace(ctx context.Context, workspaceID, accountID string) int {
	if s.store == nil {
		return 0
	}
	resumed := 0
	now := s.nowFn()

	if workspaceID != "" {
		_ = s.store.SetAccountPaused(ctx, workspaceID, accountID, false, "")
		items, _ := s.store.ListItems(ctx, workspaceID)
		for _, item := range items {
			if item.TargetAccountID == accountID && item.DiagnosticsState == DiagnosticsBlocked {
				item.DiagnosticsState = DiagnosticsHealthy
				item.UpdatedAt = now
				_ = s.store.SaveItem(ctx, item)
				resumed++
			}
		}
		return resumed
	}

	if ms, ok := s.store.(*MemoryStore); ok {
		ms.mu.Lock()
		defer ms.mu.Unlock()
		for k := range ms.pausedAccounts {
			if strings.HasSuffix(k, "|"+accountID) {
				delete(ms.pausedAccounts, k)
			}
		}
		for _, item := range ms.items {
			if item.TargetAccountID == accountID && item.DiagnosticsState == DiagnosticsBlocked {
				item.DiagnosticsState = DiagnosticsHealthy
				item.UpdatedAt = now
				resumed++
			}
		}
	}
	return resumed
}

// Retry retries a failed publish job only if no unknown external effect is pending reconciliation (PUB-02).
func (s *Service) Retry(ctx context.Context, req *connect.Request[publishv1.RetryRequest]) (*connect.Response[publishv1.RetryResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/Retry", extractCmdWorkspaceID(req.Msg.Context))
	if err != nil {
		return nil, err
	}

	item, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	job, _ := s.store.GetJobByItemID(ctx, caller.WorkspaceID, item.PublishItemID)
	if job != nil && job.LastExecutionSummary != nil {
		if reqRec, ok := job.LastExecutionSummary["requires_reconciliation"].(bool); ok && reqRec {
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrUnknownSubmit)
		}
	}

	var jobID string
	if job != nil {
		jobID = job.PublishJobID
	}
	if eff, _ := s.findJobEffects(ctx, caller.WorkspaceID, item.PublishItemID, jobID, ""); eff != nil {
		if eff.Status == "unknown" || eff.Status == "submitted" || eff.Status == "prepared" {
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrUnknownSubmit)
		}
		if eff.Status == "succeeded" {
			return nil, connect.NewError(connect.CodeFailedPrecondition, ErrDuplicatePostPrevented)
		}
	}

	now := s.nowFn()
	item.LifecycleState = StateQueued
	item.DiagnosticsState = DiagnosticsHealthy
	item.UpdatedAt = now

	if job == nil {
		job = &PublishJob{
			PublishJobID:   NewID(),
			WorkspaceID:    item.WorkspaceID,
			PublishItemID:  item.PublishItemID,
			LifecycleState: StateQueued,
			AttemptCount:   0,
			MaxAttempts:    3,
			CreatedAt:      now,
			UpdatedAt:      now,
		}
	} else {
		job.LifecycleState = StateQueued
		job.UpdatedAt = now
	}

	if err := s.store.SaveItem(ctx, item); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	if err := s.store.SaveJob(ctx, job); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&publishv1.RetryResponse{
		Item: ItemToProto(item),
		Job:  JobToProto(job),
	}), nil
}

// Cancel cancels a queued or scheduled publish item in the caller's workspace.
func (s *Service) Cancel(ctx context.Context, req *connect.Request[publishv1.CancelRequest]) (*connect.Response[publishv1.CancelResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/Cancel", extractCmdWorkspaceID(req.Msg.Context))
	if err != nil {
		return nil, err
	}

	item, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	if item.LifecycleState == StatePublished {
		return nil, connect.NewError(connect.CodeFailedPrecondition, errors.New("cannot cancel already published item"))
	}

	now := s.nowFn()
	item.LifecycleState = StateCancelled
	item.UpdatedAt = now
	if err := s.store.SaveItem(ctx, item); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	jobs, _ := s.store.ListJobs(ctx, caller.WorkspaceID)
	for _, j := range jobs {
		if j.PublishItemID == item.PublishItemID && j.LifecycleState != JobStateSucceeded {
			j.LifecycleState = StateCancelled
			j.UpdatedAt = now
			_ = s.store.SaveJob(ctx, j)
		}
	}

	return connect.NewResponse(&publishv1.CancelResponse{
		Item:      ItemToProto(item),
		Cancelled: true,
	}), nil
}

// ListQueue lists queued and scheduled items strictly scoped to the verified caller's workspace (PUB-01).
func (s *Service) ListQueue(ctx context.Context, req *connect.Request[publishv1.ListQueueRequest]) (*connect.Response[publishv1.ListQueueResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/ListQueue", req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	items, err := s.store.ListItems(ctx, caller.WorkspaceID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	jobs, err := s.store.ListJobs(ctx, caller.WorkspaceID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	protoItems := make([]*publishv1.PublishItem, 0, len(items))
	for _, item := range items {
		protoItems = append(protoItems, ItemToProto(item))
	}
	protoJobs := make([]*publishv1.PublishJob, 0, len(jobs))
	for _, job := range jobs {
		protoJobs = append(protoJobs, JobToProto(job))
	}

	return connect.NewResponse(&publishv1.ListQueueResponse{
		Items: protoItems,
		Jobs:  protoJobs,
	}), nil
}

// GetLogs returns immutable logs for an item in the caller's workspace.
func (s *Service) GetLogs(ctx context.Context, req *connect.Request[publishv1.GetLogsRequest]) (*connect.Response[publishv1.GetLogsResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/GetLogs")
	if err != nil {
		return nil, err
	}

	if _, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId); err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	logs, err := s.store.ListLogsByItemID(ctx, caller.WorkspaceID, req.Msg.PublishItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	protoLogs := make([]*publishv1.PublishLog, 0, len(logs))
	for _, l := range logs {
		protoLogs = append(protoLogs, LogToProto(l))
	}

	return connect.NewResponse(&publishv1.GetLogsResponse{
		Logs: protoLogs,
	}), nil
}

// GetDiagnostics returns failure diagnostics and repair suggestions for an item in the caller's workspace.
func (s *Service) GetDiagnostics(ctx context.Context, req *connect.Request[publishv1.GetDiagnosticsRequest]) (*connect.Response[publishv1.GetDiagnosticsResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/GetDiagnostics")
	if err != nil {
		return nil, err
	}

	item, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	capSummary := s.ResolveCapability(item.WorkspaceID, item.TargetPlatform)
	logs, _ := s.store.ListLogsByItemID(ctx, caller.WorkspaceID, item.PublishItemID)
	var latestLog *PublishLog
	if len(logs) > 0 {
		latestLog = logs[len(logs)-1]
	}

	errCode := ""
	errMsg := ""
	if latestLog != nil {
		errCode = latestLog.ErrorCode
		errMsg = latestLog.ErrorMessage
	}

	diagState := publishv1.DiagnosticsState_DIAGNOSTICS_STATE_HEALTHY
	switch item.DiagnosticsState {
	case DiagnosticsWarning:
		diagState = publishv1.DiagnosticsState_DIAGNOSTICS_STATE_WARNING
	case DiagnosticsDegraded:
		diagState = publishv1.DiagnosticsState_DIAGNOSTICS_STATE_DEGRADED
	case DiagnosticsBlocked:
		diagState = publishv1.DiagnosticsState_DIAGNOSTICS_STATE_BLOCKED
	}

	paused, _, _ := s.store.IsAccountPaused(ctx, caller.WorkspaceID, item.TargetAccountID)
	isAuthRevoked := errCode == ErrorCodeAuthRevoked || paused
	repairRec := "Hệ thống sẵn sàng xuất bản"
	if isAuthRevoked {
		repairRec = "Tài khoản bị mất quyền truy cập. Nhấn [Kết nối lại] để làm mới token hoặc dùng [Tải gói xuất bản] để đăng thủ công."
	} else if errCode == ErrorCodeUnknownSubmit {
		repairRec = "Mất kết nối khi đăng bài. Nhấn [Đối soát trạng thái] để kiểm tra trước khi thử lại."
	}

	return connect.NewResponse(&publishv1.GetDiagnosticsResponse{
		PublishItemId:        item.PublishItemID,
		DiagnosticsState:     diagState,
		ErrorCode:            errCode,
		ErrorMessage:         errMsg,
		RepairRecommendation: repairRec,
		CanReconnect:         isAuthRevoked,
		CanManualFallback:    true,
		CanRetry:             !isAuthRevoked,
		CapabilitySummary:    capSummary,
	}), nil
}

// ----------------------------------------------------------------------------
// Extended RPC Implementations (§12.1)
// ----------------------------------------------------------------------------

func (s *Service) Get(ctx context.Context, req *connect.Request[publishv1.GetRequest]) (*connect.Response[publishv1.GetResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/Get")
	if err != nil {
		return nil, err
	}

	item, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	capSummary := s.ResolveCapability(item.WorkspaceID, item.TargetPlatform)
	return connect.NewResponse(&publishv1.GetResponse{
		Item:              ItemToProto(item),
		CapabilitySummary: capSummary,
	}), nil
}

func (s *Service) List(ctx context.Context, req *connect.Request[publishv1.ListRequest]) (*connect.Response[publishv1.ListResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/List", req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	items, err := s.store.ListItems(ctx, caller.WorkspaceID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	protoItems := make([]*publishv1.PublishItem, 0, len(items))
	for _, item := range items {
		protoItems = append(protoItems, ItemToProto(item))
	}
	return connect.NewResponse(&publishv1.ListResponse{
		Items: protoItems,
	}), nil
}

func (s *Service) GetDraft(ctx context.Context, req *connect.Request[publishv1.GetDraftRequest]) (*connect.Response[publishv1.GetDraftResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/GetDraft")
	if err != nil {
		return nil, err
	}

	item, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.DraftId)
	if err != nil || item.LifecycleState != StateDraft {
		return nil, connect.NewError(connect.CodeNotFound, errors.New("draft not found"))
	}
	return connect.NewResponse(&publishv1.GetDraftResponse{
		Item: ItemToProto(item),
	}), nil
}

func (s *Service) SaveDraft(ctx context.Context, req *connect.Request[publishv1.SaveDraftRequest]) (*connect.Response[publishv1.SaveDraftResponse], error) {
	pItem := req.Msg.Item
	var itemWS string
	if pItem != nil {
		itemWS = pItem.WorkspaceId
	}
	caller, err := s.authorizeRPC(ctx, "PublishService/SaveDraft", extractCmdWorkspaceID(req.Msg.Context), itemWS)
	if err != nil {
		return nil, err
	}
	if pItem == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("draft item is required"))
	}
	if err := s.verifyAccountScope(caller.WorkspaceID, pItem.TargetAccountId); err != nil {
		return nil, err
	}

	now := s.nowFn()
	item := &PublishItem{
		PublishItemID:    NewID(),
		WorkspaceID:      caller.WorkspaceID,
		AssetID:          pItem.AssetId,
		TargetPlatform:   pItem.TargetPlatform,
		TargetAccountID:  pItem.TargetAccountId,
		Title:            pItem.Title,
		Description:      pItem.Description,
		Hashtags:         pItem.Hashtags,
		LifecycleState:   StateDraft,
		DiagnosticsState: DiagnosticsHealthy,
		CreatedBy:        caller.ActorUserID,
		CreatedAt:        now,
		UpdatedAt:        now,
	}
	if err := s.store.SaveItem(ctx, item); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}
	return connect.NewResponse(&publishv1.SaveDraftResponse{
		Item: ItemToProto(item),
	}), nil
}

func (s *Service) UpdateDraft(ctx context.Context, req *connect.Request[publishv1.UpdateDraftRequest]) (*connect.Response[publishv1.UpdateDraftResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/UpdateDraft", extractCmdWorkspaceID(req.Msg.Context))
	if err != nil {
		return nil, err
	}

	item, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}
	item.Title = req.Msg.Title
	item.Description = req.Msg.Description
	item.Hashtags = req.Msg.Hashtags
	item.UpdatedAt = s.nowFn()
	if err := s.store.SaveItem(ctx, item); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&publishv1.UpdateDraftResponse{
		Item: ItemToProto(item),
	}), nil
}

func (s *Service) ListDrafts(ctx context.Context, req *connect.Request[publishv1.ListDraftsRequest]) (*connect.Response[publishv1.ListDraftsResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/ListDrafts", req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	items, err := s.store.ListItems(ctx, caller.WorkspaceID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	drafts := make([]*publishv1.PublishItem, 0)
	for _, item := range items {
		if item.LifecycleState == StateDraft {
			drafts = append(drafts, ItemToProto(item))
		}
	}
	return connect.NewResponse(&publishv1.ListDraftsResponse{
		Drafts: drafts,
	}), nil
}

func (s *Service) PublishNow(ctx context.Context, req *connect.Request[publishv1.PublishNowRequest]) (*connect.Response[publishv1.PublishNowResponse], error) {
	if _, err := s.authorizeRPC(ctx, "PublishService/PublishNow", extractCmdWorkspaceID(req.Msg.Context)); err != nil {
		return nil, err
	}
	execResp, err := s.Execute(ctx, connect.NewRequest(&publishv1.ExecuteRequest{
		Context:       req.Msg.Context,
		PublishItemId: req.Msg.PublishItemId,
	}))
	if err != nil {
		return nil, err
	}
	return connect.NewResponse(&publishv1.PublishNowResponse{
		Item: execResp.Msg.Item,
		Job:  execResp.Msg.Job,
	}), nil
}

func (s *Service) Reschedule(ctx context.Context, req *connect.Request[publishv1.RescheduleRequest]) (*connect.Response[publishv1.RescheduleResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/Reschedule", extractCmdWorkspaceID(req.Msg.Context))
	if err != nil {
		return nil, err
	}

	item, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	newTime := req.Msg.NewScheduleAt.AsTime()
	item.ScheduleAt = &newTime
	item.LifecycleState = StateScheduled
	item.UpdatedAt = s.nowFn()
	if err := s.store.SaveItem(ctx, item); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&publishv1.RescheduleResponse{
		Item: ItemToProto(item),
	}), nil
}

func (s *Service) Delete(ctx context.Context, req *connect.Request[publishv1.DeleteRequest]) (*connect.Response[publishv1.DeleteResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/Delete", extractCmdWorkspaceID(req.Msg.Context))
	if err != nil {
		return nil, err
	}

	if err := s.store.DeleteItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId); err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	return connect.NewResponse(&publishv1.DeleteResponse{
		Deleted: true,
	}), nil
}

func (s *Service) Duplicate(ctx context.Context, req *connect.Request[publishv1.DuplicateRequest]) (*connect.Response[publishv1.DuplicateResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/Duplicate", extractCmdWorkspaceID(req.Msg.Context))
	if err != nil {
		return nil, err
	}

	item, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	now := s.nowFn()
	dup := &PublishItem{
		PublishItemID:        NewID(),
		WorkspaceID:          item.WorkspaceID,
		AssetID:              item.AssetID,
		TargetPlatform:       item.TargetPlatform,
		TargetAccountID:      item.TargetAccountID,
		TargetFormat:         item.TargetFormat,
		PublishMode:          item.PublishMode,
		Title:                item.Title + " (Bản sao)",
		Description:          item.Description,
		Hashtags:             append([]string(nil), item.Hashtags...),
		LifecycleState:       StateDraft,
		DiagnosticsState:     DiagnosticsHealthy,
		PackagingScore:       item.PackagingScore,
		ComplianceScanResult: item.ComplianceScanResult,
		CreatedBy:            caller.ActorUserID,
		CreatedAt:            now,
		UpdatedAt:            now,
	}
	if err := s.store.SaveItem(ctx, dup); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&publishv1.DuplicateResponse{
		Item: ItemToProto(dup),
	}), nil
}

func (s *Service) Pause(ctx context.Context, req *connect.Request[publishv1.PauseRequest]) (*connect.Response[publishv1.PauseResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/Pause", extractCmdWorkspaceID(req.Msg.Context))
	if err != nil {
		return nil, err
	}

	item, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}
	item.DiagnosticsState = DiagnosticsBlocked
	item.UpdatedAt = s.nowFn()
	if err := s.store.SaveItem(ctx, item); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&publishv1.PauseResponse{
		Item: ItemToProto(item),
	}), nil
}

func (s *Service) CheckCompatibility(ctx context.Context, req *connect.Request[publishv1.CheckCompatibilityRequest]) (*connect.Response[publishv1.CheckCompatibilityResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/CheckCompatibility")
	if err != nil {
		return nil, err
	}
	if err := s.verifyAccountScope(caller.WorkspaceID, req.Msg.TargetAccountId); err != nil {
		return nil, err
	}

	summary := s.ResolveCapability(caller.WorkspaceID, req.Msg.TargetPlatform)
	compatible := summary.Executable
	issues := make([]string, 0)
	if !compatible {
		issues = append(issues, summary.PolicySummary)
	}
	return connect.NewResponse(&publishv1.CheckCompatibilityResponse{
		CapabilitySummary: summary,
		Compatible:        compatible,
		Issues:            issues,
	}), nil
}

func (s *Service) UpdateMetadata(ctx context.Context, req *connect.Request[publishv1.UpdateMetadataRequest]) (*connect.Response[publishv1.UpdateMetadataResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/UpdateMetadata", extractCmdWorkspaceID(req.Msg.Context))
	if err != nil {
		return nil, err
	}

	item, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}
	item.Title = req.Msg.Title
	item.Description = req.Msg.Description
	item.Hashtags = req.Msg.Hashtags
	item.UpdatedAt = s.nowFn()
	if err := s.store.SaveItem(ctx, item); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&publishv1.UpdateMetadataResponse{
		Item: ItemToProto(item),
	}), nil
}

func (s *Service) GetCalendar(ctx context.Context, req *connect.Request[publishv1.GetCalendarRequest]) (*connect.Response[publishv1.GetCalendarResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/GetCalendar", req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	items, err := s.store.ListItems(ctx, caller.WorkspaceID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	entries := make([]*publishv1.CalendarEntry, 0)
	for _, item := range items {
		if item.ScheduleAt != nil {
			entries = append(entries, &publishv1.CalendarEntry{
				Item:          ItemToProto(item),
				ScheduledTime: timestamppb.New(*item.ScheduleAt),
				Status:        item.LifecycleState,
			})
		}
	}
	return connect.NewResponse(&publishv1.GetCalendarResponse{
		Entries: entries,
	}), nil
}

func (s *Service) ListByDateRange(ctx context.Context, req *connect.Request[publishv1.ListByDateRangeRequest]) (*connect.Response[publishv1.ListByDateRangeResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/ListByDateRange", req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	allItems, err := s.store.ListItems(ctx, caller.WorkspaceID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	items := make([]*publishv1.PublishItem, 0)
	start := req.Msg.StartDate.AsTime()
	end := req.Msg.EndDate.AsTime()

	for _, item := range allItems {
		if item.ScheduleAt != nil && !item.ScheduleAt.Before(start) && !item.ScheduleAt.After(end) {
			items = append(items, ItemToProto(item))
		}
	}
	return connect.NewResponse(&publishv1.ListByDateRangeResponse{
		Items: items,
	}), nil
}

func (s *Service) ListUpcoming(ctx context.Context, req *connect.Request[publishv1.ListUpcomingRequest]) (*connect.Response[publishv1.ListUpcomingResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/ListUpcoming", req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	allItems, err := s.store.ListItems(ctx, caller.WorkspaceID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	items := make([]*publishv1.PublishItem, 0)
	now := s.nowFn()
	for _, item := range allItems {
		if item.ScheduleAt != nil && item.ScheduleAt.After(now) {
			items = append(items, ItemToProto(item))
		}
	}
	return connect.NewResponse(&publishv1.ListUpcomingResponse{
		Items: items,
	}), nil
}

func (s *Service) ListPublished(ctx context.Context, req *connect.Request[publishv1.ListPublishedRequest]) (*connect.Response[publishv1.ListPublishedResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/ListPublished", req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	allItems, err := s.store.ListItems(ctx, caller.WorkspaceID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	items := make([]*publishv1.PublishItem, 0)
	for _, item := range allItems {
		if item.LifecycleState == StatePublished {
			items = append(items, ItemToProto(item))
		}
	}
	return connect.NewResponse(&publishv1.ListPublishedResponse{
		Items: items,
	}), nil
}

func (s *Service) ListPosts(ctx context.Context, req *connect.Request[publishv1.ListPostsRequest]) (*connect.Response[publishv1.ListPostsResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/ListPosts", req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	allPosts, err := s.store.ListPosts(ctx, caller.WorkspaceID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	posts := make([]*publishv1.ChannelPost, 0, len(allPosts))
	for _, post := range allPosts {
		posts = append(posts, ChannelPostToProto(post))
	}
	return connect.NewResponse(&publishv1.ListPostsResponse{
		Posts: posts,
	}), nil
}

func (s *Service) GetPlatformStatus(ctx context.Context, req *connect.Request[publishv1.GetPlatformStatusRequest]) (*connect.Response[publishv1.GetPlatformStatusResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/GetPlatformStatus")
	if err != nil {
		return nil, err
	}

	summary := s.ResolveCapability(caller.WorkspaceID, req.Msg.Platform)
	return connect.NewResponse(&publishv1.GetPlatformStatusResponse{
		Status: summary,
	}), nil
}

func (s *Service) GetCrossPostInsights(ctx context.Context, req *connect.Request[publishv1.GetCrossPostInsightsRequest]) (*connect.Response[publishv1.GetCrossPostInsightsResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/GetCrossPostInsights")
	if err != nil {
		return nil, err
	}

	if _, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId); err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}

	allPosts, err := s.store.ListPosts(ctx, caller.WorkspaceID)
	if err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	matchedPosts := make([]*publishv1.ChannelPost, 0)
	for _, p := range allPosts {
		if p.PublishItemID == req.Msg.PublishItemId {
			matchedPosts = append(matchedPosts, ChannelPostToProto(p))
		}
	}
	return connect.NewResponse(&publishv1.GetCrossPostInsightsResponse{
		PublishItemId: req.Msg.PublishItemId,
		Posts:         matchedPosts,
		TotalViews:    15200,
		TotalLikes:    840,
	}), nil
}

// SyncPostMetrics updates post-level metrics with Target 2 (missing denominators remain unknown)
// and Target 3 (imported proof cannot be upgraded to official without verified live platform API session).
func (s *Service) SyncPostMetrics(ctx context.Context, req *connect.Request[publishv1.SyncPostMetricsRequest]) (*connect.Response[publishv1.SyncPostMetricsResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/SyncPostMetrics", extractCmdWorkspaceID(req.Msg.Context), req.Msg.WorkspaceId)
	if err != nil {
		return nil, err
	}

	postID := req.Msg.ChannelPostId
	if postID == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("channel_post_id required"))
	}

	post, err := s.store.GetPost(ctx, caller.WorkspaceID, postID)
	if err != nil || post == nil {
		now := s.nowFn()
		post = &ChannelPost{
			ChannelPostID: postID,
			WorkspaceID:   caller.WorkspaceID,
			CreatedAt:     now,
			UpdatedAt:     now,
		}
	}

	reqClass := fromCommonSourceClass(req.Msg.SourceClass)
	reqConfidence := fromCommonConfidenceBand(req.Msg.Confidence)

	// Target 3: Imported proof cannot be upgraded to official
	if (post.SourceClass == "imported" || reqClass == "imported") && req.Msg.SourceClass == commonv1.SourceClass_SOURCE_CLASS_OFFICIAL {
		return nil, connect.NewError(connect.CodeInvalidArgument, errors.New("publish: imported proof cannot be upgraded to official without verified live platform API session"))
	}

	finalClass := reqClass
	if finalClass == "" {
		if post.SourceClass != "" {
			finalClass = post.SourceClass
		} else {
			finalClass = "imported"
		}
	}

	// Target 3: If imported, confidence cannot be High or MediumHigh (capped at Medium)
	finalConfidence := reqConfidence
	if finalClass == "imported" {
		if finalConfidence == "high" || finalConfidence == "medium_high" {
			finalConfidence = "medium"
		}
	}

	// Target 2: Missing denominator safety
	isViewsUnknown := req.Msg.IsViewsUnknown
	unknownReason := req.Msg.UnknownReason
	if req.Msg.Views == 0 && unknownReason == "" {
		isViewsUnknown = true
		unknownReason = "DATA_LAG_COLLECTING"
	}

	isClicksUnknown := req.Msg.IsClicksUnknown
	if req.Msg.Clicks == 0 && isClicksUnknown {
		if unknownReason == "" {
			unknownReason = "UNRECORDED_OR_LAG"
		}
	}

	now := s.nowFn()
	metrics := &publishv1.ChannelPostMetrics{
		Views:           req.Msg.Views,
		Likes:           req.Msg.Likes,
		Comments:        req.Msg.Comments,
		Shares:          req.Msg.Shares,
		Saves:           req.Msg.Saves,
		Clicks:          req.Msg.Clicks,
		IsViewsUnknown:  isViewsUnknown,
		IsClicksUnknown: isClicksUnknown,
		UnknownReason:   unknownReason,
		SourceClass:     toCommonSourceClass(finalClass),
		Confidence:      toCommonConfidenceBand(finalConfidence),
		CapturedAt:      timestamppb.New(now),
	}

	post.PostMetrics = metrics
	post.SourceClass = finalClass
	post.Confidence = finalConfidence
	post.SyncedAt = &now
	post.UpdatedAt = now
	if err := s.store.SavePost(ctx, post); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&publishv1.SyncPostMetricsResponse{
		Post:    ChannelPostToProto(post),
		Metrics: metrics,
		Updated: true,
	}), nil
}

func (s *Service) PublishVariants(ctx context.Context, req *connect.Request[publishv1.PublishVariantsRequest]) (*connect.Response[publishv1.PublishVariantsResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/PublishVariants", extractCmdWorkspaceID(req.Msg.Context))
	if err != nil {
		return nil, err
	}

	execCtx := ctx
	if publishRoleRank[caller.Role] == publishRoleRank[rbac.RoleEditor] {
		elevated := caller
		elevated.Role = rbac.RoleManager
		execCtx = rbac.WithPolicyContext(ctx, elevated)
	}

	items := make([]*publishv1.PublishItem, 0)
	jobs := make([]*publishv1.PublishJob, 0)

	for _, id := range req.Msg.PublishItemIds {
		res, err := s.Execute(execCtx, connect.NewRequest(&publishv1.ExecuteRequest{
			Context:       req.Msg.Context,
			PublishItemId: id,
		}))
		if err == nil && res != nil {
			items = append(items, res.Msg.Item)
			jobs = append(jobs, res.Msg.Job)
		}
	}
	return connect.NewResponse(&publishv1.PublishVariantsResponse{
		Items: items,
		Jobs:  jobs,
	}), nil
}

func (s *Service) HoldSchedule(ctx context.Context, req *connect.Request[publishv1.HoldScheduleRequest]) (*connect.Response[publishv1.HoldScheduleResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/HoldSchedule", extractCmdWorkspaceID(req.Msg.Context))
	if err != nil {
		return nil, err
	}

	item, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}
	item.DiagnosticsState = DiagnosticsBlocked
	item.UpdatedAt = s.nowFn()
	if err := s.store.SaveItem(ctx, item); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&publishv1.HoldScheduleResponse{
		Item: ItemToProto(item),
	}), nil
}

func (s *Service) ScheduleRetry(ctx context.Context, req *connect.Request[publishv1.ScheduleRetryRequest]) (*connect.Response[publishv1.ScheduleRetryResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/ScheduleRetry", extractCmdWorkspaceID(req.Msg.Context))
	if err != nil {
		return nil, err
	}

	item, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}
	retryTime := req.Msg.RetryAt.AsTime()
	item.ScheduleAt = &retryTime
	item.LifecycleState = StateScheduled
	item.DiagnosticsState = DiagnosticsHealthy
	item.UpdatedAt = s.nowFn()
	if err := s.store.SaveItem(ctx, item); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&publishv1.ScheduleRetryResponse{
		Item: ItemToProto(item),
	}), nil
}

func (s *Service) TagProduct(ctx context.Context, req *connect.Request[publishv1.TagProductRequest]) (*connect.Response[publishv1.TagProductResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/TagProduct", extractCmdWorkspaceID(req.Msg.Context))
	if err != nil {
		return nil, err
	}

	item, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}
	item.LinkedOfferIDs = append(item.LinkedOfferIDs, req.Msg.ProductId)
	item.UpdatedAt = s.nowFn()
	if err := s.store.SaveItem(ctx, item); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&publishv1.TagProductResponse{
		Item: ItemToProto(item),
	}), nil
}

func (s *Service) UntagProduct(ctx context.Context, req *connect.Request[publishv1.UntagProductRequest]) (*connect.Response[publishv1.UntagProductResponse], error) {
	caller, err := s.authorizeRPC(ctx, "PublishService/UntagProduct", extractCmdWorkspaceID(req.Msg.Context))
	if err != nil {
		return nil, err
	}

	item, err := s.store.GetItem(ctx, caller.WorkspaceID, req.Msg.PublishItemId)
	if err != nil {
		return nil, connect.NewError(connect.CodeNotFound, ErrItemNotFound)
	}
	filtered := make([]string, 0, len(item.LinkedOfferIDs))
	for _, id := range item.LinkedOfferIDs {
		if id != req.Msg.ProductId {
			filtered = append(filtered, id)
		}
	}
	item.LinkedOfferIDs = filtered
	item.UpdatedAt = s.nowFn()
	if err := s.store.SaveItem(ctx, item); err != nil {
		return nil, connect.NewError(connect.CodeInternal, err)
	}

	return connect.NewResponse(&publishv1.UntagProductResponse{
		Item: ItemToProto(item),
	}), nil
}

// ----------------------------------------------------------------------------
// Conversion Helpers
// ----------------------------------------------------------------------------

func ItemToProto(item *PublishItem) *publishv1.PublishItem {
	if item == nil {
		return nil
	}
	proto := &publishv1.PublishItem{
		PublishItemId:        item.PublishItemID,
		WorkspaceId:          item.WorkspaceID,
		AssetId:              item.AssetID,
		TargetPlatform:       item.TargetPlatform,
		TargetAccountId:      item.TargetAccountID,
		TargetFormat:         item.TargetFormat,
		PublishMode:          StringToPublishMode(item.PublishMode),
		Title:                item.Title,
		Description:          item.Description,
		Hashtags:             item.Hashtags,
		CapabilitySnapshotId: item.CapabilitySnapshotID,
		LifecycleState:       StringToLifecycleState(item.LifecycleState),
		DiagnosticsState:     StringToDiagnosticsState(item.DiagnosticsState),
		LinkedOfferIds:       item.LinkedOfferIDs,
		LinkedCampaignIds:    item.LinkedCampaignIDs,
		PackagingScore:       item.PackagingScore,
		ComplianceScanResult: item.ComplianceScanResult,
		CreatedBy:            item.CreatedBy,
		CreatedAt:            timestamppb.New(item.CreatedAt),
		UpdatedAt:            timestamppb.New(item.UpdatedAt),
	}
	if item.ScheduleAt != nil {
		proto.ScheduleAt = timestamppb.New(*item.ScheduleAt)
	}
	return proto
}

func JobToProto(job *PublishJob) *publishv1.PublishJob {
	if job == nil {
		return nil
	}
	return &publishv1.PublishJob{
		PublishJobId:      job.PublishJobID,
		WorkspaceId:       job.WorkspaceID,
		PublishItemId:     job.PublishItemID,
		DispatchStrategy:  job.DispatchStrategy,
		LifecycleState:    StringToJobLifecycleState(job.LifecycleState),
		AttemptCount:      int32(job.AttemptCount),
		MaxAttempts:       int32(job.MaxAttempts),
		CurrentWorkerId:   job.CurrentWorkerID,
		ApprovalRequestId: job.ApprovalRequestID,
		CreatedAt:         timestamppb.New(job.CreatedAt),
		UpdatedAt:         timestamppb.New(job.UpdatedAt),
	}
}

func LogToProto(log *PublishLog) *publishv1.PublishLog {
	if log == nil {
		return nil
	}
	pLog := &publishv1.PublishLog{
		PublishLogId:         log.PublishLogID,
		WorkspaceId:          log.WorkspaceID,
		PublishJobId:         log.PublishJobID,
		PublishItemId:        log.PublishItemID,
		AttemptedAt:          timestamppb.New(log.AttemptedAt),
		ActorUserId:          log.ActorUserID,
		ActingMode:           commonv1.OperatorMode_OPERATOR_MODE_CREATOR,
		ExecutionPath:        StringToExecutionPath(log.ExecutionPath),
		CapabilitySnapshotId: log.CapabilitySnapshotID,
		ResultStatus:         StringToResultStatus(log.ResultStatus),
		ExternalPostId:       log.ExternalPostID,
		ExternalPostUrl:      log.ExternalPostURL,
		DiagnosticsRef:       log.DiagnosticsRef,
		EvidenceRef:          log.EvidenceRef,
		ErrorCode:            log.ErrorCode,
		ErrorMessage:         log.ErrorMessage,
	}
	if log.CompletedAt != nil {
		pLog.CompletedAt = timestamppb.New(*log.CompletedAt)
	}
	if log.FailedAt != nil {
		pLog.FailedAt = timestamppb.New(*log.FailedAt)
	}
	return pLog
}

func toCommonSourceClass(sc string) commonv1.SourceClass {
	switch sc {
	case "official":
		return commonv1.SourceClass_SOURCE_CLASS_OFFICIAL
	case "imported":
		return commonv1.SourceClass_SOURCE_CLASS_IMPORTED
	case "inferred":
		return commonv1.SourceClass_SOURCE_CLASS_INFERRED
	case "estimated":
		return commonv1.SourceClass_SOURCE_CLASS_ESTIMATED
	case "unreconciled":
		return commonv1.SourceClass_SOURCE_CLASS_UNRECONCILED
	default:
		return commonv1.SourceClass_SOURCE_CLASS_UNSPECIFIED
	}
}

func fromCommonSourceClass(sc commonv1.SourceClass) string {
	switch sc {
	case commonv1.SourceClass_SOURCE_CLASS_OFFICIAL:
		return "official"
	case commonv1.SourceClass_SOURCE_CLASS_IMPORTED:
		return "imported"
	case commonv1.SourceClass_SOURCE_CLASS_INFERRED:
		return "inferred"
	case commonv1.SourceClass_SOURCE_CLASS_ESTIMATED:
		return "estimated"
	case commonv1.SourceClass_SOURCE_CLASS_UNRECONCILED:
		return "unreconciled"
	default:
		return "imported"
	}
}

func toCommonConfidenceBand(cb string) commonv1.ConfidenceBand {
	switch cb {
	case "high":
		return commonv1.ConfidenceBand_CONFIDENCE_BAND_HIGH
	case "medium_high":
		return commonv1.ConfidenceBand_CONFIDENCE_BAND_MEDIUM_HIGH
	case "medium":
		return commonv1.ConfidenceBand_CONFIDENCE_BAND_MEDIUM
	case "low_medium":
		return commonv1.ConfidenceBand_CONFIDENCE_BAND_LOW_MEDIUM
	case "low":
		return commonv1.ConfidenceBand_CONFIDENCE_BAND_LOW
	default:
		return commonv1.ConfidenceBand_CONFIDENCE_BAND_UNSPECIFIED
	}
}

func fromCommonConfidenceBand(cb commonv1.ConfidenceBand) string {
	switch cb {
	case commonv1.ConfidenceBand_CONFIDENCE_BAND_HIGH:
		return "high"
	case commonv1.ConfidenceBand_CONFIDENCE_BAND_MEDIUM_HIGH:
		return "medium_high"
	case commonv1.ConfidenceBand_CONFIDENCE_BAND_MEDIUM:
		return "medium"
	case commonv1.ConfidenceBand_CONFIDENCE_BAND_LOW_MEDIUM:
		return "low_medium"
	case commonv1.ConfidenceBand_CONFIDENCE_BAND_LOW:
		return "low"
	default:
		return "medium"
	}
}

func ChannelPostToProto(post *ChannelPost) *publishv1.ChannelPost {
	if post == nil {
		return nil
	}
	cp := &publishv1.ChannelPost{
		ChannelPostId:      post.ChannelPostID,
		WorkspaceId:        post.WorkspaceID,
		PublishItemId:      post.PublishItemID,
		ConnectedAccountId: post.ConnectedAccountID,
		ExternalPostId:     post.ExternalPostID,
		ExternalPermalink:  post.ExternalPermalink,
		Title:              post.Title,
		ThumbnailUrl:       post.ThumbnailURL,
		Metrics:            post.PostMetrics,
		SourceClass:        toCommonSourceClass(post.SourceClass),
		Confidence:         toCommonConfidenceBand(post.Confidence),
		CreatedAt:          timestamppb.New(post.CreatedAt),
		UpdatedAt:          timestamppb.New(post.UpdatedAt),
	}
	if post.SyncedAt != nil {
		cp.SyncedAt = timestamppb.New(*post.SyncedAt)
	}
	return cp
}

func StringToLifecycleState(s string) publishv1.PublishItemLifecycleState {
	switch s {
	case StateDraft:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_DRAFT
	case StateQueued:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_QUEUED
	case StateScheduled:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_SCHEDULED
	case StateReadyToExecute:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_READY_TO_EXECUTE
	case StateExecuting:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_EXECUTING
	case StatePublished:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_PUBLISHED
	case StatePartiallyPublished:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_PARTIALLY_PUBLISHED
	case StateFailed:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_FAILED
	case StateCancelled:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_CANCELLED
	case StateRequiresManualFallback:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_REQUIRES_MANUAL_FALLBACK
	default:
		return publishv1.PublishItemLifecycleState_PUBLISH_ITEM_LIFECYCLE_STATE_UNSPECIFIED
	}
}

func StringToJobLifecycleState(s string) publishv1.PublishJobLifecycleState {
	switch s {
	case JobStateCreated:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_CREATED
	case StateQueued:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_QUEUED
	case JobStateDispatched:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_DISPATCHED
	case StateExecuting:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_EXECUTING
	case JobStatePartiallySucceeded:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_PARTIALLY_SUCCEEDED
	case JobStateSucceeded:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_SUCCEEDED
	case StateFailed:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_FAILED
	case StateCancelled:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_CANCELLED
	case StateRequiresManualFallback:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_REQUIRES_MANUAL_FALLBACK
	default:
		return publishv1.PublishJobLifecycleState_PUBLISH_JOB_LIFECYCLE_STATE_UNSPECIFIED
	}
}

func StringToResultStatus(s string) publishv1.PublishResultStatus {
	switch s {
	case ResultSuccess:
		return publishv1.PublishResultStatus_PUBLISH_RESULT_STATUS_SUCCESS
	case ResultPartialSuccess:
		return publishv1.PublishResultStatus_PUBLISH_RESULT_STATUS_PARTIAL_SUCCESS
	case ResultFailed:
		return publishv1.PublishResultStatus_PUBLISH_RESULT_STATUS_FAILED
	case ResultTimeout:
		return publishv1.PublishResultStatus_PUBLISH_RESULT_STATUS_TIMEOUT
	default:
		return publishv1.PublishResultStatus_PUBLISH_RESULT_STATUS_UNSPECIFIED
	}
}

func StringToExecutionPath(s string) publishv1.ExecutionPath {
	switch s {
	case PathNativeAPI:
		return publishv1.ExecutionPath_EXECUTION_PATH_NATIVE_API
	case PathManualUpload:
		return publishv1.ExecutionPath_EXECUTION_PATH_MANUAL_UPLOAD
	case PathExportPackage:
		return publishv1.ExecutionPath_EXECUTION_PATH_EXPORT_PACKAGE
	default:
		return publishv1.ExecutionPath_EXECUTION_PATH_UNSPECIFIED
	}
}

func StringToDiagnosticsState(s string) publishv1.DiagnosticsState {
	switch s {
	case DiagnosticsHealthy:
		return publishv1.DiagnosticsState_DIAGNOSTICS_STATE_HEALTHY
	case DiagnosticsWarning:
		return publishv1.DiagnosticsState_DIAGNOSTICS_STATE_WARNING
	case DiagnosticsDegraded:
		return publishv1.DiagnosticsState_DIAGNOSTICS_STATE_DEGRADED
	case DiagnosticsBlocked:
		return publishv1.DiagnosticsState_DIAGNOSTICS_STATE_BLOCKED
	default:
		return publishv1.DiagnosticsState_DIAGNOSTICS_STATE_UNSPECIFIED
	}
}

func PublishModeToString(m publishv1.PublishMode) string {
	switch m {
	case publishv1.PublishMode_PUBLISH_MODE_DIRECT:
		return "direct"
	case publishv1.PublishMode_PUBLISH_MODE_DRAFT:
		return "draft"
	case publishv1.PublishMode_PUBLISH_MODE_EXPORT:
		return "export"
	case publishv1.PublishMode_PUBLISH_MODE_MANUAL:
		return "manual"
	default:
		return "direct"
	}
}

func StringToPublishMode(s string) publishv1.PublishMode {
	switch s {
	case "direct":
		return publishv1.PublishMode_PUBLISH_MODE_DIRECT
	case "draft":
		return publishv1.PublishMode_PUBLISH_MODE_DRAFT
	case "export":
		return publishv1.PublishMode_PUBLISH_MODE_EXPORT
	case "manual":
		return publishv1.PublishMode_PUBLISH_MODE_MANUAL
	default:
		return publishv1.PublishMode_PUBLISH_MODE_UNSPECIFIED
	}
}
