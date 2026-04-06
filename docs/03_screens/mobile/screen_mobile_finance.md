# Screen: Mobile — Finance Overview

> **Screen ID**: M040
> **Module**: M19 — Finance
> **Route**: `/finance` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (`profit_snapshots`, `cost_items`, `settlements`), S009 Trust Badge, B5 RBAC §2.9

---

## 1. Purpose & Context

Mobile finance hub — net profit overview, revenue vs cost trend, trust badges, and navigation to detailed screens.

### Entry Points - Tab bar: "💰 Finance"
### Exit Points - Tap KPI → detail screen

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ 💰 Finance                                  [Period: T3 ▾]         │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Net Profit ──────────────────────────────────────────────────┐   │
│ │ 💰 26.7M VND · ↑12% vs T2                                    │   │
│ │ Revenue: 45.2M · Cost: 18.5M · Margin: 59%                  │   │
│ │ Trust: [🟢 82%] Official                                      │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ 30d Trend ───────────────────────────────────────────────────┐   │
│ │ [Mini area chart: revenue vs cost]                             │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Quick Links ─────────────────────────────────────────────────┐   │
│ │ [📈 Revenue] [📉 Costs] [🔄 Reconcile] [📊 Reports]         │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ AI Insight ──────────────────────────────────────────────────┐   │
│ │ 💡 "Margin cải thiện nhờ giảm shipping 15%."                 │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ Pull-to-refresh                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7. States
| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Shimmer |
| LOADED | Data ready | KPI + chart + links |
| NO_DATA | No finance data | "Chưa có dữ liệu tài chính." |
| LOW_TRUST | < 70% Official | Warning badge |
| MARGIN_DECLINING | Margin ↓ > 5pp | Red alert |
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
FinanceOverviewScreen
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

## 5. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Primary data | Parent screen state or canonical contract object(s) | Resolve via owning feature doc + API/schema contracts | Exact DTO fields from canonical contracts | Per endpoint policy |
| List items | Parent screen list/query contract(s) | Resolve via API endpoint map before implementation | Card or row layout per wireframe | Per endpoint policy |
| Summary stats | Parent screen aggregates/projections | Resolve via feature rules + API contracts | Count / KPI / chip formatting per screen | Short-lived cache only if contract allows |
| User-facing text | i18n keys | — | Vietnamese | Static |


---
## 19. Related Screens
| Screen | Relationship |
|---|---|
| [W080] Web Finance Dashboard | Web equivalent |
| [M042] Revenue Detail | Revenue detail |
| [M041] Finance Summary | Detailed view |
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
