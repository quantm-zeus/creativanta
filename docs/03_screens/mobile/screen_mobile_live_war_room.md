# Screen: Mobile — Live War Room

> **Screen ID**: M055
> **Module**: M17 — Live Commerce War Room
> **Route**: `/live/[streamId]` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (live_streams, live_metrics), B5 RBAC §2.7

---

## 1. Purpose & Context
Real-time command center during live streams — concurrent viewers, engagement rate, AI-suggested talking points, pinned product, and audience sentiment. Updated every 5 seconds.
### Entry Points - Go Live → auto-opens / Push: "🔴 You're live!"
### Exit Points - "End stream" → post-stream summary

---

## 2. Screen Layout
### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ 🔴 LIVE · 45:23                           [📊 Stats] [⏹ End]     │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Live Metrics (real-time) ───────────────────────────────────┐   │
│ │ 👁 1,234 viewers (peak: 1,567) · ⬆ Trending                  │   │
│ │ ❤ 8,234 reactions · 💬 456 comments · 📤 67 shares          │   │
│ │ 🛒 Orders during stream: 23 · Revenue: 4.5M                  │   │
│ │ Engagement: 12.3% 🟢 · Sentiment: 😊 85% positive           │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ AI Coach (floating overlay) ────────────────────────────────┐   │
│ │ 💡 "Viewers dropping — try a giveaway!"                      │   │
│ │ 💡 "Top question: 'How to use serum?'"                       │   │
│ │ 📌 Pinned product: "Serum HA" — 45 clicks                   │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Comment Feed (scrolling) ───────────────────────────────────┐   │
│ │ @user1: "Mua serum ở đâu?" ← AI auto-reply ready           │   │
│ │ @user2: "Bao nhiêu tiền?" ← [📌 Pin]                       │   │
│ │ @user3: "❤❤❤"                                                │   │
│ │ ⚠️ @troll: "..." ← [🚫 Block] [🗑 Delete]                 │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ [🛒 Pin product ▾] [🎁 Giveaway] [📌 Pin comment]                 │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```
## 7. States
| State | Condition | Visual |
|---|---|---|
| PRE_LIVE | Setting up | "Go live in 3..." countdown |
| LIVE | Streaming | Real-time metrics + comments |
| VIEWERS_DROPPING | > 20% drop in 5min | "⚠️ Viewers dropping!" + AI tip |
| ENDING | End stream confirm | "Kết thúc live?" confirm dialog |
| ENDED | Stream done | Summary: duration, peak viewers, revenue |
| ERROR | Stream error | "⚠️ Connection issue. [Reconnect]" |

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
LiveWarRoomScreen
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
| [W109] Web Live War Room | Web equivalent |
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
