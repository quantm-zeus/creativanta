package store

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"sync"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
)

// PostgresStore wraps a base Store with durable PostgreSQL-backed checkout idempotency,
// bounded lease ownership & crash recovery (M01), and payment-intent claims in external_effects
// (UNIQUE (workspace_id, operation_key)) under tenant RLS (app.current_tenant_id),
// ensuring cross-instance checkout exclusivity and recovery (R02 & M01).
type PostgresStore struct {
	Store
	pool             *pgxpool.Pool
	instanceID       string
	mu               sync.Mutex
	nowFunc          func() time.Time
	checkoutLeaseTTL time.Duration
	activeLeases     map[string]string // key: workspaceID + ":" + idempotencyKey -> leaseOwner
}

// NewPostgresStore creates a PostgreSQL-backed store for cross-instance checkout coordination.
// If base is nil, a new MemoryStore is initialized for in-memory catalog projections.
func NewPostgresStore(pool *pgxpool.Pool, base Store) *PostgresStore {
	if base == nil {
		base = NewMemoryStore()
	}
	return &PostgresStore{
		Store:            base,
		pool:             pool,
		instanceID:       newUUID(),
		checkoutLeaseTTL: defaultCheckoutLeaseTTL,
		activeLeases:     make(map[string]string),
	}
}

func (p *PostgresStore) SetNowFunc(fn func() time.Time) {
	p.mu.Lock()
	p.nowFunc = fn
	p.mu.Unlock()
	if setter, ok := p.Store.(interface{ SetNowFunc(func() time.Time) }); ok {
		setter.SetNowFunc(fn)
	}
}

func (p *PostgresStore) SetCheckoutLeaseTTL(ttl time.Duration) {
	if ttl <= 0 {
		return
	}
	p.mu.Lock()
	p.checkoutLeaseTTL = ttl
	p.mu.Unlock()
	if setter, ok := p.Store.(interface{ SetCheckoutLeaseTTL(time.Duration) }); ok {
		setter.SetCheckoutLeaseTTL(ttl)
	}
}

func (p *PostgresStore) currentTime(ctx context.Context, tx pgx.Tx) time.Time {
	p.mu.Lock()
	fn := p.nowFunc
	p.mu.Unlock()
	if fn != nil {
		return fn().UTC()
	}
	var dbNow time.Time
	if tx != nil {
		if err := tx.QueryRow(ctx, "SELECT NOW()").Scan(&dbNow); err == nil {
			return dbNow.UTC()
		}
	}
	return time.Now().UTC()
}

func (p *PostgresStore) leaseTTL() time.Duration {
	p.mu.Lock()
	defer p.mu.Unlock()
	if p.checkoutLeaseTTL > 0 {
		return p.checkoutLeaseTTL
	}
	return defaultCheckoutLeaseTTL
}

func (p *PostgresStore) setActiveLease(workspaceID, idempotencyKey, leaseOwner string) {
	p.mu.Lock()
	defer p.mu.Unlock()
	p.activeLeases[workspaceID+":"+strings.TrimSpace(idempotencyKey)] = leaseOwner
}

func (p *PostgresStore) popActiveLease(workspaceID, idempotencyKey string) string {
	p.mu.Lock()
	defer p.mu.Unlock()
	k := workspaceID + ":" + strings.TrimSpace(idempotencyKey)
	owner := p.activeLeases[k]
	delete(p.activeLeases, k)
	return owner
}

type pgCheckoutClaimPayload struct {
	IdempotencyKey     string          `json:"idempotency_key"`
	PaymentIntentID    string          `json:"payment_intent_id"`
	RequestFingerprint string          `json:"request_fingerprint"`
	OrderID            string          `json:"order_id"`
	LeaseOwner         string          `json:"lease_owner,omitempty"`
	LeaseUntil         *time.Time      `json:"lease_until,omitempty"`
	LeaseEpoch         int64           `json:"lease_epoch,omitempty"`
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

func hydrateCheckoutResultFromPayload(payload pgCheckoutClaimPayload, isReplay bool) *CheckoutResult {
	if payload.Result == nil {
		return nil
	}
	out := cloneCheckoutResult(payload.Result, isReplay)
	if out.RequestFingerprint == "" {
		out.RequestFingerprint = payload.RequestFingerprint
	}
	if out.PaymentIntentID == "" {
		out.PaymentIntentID = payload.PaymentIntentID
	}
	return out
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
		var acquiredLeaseOwner string

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

			now := p.currentTime(ctx, tx)
			var nextEpoch int64 = 1

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
				if (status == "succeeded" || status == "prepared") && payload.PaymentIntentID != "" && paymentIntentID != "" && payload.PaymentIntentID != paymentIntentID {
					return ErrPaymentReplay
				}
				if status == "succeeded" && payload.Result != nil && payload.Result.Status == "confirmed" {
					replayRes = hydrateCheckoutResultFromPayload(payload, true)
					claimedOrderID = payload.OrderID
					return nil
				}
				claimedOrderID = payload.OrderID
				if payload.LeaseEpoch >= nextEpoch {
					nextEpoch = payload.LeaseEpoch + 1
				}
				if status == "prepared" {
					if payload.LeaseUntil != nil && now.Before(*payload.LeaseUntil) {
						waitForInflight = true
						return nil
					}
					// Lease expired (M01): take over ownership and preserve claimedOrderID for effect reconciliation.
				}
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
						replayRes = hydrateCheckoutResultFromPayload(piPayload, true)
						claimedOrderID = piPayload.OrderID
						return nil
					}
					if claimedOrderID == "" && piPayload.OrderID != "" {
						claimedOrderID = piPayload.OrderID
					}
					if piPayload.LeaseEpoch >= nextEpoch {
						nextEpoch = piPayload.LeaseEpoch + 1
					}
					if piStatus == "prepared" {
						if piPayload.LeaseUntil != nil && now.Before(*piPayload.LeaseUntil) {
							waitForInflight = true
							return nil
						}
						// Lease expired (M01): take over ownership and preserve claimedOrderID.
					}
				}
			}

			// 3. Durable claim (or expired-lease takeover) of both (workspace_id, idemOp) and (workspace_id, piOp).
			if claimedOrderID == "" {
				claimedOrderID = newUUID()
			}
			leaseOwner := p.instanceID + ":" + newUUID()
			leaseUntil := now.Add(p.leaseTTL())
			acquiredLeaseOwner = leaseOwner

			claimPayload, err := json.Marshal(pgCheckoutClaimPayload{
				IdempotencyKey:     idempotencyKey,
				PaymentIntentID:    paymentIntentID,
				RequestFingerprint: requestFingerprint,
				OrderID:            claimedOrderID,
				LeaseOwner:         leaseOwner,
				LeaseUntil:         &leaseUntil,
				LeaseEpoch:         nextEpoch,
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
				SET status = 'prepared', aggregate_id = EXCLUDED.aggregate_id, result_payload = EXCLUDED.result_payload, updated_at = NOW()
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
					SET status = 'prepared', aggregate_id = EXCLUDED.aggregate_id, result_payload = EXCLUDED.result_payload, updated_at = NOW()
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
		if acquiredLeaseOwner != "" {
			p.setActiveLease(workspaceID, idempotencyKey, acquiredLeaseOwner)
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
	leaseOwner := p.popActiveLease(workspaceID, idempotencyKey)

	cleanCtx := ctx
	if cleanCtx != nil && cleanCtx.Err() != nil {
		var cancel context.CancelFunc
		cleanCtx, cancel = context.WithTimeout(context.WithoutCancel(ctx), 5*time.Second)
		defer cancel()
	}

	return p.withTenantTx(cleanCtx, workspaceID, func(tx pgx.Tx) error {
		if leaseOwner != "" {
			_, err := tx.Exec(cleanCtx, `
				DELETE FROM external_effects
				WHERE workspace_id = $1::uuid
				  AND operation_key = $2
				  AND status = 'prepared'
				  AND (COALESCE(result_payload->>'lease_owner', '') = '' OR result_payload->>'lease_owner' = $3)
			`, workspaceID, idemOp, leaseOwner)
			if err != nil {
				return err
			}
			if piOp != "" {
				_, err = tx.Exec(cleanCtx, `
					DELETE FROM external_effects
					WHERE workspace_id = $1::uuid
					  AND operation_key = $2
					  AND status = 'prepared'
					  AND provider_request_id = $3
					  AND (COALESCE(result_payload->>'lease_owner', '') = '' OR result_payload->>'lease_owner' = $4)
				`, workspaceID, piOp, idempotencyKey, leaseOwner)
				if err != nil {
					return err
				}
			}
			return nil
		}
		_, err := tx.Exec(cleanCtx, `
			DELETE FROM external_effects
			WHERE workspace_id = $1::uuid AND operation_key = $2 AND status = 'prepared'
		`, workspaceID, idemOp)
		if err != nil {
			return err
		}
		if piOp != "" {
			_, err = tx.Exec(cleanCtx, `
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
			out = hydrateCheckoutResultFromPayload(payload, true)
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
			out = hydrateCheckoutResultFromPayload(payload, true)
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

func (p *PostgresStore) RecordVerifiedPaymentIntent(ctx context.Context, intent *VerifiedPaymentIntent) error {
	if err := p.Store.RecordVerifiedPaymentIntent(ctx, intent); err != nil {
		return err
	}
	if p.pool == nil || intent == nil {
		return nil
	}
	raw, err := json.Marshal(intent)
	if err != nil {
		return err
	}
	return p.withTenantTx(ctx, intent.WorkspaceID, func(tx pgx.Tx) error {
		_, err := tx.Exec(ctx, `
			INSERT INTO external_effects (
				effect_id, workspace_id, operation_key, provider,
				aggregate_type, aggregate_id, provider_request_id, status, result_payload
			) VALUES ($1::uuid, $2::uuid, $3, 'own_store', 'payment_intent', $4::uuid, $5, 'succeeded', $6::jsonb)
			ON CONFLICT (workspace_id, operation_key) DO UPDATE
			SET result_payload = EXCLUDED.result_payload, updated_at = NOW()
		`, newUUID(), intent.WorkspaceID, "store_verified_pi:"+strings.TrimSpace(intent.PaymentIntentID), newUUID(), strings.TrimSpace(intent.PaymentIntentID), string(raw))
		return err
	})
}

func (p *PostgresStore) GetVerifiedPaymentIntent(ctx context.Context, workspaceID, paymentIntentID string) (*VerifiedPaymentIntent, error) {
	if v, err := p.Store.GetVerifiedPaymentIntent(ctx, workspaceID, paymentIntentID); err == nil && v != nil {
		return v, nil
	}
	if p.pool == nil {
		return p.Store.GetVerifiedPaymentIntent(ctx, workspaceID, paymentIntentID)
	}
	var out *VerifiedPaymentIntent
	err := p.withTenantTx(ctx, workspaceID, func(tx pgx.Tx) error {
		var raw []byte
		err := tx.QueryRow(ctx, `
			SELECT result_payload
			FROM external_effects
			WHERE workspace_id = $1::uuid AND operation_key = $2
		`, workspaceID, "store_verified_pi:"+strings.TrimSpace(paymentIntentID)).Scan(&raw)
		if errors.Is(err, pgx.ErrNoRows) {
			return ErrPaymentNotVerified
		}
		if err != nil {
			return err
		}
		var v VerifiedPaymentIntent
		if err := json.Unmarshal(raw, &v); err != nil {
			return err
		}
		out = &v
		return nil
	})
	if err != nil {
		return nil, err
	}
	return out, nil
}

func (p *PostgresStore) CreateDigitalDelivery(ctx context.Context, d *DigitalDelivery) error {
	if p.pool == nil || d == nil {
		return p.Store.CreateDigitalDelivery(ctx, d)
	}
	err := p.withTenantTx(ctx, d.WorkspaceID, func(tx pgx.Tx) error {
		if strings.TrimSpace(d.IdempotencyKey) != "" {
			idemOp := "store_delivery_idem:" + strings.TrimSpace(d.IdempotencyKey)
			var existingRaw []byte
			err := tx.QueryRow(ctx, `
				SELECT result_payload
				FROM external_effects
				WHERE workspace_id = $1::uuid AND operation_key = $2
				FOR UPDATE
			`, d.WorkspaceID, idemOp).Scan(&existingRaw)
			if err != nil && !errors.Is(err, pgx.ErrNoRows) {
				return err
			}
			if err == nil && len(existingRaw) > 0 {
				var existing DigitalDelivery
				if uErr := json.Unmarshal(existingRaw, &existing); uErr == nil && existing.DeliveryID != "" {
					if existing.OrderID != "" && d.OrderID != "" && existing.OrderID != d.OrderID {
						return fmt.Errorf("%w: digital delivery idempotency key %s already exists for order %s", ErrPaymentReplay, d.IdempotencyKey, existing.OrderID)
					}
					*d = existing
					return nil
				}
			}
		}

		raw, err := json.Marshal(d)
		if err != nil {
			return err
		}
		_, err = tx.Exec(ctx, `
			INSERT INTO external_effects (
				effect_id, workspace_id, operation_key, provider,
				aggregate_type, aggregate_id, provider_request_id, status, result_payload
			) VALUES ($1::uuid, $2::uuid, $3, 'own_store', 'digital_delivery', $4::uuid, $5, 'succeeded', $6::jsonb)
			ON CONFLICT (workspace_id, operation_key) DO UPDATE
			SET result_payload = EXCLUDED.result_payload, updated_at = NOW()
		`, newUUID(), d.WorkspaceID, "store_delivery:"+d.DeliveryID, d.DeliveryID, d.CustomerEntityID, string(raw))
		if err != nil {
			return err
		}
		if strings.TrimSpace(d.IdempotencyKey) != "" {
			_, err = tx.Exec(ctx, `
				INSERT INTO external_effects (
					effect_id, workspace_id, operation_key, provider,
					aggregate_type, aggregate_id, provider_request_id, status, result_payload
				) VALUES ($1::uuid, $2::uuid, $3, 'own_store', 'digital_delivery', $4::uuid, $5, 'succeeded', $6::jsonb)
				ON CONFLICT (workspace_id, operation_key) DO UPDATE
				SET result_payload = EXCLUDED.result_payload, updated_at = NOW()
			`, newUUID(), d.WorkspaceID, "store_delivery_idem:"+strings.TrimSpace(d.IdempotencyKey), d.DeliveryID, d.CustomerEntityID, string(raw))
			if err != nil {
				return err
			}
		}
		return nil
	})
	if err != nil {
		return err
	}
	return p.Store.CreateDigitalDelivery(ctx, d)
}

func (p *PostgresStore) DeleteDigitalDelivery(ctx context.Context, workspaceID, deliveryID string) error {
	_ = p.Store.DeleteDigitalDelivery(ctx, workspaceID, deliveryID)
	if p.pool == nil {
		return nil
	}
	return p.withTenantTx(ctx, workspaceID, func(tx pgx.Tx) error {
		_, err := tx.Exec(ctx, `
			DELETE FROM external_effects
			WHERE workspace_id = $1::uuid AND aggregate_type = 'digital_delivery' AND aggregate_id = $2::uuid
		`, workspaceID, deliveryID)
		return err
	})
}

func (p *PostgresStore) ListDeliveriesByCustomer(ctx context.Context, workspaceID, customerEntityID string) ([]DigitalDelivery, error) {
	if p.pool == nil {
		return p.Store.ListDeliveriesByCustomer(ctx, workspaceID, customerEntityID)
	}
	var out []DigitalDelivery
	seen := make(map[string]bool)
	err := p.withTenantTx(ctx, workspaceID, func(tx pgx.Tx) error {
		rows, err := tx.Query(ctx, `
			SELECT result_payload
			FROM external_effects
			WHERE workspace_id = $1::uuid
			  AND operation_key LIKE 'store_delivery:%'
			  AND provider_request_id = $2
			ORDER BY created_at ASC
		`, workspaceID, customerEntityID)
		if err != nil {
			return err
		}
		defer rows.Close()
		for rows.Next() {
			var raw []byte
			if err := rows.Scan(&raw); err != nil {
				return err
			}
			var d DigitalDelivery
			if err := json.Unmarshal(raw, &d); err == nil && d.DeliveryID != "" && !seen[d.DeliveryID] {
				seen[d.DeliveryID] = true
				out = append(out, d)
			}
		}
		return rows.Err()
	})
	if err != nil {
		return nil, err
	}
	if memList, err := p.Store.ListDeliveriesByCustomer(ctx, workspaceID, customerEntityID); err == nil {
		for _, d := range memList {
			if !seen[d.DeliveryID] {
				seen[d.DeliveryID] = true
				out = append(out, d)
			}
		}
	}
	return out, nil
}

func (p *PostgresStore) CreateSubscription(ctx context.Context, sub *MembershipSubscription) error {
	if p.pool == nil || sub == nil {
		return p.Store.CreateSubscription(ctx, sub)
	}
	err := p.withTenantTx(ctx, sub.WorkspaceID, func(tx pgx.Tx) error {
		if strings.TrimSpace(sub.ProviderSubscriptionID) != "" {
			provOp := "store_sub_provider:" + strings.TrimSpace(sub.ProviderSubscriptionID)
			var existingRaw []byte
			err := tx.QueryRow(ctx, `
				SELECT result_payload
				FROM external_effects
				WHERE workspace_id = $1::uuid AND operation_key = $2
				FOR UPDATE
			`, sub.WorkspaceID, provOp).Scan(&existingRaw)
			if err != nil && !errors.Is(err, pgx.ErrNoRows) {
				return err
			}
			if err == nil && len(existingRaw) > 0 {
				var existing MembershipSubscription
				if uErr := json.Unmarshal(existingRaw, &existing); uErr == nil && existing.MembershipID != "" {
					*sub = existing
					return nil
				}
			}
		}

		raw, err := json.Marshal(sub)
		if err != nil {
			return err
		}
		_, err = tx.Exec(ctx, `
			INSERT INTO external_effects (
				effect_id, workspace_id, operation_key, provider,
				aggregate_type, aggregate_id, provider_request_id, status, result_payload
			) VALUES ($1::uuid, $2::uuid, $3, 'own_store', 'membership_subscription', $4::uuid, $5, 'succeeded', $6::jsonb)
			ON CONFLICT (workspace_id, operation_key) DO UPDATE
			SET result_payload = EXCLUDED.result_payload, updated_at = NOW()
		`, newUUID(), sub.WorkspaceID, "store_subscription:"+sub.MembershipID, sub.MembershipID, sub.CustomerEntityID, string(raw))
		if err != nil {
			return err
		}
		if strings.TrimSpace(sub.ProviderSubscriptionID) != "" {
			_, err = tx.Exec(ctx, `
				INSERT INTO external_effects (
					effect_id, workspace_id, operation_key, provider,
					aggregate_type, aggregate_id, provider_request_id, status, result_payload
				) VALUES ($1::uuid, $2::uuid, $3, 'own_store', 'membership_subscription', $4::uuid, $5, 'succeeded', $6::jsonb)
				ON CONFLICT (workspace_id, operation_key) DO UPDATE
				SET result_payload = EXCLUDED.result_payload, updated_at = NOW()
			`, newUUID(), sub.WorkspaceID, "store_sub_provider:"+strings.TrimSpace(sub.ProviderSubscriptionID), sub.MembershipID, sub.CustomerEntityID, string(raw))
			if err != nil {
				return err
			}
		}
		return nil
	})
	if err != nil {
		return err
	}
	return p.Store.CreateSubscription(ctx, sub)
}

func (p *PostgresStore) DeleteSubscription(ctx context.Context, workspaceID, subID string) error {
	_ = p.Store.DeleteSubscription(ctx, workspaceID, subID)
	if p.pool == nil {
		return nil
	}
	return p.withTenantTx(ctx, workspaceID, func(tx pgx.Tx) error {
		_, err := tx.Exec(ctx, `
			DELETE FROM external_effects
			WHERE workspace_id = $1::uuid AND aggregate_type = 'membership_subscription' AND aggregate_id = $2::uuid
		`, workspaceID, subID)
		return err
	})
}

func (p *PostgresStore) ListSubscriptionsByCustomer(ctx context.Context, workspaceID, customerEntityID string) ([]MembershipSubscription, error) {
	if p.pool == nil {
		return p.Store.ListSubscriptionsByCustomer(ctx, workspaceID, customerEntityID)
	}
	var out []MembershipSubscription
	seen := make(map[string]bool)
	err := p.withTenantTx(ctx, workspaceID, func(tx pgx.Tx) error {
		rows, err := tx.Query(ctx, `
			SELECT result_payload
			FROM external_effects
			WHERE workspace_id = $1::uuid
			  AND operation_key LIKE 'store_subscription:%'
			  AND provider_request_id = $2
			ORDER BY created_at ASC
		`, workspaceID, customerEntityID)
		if err != nil {
			return err
		}
		defer rows.Close()
		for rows.Next() {
			var raw []byte
			if err := rows.Scan(&raw); err != nil {
				return err
			}
			var sub MembershipSubscription
			if err := json.Unmarshal(raw, &sub); err == nil && sub.MembershipID != "" && !seen[sub.MembershipID] {
				seen[sub.MembershipID] = true
				out = append(out, sub)
			}
		}
		return rows.Err()
	})
	if err != nil {
		return nil, err
	}
	if memList, err := p.Store.ListSubscriptionsByCustomer(ctx, workspaceID, customerEntityID); err == nil {
		for _, sub := range memList {
			if !seen[sub.MembershipID] {
				seen[sub.MembershipID] = true
				out = append(out, sub)
			}
		}
	}
	return out, nil
}

func (p *PostgresStore) RecordFinancialPosting(ctx context.Context, posting *FinancialPosting) error {
	if p.pool == nil || posting == nil {
		return p.Store.RecordFinancialPosting(ctx, posting)
	}
	err := p.withTenantTx(ctx, posting.WorkspaceID, func(tx pgx.Tx) error {
		orderOp := "store_posting_order:" + strings.TrimSpace(posting.OrderID)
		var existingRaw []byte
		err := tx.QueryRow(ctx, `
			SELECT result_payload
			FROM external_effects
			WHERE workspace_id = $1::uuid AND operation_key = $2
			FOR UPDATE
		`, posting.WorkspaceID, orderOp).Scan(&existingRaw)
		if err != nil && !errors.Is(err, pgx.ErrNoRows) {
			return err
		}
		if err == nil && len(existingRaw) > 0 {
			var existing FinancialPosting
			if uErr := json.Unmarshal(existingRaw, &existing); uErr == nil && existing.PostingID != "" {
				if existing.GrossAmount.Cmp(posting.GrossAmount) != 0 || !strings.EqualFold(existing.Currency, posting.Currency) {
					return fmt.Errorf("%w: financial posting mismatch for order %s", ErrPaymentReplay, posting.OrderID)
				}
				*posting = existing
				return nil
			}
		}

		raw, err := json.Marshal(posting)
		if err != nil {
			return err
		}
		_, err = tx.Exec(ctx, `
			INSERT INTO external_effects (
				effect_id, workspace_id, operation_key, provider,
				aggregate_type, aggregate_id, provider_request_id, status, result_payload
			) VALUES ($1::uuid, $2::uuid, $3, 'own_store', 'financial_posting', $4::uuid, $5, 'succeeded', $6::jsonb)
			ON CONFLICT (workspace_id, operation_key) DO UPDATE
			SET result_payload = EXCLUDED.result_payload, updated_at = NOW()
		`, newUUID(), posting.WorkspaceID, "store_posting:"+posting.PostingID, posting.PostingID, posting.OrderID, string(raw))
		if err != nil {
			return err
		}
		_, err = tx.Exec(ctx, `
			INSERT INTO external_effects (
				effect_id, workspace_id, operation_key, provider,
				aggregate_type, aggregate_id, provider_request_id, status, result_payload
			) VALUES ($1::uuid, $2::uuid, $3, 'own_store', 'financial_posting', $4::uuid, $5, 'succeeded', $6::jsonb)
			ON CONFLICT (workspace_id, operation_key) DO UPDATE
			SET result_payload = EXCLUDED.result_payload, updated_at = NOW()
		`, newUUID(), posting.WorkspaceID, orderOp, posting.PostingID, posting.OrderID, string(raw))
		return err
	})
	if err != nil {
		return err
	}
	return p.Store.RecordFinancialPosting(ctx, posting)
}

func (p *PostgresStore) DeleteFinancialPosting(ctx context.Context, workspaceID, postingID string) error {
	_ = p.Store.DeleteFinancialPosting(ctx, workspaceID, postingID)
	if p.pool == nil {
		return nil
	}
	return p.withTenantTx(ctx, workspaceID, func(tx pgx.Tx) error {
		_, err := tx.Exec(ctx, `
			DELETE FROM external_effects
			WHERE workspace_id = $1::uuid AND aggregate_type = 'financial_posting' AND aggregate_id = $2::uuid
		`, workspaceID, postingID)
		return err
	})
}

func (p *PostgresStore) ListFinancialPostings(ctx context.Context, workspaceID string) ([]FinancialPosting, error) {
	if p.pool == nil {
		return p.Store.ListFinancialPostings(ctx, workspaceID)
	}
	var out []FinancialPosting
	seen := make(map[string]bool)
	err := p.withTenantTx(ctx, workspaceID, func(tx pgx.Tx) error {
		rows, err := tx.Query(ctx, `
			SELECT result_payload
			FROM external_effects
			WHERE workspace_id = $1::uuid
			  AND operation_key LIKE 'store_posting:%'
			ORDER BY created_at ASC
		`, workspaceID)
		if err != nil {
			return err
		}
		defer rows.Close()
		for rows.Next() {
			var raw []byte
			if err := rows.Scan(&raw); err != nil {
				return err
			}
			var fp FinancialPosting
			if err := json.Unmarshal(raw, &fp); err == nil && fp.PostingID != "" && !seen[fp.PostingID] {
				seen[fp.PostingID] = true
				out = append(out, fp)
			}
		}
		return rows.Err()
	})
	if err != nil {
		return nil, err
	}
	if memList, err := p.Store.ListFinancialPostings(ctx, workspaceID); err == nil {
		for _, fp := range memList {
			if !seen[fp.PostingID] {
				seen[fp.PostingID] = true
				out = append(out, fp)
			}
		}
	}
	return out, nil
}

type pgStockPayload struct {
	ProductID string `json:"product_id"`
	Stock     int32  `json:"stock"`
}

type pgBundleReservationPayload struct {
	OrderID  string `json:"order_id"`
	BundleID string `json:"bundle_id"`
	Quantity int32  `json:"quantity"`
}

func (p *PostgresStore) SetProductStock(ctx context.Context, workspaceID, productID string, stock int32) error {
	if err := p.Store.SetProductStock(ctx, workspaceID, productID, stock); err != nil {
		return err
	}
	if p.pool == nil || strings.TrimSpace(workspaceID) == "" || strings.TrimSpace(productID) == "" {
		return nil
	}
	raw, err := json.Marshal(pgStockPayload{ProductID: strings.TrimSpace(productID), Stock: stock})
	if err != nil {
		return err
	}
	aggID := strings.TrimSpace(productID)
	if len(aggID) != 36 {
		aggID = newUUID()
	}
	return p.withTenantTx(ctx, workspaceID, func(tx pgx.Tx) error {
		_, err := tx.Exec(ctx, `
			INSERT INTO external_effects (
				effect_id, workspace_id, operation_key, provider,
				aggregate_type, aggregate_id, provider_request_id, status, result_payload
			) VALUES ($1::uuid, $2::uuid, $3, 'own_store', 'product_stock', $4::uuid, $5, 'succeeded', $6::jsonb)
			ON CONFLICT (workspace_id, operation_key) DO UPDATE
			SET result_payload = EXCLUDED.result_payload, updated_at = NOW()
		`, newUUID(), workspaceID, "store_stock:"+strings.TrimSpace(productID), aggID, strings.TrimSpace(productID), string(raw))
		return err
	})
}

func (p *PostgresStore) GetProductStock(ctx context.Context, workspaceID, productID string) (int32, error) {
	if p.pool == nil {
		return p.Store.GetProductStock(ctx, workspaceID, productID)
	}
	var stock int32
	var found bool
	err := p.withTenantTx(ctx, workspaceID, func(tx pgx.Tx) error {
		var raw []byte
		err := tx.QueryRow(ctx, `
			SELECT result_payload
			FROM external_effects
			WHERE workspace_id = $1::uuid AND operation_key = $2
		`, workspaceID, "store_stock:"+strings.TrimSpace(productID)).Scan(&raw)
		if errors.Is(err, pgx.ErrNoRows) {
			return nil
		}
		if err != nil {
			return err
		}
		var sp pgStockPayload
		if err := json.Unmarshal(raw, &sp); err != nil {
			return err
		}
		stock = sp.Stock
		found = true
		return nil
	})
	if err != nil {
		return 0, err
	}
	if found {
		_ = p.Store.SetProductStock(ctx, workspaceID, productID, stock)
		return stock, nil
	}
	return p.Store.GetProductStock(ctx, workspaceID, productID)
}

func (p *PostgresStore) CreateBundle(ctx context.Context, bundle *Bundle) error {
	if err := p.Store.CreateBundle(ctx, bundle); err != nil {
		return err
	}
	if p.pool == nil || bundle == nil {
		return nil
	}
	raw, err := json.Marshal(bundle)
	if err != nil {
		return err
	}
	aggID := bundle.BundleID
	if len(aggID) != 36 {
		aggID = newUUID()
	}
	return p.withTenantTx(ctx, bundle.WorkspaceID, func(tx pgx.Tx) error {
		_, err := tx.Exec(ctx, `
			INSERT INTO external_effects (
				effect_id, workspace_id, operation_key, provider,
				aggregate_type, aggregate_id, provider_request_id, status, result_payload
			) VALUES ($1::uuid, $2::uuid, $3, 'own_store', 'store_bundle', $4::uuid, $5, 'succeeded', $6::jsonb)
			ON CONFLICT (workspace_id, operation_key) DO UPDATE
			SET result_payload = EXCLUDED.result_payload, updated_at = NOW()
		`, newUUID(), bundle.WorkspaceID, "store_bundle:"+bundle.BundleID, aggID, bundle.BundleID, string(raw))
		return err
	})
}

func (p *PostgresStore) GetBundle(ctx context.Context, workspaceID, bundleID string) (*Bundle, error) {
	if b, err := p.Store.GetBundle(ctx, workspaceID, bundleID); err == nil && b != nil {
		return b, nil
	}
	if p.pool == nil {
		return p.Store.GetBundle(ctx, workspaceID, bundleID)
	}
	var loaded *Bundle
	err := p.withTenantTx(ctx, workspaceID, func(tx pgx.Tx) error {
		var raw []byte
		err := tx.QueryRow(ctx, `
			SELECT result_payload
			FROM external_effects
			WHERE workspace_id = $1::uuid AND operation_key = $2
		`, workspaceID, "store_bundle:"+strings.TrimSpace(bundleID)).Scan(&raw)
		if errors.Is(err, pgx.ErrNoRows) {
			return ErrBundleNotFound
		}
		if err != nil {
			return err
		}
		var b Bundle
		if err := json.Unmarshal(raw, &b); err != nil {
			return err
		}
		loaded = &b
		return nil
	})
	if err != nil {
		return nil, err
	}
	_ = p.Store.CreateBundle(ctx, loaded)
	for _, item := range loaded.Items {
		_, _ = p.GetProductStock(ctx, workspaceID, item.ProductID)
	}
	return p.Store.GetBundle(ctx, workspaceID, bundleID)
}

func (p *PostgresStore) AtomicallyReserveBundleStock(ctx context.Context, workspaceID, bundleID string, quantity int32) error {
	if p.pool == nil {
		return p.Store.AtomicallyReserveBundleStock(ctx, workspaceID, bundleID, quantity)
	}
	b, err := p.GetBundle(ctx, workspaceID, bundleID)
	if err != nil {
		return err
	}
	orderID := checkoutOrderIDFromContext(ctx)
	updatedStocks := make(map[string]int32, len(b.Items))

	err = p.withTenantTx(ctx, workspaceID, func(tx pgx.Tx) error {
		if _, err := tx.Exec(ctx, "SELECT pg_advisory_xact_lock(hashtext($1))", workspaceID+":bundle_stock"); err != nil {
			return err
		}
		if orderID != "" {
			resOp := "store_bundle_res:" + orderID
			var existingRaw []byte
			err := tx.QueryRow(ctx, `
				SELECT result_payload
				FROM external_effects
				WHERE workspace_id = $1::uuid AND operation_key = $2
				FOR UPDATE
			`, workspaceID, resOp).Scan(&existingRaw)
			if err != nil && !errors.Is(err, pgx.ErrNoRows) {
				return err
			}
			if err == nil && len(existingRaw) > 0 {
				// Already reserved for this order before crash (M01): reconcile current stocks and return idempotently.
				for _, item := range b.Items {
					var sRaw []byte
					if sErr := tx.QueryRow(ctx, `
						SELECT result_payload FROM external_effects WHERE workspace_id = $1::uuid AND operation_key = $2
					`, workspaceID, "store_stock:"+item.ProductID).Scan(&sRaw); sErr == nil {
						var sp pgStockPayload
						if json.Unmarshal(sRaw, &sp) == nil {
							updatedStocks[item.ProductID] = sp.Stock
						}
					}
				}
				return nil
			}
		}

		currentStocks := make(map[string]int32, len(b.Items))
		for _, item := range b.Items {
			var sRaw []byte
			sErr := tx.QueryRow(ctx, `
				SELECT result_payload
				FROM external_effects
				WHERE workspace_id = $1::uuid AND operation_key = $2
				FOR UPDATE
			`, workspaceID, "store_stock:"+item.ProductID).Scan(&sRaw)
			var cur int32
			if sErr == nil && len(sRaw) > 0 {
				var sp pgStockPayload
				_ = json.Unmarshal(sRaw, &sp)
				cur = sp.Stock
			} else if errors.Is(sErr, pgx.ErrNoRows) {
				cur, _ = p.Store.GetProductStock(ctx, workspaceID, item.ProductID)
			} else if sErr != nil {
				return sErr
			}
			required := item.Quantity * quantity
			if cur < required {
				title := item.ProductTitle
				if title == "" {
					title = fmt.Sprintf("Product %s", item.ProductID)
				}
				return fmt.Errorf("%w: %s (stock=%d, required=%d)", ErrBundleComponentOutOfStock, title, cur, required)
			}
			currentStocks[item.ProductID] = cur
		}

		for _, item := range b.Items {
			newStock := currentStocks[item.ProductID] - item.Quantity*quantity
			updatedStocks[item.ProductID] = newStock
			raw, err := json.Marshal(pgStockPayload{ProductID: item.ProductID, Stock: newStock})
			if err != nil {
				return err
			}
			aggID := item.ProductID
			if len(aggID) != 36 {
				aggID = newUUID()
			}
			_, err = tx.Exec(ctx, `
				INSERT INTO external_effects (
					effect_id, workspace_id, operation_key, provider,
					aggregate_type, aggregate_id, provider_request_id, status, result_payload
				) VALUES ($1::uuid, $2::uuid, $3, 'own_store', 'product_stock', $4::uuid, $5, 'succeeded', $6::jsonb)
				ON CONFLICT (workspace_id, operation_key) DO UPDATE
				SET result_payload = EXCLUDED.result_payload, updated_at = NOW()
			`, newUUID(), workspaceID, "store_stock:"+item.ProductID, aggID, item.ProductID, string(raw))
			if err != nil {
				return err
			}
		}

		if orderID != "" {
			resRaw, err := json.Marshal(pgBundleReservationPayload{
				OrderID:  orderID,
				BundleID: bundleID,
				Quantity: quantity,
			})
			if err != nil {
				return err
			}
			aggID := orderID
			if len(aggID) != 36 {
				aggID = newUUID()
			}
			_, err = tx.Exec(ctx, `
				INSERT INTO external_effects (
					effect_id, workspace_id, operation_key, provider,
					aggregate_type, aggregate_id, provider_request_id, status, result_payload
				) VALUES ($1::uuid, $2::uuid, $3, 'own_store', 'bundle_stock_reservation', $4::uuid, $5, 'succeeded', $6::jsonb)
				ON CONFLICT (workspace_id, operation_key) DO UPDATE
				SET result_payload = EXCLUDED.result_payload, updated_at = NOW()
			`, newUUID(), workspaceID, "store_bundle_res:"+orderID, aggID, bundleID, string(resRaw))
			if err != nil {
				return err
			}
		}
		return nil
	})
	if err != nil {
		return err
	}
	for prodID, st := range updatedStocks {
		_ = p.Store.SetProductStock(ctx, workspaceID, prodID, st)
	}
	return nil
}

func (p *PostgresStore) ReleaseBundleStock(ctx context.Context, workspaceID, bundleID string, quantity int32) error {
	if p.pool == nil {
		return p.Store.ReleaseBundleStock(ctx, workspaceID, bundleID, quantity)
	}
	cleanCtx := ctx
	if cleanCtx != nil && cleanCtx.Err() != nil {
		var cancel context.CancelFunc
		cleanCtx, cancel = context.WithTimeout(context.WithoutCancel(ctx), 5*time.Second)
		defer cancel()
	}
	b, err := p.GetBundle(cleanCtx, workspaceID, bundleID)
	if err != nil {
		return err
	}
	orderID := checkoutOrderIDFromContext(ctx)
	updatedStocks := make(map[string]int32, len(b.Items))

	err = p.withTenantTx(cleanCtx, workspaceID, func(tx pgx.Tx) error {
		if _, err := tx.Exec(cleanCtx, "SELECT pg_advisory_xact_lock(hashtext($1))", workspaceID+":bundle_stock"); err != nil {
			return err
		}
		if orderID != "" {
			resOp := "store_bundle_res:" + orderID
			tag, err := tx.Exec(cleanCtx, `
				DELETE FROM external_effects
				WHERE workspace_id = $1::uuid AND operation_key = $2
			`, workspaceID, resOp)
			if err != nil {
				return err
			}
			if tag.RowsAffected() == 0 {
				return nil
			}
		}

		for _, item := range b.Items {
			var sRaw []byte
			sErr := tx.QueryRow(cleanCtx, `
				SELECT result_payload
				FROM external_effects
				WHERE workspace_id = $1::uuid AND operation_key = $2
				FOR UPDATE
			`, workspaceID, "store_stock:"+item.ProductID).Scan(&sRaw)
			var cur int32
			if sErr == nil && len(sRaw) > 0 {
				var sp pgStockPayload
				_ = json.Unmarshal(sRaw, &sp)
				cur = sp.Stock
			} else if errors.Is(sErr, pgx.ErrNoRows) {
				cur, _ = p.Store.GetProductStock(cleanCtx, workspaceID, item.ProductID)
			} else if sErr != nil {
				return sErr
			}
			newStock := cur + item.Quantity*quantity
			updatedStocks[item.ProductID] = newStock
			raw, err := json.Marshal(pgStockPayload{ProductID: item.ProductID, Stock: newStock})
			if err != nil {
				return err
			}
			aggID := item.ProductID
			if len(aggID) != 36 {
				aggID = newUUID()
			}
			_, err = tx.Exec(cleanCtx, `
				INSERT INTO external_effects (
					effect_id, workspace_id, operation_key, provider,
					aggregate_type, aggregate_id, provider_request_id, status, result_payload
				) VALUES ($1::uuid, $2::uuid, $3, 'own_store', 'product_stock', $4::uuid, $5, 'succeeded', $6::jsonb)
				ON CONFLICT (workspace_id, operation_key) DO UPDATE
				SET result_payload = EXCLUDED.result_payload, updated_at = NOW()
			`, newUUID(), workspaceID, "store_stock:"+item.ProductID, aggID, item.ProductID, string(raw))
			if err != nil {
				return err
			}
		}
		return nil
	})
	if err != nil {
		return err
	}
	for prodID, st := range updatedStocks {
		_ = p.Store.SetProductStock(cleanCtx, workspaceID, prodID, st)
	}
	return nil
}

func (p *PostgresStore) CreatePlan(ctx context.Context, plan *MembershipPlan) error {
	if err := p.Store.CreatePlan(ctx, plan); err != nil {
		return err
	}
	return p.persistPlan(ctx, plan)
}

func (p *PostgresStore) UpdatePlan(ctx context.Context, plan *MembershipPlan) error {
	if err := p.Store.UpdatePlan(ctx, plan); err != nil {
		return err
	}
	return p.persistPlan(ctx, plan)
}

func (p *PostgresStore) persistPlan(ctx context.Context, plan *MembershipPlan) error {
	if p.pool == nil || plan == nil {
		return nil
	}
	raw, err := json.Marshal(plan)
	if err != nil {
		return err
	}
	aggID := plan.PlanID
	if len(aggID) != 36 {
		aggID = newUUID()
	}
	return p.withTenantTx(ctx, plan.WorkspaceID, func(tx pgx.Tx) error {
		_, err := tx.Exec(ctx, `
			INSERT INTO external_effects (
				effect_id, workspace_id, operation_key, provider,
				aggregate_type, aggregate_id, provider_request_id, status, result_payload
			) VALUES ($1::uuid, $2::uuid, $3, 'own_store', 'membership_plan', $4::uuid, $5, 'succeeded', $6::jsonb)
			ON CONFLICT (workspace_id, operation_key) DO UPDATE
			SET result_payload = EXCLUDED.result_payload, updated_at = NOW()
		`, newUUID(), plan.WorkspaceID, "store_plan:"+plan.PlanID, aggID, plan.PlanID, string(raw))
		return err
	})
}

func (p *PostgresStore) GetPlan(ctx context.Context, workspaceID, planID string) (*MembershipPlan, error) {
	if pl, err := p.Store.GetPlan(ctx, workspaceID, planID); err == nil && pl != nil {
		return pl, nil
	}
	if p.pool == nil {
		return p.Store.GetPlan(ctx, workspaceID, planID)
	}
	var out *MembershipPlan
	err := p.withTenantTx(ctx, workspaceID, func(tx pgx.Tx) error {
		var raw []byte
		err := tx.QueryRow(ctx, `
			SELECT result_payload
			FROM external_effects
			WHERE workspace_id = $1::uuid AND operation_key = $2
		`, workspaceID, "store_plan:"+strings.TrimSpace(planID)).Scan(&raw)
		if errors.Is(err, pgx.ErrNoRows) {
			return ErrPlanNotFound
		}
		if err != nil {
			return err
		}
		var pl MembershipPlan
		if err := json.Unmarshal(raw, &pl); err != nil {
			return err
		}
		out = &pl
		return nil
	})
	if err != nil {
		return nil, err
	}
	_ = p.Store.CreatePlan(ctx, out)
	return out, nil
}

func (p *PostgresStore) UpsertProduct(ctx context.Context, product *StoreProduct) error {
	if err := p.Store.UpsertProduct(ctx, product); err != nil {
		return err
	}
	if p.pool == nil || product == nil {
		return nil
	}
	raw, err := json.Marshal(product)
	if err != nil {
		return err
	}
	aggID := product.ProductID
	if len(aggID) != 36 {
		aggID = newUUID()
	}
	return p.withTenantTx(ctx, product.WorkspaceID, func(tx pgx.Tx) error {
		_, err := tx.Exec(ctx, `
			INSERT INTO external_effects (
				effect_id, workspace_id, operation_key, provider,
				aggregate_type, aggregate_id, provider_request_id, status, result_payload
			) VALUES ($1::uuid, $2::uuid, $3, 'own_store', 'store_product', $4::uuid, $5, 'succeeded', $6::jsonb)
			ON CONFLICT (workspace_id, operation_key) DO UPDATE
			SET result_payload = EXCLUDED.result_payload, updated_at = NOW()
		`, newUUID(), product.WorkspaceID, "store_product:"+product.ProductID, aggID, product.ProductID, string(raw))
		return err
	})
}

func (p *PostgresStore) GetProduct(ctx context.Context, workspaceID, productID string) (*StoreProduct, error) {
	if pr, err := p.Store.GetProduct(ctx, workspaceID, productID); err == nil && pr != nil {
		return pr, nil
	}
	if p.pool == nil {
		return p.Store.GetProduct(ctx, workspaceID, productID)
	}
	var out *StoreProduct
	err := p.withTenantTx(ctx, workspaceID, func(tx pgx.Tx) error {
		var raw []byte
		err := tx.QueryRow(ctx, `
			SELECT result_payload
			FROM external_effects
			WHERE workspace_id = $1::uuid AND operation_key = $2
		`, workspaceID, "store_product:"+strings.TrimSpace(productID)).Scan(&raw)
		if errors.Is(err, pgx.ErrNoRows) {
			return ErrProductNotFound
		}
		if err != nil {
			return err
		}
		var pr StoreProduct
		if err := json.Unmarshal(raw, &pr); err != nil {
			return err
		}
		out = &pr
		return nil
	})
	if err != nil {
		return nil, err
	}
	_ = p.Store.UpsertProduct(ctx, out)
	return out, nil
}

func (p *PostgresStore) UpsertOffer(ctx context.Context, offer *StoreOffer) error {
	if err := p.Store.UpsertOffer(ctx, offer); err != nil {
		return err
	}
	if p.pool == nil || offer == nil {
		return nil
	}
	raw, err := json.Marshal(offer)
	if err != nil {
		return err
	}
	aggID := offer.OfferID
	if len(aggID) != 36 {
		aggID = newUUID()
	}
	return p.withTenantTx(ctx, offer.WorkspaceID, func(tx pgx.Tx) error {
		_, err := tx.Exec(ctx, `
			INSERT INTO external_effects (
				effect_id, workspace_id, operation_key, provider,
				aggregate_type, aggregate_id, provider_request_id, status, result_payload
			) VALUES ($1::uuid, $2::uuid, $3, 'own_store', 'store_offer', $4::uuid, $5, 'succeeded', $6::jsonb)
			ON CONFLICT (workspace_id, operation_key) DO UPDATE
			SET result_payload = EXCLUDED.result_payload, updated_at = NOW()
		`, newUUID(), offer.WorkspaceID, "store_offer:"+offer.OfferID, aggID, offer.OfferID, string(raw))
		return err
	})
}

func (p *PostgresStore) GetOffer(ctx context.Context, workspaceID, offerID string) (*StoreOffer, error) {
	if of, err := p.Store.GetOffer(ctx, workspaceID, offerID); err == nil && of != nil {
		return of, nil
	}
	if p.pool == nil {
		return p.Store.GetOffer(ctx, workspaceID, offerID)
	}
	var out *StoreOffer
	err := p.withTenantTx(ctx, workspaceID, func(tx pgx.Tx) error {
		var raw []byte
		err := tx.QueryRow(ctx, `
			SELECT result_payload
			FROM external_effects
			WHERE workspace_id = $1::uuid AND operation_key = $2
		`, workspaceID, "store_offer:"+strings.TrimSpace(offerID)).Scan(&raw)
		if errors.Is(err, pgx.ErrNoRows) {
			return ErrOfferNotFound
		}
		if err != nil {
			return err
		}
		var of StoreOffer
		if err := json.Unmarshal(raw, &of); err != nil {
			return err
		}
		out = &of
		return nil
	})
	if err != nil {
		return nil, err
	}
	_ = p.Store.UpsertOffer(ctx, out)
	return out, nil
}
