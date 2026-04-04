# Screen: Mobile — Gamification

> **Screen ID**: M038
> **Module**: M23 — Analytics (Gamification)
> **Route**: `/gamification` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (user_levels, user_quests, achievements, streaks), B5 RBAC §2.7

---

## 1. Purpose & Context

Mobile gamification — level progress, streak counter, active quests, achievement grid, and leaderboard. Motivational quick glance designed to drive daily engagement.

### Entry Points
- Home dashboard: Level/XP widget
- Push: "🔥 Streak 14 ngày! Đừng phá vỡ!"
- Analytics: "🎮 Gamification" tab

### Exit Points
- "Leaderboard →" → leaderboard screen
- Quest tap → quest detail bottom sheet

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Level & Achievements                                              │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Level Card ──────────────────────────────────────────────────┐   │
│ │ ⭐ Level 12 "Content Pro"                                     │   │
│ │ XP: 2,840 / 3,200 [██████████████░░░] 88%                    │   │
│ │ Next: Level 13 "Rising Star" — 360 XP to go                  │   │
│ │ 🔥 Streak: 14 ngày — Best: 21 ngày                           │   │
│ │ Streak bonus: +20% XP today                                   │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Active Quests ───────────────────────────────────────────────┐   │
│ │ 🎯 "Publish 3 videos" — 2/3 — +50 XP — Due: 2d             │   │
│ │ [██████████████░░░░░░] 67%                                     │   │
│ │ 🎯 "Reply 10 comments" — 7/10 — +30 XP — Due: today        │   │
│ │ [██████████████████████░] 70%                                  │   │
│ │ 🎯 "First live session" — 0/1 — +100 XP 🏆                  │   │
│ │ [░░░░░░░░░░░░░░░░░░░░░] 0%                                    │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Achievements (3×3 grid) ─────────────────────────────────────┐   │
│ │ [🌟 First Post] [🔥 7d Streak] [🎬 10 Videos]               │   │
│ │ [💰 First Sale] [🤖 AI Power] [🎤 First Live]               │   │
│ │ [⬜ Locked]     [⬜ Locked]    [⬜ Locked]                    │   │
│ │ 6/12 unlocked · Tap for details                                │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ [🏆 Leaderboard →]                                                  │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Card shimmer |
| LOADED | Data ready | Level + quests + achievements |
| QUEST_COMPLETED | Quest just done | 🎉 celebration animation + XP toast |
| LEVEL_UP | Just leveled up | Full-screen celebration with confetti |
| STREAK_BROKEN | Streak ended | "😢 Streak kết thúc ở {n} ngày. Bắt đầu lại!" |
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
GamificationScreen
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
| [W079] Web Gamification | Web equivalent |
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
