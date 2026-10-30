---
layer: features
module: M13
canonical: true
domain: commerce
status: SPECIFIED
last_updated: 2026-10-29
---

# Feature: Product Hub / Inventory / Order Truth (M13)

## Purpose

Creator commerce spans physical products, digital goods, services, memberships, and bundles — sold across TikTok Shop, Shopee, Lazada, own store, and affiliate networks. Without a canonical product and order layer, inventory is a guessing game, orders live in isolated platform silos, and profit calculations have no reliable source data.

M13 exists as the **canonical commerce catalog and order truth layer** — the single source of truth for products, SKUs, inventory, stock movements, order ingestion, and order lifecycle. Every offer (M14/M15), every affiliate link (M16), every live commerce action (M17), and every settlement (M19) traces back to M13's canonical product and order objects.

## Scope

### Covers (M13 owns product and order truth)
- Product master catalog: physical, digital, service, membership, bundle types
- SKU registry and variant hierarchy (Product → SKUs → Variant SKUs)
- Inventory locations and stock movement ledger
- Reserved stock tracking
- Order ingestion from connected platforms (TikTok Shop, Shopee, Lazada, Stripe)
- Order lifecycle state machine
- Refund/return lifecycle
- Fulfillment mapping
- Inventory alerts (low stock, out of stock, anomalous movements)
- Product-to-content mapping (which products appear in which content pieces)
- Product-to-campaign mapping

### Does NOT cover (M13 boundaries)
- **M14 owns**: offer strategy, pricing logic, coupon management (M14 offers reference M13 products)
- **M15 owns**: storefront pages, bundle presentation, membership management
- **M16 owns**: affiliate link generation, attribution (M16 links reference M13 products)
- **M19 owns**: settlement, cost, profit calculations (M19 derives from M13 orders)
- Payment processing: handled by Stripe/platform; M13 ingests order objects

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Seller / Operator | Editor+ | Manage products, SKUs, inventory; view orders; process returns |
| Manager | Manager+ | Configure inventory alerts, import orders, manage fulfillment |
| System (Sync) | System | Ingest orders from connected platforms, sync inventory |
| System (Alert) | System | Detect low stock, anomalous movements, order anomalies |

## Business Rules

1. **RULE-M13-001**: Every offer MUST map to a Product, OR must be explicitly declared as a product-less offer with `product_less_declaration` set to one of: `digital`, `community`, `service`. No offer may exist without this resolution — this is enforced at offer creation time in M14 (PRD §12.3, §23.13 AC, Pack 06 §2.3).
2. **RULE-M13-002**: Every order MUST have `source_class` (official, imported, inferred, estimated, unreconciled) AND `lifecycle_state`. Order source class follows PRD §15.1 taxonomy — no ad-hoc labels. The source class determines how the order feeds into M19 profit calculations (PRD §23.13 AC, Pack 06 §3.1).
3. **RULE-M13-003**: Order lifecycle state machine MUST follow canonical transitions: `created → confirmed → fulfilled → completed`. Terminal states: `completed`, `cancelled`, `refunded`, `partially_refunded`, `returned`. No state skipping — an order cannot jump from `created` to `completed` without passing through `confirmed` and `fulfilled` (DB schema §10.3).
4. **RULE-M13-004**: Inventory truth MUST NOT be separated from stock movement logic. Stock movements are the source of truth for inventory quantities. Every stock change (sale, return, adjustment, transfer) creates a Stock Movement record. Current stock is DERIVED from movement ledger, not stored as a mutable counter that can desync (PRD §23.13 AC).
   - **Query-time implementation**: A `current_stock` counter on `inventory_locations` is maintained as a **materialized view/trigger** — updated atomically on each stock_movement INSERT via PostgreSQL trigger (`AFTER INSERT ON stock_movements → UPDATE inventory_locations SET current_stock = current_stock + delta`). This counter is for UI display speed only.
   - **Reconciliation**: A scheduled job (daily 04:00 UTC) runs `SELECT SUM(delta) FROM stock_movements WHERE product_id = X AND location_id = Y` and compares to `current_stock`. Mismatches trigger `inventory.discrepancy_detected` event → appears in EC-M13-005.
   - **Cache**: `current_stock` values cached in Dragonfly (TTL: 60s, invalidated on stock_movement event). Screen specs showing real-time stock use this cache.
   - **Source of truth hierarchy**: stock_movements table (authoritative) > current_stock counter (derived, fast) > Dragonfly cache (display, fast)
5. **RULE-M13-005**: Product-to-content mapping tracks which products appear in which content pieces (scripts, assets, publish items). This mapping enables revenue attribution: when an order arrives, the system can trace Product → Content → Offer → Campaign to calculate content ROI (PRD §12.3, S16 §5).
6. **RULE-M13-006**: Refund and return are separate objects. Refund = money reversal truth. Return = logistics/quantity reversal. They may coexist on the same order but have independent lifecycles. A return without refund and a refund without return are both valid states (Pack 06 §3.2).
7. **RULE-M13-007**: Order fee breakdown (`fee_breakdown JSONB`) is the primary source for per-order profit calculation in M19. Fields: platform_fee, payment_processing_fee, shipping_fee, tax, commission, promo_discount. This decomposition MUST be populated at ingestion time when platform provides the data (DB schema §10.3, Audit v6 note).

## Main Flow

1. **Product creation**: Operator creates product in catalog
   - `ProductService/CRUD` (Editor+)
   - Product type: physical / digital / service / membership / bundle
   - External refs linked if product exists on connected platforms
   - `product.created` event emitted
2. **SKU/Variant setup**: Operator defines SKUs under product
   - SKU hierarchy: Product → SKUs (size, color, etc.) → Variant SKUs (specific combinations)
   - Inventory enabled per product → creates Inventory Location records
3. **Order ingestion**: Orders arrive from connected platforms
   - Sync worker imports orders via platform API webhooks
   - `lifecycle_state = 'created'`, `source_class` set based on source (official for connected platform, imported for manual)
   - `order.imported` event emitted → M19 begins tracking
4. **Order lifecycle progression**:
   - Platform confirms order → `confirmed`
   - Fulfillment completed → `fulfilled`
   - Delivery confirmed → `completed`
   - Each state change emits `order.state_changed` event
5. **Inventory movement**: Every order → Stock Movement created (deduction)
   - Returns → reverse Stock Movement (addition)
   - Manual adjustments → Stock Movement with reason
   - Low stock alerts triggered when threshold reached
6. **Refund/Return processing**:
   - Refund initiated → `refund.requested` → approval → `refund.completed`
   - Return initiated → `return.requested` → received → restocking
   - Both link back to original order and feed M19 reconciliation

## Alternate Flows

### A1: Manual Order Import
- Trigger: Orders from non-connected sources (e.g., direct sales, manual channels)
- Steps: Operator imports via CSV or manual entry → `source_class = 'imported'` → order enters standard lifecycle. System flags as imported truth. Reconciliation status = `imported_only` until matched with evidence.
- Result: Order tracked in canonical system but with appropriate source class caveat for M19

### A2: Product-less Digital Offer Path
- Trigger: Creator sells a digital product without physical catalog entry
- Steps: M14 creates offer with `product_less_declaration = 'digital'` → no Product record required. Orders from this offer still tracked with `offer_id` link. Revenue attribution works through offer → campaign chain.
- Result: Commerce graph complete without forcing unnecessary product catalog entries

### A3: Inventory Low Stock Alert
- Trigger: Stock movement causes inventory to drop below configured threshold
- Steps: System detects threshold breach → alert emitted → notification sent → appears as card in M01 Daily Brief (Seller Mode priority). Operator can: restock, pause offers, adjust thresholds.
- Result: Proactive inventory management prevents overselling

## Edge Cases

### EC-M13-001: Duplicate Order Ingestion
- Condition: Platform webhook delivers same order twice (network retry)
- Expected behavior: Idempotent ingestion — system checks `external_order_id` + `source_platform` uniqueness constraint. Duplicate silently ignored. No duplicate Stock Movement created. Audit log records attempted duplicate.
- Reference: PRD §28.4

### EC-M13-002: Order State Regression
- Condition: Platform sends `confirmed` state after system already shows `fulfilled`
- Expected behavior: State machine rejects backward transitions. System logs the discrepancy in diagnostics. If platform data is authoritative (`source_class = 'official'`), system flags for manual review rather than auto-regressing state.
- Reference: RULE-M13-003

### EC-M13-003: Refund Without Return
- Condition: Digital product refund — no physical return possible
- Expected behavior: Refund object created without Return object. Refund lifecycle independent. `refund.completed` event feeds M19 for financial adjustment. No inventory Stock Movement triggered (nothing to restock).
- Reference: RULE-M13-006, Pack 06 §3.2

### EC-M13-004: Stock Movement Ledger Discrepancy
- Condition: Derived stock count from movement ledger doesn't match platform's reported stock
- Expected behavior: System flags discrepancy as `unreconciled`. Dashboard shows both values with explanation. Operator can create reconciliation adjustment (Stock Movement with `type = 'adjustment'`). Adjustment requires reason for audit trail.
- Reference: RULE-M13-004

## State Machine

### Order Lifecycle

Object: order | DB column: `orders.lifecycle_state`
see [04_contracts/database_schema.md#10.3](../../04_contracts/database_schema.md)

| From | To | Trigger | Condition |
|---|---|---|---|
| — | created | Order ingested from platform or manual | Order data received |
| created | confirmed | Platform confirms order | Payment verified / seller confirms |
| confirmed | fulfilled | Fulfillment completed | Shipping dispatched or digital delivered |
| fulfilled | completed | Delivery confirmed | Customer receives / timeout auto-complete |
| created | cancelled | Order cancelled before confirmation | Buyer/seller cancellation |
| confirmed | cancelled | Order cancelled after confirmation | Before fulfillment only |
| completed | refunded | Full refund processed | Refund lifecycle completed |
| completed | partially_refunded | Partial refund processed | Partial amount refunded |
| fulfilled | returned | Return initiated and received | Return lifecycle completed |

### Refund Lifecycle

| From | To | Trigger | Condition |
|---|---|---|---|
| — | requested | Refund initiated | `refund.requested` event |
| requested | approved | Manager approves | Manager+ action |
| approved | completed | Money returned | Settlement processed |
| requested | declined | Manager declines | With reason |

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../../04_contracts/database_schema.md) | §10 (products, offers, orders, affiliate_links, campaigns) |
| API | [04_contracts/api_endpoint_map.md](../../04_contracts/api_endpoint_map.md) | §2.6 (ProductService, OfferService, OrderService — ~30 RPCs Commerce) |
| Events | [04_contracts/domain_event_catalog.md](../../04_contracts/domain_event_catalog.md) | §8 (product.created, order.imported, order.state_changed, order.refund_initiated), §19 (refund.*, return.*) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../../04_contracts/rbac_permission_matrix.md) | §2.7 (product — Editor+; order — Editor+) |
| Pack 06 | Pack 06 — Commerce Contract <!-- Legacy ref: creativanta_detail_design_pack_06_commerce_finance_proof_reporting_admin_contract_v_3_1.md — superseded by current feature docs + contract layer --> | §2 (Commerce Contract), §3 (Order/Refund/Settlement) |
| Webhooks | [04_contracts/api_endpoint_map.md](../../04_contracts/api_endpoint_map.md) | §3 (TikTok, Shopee, Lazada order events) |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Product catalog | Grid/list view, filter by type/status, bulk actions |
| Web | Product detail | SKU hierarchy, inventory status, linked content, linked offers |
| Web | Order list | Filterable by state, platform, date range, amount |
| Web | Order detail | Lifecycle timeline, fee breakdown, linked product/offer/campaign |
| Web | Inventory dashboard | Stock levels, movement history, alerts |
| Mobile | Quick stock check | Scannable product lookup, current inventory |
| Mobile | Order status | Order lifecycle view, alert actions |

## Acceptance Criteria

1. **Given** an offer is created in M14, **when** the offer references a product, **then** the `product_id` MUST link to an existing M13 product — OR the offer MUST have `product_less_declaration` set to `'digital'`, `'community'`, or `'service'`.

2. **Given** an order is imported from TikTok Shop, **when** the ingestion completes, **then** the order MUST have `source_class = 'official'`, `lifecycle_state` matching the imported source (never reset completed orders), `source_platform = 'tiktok'`, and `external_order_id` populated — the `order.imported` event MUST be emitted with `{order_id, platform, amount}`.

3. **Given** an order in `confirmed` state, **when** the seller marks it as fulfilled, **then** `lifecycle_state` MUST transition to `'fulfilled'`, a Stock Movement MUST be created (type='sale'), and `order.state_changed` MUST fire with `{from: 'confirmed', to: 'fulfilled'}`.

4. **Given** a refund is processed on a completed order, **when** the refund completes, **then** the order `lifecycle_state` MUST transition to `'refunded'` (or `'partially_refunded'`), AND the refund amount MUST feed into M19 operating ledger as a deduction.

5. **Given** inventory for a product drops below the configured threshold, **when** the stock movement is recorded, **then** an inventory alert MUST appear in M01 Daily Brief for Seller Mode users, with a CTA to restock or pause related offers.

## Open Questions / Blockers

- [NONE] — No critical blockers specific to M13 in OPEN_BLOCKERS.md. Commerce endpoints defined in API map §2.6 (~30 RPCs).
- [NOTE] DB-H-001 (RESOLVED): All money/credit fields use `NUMERIC(18,6)` — never REAL or FLOAT. Verified resolved in schema.
