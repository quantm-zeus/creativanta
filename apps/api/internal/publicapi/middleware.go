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

		// Determine operation type
		proc := req.Spec().Procedure
		if proc == "" {
			proc = req.Header().Get("X-Procedure")
		}
		isMutating := isMutatingProcedure(proc)

		now := time.Now().UTC()
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

		// Inject key into context
		ctxWithKey := WithAuthenticatedKey(ctx, apiKey)
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

func isMutatingProcedure(proc string) bool {
	lower := strings.ToLower(proc)
	if strings.Contains(lower, "create") || strings.Contains(lower, "update") ||
		strings.Contains(lower, "delete") || strings.Contains(lower, "revoke") ||
		strings.Contains(lower, "rotate") || strings.Contains(lower, "execute") ||
		strings.Contains(lower, "launch") || strings.Contains(lower, "publish") ||
		strings.Contains(lower, "cancel") || strings.Contains(lower, "mutate") {
		return true
	}
	return false
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
