# Screen: Web — Follow-up Tasks

> **Screen ID**: W53
> **Module**: M09 — Engagement
> **Route**: `/inbox/tasks`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, A1 Schema (followup_tasks, threads)

---

## 1. Purpose & Context

Follow-up Tasks tracks pending actions created from inbox threads — e.g., "Send product sample to @customer", "Create special offer for VIP buyer", "Follow up on collaboration inquiry". Each task links to its source thread.

### User Story
> As a creator managing many conversations, I want to track follow-up actions so nothing falls through the cracks.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 📌 Follow-up Tasks (12 pending)    [Filter ▾] [+ Tạo task mới]    │
├──────────────────────────────────────────────────────────────────────┤
│ ── Quá hạn (2) ──                                                    │
│ ┌─ Task Row (overdue) ───────────────────────────────────────────┐ │
│ │ 🔴 Gửi mã giảm giá cho Nguyễn Văn A                          │ │
│ │ Due: 26/3 (1 ngày trước) · From: 💬 Thread #234               │ │
│ │ Assigned: Quân                                                  │ │
│ │ [✅ Done] [📅 Gia hạn] [→ Thread]                              │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ── Hôm nay (3) ──                                                    │
│ ┌─ Task Row ──────────────────────────────────────────────────────┐ │
│ │ 🟡 Trả lời collab inquiry từ @brandx                          │ │
│ │ Due: Hôm nay · From: 💬 Thread #456 · Assigned: Quân          │ │
│ │ [✅ Done] [📅 Gia hạn] [→ Thread]                              │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ── Sắp tới (7) ──                                                    │
│ ... more task rows ...                                               │
│                                                                      │
│ ── Đã hoàn thành (gần đây) ──                                       │
│ ┌─ Task Row (completed) ─────────────────────────────────────────┐ │
│ │ ✅ Ship sample cho Lê Hoa                                       │ │
│ │ Completed: 26/3 · From: 💬 Thread #123                         │ │
│ └──────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
FollowUpTasksPage
├── AppShell (shared)
├── PageHeader
│   ├── Title + PendingCount
│   ├── FilterDropdown (All/Overdue/Today/This week/Completed)
│   └── CreateButton
├── TaskList (grouped by due date)
│   └── TaskGroup[] (Overdue, Today, This week, Completed)
│       ├── GroupHeader + Count
│       └── TaskRow[]
│           ├── PriorityIndicator (🔴/🟡/🟢)
│           ├── TaskDescription
│           ├── DueDate
│           ├── SourceThread link
│           ├── AssigneeBadge
│           └── ActionButtons
│               ├── MarkDoneButton
│               ├── RescheduleButton (date picker)
│               └── ViewThreadButton
└── CreateTaskModal
    ├── DescriptionInput
    ├── DueDatePicker
    ├── AssigneeSelector
    └── LinkThreadSelector
```

---

## 4-5. Data & Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Mark done | "✅ Done" | `FollowUpTaskService/Complete(id)` | Task moves to completed | `inbox:manage` |
| 2 | Reschedule | "📅 Gia hạn" → date picker | `FollowUpTaskService/Reschedule(id, date)` | Due date updates | `inbox:manage` |
| 3 | View thread | "→ Thread" | — | Navigate to thread | `inbox:read` |
| 4 | Create | "+ Tạo task mới" → modal | `FollowUpTaskService/Create` | New task appears | `inbox:manage` |
| 5 | Filter | Filter dropdown | Client-side / Refetch | List filters | `inbox:read` |

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Group header skeletons + row skeletons |
| LOADED | Tasks available | Grouped list (overdue, today, this week, completed) |
| EMPTY | No tasks at all | Illustration: "Không có task nào 🎉 Tạo từ inbox khi cần theo dõi! [← Inbox]" |
| ALL_DONE | All tasks completed | "Tất cả task đã hoàn thành! 🎉 [← Inbox]" |
| ERROR | API failed | Error banner with retry |

---

## 7. Edge Cases

| Edge Case | Handling |
|---|---|
| Task linked to deleted thread | Show "(Thread đã xóa)" placeholder |
| Due date in the past | Auto-move to "Quá hạn" group with red indicator |
| 100+ tasks | Pagination per group (20/group) |
| Task assigned to deactivated user | Show "(Người dùng đã vô hiệu)" + suggest reassign |
| Multi-day overdue | Show "3 ngày quá hạn" with escalating red intensity |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached" | Auto-retry online |
| Complete failed | Server error | Toast: "Không đánh dấu xong. [Thử lại]" | Retry |
| Reschedule failed | Server error | Toast: "Không gia hạn được. [Thử lại]" | Retry |
| Create failed | Validation error | Modal inline errors | Fix + retry |
| Thread link broken | Thread deleted | Toast: "Thread gốc không còn tồn tại" | — |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Task groups | `role="group"`, `aria-label="Quá hạn: {n} task"` |
| Task rows | `role="article"`, `aria-label="{description}, hạn {date}, {assignee}"` |
| Priority indicators | Color + icon (🔴/🟡/🟢) + text |
| Mark done button | `aria-label="Đánh dấu hoàn thành: {description}"` |
| Date picker | `aria-label="Chọn ngày gia hạn"` |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | App Shell + group header skeletons |
| Overdue group | 200ms | Overdue tasks appear first (priority) |
| Today group | 300ms | Today tasks populate |
| This week group | 400ms | Week tasks populate |
| Completed group | 500ms | Recently completed load (collapsed default) |

---

## 11. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (first task row) |
| Mark done | < 500ms (optimistic) |
| Reschedule | < 500ms |
| Create task | < 1s |
| Group transitions | 300ms animation |

---

## 12. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `tasks.viewed` | Page load | `pending_count`, `overdue_count` |
| `tasks.completed` | Mark done | `task_id`, `was_overdue`, `days_open` |
| `tasks.rescheduled` | Reschedule | `task_id`, `old_date`, `new_date` |
| `tasks.created` | Create new | `task_id`, `from_thread` (boolean) |
| `tasks.thread_viewed` | Click "→ Thread" | `task_id`, `thread_id` |
| `tasks.filtered` | Filter applied | `filter_type` |
| `tasks.overdue_noticed` | Overdue group visible | `overdue_count` |

---

## 13. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/inbox/tasks/+page.svelte`
- **Server load**: `+page.server.ts` → fetch tasks grouped by status
- **Overdue detection**: Server-side `WHERE due_date < NOW()` on every load
- **Reminder system**: Cron checks due tasks → push notification at due time
- **Optimistic UI**: Mark done immediately, revert on error
- **Create modal**: Client-side, with thread search autocomplete

---

## 14. Localization Notes

- Groups: "Quá hạn" (Overdue), "Hôm nay" (Today), "Tuần này" (This week), "Đã hoàn thành" (Completed)
- Priority: "🔴 Quan trọng", "🟡 Bình thường", "🟢 Thấp"
- Overdue: "1 ngày quá hạn", "3 ngày quá hạn"
- Actions: "Hoàn thành", "Gia hạn", "Xem thread"
- Due date: "Hạn: 26/3", "Hạn: Hôm nay"
- Relative: "Đã tạo 2 giờ trước"

---

## 15. Design Tokens

| Token | Usage |
|---|---|
| `--color-task-overdue` | Overdue indicator (🔴 red) |
| `--color-task-today` | Today indicator (🟡 amber) |
| `--color-task-upcoming` | Upcoming indicator (🟢 green) |
| `--color-task-completed` | Completed indicator (✅ teal) |
| `--color-priority-high` | High priority (red border-left) |
| `--color-priority-medium` | Medium priority (amber) |
| `--color-priority-low` | Low priority (green) |
| `--color-accent` | Primary CTAs (Create, Complete) |

---

## 16. Related Screens

| Screen | Relationship |
|---|---|
| [W049] Unified Inbox | Source of tasks |
| [W050] Thread Detail | Linked thread |
| [M029] Mobile Follow-up Tasks | Mobile equivalent |

---

## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Added 5 states, 5 edge cases, 5 error scenarios, accessibility for grouped tasks, SvelteKit impl (overdue cron, optimistic UI), 7 analytics, 5 perf KPIs, task-specific localization, 8 design tokens with priority/overdue colors. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
