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
	// DefaultConsumerIdleClaimTimeout is the canonical 60-second PEL idle timeout before XAUTOCLAIM recovery (queue_retry_design.md §7.2).
	DefaultConsumerIdleClaimTimeout = 60 * time.Second
)

var (
	// ErrLiveActorAuthorizationRevoked is returned when a queued message's actor lost membership or permission before execution.
	ErrLiveActorAuthorizationRevoked = errors.New("outbox: actor membership or permission revoked before execution")
	// ErrApprovalExpiredBeforeExecution is returned when a queued message's required approval expired before execution.
	ErrApprovalExpiredBeforeExecution = errors.New("outbox: required approval expired or revoked before execution")
)

// StreamMessage represents a message in a Redis Stream.
type StreamMessage struct {
	StreamEntryID   string          `json:"stream_entry_id"`
	EventID         string          `json:"event_id"`
	EventType       string          `json:"event_type"`
	TargetStream    QueueName       `json:"target_stream"`
	AggregateType   string          `json:"aggregate_type"`
	AggregateID     string          `json:"aggregate_id"`
	WorkspaceID     string          `json:"workspace_id"`
	ActorID         string          `json:"actor_id,omitempty"`
	ActorType       string          `json:"actor_type,omitempty"`
	RequiredPerm    string          `json:"required_perm,omitempty"`
	ApprovalID      string          `json:"approval_id,omitempty"`
	Payload         json.RawMessage `json:"payload"`
	Metadata        json.RawMessage `json:"metadata,omitempty"`
	PublishedAt     time.Time       `json:"published_at"`
	DeliveryCount   int             `json:"delivery_count"`
	ClaimedBy       string          `json:"claimed_by,omitempty"`
	LastDeliveredAt time.Time       `json:"last_delivered_at"`
}

// StreamBroker models Redis Streams operations (XADD, XREADGROUP, XACK, XAUTOCLAIM).
type StreamBroker interface {
	XAdd(ctx context.Context, stream QueueName, msg StreamMessage) (string, error)
	XReadGroup(ctx context.Context, stream QueueName, groupName, consumerID string, now time.Time, count int) ([]StreamMessage, error)
	XAutoClaim(ctx context.Context, stream QueueName, groupName, consumerID string, minIdle time.Duration, now time.Time, count int) ([]StreamMessage, error)
	XAck(ctx context.Context, stream QueueName, groupName, streamEntryID string) error
	PendingCount(stream QueueName, groupName string) int
}

type pelEntry struct {
	msg             StreamMessage
	consumerID      string
	lastDeliveredAt time.Time
	deliveryCount   int
}

type groupState struct {
	nextIndex int
	pel       map[string]*pelEntry
}

// MemoryStreamBroker is a thread-safe Redis Streams broker modeling consumer groups, PEL, XACK, and XAUTOCLAIM.
type MemoryStreamBroker struct {
	mu      sync.Mutex
	nextSeq int64
	streams map[QueueName][]StreamMessage
	groups  map[string]*groupState
}

// NewMemoryStreamBroker creates a MemoryStreamBroker.
func NewMemoryStreamBroker() *MemoryStreamBroker {
	return &MemoryStreamBroker{
		nextSeq: 1,
		streams: make(map[QueueName][]StreamMessage),
		groups:  make(map[string]*groupState),
	}
}

func groupKey(stream QueueName, groupName string) string {
	return string(stream) + "::" + groupName
}

func (b *MemoryStreamBroker) getOrCreateGroupLocked(stream QueueName, groupName string) *groupState {
	k := groupKey(stream, groupName)
	g, ok := b.groups[k]
	if !ok {
		g = &groupState{
			pel: make(map[string]*pelEntry),
		}
		b.groups[k] = g
	}
	return g
}

// XAdd appends a message to stream and returns its generated Redis stream entry ID.
func (b *MemoryStreamBroker) XAdd(_ context.Context, stream QueueName, msg StreamMessage) (string, error) {
	b.mu.Lock()
	defer b.mu.Unlock()

	entryID := fmt.Sprintf("%d-%d", msg.PublishedAt.UnixMilli(), b.nextSeq)
	b.nextSeq++
	msg.StreamEntryID = entryID
	b.streams[stream] = append(b.streams[stream], msg)
	return entryID, nil
}

// XReadGroup reads up to count undelivered messages for groupName and places them in the group's Pending Entries List (PEL).
func (b *MemoryStreamBroker) XReadGroup(_ context.Context, stream QueueName, groupName, consumerID string, now time.Time, count int) ([]StreamMessage, error) {
	b.mu.Lock()
	defer b.mu.Unlock()

	g := b.getOrCreateGroupLocked(stream, groupName)
	entries := b.streams[stream]
	var out []StreamMessage

	for g.nextIndex < len(entries) && len(out) < count {
		msg := entries[g.nextIndex]
		g.nextIndex++
		msg.ClaimedBy = consumerID
		msg.LastDeliveredAt = now
		msg.DeliveryCount = 1

		g.pel[msg.StreamEntryID] = &pelEntry{
			msg:             msg,
			consumerID:      consumerID,
			lastDeliveredAt: now,
			deliveryCount:   1,
		}
		out = append(out, msg)
	}
	return out, nil
}

// XAutoClaim scans the group's PEL and transfers entries idle for >= minIdle at time now to consumerID.
func (b *MemoryStreamBroker) XAutoClaim(_ context.Context, stream QueueName, groupName, consumerID string, minIdle time.Duration, now time.Time, count int) ([]StreamMessage, error) {
	b.mu.Lock()
	defer b.mu.Unlock()

	g := b.getOrCreateGroupLocked(stream, groupName)
	var claimed []StreamMessage

	for _, entry := range g.pel {
		if len(claimed) >= count {
			break
		}
		if now.Sub(entry.lastDeliveredAt) < minIdle {
			continue
		}
		entry.consumerID = consumerID
		entry.lastDeliveredAt = now
		entry.deliveryCount++
		entry.msg.ClaimedBy = consumerID
		entry.msg.LastDeliveredAt = now
		entry.msg.DeliveryCount = entry.deliveryCount
		claimed = append(claimed, entry.msg)
	}
	return claimed, nil
}

// XAck removes streamEntryID from the group's Pending Entries List (PEL).
func (b *MemoryStreamBroker) XAck(_ context.Context, stream QueueName, groupName, streamEntryID string) error {
	b.mu.Lock()
	defer b.mu.Unlock()

	g := b.getOrCreateGroupLocked(stream, groupName)
	delete(g.pel, streamEntryID)
	return nil
}

// PendingCount returns the number of unacknowledged messages in the group's PEL.
func (b *MemoryStreamBroker) PendingCount(stream QueueName, groupName string) int {
	b.mu.Lock()
	defer b.mu.Unlock()

	g := b.getOrCreateGroupLocked(stream, groupName)
	return len(g.pel)
}

// =============================================================================
// Consumer Inbox & Live Re-Verification
// =============================================================================

// LiveAuthVerifier re-verifies actor membership, RBAC permission, and approval validity at execution time.
type LiveAuthVerifier interface {
	VerifyActorAndApproval(ctx context.Context, workspaceID, actorID, requiredPerm, approvalID string, now time.Time) error
}

// ConsumerFaultHooks allows deterministic crash simulation before DB commit and between DB commit and XACK.
type ConsumerFaultHooks struct {
	BeforeTxCommit         func(msg StreamMessage) error
	AfterTxCommitBeforeAck func(msg StreamMessage) error
}

// ConsumerOutcome reports how a single StreamMessage was handled.
type ConsumerOutcome struct {
	StreamEntryID string
	EventID       string
	Executed      bool
	Deduplicated  bool
	AbortedAuth   bool
	Acked         bool
}

// ConsumerInboxEngine executes consumer handlers atomically with consumer_inbox deduplication and audit logging.
type ConsumerInboxEngine interface {
	ExecuteAtomically(
		ctx context.Context,
		consumerName string,
		msg StreamMessage,
		now time.Time,
		beforeCommit func(StreamMessage) error,
		handler func(ctx context.Context, msg StreamMessage) error,
	) (executed bool, deduplicated bool, err error)
	RecordAbortedAudit(ctx context.Context, msg StreamMessage, reason string, now time.Time) error
}

// ConsumerWorker processes messages from a StreamBroker consumer group using transactional consumer_inbox deduplication.
type ConsumerWorker struct {
	Stream       QueueName
	GroupName    string
	ConsumerID   string
	Broker       StreamBroker
	InboxEngine  ConsumerInboxEngine
	AuthVerifier LiveAuthVerifier
	IdleTimeout  time.Duration
	Faults       ConsumerFaultHooks
}

// NewConsumerWorker creates a ConsumerWorker with canonical 60-second XAUTOCLAIM idle timeout.
func NewConsumerWorker(stream QueueName, groupName, consumerID string, broker StreamBroker, engine ConsumerInboxEngine) *ConsumerWorker {
	return &ConsumerWorker{
		Stream:      stream,
		GroupName:   groupName,
		ConsumerID:  consumerID,
		Broker:      broker,
		InboxEngine: engine,
		IdleTimeout: DefaultConsumerIdleClaimTimeout,
	}
}

// ProcessNext reads new messages (via XREADGROUP) and stalled messages (via XAUTOCLAIM after 60s idle),
// re-verifies live auth/approval, runs handler inside an atomic consumer_inbox transaction, and calls XACK strictly after commit.
func (w *ConsumerWorker) ProcessNext(ctx context.Context, now time.Time, batchSize int, handler func(ctx context.Context, msg StreamMessage) error) ([]ConsumerOutcome, error) {
	idle := w.IdleTimeout
	if idle <= 0 {
		idle = DefaultConsumerIdleClaimTimeout
	}
	if batchSize <= 0 {
		batchSize = 10
	}

	reclaimed, err := w.Broker.XAutoClaim(ctx, w.Stream, w.GroupName, w.ConsumerID, idle, now, batchSize)
	if err != nil {
		return nil, err
	}
	fresh, err := w.Broker.XReadGroup(ctx, w.Stream, w.GroupName, w.ConsumerID, now, batchSize)
	if err != nil {
		return nil, err
	}

	all := append(reclaimed, fresh...)
	var outcomes []ConsumerOutcome

	for _, msg := range all {
		outcome, procErr := w.processSingleMessage(ctx, msg, now, handler)
		outcomes = append(outcomes, outcome)
		if procErr != nil {
			return outcomes, procErr
		}
	}
	return outcomes, nil
}

func (w *ConsumerWorker) processSingleMessage(
	ctx context.Context,
	msg StreamMessage,
	now time.Time,
	handler func(ctx context.Context, msg StreamMessage) error,
) (ConsumerOutcome, error) {
	outcome := ConsumerOutcome{
		StreamEntryID: msg.StreamEntryID,
		EventID:       msg.EventID,
	}

	if w.AuthVerifier != nil && (msg.WorkspaceID != "" || msg.ActorID != "" || msg.ApprovalID != "") {
		if authErr := w.AuthVerifier.VerifyActorAndApproval(ctx, msg.WorkspaceID, msg.ActorID, msg.RequiredPerm, msg.ApprovalID, now); authErr != nil {
			_ = w.InboxEngine.RecordAbortedAudit(ctx, msg, authErr.Error(), now)
			if ackErr := w.Broker.XAck(ctx, w.Stream, w.GroupName, msg.StreamEntryID); ackErr != nil {
				return outcome, ackErr
			}
			outcome.AbortedAuth = true
			outcome.Acked = true
			return outcome, nil
		}
	}

	executed, deduplicated, execErr := w.InboxEngine.ExecuteAtomically(
		ctx,
		w.GroupName,
		msg,
		now,
		w.Faults.BeforeTxCommit,
		handler,
	)
	if execErr != nil {
		return outcome, execErr
	}
	outcome.Executed = executed
	outcome.Deduplicated = deduplicated

	if w.Faults.AfterTxCommitBeforeAck != nil {
		if crashErr := w.Faults.AfterTxCommitBeforeAck(msg); crashErr != nil {
			return outcome, crashErr
		}
	}

	if err := w.Broker.XAck(ctx, w.Stream, w.GroupName, msg.StreamEntryID); err != nil {
		return outcome, err
	}
	outcome.Acked = true
	return outcome, nil
}

// =============================================================================
// In-Memory Transactional ConsumerInboxEngine (for unit/race/crash tests)
// =============================================================================

// AuditLogEntry represents an immutable audit log record written during consumer execution.
type AuditLogEntry struct {
	AuditEventID string
	WorkspaceID  string
	ActorID      string
	ActorType    string
	Action       string
	ResourceType string
	ResourceID   string
	Reason       string
	CreatedAt    time.Time
}

// MemoryConsumerInboxEngine implements ConsumerInboxEngine with transactional rollback on error.
type MemoryConsumerInboxEngine struct {
	mu     sync.Mutex
	inbox  map[string]time.Time
	audits []AuditLogEntry
}

// NewMemoryConsumerInboxEngine constructs a MemoryConsumerInboxEngine.
func NewMemoryConsumerInboxEngine() *MemoryConsumerInboxEngine {
	return &MemoryConsumerInboxEngine{
		inbox: make(map[string]time.Time),
	}
}

func inboxKey(workspaceID, consumerName, eventID string) string {
	return workspaceID + "::" + consumerName + "::" + eventID
}

// ExecuteAtomically runs handler and commits the consumer_inbox record and audit entry iff handler and beforeCommit succeed.
func (e *MemoryConsumerInboxEngine) ExecuteAtomically(
	ctx context.Context,
	consumerName string,
	msg StreamMessage,
	now time.Time,
	beforeCommit func(StreamMessage) error,
	handler func(ctx context.Context, msg StreamMessage) error,
) (bool, bool, error) {
	e.mu.Lock()
	key := inboxKey(msg.WorkspaceID, consumerName, msg.EventID)
	if _, exists := e.inbox[key]; exists {
		e.mu.Unlock()
		return false, true, nil
	}
	e.mu.Unlock()

	if err := handler(ctx, msg); err != nil {
		return false, false, err
	}
	if beforeCommit != nil {
		if err := beforeCommit(msg); err != nil {
			return false, false, err
		}
	}

	e.mu.Lock()
	defer e.mu.Unlock()
	if _, exists := e.inbox[key]; exists {
		return false, true, nil
	}
	e.inbox[key] = now
	e.audits = append(e.audits, AuditLogEntry{
		AuditEventID: msg.EventID,
		WorkspaceID:  msg.WorkspaceID,
		ActorID:      msg.ActorID,
		ActorType:    nonEmpty(msg.ActorType, "system"),
		Action:       "consumer.processed:" + msg.EventType,
		ResourceType: msg.AggregateType,
		ResourceID:   msg.AggregateID,
		CreatedAt:    now,
	})
	return true, false, nil
}

// RecordAbortedAudit records an immutable audit event when a queued job is aborted due to revoked auth or expired approval.
func (e *MemoryConsumerInboxEngine) RecordAbortedAudit(_ context.Context, msg StreamMessage, reason string, now time.Time) error {
	e.mu.Lock()
	defer e.mu.Unlock()
	e.audits = append(e.audits, AuditLogEntry{
		AuditEventID: msg.EventID,
		WorkspaceID:  msg.WorkspaceID,
		ActorID:      msg.ActorID,
		ActorType:    nonEmpty(msg.ActorType, "system"),
		Action:       "consumer.aborted:" + msg.EventType,
		ResourceType: msg.AggregateType,
		ResourceID:   msg.AggregateID,
		Reason:       reason,
		CreatedAt:    now,
	})
	return nil
}

// AuditEntries returns a snapshot of recorded audit log entries.
func (e *MemoryConsumerInboxEngine) AuditEntries() []AuditLogEntry {
	e.mu.Lock()
	defer e.mu.Unlock()
	cp := make([]AuditLogEntry, len(e.audits))
	copy(cp, e.audits)
	return cp
}

func nonEmpty(v, fallback string) string {
	if v != "" {
		return v
	}
	return fallback
}
