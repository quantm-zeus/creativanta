# Screen: Web — Schedule Calendar

> **Screen ID**: W046
> **Module**: M08 — Publish & Packaging
> **Route**: `/publish/calendar`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §18-19, A1 Schema (publish_items, published_posts, connectors), B5 RBAC §2.7

---

## 1. Purpose & Context

The Schedule Calendar is the visual content planning hub — a week/month calendar view displaying all scheduled, published, and draft content across platforms. Creators can visually plan content cadence, identify posting gaps, drag-to-reschedule posts, and see AI-recommended optimal time slots. This screen complements the Publish Queue (list view) by providing temporal/spatial awareness of content distribution.

### User Story
> As a creator managing a content calendar across 3-5 platforms, I want a visual calendar showing when each post is scheduled so I can identify gaps, avoid platform conflicts, and maintain consistent posting cadence.

### Business Goals
- Improve posting consistency by visualizing content cadence and gaps
- Reduce scheduling conflicts (posting too close together or overlapping)
- Drive content creation by highlighting empty days/slots
- Enable rapid rescheduling via drag-and-drop (reduce time-to-adjust)
- Surface AI best-time insights directly on the calendar

### When This Screen Is Used
- **Weekly planning**: Sunday evening, planning the week's content schedule
- **Post-publish review**: Seeing what was published vs. what was planned
- **Rescheduling**: Moving a post to a better time slot
- **Gap filling**: Creator sees empty days and decides to create more content
- **Team coordination**: Multiple editors checking who's posting when

### Entry Points
- Sidebar: Publish → "📅 Lịch đăng bài"
- Publish Queue ([W043]): "📅 Calendar" view toggle
- Publish Composer ([W048]): After scheduling → redirect to Calendar with highlight
- Morning Brief ([W003]): Content suggestion CTAs
- Direct URL: `/publish/calendar` or `/publish/calendar?week=2026-W13`

### Exit Points
- Click event → `/publish/[id]` (Publish Item Detail W045)
- Click empty slot → `/publish/compose?date=YYYY-MM-DD&time=HH:mm` (Composer pre-filled)
- "+ Tạo" → `/publish/compose` (Composer empty)
- "← Publish" → `/publish` (back to queue)

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid session
- User has `publish:read` permission
- At least one platform connector configured (otherwise: empty state with setup CTA)

### Postconditions
- Drag-and-drop reschedule updates `publish_items.scheduled_at` via API
- Calendar view preference (week/month) persisted to `localStorage`
- Selected date range persisted in URL (shareable calendar links)

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell (sidebar 240px) + Full calendar grid |
| Tablet (768-1279px) | App Shell (collapsed sidebar) + Calendar (3-day view instead of week) |
| Mobile (≤767px) | Redirect to Mobile Calendar (M025) |

### ASCII Wireframe (Week View)
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 📅 Lịch đăng bài    [◀ Tuần trước] Tuần 13 · 24-30 Mar [Tuần sau ▶]│
│                      [Week | Month] [Platform ▾: All]    [+ Tạo]   │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│         Mon 24   Tue 25   Wed 26   Thu 27   Fri 28   Sat 29  Sun 30│
│ ┌───────┬────────┬────────┬────────┬────────┬────────┬────────┐    │
│ │ 06:00 │        │        │        │        │        │        │    │
│ │       │        │        │        │        │        │        │    │
│ │ 12:00 │        │ 📤📸  │        │        │        │        │    │
│ │       │        │ serum  │        │        │        │        │    │
│ │       │        │ review │        │        │        │        │    │
│ │       │        │ ✅Live │        │        │        │        │    │
│ │ 18:00 │        │        │        │ 📤🎵  │        │        │    │
│ │       │        │        │        │ 5 tips │        │        │    │
│ │       │        │        │        │ cook   │        │        │    │
│ │       │        │        │        │ ✅Live │      ----       │    │
│ │ 19:00 │        │ 📤🎵  │        │ 📤📸  │        │ (empty) │    │
│ │       │        │ tips   │        │ 5 tips │        │  AI:   │    │
│ │       │        │ skin   │        │ cook   │        │ "Đăng  │    │
│ │       │        │ ✅Live │        │ ⏰Schd │        │ weekend│    │
│ │ 20:00 │ 📤📺  │        │        │        │ 📤🎵  │ 1 bài" │    │
│ │       │ tutori │        │        │        │ meal   │        │    │
│ │       │ al     │        │        │        │ prep   │        │    │
│ │       │ ✅Live │        │        │        │ ⏰Schd │        │    │
│ │       │        │        │        │        │        │        │    │
│ └───────┴────────┴────────┴────────┴────────┴────────┴────────┘    │
│                                                                      │
│ 🟢 AI Best Times: 19:00-21:00 (highlighted in green on time axis)  │
│ 📊 This week: 6 posts · 3 platforms · Gap: Sat-Sun                 │
│ 🤖 AI: "Đăng thêm 1 bài cuối tuần để maintain cadence"             │
└──────────────────────────────────────────────────────────────────────┘
```

### ASCII Wireframe (Month View)
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 📅 Lịch đăng bài   [◀ Tháng trước] Tháng 3, 2026 [Tháng sau ▶]    │
│                     [Week | Month] [Platform ▾: All]    [+ Tạo]     │
├──────────────────────────────────────────────────────────────────────┤
│     Mon    Tue    Wed    Thu    Fri    Sat    Sun                     │
│ ┌──────┬──────┬──────┬──────┬──────┬──────┬──────┐                  │
│ │      │      │      │      │      │  1   │  2   │                  │
│ │      │      │      │      │      │      │      │                  │
│ ├──────┼──────┼──────┼──────┼──────┼──────┼──────┤                  │
│ │  3   │  4   │  5   │  6   │  7   │  8   │  9   │                  │
│ │ 🎵📸│      │ 🎵  │      │ 📺  │      │      │                  │
│ ├──────┼──────┼──────┼──────┼──────┼──────┼──────┤                  │
│ │ 10   │ 11   │ 12   │ 13   │ 14   │ 15   │ 16   │                  │
│ │ 🎵  │      │ 📸🎵│      │ 🎵📺│      │      │                  │
│ ├──────┼──────┼──────┼──────┼──────┼──────┼──────┤                  │
│ │ 17   │ 18   │ 19   │ 20   │ 21   │ 22   │ 23   │                  │
│ │      │ 🎵  │ 📸  │      │ 🎵  │      │      │                  │
│ ├──────┼──────┼──────┼──────┼──────┼──────┼──────┤                  │
│ │ 24   │ 25   │ 26   │ 27   │ 28   │ 29   │ 30   │                  │
│ │ 📺  │ 📸🎵│ 🎵  │ 🎵📸│ 🎵  │      │      │                  │
│ │      │      │      │      │ ⏰  │      │      │                  │
│ └──────┴──────┴──────┴──────┴──────┴──────┴──────┘                  │
│                                                                      │
│ March summary: 18 posts · Gap days: 8 · Avg: 4.5 posts/week        │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
ScheduleCalendarPage
├── AppShell (shared)
│   ├── Sidebar
│   └── TopBar
├── PageHeader
│   ├── Title ("📅 Lịch đăng bài")
│   ├── NavigationControls
│   │   ├── PrevButton ("◀ Tuần/Tháng trước")
│   │   ├── CurrentLabel ("Tuần 13 · 24-30 Mar" or "Tháng 3, 2026")
│   │   └── NextButton ("Tuần/Tháng sau ▶")
│   ├── ViewToggle (Week | Month radio buttons)
│   ├── PlatformFilter (dropdown: All / TikTok / IG / YouTube / X)
│   └── CreateButton ("+ Tạo" → Composer)
├── CalendarGrid
│   ├── DayHeaders (Mon-Sun column labels with date)
│   ├── TimeAxis (Week view: 06:00 - 23:00 in 1h increments)
│   ├── AIBestTimeHighlight (green overlay on optimal time slots)
│   └── CalendarCell[][]
│       ├── EmptyCell (clickable → create with pre-filled date/time)
│       └── EventBlock[] (positioned by date/time)
│           ├── PlatformIcon (🎵/📸/📺/🐦)
│           ├── EventTitle (truncated, 2 lines max)
│           ├── StatusIndicator
│           │   ├── Published ("✅ Live" — green)
│           │   ├── Scheduled ("⏰ Scheduled" — blue)
│           │   ├── Draft ("📝 Draft" — grey)
│           │   └── Failed ("❌ Failed" — red)
│           ├── DragHandle (cursor: grab — for rescheduling)
│           └── ClickTarget → navigate to Publish Item Detail
├── EventPopover (on click/hover on event block)
│   ├── Thumbnail (small)
│   ├── FullTitle
│   ├── PlatformBadge + Status
│   ├── ScheduledTime
│   ├── Metrics (if published: views, ER)
│   └── QuickActions
│       ├── ViewDetailLink
│       ├── RescheduleButton (opens time picker)
│       └── CancelButton (for scheduled only)
├── CalendarFooter
│   ├── AIBestTimeLegend ("🟢 AI Best Times: 19:00-21:00")
│   ├── WeekSummary ("6 posts · 3 platforms · Gap: Sat-Sun")
│   └── AIAdvice ("🤖 Đăng thêm 1 bài cuối tuần để maintain cadence")
└── EmptyState (when no events at all)
    ├── Illustration (empty calendar)
    ├── Message ("Chưa có bài nào được lên lịch")
    └── CTAButton ("📤 Tạo bài đầu tiên")
```

---

## 5. Displayed Data / Data Binding

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Calendar events | `publish_items WHERE scheduled_at BETWEEN range` + `published_posts` | `PublishService/ListByDateRange(start, end, platform?)` | Event blocks positioned on grid | 5m TTL |
| Event title | `publish_items.title` | Included in list | Truncated 2 lines | 5m TTL |
| Event platform | `publish_items.target_platforms[]` | Included | Platform icon | 5m TTL |
| Event status | `publish_items.status` + `published_posts.status` | Included | Status badge (Live/Scheduled/Draft/Failed) | 5m TTL |
| Event metrics (published) | `engagement_snapshots WHERE post_id` | `AnalyticsService/BatchGetPostMetrics` | Compact: "👁 24K · ER 8.2%" | 15m TTL |
| AI best times | Historical engagement data | `AnalyticsService/GetBestPostingTimes(workspace_id)` | Green highlighted time slots on grid | 24h TTL |
| Gap analysis | Computed from events | Client-side computation | "Gap: Sat-Sun" text + AI advice | Client-side |
| Week/month summary | Computed from events | Client-side | "6 posts · 3 platforms" | Client-side |

---

## 6. User Actions

| # | Action | Trigger | API Call | System Response | Permission |
|---|---|---|---|---|---|
| 1 | View event detail | Click event block | — | EventPopover appears (or navigate to detail on double-click) | `publish:read` |
| 2 | Navigate to detail | Click "View detail" in popover or double-click event | — | Navigate → `/publish/[id]` | `publish:read` |
| 3 | Drag to reschedule | Drag event to new time slot | `PublishService/Reschedule(id, new_datetime)` | Event moves. Toast: "Đã chuyển sang {new_time}." Undo available: "[↩ Hoàn tác]" | `publish:update` |
| 4 | Create from empty slot | Click empty time slot | — | Navigate → `/publish/compose?date=YYYY-MM-DD&time=HH:mm` | `publish:create` |
| 5 | Create new | "+" button | — | Navigate → `/publish/compose` | `publish:create` |
| 6 | Navigate week/month | ◀ ▶ buttons | Refetch `PublishService/ListByDateRange(new_range)` | Calendar updates with transition animation | `publish:read` |
| 7 | Toggle week/month | View toggle | Client-side | View switches. URL updates. | `publish:read` |
| 8 | Filter by platform | Platform dropdown | Client-side filter + refresh | Events filtered. Non-matching events dimmed or hidden. | `publish:read` |
| 9 | Cancel scheduled post | Popover "Cancel" → confirm | `PublishService/Cancel(id)` | Event removed from calendar. Toast: "Đã hủy lịch đăng." | `publish:update` |
| 10 | Reschedule from popover | Popover "Reschedule" → time picker | `PublishService/Reschedule(id, datetime)` | Event moves to new position | `publish:update` |

---

## 7. States / State Machine

| State | Condition | Visual |
|---|---|---|
| LOADING | Page load, fetching events | Calendar grid skeleton with shimmer on cells |
| LOADED | Events received | Full calendar with events placed. AI highlights visible. |
| EMPTY | No events in range | Empty grid + "Chưa có bài nào trong tuần/tháng này. [📤 Tạo bài]" |
| DRAGGING | User dragging an event | Event "lifts" with shadow. Target slot highlights. Time tooltip follows cursor. |
| RESCHEDULING | API call for reschedule in progress | Event at new position with pulsing opacity |
| ERROR | API failed to load events | "Không tải được lịch. [Thử lại]" |
| NAVIGATING | Switching week/month | Slide transition (left/right based on navigation direction) |

### Drag-and-Drop States
```
IDLE → DRAG_START (mousedown + 150ms hold) → DRAGGING (mousemove) →
  DROP_VALID (over valid slot) → CONFIRMING (API call) → IDLE
  DROP_INVALID (over past slot or conflict) → BOUNCE_BACK → IDLE
  DROP_CANCEL (escape key) → BOUNCE_BACK → IDLE
```

---

## 8. Validation Rules

### Reschedule (Drag-and-Drop)
| Rule | Check | Error |
|---|---|---|
| Future only | Cannot reschedule to past | Visual: invalid slot highlighted red. Snap back. |
| Min 15 min | Must be ≥ 15 min from now | Toast: "Cần ít nhất 15 phút từ bây giờ" |
| Platform conflict | No posting conflict (e.g., 2 TikTok posts within 1h) | Warning popover: "Đã có bài TikTok lúc {time}. Vẫn chuyển?" |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View calendar | ✅ | ✅ | ✅ | ✅ | ✅ (own content) | ✅ (read-only) | ❌ |
| Click event to detail | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ✅ | ❌ |
| Drag to reschedule | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Create from slot | ✅ | ✅ | ✅ | ✅ | ⚠️ own | ❌ | ❌ |
| Cancel scheduled post | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Filter by platform | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |

---

## 10. Navigation Map

```
Schedule Calendar (/publish/calendar)
├── → /publish/[id]                               (Event click → detail)
├── → /publish/compose?date=...&time=...           (Click empty slot → composer)
├── → /publish/compose                             (+ Tạo → composer)
└── ← /publish                                     (Back to queue/list)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Events load failed | API error | "Không tải được lịch. [Thử lại]" | Retry button |
| Reschedule API fails | Network error during drag | Event bounces back to original position. Toast: "Không chuyển được. [Thử lại]" | Retry drag or use popover |
| Time conflict detected | Two posts on same platform within 1h | Warning popover on drop: "Đã có bài {platform} lúc {time}. [Chuyển anyway] [Hủy]" | User confirms or cancels |
| Cancel fails | API error on cancel | Toast: "Không hủy được. [Thử lại]" | Retry |
| Past reschedule attempted | Drag to past date/time | Invalid slot highlighted red. Event snaps back. | User selects future slot |
| No connectors | No platform connectors configured | Empty state: "Chưa kết nối nền tảng nào. [Kết nối ngay →]" → Settings/Connectors | Setup connectors |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Calendar grid | `role="grid"`, `aria-label="Content publishing calendar for week 13, March 24-30"` |
| Day columns | `role="columnheader"`, `aria-label="Monday, March 24"` |
| Time rows | `role="rowheader"`, `aria-label="6 PM to 7 PM"` |
| Event blocks | `role="gridcell"`, `aria-label="5 tips cooking, TikTok, scheduled for Thursday 6 PM"`. `tabindex="0"`. |
| Drag-and-drop | `aria-grabbed`, `aria-dropeffect`. Keyboard alternative: select → arrow keys → Enter to drop. |
| Empty cells | `aria-label="Empty slot, Thursday 7 PM. Press Enter to create new post."` |
| AI highlights | `aria-label="AI recommended: optimal posting time from 7 PM to 9 PM"` (informational, not interactive) |
| Navigation | Arrow keys navigate between days/times. Enter opens event. Tab moves to header controls. |
| View toggle | `role="radiogroup"`, `aria-label="Calendar view"` |
| Color contrast | All text meets WCAG 2.1 AA (4.5:1 ratio). Events use icon+text, not color alone. |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Shell render | 0ms | App Shell renders (SSR). Calendar header + grid outline visible. |
| Grid skeleton | 0-200ms | Empty grid with day headers. Shimmer on cells. |
| Events populate | 200-600ms | Event blocks appear on grid with staggered fade-in |
| AI highlights | 300-800ms | Green overlay fades in on optimal time slots |
| Footer summary | 500-1000ms | Gap analysis and AI advice appear |

---

## 14. Performance Requirements

| Metric | Target | Measurement |
|---|---|---|
| LCP | < 2.0s | Calendar grid with at least 1 event rendered |
| FID | < 100ms | First click on event or empty slot |
| CLS | < 0.05 | No shift after events load (grid dimensions pre-calculated) |
| TTI | < 2.5s | Drag-and-drop interactive |
| Week navigation | < 300ms | Slide transition between weeks |
| Drag response | < 16ms per frame | 60fps drag animation |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| New scheduled events | SSE `/events/publish` | Real-time — new event slides into calendar with highlight |
| Published status change | SSE `/events/publish` | Real-time — event status updates (⏰→✅ or ⏰→❌) |
| AI best times refresh | Cache invalidation | Updated weekly from analytics service |

### Real-time UX
- **New event created** (by team member): Event block slides in with blue glow highlight (3s)
- **Event publishes**: Status badge smoothly transitions from "⏰ Scheduled" → "✅ Live" with green flash
- **Event fails**: Status badge transitions to "❌ Failed" with red pulse

---

## 16. Localization Notes

- Primary language: Vietnamese
- Day names: "T2" (Mon), "T3" (Tue), ..., "CN" (Sun) — abbreviated Vietnamese
- Full day names: "Thứ 2", "Thứ 3", ..., "Chủ nhật" — in headers and labels
- Date: DD/MM (short: "24/3") in day headers, DD/MM/YYYY in popover
- Time: 24h format ("19:00") on time axis
- Week label: "Tuần 13 · 24-30 Mar" (mixed VN/EN for month)
- Month label: "Tháng 3, 2026"
- Platform names: English (TikTok, IG, YouTube)

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `calendar.viewed` | Page load | `view_type` (week/month), `date_range`, `event_count`, `source` |
| `calendar.event.clicked` | Click event | `event_id`, `platform`, `status`, `position` |
| `calendar.event.rescheduled` | Drag-and-drop complete | `event_id`, `old_datetime`, `new_datetime`, `method` (drag/popover) |
| `calendar.slot.clicked` | Click empty slot | `date`, `time`, `day_of_week` |
| `calendar.navigated` | ◀/▶ buttons | `direction` (prev/next), `view_type`, `new_range` |
| `calendar.view.toggled` | Week↔Month toggle | `from_view`, `to_view` |
| `calendar.filter.changed` | Platform filter changed | `platform_filter`, `previous_filter` |
| `calendar.event.canceled` | Cancel scheduled post | `event_id`, `platform`, `time_until_publish` |
| `calendar.ai_advice.viewed` | AI advice scrolled into view | `advice_type`, `gap_days` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | "+" create button, today highlight |
| `--color-surface-primary` | Calendar background |
| `--color-surface-elevated` | Event blocks, popover |
| `--color-surface-today` | Today column highlight (subtle tint) |
| `--color-success` | ✅ Published events, AI best time highlight |
| `--color-info` | ⏰ Scheduled events |
| `--color-danger` | ❌ Failed events |
| `--color-text-secondary` | Time axis labels, day headers |
| `--color-border` | Grid lines |
| `--color-border-hour` | Major hour lines (bolder) |
| `--color-ai-highlight` | AI best time slot overlay (success with 10% opacity) |
| `--color-drop-valid` | Valid drop target highlight (success with 20% opacity) |
| `--color-drop-invalid` | Invalid drop target (danger with 20% opacity) |
| `--color-platform-tiktok` | TikTok event accent |
| `--color-platform-instagram` | Instagram event accent |
| `--color-platform-youtube` | YouTube event accent |
| `--radius-event` | Event block radius (8px) |
| `--shadow-event` | Event block shadow |
| `--shadow-event-dragging` | Elevated shadow when dragging |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/publish/calendar/+page.svelte`
- **Server load**: `+page.server.ts` → fetch events for current week/month range
- **URL params**: `?view=week&week=2026-W13` or `?view=month&month=2026-03`

### Data Fetching Strategy
```
+page.server.ts:
  const view = url.searchParams.get('view') || localStorage.get('calendar_view') || 'week'
  const range = computeDateRange(view, url.searchParams)
  
  const [events, bestTimes] = await Promise.all([
    publishService.listByDateRange(workspaceId, range.start, range.end),
    analyticsService.getBestPostingTimes(workspaceId)
  ])
```

### Calendar Grid Rendering
- **Week view**: CSS Grid with 7 columns (days) × 18 rows (06:00–23:59 in 1h)
- **Month view**: CSS Grid with 7 columns × 5-6 rows (weeks)
- **Event positioning**: `grid-row` computed from `scheduled_at` hour, `grid-column` from day

### Drag-and-Drop
```javascript
// HTML5 Drag API + touch-action for mobile
function handleDragStart(event, eventId) {
  event.dataTransfer.setData('eventId', eventId)
  event.dataTransfer.effectAllowed = 'move'
  dragState = 'dragging'
}

function handleDrop(event, targetDate, targetTime) {
  const eventId = event.dataTransfer.getData('eventId')
  const newDateTime = `${targetDate}T${targetTime}`
  
  // Optimistic update
  moveEvent(eventId, newDateTime)
  
  // API call
  await publishService.reschedule(eventId, newDateTime)
    .catch(() => {
      revertEvent(eventId)  // bounce back
      toast.error('Không chuyển được')
    })
}
```

### Keyboard Alternative for Drag
- Focus event → Enter to "pick up" → Arrow keys to navigate slots → Enter to "drop"
- Escape to cancel

---

## 20. Related Screens

| Screen | Relationship |
|---|---|
| [W043] Publish Queue | Sibling: list view of same data |
| [W045] Publish Item Detail | Child: event detail |
| [W048] Publish Composer | Upstream: create/schedule content |
| [W056] Packaging QA | Pre-publish check |
| [M025] Mobile Calendar | Mobile equivalent |

---

## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Full Tier A rewrite**: Upgraded from 189-line Tier C with generic boilerplate to 440+ line full spec. Added: complete component hierarchy with week/month dual views, ASCII wireframes for both views, drag-and-drop state machine with keyboard alternative, AI best-time overlay, gap analysis with AI advice, event popover with quick actions, platform color-coded events, 9 analytics events, 7-role RBAC, responsive 3-day tablet view. Removed all generic boilerplate. Standardized Screen ID from W45 to W046. | System |
| 2026-03-27 | 1.0 | Initial specification (Tier C) | System |
