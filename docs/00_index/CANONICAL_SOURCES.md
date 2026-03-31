---
layer: index
canonical: true
last_updated: 2026-03-30
---

# Canonical Sources — Single Source of Truth Registry

Cross-link rule: If file A mentions content owned by file B, A places exactly one link — never copies content.

## Agent Configuration

| Topic | Canonical File | Notes |
|-------|---------------|-------|
| Shared agent rules | `AGENTS.md` (root) | Read first — cross-tool |
| Claude Code-specific | `CLAUDE.md` (root) | Thin wrapper, imports @AGENTS.md |
| Antigravity-specific | `GEMINI.md` (root) | Overrides AGENTS.md in Antigravity |

## Business & Product

| Topic | Canonical File | Notes |
|-------|---------------|-------|
| Product scope & vision | 01_business/product_overview.md | Sourced from PRD §2-§7 |
| User segments & operator modes | 01_business/user_segments_and_modes.md | 7 segments, 6 modes (PRD §8) |
| Business rules & invariants | 01_business/business_rules.md | Cross-module contracts (PRD §25) |
| Glossary | 01_business/glossary.md | Canonical naming, One Graph taxonomy |
| Pricing, tiers, credits | 01_business/pricing_and_credits.md | 5 tiers, add-ons, credit system |
| Legal & compliance | 01_business/legal_compliance.md | ⚠️ Human review required |

## Feature Behavior

| Topic | Canonical File | Notes |
|-------|---------------|-------|
| Feature M01–M23 + auth | 02_features/<domain>/<feature>.md | See Domain Map in BUILD_INDEX.md |

## Contract Layer

| Topic | Canonical File | Notes |
|-------|---------------|-------|
| DB schema | 04_contracts/database_schema.md | ~116 tables. Known: DB-C-001, DB-C-002, DB-H-001 |
| API endpoints | 04_contracts/api_endpoint_map.md | ~310 RPCs. Known: API-C-001, API-H-001, API-H-002 |
| Protobuf / gRPC | 04_contracts/protobuf_contracts.md | ~41 services, codegen for 3 platforms |
| Domain events | 04_contracts/domain_event_catalog.md | ~215 events. Known: EVT-H-001 |
| RBAC permissions | 04_contracts/rbac_permission_matrix.md | 7 roles × ~106 perms + 8 admin roles |
| Connector specs | 04_contracts/connector_specs.md | 6 platforms: TikTok, Shopee, Lazada, YouTube, Instagram, Facebook |

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

## Screens & Index

| Topic | Canonical File | Notes |
|-------|---------------|-------|
| Screen index | 03_screens/SCREEN_INDEX.md | Do NOT use old docs/screen_index.md |

## Meta

| Topic | Canonical File | Notes |
|-------|---------------|-------|
| Docs audit findings | 00_index/OPEN_BLOCKERS.md | Extracted from audit reports |
| Build phases | 00_index/IMPLEMENTATION_ORDER.md | 9 phases, dependencies |
| Architecture decisions | 00_index/DECISION_LOG.md | ≥12 ADRs |
| Acceptance tests | 00_index/ACCEPTANCE_TESTS.md | Created in Phase 1B |
