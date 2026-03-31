# Screen: Mobile — Quick Edit

> **Screen ID**: M52
> **Module**: M07 — AI Studio
> **Route**: `/studio/quick-edit` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 04, A1 Schema (assets)

---

## 1. Purpose & Context

Mobile-optimized transcript-based video editing. Upload from camera roll → AI transcribes → swipe words to delete → toggle edit options → generate. Tabbed UI: Transcript, Edit Plan, Settings.

### User Story
> As a creator on the go, I want to quickly clean up my video by removing filler words using my phone.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Quick Edit                                [Credits: ~25] [⋮]     │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Video Player (full width, 16:9) ──────────────────────────────┐ │
│ │ [Video preview with playhead]                                   │ │
│ │ [Before ◀ ▶ After] toggle overlay                               │ │
│ │ ▶ 00:35 / 02:15                                                │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ Tabs: [📝 Transcript] [✂️ Edit Plan] [⚙️ Settings]                │
│                                                                      │
│ ── Transcript Tab ──                                                 │
│ ┌─ Transcript (scrollable) ──────────────────────────────────────┐ │
│ │ [00:00] "Xin chào các bạn, hôm nay mình sẽ..."               │ │
│ │ [00:05] "review sản phẩm serum vitamin C này"   [🟡 uh]       │ │
│ │ [00:12] "Đầu tiên mình thấy là texture rất..."                │ │
│ │ [00:18] "nhẹ và thấm nhanh vào da" [🔴 long pause]            │ │
│ │                                                                  │ │
│ │ Swipe word left = strike-through (delete)                       │ │
│ │ Tap word = select/deselect                                      │ │
│ │ Long press = context menu (delete/restore/split)                │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ [▶ Preview — free] [🚀 Apply edits — 25 credits]                   │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬•] [💬] [📊]                                         │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3-5. Component & Actions

```
MobileQuickEditPage
├── AppBar (← back, title, credits, menu)
├── VideoPlayer (full-width)
├── TabBar (Transcript / Edit Plan / Settings)
├── TranscriptTab
│   └── TranscriptWordList (swipeable words with filler badges)
├── EditPlanTab
│   └── EditOptionCheckboxList
├── SettingsTab
│   └── Platform/Export settings
└── ActionBar (Preview, Apply)
```

| # | Action | Gesture | Result |
|---|---|---|---|
| 1 | Delete word | Swipe left on word | Word struck through |
| 2 | Restore | Tap struck word | Word restored |
| 3 | Toggle option | Tap checkbox | Edit plan updated |
| 4 | Apply | "🚀 Apply" | → Generation queue |

### Flutter Implementation
- Swipeable: `Dismissible` widget on each word
- Video: `video_player` package
- Haptic: on swipe threshold

### Related Screens: [W25] Web Quick Edit, [M21] Mobile Studio Launcher

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

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
QuickEditScreen
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
