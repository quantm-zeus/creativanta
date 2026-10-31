# Screen: Admin — Connector Debug

> **Screen ID**: A033
> **Module**: S26 — Internal Admin & Operations
> **Route**: `/admin/platforms/[provider]/debug`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: A1 Schema (`connected_accounts`, `platform_health_scores`, `webhook_events`, `background_jobs`), A3 API (`ConnectorService/GetDebugLog`, `ConnectorService/ListWebhookDeliveries`, `ConnectorService/TestConnection`, `ConnectorService/ReplayWebhookDelivery`), B5 RBAC §3

---
## 1. Purpose & Context

Deep-dive diagnostic workspace for a single connector provider or connected account. This screen is used after A007 Platform Monitor identifies degradation, token expiry, sync backlog, or webhook failures.

### Entry Points
- A007 Platform Monitor → click provider card or "View all errors"
- A008 Job Monitor → filtered job row for connector queues
- A031 Incident Manager → linked provider incident timeline

### Exit Points
- Back to A007 Platform Monitor
- Account row → workspace detail A005
- "Open incident" → A031 Incident Manager pre-filled with provider context

---
## 2. Preconditions / Postconditions

### Preconditions
- VPN + internal admin auth verified
- Role: Super Admin, Operations Admin, or Tech Admin
- Provider or connected account selected in route params

### Postconditions
- Any replay/test action logged to `internal_audit_logs`
- Webhook replay or connection test produces immutable debug entry
- Manual actions never mutate customer data beyond connector sync/job state

---
## 3. Screen Layout

### ASCII Wireframe
```text
┌─ Admin Shell ───────────────────────────────────────────────────────────┐
│ ← Platform Monitor / TikTok / Debug          [Test connection] [Replay]│
├─────────────────────────────────────────────────────────────────────────┤
│ Health: 🟡 Degraded  Last sync: 5m ago  Token expiry: 3d  Rate: 89%   │
│                                                                         │
│ Tabs: [Timeline] [Webhook Deliveries] [Sync Jobs] [Token & Scopes]      │
│                                                                         │
│ ┌─ Timeline ─────────────────────────────────────────────────────────┐  │
│ │ 10:42  ⚠ token_refresh_failed     acct_123 · invalid_grant       │  │
│ │ 10:39  🔄 order_sync_retry         ws_demo · attempt 2/3          │  │
│ │ 10:31  📥 webhook_received         orders.updated · 200 OK         │  │
│ └────────────────────────────────────────────────────────────────────┘  │
│                                                                         │
│ ┌─ Webhook Deliveries ──────────────────────────────────────────────┐  │
│ │ event_id │ topic          │ status │ latency │ idempotency │ act │  │
│ │ wh_...   │ orders.updated │ failed │ 5.2s    │ idem_...    │ ↻   │  │
│ └────────────────────────────────────────────────────────────────────┘  │
│                                                                         │
│ ┌─ Token & Scopes ──────────────────────────────────────────────────┐  │
│ │ Access token: expiring in 3d  Refresh: ✅  Scopes missing: none   │  │
│ │ Connected accounts: 1,234  Degraded: 23  Requires reauth: 12     │  │
│ └────────────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```text
ConnectorDebugPage
├── AdminShell
├── PageHeader
│   ├── Breadcrumbs
│   ├── TestConnectionButton
│   └── ReplayLatestFailureButton
├── ProviderSummary
│   ├── HealthBadge
│   ├── LastSyncStat
│   ├── RateLimitStat
│   └── TokenExpiryStat
├── TabBar
│   ├── TimelineTab
│   ├── WebhookTab
│   ├── SyncJobsTab
│   └── TokenTab
├── TimelineList
├── WebhookDeliveryTable
├── SyncJobsTable
└── TokenPanel
```

---
## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Provider summary | `connected_accounts`, `platform_health_scores` | `ConnectorService/GetAllStatus` | Health badges + counts | 30s TTL |
| Debug timeline | Connector debug projection from `webhook_events` + `background_jobs` | `ConnectorService/GetDebugLog` | Reverse chronological timeline | No cache |
| Webhook deliveries | `webhook_events WHERE provider=:provider` | `ConnectorService/ListWebhookDeliveries` | Table rows with status/latency | No cache |
| Sync job failures | `background_jobs WHERE queue_name LIKE provider%` | `ConnectorService/GetDebugLog` | Job rows with attempt/error | No cache |
| Token health | `connected_accounts` token metadata | `ConnectorService/GetTokenStatus` | Expiry, scope checklist | 1m TTL |

---
## 6. User Actions

| # | Action | Trigger | API Call | Result | Permission |
|---|---|---|---|---|---|
| 1 | Test connection | Click "Test connection" | `ConnectorService/TestConnection` | Non-mutating health check result drawer | `admin:workspace:read` |
| 2 | Replay failed webhook | Row action ↻ | `ConnectorService/ReplayWebhookDelivery` | New webhook event enqueued + toast | `admin:queue:manage` |
| 3 | Refresh token | Click "Refresh token" | `ConnectorService/RefreshToken` | Token status updates | `admin:queue:manage` |
| 4 | Force sync | Click "Force sync" | `ConnectorService/ForceSync` | Background job created | `admin:queue:manage` |
| 5 | Open incident | Click "Open incident" | `AdminIncidentService/Create` | Incident draft pre-filled | `admin:incident:manage` |

---
## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Summary skeleton + table placeholders |
| HEALTHY | No recent failures | Green summary, empty-state success card |
| DEGRADED | Failures or token risk present | Yellow banner with top issues |
| WEBHOOK_FAILURE | Failed deliveries exist | Red badge on Webhook tab |
| TOKEN_EXPIRING | Expiry < 7 days | Amber token warning |
| ERROR | API failure | Inline error with retry |

---
## 8. Permission Matrix

| Action | Super | Ops | Tech | Support | Analyst |
|---|---|---|---|---|---|
| View debug data | ✅ | ✅ | ✅ | ⚠️ read-only | ✅ |
| Replay delivery | ✅ | ✅ | ✅ | ❌ | ❌ |
| Force sync / refresh token | ✅ | ✅ | ✅ | ❌ | ❌ |
| Open incident | ✅ | ❌ | ✅ | ❌ | ❌ |

---
## 9. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Provider unavailable | Connector API hard down | Banner with incident CTA | Open incident / retry later |
| Replay rejected | Idempotency lock active | Toast: "Delivery already replayed recently" | Wait 5 minutes |
| Token refresh failed | OAuth revoked | Red token card + reauth note | Notify workspace admin |
| Debug log fetch failed | 5xx | Inline error state | Retry |

---
## 10. Related Screens

| Screen | Relationship |
|---|---|
| [screen_admin_platform_monitor.md](screen_admin_platform_monitor.md) | Parent provider monitor |
| [screen_admin_job_monitor.md](screen_admin_job_monitor.md) | Sync job queue context |
| [screen_admin_incident_manager.md](screen_admin_incident_manager.md) | Escalation target |

---
## 11. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-04-06 | 1.0 | Created to resolve missing S26 connector debug coverage and bind admin debug flows to canonical connector/job/webhook contracts. | System |
