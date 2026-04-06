# Screen: Admin — System Health

> **Screen ID**: A006
> **Module**: S26 — Core Operations
> **Route**: `/admin/health`
> **Platform**: Admin Web (SvelteKit) — VPN-only
> **Upstream**: A1 Schema (`diagnostics_records`, `platform_health_metrics`, `system_alerts`, `background_jobs`), A3 API (`AdminService/GetSystemHealth`, `AdminAlertService/GetActive`, `AdminJobService/GetQueueStats`), B5 RBAC §3

---

## 1. Purpose & Context
Real-time system health dashboard — all services status, resource usage, alerts, and operational KPIs. Auto-refresh every 30 seconds.
### Entry Points - Admin sidebar: "❤️ Health" / Alert: "🔴 Service down"
### Exit Points - Click service → detail / Click alert → investigation

---

## 2. Screen Layout
### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ ❤️ System Health                     Overall: 🟢 All OK  [🔄 30s] │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Service Grid ────────────────────────────────────────────────┐   │
│ │ SvelteKit App  🟢 OK     3ms    99.99%   0 errors             │   │
│ │ Rust API       🟢 OK     5ms    99.98%   0 errors             │   │
│ │ PostgreSQL     🟢 OK     2ms    100%     0 errors             │   │
│ │ Dragonfly      🟢 OK     <1ms   100%     0 errors             │   │
│ │ Meilisearch    🟢 OK     8ms    100%     0 errors             │   │
│ │ TikTok API     🟢 OK     120ms  99.8%    0 errors             │   │
│ │ Shopee API     🟡 WARN   350ms  98.2%    23 errors            │   │
│ │ OpenAI         🟢 OK     450ms  99.1%    0 errors             │   │
│ │ File Storage   🟢 OK     45ms   99.9%    0 errors             │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Resources ───────────────────────────────────────────────────┐   │
│ │ CPU: 35% ████░░░░░░ · RAM: 62% ██████░░░░ · Disk: 45%       │   │
│ │ DB connections: 45/100 · Redis keys: 12K · Search docs: 145K │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Active Alerts ───────────────────────────────────────────────┐   │
│ │ 🟡 Shopee API high latency (350ms > 200ms threshold) · 30m   │   │
│ │ [📋 Investigate] [✅ Acknowledge]                              │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Uptime (30d) ────────────────────────────────────────────────┐   │
│ │ Overall: 99.95% · Incidents: 2 · MTTR: 15 min                │   │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```
## 7. States
| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Shimmer |
| ALL_HEALTHY | Everything green | "🟢 All systems operational" |
| DEGRADED | Warnings present | "🟡 Degraded — {n} warnings" |
| CRITICAL | Service(s) down | "🔴 Critical — {n} services require attention" |
| ERROR | Health check failed | Error with retry |

---

## 2. Preconditions / Postconditions
### Preconditions
- Admin user with appropriate S26 role
- VPN connection active
### Postconditions
- All actions logged in audit trail
- State changes reflected in real-time

---

## 4. Component Hierarchy
```text
SystemHealthPage
├── AdminShell
├── PageHeader
├── ServiceGrid
├── ResourcePanel
├── ActiveAlertsPanel
└── UptimeSummary
```

---

## 5. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Service grid | `platform_health_metrics`, `diagnostics_records` | `AdminService/GetSystemHealth` | Latency/uptime/error tiles | 30s TTL |
| Active alerts | `system_alerts` | `AdminAlertService/GetActive` | Severity rows | No cache |
| Queue pressure | `background_jobs` aggregation | `AdminJobService/GetQueueStats` | Queue lag + workers | 30s TTL |
| Resource usage | Infra health projection | `AdminService/GetSystemHealth` | CPU/RAM/Disk bars | 30s TTL |


---
## 19. Related Screens
| Screen | Relationship |
|---|---|
| [A008] Job Monitor | Background jobs |
| [A007] Platform Monitor | Platform integrations |
| [A025] Error Analytics | Error analysis |
---
## Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached data | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được dữ liệu. [Thử lại]" | Retry |
| Not found | 404 | "Không tìm thấy" → navigate back | Back |
| Permission denied | 403 | "Không có quyền truy cập" | Contact admin |

---
## Accessibility

| Element | Requirement |
|---|---|
| Interactive elements | Minimum 48×48dp tap targets |
| Icons with meaning | `Semantics(label:)` descriptive text |
| Status indicators | Color not sole indicator; text/icon also present |
| Dynamic content | `Semantics(liveRegion: true)` for updates |
| Contrast | 4.5:1 minimum ratio |

---
## Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + shimmer placeholders |
| Primary data | 200-500ms | Content populates progressively |
| User action | <1s | Inline spinner → result feedback |

---
## Localization Notes

- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator: "1.200.000đ")
- Date: DD/MM/YYYY
- Numbers: dot separator (1.234)
- Relative time: "2 giờ trước", "1 ngày trước"
- Tone: Friendly, action-oriented

---
## Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Primary actions, CTAs |
| `--color-success` | Positive states, confirmations |
| `--color-warning` | Warning indicators |
| `--color-danger` | Error states, destructive actions |
| `--color-surface-elevated` | Cards, elevated surfaces |

---
## Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-04-06 | 2.0 | Rebound system-health screen to canonical diagnostics, alert, and queue contracts; removed generic service-health placeholder references. | System |
| 2026-03-28 | Patch | Removed duplicate template sections. Replaced with screen-specific Error Handling, Accessibility, Loading, Localization, Design Tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
