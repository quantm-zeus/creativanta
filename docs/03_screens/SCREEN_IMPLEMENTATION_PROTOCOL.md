---
layer: screens
canonical: true
last_updated: 2026-04-09
---

# Screen Implementation Protocol

This file defines how an engineer or AI coding agent must use `docs/03_screens/` safely when building UI surfaces.

## 1. Source Precedence

Use this order whenever a screen spec and another layer differ:

1. `docs/04_contracts/` for exact schema, DTO, RPC, event, permission and numerical semantics
2. `docs/02_features/` for business behavior and acceptance, using those exact contracts
3. `docs/05_system/` for async behavior, retries, queues, provider routing, real-time flows
4. `docs/03_screens/` for route, layout, UX states, entry/exit points, CTA placement, copy

If a screen doc conflicts with a feature or contract doc, the screen doc loses.

## 2. What Screen Docs Own

Screen docs are authoritative for:
- Route and navigation entry/exit points
- Page composition and major regions
- Which UI states must render distinctly
- CTA placement and interaction sequencing
- Platform-specific layout differences
- Localization tone and design-token intent

Screen docs are not authoritative for:
- Database table names
- Field names
- RPC names
- Event names
- RBAC token names
- Derived business computations

## 2A. Executable action and phase contract

[RPC bindings](../04_contracts/rpc_permission_bindings.csv) owns each RPC's permission/family; [API behavior](../04_contracts/api_behavior_contracts.md) owns transport and command semantics. A screen's role grid cannot grant more access. For every action, build its rendered permission state from the binding AND underlying object permission, tier, phase availability, approval and provider capability. A mismatch must be corrected before the slice UI is accepted. Use the owning P0–P8 phase; no unbuilt action is enabled or represented by fake success.

Credit/pricing quantities in wireframes are illustrative. Fetch a live cost-based quote and durable balance before confirming AI action; do not implement historical ranges as prices. Billing mutations are Owner-only. Impersonation is read-only for every admin role.

## 3. Data-Binding Rule

Treat a screen data-binding row as canonical only if every referenced object exists verbatim in:
- `database_schema.md`
- `api_endpoint_map.md`
- `rbac_permission_matrix.md`

If not, the screen line is an implementation hint only and must be resolved to the canonical contract before coding.

## 3A. Boilerplate Template Markers

Some legacy screen files still contain generic scaffold markers from the screen template system. The following exact markers are non-authoritative and MUST NEVER be implemented literally:
- `[Items per wireframe]`
- `Backend table`
- `Backend query`
- `Aggregation`
- `Service/Get`
- `Service/List(page)`
- `Service/GetStats`
- `UnknownPage`

When these markers appear, resolve the actual composition, data source, and API calls from the owning feature doc plus the canonical contract layer.

## 4. Legacy Alias Policy

Many legacy screen files contain conceptual aliases in upstream notes or data-binding tables. These aliases are allowed as explanatory shorthand and must not be implemented literally if they do not exist in the contract layer.

Common examples:
- `tickets` → use `support_tickets`
- `ticket_messages` → use `support_ticket_messages`
- `credit_transactions` → use `ai_credit_transactions`
- `credit_pools` → use the operational credit-pool projection returned by `AdminCreditService/GetPoolStatus`
- `credit_allocations` → use the plan-allocation projection returned by `AdminCreditService/GetPlanAllocations`
- `credit_balances` → use `CreditService/GetBalance` or `workspaces.ai_credits_remaining`
- `credit_purchases` → use `BillingService/ListCreditPurchases` plus `billing_events` / `ai_credit_transactions`
- `subscription_plans` → use `subscriptions.plan_tier` plus `BillingService/GetCurrentPlan` / `BillingService/ListPlans`
- `credit_packages` → use `BillingService/ListCreditPackages`
- `workspace_usage` → use `UsageService/GetStorageUsage` / `UsageService/GetBreakdown`
- `dashboards` → use `home_dashboard_config` plus the canonical Home API projections
- `alerts` → use `notifications`, `diagnostics_records`, or `system_alerts` based on feature context
- `connectors` / `platform_connections` → use `connected_accounts`
- `publish_jobs` → use `publish_items` plus `publish_logs`
- `studio_jobs` → use `generation_jobs`, `video_edit_jobs`, `repurpose_jobs`, or the job-specific production table named in contracts
- `studio_assets` → use `assets`
- `coupon_usage` → use `coupons.current_uses`, `coupons.max_uses`, or coupon redemption projections returned by `CouponService`
- `offer_products` → use `offers.product_id` or `offers.product_less_declaration`
- `campaign_products` → use `campaigns.related_product_ids` or the campaign-product projection returned by `CampaignService`
- `campaign_offers` → use `campaigns.related_offer_ids` or `CampaignService/GetLinkedOffers`
- `campaign_content` → use `CampaignService/GetLinkedContent`; do not invent a relational table if none is canonically defined
- `campaign_costs` → use `cost_items` with `related_scope_type = 'campaign'` and `related_scope_id = campaign_id`, exposed via `CampaignService/GetCosts`
- `workflow_steps` / `workflow_step_outputs` → use `workflow_run_steps`
- `agent_executions` → use `agent_runs`
- `agent_steps` → use `agent_run_steps`
- `brand_deal_deliverables` → use the deliverables projection returned by `BrandDealService/ListPartnerships`; the canonical root object remains `brand_deals`
- `published_posts` → use canonical publish/channel-post objects exposed by API contracts
- `service_health` → use `diagnostics_records`, `platform_health_metrics`, `system_alerts`, or the service-level health projection defined by API/system docs
- `ai_providers` / `ai_routing` → use `AdminAIService` projections; do not infer standalone admin tables unless the schema defines them

Legacy role labels follow the same rule:
- `Ops Admin` → use canonical `ops_admin`
- `Comms Admin` → use canonical `ops_admin`
- `Analytics Admin` → resolve to the service-authorized canonical roles; for finance-heavy business analytics screens this is typically `super_admin` / `finance_admin`
- `AI Admin` → resolve by service auth: `tech_admin` for `AdminAIService`, `finance_admin` for `AdminCreditService`
- `Read Only` → resolve to `analyst` or `auditor` based on the screen's read scope
- `Trust Safety` / `ContentMod` → use canonical `content_admin`

If an alias is not covered above, resolve it via feature intent + API contract, not by inventing a new table.

## 5. Shared UI Fallback Rules

If a screen omits a specific state or behavior, use shared specs in this order:
- Loading: `screen_shared_loading_states.md`
- Empty: `screen_shared_empty_states.md`
- Error: `screen_shared_error_states.md`
- Confirm destructive actions: `screen_shared_confirmations.md`
- Trust/proof display: `screen_shared_trust_badge.md`
- Navigation shell: `screen_shared_app_shell.md`, `screen_shared_navigation.md`, `screen_shared_mobile_nav.md`

## 6. AI Build Algorithm

For each screen:

1. Read the owning feature doc.
2. Extract the canonical actions, validations, roles, and state transitions.
3. Read the relevant API/schema/RBAC contracts.
4. Read the screen doc for layout and UX specifics.
5. Replace any non-canonical aliases with canonical contract objects before implementation.
6. Pull missing shared states from the shared screen docs.
7. If a conflict remains after step 6, create a `[CONFLICT]` note and stop for human confirmation.

## 7. Completion Gate

A screen is implementation-ready when all of the following are true:
- Route is explicit
- Entry/exit points are explicit
- Required UI states are explicit
- All user actions map to canonical RPCs or local-only interactions
- Permissions map to canonical RBAC tokens or canonical admin-role matrix
- Any boilerplate template markers are ignored per §3A
- Any legacy aliases have been resolved to contract-layer objects before coding

This protocol makes legacy screen shorthand safe by forcing resolution through the canonical contract layer before implementation.
