# Screen: Mobile — Competitor Tracking

> **Screen ID**: M018
> **Module**: M23 — Analytics
> **Route**: `/analytics/competitors` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (competitor_profiles, competitor_snapshots), B5 RBAC §2.7

---

## 1. Purpose & Context

Mobile competitor tracking — monitor competitor accounts with growth rate, posting frequency, and engagement trends. Simplified card view of web equivalent.

### Entry Points
- Analytics tab → "👥 Competitors"
- Morning Brief: "Competitor update" link

### Exit Points
- Tap competitor → competitor detail

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Đối thủ                                        [+ Thêm]         │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Your Position ───────────────────────────────────────────────┐   │
│ │ You rank #3 of 5 tracked · Avg ER: 5.8% (rank #1)           │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Competitor Card ─────────────────────────────────────────────┐   │
│ │ [Avatar] @skincare_queen · 🎵 TikTok                         │   │
│ │ 120K followers (+5.2% this month) · ER: 4.2%                 │   │
│ │ Posts: 15/mo · Last post: 2h ago                               │   │
│ │ Trending: "Night routine" (45K views)                          │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Competitor Card ─────────────────────────────────────────────┐   │
│ │ [Avatar] @beauty_tips_vn · 🎵 TikTok                         │   │
│ │ 85K followers (+2.1%) · ER: 3.8%                              │   │
│ │ Posts: 20/mo · Last post: 1d ago                               │   │
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
| LOADING | Fetching | Card shimmer |
| LOADED | Competitors tracked | Position + competitor cards |
| EMPTY | No competitors | "Thêm đối thủ để so sánh hiệu suất. [+ Thêm đầu tiên]" |
| COMPETITOR_GROWING | Competitor growing fast | 🔴 "Tăng trưởng nhanh!" badge |
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
CompetitorTrackingScreen
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
| [W040] Web Competitor Registry | Web equivalent |
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
