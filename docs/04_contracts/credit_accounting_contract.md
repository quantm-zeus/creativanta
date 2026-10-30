---
layer: contracts
canonical: true
last_updated: 2026-10-29
---

# Credit Accounting Contract

## 1. Ownership and quantities

[Schema §26](database_schema.md#26-execution-integrity-additions-2026-10-29) owns field/constraint definitions. [Pricing](../01_business/pricing_and_credits.md) owns plan allocations, cost quotation and rollover. This document owns transitions and invariants. All credits/money use decimal arithmetic and decimal strings on the wire; never integer Redis DECRBY or floating-point finance.

- `remaining` is total unspent credit, including held amounts. `reserved` is held credit. `available = remaining - reserved`; all are nonnegative.
- `workspaces.ai_credits_remaining/ai_credits_reserved` are transactionally maintained projections of `ai_credit_lots`; the lot/ledger state is durable authority. Cache is only a read projection.
- Every grant creates exactly one lot and one positive `ai_credit_transactions` entry under a unique grant key. Invoice/payment webhook replay cannot grant twice. Top-ups grant only after verified settled payment.
- Consumption order: expiring promotional grants, subscription/rollover by earliest expiry, then purchased lots by creation time, then authorized overage. Purchased lots have no expiry. Lots of different sources are never merged.
- Subscription expiration/rollover affects subscription lots only. Purchased lots remain after trial/downgrade/cancellation; unavailable during read-only/inactive access, with export/refund policy per legal/billing. Reactivation restores their unspent balance before any legally authorized workspace erasure.
- Max five active reservations per workspace. A business overage buffer is represented as a separately authorized overage lot; never a negative balance. Free/Starter/Pro cannot use invoice overage.

## 2. Quote and reserve

1. Validate session, active membership, plan/usage limits, permission and object scope. Obtain a versioned quote for the complete bounded pipeline. Quote validity is five minutes; changed parameters invalidate its request hash.
2. Require `quote_id`, `confirmed_credits` equal to the quote, and `idempotency_key`. Reusing the key with different parameters returns `BILLING_CONFLICT_002`; identical retries return the original reservation/result.
3. In one PostgreSQL transaction: lock workspace row `FOR UPDATE`; recheck quote/available balance/concurrency; allocate eligible lots; increment lot and workspace reserved amounts; insert `ai_credit_reservations` and allocations; enqueue the canonical generation command in outbox. No provider call occurs inside this transaction.
4. Reservation starts `held`, with `expires_at = now + 30 minutes`. Reservation itself creates no debit ledger entry: remaining has not changed. A held credit is unavailable to other actions.
5. The worker atomically changes held → in_flight before submitting to the provider, recording a durable `external_effects.operation_key`. Commit/release decisions always lock the same workspace/reservation rows in that order.

For automation, explicit activation consent may preauthorize a bounded per-run/day AI budget and allowed operation/model/input bounds. Each step still produces a quote/hold bound to its actual request and the active delegation. Exceeding any consent/budget bound pauses for fresh approval; an agent cannot silently raise the ceiling.

## 3. State machine

| From | To | Condition and atomic effect |
|---|---|---|
| — | held | Confirmed quote and successful lot allocation |
| held | in_flight | Provider attempt claimed before expiry; stable operation key persisted |
| held | expired | Deadline passed and provider was never submitted; release lot holds once |
| held/in_flight | released | Provider definitively failed/cancelled without usable output; release holds once |
| in_flight | reconciling | Deadline/lease expired with unknown provider result; preserve holds and probe status |
| in_flight/reconciling | committed | Usable accepted output and final credits ≤ reserved; append one debit per consumed lot, reduce remaining/reserved, release unused holds |
| reconciling | released | Definitive provider failure/cancellation, or operator resolution with reason and audit |
| committed/released/expired | same | Replay returns prior terminal result; no financial mutation |

Never release an in-flight provider operation just because a cache TTL expired. `reconciling` runs a status check at least every 60 seconds with backoff; after 24 hours escalate to diagnostics/manual resolution, retaining the hold until the outcome is established. User sees the held amount, reason and repair path. Cancellation is a request until provider non-execution/cancellation is confirmed. A late result after a final release/expiry cannot debit again; quarantine output and record provider cost as platform loss pending review.

## 4. Commit, adjustment and reset

- Compute actual customer credit from measured units and the same pricebook version; cap at confirmed quote. Never charge a second time for fallback/retry already included in the bounded quote. A costlier/new pipeline requires a new explicit quote/consent before submission.
- Commit deducts only actual credits and releases the rest. Append immutable ledger entries with `reservation_id`, `lot_id`, stable `idempotency_key` and `balance_after`; sum ledger deltas must reconcile to lot balances. Never UPDATE an existing debit into a refund.
- Corrections/refunds append compensating entries referencing `reference_transaction_id`. A reservation's summed debit has one durable idempotency identity per lot. Operator credit grants/revokes require allowed internal-admin permission and reason.
- A cycle-close transaction locks workspace and lots, resolves expiring unsubmitted holds, computes rollover once (20% of unspent eligible subscription credits for Pro/Business, valid for the next cycle only), expires the remainder and grants the next allocation. In-flight reservations retain their source lot until resolution; their unused expired-source remainder expires rather than becoming purchased credit. The workspace summary is recomputed in the same transaction.
- Reset follows the subscription's billing boundary, including annual subscriptions' monthly allocation anniversaries, clamping day 29–31 to the month's last day. Idempotency key includes subscription ID and allocation period. It is not a global first-of-calendar-month grant.
- After DB commit invalidate credit cache via outbox. Cache failure cannot roll back or reapply a debit. Sweeper scans DB every 30 seconds for expired held reservations and reconciliation work; Pub/Sub expiry is only a wake-up hint.

## 5. Required adversarial fixtures

Two simultaneous 8-credit reservations against 10 available → one succeeds. Reserve 8, commit 6 → remaining initial−6 and reserved 0. Repeat callback/commit/release/reset/payment webhook → no additional delta. Worker dies before/after provider submit → correct held/unknown recovery. Cache is flushed or notification missed → DB sweeper restores valid availability. Cycle boundary during generation → purchased credits preserved and no renewal duplication. Late success after release → no charge. Consumer redelivery after DB commit → ledger unchanged.
