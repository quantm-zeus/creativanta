# Screen: Mobile — Performance Coach

> **Screen ID**: M039
> **Module**: M23 — Analytics
> **Route**: `/analytics/coach` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (coaching_insights, weekly_reports), B5 RBAC §2.7

---

## 1. Purpose & Context

Mobile AI performance coach — weekly coaching cards with actionable recommendations, content quality scores, and "do this next" suggestions.

### Entry Points
- Analytics → "💡 Coach" tab
- Push: "💡 Your weekly performance report is ready"

### Exit Points
- Tap recommendation → relevant screen

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Performance Coach                                                 │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Weekly Score ────────────────────────────────────────────────┐   │
│ │ 📊 This Week: 82/100 (↑5 vs last week)                       │   │
│ │ Grade: A- · Streak: 3 weeks improving                        │   │
│ │ Best post: "5 tips" (ER 8.2%) · Worst: "Review" (ER 2.1%)  │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Recommendation Card ────────────────────────────────────────┐   │
│ │ 💡 "Post more 'tips' content — 4/5 top posts are tips"      │   │
│ │ Impact: High · Effort: Low                                    │   │
│ │ [📝 Create a tips video →]                                    │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Recommendation Card ────────────────────────────────────────┐   │
│ │ 💡 "Post at 19:00 — your audience is most active"            │   │
│ │ Impact: Medium · Effort: Low                                   │   │
│ │ [📅 Schedule for 19:00 →]                                     │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Recommendation Card ────────────────────────────────────────┐   │
│ │ 💡 "Add CTA overlay — estimated +50 followers/video"         │   │
│ │ Impact: Medium · Effort: Medium                                │   │
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
| LOADING | Generating | "🤖 Analyzing your performance..." |
| LOADED | Coach ready | Score + recommendations |
| NO_DATA | < 3 posts | "Cần ít nhất 3 bài đăng để AI Coach phân tích." |
| IMPROVING | Score increasing | Green trend: "🔥 3 tuần liên tục cải thiện!" |
| DECLINING | Score dropping | Orange: "📉 Hiệu suất giảm. Xem recommendations." |
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
PerformanceCoachScreen
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
| [W077] Web Performance Metrics | Web equivalent |
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
