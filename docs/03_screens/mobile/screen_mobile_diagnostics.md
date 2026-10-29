# Screen: Mobile — Diagnostics

> **Screen ID**: M059
> **Module**: M23 — Settings
> **Route**: `/settings/diagnostics` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (`diagnostics_records`, `platform_health_metrics`, `system_alerts`), A3 API (`DiagnosticsService`, `PlatformHealthService`), B5 RBAC §2.9

---

## 1. Purpose & Context

Mobile diagnostics — simplified health overview with quick-fix buttons for common issues. Shows critical alerts prominently and allows one-tap fixes for routine problems.

### Entry Points
- Settings: "🔧 Diagnostics" row
- Push: "🔴 Critical: Shopee sync failed"
- Status badge tap (from any screen)

### Exit Points
- "🔧 Quick Fix" → auto-repair flow
- "📋 Details" → issue detail bottom sheet

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Diagnostics                               Overall: 🟡 Degraded  │
├──────────────────────────────────────────────────────────────────────┤
│ Quick stats: 🔴 2 · 🟡 3 · 🟢 12                                 │
│ [🔄 Run check now]                                                  │
│                                                                      │
│ ── Issues ──                                                         │
│ ┌─ Issue Card ──────────────────────────────────────────────────┐   │
│ │ 🔴 Shopee Order Sync Failed                                   │   │
│ │ Since: 2h ago · Impact: Revenue data missing                   │   │
│ │ Root cause: API rate limit · Auto-retry: 3× failed            │   │
│ │ [🔧 Quick Fix] [📋 Details]                                   │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Issue Card ──────────────────────────────────────────────────┐   │
│ │ 🔴 TikTok Token Expiring (25 days)                             │   │
│ │ [🔄 Re-authorize →]                                            │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Issue Card ──────────────────────────────────────────────────┐   │
│ │ 🟡 AI Credits Low — 120/500 (24%)                              │   │
│ │ ~8 days remaining · [💳 Top up]                                │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── All Services (collapsed) ──                                       │
│ ┌─ Service Grid ────────────────────────────────────────────────┐   │
│ │ TikTok 🟢 120ms · Shopee 🔴 timeout · IG 🟢 180ms          │   │
│ │ AI 🟢 450ms · DB 🟢 3ms · Search 🟢 8ms · Cache 🟢 1ms    │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Pull-to-refresh                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Running checks | Shimmer |
| ALL_HEALTHY | All services 🟢 | "✅ All systems OK" |
| DEGRADED | Warnings exist | "🟡 {n} warnings" |
| CRITICAL | Critical issues | "🔴 {n} critical" at top |
| FIXING | Quick fix in progress | Progress spinner on issue |
| ERROR | Diagnostics failed | Error with retry |

---
## 4. Preconditions / Postconditions
### Preconditions
- User authenticated with valid session
- Required module permissions granted
### Postconditions
- User actions persisted to backend
- Related screens updated via state management
- Analytics events dispatched

---

## 5. Component Hierarchy
```
DiagnosticsScreen
├── AppBar
│   ├── BackButton
│   └── Title + ActionButtons
├── ContentArea (scrollable, pull-to-refresh)
│   ├── SummarySection
│   ├── PrimaryContent
│   │   └── Screen-specific regions defined by the ASCII wireframe and interaction states
│   └── SecondaryContent
└── BottomNavBar (shared)
```

---

## 6. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Primary data | Parent screen state or canonical contract object(s) | Resolve via owning feature doc + API/schema contracts | Exact DTO fields from canonical contracts | Per endpoint policy |
| List items | Parent screen list/query contract(s) | Resolve via API endpoint map before implementation | Card or row layout per wireframe | Per endpoint policy |
| Summary stats | Parent screen aggregates/projections | Resolve via feature rules + API contracts | Count / KPI / chip formatting per screen | Short-lived cache only if contract allows |
| User-facing text | i18n keys | — | Vietnamese | Static |


---
## 7. Related Screens

| Screen | Relationship |
|---|---|
| [W125] Web Diagnostics Center | Web equivalent (full) |
| [M057] Settings | Parent |
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
