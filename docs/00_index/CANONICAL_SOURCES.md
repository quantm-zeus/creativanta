---
layer: index
canonical: true
last_updated: 2026-10-30
---

# Canonical Sources — Single Source of Truth Registry

Cross-link rule: If file A mentions content owned by file B, A places exactly one link — never copies content.

## Agent Configuration

> **Note**: Agent configuration files are at **repository root**, external to the `docs/` package. They are not included in docs-only distributions.

| Topic | Canonical File | Notes |
|-------|---------------|-------|
| Shared agent rules | `AGENTS.md` (repo root, external to docs/) | Read first — cross-tool |
| Claude Code-specific | `CLAUDE.md` (repo root, external to docs/) | Thin wrapper, imports @AGENTS.md |
| Antigravity-specific | `GEMINI.md` (repo root, external to docs/) | Overrides AGENTS.md in Antigravity |

## Business & Product

| Topic | Canonical File | Notes |
|-------|---------------|-------|
| Product scope & vision | 01_business/product_overview.md | Sourced from PRD §2-§7 |
| User segments & operator modes | 01_business/user_segments_and_modes.md | 7 segments, 6 modes (PRD §8) |
| Business rules & invariants | 01_business/business_rules.md | Cross-module contracts (PRD §25) |
| Glossary | 01_business/glossary.md | Canonical naming, One Graph taxonomy |
| Pricing, tiers, credits | 01_business/pricing_and_credits.md | 5 tiers, add-ons, credit system |
| Legal & compliance | 01_business/legal_compliance.md | `engineering-approved`, `launch-gated pending legal sign-off` (DEC-001). Engineering implementation may proceed under the approved defaults; final sign-off is a launch gate. |

## Feature Behavior

| Topic | Canonical File | Notes |
|-------|---------------|-------|
| Feature M01–M23 + auth | 02_features/<domain>/<feature>.md | See Domain Map in BUILD_INDEX.md |
| Copilot (AI assistant) | 02_features/platform/copilot.md | Cross-cutting AI ops assistant; PRD §34 |
| Help Center, Changelog, Beta | 02_features/platform/help_center.md | S19 §4, §8, §9; includes Public Status Page |
| Referral & Growth Engine | 02_features/platform/referral_growth.md | PRD §37.2, Pricing §6-7 |

## Contract Layer

| Topic | Canonical File | Notes |
|-------|---------------|-------|
| DB schema | 04_contracts/database_schema.md | Canonical table/enum/index contract. Includes workflow/agent step tables, KB tables, admin broadcast/job ops tables, public API usage tables. |
| API endpoints | 04_contracts/api_endpoint_map.md | Canonical RPC inventory and REST/webhook surface. Coverage is broad, but downstream screen cleanliness and implementation readiness still require OPEN_BLOCKERS review. |
| Protobuf / gRPC | 04_contracts/protobuf_contracts.md | Transport/codegen overview only. During the docs-only phase, use `api_endpoint_map.md` + `api_examples.md` as the canonical transport authoring source. Commit `/protos/` later when typed client/server generation begins. |
| Domain events | 04_contracts/domain_event_catalog.md | ~230 canonical event types (Round 5 2026-04-04). All notification matrix events now have verbatim canonical entries. EVT-H-001 fully resolved (74-row mapping table). |
| API command/message semantics | 04_contracts/api_behavior_contracts.md | Common wire fields, critical commands, validation, replay and phase transport gate. |
| RPC permission/action bindings | 04_contracts/rpc_permission_bindings.csv | One binding for every inventory RPC; named permissions resolve through RBAC. |
| Durable credit accounting | 04_contracts/credit_accounting_contract.md | Source lots, reservations, append-only ledger and restart/late-result recovery. |
| Financial computation | 04_contracts/financial_computation_contract.md | Recognition, cost/FX snapshots, dedup, reconciliation and golden fixtures. |
| API JSON examples | 04_contracts/api_examples.md | 24 request/response examples, companion to api_endpoint_map.md |
| RBAC permissions | 04_contracts/rbac_permission_matrix.md | 7 workspace roles + 8 internal admin roles; exact keys are in the matrix. Round 5 (2026-04-04): Added `affiliate:read`, `competitor:read`, `evidence:read`, `membership:read/manage`, `admin:user:read`, `admin:workspace:read`, `admin:commerce:read`. Note: `permission_alias_policy.md` was demoted to non-canonical (HISTORICAL_REFERENCE) — screen docs now use RBAC tokens directly. |
| Connector specs | 04_contracts/connector_specs.md | 6 platforms: TikTok, Shopee, Lazada, YouTube, Instagram, Facebook |
| Error catalog | 04_contracts/error_catalog.md | Canonical error registry across all active domains in the corpus. Add new error families here before implementation uses them. |
| Screen↔API reconciliation | 04_contracts/screen_api_reconciliation.md | Historical API coverage traceability. Useful for inventory, but not proof that every screen doc is semantically implementation-clean. |
| Permission alias policy | 09_archive/permission_alias_policy.md | **NOT CANONICAL** (demoted 2026-04-04, moved to `09_archive/`). Historical reference only. Contains semantically unsafe alias mappings (read→manage, delete→create). Screen docs have been directly canonicalized to use RBAC tokens. Do NOT use for implementation. |

## System Layer

| Topic | Canonical File | Notes |
|-------|---------------|-------|
| Tech stack ADR | 05_system/tech_stack_adr.md | 14 ADRs, full stack mapping |
| Sequence diagrams | 05_system/sequence_diagrams.md | 13 critical flow diagrams |
| Queue / retry | 05_system/queue_retry_design.md | Named queues, at-least-once outbox/inbox, external-effect recovery, DLQ and budgets. |
| AI provider routing | 05_system/ai_provider_guide.md | Multi-provider adapter, Gemini default |
| Cache & search | 05_system/cache_search_strategy.md | Dragonfly, Meilisearch, ClickHouse |
| Runtime workflow | 05_system/runtime_workflow.md | Owned builder/runtime, optional licensed Activepieces adapter, tier limits |
| AI media & continuity | 05_system/ai_media_continuity.md | Multi-provider video/image/TTS/voice |

## Quality & Operations

| Topic | Canonical File | Notes |
|-------|---------------|-------|
| QA acceptance packs | 06_quality_ops/qa_acceptance_packs.md | 5-path test matrix |
| Accessibility spec | 06_quality_ops/accessibility_spec.md | WCAG 2.1 AA implementation contract across surfaces |
| Security threat model | 06_quality_ops/security_threat_model.md | OWASP Top 10, multi-tenant |
| Performance benchmarks | 06_quality_ops/performance_benchmarks.md | SLA targets, k6 scenarios |
| Data migration | 06_quality_ops/data_migration_strategy.md | Import sources, CSV, sync |
| Dev environment | 06_quality_ops/docker_dev_environment.md | Docker Compose + env |
| Seed fixtures spec | 06_quality_ops/seed_data.md | Fixture design, seed order, environment policy |
| Executable seed SQL | 06_quality_ops/seed_data.sql | Canonical seed script for local/test bootstrap |
| Notification templates | 06_quality_ops/notification_templates.md | 13 email, 8 push, in-app |
| Analytics taxonomy | 06_quality_ops/analytics_event_taxonomy.md | PostHog events, funnels, required common properties, and module-complete minimum coverage matrix |
| Moderation rules | 06_quality_ops/moderation_rules_engine.md | Pipeline, EU AI Act |
| i18n guide | 06_quality_ops/i18n_guide.md | Paraglide + Flutter intl |
| Activepieces integration | 06_quality_ops/activepieces_integration.md | 9 pieces, 8 recipes, tiers |
| Notification trigger matrix | 06_quality_ops/notification_trigger_matrix.md | Maps domain events → notification templates. All 35 canonical events verified verbatim in `domain_event_catalog.md` (Round 5 2026-04-04). |

## Screens & Index

| Topic | Canonical File | Notes |
|-------|---------------|-------|
| Screen index | 03_screens/SCREEN_INDEX.md | Do NOT use old docs/screen_index.md |
| Screen implementation protocol | 03_screens/SCREEN_IMPLEMENTATION_PROTOCOL.md | Canonical rules for resolving legacy screen aliases and placeholders via feature/contract layers |

## Meta

| Topic | Canonical File | Notes |
|-------|---------------|-------|
| Docs audit findings | 00_index/OPEN_BLOCKERS.md | Current source of truth for OPEN, PARTIAL, and RESOLVED blockers. Read this file before implementation; do not rely on older summary counts. |
| Doc ownership / freshness | 00_index/DOC_OWNERSHIP_AND_FRESHNESS.md | Canonical owner-role, cadence, and freshness trigger matrix for the active docs corpus |
| Build phases | 00_index/IMPLEMENTATION_ORDER.md | P0–P8, all 31 entries, start/completion and exit gates. |
| AI execution/handoff | 00_index/BUILD_EXECUTION_CONTRACT.md | Evidence states, per-slice packets, external gates, full-scope completion. |
| Static documentation validation | ../tooling/check_docs.py | Executable selected-invariant checks; not runtime/launch certification. |
| Architecture decisions | 00_index/DECISION_LOG.md | ≥12 ADRs |
| Acceptance tests | 00_index/ACCEPTANCE_TESTS.md | Created in Phase 1B |
| Requirements traceability | 00_index/REQUIREMENTS_TRACEABILITY_MATRIX.md | Module-to-business/feature/contract/runtime/quality traceability backbone |
| Cross-layer matrix | 00_index/CROSS_LAYER_MATRIX.md | Module mapping and integrity snapshot. It is not a blanket claim that the corpus is contradiction-free or fully implementation-ready. |

## Review and phased build additions — 2026-10-30

| Topic | Canonical File | Notes |
|---|---|---|
| Product validation and improvement rationale | 01_business/product_strategy_validation.md | Pilot segments, hypotheses, decision criteria and checked external references; no demand claims |
| Agent task decomposition | 00_index/agent_task_catalog.json | Exact task IDs/dependencies, source routing and module-completion owners |
| Backlog usage | 00_index/AGENT_BUILD_BACKLOG.md | How to choose/split a slice and preserve scope; AGENT_TASK_CARDS is a generated projection |
| Requirement and screen coverage | 00_index/requirement_task_map.csv; 00_index/screen_task_map.csv | Generated source/line/hash links; not copied behavior or runtime acceptance |
| Backlog validation | ../tooling/build_plan.py | Rebuild and drift/dependency/module checks, integrated into check_docs |
| Inventory computations | 04_contracts/inventory_computation_contract.md | Stock ledger, durable reservations, baseline imports, locking and I01–I10 fixtures |
| Current review results | 00_index/BUILD_READINESS.md | Findings, corrected specs, readiness limits and actual verification artifacts |
