---
layer: contracts
canonical: true
last_updated: 2026-10-29
---

# Financial Computation Contract

## 1. Recognition and immutable inputs

This owns numerical/recognition semantics for M19. [M19 feature](../02_features/finance/operating_ledger.md) owns UX/business flows; [schema](database_schema.md) owns storage. This is an operating profit measure, not a certified statutory/tax accounting statement.

- Revenue is recognized once when an order becomes completed; `recognized_at` is the source completion timestamp. Imported records already completed are recognized directly; do not reset their lifecycle to created.
- Created/confirmed/fulfilled orders are shown as pending revenue, excluded from recognized profit. Cancelled/unpaid orders contribute zero. A refund creates a separate negative refund component; never both net the original revenue and subtract the refund again.
- Settlement cash does not create additional order revenue. Match it to recognized orders; unmatched settlement cash remains in the unreconciled bucket and is excluded from finalized order profit. Display cash received and recognized revenue separately.
- Persist transaction-time `orders.items[].unit_cogs`, quantity, price, discount, currency and tax; do not query today's catalog COGS to recalculate past profit. Missing COGS is a gap, never verified zero. Zero is valid only with explicit source/reason.
- Each component posts once to append-only `financial_postings` using origin identity/version/component. Corrections reverse prior postings and append corrected ones; cache/snapshot recomputation cannot create postings.
- Platform fees, shipping and affiliate commissions can arrive from order fee breakdown, settlement or explicit cost records. Use the same economic-component identity to reconcile/replace estimates. Never sum duplicate observations of one expense. Reconciled source supersedes the estimate using reversal/replacement, not by keeping both costs.
- Affiliate income belongs to creator revenue; affiliate commission expense belongs to seller cost. Record the workspace's economic role and do not charge a creator both seller COGS and commission cost for the same affiliate sale.

## 2. Decimal, FX and period rules

All API and JSONB money/credit amounts are decimal strings. Parse to a decimal type, compute at ≥6 fractional places, persist NUMERIC(18,6). Sum unrounded base amounts, then round each displayed/exported currency total to that currency's decimal places using half-away-from-zero. No binary floats or UI recomputation.

`base_amount = transaction_amount × exchange_rate_snapshot.rate_to_base`. Rate means base-currency units per one transaction-currency unit; require positive rate and matching currency codes. Same-currency rate is exactly 1. Persist provider, source class, effective/capture time. Supported authorized rate feed is configured per currency; do not assume ECB supplies VND. Unsupported/stale FX requires labeled imported/manual input with reason and cannot be marked verified. Never silently substitute today's FX for a missing historical rate.

Workspace reporting uses its configured IANA timezone. Periods are `[start local midnight, next local midnight)` converted to UTC; stored timestamps remain UTC. Finalized historical reports retain their snapshot/version. Changing base currency starts a new reporting regime; it does not reinterpret existing postings or merge currencies without a conversion snapshot.

Tax fields preserve imported tax separately from income. Direct-store launch defaults follow BIZ-007 (`tax_amount=0`, creator responsibility note). A tax disclaimer does not turn zero into proof of tax exemption. Tax collected for remittance is excluded from recognized gross revenue; tax handling/export scope remains launch-gated by [legal compliance](../01_business/legal_compliance.md).

## 3. Aggregation

`net_profit = revenue − platform_fee − shipping − cogs − ai_credits − commission − ads_spend − seeding − refund − other`.

`profit_snapshots` is a replaceable projection of postings for scope/period/currency, including `seeding_costs`. Each expense belongs to exactly one component; `other` excludes named components. One order may have multiple content attribution rows, but their total allocated amount cannot exceed its recognized net-of-refund revenue. Workspace totals sum orders once, never attributed rows again. Allocation is separate from evidence of causation.

Confidence bands are ordered high > medium_high > medium > low_medium > low. Aggregate inherits the lowest contributing band. A mix of official and estimated/inferred values caps the result at medium; unreconciled or unknown required components cap at low. Source-mix percentages are by absolute base amount, with explicit unknown-component count (zero amounts cannot hide gaps). Pure API origin does not prove reconciliation; source class and reconciliation state remain separate axes.

## 4. Matching and import identity

- API order identity: workspace + connected_account + platform + external_order_id. CSV rows must include stable external identity or deterministic import_fingerprint from source file hash + source row identity; repeat the same file/row cannot create another order. Changed source revisions update the existing economic record and produce versioned correcting postings.
- Settlement identity follows its account/provider ID; each `settlement_lines` row has a unique external_line_id. Many-to-many partial matches lock affected orders/lines and enforce remaining amount capacity. Candidate suggestions cannot finalize themselves without the required Admin permission.
- Tolerance is one smallest currency unit per matched group after FX conversion and final rounding. Larger discrepancies stay conflict_detected. Explicit accepted discrepancy creates an audited adjustment with source/reason; it never silently changes raw source amounts.
- Reopen reconciliation on later refund/reversal. Human overrides require `reconciliation:override`; they change reconciliation truth with evidence, not immutable imported evidence.

## 5. Golden acceptance fixtures

| Fixture | Inputs | Expected |
|---|---|---|
| F01 recognized profit | Completed order revenue 1,000,000 VND; fee 100,000; shipping 20,000; COGS 400,000; AI 10,000; commission 50,000; ads 30,000; seeding 15,000 | net 375,000; all components separate |
| F02 partial refund | F01 + refund 100,000; no return/restock adjustment | net 275,000; revenue remains 1,000,000, refund component 100,000 |
| F03 settlement duplication | F01 + cash settlement confirming order and same fee | net remains 375,000; settlement is matching/cash evidence, fee not charged twice |
| F04 FX | USD order revenue 100; historical rate 25,000 VND/USD; total USD costs 40 | revenue 2,500,000; cost 1,000,000; net 1,500,000 VND, unchanged after today's rate changes |
| F05 pending order | Same amounts as F01 but order confirmed, not completed | recognized revenue/profit 0; pending bucket visible |
| F06 replay/correction | Import F01 twice, then correct fee to 120,000 | one order; net 355,000; prior fee reversal and replacement, no duplicated revenue |
| F07 unknown COGS | F01 with COGS missing | provisional amount labeled incomplete; confidence low; cannot claim verified 775,000 profit |
| F08 partial settlement | One 1,000,000 order, two settlement lines each allocating 500,000 | total matched 1,000,000; third allocation rejected; no duplicate revenue |
| F09 source mix | Official high-confidence components + estimated low-confidence cost | aggregate low (minimum), not mechanically medium because of source percentage |

Each fixture must run against PostgreSQL as well as service code; expected values must not be computed by the same implementation under test. Refund/return stock and COGS adjustments are separate economic events and require their own evidence.
