---
layer: contracts
canonical: true
source_file: impl_b5_rbac_permission_matrix.md
last_verified: 2026-03-30
known_issues:
  - none
do_not_edit_without: Đọc 00_index/OPEN_BLOCKERS.md trước khi sửa
last_updated: 2026-10-30
---

## Quick Navigation

| Section | Content |
|---|---|
| §1 Permission Key Format | `{domain}:{resource}:{action}` pattern |
| §2.1 Workspace & Identity | workspace:settings, workspace:members, workspace:billing, account:connect |
| §2.2 Intelligence (M02-M04) | trend:read, opportunity:create/assign/convert, competitor:manage |
| §2.3 Content (M05-M06) | idea:read/create/convert, script:read/create/edit/approve/delete |
| §2.4 AI Production (M07-M09) | asset:read/generate/approve/promote_canonical, character:manage, continuity:pack_manage |
| §2.5 Publish (M10-M11) | publish:read/create/schedule/execute/approve/retry/cancel |
| §2.6 Engagement (M12) | thread:read/triage/reply/assign, follow_up:manage |
| §2.7 Commerce (M13-M16) | product/offer/order/campaign/affiliate/store permissions |
| §2.8 Finance (M19) | profit:read, cost:manage, settlement:import, reconciliation:manage/override, evidence:submit |
| §2.9 Workflow (M20-M21) | workflow:read/create/edit/activate, recipe:install, agent:execute/approve |
| §2.10 Admin (M22-M23) | report:read/export, diagnostics:read, admin:audit_log, capability:read |
| §2.11 Live Commerce (M17) | live:read/manage/start_stop/cue_action/highlight |
| §2.12 Seeding (M18) | sample:read/manage, creator_assignment:manage |
| §2.13 Creator Pro (S16) | link_in_bio, media_kit, rate_card, brand_deal permissions |
| §2.14 Growth & Analytics | gamification, referral, promotion, coach permissions |
| §2.15 Copilot & AI | copilot:use_creative/analytics/action/video_production/help, credits:view_balance/top_up |
| §3 Internal Admin RBAC | 8 admin roles: Super, Ops, Finance, Content, Support, Tech, Analyst, Auditor (~20 permission keys) |
| §4 Constraint Rules | External Collaborator, Contributor constraints, Approval-Required Actions |
| §5 Implementation | Go HTTP middleware / Connect interceptors pattern |

# B5 — RBAC Permission Matrix

> **Upstream**: Product Freeze §43, Pack 08 §8, S26 §8
> **7 Canonical Roles**: Owner, Admin, Manager, Editor, Contributor, Viewer, External Collaborator

---

## 1. Permission Key Format

```
{domain}:{resource}:{action}
```
Example: `content:script:approve`, `commerce:order:read`, `admin:billing:manage`

---

## 2. Core Permission Matrix

### Legend
- ✅ = Allowed
- ⚠️ = Allowed with constraints
- ❌ = Denied

### 2.1 Workspace & Identity

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `workspace:settings:manage` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `workspace:members:invite` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `workspace:members:remove` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `workspace:roles:assign` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `workspace:billing:manage` | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `workspace:billing:read` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `workspace:delete` | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `account:connect` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `account:disconnect` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |

### 2.2 Intelligence (M02-M04)

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `trend:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `trend:watchlist:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `competitor:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `competitor:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `opportunity:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `opportunity:create` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `opportunity:assign` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `opportunity:convert` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

### 2.3 Content Creation (M05-M06)

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `idea:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ |
| `idea:create` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `idea:convert` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `script:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ |
| `script:create` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `script:edit` | ✅ | ✅ | ✅ | ✅ | ⚠️ | ❌ | ❌ |
| `script:approve` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `script:delete` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

### 2.4 AI Production (M07-M09)

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `asset:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ |
| `asset:generate` | ✅ | ✅ | ✅ | ✅ | ⚠️ | ❌ | ❌ |
| `asset:approve` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `asset:promote_canonical` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `asset:delete` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `character:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `continuity:pack_manage` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `derivative:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `voice_clone:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `voice_clone:manage` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `voice_clone:delete` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `sound:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `sound:generate` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `production_job:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `production_job:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `style_pack:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `style_pack:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `style_pack:delete` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `translation:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `translation:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `repurpose:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `repurpose:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

> **Audit v8**: VoiceClone, SoundStudio, ProductionJob, StylePack, Translation, Repurpose permissions added to cover Extended Production RPCs (api_endpoint_map.md §15-§20). Auth levels match the API spec.

### 2.5 Publish (M10-M11)

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `publish:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `publish:create` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `publish:schedule` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `publish:execute` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `publish:approve` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `publish:retry` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `publish:cancel` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `packaging:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `packaging:score` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `packaging:override` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

### 2.6 Engagement (M12)

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `thread:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `thread:triage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `thread:reply` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `thread:assign` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `follow_up:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

> Capability rule: RBAC grants authorization only. Actual reply execution still depends on connector capability state in `connector_specs.md`; platforms such as Instagram DM and TikTok DM can remain read-only/manual even when `thread:reply` is granted.

### 2.7 Commerce (M13-M16)

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `product:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `product:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `product:delete` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `product:import` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `offer:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `offer:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `offer:activate` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `order:read` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `order:manage` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `campaign:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `campaign:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `coupon:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `coupon:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `affiliate:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `affiliate:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `store:manage` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `membership:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `membership:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `offer:price_change` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `refund:read` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `refund:manage` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `showcase:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `showcase:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `link_to_video:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `link_to_video:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `ab_test:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `ab_test:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `ab_test:declare_winner` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

### 2.8 Finance & Proof (M19)

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `profit:read` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `profit:detailed_read` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `cost:manage` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `settlement:import` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `reconciliation:manage` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `reconciliation:override` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `evidence:submit` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `evidence:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `proof_bundle:read` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

### 2.9 Workflow & Agent (M20-M21)

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `workflow:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `workflow:create` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `workflow:edit` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `workflow:activate` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `workflow_run:approve` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `recipe:install` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `agent:execute` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `agent:approve` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

### 2.10 Admin & System (M22-M23)

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `report:read` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `report:export` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `diagnostics:read` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `admin:audit_log:read` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `admin:override` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `capability:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |

### 2.11 Live Commerce (M17)

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `live:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `live:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `live:start_stop` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `live:cue_action` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `live:highlight` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

### 2.12 Seeding/Sample CRM (M18)

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `sample:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `sample:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `creator_assignment:manage` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

### 2.13 Creator Pro Tools (S16)

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `link_in_bio:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `link_in_bio:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `media_kit:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ⚠️ |
| `media_kit:generate` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `media_kit:publish` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `rate_card:read` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `rate_card:manage` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `brand_deal:read` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `brand_deal:manage` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

### 2.14 Growth & Analytics (Gamification, Referral, Promotions, Coach)

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `gamification:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `gamification:share` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `referral:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `referral:claim` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `promotion:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `promotion:redeem` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `coach:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `coach:generate_plan` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

### 2.15 Copilot & AI (§34)

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `copilot:use_creative` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `copilot:use_analytics` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `copilot:use_action` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `copilot:use_video_production` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `copilot:use_help` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `credits:view_balance` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `credits:top_up` | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |

---


### 2.16 Explicit utility and projection permissions (2026-10-29)

All remain subject to object/user scope. user:self and support:own never grant access to another user's data. Read permission never authorizes the corresponding write.

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `user:self` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| `workspace:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `account:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `file:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `file:manage` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `entity:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `entity:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `task:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `task:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `store:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `cost:read` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `settlement:read` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `reconciliation:read` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `proof_bundle:assemble` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `api_key:manage` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `support:own` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

---

## 3. Internal Admin RBAC (S26 — Separate System)

> **Important**: Internal admin RBAC is completely isolated from workspace RBAC. Uses separate auth, separate JWT, VPN-only access.

### 3.1 Admin Roles (8)

| Role | Scope | Description |
|---|---|---|
| **Super Admin** | Platform | Full access to all admin functions + destructive actions |
| **Operations Admin** | Platform | User/workspace management, billing, support queue |
| **Finance Admin** | Platform | Billing, credits, refunds, revenue analytics, fee schedules |
| **Content Admin** | Platform | Moderation, content review, fraud investigation |
| **Support Admin** | Platform | Support ticket management, user communication, escalation |
| **Tech Admin** | Platform | System health, incidents, feature flags, queues |
| **Analyst** | Platform | Read-only analytics, reporting, dashboards (no write) |
| **Auditor** | Platform | Read-only audit logs, compliance checks, export (no write) |

### 3.2 Admin Permission Matrix

| Permission | Super | Ops | Finance | Content | Support | Tech | Analyst | Auditor |
|---|---|---|---|---|---|---|---|---|
| `admin:user:suspend` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `admin:user:delete` | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `admin:credits:adjust` | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `admin:plan:override` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `admin:refund:issue` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `admin:impersonate` | ✅ | ✅ | ❌ | ❌ | ⚠️ | ❌ | ❌ | ❌ |
| `admin:moderation:manage` | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `admin:fraud:investigate` | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `admin:support:manage` | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |
| `admin:incident:manage` | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| `admin:feature_flag:toggle` | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| `admin:announcement:publish` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `admin:maintenance:toggle` | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| `admin:queue:manage` | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| `admin:audit_log:read` | ✅ | ✅ | ✅ | ✅ | ⚠️ | ✅ | ✅ | ✅ |
| `admin:analytics:read` | ✅ | ✅ | ✅ | ❌ | ❌ | ✅ | ✅ | ✅ |
| `admin:billing:read` | ✅ | ✅ | ✅ | ❌ | ⚠️ | ❌ | ✅ | ✅ |
| `admin:fee_schedule:manage` | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `admin:report:export` | ✅ | ✅ | ✅ | ❌ | ❌ | ✅ | ✅ | ✅ |
| `admin:compliance:read` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ✅ |
| `admin:user:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| `admin:workspace:read` | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ | ✅ | ✅ |
| `admin:commerce:read` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ |

> **Constraints**: Analyst and Auditor are read-only roles. Support Admin impersonation is read-only mode only (no OTP override). ⚠️ = scoped access (e.g., Support Admin sees billing status but not amounts).

---


### 3.3 Explicit administration operations (2026-10-29)

| Permission | Super | Ops | Finance | Content | Support | Tech | Analyst | Auditor |
|---|---|---|---|---|---|---|---|---|
| `admin:config:manage` | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| `admin:users:manage` | ✅ | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ | ❌ |
| `admin:admins:manage` | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `admin:ai:manage` | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| `admin:alerts:manage` | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |

---

## 4. Constraint Rules

### External Collaborator Constraints
- Can only access resources explicitly shared with them
- Read-only for ideas/scripts marked `shared_externally = true`
- Cannot see financial data, orders, or profit
- Cannot execute any write actions without explicit share grant

### Contributor Constraints
- Can create content (ideas, scripts) but cannot approve
- Can generate assets but limited by daily credit quota
- Cannot access financial details or commerce management

### Approval-Required Actions (Policy Override)
These actions require approval regardless of role when policy is active:
- `publish:execute` on business-critical platforms
- `offer:price_change` on active offers
- `reconciliation:override`
- `workflow:activate` with financial side effects
- `admin:override` always requires reason + audit

---

## 5. Implementation (Go Middleware and Connect Interceptors)

```go
// Binding lookup uses the exact key in rpc_permission_bindings.csv.
// The policy checker resolves membership from authenticated server context.
type PermissionChecker interface {
    Require(ctx context.Context, rpc string, objectID string) error
}

// Illustrative handler sequence, not a complete authorization implementation:
// 1. Verify Clerk session/JWT; resolve current membership and workspace.
// 2. Resolve RPC binding; check named permission and object scope.
// 3. Check plan/tier, approval and current capability before mutation.
// 4. Run domain work + audit/outbox through the same tenant transaction.
// Deny missing bindings/unknown permission keys; never infer a key by
// concatenating domain/resource/action (canonical keys have varied lengths).
// Internal-admin identity and permissions remain a separate trust boundary.
```

**Workspace RBAC**: ~150 permission keys × 7 roles = full matrix.
**Admin RBAC**: ~23 permission keys × 8 admin roles = full admin matrix.

> **Audit v5 — C2 Fix**: `workspace:billing:manage` is Owner-only (non-delegatable, aligned to Freeze §46A.4 and Pack 02 §S07.2). `workspace:billing:read` added for Admin and Manager view access. Previous versions had a conflict where B5 allowed Admin billing manage but Pack 02 §S07.2 restricted it to Owner.

> **Reconciliation: Finance Role → Manager Merge** (Legacy Pricing §8): The original pricing contract defined a separate "Finance" workspace role with permissions for `settlement:import`, `reconciliation:manage`, and `profit:detailed_read`. Per Freeze §46A.4 reconciliation, this role was merged into "Manager" with these specific permissions elevated to Admin-only scope. See §2.8 Finance & Proof — `settlement:import` and `reconciliation:manage/override` require Admin+. This merge is intentional and canonical.
