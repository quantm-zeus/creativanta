package store

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

// PostgresStore wraps a base Store with durable PostgreSQL-backed checkout idempotency
// and payment-intent claims in external_effects (UNIQUE (workspace_id, operation_key))
// under tenant RLS (app.current_tenant_id), ensuring cross-instance checkout exclusivity (R02).
type PostgresStore struct {
	Store
	pool *pgxpool.Pool
}

// NewPostgresStore creates a PostgreSQL-backed store for cross-instance checkout coordination.
// If base is nil, a new MemoryStore is initialized for in-memory catalog projections.
func NewPostgresStore(pool *pgxpool.Pool, base Store) *PostgresStore {
	if base == nil {
		base = NewMemoryStore()
	}
	return &PostgresStore{
		Store: base,
		pool:  pool,
	}
}

type pgCheckoutClaimPayload struct {
	IdempotencyKey     string          `json:"idempotency_key"`
	PaymentIntentID    string          `json:"payment_intent_id"`
	RequestFingerprint string          `json:"request_fingerprint"`
	OrderID            string          `json:"order_id"`
	Result             *CheckoutResult `json:"result,omitempty"`
}

func pgIdemOpKey(idempotencyKey string) string {
	return "store_checkout_idem:" + strings.TrimSpace(idempotencyKey)
}

func pgPaymentOpKey(paymentIntentID string) string {
	return "store_checkout_pi:" + strings.TrimSpace(paymentIntentID)
}

func (p *PostgresStore) withTenantTx(ctx context.Context, workspaceID string, fn func(tx pgx.Tx) error) error {
	tx, err := p.pool.Begin(ctx)
	if err != nil {
		return err
	}
	defer func() { _ = tx.Rollback(ctx) }()

	if _, err := tx.Exec(ctx, "SELECT set_config('app.current_tenant_id', $1, true)", workspaceID); err != nil {
		return err
	}
	if err := fn(tx); err != nil {
		return err
	}
	return tx.Commit(ctx)
}

func (p *PostgresStore) ClaimCheckout(ctx context.Context, workspaceID, idempotencyKey, paymentIntentID, requestFingerprint string) (*CheckoutResult, string, error) {
	if p.pool == nil {
		return p.Store.ClaimCheckout(ctx, workspaceID, idempotencyKey, paymentIntentID, requestFingerprint)
	}

	idemOp := pgIdemOpKey(idempotencyKey)
	piOp := ""
	if strings.TrimSpace(paymentIntentID) != "" {
		piOp = pgPaymentOpKey(paymentIntentID)
	}

	for {
		var replayRes *CheckoutResult
		var claimedOrderID string
		var waitForInflight bool

		err := p.withTenantTx(ctx, workspaceID, func(tx pgx.Tx) error {
			// Acquire deterministic transaction-scoped advisory locks in canonical order to prevent deadlocks.
			lock1 := workspaceID + ":" + idemOp
			lock2 := workspaceID + ":" + piOp
			if lock2 < lock1 {
				lock1, lock2 = lock2, lock1
			}
			if _, err := tx.Exec(ctx, "SELECT pg_advisory_xact_lock(hashtext($1)), pg_advisory_xact_lock(hashtext($2))", lock1, lock2); err != nil {
				return err
			}

			// 1. Check existing idempotency key record in external_effects.
			var status string
			var rawPayload []byte
			err := tx.QueryRow(ctx, `
				SELECT status, result_payload
				FROM external_effects
				WHERE workspace_id = $1::uuid AND operation_key = $2
				FOR UPDATE
			`, workspaceID, idemOp).Scan(&status, &rawPayload)
			if err != nil && !errors.Is(err, pgx.ErrNoRows) {
				return err
			}
			if err == nil {
				var payload pgCheckoutClaimPayload
				if len(rawPayload) > 0 {
					_ = json.Unmarshal(rawPayload, &payload)
				}
				if payload.RequestFingerprint != "" && requestFingerprint != "" && payload.RequestFingerprint != requestFingerprint {
					return ErrPaymentReplay
				}
				if payload.PaymentIntentID != "" && paymentIntentID != "" && payload.PaymentIntentID != paymentIntentID {
					return ErrPaymentReplay
				}
				if status == "succeeded" && payload.Result != nil && payload.Result.Status == "confirmed" {
					replayRes = cloneCheckoutResult(payload.Result, true)
					claimedOrderID = payload.OrderID
					return nil
				}
				if status == "prepared" {
					waitForInflight = true
					return nil
				}
				claimedOrderID = payload.OrderID
			}

			// 2. Check existing payment intent claim in external_effects.
			if piOp != "" {
				var piStatus string
				var piRaw []byte
				piErr := tx.QueryRow(ctx, `
					SELECT status, result_payload
					FROM external_effects
					WHERE workspace_id = $1::uuid AND operation_key = $2
					FOR UPDATE
				`, workspaceID, piOp).Scan(&piStatus, &piRaw)
				if piErr != nil && !errors.Is(piErr, pgx.ErrNoRows) {
					return piErr
				}
				if piErr == nil {
					var piPayload pgCheckoutClaimPayload
					if len(piRaw) > 0 {
						_ = json.Unmarshal(piRaw, &piPayload)
					}
					if piPayload.IdempotencyKey != "" && piPayload.IdempotencyKey != idempotencyKey {
						return fmt.Errorf("%w: payment intent %s already consumed by checkout %s", ErrPaymentReplay, paymentIntentID, piPayload.IdempotencyKey)
					}
					if piPayload.RequestFingerprint != "" && requestFingerprint != "" && piPayload.RequestFingerprint != requestFingerprint {
						return ErrPaymentReplay
					}
					if piStatus == "succeeded" && piPayload.Result != nil && piPayload.Result.Status == "confirmed" {
						replayRes = cloneCheckoutResult(piPayload.Result, true)
						claimedOrderID = piPayload.OrderID
						return nil
					}
					if piStatus == "prepared" {
						waitForInflight = true
						return nil
					}
				}
			}

			// 3. Durable claim of both (workspace_id, idemOp) and (workspace_id, piOp).
			if claimedOrderID == "" {
				claimedOrderID = newUUID()
			}
			claimPayload, err := json.Marshal(pgCheckoutClaimPayload{
				IdempotencyKey:     idempotencyKey,
				PaymentIntentID:    paymentIntentID,
				RequestFingerprint: requestFingerprint,
				OrderID:            claimedOrderID,
			})
			if err != nil {
				return err
			}

			_, err = tx.Exec(ctx, `
				INSERT INTO external_effects (
					effect_id, workspace_id, operation_key, provider,
					aggregate_type, aggregate_id, provider_request_id, status, result_payload
				) VALUES ($1::uuid, $2::uuid, $3, 'own_store', 'store_order', $4::uuid, $5, 'prepared', $6::jsonb)
				ON CONFLICT (workspace_id, operation_key) DO UPDATE
				SET status = 'prepared', result_payload = EXCLUDED.result_payload, updated_at = NOW()
			`, newUUID(), workspaceID, idemOp, claimedOrderID, idempotencyKey, string(claimPayload))
			if err != nil {
				return err
			}

			if piOp != "" {
				_, err = tx.Exec(ctx, `
					INSERT INTO external_effects (
						effect_id, workspace_id, operation_key, provider,
						aggregate_type, aggregate_id, provider_request_id, status, result_payload
					) VALUES ($1::uuid, $2::uuid, $3, 'own_store', 'store_order', $4::uuid, $5, 'prepared', $6::jsonb)
					ON CONFLICT (workspace_id, operation_key) DO UPDATE
					SET status = 'prepared', result_payload = EXCLUDED.result_payload, updated_at = NOW()
				`, newUUID(), workspaceID, piOp, claimedOrderID, idempotencyKey, string(claimPayload))
				if err != nil {
					return err
				}
			}
			return nil
		})
		if err != nil {
			return nil, "", err
		}
		if waitForInflight {
			select {
			case <-time.After(15 * time.Millisecond):
				continue
			case <-ctx.Done():
				return nil, "", ctx.Err()
			}
		}
		if replayRes != nil {
			return replayRes, claimedOrderID, nil
		}
		return nil, claimedOrderID, nil
	}
}

func (p *PostgresStore) ReleaseCheckoutClaim(ctx context.Context, workspaceID, idempotencyKey, paymentIntentID string) error {
	_ = p.Store.ReleaseCheckoutClaim(ctx, workspaceID, idempotencyKey, paymentIntentID)
	if p.pool == nil {
		return nil
	}

	idemOp := pgIdemOpKey(idempotencyKey)
	piOp := ""
	if strings.TrimSpace(paymentIntentID) != "" {
		piOp = pgPaymentOpKey(paymentIntentID)
	}

	return p.withTenantTx(ctx, workspaceID, func(tx pgx.Tx) error {
		_, err := tx.Exec(ctx, `
			DELETE FROM external_effects
			WHERE workspace_id = $1::uuid AND operation_key = $2 AND status = 'prepared'
		`, workspaceID, idemOp)
		if err != nil {
			return err
		}
		if piOp != "" {
			_, err = tx.Exec(ctx, `
				DELETE FROM external_effects
				WHERE workspace_id = $1::uuid AND operation_key = $2 AND status = 'prepared' AND provider_request_id = $3
			`, workspaceID, piOp, idempotencyKey)
			if err != nil {
				return err
			}
		}
		return nil
	})
}

func (p *PostgresStore) GetCheckoutResultByIdempotency(ctx context.Context, workspaceID, idempotencyKey string) (*CheckoutResult, error) {
	if p.pool == nil {
		return p.Store.GetCheckoutResultByIdempotency(ctx, workspaceID, idempotencyKey)
	}
	var out *CheckoutResult
	err := p.withTenantTx(ctx, workspaceID, func(tx pgx.Tx) error {
		var raw []byte
		err := tx.QueryRow(ctx, `
			SELECT result_payload
			FROM external_effects
			WHERE workspace_id = $1::uuid AND operation_key = $2 AND status IN ('succeeded', 'submitted')
		`, workspaceID, pgIdemOpKey(idempotencyKey)).Scan(&raw)
		if errors.Is(err, pgx.ErrNoRows) {
			return nil
		}
		if err != nil {
			return err
		}
		var payload pgCheckoutClaimPayload
		if err := json.Unmarshal(raw, &payload); err != nil {
			return err
		}
		if payload.Result != nil {
			out = cloneCheckoutResult(payload.Result, true)
		}
		return nil
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (p *PostgresStore) GetCheckoutByPaymentIntent(ctx context.Context, workspaceID, paymentIntentID string) (*CheckoutResult, string, error) {
	if p.pool == nil {
		return p.Store.GetCheckoutByPaymentIntent(ctx, workspaceID, paymentIntentID)
	}
	var out *CheckoutResult
	var boundIdem string
	err := p.withTenantTx(ctx, workspaceID, func(tx pgx.Tx) error {
		var raw []byte
		err := tx.QueryRow(ctx, `
			SELECT result_payload
			FROM external_effects
			WHERE workspace_id = $1::uuid AND operation_key = $2 AND status IN ('succeeded', 'submitted', 'prepared')
		`, workspaceID, pgPaymentOpKey(paymentIntentID)).Scan(&raw)
		if errors.Is(err, pgx.ErrNoRows) {
			return nil
		}
		if err != nil {
			return err
		}
		var payload pgCheckoutClaimPayload
		if err := json.Unmarshal(raw, &payload); err != nil {
			return err
		}
		boundIdem = payload.IdempotencyKey
		if payload.Result != nil {
			out = cloneCheckoutResult(payload.Result, true)
		}
		return nil
	})
	if err != nil {
		return nil, "", err
	}
	return out, boundIdem, nil
}

func (p *PostgresStore) SaveCheckoutResult(ctx context.Context, workspaceID, idempotencyKey string, res *CheckoutResult) error {
	if p.pool == nil {
		return p.Store.SaveCheckoutResult(ctx, workspaceID, idempotencyKey, res)
	}
	if res == nil {
		return nil
	}

	idemOp := pgIdemOpKey(idempotencyKey)
	piOp := ""
	if strings.TrimSpace(res.PaymentIntentID) != "" {
		piOp = pgPaymentOpKey(res.PaymentIntentID)
	}

	err := p.withTenantTx(ctx, workspaceID, func(tx pgx.Tx) error {
		if piOp != "" {
			var raw []byte
			err := tx.QueryRow(ctx, `
				SELECT result_payload
				FROM external_effects
				WHERE workspace_id = $1::uuid AND operation_key = $2
				FOR UPDATE
			`, workspaceID, piOp).Scan(&raw)
			if err != nil && !errors.Is(err, pgx.ErrNoRows) {
				return err
			}
			if err == nil && len(raw) > 0 {
				var piPayload pgCheckoutClaimPayload
				_ = json.Unmarshal(raw, &piPayload)
				if piPayload.IdempotencyKey != "" && piPayload.IdempotencyKey != idempotencyKey {
					return fmt.Errorf("%w: payment intent %s already consumed by checkout %s", ErrPaymentReplay, res.PaymentIntentID, piPayload.IdempotencyKey)
				}
			}
		}

		cp := cloneCheckoutResult(res, false)
		orderID := cp.OrderID
		if orderID == "" {
			orderID = newUUID()
		}
		payloadBytes, err := json.Marshal(pgCheckoutClaimPayload{
			IdempotencyKey:     idempotencyKey,
			PaymentIntentID:    cp.PaymentIntentID,
			RequestFingerprint: cp.RequestFingerprint,
			OrderID:            orderID,
			Result:             cp,
		})
		if err != nil {
			return err
		}

		effStatus := "submitted"
		if cp.Status == "confirmed" {
			effStatus = "succeeded"
		}

		_, err = tx.Exec(ctx, `
			INSERT INTO external_effects (
				effect_id, workspace_id, operation_key, provider,
				aggregate_type, aggregate_id, provider_request_id, status, result_payload
			) VALUES ($1::uuid, $2::uuid, $3, 'own_store', 'store_order', $4::uuid, $5, $6, $7::jsonb)
			ON CONFLICT (workspace_id, operation_key) DO UPDATE
			SET status = EXCLUDED.status, result_payload = EXCLUDED.result_payload, updated_at = NOW()
		`, newUUID(), workspaceID, idemOp, orderID, idempotencyKey, effStatus, string(payloadBytes))
		if err != nil {
			return err
		}

		if piOp != "" {
			if cp.Status == "confirmed" {
				_, err = tx.Exec(ctx, `
					INSERT INTO external_effects (
						effect_id, workspace_id, operation_key, provider,
						aggregate_type, aggregate_id, provider_request_id, status, result_payload
					) VALUES ($1::uuid, $2::uuid, $3, 'own_store', 'store_order', $4::uuid, $5, 'succeeded', $6::jsonb)
					ON CONFLICT (workspace_id, operation_key) DO UPDATE
					SET status = 'succeeded', result_payload = EXCLUDED.result_payload, updated_at = NOW()
				`, newUUID(), workspaceID, piOp, orderID, idempotencyKey, string(payloadBytes))
				if err != nil {
					return err
				}
			} else {
				_, err = tx.Exec(ctx, `
					DELETE FROM external_effects
					WHERE workspace_id = $1::uuid AND operation_key = $2 AND provider_request_id = $3
				`, workspaceID, piOp, idempotencyKey)
				if err != nil {
					return err
				}
			}
		}
		return nil
	})
	if err != nil {
		return err
	}
	return p.Store.SaveCheckoutResult(ctx, workspaceID, idempotencyKey, res)
}
