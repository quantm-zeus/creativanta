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
| `workspace:billing:manage` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `workspace:delete` | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| `account:connect` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `account:disconnect` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |

### 2.2 Intelligence (M02-M04)

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `trend:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `trend:watchlist:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `competitor:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
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

### 2.6 Engagement (M12)

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `thread:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `thread:triage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `thread:reply` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `thread:assign` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `follow_up:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

### 2.7 Commerce (M13-M16)

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `product:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `product:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `offer:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `offer:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `order:read` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `order:manage` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `campaign:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `affiliate:manage` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `store:manage` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

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
| `proof_bundle:read` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

### 2.9 Workflow & Agent (M20-M21)

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `workflow:read` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `workflow:create` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `workflow:edit` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `workflow:activate` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `workflow_run:approve` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `recipe:install` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `agent:execute` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
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
| `rate_card:read` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `rate_card:manage` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `brand_deal:read` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `brand_deal:manage` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

### 2.14 Copilot & AI (§34)

| Permission | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| `copilot:use_creative` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `copilot:use_analytics` | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| `copilot:use_action` | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| `copilot:use_help` | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| `credits:view_balance` | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| `credits:top_up` | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |

---

## 3. Internal Admin RBAC (S26 — Separate System)

> **Important**: Internal admin RBAC is completely isolated from workspace RBAC. Uses separate auth, separate JWT, VPN-only access.

### 3.1 Admin Roles (4)

| Role | Scope | Description |
|---|---|---|
| **Super Admin** | Platform | Full access to all admin functions + destructive actions |
| **Operations Admin** | Platform | User/workspace management, billing, support queue |
| **Content Admin** | Platform | Moderation, content review, fraud investigation |
| **Tech Admin** | Platform | System health, incidents, feature flags, queues |

### 3.2 Admin Permission Matrix

| Permission | Super | Ops | Content | Tech |
|---|---|---|---|---|
| `admin:user:suspend` | ✅ | ✅ | ❌ | ❌ |
| `admin:user:delete` | ✅ | ❌ | ❌ | ❌ |
| `admin:credits:adjust` | ✅ | ✅ | ❌ | ❌ |
| `admin:plan:override` | ✅ | ✅ | ❌ | ❌ |
| `admin:refund:issue` | ✅ | ✅ | ❌ | ❌ |
| `admin:impersonate` | ✅ | ✅ | ❌ | ❌ |
| `admin:moderation:manage` | ✅ | ❌ | ✅ | ❌ |
| `admin:fraud:investigate` | ✅ | ❌ | ✅ | ❌ |
| `admin:support:manage` | ✅ | ✅ | ❌ | ❌ |
| `admin:incident:manage` | ✅ | ❌ | ❌ | ✅ |
| `admin:feature_flag:toggle` | ✅ | ❌ | ❌ | ✅ |
| `admin:announcement:publish` | ✅ | ✅ | ❌ | ❌ |
| `admin:maintenance:toggle` | ✅ | ❌ | ❌ | ✅ |
| `admin:queue:manage` | ✅ | ❌ | ❌ | ✅ |
| `admin:audit_log:read` | ✅ | ✅ | ✅ | ✅ |

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

## 5. Implementation (Rust Tower Middleware)

```rust
pub struct Permission {
    pub domain: &'static str,
    pub resource: &'static str,
    pub action: &'static str,
}

impl Permission {
    pub fn key(&self) -> String {
        format!("{}:{}:{}", self.domain, self.resource, self.action)
    }
}

// Tower middleware checks: JWT → workspace_id → role → permission
pub async fn check_permission(
    role: &str,
    permission: &Permission,
) -> Result<(), AuthError> {
    let allowed = PERMISSION_MATRIX
        .get(role)
        .and_then(|perms| perms.get(&permission.key()))
        .copied()
        .unwrap_or(false);
    
    if !allowed {
        return Err(AuthError::Forbidden(permission.key()));
    }
    Ok(())
}
```

**Workspace RBAC**: ~105 permission keys × 7 roles = full matrix.
**Admin RBAC**: ~15 permission keys × 4 admin roles = full admin matrix.
