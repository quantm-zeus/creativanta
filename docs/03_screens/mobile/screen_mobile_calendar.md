# Screen: Mobile — Publish Calendar

> **Screen ID**: M045
> **Module**: M08 — Publish & Schedule
> **Route**: `/calendar` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (scheduled_posts, content_items), B5 RBAC §2.7

---
## 1. Purpose & Context

Mobile content calendar — visual week/month timeline of scheduled, published, and draft posts. Enables creators to visualize publishing cadence, identify gaps and conflicts, and quickly reschedule. Optimized for "check my schedule at a glance."

### Entry Points
- Publish Queue (M046): "📅 Calendar" button
- Home Dashboard (M001): Content Pipeline → "📅 Calendar"
- Push: "📅 Bạn có 1 bài lên lịch hôm nay"

### Exit Points
- Tap post → Content Detail/Editor
- Tap empty slot → "+" Quick Capture with pre-set date
- "📋 Queue" → Publish Queue (M046)

---
## 2. Preconditions / Postconditions

### Preconditions
- `publish:read` permission · Connected platforms · Calendar range fetched

### Postconditions
- Rescheduled posts → `scheduled_posts.scheduled_at` updated
- New content from empty slot → draft created
- Page view logged

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Calendar                          [View: Week ▾] [+ Post] [📋]   │
├──────────────────────────────────────────────────────────────────────┤
│ ← March 24–30, 2026 →                                                │
│ ┌─ Week Grid ─────────────────────────────────────────────────────┐  │
│ │ Mon 24  │ Tue 25     │ Wed 26 │ Thu 27   │ Fri 28 │ Sat │ Sun │  │
│ │         │ 🎵 19:00   │        │ 📸 12:00 │ 📺 10:00│    │     │  │
│ │         │ "5 tips"   │        │ "Serum"  │ "How to"│    │     │  │
│ │         │ 🟢         │        │ 🟡       │ 🔴      │    │     │  │
│ └────────────────────────────────────────────────────────────────┘   │
│ Legend: 🟢 Ready  🟡 Draft  🔴 Missing  ○ Empty slot                │
│                                                                      │
│ ── Today's Detail ───────────────────────────────────────────────── │
│ ┌─ Post Card ──────────────────────────────────────────────────────┐│
│ │ [📸] "5 tips nấu ăn" · 🎵 TikTok · 19:00 · [🟢 Ready]        ││
│ │ [📤 Publish now] [✏ Edit] [📅 Đổi lịch]                        ││
│ └──────────────────────────────────────────────────────────────────┘│
│ ── Upcoming ───────────────────────────────────────────────────────  │
│ │ Thu 27 12:00 · "Serum review" · 📸 IG · [🟡 Draft]             │ │
│ │ Fri 28 10:00 · "How to..." · 📺 YouTube · [🔴 Missing video]   │ │
│ Pull-to-refresh                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
PublishCalendarPage
├── AppBar (BackButton, Title, ViewToggle, AddPost, QueueButton)
├── WeekNavigator ("← March 24–30 →")
├── CalendarGrid (Week or Month)
│   └── DayColumn[] → DayHeader, PostDot[], PostMiniCard, EmptySlotButton
├── Legend
├── TodayDetailSection → PostCard (expanded)
├── UpcomingSection → PostRow[] (compact)
└── BottomNavBar
```

---
## 5. Data Binding & Display Format

| Element | Source | API | Format | Cache |
|---|---|---|---|---|
| Calendar posts | `scheduled_posts` by date range | `PublishService/GetCalendar(start, end)` | Dots/cards on grid | 5m |
| Post status | Completeness check | Client-side | 🟢/🟡/🔴 | — |
| Platform tokens | `connected_accounts` | `AccountService/GetStatus` | 🟢/🔴 badge | 5m |

---
## 6. Actions Table

| # | Action | Trigger | API Call | Permission |
|---|---|---|---|---|
| 1 | Tap post | Tap dot/card | — → Content Editor | `publish:read` |
| 2 | Tap empty slot | Tap empty day | — → Quick Capture (date pre-set) | `publish:create` |
| 3 | Toggle view | "Week ▾"/"Month ▾" | Client-side | `publish:read` |
| 4 | Navigate week | Tap ←/→ | `GetCalendar(new_range)` | `publish:read` |
| 5 | Publish now | "📤" on today's post | `PublishService/PublishNow` | `publish:create` |
| 6 | Reschedule | "📅 Đổi lịch" | `PublishService/Reschedule` | `publish:edit` |
| 7 | Open queue | "📋" | — → M046 | `publish:read` |
| 8 | Pull refresh | Pull-down | Refetch range | `publish:read` |

---
## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Grid shimmer |
| LOADED | Data ready | Grid + today detail + upcoming |
| EMPTY_WEEK | No posts this week | "📅 Tuần này chưa lên lịch. [+ Lên lịch →]" |
| HAS_MISSING | Posts with missing assets | Red dots + badge |
| HAS_GAPS | 3+ consecutive empty days | "+" pulse on empty days |
| MONTH_VIEW | Month view active | Compact dot grid |
| ERROR | API failed | Error + retry |
| OFFLINE | No network | Cached data + banner |

---
## 8. Permissions & Role-based Behavior

| Action | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View calendar | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ❌ |
| Add post | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Publish now | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Reschedule | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

---
## 9. Mobile-specific UX

### Gestures & Haptics
| Gesture | Target | Haptic | Result |
|---|---|---|---|
| Tap day | DayColumn | Light | Select day, show detail |
| Swipe left/right | Grid | — | Previous/next week |
| Long press dot | PostDot | Heavy | Quick preview peek |
| Pull down | Page | Light | Refresh |

### Week vs Month: Week shows mini-cards; Month shows dots only, tap to expand.
### Offline: Cached grid readable. Actions disabled. Banner: "📡 Ngoại tuyến"

---
## 10. Edge Cases

| Edge Case | Handling |
|---|---|
| 5+ posts same day | Stack dots (max 3 visible) + "+2" badge |
| Past dates | Grey out. Show final status (✅/❌/🔄) |
| Schedule conflict | Orange outline + "⚠️ Trùng giờ" |
| Today highlight | Accent border on today column |

---
## 11. Navigation Map

```
/calendar → /publish/edit/[id] | /capture | /publish (queue)
```

---
## 12. Error Handling

| Error | UI Response | Recovery |
|---|---|---|
| Offline | Cached calendar + banner | Pull-to-refresh |
| API 5xx | Toast: "Không tải được lịch" | Retry |
| Reschedule failed | Toast: "Đổi lịch thất bại" | Retry |

---
## 13. Accessibility

| Element | Requirement |
|---|---|
| Day headers | `Semantics(header: true, label: "Thứ Ba 25 tháng 3, 1 bài")` |
| Post dots | `Semantics(label: "5 tips, TikTok, 19 giờ, sẵn sàng")` |
| Empty slots | `Semantics(button, label: "Thêm bài ngày 26")` |

---
## 14. Localization Notes

- Days: "T2"–"CN" (abbreviated Vietnamese)
- Month: "Tháng 3, 2026"
- Time: 24h ("19:00")
- Status: "Sẵn sàng", "Bản nháp", "Thiếu media"

---
## 15. Analytics / Tracking Events

| Event | Properties |
|---|---|
| `calendar.viewed` | `view_type`, `visible_posts`, `empty_days` |
| `calendar.post_opened` | `post_id`, `status` |
| `calendar.empty_slot_tapped` | `date` |
| `calendar.view_toggled` | `new_view` |

---
## 16. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Today column border, add button |
| `--color-success` | Ready dot (🟢) |
| `--color-warning` | Draft dot (🟡), conflict |
| `--color-danger` | Missing dot (🔴) |
| `--color-today-highlight` | Today column tint |

---
## 17. Related Screens

| Screen | Relationship |
|---|---|
| [W046] Web Calendar | Web equivalent |
| [M046] Publish Queue | List complement |
| [M006] Quick Publish | Create from empty slot |

---
## 18. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 2.0 | **Full Tier A rewrite** from Tier C. Added 18-section structure: week/month grid, status dots, today detail, RBAC, gestures, edge cases, accessibility, analytics. Replaced ALL template placeholders. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
