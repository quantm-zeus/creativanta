# Screen: Mobile — Analytics Dashboard

> **Screen ID**: M035
> **Module**: M23 — Analytics
> **Route**: `/analytics` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (engagement_snapshots, content_items), B5 RBAC §2.7

---

## 1. Purpose & Context
Mobile analytics hub — overview metrics, top content, trend chart, and navigation to detail screens. Optimized for quick daily check.
### Entry Points - Bottom nav: "📊" / Morning Brief CTA
### Exit Points - Tap card → detail screen

---

## 2. Screen Layout
### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ 📊 Analytics                           [Period: 7d ▾] [Platform ▾] │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Key Metrics ─────────────────────────────────────────────────┐   │
│ │ 👁 Views: 245K (↑18%) · ❤ Engagement: 5.8% (↑0.5pp)        │   │
│ │ 👥 Followers: +1,234 · Posts: 12                              │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Trend (mini chart) ────────────────────────────────────────┐    │
│ │ [7d line chart: views + engagement]                           │    │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Top Content ─────────────────────────────────────────────────┐   │
│ │ 🏆 "5 tips nấu ăn" — 50K views, ER 8.2%  [📊 →]            │   │
│ │ 2. "Skincare routine" — 18K views, ER 5.1%                   │   │
│ │ 3. "Unboxing" — 12K views, ER 4.5%                           │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Quick Links ─────────────────────────────────────────────────┐   │
│ │ [👥 Competitors] [💡 Coach] [🎮 Gamification]                │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ Pull-to-refresh                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```
## 3. States
| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Shimmer |
| LOADED | Data ready | Metrics + chart + list |
| NO_DATA | < 7d of data | "Cần thêm dữ liệu. Kết nối platform và đăng nội dung!" |
| ERROR | API failed | Error with retry |

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
AnalyticsDashboardScreen
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
| [W075] Web Analytics Overview | Web equivalent |
| [M037] Post Analytics | Per-post detail |
| [M038] Gamification | XP/streaks |
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
