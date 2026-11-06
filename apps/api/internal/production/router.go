package production

import (
	"context"
	"errors"
	"fmt"
	"io"
	"net"
	"strings"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// PipelineRouter coordinates smart strategy selection, provider failover, and credit recovery.
type PipelineRouter struct {
	mu               sync.RWMutex
	primaryProvider  VideoProvider
	fallbackProvider VideoProvider
	primaryCB        *CircuitBreaker
	fallbackCB       *CircuitBreaker
	budgetCalc       *BudgetCalculator
}

// NewPipelineRouter creates a pipeline router with primary and secondary fallback providers.
func NewPipelineRouter(primary, fallback VideoProvider) *PipelineRouter {
	return &PipelineRouter{
		primaryProvider:  primary,
		fallbackProvider: fallback,
		primaryCB:        NewCircuitBreaker(3, 300), // trip after 3 consecutive failures for 5 minutes
		fallbackCB:       NewCircuitBreaker(3, 300),
		budgetCalc:       NewBudgetCalculator(),
	}
}

// HasConfiguredProvider reports whether at least one real or test provider is configured.
func (r *PipelineRouter) HasConfiguredProvider() bool {
	if r == nil {
		return false
	}
	r.mu.RLock()
	defer r.mu.RUnlock()
	if r.primaryProvider != nil {
		if cve, ok := r.primaryProvider.(*VideoEngineProvider); ok {
			if cve.IsConfigured() {
				return true
			}
		} else {
			return true
		}
	}
	if r.fallbackProvider != nil {
		if cve, ok := r.fallbackProvider.(*VideoEngineProvider); ok {
			if cve.IsConfigured() {
				return true
			}
		} else {
			return true
		}
	}
	return false
}

// SelectStrategy auto-selects pipeline strategy based on parameters per ai_video_studio.md.
func (r *PipelineRouter) SelectStrategy(hasVoiceClone, isMultiLanguage, isBRollOnly bool) string {
	if hasVoiceClone {
		return "audio_first" // Strategy 2: ElevenLabs TTS -> HeyGen/Kling
	}
	if isMultiLanguage {
		return "post_prod_lip_sync" // Strategy 3: Video gen || TTS -> Lip-sync
	}
	if isBRollOnly {
		return "simple_voice_over" // Strategy 4: B-roll / Showcase
	}
	return "native_audio" // Strategy 1: Default native audio
}

// ExecutionResult encapsulates the outcome of a routed generation attempt.
type ExecutionResult struct {
	ProviderJobID    string
	ActualProvider   string
	ActualModel      string
	Status           string // "queued", "processing", "completed", "unknown"
	OutcomeUnknown   bool
	ResultURL        string
	DurationSecs     tenantdb.ExactDecimal
	Resolution       string
	CostUSD          tenantdb.ExactDecimal
	CreditsDeducted  tenantdb.ExactDecimal
	UsedFallback     bool
	FallbackAttempts int
	BYOKUsed         bool
	Lineage          LineageRecord
}

func isUnknownSubmissionOutcomeError(err error) bool {
	if err == nil {
		return false
	}
	if errors.Is(err, context.DeadlineExceeded) ||
		errors.Is(err, context.Canceled) ||
		errors.Is(err, ErrExecutionTimeout) ||
		errors.Is(err, ErrOutcomeUnknown) ||
		errors.Is(err, io.EOF) ||
		errors.Is(err, io.ErrUnexpectedEOF) {
		return true
	}
	var netErr net.Error
	if errors.As(err, &netErr) {
		return true
	}
	lower := strings.ToLower(err.Error())
	return strings.Contains(lower, "eof") ||
		strings.Contains(lower, "connection reset") ||
		strings.Contains(lower, "broken pipe") ||
		strings.Contains(lower, "invalid render-job response")
}

// ExecuteRoutedJob satisfies Acceptance Target 2:
// "Fallback no double charge"
// Executes primary provider first; on definitive failure, auto-falls back to secondary provider
// within the confirmed quote and consent ceiling, preserving attempt history and recording actual lineage,
// with zero double debit.
// When submission or status check times out or has an unknown outcome, it MUST NOT fail over to
// a second provider (preventing double external submission) and returns OutcomeUnknown=true.
func (r *PipelineRouter) ExecuteRoutedJob(ctx context.Context, req ProviderGenRequest, confirmedQuoteCredits tenantdb.ExactDecimal) (*ExecutionResult, error) {
	if !r.HasConfiguredProvider() {
		return nil, ErrProviderNotConfigured
	}
	now := time.Now().UTC()
	var (
		activeProvider   VideoProvider
		usedFallback     = false
		fallbackAttempts = 0
	)

	// 1. Try primary provider if configured and circuit breaker allows
	if r.primaryProvider != nil && r.primaryCB.AllowExecution(now) {
		activeProvider = r.primaryProvider
	} else if r.fallbackProvider != nil && r.fallbackCB.AllowExecution(now) {
		// Primary is nil or circuit breaker is OPEN -> route to fallback
		activeProvider = r.fallbackProvider
		usedFallback = r.primaryProvider != nil
		if usedFallback {
			fallbackAttempts = 1
		}
	} else {
		return nil, ErrCircuitBreakerOpen
	}

	resp, err := activeProvider.Generate(ctx, req)
	if err != nil {
		if errors.Is(err, ErrProviderNotConfigured) {
			return nil, ErrProviderNotConfigured
		}
		// AI-06: If primary submission timed out or returned unknown outcome, DO NOT trigger
		// fallback provider (which would submit a second external job) and DO NOT treat as definitive failure!
		if isUnknownSubmissionOutcomeError(err) {
			if activeProvider == r.primaryProvider {
				r.primaryCB.RecordFailure(now)
			} else if activeProvider == r.fallbackProvider {
				r.fallbackCB.RecordFailure(now)
			}
			return &ExecutionResult{
				ActualProvider:   activeProvider.Name(),
				ActualModel:      activeProvider.Name() + "-v1",
				Status:           "unknown",
				OutcomeUnknown:   true,
				UsedFallback:     usedFallback,
				FallbackAttempts: fallbackAttempts,
				BYOKUsed:         req.BYOKApiKey != "",
			}, fmt.Errorf("%w: provider %s submission outcome unknown: %v", ErrOutcomeUnknown, activeProvider.Name(), err)
		}

		// Definitive failure on primary -> record failure and try fallback if available
		if activeProvider == r.primaryProvider {
			r.primaryCB.RecordFailure(now)

			if r.fallbackProvider != nil && r.fallbackCB.AllowExecution(now) {
				usedFallback = true
				fallbackAttempts = 1
				activeProvider = r.fallbackProvider
				resp, err = activeProvider.Generate(ctx, req)
				if err != nil && isUnknownSubmissionOutcomeError(err) {
					r.fallbackCB.RecordFailure(now)
					return &ExecutionResult{
						ActualProvider:   activeProvider.Name(),
						ActualModel:      activeProvider.Name() + "-v1",
						Status:           "unknown",
						OutcomeUnknown:   true,
						UsedFallback:     usedFallback,
						FallbackAttempts: fallbackAttempts,
						BYOKUsed:         req.BYOKApiKey != "",
					}, fmt.Errorf("%w: fallback provider %s submission outcome unknown: %v", ErrOutcomeUnknown, activeProvider.Name(), err)
				}
			}
		}
	}

	if err != nil {
		if activeProvider == r.fallbackProvider {
			r.fallbackCB.RecordFailure(now)
		}
		return nil, fmt.Errorf("production generation failed across available providers: %w", err)
	}

	// Poll or retrieve status
	status, err := activeProvider.CheckStatus(ctx, resp.ProviderJobID)
	if err != nil {
		// Job was already accepted (resp.ProviderJobID exists); status check error means outcome is unknown!
		return &ExecutionResult{
			ProviderJobID:    resp.ProviderJobID,
			ActualProvider:   activeProvider.Name(),
			ActualModel:      activeProvider.Name() + "-v1",
			Status:           "unknown",
			OutcomeUnknown:   true,
			UsedFallback:     usedFallback,
			FallbackAttempts: fallbackAttempts,
			BYOKUsed:         req.BYOKApiKey != "",
		}, fmt.Errorf("%w: failed to check provider status for %s: %v", ErrOutcomeUnknown, resp.ProviderJobID, err)
	}

	normalizedStatus := strings.ToLower(strings.TrimSpace(status.Status))
	switch normalizedStatus {
	case "failed", "cancelled", "canceled":
		if activeProvider == r.primaryProvider {
			r.primaryCB.RecordFailure(now)
		} else {
			r.fallbackCB.RecordFailure(now)
		}
		errMsg := strings.TrimSpace(status.ErrorMessage)
		if errMsg == "" {
			errMsg = fmt.Sprintf("provider %s reported terminal status %s", activeProvider.Name(), normalizedStatus)
		}
		return nil, fmt.Errorf("provider %s job %s %s: %s", activeProvider.Name(), resp.ProviderJobID, normalizedStatus, errMsg)

	case "queued", "processing":
		if activeProvider == r.primaryProvider {
			r.primaryCB.RecordSuccess()
		} else {
			r.fallbackCB.RecordSuccess()
		}
		return &ExecutionResult{
			ProviderJobID:    resp.ProviderJobID,
			ActualProvider:   activeProvider.Name(),
			ActualModel:      activeProvider.Name() + "-v1",
			Status:           normalizedStatus,
			DurationSecs:     status.DurationSecs,
			Resolution:       status.Resolution,
			UsedFallback:     usedFallback,
			FallbackAttempts: fallbackAttempts,
			BYOKUsed:         req.BYOKApiKey != "",
		}, nil

	case "completed", "succeeded":
		if strings.TrimSpace(status.ResultURL) == "" {
			return nil, fmt.Errorf("provider %s job %s reported completed status with empty result_url", activeProvider.Name(), resp.ProviderJobID)
		}

	default:
		// "unknown" or unrecognized status must never be treated as completed!
		return &ExecutionResult{
			ProviderJobID:    resp.ProviderJobID,
			ActualProvider:   activeProvider.Name(),
			ActualModel:      activeProvider.Name() + "-v1",
			Status:           "unknown",
			OutcomeUnknown:   true,
			UsedFallback:     usedFallback,
			FallbackAttempts: fallbackAttempts,
			BYOKUsed:         req.BYOKApiKey != "",
		}, fmt.Errorf("%w: provider %s job %s returned non-terminal status %q", ErrOutcomeUnknown, activeProvider.Name(), resp.ProviderJobID, status.Status)
	}

	// Record success on circuit breaker
	if activeProvider == r.primaryProvider {
		r.primaryCB.RecordSuccess()
	} else {
		r.fallbackCB.RecordSuccess()
	}

	// Calculate credits based on actual duration and rate, but CAP strictly at confirmed quote ceiling
	// RULE-M07-002: Bounded retry/fallback included in quote NEVER charges customer above confirmed quote
	actualCredits, _ := r.budgetCalc.ComputeQuotedCredits(status.CostUSD)
	if !confirmedQuoteCredits.IsZero() && actualCredits.Cmp(confirmedQuoteCredits) > 0 {
		actualCredits = confirmedQuoteCredits
	}

	lineage := LineageRecord{
		SourceProvider:        activeProvider.Name(),
		SourceModel:           activeProvider.Name() + "-v1",
		GenerationPrompt:      req.Prompt,
		GenerationCostCredits: actualCredits,
		GenerationCostUSD:     status.CostUSD,
		RecordedAt:            time.Now().UTC(),
	}

	return &ExecutionResult{
		ProviderJobID:    resp.ProviderJobID,
		ActualProvider:   activeProvider.Name(),
		ActualModel:      activeProvider.Name() + "-v1",
		Status:           "completed",
		ResultURL:        status.ResultURL,
		DurationSecs:     status.DurationSecs,
		Resolution:       status.Resolution,
		CostUSD:          status.CostUSD,
		CreditsDeducted:  actualCredits,
		UsedFallback:     usedFallback,
		FallbackAttempts: fallbackAttempts,
		BYOKUsed:         req.BYOKApiKey != "",
		Lineage:          lineage,
	}, nil
}
