# Screen: Mobile — Trend List

> **Screen ID**: M14
> **Module**: M02 — Trend Radar
> **Route**: `/trends` (mobile app)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 01 §4, Product Freeze §10/§11, A1 Schema (trends, watchlists)

---

## 1. Purpose & Context

Mobile Trend List is the mobile-optimized version of the Trend Radar. Single-column card stack optimized for vertical scroll, with platform filter chips and swipe-to-save gestures.

### User Story
> As a creator on mobile, I want to browse trending topics quickly and save interesting ones for content creation later.

### Entry Points
- Home Dashboard: AI Pulse "Xem tất cả →"
- Bottom sheet: intelligence section
- Push notification: "3 xu hướng mới phù hợp"

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ 🔥 Xu hướng                                    [Filter ▾]          │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Platform Chips ───────────────────────────────────────────────┐  │
│ │ [Tất cả] [🎵 TikTok] [📸 Instagram] [📺 YouTube] [🛍 Shopee]│  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Trend Card ────────────────────────────────────────────────────┐ │
│ │ 🔥 "AI cooking assistant"                          ⭐ 92/100  │ │
│ │ 🎵 TikTok · +340% (7d) · 1.2M views                          │ │
│ │ Food & Cooking                                                  │ │
│ │ [📈 Mini sparkline]                                             │ │
│ │ [💡 Tạo ý tưởng] [📌 Lưu]                  ← swipe: 📌     │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Trend Card ────────────────────────────────────────────────────┐ │
│ │ 🔥 "Minimalist skincare for acne"              ⭐ 78/100      │ │
│ │ 📸 Instagram · +180% (3d) · 450K reach                        │ │
│ │ Beauty & Skincare                                               │ │
│ │ [📈 Mini sparkline]                                             │ │
│ │ [💡 Tạo ý tưởng] [📌 Lưu]                                    │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ... scroll for more ...                                              │
│                                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                           │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
MobileTrendListPage
├── AppBar ("🔥 Xu hướng" + FilterButton)
├── PlatformFilterChips (horizontal scroll)
├── TrendCardList (pull-to-refresh)
│   └── TrendCard[] (swipeable)
│       ├── TrendTitle
│       ├── StrengthScoreBadge (color-coded)
│       ├── PlatformIcon + GrowthIndicator + Volume
│       ├── CategoryChip
│       ├── SparklineMini
│       ├── ActionRow
│       │   ├── CreateIdeaButton
│       │   └── SaveButton
│       └── SwipeRightAction (Save to watchlist)
└── BottomNavBar
```

---

## 4-5. Data & Actions

Same API as [W09] Web Trend Radar with mobile-optimized payload.

| # | Action | Trigger | API | Result |
|---|---|---|---|---|
| 1 | Open detail | Tap card | — | Push → M15 Trend Detail |
| 2 | Create idea | "💡 Tạo ý tưởng" | `IdeaService/Create(from_trend_id)` | Toast + navigate |
| 3 | Save to watchlist | "📌 Lưu" or swipe right | `WatchlistService/AddItem` | Haptic + pin fills |
| 4 | Filter platform | Tap chip | Refetch | List filters |
| 5 | Pull refresh | Gesture | Refetch | List updates |

---

## 6-20. Standard Sections

### Mobile UX
- Swipe right: save to watchlist (haptic feedback)
- Pull-to-refresh: custom branded indicator
- Infinite scroll: 20 items per page, cursor-based
- Score badge colors: 🟢 ≥80, 🟡 50-79, 🔴 <50

### States
| State | Visual |
|---|---|
| LOADING | Card shimmer skeletons |
| LOADED | Card list with sparklines |
| EMPTY | "Kết nối nền tảng để khám phá xu hướng!" + connect CTA |
| EMPTY_FILTERED | "Không có xu hướng cho [platform]. [Xóa bộ lọc]" |

### Flutter Implementation
- Widget: `TrendListPage extends ConsumerWidget`
- State: Riverpod `trendListProvider`
- Sparkline: custom `CustomPainter` widget
- Swipe: `Dismissible` with `confirmDismiss`

### Related Screens
| Screen | Relationship |
|---|---|
| [W09] Web Trend Radar | Web equivalent |
| [M15] Mobile Trend Detail | Detail after tap |
| [M01] Mobile Home | AI Pulse links here |

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-27 | 1.0 | Initial specification |

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
