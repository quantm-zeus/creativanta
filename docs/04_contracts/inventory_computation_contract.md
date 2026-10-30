---
layer: contracts
canonical: true
last_updated: 2026-10-30
---

# Inventory Computation and Reservation Contract

## 1. Ownership and quantities

[M13](../02_features/commerce/product_hub.md) owns product/order behavior; [schema](database_schema.md) owns exact fields. For each workspace/SKU/location, `on_hand = SUM(stock_movements.quantity)` and `reserved = SUM(quantity of held stock_reservations)`. Sellable quantity is `on_hand − reserved`, computed by the server. Inventory balances and SKU totals are rebuildable projections, never independent writable truth. Use integer quantities, not money types or fractional units; unsupported unit conversions require an explicit later contract.

Every movement has a stable `movement_key` scoped to workspace and economic source/line/revision. Retrying a command, event or webhook preserves that identity. Same identity with changed payload is a conflict. Adjustments/reversals append a new key and link the original via reference_type/reference_id. All references are checked in the same tenant. Runtime cannot update/delete movement history.

## 2. Initial import and freshness

Before local stock commitments, initialize each SKU/location with an evidenced opening count movement and `opening_at`. Missing opening count is unknown, never assumed zero or unlimited. A virtual location may represent an external shop; it is a real location record, not a NULL key.

Historical orders at/before the opening boundary are imported for financial recognition without replaying their stock deductions into the opening count. New source movements after the boundary apply once. If a provider offers only a current absolute stock count, take a checkpoint, reconcile intervening known events and append the delta as an explained `platform_sync` adjustment. Never append the absolute count on every poll. Ambiguous ordering stays a discrepancy and disables local promises against that location until repaired.

Authoritative external oversell/late corrections may make on_hand negative; preserve this truth and alert. A local checkout cannot create a negative sellable quantity. External channels without a verified shared reservation API cannot be promised globally synchronized stock; expose freshness and channel risk.

## 3. Atomic reservation protocol

1. Validate `product:manage` or the owning order/checkout command's permission and delegated stock authority, plan, source identity, SKU/location and order tenant. Public checkout accepts only server-resolved published offers, never arbitrary stock commands.
2. Ensure balance rows exist, then lock all affected balance rows in sorted `(workspace_id, sku_id, location_id)` order, and relevant reservations. Lock order is identical for checkout, fulfillment, expiry and correction. Multi-SKU/bundle requests are all-or-nothing.
3. Check initialized balance and sellable quantity. Insert held reservations with stable reservation_key, increment reserved projections and audit atomically. Unpaid checkout holds expire after 15 minutes; confirmed paid orders clear expiry and retain holds until fulfillment/cancellation. The stock TTL is independent of AI credit leases.
4. Fulfillment consumes each held row once, appends the negative sale movement and decreases on_hand/reserved in one transaction. Failed fulfillment releases no stock until the outcome is established. A duplicate callback is a no-op.
5. Cancellation/confirmed payment failure releases held reservations once. Expiry worker uses the same locks and conditional transition; if payment outcome is unknown, retain hold with diagnostics until reconciled. A late payment after release attempts a fresh reservation; if unavailable, block fulfillment and invoke the explicit refund/repair flow.
6. Physical accepted returns append positive return movements keyed to accepted return line/quantity; enforce cumulative return quantity ≤ sold quantity. Refund without physical return changes no stock. Transfers atomically append paired negative/positive movements with one transfer reference.

After commit, emit only the existing `inventory.stock_moved` and relevant order/diagnostic events from the event catalog. Reservation-only changes use audit and projection invalidation, not invented domain events. Cache invalidation is after commit; cached quantity never passes a reservation check. Daily reconciliation compares ledger/reservations with both balance and SKU projections; mismatch emits the existing discrepancy event and is repaired transactionally with audit.

## 4. Required implementation fixtures

| ID | Setup / action | Expected |
|---|---|---|
| I01 | One unit; two simultaneous one-unit holds | One hold succeeds; no negative sellable quantity |
| I02 | Fulfill a held order; replay request and webhook | One sale movement; one consumed hold |
| I03 | One failed line in a two-SKU bundle | No partial reservation or movement |
| I04 | Opening count 10 today; import completed order from yesterday | Stock stays 10; historical finance still recognizes once |
| I05 | Confirmed physical return replay; separate refund callback | One positive return movement; refund adds no stock |
| I06 | Expiry races payment confirmation | One locked outcome; no lost hold or double fulfillment |
| I07 | Foreign tenant SKU/location/order or forged movement key | Rejected before mutation; no foreign data disclosure |
| I08 | External correction drives stock below reservations | Truth retained; discrepancy visible; new local holds blocked |
| I09 | Crash after transaction before event ACK; rebuild cache | Ledger, holds and projections agree; no repeated movement |
| I10 | Same absolute source count polled twice | Second sync changes no quantity |

Execute these against real PostgreSQL in P1 and exercise checkout/bundle/payment races again in P6. Static SQL parsing does not prove locking or stock correctness.
