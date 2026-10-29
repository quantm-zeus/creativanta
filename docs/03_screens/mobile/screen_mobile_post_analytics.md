# Screen: Mobile — Post Analytics Detail

> **Screen ID**: M037
> **Module**: M23 — Analytics
> **Route**: `/analytics/post/[id]` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (content_items, engagement_snapshots), B5 RBAC §2.7

---

## 1. Purpose & Context

Single post performance on mobile — key metrics, 72h reach timeline, AI insight cards, and audience breakdown. Scrollable vertical layout.

### Entry Points
- Published posts: tap row
- Analytics Dashboard: tap content row
- Push: "🔥 Your post hit 10K views!"

### Exit Points
- "📦 Derivatives" → Derivative Manager
- "← Analytics" → back

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Post Analytics   "5 tips nấu ăn"                                 │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Post Thumbnail + Meta ───────────────────────────────────────┐   │
│ │ [📸 Thumbnail]  🎵 TikTok · Published 3d ago · 60s           │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Key Metrics ─────────────────────────────────────────────────┐   │
│ │ 👁 50,234 (↑120%) · ❤ 3,120 (↑85%) · 💬 456 (↑200%)        │   │
│ │ 📤 234 (↑150%) · 📌 567 (↑95%)                               │   │
│ │ ER: 6.2% (↑45% vs avg) · Watch: 42/60s (70%)                │   │
│ │ Followers gained: +234                                         │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Reach Timeline (72h) ───────────────────────────────────────┐    │
│ │ [Line chart: views over 72 hours]                              │    │
│ │ Peak: Hour 3 (12,500/hr) · Viral window: 0-8h                │    │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ AI Analysis ─────────────────────────────────────────────────┐   │
│ │ Score: 85/100 (A)                                              │   │
│ │ ✅ Hook: 3s opening retained 65%                               │   │
│ │ ✅ Trending sound boost: +35%                                  │   │
│ │ ❌ No CTA → missed ~50 followers                               │   │
│ │ 💡 Add "Follow for more" overlay at end                       │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Audience ────────────────────────────────────────────────────┐   │
│ │ Age: 18-24 (45%) · Female: 65% · HCM: 35%                   │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ Pull-to-refresh                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Metrics shimmer |
| LOADED | Full data | Complete analytics |
| PARTIAL_DATA | Still processing | "📊 Dữ liệu đầy đủ trong 24-48h." |
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
PostAnalyticsDetailScreen
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
| [W078] Web Post Detail Analytics | Web equivalent |
| [M035] Analytics | Parent |
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
