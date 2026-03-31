---
layer: features
module: M14
canonical: true
domain: commerce
status: DRAFT
last_updated: 2026-03-30
---

# Feature: Monetization OS (M14)

## Purpose

Creator commerce monetization involves multiple interconnected instruments — offers, campaigns, coupons, affiliate links, membership plans, sponsorship coordination — each requiring distinct pricing logic, channel routing, and lifecycle management. When these instruments live in silos, monetization strategy becomes fragmented: coupon codes clash, affiliate links aren't coordinated with offers, and the connection between monetization actions and the operating ledger is broken.

M14 exists as the **monetization coordination layer** — the module that manages offer strategy, pricing logic, coupon lifecycle, campaign coordination, and conversion signal linking. Every monetization object in M14 MUST map back to the M19 operating ledger when revenue or cost is generated, ensuring there are no monetization actions that produce financial impact without ledger visibility.

## Scope

### Covers (M14 owns monetization strategy and coordination)
- Offer strategy: creation, pricing logic, CTA configuration, channel availability
- Offer lifecycle management: draft → active → paused → expired → retired
- Coupon management: creation, code generation, usage limits, expiry, tracking
- Affiliate link coordination (links created via M16, M14 coordinates with offers/campaigns)
- Campaign management: campaign lifecycle, budget tracking, product/offer/creator coordination
- Monetization experiments: A/B offer testing, price experimentation
- Sponsorship monetization coordination: sponsor offer definitions
- Conversion signal linking: connecting engagement signals to monetization actions

### Does NOT cover (M14 boundaries)
- **M13 owns**: product catalog, SKU hierarchy, order lifecycle (M14 offers reference M13 products)
- **M15 owns**: storefront pages, bundle presentation, membership entitlements (M15 uses M14 offers)
- **M16 owns**: affiliate link generation, attribution tracking (M16 references M14 offers/campaigns)
- **M19 owns**: profit calculations, reconciliation (M14 feeds monetization signals → M19 aggregates)
- Payment processing: Stripe/platform handles transactions; M14 defines the commercial terms

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Creator / Seller | Editor+ | Create/edit offers, manage coupons, configure campaigns |
| Manager | Manager+ | Approve offers for activation, configure pricing rules, manage budgets |
| System (Coordination) | System | Link offers ↔ campaigns ↔ coupons ↔ affiliate links, enforce lifecycle rules |
| System (Conversion) | System | Match conversion signals to monetization objects, emit attribution events |

## Business Rules

1. **RULE-M14-001**: Every monetization object (Offer, Coupon, Affiliate Link, Membership Plan, Campaign) MUST be traceable to the M19 operating ledger when revenue or cost is generated. No monetization surface may produce financial impact outside the ledger graph. This is verified by: offer → order → settlement → ledger chain for revenue; campaign → cost_item → ledger for costs (PRD §23.14 AC, Pack 06 §2.4).
2. **RULE-M14-002**: Offer lifecycle state machine: `draft → review_required → active → paused → expired → retired`. Every offer MUST have: `offer_type`, `pricing_value`, `pricing_logic`, `cta_text`, `channel_availability`, and `lifecycle_state`. Product-backed offers link to `product_id`; product-less offers MUST have `product_less_declaration` set (Pack 06 §2.3, DB schema §10.2).
3. **RULE-M14-003**: Coupon lifecycle: `active → used → expired → revoked`. A coupon MUST have: code, discount logic (percentage/fixed), usage limits (per-coupon, per-user), effective window, linked offer/campaign. `coupon.activated`, `coupon.used`, `coupon.expired` events emitted at transitions (Domain events §19).
4. **RULE-M14-004**: Campaign is a coordination object — it groups offers, affiliate links, seeding efforts, and sponsor deliverables under a single operational scope. Campaign lifecycle: `planned → ready → live → paused → completed → cancelled`. Campaigns track budget and related product/offer IDs (DB schema §10.5, Pack 06 §2.5).
5. **RULE-M14-005**: Monetization surfaces MUST NOT stand apart from the proof/profit system. Every offer activation → `offer.activated` event consumed by M01, M11, M15. Every campaign completion → `campaign.completed` event consumed by M19 for performance assessment. UI surfaces monetization metrics with source class and confidence badges (PRD §23.14 AC).
6. **RULE-M14-006**: Conversion signal linking traces: engagement thread (M12) → user intent → suggested offer action → offer interaction → conversion event → order (M13) → revenue (M19). This path enables content ROI calculation and "comment-to-commerce" flows that are core to SEA commerce patterns (PRD §17, §25).
7. **RULE-M14-007**: Monetization support objects (Coupon, Affiliate Link, Membership Plan, Store Page, Bundle, Price Rule, Promotion Rule) follow a family contract requiring: canonical ID, related product/offer/campaign refs, commercial logic summary, lifecycle state, effective window, and auditability for price/commission/entitlement changes (Pack 06 §2.4).

## Main Flow

1. **Offer creation**: Operator creates offer
   - `OfferService/CRUD` (Editor+)
   - Links to product (M13) or declares product-less type
   - Pricing, CTA, channel availability configured
   - `lifecycle_state = 'draft'`
2. **Offer activation**: Manager reviews and activates offer
   - Offer goes through `review_required` if policy requires
   - `lifecycle_state = 'active'`, `offer.activated` event emitted
   - Offer available on configured channels (M15 storefront, M11 publish, M16 affiliate)
3. **Campaign setup**: Manager creates campaign grouping offers + creators + budget
   - Campaign type: content, affiliate, seeding, live, brand_collab
   - Links products, offers, seeding lists
   - `campaign.started` event emitted when activated
4. **Coupon management**: Operator creates coupons linked to offers/campaigns
   - Code generation (manual or auto), discount logic, limits
   - `coupon.activated` event emitted
   - Usage tracked per redemption → `coupon.used` event → feeds M19
5. **Conversion tracking**: System links engagement signals to monetization
   - Thread intent (M12) → suggested offer → offer interaction → click/lead/conversion
   - `conversion.attributed` event emitted by M16 with commission details
6. **Campaign completion**: Campaign reaches end date or manually completed
   - `campaign.completed` event → M19 calculates campaign ROI
   - Performance metrics assembled with proof evidence

## Alternate Flows

### A1: Comment-to-Commerce Flow
- Trigger: M12 detects `intent = 'purchase_interest'` on a thread
- Steps: M12 suggests commerce action → operator selects relevant offer → offer shared with customer via reply. If conversion tracked: engagement → offer → order → revenue chain established.
- Result: Revenue attributable to engagement-driven monetization

### A2: Monetization Experiment (A/B Offer)
- Trigger: Operator wants to test two pricing strategies
- Steps: Create two offers with different pricing → assign to experiment → split traffic/channels → track conversion rates → declare winner → retire losing variant
- Result: Data-driven pricing decisions with tracked experiments

### A3: Sponsor Offer Coordination
- Trigger: Brand collaboration requires specific offer terms
- Steps: Create offer with `offer_type = 'sponsor_offer'` → link to campaign with type `brand_collab` → define deliverables and payment terms → track through brand deal pipeline (S16)
- Result: Sponsor monetization coordinated within canonical commerce graph

## Edge Cases

### EC-M14-001: Offer Activated Without Product Link
- Condition: Operator activates offer without linking to product or setting product-less declaration
- Expected behavior: System blocks activation with validation error: "Offer must reference a product (M13) or declare as product-less (digital/community/service)." Offer remains in `draft` state.
- Reference: RULE-M14-002, RULE-M13-001

### EC-M14-002: Coupon Used After Expiry
- Condition: Race condition — customer starts checkout with valid coupon, completes after coupon expires
- Expected behavior: Coupon validity checked at point of commitment (not just display). If expired during checkout: order processes without discount. Diagnostics: "Coupon [code] expired during checkout for order [X]."
- Reference: RULE-M14-003

### EC-M14-003: Campaign Budget Exceeded
- Condition: Campaign spend exceeds configured budget
- Expected behavior: System emits warning when 80% budget consumed. At 100%: alert to Manager, offers can optionally auto-pause. Budget is tracked as sum of `cost_items` with `related_scope_id = campaign_id`. Campaign does NOT auto-cancel — operator decides.
- Reference: RULE-M14-004

## State Machine

### Offer Lifecycle

Object: offer | DB column: `offers.lifecycle_state`
see [04_contracts/database_schema.md#10.2](../04_contracts/database_schema.md)

| From | To | Trigger | Condition |
|---|---|---|---|
| — | draft | Offer created | Basic fields populated |
| draft | review_required | Submitted for review | Policy requires review |
| draft | active | Direct activation | No review policy OR Manager activates |
| review_required | active | Manager approves | Manager+ action |
| review_required | draft | Manager returns for edits | With feedback |
| active | paused | Operator pauses | Temporary suspension |
| paused | active | Operator reactivates | Conditions met |
| active | expired | Effective window ends | End date reached |
| expired | retired | Operator retires | Permanent deactivation |
| any (pre-retired) | retired | Operator retires | Final state |

### Campaign Lifecycle

Object: campaign | DB column: `campaigns.status`

| From | To | Trigger | Condition |
|---|---|---|---|
| — | planned | Campaign created | Title + type + dates |
| planned | ready | Setup complete | Products/offers/creators linked |
| ready | live | Manager activates | Start date reached or manual |
| live | paused | Manager pauses | Temporary hold |
| paused | live | Manager resumes | Resume operations |
| live | completed | End date or manual | Campaign objectives met |
| any (pre-completed) | cancelled | Manager cancels | With reason |

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../04_contracts/database_schema.md) | §10.2 (offers), §10.5 (campaigns), plus coupon/monetization support in §19 operational context |
| API | [04_contracts/api_endpoint_map.md](../04_contracts/api_endpoint_map.md) | §2.6 (OfferService, CampaignService — ~11 RPCs) |
| Events | [04_contracts/domain_event_catalog.md](../04_contracts/domain_event_catalog.md) | §8 (offer.activated, offer.expired, campaign.started, campaign.completed), §19 (coupon.activated, coupon.used, coupon.expired, commission.calculated) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../04_contracts/rbac_permission_matrix.md) | §2.6 (offer — Editor+; campaign — Editor+) |
| Pack 06 | [Pack 06 — Commerce Contract](../creativanta_detail_design_pack_06_commerce_finance_proof_reporting_admin_contract_v_3_1.md) | §2.3 (Offer), §2.4 (Monetization Support Objects), §2.5 (Campaign) |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Offer management | CRUD view with lifecycle state filters, channel availability matrix |
| Web | Campaign dashboard | Campaign list with status, budget utilization, linked objects overview |
| Web | Coupon management | Code list, usage stats, active/expired filters |
| Web | Monetization analytics | Cross-object performance: offers × campaigns × channels breakdown |
| Mobile | Quick coupon/link access | Copy coupon code, share affiliate link, one-tap actions |
| Mobile | Offer tweaks | Quick price/CTA edits on active offers |
| Mobile | Conversion follow-up | View recent conversions, follow-up on engagement-driven offers |

## Acceptance Criteria

1. **Given** an offer is activated with a linked product, **when** an order is placed using this offer, **then** the revenue chain MUST be traceable: offer → order → settlement → M19 ledger — the offer's `offer_id` MUST appear in the order's `offer_id` field.

2. **Given** a coupon is used in a purchase, **when** the `coupon.used` event fires, **then** the coupon usage count MUST increment, the discount amount MUST be recorded, and the linked order MUST reference the coupon — the discount impact MUST appear in M19's profit calculation.

3. **Given** a campaign with budget $1,000, **when** tracked costs reach $800, **then** the system MUST emit a warning notification to the campaign manager — at $1,000, the manager MUST be alerted with option to pause related offers.

4. **Given** an offer without `product_id` or `product_less_declaration`, **when** the operator attempts to activate it, **then** the system MUST reject the activation with a validation error — the offer MUST remain in `draft` state.

5. **Given** monetization objects (offers, coupons, campaigns) generate revenue or costs, **when** financial events occur, **then** every financial impact MUST be traceable in M19's operating ledger — no monetization action may produce financial impact outside the ledger graph.

## Open Questions / Blockers

- [NONE] — No critical blockers specific to M14 in OPEN_BLOCKERS.md. Commerce endpoints defined in API map §2.6.
