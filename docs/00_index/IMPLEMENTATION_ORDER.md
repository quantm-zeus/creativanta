---
layer: index
canonical: true
last_updated: 2026-04-06
---

# Implementation Order — Build Phases & Dependencies

## 1. Dependency Principles

- Each phase unlocks the next; do not skip phases.
- Canonical objects (One Graph) must exist before modules that consume them.
- Cross-cutting concerns (auth, RLS, canonical contract scaffolding) are Phase 0 hard blockers.
- Modules within the same phase can run in parallel unless noted.

## 2. Build Phases

### Phase 0 — Foundation (no dependencies)

| Component | Contract Source | Blocker |
|-----------|----------------|---------|
| Auth & Workspace (Clerk + JWT + RBAC) | 04_contracts/database_schema.md#workspace | None |
| DB schema bootstrap | 04_contracts/database_schema.md | None — DB-C-001/002 resolved |
| Contract scaffolding (`api_endpoint_map` → `/protos/`) | 04_contracts/api_endpoint_map.md + 04_contracts/protobuf_contracts.md | None — generate `/protos/` at implementation kickoff |
| Design system tokens | 05_system/tech_stack_adr.md#design | None |
| Dev environment (Docker Compose) | 06_quality_ops/docker_dev_environment.md | None |
| RLS policies for all tables | 04_contracts/database_schema.md | None — DB-C-001/002 resolved |

### Phase 1 — Core Intelligence: M02, M03, M04

| Module | Dependencies | Notes |
|--------|-------------|-------|
| M02 Trend Fusion Radar | Phase 0 (auth, schema) | Crawler + Meilisearch + pgvector |
| M03 Research & Competitor Intel | Phase 0 | ClickHouse for aggregation |
| M04 Opportunity Board | Phase 0 + M02 partial | Opportunity needs Trend/Signal data |

### Phase 2 — Content: M05, M06, M08

| Module | Dependencies | Notes |
|--------|-------------|-------|
| M05 Idea Engine | Phase 0 + M04 partial | Ideas link to Opportunities |
| M06 Script Lab | Phase 0 + M05 | Scripts require Ideas |
| M08 Continuity OS | Phase 0 | Can start independently (packs are standalone) |

M05 + M06 can run in parallel with M08.

### Phase 3 — AI Production: M07, M09, M10

| Module | Dependencies | Blockers |
|--------|-------------|----------|
| M07 AI Video Studio | Phase 2 (M06, M08) | **API-C-001**, API-H-001, API-H-002 |
| M09 Asset Derivative Manager | M07 partial | Needs generated assets |
| M10 Packaging QA | M06, M07 partial | Needs scripts + assets |

### Phase 4 — Publish & Engagement: M11, M12

| Module | Dependencies | Notes |
|--------|-------------|-------|
| M11 Publish Hub | Phase 3 (M07, M10) + connectors | Platform API connectors required |
| M12 Unified Inbox | Phase 0 + connectors | WebSocket + thread management |

M11 and M12 can start in parallel.

### Phase 5 — Commerce: M13 → M14, M15, M16 → M17, M18

| Module | Dependencies | Notes |
|--------|-------------|-------|
| M13 Product Hub | Phase 0 | Foundation for commerce — **start first** |
| M14 Monetization OS | M13 | Offers link to Products |
| M15 Creator Store | M13, M14 | Storefront needs product + offer layer |
| M16 Affiliate Network | M13 | Links + attribution need Products |
| M17 Live Commerce War Room | M13, M14 | Live needs product + offer pinning |
| M18 Seeding / Sample CRM | M13 | Sample requests link to Products |

**Parallel opportunities:** M14 + M15 + M16 can run in parallel after M13.
M17 and M18 can start after M13, parallel with M14–M16.

### Phase 6 — Finance: M19

| Module | Dependencies | Notes |
|--------|-------------|-------|
| M19 Operating Ledger | M11, M13, M16, M17, M18 | Aggregates revenue/cost from all commerce + publish modules |

### Phase 7 — Automation: M20, M21

| Module | Dependencies | Notes |
|--------|-------------|-------|
| M20 Workflow Studio | Phase 0-6 canonical objects | Activepieces integration; needs all canonical objects available |
| M21 Recipe / Agent Center | M20 | Recipes are workflow templates |

### Phase 8 — Platform & Admin: M01, M22, M23

| Module | Dependencies | Notes |
|--------|-------------|-------|
| M01 Home / Daily Brief | ALL modules | Aggregates from every domain |
| M22 Capability Matrix | Phase 0 + connectors | Policy + capability state across platform |
| M23 Reporting / Admin / Billing | ALL modules | Admin console, S26 internal site |

## 3. Parallel Opportunities Summary

```
Phase 0: Sequential (foundation + contract scaffolding)
Phase 1: M02 ∥ M03 (M04 waits for M02 partial)
Phase 2: (M05 → M06) ∥ M08
Phase 3: M07 → (M09 ∥ M10)
Phase 4: M11 ∥ M12
Phase 5: M13 → (M14 ∥ M15 ∥ M16) → (M17 ∥ M18)
Phase 6: M19 (serial, needs Phase 5)
Phase 7: M20 → M21
Phase 8: M01 ∥ M22 ∥ M23
```

## 4. Critical Path

The longest dependency chain:
```
Phase 0 → Phase 1 (M02) → Phase 2 (M05→M06) → Phase 3 (M07) → Phase 4 (M11) → Phase 5 (M13→M14) → Phase 6 (M19) → Phase 7 (M20) → Phase 8 (M01)
```
