---
layer: features
module: M15
canonical: true
domain: commerce
status: SPECIFIED
last_updated: 2026-10-29
---

# Feature: Creator Store / Storefront Builder (M15)

## Purpose

Creators and sellers need owned storefronts where they control the buying experience — not dependent on platform algorithms or marketplace search. Whether selling physical products, digital downloads, memberships, or bundled offers, the storefront is the bridge between content audiences and commerce conversion. Without it, every sale requires a platform middleman.

M15 exists as the **creator storefront builder** — an owned commerce surface where creators publish products, offers, bundles, and membership plans to their audience. Store pages are publishable, embeddable, and linkable from content and link-in-bio pages. Every storefront transaction feeds the M19 operating ledger, and every offer displayed on the store traces back to the M14 monetization graph.

## Scope

### Covers (M15 owns storefront surfaces)
- Storefront page builder: landing pages, product pages, collection pages
- Bundle presentation: visual bundles combining multiple products/offers
- Membership management: plan creation, entitlement definition, subscriber lifecycle
- Store page publishing and theming
- Store analytics: page views, conversion rates, revenue per page
- Embedded store widgets for external sites
- Store SEO configuration
- Store domain configuration (subdomain or custom domain)

### Does NOT cover (M15 boundaries)
- **M13 owns**: product catalog, inventory, order lifecycle (M15 displays M13 products)
- **M14 owns**: offer pricing logic, coupon rules, campaign coordination (M15 uses M14 offers)
- **M16 owns**: affiliate link attribution (M15 pages may contain affiliate links managed by M16)
- **M19 owns**: profit calculations from store transactions (M15 feeds data → M19 aggregates)
- Payment processing: Stripe handles transactions; M15 orchestrates checkout experience
- **S16 owns**: link-in-bio pages (separate from store pages, but can link TO store)

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Creator / Seller | Editor+ | Build store pages, configure themes, manage bundles, create membership plans |
| Manager | Manager+ | Publish store, configure domains, manage membership entitlements |
| Customer (external) | External | Browse store, purchase products/offers, subscribe to memberships |
| System (Publisher) | System | Generate store page URLs, manage SSL, sync product availability |
| System (Analytics) | System | Track store page views, conversion funnel, revenue per page |

## Business Rules

1. **RULE-M15-001**: A store page MUST only display offers that are in `lifecycle_state = 'active'` (M14). Expired, paused, or retired offers MUST NOT appear on published store pages. System auto-hides offers when their lifecycle state changes from active (PRD §23.15 AC).
2. **RULE-M15-002**: Product-less offers displayed on the store MUST have their `product_less_declaration` explicitly visible. The store page MUST show what the customer receives: for digital → access/download details; for community → community access details; for service → service description. No "buy now" without clear deliverable description (Pack 06 §2.3, RULE-M13-001).
3. **RULE-M15-003**: Membership lifecycle: `active → cancelled → expired` (for subscriber) and `draft → active → paused → retired` (for plan). Membership entitlements define what subscribers access (content, community, discounts, exclusive offers). `membership.subscribed` and `membership.cancelled` events feed M19 for recurring revenue tracking (Domain events §19).
4. **RULE-M15-004**: Store page publishing emits `store.page_published` event. Published pages are accessible via: `{store-slug}.creativanta.store/{page-slug}` (shared domain) or custom domain (Pro+ tier). HTTPS enforced. Page analytics activate on publish (Domain events §19).
5. **RULE-M15-005**: Bundle offers combine multiple products/offers into a single purchasable unit. Bundle pricing can be: fixed price, percentage discount, or custom logic. Each bundle component traces back to an M13 product or M14 offer. Inventory for bundles derived from component stock levels — if any component is out of stock, bundle is unavailable (PRD §12, Pack 06 §2.4).
6. **RULE-M15-006**: Store page theming respects workspace brand kit (brand colors, fonts, logos from M08 brand packs, if configured). Custom CSS is available for Pro+ tier. Theme changes preview before publish — no live-edit-and-break (PRD §23.15 AC).
7. **RULE-M15-007**: Every store transaction → order created in M13 → feeds M19 operating ledger. Payment processing via Stripe. Store is a self-owned channel alongside platform channels (TikTok Shop, Shopee). Revenue attribution: `source_platform = 'own_store'`, allowing creators to compare own-store vs marketplace performance (PRD §16).

## Main Flow

1. **Store setup**: Creator configures store
   - Store name, slug, branding, theme selection
   - Domain configuration: shared domain or custom domain
   - `StoreService/Setup` (Editor+)
2. **Page building**: Creator builds store pages
   - Page types: landing, product listing, product detail, collection, membership, custom
   - Drag-drop builder with sections: hero, product grid, offer cards, testimonials, CTA blocks
   - Each page references M13 products and M14 offers
3. **Offer placement**: Active offers (M14) selected for display
   - Only `lifecycle_state = 'active'` offers eligible
   - Product-less offers show explicit deliverable descriptions
   - Bundles assembled from product/offer components
4. **Store publishing**: Manager publishes store pages
   - Preview → publish → `store.page_published` event
   - Pages live at configured URL
   - Analytics tracking activated
5. **Customer interaction**: External users browse and purchase
   - Product browsing → add to cart → checkout (Stripe)
   - Order created in M13 with `source_platform = 'own_store'`
   - `order.imported` event → M19 financial tracking begins
6. **Membership subscription**: Customer subscribes to membership plan
   - `membership.subscribed` event → recurring revenue tracked in M19
   - Entitlements activated for subscriber
   - Renewal and cancellation handled automatically

## Alternate Flows

### A1: Bundle Component Out of Stock
- Trigger: Customer attempts to purchase bundle where one component is out of stock
- Steps: System checks component inventory → detects stock = 0 for component X → bundle marked as unavailable → customer sees "Temporarily unavailable — [Product X] out of stock" → operator notified via inventory alert
- Result: No overselling; clear customer communication; inventory alert to operator

### A2: Membership Cancellation with Active Period
- Trigger: Subscriber cancels mid-billing period
- Steps: `membership.cancelled` event fired → entitlements remain active until period end → no pro-rated refund by default (configurable policy) → at period end, access revoked. Subscriber can be flagged for win-back campaign.
- Result: Fair cancellation handling; M19 tracks cancellation for churn metrics

### A3: Store Page Linking from Link-in-Bio
- Trigger: Creator adds store page URL to their S16 Link-in-Bio page
- Steps: Store page URL added as link item in Link-in-Bio → clicks tracked via S16 analytics → conversion tracked when click leads to store purchase. Attribution: `link_in_bio → store → order` chain.
- Result: Cross-module attribution from creator profile to owned store to revenue

## Edge Cases

### EC-M15-001: Offer State Change After Page Cache
- Condition: Offer expires 5 minutes after customer loads store page (page cached)
- Expected behavior: Offer validity re-checked at checkout time. If expired: checkout blocked with "This offer is no longer available." Store page refreshes to remove expired offer. CDN cache invalidated on `offer.expired` event (webhook to CDN).
- Reference: RULE-M15-001

### EC-M15-002: Store Page with Zero Active Offers
- Condition: All offers on a store page are paused/expired
- Expected behavior: Page shows graceful empty state: "Products coming soon. [Notify me when available]" with email capture. Page is NOT auto-unpublished — operator decides. Dashboard warns: "Store page [X] has no active offers."
- Reference: RULE-M15-001

### EC-M15-003: Custom Domain SSL Provisioning Failure
- Condition: CNAME configured correctly but SSL cert provisioning fails
- Expected behavior: Store remains accessible on shared domain. Custom domain shows warning until SSL resolved. System retries SSL provisioning every 4 hours. Diagnostics show: "SSL certificate pending for [domain] — [Retry] [Use shared domain]."
- Reference: RULE-M15-004

### EC-M15-004: Membership Entitlement Sync Lag
- Condition: Customer subscribes but entitlements don't activate immediately
- Expected behavior: `membership.subscribed` event triggers entitlement activation. Maximum acceptable delay: 30 seconds. If delay > 30s: customer sees "Setting up your membership..." interstitial. If > 5 minutes: support ticket auto-created. Entitlement state is eventually consistent, not transactional.
- Reference: RULE-M15-003

## State Machine

### Offer Display Eligibility (M15 perspective)

M15 doesn't own offer lifecycle (M14 does) but M15 enforces display rules:

| Offer `lifecycle_state` | Store Page Display | Action |
|---|---|---|
| draft | Hidden | Cannot be added to page |
| review_required | Hidden | Cannot be added to page |
| active | Visible | Displayable with full purchase flow |
| paused | Hidden (auto) | Removed from published page on state change |
| expired | Hidden (auto) | Removed from published page on state change |
| retired | Hidden (permanent) | Removed, cannot be re-added |

### Membership Plan Lifecycle

| From | To | Trigger | Condition |
|---|---|---|---|
| — | draft | Plan created | Title + pricing + entitlements defined |
| draft | active | Manager publishes plan | Ready for subscribers |
| active | paused | Manager pauses | Temporarily unavailable |
| paused | active | Manager reactivates | Resume subscriptions |
| active | retired | Manager retires | Permanent deactivation, existing subscribers honored until period end |

### Membership Subscriber Lifecycle

| From | To | Trigger | Condition |
|---|---|---|---|
| — | active | Subscriber pays | Payment confirmed |
| active | cancelled | Subscriber cancels | Voluntary cancellation |
| active | expired | Payment fails | Dunning exhausted |
| cancelled | expired | Period ends | Access revoked |

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../../04_contracts/database_schema.md) | §10 (products, offers — referenced by M15), plus store_pages and memberships in operational context |
| API | [04_contracts/api_endpoint_map.md](../../04_contracts/api_endpoint_map.md) | §2.6 (StoreService, MembershipService — within Commerce ~30 RPCs) |
| Events | [04_contracts/domain_event_catalog.md](../../04_contracts/domain_event_catalog.md) | §8 (offer.activated, offer.expired → M15 display update), §19 (store.page_published, membership.subscribed, membership.cancelled) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../../04_contracts/rbac_permission_matrix.md) | §2.7 (store — Editor+; membership — Manager+) |
| Pack 06 | Pack 06 — Commerce Contract <!-- Legacy ref: creativanta_detail_design_pack_06_commerce_finance_proof_reporting_admin_contract_v_3_1.md — superseded by current feature docs + contract layer --> | §2.3 (Offer/Product-less), §2.4 (Monetization Support — bundles, memberships) |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Store builder | Drag-drop page builder with sections, theme customization, preview |
| Web | Store page manager | Page list with publish status, analytics summary |
| Web | Bundle builder | Visual bundle composition from products/offers |
| Web | Membership plan manager | Plan CRUD, entitlement editor, subscriber list |
| Web | Store analytics | Per-page metrics: views, conversion rate, revenue, traffic sources |
| Mobile | Store preview | Mobile-optimized preview of published store |
| Mobile | Order notifications | Real-time store order alerts |

## Acceptance Criteria

1. **Given** an offer with `lifecycle_state = 'active'` is placed on a store page, **when** the offer transitions to `'expired'`, **then** the store page MUST auto-hide the offer within 60 seconds — a customer attempting checkout for the expired offer MUST see "This offer is no longer available."

2. **Given** a product-less offer on the store page, **when** a customer views the offer, **then** the `product_less_declaration` type MUST be visible (digital/community/service) with a clear description of what the customer receives.

3. **Given** a store purchase is completed via Stripe, **when** the order is created in M13, **then** the order MUST have `source_platform = 'own_store'` AND `offer_id` linking to the M14 offer — the revenue MUST feed M19's operating ledger.

4. **Given** a bundle where one component product has 0 inventory, **when** the customer views the store, **then** the bundle MUST show as "Temporarily unavailable" with explanation — no partial checkout allowed for bundles.

5. **Given** a membership plan is published and a customer subscribes, **when** the `membership.subscribed` event fires, **then** the subscriber's entitlements MUST activate within 30 seconds AND M19 MUST begin tracking the recurring revenue with `source_platform = 'own_store'`.

## Open Questions / Blockers

- [NONE] — No critical blockers specific to M15 in OPEN_BLOCKERS.md. Store and membership endpoints within Commerce API map §2.6.
