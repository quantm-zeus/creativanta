# Screen: Mobile — Task Queue

> **Screen ID**: M052
> **Module**: M20 — Workflow Studio
> **Route**: `/m/tasks`
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 03 §Workflow/Agent, A1 Schema (tasks, task_assignments, workflows), B5 RBAC §2.7

---

## 1. Purpose & Context

Personal and team task queue on mobile — aggregates tasks from workflows, manual assignments, scheduled deadlines, and system-generated action items. Designed for swipe-to-complete interaction and grouped by urgency.

### User Story
> As a team member on mobile, I want to see all my pending tasks in priority order and quickly complete them with a swipe so nothing falls through the cracks.

### Business Goal
- Single queue for all actionable items across the platform
- Reduce task completion time (target: <4h for normal, <1h for urgent)
- Surface overdue items prominently to prevent bottlenecks
- Connect task completion to workflow progression

### When to Use
- Morning check: "What do I need to do today?"
- Responding to push: "📋 New task assigned"
- Processing overdue items after being away
- Checking team tasks for delegation

### Entry Points
- Bottom nav: 📋 Tasks tab (with badge count)
- Dashboard widget: "Tasks" → this screen
- Push notification: "📋 New task: {title}" → deep link
- Copilot: "Hôm nay tôi cần làm gì?" → shows task summary

### Exit Points
- Swipe complete → task done (stays on list)
- Tap task → Task Detail bottom sheet
- Create task → from "+" button
- Back → Home (bottom nav)

---

## 2. Preconditions / Postconditions

### Preconditions
- User is authenticated
- User has tasks assigned or owns workspace tasks

### Postconditions
- Completed tasks marked `done` with completion timestamp
- Linked workflows resumed/advanced when task completed
- Overdue tasks flagged with duration
- Audit event: `task.completed`, `task.created`

---

## 3. Layout Structure

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ Tasks                                   [Filter ▾] [+ Tạo task]    │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ ┌─ Summary Bar ───────────────────────────────────────────────────┐  │
│ │ 📋 Hôm nay: 5   ⚠️ Quá hạn: 1   ✅ Tuần này: 12              │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ Segments: [📋 To Do (5)] [🔄 In Progress (2)] [✅ Done (12)]        │
│ View: [🗓 By Date] [📂 By Source] [👤 By Assignee]                  │
│                                                                       │
│ ── ⚠️ Quá hạn ──────────────────────────────────────────────────     │
│ ┌─ Task Card ─────────────────────────────────────────────────────┐  │
│ │ ⚠️ "Review brand deal contract"                                 │  │
│ │ 🔴 High · Due: Yesterday · Source: 🤝 Brand Deals               │  │
│ │ 👤 Assigned: You · Created by: Mai                               │  │
│ │ ← Swipe R: ✅ Done →                                            │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ── 📅 Hôm nay ──────────────────────────────────────────────────     │
│ ┌─ Task Card ─────────────────────────────────────────────────────┐  │
│ │ 📋 "Approve 3 scripts"                                          │  │
│ │ 🟡 Medium · Due: 18:00 · Source: ⚡ Workflow "Daily Pipeline"   │  │
│ │ 👤 Assigned: You · Auto-generated                                │  │
│ │ ← Swipe R: ✅ Done →                                            │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Task Card ─────────────────────────────────────────────────────┐  │
│ │ 📋 "Respond to @beauty_fan comment"                              │  │
│ │ 🟢 Low · Due: 20:00 · Source: 💬 Engagement                     │  │
│ │ 👤 Assigned: You · Auto-generated                                │  │
│ │ ← Swipe R: ✅ Done →                                            │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ── 📅 Ngày mai ──────────────────────────────────────────────────    │
│ ┌─ Task Card ─────────────────────────────────────────────────────┐  │
│ │ 📋 "Ship seeding samples to 5 KOCs"                             │  │
│ │ 🟡 Medium · Due: Tomorrow 10:00 · Source: 📦 Seeding            │  │
│ │ ← Swipe R: ✅ Done →                                            │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ Pull-to-refresh ↻                                                    │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [📋*] [➕] [💬] [👤]  (* = active tab with badge)             │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
TaskQueueScreen
├── AppBar
│   ├── Title ("Tasks")
│   ├── FilterButton (dropdown)
│   └── CreateTaskButton (+)
├── SummaryBar
│   ├── TodayCount
│   ├── OverdueCount (red if >0)
│   └── WeekCompletedCount
├── SegmentBar
│   ├── ToDoSegment (count badge)
│   ├── InProgressSegment (count badge)
│   └── DoneSegment (count badge)
├── ViewModeSelector
│   ├── ByDateMode (default — grouped by date)
│   ├── BySourceMode (grouped by module/feature)
│   └── ByAssigneeMode (grouped by team member)
├── TaskList (scrollable, pull-to-refresh)
│   ├── DateGroupHeader ("⚠️ Quá hạn" / "📅 Hôm nay" / "📅 Ngày mai")
│   └── SwipeableTaskCard[]
│       ├── TaskTitle
│       ├── MetaRow
│       │   ├── PriorityBadge (🔴 High / 🟡 Medium / 🟢 Low)
│       │   ├── DueDate (relative or absolute)
│       │   └── SourceBadge (icon + module name)
│       ├── AssigneeRow
│       │   ├── AssigneeAvatar + Name
│       │   └── CreatorInfo
│       ├── SwipeActions
│       │   ├── RightAction (✅ Done — green)
│       │   └── LeftAction (⏭ Snooze — yellow)
│       └── TapAction → TaskDetailBottomSheet
├── TaskDetailBottomSheet (conditional)
│   ├── TaskHeader (title + priority + status)
│   ├── Description (full text)
│   ├── MetadataGrid
│   │   ├── Source (linked object — click to navigate)
│   │   ├── DueDate
│   │   ├── Assignee
│   │   ├── Created (date + by whom)
│   │   └── Labels
│   ├── SubtaskList (if any)
│   │   └── SubtaskItem[] (checkbox + text)
│   ├── CommentsSection
│   │   └── CommentItem[] (avatar + text + time)
│   ├── AddCommentInput
│   └── ActionButtons
│       ├── MarkDoneButton
│       ├── SnoozeButton (picker: 1h/4h/tomorrow/next week)
│       ├── ReassignButton
│       ├── EditButton
│       └── DeleteButton
├── CreateTaskBottomSheet (conditional)
│   ├── TitleInput
│   ├── DescriptionInput
│   ├── PrioritySelector (High/Medium/Low)
│   ├── DueDatePicker
│   ├── AssigneePicker
│   ├── SourceLinker (optional — link to existing object)
│   └── CreateButton
└── BottomNavBar (shared, badge on Tasks tab)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Summary counts | `tasks` aggregation per user | `TaskService/GetSummary(user_id)` | Integer counts | Real-time (SSE) |
| Task list | `tasks` | `TaskService/ListTasks(segment, view_mode, page)` | Grouped card list | Real-time (SSE) |
| Priority | `tasks.priority` | included | 🔴/🟡/🟢 badge | — |
| Due date | `tasks.due_at` | included | Relative: "18:00" / "Yesterday" / "Tomorrow 10:00" | Client-computed |
| Source | `tasks.source_type` + `source_id` | included | Icon + module label | — |
| Assignee | `tasks.assignee_id` → `users` | included | Avatar + name | Session |
| Subtasks | `tasks.subtasks[]` | `TaskService/GetTaskDetail(id)` | Checkbox list | No cache |
| Comments | `task_comments` | `TaskService/GetTaskComments(id)` | Avatar + text + time | No cache |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Complete task | Swipe right (+haptic) | `TaskService/Complete(id)` | `tasks.status = done` | Card slides off + count updates + undo toast (3s) | Task owner/assignee |
| 2 | Snooze task | Swipe left → pick duration | `TaskService/Snooze(id, until)` | `tasks.due_at = new_date` | Card moves to new date group | Task owner/assignee |
| 3 | View task detail | Tap card | `TaskService/GetTaskDetail(id)` | — | Open TaskDetailBottomSheet | Any assigned |
| 4 | Complete subtask | Tap subtask checkbox | `TaskService/UpdateSubtask(id, subtask_id)` | Subtask status toggles | Checkbox animates + progress updates | Task owner/assignee |
| 5 | Add comment | Submit comment in detail | `TaskService/AddComment(id, text)` | Comment created | Comment appears in list | Any assigned |
| 6 | Create task | Open + submit create form | `TaskService/CreateTask(payload)` | Task created | Toast "Task created" + card appears in list | `follow_up:manage` |
| 7 | Reassign task | Tap "Reassign" → pick user | `TaskService/Reassign(id, user_id)` | `tasks.assignee_id = new_user` | Card updates assignee | Manager+ |
| 8 | Delete task | Tap "Delete" → confirm | `TaskService/Delete(id)` | Task soft-deleted | Card removed | Task creator/Manager+ |
| 9 | Filter | Select filter options | `TaskService/ListTasks(filters)` | — | List filters | Any |
| 10 | Switch view mode | Tap view mode chip | Client-side re-group | — | Cards re-group by date/source/assignee | Any |
| 11 | Undo complete | Tap "Hoàn tác" in toast (3s) | `TaskService/Uncomplete(id)` | `tasks.status = todo` | Card reappears | Task owner/assignee |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching tasks | Shimmer summary + skeleton cards |
| LOADED | Tasks available | Grouped card list |
| EMPTY | No tasks at all | "🎉 Không có task nào! Thời gian sáng tạo!" + illustration |
| HAS_OVERDUE | Overdue tasks exist | Red "Quá hạn" section pinned to top, overdue count in orange |
| FILTERED | Filter applied, results available | Filtered list |
| FILTERED_EMPTY | Filter applied, no matches | "Không có task phù hợp bộ lọc. [Xóa bộ lọc]" |
| CREATING | Create form open | CreateTaskBottomSheet |
| DETAIL_OPEN | Task detail open | TaskDetailBottomSheet |
| COMPLETING | Swipe-complete in progress | Card sliding off |
| ERROR | API failure | Toast with retry |
| OFFLINE | No network | Banner: "Offline. Tasks sẽ đồng bộ khi có mạng." + cached list |

---

## 8. Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Task title | Required, 3-200 chars | "Tên task không được trống" |
| Due date | Optional, must be future if set | "Hạn phải ở tương lai" |
| Assignee | Optional (defaults to self) | — |
| Comment | 1-1000 chars | "Comment không được trống" |
| Snooze duration | Must be future | — |

---

## 9. Permission Matrix

| Action | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View own tasks | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| View team tasks | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Complete own tasks | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Create tasks | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Reassign tasks | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Delete tasks | ✅ | ✅ | ✅ (own) | ❌ | ❌ | ❌ | ❌ |

---

## 10. Navigation Map

```
Tasks (/m/tasks)
├── → TaskDetailBottomSheet        (via tap card)
├── → CreateTaskBottomSheet        (via + button)
├── → /m/scripts/[id]             (via task source: Script)
├── → /m/orders/[id]              (via task source: Order)
├── → /m/threads/[id]             (via task source: Engagement)
├── → /m/workflows/runs/[id]      (via task source: Workflow)
├── → /m/approvals                (via task source: Approval)
└── ← /m/home                    (via bottom nav)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network error | Offline | Banner + cached task list | Auto-sync on reconnect |
| Complete failed | API error | Toast + card returns | Re-swipe to retry |
| Create failed | API error | Toast "Không tạo được task. Thử lại." | Retry in form |
| Task deleted by another | Concurrent | Toast "Task đã bị xóa." + card removed | No action |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Summary bar | `Semantics: "5 tasks hôm nay, 1 quá hạn"` |
| Task cards | Full label: "Review brand deal contract, ưu tiên cao, quá hạn 1 ngày" |
| Swipe actions | Tap fallback for reduced-motion |
| Overdue section | `Semantics(liveRegion: true)` |
| Priority badges | Text + color (not color alone) |
| Haptic | Medium on complete, light on snooze |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + shimmer |
| Data fetch | 200-500ms | Summary → cards animate in (stagger) |
| Swipe complete | 200ms | Card slides + count animates |
| Undo window | 3s | Toast with "Hoàn tác" button |
| Detail load | <300ms | Bottom sheet slides up + content loads |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Screen render | <1.5s |
| Swipe response | <100ms |
| Task list (50 items) | <500ms |
| List scroll | 60fps |

---

## 15. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| Task count (badge) | SSE `/events/tasks` | Real-time |
| New task assigned | Push notification + SSE | Real-time |
| Task completed by team | SSE | Real-time |

---

## 16. Localization Notes

- Due dates: Vietnamese relative ("Hôm nay 18:00", "Hôm qua", "Ngày mai")
- Priority labels: Vietnamese ("Cao", "Trung bình", "Thấp")
- Source labels: Vietnamese module names
- Tone: Action-oriented, encouraging

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `tasks.viewed` | Screen load | `todo_count`, `overdue_count`, `source` |
| `tasks.completed` | Swipe complete | `task_id`, `source_type`, `time_to_complete` |
| `tasks.snoozed` | Snooze action | `task_id`, `snooze_duration` |
| `tasks.created` | Create task | `priority`, `has_due_date`, `has_assignee` |
| `tasks.undone` | Undo complete | `task_id` |
| `tasks.detail_viewed` | Open detail | `task_id`, `source_type` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-success` | Done swipe, completed badge |
| `--color-warning` | Snooze swipe, medium priority, overdue background |
| `--color-danger` | High priority badge, overdue count |
| `--color-surface-elevated` | Task cards |
| `--color-accent` | Create button, CTA buttons |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W105] Web Tasks | Web equivalent (kanban/table view) |
| [M051] Approval Queue | Sibling — approval-specific tasks |
| [M050] Workflow Monitor | Parent — workflow-generated tasks |
| [M001] Home Dashboard | Source — task widget |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | Full 20-point upgrade from 65-line Tier C. Added summary bar, 3 view modes (date/source/assignee), task detail bottom sheet with subtasks/comments, create task form, snooze with duration picker, undo on complete, overdue pinned section, 11 states, source attribution with deep links, comprehensive analytics. Fixed Screen ID (M057→M052). | System |
