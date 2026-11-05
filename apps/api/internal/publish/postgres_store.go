package publish

import (
	"context"
	"database/sql"
	"encoding/json"
	"errors"
	"fmt"
	"regexp"
	"strings"
	"sync"
	"time"
)

var pgUUIDRegex = regexp.MustCompile(`^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$`)

func isValidPGUUID(val string) bool {
	v := strings.TrimSpace(val)
	return v != "" && v != "00000000-0000-0000-0000-000000000000" && pgUUIDRegex.MatchString(v)
}

func nullableUUID(val string) any {
	if isValidPGUUID(val) {
		return strings.TrimSpace(val)
	}
	return nil
}

func formatUUIDArrayLiteral(vals []string) string {
	var valid []string
	for _, v := range vals {
		if isValidPGUUID(v) {
			valid = append(valid, strings.TrimSpace(v))
		}
	}
	if len(valid) == 0 {
		return "{}"
	}
	return "{" + strings.Join(valid, ",") + "}"
}

func parseUUIDArrayLiteral(raw string) []string {
	trimmed := strings.TrimSpace(raw)
	trimmed = strings.TrimPrefix(trimmed, "{")
	trimmed = strings.TrimSuffix(trimmed, "}")
	if trimmed == "" {
		return []string{}
	}
	parts := strings.Split(trimmed, ",")
	out := make([]string, 0, len(parts))
	for _, p := range parts {
		clean := strings.Trim(strings.TrimSpace(p), `"`)
		if clean != "" && clean != "NULL" {
			out = append(out, clean)
		}
	}
	return out
}

func isOperatorModeEnum(val string) bool {
	switch val {
	case "creator", "seller", "affiliate_operator", "live_operator", "agency_mcn", "brand_collaboration":
		return true
	default:
		return false
	}
}

// PostgresStore persists Publish Hub state (publish_items, publish_jobs, publish_logs,
// channel_posts, external_effects, event_outbox) inside tenant-scoped transactions
// with SET LOCAL app.current_tenant_id (migrations 00001, 00002, 00026).
type PostgresStore struct {
	db             *sql.DB
	mu             sync.RWMutex
	pausedAccounts map[string]string
}

// NewPostgresStore creates a durable PostgreSQL-backed Publish store.
func NewPostgresStore(db *sql.DB) *PostgresStore {
	return &PostgresStore{
		db:             db,
		pausedAccounts: make(map[string]string),
	}
}

func (s *PostgresStore) beginTenantTx(ctx context.Context, workspaceID string) (*sql.Tx, error) {
	if s.db == nil {
		return nil, ErrStoreNotConfigured
	}
	if !isValidPGUUID(workspaceID) {
		return nil, ErrUnauthenticated
	}
	tx, err := s.db.BeginTx(ctx, nil)
	if err != nil {
		return nil, err
	}
	if _, err := tx.ExecContext(ctx, `SET LOCAL app.current_tenant_id = $1`, workspaceID); err != nil {
		_ = tx.Rollback()
		return nil, err
	}
	return tx, nil
}

func cloneMetadataWithoutInternalKeys(meta map[string]any) map[string]any {
	out := make(map[string]any)
	for k, v := range meta {
		if !strings.HasPrefix(k, "_pub_") {
			out[k] = v
		}
	}
	return out
}

func stringSliceFromAny(v any) []string {
	switch raw := v.(type) {
	case []string:
		return append([]string(nil), raw...)
	case []any:
		out := make([]string, 0, len(raw))
		for _, elem := range raw {
			if str, ok := elem.(string); ok {
				out = append(out, str)
			}
		}
		return out
	default:
		return nil
	}
}

func (s *PostgresStore) SaveItem(ctx context.Context, item *PublishItem) error {
	tx, err := s.beginTenantTx(ctx, item.WorkspaceID)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	if item.PublishItemID == "" {
		item.PublishItemID = NewID()
	}
	now := time.Now().UTC()
	if item.CreatedAt.IsZero() {
		item.CreatedAt = now
	}
	if item.UpdatedAt.IsZero() {
		item.UpdatedAt = now
	}
	if item.PublishMode == "" {
		item.PublishMode = "direct"
	}
	if item.LifecycleState == "" {
		item.LifecycleState = StateDraft
	}
	if item.DiagnosticsState == "" {
		item.DiagnosticsState = DiagnosticsHealthy
	}

	hashtagsJSON, _ := json.Marshal(item.Hashtags)
	if len(hashtagsJSON) == 0 || string(hashtagsJSON) == "null" {
		hashtagsJSON = []byte("[]")
	}
	compDetailsJSON, _ := json.Marshal(item.ComplianceDetails)
	if len(compDetailsJSON) == 0 || string(compDetailsJSON) == "null" {
		compDetailsJSON = []byte("{}")
	}

	metaMap := make(map[string]any)
	for k, v := range item.Metadata {
		metaMap[k] = v
	}
	if item.AssetID != "" {
		metaMap["_pub_asset_id"] = item.AssetID
	}
	if item.TargetAccountID != "" {
		metaMap["_pub_target_account_id"] = item.TargetAccountID
	}
	if item.CreatedBy != "" {
		metaMap["_pub_created_by"] = item.CreatedBy
	}
	if len(item.LinkedOfferIDs) > 0 {
		metaMap["_pub_linked_offer_ids"] = item.LinkedOfferIDs
	}
	if len(item.LinkedCampaignIDs) > 0 {
		metaMap["_pub_linked_campaign_ids"] = item.LinkedCampaignIDs
	}
	metaJSON, _ := json.Marshal(metaMap)

	offerArr := formatUUIDArrayLiteral(item.LinkedOfferIDs)
	campArr := formatUUIDArrayLiteral(item.LinkedCampaignIDs)

	upsertSQL := `
		INSERT INTO publish_items (
			publish_item_id, workspace_id, asset_id, target_platform, target_account_id,
			target_format, publish_mode, title, description, hashtags,
			schedule_at, capability_snapshot_id, lifecycle_state, diagnostics_state,
			linked_offer_ids, linked_campaign_ids, packaging_score,
			compliance_scan_result, compliance_details, metadata, created_by,
			created_at, updated_at, deleted_at
		) VALUES (
			$1, $2, $3, $4, $5,
			$6, $7, $8, $9, $10::jsonb,
			$11, $12, $13, $14,
			$15::uuid[], $16::uuid[], $17,
			$18, $19::jsonb, $20::jsonb, $21,
			$22, $23, $24
		)
		ON CONFLICT (publish_item_id) DO UPDATE SET
			asset_id = EXCLUDED.asset_id,
			target_platform = EXCLUDED.target_platform,
			target_account_id = EXCLUDED.target_account_id,
			target_format = EXCLUDED.target_format,
			publish_mode = EXCLUDED.publish_mode,
			title = EXCLUDED.title,
			description = EXCLUDED.description,
			hashtags = EXCLUDED.hashtags,
			schedule_at = EXCLUDED.schedule_at,
			capability_snapshot_id = EXCLUDED.capability_snapshot_id,
			lifecycle_state = EXCLUDED.lifecycle_state,
			diagnostics_state = EXCLUDED.diagnostics_state,
			linked_offer_ids = EXCLUDED.linked_offer_ids,
			linked_campaign_ids = EXCLUDED.linked_campaign_ids,
			packaging_score = EXCLUDED.packaging_score,
			compliance_scan_result = EXCLUDED.compliance_scan_result,
			compliance_details = EXCLUDED.compliance_details,
			metadata = EXCLUDED.metadata,
			updated_at = EXCLUDED.updated_at,
			deleted_at = EXCLUDED.deleted_at
		WHERE publish_items.workspace_id = $2
	`

	_, _ = tx.ExecContext(ctx, "SAVEPOINT sp_save_item")
	_, err = tx.ExecContext(
		ctx,
		upsertSQL,
		item.PublishItemID,
		item.WorkspaceID,
		nullableUUID(item.AssetID),
		item.TargetPlatform,
		nullableUUID(item.TargetAccountID),
		nullIfEmpty(item.TargetFormat),
		item.PublishMode,
		nullIfEmpty(item.Title),
		nullIfEmpty(item.Description),
		string(hashtagsJSON),
		item.ScheduleAt,
		nullableUUID(item.CapabilitySnapshotID),
		item.LifecycleState,
		item.DiagnosticsState,
		offerArr,
		campArr,
		item.PackagingScore,
		nullIfEmpty(item.ComplianceScanResult),
		string(compDetailsJSON),
		string(metaJSON),
		nullableUUID(item.CreatedBy),
		item.CreatedAt,
		item.UpdatedAt,
		item.DeletedAt,
	)
	if err != nil {
		// If optional FK rows (assets, connected_accounts, users) are not seeded, retry with NULL FK columns while preserving IDs in metadata.
		_, _ = tx.ExecContext(ctx, "ROLLBACK TO SAVEPOINT sp_save_item")
		_, err = tx.ExecContext(
			ctx,
			upsertSQL,
			item.PublishItemID,
			item.WorkspaceID,
			nil,
			item.TargetPlatform,
			nil,
			nullIfEmpty(item.TargetFormat),
			item.PublishMode,
			nullIfEmpty(item.Title),
			nullIfEmpty(item.Description),
			string(hashtagsJSON),
			item.ScheduleAt,
			nullableUUID(item.CapabilitySnapshotID),
			item.LifecycleState,
			item.DiagnosticsState,
			offerArr,
			campArr,
			item.PackagingScore,
			nullIfEmpty(item.ComplianceScanResult),
			string(compDetailsJSON),
			string(metaJSON),
			nil,
			item.CreatedAt,
			item.UpdatedAt,
			item.DeletedAt,
		)
		if err != nil {
			return fmt.Errorf("postgres save publish_item: %w", err)
		}
	}

	return tx.Commit()
}

func scanPublishItemRow(scanner interface{ Scan(dest ...any) error }) (*PublishItem, error) {
	var (
		item          PublishItem
		assetID       sql.NullString
		targetAccID   sql.NullString
		targetFormat  sql.NullString
		title         sql.NullString
		description   sql.NullString
		hashtagsRaw   []byte
		scheduleAt    sql.NullTime
		capSnapID     sql.NullString
		diagState     sql.NullString
		offerRaw      sql.NullString
		campRaw       sql.NullString
		packScore     sql.NullFloat64
		compResult    sql.NullString
		compDetRaw    []byte
		metaRaw       []byte
		createdBy     sql.NullString
		deletedAt     sql.NullTime
	)
	err := scanner.Scan(
		&item.PublishItemID,
		&item.WorkspaceID,
		&assetID,
		&item.TargetPlatform,
		&targetAccID,
		&targetFormat,
		&item.PublishMode,
		&title,
		&description,
		&hashtagsRaw,
		&scheduleAt,
		&capSnapID,
		&item.LifecycleState,
		&diagState,
		&offerRaw,
		&campRaw,
		&packScore,
		&compResult,
		&compDetRaw,
		&metaRaw,
		&createdBy,
		&item.CreatedAt,
		&item.UpdatedAt,
		&deletedAt,
	)
	if err != nil {
		return nil, err
	}

	item.AssetID = assetID.String
	item.TargetAccountID = targetAccID.String
	item.TargetFormat = targetFormat.String
	item.Title = title.String
	item.Description = description.String
	if scheduleAt.Valid {
		t := scheduleAt.Time.UTC()
		item.ScheduleAt = &t
	}
	item.CapabilitySnapshotID = capSnapID.String
	item.DiagnosticsState = diagState.String
	item.LinkedOfferIDs = parseUUIDArrayLiteral(offerRaw.String)
	item.LinkedCampaignIDs = parseUUIDArrayLiteral(campRaw.String)
	if packScore.Valid {
		item.PackagingScore = float32(packScore.Float64)
	}
	item.ComplianceScanResult = compResult.String
	item.CreatedBy = createdBy.String
	if deletedAt.Valid {
		t := deletedAt.Time.UTC()
		item.DeletedAt = &t
	}
	if len(hashtagsRaw) > 0 {
		_ = json.Unmarshal(hashtagsRaw, &item.Hashtags)
	}
	if item.Hashtags == nil {
		item.Hashtags = []string{}
	}
	if len(compDetRaw) > 0 {
		_ = json.Unmarshal(compDetRaw, &item.ComplianceDetails)
	}
	if item.ComplianceDetails == nil {
		item.ComplianceDetails = make(map[string]any)
	}
	rawMeta := make(map[string]any)
	if len(metaRaw) > 0 {
		_ = json.Unmarshal(metaRaw, &rawMeta)
	}
	if item.AssetID == "" {
		if v, ok := rawMeta["_pub_asset_id"].(string); ok {
			item.AssetID = v
		}
	}
	if item.TargetAccountID == "" {
		if v, ok := rawMeta["_pub_target_account_id"].(string); ok {
			item.TargetAccountID = v
		}
	}
	if item.CreatedBy == "" {
		if v, ok := rawMeta["_pub_created_by"].(string); ok {
			item.CreatedBy = v
		}
	}
	if offers := stringSliceFromAny(rawMeta["_pub_linked_offer_ids"]); len(offers) > 0 {
		item.LinkedOfferIDs = offers
	}
	if camps := stringSliceFromAny(rawMeta["_pub_linked_campaign_ids"]); len(camps) > 0 {
		item.LinkedCampaignIDs = camps
	}
	item.Metadata = cloneMetadataWithoutInternalKeys(rawMeta)
	return &item, nil
}

const selectPublishItemColumns = `
	publish_item_id, workspace_id, asset_id, target_platform, target_account_id,
	target_format, publish_mode, title, description, hashtags,
	schedule_at, capability_snapshot_id, lifecycle_state, diagnostics_state,
	linked_offer_ids::text, linked_campaign_ids::text, packaging_score,
	compliance_scan_result, compliance_details, metadata, created_by,
	created_at, updated_at, deleted_at
`

func (s *PostgresStore) GetItem(ctx context.Context, workspaceID, publishItemID string) (*PublishItem, error) {
	if !isValidPGUUID(publishItemID) {
		return nil, ErrItemNotFound
	}
	tx, err := s.beginTenantTx(ctx, workspaceID)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	row := tx.QueryRowContext(
		ctx,
		`SELECT `+selectPublishItemColumns+` FROM publish_items WHERE workspace_id = $1 AND publish_item_id = $2 AND deleted_at IS NULL`,
		workspaceID, publishItemID,
	)
	item, err := scanPublishItemRow(row)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, ErrItemNotFound
		}
		return nil, fmt.Errorf("postgres get publish_item: %w", err)
	}
	_ = tx.Commit()
	return item, nil
}

func (s *PostgresStore) ListItems(ctx context.Context, workspaceID string) ([]*PublishItem, error) {
	tx, err := s.beginTenantTx(ctx, workspaceID)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	rows, err := tx.QueryContext(
		ctx,
		`SELECT `+selectPublishItemColumns+` FROM publish_items WHERE workspace_id = $1 AND deleted_at IS NULL ORDER BY created_at ASC, publish_item_id ASC`,
		workspaceID,
	)
	if err != nil {
		return nil, fmt.Errorf("postgres list publish_items: %w", err)
	}
	defer rows.Close()

	var out []*PublishItem
	for rows.Next() {
		it, err := scanPublishItemRow(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, it)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	_ = tx.Commit()
	return out, nil
}

func (s *PostgresStore) DeleteItem(ctx context.Context, workspaceID, publishItemID string) error {
	if !isValidPGUUID(publishItemID) {
		return ErrItemNotFound
	}
	tx, err := s.beginTenantTx(ctx, workspaceID)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	res, err := tx.ExecContext(ctx, `DELETE FROM publish_items WHERE workspace_id = $1 AND publish_item_id = $2`, workspaceID, publishItemID)
	if err != nil {
		return fmt.Errorf("postgres delete publish_item: %w", err)
	}
	n, _ := res.RowsAffected()
	if n == 0 {
		return ErrItemNotFound
	}
	return tx.Commit()
}

func (s *PostgresStore) SaveJob(ctx context.Context, job *PublishJob) error {
	tx, err := s.beginTenantTx(ctx, job.WorkspaceID)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	if job.PublishJobID == "" {
		job.PublishJobID = NewID()
	}
	now := time.Now().UTC()
	if job.CreatedAt.IsZero() {
		job.CreatedAt = now
	}
	if job.UpdatedAt.IsZero() {
		job.UpdatedAt = now
	}
	if job.LifecycleState == "" {
		job.LifecycleState = JobStateCreated
	}
	if job.MaxAttempts == 0 {
		job.MaxAttempts = 3
	}

	summaryMap := make(map[string]any)
	for k, v := range job.LastExecutionSummary {
		summaryMap[k] = v
	}
	if job.ApprovalRequestID != "" {
		summaryMap["_pub_approval_request_id"] = job.ApprovalRequestID
	}
	summaryJSON, _ := json.Marshal(summaryMap)

	_, err = tx.ExecContext(
		ctx,
		`INSERT INTO publish_jobs (
			publish_job_id, workspace_id, publish_item_id, dispatch_strategy,
			lifecycle_state, attempt_count, max_attempts, current_worker_id,
			last_execution_summary, approval_request_id, created_at, updated_at, deleted_at
		) VALUES (
			$1, $2, $3, $4,
			$5, $6, $7, $8,
			$9::jsonb, $10, $11, $12, $13
		)
		ON CONFLICT (publish_job_id) DO UPDATE SET
			dispatch_strategy = EXCLUDED.dispatch_strategy,
			lifecycle_state = EXCLUDED.lifecycle_state,
			attempt_count = EXCLUDED.attempt_count,
			max_attempts = EXCLUDED.max_attempts,
			current_worker_id = EXCLUDED.current_worker_id,
			last_execution_summary = EXCLUDED.last_execution_summary,
			approval_request_id = EXCLUDED.approval_request_id,
			updated_at = EXCLUDED.updated_at,
			deleted_at = EXCLUDED.deleted_at
		WHERE publish_jobs.workspace_id = $2`,
		job.PublishJobID,
		job.WorkspaceID,
		job.PublishItemID,
		nullIfEmpty(job.DispatchStrategy),
		job.LifecycleState,
		job.AttemptCount,
		job.MaxAttempts,
		nullIfEmpty(job.CurrentWorkerID),
		string(summaryJSON),
		nullableUUID(job.ApprovalRequestID),
		job.CreatedAt,
		job.UpdatedAt,
		job.DeletedAt,
	)
	if err != nil {
		return fmt.Errorf("postgres save publish_job: %w", err)
	}
	return tx.Commit()
}

func scanPublishJobRow(scanner interface{ Scan(dest ...any) error }) (*PublishJob, error) {
	var (
		job              PublishJob
		dispatchStrategy sql.NullString
		workerID         sql.NullString
		summaryRaw       []byte
		approvalReqID    sql.NullString
		deletedAt        sql.NullTime
	)
	err := scanner.Scan(
		&job.PublishJobID,
		&job.WorkspaceID,
		&job.PublishItemID,
		&dispatchStrategy,
		&job.LifecycleState,
		&job.AttemptCount,
		&job.MaxAttempts,
		&workerID,
		&summaryRaw,
		&approvalReqID,
		&job.CreatedAt,
		&job.UpdatedAt,
		&deletedAt,
	)
	if err != nil {
		return nil, err
	}
	job.DispatchStrategy = dispatchStrategy.String
	job.CurrentWorkerID = workerID.String
	job.ApprovalRequestID = approvalReqID.String
	if deletedAt.Valid {
		t := deletedAt.Time.UTC()
		job.DeletedAt = &t
	}
	rawSummary := make(map[string]any)
	if len(summaryRaw) > 0 {
		_ = json.Unmarshal(summaryRaw, &rawSummary)
	}
	if job.ApprovalRequestID == "" {
		if v, ok := rawSummary["_pub_approval_request_id"].(string); ok {
			job.ApprovalRequestID = v
		}
	}
	job.LastExecutionSummary = cloneMetadataWithoutInternalKeys(rawSummary)
	return &job, nil
}

const selectPublishJobColumns = `
	publish_job_id, workspace_id, publish_item_id, dispatch_strategy,
	lifecycle_state, attempt_count, max_attempts, current_worker_id,
	last_execution_summary, approval_request_id, created_at, updated_at, deleted_at
`

func (s *PostgresStore) GetJob(ctx context.Context, workspaceID, publishJobID string) (*PublishJob, error) {
	if !isValidPGUUID(publishJobID) {
		return nil, ErrJobNotFound
	}
	tx, err := s.beginTenantTx(ctx, workspaceID)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	row := tx.QueryRowContext(
		ctx,
		`SELECT `+selectPublishJobColumns+` FROM publish_jobs WHERE workspace_id = $1 AND publish_job_id = $2 AND deleted_at IS NULL`,
		workspaceID, publishJobID,
	)
	job, err := scanPublishJobRow(row)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, ErrJobNotFound
		}
		return nil, fmt.Errorf("postgres get publish_job: %w", err)
	}
	_ = tx.Commit()
	return job, nil
}

func (s *PostgresStore) GetJobByItemID(ctx context.Context, workspaceID, publishItemID string) (*PublishJob, error) {
	if !isValidPGUUID(publishItemID) {
		return nil, ErrJobNotFound
	}
	tx, err := s.beginTenantTx(ctx, workspaceID)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	row := tx.QueryRowContext(
		ctx,
		`SELECT `+selectPublishJobColumns+` FROM publish_jobs WHERE workspace_id = $1 AND publish_item_id = $2 AND deleted_at IS NULL ORDER BY created_at DESC, publish_job_id DESC LIMIT 1`,
		workspaceID, publishItemID,
	)
	job, err := scanPublishJobRow(row)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, ErrJobNotFound
		}
		return nil, fmt.Errorf("postgres get publish_job by item: %w", err)
	}
	_ = tx.Commit()
	return job, nil
}

func (s *PostgresStore) ListJobs(ctx context.Context, workspaceID string) ([]*PublishJob, error) {
	tx, err := s.beginTenantTx(ctx, workspaceID)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	rows, err := tx.QueryContext(
		ctx,
		`SELECT `+selectPublishJobColumns+` FROM publish_jobs WHERE workspace_id = $1 AND deleted_at IS NULL ORDER BY created_at ASC, publish_job_id ASC`,
		workspaceID,
	)
	if err != nil {
		return nil, fmt.Errorf("postgres list publish_jobs: %w", err)
	}
	defer rows.Close()

	var out []*PublishJob
	for rows.Next() {
		j, err := scanPublishJobRow(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, j)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	_ = tx.Commit()
	return out, nil
}

func (s *PostgresStore) DeleteJobsByItemID(ctx context.Context, workspaceID, publishItemID string) error {
	if !isValidPGUUID(publishItemID) {
		return nil
	}
	tx, err := s.beginTenantTx(ctx, workspaceID)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	_, err = tx.ExecContext(ctx, `DELETE FROM publish_jobs WHERE workspace_id = $1 AND publish_item_id = $2`, workspaceID, publishItemID)
	if err != nil {
		return fmt.Errorf("postgres delete publish_jobs: %w", err)
	}
	return tx.Commit()
}

func (s *PostgresStore) AppendLog(ctx context.Context, logEntry *PublishLog) error {
	tx, err := s.beginTenantTx(ctx, logEntry.WorkspaceID)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	if logEntry.PublishLogID == "" {
		logEntry.PublishLogID = NewID()
	}
	if logEntry.AttemptedAt.IsZero() {
		logEntry.AttemptedAt = time.Now().UTC()
	}

	metaMap := make(map[string]any)
	for k, v := range logEntry.Metadata {
		metaMap[k] = v
	}
	if logEntry.ActingMode != "" {
		metaMap["_pub_acting_mode"] = logEntry.ActingMode
	}
	if logEntry.ActorUserID != "" {
		metaMap["_pub_actor_user_id"] = logEntry.ActorUserID
	}
	if logEntry.DiagnosticsRef != "" {
		metaMap["_pub_diagnostics_ref"] = logEntry.DiagnosticsRef
	}
	if logEntry.EvidenceRef != "" {
		metaMap["_pub_evidence_ref"] = logEntry.EvidenceRef
	}
	metaJSON, _ := json.Marshal(metaMap)

	var actingModeCol any
	if isOperatorModeEnum(logEntry.ActingMode) {
		actingModeCol = logEntry.ActingMode
	}

	_, err = tx.ExecContext(
		ctx,
		`INSERT INTO publish_logs (
			publish_log_id, workspace_id, publish_job_id, publish_item_id,
			attempted_at, completed_at, failed_at, actor_user_id, acting_mode,
			execution_path, capability_snapshot_id, result_status,
			external_post_id, external_post_url, diagnostics_ref, evidence_ref,
			error_code, error_message, metadata
		) VALUES (
			$1, $2, $3, $4,
			$5, $6, $7, $8, $9,
			$10, $11, $12,
			$13, $14, $15, $16,
			$17, $18, $19::jsonb
		)`,
		logEntry.PublishLogID,
		logEntry.WorkspaceID,
		logEntry.PublishJobID,
		logEntry.PublishItemID,
		logEntry.AttemptedAt,
		logEntry.CompletedAt,
		logEntry.FailedAt,
		nullableUUID(logEntry.ActorUserID),
		actingModeCol,
		nullIfEmpty(logEntry.ExecutionPath),
		nullableUUID(logEntry.CapabilitySnapshotID),
		logEntry.ResultStatus,
		nullIfEmpty(logEntry.ExternalPostID),
		nullIfEmpty(logEntry.ExternalPostURL),
		nullableUUID(logEntry.DiagnosticsRef),
		nullableUUID(logEntry.EvidenceRef),
		nullIfEmpty(logEntry.ErrorCode),
		nullIfEmpty(logEntry.ErrorMessage),
		string(metaJSON),
	)
	if err != nil {
		return fmt.Errorf("postgres insert publish_log: %w", err)
	}
	return tx.Commit()
}

func (s *PostgresStore) ListLogsByItemID(ctx context.Context, workspaceID, publishItemID string) ([]*PublishLog, error) {
	if !isValidPGUUID(publishItemID) {
		return nil, nil
	}
	tx, err := s.beginTenantTx(ctx, workspaceID)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	rows, err := tx.QueryContext(
		ctx,
		`SELECT
			publish_log_id, workspace_id, publish_job_id, publish_item_id,
			attempted_at, completed_at, failed_at, actor_user_id, acting_mode::text,
			execution_path, capability_snapshot_id, result_status,
			external_post_id, external_post_url, diagnostics_ref, evidence_ref,
			error_code, error_message, metadata
		FROM publish_logs
		WHERE workspace_id = $1 AND publish_item_id = $2
		ORDER BY attempted_at ASC, publish_log_id ASC`,
		workspaceID, publishItemID,
	)
	if err != nil {
		return nil, fmt.Errorf("postgres list publish_logs: %w", err)
	}
	defer rows.Close()

	var out []*PublishLog
	for rows.Next() {
		var (
			l              PublishLog
			completedAt    sql.NullTime
			failedAt       sql.NullTime
			actorUserID    sql.NullString
			actingMode     sql.NullString
			execPath       sql.NullString
			capSnapID      sql.NullString
			extPostID      sql.NullString
			extPostURL     sql.NullString
			diagRef        sql.NullString
			evidRef        sql.NullString
			errCode        sql.NullString
			errMsg         sql.NullString
			metaRaw        []byte
		)
		if err := rows.Scan(
			&l.PublishLogID,
			&l.WorkspaceID,
			&l.PublishJobID,
			&l.PublishItemID,
			&l.AttemptedAt,
			&completedAt,
			&failedAt,
			&actorUserID,
			&actingMode,
			&execPath,
			&capSnapID,
			&l.ResultStatus,
			&extPostID,
			&extPostURL,
			&diagRef,
			&evidRef,
			&errCode,
			&errMsg,
			&metaRaw,
		); err != nil {
			return nil, err
		}
		if completedAt.Valid {
			t := completedAt.Time.UTC()
			l.CompletedAt = &t
		}
		if failedAt.Valid {
			t := failedAt.Time.UTC()
			l.FailedAt = &t
		}
		l.ActorUserID = actorUserID.String
		l.ActingMode = actingMode.String
		l.ExecutionPath = execPath.String
		l.CapabilitySnapshotID = capSnapID.String
		l.ExternalPostID = extPostID.String
		l.ExternalPostURL = extPostURL.String
		l.DiagnosticsRef = diagRef.String
		l.EvidenceRef = evidRef.String
		l.ErrorCode = errCode.String
		l.ErrorMessage = errMsg.String

		rawMeta := make(map[string]any)
		if len(metaRaw) > 0 {
			_ = json.Unmarshal(metaRaw, &rawMeta)
		}
		if l.ActingMode == "" {
			if v, ok := rawMeta["_pub_acting_mode"].(string); ok {
				l.ActingMode = v
			}
		}
		if l.ActorUserID == "" {
			if v, ok := rawMeta["_pub_actor_user_id"].(string); ok {
				l.ActorUserID = v
			}
		}
		if l.DiagnosticsRef == "" {
			if v, ok := rawMeta["_pub_diagnostics_ref"].(string); ok {
				l.DiagnosticsRef = v
			}
		}
		if l.EvidenceRef == "" {
			if v, ok := rawMeta["_pub_evidence_ref"].(string); ok {
				l.EvidenceRef = v
			}
		}
		l.Metadata = cloneMetadataWithoutInternalKeys(rawMeta)
		out = append(out, &l)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	_ = tx.Commit()
	return out, nil
}

func (s *PostgresStore) SavePost(ctx context.Context, post *ChannelPost) error {
	tx, err := s.beginTenantTx(ctx, post.WorkspaceID)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	if post.ChannelPostID == "" {
		post.ChannelPostID = NewID()
	}
	now := time.Now().UTC()
	if post.CreatedAt.IsZero() {
		post.CreatedAt = now
	}
	if post.UpdatedAt.IsZero() {
		post.UpdatedAt = now
	}

	metricsJSON, _ := json.Marshal(post.Metrics)
	if len(metricsJSON) == 0 || string(metricsJSON) == "null" {
		metricsJSON = []byte("{}")
	}
	metaMap := make(map[string]any)
	for k, v := range post.Metadata {
		metaMap[k] = v
	}
	if post.ConnectedAccountID != "" {
		metaMap["_pub_connected_account_id"] = post.ConnectedAccountID
	}
	if post.SourceClass != "" {
		metaMap["_pub_source_class"] = post.SourceClass
	}
	if post.Confidence != "" {
		metaMap["_pub_confidence"] = post.Confidence
	}
	if post.PostMetrics != nil {
		metaMap["_pub_post_metrics"] = map[string]any{
			"views":             post.PostMetrics.Views,
			"likes":             post.PostMetrics.Likes,
			"comments":          post.PostMetrics.Comments,
			"shares":            post.PostMetrics.Shares,
			"saves":             post.PostMetrics.Saves,
			"clicks":            post.PostMetrics.Clicks,
			"is_views_unknown":  post.PostMetrics.IsViewsUnknown,
			"is_clicks_unknown": post.PostMetrics.IsClicksUnknown,
			"unknown_reason":    post.PostMetrics.UnknownReason,
		}
	}
	metaJSON, _ := json.Marshal(metaMap)

	upsertSQL := `
		INSERT INTO channel_posts (
			channel_post_id, workspace_id, publish_item_id, connected_account_id,
			external_post_id, external_permalink, title, thumbnail_url,
			metrics, synced_at, metadata, created_at, updated_at
		) VALUES (
			$1, $2, $3, $4,
			$5, $6, $7, $8,
			$9::jsonb, $10, $11::jsonb, $12, $13
		)
		ON CONFLICT (channel_post_id) DO UPDATE SET
			external_post_id = EXCLUDED.external_post_id,
			external_permalink = EXCLUDED.external_permalink,
			title = EXCLUDED.title,
			thumbnail_url = EXCLUDED.thumbnail_url,
			metrics = EXCLUDED.metrics,
			synced_at = EXCLUDED.synced_at,
			metadata = EXCLUDED.metadata,
			updated_at = EXCLUDED.updated_at
		WHERE channel_posts.workspace_id = $2
	`

	_, _ = tx.ExecContext(ctx, "SAVEPOINT sp_save_post")
	_, err = tx.ExecContext(
		ctx,
		upsertSQL,
		post.ChannelPostID,
		post.WorkspaceID,
		nullableUUID(post.PublishItemID),
		nullableUUID(post.ConnectedAccountID),
		nullIfEmpty(post.ExternalPostID),
		nullIfEmpty(post.ExternalPermalink),
		nullIfEmpty(post.Title),
		nullIfEmpty(post.ThumbnailURL),
		string(metricsJSON),
		post.SyncedAt,
		string(metaJSON),
		post.CreatedAt,
		post.UpdatedAt,
	)
	if err != nil {
		_, _ = tx.ExecContext(ctx, "ROLLBACK TO SAVEPOINT sp_save_post")
		_, err = tx.ExecContext(
			ctx,
			upsertSQL,
			post.ChannelPostID,
			post.WorkspaceID,
			nullableUUID(post.PublishItemID),
			nil,
			nullIfEmpty(post.ExternalPostID),
			nullIfEmpty(post.ExternalPermalink),
			nullIfEmpty(post.Title),
			nullIfEmpty(post.ThumbnailURL),
			string(metricsJSON),
			post.SyncedAt,
			string(metaJSON),
			post.CreatedAt,
			post.UpdatedAt,
		)
		if err != nil {
			return fmt.Errorf("postgres save channel_post: %w", err)
		}
	}
	return tx.Commit()
}

func scanChannelPostRow(scanner interface{ Scan(dest ...any) error }) (*ChannelPost, error) {
	var (
		p          ChannelPost
		pubItemID  sql.NullString
		connAccID  sql.NullString
		extPostID  sql.NullString
		extLink    sql.NullString
		title      sql.NullString
		thumbURL   sql.NullString
		metricsRaw []byte
		syncedAt   sql.NullTime
		metaRaw    []byte
	)
	if err := scanner.Scan(
		&p.ChannelPostID,
		&p.WorkspaceID,
		&pubItemID,
		&connAccID,
		&extPostID,
		&extLink,
		&title,
		&thumbURL,
		&metricsRaw,
		&syncedAt,
		&metaRaw,
		&p.CreatedAt,
		&p.UpdatedAt,
	); err != nil {
		return nil, err
	}
	p.PublishItemID = pubItemID.String
	p.ConnectedAccountID = connAccID.String
	p.ExternalPostID = extPostID.String
	p.ExternalPermalink = extLink.String
	p.Title = title.String
	p.ThumbnailURL = thumbURL.String
	if syncedAt.Valid {
		t := syncedAt.Time.UTC()
		p.SyncedAt = &t
	}
	if len(metricsRaw) > 0 {
		_ = json.Unmarshal(metricsRaw, &p.Metrics)
	}
	if p.Metrics == nil {
		p.Metrics = make(map[string]any)
	}
	rawMeta := make(map[string]any)
	if len(metaRaw) > 0 {
		_ = json.Unmarshal(metaRaw, &rawMeta)
	}
	if p.ConnectedAccountID == "" {
		if v, ok := rawMeta["_pub_connected_account_id"].(string); ok {
			p.ConnectedAccountID = v
		}
	}
	if v, ok := rawMeta["_pub_source_class"].(string); ok {
		p.SourceClass = v
	}
	if v, ok := rawMeta["_pub_confidence"].(string); ok {
		p.Confidence = v
	}
	p.Metadata = cloneMetadataWithoutInternalKeys(rawMeta)
	return &p, nil
}

const selectChannelPostColumns = `
	channel_post_id, workspace_id, publish_item_id, connected_account_id,
	external_post_id, external_permalink, title, thumbnail_url,
	metrics, synced_at, metadata, created_at, updated_at
`

func (s *PostgresStore) GetPost(ctx context.Context, workspaceID, channelPostID string) (*ChannelPost, error) {
	if !isValidPGUUID(channelPostID) {
		return nil, ErrItemNotFound
	}
	tx, err := s.beginTenantTx(ctx, workspaceID)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	row := tx.QueryRowContext(
		ctx,
		`SELECT `+selectChannelPostColumns+` FROM channel_posts WHERE workspace_id = $1 AND channel_post_id = $2`,
		workspaceID, channelPostID,
	)
	post, err := scanChannelPostRow(row)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, ErrItemNotFound
		}
		return nil, fmt.Errorf("postgres get channel_post: %w", err)
	}
	_ = tx.Commit()
	return post, nil
}

func (s *PostgresStore) GetPostByItemID(ctx context.Context, workspaceID, publishItemID string) (*ChannelPost, error) {
	if !isValidPGUUID(publishItemID) {
		return nil, ErrItemNotFound
	}
	tx, err := s.beginTenantTx(ctx, workspaceID)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	row := tx.QueryRowContext(
		ctx,
		`SELECT `+selectChannelPostColumns+` FROM channel_posts WHERE workspace_id = $1 AND publish_item_id = $2 ORDER BY created_at DESC LIMIT 1`,
		workspaceID, publishItemID,
	)
	post, err := scanChannelPostRow(row)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, ErrItemNotFound
		}
		return nil, fmt.Errorf("postgres get channel_post by item: %w", err)
	}
	_ = tx.Commit()
	return post, nil
}

func (s *PostgresStore) ListPosts(ctx context.Context, workspaceID string) ([]*ChannelPost, error) {
	tx, err := s.beginTenantTx(ctx, workspaceID)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	rows, err := tx.QueryContext(
		ctx,
		`SELECT `+selectChannelPostColumns+` FROM channel_posts WHERE workspace_id = $1 ORDER BY created_at ASC, channel_post_id ASC`,
		workspaceID,
	)
	if err != nil {
		return nil, fmt.Errorf("postgres list channel_posts: %w", err)
	}
	defer rows.Close()

	var out []*ChannelPost
	for rows.Next() {
		p, err := scanChannelPostRow(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, p)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	_ = tx.Commit()
	return out, nil
}

func (s *PostgresStore) SaveEffect(ctx context.Context, effect *ExternalEffect) error {
	tx, err := s.beginTenantTx(ctx, effect.WorkspaceID)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	if effect.EffectID == "" {
		effect.EffectID = NewID()
	}
	now := time.Now().UTC()
	if effect.CreatedAt.IsZero() {
		effect.CreatedAt = now
	}
	if effect.UpdatedAt.IsZero() {
		effect.UpdatedAt = now
	}

	payloadMap := make(map[string]any)
	for k, v := range effect.ResultPayload {
		payloadMap[k] = v
	}
	if effect.ConnectedAccountID != "" {
		payloadMap["_pub_connected_account_id"] = effect.ConnectedAccountID
	}
	payloadJSON, _ := json.Marshal(payloadMap)

	upsertSQL := `
		INSERT INTO external_effects (
			effect_id, workspace_id, operation_key, provider, connected_account_id,
			aggregate_type, aggregate_id, provider_request_id, status,
			result_payload, last_checked_at, created_at, updated_at
		) VALUES (
			$1, $2, $3, $4, $5,
			$6, $7, $8, $9,
			$10::jsonb, $11, $12, $13
		)
		ON CONFLICT (workspace_id, operation_key) DO UPDATE SET
			provider_request_id = EXCLUDED.provider_request_id,
			status = EXCLUDED.status,
			result_payload = EXCLUDED.result_payload,
			last_checked_at = EXCLUDED.last_checked_at,
			updated_at = EXCLUDED.updated_at
		WHERE external_effects.workspace_id = $2
	`

	_, _ = tx.ExecContext(ctx, "SAVEPOINT sp_save_effect")
	_, err = tx.ExecContext(
		ctx,
		upsertSQL,
		effect.EffectID,
		effect.WorkspaceID,
		effect.OperationKey,
		effect.Provider,
		nullableUUID(effect.ConnectedAccountID),
		effect.AggregateType,
		effect.AggregateID,
		nullIfEmpty(effect.ProviderRequestID),
		effect.Status,
		string(payloadJSON),
		effect.LastCheckedAt,
		effect.CreatedAt,
		effect.UpdatedAt,
	)
	if err != nil {
		_, _ = tx.ExecContext(ctx, "ROLLBACK TO SAVEPOINT sp_save_effect")
		_, err = tx.ExecContext(
			ctx,
			upsertSQL,
			effect.EffectID,
			effect.WorkspaceID,
			effect.OperationKey,
			effect.Provider,
			nil,
			effect.AggregateType,
			effect.AggregateID,
			nullIfEmpty(effect.ProviderRequestID),
			effect.Status,
			string(payloadJSON),
			effect.LastCheckedAt,
			effect.CreatedAt,
			effect.UpdatedAt,
		)
		if err != nil {
			return fmt.Errorf("postgres save external_effect: %w", err)
		}
	}
	return tx.Commit()
}

func scanExternalEffectRow(scanner interface{ Scan(dest ...any) error }) (*ExternalEffect, error) {
	var (
		eff           ExternalEffect
		connAccID     sql.NullString
		provReqID     sql.NullString
		payloadRaw    []byte
		lastCheckedAt sql.NullTime
	)
	if err := scanner.Scan(
		&eff.EffectID,
		&eff.WorkspaceID,
		&eff.OperationKey,
		&eff.Provider,
		&connAccID,
		&eff.AggregateType,
		&eff.AggregateID,
		&provReqID,
		&eff.Status,
		&payloadRaw,
		&lastCheckedAt,
		&eff.CreatedAt,
		&eff.UpdatedAt,
	); err != nil {
		return nil, err
	}
	eff.ConnectedAccountID = connAccID.String
	eff.ProviderRequestID = provReqID.String
	if lastCheckedAt.Valid {
		t := lastCheckedAt.Time.UTC()
		eff.LastCheckedAt = &t
	}
	rawPayload := make(map[string]any)
	if len(payloadRaw) > 0 {
		_ = json.Unmarshal(payloadRaw, &rawPayload)
	}
	if eff.ConnectedAccountID == "" {
		if v, ok := rawPayload["_pub_connected_account_id"].(string); ok {
			eff.ConnectedAccountID = v
		}
	}
	eff.ResultPayload = cloneMetadataWithoutInternalKeys(rawPayload)
	return &eff, nil
}

const selectExternalEffectColumns = `
	effect_id, workspace_id, operation_key, provider, connected_account_id,
	aggregate_type, aggregate_id, provider_request_id, status,
	result_payload, last_checked_at, created_at, updated_at
`

func (s *PostgresStore) GetEffectByKey(ctx context.Context, workspaceID, operationKey string) (*ExternalEffect, error) {
	tx, err := s.beginTenantTx(ctx, workspaceID)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	row := tx.QueryRowContext(
		ctx,
		`SELECT `+selectExternalEffectColumns+` FROM external_effects WHERE workspace_id = $1 AND operation_key = $2`,
		workspaceID, operationKey,
	)
	eff, err := scanExternalEffectRow(row)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil
		}
		return nil, fmt.Errorf("postgres get external_effect: %w", err)
	}
	_ = tx.Commit()
	return eff, nil
}

func (s *PostgresStore) ListEffectsByAggregate(ctx context.Context, workspaceID, aggregateType, aggregateID string) ([]*ExternalEffect, error) {
	if !isValidPGUUID(aggregateID) {
		return nil, nil
	}
	tx, err := s.beginTenantTx(ctx, workspaceID)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	var (
		rows *sql.Rows
	)
	if aggregateType != "" {
		rows, err = tx.QueryContext(
			ctx,
			`SELECT `+selectExternalEffectColumns+` FROM external_effects WHERE workspace_id = $1 AND aggregate_type = $2 AND aggregate_id = $3 ORDER BY created_at ASC, effect_id ASC`,
			workspaceID, aggregateType, aggregateID,
		)
	} else {
		rows, err = tx.QueryContext(
			ctx,
			`SELECT `+selectExternalEffectColumns+` FROM external_effects WHERE workspace_id = $1 AND aggregate_id = $2 ORDER BY created_at ASC, effect_id ASC`,
			workspaceID, aggregateID,
		)
	}
	if err != nil {
		return nil, fmt.Errorf("postgres list external_effects: %w", err)
	}
	defer rows.Close()

	var out []*ExternalEffect
	for rows.Next() {
		eff, err := scanExternalEffectRow(rows)
		if err != nil {
			return nil, err
		}
		out = append(out, eff)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	_ = tx.Commit()
	return out, nil
}

func (s *PostgresStore) AppendEvent(ctx context.Context, ev DomainEvent) error {
	tx, err := s.beginTenantTx(ctx, ev.WorkspaceID)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	if ev.EventID == "" {
		ev.EventID = NewID()
	}
	if ev.OccurredAt.IsZero() {
		ev.OccurredAt = time.Now().UTC()
	}

	payloadJSON, _ := json.Marshal(ev.Payload)
	if len(payloadJSON) == 0 || string(payloadJSON) == "null" {
		payloadJSON = []byte("{}")
	}

	_, err = tx.ExecContext(
		ctx,
		`INSERT INTO event_outbox (
			event_id, event_type, target_stream, aggregate_type, aggregate_id,
			workspace_id, payload, created_at
		) VALUES ($1, $2, $3, $4, $5, $6, $7::jsonb, $8)
		ON CONFLICT (event_id) DO NOTHING`,
		ev.EventID,
		ev.EventType,
		"PUBLISH_EVENTS",
		ev.AggregateType,
		ev.AggregateID,
		ev.WorkspaceID,
		string(payloadJSON),
		ev.OccurredAt,
	)
	if err != nil {
		return fmt.Errorf("postgres insert event_outbox: %w", err)
	}
	return tx.Commit()
}

func (s *PostgresStore) ListEvents(ctx context.Context, workspaceID string) ([]DomainEvent, error) {
	tx, err := s.beginTenantTx(ctx, workspaceID)
	if err != nil {
		return nil, err
	}
	defer tx.Rollback()

	rows, err := tx.QueryContext(
		ctx,
		`SELECT event_id, event_type, aggregate_type, aggregate_id, workspace_id, payload, created_at
		FROM event_outbox
		WHERE workspace_id = $1
		ORDER BY outbox_id ASC`,
		workspaceID,
	)
	if err != nil {
		return nil, fmt.Errorf("postgres list event_outbox: %w", err)
	}
	defer rows.Close()

	var out []DomainEvent
	for rows.Next() {
		var (
			ev         DomainEvent
			payloadRaw []byte
		)
		if err := rows.Scan(
			&ev.EventID,
			&ev.EventType,
			&ev.AggregateType,
			&ev.AggregateID,
			&ev.WorkspaceID,
			&payloadRaw,
			&ev.OccurredAt,
		); err != nil {
			return nil, err
		}
		if len(payloadRaw) > 0 {
			_ = json.Unmarshal(payloadRaw, &ev.Payload)
		}
		if ev.Payload == nil {
			ev.Payload = make(map[string]any)
		}
		out = append(out, ev)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	_ = tx.Commit()
	return out, nil
}

func (s *PostgresStore) SetAccountPaused(ctx context.Context, workspaceID, accountID string, paused bool, reason string) error {
	s.mu.Lock()
	key := workspaceID + "|" + accountID
	if paused {
		s.pausedAccounts[key] = reason
	} else {
		delete(s.pausedAccounts, key)
	}
	s.mu.Unlock()

	if !isValidPGUUID(accountID) {
		return nil
	}
	tx, err := s.beginTenantTx(ctx, workspaceID)
	if err != nil {
		return err
	}
	defer tx.Rollback()

	patch := map[string]any{
		"publish_queue_paused":       paused,
		"publish_queue_pause_reason": reason,
	}
	patchJSON, _ := json.Marshal(patch)
	_, _ = tx.ExecContext(
		ctx,
		`UPDATE connected_accounts SET metadata = COALESCE(metadata, '{}'::jsonb) || $1::jsonb, updated_at = NOW() WHERE workspace_id = $2 AND connected_account_id = $3`,
		string(patchJSON), workspaceID, accountID,
	)
	return tx.Commit()
}

func (s *PostgresStore) IsAccountPaused(ctx context.Context, workspaceID, accountID string) (bool, string, error) {
	s.mu.RLock()
	reason, ok := s.pausedAccounts[workspaceID+"|"+accountID]
	s.mu.RUnlock()
	if ok {
		return true, reason, nil
	}
	if !isValidPGUUID(accountID) {
		return false, "", nil
	}
	tx, err := s.beginTenantTx(ctx, workspaceID)
	if err != nil {
		return false, "", err
	}
	defer tx.Rollback()

	var metaRaw []byte
	err = tx.QueryRowContext(
		ctx,
		`SELECT metadata FROM connected_accounts WHERE workspace_id = $1 AND connected_account_id = $2`,
		workspaceID, accountID,
	).Scan(&metaRaw)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return false, "", nil
		}
		return false, "", err
	}
	_ = tx.Commit()
	var meta map[string]any
	if len(metaRaw) > 0 {
		_ = json.Unmarshal(metaRaw, &meta)
	}
	if paused, ok := meta["publish_queue_paused"].(bool); ok && paused {
		r, _ := meta["publish_queue_pause_reason"].(string)
		return true, r, nil
	}
	return false, "", nil
}

func nullIfEmpty(s string) any {
	if strings.TrimSpace(s) == "" {
		return nil
	}
	return s
}
