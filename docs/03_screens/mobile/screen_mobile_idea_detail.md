# Screen: Mobile — Idea Detail

> **Screen ID**: M005b
> **Module**: M05 — Content Pipeline
> **Route**: `/ideas/[id]` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (ideas, idea_variations)

---

## 1. Purpose & Context
Mobile idea detail — full idea card with AI variations, trending context, and action flow to create script/content.
### Entry Points - Idea Board (M005): tap idea card
### Exit Points - "📝 Tạo script" → Script Editor / "📤 Lên lịch" → Publish

---

## 2. Screen Layout
### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Ideas   "5 tips nấu ăn healthy"                                  │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Idea Card ──────────────────────────────────────────────────┐    │
│ │ 💡 "5 tips nấu ăn healthy cho newbie"                        │    │
│ │ Platform: 🎵 TikTok · Type: Tips/Tutorial · 60s             │    │
│ │ Source: 🤖 AI suggested · Based on: trending "healthy food" │    │
│ │ Predicted ER: 6.5% · Audience match: 92%                     │    │
│ │ Tags: [cooking] [healthy] [tips]                              │    │
│ │ Status: [🟡 In Pipeline]                                      │    │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ AI Variations ──────────────────────────────────────────────┐    │
│ │ 🔄 Variation 1: "3 healthy meals under 50K"                  │    │
│ │ 🔄 Variation 2: "Healthy meal prep cho tuần bận"             │    │
│ │ [🤖 Generate more variations]                                 │    │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Trending Context ──────────────────────────────────────────┐     │
│ │ 🔥 "healthy food" — TikTok +340% this week                  │     │
│ │ Related: "meal prep" +120%, "budget cooking" +85%            │     │
│ └────────────────────────────────────────────────────────────────┘   │
│ [📝 Tạo script →] [📤 Lên lịch →] [🗑 Xóa]                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```
## 7. States
| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Shimmer |
| LOADED | Idea shown | Full detail view |
| GENERATING | AI creating variations | "🤖 Đang tạo variations..." |
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
IdeaDetailScreen
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
| [W011] Web Idea Detail | Web equivalent |
| [M005] Idea Board | Parent |
| [M013] Scripts | Next step |
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
