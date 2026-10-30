---
layer: index
canonical: true
last_updated: 2026-04-09
---

# Documentation Ownership And Freshness Matrix

This file defines the minimum ownership and review-cadence policy for the active documentation corpus.

## 1. Ownership Matrix

| Artifact family | Canonical docs | Primary owner role | Review cadence | Freshness trigger |
|---|---|---|---|---|
| Control plane | `BUILD_INDEX.md`, `OPEN_BLOCKERS.md`, `CANONICAL_SOURCES.md`, `IMPLEMENTATION_ORDER.md`, `REQUIREMENTS_TRACEABILITY_MATRIX.md` | Docs lead | Weekly | Any blocker, phase, scope, or source-of-truth change |
| Business | `docs/01_business/*` | Product owner + finance/legal as applicable | Monthly | Pricing, policy, legal, or segmentation change |
| Features | `docs/02_features/*` | Feature owner | Before and after implementation of the module | Business rule, workflow, state machine, or acceptance change |
| Screens | `docs/03_screens/*`, `SCREEN_INDEX.md`, `SCREEN_IMPLEMENTATION_PROTOCOL.md` | Screen doc lead + frontend owner | Weekly during active UI implementation | Any RBAC/schema/API/state change touching a screen |
| Contracts | `docs/04_contracts/*` | API/backend lead | Weekly | Schema/API/event/RBAC change |
| System | `docs/05_system/*` | Platform lead | Weekly | Queue/runtime/provider/architecture change |
| Quality / Ops | `docs/06_quality_ops/*` | QA lead + DevOps/platform + security as applicable | Weekly | CI/CD, observability, analytics, performance, security, or fixture change |

## 2. Freshness Rules

1. A downstream doc must be reviewed whenever its upstream canonical source changes.
2. Feature docs cannot remain `READY` if the owning schema/API/event contract changed and the feature doc has not been reviewed.
3. Screen docs cannot be treated as authoritative if they diverge from RBAC, schema, or API contracts; `SCREEN_IMPLEMENTATION_PROTOCOL.md` governs any legacy shorthand until cleaned.
4. `OPEN_BLOCKERS.md` must be updated on the same day a blocker is opened, resolved, deferred, or reclassified.
5. Historical snapshots and review reports must not override canonical docs; if retained, they must clearly state when they are superseded.

## 3. Escalation Policy

| Condition | Escalation |
|---|---|
| Canonical contradiction between business/feature/contract docs | Escalate to docs lead + owning product/API leads before implementation continues |
| Screen drift against RBAC/schema/API | Escalate to screen doc lead + frontend owner |
| Ops doc claims runnable behavior without canonical deployment semantics | Escalate to DevOps/platform owner |
| Review/report file contradicts canonical docs | Mark the review/report file as superseded or update it immediately |

## Task-map freshness

The Product/Engineering owner reviews agent_task_catalog and module completion after every scope/dependency change. Feature or screen edits must regenerate the source-hash inventories with build_plan after semantic review. The checker fails on stale maps. Product owns validation hypotheses; Finance/Commerce owns inventory/financial numerical contracts; Security owns public directory visibility and override boundaries. Evidence logs are historical observations and never replace current checks.
