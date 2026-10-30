---
layer: features
module: M19
canonical: true
domain: finance
status: SPECIFIED
last_updated: 2026-10-30
---

# Feature: Operating Ledger & Proof System (M19)

## Purpose

Creator commerce generates revenue and costs across 5+ platforms, multiple product types, affiliate networks, live sessions, and seeding investments. Financial data comes from platform APIs, manual imports, CSV uploads, and inferred calculations — each with different reliability. Without a structured proof layer, creators see headline numbers they can't trust, make decisions based on mixing official and estimated data, and have no defensible evidence for tax, brand negotiation, or dispute resolution.

M19 exists as the **financial truth and proof layer** — the operating ledger that computes profit from canonical revenue and cost objects, qualifies every financial metric with provenance (source class + confidence), maintains an evidence chain for every claim, and ensures the system NEVER silently mixes estimated data with official truth.

## Scope

### Covers (M19 owns financial truth)
- **Revenue aggregation**: orders (M13), settlements (platform payouts), membership subscriptions (M15)
- **Cost aggregation**: platform fees, shipping, COGS, AI credits, affiliate commissions, seeding costs, ads spend, other costs
- **Profit calculation**: gross revenue − all costs = net profit, with per-scope breakdowns (workspace, product, campaign, content, period)
- **Proof truth hierarchy**: Official > Reconciled > Estimated > Inferred > Unreconciled
- **Source class system**: every money value carries `source_class` (official, imported, inferred, estimated, unreconciled)
- **Confidence bands**: high, medium, low — derived from source class mix and evidence coverage
- **Evidence objects**: screenshot, API response, receipt, report, platform data — immutable with content hash
- **Proof bundles**: assembled claims with supporting evidence and gap documentation
- **Reconciliation engine**: match settlements to orders, detect conflicts
- **Unreconciled bucket**: always visible, never hidden, never auto-resolved
- **Anomaly detection**: unusual revenue/cost patterns trigger alerts
- **Money card UX contract**: every money card shows source class badge + confidence + drilldown

### Does NOT cover (M19 boundaries)
- **M13 owns**: order lifecycle, order creation/ingestion (M19 consumes order data)
- **M14 owns**: offer/campaign strategy (M19 tracks their financial impact)
- **M16 owns**: affiliate attribution, commission calculation (M19 records commission as cost_item)
- **M17/M18 own**: live/seeding operations (M19 tracks their financial outcomes)
- Payment processing: Stripe/platform handles; M19 records the financial truth
- Tax calculation: M19 provides export data; tax calculation is advisory/third-party

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Finance Operator | Editor+ | Review profit, drill into costs, submit evidence, trigger reconciliation |
| Manager | Manager+ | Review profit, export reports, assemble proof bundles |
| Admin | Admin+ | Queue reconciliation, force-reconcile, override reconciliation conflicts, configure anomaly thresholds |
| System (Reconciliation) | System | Match settlements to orders, detect conflicts, update reconciliation states |
| System (Snapshot) | System | Compute profit snapshots, detect anomalies, refresh materialized views |
| System (Cost Tracker) | System | Record cost_items from generation_jobs (AI credits), commissions, shipping |

## Business Rules

1. **RULE-M19-001 (CRITICAL)**: **Estimated data MUST NOT be mixed with Official truth without a label.** Every money value displayed in the UI MUST show its `source_class` badge. When computing aggregates mixing official and estimated sources, the aggregate MUST show `confidence = 'low'` or `'medium'` with a caveat: "This total includes estimated values." The system MUST NOT present a mixed-source total as if it were official truth (PRD §15.1, §23.19 AC, Pack 06 §7).
2. **RULE-M19-002**: Proof truth hierarchy determines display priority: `Official (API-confirmed) > Reconciled (matched against settlement) > Estimated (derived from available data) > Inferred (partially traceable) > Unreconciled (no match found)`. Higher-truth data always takes precedence when multiple sources exist for the same metric (Pack 06 §7.1).
3. **RULE-M19-003**: The **unreconciled bucket** MUST always be visible on profit dashboards. It shows: total unreconciled amount, count of unreconciled items, age distribution. The bucket CANNOT be hidden, collapsed, or auto-resolved. User must explicitly act on each unreconciled item (PRD §23.19 AC).
4. **RULE-M19-004**: Profit formula: `Net Profit = Gross Revenue − Platform Fees − Shipping − COGS − AI Credits − Affiliate Commissions − Ads Spend − Seeding Costs − Refund Deductions − Other Costs`. Each line item carries its own `source_class` and `confidence`. The formula result inherits the LOWEST confidence from any contributing line item (Pack 06 §5, DB schema §11.3).
5. **RULE-M19-005**: Evidence objects are **immutable** — once created, their content cannot be edited; verification metadata may change with audit, and legally required erasure uses an authorized maintenance path. Each evidence object has a `content_hash` (SHA-512) for integrity verification. Evidence supports: screenshots, API responses, receipts, reports, platform data exports (DB schema §11.4).
6. **RULE-M19-006**: Proof bundles assemble multiple evidence objects into a coherent claim. Every proof bundle MUST document: claim scope, claim summary, supporting evidence IDs, confidence band, coverage summary, and unresolved gaps. Gaps are explicitly listed — a proof bundle with unresolved gaps is still valid but with reduced confidence (DB schema §11.5, Pack 06 §7.2).
7. **RULE-M19-007**: Canonical reconciliation truth uses the shared enum `reconciliation_state`: `awaiting_evidence`, `imported_only`, `inferred_pending_confirmation`, `partially_reconciled`, `fully_reconciled`, `conflict_detected`, `manually_overridden`. `settlements.settlement_state` is a separate ingestion lifecycle (`imported → normalized → ready_for_matching → archived`) and MUST NOT be confused with reconciliation truth. Override requires Admin+ with reason + audit trail. Conflicts cannot be auto-resolved; they require human decision (Pack 06 §6, DB schema §11.1).
8. **RULE-M19-008**: Money cards (UI) MUST show: (a) the monetary value, (b) source class badge (colored icon), (c) confidence indicator (high/medium/low), (d) data freshness timestamp, (e) drilldown CTA to underlying objects/evidence. Frontend MUST NOT perform ad-hoc financial calculations — it MUST consume pre-computed values from profit_snapshots and derived views (Pack 06 §11).

## Main Flow

1. **Revenue recording**: Orders arrive from M13 → completed orders create recognized revenue postings; earlier states remain pending
   - `order.imported` / `order.state_changed` events consumed
   - Revenue recorded with `source_class` from order (official for connected platform, imported for manual)
2. **Cost recording**: Cost events arrive from multiple sources
   - AI credits: `asset.generation_completed` → cost_item (type = `ai_credits`)
   - Commissions: `affiliate.commission.calculated` → cost_item (type = `commission`)
   - Platform fees: extracted from `orders.fee_breakdown`
   - Seeding: `sample_request.approved` → cost_item (type = `seeding`, source_class = `estimated`)
   - COGS: from immutable `orders.items[].unit_cogs` captured at transaction time
   - Other: manual entry with evidence requirement
3. **Settlement import**: Platform settlements ingested
   - Settlement data imported (Shopee weekly payout, TikTok settlement, etc.)
   - `settlement_state = 'imported'`, `reconciliation_state = 'imported_only'`
   - `settlement.imported` event emitted
4. **Reconciliation**: System matches settlements to orders
   - Automatic matching by external_order_id, amount, date
   - Candidate match found but human confirmation still needed → `inferred_pending_confirmation`
   - Fully matched and confirmed → `fully_reconciled`
   - Partially matched → `partially_reconciled`
   - Mismatch detected → `conflict_detected`
   - Admin override with reason → `manually_overridden`
   - Unmatched imported items remain `imported_only`; evidence-gated items remain `awaiting_evidence`
   - `settlement.reconciled` or `reconciliation.conflict_detected` events emitted
5. **Profit snapshot computation**: System computes materialized profit views
   - Per scope: workspace, product, platform, campaign, content, period
   - Each snapshot carries `source_class_mix`, `confidence`, `freshness_at`; recognition, FX, component dedup and fixture arithmetic follow [Financial computation](../../04_contracts/financial_computation_contract.md)
   - `profit.snapshot_updated` event emitted
   - **Computation triggers** (multi-strategy):
     - **Event-driven (primary)**: On `order.state_changed`, `settlement.reconciled`, `cost.recorded`, `refund.completed` → affected scope snapshots recompute within 30s
     - **Cron (catch-all)**: Full recomputation every **15 minutes** for active workspaces (those with >0 orders in last 30 days). Inactive workspaces recompute daily at 03:00 UTC.
     - **On-demand**: User clicks "Refresh" on profit dashboard → forces immediate recomputation for that workspace scope (rate limit: 1 per 60s per workspace)
   - **Staleness threshold**: Money cards MUST show `freshness_at` timestamp. If `NOW() - freshness_at > 30 minutes`, card shows ⚠️ "Data may be stale — refreshing…" and triggers on-demand recomputation
6. **Anomaly detection**: System monitors for unusual patterns
   - Revenue drop > threshold → `profit.anomaly_detected` event
   - Cost spike → alert
   - Reconciliation gap widening → alert
7. **Proof assembly**: Operator assembles proof bundles for claims
   - Select scope (e.g., "Campaign X generated Y revenue")
   - System pulls relevant evidence objects
   - Operator reviews, adds supplements, documents gaps
   - `proof_bundle.assembled` event → available for export/reporting

## Alternate Flows

### A1: Manual Cost Entry
- Trigger: Cost not captured automatically (e.g., external service, offline expense)
- Steps: Operator creates cost_item manually → evidence required (receipt upload) → `source_class = 'imported'` → cost enters profit calculation
- Result: Manual costs tracked with explicit source provenance

### A2: Reconciliation Conflict
- Trigger: Settlement amount doesn't match tracked orders
- Steps: System flags conflict → `reconciliation.conflict_detected` event → Admin reviews → resolves by: adjusting order amounts, adding missing orders, or documenting as agreed discrepancy → audit trail recorded
- Result: Conflict resolved with full audit trail, not auto-resolved

### A3: Proof Bundle for Brand Negotiation
- Trigger: Creator needs verified performance data for brand deal pricing
- Steps: Operator selects campaign scope → system pulls: orders, revenue, content performance, audience metrics → assembles proof bundle with evidence objects → exports as branded PDF with Creativanta verification stamp → confidence level clearly shown
- Result: Defensible performance proof with transparent methodology

## Edge Cases

### EC-M19-001: Mixed Source Class in Aggregate
- Condition: Profit snapshot includes 70% official data and 30% estimated data
- Expected behavior: Aggregate confidence inherits the lowest contributing band, capped at `'medium'` for mixed estimated/official sources. Money card shows: value + "medium confidence" badge + caveat "Includes estimated values (30%)." Drilldown shows per-line-item source class breakdown. Dashboard never hides the source mix.
- Reference: RULE-M19-001, RULE-M19-004

### EC-M19-002: Settlement Import with No Matching Orders
- Condition: Platform settlement contains orders not in the system
- Expected behavior: Unmatched settlement items enter unreconciled bucket with `reconciliation_state = 'imported_only'`. System suggests: "Import missing orders from [Platform]" CTA. Unreconciled amount visible on dashboard. Revenue from these items shows as `source_class = 'unreconciled'` until matched.
- Reference: RULE-M19-003, RULE-M19-007

### EC-M19-003: Refund Impact on Profit Snapshot
- Condition: Refund processed on order that was already counted in profit snapshot
- Expected behavior: `refund.completed` event triggers profit snapshot recomputation. Refund deducted as `refund_deductions` line item. Snapshot `freshness_at` updates. If original order was `reconciled`, refund preserves reconciliation state but adds deduction. Dashboard shows: "Profit revised due to refund — [Details]."
- Reference: RULE-M19-004, Domain events §19

### EC-M19-004: Evidence Object Integrity Failure
- Condition: Stored evidence file doesn't match content_hash on re-verification
- Expected behavior: Evidence marked as `verification_status = 'failed'`. Proof bundles referencing this evidence downgrade confidence. Alert: "Evidence integrity check failed for [evidence_id] — original file may have been corrupted." Evidence is NOT deleted — it's flagged for investigation.
- Reference: RULE-M19-005

## State Machine

### Reconciliation State

Object: order / settlement / reconciliation_record | DB column: `orders.reconciliation_state`, `settlements.reconciliation_state`, `reconciliation_records.reconciliation_state`

| From | To | Trigger | Condition |
|---|---|---|---|
| — | imported_only | Settlement imported | Imported payout exists but no canonical match confirmed yet |
| — | awaiting_evidence | Manual or inferred record created | Supporting evidence still missing |
| imported_only | inferred_pending_confirmation | Candidate match found | Auto-match confidence passes threshold but requires confirmation |
| awaiting_evidence | inferred_pending_confirmation | Evidence uploaded and candidate match found | Manual/derived record becomes matchable |
| inferred_pending_confirmation | fully_reconciled | Match confirmed | Amount, identity, and timing all validated |
| inferred_pending_confirmation | partially_reconciled | Partial match accepted | Some evidence is still unresolved |
| inferred_pending_confirmation | conflict_detected | Conflict detected | Amount mismatch or duplicate claim |
| partially_reconciled | fully_reconciled | Missing evidence provided | Gaps filled |
| conflict_detected | manually_overridden | Admin overrides with reason | Exception accepted and audit recorded |
| fully_reconciled | conflict_detected | Later discrepancy discovered | Re-opened due to reversal/refund/data correction |

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../../04_contracts/database_schema.md) | §11 (settlements, cost_items, profit_snapshots, evidence_objects, proof_bundles), §10.3 (`orders.reconciliation_state`), §19.9E (`reconciliation_records.reconciliation_state`) |
| API | [04_contracts/api_endpoint_map.md](../../04_contracts/api_endpoint_map.md) | §2.7 (SettlementService, CostService, ProfitService, ReconciliationService, EvidenceService, ProofService — ~20 RPCs) |
| Events | [04_contracts/domain_event_catalog.md](../../04_contracts/domain_event_catalog.md) | §10 (settlement.imported, settlement.reconciled, cost.recorded, profit.snapshot_updated, profit.anomaly_detected, evidence.submitted, proof_bundle.assembled, reconciliation.conflict_detected) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../../04_contracts/rbac_permission_matrix.md) | §2.8 (finance — Manager+ for profit views, Admin+ for reconciliation manage/override, Editor+ for evidence submission) |
| Pack 06 | Pack 06 — Finance/Proof Contract <!-- Legacy ref: creativanta_detail_design_pack_06_commerce_finance_proof_reporting_admin_contract_v_3_1.md — superseded by current feature docs + contract layer --> | §5 (Profit OS), §6 (Reconciliation), §7 (Proof Layer), §11 (FE/UX — money cards) |
| Source class | PRD Part 1, §15.1 | official, imported, inferred, estimated, unreconciled |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Profit dashboard | Money cards with source class badges, confidence indicators, unreconciled bucket always visible |
| Web | Revenue breakdown | Per-product, per-platform, per-campaign revenue with source class drilldown |
| Web | Cost breakdown | Line-item costs with evidence links, source class per item |
| Web | Reconciliation console | Imported vs tracked comparison, match/unmatch/override actions |
| Web | Evidence library | Uploaded/auto-captured evidence objects, integrity status |
| Web | Proof bundle builder | Claim assembly with evidence selection, gap documentation |
| Mobile | Profit summary | Compact money cards, swipe for drilldown, source class visible |
| Mobile | Quick evidence capture | Camera → upload receipt/screenshot as evidence |

## Acceptance Criteria

1. **Given** a profit dashboard is displayed, **when** the profit snapshot includes a mix of official (70%) and estimated (30%) data, **then** the money card MUST show: the profit value, a confidence badge following the minimum-band rule (at most medium), a caveat "Includes estimated values (30%)," source class breakdown on drilldown — the card MUST NOT present the value as official truth.

2. **Given** a settlement is imported from Shopee, **when** 5 out of 20 settlement line items have no matching orders in the system, **then** those 5 items MUST appear in the unreconciled bucket with `reconciliation_state = 'imported_only'` — the unreconciled bucket MUST be visible on the profit dashboard, not hidden or collapsed.

3. **Given** a `affiliate.commission.calculated` event fires from M16, **when** M19 processes it, **then** the workspace's economic role MUST determine whether the amount is seller commission expense or creator affiliate income, using the financial computation contract; repeated observations of the same component MUST NOT create a second posting.

4. **Given** an operator assembles a proof bundle for "Campaign X ROI," **when** the bundle includes 8 evidence objects but 2 required evidence categories are missing, **then** the proof bundle MUST show `confidence = 'medium'` (or lower), `unresolved_gaps` listing the 2 missing categories, and `coverage_summary` explaining what IS proven.

5. **Given** any money card in the application (revenue, cost, profit), **when** the card is displayed, **then** it MUST show: (a) monetary value, (b) source class icon/badge, (c) confidence indicator, (d) data freshness — the frontend MUST NOT perform its own financial calculations; it MUST consume `profit_snapshots` data.

## Open Questions / Blockers

- [NONE] — No critical blockers specific to M19 in OPEN_BLOCKERS.md. Finance endpoints defined in API map §2.7 (~20 RPCs).
- [NOTE] DB-H-001 (RESOLVED): All money/credit fields use `NUMERIC(18,6)` — never REAL or FLOAT. Verified resolved in schema.

## Evidence coverage and repair queue

Alongside the profit value, show missing required component count, unreconciled amount/count and freshness, with links to the contributing orders/costs/evidence. Coverage is computed on the server by the financial contract, never inferred from a reassuring badge or a zero-valued missing field. Order the repair queue by explicit severity, oldest unresolved timestamp, then stable object identity; explain this ordering and allow filtering by source/product/period.

A repair action opens the existing reconciliation, cost or evidence flow with its own permission check. An operator without that permission can inspect only authorized gaps and request an authorized reviewer through the existing task flow. No new write path may set profit or declare raw evidence verified.

Given an order without COGS, show incomplete profit and a cost-entry CTA, including an explicit zero-cost-with-reason path. Given a later cost correction, recompute gaps and financial projections without altering the imported proof. Given an aggregate with unknown components, show unknown count separately from source percentages, even if the recorded missing amount is zero.
