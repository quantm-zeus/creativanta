# Screen: Mobile — Brand Deals Pipeline

> **Screen ID**: M046
> **Module**: S16 — Creator Pro Tools
> **Route**: `/creator-pro/deals` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (brand_deals), B5 RBAC §2.7

---

## 1. Purpose & Context
Mobile brand deal management — pipeline view with swipe actions, revenue tracking, deadline alerts.
### Entry Points - Creator Pro → "🤝 Deals" / Push: "🤝 New deal offer from Brand X"
### Exit Points - Tap deal → deal detail bottom sheet

---

## 2. Screen Layout
### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Brand Deals                                     [+ Thêm deal]   │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Pipeline Summary ──────────────────────────────────────────┐    │
│ │ Active: 3 · Value: 15M · Completed (Q1): 8 · Win rate: 67%  │    │
│ └────────────────────────────────────────────────────────────────┘   │
│ Chips: [All] [📩 Inquiry (2)] [📝 Negotiation (1)]                │
│        [🎬 In Progress (3)] [✅ Done (8)]                          │
│ ┌─ Deal Card ──────────────────────────────────────────────────┐   │
│ │ 🤝 "Serum HA Review" · Brand: CosmeticVN                    │   │
│ │ Value: 5,000,000đ · Due: 31/3 · [🎬 In Progress]           │   │
│ │ Deliverables: 1 TikTok + 2 IG Stories                        │   │
│ │ Deadline: 3 days left ⏰                                      │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Deal Card ──────────────────────────────────────────────────┐   │
│ │ 🤝 "Summer Collection" · Brand: FashionVN                   │   │
│ │ Value: 3,000,000đ · [📝 Negotiating]                        │   │
│ │ [📧 Reply] [✅ Accept] [❌ Decline]                          │   │
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
| LOADED | Deals listed | Summary + cards |
| EMPTY | No deals | "Chưa có deal nào. Chia sẻ Media Kit để thu hút brands!" |
| DEADLINE_NEAR | Deal due < 3d | Orange: "⏰ Deadline gần!" |
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
BrandDealsPipelineScreen
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
| [W095] Web Brand Deal Manager | Web equivalent |
| [M048] Media Kit Preview | Para sharing |
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

## P8 kanban and document parity

Add a status-filtered list equivalent to web kanban, with accessible move/status controls using the canonical M16 lifecycle and optimistic checks. Document tab supports the template preview, safe upload, immutable versions and external signature evidence in [Deal Contracts](../web/screen_web_creator_contracts.md). Inquiry remains a separate thread before deal creation. All writes recheck permissions and show conflict/repair states.
