# Screen: Admin — Subscription Override

> **Screen ID**: A037
> **Module**: S26 — Internal Admin, Billing & Revenue
> **Route**: `/admin/subscriptions/overrides`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: A1 Schema (`workspaces`, `subscription_events`, `invoices`, `payment_methods`), A3 API (`AdminService/OverridePlan`, `AdminBillingService/GetBillingSummary`, `AdminConfigService/GetPricing`), B5 RBAC §3

---
## 1. Purpose & Context

Controlled override surface for temporary plan changes, grace periods, commercial concessions, manual tier migrations, and override audit review. This screen owns write-path plan overrides that are only quick actions elsewhere.

### Entry Points
- A004 Workspace List → "Upgrade plan"
- A021 Subscriptions → billing issue row
- A003 User Detail → plan override shortcut

### Exit Points
- Back to A021 Subscriptions
- Workspace detail A005 with override badge

---
## 2. Preconditions / Postconditions

### Preconditions
- Role: Super Admin, Operations Admin, or Finance Admin
- MFA verified

### Postconditions
- Override written via `AdminService/OverridePlan`
- `workspaces.subscription_tier` and billing projections refreshed
- Reason, actor, start/end time, and reversal plan audit-logged

---
## 3. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Workspace billing summary | `workspaces`, `subscription_events`, `invoices` | `AdminBillingService/GetBillingSummary` | Summary card | No cache |
| Plan catalog | Pricing config | `AdminConfigService/GetPricing` | Plan cards with limits | 30m TTL |
| Override history | `subscription_events` filtered to overrides | `AdminBillingService/GetBillingSummary` | Timeline rows | No cache |

---
## 4. User Actions

| # | Action | Trigger | API Call | Result | Permission |
|---|---|---|---|---|---|
| 1 | Start override | Submit override form | `AdminService/OverridePlan` | Workspace plan updated | `admin:plan:override` |
| 2 | Extend grace period | Quick action | `AdminService/OverridePlan` | End date extended | `admin:plan:override` |
| 3 | Revert to canonical plan | Row action | `AdminService/OverridePlan` | Plan reverts at selected timestamp | `admin:plan:override` |
| 4 | Export override log | Click export | `AdminBillingService/GetBillingSummary` | CSV download | `admin:report:export` |

---
## 5. Validation Rules

| Field | Rule | Error |
|---|---|---|
| Reason | Required, 15+ chars | "Override reason is required" |
| Duration | Required unless permanent migration | "Select an expiry date or mark as permanent" |
| Target plan | Must exist in pricing config | "Select a valid plan" |
| Grace extension | Max 30 days without Super Admin | "Long grace periods require Super Admin" |

---
## 6. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching workspace/pricing | Form skeleton |
| READY | No active override | Empty override form |
| ACTIVE_OVERRIDE | Workspace has active manual plan | Highlighted override banner |
| EXPIRING_SOON | Override expires < 72h | Amber warning |
| ERROR | Apply/revert failed | Inline error + retry |

---
## 7. Related Screens

| Screen | Relationship |
|---|---|
| [screen_admin_subscriptions.md](screen_admin_subscriptions.md) | Parent billing overview |
| [screen_admin_workspace_list.md](screen_admin_workspace_list.md) | Workspace quick actions |

---
## 8. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-04-06 | 1.0 | Created to resolve missing dedicated subscription override surface and separate quick-action behavior from canonical override workflow. | System |
