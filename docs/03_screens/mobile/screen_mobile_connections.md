# Screen: Mobile — Connected Accounts

> **Screen ID**: M058
> **Module**: M23 — Settings
> **Route**: `/settings/connections` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (connected_accounts), B5 RBAC §2.9

---

## 1. Purpose & Context

Mobile connected accounts — platform connection status, quick reconnect, sync status, and new platform connection via OAuth. Simplified view of web Connectors (W117).

### Entry Points
- Settings screen: "🔗 Kết nối" row
- Push notification: "⚠️ TikTok token expiring"

### Exit Points
- Tap platform → Mobile Connector Detail
- "+ Kết nối mới" → OAuth flow in in-app browser

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Kết nối                                       [+ Kết nối mới]   │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Connected ────────────────────────────────────────────────────┐  │
│ │ 🎵 TikTok · @creativanta                 🟢 Connected         │  │
│ │    Last sync: 10m ago · Next: 5m · Tap for details             │  │
│ │ 🛍 Shopee · shop_creativanta              🟡 Degraded          │  │
│ │    ⚠ Order sync delayed 2h · [🔧 Fix →]                       │  │
│ │ ▶️ YouTube · Quân Channel                 🟢 Connected         │  │
│ │    Last sync: 1h ago                                            │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Available to Connect ───────────────────────────────────────┐    │
│ │ 📸 Instagram                              [Kết nối →]         │    │
│ │ 📘 Facebook Pages                         [Kết nối →]         │    │
│ │ 🛒 Lazada                                  [Kết nối →]        │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Pull-to-refresh                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Shimmer rows |
| LOADED | Data received | Connected + available lists |
| NO_CONNECTIONS | Nothing connected | "Kết nối nền tảng để bắt đầu! [+ Kết nối đầu tiên]" |
| HAS_ISSUES | Some degraded/failed | Yellow/red badges on affected platforms |
| CONNECTING | OAuth flow in progress | In-app browser overlay |
| ERROR | API failed | Error with retry |

---
## 2. Preconditions / Postconditions
### Preconditions
- User authenticated with valid session
- Required module permissions granted
### Postconditions
- User actions persisted to backend
- Related screens updated via state management
- Analytics events dispatched

---

## 4. Component Hierarchy
```
ConnectedAccountsScreen
├── AppBar
│   ├── BackButton
│   └── Title + ActionButtons
├── ContentArea (scrollable, pull-to-refresh)
│   ├── SummarySection
│   ├── PrimaryContent
│   │   └── [Items per wireframe]
│   └── SecondaryContent
└── BottomNavBar (shared)
```

---

## 5. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Primary data | Backend table | `Service/Get` | Formatted display | 15m TTL |
| List items | Backend query | `Service/List(page)` | Card/row list | Based on criticality |
| Summary stats | Aggregation | `Service/GetStats` | Count/percentage | 5m TTL |
| User-facing text | i18n keys | — | Vietnamese | Static |


---
## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W117] Connectors | Web equivalent |
| [W127] Connected Account Detail | Web detail view |
| [M057] Mobile Settings | Parent |
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
| 2026-03-28 | Patch | Removed duplicate template sections. Replaced with screen-specific Error Handling, Accessibility, Loading, Localization, Design Tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
