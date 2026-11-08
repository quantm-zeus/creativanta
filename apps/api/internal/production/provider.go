package production

import (
	"context"
	"fmt"
	"sync"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// ProviderGenRequest holds the normalized request payload dispatched to AI providers.
type ProviderGenRequest struct {
	Prompt             string
	DurationSeconds    int
	AspectRatio        string
	PipelineStrategy   string
	BYOKApiKey         string // User's own key if provided
	ReferenceURL       string
	ImageURLs          []string
	IdempotencyKey     string
	OnProviderAccepted func(providerName, providerJobID string)
}

// ProviderGenResponse is the initial submission acknowledgement from the provider.
type ProviderGenResponse struct {
	ProviderJobID string
	InitialStatus string // queued, processing, completed
	EstimatedCost tenantdb.ExactDecimal
}

// ProviderGenStatus holds the polled or callback status of a provider execution.
type ProviderGenStatus struct {
	ProviderJobID string
	Status        string // queued, processing, completed, failed, unknown
	ProgressPct   int
	ResultURL     string
	DurationSecs  tenantdb.ExactDecimal
	Resolution    string
	CostUSD       tenantdb.ExactDecimal
	ErrorCode     string
	ErrorMessage  string
}

// VideoProvider abstracts underlying video model engines (Veo, Kling, etc.).
type VideoProvider interface {
	Name() string
	Generate(ctx context.Context, req ProviderGenRequest) (*ProviderGenResponse, error)
	CheckStatus(ctx context.Context, providerJobID string) (*ProviderGenStatus, error)
	Cancel(ctx context.Context, providerJobID string) error
	CostRatePerSecondUSD() tenantdb.ExactDecimal
}

// CircuitBreaker monitors provider health and fails over to secondary adapters (ADR-010).
type CircuitBreaker struct {
	mu               sync.RWMutex
	failureThreshold int
	resetTimeoutSecs int
	consecutiveFails int
	lastFailureAt    time.Time
	state            string // "closed", "open", "half-open"
}

// NewCircuitBreaker creates a circuit breaker with threshold and reset timeout.
func NewCircuitBreaker(threshold, resetTimeoutSecs int) *CircuitBreaker {
	return &CircuitBreaker{
		failureThreshold: threshold,
		resetTimeoutSecs: resetTimeoutSecs,
		state:            "closed",
	}
}

// AllowExecution checks if requests are allowed through to this provider.
func (cb *CircuitBreaker) AllowExecution(now time.Time) bool {
	cb.mu.Lock()
	defer cb.mu.Unlock()

	if cb.state == "open" {
		if now.Sub(cb.lastFailureAt).Seconds() > float64(cb.resetTimeoutSecs) {
			cb.state = "half-open"
			return true
		}
		return false
	}
	return true
}

// RecordSuccess resets consecutive failure counter on success.
func (cb *CircuitBreaker) RecordSuccess() {
	cb.mu.Lock()
	defer cb.mu.Unlock()

	cb.consecutiveFails = 0
	cb.state = "closed"
}

// RecordFailure increments failure counter and trips circuit when threshold is hit.
func (cb *CircuitBreaker) RecordFailure(now time.Time) {
	cb.mu.Lock()
	defer cb.mu.Unlock()

	cb.consecutiveFails++
	cb.lastFailureAt = now
	if cb.consecutiveFails >= cb.failureThreshold {
		cb.state = "open"
	}
}

// State returns the current circuit breaker state ("closed", "open", "half-open").
func (cb *CircuitBreaker) State() string {
	cb.mu.RLock()
	defer cb.mu.RUnlock()
	return cb.state
}

// MockVeoProvider implements Google Veo 3.1 provider adapter.
type MockVeoProvider struct {
	mu             sync.RWMutex
	jobs           map[string]*ProviderGenStatus
	FailGeneration bool
	TimeoutOnCall  bool
	CheckStatusErr error
	CustomStatus   *ProviderGenStatus
	GenerateCount  int
	LastRequest    ProviderGenRequest
	RateUSDPerSec  tenantdb.ExactDecimal
}

// NewMockVeoProvider returns a Veo 3.1 provider instance.
func NewMockVeoProvider() *MockVeoProvider {
	rate, _ := tenantdb.ParseExactDecimal("0.040000") // $0.04/second
	return &MockVeoProvider{
		jobs:          make(map[string]*ProviderGenStatus),
		RateUSDPerSec: rate,
	}
}

func (p *MockVeoProvider) Name() string { return "veo" }

func (p *MockVeoProvider) CostRatePerSecondUSD() tenantdb.ExactDecimal {
	return p.RateUSDPerSec
}

func (p *MockVeoProvider) GetGenerateCount() int {
	p.mu.RLock()
	defer p.mu.RUnlock()
	return p.GenerateCount
}

func (p *MockVeoProvider) GetLastRequest() ProviderGenRequest {
	p.mu.RLock()
	defer p.mu.RUnlock()
	return p.LastRequest
}

func (p *MockVeoProvider) Generate(ctx context.Context, req ProviderGenRequest) (*ProviderGenResponse, error) {
	p.mu.Lock()
	defer p.mu.Unlock()

	p.GenerateCount++
	p.LastRequest = req

	if p.TimeoutOnCall {
		return nil, context.DeadlineExceeded
	}

	if p.FailGeneration {
		return nil, fmt.Errorf("veo: provider capacity error: 503 Service Unavailable")
	}

	jobID := fmt.Sprintf("veo-job-%d", time.Now().UnixNano())
	dur := req.DurationSeconds
	if dur <= 0 {
		dur = 15
	}
	durDec, _ := tenantdb.ParseExactDecimal(fmt.Sprintf("%d.000000", dur))
	cost, _ := durDec.MulFloor(p.RateUSDPerSec)

	st := &ProviderGenStatus{
		ProviderJobID: jobID,
		Status:        "completed",
		ProgressPct:   100,
		ResultURL:     fmt.Sprintf("https://cdn.creativanta.test/outputs/%s.mp4", jobID),
		DurationSecs:  durDec,
		Resolution:    "1080x1920",
		CostUSD:       cost,
	}
	if p.CustomStatus != nil {
		cp := *p.CustomStatus
		cp.ProviderJobID = jobID
		if cp.DurationSecs.IsZero() {
			cp.DurationSecs = durDec
		}
		if cp.CostUSD.IsZero() {
			cp.CostUSD = cost
		}
		st = &cp
	}
	p.jobs[jobID] = st

	return &ProviderGenResponse{
		ProviderJobID: jobID,
		InitialStatus: "processing",
		EstimatedCost: cost,
	}, nil
}

func (p *MockVeoProvider) CheckStatus(ctx context.Context, providerJobID string) (*ProviderGenStatus, error) {
	p.mu.RLock()
	defer p.mu.RUnlock()

	if p.CheckStatusErr != nil {
		return nil, p.CheckStatusErr
	}

	st, ok := p.jobs[providerJobID]
	if !ok {
		return nil, fmt.Errorf("veo: job %q not found", providerJobID)
	}
	cp := *st
	return &cp, nil
}

func (p *MockVeoProvider) Cancel(ctx context.Context, providerJobID string) error {
	p.mu.Lock()
	defer p.mu.Unlock()

	if st, ok := p.jobs[providerJobID]; ok {
		st.Status = "cancelled"
	}
	return nil
}

// MockKlingProvider implements Kling 3.0 secondary/fallback provider adapter.
type MockKlingProvider struct {
	mu             sync.RWMutex
	jobs           map[string]*ProviderGenStatus
	FailGeneration bool
	GenerateCount  int
	LastRequest    ProviderGenRequest
	RateUSDPerSec  tenantdb.ExactDecimal
}

// NewMockKlingProvider returns a Kling 3.0 fallback provider.
func NewMockKlingProvider() *MockKlingProvider {
	rate, _ := tenantdb.ParseExactDecimal("0.030000") // $0.03/second
	return &MockKlingProvider{
		jobs:          make(map[string]*ProviderGenStatus),
		RateUSDPerSec: rate,
	}
}

func (p *MockKlingProvider) Name() string { return "kling" }

func (p *MockKlingProvider) CostRatePerSecondUSD() tenantdb.ExactDecimal {
	return p.RateUSDPerSec
}

func (p *MockKlingProvider) GetGenerateCount() int {
	p.mu.RLock()
	defer p.mu.RUnlock()
	return p.GenerateCount
}

func (p *MockKlingProvider) Generate(ctx context.Context, req ProviderGenRequest) (*ProviderGenResponse, error) {
	p.mu.Lock()
	defer p.mu.Unlock()

	p.GenerateCount++
	p.LastRequest = req

	if p.FailGeneration {
		return nil, fmt.Errorf("kling: provider capacity error: 500 Internal Error")
	}

	jobID := fmt.Sprintf("kling-job-%d", time.Now().UnixNano())
	dur := req.DurationSeconds
	if dur <= 0 {
		dur = 15
	}
	durDec, _ := tenantdb.ParseExactDecimal(fmt.Sprintf("%d.000000", dur))
	cost, _ := durDec.MulFloor(p.RateUSDPerSec)

	p.jobs[jobID] = &ProviderGenStatus{
		ProviderJobID: jobID,
		Status:        "completed",
		ProgressPct:   100,
		ResultURL:     fmt.Sprintf("https://cdn.creativanta.test/outputs/%s.mp4", jobID),
		DurationSecs:  durDec,
		Resolution:    "1080x1920",
		CostUSD:       cost,
	}

	return &ProviderGenResponse{
		ProviderJobID: jobID,
		InitialStatus: "processing",
		EstimatedCost: cost,
	}, nil
}

func (p *MockKlingProvider) CheckStatus(ctx context.Context, providerJobID string) (*ProviderGenStatus, error) {
	p.mu.RLock()
	defer p.mu.RUnlock()

	st, ok := p.jobs[providerJobID]
	if !ok {
		return nil, fmt.Errorf("kling: job %q not found", providerJobID)
	}
	cp := *st
	return &cp, nil
}

func (p *MockKlingProvider) Cancel(ctx context.Context, providerJobID string) error {
	p.mu.Lock()
	defer p.mu.Unlock()

	if st, ok := p.jobs[providerJobID]; ok {
		st.Status = "cancelled"
	}
	return nil
}
