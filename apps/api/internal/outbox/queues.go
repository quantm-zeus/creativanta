package outbox

import (
	"errors"
	"fmt"
	"sync"
	"time"
)

// QueueName identifies one of the 11 canonical Redis Streams queues from docs/05_system/queue_retry_design.md §2.
type QueueName string

const (
	QueueGenerationJobs    QueueName = "generation_jobs"
	QueuePublishJobs       QueueName = "publish_jobs"
	QueueConnectorSync     QueueName = "connector_sync"
	QueueWebhookDelivery   QueueName = "webhook_delivery"
	QueueNotifications     QueueName = "notifications"
	QueueAnalyticsCompute  QueueName = "analytics_compute"
	QueueReconciliation    QueueName = "reconciliation"
	QueueExportJobs        QueueName = "export_jobs"
	QueueSearchIndexing    QueueName = "search_indexing"
	QueueModerationScan    QueueName = "moderation_scan"
	QueueGamification      QueueName = "gamification"
	QueueSyncJobs          QueueName = "sync_jobs"
	QueueNotificationPush  QueueName = "notification_push"
	QueueNotificationEmail QueueName = "notification_email"
	QueueAnalyticsEvents   QueueName = "analytics_events"
	QueueAIPipeline        QueueName = "ai_pipeline"
	QueueWorkflowTrigger   QueueName = "workflow_trigger"
	QueueSettlementImport  QueueName = "settlement_import"
	QueueTrendCrawl        QueueName = "trend_crawl"
	QueueAICredit          QueueName = "ai_credit"
)

// Priority represents job scheduling priority levels from queue_retry_design.md §2 & §9.
type Priority string

const (
	PriorityUrgent Priority = "urgent"
	PriorityHigh   Priority = "high"
	PriorityNormal Priority = "normal"
	PriorityLow    Priority = "low"
)

// Weight returns the canonical weighted round-robin scheduling weight (8 : 4 : 2 : 1).
func (p Priority) Weight() int {
	switch p {
	case PriorityUrgent:
		return 8
	case PriorityHigh:
		return 4
	case PriorityNormal:
		return 2
	case PriorityLow:
		return 1
	default:
		return 1
	}
}

// QueueSpec defines the canonical topology and retry policy for a single queue.
type QueueSpec struct {
	Name                   QueueName
	AllowedPriorities      []Priority
	WorkerConcurrency      int
	MaxPerWorkspaceActive  int
	JobTimeout             time.Duration
	MaxRetries             int
	BackoffSchedule        []time.Duration
	ConsecutiveFailSuspend int
}

var canonicalQueueSpecs = map[QueueName]QueueSpec{
	QueueGenerationJobs: {
		Name:                  QueueGenerationJobs,
		AllowedPriorities:     []Priority{PriorityUrgent, PriorityHigh, PriorityNormal},
		WorkerConcurrency:     4,
		MaxPerWorkspaceActive: 3,
		JobTimeout:            5 * time.Minute,
		MaxRetries:            3,
		BackoffSchedule:       []time.Duration{5 * time.Second, 15 * time.Second, 60 * time.Second},
	},
	QueuePublishJobs: {
		Name:                  QueuePublishJobs,
		AllowedPriorities:     []Priority{PriorityUrgent, PriorityHigh, PriorityNormal},
		WorkerConcurrency:     4,
		MaxPerWorkspaceActive: 2,
		JobTimeout:            2 * time.Minute,
		MaxRetries:            3,
		BackoffSchedule:       []time.Duration{10 * time.Second, 30 * time.Second, 120 * time.Second},
	},
	QueueConnectorSync: {
		Name:                  QueueConnectorSync,
		AllowedPriorities:     []Priority{PriorityNormal, PriorityLow},
		WorkerConcurrency:     2,
		MaxPerWorkspaceActive: 1,
		JobTimeout:            3 * time.Minute,
		MaxRetries:            3,
		BackoffSchedule:       []time.Duration{30 * time.Second, 120 * time.Second, 600 * time.Second},
	},
	QueueWebhookDelivery: {
		Name:                   QueueWebhookDelivery,
		AllowedPriorities:      []Priority{PriorityHigh},
		WorkerConcurrency:      4,
		MaxPerWorkspaceActive:  2,
		JobTimeout:             30 * time.Second,
		MaxRetries:             3,
		BackoffSchedule:        []time.Duration{1 * time.Second, 10 * time.Second, 60 * time.Second},
		ConsecutiveFailSuspend: 100,
	},
	QueueNotifications: {
		Name:                  QueueNotifications,
		AllowedPriorities:     []Priority{PriorityUrgent, PriorityHigh, PriorityNormal, PriorityLow},
		WorkerConcurrency:     4,
		MaxPerWorkspaceActive: 4,
		JobTimeout:            15 * time.Second,
		MaxRetries:            3,
		BackoffSchedule:       []time.Duration{2 * time.Second, 10 * time.Second, 30 * time.Second},
	},
	QueueAnalyticsCompute: {
		Name:                  QueueAnalyticsCompute,
		AllowedPriorities:     []Priority{PriorityNormal, PriorityLow},
		WorkerConcurrency:     2,
		MaxPerWorkspaceActive: 1,
		JobTimeout:            5 * time.Minute,
		MaxRetries:            2,
		BackoffSchedule:       []time.Duration{60 * time.Second, 300 * time.Second},
	},
	QueueReconciliation: {
		Name:                  QueueReconciliation,
		AllowedPriorities:     []Priority{PriorityLow},
		WorkerConcurrency:     1,
		MaxPerWorkspaceActive: 1,
		JobTimeout:            10 * time.Minute,
		MaxRetries:            2,
		BackoffSchedule:       []time.Duration{120 * time.Second, 600 * time.Second},
	},
	QueueExportJobs: {
		Name:                  QueueExportJobs,
		AllowedPriorities:     []Priority{PriorityLow},
		WorkerConcurrency:     2,
		MaxPerWorkspaceActive: 1,
		JobTimeout:            10 * time.Minute,
		MaxRetries:            2,
		BackoffSchedule:       []time.Duration{30 * time.Second, 120 * time.Second},
	},
	QueueSearchIndexing: {
		Name:                  QueueSearchIndexing,
		AllowedPriorities:     []Priority{PriorityLow},
		WorkerConcurrency:     2,
		MaxPerWorkspaceActive: 2,
		JobTimeout:            1 * time.Minute,
		MaxRetries:            3,
		BackoffSchedule:       []time.Duration{5 * time.Second, 15 * time.Second, 60 * time.Second},
	},
	QueueModerationScan: {
		Name:                  QueueModerationScan,
		AllowedPriorities:     []Priority{PriorityHigh},
		WorkerConcurrency:     2,
		MaxPerWorkspaceActive: 2,
		JobTimeout:            1 * time.Minute,
		MaxRetries:            2,
		BackoffSchedule:       []time.Duration{5 * time.Second, 30 * time.Second},
	},
	QueueGamification: {
		Name:                  QueueGamification,
		AllowedPriorities:     []Priority{PriorityLow},
		WorkerConcurrency:     2,
		MaxPerWorkspaceActive: 2,
		JobTimeout:            30 * time.Second,
		MaxRetries:            2,
		BackoffSchedule:       []time.Duration{5 * time.Second, 30 * time.Second},
	},
	QueueSyncJobs: {
		Name:                  QueueSyncJobs,
		AllowedPriorities:     []Priority{PriorityNormal, PriorityLow},
		WorkerConcurrency:     2,
		MaxPerWorkspaceActive: 1,
		JobTimeout:            5 * time.Minute,
		MaxRetries:            5,
		BackoffSchedule:       []time.Duration{30 * time.Second, 1 * time.Minute, 5 * time.Minute, 15 * time.Minute, 1 * time.Hour},
	},
	QueueNotificationPush: {
		Name:                  QueueNotificationPush,
		AllowedPriorities:     []Priority{PriorityLow},
		WorkerConcurrency:     4,
		MaxPerWorkspaceActive: 4,
		JobTimeout:            15 * time.Second,
		MaxRetries:            2,
		BackoffSchedule:       []time.Duration{10 * time.Second, 1 * time.Minute},
	},
	QueueNotificationEmail: {
		Name:                  QueueNotificationEmail,
		AllowedPriorities:     []Priority{PriorityLow},
		WorkerConcurrency:     4,
		MaxPerWorkspaceActive: 4,
		JobTimeout:            30 * time.Second,
		MaxRetries:            3,
		BackoffSchedule:       []time.Duration{30 * time.Second, 5 * time.Minute, 30 * time.Minute},
	},
	QueueAnalyticsEvents: {
		Name:                  QueueAnalyticsEvents,
		AllowedPriorities:     []Priority{PriorityLow},
		WorkerConcurrency:     2,
		MaxPerWorkspaceActive: 2,
		JobTimeout:            30 * time.Second,
		MaxRetries:            1,
		BackoffSchedule:       []time.Duration{10 * time.Second},
	},
	QueueAIPipeline: {
		Name:                  QueueAIPipeline,
		AllowedPriorities:     []Priority{PriorityNormal},
		WorkerConcurrency:     4,
		MaxPerWorkspaceActive: 2,
		JobTimeout:            2 * time.Minute,
		MaxRetries:            3,
		BackoffSchedule:       []time.Duration{30 * time.Second, 2 * time.Minute, 10 * time.Minute},
	},
	QueueWorkflowTrigger: {
		Name:                  QueueWorkflowTrigger,
		AllowedPriorities:     []Priority{PriorityNormal},
		WorkerConcurrency:     4,
		MaxPerWorkspaceActive: 2,
		JobTimeout:            2 * time.Minute,
		MaxRetries:            3,
		BackoffSchedule:       []time.Duration{10 * time.Second, 1 * time.Minute, 5 * time.Minute},
	},
	QueueSettlementImport: {
		Name:                  QueueSettlementImport,
		AllowedPriorities:     []Priority{PriorityHigh},
		WorkerConcurrency:     2,
		MaxPerWorkspaceActive: 1,
		JobTimeout:            10 * time.Minute,
		MaxRetries:            5,
		BackoffSchedule:       []time.Duration{1 * time.Minute, 5 * time.Minute, 15 * time.Minute, 1 * time.Hour, 6 * time.Hour},
	},
	QueueTrendCrawl: {
		Name:                  QueueTrendCrawl,
		AllowedPriorities:     []Priority{PriorityLow},
		WorkerConcurrency:     2,
		MaxPerWorkspaceActive: 1,
		JobTimeout:            5 * time.Minute,
		MaxRetries:            2,
		BackoffSchedule:       []time.Duration{5 * time.Minute, 30 * time.Minute},
	},
	QueueAICredit: {
		Name:                  QueueAICredit,
		AllowedPriorities:     []Priority{PriorityHigh},
		WorkerConcurrency:     2,
		MaxPerWorkspaceActive: 1,
		JobTimeout:            30 * time.Second,
		MaxRetries:            2,
		BackoffSchedule:       []time.Duration{10 * time.Second, 1 * time.Minute},
	},
}

// GetQueueSpec returns the canonical QueueSpec for name, or false if name is not a canonical queue.
func GetQueueSpec(name QueueName) (QueueSpec, bool) {
	spec, ok := canonicalQueueSpecs[name]
	return spec, ok
}

// AllQueueSpecs returns all 11 canonical queue specifications.
func AllQueueSpecs() []QueueSpec {
	names := []QueueName{
		QueueGenerationJobs,
		QueuePublishJobs,
		QueueConnectorSync,
		QueueWebhookDelivery,
		QueueNotifications,
		QueueAnalyticsCompute,
		QueueReconciliation,
		QueueExportJobs,
		QueueSearchIndexing,
		QueueModerationScan,
		QueueGamification,
	}
	out := make([]QueueSpec, 0, len(names))
	for _, n := range names {
		out = append(out, canonicalQueueSpecs[n])
	}
	return out
}

// NextBackoff returns the retry delay for 1-based retryAttempt (1..MaxRetries), or (0, false) if retries are exhausted.
func (s QueueSpec) NextBackoff(retryAttempt int) (time.Duration, bool) {
	if retryAttempt < 1 || retryAttempt > s.MaxRetries || retryAttempt > len(s.BackoffSchedule) {
		return 0, false
	}
	return s.BackoffSchedule[retryAttempt-1], true
}

// ErrorClass classifies job/provider errors per docs/05_system/queue_retry_design.md §3.1.
type ErrorClass string

const (
	ErrorClassTransientNetwork    ErrorClass = "transient_network"
	ErrorClassRateLimited         ErrorClass = "rate_limited"
	ErrorClassProvider5xx         ErrorClass = "provider_5xx"
	ErrorClassProviderTimeout     ErrorClass = "provider_timeout"
	ErrorClassAuthExpired         ErrorClass = "auth_expired"
	ErrorClassContentRejected     ErrorClass = "content_rejected"
	ErrorClassInvalidInput        ErrorClass = "invalid_input"
	ErrorClassInsufficientCredits ErrorClass = "insufficient_credits"
	ErrorClassQuotaExhausted      ErrorClass = "quota_exhausted"
	ErrorClassUnknownError        ErrorClass = "unknown_error"
)

// RetryAction describes the canonical recovery strategy for an ErrorClass.
type RetryAction string

const (
	RetryActionExponential       RetryAction = "retry_exponential"
	RetryActionRespectRetryAfter RetryAction = "retry_after_header"
	RetryActionRetryThenFallback RetryAction = "retry_then_fallback"
	RetryActionVerifyStatusFirst RetryAction = "verify_status_first"
	RetryActionNoRetryReconnect  RetryAction = "no_retry_reconnect"
	RetryActionNoRetryFixContent RetryAction = "no_retry_fix_content"
	RetryActionNoRetryDLQAlert   RetryAction = "no_retry_dlq_alert"
	RetryActionNoRetryTopUp      RetryAction = "no_retry_top_up"
	RetryActionPauseWaitReset    RetryAction = "pause_queue_wait_reset"
	RetryActionOnceThenDLQ       RetryAction = "retry_once_then_dlq"
)

// ErrorClassification holds the retry decision for an ErrorClass.
type ErrorClassification struct {
	Class            ErrorClass
	Action           RetryAction
	AllowBlindRetry  bool
	MaxClassAttempts int
	RequiresStatusCk bool
}

// ClassifyError returns the canonical ErrorClassification from queue_retry_design.md §3.1.
// Notably, ErrorClassProviderTimeout NEVER allows blind retry; it requires status verification first.
func ClassifyError(class ErrorClass) ErrorClassification {
	switch class {
	case ErrorClassTransientNetwork:
		return ErrorClassification{
			Class:            ErrorClassTransientNetwork,
			Action:           RetryActionExponential,
			AllowBlindRetry:  true,
			MaxClassAttempts: 3,
		}
	case ErrorClassRateLimited:
		return ErrorClassification{
			Class:            ErrorClassRateLimited,
			Action:           RetryActionRespectRetryAfter,
			AllowBlindRetry:  true,
			MaxClassAttempts: 3,
		}
	case ErrorClassProvider5xx:
		return ErrorClassification{
			Class:            ErrorClassProvider5xx,
			Action:           RetryActionRetryThenFallback,
			AllowBlindRetry:  true,
			MaxClassAttempts: 3,
		}
	case ErrorClassProviderTimeout:
		return ErrorClassification{
			Class:            ErrorClassProviderTimeout,
			Action:           RetryActionVerifyStatusFirst,
			AllowBlindRetry:  false,
			MaxClassAttempts: 0,
			RequiresStatusCk: true,
		}
	case ErrorClassAuthExpired:
		return ErrorClassification{
			Class:            ErrorClassAuthExpired,
			Action:           RetryActionNoRetryReconnect,
			AllowBlindRetry:  false,
			MaxClassAttempts: 0,
		}
	case ErrorClassContentRejected:
		return ErrorClassification{
			Class:            ErrorClassContentRejected,
			Action:           RetryActionNoRetryFixContent,
			AllowBlindRetry:  false,
			MaxClassAttempts: 0,
		}
	case ErrorClassInvalidInput:
		return ErrorClassification{
			Class:            ErrorClassInvalidInput,
			Action:           RetryActionNoRetryDLQAlert,
			AllowBlindRetry:  false,
			MaxClassAttempts: 0,
		}
	case ErrorClassInsufficientCredits:
		return ErrorClassification{
			Class:            ErrorClassInsufficientCredits,
			Action:           RetryActionNoRetryTopUp,
			AllowBlindRetry:  false,
			MaxClassAttempts: 0,
		}
	case ErrorClassQuotaExhausted:
		return ErrorClassification{
			Class:            ErrorClassQuotaExhausted,
			Action:           RetryActionPauseWaitReset,
			AllowBlindRetry:  false,
			MaxClassAttempts: 0,
		}
	default:
		return ErrorClassification{
			Class:            ErrorClassUnknownError,
			Action:           RetryActionOnceThenDLQ,
			AllowBlindRetry:  true,
			MaxClassAttempts: 1,
		}
	}
}

// CircuitState represents the state of a provider circuit breaker (queue_retry_design.md §6).
type CircuitState string

const (
	CircuitClosed   CircuitState = "closed"
	CircuitOpen     CircuitState = "open"
	CircuitHalfOpen CircuitState = "half_open"
)

var (
	// ErrCircuitOpen is returned when a provider circuit breaker is open.
	ErrCircuitOpen = errors.New("outbox: provider circuit breaker is open")
	// ErrWorkspaceConcurrencyCap is returned when a workspace reaches its per-queue active job cap.
	ErrWorkspaceConcurrencyCap = errors.New("outbox: workspace reached maximum concurrent jobs for queue")
)

// CircuitBreaker implements the canonical 3-state provider circuit breaker from queue_retry_design.md §6:
// - Closed -> Open after failureThreshold (5) failures within failureWindow (60s)
// - Open -> HalfOpen after openDuration (30s)
// - HalfOpen -> Closed on probe success, or Open on probe failure.
type CircuitBreaker struct {
	mu               sync.Mutex
	provider         string
	failureThreshold int
	failureWindow    time.Duration
	openDuration     time.Duration
	state            CircuitState
	failures         []time.Time
	openedAt         time.Time
	probeInFlight    bool
}

// NewCircuitBreaker constructs a CircuitBreaker with canonical defaults (5 failures / 60s window / 30s open).
func NewCircuitBreaker(provider string) *CircuitBreaker {
	return &CircuitBreaker{
		provider:         provider,
		failureThreshold: 5,
		failureWindow:    60 * time.Second,
		openDuration:     30 * time.Second,
		state:            CircuitClosed,
	}
}

// Allow checks whether a request to the provider is permitted at time now.
func (cb *CircuitBreaker) Allow(now time.Time) error {
	cb.mu.Lock()
	defer cb.mu.Unlock()

	cb.advanceStateLocked(now)
	switch cb.state {
	case CircuitClosed:
		return nil
	case CircuitOpen:
		return fmt.Errorf("%w: provider=%s", ErrCircuitOpen, cb.provider)
	case CircuitHalfOpen:
		if cb.probeInFlight {
			return fmt.Errorf("%w: provider=%s half-open probe already in flight", ErrCircuitOpen, cb.provider)
		}
		cb.probeInFlight = true
		return nil
	default:
		return nil
	}
}

// RecordSuccess records a successful provider call at time now.
func (cb *CircuitBreaker) RecordSuccess(now time.Time) {
	cb.mu.Lock()
	defer cb.mu.Unlock()

	cb.state = CircuitClosed
	cb.failures = nil
	cb.probeInFlight = false
}

// RecordFailure records a failed provider call at time now.
func (cb *CircuitBreaker) RecordFailure(now time.Time) CircuitState {
	cb.mu.Lock()
	defer cb.mu.Unlock()

	cb.advanceStateLocked(now)
	if cb.state == CircuitHalfOpen {
		cb.state = CircuitOpen
		cb.openedAt = now
		cb.probeInFlight = false
		return cb.state
	}

	cutoff := now.Add(-cb.failureWindow)
	kept := cb.failures[:0]
	for _, ts := range cb.failures {
		if !ts.Before(cutoff) {
			kept = append(kept, ts)
		}
	}
	cb.failures = append(kept, now)

	if len(cb.failures) >= cb.failureThreshold {
		cb.state = CircuitOpen
		cb.openedAt = now
		cb.probeInFlight = false
	}
	return cb.state
}

// State returns the current state of the circuit breaker at time now.
func (cb *CircuitBreaker) State(now time.Time) CircuitState {
	cb.mu.Lock()
	defer cb.mu.Unlock()
	cb.advanceStateLocked(now)
	return cb.state
}

func (cb *CircuitBreaker) advanceStateLocked(now time.Time) {
	if cb.state == CircuitOpen && !now.Before(cb.openedAt.Add(cb.openDuration)) {
		cb.state = CircuitHalfOpen
		cb.probeInFlight = false
	}
}

// FairWorkspaceScheduler enforces per-workspace concurrency limits per queue (queue_retry_design.md §9)
// so a single noisy tenant cannot monopolize worker slots.
type FairWorkspaceScheduler struct {
	mu     sync.Mutex
	active map[QueueName]map[string]int
}

// NewFairWorkspaceScheduler creates a FairWorkspaceScheduler.
func NewFairWorkspaceScheduler() *FairWorkspaceScheduler {
	return &FairWorkspaceScheduler{
		active: make(map[QueueName]map[string]int),
	}
}

// Acquire claims a worker slot for workspaceID on queueName if below the canonical per-workspace cap.
func (s *FairWorkspaceScheduler) Acquire(queueName QueueName, workspaceID string) (func(), error) {
	spec, ok := GetQueueSpec(queueName)
	if !ok {
		return nil, fmt.Errorf("outbox: unknown queue %q", queueName)
	}
	s.mu.Lock()
	defer s.mu.Unlock()

	wsMap, ok := s.active[queueName]
	if !ok {
		wsMap = make(map[string]int)
		s.active[queueName] = wsMap
	}
	cur := wsMap[workspaceID]
	if cur >= spec.MaxPerWorkspaceActive {
		return nil, fmt.Errorf("%w: queue=%s workspace=%s active=%d max=%d",
			ErrWorkspaceConcurrencyCap, queueName, workspaceID, cur, spec.MaxPerWorkspaceActive)
	}
	wsMap[workspaceID] = cur + 1

	var once sync.Once
	release := func() {
		once.Do(func() {
			s.mu.Lock()
			defer s.mu.Unlock()
			if m, exists := s.active[queueName]; exists {
				if m[workspaceID] <= 1 {
					delete(m, workspaceID)
				} else {
					m[workspaceID]--
				}
			}
		})
	}
	return release, nil
}
