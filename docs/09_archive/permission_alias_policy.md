---
layer: contracts
canonical: false
status: HISTORICAL_REFERENCE
created: 2026-04-04
demoted: 2026-04-04
demoted_reason: >
  Many alias mappings were semantically unsafe (e.g., read→manage, delete→create).
  Screen docs have since been directly canonicalized to use RBAC permission tokens.
  This document is retained as a historical reference only.
---

# Permission Alias Policy — HISTORICAL REFERENCE

> [!CAUTION]
> **This document is NOT canonical.** It was demoted from canonical status on 2026-04-04.
> **Do NOT use these mappings for RBAC implementation.**
> Screen docs have been directly updated to use canonical permission tokens from `rbac_permission_matrix.md`.
> Many mappings below are semantically unsafe (e.g., `read` → `manage`, `delete` → `create`).
> This document is retained solely for understanding legacy screen docs.

> ~~**Purpose**: Maps screen-level permission shorthand tokens to their canonical equivalents in `rbac_permission_matrix.md`.~~
> ~~Screen docs may use abbreviated permission names for readability. This document provides the official mapping.~~
> ~~When implementing RBAC checks, **always use the Canonical Permission** (right column).~~

> ~~[!IMPORTANT]~~
> ~~**Rule**: Screen documentation may use the Alias (left column) for readability, but implementation code MUST use the Canonical Permission from `rbac_permission_matrix.md`.~~

## Alias → Canonical Mapping

| Screen Alias | Canonical Permission | Notes |
|---|---|---|
| `achievement:read` | `analytics:read` | |
| `affiliate:read` | `affiliate:read` | Read-only affiliate data access (canonicalized — was incorrectly mapped to `affiliate:manage`) |
| `agent:manage` | `recipe:install` | |
| `analytics:export` | `report:export` | |
| `analytics:read` | `report:read` | |
| `approval:approve` | `publish:approve` | |
| `approval:reject` | `publish:approve` | |
| `approval:review` | `publish:approve` | |
| `benchmark:read` | `competitor:manage` | |
| `billing:manage` | `workspace:billing:manage` | |
| `billing:read` | `workspace:billing:read` | |
| `brand_deal:create` | `brand_deal:manage` | |
| `campaign:read` | `campaign:manage` | |
| `commerce:read` | `product:read` | |
| `competitor:read` | `competitor:read` | Read-only competitor data access (canonicalized — was incorrectly mapped to `competitor:manage`) |
| `connector:read` | `account:connect` | |
| `contact:export` | `report:export` | |
| `contact:manage` | `thread:triage` | |
| `contact:read` | `thread:read` | |
| `contact:update` | `thread:triage` | |
| `content:create` | `idea:create` | |
| `content:delete` | `script:delete` | |
| `content:edit` | `script:edit` | |
| `content:read` | `idea:read` | |
| `content:update` | `script:edit` | |
| `copilot:query` | `copilot:use_creative` | |
| `copilot:use_create` | `copilot:use_creative` | |
| `copilot:use_deep` | `copilot:use_analytics` | |
| `cost:read` | `profit:read` | |
| `coupon:manage` | `offer:manage` | |
| `coupon:read` | `offer:read` | |
| `dashboard:read` | `report:read` | |

| `engagement:read` | `thread:read` | |
| `engagement:reply` | `thread:reply` | |
| `evidence:read` | `evidence:read` | Read-only evidence access (canonicalized — was incorrectly mapped to `evidence:submit`) |
| `finance:manage` | `reconciliation:manage` | |
| `finance:proof` | `proof_bundle:read` | |
| `finance:read` | `profit:read` | |
| `finance:reconcile` | `reconciliation:manage` | |
| `finance:write` | `cost:manage` | |
| `gamification:read` | `analytics:read` | |

| `idea:delete` | `idea:create` | |
| `idea:generate` | `idea:create` | |
| `idea:update` | `idea:create` | |
| `inbox:manage` | `thread:triage` | |
| `inbox:read` | `thread:read` | |
| `inbox:reply` | `thread:reply` | |
| `inventory:manage` | `product:manage` | |
| `inventory:read` | `product:read` | |
| `inventory:write` | `product:manage` | |
| `live_session:manage` | `live:manage` | |
| `live_session:read` | `live:read` | |
| `media_kit:manage` | `media_kit:generate` | |
| `offer:create` | `offer:manage` | |
| `offer:delete` | `offer:manage` | |
| `offer:update` | `offer:manage` | |
| `offer:write` | `offer:manage` | |
| `order:contact_buyer` | `order:manage` | |
| `order:update` | `order:manage` | |
| `order:write` | `order:manage` | |
| `product:create` | `product:manage` | |
| `product:delete` | `product:manage` | |
| `product:update` | `product:manage` | |
| `profit:manage` | `profit:detailed_read` | |

| `publish:delete` | `publish:cancel` | |
| `publish:edit` | `publish:schedule` | |
| `publish:manage` | `publish:execute` | |
| `publish:update` | `publish:schedule` | |
| `read:analytics` | `report:read` | |
| `read:content` | `script:read` | |
| `read:finance` | `profit:read` | |
| `read:orders` | `order:read` | |
| `recipe:manage` | `recipe:install` | |
| `report:manage` | `report:export` | |
| `revenue:read` | `profit:read` | |
| `script:review` | `script:approve` | |
| `script:submit_review` | `script:edit` | |
| `script:update` | `script:edit` | |
| `seeding:manage` | `sample:manage` | |
| `seeding:read` | `sample:read` | |
| `settings:danger` | `workspace:delete` | |
| `settings:manage` | `workspace:settings:manage` | |

| `settings:update` | `workspace:settings:manage` | |
| `settings:write` | `workspace:settings:manage` | |
| `settlement:read` | `reconciliation:manage` | |
| `store:read` | `store:manage` | |
| `studio:manage` | `asset:generate` | |
| `studio:read` | `asset:read` | |
| `studio:use` | `asset:generate` | |
| `task:create` | `follow_up:manage` | |
| `trend:manage` | `trend:watchlist:manage` | |
| `use:enhance` | `copilot:use_creative` | |
| `use:inert` | `copilot:use_help` | |
| `workflow:execute` | `workflow:activate` | |
| `workflow:manage` | `workflow:edit` | |
| `workspace:manage` | `workspace:settings:manage` | |
| `write:content` | `script:edit` | |
| `write:publish` | `publish:execute` | |

## Cross-references

- **RBAC Matrix**: `04_contracts/rbac_permission_matrix.md` (canonical permission definitions)
- **Screen Index**: `03_screens/SCREEN_INDEX.md` (screen inventory)
- **Canonical Sources**: `00_index/CANONICAL_SOURCES.md`
