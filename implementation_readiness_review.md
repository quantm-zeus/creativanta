# Implementation Readiness Review

## Metadata
- **Review Date**: 2026-04-07
- **Reviewer**: Claude Opus (Principal Systems Analyst / Solution Architect / Staff Engineer Reviewer)
- **Corpus**: `/docs/` — 330+ Markdown files across 7 documentation layers
- **Output Filename**: implementation_readiness_review.md
- **Readiness Class**: Partial Implementation-Ready
- **Total Score**: 38 / 48 (79%)

## Table of Contents

- [1. Executive Summary](#1-executive-summary)
- [2. Documentation System Map](#2-documentation-system-map)
- [3. Scorecard](#3-scorecard)
- [4. PRD Coverage Gaps](#4-prd-coverage-gaps)
- [5. Logic Issues](#5-logic-issues)
- [6. Business Rule Gaps](#6-business-rule-gaps)
- [7. Cross-Folder Linkage Issues](#7-cross-folder-linkage-issues)
- [8. Surface Parity Issues](#8-surface-parity-issues)
- [9. UI/UX Implementation Gaps](#9-uiux-implementation-gaps)
- [10. API / Contract Gaps](#10-api--contract-gaps)
- [11. Data / Persistence Gaps](#11-data--persistence-gaps)
- [12. Security / Permission / Compliance Gaps](#12-security--permission--compliance-gaps)
- [13. Operational Readiness Gaps](#13-operational-readiness-gaps)
- [14. Critical Blockers](#14-critical-blockers)
- [15. Important but Non-Blocking Gaps](#15-important-but-non-blocking-gaps)
- [16. Safe Assumptions vs Unsafe Assumptions](#16-safe-assumptions-vs-unsafe-assumptions)
- [17. Required Missing Artifacts](#17-required-missing-artifacts)
- [18. Feature Coverage Matrix](#18-feature-coverage-matrix)
- [19. Surface Parity Matrix](#19-surface-parity-matrix)
- [20. Contract Completeness Matrix](#20-contract-completeness-matrix)
- [21. Blocker Propagation Matrix](#21-blocker-propagation-matrix)
- [22. Build Readiness Verdict](#22-build-readiness-verdict)
- [23. Top Questions to Unblock Implementation](#23-top-questions-to-unblock-implementation)
- [24. Recommended Next Action](#24-recommended-next-action)
- [Appendix: Review Method Notes](#appendix-review-method-notes)

---

## 1. Executive Summary

**Overall Verdict**: The documentation corpus is among the most complete pre-implementation design systems this reviewer has assessed. It covers 23 core modules, 243 screens across 4 surfaces, ~1,160 RPCs, ~250 domain events, 114 glossary terms, 106 RLS-enforced database tables, and a full operational stack. The documentation system has undergone 7 rounds of internal alignment audits (per CROSS_LAYER_MATRIX.md), resolving 19 of 20 tracked blockers.

**Readiness Class**: **Partial Implementation-Ready**. The system is not "full implementation-ready" due to 5 factors: (1) no actual `.proto` files or generated code artifacts exist; (2) subscription tier pricing is absent from all docs; (3) screen docs have uneven quality (Tier A vs Tier C template contamination); (4) several cross-document contradictions remain unresolved; (5) legal compliance is pending sign-off. However, an estimated **65–75%** of the system can be built with acceptable risk using the current docs.

**Biggest Strengths**:
- Cross-layer traceability is explicit and well-maintained (BUILD_INDEX → features → contracts → system → quality)
- Database schema is DDL-ready with full RLS, CHECK constraints, and NUMERIC(18,6) for all financial fields
- All 23 core modules have defined state machines, 5+ acceptance criteria, and explicit edge cases
- The contract layer (API endpoint map, domain events, RBAC matrix) is comprehensive at ~1,160 RPCs
- Decision log (15 ADRs) captures irreversibility rationale, preventing accidental tech stack reversals
- Sequence diagrams provide 13 cross-service flow references that directly map to implementation

**Biggest Risks**:
- Gamification streak rewards contradict between M07 (50/200 credits) and gamification.md (10/50 credits)
- RBAC says workflow:create requires Manager+; API endpoint map says Editor+ — direct contradiction
- Secret storage contradicts between security_threat_model.md (Infisical) and ci_cd_pipeline.md (GitHub Secrets)
- Axiom vs Grafana Loki for logging — ADR says Axiom, observability.md says Loki
- Screen docs contain template contamination (boilerplate markers from an upgrade process)
- No subscription tier prices in any document — blocks billing/pricing page implementation
- Legal compliance file is "launch-gated pending legal sign-off"

**Should an AI coding agent begin implementation now?** Yes, but only for Phase 0 (foundation) and Phase 1 (intelligence) modules. The contradictions and missing artifacts must be resolved before Commerce (Phase 5), Finance (Phase 6), and Automation (Phase 7) work begins.

---

## 2. Documentation System Map

### Folder Roles

| Folder | Role | File Count | Status |
|--------|------|-----------|--------|
| `00_index/` | Master navigation, governance, blocker tracking, traceability | 8 | Complete |
| `01_business/` | Business context, rules, glossary, pricing, legal, segments | 6 | Complete (legal pending sign-off) |
| `02_features/` | Feature behavior specs with state machines and acceptance criteria | 31 | All READY |
| `03_screens/` | UI implementation specs per surface | 243 | Mixed quality (Tier A–C) |
| `04_contracts/` | API, schema, events, RBAC, connectors, errors, protobuf | 9 | Complete (spec-level) |
| `05_system/` | Runtime architecture, sequences, queues, AI, caching, observability | 8 | Complete |
| `06_quality_ops/` | QA, security, performance, dev environment, CI/CD, seed data, i18n | 16 | Complete (some gaps in analytics taxonomy) |
| `09_archive/` | Historical reference only — NOT canonical | 1 | Read-only |
| `_templates/` | Standard templates for new docs | 6 | Reference only |

### Canonical / Control Documents

- **BUILD_INDEX.md**: Master navigation hub, 23-module registry, dependency graph, 15 hard rules
- **CANONICAL_SOURCES.md**: Single source-of-truth registry for all artifact types
- **OPEN_BLOCKERS.md**: 20 tracked blockers (19 RESOLVED, 1 PARTIALLY RESOLVED)
- **CROSS_LAYER_MATRIX.md**: Production alignment matrix — "FULL-CONTRACT ALIGNMENT ACHIEVED" (907/907 RPCs)
- **IMPLEMENTATION_ORDER.md**: 9-phase build plan with dependency ordering
- **DECISION_LOG.md**: 15 ADRs with irreversibility rationale
- **REQUIREMENTS_TRACEABILITY_MATRIX.md**: 31-row traceability backbone
- **ACCEPTANCE_TESTS.md**: Given/When/Then criteria for M01–M23 from PRD §23

### Feature Domains (8)

1. **Platform**: Auth, Home (M01), Capability (M22), Copilot, Gamification, Help, Referral, Public API (S24), Internal Admin (S26), Reporting/Billing (M23)
2. **Intelligence**: Trend Radar (M02), Competitor Intelligence (M03), Opportunity Board (M04)
3. **Content**: Idea Engine (M05), Script Lab (M06), Continuity OS (M08)
4. **Production**: AI Video Studio (M07), Asset Derivatives (M09), Packaging QA (M10)
5. **Publish**: Publish Hub (M11)
6. **Engagement**: Unified Inbox (M12)
7. **Commerce**: Product Hub (M13), Monetization OS (M14), Creator Store (M15), Affiliate Network (M16), Live War Room (M17), Seeding CRM (M18), Creator Pro (S16)
8. **Finance**: Operating Ledger (M19)
9. **Automation**: Workflow Studio (M20), Recipe/Agent Center (M21)

### Surfaces

- **Web**: 133 screens (SvelteKit 2 + Svelte 5 Runes)
- **Mobile**: 61 screens (Flutter 3.41 + Riverpod 2.x)
- **Admin**: 37 screens (separate SvelteKit deployment, VPN-only)
- **Shared**: 12 component specs (cross-surface patterns)

### Contract Artifacts

- API endpoint map: ~1,160 RPCs across ~52 services
- Database schema: 106+ tenant-scoped tables with full DDL
- Domain event catalog: ~250 events with dot-notation naming
- RBAC permission matrix: ~114 workspace permissions + ~23 admin permissions
- Connector specs: 6 platforms with capability matrices
- Error catalog: 36+ error codes across 7 domains
- Protobuf contracts: structural blueprint (no compiled .proto files)
- API examples: 24 JSON request/response pairs

### System Artifacts

- Tech stack ADR with 15 decisions
- 13 sequence diagrams (Mermaid)
- Queue/retry design with DLQ DDL and circuit breaker
- AI provider guide with Rust trait and credit cost table
- Cache/search strategy with 26 cache keys, 13 Meilisearch indexes, 3 ClickHouse tables
- Observability stack with 24 custom metrics, SLOs, backup/DR plan

### Quality/Ops Artifacts

- QA acceptance packs with 5-path testing framework
- Security threat model with OAuth token contract and OWASP coverage
- Performance benchmarks with 12 SLA targets and k6 scenarios
- Docker dev environment (deployable compose file)
- CI/CD pipeline (GitHub Actions YAML)
- Design system tokens (CSS + partial Flutter)
- Seed data (SQL with FK-ordered execution)
- Notification templates and trigger matrix
- Analytics event taxonomy (sparse)
- i18n guide, moderation rules engine, runbook, data migration strategy, surface parity spec, Activepieces integration

### Notable Missing Artifact Classes

- **No compiled .proto files** — structural blueprint only; generation deferred to Phase 1
- **No subscription tier pricing** — feature gating matrix exists but no dollar amounts
- **No Figma design files or links** — design tokens exist but no visual mockups
- **No accessibility audit results** — WCAG 2.1 AA claimed but no proof
- **No ownership map** — no document assigns module ownership to specific people/teams
- **No doc freshness / review cadence** — no process for keeping docs updated post-implementation

---

## 3. Scorecard

| # | Criterion | Score | Evidence | Missing | Risk if AI Implements Now |
|---|-----------|-------|----------|---------|--------------------------|
| 1 | Scope and objectives | 3 | product_overview.md defines vision, 23-module scope, non-goals, operating loop. Phase distinctions via IMPLEMENTATION_ORDER.md. 7 user segments + 6 operator modes defined. | Enterprise tier details vague ("Custom"). | Low — scope is clear. |
| 2 | PRD coverage and traceability | 3 | REQUIREMENTS_TRACEABILITY_MATRIX.md provides 31-row backbone. ACCEPTANCE_TESTS.md has GWT for M01–M23. CROSS_LAYER_MATRIX.md confirms 907/907 screen→API coverage. | No auth/S16/S24/S26 acceptance tests in ACCEPTANCE_TESTS.md. Acceptance test depth is 3 per module (sparse for complex modules). | Low — traceability chain exists even if thin in places. |
| 3 | Logic correctness | 2 | 15/15 state machines defined. State transitions explicit with From/To/Trigger columns. Cross-module contract rules (RULE-001 to RULE-009) govern data flow invariants. | Gamification streak rewards contradict (M07: 50/200 vs gamification.md: 10/50). M12 thread `stale` state in A4 flow not in state machine table. M17 no state for post_live_processing failure. | **Medium** — contradicting reward values will cause wrong credit disbursement. |
| 4 | Business completeness | 3 | business_rules.md has 9 invariants + 14 resolved ambiguous rules (BIZ-001–BIZ-014). Pricing tiers, credit system, billing rules, dunning flow all specified. Feature gating matrix comprehensive (26 dimensions × 5 tiers). | No tier prices. Add-on pricing absent. Pro credit warning threshold contradicts (90% vs 80%). BIZ-007 Phase 2 trigger undefined. | Medium — billing system cannot be fully built without prices. |
| 5 | Feature completeness | 3 | All 31 modules READY. Each has state machines, 5+ ACs, edge cases, schema references, business rules. M07 (AI Video Studio) has 17 ACs and 7 edge cases. | M01 mode card ordering for 5/6 modes requires Pack 01. M04 Impact/Effort formulas deferred to Pack 02. S26 has only 2 ACs for 200+ RPCs. | Low for core modules. Medium for M01/S26. |
| 6 | Cross-folder traceability | 3 | CROSS_LAYER_MATRIX.md confirms alignment across all 28 modules. CANONICAL_SOURCES.md establishes source-of-truth policy. BUILD_INDEX.md provides 14 reading-order scenarios. | IMPLEMENTATION_ORDER.md still lists 3 resolved blockers as active for Phase 3 (stale cross-reference). | Low — governance docs are well-maintained. |
| 7 | Canonical source and governance | 3 | Explicit conflict resolution: PRD §23 > design packs > impl docs > screens. DECISION_LOG.md has 15 ADRs with "Must not reverse because" rationale. OPEN_BLOCKERS.md tracks 20 items with verification commands. | PRD-H-001 PARTIALLY RESOLVED (some edge cases still prose-based). Legal compliance pending sign-off. | Low — governance is strong. |
| 8 | UI/UX implementation readiness | 2 | 243 screens across 4 surfaces. Tier A screens (Home, Composer, Orders) are excellent with state machines, RBAC matrices, data binding, technical implementation notes. | Admin Moderation (A015) is Tier C — no action-to-RPC mapping. Template contamination in shared/admin screens. Legacy aliases in data binding tables. Screen ID cross-reference errors (W062→W063, stale W043/W046). | **Medium** — Tier A screens are buildable; Tier C screens need remediation. |
| 9 | Multi-surface parity | 2 | surface_parity_spec.md has 28-row matrix. Intentional mobile exclusions documented (6 features). Mobile additions documented (5 features). 5 parity enforcement rules. | Only 7–8/28 modules have full parity. M22 Capability Matrix is 🔴 None on mobile (but may be intentional). No mechanism to keep parity matrix updated. | Low — intentional divergences are documented. |
| 10 | API and contract readiness | 2 | ~1,160 RPCs. 24 JSON examples. Error catalog with 36+ codes. Webhook endpoints for 6 providers. Public REST API defined. Pagination convention specified. | CouponService/ValidateCoupon missing from endpoint map. GenerationService vs AssetService naming conflict. Pagination response inconsistency (root vs nested). Missing error domains (CONTENT, ENGAGEMENT, FINANCE, LIVE, SEEDING). workflow:create auth level contradicts RBAC. | **Medium** — naming conflicts and missing RPCs will cause frontend/backend misalignment. |
| 11 | Data model and persistence | 3 | Full PostgreSQL DDL for 106+ tables. RLS + FORCE RLS on all tenant-scoped tables. NUMERIC(18,6) for financials. UUID v7 policy. pgvector columns. TimescaleDB hypertables. ClickHouse OLAP tables. | JSONB column shapes undocumented for 4+ columns (benchmark_snapshots.metrics, capability_summary, expected_impact, scripts.body). voice_clones table not visible in reviewed portion. No sample_requests table name cited in M18. | Low — DDL is write-ready. JSONB shapes are a known gap. |
| 12 | Permission and trust model | 2 | 114 workspace permissions + 23 admin permissions in full role matrices. Constraint rules for External Collaborator. 5 approval-required actions. Rust Tower middleware pattern provided. | workflow:create Manager+ vs Editor+ contradiction. Instagram DM read-only connector vs RBAC write permission. Tier-gate enforcement not mapped in RBAC matrix. 71 admin-only permissions not surfaced in screen UI (known, justified). | **Medium** — the workflow:create contradiction is a real implementation blocker for M20. |
| 13 | Runtime and architecture | 2 | 13 sequence diagrams. Full queue pipeline with outbox pattern. Circuit breaker with per-provider thresholds. Credit reservation flow (Redis commands included). AI provider trait in Rust. | NATS role undefined (in ADR, absent from queue design and Docker). Axiom vs Loki logging contradiction. event_outbox missing target_stream column. StreamChunk struct undefined. Diagrams omit async queue layer (show sync calls where queues are intended). | **Medium** — contradictions need resolution before infra setup. |
| 14 | Quality, testing, and ops | 2 | QA acceptance packs with 5-path testing. 12 SLA targets. k6 scenarios defined. Docker dev environment deployable. CI/CD pipeline YAML ready. Runbook with DR plan and RPO/RTO. Security threat model with OAuth contract. | No k6 script code. Analytics taxonomy sparse (~30 events for 23 modules). Seed data SQL incomplete (7/18 tables in markdown). No mobile CI/CD. Moderation scoring thresholds undefined. Notification MJML bodies absent. | Medium — operational foundation is strong but test/analytics artifacts are incomplete. |
| 15 | Machine-readability for AI agents | 2 | Consistent frontmatter metadata. Canonical source policy. 15 hard rules in BUILD_INDEX.md. Naming conventions enforced. Tables and enums are explicit. | Screen docs mix Tier A specs with Tier C boilerplate — AI agent may implement template placeholders literally. Legacy aliases in data binding require protocol lookup. Some prose sections are narrative rather than spec-like (particularly in ai_media_continuity.md §9). | **Medium** — protocol mitigates boilerplate risk but adds lookup overhead. |
| 16 | Build readiness verdict | 2 | Phase 0–1 modules are safe to build. Foundation infra (auth, DB, queues, credits) is well-specified. 65–75% buildable with acceptable risk. | Full system build blocked by: no prices, legal pending, contradictions, screen quality variance. | See Section 22 for detailed verdict. |

**Total Score: 38 / 48 (79%)**

**Readiness Class: Partial Implementation-Ready**

---

## 4. PRD Coverage Gaps

| Requirement Area | Coverage Status | Gap Description |
|-----------------|----------------|-----------------|
| Subscription pricing | Missing | No dollar amounts for any tier (Free through Enterprise) in any document. Feature gating matrix exists but cannot drive pricing page or billing configuration. |
| Add-on module pricing | Missing | 5 add-ons listed in pricing_and_credits.md §4 with feature descriptions but zero price points. |
| Enterprise tier specifics | Weak | Most fields say "Custom" with no floor/ceiling guidance. |
| Auth acceptance tests | Missing | ACCEPTANCE_TESTS.md covers M01–M23 only. No GWT ACs for auth, S16, S24, S26, Copilot, Referral, Gamification, or Help. |
| Operator mode contract completeness | Partial | 5 of 8 mandatory fields unpopulated per mode (Daily Brief logic, navigation emphasis, terminology, recommended recipes, alert priorities). |
| M01 mode card ordering | Partial | Only Seller mode card order specified in ACs. 5 other modes require Pack 01 §S05.1 (not in current doc set). |
| M04 Impact/Effort scoring | Deferred | Formulas referenced as "Pack 02 §9.1" — not present in current docs. |
| M03 API surface | Thin | Only 2 RPCs defined for a module that implies add/delete/refresh/link operations. |
| M10 weight configurability | Ambiguous | RULE-M10-003 says "suggested weights" but system treats them as fixed. |
| Step 13 "Learn/Optimize" in operating loop | Missing | No module explicitly owns this step in the 14-step operating loop. |
| Merchant of record conditions | Vague | Non-Goal #6 hedges with "by default" — conditions for acting as merchant of record are unspecified. |

---

## 5. Logic Issues

### Contradictions

| ID | Issue | Source A | Source B | Severity |
|----|-------|----------|----------|----------|
| L-001 | Gamification streak reward amounts | M07 ai_video_studio.md: 7-day = 50 credits, 30-day = 200 credits | gamification.md: 7-day = 10 credits, 30-day = 50 credits | **Critical** — will cause wrong credit disbursement |
| L-002 | workflow:create minimum role | rbac_permission_matrix.md: Manager+ | api_endpoint_map.md: Editor+ | **Critical** — permission check will either over-restrict or under-restrict |
| L-003 | Pro credit warning threshold | pricing_and_credits.md §6: 90% | business_rules.md §3.3: implied 80% | Medium |
| L-004 | Pro tier "auto-buy" | business_rules.md §3.3 mentions "auto-buy" for Pro | BIZ-002 scopes auto-charge to Business only | Medium — likely doc error |
| L-005 | Secret storage for production | security_threat_model.md: Infisical | ci_cd_pipeline.md: GitHub Secrets | Medium — must pick one |
| L-006 | Logging infrastructure | tech_stack_adr.md Layer 9: Axiom | observability.md: Grafana Loki | Medium — observability.md is newer |
| L-007 | GenerationService vs AssetService | api_examples.md A.4–A.5: GenerationService | api_endpoint_map.md + protobuf: AssetService | Medium — naming mismatch |
| L-008 | Pagination response structure | api_examples.md A.2: next_page_token at root | api_examples.md A.24: nested under "pagination" key | Medium |
| L-009 | TrendUpdated event mapping | runtime_workflow.md §3.1B: TrendUpdated → trend.created | Expected: TrendUpdated → trend.updated | Low — likely typo |
| L-010 | Brand Deal lifecycle states | S16 creator_pro_tools.md: 7 states (incl. contracted) | M16 affiliate_network.md: 6 states (omits contracted) | Low — S16 is canonical |

### Missing State Transitions

| Module | Issue |
|--------|-------|
| M12 Unified Inbox | Thread `stale` state referenced in A4 ghost message flow but absent from state machine table |
| M17 Live War Room | No state defined for post_live_processing failure — session stuck indefinitely |
| M13 Product Hub | `returned` state described in prose but absent from order lifecycle state table |
| M15 Creator Store | 60-second auto-hide AC vs CDN cache invalidation timing (potentially up to 5 minutes) |
| Referral | Month-1 bonus (50 additional credits) has no corresponding state machine transition |
| Copilot | Credit recovery on partial_failure of multi-step actions is underspecified |

### Unresolved Source-of-Truth Issues

- Voice clone event namespace: `gamification.voice_clone.*` vs `production.voice_clone.*` vs `continuity.voice_clone.*` — explicitly flagged as unresolved in M07 and M08
- Gamification event namespace: feature doc expects `gamification.achievement.unlocked` but catalog uses `achievement.unlocked`; `streak.milestone` referenced but only `streak.broken` exists in catalog

---

## 6. Business Rule Gaps

| Rule Area | Gap | Impact |
|-----------|-----|--------|
| Subscription pricing | Zero price points for any tier or add-on | Cannot build pricing page, checkout, or billing system |
| BIZ-007 Phase 2 trigger | "When Creator Store M15 reaches PMF" — no objective PMF criteria | Cannot automate tax engine integration trigger |
| BIZ-011 workspace definition | Max 10 auto-refunds/workspace/day — does not define "workspace" for solo creators with sub-accounts | Edge case in refund throttling |
| BIZ-006 referral cap | Max 50/workspace/year — does not address mid-year workspace merges | Edge case in referral anti-abuse |
| Currency exchange | ECB rates "cached 1h for display, daily for records" — no fallback for ECB API downtime | Missing resilience rule |
| Coupon stacking | "Max 1 coupon + platform promo codes, total cap 50%" — but what defines a "platform promo code" vs a "coupon"? | Ambiguous boundary between two discount types |
| Tax handling | Phase 0 is "creator-responsible, no native tax engine" — but no UI copy or disclaimer text is specified | Creator may not understand tax responsibility |
| Workspace deletion | 3-phase process (quarantine/soft-delete/purge) — but no mention of how active subscriptions interact with deletion | Missing business rule for billing during quarantine |
| Content moderation scoring | Pipeline says "score < threshold" but no threshold values are defined anywhere | Cannot implement automated content decisions |

---

## 7. Cross-Folder Linkage Issues

### Broken or Weak Chains

| Chain | Issue | Severity |
|-------|-------|----------|
| IMPLEMENTATION_ORDER → OPEN_BLOCKERS | Phase 3 (M07) still lists API-C-001, API-H-001, API-H-002 as active blockers, but all 3 are RESOLVED in OPEN_BLOCKERS.md | Medium — misleads developers |
| Feature docs → Domain Event Catalog | gamification.md expects `gamification.achievement.unlocked` and `streak.milestone`; catalog has `achievement.unlocked` and `streak.broken` only | Medium — event consumers will break |
| Connector specs → RBAC matrix | Instagram DM is "Read-only (limited)" in connectors but RBAC grants `thread:reply` for Contributors without platform restriction | Medium — write attempts will fail |
| api_examples → api_endpoint_map | GenerationService in examples has no matching service in endpoint map (uses AssetService instead) | Medium — frontend will call wrong service |
| screen_api_reconciliation → api_endpoint_map | AffiliateService/Create and AffiliateService/Delete referenced in reconciliation but only CreateLink/DeleteLink exist in endpoint map | Low — possible orphan RPCs |
| M19 feature doc → _STATUS.md | Feature doc says "~20 RPCs"; STATUS says 26. 6 RPCs unaccounted. | Low |
| Screen docs → api_endpoint_map | AdminBillingService/GetCreditBalance called from user-facing screens (W001, W021) — Admin prefix unexpected in user context | Low — may be intentional |
| legal_compliance → business_rules | DEC-002 and DEC-005 referenced in legal doc but no DEC-series decisions defined anywhere | Low — orphan references |
| Observability → Docker dev | Grafana referenced in alerts but absent from Docker Compose dev environment | Low — can be added |
| Runbook → Docker dev | NATS health check in runbook but NATS absent from Docker Compose | Medium — inconsistent infra |

### Orphan Documents

- `09_archive/permission_alias_policy.md` — explicitly marked NOT CANONICAL with warnings. Not orphan per se, but could confuse scanners.

---

## 8. Surface Parity Issues

| Capability | Web | Mobile | Admin | Issue |
|-----------|-----|--------|-------|-------|
| Script Lab (M06) | Full | Partial (view + quick edit only) | N/A | Intentional — mobile lacks full editor. Documented. |
| AI Video Studio (M07) | Full | Partial (launcher + quick edit + status) | N/A | Intentional. Some studio modes web-only. Documented. |
| Workflow Builder (M20) | Full | Monitor only | N/A | Intentional. Builder is desktop-first. |
| Competitor Intelligence (M03) | Full | Partial (list + alerts) | N/A | Intentional. Registry management web-only. |
| Creator Store (M15) | Full | Partial | N/A | Store page editor is web-only. Documented. |
| Operating Ledger (M19) | Full | Summary view only | Admin has reconciliation tools | Intentional but aggressive — finance is a power-user feature. |
| Capability Matrix (M22) | Full | None | Admin view | Mobile absence undocumented as intentional or accidental |
| Admin screens | N/A | N/A | 37 screens | Admin is web-only (security policy). Consistent. |
| Shared components | 12 specs | Shared via protocol | Shared via protocol | No version tracking for parity drift |

**Key finding**: The intentional mobile exclusions are well-documented in surface_parity_spec.md. The primary risk is that the parity matrix is a point-in-time document with no mechanism to stay updated as features are built.

---

## 9. UI/UX Implementation Gaps

| Gap | Affected Screens | Severity |
|-----|-----------------|----------|
| Template contamination (Tier C boilerplate) | A015 (Admin Moderation), S001 (App Shell appended sections), S005 (Empty States appended sections), likely 20–40+ other screens | **High** — AI agent may implement placeholder text literally |
| Admin Moderation missing action-to-RPC mapping | A015 | **High** — [Approve/Remove/Warn/Suspend] buttons have no API binding |
| Legacy aliases in data binding tables | W001, W021, W052, W062, M001, M027 (at least) | Medium — resolvable via SCREEN_IMPLEMENTATION_PROTOCOL.md but adds lookup friction |
| Screen ID cross-reference errors | W062 cites W062 for Order Detail (should be W063); W052 cites stale W043/W046; M001 cites non-existent M011 | Low — routes are correct, only IDs are wrong |
| Studio Launcher mode→route mapping | W021 | Medium — 12 mode cards → 17 studio screens, mapping not explicit |
| Notification template MJML bodies | All notification-triggering screens | Medium — subject lines exist but no email HTML structure |
| Empty state permission-denied fallback | S005 | Low — CTA click by unpermitted user has no defined behavior |
| Admin Moderation localization language | A015 says Vietnamese; A001 says English-only | Low — likely A015 is wrong |
| Responsive behavior for complex tables | Commerce order lists, finance dashboards | Low — breakpoint rules in shared spec but per-screen adaptation sparse |

---

## 10. API / Contract Gaps

| Gap | Location | Impact |
|-----|----------|--------|
| CouponService/ValidateCoupon missing from endpoint map | api_examples.md A.11 uses it; api_endpoint_map.md §2.6.7 omits it | Frontend will call undefined RPC |
| GenerationService vs AssetService naming | api_examples.md uses GenerationService; endpoint map uses AssetService | Service name mismatch across frontend/backend |
| Pagination response inconsistency | A.2 puts next_page_token at root; A.24 convention nests under "pagination" | Frontend cannot rely on a single pagination contract |
| workflow:create auth level contradiction | RBAC: Manager+; API: Editor+ | Permission enforcement will be wrong for one or the other |
| Missing error domains | CONTENT, ENGAGEMENT, FINANCE, LIVE, SEEDING, CREATOR_PRO error codes absent | No structured error responses for 6 major domains |
| JSONB column shapes undocumented | benchmark_snapshots.metrics, capability_summary, expected_impact, scripts.body | Frontend/backend must guess or negotiate field shapes |
| StreamChunk struct undefined | ai_provider_guide.md references streaming response type | Cannot implement SSE/streaming without defining chunk format |
| event_outbox missing target_stream | queue_retry_design.md outbox poller calls event.target_stream() but no column exists | Outbox poller cannot route events to correct Redis Stream |
| AffiliateService/Create vs CreateLink | screen_api_reconciliation lists both; endpoint map only has CreateLink | Ambiguous whether Create is a distinct RPC |
| AuthService/Login absent from endpoint map | Login flow exists in examples but login RPC not in service table | Rate limit and auth level for login undefined in contracts |
| Protobuf message definitions absent | protobuf_contracts.md shows 7 services but no request/response message types | Cannot generate typed clients without message definitions |

---

## 11. Data / Persistence Gaps

| Gap | Impact |
|-----|--------|
| JSONB shapes for benchmark_snapshots.metrics, capability_summary, expected_impact, scripts.body, scripts.cta_blocks | Frontend cannot render these without knowing the shape; backend cannot validate. |
| voice_clones table not visible in reviewed schema sections | VoiceCloneService has API examples (A.22) but may lack schema backing. Needs verification in §19+. |
| sample_requests table (M18) | Feature doc says "workflow-scoped records" but no canonical table name or schema section cited. |
| Continuity pack types (style, lookbook, scene_memory) | Marked "Tier C deferred to §24" in schema — not fully specified. |
| ClickHouse migration strategy | ci_cd_pipeline.md covers SeaORM migrations but not ClickHouse DDL deployment. |
| Seed data incomplete | Markdown covers 7/18 tables. Companion seed_data.sql existence noted but content not verified. |
| No sample payloads for complex JSONB fields | scripts.body, run_of_show, cta_blocks — no example data in any doc. |
| Soft-delete coverage | deleted_at added to 51 tables (DB-H-003 RESOLVED) but retention/purge schedule per table is not mapped. Only business-level retention in legal_compliance.md. |
| Cache warming strategy absent | No doc specifies whether caches are pre-populated or lazy-filled. |

---

## 12. Security / Permission / Compliance Gaps

| Gap | Severity |
|-----|----------|
| Legal compliance pending legal sign-off | **High** — engineering-approved but launch-blocked |
| workflow:create Manager+ (RBAC) vs Editor+ (API) contradiction | **High** — direct permission enforcement conflict |
| Instagram DM write capability (RBAC grants thread:reply; connector says read-only) | Medium — write attempts on Instagram DM will fail silently |
| Secret storage contradiction (Infisical vs GitHub Secrets) | Medium — must be resolved before production deployment |
| Tier-gate enforcement not mapped in RBAC matrix | Medium — tier limits exist in business rules but not reflected in permission model |
| Admin site separate authentication details sparse | Medium — "VPN-only, MFA, separate auth, audit log" stated without implementation specifics |
| Content moderation scoring thresholds undefined | Medium — pipeline exists but automated decisions cannot be made without thresholds |
| C2PA metadata injection implementation details absent | Low — EU AI Act compliance listed but no library/implementation reference |
| CSP header directives not specified | Low — listed as mitigation but no actual policy provided |
| Age verification "verified payment method" as proxy | Low — may not satisfy all jurisdictions |
| DMCA 3-strike outcome vague | Low — "suspension review" without outcome criteria |
| ClamAV scan listed but not in Docker dev environment | Low — file upload scanning not testable locally |

---

## 13. Operational Readiness Gaps

| Area | Status | Gap |
|------|--------|-----|
| Local dev setup | Ready | Docker Compose deployable. Missing: NATS, ClickHouse init script, Activepieces health check. |
| CI/CD pipeline | Ready (spec) | YAML ready. Missing: deploy.sh, smoke-test.sh, proto-gen.sh, Flutter/mobile build steps. |
| Migration strategy | Partial | SeaORM migrations documented. ClickHouse DDL deployment not in pipeline. |
| Observability | Ready (spec) | Prometheus/Grafana/Jaeger/Loki Docker blocks provided. SLOs defined. Grafana not in dev Docker. |
| Analytics mapping | Weak | ~30 events for 23 modules — significant coverage gaps. No super-properties or identify strategy. |
| Notification triggers | Ready | 35-row trigger matrix. Templates have subjects but no MJML bodies. SMS deferred to P2. |
| Performance targets | Ready | 12 SLA targets. k6 scenarios described but no script code. Some targets aggressive (API p50 ≤10ms). |
| Failure handling | Ready | Runbook with 5 failure playbooks. DLQ design with retry policies. Circuit breaker per provider. |
| Debugging readiness | Good | Diagnostics hierarchy (L1–L4). Structured JSON logging. Sentry error context. |
| Backup/DR | Ready | RPO/RTO targets. PITR procedure. 5-scenario DR plan. Backup verification process. |
| Proto-gen tooling | Not ready | proto-gen.sh referenced but does not exist. Path inconsistent (./tooling/ vs ./scripts/). |

---

## 14. Critical Blockers

These must be resolved before an AI coding agent should begin implementation of the affected modules.

| # | Blocker | Affected Area | Why Critical |
|---|---------|---------------|-------------|
| 1 | Gamification streak reward amount contradiction (M07: 50/200 vs gamification.md: 10/50) | Gamification, Credit System | Will cause incorrect credit disbursement — financial impact |
| 2 | workflow:create auth level contradiction (Manager+ vs Editor+) | M20 Workflow Studio, RBAC middleware | Permission check will be wrong — security impact |
| 3 | GenerationService vs AssetService naming conflict | M07 AI Video Studio, frontend API client | Frontend will call non-existent service name |
| 4 | CouponService/ValidateCoupon missing from API endpoint map | M14 Monetization OS, Commerce checkout | Checkout cannot validate coupons |
| 5 | Pagination response structure inconsistency | All list endpoints, all frontend surfaces | Frontend cannot implement a single pagination handler |
| 6 | event_outbox missing target_stream column/routing | Event bus, outbox poller | Events cannot be routed to correct Redis Stream — entire async pipeline blocked |
| 7 | Secret storage contradiction (Infisical vs GitHub Secrets) | Production deployment | Cannot set up production secrets pipeline |

---

## 15. Important but Non-Blocking Gaps

| # | Gap | Workaround |
|---|-----|-----------|
| 1 | No subscription tier prices | Implement billing system with configurable price_id references; populate prices from Stripe dashboard |
| 2 | Legal compliance pending sign-off | Implement consent flows and data retention as specified; launch gate remains with legal team |
| 3 | Screen template contamination (Tier C) | Follow SCREEN_IMPLEMENTATION_PROTOCOL.md §3A — treat boilerplate markers as null; derive from feature docs |
| 4 | Legacy aliases in screen data binding | Follow SCREEN_IMPLEMENTATION_PROTOCOL.md §4 alias resolution table |
| 5 | Axiom vs Loki logging | Use Loki (observability.md is newer and has Docker config) |
| 6 | NATS role undefined | Proceed with Redis Streams only; add NATS when workflow complexity requires it |
| 7 | Admin Moderation screen incomplete | Derive actions from S26 feature doc and RBAC matrix |
| 8 | Analytics taxonomy sparse | Expand taxonomy during implementation per module |
| 9 | JSONB column shapes undocumented | Define shapes in protobuf message types during Phase 1 |
| 10 | 5/8 operator mode contract fields unpopulated | Implement with defaults; refine based on user testing |
| 11 | No k6 script code | Write scripts from described scenarios |
| 12 | No MJML email template bodies | Design templates during frontend implementation |
| 13 | Missing error domains (CONTENT, ENGAGEMENT, etc.) | Add error codes per module as implemented |
| 14 | Proto-gen script path inconsistency | Standardize to one path during Phase 0 scaffolding |
| 15 | Docker Compose rollback --image flag invalid | Fix to use proper image tag override syntax |

---

## 16. Safe Assumptions vs Unsafe Assumptions

### Safe Assumptions

An AI coding agent can safely assume:

1. **Tech stack is locked**: Rust/Axum/SeaORM/Tonic (backend), SvelteKit 2/Svelte 5 (web), Flutter 3.41/Riverpod (mobile), PostgreSQL 17 (DB). 15 ADRs with irreversibility rationale.
2. **UUID v7 for application-generated IDs**: ADR-015 explicitly locked.
3. **NUMERIC(18,6) for all financial fields**: DB-H-001 resolved and verified.
4. **RLS + FORCE RLS on all tenant-scoped tables**: DB-C-001 resolved and verified.
5. **Clerk for user authentication**: Auth feature doc locks this with webhook event mapping.
6. **Vietnamese-first for user-facing content**: i18n guide and product principles confirm.
7. **Dragonfly (Redis-compatible) for caching**: ADR-007 locked with rationale.
8. **Meilisearch for full-text search**: 13 indexes defined with Vietnamese tokenizer config.
9. **dot.notation for domain events**: EVT-H-001 resolution explicitly maps CamelCase → dot.notation.
10. **Activepieces for workflow execution engine**: ADR-008 locked (MIT license, replacing n8n).
11. **5 subscription tiers**: Free, Starter, Pro, Business, Enterprise — tier names and feature gating locked.
12. **6 operator modes**: DB enum values locked (creator, seller, affiliate_operator, live_operator, agency_mcn, brand_collaboration).
13. **7 workspace roles**: Owner, Admin, Manager, Editor, Contributor, Viewer, External Collaborator.
14. **Credit system**: 1 credit = abstraction over tokens; escrow/reservation pattern with 15-min TTL and max 5 concurrent.

### Unsafe Assumptions Requiring Human Confirmation

1. **Which streak reward amounts are correct?** M07 says 50/200 credits; gamification.md says 10/50. Cannot implement without decision.
2. **workflow:create minimum role?** Manager+ or Editor+? Cannot implement M20 RBAC without decision.
3. **Loki or Axiom for logging?** Evidence favors Loki (newer doc) but ADR has not been updated.
4. **Infisical or GitHub Secrets for production?** Cannot set up deployment pipeline.
5. **Is NATS part of v1 architecture?** ADR includes it; queue design and Docker do not.
6. **What are the subscription tier prices?** Feature gating exists but no dollar amounts.
7. **Are content moderation scoring thresholds configurable or fixed?** Pipeline defined without values.
8. **Is M22 Capability Matrix intentionally excluded from mobile?** surface_parity_spec shows 🔴 None but no justification.
9. **Should Add-on Modules have a fixed price or be negotiable?** Pricing doc lists features but zero prices.
10. **What is the canonical pagination response format?** Root-level or nested under "pagination" key?
11. **Does Instagram DM support write operations in v1?** Connector says read-only; RBAC allows thread:reply.

---

## 17. Required Missing Artifacts

| Artifact | Relevance | Priority |
|----------|-----------|----------|
| Proto files (.proto) | Required for gRPC/ConnectRPC code generation across Rust/TypeScript/Dart | **P0** — blocks typed client generation |
| Subscription tier pricing table | Required for billing system and pricing page | **P0** — blocks revenue |
| Workflow/state machine diagrams (visual) | State machines exist as tables; visual diagrams would reduce implementation errors | P1 |
| JSONB field schema definitions | Required for 4+ columns with flexible structures | P1 |
| Error catalog expansion (CONTENT, ENGAGEMENT, FINANCE, LIVE, SEEDING) | Required for structured error handling in 6 domains | P1 |
| k6 load test scripts | Required for performance validation | P1 |
| MJML email template bodies | Required for transactional email implementation | P1 |
| Seed data SQL completion (11/18 tables missing from markdown) | Required for developer onboarding and test setup | P2 |
| Analytics event taxonomy expansion | Required for product analytics — current ~30 events insufficient | P2 |
| Ownership map (module → team/person) | Useful for coordination but not implementation-blocking | P2 |
| Doc freshness / review cadence | Prevents doc rot post-implementation | P3 |
| Accessibility audit/compliance proof | WCAG 2.1 AA claimed but no evidence | P3 |

---

## 18. Feature Coverage Matrix

| Feature / Domain | Business Source | Feature Spec | Screen Coverage | API / Contract | Data / Schema | RBAC | Events | System / Runtime | Quality / Test | Status | Notes / Risks |
|-----------------|----------------|--------------|-----------------|----------------|---------------|------|--------|------------------|---------------|--------|---------------|
| Auth | user_segments, legal_compliance | auth.md ✅ | W (3), M (1) | ~15 RPCs | §4 users/workspaces | §2.1 | identity.* | Seq #7 | QA packs | Ready | No ACCEPTANCE_TESTS.md ACs |
| M01 Home | product_overview, business_rules | home_decision_engine.md ✅ | W001, M001 | Aggregation RPCs | §4–§13 (projections) | §2.1 | morning_brief.* | Seq #8 | QA packs | Ready | 5/6 mode card orders need Pack 01 |
| M02 Trend Radar | product_overview | trend_radar.md ✅ | W (3), M (2) | ~12 RPCs | §5 signals/trends | §2.2 | intelligence.* | Seq #1 | QA packs | Ready | Spike threshold configurable but no default |
| M03 Competitor | product_overview | competitor_intelligence.md ✅ | W (3), M (1) | 2 RPCs | §5.6–5.7 | §2.2 | competitor.* | — | QA packs | Ready | Only 2 RPCs — lean |
| M04 Opportunity | product_overview | opportunity_board.md ✅ | W (4), M (1) | ~8 RPCs | §5.4–5.5 | §2.2 | opportunity.* | — | QA packs | Ready | Impact/Effort formulas deferred |
| M05 Idea Engine | product_overview | idea_engine.md ✅ | W (4), M (3) | ~8 RPCs | §6.1–6.3 | §2.3 | content.idea.* | Seq #1 | QA packs | Ready | — |
| M06 Script Lab | product_overview | script_lab.md ✅ | W (4), M (2) | ~10 RPCs | §6.4–6.6 | §2.3 | content.script.* | Seq #1 | QA packs | Ready | Dual state machines (lifecycle+approval) |
| M07 AI Video Studio | product_overview, legal_compliance | ai_video_studio.md ✅ | W (17), M (4) | ~25 RPCs | §7.3–7.5 | §2.4 | production.* | Seq #2, #10, #12, #13 | QA packs §5 | Ready | Voice clone namespace unresolved; gamification reward conflict |
| M08 Continuity OS | product_overview | continuity_os.md ✅ | W (1), M (0) | ~8 RPCs | §7.1–7.2 | §2.4 | continuity.* | ai_media_continuity | QA packs | Ready | Voice clone namespace unresolved |
| M09 Asset Derivatives | product_overview | asset_derivatives.md ✅ | W (2), M (0) | ~8 RPCs | §7.3 (parent_asset_id) | §2.4 | asset.* | Seq #13 | QA packs §5 | Ready | Tier limits must sync with M07 |
| M10 Packaging QA | product_overview | packaging_qa.md ✅ | W (2), M (0) | ~6 RPCs | §8.1 fields | §2.5 | packaging.* | — | QA packs §5 | Ready | "Suggested" weights ambiguity |
| M11 Publish Hub | product_overview | publish_hub.md ✅ | W (7), M (2) | ~15 RPCs | §8.1–8.3 | §2.5 | publish.* | Seq #3 | QA packs | Ready | — |
| M12 Unified Inbox | product_overview | unified_inbox.md ✅ | W (6), M (3) | ~18 RPCs | §9.1–9.3 | §2.6 | engagement.* | Seq #5 | QA packs | Ready | `stale` state not in state table |
| M13 Product Hub | product_overview, business_rules | product_hub.md ✅ | W (7), M (4) | 42 Commerce RPCs | §10.1–10.5 | §2.7 | commerce.* | Seq #4 | QA packs | Ready | — |
| M14 Monetization OS | product_overview | monetization_os.md ✅ | W (6), M (3) | (shared Commerce) | §10.2, §10.5 | §2.7 | commerce.offer.* | — | QA packs | Ready | CouponService/ValidateCoupon missing |
| M15 Creator Store | product_overview | creator_store.md ✅ | W (4), M (0) | (shared Commerce) | §10, store pages | §2.7 | commerce.store.* | — | QA packs | Ready | — |
| M16 Affiliate | product_overview | affiliate_network.md ✅ | W (2), M (1) | (shared Commerce) | §10.4, §16 | §2.7 | commerce.affiliate.* | — | QA packs | Ready | LinkHealth object in feature doc (drift risk) |
| M17 Live War Room | product_overview | live_war_room.md ✅ | W (4), M (1) | 87 Other RPCs | §12.1 | §2.11 | live.* | — | QA packs | Ready | No post_live_processing failure state |
| M18 Seeding CRM | product_overview | seeding_crm.md ✅ | W (3), M (1) | (shared Other) | §12 (operations) | §2.12 | seeding.* | — | QA packs | Ready | sample_requests table name unclear |
| S16 Creator Pro | product_overview | creator_pro_tools.md ✅ | W (5), M (2) | (shared Commerce) | §16 | §2.13 | creator_pro.* | — | QA packs | Ready | 9 Gherkin ACs — strongest supplementary |
| M19 Operating Ledger | product_overview, pricing_and_credits | operating_ledger.md ✅ | W (8), M (3) | 26 RPCs | §11, §19.9E | §2.8 | finance.* | Seq #4 | QA packs | Ready | API count discrepancy (doc:~20, STATUS:26) |
| M20 Workflow Studio | product_overview | workflow_studio.md ✅ | W (7), M (1) | ~13 RPCs | §12.2–12.4 | §2.9 ⚠️ | workflow.* | Seq #6, runtime_workflow | QA packs | **Blocked** | workflow:create RBAC contradiction |
| M21 Recipe/Agent | product_overview | recipe_agent_center.md ✅ | W (2), M (2) | ~12 RPCs | §12.5, §19.11 | §2.9 | agent.* | runtime_workflow | QA packs | Ready | — |
| M22 Capability | product_overview | capability_matrix.md ✅ | W (1), M (0) | §9, §2.8 | connector cache | §2.10 | capability.* | connector_specs | QA packs | Ready | Mobile absence unjustified |
| M23 Reporting/Admin/Billing | product_overview, pricing_and_credits | reporting_admin_billing.md ✅ | A (37), W (settings) | 200+ RPCs | §4, §13, §17 | §3 (admin) | admin.* | — | QA packs | Ready | Only 2 GWT ACs for 200+ RPCs (S26) |
| Copilot | product_overview | copilot.md ✅ | W (1), M (1) | ~8 RPCs | §19.12 | §2.14 | copilot.* | — | — | Ready | Credit recovery on partial_failure unclear |
| Gamification | product_overview | gamification.md ✅ | W (1), M (1) | ~6 RPCs | §14, §22.10–11 | N/A | achievement.* ⚠️ | — | QA packs §5 | **Blocked** | Reward amounts contradict M07 |
| Referral | product_overview | referral_growth.md ✅ | W (1), M (1) | ~4 RPCs | §18.6 | N/A | referral.* | — | — | Ready | Month-1 bonus not in state machine |
| Help Center | product_overview | help_center.md ✅ | W (3), M (1) | ~6 RPCs | §17.8–9D | N/A | support.* | — | — | Ready | No edge case blocks |
| S24 Public API | product_overview | public_api.md ✅ | W (1) | §4 REST | §18 | §2.10 | api.* | — | — | Ready | Only 2 GWT ACs |

---

## 19. Surface Parity Matrix

| Capability | Web | Mobile | Admin | Shared | Parity Risk / Explanation |
|-----------|-----|--------|-------|--------|--------------------------|
| Auth (login/register/reset) | 🟢 Full | 🟢 Full | 🟢 Separate auth | 🟢 Patterns | Low — all surfaces covered |
| Home Dashboard | 🟢 Full | 🟢 Full | 🟢 Admin variant | 🟢 Shell | Low |
| Trend Radar | 🟢 Full | 🟡 List+alerts | ⚪ N/A | — | Low — intentional |
| Competitor Intelligence | 🟢 Full | 🟡 List only | ⚪ N/A | — | Low — intentional |
| Opportunity Board | 🟢 Full | 🟡 List+detail | ⚪ N/A | — | Low — intentional |
| Idea Engine | 🟢 Full | 🟢 Full (quick capture) | ⚪ N/A | — | Low |
| Script Lab | 🟢 Full | 🟡 View+quick edit | ⚪ N/A | — | Low — mobile lacks full editor |
| AI Video Studio | 🟢 Full (17 screens) | 🟡 Launcher+status | ⚪ N/A | — | Medium — significant mobile reduction |
| Continuity OS | 🟢 Full | 🔴 None | ⚪ N/A | — | Medium — character management web-only |
| Packaging QA | 🟢 Full | 🔴 None | ⚪ N/A | — | Low — QA is review-focused |
| Publish Hub | 🟢 Full | 🟢 Queue+quick | ⚪ N/A | — | Low |
| Unified Inbox | 🟢 Full | 🟢 Full | ⚪ N/A | — | Low |
| Commerce (M13-M16) | 🟢 Full | 🟡 Partial | 🟡 Disputes/fees | — | Medium — mobile commerce is view-heavy |
| Live War Room | 🟢 Full | 🟡 Monitor only | ⚪ N/A | — | Medium — real-time features web-first |
| Seeding CRM | 🟢 Full | 🟡 List only | ⚪ N/A | — | Low |
| Operating Ledger | 🟢 Full | 🟡 Summary only | 🟢 Reconciliation | — | Low — intentional power-user focus |
| Workflow Studio | 🟢 Full | 🟡 Monitor only | ⚪ N/A | — | Low — builder is desktop-first |
| Recipe/Agent | 🟢 Full | 🟡 Runs+recipes | ⚪ N/A | — | Low |
| Capability Matrix | 🟢 Full | 🔴 None | 🟢 Admin view | — | Low — admin/config concern |
| Billing/Settings | 🟢 Full | 🟢 Full | 🟢 Override tools | — | Low |
| Gamification | 🟢 Full | 🟢 Full | ⚪ N/A | — | Low |
| Creator Pro (S16) | 🟢 Full | 🟡 Partial | ⚪ N/A | — | Low |
| Moderation | ⚪ N/A | ⚪ N/A | 🟡 Incomplete (A015) | — | **High** — admin moderation screen is Tier C |
| System Health | ⚪ N/A | ⚪ N/A | 🟢 Full | — | Low |

---

## 20. Contract Completeness Matrix

| Module / Domain | Endpoint Map | Schema | Events | Permissions | Examples | Failure Modes | Completeness |
|----------------|-------------|--------|--------|-------------|---------|---------------|-------------|
| Auth/Identity | ✅ ~15 RPCs | ✅ §4 | ✅ identity.* | ✅ §2.1 | ✅ A.1 | ✅ AUTH_* | Complete |
| Intelligence (M02-M04) | ✅ ~12 RPCs | ✅ §5 | ✅ intelligence.* | ✅ §2.2 | ✅ A.2 | ❌ No INTELLIGENCE_* | Near-complete |
| Content (M05-M06) | ✅ ~25 RPCs | ✅ §6 | ✅ content.* | ✅ §2.3 | ✅ A.3 | ❌ No CONTENT_* | Near-complete |
| AI Production (M07-M10) | ✅ ~25 RPCs | ✅ §7 | ✅ production.* | ✅ §2.4 | ✅ A.4-A.5 | ✅ AI_* | Complete |
| Publish (M11) | ✅ ~15 RPCs | ✅ §8 | ✅ publish.* | ✅ §2.5 | ✅ A.6 | ✅ PUBLISH_* | Complete |
| Engagement (M12) | ✅ ~18 RPCs | ✅ §9 | ✅ engagement.* | ✅ §2.6 | ✅ A.7 | ❌ No ENGAGEMENT_* | Near-complete |
| Commerce (M13-M18) | ✅ 42+ RPCs | ✅ §10, §12 | ✅ commerce.* | ✅ §2.7 | ✅ A.8-A.11 | ✅ COMMERCE_* | Near-complete (ValidateCoupon missing) |
| Finance (M19) | ✅ 26 RPCs | ✅ §11 | ✅ finance.* | ✅ §2.8 | ✅ A.12-A.13 | ❌ No FINANCE_* | Near-complete |
| Workflow (M20-M21) | ✅ ~25 RPCs | ✅ §12 | ✅ workflow.* | ⚠️ §2.9 (contradicts) | ✅ A.14-A.15 | ✅ WORKFLOW_* | **Blocked** (RBAC conflict) |
| Live Commerce (M17) | ✅ (in Other) | ✅ §12.1 | ✅ live.* | ✅ §2.11 | ✅ A.16 | ❌ No LIVE_* | Near-complete |
| Seeding (M18) | ✅ (in Other) | ⚠️ table unclear | ✅ seeding.* | ✅ §2.12 | ✅ A.17 | ❌ No SEEDING_* | Partial |
| Creator Pro (S16) | ✅ (in Commerce) | ✅ §16 | ✅ creator_pro.* | ✅ §2.13 | ❌ None | ❌ No CREATOR_PRO_* | Partial |
| Admin (S26) | ✅ 200+ RPCs | ✅ §17+ | ✅ admin.* | ✅ §3 | ✅ A.19 | ✅ ADMIN_* | Near-complete |
| Public API (S24) | ✅ §4 REST | ✅ §18 | ✅ api.* | ✅ §2.10 | ❌ None | ❌ None | Partial |
| Connectors | ✅ 6 platforms | ✅ capability tables | ✅ connector.* | N/A | ❌ None | ⚠️ Backoff deferred | Near-complete |

---

## 21. Blocker Propagation Matrix

| Blocker | Affected Feature(s) | Affected Screen(s) | Affected Contract(s) | Affected System/Ops | Implementation Impact |
|---------|---------------------|--------------------|-----------------------|---------------------|----------------------|
| L-001: Gamification reward contradiction | M07, Gamification | W (gamification), M (gamification) | credit_transactions, achievement_records | Credit system | **Cannot ship gamification rewards** |
| L-002: workflow:create RBAC | M20 Workflow Studio | W (workflow builder/list) | rbac_permission_matrix, api_endpoint_map | Auth middleware | **Cannot implement M20 RBAC correctly** |
| L-003: GenerationService naming | M07 AI Video Studio | W (studio screens) | api_examples, api_endpoint_map | Frontend API client | Frontend will call wrong service |
| L-006: Pagination inconsistency | All list views | All list/table screens | api_examples | Frontend list components | Must pick one format before any list view |
| L-007: event_outbox routing | All async features | None directly | domain_event_catalog, queue_retry_design | Outbox poller | **Entire event bus is blocked** |
| Missing prices | Billing (M23), all tier-gated features | Pricing page, billing settings | Subscription tables | Stripe integration | Cannot build billing or pricing |
| Legal pending | All user-facing features | All screens with consent | legal_compliance | Consent management | Launch-blocked (not build-blocked) |

---

## 22. Build Readiness Verdict

### Can the AI coding agent build the full system now?

**No.** The 7 critical blockers in Section 14 prevent full system implementation. Specifically:

- The event bus (outbox routing) affects all async features
- The RBAC contradiction blocks M20
- The gamification reward contradiction blocks the credit reward system
- The naming/pagination conflicts affect all frontend API integration

### If implementation starts now, what percent can be built with acceptable risk?

**65–75%** of the system can be built with acceptable risk, covering:

- Phase 0 Foundation (auth, DB migrations, Docker setup, design tokens, RLS policies)
- Phase 1 Intelligence (M02, M03, M04) — no blockers
- Phase 2 Content (M05, M06, M08) — no blockers
- Phase 3 AI Production (M07, M09, M10) — buildable if GenerationService naming is resolved
- Phase 4 Publish + Engagement (M11, M12) — no blockers
- Partial Phase 5 Commerce (M13 core, M15) — buildable; M14 blocked on ValidateCoupon

### Which modules are safest to build first?

1. **Phase 0 Foundation**: Auth (Clerk integration), DB schema migration, Docker dev setup, design system tokens, RLS policy application — all well-specified with no blockers
2. **M02 Trend Radar**: Fully specified, 5 ACs, clear schema, no dependencies
3. **M05 Idea Engine**: Fully specified, simple state machine, pgvector search
4. **M06 Script Lab**: Dual state machines well-defined, clear schema
5. **M11 Publish Hub**: 12-state lifecycle, immutable logs, jitter algorithm specified
6. **M12 Unified Inbox**: Strong specification despite `stale` state gap (can default to `resolved`)

### Which modules are most dangerous to build now?

1. **M20 Workflow Studio**: RBAC contradiction (Manager+ vs Editor+) — permission model will be wrong
2. **Gamification**: Reward amounts contradict — will disburse wrong credits
3. **M19 Operating Ledger**: Requires ClickHouse setup, reconciliation complexity, no FINANCE error codes
4. **M17 Live War Room**: Real-time WebSocket complexity, no post_live_processing failure handling
5. **S26 Internal Admin**: 200+ RPCs with only 2 GWT ACs — highest ambiguity surface

### What should be resolved first before implementation begins?

In priority order:

1. **Resolve event_outbox routing** (add target_stream column or define routing function)
2. **Resolve workflow:create RBAC** (Manager+ or Editor+)
3. **Resolve gamification reward amounts** (10/50 or 50/200 credits)
4. **Resolve GenerationService vs AssetService naming** (pick one, update all docs)
5. **Resolve pagination response format** (root-level or nested)
6. **Add CouponService/ValidateCoupon to endpoint map**
7. **Resolve secret storage** (Infisical or GitHub Secrets)

---

## 23. Top Questions to Unblock Implementation

### Critical Blocking Questions

1. **What is the correct minimum role for workflow:create?** Manager+ (RBAC matrix) or Editor+ (API endpoint map)?
2. **What are the correct gamification streak reward amounts?** 10/50 credits (gamification.md) or 50/200 credits (M07)?
3. **How does the event outbox route events to the correct Redis Stream?** Is there a target_stream column, a routing table, or derivation from event_type?
4. **What is the canonical service name for AI generation?** GenerationService (examples) or AssetService (endpoint map)?
5. **What is the canonical pagination response format?** Root-level next_page_token or nested under "pagination" object?
6. **Does CouponService/ValidateCoupon exist?** It's in examples but missing from the endpoint map.
7. **Where are production secrets stored?** Infisical (security model) or GitHub Secrets (CI/CD)?

### High-Risk Ambiguity Questions

8. **What are the subscription tier prices?** No dollar amounts exist in any document.
9. **Is Loki or Axiom the logging backend?** ADR says Axiom; observability.md says Loki.
10. **Is NATS part of the v1 architecture?** ADR includes it; no other doc uses it.
11. **What are the content moderation scoring thresholds?** Pipeline defined but no threshold values.
12. **Does Instagram support DM write operations in v1?** Connector says read-only; RBAC allows thread:reply.
13. **What is the Pro tier credit warning threshold?** 90% (pricing) or 80% (business rules)?
14. **Is "auto-buy" a Pro tier feature or Business-only?** business_rules.md §3.3 mentions Pro auto-buy; BIZ-002 scopes to Business.
15. **What is the StreamChunk struct for SSE streaming responses?** Referenced but never defined.

### Clarification Questions

16. **Are M10 packaging score component weights fixed or configurable?** RULE-M10-003 says "suggested."
17. **What happens when post_live_processing fails in M17?** No failure state defined.
18. **Is M22 Capability Matrix intentionally excluded from mobile?** No justification in parity spec.
19. **What is the proto-gen.sh canonical path?** ./tooling/ or ./scripts/?
20. **Are there Add-on Module prices?** Feature lists exist but zero prices.
21. **What objective criteria define "Creator Store reaches PMF" for BIZ-007?**
22. **Should the Admin site use Vietnamese or English?** A001 says English; A015 says Vietnamese.
23. **Where is the face match verification threshold for Digital Twin consent?**
24. **What is the Docker Compose rollback syntax?** The --image flag is invalid.
25. **Are there additional ACs beyond the 3-per-module in ACCEPTANCE_TESTS.md for complex modules like M19/M20?**

---

## 24. Recommended Next Action

**Recommendation: Start only with selected low-risk modules (Phase 0 + Phase 1)**

### Why

The documentation corpus is impressively comprehensive but has 7 critical blockers that affect cross-cutting concerns (event bus routing, RBAC, naming, pagination). These blockers propagate to multiple modules and surfaces. Starting full implementation now would embed contradictions into code that are expensive to fix later.

However, Phase 0 (Foundation) and Phase 1 (Intelligence) have zero critical blockers and are fully specified. Starting these immediately provides:

1. **Validated infrastructure**: Auth, DB, Docker, RLS, design tokens — proving the stack works
2. **Event bus design forcing function**: Implementing M02 trend ingestion requires the outbox/event bus, forcing resolution of the target_stream gap
3. **Frontend patterns**: Building M02/M04 screens establishes list/detail/search patterns that all later modules reuse
4. **Confidence**: Completing Phase 0–1 provides evidence that the docs-to-code pipeline works

### Before starting Phase 2+

Resolve these 7 items (estimated effort: 1–2 hours of doc updates):

1. Add `target_stream VARCHAR NOT NULL` column to event_outbox DDL or define routing function
2. Pick Manager+ or Editor+ for workflow:create and update the losing document
3. Pick 10/50 or 50/200 for gamification streak rewards and update the losing document
4. Rename GenerationService → AssetService in api_examples.md (or vice versa in endpoint map)
5. Standardize pagination response to one format across all examples
6. Add CouponService/ValidateCoupon to api_endpoint_map.md
7. Pick Infisical or GitHub Secrets and update the losing document

### Parallel work while Phase 0–1 is being built

- Author .proto files from api_endpoint_map.md (blocking Phase 1 typed clients)
- Determine subscription tier prices (blocking billing)
- Complete legal sign-off (blocking launch)
- Expand analytics event taxonomy (non-blocking but needed pre-launch)
- Fix screen template contamination in Tier C screens (non-blocking for Phase 0–1)

---

## Appendix: Review Method Notes

### How Evidence Was Weighed

- **Direct textual evidence** was required for any claim of completeness. A feature being "named" in an index is not the same as being "specified" with behavior, state machines, and acceptance criteria.
- **Recency** was used to resolve conflicting documents. When two docs disagreed (e.g., Axiom vs Loki), the more recently dated document was noted as the likely current state, but the contradiction was still flagged.
- **Cross-layer verification** was performed for representative modules. For each major domain (Intelligence, Commerce, Finance, Production), the chain from business rules → feature spec → screen spec → API contract → schema → events → RBAC was traced and gaps were noted.
- **Screen quality** was assessed through a stratified sample: 2 web Tier A screens, 1 web Tier B, 2 mobile Tier A, 2 admin screens, 2 shared components. Findings from the sample were extrapolated to the broader corpus with the caveat that unreviewed screens may differ.

### How Contradictions Were Handled

- Contradictions were classified as **Critical** (will cause wrong implementation), **Medium** (will cause confusion or require rework), or **Low** (cosmetic or easily resolved).
- No contradictions were silently reconciled. Each was flagged with both source documents cited.
- Where a conflict resolution policy existed (PRD §23 > design packs > impl docs > screens), it was noted but the contradiction was still flagged because an AI agent may not apply the policy correctly.

### What "Insufficient Evidence" Means

- Used when a claim is made but no supporting artifact exists (e.g., "WCAG 2.1 AA compliant" with no audit results).
- Used when a section is expected but absent (e.g., FINANCE error codes).
- Used when a referenced external document was not available for review (e.g., "Pack 01 §S05.1", "Pack 02 §9.1").
- Not used for intentional omissions that are documented as such (e.g., SMS deferred to P2).
