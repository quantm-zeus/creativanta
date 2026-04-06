# Screen: Admin — Email Campaign Manager

> **Screen ID**: A035
> **Module**: S26 — Internal Admin & Communications
> **Route**: `/admin/notifications/campaigns`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: A1 Schema (`broadcasts`, `broadcast_targets`, `notification_events`), A3 API (`AdminBroadcastService/*`), B5 RBAC §3

---
## 1. Purpose & Context

Email-first broadcast management surface for lifecycle emails, maintenance campaigns, targeted feature launches, and delivery analytics. This is the operational companion to A027 Notification Broadcast, optimized for email scheduling and CTR analysis.

### Entry Points
- A027 Notification Broadcast → "Open email campaign mode"
- A031 Incident Manager → "Notify affected users"
- A021 Subscriptions → "Send billing follow-up"

### Exit Points
- Back to A027 Notification Broadcast
- Broadcast row → detail drawer with delivery analytics

---
## 2. Preconditions / Postconditions

### Preconditions
- Role: Super Admin or Operations Admin
- VPN + MFA active

### Postconditions
- Draft/scheduled campaign persisted to `broadcasts`
- Audience expansion persisted to `broadcast_targets`
- Delivery/read/click metrics streamed via `notification_events`
- Audit entry written for send, cancel, or send-now actions

---
## 3. Layout

```text
Campaign list + filters (status, audience, date) on the left.
Selected campaign detail on the right with subject, content preview, schedule,
reach estimate, CTR trend, bounce/failure breakdown, and quick actions.
```

---
## 4. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Campaign list | `broadcasts WHERE channels includes email` | `AdminBroadcastService/ListHistory` | Sortable table | No cache |
| Scheduled list | `broadcasts WHERE status='scheduled'` | `AdminBroadcastService/ListScheduled` | Card list | No cache |
| Reach estimate | `broadcast_targets` projection | `AdminBroadcastService/EstimateReach` | Workspace/user counts | No cache |
| Delivery analytics | `notification_events` | `AdminBroadcastService/ListHistory` | Delivered/open/click/fail metrics | 5m TTL |

---
## 5. User Actions

| # | Action | Trigger | API Call | Result | Permission |
|---|---|---|---|---|---|
| 1 | Preview email | Click preview | `AdminBroadcastService/PreviewEmail` | Email rendering modal | `admin:announcement:publish` |
| 2 | Send test | Click test | `AdminBroadcastService/SendTest` | Test email to current admin | `admin:announcement:publish` |
| 3 | Schedule campaign | Click schedule | `AdminBroadcastService/Schedule` | Status → scheduled | `admin:announcement:publish` |
| 4 | Send now | Scheduled row action | `AdminBroadcastService/SendNow` | Immediate delivery begins | `admin:announcement:publish` |
| 5 | Cancel | Scheduled row action | `AdminBroadcastService/Cancel` | Campaign removed from schedule | `admin:announcement:publish` |

---
## 6. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching campaigns | Table skeleton |
| DRAFT | Campaign not scheduled | Editable form |
| SCHEDULED | Future send time set | Countdown badge |
| SENDING | Delivery in progress | Progress indicator |
| SENT | Completed send | Metrics panel active |
| ERROR | Delivery or API failure | Retry banner |

---
## 7. Related Screens

| Screen | Relationship |
|---|---|
| [screen_admin_notifications.md](/Users/quantm/Documents/My Projects/creativanta/docs/03_screens/admin/screen_admin_notifications.md) | General broadcast composer |
| [screen_admin_subscriptions.md](/Users/quantm/Documents/My Projects/creativanta/docs/03_screens/admin/screen_admin_subscriptions.md) | Billing-lifecycle campaigns |

---
## 8. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-04-06 | 1.0 | Created to resolve missing S26 email campaign management surface using canonical broadcast contracts. | System |
