---
layer: index
canonical: true
last_updated: 2026-04-07
---

# Open Blockers

> This is the **most critical file** after BUILD_INDEX.md. Every AI agent and developer MUST read this before starting implementation work.

---

## Current Open Blockers (Validated 2026-04-07)

> Historical resolved entries remain below. The items in this section are still OPEN or PARTIAL and must not be silently worked around.

## PROTO-C-001: No committed `.proto` files or generated transport artifacts

- Layer: Contracts / Build
- Severity: **CRITICAL**
- Status: **OPEN**
- Impact: `protobuf_contracts.md` is still an overview only. Typed client/server code generation cannot start from committed `.proto` files because none exist in the repo.
- Evidence: repository search for `*.proto` returned 0 files on 2026-04-07.
- Owner: API Lead

## BIZ-C-001: Subscription tier prices and add-on prices are not approved

- Layer: Business
- Severity: **CRITICAL**
- Status: **OPEN**
- Impact: `pricing_and_credits.md` defines limits and credit-pack prices, but not the recurring subscription prices or add-on SKU prices. Billing/paywall implementation cannot be finalized without human confirmation.
- Owner: Product + Finance

## SCR-H-003: Screen corpus still contains widespread template contamination and stale admin role aliases

- Layer: Screens
- Severity: **HIGH**
- Status: **OPEN**
- Impact: screen inventory still shows ~140 files with unresolved template markers / generic data-binding placeholders. Several admin screens also still use non-canonical role labels (`Ops Admin`, `AI Admin`, `Trust Safety`, `Read Only`, etc.) instead of the canonical 8-role admin matrix.
- Owner: Screen Doc Lead

## LEG-H-001: Launch remains gated on legal sign-off

- Layer: Business / Compliance
- Severity: **HIGH**
- Status: **OPEN**
- Impact: `legal_compliance.md` is engineering-approved but explicitly launch-gated pending legal sign-off. This is not a coding blocker for all modules, but it remains a release blocker.
- Owner: Legal + Product

## MOD-H-001: Moderation scoring thresholds are not canonicalized

- Layer: Quality / Ops
- Severity: **HIGH**
- Status: **OPEN**
- Impact: moderation flow exists, but numeric allow/review/block thresholds are still missing from canonical docs. Admin moderation tooling and automated moderation rules cannot be finalized safely.
- Owner: Trust & Safety

## BIZ-M-001: Operator mode contract is partial

- Layer: Business
- Severity: **MEDIUM**
- Status: **OPEN**
- Impact: `user_segments_and_modes.md` requires 8 fields per mode, but only 3 are currently defined. Home/dashboard personalization and mode-specific UX prioritization remain under-specified.
- Owner: Product

## ERR-M-002: Error catalog coverage is incomplete

- Layer: Contracts
- Severity: **MEDIUM**
- Status: **OPEN**
- Impact: canonical error coverage exists for AUTH, BILLING, AI, COMMERCE, PUBLISH, WORKFLOW, and SYSTEM only. CONTENT, ENGAGEMENT, FINANCE, LIVE, SEEDING, CREATOR_PRO, and broader ADMIN coverage remain undefined.
- Owner: API Lead

## ANA-M-001: Analytics taxonomy is still a seed set, not full module coverage

- Layer: Quality / Ops
- Severity: **MEDIUM**
- Status: **OPEN**
- Impact: current analytics taxonomy is too sparse for full product analytics instrumentation across 23 modules.
- Owner: Product Analytics

## OPS-M-002: CI/CD documentation references missing scripts and omits ClickHouse deployment

- Layer: Quality / Ops
- Severity: **MEDIUM**
- Status: **OPEN**
- Impact: `ci_cd_pipeline.md` references `./tooling/proto-gen.sh`, `./scripts/deploy.sh`, and `./scripts/smoke-test.sh`, but none of those files are committed in the repo as of 2026-04-07. The same pipeline doc also does not define how ClickHouse DDL is deployed, despite ClickHouse remaining part of the canonical runtime stack.
- Evidence: repository checks on 2026-04-07 found all 3 script paths missing; `ci_cd_pipeline.md` contains no ClickHouse deployment step.
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

## DB-C-002: ENABLE ROW LEVEL SECURITY is template-only, not applied per-table

- Layer: DB
- Severity: **CRITICAL**
- Status: **RESOLVED** (2026-04-02)
- Impact: Previously only in §1 template, not per-table.
- Resolution: 106 individual `ENABLE ROW LEVEL SECURITY` statements now present in schema, one per tenant-scoped table. Each includes the full triple: ENABLE + FORCE + tenant_isolation policy.
- Verified: `grep -c 'ENABLE ROW LEVEL SECURITY' database_schema.md` = 106 (excluding template)
- Owner: Backend Lead

## DB-H-001: REAL type used for credit/cost/score fields — 31 occurrences

- Layer: DB
- Severity: **HIGH**
- Status: **RESOLVED** (previous session)
- Impact: Originally 31 `REAL` fields for financial data.
- Resolution: All financial fields converted to `NUMERIC(18,6)`. Remaining `REAL` fields are non-financial scores (relevance, quality, drift) with explicit `-- 0-100 non-financial score` comments.
- Verified: `grep 'NUMERIC(18,6)' database_schema.md` confirms all financial fields use correct type.
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
- Resolution: Replaced all `credit_ledger` references with canonical `credit_transactions` (matching `ai_credit_transactions` table in §13.2). Files updated: screen_web_studio_queue, screen_web_home_dashboard, screen_web_capability_matrix, screen_web_studio_launcher, screen_mobile_studio_launcher, screen_mobile_home_dashboard, screen_mobile_billing.
- Verified: `grep -r 'credit_ledger' docs/03_screens/` = 0 matches
- Owner: Screen Doc Lead


## ~~API-C-002~~: ✅ RESOLVED — Screen→API RPC gap fully closed

- Layer: API / Screens
- Severity: ~~**HIGH**~~ → **RESOLVED**
- Status: **✅ RESOLVED** (2026-04-06)
- Resolution: API inventory work promoted a large screen-referenced RPC set into `api_endpoint_map.md` §10-§20 with method, auth level, rate limit, and description.
- Verified: Python gap analysis script confirms 0 remaining missing RPCs.
- `screen_api_reconciliation.md` status updated from WORKING_ANALYSIS → RESOLVED.
- Caveat (2026-04-07): do NOT treat this as proof that all screen docs are implementation-clean. Canonical API coverage and screen semantic quality are separate concerns; screen contamination remains tracked as `SCR-H-003`.
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
