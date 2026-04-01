---
layer: features
module: M16
canonical: true
domain: commerce
status: READY
last_updated: 2026-03-30
---

# Feature: In-Product Affiliate Network & Creator Pro Tools (M16)

## Purpose

Affiliate commerce is the primary revenue engine for many SEA creators — but managing links across platforms, tracking attribution accurately, reconciling statements, and presenting a professional profile to brands requires tools scattered across 5+ services. Without a unified affiliate layer, attribution is guesswork, payouts don't connect to profit, and creators lack the professional tools to grow brand partnerships.

M16 exists as the **affiliate operations and creator professionalization layer** — managing link generation, creator assignments, multi-source attribution with explicit confidence labeling, affiliate statement reconciliation, and payout-to-ledger linking. It also houses the Creator Pro toolset (S16): link-in-bio pages, AI media kits, rate cards, and brand deal management — professional tools that help creators monetize more effectively and present credibly to brands.

## Scope

### Covers (M16 owns affiliate operations + S16 Creator Pro)
- Affiliate link generation and management (per product, per offer, per campaign)
- Coupon assignment for affiliate tracking
- Creator assignment to campaigns/products
- Attribution tracking with source class + confidence labeling
- Ambiguous attribution explicit labeling (inferred/unreconciled — PRD §15.1)
- Affiliate statement import and reconciliation
- Payout-to-ledger linking (every affiliate payout → M19 operating ledger)
- Link health monitoring (redirect chain analysis, broken link detection, product availability)
- **S16 Link-in-Bio Builder**: personal landing page (`creativanta.link/{username}` or custom domain)
- **S16 Media Kit Auto-Generator**: AI-generated media kit from workspace data
- **S16 Rate Card Builder**: AI-suggested pricing for brand collaborations
- **S16 Brand Deal Management (v1)**: simplified deal pipeline (manual entry, status tracking)
- **S16 Revenue Per Content Tracker**: content ROI dashboard with RPM tracking
- **S16 Tax Report Export**: income reports for tax filing

### Does NOT cover (M16 boundaries)
- **M13 owns**: product catalog, order lifecycle (M16 links reference M13 products)
- **M14 owns**: offer strategy, coupon lifecycle rules (M16 uses coupons M14 creates)
- **M19 owns**: profit calculations, settlement reconciliation logic (M16 feeds data to M19)
- **S16 P2 scope**: brand deal CRM pipeline (kanban), contract templates, brand marketplace — deferred

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Creator / Affiliate | Editor+ | Generate links, share links/coupons, view attributed results, create media kit |
| Manager | Manager+ | Assign creators to campaigns, import statements, configure rate cards, manage brand deals |
| System (Attribution) | System | Track clicks → conversions → revenue attribution, calculate confidence |
| System (Health) | System | Monitor link health (redirect chains, availability, geo-access) |
| System (AI) | System | Generate media kit content, suggest rate card pricing |

## Business Rules

1. **RULE-M16-001**: Every attributed performance metric MUST have a `source_class` (official, imported, inferred, estimated, unreconciled) AND a `confidence` level. Attribution from connected platforms with API data = `official`. UTM-based correlation = `inferred`. Manual import = `imported`. Unmatched attribution = `unreconciled`. NO attribution may be displayed without its source class badge (PRD §15.1, §23.16 AC).
2. **RULE-M16-002**: Ambiguous attribution MUST be explicitly labeled as `inferred` or `unreconciled`. The system MUST NOT present uncertain attribution as definitive truth. UI badge shows "Inferred" or "Awaiting reconciliation" with explanation link. This applies to: cross-device attribution, post-view conversions, multi-touch attribution where last-click rule is ambiguous (PRD §23.16 AC).
3. **RULE-M16-003**: Affiliate payouts and commissions MUST link to the M19 operating ledger. Every `commission.calculated` event creates a cost_item (type = `commission`) in M19. Every `commission.paid` event links to the corresponding payout settlement. The profit formula in M19 deducts affiliate commissions as a cost layer (PRD §16.5, Pack 06 §4.2).
4. **RULE-M16-004**: Affiliate statement reconciliation matches imported platform statements against tracked conversions. Reconciliation states: `open → matching → partially_reconciled → fully_reconciled / conflict_detected`. Unreconciled items MUST remain visible with explicit "unreconciled" label — they are NOT hidden or auto-resolved (Pack 06 §6).
5. **RULE-M16-005**: Link health monitoring checks: redirect hops (warn if >3), HTTPS enforcement, geo-availability, product stock at destination, commission rate changes. Broken links trigger `affiliate.link_health.broken` event (critical notification). System suggests replacement products with similar commission when links break (S14 §S14.4, API §9).
6. **RULE-M16-006 (S16)**: Link-in-Bio pages on shared domain `creativanta.link` must have anti-abuse protection. URL destination scan (Google Safe Browsing API), AUP violation handling (warn → remove in 48h), mass creation throttle (max 20 links/day), report mechanism. Pro+ tiers can use custom domains with CNAME + SSL auto-provision (S16 §2.4).
7. **RULE-M16-007 (S16)**: Media Kit generation pulls real-time metrics from connected platforms. Content: creator overview, platform stats, audience demographics, top content, rate card, past collaborations, contact info. AI credit cost: 3-5 credits per generation. ≥3 professional templates available with brand kit auto-applied (S16 §3).
8. **RULE-M16-008 (S16)**: Rate Card AI suggests pricing based on: followers × engagement rate × niche multiplier (for posts), views avg × completion rate × niche (for videos). Pricing is a suggestion — creator has final control. Rate card items store both `ai_suggested_price` and creator-set `price_min` / `price_max` (S16 §4).
9. **RULE-M16-009 (S16)**: Brand Deal (v1 scope) is a simplified manual pipeline: `negotiating → agreed → in_progress → delivered → paid → completed`. Calendar integration for deadlines. P2 defers: kanban CRM, contract templates, auto-invoice, brand marketplace (S16 §6).

## Main Flow

### Affiliate Operations Flow
1. **Link generation**: Operator creates affiliate link for product/offer/campaign
   - `AffiliateService/CRUD` (Editor+)
   - System generates tracked URL + optional short code
   - `affiliate_link.created` event emitted
2. **Creator assignment**: Manager assigns creator to campaign with product/link
   - Creator receives assignment notification
   - `creator_assignment.created` event emitted
3. **Attribution tracking**: System tracks click → conversion → revenue chain
   - Click events recorded (UTM, referral, direct link)
   - Conversion events matched to clicks (attribution window: configurable, default 7 days)
   - `conversion.attributed` event emitted with `{order_id, link_id, commission, source_class}`
4. **Commission calculation**: System calculates commission per conversion
   - `commission.calculated` event → feeds M19 as cost_item
   - `commission.paid` event when payout confirmed
5. **Statement reconciliation**: Manager imports platform affiliate statements
   - System matches statement line items against tracked conversions
   - Unmatched items flagged as `unreconciled`
   - Matched items update reconciliation_state

### Creator Pro (S16) Flow
1. **Link-in-Bio**: Creator builds landing page → configures links → publishes at `creativanta.link/{slug}`
   - System scans URL destinations for safety
   - Analytics track views + clicks per link
2. **Media Kit**: Creator triggers AI generation → system pulls metrics → generates branded PDF/web page
   - Shareable link + downloadable PDF
   - Auto-updates when metrics change significantly
3. **Rate Card**: Creator/AI generates pricing → creator reviews/adjusts → saves for brand outreach
4. **Brand Deal**: Creator logs deal → tracks deliverables → marks completed → revenue recorded in M19

## Alternate Flows

### A1: Multi-Touch Attribution Ambiguity
- Trigger: Customer clicks affiliate link, then visits directly, then purchases
- Steps: System records both click sources. Attribution applied with `source_class = 'inferred'` and lower confidence. UI shows "Attributed (inferred)" badge with "Multiple touch points detected — last click rule applied."
- Result: Revenue attributed but clearly labeled as non-definitive

### A2: Broken Affiliate Link Detection
- Trigger: Link health check detects broken destination or product unavailability
- Steps: `affiliate.link_health.broken` event fired → critical notification → operator sees broken link in dashboard with "Suggested replacement: [similar product]" → operator can update or pause link
- Result: Revenue leakage prevented through proactive link maintenance

### A3: Link-in-Bio Abuse Detection
- Trigger: URL destination flagged by Google Safe Browsing
- Steps: Link flagged → creator warned → 48h to fix/remove → if no action, link auto-removed. If shared domain reputation threatened, ops alerted for emergency suspension of violating pages.
- Result: Shared domain reputation protected; legitimate creators unaffected

## State Machine

### Affiliate Link Lifecycle

| From | To | Trigger | Condition |
|---|---|---|---|
| — | active | Link created | `AffiliateService/CreateLink` (Editor+) |
| active | paused | Operator pauses | Manual pause or stock-out auto-pause |
| paused | active | Operator resumes | `AffiliateService/Resume` |
| active | broken | Health check fails | Redirect broken / product unavailable → `affiliate.link_health.broken` |
| broken | active | Operator fixes destination | Link destination updated and health check passes |
| active | expired | TTL reached or campaign ends | System auto-expires based on `expiry_date` |
| any (except deleted) | deleted | Operator deletes | Soft delete with `deleted_at` |

### Reconciliation Lifecycle

| From | To | Trigger | Condition |
|---|---|---|---|
| — | open | Statement imported | `ReconciliationService/Import` |
| open | matching | System starts auto-match | Background job matches line items to tracked conversions |
| matching | partially_reconciled | Some matches found | ≥1 match but unmatched items remain |
| matching | fully_reconciled | All matches found | 100% line items matched to tracked conversions |
| matching | conflict_detected | Contradictory matches | Same order attributed to multiple sources → human review required |
| partially_reconciled | fully_reconciled | Human resolves remaining | All unmatched items manually resolved |
| conflict_detected | fully_reconciled | Human resolves conflict | Override decision with reason + audit trail |

### Brand Deal Lifecycle (S16 v1)

| From | To | Trigger | Condition |
|---|---|---|---|
| — | negotiating | Creator logs deal | Manual entry |
| negotiating | agreed | Terms confirmed | Creator marks as agreed |
| agreed | in_progress | Work begins | Creator starts deliverables |
| in_progress | delivered | All deliverables submitted | Creator marks complete |
| delivered | paid | Payment received | Creator confirms payment |
| paid | completed | Deal closed | Final status — archived |

## Affiliate Link Health Monitor

> Source: Pricing/Credits Contract §5 — Affiliate Link Health Monitor Contract

### Purpose

Automatically detect broken, expired, or degraded affiliate links — preventing silent revenue loss. Every broken link is assessed for revenue impact and prioritized for operator action.

### Health Check Types

| Check Type | Frequency | Action on Failure |
|---|---|---|
| **HTTP status check** | Every 6 hours | Flag dead link + notify operator |
| **Product availability** | Every 12 hours | Flag out-of-stock + suggest alternative product |
| **Price change detection** | Every 12 hours | Notify if price changed significantly (>10%) |
| **Commission rate change** | Daily | Alert if commission decreased |
| **Link expiry** | Daily | Alert 7 days before expiry |
| **Redirect chain check** | Weekly | Flag excessive redirects (>3 hops) |
| **Platform account status** | Daily | Check if affiliate account still active |

### Link Health Object

```
LinkHealth:
  link_health_id: UUID
  affiliate_link_ref: FK → affiliate_links
  last_checked_at: timestamp
  http_status: integer
  product_status: enum(available, out_of_stock, discontinued, price_changed, unknown)
  commission_status: enum(active, changed, suspended, unknown)
  link_status: enum(healthy, warning, broken, expired)
  expiry_date: date (nullable)
  suggested_action: text
  revenue_impact_30d: NUMERIC(14,2) — estimated 30-day revenue impact of this link being broken
  alert_sent: boolean
```

### Revenue Impact Assessment
- Each broken link's revenue impact estimated from last 30 days of historical performance
- Sort broken links by revenue impact (fix high-impact first)
- Monthly "lost revenue" report from broken/expired links
- Dashboard widget: "X links need attention — est. Y₫ revenue at risk"

### FE/UX for Link Health
- Affiliate link list displays health status badge (✅ healthy / ⚠️ warning / ❌ broken)
- Dashboard widget: "[N] links need attention"
- Click-to-fix: suggest replacement links, update expired links
- Bulk health check action (manual trigger)
- Critical notifications for high revenue-impact broken links

---

## Edge Cases

### EC-M16-001: Commission Rate Change Mid-Campaign
- Condition: Platform changes commission rate after affiliate link was created
- Expected behavior: Link health check detects commission rate change → `affiliate.link_health.checked` event with rate change alert. Operator notified: "Commission rate for [Product] changed from 10% to 7%." Historical conversions calculated at original rate; new conversions use new rate.
- Reference: RULE-M16-005, S14 §S14.4

### EC-M16-002: Cross-Platform Attribution Conflict
- Condition: Same order attributed to two different affiliate links from different platforms
- Expected behavior: System flags as `conflict_detected` in reconciliation. Both attribution records preserved with source_class context. Human reconciliation required — system suggests resolution based on click timestamp proximity. Override requires reason + audit trail.
- Reference: RULE-M16-002, RULE-M16-004

### EC-M16-003: Shared Domain Blacklisted
- Condition: `creativanta.link` appears on platform blocklist due to abuser
- Expected behavior: Ops alerted immediately. All AUP-violating pages suspended. Legitimate pages on shared domain may be temporarily affected. Pro+ users on custom domains unaffected. Recovery: clean up violations → request blocklist removal → monitor reputation score.
- Reference: RULE-M16-006, S16 §2.4

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../04_contracts/database_schema.md) | §10.4 (affiliate_links), §10.5 (campaigns), §16 (Creator Pro: link_in_bio_pages, media_kits, rate_cards, brand_deals) |
| API | [04_contracts/api_endpoint_map.md](../04_contracts/api_endpoint_map.md) | §2.6 (AffiliateService, CampaignService — ~10 RPCs), §5 (S16: LinkInBioService, MediaKitService, RateCardService, BrandDealService — ~13 RPCs) |
| Events | [04_contracts/domain_event_catalog.md](../04_contracts/domain_event_catalog.md) | §8 (affiliate_link.created, conversion.attributed), §15 (S16 events), §15D (affiliate.link_health.*), §19 (commission.calculated, commission.paid, creator_assignment.created) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../04_contracts/rbac_permission_matrix.md) | §2.6 (affiliate — Editor+; campaign — Editor+), §5 (S16 Creator Pro — varying by feature) |
| Pack 06 | [Pack 06 — Commerce Contract](../creativanta_detail_design_pack_06_commerce_finance_proof_reporting_admin_contract_v_3_1.md) | §2.4 (Monetization Support), §4.2 (Payout/Statement), §6 (Reconciliation) |
| S16 Spec | [S16 — Creator Pro Tools](../creativanta_supplementary_s16_creator_pro_tools_v_3_1.md) | §2-7 (Link-in-Bio, Media Kit, Rate Card, Brand Deals, Revenue Tracker, Tax Export) |
| Link Health | [Pack 05 — S14](../creativanta_detail_design_pack_05_connector_capability_publish_inbox_contract_v_3_1.md) | §S14.4 (Redirect Chain Analysis) |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Affiliate link dashboard | Link list with health status, clicks, conversions, revenue, confidence badges |
| Web | Attribution report | Revenue attribution by source class, confidence breakdown, unreconciled bucket |
| Web | Statement reconciliation | Imported vs tracked comparison, match/unmatch actions |
| Web | Link-in-Bio editor | Drag-drop page builder, theme selection, link management |
| Web | Media Kit generator | AI-generated preview, template selection, export actions |
| Web | Rate Card builder | Service grid, AI suggestions, manual overrides |
| Web | Brand Deal pipeline | Status list (v1), deadline calendar integration |
| Mobile | Quick share (link/coupon) | One-tap copy/share affiliate link or coupon code |
| Mobile | Attribution results | Simplified attributed metrics view, follow-up actions |

## Acceptance Criteria

1. **Given** an affiliate link generates a conversion, **when** the attribution is calculated, **then** the conversion record MUST include `source_class` (official/imported/inferred) AND `confidence` level — the `conversion.attributed` event payload MUST include `{order_id, link_id, commission, source_class}`.

2. **Given** a conversion where the customer clicked an affiliate link but also visited directly before purchasing, **when** the system attributes the conversion, **then** it MUST be labeled as `source_class = 'inferred'` with a UI badge showing "Attributed (inferred)" and an explanation of the multi-touch scenario.

3. **Given** a `commission.calculated` event fires, **when** M19 processes it, **then** a `cost_item` MUST be created with `cost_type = 'commission'` linked to the corresponding order/campaign scope — ensuring the affiliate commission is deducted in the M19 profit formula.

4. **Given** a creator generates an AI Media Kit (S16), **when** generation completes, **then** the media kit MUST include auto-populated platform stats from connected accounts, ≥3 sections (overview, stats, top content), and a shareable link — the AI credit cost MUST be 3-5 credits.

5. **Given** a link health check detects a broken affiliate link, **when** the `affiliate.link_health.broken` event fires, **then** the operator MUST receive a critical notification with the broken link details AND a suggested replacement product (if available).

## Open Questions / Blockers

- [NONE] — No critical blockers specific to M16 in OPEN_BLOCKERS.md. Affiliate endpoints defined in API map §2.6 (~5 RPCs) and S16 Creator Pro endpoints in §5 (~13 RPCs).
