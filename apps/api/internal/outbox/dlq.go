package outbox

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"sync"
	"time"
)

const (
	// DefaultDLQRetentionPeriod is the 30-day retention window for non-financial DLQ items (queue_retry_design.md §5).
	DefaultDLQRetentionPeriod = 30 * 24 * time.Hour
)

var (
	// ErrDLQProtectedByOPS202602 is returned when attempting to discard/purge a financial or unresolved-external-effect DLQ item.
	ErrDLQProtectedByOPS202602 = errors.New("outbox: DLQ item is protected by OPS-2026-02 (financial or unresolved external effect)")
)

// DLQRetryAttempt records one failed execution attempt in dead_letter_queue.retry_history.
type DLQRetryAttempt struct {
	Attempt    int        `json:"attempt"`
	ErrorClass ErrorClass `json:"error_class"`
	ErrorMsg   string     `json:"error_message"`
	FailedAt   time.Time  `json:"failed_at"`
}

// DLQItem models a row in dead_letter_queue (§18.4G).
type DLQItem struct {
	DLQID             string            `json:"dlq_id"`
	QueueName         QueueName         `json:"queue_name"`
	OriginalMessageID string            `json:"original_message_id"`
	EventID           string            `json:"event_id"`
	OperationKey      string            `json:"operation_key,omitempty"`
	WorkspaceID       string            `json:"workspace_id"`
	Payload           json.RawMessage   `json:"payload"`
	ErrorClass        ErrorClass        `json:"error_class"`
	ErrorMessage      string            `json:"error_message"`
	LastErrorAt       time.Time         `json:"last_error_at"`
	AttemptCount      int               `json:"attempt_count"`
	RetryHistory      []DLQRetryAttempt `json:"retry_history"`
	Status            string            `json:"status"` // pending, retrying, resolved, discarded
	IsFinancial       bool              `json:"is_financial"`
	ResolvedAt        *time.Time        `json:"resolved_at,omitempty"`
	ResolvedBy        string            `json:"resolved_by,omitempty"`
	ResolutionNotes   string            `json:"resolution_notes,omitempty"`
	CreatedAt         time.Time         `json:"created_at"`
}

// DLQManager manages dead-lettered messages, manual replays, and OPS-2026-02 retention protection.
type DLQManager struct {
	mu          sync.Mutex
	items       map[string]*DLQItem
	effectGuard *ExternalEffectGuard
}

// NewDLQManager constructs a DLQManager linked to an ExternalEffectGuard.
func NewDLQManager(effectGuard *ExternalEffectGuard) *DLQManager {
	return &DLQManager{
		items:       make(map[string]*DLQItem),
		effectGuard: effectGuard,
	}
}

// EnqueueDLQ persists a dead-lettered message after retry exhaustion or terminal failure.
func (m *DLQManager) EnqueueDLQ(item DLQItem) (DLQItem, error) {
	if item.DLQID == "" || item.OriginalMessageID == "" {
		return DLQItem{}, errors.New("outbox: dlq_id and original_message_id are required")
	}
	if item.Status == "" {
		item.Status = "pending"
	}
	if item.QueueName == QueueReconciliation {
		item.IsFinancial = true
	}

	m.mu.Lock()
	defer m.mu.Unlock()
	cp := item
	m.items[item.DLQID] = &cp
	return cp, nil
}

// ReplayDLQItem manually replays a DLQ item while preserving its original EventID and OperationKey.
// If the linked ExternalEffectRecord is in 'unknown' or 'submitted' state, replay is blocked until reconciled.
func (m *DLQManager) ReplayDLQItem(
	ctx context.Context,
	dlqID string,
	broker StreamBroker,
	now time.Time,
) (StreamMessage, error) {
	m.mu.Lock()
	item, ok := m.items[dlqID]
	if !ok {
		m.mu.Unlock()
		return StreamMessage{}, fmt.Errorf("outbox: DLQ item %q not found", dlqID)
	}
	cp := *item
	m.mu.Unlock()

	if m.effectGuard != nil && cp.OperationKey != "" {
		if rec, exists := m.effectGuard.GetRecord(cp.WorkspaceID, cp.OperationKey); exists {
			if rec.Status == EffectStatusUnknown || rec.Status == EffectStatusSubmitted {
				return StreamMessage{}, fmt.Errorf(
					"%w: cannot replay DLQ item %s while operation_key=%s is %s",
					ErrExternalOutcomeUnresolved, dlqID, cp.OperationKey, rec.Status,
				)
			}
		}
	}

	replayedMsg := StreamMessage{
		EventID:       cp.EventID,
		EventType:     "dlq.replayed",
		TargetStream:  cp.QueueName,
		AggregateType: "dlq_replay",
		AggregateID:   cp.EventID,
		WorkspaceID:   cp.WorkspaceID,
		Payload:       cp.Payload,
		PublishedAt:   now,
	}
	entryID, err := broker.XAdd(ctx, cp.QueueName, replayedMsg)
	if err != nil {
		return StreamMessage{}, err
	}
	replayedMsg.StreamEntryID = entryID

	m.mu.Lock()
	if cur, exists := m.items[dlqID]; exists {
		cur.Status = "retrying"
	}
	m.mu.Unlock()

	return replayedMsg, nil
}

// PurgeExpiredItems deletes non-financial DLQ items older than DefaultDLQRetentionPeriod,
// while strictly preserving financial items and items with unresolved ('unknown'/'submitted') external effects per OPS-2026-02.
func (m *DLQManager) PurgeExpiredItems(now time.Time) (purged int, protected int) {
	m.mu.Lock()
	defer m.mu.Unlock()

	for id, item := range m.items {
		if now.Sub(item.CreatedAt) < DefaultDLQRetentionPeriod {
			continue
		}
		if item.IsFinancial {
			protected++
			continue
		}
		if m.effectGuard != nil && item.OperationKey != "" {
			if rec, exists := m.effectGuard.GetRecord(item.WorkspaceID, item.OperationKey); exists {
				if rec.Status == EffectStatusUnknown || rec.Status == EffectStatusSubmitted {
					protected++
					continue
				}
			}
		}
		delete(m.items, id)
		purged++
	}
	return purged, protected
}

// CountPendingByWorkspace returns the number of pending DLQ items for workspaceID.
func (m *DLQManager) CountPendingByWorkspace(workspaceID string) int {
	m.mu.Lock()
	defer m.mu.Unlock()
	count := 0
	for _, item := range m.items {
		if item.WorkspaceID == workspaceID && (item.Status == "pending" || item.Status == "retrying") {
			count++
		}
	}
	return count
}
