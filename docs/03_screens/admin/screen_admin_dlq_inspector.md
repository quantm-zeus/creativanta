# Screen: Admin — DLQ Inspector

> **Screen ID**: A036
> **Module**: S26 — Internal Admin & Operations
> **Route**: `/admin/jobs/dlq`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: A1 Schema (`dead_letter_queue`, `background_jobs`), A3 API (`AdminJobService/ListDLQ`, `AdminJobService/GetDLQItem`, `AdminJobService/RetryDLQItem`, `AdminJobService/PurgeDLQItem`), B5 RBAC §3

---
## 1. Purpose & Context

Standalone review surface for dead-lettered jobs that require manual triage, replay, or discard. This separates long-tail operational cleanup from the broader A008 Job Monitor.

### Entry Points
- A008 Job Monitor → DLQ tab "Open dedicated inspector"
- Alert center → dead-letter queue alert
- Incident timeline → linked DLQ item

### Exit Points
- Back to A008 Job Monitor
- Workspace link → A005 Workspace Detail

---
## 2. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| DLQ list | `dead_letter_queue` | `AdminJobService/ListDLQ` | Filterable table | No cache |
| Item detail | `dead_letter_queue` + related `background_jobs` | `AdminJobService/GetDLQItem` | Drawer with payload + retry history | No cache |
| Queue summary | `dead_letter_queue` aggregation | `AdminJobService/ListDLQ` | Count badges by queue/status | 30s TTL |

---
## 3. User Actions

| # | Action | Trigger | API Call | Result | Permission |
|---|---|---|---|---|---|
| 1 | Open item detail | Click row | `AdminJobService/GetDLQItem` | Detail drawer opens | `admin:queue:manage` |
| 2 | Retry item | Click "Retry" | `AdminJobService/RetryDLQItem` | New background job queued | `admin:queue:manage` |
| 3 | Purge item | Click "Discard" | `AdminJobService/PurgeDLQItem` | Status → discarded | `admin:queue:manage` |
| 4 | Filter by queue or error class | Use filter bar | `AdminJobService/ListDLQ` | Table filtered | `admin:queue:manage` |

---
## 4. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching DLQ list | Table skeleton |
| EMPTY | No DLQ items | Success empty state |
| ITEMS_PRESENT | Pending/retrying items exist | Queue summary + table |
| RETRYING | Retry in progress | Inline spinner on row |
| ERROR | API error | Retry banner |

---
## 5. Validation Rules

| Action | Rule | Error |
|---|---|---|
| Retry item | Only `pending` or `retrying` items | "This item is no longer retryable" |
| Purge item | Resolution note required for `attempt_count >= max` | "Add discard rationale" |

---
## 6. Related Screens

| Screen | Relationship |
|---|---|
| [screen_admin_job_monitor.md](/Users/quantm/Documents/My Projects/creativanta/docs/03_screens/admin/screen_admin_job_monitor.md) | Parent job monitor |
| [screen_admin_incident_manager.md](/Users/quantm/Documents/My Projects/creativanta/docs/03_screens/admin/screen_admin_incident_manager.md) | Incident escalation |

---
## 7. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-04-06 | 1.0 | Created to resolve missing dedicated DLQ surface and anchor dead-letter operations to canonical queue contracts. | System |
