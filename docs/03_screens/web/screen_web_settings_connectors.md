# Screen: Web — Settings: Connected Accounts

> **Screen ID**: W117
> **Module**: M22 — Capability Matrix (Connectors)
> **Route**: `/settings/connections`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 10, PRD §33 Platform Capabilities, A1 Schema (connected_accounts, capability_snapshots, sync_jobs), B5 RBAC §2.9

---
## 1. Purpose & Context

Manage all platform connections — social media (TikTok, Instagram, YouTube, Facebook) and commerce platforms (Shopee, Lazada, TikTok Shop). Shows per-platform capability status, rate limit usage, sync history, and connection health. This is the "nerve center" for all external integrations.

### User Goals
- Connect new social or commerce platforms
- Monitor connection health and sync freshness
- Understand what capabilities each platform supports (publish, read, reply, DMs)
- Diagnose and fix connection problems (expired tokens, rate limits)

### Business Goals
- Ensure all platform data flows are healthy for accurate commerce and analytics
- Surface capability degradation before it affects publishing workflow
- Track rate limit usage to prevent API throttling

### Entry Points
- Sidebar: Settings → "🔗 Kết nối"
- Onboarding: step 2 "Connect your platforms"
- Publish Composer: "Platform disconnected" warning → link
- Notification: "TikTok token expiring in 3 days"
- Copilot: "Kiểm tra kết nối TikTok"

### Exit Points
- Click connector → Connector Detail (W118)
- "+ Kết nối mới" → OAuth flow (popup)
- "🔧 Kiểm tra" → Diagnostics Center

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `workspace:settings:manage` permission (Owner, Admin)

### Postconditions
- New connection creates `connected_account` record + triggers initial sync
- Disconnect removes tokens + marks account as disconnected (data retained)
- Capability snapshot updated after each reconnect

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ⚙️ Settings > 🔗 Kết nối                           [+ Kết nối mới] │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary Bar ─────────────────────────────────────────────────┐   │
│ │ 🟢 3 connected · 🟡 1 degraded · ⚫ 4 available             │   │
│ │ Overall health: Good · Last sync: 10m ago                     │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── Connected ───────────────────────────────────────────────────      │
│ ┌─ Connector Card ──────────────────────────────────────────────┐   │
│ │ 🎵 TikTok · @creativanta_studio           [🟢 Connected]     │   │
│ │ Token: ✅ Valid (expires in 28d)                               │   │
│ │ Last sync: 10 phút trước · Sync frequency: 15 min            │   │
│ │                                                                  │   │
│ │ Capabilities:                                                    │   │
│ │ ├ 🟢 Publish video · 🟢 Read comments · 🟢 Reply comments    │   │
│ │ ├ 🟡 Read DMs (read-only) · 🔴 Send DMs (unsupported)        │   │
│ │ ├ 🟢 Read analytics · 🟢 Read followers                      │   │
│ │ └ 🟢 Commerce: Product sync · Order sync · Settlement sync    │   │
│ │                                                                  │   │
│ │ Rate limits: 145/600 requests today (24%)                      │   │
│ │ [████░░░░░░░░░░░░░░░░]                                       │   │
│ │                                                                  │   │
│ │ [🔄 Force sync] [⚙️ Chi tiết] [🔌 Ngắt kết nối]            │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Connector Card ──────────────────────────────────────────────┐   │
│ │ 🛍 Shopee · shop_creativanta               [🟡 Degraded]     │   │
│ │ Token: ✅ Valid · Sync: ⚠️ 2h overdue                         │   │
│ │ ⚠️ "Đồng bộ đơn hàng bị chậm. API Shopee trả về timeout.    │   │
│ │    Đang thử lại tự động." [🔧 Kiểm tra chi tiết]            │   │
│ │                                                                  │   │
│ │ Capabilities: 🟢 Product · 🟢 Order · 🟡 Settlement (delayed)│  │
│ │ [🔄 Force sync] [⚙️ Chi tiết] [🔌 Ngắt]                    │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Connector Card ──────────────────────────────────────────────┐   │
│ │ ▶️ YouTube · Creativanta Channel             [🟢 Connected]  │   │
│ │ Capabilities: 🟢 Upload · 🟢 Analytics · 🔴 Shorts compose   │   │
│ │ [⚙️ Chi tiết] [🔌 Ngắt]                                     │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── Available to connect ────────────────────────────────────────      │
│ ┌─ Available Connectors ────────────────────────────────────────┐   │
│ │ 📸 Instagram [Kết nối →]   📘 Facebook [Kết nối →]           │   │
│ │ 🛒 Lazada [Kết nối →]      🐦 X/Twitter [Coming soon]        │   │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
ConnectedAccountsPage
├── AppShell (shared)
├── PageHeader
│   ├── BreadcrumbNav ("⚙️ Settings > 🔗 Kết nối")
│   └── AddConnectionButton ("+ Kết nối mới")
├── SummaryBar
│   ├── ConnectedCount + DegradedCount + AvailableCount
│   ├── OverallHealth
│   └── LastSyncTimestamp
├── ConnectedSection
│   └── ConnectorCard[]
│       ├── PlatformIcon + Name + Handle
│       ├── StatusBadge (🟢 Connected / 🟡 Degraded / 🔴 Error / ⚫ Disconnected)
│       ├── TokenStatus (valid + expiry countdown)
│       ├── SyncStatus (last sync time + frequency)
│       ├── DegradedWarning (if applicable — issue + auto-retry status)
│       ├── CapabilityGrid
│       │   └── CapabilityItem[]
│       │       ├── CapabilityName
│       │       └── StatusIcon (🟢 Native / 🟡 Read-only / 🔴 Unsupported / ⚫ Not connected)
│       ├── RateLimitBar (used/total + progress bar)
│       └── ActionBar
│           ├── ForceSyncButton ("🔄 Force sync")
│           ├── DetailButton ("⚙️ Chi tiết" → W118)
│           └── DisconnectButton ("🔌 Ngắt kết nối")
├── AvailableSection
│   └── AvailableConnectorTile[]
│       ├── PlatformIcon + Name
│       ├── ConnectButton ("Kết nối →" → OAuth popup)
│       └── ComingSoonBadge (if not yet available)
└── OAuthPopup (system level — not in page)
    ├── PlatformAuthPage (external)
    ├── PermissionConsent
    └── RedirectCallback → connected_accounts record
```

---
## 5. Displayed Data

| Field | Source | Format |
|---|---|---|
| Platform name | `connected_accounts.platform` | Icon + name |
| Handle | `connected_accounts.platform_username` | "@creativanta_studio" |
| Status | `connected_accounts.status` | Color badge |
| Token expiry | `connected_accounts.token_expires_at` | "expires in 28d" or "⚠️ expires tomorrow" |
| Last sync | `sync_jobs.last_success_at` for platform | Relative: "10m ago" |
| Sync frequency | `connected_accounts.sync_interval_minutes` | "15 min" |
| Capabilities | `capability_snapshots` for platform | Grid with status icons |
| Rate limits | `connected_accounts.rate_limit_used` / `rate_limit_total` | "145/600" + progress bar |
| Degradation reason | `sync_jobs.last_error_message` | Warning text |

---
## 6. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Connect platform | "Kết nối →" | OAuth popup → callback | New connected_account, initial sync triggered, toast "Đã kết nối {platform}!" | `workspace:settings:manage` |
| 2 | Force sync | "🔄 Force sync" | `ConnectorService/ForceSync(platform)` | Sync starts, progress indicator | `workspace:settings:manage` |
| 3 | View detail | "⚙️ Chi tiết" | — | → `/settings/connections/[platform]` | `workspace:settings:manage` |
| 4 | Disconnect | "🔌 Ngắt kết nối" → confirm | `ConnectorService/Disconnect(platform)` | Confirmation: "Ngắt kết nối sẽ dừng đồng bộ dữ liệu. Dữ liệu hiện tại vẫn được giữ. Tiếp tục?" → disconnected | `workspace:settings:manage` |
| 5 | Check diagnostics | "🔧 Kiểm tra" | — | → Diagnostics for this connector | `workspace:settings:manage` |
| 6 | Reconnect (expired) | "🔄 Kết nối lại" (on expired tokens) | OAuth popup | Token refreshed | `workspace:settings:manage` |

---
## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Connector card skeletons |
| LOADED | Data received | Connected + available sections |
| NO_CONNECTIONS | No platforms connected | "Chưa kết nối nền tảng nào. Kết nối TikTok, Shopee hoặc Instagram để bắt đầu." + large connect buttons |
| TOKEN_EXPIRING | Token expires within 7 days | Orange warning on connector: "⚠️ Token hết hạn trong {days} ngày. [🔄 Gia hạn]" |
| TOKEN_EXPIRED | Token expired | Red alert: "🔴 Token đã hết hạn. Kết nối lại để tiếp tục đồng bộ. [🔄 Kết nối lại]" |
| DEGRADED | Sync delayed or partial failures | Yellow warning with auto-retry status |
| RATE_LIMITED | Rate limit > 90% | Red progress bar: "⚠️ Sắp hết rate limit. Giãn cách request." |
| ERROR | API failed | Error with retry |

---
## 8. Capability Status Reference

Per PRD M22, platform capabilities have 4 states:
| Status | Icon | Meaning |
|---|---|---|
| Native | 🟢 | Full API support. Read + write. |
| Read-only | 🟡 | Can read data, cannot write. |
| Manual | 🟠 | Not API-supported. User must do manually. |
| Unsupported | 🔴 | Platform does not offer this capability. |

---
## 9. Permissions

| Feature | Owner | Admin | Manager | Editor+ |
|---|---|---|---|---|
| View connections | ✅ | ✅ | ✅ (read-only) | ❌ |
| Connect/disconnect | ✅ | ✅ | ❌ | ❌ |
| Force sync | ✅ | ✅ | ❌ | ❌ |
| View diagnostics | ✅ | ✅ | ❌ | ❌ |

---
## 10. Edge Cases

| Edge Case | Handling |
|---|---|
| OAuth popup blocked | Show "Popup bị chặn. Vui lòng cho phép popup cho trang này." |
| OAuth denied by user | Toast: "Kết nối bị từ chối. Thử lại khi sẵn sàng." |
| Platform API down | Show connector as "🟡 Degraded — API không phản hồi" with auto-retry |
| Token refresh fails silently | Background job detects → push notification + in-app alert |
| Multiple accounts same platform | Show each as separate connector (e.g., 2 TikTok accounts) |
| Rate limit exceeded | Connector shows "🔴 Rate limit reached. Reset in {time}." |

---
---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached connectors | Retry online |
| OAuth popup blocked | Browser blocks popup | Toast: "Popup bị chặn. Cho phép popup → thử lại" | User allows popup |
| OAuth timeout | OAuth window open >5m | Toast: "Kết nối hết thời gian. [Thử lại]" | Retry |
| Force sync fail | Platform API error | Toast: "Đồng bộ thất bại. [Xem diagnostics]" | Diagnostics link |
| Disconnect fail | API error on disconnect | Toast: "Không ngắt được. [Thử lại]" | Retry |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Summary bar | `role="status"`, `aria-label="3 connected, 1 degraded, 4 available"` |
| Connector cards | `role="article"`, `aria-label="{platform}: {status}"` |
| Capability grid | `role="list"`, each item `aria-label="{capability}: {status}"` (not color only) |
| Rate limit bar | `role="progressbar"`, `aria-valuenow`, `aria-valuemax`, `aria-label="Rate limit: 145 of 600 used"` |
| Status badges | Text + icon (🟢/🟡/🔴), not color alone |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Shell + connector card skeletons |
| Summary bar | 100-300ms | Counts populate |
| Connected cards | 200-600ms | Cards stagger in |
| Capability grids | 300-800ms | Capability icons populate |
| Available section | 400-800ms | Available tiles fade in |

---

## 14. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `settings_connectors.viewed` | Page load | `connected_count`, `degraded_count`, `source` |
| `settings_connectors.connect_started` | "Kết nối →" | `platform` |
| `settings_connectors.connect_completed` | OAuth callback success | `platform`, `duration_ms` |
| `settings_connectors.connect_failed` | OAuth error/cancel | `platform`, `error_type` |
| `settings_connectors.disconnect` | "Ngắt kết nối" confirmed | `platform`, `data_retained` |
| `settings_connectors.force_sync` | "🔄 Force sync" | `platform`, `last_sync_age_min` |
| `settings_connectors.detail_viewed` | "⚙️ Chi tiết" | `platform` |
| `settings_connectors.reconnect` | "🔄 Kết nối lại" (expired) | `platform`, `days_expired` |

---

## 15. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/settings/connections/+page.svelte`
- **Server load**: `+page.server.ts` → `ConnectorService/List(workspace_id)` + `CapabilityService/GetSnapshots`
- **OAuth flow**: Server creates OAuth URL → `window.open(url, popup)` → listen `message` event for callback
- **OAuth callback**: `/api/oauth/callback/[platform]` → creates `connected_account` → `postMessage` to parent
- **Force sync**: `ConnectorService/ForceSync(platform)` → SSE `/events/sync/{platform}` for progress
- **Rate limits**: Cached per-platform, refreshed every 5m
- **Disconnect**: Confirm modal → `ConnectorService/Disconnect(platform)` → optimistic removal + revert on error
- **Available platforms**: Static config + `ComingSoonBadge` for unreleased integrations

---

## 16. Localization Notes

- Platform names: English (TikTok, Instagram, YouTube, Shopee, Lazada)
- Status: "🟢 Đã kết nối", "🟡 Suy giảm", "🔴 Lỗi", "⚫ Chưa kết nối"
- Token: "Token hết hạn trong {n} ngày"
- Sync: "Đồng bộ lần cuối: {time} trước"
- Capabilities: Vietnamese ("Đăng video", "Đọc bình luận", "Trả lời bình luận")
- Tone: Technical, reassuring

---

## 17. Design Tokens

| Token | Usage |
|---|---|
| `--color-connector-connected` | 🟢 Connected status (green) |
| `--color-connector-degraded` | 🟡 Degraded status (amber) |
| `--color-connector-error` | 🔴 Error/disconnected status (red) |
| `--color-connector-available` | ⚫ Available to connect (neutral) |
| `--color-rate-limit-ok` | Rate limit progress bar (<80%) |
| `--color-rate-limit-warning` | Rate limit >80% (amber) |
| `--color-rate-limit-critical` | Rate limit >95% (red) |
| `--color-surface-elevated` | Connector cards |
| `--color-accent` | "Kết nối →" CTA |
| `--color-platform-*` | Platform-specific accents |

---

## 18. Related Screens

| Screen | Relationship |
|---|---|
| [W127] Connected Account Detail | Per-platform detail with sync history |
| [W125] Diagnostics Center | Technical diagnostics |
| [W052] Publish Composer | Publishing requires active connectors |
| [W060] Product List | Product sync from commerce platforms |
| [M058] Mobile Connections | Mobile equivalent |

---

## 19. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (OAuth timeout, sync fail), card/grid a11y, 8 analytics, SvelteKit impl (OAuth popup, SSE sync), localization, 10 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
