// Package tenantdb provides P0-06 credit lots, cost-based quotes, reservations,
// append-only ledger transactions, subscriptions, invoices, and payment methods
// queries enforced inside WithTx.
//
// Canonical contract:
//   - docs/04_contracts/database_schema.md (§4.1, §13.1–§13.2, §19.1, §26.1–§26.5)
//   - docs/04_contracts/credit_accounting_contract.md (§1–§4)
package tenantdb

import (
	"context"
	"encoding/json"
	"errors"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
)

// ProviderRateRow models a row in ai_provider_rates (§26.1 [GLOBAL]).
type ProviderRateRow struct {
	RateID     string
	Provider   string
	ModelID    string
	Version    string
	Currency   string
	UnitRates  map[string]string
	SourceURL  string
	VerifiedAt time.Time
	ValidUntil time.Time
	Enabled    bool
}

const upsertProviderRateSQL = `
INSERT INTO ai_provider_rates (
  rate_id, provider, model_id, version, currency, unit_rates, source_url, verified_at, valid_until, enabled
)
VALUES (
  COALESCE(NULLIF($1, '')::uuid, gen_random_uuid()),
  $2, $3, $4, 'USD', $5::jsonb, $6, $7, $8, $9
)
ON CONFLICT (provider, model_id, version) DO UPDATE SET
  unit_rates = EXCLUDED.unit_rates,
  source_url = EXCLUDED.source_url,
  verified_at = EXCLUDED.verified_at,
  valid_until = EXCLUDED.valid_until,
  enabled = EXCLUDED.enabled
RETURNING
  rate_id::text, provider, model_id, version, currency, unit_rates, source_url, verified_at, valid_until, enabled
`

// UpsertProviderRate inserts or updates a global verified provider rate card.
func (q *Queries) UpsertProviderRate(ctx context.Context, arg ProviderRateRow) (ProviderRateRow, error) {
	rawRates, err := json.Marshal(arg.UnitRates)
	if err != nil {
		return ProviderRateRow{}, err
	}
	var row ProviderRateRow
	var rawOut []byte
	err = q.db.QueryRow(
		ctx,
		upsertProviderRateSQL,
		arg.RateID,
		arg.Provider,
		arg.ModelID,
		arg.Version,
		rawRates,
		arg.SourceURL,
		arg.VerifiedAt,
		arg.ValidUntil,
		arg.Enabled,
	).Scan(
		&row.RateID,
		&row.Provider,
		&row.ModelID,
		&row.Version,
		&row.Currency,
		&rawOut,
		&row.SourceURL,
		&row.VerifiedAt,
		&row.ValidUntil,
		&row.Enabled,
	)
	if err != nil {
		return ProviderRateRow{}, err
	}
	_ = json.Unmarshal(rawOut, &row.UnitRates)
	return row, nil
}

const getActiveProviderRateSQL = `
SELECT
  rate_id::text, provider, model_id, version, currency, unit_rates, source_url, verified_at, valid_until, enabled
FROM ai_provider_rates
WHERE provider = $1
  AND model_id = $2
  AND ($3 = '' OR version = $3)
ORDER BY verified_at DESC
LIMIT 1
`

// GetProviderRate fetches the latest (or version-specific) provider rate card.
func (q *Queries) GetProviderRate(ctx context.Context, provider, modelID, version string) (ProviderRateRow, error) {
	var row ProviderRateRow
	var rawOut []byte
	err := q.db.QueryRow(ctx, getActiveProviderRateSQL, provider, modelID, version).Scan(
		&row.RateID,
		&row.Provider,
		&row.ModelID,
		&row.Version,
		&row.Currency,
		&rawOut,
		&row.SourceURL,
		&row.VerifiedAt,
		&row.ValidUntil,
		&row.Enabled,
	)
	if err != nil {
		return ProviderRateRow{}, err
	}
	_ = json.Unmarshal(rawOut, &row.UnitRates)
	return row, nil
}

const getWorkspaceForUpdateSQL = `
SELECT
  workspace_id::text, name, slug, owner_user_id::text, subscription_tier,
  default_mode::text, enabled_modes::text[], ai_credits_remaining, ai_credits_monthly_limit,
  storage_used_bytes, storage_limit_bytes, settings, locale, timezone, status,
  created_at, updated_at
FROM workspaces
WHERE workspace_id = $1::uuid
FOR UPDATE
`

// GetWorkspaceForUpdate locks and reads the active workspace row inside WithTx.
func (q *Queries) GetWorkspaceForUpdate(ctx context.Context, workspaceID string) (WorkspaceRow, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return WorkspaceRow{}, err
	}
	var row WorkspaceRow
	var remNum, limNum pgtype.Numeric
	err := q.db.QueryRow(ctx, getWorkspaceForUpdateSQL, workspaceID).Scan(
		&row.WorkspaceID,
		&row.Name,
		&row.Slug,
		&row.OwnerUserID,
		&row.SubscriptionTier,
		&row.DefaultMode,
		&row.EnabledModes,
		&remNum,
		&limNum,
		&row.StorageUsedBytes,
		&row.StorageLimitBytes,
		&row.SettingsJSON,
		&row.Locale,
		&row.Timezone,
		&row.Status,
		&row.CreatedAt,
		&row.UpdatedAt,
	)
	if err != nil {
		return WorkspaceRow{}, err
	}
	if row.AICreditsRemaining, err = FromPgNumeric(remNum); err != nil {
		return WorkspaceRow{}, err
	}
	if row.AICreditsMonthlyLimit, err = FromPgNumeric(limNum); err != nil {
		return WorkspaceRow{}, err
	}
	return row, nil
}

const updateWorkspaceCreditProjectionSQL = `
UPDATE workspaces
SET
  ai_credits_remaining = $2,
  ai_credits_monthly_limit = $3,
  subscription_tier = COALESCE(NULLIF($4, ''), subscription_tier),
  updated_at = NOW()
WHERE workspace_id = $1::uuid
`

// UpdateWorkspaceCreditProjection updates the cached workspace credit summary columns inside WithTx.
func (q *Queries) UpdateWorkspaceCreditProjection(ctx context.Context, workspaceID string, remaining, monthlyLimit ExactDecimal, tier string) error {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return err
	}
	_, err := q.db.Exec(
		ctx,
		updateWorkspaceCreditProjectionSQL,
		workspaceID,
		remaining.ToPgNumeric(),
		monthlyLimit.ToPgNumeric(),
		tier,
	)
	return err
}

// CreditQuoteRow models a row in ai_credit_quotes (§26.2).
type CreditQuoteRow struct {
	QuoteID           string
	WorkspaceID       string
	RequestHash       string
	OperationType     string
	RateVersion       string
	ProviderPlanJSON  []byte
	CostCeilingUSD    ExactDecimal
	USDPerCreditFloor ExactDecimal
	GrossMarginFloor  ExactDecimal
	QuotedCredits     ExactDecimal
	ExpiresAt         time.Time
	CreatedAt         time.Time
}

const insertCreditQuoteSQL = `
INSERT INTO ai_credit_quotes (
  quote_id, workspace_id, request_hash, operation_type, rate_version,
  provider_plan, cost_ceiling_usd, usd_per_credit_floor, gross_margin_floor,
  quoted_credits, expires_at
)
VALUES (
  COALESCE(NULLIF($1, '')::uuid, gen_random_uuid()),
  $2::uuid, $3, $4, $5, $6::jsonb, $7, $8, $9, $10, $11
)
RETURNING
  quote_id::text, workspace_id::text, request_hash, operation_type, rate_version,
  provider_plan, cost_ceiling_usd, usd_per_credit_floor, gross_margin_floor,
  quoted_credits, expires_at, created_at
`

// InsertCreditQuote persists an immutable cost-based credit quote inside WithTx.
func (q *Queries) InsertCreditQuote(ctx context.Context, arg CreditQuoteRow) (CreditQuoteRow, error) {
	if _, err := q.requireTenantTx(ctx, arg.WorkspaceID); err != nil {
		return CreditQuoteRow{}, err
	}
	plan := arg.ProviderPlanJSON
	if len(plan) == 0 {
		plan = []byte(`{}`)
	}
	var row CreditQuoteRow
	var costNum, floorNum, marginNum, quotedNum pgtype.Numeric
	err := q.db.QueryRow(
		ctx,
		insertCreditQuoteSQL,
		arg.QuoteID,
		arg.WorkspaceID,
		arg.RequestHash,
		arg.OperationType,
		arg.RateVersion,
		plan,
		arg.CostCeilingUSD.ToPgNumeric(),
		arg.USDPerCreditFloor.ToPgNumeric(),
		arg.GrossMarginFloor.ToPgNumeric(),
		arg.QuotedCredits.ToPgNumeric(),
		arg.ExpiresAt,
	).Scan(
		&row.QuoteID,
		&row.WorkspaceID,
		&row.RequestHash,
		&row.OperationType,
		&row.RateVersion,
		&row.ProviderPlanJSON,
		&costNum,
		&floorNum,
		&marginNum,
		&quotedNum,
		&row.ExpiresAt,
		&row.CreatedAt,
	)
	if err != nil {
		return CreditQuoteRow{}, err
	}
	if row.CostCeilingUSD, err = FromPgNumeric(costNum); err != nil {
		return CreditQuoteRow{}, err
	}
	if row.USDPerCreditFloor, err = FromPgNumeric(floorNum); err != nil {
		return CreditQuoteRow{}, err
	}
	if row.GrossMarginFloor, err = FromPgNumeric(marginNum); err != nil {
		return CreditQuoteRow{}, err
	}
	if row.QuotedCredits, err = FromPgNumeric(quotedNum); err != nil {
		return CreditQuoteRow{}, err
	}
	return row, nil
}

const getCreditQuoteSQL = `
SELECT
  quote_id::text, workspace_id::text, request_hash, operation_type, rate_version,
  provider_plan, cost_ceiling_usd, usd_per_credit_floor, gross_margin_floor,
  quoted_credits, expires_at, created_at
FROM ai_credit_quotes
WHERE workspace_id = $1::uuid
  AND quote_id = $2::uuid
`

// GetCreditQuote retrieves a credit quote for the active workspace inside WithTx.
func (q *Queries) GetCreditQuote(ctx context.Context, workspaceID, quoteID string) (CreditQuoteRow, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return CreditQuoteRow{}, err
	}
	var row CreditQuoteRow
	var costNum, floorNum, marginNum, quotedNum pgtype.Numeric
	err := q.db.QueryRow(ctx, getCreditQuoteSQL, workspaceID, quoteID).Scan(
		&row.QuoteID,
		&row.WorkspaceID,
		&row.RequestHash,
		&row.OperationType,
		&row.RateVersion,
		&row.ProviderPlanJSON,
		&costNum,
		&floorNum,
		&marginNum,
		&quotedNum,
		&row.ExpiresAt,
		&row.CreatedAt,
	)
	if err != nil {
		return CreditQuoteRow{}, err
	}
	if row.CostCeilingUSD, err = FromPgNumeric(costNum); err != nil {
		return CreditQuoteRow{}, err
	}
	if row.USDPerCreditFloor, err = FromPgNumeric(floorNum); err != nil {
		return CreditQuoteRow{}, err
	}
	if row.GrossMarginFloor, err = FromPgNumeric(marginNum); err != nil {
		return CreditQuoteRow{}, err
	}
	if row.QuotedCredits, err = FromPgNumeric(quotedNum); err != nil {
		return CreditQuoteRow{}, err
	}
	return row, nil
}

// CreditLotRow models a row in ai_credit_lots (§26.3).
type CreditLotRow struct {
	LotID            string
	WorkspaceID      string
	SourceType       string
	GrantedCredits   ExactDecimal
	RemainingCredits ExactDecimal
	ReservedCredits  ExactDecimal
	ExpiresAt        *time.Time
	ExternalGrantKey string
	CreatedAt        time.Time
}

const insertCreditLotSQL = `
INSERT INTO ai_credit_lots (
  lot_id, workspace_id, source_type, granted_credits, remaining_credits,
  reserved_credits, expires_at, external_grant_key
)
VALUES (
  COALESCE(NULLIF($1, '')::uuid, gen_random_uuid()),
  $2::uuid, $3, $4, $5, $6, $7, $8
)
ON CONFLICT (workspace_id, external_grant_key) DO NOTHING
RETURNING
  lot_id::text, workspace_id::text, source_type, granted_credits,
  remaining_credits, reserved_credits, expires_at, external_grant_key, created_at
`

// InsertCreditLotIdempotent inserts a credit lot once per (workspace_id, external_grant_key) inside WithTx.
// Returns (row, true, nil) when newly inserted, or (existingRow, false, nil) on duplicate external_grant_key.
func (q *Queries) InsertCreditLotIdempotent(ctx context.Context, arg CreditLotRow) (CreditLotRow, bool, error) {
	if _, err := q.requireTenantTx(ctx, arg.WorkspaceID); err != nil {
		return CreditLotRow{}, false, err
	}
	var row CreditLotRow
	var grantNum, remNum, resNum pgtype.Numeric
	err := q.db.QueryRow(
		ctx,
		insertCreditLotSQL,
		arg.LotID,
		arg.WorkspaceID,
		arg.SourceType,
		arg.GrantedCredits.ToPgNumeric(),
		arg.RemainingCredits.ToPgNumeric(),
		arg.ReservedCredits.ToPgNumeric(),
		arg.ExpiresAt,
		arg.ExternalGrantKey,
	).Scan(
		&row.LotID,
		&row.WorkspaceID,
		&row.SourceType,
		&grantNum,
		&remNum,
		&resNum,
		&row.ExpiresAt,
		&row.ExternalGrantKey,
		&row.CreatedAt,
	)
	if err == nil {
		if row.GrantedCredits, err = FromPgNumeric(grantNum); err != nil {
			return CreditLotRow{}, false, err
		}
		if row.RemainingCredits, err = FromPgNumeric(remNum); err != nil {
			return CreditLotRow{}, false, err
		}
		if row.ReservedCredits, err = FromPgNumeric(resNum); err != nil {
			return CreditLotRow{}, false, err
		}
		return row, true, nil
	}

	if !errors.Is(err, pgx.ErrNoRows) {
		return CreditLotRow{}, false, err
	}

	// Duplicate external_grant_key -> read existing lot.
	existing, getErr := q.GetCreditLotByGrantKey(ctx, arg.WorkspaceID, arg.ExternalGrantKey)
	if getErr != nil {
		return CreditLotRow{}, false, getErr
	}
	return existing, false, nil
}

const getCreditLotByGrantKeySQL = `
SELECT
  lot_id::text, workspace_id::text, source_type, granted_credits,
  remaining_credits, reserved_credits, expires_at, external_grant_key, created_at
FROM ai_credit_lots
WHERE workspace_id = $1::uuid
  AND external_grant_key = $2
`

// GetCreditLotByGrantKey fetches a credit lot by (workspace_id, external_grant_key) inside WithTx.
func (q *Queries) GetCreditLotByGrantKey(ctx context.Context, workspaceID, grantKey string) (CreditLotRow, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return CreditLotRow{}, err
	}
	var row CreditLotRow
	var grantNum, remNum, resNum pgtype.Numeric
	err := q.db.QueryRow(ctx, getCreditLotByGrantKeySQL, workspaceID, grantKey).Scan(
		&row.LotID,
		&row.WorkspaceID,
		&row.SourceType,
		&grantNum,
		&remNum,
		&resNum,
		&row.ExpiresAt,
		&row.ExternalGrantKey,
		&row.CreatedAt,
	)
	if err != nil {
		return CreditLotRow{}, err
	}
	if row.GrantedCredits, err = FromPgNumeric(grantNum); err != nil {
		return CreditLotRow{}, err
	}
	if row.RemainingCredits, err = FromPgNumeric(remNum); err != nil {
		return CreditLotRow{}, err
	}
	if row.ReservedCredits, err = FromPgNumeric(resNum); err != nil {
		return CreditLotRow{}, err
	}
	return row, nil
}

// Consumption order from credit_accounting_contract.md §1:
// 1. promotional (earliest expires_at first)
// 2. subscription (earliest expires_at first)
// 3. purchased (expires_at IS NULL, FIFO by created_at)
// 4. overage (FIFO by created_at)
const listCreditLotsForUpdateSQL = `
SELECT
  lot_id::text, workspace_id::text, source_type, granted_credits,
  remaining_credits, reserved_credits, expires_at, external_grant_key, created_at
FROM ai_credit_lots
WHERE workspace_id = $1::uuid
ORDER BY
  CASE source_type
    WHEN 'promotional' THEN 1
    WHEN 'subscription' THEN 2
    WHEN 'purchased' THEN 3
    WHEN 'overage' THEN 4
    ELSE 5
  END ASC,
  expires_at ASC NULLS LAST,
  created_at ASC,
  lot_id ASC
FOR UPDATE
`

// ListCreditLotsForUpdate locks and returns all credit lots for a workspace in canonical consumption priority order.
func (q *Queries) ListCreditLotsForUpdate(ctx context.Context, workspaceID string) ([]CreditLotRow, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return nil, err
	}
	rows, err := q.db.Query(ctx, listCreditLotsForUpdateSQL, workspaceID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []CreditLotRow
	for rows.Next() {
		var row CreditLotRow
		var grantNum, remNum, resNum pgtype.Numeric
		if err := rows.Scan(
			&row.LotID,
			&row.WorkspaceID,
			&row.SourceType,
			&grantNum,
			&remNum,
			&resNum,
			&row.ExpiresAt,
			&row.ExternalGrantKey,
			&row.CreatedAt,
		); err != nil {
			return nil, err
		}
		if row.GrantedCredits, err = FromPgNumeric(grantNum); err != nil {
			return nil, err
		}
		if row.RemainingCredits, err = FromPgNumeric(remNum); err != nil {
			return nil, err
		}
		if row.ReservedCredits, err = FromPgNumeric(resNum); err != nil {
			return nil, err
		}
		out = append(out, row)
	}
	return out, rows.Err()
}

const updateCreditLotBalancesSQL = `
UPDATE ai_credit_lots
SET
  remaining_credits = $3,
  reserved_credits = $4
WHERE workspace_id = $1::uuid
  AND lot_id = $2::uuid
`

// UpdateCreditLotBalances updates remaining_credits and reserved_credits on a locked lot inside WithTx.
func (q *Queries) UpdateCreditLotBalances(ctx context.Context, workspaceID, lotID string, remaining, reserved ExactDecimal) error {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return err
	}
	_, err := q.db.Exec(
		ctx,
		updateCreditLotBalancesSQL,
		workspaceID,
		lotID,
		remaining.ToPgNumeric(),
		reserved.ToPgNumeric(),
	)
	return err
}

// CreditReservationRow models a row in ai_credit_reservations (§26.4).
type CreditReservationRow struct {
	ReservationID     string
	WorkspaceID       string
	QuoteID           string
	IdempotencyKey    string
	RequestHash       string
	Status            string
	ReservedCredits   ExactDecimal
	ActualCredits     *ExactDecimal
	ExpiresAt         time.Time
	LastHeartbeatAt   *time.Time
	ProviderRequestID string
	TerminalReason    string
	CreatedAt         time.Time
	UpdatedAt         time.Time
}

// CreditReservationAllocationRow models a row in ai_credit_reservation_allocations (§26.5).
type CreditReservationAllocationRow struct {
	AllocationID  string
	WorkspaceID   string
	ReservationID string
	LotID         string
	Credits       ExactDecimal
}

const countActiveReservationsSQL = `
SELECT COUNT(*)
FROM ai_credit_reservations
WHERE workspace_id = $1::uuid
  AND status IN ('held', 'in_flight', 'reconciling')
`

// CountActiveReservations returns the count of active (held/in_flight/reconciling) reservations for a workspace.
func (q *Queries) CountActiveReservations(ctx context.Context, workspaceID string) (int, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return 0, err
	}
	var count int
	err := q.db.QueryRow(ctx, countActiveReservationsSQL, workspaceID).Scan(&count)
	return count, err
}

const getReservationByIdempotencyKeySQL = `
SELECT
  reservation_id::text, workspace_id::text, quote_id::text, idempotency_key,
  request_hash, status, reserved_credits, actual_credits, expires_at,
  last_heartbeat_at, COALESCE(provider_request_id, ''), COALESCE(terminal_reason, ''),
  created_at, updated_at
FROM ai_credit_reservations
WHERE workspace_id = $1::uuid
  AND idempotency_key = $2
FOR UPDATE
`

// GetReservationByIdempotencyKeyForUpdate looks up an existing reservation by (workspace_id, idempotency_key) inside WithTx.
func (q *Queries) GetReservationByIdempotencyKeyForUpdate(ctx context.Context, workspaceID, idempotencyKey string) (CreditReservationRow, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return CreditReservationRow{}, err
	}
	return scanReservationRow(q.db.QueryRow(ctx, getReservationByIdempotencyKeySQL, workspaceID, idempotencyKey))
}

const getReservationForUpdateSQL = `
SELECT
  reservation_id::text, workspace_id::text, quote_id::text, idempotency_key,
  request_hash, status, reserved_credits, actual_credits, expires_at,
  last_heartbeat_at, COALESCE(provider_request_id, ''), COALESCE(terminal_reason, ''),
  created_at, updated_at
FROM ai_credit_reservations
WHERE workspace_id = $1::uuid
  AND reservation_id = $2::uuid
FOR UPDATE
`

// GetReservationForUpdate locks and returns a credit reservation inside WithTx.
func (q *Queries) GetReservationForUpdate(ctx context.Context, workspaceID, reservationID string) (CreditReservationRow, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return CreditReservationRow{}, err
	}
	return scanReservationRow(q.db.QueryRow(ctx, getReservationForUpdateSQL, workspaceID, reservationID))
}

func scanReservationRow(r interface{ Scan(dest ...any) error }) (CreditReservationRow, error) {
	var row CreditReservationRow
	var resNum, actNum pgtype.Numeric
	err := r.Scan(
		&row.ReservationID,
		&row.WorkspaceID,
		&row.QuoteID,
		&row.IdempotencyKey,
		&row.RequestHash,
		&row.Status,
		&resNum,
		&actNum,
		&row.ExpiresAt,
		&row.LastHeartbeatAt,
		&row.ProviderRequestID,
		&row.TerminalReason,
		&row.CreatedAt,
		&row.UpdatedAt,
	)
	if err != nil {
		return CreditReservationRow{}, err
	}
	if row.ReservedCredits, err = FromPgNumeric(resNum); err != nil {
		return CreditReservationRow{}, err
	}
	if actNum.Valid {
		actDec, err := FromPgNumeric(actNum)
		if err != nil {
			return CreditReservationRow{}, err
		}
		row.ActualCredits = &actDec
	}
	return row, nil
}

const insertReservationSQL = `
INSERT INTO ai_credit_reservations (
  reservation_id, workspace_id, quote_id, idempotency_key, request_hash,
  status, reserved_credits, expires_at
)
VALUES (
  COALESCE(NULLIF($1, '')::uuid, gen_random_uuid()),
  $2::uuid, $3::uuid, $4, $5, $6, $7, $8
)
RETURNING
  reservation_id::text, workspace_id::text, quote_id::text, idempotency_key,
  request_hash, status, reserved_credits, actual_credits, expires_at,
  last_heartbeat_at, COALESCE(provider_request_id, ''), COALESCE(terminal_reason, ''),
  created_at, updated_at
`

// InsertReservation creates a new held credit reservation inside WithTx.
func (q *Queries) InsertReservation(ctx context.Context, arg CreditReservationRow) (CreditReservationRow, error) {
	if _, err := q.requireTenantTx(ctx, arg.WorkspaceID); err != nil {
		return CreditReservationRow{}, err
	}
	return scanReservationRow(q.db.QueryRow(
		ctx,
		insertReservationSQL,
		arg.ReservationID,
		arg.WorkspaceID,
		arg.QuoteID,
		arg.IdempotencyKey,
		arg.RequestHash,
		arg.Status,
		arg.ReservedCredits.ToPgNumeric(),
		arg.ExpiresAt,
	))
}

const updateReservationStatusSQL = `
UPDATE ai_credit_reservations
SET
  status = $3,
  actual_credits = $4,
  last_heartbeat_at = $5,
  provider_request_id = NULLIF($6, ''),
  terminal_reason = NULLIF($7, ''),
  updated_at = NOW()
WHERE workspace_id = $1::uuid
  AND reservation_id = $2::uuid
RETURNING
  reservation_id::text, workspace_id::text, quote_id::text, idempotency_key,
  request_hash, status, reserved_credits, actual_credits, expires_at,
  last_heartbeat_at, COALESCE(provider_request_id, ''), COALESCE(terminal_reason, ''),
  created_at, updated_at
`

// UpdateReservationStatus transitions a reservation state inside WithTx.
func (q *Queries) UpdateReservationStatus(
	ctx context.Context,
	workspaceID, reservationID, status string,
	actualCredits *ExactDecimal,
	lastHeartbeat *time.Time,
	providerRequestID, terminalReason string,
) (CreditReservationRow, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return CreditReservationRow{}, err
	}
	var actNum pgtype.Numeric
	if actualCredits != nil {
		actNum = actualCredits.ToPgNumeric()
	}
	return scanReservationRow(q.db.QueryRow(
		ctx,
		updateReservationStatusSQL,
		workspaceID,
		reservationID,
		status,
		actNum,
		lastHeartbeat,
		providerRequestID,
		terminalReason,
	))
}

const insertReservationAllocationSQL = `
INSERT INTO ai_credit_reservation_allocations (
  allocation_id, workspace_id, reservation_id, lot_id, credits
)
VALUES (
  COALESCE(NULLIF($1, '')::uuid, gen_random_uuid()),
  $2::uuid, $3::uuid, $4::uuid, $5
)
RETURNING allocation_id::text, workspace_id::text, reservation_id::text, lot_id::text, credits
`

// InsertReservationAllocation records a reservation-to-lot credit allocation inside WithTx.
func (q *Queries) InsertReservationAllocation(ctx context.Context, arg CreditReservationAllocationRow) (CreditReservationAllocationRow, error) {
	if _, err := q.requireTenantTx(ctx, arg.WorkspaceID); err != nil {
		return CreditReservationAllocationRow{}, err
	}
	var row CreditReservationAllocationRow
	var credNum pgtype.Numeric
	err := q.db.QueryRow(
		ctx,
		insertReservationAllocationSQL,
		arg.AllocationID,
		arg.WorkspaceID,
		arg.ReservationID,
		arg.LotID,
		arg.Credits.ToPgNumeric(),
	).Scan(&row.AllocationID, &row.WorkspaceID, &row.ReservationID, &row.LotID, &credNum)
	if err != nil {
		return CreditReservationAllocationRow{}, err
	}
	row.Credits, err = FromPgNumeric(credNum)
	return row, err
}

const listReservationAllocationsSQL = `
SELECT
  a.allocation_id::text, a.workspace_id::text, a.reservation_id::text, a.lot_id::text, a.credits
FROM ai_credit_reservation_allocations a
JOIN ai_credit_lots l ON l.workspace_id = a.workspace_id AND l.lot_id = a.lot_id
WHERE a.workspace_id = $1::uuid
  AND a.reservation_id = $2::uuid
ORDER BY
  CASE l.source_type
    WHEN 'promotional' THEN 1
    WHEN 'subscription' THEN 2
    WHEN 'purchased' THEN 3
    WHEN 'overage' THEN 4
    ELSE 5
  END ASC,
  l.expires_at ASC NULLS LAST,
  l.created_at ASC,
  l.lot_id ASC
`

// ListReservationAllocations returns the lot allocations for a reservation in consumption priority order.
func (q *Queries) ListReservationAllocations(ctx context.Context, workspaceID, reservationID string) ([]CreditReservationAllocationRow, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return nil, err
	}
	rows, err := q.db.Query(ctx, listReservationAllocationsSQL, workspaceID, reservationID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []CreditReservationAllocationRow
	for rows.Next() {
		var row CreditReservationAllocationRow
		var credNum pgtype.Numeric
		if err := rows.Scan(&row.AllocationID, &row.WorkspaceID, &row.ReservationID, &row.LotID, &credNum); err != nil {
			return nil, err
		}
		if row.Credits, err = FromPgNumeric(credNum); err != nil {
			return nil, err
		}
		out = append(out, row)
	}
	return out, rows.Err()
}

// CreditTransactionRow models an immutable append-only row in ai_credit_transactions (§13.2).
type CreditTransactionRow struct {
	TransactionID          string
	WorkspaceID            string
	UserID                 string
	OperationType          string
	CreditsDelta           ExactDecimal
	BalanceAfter           ExactDecimal
	Source                 string
	ReferenceID            string
	ReservationID          string
	LotID                  string
	QuoteID                string
	ReferenceTransactionID string
	ProviderCostUSD        *ExactDecimal
	RateVersion            string
	IdempotencyKey         string
	Description            string
	CreatedAt              time.Time
}

const insertCreditTransactionSQL = `
INSERT INTO ai_credit_transactions (
  transaction_id, workspace_id, transaction_type, credits,
  balance_after, operation_type, generation_job_id, actual_cost,
  reservation_id, lot_id, reference_transaction_id, idempotency_key, description
)
VALUES (
  COALESCE(NULLIF($1, '')::uuid, gen_random_uuid()),
  $2::uuid,
  COALESCE(NULLIF($3, ''), 'debit'),
  $4,
  $5,
  NULLIF($6, ''),
  NULLIF($7, '')::uuid,
  $8,
  NULLIF($9, '')::uuid,
  NULLIF($10, '')::uuid,
  NULLIF($11, '')::uuid,
  NULLIF($12, ''),
  NULLIF($13, '')
)
ON CONFLICT (workspace_id, idempotency_key) WHERE idempotency_key IS NOT NULL DO NOTHING
RETURNING
  transaction_id::text, workspace_id::text, COALESCE(operation_type, ''),
  credits, balance_after, transaction_type,
  COALESCE(generation_job_id::text, ''), COALESCE(reservation_id::text, ''),
  COALESCE(lot_id::text, ''), COALESCE(reference_transaction_id::text, ''),
  actual_cost, COALESCE(idempotency_key, ''), COALESCE(description, ''), created_at
`

// InsertCreditTransaction appends an immutable row to ai_credit_transactions inside WithTx.
func (q *Queries) InsertCreditTransaction(ctx context.Context, arg CreditTransactionRow) (CreditTransactionRow, bool, error) {
	if _, err := q.requireTenantTx(ctx, arg.WorkspaceID); err != nil {
		return CreditTransactionRow{}, false, err
	}
	var costNum pgtype.Numeric
	if arg.ProviderCostUSD != nil {
		costNum = arg.ProviderCostUSD.ToPgNumeric()
	}
	var row CreditTransactionRow
	var deltaNum, balNum, outCostNum pgtype.Numeric
	err := q.db.QueryRow(
		ctx,
		insertCreditTransactionSQL,
		arg.TransactionID,
		arg.WorkspaceID,
		arg.Source,
		arg.CreditsDelta.ToPgNumeric(),
		arg.BalanceAfter.ToPgNumeric(),
		arg.OperationType,
		arg.ReferenceID,
		costNum,
		arg.ReservationID,
		arg.LotID,
		arg.ReferenceTransactionID,
		arg.IdempotencyKey,
		arg.Description,
	).Scan(
		&row.TransactionID,
		&row.WorkspaceID,
		&row.OperationType,
		&deltaNum,
		&balNum,
		&row.Source,
		&row.ReferenceID,
		&row.ReservationID,
		&row.LotID,
		&row.ReferenceTransactionID,
		&outCostNum,
		&row.IdempotencyKey,
		&row.Description,
		&row.CreatedAt,
	)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return CreditTransactionRow{}, false, nil
		}
		return CreditTransactionRow{}, false, err
	}
	row.UserID = arg.UserID
	row.QuoteID = arg.QuoteID
	row.RateVersion = arg.RateVersion
	if row.CreditsDelta, err = FromPgNumeric(deltaNum); err != nil {
		return CreditTransactionRow{}, false, err
	}
	if row.BalanceAfter, err = FromPgNumeric(balNum); err != nil {
		return CreditTransactionRow{}, false, err
	}
	if outCostNum.Valid {
		cDec, err := FromPgNumeric(outCostNum)
		if err != nil {
			return CreditTransactionRow{}, false, err
		}
		row.ProviderCostUSD = &cDec
	}
	return row, true, nil
}

const listCreditTransactionsSQL = `
SELECT
  transaction_id::text, workspace_id::text, COALESCE(operation_type, ''),
  credits, balance_after, transaction_type,
  COALESCE(generation_job_id::text, ''), COALESCE(reservation_id::text, ''),
  COALESCE(lot_id::text, ''), COALESCE(reference_transaction_id::text, ''),
  actual_cost, COALESCE(idempotency_key, ''), COALESCE(description, ''), created_at
FROM ai_credit_transactions
WHERE workspace_id = $1::uuid
ORDER BY created_at DESC, transaction_id DESC
`

// ListCreditTransactions returns the append-only credit ledger entries for a workspace inside WithTx.
func (q *Queries) ListCreditTransactions(ctx context.Context, workspaceID string) ([]CreditTransactionRow, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return nil, err
	}
	rows, err := q.db.Query(ctx, listCreditTransactionsSQL, workspaceID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []CreditTransactionRow
	for rows.Next() {
		var row CreditTransactionRow
		var deltaNum, balNum, outCostNum pgtype.Numeric
		if err := rows.Scan(
			&row.TransactionID,
			&row.WorkspaceID,
			&row.OperationType,
			&deltaNum,
			&balNum,
			&row.Source,
			&row.ReferenceID,
			&row.ReservationID,
			&row.LotID,
			&row.ReferenceTransactionID,
			&outCostNum,
			&row.IdempotencyKey,
			&row.Description,
			&row.CreatedAt,
		); err != nil {
			return nil, err
		}
		if row.CreditsDelta, err = FromPgNumeric(deltaNum); err != nil {
			return nil, err
		}
		if row.BalanceAfter, err = FromPgNumeric(balNum); err != nil {
			return nil, err
		}
		if outCostNum.Valid {
			cDec, err := FromPgNumeric(outCostNum)
			if err != nil {
				return nil, err
			}
			row.ProviderCostUSD = &cDec
		}
		out = append(out, row)
	}
	return out, rows.Err()
}

// SubscriptionRow models a row in subscriptions (§19.1).
type SubscriptionRow struct {
	SubscriptionID       string
	WorkspaceID          string
	StripeCustomerID     string
	StripeSubscriptionID string
	Plan                 string
	BillingInterval      string
	Status               string
	Amount               ExactDecimal
	Currency             string
	CurrentPeriodStart   time.Time
	CurrentPeriodEnd     time.Time
	CancelAtPeriodEnd    bool
	CanceledAt           *time.Time
	TrialEnd             *time.Time
	Addons               []string
	MetadataJSON         []byte
	CreatedAt            time.Time
	UpdatedAt            time.Time
}

const upsertSubscriptionSQL = `
INSERT INTO subscriptions (
  subscription_id, workspace_id, stripe_subscription_id,
  plan_tier, billing_interval, status, current_period_start,
  current_period_end, cancelled_at, trial_ends_at
)
VALUES (
  COALESCE(NULLIF($1, '')::uuid, gen_random_uuid()),
  $2::uuid,
  NULLIF($3, ''),
  $4,
  $5,
  $6,
  $7,
  $8,
  $9,
  $10
)
ON CONFLICT (subscription_id) DO UPDATE SET
  stripe_subscription_id = COALESCE(EXCLUDED.stripe_subscription_id, subscriptions.stripe_subscription_id),
  plan_tier = EXCLUDED.plan_tier,
  billing_interval = EXCLUDED.billing_interval,
  status = EXCLUDED.status,
  current_period_start = EXCLUDED.current_period_start,
  current_period_end = EXCLUDED.current_period_end,
  cancelled_at = EXCLUDED.cancelled_at,
  trial_ends_at = EXCLUDED.trial_ends_at,
  updated_at = NOW()
RETURNING
  subscription_id::text, workspace_id::text,
  COALESCE(stripe_subscription_id, ''), plan_tier, billing_interval, status,
  current_period_start, current_period_end,
  cancelled_at, trial_ends_at, created_at, updated_at
`

// UpsertSubscription inserts or updates a workspace subscription inside WithTx.
func (q *Queries) UpsertSubscription(ctx context.Context, arg SubscriptionRow) (SubscriptionRow, error) {
	if _, err := q.requireTenantTx(ctx, arg.WorkspaceID); err != nil {
		return SubscriptionRow{}, err
	}
	var row SubscriptionRow
	err := q.db.QueryRow(
		ctx,
		upsertSubscriptionSQL,
		arg.SubscriptionID,
		arg.WorkspaceID,
		arg.StripeSubscriptionID,
		arg.Plan,
		arg.BillingInterval,
		arg.Status,
		arg.CurrentPeriodStart,
		arg.CurrentPeriodEnd,
		arg.CanceledAt,
		arg.TrialEnd,
	).Scan(
		&row.SubscriptionID,
		&row.WorkspaceID,
		&row.StripeSubscriptionID,
		&row.Plan,
		&row.BillingInterval,
		&row.Status,
		&row.CurrentPeriodStart,
		&row.CurrentPeriodEnd,
		&row.CanceledAt,
		&row.TrialEnd,
		&row.CreatedAt,
		&row.UpdatedAt,
	)
	if err != nil {
		return SubscriptionRow{}, err
	}
	row.StripeCustomerID = arg.StripeCustomerID
	row.Amount = arg.Amount
	row.Currency = arg.Currency
	row.CancelAtPeriodEnd = arg.CancelAtPeriodEnd
	row.Addons = arg.Addons
	row.MetadataJSON = arg.MetadataJSON
	return row, nil
}

const getWorkspaceSubscriptionSQL = `
SELECT
  subscription_id::text, workspace_id::text,
  COALESCE(stripe_subscription_id, ''), plan_tier, billing_interval, status,
  current_period_start, current_period_end,
  cancelled_at, trial_ends_at, created_at, updated_at
FROM subscriptions
WHERE workspace_id = $1::uuid
ORDER BY created_at DESC
LIMIT 1
`

// GetWorkspaceSubscription returns the latest subscription for a workspace inside WithTx.
func (q *Queries) GetWorkspaceSubscription(ctx context.Context, workspaceID string) (SubscriptionRow, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return SubscriptionRow{}, err
	}
	var row SubscriptionRow
	err := q.db.QueryRow(ctx, getWorkspaceSubscriptionSQL, workspaceID).Scan(
		&row.SubscriptionID,
		&row.WorkspaceID,
		&row.StripeSubscriptionID,
		&row.Plan,
		&row.BillingInterval,
		&row.Status,
		&row.CurrentPeriodStart,
		&row.CurrentPeriodEnd,
		&row.CanceledAt,
		&row.TrialEnd,
		&row.CreatedAt,
		&row.UpdatedAt,
	)
	if err != nil {
		return SubscriptionRow{}, err
	}
	row.Currency = "USD"
	return row, nil
}

// InvoiceRow models a row in invoices (§19.1B).
type InvoiceRow struct {
	InvoiceID        string
	WorkspaceID      string
	SubscriptionID   string
	StripeInvoiceID  string
	InvoiceNumber    string
	Status           string
	Currency         string
	Subtotal         ExactDecimal
	DiscountAmount   ExactDecimal
	TaxAmount        ExactDecimal
	Total            ExactDecimal
	AmountPaid       ExactDecimal
	AmountDue        ExactDecimal
	InvoicePDFURL    string
	HostedInvoiceURL string
	PeriodStart      *time.Time
	PeriodEnd        *time.Time
	DueDate          *time.Time
	PaidAt           *time.Time
	LineItemsJSON    []byte
	CreatedAt        time.Time
	UpdatedAt        time.Time
}

const insertInvoiceSQL = `
INSERT INTO invoices (
  invoice_id, workspace_id, subscription_id, stripe_invoice_id, invoice_number,
  status, currency, subtotal, discount_amount, tax_amount, total, amount_paid,
  amount_due, invoice_pdf_url, hosted_invoice_url, period_start, period_end,
  due_date, paid_at, line_items
)
VALUES (
  COALESCE(NULLIF($1, '')::uuid, gen_random_uuid()),
  $2::uuid,
  NULLIF($3, '')::uuid,
  NULLIF($4, ''),
  $5,
  $6,
  $7,
  $8,
  $9,
  $10,
  $11,
  $12,
  $13,
  NULLIF($14, ''),
  NULLIF($15, ''),
  $16,
  $17,
  $18,
  $19,
  $20::jsonb
)
RETURNING
  invoice_id::text, workspace_id::text, COALESCE(subscription_id::text, ''),
  COALESCE(stripe_invoice_id, ''), invoice_number, status, currency,
  subtotal, discount_amount, tax_amount, total, amount_paid, amount_due,
  COALESCE(invoice_pdf_url, ''), COALESCE(hosted_invoice_url, ''),
  period_start, period_end, due_date, paid_at, line_items, created_at, updated_at
`

// InsertInvoice inserts a billing invoice inside WithTx.
func (q *Queries) InsertInvoice(ctx context.Context, arg InvoiceRow) (InvoiceRow, error) {
	if _, err := q.requireTenantTx(ctx, arg.WorkspaceID); err != nil {
		return InvoiceRow{}, err
	}
	items := arg.LineItemsJSON
	if len(items) == 0 {
		items = []byte(`[]`)
	}
	var row InvoiceRow
	var subNum, discNum, taxNum, totNum, paidNum, dueNum pgtype.Numeric
	err := q.db.QueryRow(
		ctx,
		insertInvoiceSQL,
		arg.InvoiceID,
		arg.WorkspaceID,
		arg.SubscriptionID,
		arg.StripeInvoiceID,
		arg.InvoiceNumber,
		arg.Status,
		arg.Currency,
		arg.Subtotal.ToPgNumeric(),
		arg.DiscountAmount.ToPgNumeric(),
		arg.TaxAmount.ToPgNumeric(),
		arg.Total.ToPgNumeric(),
		arg.AmountPaid.ToPgNumeric(),
		arg.AmountDue.ToPgNumeric(),
		arg.InvoicePDFURL,
		arg.HostedInvoiceURL,
		arg.PeriodStart,
		arg.PeriodEnd,
		arg.DueDate,
		arg.PaidAt,
		items,
	).Scan(
		&row.InvoiceID,
		&row.WorkspaceID,
		&row.SubscriptionID,
		&row.StripeInvoiceID,
		&row.InvoiceNumber,
		&row.Status,
		&row.Currency,
		&subNum,
		&discNum,
		&taxNum,
		&totNum,
		&paidNum,
		&dueNum,
		&row.InvoicePDFURL,
		&row.HostedInvoiceURL,
		&row.PeriodStart,
		&row.PeriodEnd,
		&row.DueDate,
		&row.PaidAt,
		&row.LineItemsJSON,
		&row.CreatedAt,
		&row.UpdatedAt,
	)
	if err != nil {
		return InvoiceRow{}, err
	}
	if row.Subtotal, err = FromPgNumeric(subNum); err != nil {
		return InvoiceRow{}, err
	}
	if row.DiscountAmount, err = FromPgNumeric(discNum); err != nil {
		return InvoiceRow{}, err
	}
	if row.TaxAmount, err = FromPgNumeric(taxNum); err != nil {
		return InvoiceRow{}, err
	}
	if row.Total, err = FromPgNumeric(totNum); err != nil {
		return InvoiceRow{}, err
	}
	if row.AmountPaid, err = FromPgNumeric(paidNum); err != nil {
		return InvoiceRow{}, err
	}
	if row.AmountDue, err = FromPgNumeric(dueNum); err != nil {
		return InvoiceRow{}, err
	}
	return row, nil
}

// PaymentMethodRow models a row in payment_methods (§19.1C).
type PaymentMethodRow struct {
	PaymentMethodID       string
	WorkspaceID           string
	StripePaymentMethodID string
	Type                  string
	CardBrand             string
	CardLast4             string
	CardExpMonth          int32
	CardExpYear           int32
	IsDefault             bool
	BillingDetailsJSON    []byte
	CreatedAt             time.Time
	UpdatedAt             time.Time
}

const insertPaymentMethodSQL = `
INSERT INTO payment_methods (
  payment_method_id, workspace_id, stripe_payment_method_id, type,
  card_brand, card_last4, card_exp_month, card_exp_year, is_default, billing_details
)
VALUES (
  COALESCE(NULLIF($1, '')::uuid, gen_random_uuid()),
  $2::uuid, $3, $4, NULLIF($5, ''), NULLIF($6, ''), $7, $8, $9, $10::jsonb
)
RETURNING
  payment_method_id::text, workspace_id::text, stripe_payment_method_id, type,
  COALESCE(card_brand, ''), COALESCE(card_last4, ''),
  COALESCE(card_exp_month, 0)::int, COALESCE(card_exp_year, 0)::int,
  is_default, billing_details, created_at, updated_at
`

// InsertPaymentMethod adds a payment method for the workspace inside WithTx.
func (q *Queries) InsertPaymentMethod(ctx context.Context, arg PaymentMethodRow) (PaymentMethodRow, error) {
	if _, err := q.requireTenantTx(ctx, arg.WorkspaceID); err != nil {
		return PaymentMethodRow{}, err
	}
	if arg.IsDefault {
		if _, err := q.db.Exec(ctx, `UPDATE payment_methods SET is_default = false, updated_at = NOW() WHERE workspace_id = $1::uuid`, arg.WorkspaceID); err != nil {
			return PaymentMethodRow{}, err
		}
	}
	details := arg.BillingDetailsJSON
	if len(details) == 0 {
		details = []byte(`{}`)
	}
	var row PaymentMethodRow
	err := q.db.QueryRow(
		ctx,
		insertPaymentMethodSQL,
		arg.PaymentMethodID,
		arg.WorkspaceID,
		arg.StripePaymentMethodID,
		arg.Type,
		arg.CardBrand,
		arg.CardLast4,
		arg.CardExpMonth,
		arg.CardExpYear,
		arg.IsDefault,
		details,
	).Scan(
		&row.PaymentMethodID,
		&row.WorkspaceID,
		&row.StripePaymentMethodID,
		&row.Type,
		&row.CardBrand,
		&row.CardLast4,
		&row.CardExpMonth,
		&row.CardExpYear,
		&row.IsDefault,
		&row.BillingDetailsJSON,
		&row.CreatedAt,
		&row.UpdatedAt,
	)
	return row, err
}

const listPaymentMethodsSQL = `
SELECT
  payment_method_id::text, workspace_id::text, stripe_payment_method_id, type,
  COALESCE(card_brand, ''), COALESCE(card_last4, ''),
  COALESCE(card_exp_month, 0)::int, COALESCE(card_exp_year, 0)::int,
  is_default, billing_details, created_at, updated_at
FROM payment_methods
WHERE workspace_id = $1::uuid
ORDER BY is_default DESC, created_at ASC
`

// ListPaymentMethods returns all payment methods for a workspace inside WithTx.
func (q *Queries) ListPaymentMethods(ctx context.Context, workspaceID string) ([]PaymentMethodRow, error) {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return nil, err
	}
	rows, err := q.db.Query(ctx, listPaymentMethodsSQL, workspaceID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []PaymentMethodRow
	for rows.Next() {
		var row PaymentMethodRow
		if err := rows.Scan(
			&row.PaymentMethodID,
			&row.WorkspaceID,
			&row.StripePaymentMethodID,
			&row.Type,
			&row.CardBrand,
			&row.CardLast4,
			&row.CardExpMonth,
			&row.CardExpYear,
			&row.IsDefault,
			&row.BillingDetailsJSON,
			&row.CreatedAt,
			&row.UpdatedAt,
		); err != nil {
			return nil, err
		}
		out = append(out, row)
	}
	return out, rows.Err()
}

const deletePaymentMethodSQL = `
DELETE FROM payment_methods
WHERE workspace_id = $1::uuid
  AND stripe_payment_method_id = $2
`

// DeletePaymentMethod removes a payment method by stripe_payment_method_id inside WithTx.
func (q *Queries) DeletePaymentMethod(ctx context.Context, workspaceID, stripePaymentMethodID string) error {
	if _, err := q.requireTenantTx(ctx, workspaceID); err != nil {
		return err
	}
	_, err := q.db.Exec(ctx, deletePaymentMethodSQL, workspaceID, stripePaymentMethodID)
	return err
}
