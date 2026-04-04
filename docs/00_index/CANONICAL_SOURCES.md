---
layer: index
canonical: true
last_updated: 2026-04-06
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
| Legal & compliance | 01_business/legal_compliance.md | `engineering-approved`, `launch-gated pending legal sign-off` (DEC-001) |

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
| DB schema | 04_contracts/database_schema.md | ~135 CREATE TABLE blocks. RLS (106+), deleted_at (51+), CHECK (23+). All blockers RESOLVED. ✅ 51 DDL comma issues fixed (49 original + 2 additional in `coupons`/`store_pages` Round 5 2026-04-04). |
| API endpoints | 04_contracts/api_endpoint_map.md | **~1,160 canonical RPC definitions** (§2-§20) + ~14 REST endpoints + 6 webhook endpoints. ✅ All API blockers RESOLVED. §10-§20 contain screen-derived RPCs promoted to canonical status (2026-04-06). 100% screen-to-API coverage achieved (907/907). |
| Protobuf / gRPC | 04_contracts/protobuf_contracts.md | Overview doc only (~52 services, ~310 RPCs). ⚠️ Actual `.proto` files do NOT exist yet — planned for implementation Phase 1. |
| Domain events | 04_contracts/domain_event_catalog.md | ~230 canonical event types (Round 5 2026-04-04). All notification matrix events now have verbatim canonical entries. EVT-H-001 fully resolved (74-row mapping table). |
| API JSON examples | 04_contracts/api_examples.md | 24 request/response examples, companion to api_endpoint_map.md |
| RBAC permissions | 04_contracts/rbac_permission_matrix.md | 7 roles × ~114 perms + 8 admin roles (~23 perms). Round 5 (2026-04-04): Added `affiliate:read`, `competitor:read`, `evidence:read`, `membership:read/manage`, `admin:user:read`, `admin:workspace:read`, `admin:commerce:read`. Note: `permission_alias_policy.md` was demoted to non-canonical (HISTORICAL_REFERENCE) — screen docs now use RBAC tokens directly. |
| Connector specs | 04_contracts/connector_specs.md | 6 platforms: TikTok, Shopee, Lazada, YouTube, Instagram, Facebook |
| Error catalog | 04_contracts/error_catalog.md | **READY**. 30+ error codes, gRPC↔HTTP mapping, retry policy, bilingual messages |
| Screen↔API reconciliation | 04_contracts/screen_api_reconciliation.md | ✅ RESOLVED (2026-04-06). Traceability record showing which screens reference which RPCs. All 907 screen-referenced RPCs now have canonical definitions in `api_endpoint_map.md` §2-§20. No longer a gap-tracking document. |
| Permission alias policy | 09_archive/permission_alias_policy.md | **NOT CANONICAL** (demoted 2026-04-04, moved to `09_archive/`). Historical reference only. Contains semantically unsafe alias mappings (read→manage, delete→create). Screen docs have been directly canonicalized to use RBAC tokens. Do NOT use for implementation. |

## System Layer

| Topic | Canonical File | Notes |
|-------|---------------|-------|
| Tech stack ADR | 05_system/tech_stack_adr.md | 14 ADRs, full stack mapping |
| Sequence diagrams | 05_system/sequence_diagrams.md | 13 critical flow diagrams |
| Queue / retry | 05_system/queue_retry_design.md | 10 queues, DLQ, outbox, circuit breaker |
| AI provider routing | 05_system/ai_provider_guide.md | Multi-provider adapter, Gemini default |
| Cache & search | 05_system/cache_search_strategy.md | Dragonfly, Meilisearch, ClickHouse |
| Runtime workflow | 05_system/runtime_workflow.md | Activepieces integration, tier limits |
| AI media & continuity | 05_system/ai_media_continuity.md | Multi-provider video/image/TTS/voice |

## Quality & Operations

| Topic | Canonical File | Notes |
|-------|---------------|-------|
| QA acceptance packs | 06_quality_ops/qa_acceptance_packs.md | 5-path test matrix |
| Security threat model | 06_quality_ops/security_threat_model.md | OWASP Top 10, multi-tenant |
| Performance benchmarks | 06_quality_ops/performance_benchmarks.md | SLA targets, k6 scenarios |
| Data migration | 06_quality_ops/data_migration_strategy.md | Import sources, CSV, sync |
| Dev environment | 06_quality_ops/docker_dev_environment.md | Docker Compose + env |
| Notification templates | 06_quality_ops/notification_templates.md | 13 email, 8 push, in-app |
| Analytics taxonomy | 06_quality_ops/analytics_event_taxonomy.md | PostHog events, funnels |
| Moderation rules | 06_quality_ops/moderation_rules_engine.md | Pipeline, EU AI Act |
| i18n guide | 06_quality_ops/i18n_guide.md | Paraglide + Flutter intl |
| Activepieces integration | 06_quality_ops/activepieces_integration.md | 9 pieces, 8 recipes, tiers |
| Notification trigger matrix | 06_quality_ops/notification_trigger_matrix.md | Maps domain events → notification templates. All 35 canonical events verified verbatim in `domain_event_catalog.md` (Round 5 2026-04-04). |

## Screens & Index

| Topic | Canonical File | Notes |
|-------|---------------|-------|
| Screen index | 03_screens/SCREEN_INDEX.md | Do NOT use old docs/screen_index.md |

## Meta

| Topic | Canonical File | Notes |
|-------|---------------|-------|
| Docs audit findings | 00_index/OPEN_BLOCKERS.md | 20 tracked entries: 19 RESOLVED, 1 PARTIALLY RESOLVED (PRD-H-001). Zero OPEN/CRITICAL blockers in tracked set. Downstream integrity gaps tracked in CROSS_LAYER_MATRIX.md §Known Integrity Gaps. |
| Build phases | 00_index/IMPLEMENTATION_ORDER.md | 9 phases, dependencies |
| Architecture decisions | 00_index/DECISION_LOG.md | ≥12 ADRs |
| Acceptance tests | 00_index/ACCEPTANCE_TESTS.md | Created in Phase 1B |
| Cross-layer matrix | 00_index/CROSS_LAYER_MATRIX.md | **28 doc-spec aligned** (feature doc ↔ schema ↔ screens ↔ API service name). ✅ Full-contract alignment achieved: ~1,160 canonical RPCs covering 100% of screen references (907/907). See `screen_api_reconciliation.md` (RESOLVED). Caveat: `ci_cd_pipeline.md` remains SCAFFOLD; legal is launch-gated. |
