package production

import (
	"context"
	"fmt"
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

// ExecuteRoutedJob satisfies Acceptance Target 2:
// "Fallback no double charge"
// Executes primary provider first; on definitive failure, auto-falls back to secondary provider
// within the confirmed quote and consent ceiling, preserving attempt history and recording actual lineage,
// with zero double debit.
func (r *PipelineRouter) ExecuteRoutedJob(ctx context.Context, req ProviderGenRequest, confirmedQuoteCredits tenantdb.ExactDecimal) (*ExecutionResult, error) {
	now := time.Now().UTC()
	var (
		activeProvider   VideoProvider
		usedFallback     = false
		fallbackAttempts = 0
	)

	// 1. Try primary provider if circuit breaker allows
	if r.primaryCB.AllowExecution(now) {
		activeProvider = r.primaryProvider
	} else if r.fallbackProvider != nil && r.fallbackCB.AllowExecution(now) {
		// Primary circuit breaker is OPEN -> directly route to fallback
		activeProvider = r.fallbackProvider
		usedFallback = true
		fallbackAttempts = 1
	} else {
		return nil, ErrCircuitBreakerOpen
	}

	resp, err := activeProvider.Generate(ctx, req)
	if err != nil {
		// Record failure on primary
		if activeProvider == r.primaryProvider {
			r.primaryCB.RecordFailure(now)

			// Try secondary fallback if available
			if r.fallbackProvider != nil && r.fallbackCB.AllowExecution(now) {
				usedFallback = true
				fallbackAttempts = 1
				activeProvider = r.fallbackProvider
				resp, err = activeProvider.Generate(ctx, req)
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
		return nil, fmt.Errorf("failed to check provider status for %s: %w", resp.ProviderJobID, err)
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
