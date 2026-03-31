# Screen: Mobile — Clip Factory

> **Screen ID**: M53
> **Module**: M07 — AI Studio
> **Route**: `/studio/clip-factory` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 04, A1 Schema (assets)

---

## 1. Purpose & Context

Mobile clip factory uses Tinder-style swipe selection for detected clips. Upload long video → AI analyzes → swipe through clips (right=select, left=skip, up=preview) → batch generate selected.

### User Story
> As a creator, I want to quickly sift through AI-detected clips using swipe gestures and select the best ones to export.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Clip Factory                              [Credits: ~15/clip]    │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Clip Card Stack (Tinder-style) ───────────────────────────────┐ │
│ │ ┌──────────────────────────────────────────────────────────┐   │ │
│ │ │ [Video preview 9:16]                                      │   │ │
│ │ │ ▶ Clip 3 of 8 · 00:45 - 01:12 (27s)                     │   │ │
│ │ │                                                            │   │ │
│ │ │ 🔥 Virality: 87/100                                       │   │ │
│ │ │ "Review serum — before/after reveal"                       │   │ │
│ │ │                                                            │   │ │
│ │ │ ← SKIP                                   SELECT →         │   │ │
│ │ └──────────────────────────────────────────────────────────┘   │ │
│ │ Swipe RIGHT = Select · Swipe LEFT = Skip · Swipe UP = Preview │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ Selected: 3 clips · [📋 Review selected]                            │
│ [🚀 Generate 3 clips — 45 credits]                                  │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬•] [💬] [📊]                                         │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3-5. Component & Actions

```
MobileClipFactoryPage
├── UploadStep (upload long video)
├── AnalysisProgress (loading)
├── SwipeStack
│   └── ClipCard[] (stacked, swipeable)
│       ├── VideoPreview
│       ├── ClipInfo (number, timestamp, duration)
│       ├── ViralityBadge
│       └── DescriptionSnippet
├── SelectionCounter
├── ReviewButton → BottomSheet (list selected clips)
└── GenerateButton
```

| # | Action | Gesture | Result |
|---|---|---|---|
| 1 | Select | Swipe right | Card flies right, haptic |
| 2 | Skip | Swipe left | Card flies left |
| 3 | Preview | Swipe up | Full-screen preview |
| 4 | Generate | Bottom button | → Queue |

### Flutter Implementation
- Card stack: `flutter_card_swiper` or custom `GestureDetector` + `Transform`
- Haptic: medium on selection, light on skip
- Video preview: auto-play muted

### Related Screens: [W26] Web Clip Factory, [M21] Studio Launcher

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
ClipFactoryScreen
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
