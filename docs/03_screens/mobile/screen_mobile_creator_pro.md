# Screen: Mobile — Creator Pro Dashboard

> **Screen ID**: M045
> **Module**: S16 — Creator Pro Tools
> **Route**: `/creator-pro` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (creator_profiles), B5 RBAC §2.7

---

## 1. Purpose & Context
Creator Pro hub on mobile — access media kit, brand deals, tax tools, and monetization analytics from a single dashboard.
### Entry Points - Sidebar: "⭐ Creator Pro" / Upgrade flow
### Exit Points - Tap card → specific Creator Pro feature

---

## 2. Screen Layout
### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Creator Pro                                                       │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Monetization Summary ──────────────────────────────────────┐    │
│ │ 💰 This month: 15.2M VND (↑22%)                             │    │
│ │ Brand deals: 8M · Affiliate: 4.2M · Platform: 3M            │    │
│ │ Active deals: 3 · Pending invoices: 1                         │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Quick Actions (2×2 grid) ──────────────────────────────────┐    │
│ │ [📋 Media Kit]        [🤝 Brand Deals]                      │    │
│ │  87K followers         3 active, 15M value                    │    │
│ │ [📊 Creator Analytics] [💰 Tax & Reports]                   │    │
│ │  Score: 82/100 A-      Q1 report ready                       │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ AI Coach Tip ────────────────────────────────────────────────┐   │
│ │ 💡 "Tăng rate card 10% — engagement bạn trên trung bình."  │   │
│ │ [📋 Update Media Kit →]                                       │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Recent Activity ─────────────────────────────────────────────┐   │
│ │ 🤝 "CosmeticVN" deal moved to "In Progress" · 1d ago        │   │
│ │ 📋 Media Kit viewed 5 times this week                        │   │
│ └────────────────────────────────────────────────────────────────┘   │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```
## 7. States
| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Card shimmer |
| LOADED | Data ready | Summary + grid + tips |
| NOT_PRO | Free/Basic plan | "⭐ Upgrade to Pro to unlock Creator tools. [Upgrade →]" |
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
CreatorProDashboardScreen
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
| [W088] Web Creator Pro | Web equivalent |
| [M048] Media Kit Preview | Media kit |
| [M046] Brand Deals | Deal pipeline |
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
