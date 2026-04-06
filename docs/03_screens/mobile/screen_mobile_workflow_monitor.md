# Screen: Mobile — Workflow Monitor

> **Screen ID**: M050
> **Module**: M20 — Workflow Studio
> **Route**: `/m/workflows/runs`
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 03 §Workflow/Agent, A1 Schema (`workflow_runs`, `workflow_run_steps`, `agent_runs`), A3 API (`WorkflowService/ListRuns`, `WorkflowService/GetRunStats`, `WorkflowService/GetRunDetail`), B5 RBAC §2.7

---

## 1. Purpose & Context

Mobile workflow execution monitor for tracking running, completed, and failed workflow runs. Enables on-the-go monitoring, quick retry of failed runs, and responding to paused workflows that need human input. Essential for users relying on automated pipelines.

### User Story
> As a creator with active workflows, I want to check their status on mobile and quickly retry or unblock paused ones so my automated pipelines keep running.

### Business Goal
- Keep automated pipelines operational even when user is away from desktop
- Reduce time-to-remediation for failed workflows
- Enable mobile response to human-in-the-loop workflow pauses
- Surface workflow status proactively through push notifications

### When to Use
- Checking if automated content pipeline completed
- Responding to "workflow paused — needs input" push notification
- Retrying a failed workflow after fixing the underlying issue
- Monitoring a newly deployed workflow's first runs

### Entry Points
- Workflows tab → "📊 Runs"
- Push notification: "⏸ Workflow paused — needs input" → deep link to specific run
- Push notification: "❌ Workflow failed" → deep link to failed run
- Dashboard mini-widget → "Active Workflows: 2" → this screen

### Exit Points
- Tap run → Run Detail (full step timeline)
- "🔄 Retry" → re-run (auto-navigate to new running instance)
- "Provide Input" → human-input form bottom sheet
- Back → Workflow list

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `workflow:read` permission
- At least 1 workflow exists in workspace
- Optional: active runs in progress

### Postconditions
- Run status visible with real-time progress updates
- Failed runs can be retried (creates new run instance)
- Paused runs can receive human input and resume
- Cancelled runs stop processing

---

## 3. Layout Structure

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Workflow Runs                              [Auto-refresh 🟢]      │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ ┌─ Summary Cards ─────────────────────────────────────────────────┐  │
│ │ 🟢 Running  │  ✅ Done (24h)  │  ❌ Failed  │  ⏸ Paused      │  │
│ │    2        │     23           │     1        │     1           │  │
│ │             │                  │              │  ⚠️ Needs input │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ Chips: [All (27)] [🟢 Running (2)] [✅ Done (23)] [❌ Failed (1)]   │
│        [⏸ Paused (1)]                                                │
│                                                                       │
│ ┌─ Run Card — RUNNING ────────────────────────────────────────────┐  │
│ │ ⚡ "Auto-respond pipeline"                    [🟢 Running]      │  │
│ │ Workflow: Daily Content Pipeline                                 │  │
│ │ Step: 3/5 · "Generating AI response" · 5m 30s                   │  │
│ │ Credits used: 8 · Est. remaining: 4                              │  │
│ │ [████████████████████░░░░░░░░░░] 60%                             │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Run Card — PAUSED (Needs Input) ───────────────────────────────┐  │
│ │ ⏸ "Brand deal review workflow"               [⏸ Paused]        │  │
│ │ ⚠️ Waiting for your input: "Approve brand brief?"              │  │
│ │ Paused at step 2/4 · 2h ago                                     │  │
│ │ [📝 Provide Input]     [⏭ Skip Step]     [🗑 Cancel]           │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Run Card — FAILED ─────────────────────────────────────────────┐  │
│ │ ❌ "Daily content pipeline"                   [❌ Failed]       │  │
│ │ Error: "TikTok API timeout"                                      │  │
│ │ Failed at: Step 4/5 "Publish to TikTok" · 2h ago                │  │
│ │ Duration: 3m 45s · Credits: 12                                   │  │
│ │ [🔄 Retry]     [👁 View Log]     [🗑 Dismiss]                  │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Run Card — COMPLETED ──────────────────────────────────────────┐  │
│ │ ✅ "Morning brief generation"                 [✅ Done]         │  │
│ │ Completed: 5 steps in 2m 15s · Credits: 15                      │  │
│ │ Results: 3 ideas generated, 1 script started                     │  │
│ │ 30m ago                                                          │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ Pull-to-refresh ↻                                                    │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [📋] [➕] [💬] [👤]                                            │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
WorkflowMonitorScreen
├── AppBar
│   ├── BackButton
│   ├── Title ("Workflow Runs")
│   └── AutoRefreshIndicator (green dot, pulsing when active)
├── SummaryCards (4 cards, horizontal scroll on small screens)
│   ├── RunningCard (🟢 + count)
│   ├── CompletedCard (✅ + count, 24h window)
│   ├── FailedCard (❌ + count, red highlight if >0)
│   └── PausedCard (⏸ + count, warning if needs input)
├── FilterChips (horizontal scroll)
│   ├── AllChip (total count)
│   ├── RunningChip
│   ├── CompletedChip
│   ├── FailedChip
│   └── PausedChip
├── RunsList (scrollable, pull-to-refresh)
│   └── WorkflowRunCard[] (polymorphic by status)
│       ├── RunningCard
│       │   ├── WorkflowIcon + RunName
│       │   ├── WorkflowLabel
│       │   ├── StepProgress ("Step 3/5 · 'Generating AI response'")
│       │   ├── CreditUsage ("Credits: 8 · Est. remaining: 4")
│       │   ├── ProgressBar (animated)
│       │   └── Duration (elapsed)
│       ├── PausedCard
│       │   ├── PauseIcon + RunName + ⚠️ Badge
│       │   ├── InputPrompt ("Waiting for: 'Approve brand brief?'")
│       │   ├── PausedStepInfo
│       │   └── ActionButtons
│       │       ├── ProvideInputButton (primary)
│       │       ├── SkipStepButton (secondary)
│       │       └── CancelButton (destructive)
│       ├── FailedCard
│       │   ├── FailIcon + RunName
│       │   ├── ErrorMessage (truncated)
│       │   ├── FailedStepInfo
│       │   ├── DurationAndCredits
│       │   └── ActionButtons
│       │       ├── RetryButton (primary)
│       │       ├── ViewLogButton
│       │       └── DismissButton
│       └── CompletedCard
│           ├── CheckIcon + RunName
│           ├── CompletionInfo ("5 steps in 2m 15s")
│           ├── ResultsSummary
│           └── TimeAgo
├── HumanInputBottomSheet (conditional — from Provide Input)
│   ├── InputPrompt (question from workflow)
│   ├── InputFields (dynamic — based on workflow step config)
│   ├── SubmitButton
│   └── CancelButton
└── BottomNavBar (shared)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Summary counts | `workflow_runs` aggregation | `WorkflowService/GetRunStats` | Integer per status | Real-time (SSE) |
| Run list | `workflow_runs` | `WorkflowService/ListRuns(status, page)` | Card list by recency | Real-time (SSE) |
| Step progress | `workflow_run_steps[current]` | Included in run detail / live progress payload | "Step {n}/{total} · '{step_name}'" | Real-time |
| Progress percentage | `workflow_runs.progress` | SSE push | Animated progress bar | Real-time |
| Credit usage | `workflow_runs.credits_used` | included | Integer + estimated remaining | Real-time |
| Error message | `workflow_runs.error` | included | Truncated to 2 lines | No cache |
| Duration | `workflow_runs.started_at` → now/completed_at | Client-computed | "5m 30s" / "2h 15m" | Client |
| Results summary | `workflow_runs.result_summary` | included | "3 ideas generated, 1 script started" | No cache |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Filter by status | Tap filter chip | `WorkflowService/ListRuns(status)` | — | List filters | `workflow:read` |
| 2 | View run detail | Tap card (running/completed) | — | — | Navigate to Run Detail screen | `workflow:read` |
| 3 | Retry failed run | Tap "🔄 Retry" on failed card | `WorkflowService/RetryRun(id)` | New run instance created | Toast "Retrying..." → card moves to Running | `workflow:activate` |
| 4 | Provide input | Tap "📝 Provide Input" on paused card | — | — | Open HumanInputBottomSheet | `workflow:activate` |
| 5 | Submit input | Submit form in bottom sheet | `WorkflowService/ProvideInput(id, data)` | Run resumes | Toast "✅ Workflow resumed" → card moves to Running | `workflow:activate` |
| 6 | Skip step | Tap "⏭ Skip Step" on paused card | `WorkflowService/SkipStep(id)` | Step skipped, run continues | Toast "Step skipped" → card updates | `workflow:activate` |
| 7 | Cancel run | Tap "🗑 Cancel" on paused/running | Confirm → `WorkflowService/CancelRun(id)` | `status = cancelled` | Card removed + toast | `workflow:activate` |
| 8 | Dismiss failed | Tap "🗑 Dismiss" on failed card | `WorkflowService/DismissRun(id)` | `status = dismissed` | Card fades out | `workflow:activate` |
| 9 | View log | Tap "👁 View Log" on failed card | — | — | Navigate to Run Detail with logs tab | `workflow:read` |
| 10 | Pull to refresh | Pull down gesture | `WorkflowService/ListRuns` + `GetRunStats` | — | Everything refreshes | `workflow:read` |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Shimmer summary cards + skeleton cards |
| LOADED | Data available | Summary + run cards |
| EMPTY | No runs ever | "Chưa có workflow nào chạy. [Tạo workflow đầu tiên →]" |
| FILTERED_EMPTY | Filter active, 0 matches | "Không có run nào với trạng thái này." |
| HAS_PAUSED | Paused runs needing input | Paused card highlighted with ⚠️ badge |
| HAS_FAILED | Failed runs | Failed section at top with red highlight |
| ALL_HEALTHY | Only running/completed | Green summary, no alerts |
| HUMAN_INPUT | Input bottom sheet open | Bottom sheet with input form |
| RETRYING | Retry in progress | Card shows spinner → moves to Running |
| ERROR | API failure | Toast with retry |
| OFFLINE | No network | Banner: "Đang offline. Dữ liệu có thể chưa cập nhật." |

---

## 8. Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Human input (text) | Required if workflow step requires it | "Vui lòng nhập phản hồi" |
| Human input (choice) | Must select an option | "Vui lòng chọn một tùy chọn" |
| Cancel confirmation | Must confirm | "Hủy workflow sẽ dừng tất cả xử lý. Tiếp tục?" |

---

## 9. Permission Matrix

| Action | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View runs | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ✅ (read-only) | ❌ |
| Retry run | ✅ | ✅ | ✅ | ✅ (own) | ❌ | ❌ | ❌ |
| Provide input | ✅ | ✅ | ✅ | ✅ (assigned) | ❌ | ❌ | ❌ |
| Cancel run | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Skip step | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

---

## 10. Navigation Map

```
Workflow Runs (/m/workflows/runs)
├── → /m/workflows/runs/[id]         (via tap run card — full detail)
├── → /m/workflows/runs/[id]?tab=logs (via View Log)
├── → HumanInputBottomSheet           (via Provide Input)
├── → /m/workflows/new                (via empty state CTA)
└── ← /m/workflows                    (via back)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network error | No connectivity | Offline banner + cached run list | Pull-to-refresh when online |
| Retry failed | Run cannot be retried (workflow deleted) | Toast: "Workflow không còn tồn tại." | Dismiss run |
| Input submit failed | API error | Toast: "Không gửi được. Thử lại." | Retry submit |
| SSE reconnection | Connection lost | "Reconnecting..." indicator | Auto-reconnect |
| Run not found | Stale deep link | Toast: "Run không tìm thấy." + navigate to list | Show list |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Summary cards | `Semantics(label: "2 workflows đang chạy")` |
| Run cards | Full label: "Auto-respond pipeline, đang chạy, step 3 trên 5, 60% hoàn thành" |
| Progress bar | `Semantics(value: 60, label: "Tiến trình")` |
| Action buttons | Minimum 48x48 tap targets |
| Status changes | `Semantics(liveRegion: true)` for status updates |
| Bottom sheet | Focus trap, swipe-to-dismiss |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + shimmer |
| Data fetch | 200-500ms | Summary populates → cards animate in (stagger) |
| Progress updates | Real-time (SSE) | Progress bar animates smoothly |
| Retry action | 500ms-2s | Card shows spinner → moves to Running section |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Screen render | <1.5s |
| SSE latency | <2s (status change → UI update) |
| Card animation | 60fps on mid-range devices |
| List scroll | 60fps with 50+ cards |

---

## 15. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| Run status changes | SSE `/events/workflow-runs` | Real-time |
| Step progress | SSE (same channel) | Every step transition |
| New run started | SSE | Real-time |
| Run completed/failed | Push notification + SSE | Real-time |

---

## 16. Localization Notes

- Duration: "5m 30s", "2h 15m" (abbreviated Vietnamese-friendly)
- Error messages: Vietnamese for user-facing, English for technical details
- Step names: displayed as-is (user-defined, mix of en/vi)
- Credits: "8 cr" abbreviated format

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `workflow.runs.viewed` | Screen load | `running_count`, `failed_count`, `paused_count` |
| `workflow.run.retried` | Retry action | `run_id`, `workflow_name`, `error_type` |
| `workflow.run.input_provided` | Submit human input | `run_id`, `step_name` |
| `workflow.run.cancelled` | Cancel action | `run_id`, `status_at_cancel` |
| `workflow.run.detail_viewed` | Tap run card | `run_id`, `status` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-success` | Running/completed indicators |
| `--color-danger` | Failed indicators, error text |
| `--color-warning` | Paused indicators, input-needed badge |
| `--color-accent` | Retry/input action buttons |
| `--color-surface-elevated` | Run cards |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W102] Web Run History | Web equivalent (table view with full details) |
| [M051] Approval Queue | Sibling — some approvals come from workflows |
| [M054] Recipe Library | Sibling — template selection |
| [W101] Workflow Builder | Parent — where workflows are designed |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | Full 20-point upgrade from 58-line Tier C. Added 4 card type variants (running/paused/failed/completed), human-input bottom sheet, SSE real-time progress, step progress detail, credit tracking, cancel/skip/dismiss actions, 11 states, comprehensive accessibility. Fixed Screen ID (M058→M050). | System |
