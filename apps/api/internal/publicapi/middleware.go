package publicapi

import (
	"context"
	"fmt"
	"net/http"
	"strconv"
	"strings"
	"sync"
	"time"

	"connectrpc.com/connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
)

type contextKey string

const (
	apiKeyContextKey contextKey = "publicapi.authenticated_api_key"
)

// AuthenticatedKeyFromContext retrieves the authenticated APIKeyEntity from context if present.
func AuthenticatedKeyFromContext(ctx context.Context) (APIKeyEntity, bool) {
	key, ok := ctx.Value(apiKeyContextKey).(APIKeyEntity)
	return key, ok
}

// WithAuthenticatedKey injects an APIKeyEntity into the context.
func WithAuthenticatedKey(ctx context.Context, key APIKeyEntity) context.Context {
	return context.WithValue(ctx, apiKeyContextKey, key)
}

// SlidingWindowRateLimiter implements per-key sliding window rate limits per RULE-S24-002 & EC-S24-002.
// Read limit: 100 req/min, Write limit: 30 req/min. Burst allowance: 2x in 10-second windows.
type SlidingWindowRateLimiter struct {
	mu      sync.Mutex
	history map[string][]time.Time // key_id:action -> timestamps
}

func NewSlidingWindowRateLimiter() *SlidingWindowRateLimiter {
	return &SlidingWindowRateLimiter{
		history: make(map[string][]time.Time),
	}
}

// CheckRateLimit checks and records a request. Returns allowed, limit, remaining, resetSeconds.
func (rl *SlidingWindowRateLimiter) CheckRateLimit(keyID string, isWrite bool, limitOverride int, now time.Time) (allowed bool, limit int, remaining int, resetSeconds int) {
	rl.mu.Lock()
	defer rl.mu.Unlock()

	limit = DefaultReadRateLimitRPM
	if isWrite {
		limit = DefaultWriteRateLimitRPM
	}
	if limitOverride > 0 {
		limit = limitOverride
	}

	actionKey := keyID + ":read"
	if isWrite {
		actionKey = keyID + ":write"
	}

	windowStart := now.Add(-1 * time.Minute)
	timestamps := rl.history[actionKey]

	// Prune timestamps older than 1 minute
	var active []time.Time
	for _, t := range timestamps {
		if t.After(windowStart) {
			active = append(active, t)
		}
	}

	currentCount := len(active)
	if currentCount >= limit {
		// Rate limit exceeded!
		oldest := active[0]
		resetTime := oldest.Add(1 * time.Minute)
		resetSec := int(resetTime.Sub(now).Seconds())
		if resetSec <= 0 {
			resetSec = 1
		}
		rl.history[actionKey] = active
		return false, limit, 0, resetSec
	}

	// Allowed
	active = append(active, now)
	rl.history[actionKey] = active
	remaining = limit - len(active)
	if remaining < 0 {
		remaining = 0
	}
	return true, limit, remaining, 60
}

// RateLimitHeaders writes standard X-RateLimit headers.
func RateLimitHeaders(header http.Header, limit, remaining, resetSeconds int) {
	header.Set("X-RateLimit-Limit", strconv.Itoa(limit))
	header.Set("X-RateLimit-Remaining", strconv.Itoa(remaining))
	header.Set("X-RateLimit-Reset", strconv.Itoa(resetSeconds))
}

// APIKeyInterceptor provides ConnectRPC unary interception for Public API requests.
type APIKeyInterceptor struct {
	service     *Service
	rateLimiter *SlidingWindowRateLimiter
}

func NewAPIKeyInterceptor(service *Service) *APIKeyInterceptor {
	return &APIKeyInterceptor{
		service:     service,
		rateLimiter: NewSlidingWindowRateLimiter(),
	}
}

func (in *APIKeyInterceptor) WrapUnary(next connect.UnaryFunc) connect.UnaryFunc {
	return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
		authHeader := req.Header().Get("Authorization")
		if !strings.HasPrefix(strings.ToLower(authHeader), "bearer ") {
			// If not an API key request, proceed to inner handlers (e.g. session-based auth).
			return next(ctx, req)
		}

		rawToken := strings.TrimSpace(authHeader[7:])
		apiKey, err := in.service.AuthenticateKey(ctx, rawToken)
		if err != nil {
			if strings.Contains(err.Error(), "expired") {
				return nil, connect.NewError(connect.CodeUnauthenticated, fmt.Errorf("key_expired: %s", err.Error()))
			}
			return nil, connect.NewError(connect.CodeUnauthenticated, err)
		}

		// Determine canonical operation scope & mutating classification (fail-closed if unmapped)
		proc := req.Spec().Procedure
		if proc == "" {
			proc = req.Header().Get("X-Procedure")
		}
		spec, mapped := LookupPublicAPIProcedureSpec(proc)
		now := time.Now().UTC()
		if !mapped {
			_ = in.service.store.RecordUsage(ctx, apiKey.WorkspaceID, apiKey.LogicalKeyID, false, http.StatusForbidden, 0, now)
			return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("%w: procedure %q is not exposed to Public API keys", ErrScopeUnauthorized, proc))
		}
		isMutating := spec.IsMutating

		// Reject mismatched workspace header against the API key's tenant scope (AUTH-03)
		if wsHeader := strings.TrimSpace(req.Header().Get("X-Workspace-ID")); wsHeader != "" && wsHeader != apiKey.WorkspaceID {
			_ = in.service.store.RecordUsage(ctx, apiKey.WorkspaceID, apiKey.LogicalKeyID, isMutating, http.StatusForbidden, 0, now)
			return nil, connect.NewError(connect.CodePermissionDenied, tenantdb.ErrScopeMismatch)
		}

		// Target 1: Read-only key cannot mutate!
		if isMutating {
			tier, _ := in.service.tierProvider.GetWorkspaceTier(ctx, apiKey.WorkspaceID)
			if strings.ToLower(tier) == "starter" {
				_ = in.service.store.RecordUsage(ctx, apiKey.WorkspaceID, apiKey.LogicalKeyID, isMutating, http.StatusForbidden, 0, now)
				return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("%w: starter tier workspaces cannot perform mutating API operations", ErrReadOnlyMutationForbidden))
			}
			if IsReadOnlyScopes(apiKey.Scopes) {
				_ = in.service.store.RecordUsage(ctx, apiKey.WorkspaceID, apiKey.LogicalKeyID, isMutating, http.StatusForbidden, 0, now)
				return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("%w: key has read-only scopes", ErrReadOnlyMutationForbidden))
			}
		}

		// Enforce exact operation-scope requirement (AUTH-02)
		if !HasScope(apiKey.Scopes, spec.RequiredScope) {
			_ = in.service.store.RecordUsage(ctx, apiKey.WorkspaceID, apiKey.LogicalKeyID, isMutating, http.StatusForbidden, 0, now)
			return nil, connect.NewError(connect.CodePermissionDenied, fmt.Errorf("%w: procedure %s requires scope %s", ErrScopeUnauthorized, spec.CanonicalProcedure, spec.RequiredScope))
		}

		// Rate Limiting (Sliding Window)
		allowed, limit, remaining, resetSec := in.rateLimiter.CheckRateLimit(apiKey.LogicalKeyID, isMutating, apiKey.RateLimitOverride, now)
		if !allowed {
			_ = in.service.store.RecordUsage(ctx, apiKey.WorkspaceID, apiKey.LogicalKeyID, isMutating, http.StatusTooManyRequests, 0, now)
			err := connect.NewError(connect.CodeResourceExhausted, ErrRateLimitExceeded)
			err.Meta().Set("Retry-After", strconv.Itoa(resetSec))
			err.Meta().Set("X-RateLimit-Limit", strconv.Itoa(limit))
			err.Meta().Set("X-RateLimit-Remaining", "0")
			err.Meta().Set("X-RateLimit-Reset", strconv.Itoa(resetSec))
			return nil, err
		}

		// Inject both APIKeyEntity and tenant-bound transportauth.Session principal into context (AUTH-03)
		ctxWithKey := WithAuthenticatedKey(ctx, apiKey)
		ctxWithKey = transportauth.WithPrincipal(ctxWithKey, transportauth.Session{
			UserID:       apiKey.APIKeyID,
			WorkspaceID:  apiKey.WorkspaceID,
			ScopesCSV:    transportauth.JoinScopes(apiKey.Scopes),
			ServiceKeyID: apiKey.APIKeyID,
		})
		res, execErr := next(ctxWithKey, req)

		statusCode := http.StatusOK
		if execErr != nil {
			var connErr *connect.Error
			if errorsAs(execErr, &connErr) {
				statusCode = connectCodeToHTTPStatus(connErr.Code())
			} else {
				statusCode = http.StatusInternalServerError
			}
		}

		// Meter usage into daily usage table
		// Per EC-S24-003: 5xx errors do NOT deduct billable AI credits
		_ = in.service.store.RecordUsage(ctx, apiKey.WorkspaceID, apiKey.LogicalKeyID, isMutating, statusCode, 0, now)

		if res != nil {
			RateLimitHeaders(res.Header(), limit, remaining, resetSec)
		}
		return res, execErr
	}
}

// ProcedureScopeSpec defines the exact required scope and mutation classification for a Public API RPC.
type ProcedureScopeSpec struct {
	CanonicalProcedure string
	RequiredScope      string
	IsMutating         bool
}

var publicAPIProcedureSpecs = map[string]ProcedureScopeSpec{
	// OrderService
	"OrderService/GetOrder":      {CanonicalProcedure: "OrderService/GetOrder", RequiredScope: "read:orders", IsMutating: false},
	"OrderService/ListOrders":    {CanonicalProcedure: "OrderService/ListOrders", RequiredScope: "read:orders", IsMutating: false},
	"OrderService/GetSummary":    {CanonicalProcedure: "OrderService/GetSummary", RequiredScope: "read:orders", IsMutating: false},
	"OrderService/CreateOrder":   {CanonicalProcedure: "OrderService/CreateOrder", RequiredScope: "write:orders", IsMutating: true},
	"OrderService/Confirm":       {CanonicalProcedure: "OrderService/Confirm", RequiredScope: "write:orders", IsMutating: true},
	"OrderService/Fulfill":       {CanonicalProcedure: "OrderService/Fulfill", RequiredScope: "write:orders", IsMutating: true},
	"OrderService/Complete":      {CanonicalProcedure: "OrderService/Complete", RequiredScope: "write:orders", IsMutating: true},
	"OrderService/Cancel":        {CanonicalProcedure: "OrderService/Cancel", RequiredScope: "write:orders", IsMutating: true},
	"OrderService/Return":        {CanonicalProcedure: "OrderService/Return", RequiredScope: "write:orders", IsMutating: true},
	"OrderService/RequestRefund": {CanonicalProcedure: "OrderService/RequestRefund", RequiredScope: "write:orders", IsMutating: true},
	"OrderService/ApproveRefund": {CanonicalProcedure: "OrderService/ApproveRefund", RequiredScope: "write:orders", IsMutating: true},
	"OrderService/RejectRefund":  {CanonicalProcedure: "OrderService/RejectRefund", RequiredScope: "write:orders", IsMutating: true},

	// ProductService
	"ProductService/Get":            {CanonicalProcedure: "ProductService/Get", RequiredScope: "read:products", IsMutating: false},
	"ProductService/List":           {CanonicalProcedure: "ProductService/List", RequiredScope: "read:products", IsMutating: false},
	"ProductService/GetCostHistory": {CanonicalProcedure: "ProductService/GetCostHistory", RequiredScope: "read:products", IsMutating: false},
	"ProductService/Create":         {CanonicalProcedure: "ProductService/Create", RequiredScope: "write:products", IsMutating: true},
	"ProductService/Update":         {CanonicalProcedure: "ProductService/Update", RequiredScope: "write:products", IsMutating: true},
	"ProductService/Archive":        {CanonicalProcedure: "ProductService/Archive", RequiredScope: "write:products", IsMutating: true},
	"ProductService/CreateSKU":      {CanonicalProcedure: "ProductService/CreateSKU", RequiredScope: "write:products", IsMutating: true},
	"ProductService/UpdateSKU":      {CanonicalProcedure: "ProductService/UpdateSKU", RequiredScope: "write:products", IsMutating: true},

	// InventoryService
	"InventoryService/GetStock":           {CanonicalProcedure: "InventoryService/GetStock", RequiredScope: "read:inventory", IsMutating: false},
	"InventoryService/ListMovements":      {CanonicalProcedure: "InventoryService/ListMovements", RequiredScope: "read:inventory", IsMutating: false},
	"InventoryService/ListAlerts":         {CanonicalProcedure: "InventoryService/ListAlerts", RequiredScope: "read:inventory", IsMutating: false},
	"InventoryService/AdjustStock":        {CanonicalProcedure: "InventoryService/AdjustStock", RequiredScope: "write:inventory", IsMutating: true},
	"InventoryService/ReserveStock":       {CanonicalProcedure: "InventoryService/ReserveStock", RequiredScope: "write:inventory", IsMutating: true},
	"InventoryService/ConfirmReservation": {CanonicalProcedure: "InventoryService/ConfirmReservation", RequiredScope: "write:inventory", IsMutating: true},
	"InventoryService/ReleaseReservation": {CanonicalProcedure: "InventoryService/ReleaseReservation", RequiredScope: "write:inventory", IsMutating: true},

	// ScriptService / Content
	"ScriptService/GetScript":    {CanonicalProcedure: "ScriptService/GetScript", RequiredScope: "read:content", IsMutating: false},
	"ScriptService/ListScripts":  {CanonicalProcedure: "ScriptService/ListScripts", RequiredScope: "read:content", IsMutating: false},
	"ScriptService/CreateScript": {CanonicalProcedure: "ScriptService/CreateScript", RequiredScope: "write:content", IsMutating: true},
	"ScriptService/UpdateScript": {CanonicalProcedure: "ScriptService/UpdateScript", RequiredScope: "write:content", IsMutating: true},
	"ScriptService/DeleteScript": {CanonicalProcedure: "ScriptService/DeleteScript", RequiredScope: "write:content", IsMutating: true},

	// PublishService
	"PublishService/GetItem":    {CanonicalProcedure: "PublishService/GetItem", RequiredScope: "read:publish", IsMutating: false},
	"PublishService/ListItems":  {CanonicalProcedure: "PublishService/ListItems", RequiredScope: "read:publish", IsMutating: false},
	"PublishService/Schedule":   {CanonicalProcedure: "PublishService/Schedule", RequiredScope: "write:publish", IsMutating: true},
	"PublishService/PublishNow": {CanonicalProcedure: "PublishService/PublishNow", RequiredScope: "write:publish", IsMutating: true},
	"PublishService/Cancel":     {CanonicalProcedure: "PublishService/Cancel", RequiredScope: "write:publish", IsMutating: true},

	// AnalyticsService
	"AnalyticsService/GetOverview": {CanonicalProcedure: "AnalyticsService/GetOverview", RequiredScope: "read:analytics", IsMutating: false},
	"AnalyticsService/GetMetrics":  {CanonicalProcedure: "AnalyticsService/GetMetrics", RequiredScope: "read:analytics", IsMutating: false},

	// WorkflowService
	"WorkflowService/Get":        {CanonicalProcedure: "WorkflowService/Get", RequiredScope: "read:workflows", IsMutating: false},
	"WorkflowService/List":       {CanonicalProcedure: "WorkflowService/List", RequiredScope: "read:workflows", IsMutating: false},
	"WorkflowService/GetRun":     {CanonicalProcedure: "WorkflowService/GetRun", RequiredScope: "read:workflows", IsMutating: false},
	"WorkflowService/ListRuns":   {CanonicalProcedure: "WorkflowService/ListRuns", RequiredScope: "read:workflows", IsMutating: false},
	"WorkflowService/Validate":   {CanonicalProcedure: "WorkflowService/Validate", RequiredScope: "read:workflows", IsMutating: false},
	"WorkflowService/Create":     {CanonicalProcedure: "WorkflowService/Create", RequiredScope: "write:workflows", IsMutating: true},
	"WorkflowService/Update":     {CanonicalProcedure: "WorkflowService/Update", RequiredScope: "write:workflows", IsMutating: true},
	"WorkflowService/Activate":   {CanonicalProcedure: "WorkflowService/Activate", RequiredScope: "write:workflows", IsMutating: true},
	"WorkflowService/Pause":      {CanonicalProcedure: "WorkflowService/Pause", RequiredScope: "write:workflows", IsMutating: true},
	"WorkflowService/TriggerRun": {CanonicalProcedure: "WorkflowService/TriggerRun", RequiredScope: "write:workflows", IsMutating: true},
	"WorkflowService/CancelRun":  {CanonicalProcedure: "WorkflowService/CancelRun", RequiredScope: "write:workflows", IsMutating: true},

	// AgentService
	"AgentService/GetAgent":      {CanonicalProcedure: "AgentService/GetAgent", RequiredScope: "read:agents", IsMutating: false},
	"AgentService/ListAgents":    {CanonicalProcedure: "AgentService/ListAgents", RequiredScope: "read:agents", IsMutating: false},
	"AgentService/GetRun":        {CanonicalProcedure: "AgentService/GetRun", RequiredScope: "read:agents", IsMutating: false},
	"AgentService/ListRuns":      {CanonicalProcedure: "AgentService/ListRuns", RequiredScope: "read:agents", IsMutating: false},
	"AgentService/ListMemory":    {CanonicalProcedure: "AgentService/ListMemory", RequiredScope: "read:agents", IsMutating: false},
	"AgentService/CreateAgent":   {CanonicalProcedure: "AgentService/CreateAgent", RequiredScope: "write:agents", IsMutating: true},
	"AgentService/LaunchRun":     {CanonicalProcedure: "AgentService/LaunchRun", RequiredScope: "write:agents", IsMutating: true},
	"AgentService/ResumeHandoff": {CanonicalProcedure: "AgentService/ResumeHandoff", RequiredScope: "write:agents", IsMutating: true},
	"AgentService/CancelRun":     {CanonicalProcedure: "AgentService/CancelRun", RequiredScope: "write:agents", IsMutating: true},
	"AgentService/DeleteMemory":  {CanonicalProcedure: "AgentService/DeleteMemory", RequiredScope: "write:agents", IsMutating: true},
	"AgentService/ClearMemory":   {CanonicalProcedure: "AgentService/ClearMemory", RequiredScope: "write:agents", IsMutating: true},
}

// NormalizeProcedureName strips package prefixes from a ConnectRPC procedure path
// (e.g., "/creativanta.commerce.v1.OrderService/GetOrder" -> "OrderService/GetOrder").
func NormalizeProcedureName(proc string) string {
	trimmed := strings.TrimSpace(strings.TrimPrefix(strings.TrimSpace(proc), "/"))
	if trimmed == "" {
		return ""
	}
	slashIdx := strings.IndexByte(trimmed, '/')
	if slashIdx <= 0 || slashIdx == len(trimmed)-1 {
		return ""
	}
	servicePart := trimmed[:slashIdx]
	methodPart := trimmed[slashIdx+1:]
	if strings.Contains(methodPart, "/") {
		return ""
	}
	if dotIdx := strings.LastIndexByte(servicePart, '.'); dotIdx >= 0 {
		servicePart = servicePart[dotIdx+1:]
	}
	if servicePart == "" || methodPart == "" {
		return ""
	}
	return servicePart + "/" + methodPart
}

// LookupPublicAPIProcedureSpec resolves a ConnectRPC procedure against the canonical Public API scope map.
func LookupPublicAPIProcedureSpec(proc string) (ProcedureScopeSpec, bool) {
	norm := NormalizeProcedureName(proc)
	if norm == "" {
		return ProcedureScopeSpec{}, false
	}
	spec, ok := publicAPIProcedureSpecs[norm]
	return spec, ok
}

func connectCodeToHTTPStatus(c connect.Code) int {
	switch c {
	case connect.CodeNotFound:
		return http.StatusNotFound
	case connect.CodePermissionDenied:
		return http.StatusForbidden
	case connect.CodeUnauthenticated:
		return http.StatusUnauthorized
	case connect.CodeResourceExhausted:
		return http.StatusTooManyRequests
	case connect.CodeInvalidArgument:
		return http.StatusBadRequest
	case connect.CodeAlreadyExists:
		return http.StatusConflict
	default:
		return http.StatusInternalServerError
	}
}

func errorsAs(err error, target any) bool {
	var connErr *connect.Error
	if ok := connectAs(err, &connErr); ok {
		if ptr, ok := target.(**connect.Error); ok {
			*ptr = connErr
			return true
		}
	}
	return false
}

func connectAs(err error, target **connect.Error) bool {
	if c, ok := err.(*connect.Error); ok {
		*target = c
		return true
	}
	return false
}
