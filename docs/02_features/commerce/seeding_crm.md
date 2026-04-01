---
layer: features
module: M18
canonical: true
domain: commerce
status: READY
last_updated: 2026-03-30
blockers: []  # API-M-001 resolved 2026-04-02 — SeedingService §2.8.4 (9 RPCs)
---

# Feature: Seeding / Sample CRM (M18)

## Purpose

Product seeding — sending samples to creators for review and content creation — is a core growth lever in SEA creator commerce. Brands and sellers manage seeding manually: spreadsheets for creator rosters, WhatsApp for shipment tracking, and zero systematic outcome measurement. Without a structured seeding layer, sample costs are invisible, follow-ups are forgotten, and the connection between seeding investments and revenue outcomes is unprovable.

M18 exists as the **seeding operations and sample lifecycle manager** — tracking sample requests from creation through shipment, delivery, and outcome logging, with explicit rules about what constitutes a proven outcome versus an unverified claim. Every seeding action feeds the M19 operating ledger, and every outcome claim must be backed by evidence or labeled with its confidence level.

## Scope

### Covers (M18 owns seeding/sample lifecycle)
- Creator roster management: list of creators for potential seeding
- Seeding lists: curated groups of creators for specific campaigns/products
- Sample request lifecycle: CREATED → APPROVED → SHIPPED → DELIVERED → OUTCOME_LOGGED
- Sample shipment tracking: carrier, tracking number, status
- Follow-up state management: pending, contacted, responded, no_response
- Outcome logging: content created, review posted, conversions tracked
- Performance linkage: seeding → content → revenue → proof (when data available)
- Seeding cost tracking: sample value + shipping → M19 cost_item

### Does NOT cover (M18 boundaries)
- **M12 owns**: initial sample request detection in inbox (M12 routes → M18 manages)
- **M13 owns**: product catalog, inventory (M18 references M13 products for samples)
- **M16 owns**: affiliate link attribution for seeded creators (M16 tracks, M18 links)
- **M19 owns**: profit calculations (M18 feeds seeding costs → M19 aggregates)
- **M14 owns**: campaign coordination (M18 seeding lists can be linked to M14 campaigns)

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Seeding Manager | Editor+ | Create sample requests, manage creator roster, log outcomes |
| Manager | Manager+ | Approve/decline sample requests, configure seeding budgets |
| Creator (external) | External | Receive sample, create content (tracked via connected accounts or manual log) |
| System (Tracking) | System | Shipment status sync, follow-up reminders, outcome detection |
| System (Cost) | System | Calculate seeding costs → emit to M19 operating ledger |

## Business Rules

1. **RULE-M18-001**: Sample request lifecycle MUST follow canonical state machine: `created → approved → declined` (terminal) or `created → approved → shipped → delivered → outcome_logged`. Each state transition is auditable with actor + timestamp. `declined` requires reason (PRD §24, §23.18 AC).
2. **RULE-M18-002**: **CRITICAL RULE — Missing proof MUST NOT be claimed as definitive outcome.** When a seeded creator hasn't posted content or when content exists but has no traceable conversion, the outcome MUST be labeled with appropriate `source_class`: `estimated` (if based on indirect signals), `inferred` (if partially traceable), or `unreconciled` (if completely unverified). The system MUST NOT present "no data" as "no result" or "data exists" as "proven result" without evidence qualification (PRD §23.18 AC, §15.1).
3. **RULE-M18-003**: Every sample request has a lifecycle state AND an outcome state. Lifecycle tracks logistics (was it shipped? delivered?). Outcome tracks business result (did the creator make content? did it drive conversions?). These are orthogonal — a delivered sample with no logged outcome is a complete lifecycle but an incomplete outcome, NOT a failed seeding (PRD §23.18 AC).
4. **RULE-M18-004**: Seeding outcomes link to campaign/performance ONLY when data exists. The linkage chain: Sample Request → Creator Assignment → Creator's Content (if created) → Conversions (if tracked via M16 affiliate or UTM) → Revenue (if attributable). Each step may be missing — the system must show exactly where the chain breaks and what confidence remains (PRD §23.18 AC).
5. **RULE-M18-005**: Seeding costs MUST feed M19 operating ledger. When a sample request is approved, system creates a provisional `cost_item` (type = `seeding`, source_class = `estimated`). When shipped, cost updates with actual shipping cost. Cost includes: product COGS (from M13 `products.cogs`) + shipping cost. These costs deduct from profit in M19's profit formula (Pack 06 §4.1).
6. **RULE-M18-006**: Follow-up states track the creator communication after delivery: `pending_followup → contacted → responded → no_response`. Follow-up tasks created as `follow_up_tasks` records. Automated reminders configurable (e.g., 3 days after delivery, 7 days, 14 days). No-response after all follow-ups is a valid terminal state — it does NOT automatically mean negative outcome (RULE-M18-002 applies).

## Main Flow

1. **Creator roster building**: Manager curates creator list for seeding
   - Creator entities referenced from M12 Entity registry or created manually
   - Creators tagged by niche, audience size, engagement rate, platform
   - Seeding lists created: named groups of creators for specific campaigns
2. **Sample request creation**: Manager creates sample request
   - Links: product (M13), campaign (M14) if applicable, creator entity
   - Quantity, shipping address, expected delivery timeline
   - `status = 'created'`, `sample_request.created` event emitted
3. **Approval**: Manager approves or declines request
   - Approved → provisional cost_item created in M19 (estimated)
   - Declined → terminal with reason, `sample_request.declined` event
   - `sample_request.approved` event emitted
4. **Shipment**: Operator logs shipment
   - Carrier, tracking number, shipped date
   - `status = 'shipped'`, `sample.shipped` event with tracking
   - Shipping cost recorded → cost_item updated with actuals
5. **Delivery confirmation**: System or operator confirms delivery
   - `status = 'delivered'`, `sample.delivered` event
   - Follow-up sequence initiated (automated reminders)
6. **Outcome logging**: Operator logs outcome after creator acts
   - Content outcome: creator posted content? Link to publish item / external URL
   - Conversion outcome: attributable conversions from content? Link to M16 attribution
   - Revenue outcome: traceable revenue? Amount + source_class
   - `status = 'outcome_logged'`
   - Outcome feeds post-live summary and campaign proof bundles

## Alternate Flows

### A1: Inbox-Originated Sample Request
- Trigger: M12 detects `intent = 'sample_request'` in inbox thread
- Steps: Operator routes thread to M18 → sample request created with `source_thread_id` → thread's `related_object_refs` updated → M18 manages lifecycle while M12 preserves inbox provenance
- Result: Sample request traceable back to original engagement context

### A2: Bulk Seeding Campaign
- Trigger: Manager wants to seed 50 creators with same product
- Steps: Manager selects seeding list → creates bulk sample requests → all approved in batch → shipments tracked individually → follow-ups automated per creator
- Result: Campaign-level seeding view with per-creator status tracking

### A3: Creator Self-Request (from Store/Link-in-Bio)
- Trigger: Creator discovers product via M15 store page and requests sample
- Steps: External request detected (inbox or form) → M12 routes to M18 → standard approval flow → sample shipped
- Result: Inbound seeding request handled through same lifecycle

## Edge Cases

### EC-M18-001: Sample Delivered But No Creator Response
- Condition: Sample delivered 30 days ago, all follow-up attempts made, no response
- Expected behavior: Follow-up state = `no_response`. Outcome state = `pending` (not `failed`). System shows "No outcome data available — sample delivered, creator has not responded." Cost still recorded in M19 ledger. Dashboard shows seeding ROI calculation with this sample as cost without attributable revenue — clearly marked as "pending outcome."
- Reference: RULE-M18-002, RULE-M18-003

### EC-M18-002: Creator Posts Content But No Attribution Link
- Condition: Seeded creator posts review video but didn't use affiliate link
- Expected behavior: If operator manually links the content: outcome logged with `source_class = 'imported'` (manually verified). If content detected but not confirmed: outcome logged with `source_class = 'inferred'`. Conversion impact: `estimated` unless UTM or affiliate data exists. System does NOT auto-claim revenue attribution without evidence chain.
- Reference: RULE-M18-002, RULE-M18-004

### EC-M18-003: Product COGS Not Set in M13
- Condition: Sample request approved for a product without COGS value in M13
- Expected behavior: Provisional cost_item created with `amount = 0` and `confidence_reason = 'COGS not configured for product'`. System warns: "Product cost not set — seeding cost calculation incomplete." Operator can manually set cost or update M13 product COGS. Cost_item updates when COGS populated.
- Reference: RULE-M18-005

### EC-M18-004: Duplicate Sample Request for Same Creator × Product
- Condition: Manager creates second sample request for same creator + product
- Expected behavior: System warns: "A sample request for [Creator] × [Product] already exists (status: [X])." Manager can proceed (valid for re-seeding) or cancel. Each request is independent with its own lifecycle.
- Reference: RULE-M18-001

## State Machine

### Sample Request Lifecycle

Object: sample_request | Stored as workflow-scoped records
see [04_contracts/domain_event_catalog.md#19](../04_contracts/domain_event_catalog.md)

| From | To | Trigger | Condition |
|---|---|---|---|
| — | created | Request created | Product + creator + details provided |
| created | approved | Manager approves | Manager+ action, budget available |
| created | declined | Manager declines | With reason (terminal) |
| approved | shipped | Shipment logged | Carrier + tracking provided |
| shipped | delivered | Delivery confirmed | Tracking confirms or manual confirmation |
| delivered | outcome_logged | Outcome recorded | Content/conversion/revenue outcome logged |

### Follow-Up States

| State | Description |
|---|---|
| pending_followup | Delivered, follow-up not yet initiated |
| contacted | Follow-up message sent to creator |
| responded | Creator responded to follow-up |
| no_response | All follow-up attempts exhausted, no response |

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../04_contracts/database_schema.md) | §12 (Operations context), §9 (follow_up_tasks, entities) |
| API | [04_contracts/api_endpoint_map.md](../04_contracts/api_endpoint_map.md) | §2.8 (Seeding — ~8 RPCs: Sample CRUD, Shipment) |
| Events | [04_contracts/domain_event_catalog.md](../04_contracts/domain_event_catalog.md) | §19 (sample_request.created, sample_request.approved, sample_request.declined, creator_assignment.created, sample.shipped, sample.delivered) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../04_contracts/rbac_permission_matrix.md) | §2.8 (seeding — Editor+ for operations, Manager+ for approval) |
| Pack 06 | [Pack 06 — Commerce Contract](../creativanta_detail_design_pack_06_commerce_finance_proof_reporting_admin_contract_v_3_1.md) | §4.1 (Cost Item Types — seeding/sample cost), §4.2 (Payout/Statement Support) |
| Source class | PRD Part 1, §15.1 | official, imported, inferred, estimated, unreconciled |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Creator roster | Searchable creator list with tags, platforms, past seeding history |
| Web | Seeding campaign dashboard | Per-campaign seeding list, per-creator status, aggregate outcome view |
| Web | Sample request detail | Lifecycle timeline, shipment tracking, follow-up history, outcome log |
| Web | Seeding ROI report | Cost vs attributable revenue, outcome coverage rate, confidence breakdown |
| Mobile | Request triage | Approve/decline sample requests with context |
| Mobile | Shipment check | Quick shipment status lookup |
| Mobile | Follow-up update | Log follow-up outcome on the go |

## Acceptance Criteria

1. **Given** a sample request is created for creator X and product Y, **when** the request is approved by a Manager, **then** the request `status` MUST be `'approved'`, a `cost_item` of type `'seeding'` MUST be provisionally created in M19 with `source_class = 'estimated'`, and the `sample_request.approved` event MUST fire.

2. **Given** a sample is delivered but the creator has not posted any content after 30 days, **when** the operator views the seeding dashboard, **then** the outcome MUST show "Pending — no content detected" with `source_class` context — the system MUST NOT display "0 revenue" as a definitive outcome or label the seeding as "failed."

3. **Given** a seeded creator posts content without using an affiliate link, **when** the operator manually logs the content URL as an outcome, **then** the outcome record MUST have `source_class = 'imported'` and conversion attribution (if any) MUST be labeled as `'inferred'` — NOT as `'official'`.

4. **Given** a sample request goes through the full lifecycle (created → approved → shipped → delivered → outcome_logged), **when** each state transition occurs, **then** every transition MUST be auditable with actor, timestamp, and associated event emission.

5. **Given** a seeding campaign with 20 sample requests, **when** the manager views the campaign summary, **then** the summary MUST show: total cost (COGS + shipping), total attributable revenue (with source_class breakdown), outcome coverage rate (% of delivered samples with logged outcomes), and confidence level of the overall ROI calculation.

## Open Questions / Blockers

> ✅ **RESOLVED: API-M-001** (2026-04-02) — `SeedingService` now fully defined in `api_endpoint_map.md` §2.8.4 with 9 RPCs: CreateSample, Get, List, Approve, Ship, TrackDelivery, GetReport, CreateCampaign, ListCampaigns. Each RPC has Method, Auth, Rate Limit, Description.
> Remaining gap: API-M-002 (JSON request/response examples not yet added).
