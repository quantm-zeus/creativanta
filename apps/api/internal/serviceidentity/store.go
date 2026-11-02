package serviceidentity

import (
	"context"
	"fmt"
	"sync"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

// Store defines persistence operations for API keys and daily usage metering.
type Store interface {
	InsertKey(ctx context.Context, key APIKey) error
	GetKeyByID(ctx context.Context, workspaceID, apiKeyID string) (*APIKey, error)
	GetKeyByHash(ctx context.Context, keyHash string) (*APIKey, error)
	ListKeysByWorkspace(ctx context.Context, workspaceID string) ([]APIKey, error)
	CountActiveKeys(ctx context.Context, workspaceID string) (int, error)
	UpdateKeyStatus(ctx context.Context, workspaceID, apiKeyID string, status Status, reason string, updatedAt time.Time) error
	RotateKey(ctx context.Context, oldKeyID string, newKey APIKey, graceEndsAt time.Time) error
	RecordUsage(ctx context.Context, workspaceID, apiKeyID string, date string, isWrite bool, isError bool, billableAICredits int) error
	GetUsage(ctx context.Context, workspaceID, apiKeyID string, startDate, endDate string) ([]UsageMetrics, error)
}

// MemoryStore provides a thread-safe in-memory store for unit testing and deterministic verification.
type MemoryStore struct {
	mu     sync.RWMutex
	keys   map[string]APIKey                   // key: apiKeyID
	byHash map[string]string                   // key: keyHash -> apiKeyID
	usage  map[string]map[string]*UsageMetrics // key: apiKeyID -> (date -> metrics)
}

// NewMemoryStore constructs a new MemoryStore.
func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		keys:   make(map[string]APIKey),
		byHash: make(map[string]string),
		usage:  make(map[string]map[string]*UsageMetrics),
	}
}

func (s *MemoryStore) InsertKey(_ context.Context, key APIKey) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	s.keys[key.APIKeyID] = key
	s.byHash[key.KeyHash] = key.APIKeyID
	return nil
}

func (s *MemoryStore) GetKeyByID(_ context.Context, workspaceID, apiKeyID string) (*APIKey, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	k, exists := s.keys[apiKeyID]
	if !exists || k.WorkspaceID != workspaceID {
		return nil, ErrKeyNotFound
	}
	cp := k
	return &cp, nil
}

func (s *MemoryStore) GetKeyByHash(_ context.Context, keyHash string) (*APIKey, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	id, exists := s.byHash[keyHash]
	if !exists {
		return nil, ErrKeyNotFound
	}
	k := s.keys[id]
	cp := k
	return &cp, nil
}

func (s *MemoryStore) ListKeysByWorkspace(_ context.Context, workspaceID string) ([]APIKey, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var result []APIKey
	for _, k := range s.keys {
		if k.WorkspaceID == workspaceID {
			result = append(result, k)
		}
	}
	return result, nil
}

func (s *MemoryStore) CountActiveKeys(_ context.Context, workspaceID string) (int, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	count := 0
	for _, k := range s.keys {
		if k.WorkspaceID == workspaceID && (k.Status == StatusActive || k.Status == StatusRotating) {
			count++
		}
	}
	return count, nil
}

func (s *MemoryStore) UpdateKeyStatus(_ context.Context, workspaceID, apiKeyID string, status Status, reason string, updatedAt time.Time) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	k, exists := s.keys[apiKeyID]
	if !exists || k.WorkspaceID != workspaceID {
		return ErrKeyNotFound
	}
	k.Status = status
	k.SuspendedReason = reason
	k.UpdatedAt = updatedAt
	s.keys[apiKeyID] = k
	return nil
}

func (s *MemoryStore) RotateKey(_ context.Context, oldKeyID string, newKey APIKey, graceEndsAt time.Time) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	old, exists := s.keys[oldKeyID]
	if !exists {
		return ErrKeyNotFound
	}
	old.Status = StatusRotating
	old.RotationGraceEndsAt = &graceEndsAt
	old.ReplacedByKeyID = newKey.APIKeyID
	old.UpdatedAt = newKey.CreatedAt
	s.keys[oldKeyID] = old

	s.keys[newKey.APIKeyID] = newKey
	s.byHash[newKey.KeyHash] = newKey.APIKeyID
	return nil
}

func (s *MemoryStore) RecordUsage(_ context.Context, workspaceID, apiKeyID string, date string, isWrite bool, isError bool, billableAICredits int) error {
	s.mu.Lock()
	defer s.mu.Unlock()

	k, exists := s.keys[apiKeyID]
	if exists {
		k.RequestCount++
		now := time.Now().UTC()
		k.LastUsedAt = &now
		s.keys[apiKeyID] = k
	}

	byDate, exists := s.usage[apiKeyID]
	if !exists {
		byDate = make(map[string]*UsageMetrics)
		s.usage[apiKeyID] = byDate
	}
	m, exists := byDate[date]
	if !exists {
		m = &UsageMetrics{
			WorkspaceID: workspaceID,
			APIKeyID:    apiKeyID,
			Date:        date,
		}
		byDate[date] = m
	}
	m.RequestCount++
	if isWrite {
		m.WriteCount++
	} else {
		m.ReadCount++
	}
	if isError {
		m.ErrorCount++
	}
	m.BillableAICredits += billableAICredits
	return nil
}

func (s *MemoryStore) GetUsage(_ context.Context, workspaceID, apiKeyID string, startDate, endDate string) ([]UsageMetrics, error) {
	s.mu.RLock()
	defer s.mu.RUnlock()

	var result []UsageMetrics
	byDate, exists := s.usage[apiKeyID]
	if !exists {
		return result, nil
	}
	for date, m := range byDate {
		if (startDate == "" || date >= startDate) && (endDate == "" || date <= endDate) {
			result = append(result, *m)
		}
	}
	return result, nil
}

// PgStore implements Store using real PostgreSQL via pgxpool.Pool.
type PgStore struct {
	pool *pgxpool.Pool
}

// NewPgStore creates a new PostgreSQL store for API keys.
func NewPgStore(pool *pgxpool.Pool) *PgStore {
	return &PgStore{pool: pool}
}

func (p *PgStore) InsertKey(ctx context.Context, key APIKey) error {
	query := `
		INSERT INTO api_keys (
			api_key_id, workspace_id, key_prefix, key_hash, name, scopes, status,
			logical_key_id, replaced_by_key_id, rotation_grace_ends_at, expires_at,
			created_by, created_at, updated_at
		) VALUES (
			$1::uuid, $2::uuid, $3, $4, $5, $6::jsonb, $7,
			$8::uuid, $9::uuid, $10, $11,
			$12::uuid, $13, $14
		)
	`
	var logicalKeyID, replacedByKeyID *string
	if key.LogicalKeyID != "" {
		logicalKeyID = &key.LogicalKeyID
	}
	if key.ReplacedByKeyID != "" {
		replacedByKeyID = &key.ReplacedByKeyID
	}

	_, err := p.pool.Exec(ctx, query,
		key.APIKeyID, key.WorkspaceID, key.KeyPrefix, key.KeyHash, key.Name, key.Scopes, key.Status,
		logicalKeyID, replacedByKeyID, key.RotationGraceEndsAt, key.ExpiresAt,
		key.CreatedBy, key.CreatedAt, key.UpdatedAt,
	)
	return err
}

func (p *PgStore) GetKeyByID(ctx context.Context, workspaceID, apiKeyID string) (*APIKey, error) {
	query := `
		SELECT api_key_id, workspace_id, key_prefix, key_hash, name, scopes, status,
		       logical_key_id, replaced_by_key_id, rotation_grace_ends_at, last_used_at,
		       request_count, expires_at, created_by, COALESCE(suspended_reason, ''),
		       created_at, updated_at
		FROM api_keys
		WHERE api_key_id = $1::uuid AND workspace_id = $2::uuid
	`
	row := p.pool.QueryRow(ctx, query, apiKeyID, workspaceID)
	return scanAPIKey(row)
}

func (p *PgStore) GetKeyByHash(ctx context.Context, keyHash string) (*APIKey, error) {
	query := `
		SELECT api_key_id, workspace_id, key_prefix, key_hash, name, scopes, status,
		       logical_key_id, replaced_by_key_id, rotation_grace_ends_at, last_used_at,
		       request_count, expires_at, created_by, COALESCE(suspended_reason, ''),
		       created_at, updated_at
		FROM api_keys
		WHERE key_hash = $1
	`
	row := p.pool.QueryRow(ctx, query, keyHash)
	return scanAPIKey(row)
}

func (p *PgStore) ListKeysByWorkspace(ctx context.Context, workspaceID string) ([]APIKey, error) {
	query := `
		SELECT api_key_id, workspace_id, key_prefix, key_hash, name, scopes, status,
		       logical_key_id, replaced_by_key_id, rotation_grace_ends_at, last_used_at,
		       request_count, expires_at, created_by, COALESCE(suspended_reason, ''),
		       created_at, updated_at
		FROM api_keys
		WHERE workspace_id = $1::uuid
		ORDER BY created_at DESC
	`
	rows, err := p.pool.Query(ctx, query, workspaceID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var keys []APIKey
	for rows.Next() {
		k, err := scanAPIKey(rows)
		if err != nil {
			return nil, err
		}
		keys = append(keys, *k)
	}
	return keys, rows.Err()
}

func (p *PgStore) CountActiveKeys(ctx context.Context, workspaceID string) (int, error) {
	query := `
		SELECT COUNT(*)
		FROM api_keys
		WHERE workspace_id = $1::uuid AND status IN ('active', 'rotating')
	`
	var count int
	err := p.pool.QueryRow(ctx, query, workspaceID).Scan(&count)
	return count, err
}

func (p *PgStore) UpdateKeyStatus(ctx context.Context, workspaceID, apiKeyID string, status Status, reason string, updatedAt time.Time) error {
	query := `
		UPDATE api_keys
		SET status = $1, suspended_reason = $2, updated_at = $3
		WHERE api_key_id = $4::uuid AND workspace_id = $5::uuid
	`
	tag, err := p.pool.Exec(ctx, query, status, reason, updatedAt, apiKeyID, workspaceID)
	if err != nil {
		return err
	}
	if tag.RowsAffected() == 0 {
		return ErrKeyNotFound
	}
	return nil
}

func (p *PgStore) RotateKey(ctx context.Context, oldKeyID string, newKey APIKey, graceEndsAt time.Time) error {
	tx, err := p.pool.Begin(ctx)
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)

	// Update old key to rotating
	updateQuery := `
		UPDATE api_keys
		SET status = 'rotating', rotation_grace_ends_at = $1, replaced_by_key_id = $2::uuid, updated_at = $3
		WHERE api_key_id = $4::uuid
	`
	tag, err := tx.Exec(ctx, updateQuery, graceEndsAt, newKey.APIKeyID, newKey.CreatedAt, oldKeyID)
	if err != nil {
		return err
	}
	if tag.RowsAffected() == 0 {
		return ErrKeyNotFound
	}

	// Insert new key
	insertQuery := `
		INSERT INTO api_keys (
			api_key_id, workspace_id, key_prefix, key_hash, name, scopes, status,
			logical_key_id, expires_at, created_by, created_at, updated_at
		) VALUES (
			$1::uuid, $2::uuid, $3, $4, $5, $6::jsonb, $7,
			$8::uuid, $9, $10::uuid, $11, $12
		)
	`
	var logicalKeyID *string
	if newKey.LogicalKeyID != "" {
		logicalKeyID = &newKey.LogicalKeyID
	}

	_, err = tx.Exec(ctx, insertQuery,
		newKey.APIKeyID, newKey.WorkspaceID, newKey.KeyPrefix, newKey.KeyHash, newKey.Name, newKey.Scopes, newKey.Status,
		logicalKeyID, newKey.ExpiresAt, newKey.CreatedBy, newKey.CreatedAt, newKey.UpdatedAt,
	)
	if err != nil {
		return err
	}

	return tx.Commit(ctx)
}

func (p *PgStore) RecordUsage(ctx context.Context, workspaceID, apiKeyID string, date string, isWrite bool, isError bool, billableAICredits int) error {
	tx, err := p.pool.Begin(ctx)
	if err != nil {
		return err
	}
	defer tx.Rollback(ctx)

	// Update last_used_at and request_count on api_keys
	_, err = tx.Exec(ctx, `
		UPDATE api_keys
		SET request_count = request_count + 1, last_used_at = NOW(), updated_at = NOW()
		WHERE api_key_id = $1::uuid
	`, apiKeyID)
	if err != nil {
		return err
	}

	readInc := 1
	writeInc := 0
	if isWrite {
		readInc = 0
		writeInc = 1
	}
	errorInc := 0
	if isError {
		errorInc = 1
	}

	// Upsert into api_usage_daily
	upsertQuery := `
		INSERT INTO api_usage_daily (
			workspace_id, api_key_id, usage_date, request_count, read_count, write_count, error_count, billable_ai_credits, created_at, updated_at
		) VALUES (
			$1::uuid, $2::uuid, $3::date, 1, $4, $5, $6, $7, NOW(), NOW()
		)
		ON CONFLICT (workspace_id, api_key_id, usage_date) DO UPDATE SET
			request_count = api_usage_daily.request_count + 1,
			read_count = api_usage_daily.read_count + EXCLUDED.read_count,
			write_count = api_usage_daily.write_count + EXCLUDED.write_count,
			error_count = api_usage_daily.error_count + EXCLUDED.error_count,
			billable_ai_credits = api_usage_daily.billable_ai_credits + EXCLUDED.billable_ai_credits,
			updated_at = NOW()
	`
	_, err = tx.Exec(ctx, upsertQuery, workspaceID, apiKeyID, date, readInc, writeInc, errorInc, billableAICredits)
	if err != nil {
		return err
	}

	return tx.Commit(ctx)
}

func (p *PgStore) GetUsage(ctx context.Context, workspaceID, apiKeyID string, startDate, endDate string) ([]UsageMetrics, error) {
	query := `
		SELECT workspace_id, api_key_id, usage_date::text, request_count, read_count, write_count, error_count, billable_ai_credits
		FROM api_usage_daily
		WHERE workspace_id = $1::uuid AND api_key_id = $2::uuid
		  AND ($3 = '' OR usage_date >= $3::date)
		  AND ($4 = '' OR usage_date <= $4::date)
		ORDER BY usage_date ASC
	`
	rows, err := p.pool.Query(ctx, query, workspaceID, apiKeyID, startDate, endDate)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var result []UsageMetrics
	for rows.Next() {
		var m UsageMetrics
		err := rows.Scan(
			&m.WorkspaceID, &m.APIKeyID, &m.Date, &m.RequestCount,
			&m.ReadCount, &m.WriteCount, &m.ErrorCount, &m.BillableAICredits,
		)
		if err != nil {
			return nil, err
		}
		result = append(result, m)
	}
	return result, rows.Err()
}

type rowScanner interface {
	Scan(dest ...any) error
}

func scanAPIKey(row rowScanner) (*APIKey, error) {
	var k APIKey
	var logicalKeyID, replacedByKeyID *string
	err := row.Scan(
		&k.APIKeyID, &k.WorkspaceID, &k.KeyPrefix, &k.KeyHash, &k.Name, &k.Scopes, &k.Status,
		&logicalKeyID, &replacedByKeyID, &k.RotationGraceEndsAt, &k.LastUsedAt,
		&k.RequestCount, &k.ExpiresAt, &k.CreatedBy, &k.SuspendedReason,
		&k.CreatedAt, &k.UpdatedAt,
	)
	if err != nil {
		if err == pgx.ErrNoRows {
			return nil, ErrKeyNotFound
		}
		return nil, fmt.Errorf("scan api_key: %w", err)
	}
	if logicalKeyID != nil {
		k.LogicalKeyID = *logicalKeyID
	}
	if replacedByKeyID != nil {
		k.ReplacedByKeyID = *replacedByKeyID
	}
	return &k, nil
}
