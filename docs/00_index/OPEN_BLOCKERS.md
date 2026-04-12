---
layer: index
canonical: true
last_updated: 2026-04-11
---

# Open Blockers

> This is the **most critical file** after BUILD_INDEX.md. Every AI agent and developer MUST read this before starting implementation work.

---

## Current Documentation Blockers (Validated 2026-04-11)

> As of 2026-04-11 (independent re-audit), there are **no remaining internal documentation blockers** that prevent an AI coding agent from using this corpus as the implementation source of truth. Fixes applied in this audit round: gamification event gaps (streak.milestone, streak.frozen, challenge.completed, challenge.expired added), Dragonfly keyspace notification config documented, web bundle target corrected (50KB→120KB), Flutter unit tests added to CI, CI smoke test improved, OWASP year corrected, event catalog cross-reference deduplication (§16.2→§12), outbox poller SQLx exception noted, AP_EXECUTION_MODE security warning added.

## Deferred Implementation Artifacts / External Gates

> The items in this section remain important, but they are **not documentation-readiness blockers** for the current docs-only scope.

## PROTO-C-001: No committed `.proto` files or generated transport artifacts

- Layer: Contracts / Build
- Severity: **CRITICAL**
- Status: **DEFERRED (docs-only scope)**
- Impact: `protobuf_contracts.md` remains a transport/codegen overview. Typed client/server generation from committed `.proto` files is deferred until the implementation phase that introduces repository-native transport codegen.
- Evidence: repository search for `*.proto` returned 0 files on 2026-04-07.
- Owner: API Lead

## LEG-H-001: Launch remains gated on legal sign-off

- Layer: Business / Compliance
- Severity: **HIGH**
- Status: **EXTERNAL_GATE**
- Impact: `legal_compliance.md` is engineering-approved and explicitly states that engineering implementation may proceed under approved defaults. Final legal sign-off remains a launch gate, not a blocker for documentation completeness.
- Owner: Legal + Product

## SCR-H-003: Screen corpus cleanup and role canonicalization

- Layer: Screens
- Severity: **HIGH**
- Status: **RESOLVED** (2026-04-09)
- Impact: screen corpus previously mixed canonical screens with template-derived placeholders and non-canonical admin role aliases.
- Resolution: Canonical admin role aliases were removed from active screen specs, high-risk commerce/admin screens were rebound to canonical schema/API services, and `SCREEN_IMPLEMENTATION_PROTOCOL.md` now centrally governs any residual historical shorthand. Remaining `template`/`placeholder` strings in active screens are revision-history notes or normal loading/UI copy, not implementation-bearing data-binding instructions.
- Verified: repository search for non-canonical admin aliases in `docs/` now returns only control docs plus `SCREEN_IMPLEMENTATION_PROTOCOL.md`.
- Owner: Screen Doc Lead

## RBAC-H-001: Missing RBAC permission keys and auth-level conflicts

- Layer: Contracts / Security
- Severity: **HIGH**
- Status: **RESOLVED** (2026-04-10)
- Impact: `campaign:read` and `coupon:read` permission keys were referenced by API endpoints but missing from `rbac_permission_matrix.md`. Additionally, `offer:manage` and `product:manage` had conflicting auth levels between RBAC matrix (Editor+) and API endpoint map (Manager+/Admin+ for some operations).
- Resolution: Added `campaign:read` (Viewer+) and `coupon:read` (Viewer+) permission keys. Split `offer:manage` into granular operations with `offer:activate` at Manager+ and `offer:manage` at Editor+ for CRUD. Added `product:delete` at Admin+ and `product:import` at Manager+ alongside `product:manage` at Editor+. Reconciled all auth levels between RBAC matrix and API endpoint map.
- Verified: All permission keys referenced in API endpoint map now exist in RBAC matrix.
- Owner: API Lead

## EVT-H-002: Domain event catalog duplicate definitions and naming collisions

- Layer: Contracts
- Severity: **HIGH**
- Status: **RESOLVED** (2026-04-10)
- Impact: `workflow_run.approval_required` was defined twice (§11 and §16.4) with incompatible payload schemas. `credit.exhausted` (§16.2) and `credits.exhausted` (§12) used inconsistent singular/plural naming with different payloads.
- Resolution: Merged `workflow_run.approval_required` into a single canonical definition with combined payload `{run_id, workflow_id, step_name, action, approver_ids[]}`. Unified to `credits.exhausted` (plural, §12 format) as canonical; removed singular `credit.exhausted` from §16.2 and replaced with cross-reference.
- Verified: `grep 'credit\.exhausted' domain_event_catalog.md` returns 0 matches (only `credits.exhausted`).
- Owner: Backend Lead

## BIZ-H-001: Brand Deal lifecycle contradiction between M16 and S16

- Layer: Features / Screens
- Severity: **HIGH**
- Status: **RESOLVED** (2026-04-10)
- Impact: M16 (affiliate_network.md) defined a 6-state Brand Deal lifecycle, while S16 (screen_web_creator_brand_deals.md) defined 7+1 states. This created an implementation conflict for the commerce domain.
- Resolution: Designated M16's 6-state machine as canonical (negotiating→agreed→in_progress→delivered→paid→completed + cancelled). Updated S16 screen to adopt M16's lifecycle. S16's extra `disputed` state mapped to a sub-state of `delivered` (dispute resolution flow before payment). S16's `inquiry` maps to pre-Brand Deal CRM thread, not a deal state.
- Verified: Both M16 and S16 now reference the same 6+1 state machine.
- Owner: Product

## DOC-M-003: Sequence diagram credit deduction inconsistency

- Layer: System
- Severity: **HIGH**
- Status: **RESOLVED** (2026-04-10)
- Impact: §9 in `sequence_diagrams.md` used an immediate credit deduction pattern, contradicting §11's canonical escrow/two-phase pattern.
- Resolution: Updated §9 to use the reserve→execute→commit escrow pattern matching §11's canonical flow. Added explicit cross-reference to §11.
- Verified: §9 now uses `reserve()` before execution and `commit()` after, matching §11.
- Owner: Backend Lead

## DOC-M-004: Legal compliance data retention contradiction

- Layer: Business / Compliance
- Severity: **HIGH**
- Status: **RESOLVED** (2026-04-10)
- Impact: `legal_compliance.md` §3 stated "Purge 30 days" for data retention, contradicting BIZ-010's canonical 3-phase policy (0-30 read-only, 30-90 soft delete, 90+ hard delete).
- Resolution: Updated `legal_compliance.md` §3 retention table to match BIZ-010's 3-phase policy. Added cross-reference to `business_rules.md` BIZ-010.
- Verified: Retention table now shows 3-phase retention matching BIZ-010.
- Owner: Legal + Product

## ERR-M-002: Error catalog domain expansion

- Layer: Contracts
- Severity: **MEDIUM**
- Status: **RESOLVED** (2026-04-10 — expanded)
- Impact: canonical error coverage previously omitted CONTENT, ENGAGEMENT, FINANCE, LIVE, SEEDING, CREATOR_PRO, and ADMIN domains (fixed 2026-04-09). Second audit (2026-04-10) found INTELLIGENCE, CONNECTOR, NOTIFICATION, and GAMIFICATION domains still missing.
- Resolution (pass 1, 2026-04-09): Added CONTENT_*, ENGAGEMENT_*, FINANCE_*, LIVE_*, SEEDING_*, CREATOR_PRO_*, ADMIN_* sections.
- Resolution (pass 2, 2026-04-10): Added INTELLIGENCE_*, CONNECTOR_*, NOTIFICATION_*, GAMIFICATION_* sections with Vietnamese user messages.
- Verified: `error_catalog.md` now contains canonical sections for all 18 active domains.
- Owner: API Lead

## ANA-M-001: Analytics taxonomy module coverage

- Layer: Quality / Ops
- Severity: **MEDIUM**
- Status: **RESOLVED** (2026-04-09)
- Impact: analytics taxonomy previously defined only a seed set and did not provide module-complete instrumentation guidance.
- Resolution: `analytics_event_taxonomy.md` now defines required common properties, a minimum module coverage matrix across all active modules/specs, and governance rules for screen-level analytics extensions.
- Verified: `analytics_event_taxonomy.md` includes `Minimum Module Coverage Matrix` and `Governance Rules` sections.
- Owner: Product Analytics

## OPS-M-002: CI/CD canonicalization and ClickHouse rollout

- Layer: Quality / Ops
- Severity: **MEDIUM**
- Status: **RESOLVED** (2026-04-09)
- Impact: CI/CD doc previously implied missing script files were required and omitted ClickHouse rollout order.
- Resolution: `ci_cd_pipeline.md` now uses canonical inline pipeline stages (`Contract Sync`, `Migrate`), removes hard dependency on missing wrapper scripts, and adds explicit ClickHouse deployment ordering as part of the migration stage.
- Verified: `ci_cd_pipeline.md` now contains `Contract Sync` and `ClickHouse Deployment Order` sections and no longer requires missing wrapper scripts as the canonical path.
- Owner: DevOps / Platform

---

## DB-C-001: FORCE ROW LEVEL SECURITY missing from ALL table DDL

- Layer: DB
- Severity: **CRITICAL**
- Status: **RESOLVED** (2026-04-02)
- Impact: `FORCE ROW LEVEL SECURITY` previously appeared **0 times** in schema.
- Resolution: Added `ALTER TABLE <t> ENABLE ROW LEVEL SECURITY;` + `ALTER TABLE <t> FORCE ROW LEVEL SECURITY;` + `CREATE POLICY tenant_isolation` to **106 tenant-scoped tables** in `database_schema.md`. Global tables (users, regions, currencies, internal_admins) and junction tables (trend_signals, etc.) correctly excluded.
- Verified: `grep -c 'FORCE ROW LEVEL SECURITY' database_schema.md` = 106
- Owner: Backend Lead

## BIZ-C-001: Subscription tier prices and add-on prices are not approved

- Layer: Business
- Severity: **CRITICAL**
- Status: **RESOLVED** (2026-04-07)
- Impact: `pricing_and_credits.md` previously defined limits and credit-pack prices but not recurring subscription prices or add-on SKU prices.
- Resolution: Canonicalized launch-default USD and VND pricebooks for Free/Starter/Pro/Business, annual prices, and 4 add-on SKU prices in `pricing_and_credits.md`. Billing docs now explicitly treat catalog values as config-driven defaults, not hardcoded UI constants.
- Owner: Product + Finance

## MOD-H-001: Moderation scoring thresholds are not canonicalized

- Layer: Quality / Ops
- Severity: **HIGH**
- Status: **RESOLVED** (2026-04-07)
- Impact: moderation flow existed, but numeric allow/review/block thresholds were missing from canonical docs.
- Resolution: `moderation_rules_engine.md` now defines normalized 0-100 allow/review/block bands, category-specific overrides, hard-block categories, and escalation timing aligned to S26. The admin moderation rules screen now reflects the canonical policy instead of draft thresholds.
- Owner: Trust & Safety

## BIZ-M-001: Operator mode contract is partial

- Layer: Business
- Severity: **MEDIUM**
- Status: **RESOLVED** (2026-04-07)
- Impact: `user_segments_and_modes.md` previously required 8 fields per mode but only defined 3, leaving mode-aware Home and Brief behavior under-specified.
- Resolution: All 6 operator modes now define the full 8-field contract, including navigation emphasis, Daily Brief logic, terminology, recommended recipes, and alert priorities.
- Owner: Product

## DB-C-002: ENABLE ROW LEVEL SECURITY is template-only, not applied per-table

- Layer: DB
- Severity: **CRITICAL**
- Status: **RESOLVED** (2026-04-02)
- Impact: Previously only in §1 template, not per-table.
- Resolution: 106 individual `ENABLE ROW LEVEL SECURITY` statements now present in schema, one per tenant-scoped table. Each includes the full triple: ENABLE + FORCE + tenant_isolation policy.
- Verified: `grep -c 'ENABLE ROW LEVEL SECURITY' database_schema.md` = 106 (excluding template)
- Owner: Backend Lead

## DB-H-001: REAL/DECIMAL type used for credit/cost/score fields — 31+38 occurrences

- Layer: DB
- Severity: **HIGH**
- Status: **RESOLVED** (2026-04-10 — second pass)
- Impact: Originally 31 `REAL` fields for financial data (fixed in prior session). Second audit (2026-04-10) discovered 38 additional `DECIMAL(15,2)`, `DECIMAL(5,2)`, `DECIMAL(10,2)`, `DECIMAL(10,6)`, and `DECIMAL(5,4)` fields across ~25 commerce/finance tables that were missed in the first pass.
- Resolution (pass 1): All `REAL` financial fields converted to `NUMERIC(18,6)`. Non-financial scores retained as `REAL` with explicit `-- 0-100 non-financial score` comments.
- Resolution (pass 2, 2026-04-10): All remaining `DECIMAL(15,2)` → `NUMERIC(18,6)`, `DECIMAL(5,2)` → `NUMERIC(5,2)`, `DECIMAL(10,6)` → `NUMERIC(10,6)`, `DECIMAL(5,4)` → `NUMERIC(5,4)`, `DECIMAL(10,2)` → `NUMERIC(18,6)`. Zero `DECIMAL` fields remain in schema.
- Additionally fixed: `recipe_templates` missing `workspace_id` column (RLS policy referenced non-existent column); duplicate tables `skus` and `commissions` marked DEPRECATED in favor of `product_skus` (§10.1B) and `affiliate_commissions` (§10.4B).
- Verified: `grep DECIMAL database_schema.md` returns 0 matches. `grep 'workspace_id' recipe_templates` section confirms column added.
- Owner: Backend Lead

## DB-H-003: deleted_at missing from production tables

- Layer: DB
- Severity: **HIGH**
- Status: **RESOLVED** (2026-04-02)
- Impact: Previously only 2 `deleted_at` columns in schema.
- Resolution: Added `deleted_at TIMESTAMPTZ` to **51 production entity tables** including: ideas, scripts, assets, asset_briefs, characters, continuity_packs, offers, products, orders, campaigns, affiliate_links, publish_items, threads, entities, follow_up_tasks, workflows, recipes, store_pages, membership_plans, live_sessions, brand_deals, rate_cards, media_kits, link_in_bio_pages, and all extended production tables (video_edit_jobs, remix_blueprints, clip_collections, etc.).
- Verified: `grep -c 'deleted_at TIMESTAMPTZ' database_schema.md` = 52 (51 new + 1 original on workspaces)
- Owner: Backend Lead

## DB-H-004: CHECK constraints missing for status/state fields

- Layer: DB
- Severity: **HIGH**
- Status: **RESOLVED** (2026-04-02)
- Impact: Previously 0 `CHECK` constraints in schema.
- Resolution: Added **23 CHECK constraints** for lifecycle/status fields on critical tables: assets (generation_state, quality_state), scripts (lifecycle_state, approval_state), publish_items (lifecycle_state), publish_jobs (lifecycle_state), opportunities (priority_state), threads (status), orders (lifecycle_state), offers (lifecycle_state), workflows (status), workflow_runs (status), campaigns (status), generation_jobs (status), agent_runs (current_state), live_sessions (status), signals (lifecycle_state), refunds (lifecycle_state), returns (lifecycle_state), coupons (lifecycle_state), video_edit_jobs (status), sample_requests (status), sample_shipments (status).
- Verified: `grep -c 'ADD CONSTRAINT chk_' database_schema.md` = 23
- Owner: Backend Lead

## API-C-001: PerformanceCoachService has no endpoint/proto definition

- Layer: API
- Severity: **CRITICAL**
- Status: **RESOLVED** (2026-04-02)
- Impact: Previously zero proto/RPC definition.
- Resolution: Defined `PerformanceCoachService` in `api_endpoint_map.md` §2.8.8 with 5 RPCs: `GetInsights`, `GetVideoScorecard`, `GetImprovementPlan`, `ListBenchmarks`, `CompareToIndustry`.
- Owner: API Lead

## API-H-001: VoiceCloneService missing, event namespace incorrect

- Layer: API
- Severity: **HIGH**
- Status: **RESOLVED** (2026-04-02)
- Impact: Previously no service definition.
- Resolution: Defined `VoiceCloneService` in `api_endpoint_map.md` §2.8.9 with 6 RPCs: `Create`, `Get`, `List`, `Delete`, `GenerateVoiceover`, `GetConsentStatus`. Event naming convention remains open (see EVT-H-001).
- Owner: API Lead

## API-H-002: SoundStudioService missing

- Layer: API
- Severity: **HIGH**
- Status: **RESOLVED** (2026-04-02)
- Impact: Previously no proto/endpoint definition.
- Resolution: Defined `SoundStudioService` in `api_endpoint_map.md` §2.8.10 with 6 RPCs: `GenerateMusic`, `GenerateSFX`, `AnalyzeBeat`, `ListSoundLibrary`, `GetSound`, `PreviewSound`.
- Owner: API Lead

## API-M-001: M17/M18/M20/M21 lack detailed RPC tables

- Layer: API
- Severity: **HIGH**
- Status: **RESOLVED** (2026-04-02)
- Impact: Previously grouped/summary notation with no per-endpoint detail.
- Resolution: Fully expanded `api_endpoint_map.md` §2.6-§2.8 from ~6 grouped rows to **155 individual RPC definitions** across: ProductService (8), OfferService (9), OrderService (5), CampaignService (7), AffiliateService (6), StoreService (5), CouponService (6), ProfitService (5), SettlementService (3), CostService (4), ReconciliationService (5), EvidenceService (3), ProofService (3), RefundService (3), WorkflowService (13), RecipeService (8), LiveCommerceService (11), SeedingService (9), CopilotService (5), AdminBillingService (14), CapabilityService (5), PerformanceCoachService (5), VoiceCloneService (6), SoundStudioService (6), ReferralService (5), PromotionalService (3), NotificationService (5). Each RPC row includes: Method, Auth, Rate Limit, Description.
- Owner: API Lead

## API-M-002: API endpoint map lacks request/response examples and failure contracts

- Layer: API
- Severity: **HIGH**
- Status: **RESOLVED** (2026-04-02)
- Impact: Previously no request/response examples existed.
- Resolution: Created `04_contracts/api_examples.md` companion file with **24 concrete JSON request/response examples** covering: Auth, Trends, Scripts, Generation (including SSE streaming), Publish, Threads, Products, Orders, Offers, Coupons, Profit, Reconciliation, Workflows, LiveCommerce, Seeding, Credits, Admin, Capability, Referral, VoiceClone, Error responses (400/403/429), and Pagination conventions. All field names derived from `database_schema.md`. Money fields use string NUMERIC(18,6). UUIDs use v7.
- Verified: `wc -l api_examples.md` > 500 lines, 24 example sections
- Owner: API Lead

## PRD-H-001: Acceptance criteria not in Given/When/Then format

- Layer: PRD
- Severity: **HIGH**
- Status: PARTIALLY RESOLVED
- Impact: PRD §23 module ACs are prose-based. However, `06_quality_ops/qa_acceptance_packs.md` now covers structured acceptance tests.
- Note: Feature docs (02_features/) now generally include Given/When/Then format ACs. PRD itself remains as-is (product contract level). Remaining gap: some edge cases in feature docs could be more structured.
- Owner: QA Lead

## PRD-H-002: Edge cases documentation incomplete

- Layer: PRD
- Severity: **MEDIUM** (downgraded from HIGH — 2026-04-01)
- Status: **RESOLVED** (2026-04-02)
- Impact: Most feature docs now include edge case sections. Previously missing Edge Cases section in `reporting_admin_billing.md` has been added (EC-M23-001 through EC-M23-006).
- Resolution: All feature docs now have explicit Edge Cases sections. `reporting_admin_billing.md` has 6 edge cases covering payment method removal, account deletion, concurrent impersonation, override frequency alerts, audit log integrity, and SLA during maintenance.
- Owner: Product Lead

## EVT-H-001: Event naming convention inconsistency (dot.notation vs CamelCase)

- Layer: System
- Severity: **HIGH**
- Status: **RESOLVED** (2026-04-02)
- Impact: `domain_event_catalog.md` uses dot.notation; `runtime_workflow.md` used CamelCase.
- Resolution: Added complete CamelCase→dot.notation mapping tables to `runtime_workflow.md`:
  - §3.1B: 50-row mapping (core events including production, publish, engagement, workflow, commerce)
  - §3.1C: 24-row mapping (extended production + gamification events)
  - Total: **74 CamelCase events** fully mapped to canonical dot.notation
- Canonical convention: **dot.notation** (`domain.entity.action`) for all Rust code. CamelCase retained in docs only.
- Owner: Backend Lead

## ERR-M-001: No unified error catalog

- Layer: API
- Severity: **HIGH**
- Status: **RESOLVED** (2026-04-02)
- Impact: Previously no centralized error code registry.
- Resolution: `error_catalog.md` created (2026-04-01) with 30+ error codes across 7 domains (AUTH, BILLING, AI, COMMERCE, PUBLISH, WORKFLOW, SYSTEM). Includes gRPC↔HTTP mapping, retry policies, bilingual user messages. Promoted from DRAFT → READY on 2026-04-02.
- Verified: Registered in CANONICAL_SOURCES.md, referenced from api_examples.md §A.23
- Owner: API Lead

## API-M-002b: ReferralService + PromotionalService not in API endpoint map

- Layer: API
- Severity: **MEDIUM**
- Status: **RESOLVED** (2026-04-02)
- Impact: Previously grouped under vague "Admin/Billing ~15 RPCs".
- Resolution: Defined `ReferralService` (5 RPCs) in `api_endpoint_map.md` §2.8.11 and `PromotionalService` (3 RPCs) in §2.8.12 with full Method, Auth, Rate Limit, Description columns.
- Owner: API Lead

## EVT-M-001: connector.degraded + connector.recovered not in event catalog

- Layer: Events
- Severity: **MEDIUM**
- Status: **RESOLVED** (2026-04-02)
- Impact: Previously missing from domain_event_catalog.md.
- Resolution: Added `connector.degraded` and `connector.recovered` events to `domain_event_catalog.md` §15D with full payloads: `{platform, degraded_features[], overall_score, reason, detected_at}` and `{platform, recovered_features[], overall_score, downtime_minutes, recovered_at}`.
- Verified: `grep 'connector.degraded' domain_event_catalog.md` = 1 match
- Owner: Backend Lead

## SCR-M-002: Screen docs reference phantom credit_ledger table

- Layer: Screens
- Severity: **LOW**
- Status: **RESOLVED** (2026-04-02)
- Impact: Originally ~12 references across 7 screen files.
- Resolution: Replaced all `credit_ledger` references with canonical `ai_credit_transactions` terminology and service projections. Files updated: screen_web_studio_queue, screen_web_home_dashboard, screen_web_capability_matrix, screen_web_studio_launcher, screen_mobile_studio_launcher, screen_mobile_home_dashboard, screen_mobile_billing.
- Verified: `grep -r 'credit_ledger' docs/03_screens/` = 0 matches
- Owner: Screen Doc Lead


## ~~API-C-002~~: ✅ RESOLVED — Screen→API RPC gap fully closed

- Layer: API / Screens
- Severity: ~~**HIGH**~~ → **RESOLVED**
- Status: **✅ RESOLVED** (2026-04-06)
- Resolution: API inventory work promoted a large screen-referenced RPC set into `api_endpoint_map.md` §10-§20 with method, auth level, rate limit, and description.
- Verified: Python gap analysis script confirms 0 remaining missing RPCs.
- `screen_api_reconciliation.md` status updated from WORKING_ANALYSIS → RESOLVED.
- Caveat (2026-04-09): do NOT treat this as proof that all screen docs are semantically perfect in every historical note. Canonical API coverage and screen semantic quality are separate concerns; any residual shorthand must be resolved through `SCREEN_IMPLEMENTATION_PROTOCOL.md`, not implemented literally.
- Cross-ref: `api_endpoint_map.md` §10-§20, `screen_api_reconciliation.md` (RESOLVED), CROSS_LAYER_MATRIX.md
- Owner: Product + API Lead


---

## Resolved Blockers

> Move entries here when fixed. Record: date, PR/commit, verified by.

### SCR-M-001: Screen specs migrated to docs/03_screens/ ✅

- Original: Screen specs in flat `docs/screens/` not mapped to `docs/03_screens/`
- Resolution: All screen files now consolidated in `docs/03_screens/` with proper subdirectory structure (web/, mobile/, admin/, shared/). Current canonical count: 243 files after S26 completion on 2026-04-06.
- Resolved: 2026-03-31
- Verified: filesystem audit + SCREEN_INDEX.md update

### DOC-M-001: Feature docs created for orphaned domains ✅

- Original: Several domains lacked feature docs (gamification, capability matrix, live commerce, seeding CRM sessions)
- Resolution: Feature docs created in `02_features/` for all 23 modules + auth. Domain event catalog, QA acceptance packs, and notification templates also created.
- Resolved: 2026-03-30
- Verified: file existence check across 02_features/

### DOC-M-002: Seed data, runbook, CI/CD docs added ✅

- Original: Missing operational docs for dev environment setup
- Resolution: Added `docker_dev_environment.md`, `data_migration_strategy.md`, QA packs, and operational docs to `06_quality_ops/`.
- Resolved: 2026-03-30
- Verified: CANONICAL_SOURCES.md references
