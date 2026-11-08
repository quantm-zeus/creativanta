package outbox

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

const (
	// DefaultOutboxLeaseDuration is the canonical 30-second outbox poller lease window.
	DefaultOutboxLeaseDuration = 30 * time.Second
	// DefaultOutboxBatchSize is the default batch size for FOR UPDATE SKIP LOCKED polling.
	DefaultOutboxBatchSize = 100
)

var (
	// ErrInvalidOutboxEnvelope is returned when an outbox event fails validation.
	ErrInvalidOutboxEnvelope = errors.New("outbox: invalid domain event envelope")
	// ErrCredentialLeakBlocked is returned when an outbox event payload or metadata contains a forbidden secret key.
	ErrCredentialLeakBlocked = errors.New("outbox: forbidden credential or token field in outbox payload")
	// ErrStaleOutboxLease is returned when a poller attempts to mark published after its lease was reclaimed.
	ErrStaleOutboxLease = errors.New("outbox: lease ownership lost before mark published")
)

var forbiddenSecretKeys = map[string]struct{}{
	"access_token":         {},
	"refresh_token":        {},
	"client_secret":        {},
	"api_key_secret":       {},
	"signing_secret":       {},
	"signing_secret_plain": {},
	"password_hash":        {},
	"private_key":          {},
	"secret_key":           {},
	"authorization":        {},
	"mfa_secret":           {},
}

// DomainEventEnvelope models the canonical event envelope from docs/04_contracts/domain_event_catalog.md §1.
type DomainEventEnvelope struct {
	EventID       string          `json:"event_id"`
	EventType     string          `json:"event_type"`
	TargetStream  QueueName       `json:"target_stream"`
	AggregateType string          `json:"aggregate_type"`
	AggregateID   string          `json:"aggregate_id"`
	WorkspaceID   string          `json:"workspace_id"`
	ActorID       string          `json:"actor_id"`
	ActorType     string          `json:"actor_type"`
	OccurredAt    time.Time       `json:"occurred_at"`
	SchemaVersion int             `json:"schema_version"`
	CorrelationID string          `json:"correlation_id"`
	CausationID   string          `json:"causation_id,omitempty"`
	Payload       json.RawMessage `json:"payload"`
	Metadata      json.RawMessage `json:"metadata,omitempty"`
}

// ValidateOutboxEnvelope validates a DomainEventEnvelope before inserting into event_outbox.
// It enforces valid UUIDs, a canonical target_stream, and scans JSON keys to reject credential leaks.
func ValidateOutboxEnvelope(env DomainEventEnvelope) error {
	if !tenantdb.IsValidNonZeroUUID(env.EventID) {
		return fmt.Errorf("%w: invalid event_id %q", ErrInvalidOutboxEnvelope, env.EventID)
	}
	if strings.TrimSpace(env.EventType) == "" {
		return fmt.Errorf("%w: event_type is required", ErrInvalidOutboxEnvelope)
	}
	if _, ok := GetQueueSpec(env.TargetStream); !ok {
		return fmt.Errorf("%w: target_stream %q is not a canonical queue", ErrInvalidOutboxEnvelope, env.TargetStream)
	}
	if strings.TrimSpace(env.AggregateType) == "" {
		return fmt.Errorf("%w: aggregate_type is required", ErrInvalidOutboxEnvelope)
	}
	if !tenantdb.IsValidNonZeroUUID(env.AggregateID) {
		return fmt.Errorf("%w: invalid aggregate_id %q", ErrInvalidOutboxEnvelope, env.AggregateID)
	}
	if !tenantdb.IsValidNonZeroUUID(env.WorkspaceID) {
		return fmt.Errorf("%w: invalid workspace_id %q", ErrInvalidOutboxEnvelope, env.WorkspaceID)
	}
	if err := rejectForbiddenSecretKeys(env.Payload); err != nil {
		return err
	}
	if len(env.Metadata) > 0 {
		if err := rejectForbiddenSecretKeys(env.Metadata); err != nil {
			return err
		}
	}
	return nil
}

func rejectForbiddenSecretKeys(raw []byte) error {
	if len(raw) == 0 {
		return nil
	}
	var decoded any
	if err := json.Unmarshal(raw, &decoded); err != nil {
		return fmt.Errorf("%w: malformed JSON payload: %v", ErrInvalidOutboxEnvelope, err)
	}
	return scanJSONForSecrets(decoded)
}

func scanJSONForSecrets(v any) error {
	switch val := v.(type) {
	case map[string]any:
		for k, child := range val {
			normalized := strings.ToLower(strings.TrimSpace(k))
			if _, bad := forbiddenSecretKeys[normalized]; bad {
				return fmt.Errorf("%w: key %q is prohibited in outbox event", ErrCredentialLeakBlocked, k)
			}
			if err := scanJSONForSecrets(child); err != nil {
				return err
			}
		}
	case []any:
		for _, item := range val {
			if err := scanJSONForSecrets(item); err != nil {
				return err
			}
		}
	}
	return nil
}

// OutboxRow represents a persisted row in event_outbox (§18.4H).
type OutboxRow struct {
	OutboxID      int64
	EventID       string
	EventType     string
	TargetStream  QueueName
	AggregateType string
	AggregateID   string
	WorkspaceID   string
	Payload       json.RawMessage
	Metadata      json.RawMessage
	Published     bool
	PublishedAt   *time.Time
	LeaseOwner    string
	LeaseUntil    *time.Time
	AttemptCount  int
	NextAttemptAt time.Time
	CreatedAt     time.Time
}

// OutboxStore defines the storage contract for the outbox poller.
type OutboxStore interface {
	ClaimBatch(ctx context.Context, pollerID string, now time.Time, leaseDuration time.Duration, limit int) ([]OutboxRow, error)
	MarkPublished(ctx context.Context, outboxID int64, pollerID string, publishedAt time.Time) error
	ReleaseForRetry(ctx context.Context, outboxID int64, pollerID string, nextAttemptAt time.Time) error
}

// PollerFaultHooks allows deterministic crash/kill simulation at each transaction and broker boundary.
type PollerFaultHooks struct {
	AfterClaimBeforePublish     func(row OutboxRow) error
	AfterPublishBeforeMarkSaved func(row OutboxRow, streamEntryID string) error
}

// PollBatchResult summarizes one PollOnce execution.
type PollBatchResult struct {
	ClaimedCount   int
	PublishedCount int
	RetriedCount   int
}

// OutboxPoller polls unpublished rows from event_outbox using a 30s lease and publishes them to StreamBroker.
type OutboxPoller struct {
	PollerID      string
	Store         OutboxStore
	Broker        StreamBroker
	LeaseDuration time.Duration
	BatchSize     int
	Faults        PollerFaultHooks
}

// NewOutboxPoller creates an OutboxPoller with canonical defaults.
func NewOutboxPoller(pollerID string, store OutboxStore, broker StreamBroker) *OutboxPoller {
	return &OutboxPoller{
		PollerID:      pollerID,
		Store:         store,
		Broker:        broker,
		LeaseDuration: DefaultOutboxLeaseDuration,
		BatchSize:     DefaultOutboxBatchSize,
	}
}

// PollOnce claims a batch of unpublished outbox rows, publishes each to Redis Streams (XADD),
// and marks each row published iff the poller still holds the lease.
func (p *OutboxPoller) PollOnce(ctx context.Context, now time.Time) (PollBatchResult, error) {
	leaseDur := p.LeaseDuration
	if leaseDur <= 0 {
		leaseDur = DefaultOutboxLeaseDuration
	}
	batchSize := p.BatchSize
	if batchSize <= 0 {
		batchSize = DefaultOutboxBatchSize
	}

	claimed, err := p.Store.ClaimBatch(ctx, p.PollerID, now, leaseDur, batchSize)
	if err != nil {
		return PollBatchResult{}, err
	}

	res := PollBatchResult{ClaimedCount: len(claimed)}
	for _, row := range claimed {
		if p.Faults.AfterClaimBeforePublish != nil {
			if faultErr := p.Faults.AfterClaimBeforePublish(row); faultErr != nil {
				return res, faultErr
			}
		}

		msg := StreamMessage{
			EventID:       row.EventID,
			EventType:     row.EventType,
			TargetStream:  row.TargetStream,
			AggregateType: row.AggregateType,
			AggregateID:   row.AggregateID,
			WorkspaceID:   row.WorkspaceID,
			Payload:       row.Payload,
			Metadata:      stripBrokerMetadata(row.Metadata),
			PublishedAt:   now,
		}
		populateEnvelopeAuthFields(&msg, row.Metadata, row.Payload)
		entryID, pubErr := p.Broker.XAdd(ctx, row.TargetStream, msg)
		if pubErr != nil {
			backoff := time.Duration(1<<minInt(row.AttemptCount, 5)) * time.Second
			_ = p.Store.ReleaseForRetry(ctx, row.OutboxID, p.PollerID, now.Add(backoff))
			res.RetriedCount++
			continue
		}

		if p.Faults.AfterPublishBeforeMarkSaved != nil {
			if faultErr := p.Faults.AfterPublishBeforeMarkSaved(row, entryID); faultErr != nil {
				return res, faultErr
			}
		}

		if err := p.Store.MarkPublished(ctx, row.OutboxID, p.PollerID, now); err != nil {
			return res, err
		}
		res.PublishedCount++
	}
	return res, nil
}

func minInt(a, b int) int {
	if a < b {
		return a
	}
	return b
}

// =============================================================================
// PostgreSQL OutboxStore implementation (runs as outbox_poller role)
// =============================================================================

// PgOutboxStore implements OutboxStore on PostgreSQL using the dedicated outbox_poller role.
type PgOutboxStore struct {
	db      tenantdb.TxBeginner
	setRole bool
}

// NewPgOutboxStore constructs a PgOutboxStore. When setOutboxPollerRole is true,
// each transaction executes SET LOCAL ROLE outbox_poller before touching event_outbox.
func NewPgOutboxStore(db tenantdb.TxBeginner, setOutboxPollerRole bool) *PgOutboxStore {
	return &PgOutboxStore{
		db:      db,
		setRole: setOutboxPollerRole,
	}
}

const claimOutboxBatchSQL = `
WITH candidates AS (
  SELECT outbox_id
  FROM event_outbox
  WHERE published = false
    AND next_attempt_at <= $2
    AND (lease_until IS NULL OR lease_until < $2)
  ORDER BY created_at ASC, outbox_id ASC
  LIMIT $4
  FOR UPDATE SKIP LOCKED
)
UPDATE event_outbox o
SET
  lease_owner = $1,
  lease_until = $3,
  attempt_count = o.attempt_count + 1
FROM candidates c
WHERE o.outbox_id = c.outbox_id
RETURNING
  o.outbox_id, o.event_id::text, o.event_type, o.target_stream,
  o.aggregate_type, o.aggregate_id::text, COALESCE(o.workspace_id::text, ''),
  o.payload, COALESCE(o.metadata, '{}'::jsonb), o.published, o.published_at,
  COALESCE(o.lease_owner, ''), o.lease_until, o.attempt_count,
  o.next_attempt_at, o.created_at
`

// ClaimBatch atomically claims up to limit unpublished rows whose lease is nil or expired.
func (s *PgOutboxStore) ClaimBatch(ctx context.Context, pollerID string, now time.Time, leaseDuration time.Duration, limit int) ([]OutboxRow, error) {
	tx, err := s.db.Begin(ctx)
	if err != nil {
		return nil, err
	}
	defer func() { _ = tx.Rollback(ctx) }()

	if s.setRole {
		if _, err := tx.Exec(ctx, `SET LOCAL ROLE outbox_poller`); err != nil {
			return nil, fmt.Errorf("outbox: SET LOCAL ROLE outbox_poller: %w", err)
		}
	}

	leaseUntil := now.Add(leaseDuration)
	rows, err := tx.Query(ctx, claimOutboxBatchSQL, pollerID, now, leaseUntil, limit)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var claimed []OutboxRow
	for rows.Next() {
		var r OutboxRow
		var stream string
		if err := rows.Scan(
			&r.OutboxID,
			&r.EventID,
			&r.EventType,
			&stream,
			&r.AggregateType,
			&r.AggregateID,
			&r.WorkspaceID,
			&r.Payload,
			&r.Metadata,
			&r.Published,
			&r.PublishedAt,
			&r.LeaseOwner,
			&r.LeaseUntil,
			&r.AttemptCount,
			&r.NextAttemptAt,
			&r.CreatedAt,
		); err != nil {
			return nil, err
		}
		r.TargetStream = QueueName(stream)
		claimed = append(claimed, r)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	if err := tx.Commit(ctx); err != nil {
		return nil, err
	}
	for i := range claimed {
		enrichClaimedOutboxRow(ctx, s.db, s.setRole, &claimed[i])
	}
	return claimed, nil
}

const markOutboxPublishedSQL = `
UPDATE event_outbox
SET
  published = true,
  published_at = $3,
  lease_owner = NULL,
  lease_until = NULL
WHERE outbox_id = $1
  AND lease_owner = $2
  AND published = false
`

// MarkPublished marks a claimed outbox row published only if pollerID still owns the lease.
func (s *PgOutboxStore) MarkPublished(ctx context.Context, outboxID int64, pollerID string, publishedAt time.Time) error {
	tx, err := s.db.Begin(ctx)
	if err != nil {
		return err
	}
	defer func() { _ = tx.Rollback(ctx) }()

	if s.setRole {
		if _, err := tx.Exec(ctx, `SET LOCAL ROLE outbox_poller`); err != nil {
			return err
		}
	}
	tag, err := tx.Exec(ctx, markOutboxPublishedSQL, outboxID, pollerID, publishedAt)
	if err != nil {
		return err
	}
	if tag.RowsAffected() == 0 {
		return fmt.Errorf("%w: outbox_id=%d poller=%s", ErrStaleOutboxLease, outboxID, pollerID)
	}
	return tx.Commit(ctx)
}

const releaseOutboxForRetrySQL = `
UPDATE event_outbox
SET
  lease_owner = NULL,
  lease_until = NULL,
  next_attempt_at = $3
WHERE outbox_id = $1
  AND lease_owner = $2
  AND published = false
`

// ReleaseForRetry releases the current lease and schedules the next attempt timestamp.
func (s *PgOutboxStore) ReleaseForRetry(ctx context.Context, outboxID int64, pollerID string, nextAttemptAt time.Time) error {
	tx, err := s.db.Begin(ctx)
	if err != nil {
		return err
	}
	defer func() { _ = tx.Rollback(ctx) }()

	if s.setRole {
		if _, err := tx.Exec(ctx, `SET LOCAL ROLE outbox_poller`); err != nil {
			return err
		}
	}
	if _, err := tx.Exec(ctx, releaseOutboxForRetrySQL, outboxID, pollerID, nextAttemptAt); err != nil {
		return err
	}
	return tx.Commit(ctx)
}

// =============================================================================
// In-Memory OutboxStore (for deterministic crash/lease/concurrency tests)
// =============================================================================

// MemoryOutboxStore is a thread-safe in-memory OutboxStore that mirrors PostgreSQL FOR UPDATE SKIP LOCKED semantics.
type MemoryOutboxStore struct {
	mu     sync.Mutex
	nextID int64
	rows   []*OutboxRow
}

// NewMemoryOutboxStore constructs an empty MemoryOutboxStore.
func NewMemoryOutboxStore() *MemoryOutboxStore {
	return &MemoryOutboxStore{nextID: 1}
}

// Enqueue validates and appends a DomainEventEnvelope to the outbox.
func (m *MemoryOutboxStore) Enqueue(env DomainEventEnvelope, now time.Time) (OutboxRow, error) {
	if err := ValidateOutboxEnvelope(env); err != nil {
		return OutboxRow{}, err
	}
	m.mu.Lock()
	defer m.mu.Unlock()

	for _, existing := range m.rows {
		if existing.EventID == env.EventID {
			return OutboxRow{}, fmt.Errorf("outbox: duplicate event_id %s", env.EventID)
		}
	}

	row := &OutboxRow{
		OutboxID:      m.nextID,
		EventID:       env.EventID,
		EventType:     env.EventType,
		TargetStream:  env.TargetStream,
		AggregateType: env.AggregateType,
		AggregateID:   env.AggregateID,
		WorkspaceID:   env.WorkspaceID,
		Payload:       append(json.RawMessage(nil), env.Payload...),
		Metadata:      append(json.RawMessage(nil), env.Metadata...),
		Published:     false,
		AttemptCount:  0,
		NextAttemptAt: now,
		CreatedAt:     now,
	}
	m.nextID++
	m.rows = append(m.rows, row)
	return *row, nil
}

// ClaimBatch claims up to limit unpublished rows whose lease is nil or expired at time now.
func (m *MemoryOutboxStore) ClaimBatch(_ context.Context, pollerID string, now time.Time, leaseDuration time.Duration, limit int) ([]OutboxRow, error) {
	m.mu.Lock()
	defer m.mu.Unlock()

	var claimed []OutboxRow
	leaseUntil := now.Add(leaseDuration)
	for _, r := range m.rows {
		if len(claimed) >= limit {
			break
		}
		if r.Published {
			continue
		}
		if now.Before(r.NextAttemptAt) {
			continue
		}
		if r.LeaseUntil != nil && !now.After(*r.LeaseUntil) {
			continue
		}
		lu := leaseUntil
		r.LeaseOwner = pollerID
		r.LeaseUntil = &lu
		r.AttemptCount++
		cp := *r
		claimed = append(claimed, cp)
	}
	return claimed, nil
}

// MarkPublished marks outboxID published only if pollerID still holds the lease and it is not yet published.
func (m *MemoryOutboxStore) MarkPublished(_ context.Context, outboxID int64, pollerID string, publishedAt time.Time) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	for _, r := range m.rows {
		if r.OutboxID == outboxID {
			if r.Published {
				return nil
			}
			if r.LeaseOwner != pollerID {
				return fmt.Errorf("%w: outbox_id=%d expected_owner=%s actual_owner=%s",
					ErrStaleOutboxLease, outboxID, pollerID, r.LeaseOwner)
			}
			ts := publishedAt
			r.Published = true
			r.PublishedAt = &ts
			r.LeaseOwner = ""
			r.LeaseUntil = nil
			return nil
		}
	}
	return pgx.ErrNoRows
}

// ReleaseForRetry releases a lease and sets next_attempt_at.
func (m *MemoryOutboxStore) ReleaseForRetry(_ context.Context, outboxID int64, pollerID string, nextAttemptAt time.Time) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	for _, r := range m.rows {
		if r.OutboxID == outboxID && !r.Published && r.LeaseOwner == pollerID {
			r.LeaseOwner = ""
			r.LeaseUntil = nil
			r.NextAttemptAt = nextAttemptAt
			return nil
		}
	}
	return nil
}

// Snapshot returns a copy of all rows for inspection in tests.
func (m *MemoryOutboxStore) Snapshot() []OutboxRow {
	m.mu.Lock()
	defer m.mu.Unlock()
	out := make([]OutboxRow, len(m.rows))
	for i, r := range m.rows {
		out[i] = *r
	}
	return out
}
