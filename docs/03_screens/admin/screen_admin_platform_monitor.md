# Screen: Admin — Platform Integration Monitor

> **Screen ID**: A007
> **Module**: S26 — Platform Operations
> **Route**: `/admin/platforms`
> **Platform**: Admin Web (SvelteKit) — VPN-only
> **Upstream**: A1 Schema (`connected_accounts`, `platform_health_scores`, `webhook_events`, `background_jobs`), A3 API (`ConnectorService/GetAllStatus`, `ConnectorService/GetSyncStatus`, `ConnectorService/GetTokenStatus`, `ConnectorService/GetDebugLog`, `ConnectorService/ListWebhookDeliveries`), B5 RBAC §3

---

## 1. Purpose & Context
Monitor all platform integrations — TikTok, Instagram, Shopee, YouTube, Facebook. Health status, sync errors, rate limit usage, and token expiry warnings.
### Entry Points - Admin sidebar: "🔗 Platforms" / System Health → "Platforms"
### Exit Points - Click card → platform detail

---

## 2. Screen Layout
### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 🔗 Platform Integrations                                            │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Platform Grid ────────────────────────────────────────────────┐  │
│ │ ┌──────────────────────┐  ┌──────────────────────┐            │  │
│ │ │ 🎵 TikTok [🟢 OK]   │  │ 📸 Instagram [🟢 OK]│            │  │
│ │ │ Connected: 1,234     │  │ Connected: 890       │            │  │
│ │ │ Sync errors: 0       │  │ Sync errors: 3       │            │  │
│ │ │ Rate: 45% of limit   │  │ Rate: 72% ⚠️        │            │  │
│ │ │ Expiring tokens: 12  │  │ Expiring tokens: 5   │            │  │
│ │ │ Avg sync: 2.3s       │  │ Avg sync: 4.1s       │            │  │
│ │ └──────────────────────┘  └──────────────────────┘            │  │
│ │ ┌──────────────────────┐  ┌──────────────────────┐            │  │
│ │ │ 🛍 Shopee [🟡 WARN]  │  │ ▶ YouTube [🟢 OK]  │            │  │
│ │ │ Connected: 456       │  │ Connected: 678       │            │  │
│ │ │ Sync errors: 23 ⚠️   │  │ Sync errors: 0       │            │  │
│ │ │ Rate: 89% 🔴         │  │ Rate: 12%            │            │  │
│ │ └──────────────────────┘  └──────────────────────┘            │  │
│ └────────────────────────────────────────────────────────────────┘  │
│ ┌─ Recent Errors ────────────────────────────────────────────────┐  │
│ │ ⚠️ Shopee: Rate limit ws_456 · 5m ago                         │  │
│ │ ⚠️ Instagram: Token refresh failed @user123 · 2h ago          │  │
│ │ [View all errors →]                                             │  │
│ └────────────────────────────────────────────────────────────────┘  │
│ ┌─ Token Expiry Warnings ──────────────────────────────────────┐   │
│ │ 12 TikTok tokens expiring < 30 days                           │   │
│ │ 5 Instagram tokens expiring < 30 days                         │   │
│ │ [📧 Notify affected users]                                    │   │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```
## 3. States
| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Shimmer |
| ALL_HEALTHY | Everything green | "🟢 All platforms operational" |
| DEGRADED | Warnings | "🟡 {n} platforms degraded" |
| PLATFORM_DOWN | Platform unavailable | Red card with alert |
| RATE_LIMIT | Near rate limits | Orange warning on affected cards |
| ERROR | API failed | Error with retry |

---

## 4. Preconditions / Postconditions
### Preconditions
- Admin user with appropriate S26 role
- VPN connection active
### Postconditions
- All actions logged in audit trail
- State changes reflected in real-time

---

## 5. Component Hierarchy
```text
PlatformIntegrationMonitorPage
├── AdminShell
├── PageHeader
├── ProviderGrid
│   └── ProviderHealthCard[]
├── RecentErrorsPanel
├── TokenExpiryPanel
└── DebugShortcutBar
```

---

## 6. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Provider cards | `connected_accounts`, `platform_health_scores` | `ConnectorService/GetAllStatus` | Health cards | 30s TTL |
| Sync errors | `background_jobs` filtered by provider queue | `ConnectorService/GetDebugLog` | Recent error rows | No cache |
| Webhook failures | `webhook_events` | `ConnectorService/ListWebhookDeliveries` | Delivery table | No cache |
| Token expiry | Auth metadata per account | `ConnectorService/GetTokenStatus` | Warning list | 1m TTL |


---
## 7. Related Screens
| Screen | Relationship |
|---|---|
| [A006] System Health | System overview |
| [A033] Connector Debug | Deep-dive provider diagnostics |
| [A010] Audit Log | Operations log |
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
| 2026-04-06 | 2.0 | Canonicalized provider monitor to actual connector health, webhook, and job contracts; added debug-screen handoff path A033. | System |
| 2026-03-28 | Patch | Removed duplicate template sections. Replaced with screen-specific Error Handling, Accessibility, Loading, Localization, Design Tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
