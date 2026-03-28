# Screen: Web — Content Calendar (Full View)

> **Screen ID**: W46
> **Module**: M08 — Publish
> **Route**: `/publish/calendar/full`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §19, A1 Schema (publish_items)

---

## 1. Purpose & Context

Full calendar view with month/week/day modes showing all scheduled, published, and draft content. Color-coded by platform with drag-to-reschedule and AI optimal time overlay.

### User Story
> As a creator, I want a visual content calendar to plan my posting schedule and see gaps in my content plan.

---

## 2. Layout Structure

### ASCII Wireframe (Week view)
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Publish   📅 Content Calendar        [◀ Week ▶] [Month|Week|Day]│
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Filters ─────────────────────────────────────────────────────┐   │
│ │ Platform: [☑ All] [🎵TikTok] [📸IG] [📺YT]                  │   │
│ │ Status: [☑ All] [📝Draft] [⏳Scheduled] [✅Published]        │   │
│ │ AI overlay: [☑ Best times ☐ Content gaps]                     │   │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│       Mon 24    Tue 25    Wed 26    Thu 27    Fri 28    Sat 29      │
│ ┌────────────────────────────────────────────────────────────────┐  │
│ │ 🌅   •·····   ·····    ·····    ★·····   ·····    ·····       │  │
│ │ 08:00                                                          │  │
│ │ 10:00                                                          │  │
│ │ 12:00 [🎵 "5  │         │ [📸 St │         │         │         │  │
│ │       tips"]  │         │ ory]   │         │         │         │  │
│ │ 14:00         │ [📺 Tu │         │         │         │         │  │
│ │               │ torial]│         │         │         │         │  │
│ │ 16:00         │         │         │         │         │         │  │
│ │ 18:00 ★       │ ★       │ ★       │ ★       │ ★       │         │  │
│ │ 19:00         │ [🎵 Re │         │         │ [🎵 Re │         │  │
│ │               │ view]  │         │         │ mix]   │         │  │
│ │ 20:00         │         │         │         │         │         │  │
│ │ 22:00                                                          │  │
│ └────────────────────────────────────────────────────────────────┘  │
│ ★ = AI recommended optimal posting time                             │
│ • = content gap (no post planned)                                   │
│                                                                      │
│ [+ Tạo bài mới]                                                    │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3-5. Component & Actions

```
ContentCalendarPage
├── AppShell
├── PageHeader (back, title, week navigation, view mode toggle)
├── FilterBar (platform, status, AI overlay toggles)
├── CalendarGrid
│   ├── DayColumn[] (with time slots)
│   │   └── ContentBlock[] (draggable, platform-colored)
│   │       ├── PlatformIcon
│   │       ├── ContentTitle
│   │       ├── StatusIndicator
│   │       └── DragHandle
│   ├── AIOverlay (★ markers for optimal times)
│   └── GapIndicator (• markers for empty days)
└── CreateButton (FAB)
```

| # | Action | Trigger | Result |
|---|---|---|---|
| 1 | Drag reschedule | Drag content block to new slot | `PublishService/Reschedule` |
| 2 | Click content | Click block | Side panel: content detail |
| 3 | Create new | Click empty slot or "+" | → Create publish item |
| 4 | Switch view | Month/Week/Day toggle | Calendar reconfigures |
| 5 | AI overlay | Toggle "Best times" | ★ markers appear |

### Platform Color Coding
| Platform | Color |
|---|---|
| 🎵 TikTok | Cyan |
| 📸 Instagram | Pink |
| 📺 YouTube | Red |
| 🛍 Shopee | Orange |

### Technical Notes
- Route: `src/routes/(app)/publish/calendar/full/+page.svelte`
- Calendar: custom Svelte component (no heavy library)
- Drag-drop: native drag events
- AI overlay: `CopilotService/GetOptimalTimes(platform, audience_timezone)`

### Related Screens: [W45] Schedule Calendar (compact), [W44] Publish Queue

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

---

## 6. Edge Cases

| Edge Case | Handling |
|---|---|
| 20+ posts in one day (month view) | Day cell shows "+{n} more" badge, click to expand overlay |
| Drag to past time slot | Slot turns red, event snaps back, no API call |
| AI overlay no data (new workspace) | "🤖 Chưa đủ dữ liệu. Đăng thêm ≥10 bài để AI phân tích." |
| No posts in visible range | Empty grid: "Chưa có bài trong khoảng thời gian này. [+ Tạo bài]" |
| Platform filter hides all events | "Không có bài nào trên {platform}. [Xóa bộ lọc]" |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached calendar | Auto-retry online |
| Reschedule fail | API error after drag | Event bounces back + Toast: "Không chuyển được. [Thử lại]" | Retry drag |
| AI times unavailable | Analytics service error | AI overlay hidden: "🤖 AI gợi ý tạm không khả dụng" | Graceful degrade |
| Events load fail | API error | "Không tải được lịch. [Thử lại]" | Retry |
| Time conflict | 2 same-platform posts <1h apart | Warning popover on drop: "Đã có bài {platform} lúc {time}. [Vẫn chuyển]" | Confirm or cancel |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Calendar grid | `role="grid"`, `aria-label="Content calendar, {view} view"` |
| Day columns | `role="columnheader"`, `aria-label="Monday, March 24"` |
| Content blocks | `role="gridcell"`, `aria-label="{title}, {platform}, {status}, {time}"`, `tabindex="0"` |
| Drag-and-drop | Keyboard alt: select → arrow keys → Enter to drop. `aria-grabbed`, `aria-dropeffect` |
| AI markers | `aria-label="AI recommended: optimal posting time {time}"` (informational) |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Grid outline + day headers |
| Events populate | 200-600ms | Blocks fade-in with stagger |
| AI overlay | 300-800ms | ★ markers fade in |
| Gap indicators | 500-1000ms | • markers appear |
| View switch | <300ms | Smooth CSS transition |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `calendar_full.viewed` | Page load | `view_type`, `date_range`, `event_count` |
| `calendar_full.event_clicked` | Click content block | `event_id`, `platform`, `status` |
| `calendar_full.event_rescheduled` | Drag-and-drop complete | `event_id`, `old_time`, `new_time` |
| `calendar_full.slot_clicked` | Click empty slot | `date`, `time` |
| `calendar_full.view_changed` | Month/Week/Day toggle | `from_view`, `to_view` |
| `calendar_full.filter_changed` | Platform/status filter | `filter_type`, `filter_value` |
| `calendar_full.ai_overlay_toggled` | Toggle AI overlay | `overlay_type`, `enabled` |
| `calendar_full.navigated` | ◀/▶ buttons | `direction`, `new_range` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/publish/calendar/full/+page.svelte`
- **Server load**: `+page.server.ts` → `PublishService/ListByDateRange(range)` + `AnalyticsService/GetBestPostingTimes`
- **Calendar grid**: Custom Svelte component (CSS Grid: 7 cols × time rows)
- **Drag-and-drop**: Native HTML5 Drag API with `touch-action` for tablet
- **AI overlay**: `CopilotService/GetOptimalTimes(platform, audience_timezone)` cached 24h
- **View state**: URL params `?view=week&week=2026-W13`, `localStorage` fallback
- **SSE**: New/changed events via `/events/publish`
- **Keyboard**: Arrow key navigation between cells, Enter to interact

---

## 12. Localization Notes

- Days: "T2" (Mon), "T3" (Tue), ..., "CN" (Sun)
- View: "Tuần", "Tháng", "Ngày"
- Time: 24h format ("19:00")
- Week: "Tuần 13 · 24-30 Mar"
- Status: "✅ Live", "⏰ Lên lịch", "📝 Nháp", "❌ Lỗi"
- AI: "★ AI gợi ý thời gian tối ưu"
- Tone: Planning-oriented

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-platform-tiktok` | TikTok event accent (cyan) |
| `--color-platform-instagram` | Instagram event accent (pink) |
| `--color-platform-youtube` | YouTube event accent (red) |
| `--color-platform-shopee` | Shopee event accent (orange) |
| `--color-ai-highlight` | AI best time overlay (green 10% opacity) |
| `--color-drop-valid` | Valid drop target (green 20% opacity) |
| `--color-drop-invalid` | Invalid drop target (red 20% opacity) |
| `--color-surface-today` | Today column highlight |
| `--color-border` | Grid lines |
| `--color-surface-elevated` | Event blocks |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W046] Schedule Calendar | Compact sibling |
| [W044] Publish Queue | List view sibling |
| [W048] Publish Composer | Create from slot |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (20+ posts, drag past), 5 errors, grid/event a11y with keyboard, 8 analytics, SvelteKit impl (custom grid, drag API), localization, 10 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
