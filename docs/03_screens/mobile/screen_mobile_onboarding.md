# Screen: Mobile — Onboarding Flow

> **Screen ID**: M054
> **Module**: M01 — Home (First Run)
> **Route**: `/onboarding` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (user_profiles, onboarding_progress)

---

## 1. Purpose & Context

5-step onboarding for first-time mobile users — welcome, niche selection, platform connect, first AI idea, and completion. Optimized for < 2 minute completion with skip option.

### Entry Points
- First app launch (auto-trigger)
- Re-onboarding from Settings

### Exit Points
- "Bỏ qua →" → Dashboard (skip)
- Step 5 complete → Dashboard

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ Step 1 of 5                                         [Bỏ qua →]    │
├──────────────────────────────────────────────────────────────────────┤
│ ── Step 1: Welcome ──                                                │
│ ┌────────────────────────────────────────────────────────────────┐  │
│ │ [🎬 Welcome animation — Lottie]                               │  │
│ │ "Chào mừng đến Creativanta!"                                  │  │
│ │ "Nền tảng AI giúp bạn tạo nội dung hiệu quả hơn"           │  │
│ │ [Bắt đầu →]                                                   │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ── Step 2: Niche (multi-select, max 3) ──                           │
│ [🍳 Ẩm thực] [💄 Beauty] [📱 Tech] [👗 Fashion]                 │
│ [📚 Education] [🏋 Fitness] [🎮 Gaming] [✈ Travel]               │
│                                                                      │
│ ── Step 3: Connect Platforms ──                                      │
│ [🎵 TikTok — Kết nối] [📸 Instagram — Kết nối]                  │
│ [▶ YouTube — Kết nối] [⏭ Kết nối sau]                            │
│                                                                      │
│ ── Step 4: First Idea ──                                             │
│ [🤖 AI generating your first content idea...]                      │
│ → Card preview: "5 tips nấu ăn healthy cho newbie"                 │
│ [❤ Thích] [→ Tiếp]                                                 │
│                                                                      │
│ ── Step 5: Done ──                                                   │
│ "🎉 Hoàn tất! Bạn đã sẵn sàng sáng tạo!"                        │
│ [→ Vào Dashboard]                                                    │
├──────────────────────────────────────────────────────────────────────┤
│ [● ○ ○ ○ ○] Progress dots                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| WELCOME | Step 1 | Lottie animation |
| NICHE_SELECT | Step 2 | Chip grid |
| PLATFORM_CONNECT | Step 3 | OAuth buttons |
| AI_GENERATING | Step 4 | AI shimmer → idea card |
| COMPLETE | Step 5 | Celebration |
| SKIPPED | User skipped | → Dashboard (tutorial tooltips) |

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
OnboardingFlowScreen
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
| [W006] Web Onboarding | Web equivalent |
| [M001] Dashboard | Destination |
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
