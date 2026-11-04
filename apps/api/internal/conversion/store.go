package conversion

import (
	"context"
	"errors"
	"fmt"
	"sync"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

var (
	ErrLineageNotFound = errors.New("conversion: lineage record not found")
)

// LineageStore defines persistence for cross-domain conversions and shared lineage.
type LineageStore interface {
	SaveLineage(ctx context.Context, record LineageRecord) error
	GetLineage(ctx context.Context, workspaceID, conversionID string) (*LineageRecord, error)
	ListLineageBySource(ctx context.Context, workspaceID string, sourceType SourceType, sourceID string) ([]LineageRecord, error)
	ListLineageByTarget(ctx context.Context, workspaceID string, targetType TargetType, targetID string) ([]LineageRecord, error)
	ListWorkspaceLineage(ctx context.Context, workspaceID string) ([]LineageRecord, error)
	DeleteLineage(ctx context.Context, workspaceID, conversionID string) error
}

// MemoryLineageStore provides thread-safe in-memory storage for lineage records.
type MemoryLineageStore struct {
	mu      sync.RWMutex
	records map[string]LineageRecord // key: workspaceID + ":" + conversionID
}

// NewMemoryLineageStore creates an initialized in-memory lineage store.
func NewMemoryLineageStore() *MemoryLineageStore {
	return &MemoryLineageStore{
		records: make(map[string]LineageRecord),
	}
}

func (m *MemoryLineageStore) key(wsID, convID string) string {
	return wsID + ":" + convID
}

func (m *MemoryLineageStore) SaveLineage(ctx context.Context, record LineageRecord) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	if record.ConversionID == "" {
		record.ConversionID = NewUUID()
	}
	if record.CreatedAt.IsZero() {
		record.CreatedAt = time.Now().UTC()
	}
	record.UpdatedAt = time.Now().UTC()

	m.records[m.key(record.WorkspaceID, record.ConversionID)] = record
	return nil
}

func (m *MemoryLineageStore) GetLineage(ctx context.Context, workspaceID, conversionID string) (*LineageRecord, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	rec, ok := m.records[m.key(workspaceID, conversionID)]
	if !ok {
		return nil, ErrLineageNotFound
	}
	cpy := rec
	return &cpy, nil
}

func (m *MemoryLineageStore) ListLineageBySource(ctx context.Context, workspaceID string, sourceType SourceType, sourceID string) ([]LineageRecord, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []LineageRecord
	for _, rec := range m.records {
		if rec.WorkspaceID == workspaceID && rec.SourceType == sourceType && rec.SourceID == sourceID {
			result = append(result, rec)
		}
	}
	return result, nil
}

func (m *MemoryLineageStore) ListLineageByTarget(ctx context.Context, workspaceID string, targetType TargetType, targetID string) ([]LineageRecord, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []LineageRecord
	for _, rec := range m.records {
		if rec.WorkspaceID == workspaceID && rec.TargetType == targetType && rec.TargetID == targetID {
			result = append(result, rec)
		}
	}
	return result, nil
}

func (m *MemoryLineageStore) ListWorkspaceLineage(ctx context.Context, workspaceID string) ([]LineageRecord, error) {
	m.mu.RLock()
	defer m.mu.RUnlock()

	var result []LineageRecord
	for _, rec := range m.records {
		if rec.WorkspaceID == workspaceID {
			result = append(result, rec)
		}
	}
	return result, nil
}

func (m *MemoryLineageStore) DeleteLineage(ctx context.Context, workspaceID, conversionID string) error {
	m.mu.Lock()
	defer m.mu.Unlock()

	delete(m.records, m.key(workspaceID, conversionID))
	return nil
}

// PostgresLineageStore implements LineageStore against PostgreSQL table cross_domain_conversions.
type PostgresLineageStore struct {
	pool *pgxpool.Pool
}

func NewPostgresLineageStore(pool *pgxpool.Pool) *PostgresLineageStore {
	return &PostgresLineageStore{pool: pool}
}

func (p *PostgresLineageStore) SaveLineage(ctx context.Context, record LineageRecord) error {
	if p.pool == nil {
		return fmt.Errorf("postgres pool not configured")
	}

	query := `
		INSERT INTO cross_domain_conversions (
			conversion_id, workspace_id, source_type, source_id,
			target_type, target_id, converted_by, status,
			lineage_depth, root_source_type, root_source_id, metadata,
			created_at, updated_at
		) VALUES (
			$1, $2, $3, $4,
			$5, $6, $7, $8,
			$9, $10, $11, $12,
			$13, $14
		)
		ON CONFLICT (workspace_id, conversion_id) DO UPDATE SET
			status = EXCLUDED.status,
			metadata = EXCLUDED.metadata,
			updated_at = EXCLUDED.updated_at
	`

	if record.ConversionID == "" {
		record.ConversionID = NewUUID()
	}
	now := time.Now().UTC()
	if record.CreatedAt.IsZero() {
		record.CreatedAt = now
	}
	record.UpdatedAt = now

	_, err := p.pool.Exec(ctx, query,
		record.ConversionID, record.WorkspaceID, string(record.SourceType), record.SourceID,
		string(record.TargetType), record.TargetID, record.ConvertedBy, record.Status,
		record.LineageDepth, record.RootSourceType, record.RootSourceID, record.Metadata,
		record.CreatedAt, record.UpdatedAt,
	)
	return err
}

func (p *PostgresLineageStore) GetLineage(ctx context.Context, workspaceID, conversionID string) (*LineageRecord, error) {
	if p.pool == nil {
		return nil, fmt.Errorf("postgres pool not configured")
	}

	query := `
		SELECT conversion_id, workspace_id, source_type, source_id,
		       target_type, target_id, converted_by, status,
		       lineage_depth, root_source_type, root_source_id, metadata,
		       created_at, updated_at
		FROM cross_domain_conversions
		WHERE workspace_id = $1 AND conversion_id = $2
	`

	var rec LineageRecord
	var srcType, tgtType string
	err := p.pool.QueryRow(ctx, query, workspaceID, conversionID).Scan(
		&rec.ConversionID, &rec.WorkspaceID, &srcType, &rec.SourceID,
		&tgtType, &rec.TargetID, &rec.ConvertedBy, &rec.Status,
		&rec.LineageDepth, &rec.RootSourceType, &rec.RootSourceID, &rec.Metadata,
		&rec.CreatedAt, &rec.UpdatedAt,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrLineageNotFound
		}
		return nil, err
	}
	rec.SourceType = SourceType(srcType)
	rec.TargetType = TargetType(tgtType)
	return &rec, nil
}

func (p *PostgresLineageStore) ListLineageBySource(ctx context.Context, workspaceID string, sourceType SourceType, sourceID string) ([]LineageRecord, error) {
	if p.pool == nil {
		return nil, fmt.Errorf("postgres pool not configured")
	}

	query := `
		SELECT conversion_id, workspace_id, source_type, source_id,
		       target_type, target_id, converted_by, status,
		       lineage_depth, root_source_type, root_source_id, metadata,
		       created_at, updated_at
		FROM cross_domain_conversions
		WHERE workspace_id = $1 AND source_type = $2 AND source_id = $3
		ORDER BY created_at DESC
	`

	rows, err := p.pool.Query(ctx, query, workspaceID, string(sourceType), sourceID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var records []LineageRecord
	for rows.Next() {
		var rec LineageRecord
		var srcType, tgtType string
		if err := rows.Scan(
			&rec.ConversionID, &rec.WorkspaceID, &srcType, &rec.SourceID,
			&tgtType, &rec.TargetID, &rec.ConvertedBy, &rec.Status,
			&rec.LineageDepth, &rec.RootSourceType, &rec.RootSourceID, &rec.Metadata,
			&rec.CreatedAt, &rec.UpdatedAt,
		); err != nil {
			return nil, err
		}
		rec.SourceType = SourceType(srcType)
		rec.TargetType = TargetType(tgtType)
		records = append(records, rec)
	}
	return records, rows.Err()
}

func (p *PostgresLineageStore) ListLineageByTarget(ctx context.Context, workspaceID string, targetType TargetType, targetID string) ([]LineageRecord, error) {
	if p.pool == nil {
		return nil, fmt.Errorf("postgres pool not configured")
	}

	query := `
		SELECT conversion_id, workspace_id, source_type, source_id,
		       target_type, target_id, converted_by, status,
		       lineage_depth, root_source_type, root_source_id, metadata,
		       created_at, updated_at
		FROM cross_domain_conversions
		WHERE workspace_id = $1 AND target_type = $2 AND target_id = $3
		ORDER BY created_at DESC
	`

	rows, err := p.pool.Query(ctx, query, workspaceID, string(targetType), targetID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var records []LineageRecord
	for rows.Next() {
		var rec LineageRecord
		var srcType, tgtType string
		if err := rows.Scan(
			&rec.ConversionID, &rec.WorkspaceID, &srcType, &rec.SourceID,
			&tgtType, &rec.TargetID, &rec.ConvertedBy, &rec.Status,
			&rec.LineageDepth, &rec.RootSourceType, &rec.RootSourceID, &rec.Metadata,
			&rec.CreatedAt, &rec.UpdatedAt,
		); err != nil {
			return nil, err
		}
		rec.SourceType = SourceType(srcType)
		rec.TargetType = TargetType(tgtType)
		records = append(records, rec)
	}
	return records, rows.Err()
}

func (p *PostgresLineageStore) ListWorkspaceLineage(ctx context.Context, workspaceID string) ([]LineageRecord, error) {
	if p.pool == nil {
		return nil, fmt.Errorf("postgres pool not configured")
	}

	query := `
		SELECT conversion_id, workspace_id, source_type, source_id,
		       target_type, target_id, converted_by, status,
		       lineage_depth, root_source_type, root_source_id, metadata,
		       created_at, updated_at
		FROM cross_domain_conversions
		WHERE workspace_id = $1
		ORDER BY created_at DESC
	`

	rows, err := p.pool.Query(ctx, query, workspaceID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var records []LineageRecord
	for rows.Next() {
		var rec LineageRecord
		var srcType, tgtType string
		if err := rows.Scan(
			&rec.ConversionID, &rec.WorkspaceID, &srcType, &rec.SourceID,
			&tgtType, &rec.TargetID, &rec.ConvertedBy, &rec.Status,
			&rec.LineageDepth, &rec.RootSourceType, &rec.RootSourceID, &rec.Metadata,
			&rec.CreatedAt, &rec.UpdatedAt,
		); err != nil {
			return nil, err
		}
		rec.SourceType = SourceType(srcType)
		rec.TargetType = TargetType(tgtType)
		records = append(records, rec)
	}
	return records, rows.Err()
}

func (p *PostgresLineageStore) DeleteLineage(ctx context.Context, workspaceID, conversionID string) error {
	if p.pool == nil {
		return fmt.Errorf("postgres pool not configured")
	}

	query := `
		DELETE FROM cross_domain_conversions
		WHERE workspace_id = $1 AND conversion_id = $2
	`
	_, err := p.pool.Exec(ctx, query, workspaceID, conversionID)
	return err
}
