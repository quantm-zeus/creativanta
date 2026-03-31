# Screen: Web — Workflow Run History

> **Screen ID**: W103
> **Module**: M20 — Workflow Studio
> **Route**: `/workflows/[id]/runs`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 05, PRD §28, A1 Schema (workflow_runs, workflow_steps, workflow_step_outputs), B5 RBAC §2.7

---
## 1. Purpose & Context

The Workflow Run History shows all execution records for a specific workflow — run status, duration, per-step execution logs with input/output data, error traces, retry capability, and real-time monitoring of in-progress runs. This is the primary debugging and monitoring surface for automations.

### User Goals
- See all past executions of a specific workflow with success/failure status
- Investigate failures by inspecting per-step input/output data and error traces
- Retry failed runs with same input data to verify fixes
- Monitor in-progress runs with live step-by-step progress
- Identify performance bottlenecks (slow steps, duration trends)

### Business Goals
- Diagnose and fix broken automations quickly (reduce MTTR)
- Track workflow reliability (success rate as SLA metric)
- Identify optimization opportunities (slow steps, unnecessary steps)
- Build trust in automation through transparent execution visibility

### When This Screen Is Used
- After workflow failure notification: Inspect what went wrong
- During development: Testing new/modified workflows, watching runs live
- Periodic review: Weekly automation health check
- Performance tuning: Identifying slow steps for optimization

### Entry Points
- Workflow List (W101): "📊 Runs" button on workflow card
- Workflow Builder (W102): "📊 Run History" tab in header
- Notification: "❌ Workflow 'Auto-respond' failed — view run" → deep link to specific run
- Email digest: "3 workflows failed yesterday" → filtered view

### Exit Points
- "🔄 Retry" → Re-queues failed run → stays on page, new run appears
- "← Workflow" → Workflow Builder (W102)
- "← Workflows" → Workflow List (W101)
- "📝 Edit step" → Workflow Builder focused on failed step
- "🔗 View trigger" → Source entity (comment, order, etc.)

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `workflow:read` permission (Editor+ roles)
- Workflow exists and belongs to user's workspace
- Workflow has been triggered at least once (otherwise EMPTY state)

### Postconditions
- Retry action creates new `workflow_run` record with same trigger data
- Debug mode creates temporary breakpoints (cleared after session)
- All page views are tracked for workflow engagement analytics

---
## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + full run list with expanded step details |
| Tablet (768-1279px) | App Shell (collapsed) + run list, step details in slide-over |
| Mobile (≤767px) | Redirect to M045 Mobile Workflow Runs |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Workflow   📊 Run History: "Auto-respond DM khách hỏi giá"       │
│                                              [📤 Export] [⚙ Settings]│
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Run Summary Dashboard ──────────────────────────────────────────┐ │
│ │ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌─────────┐│ │
│ │ │ Total    │ │ Success  │ │ Failed   │ │ Avg Time │ │ Today   ││ │
│ │ │ 145      │ │ 140      │ │ 5        │ │ 2.1s     │ │ 4 runs  ││ │
│ │ │ (30d)    │ │ 96.6% 🟢│ │ 3.4% 🟡 │ │ ↓0.3s   │ │ 0 fails ││ │
│ │ └──────────┘ └──────────┘ └──────────┘ └──────────┘ └─────────┘│ │
│ │                                                                    │ │
│ │ ┌─ Run Trend Chart (sparkline, 30 days) ──────────────────────┐  │ │
│ │ │ ████████████████░░████████████████░░██████████░███████████  │  │ │
│ │ │ Green = success · Red = failed · Height = count              │  │ │
│ │ └──────────────────────────────────────────────────────────────┘  │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ Filter: [Status ▾] [Period ▾] [Trigger type ▾] Search: [🔍 Run ID..]│
│                                                                      │
│ ┌─ Run Row #45 ──────────────────────────────────────────────────┐  │
│ │ #45 · ✅ Completed · 15 phút trước · Duration: 2.3s           │  │
│ │ Trigger: 💬 Comment from @nguyenvana on "Serum review"         │  │
│ │ Steps: 4/4 completed · Output: Reply posted to TikTok          │  │
│ │ Credits used: 1 · [→ View details ▾]                           │  │
│ │                                                                  │  │
│ │ ┌─ Step Details (expanded on click) ────────────────────────┐  │  │
│ │ │                                                            │  │  │
│ │ │ Step 1: 🔔 Trigger (Receive Comment)    ✅ 0.1s           │  │  │
│ │ │ ┌─ Input ──────────────────────────────────────────────┐  │  │  │
│ │ │ │ { "comment_id": "abc123",                           │  │  │  │
│ │ │ │   "text": "Giá bao nhiêu?",                        │  │  │  │
│ │ │ │   "user": "@nguyenvana",                            │  │  │  │
│ │ │ │   "post_id": "post_xyz" }                           │  │  │  │
│ │ │ └────────────────────────────────────────────────────────┘  │  │  │
│ │ │ ┌─ Output ─────────────────────────────────────────────┐  │  │  │
│ │ │ │ { "intent": "purchase_inquiry",                      │  │  │  │
│ │ │ │   "confidence": 0.92,                                │  │  │  │
│ │ │ │   "product_match": "Serum Vitamin C" }               │  │  │  │
│ │ │ └────────────────────────────────────────────────────────┘  │  │  │
│ │ │                                                            │  │  │
│ │ │ Step 2: 🤖 AI Generate (Reply)          ✅ 1.8s          │  │  │
│ │ │   Input: { "prompt": "Trả lời mua hàng..." }            │  │  │
│ │ │   Output: { "reply": "Dạ sản phẩm giá 299K..." }       │  │  │
│ │ │                                                            │  │  │
│ │ │ Step 3: ❓ Condition (Need Approval?)    ✅ 0.0s          │  │  │
│ │ │   Condition: confidence > 0.9 → Auto-proceed              │  │  │
│ │ │   Result: true → Skip approval                             │  │  │
│ │ │                                                            │  │  │
│ │ │ Step 4: 📤 Action (Send Reply)           ✅ 0.4s          │  │  │
│ │ │   Input: { "reply_text": "Dạ sản phẩm giá 299K..." }   │  │  │
│ │ │   Output: { "reply_id": "reply_456", "status": "sent" } │  │  │
│ │ └────────────────────────────────────────────────────────────┘  │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Run Row #43 (Failed) ─────────────────────────────────────────┐  │
│ │ #43 · ❌ Failed · 3h ago · Duration: 0.2s (stopped at step 2) │  │
│ │ Trigger: 💬 Comment from @user123 on "Skincare tips"           │  │
│ │ ❌ Error at Step 2 (AI Generate): Provider timeout after 3 ret │  │
│ │ Steps: 1/4 completed · Failed at: Step 2 "AI Generate"        │  │
│ │ [→ View details ▾] [🔄 Retry] [🐛 Debug] [📝 Edit step]     │  │
│ │                                                                  │  │
│ │ ┌─ Error Details (auto-expanded for failures) ──────────────┐  │  │
│ │ │ ❌ Error: PROVIDER_TIMEOUT                                 │  │  │
│ │ │ Message: "OpenAI API timeout after 30s (3/3 retries)"     │  │  │
│ │ │ Step: AI Generate (#2)                                      │  │  │
│ │ │ Last retry: 3h ago                                          │  │  │
│ │ │ Input that caused error:                                    │  │  │
│ │ │ { "prompt": "Trả lời mua hàng...", "model": "gpt-4o" }   │  │  │
│ │ │                                                              │  │  │
│ │ │ Suggested fix: Check AI provider status or try different    │  │  │
│ │ │ model. [📊 Provider status →]                               │  │  │
│ │ └──────────────────────────────────────────────────────────────┘  │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ Pagination: [← Trước] Page 1/15 [Tiếp →] · 10 per page             │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
WorkflowRunHistoryPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Workflow" → W102)
│   ├── PageTitle ("📊 Run History: {workflow_name}")
│   ├── ExportButton ("📤 Export CSV")
│   └── SettingsLink ("⚙" → workflow settings)
├── RunSummaryDashboard
│   ├── MetricCard[] (5 cards)
│   │   ├── TotalRuns (30d count)
│   │   ├── SuccessRate (percentage + trend + color badge)
│   │   ├── FailedCount (count + percentage)
│   │   ├── AvgDuration (seconds + trend arrow)
│   │   └── TodayCount (runs today + failures today)
│   └── RunTrendChart (30-day sparkline: stacked bar, green/red)
├── FilterBar
│   ├── StatusFilter (All, Completed, Failed, Running, Skipped, Cancelled)
│   ├── PeriodFilter (Today, 7d, 30d, 90d, Custom)
│   ├── TriggerTypeFilter (Comment, Order, Schedule, Manual, Webhook)
│   └── SearchInput (run ID, trigger data full-text search)
├── RunList (paginated)
│   └── RunRow[] (expandable accordion)
│       ├── RunHeader
│       │   ├── RunNumber ("#45")
│       │   ├── StatusBadge (✅/❌/🔄/⏭/🚫)
│       │   ├── Timestamp (relative)
│       │   ├── Duration
│       │   └── CreditsUsed
│       ├── TriggerInfo
│       │   ├── TriggerIcon (comment/order/schedule/webhook)
│       │   ├── TriggerDescription
│       │   └── TriggerSourceLink (→ view original comment/order)
│       ├── StepProgress ("4/4 completed" or "1/4 — failed at step 2")
│       ├── OutputSummary (one-line result description)
│       ├── ErrorSummary (for failed — red text with error type)
│       ├── ActionBar
│       │   ├── ToggleDetailsButton ("→ View details ▾")
│       │   ├── RetryButton ("🔄 Retry", for failed runs only)
│       │   ├── DebugButton ("🐛 Debug", for failed runs)
│       │   └── EditStepButton ("📝 Edit step", for failed — links to builder)
│       └── StepDetails (expandable panel)
│           └── StepRow[]
│               ├── StepNumber
│               ├── StepIcon (trigger/AI/condition/action/delay)
│               ├── StepName
│               ├── StatusIcon (✅/❌/⏳/⏭)
│               ├── Duration
│               ├── InputData (collapsible JSON with syntax highlighting)
│               ├── OutputData (collapsible JSON)
│               ├── ConditionResult (for condition steps: true/false + reason)
│               ├── ErrorDetails (for failed steps)
│               │   ├── ErrorCode
│               │   ├── ErrorMessage
│               │   ├── RetryCount
│               │   ├── SuggestedFix
│               │   └── ProviderStatusLink
│               └── CopyButton (copy step data to clipboard)
├── LiveRunBanner (conditional — when a run is in progress)
│   ├── RunNumber + "🔄 Running..."
│   ├── LiveStepProgress (animated step-by-step)
│   │   └── StepDot[] (grey → spinning → green/red)
│   ├── ElapsedTime (live counter)
│   └── CancelButton
└── Pagination
    ├── PageButtons (Previous, 1, 2, ..., N, Next)
    └── PageSizeSelector (10, 25, 50)
```

---
## 5. Displayed Data

| Element | Source | API | Display Format | Cache |
|---|---|---|---|---|
| Run list | `workflow_runs` | `WorkflowService/ListRuns(workflow_id, filters)` | Paginated rows | 30s |
| Run summary stats | Aggregated from runs | `WorkflowService/GetRunStats(workflow_id, period)` | Metric cards | 5m |
| Step details | `workflow_steps` + `workflow_step_outputs` | `WorkflowService/GetRunDetail(run_id)` | Expandable JSON | On-demand |
| Trend chart | Aggregated daily run counts | Included in stats response | Sparkline bars | 5m |
| Credits used | `credit_transactions WHERE ref_type='workflow_run'` | Included in run data | Integer | 30s |
| Trigger source | Polymorphic: `comments`/`orders`/etc. | Included in run data | Link to entity | 30s |
| Live run progress | WebSocket `/ws/workflow_runs/{run_id}` | Real-time stream | Animated progress | Real-time |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Navigation | Permission |
|---|---|---|---|---|---|---|---|
| 1 | Expand run | Click "→ View details" | Toggle | `WorkflowService/GetRunDetail(run_id)` (lazy) | Step details expand with animation | — | `workflow:read` |
| 2 | Collapse run | Click "▴ Hide details" | Toggle | — | Step details collapse | — | `workflow:read` |
| 3 | Retry failed run | "🔄 Retry" → confirm | Action | `WorkflowService/RetryRun(run_id)` | Confirmation dialog → toast "Run đã re-queue" → new run appears at top | — | `workflow:manage` |
| 4 | Debug failed run | "🐛 Debug" | Navigate | — | → W102 Builder with debug mode, breakpoints at failed step | → W102 | `workflow:manage` |
| 5 | Edit step | "📝 Edit step" | Navigate | — | → W102 Builder focused on the specific failed step | → W102 | `workflow:manage` |
| 6 | View trigger source | Click trigger link | Navigate | — | → Source entity (comment, order, etc.) | → entity page | `workflow:read` |
| 7 | Copy step data | Click copy on JSON | Action | — (clipboard) | Toast "Đã copy dữ liệu" | — | `workflow:read` |
| 8 | Filter runs | Change status/period/trigger filter | Filter | Refetch with filters | Run list updates | — | `workflow:read` |
| 9 | Search | Type in search input | Search | Debounced 300ms query | Filtered results | — | `workflow:read` |
| 10 | Export history | "📤 Export" | Export | `WorkflowService/ExportRuns(workflow_id, filters)` | CSV download | — | `workflow:read` |
| 11 | Cancel live run | "Cancel" on live banner | Destructive | `WorkflowService/CancelRun(run_id)` | Confirmation → run cancelled → status ❌ | — | `workflow:manage` |
| 12 | Change page | Click page number | Paginate | Refetch with offset | Run list updates | — | `workflow:read` |

---
## 7. Validation Rules

### Retry Confirmation
| Field | Rule |
|---|---|
| Confirmation | Must click "Confirm retry" in dialog |
| Note | On retry: same trigger data is replayed. If workflow was edited since failure, new version runs. |

### Search
| Field | Rule | Error |
|---|---|---|
| Query | Min 2 chars | "Nhập ít nhất 2 ký tự" |
| Query | Max 200 chars | Auto-truncate |

---
## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial page load | Summary shimmer + row skeletons | Wait |
| LOADED | Data received | Full summary + run list | Interact normally |
| EMPTY | No runs ever | Illustration + "Workflow chưa chạy lần nào. Sẽ tự động chạy khi trigger kích hoạt. [▶ Chạy thử →]" | Trigger manual test run or wait |
| EMPTY_FILTERED | Filters active, no match | "Không có run phù hợp với bộ lọc. [Xóa bộ lọc]" | Clear filters |
| HAS_FAILURES | Recent failures exist (30d) | Red badge on failure count, failed runs highlighted | Investigate failures |
| RUNNING | A run is currently in progress | LiveRunBanner at top with real-time step animation, elapsed timer | Watch or cancel |
| RETRY_QUEUED | Retry has been triggered | Toast "Run đã queue, đang chờ xử lý..." → new run appears when starts | Wait |
| ERROR | API failed | "Không tải được run history. [Thử lại]" | Retry |

---
## 9. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View run history | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Expand step details | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Copy step data | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ | ❌ |
| Retry failed run | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Debug mode | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Edit step | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Cancel live run | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Export | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Viewer**: Can see run history and step details (read-only debugging). No action buttons except "View details".
- **Editor**: Can view and export but not retry, debug, or cancel.
- **Contributor/External**: No access to workflow screens.

---
## 10. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Live run progress | WebSocket `/ws/workflow_runs/{run_id}` | Real-time (per step completion) |
| New run started | SSE `/events/workflow_runs` | Real-time |
| Run completed/failed | SSE | Real-time (triggers toast if user is on page) |
| Summary stats | Polling | Every 60 seconds |

### Real-time UX
- **Live run**: Step dots animate from grey → spinning → green/red. Elapsed time counts up.
- **New run completes**: Toast "✅ Run #46 completed in 1.8s" (or "❌ Run #46 failed at step 2")
- **Summary stats**: Numbers animate to new values on update

---
## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| Run with 20+ steps | Scrollable step list within expanded row. Collapse all by default. |
| Step output is very large (>10KB JSON) | Truncate to first 500 chars with "📋 Copy full output" and "🔽 View full in modal" |
| Concurrent retry attempts | Server deduplicates — returns existing queued run ID |
| Workflow deleted while viewing runs | Banner: "⚠️ Workflow đã bị xóa. Lịch sử vẫn xem được." Actions disabled. |
| Run triggered by deleted entity | Show trigger info from snapshot data: "💬 [Deleted comment] from @user" |
| 100+ runs per day | Paginate with server-side offset. Summary stats still aggregate full period. |
| Step with null output (timeout/crash) | Show "⚠️ No output captured" instead of empty JSON |
| Premium feature gating | If workflow uses Premium steps but workspace is Free: "⚠️ Premium step — upgrade to enable" |

---
## 12. Accessibility

| Element | Requirement |
|---|---|
| Run list | `role="feed"`, `aria-label="Workflow run history"` |
| Run row | `role="article"`, expandable via `aria-expanded` |
| Status badge | `aria-label` with full status text ("Run 45: completed successfully") |
| Step details | `role="region"`, `aria-label="Step details for run {number}"` |
| JSON code blocks | `role="code"`, copyable via keyboard |
| Live run banner | `role="status"`, `aria-live="polite"` |
| Sparkline chart | `aria-label="Run trend: 145 runs in 30 days, 96.6% success rate"` |

---
## 13. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (summary dashboard) |
| Run list render | < 500ms for 10 rows |
| Step detail expand | < 200ms (lazy-loaded, cached) |
| Live run update frequency | ≤ 500ms per step transition |
| Search latency | < 300ms |
| Export (CSV) | < 5s for 1000 runs |
| JSON syntax highlighting | Client-side, < 50ms per block |

---
## 14. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `workflow.runs.viewed` | Page load | `workflow_id`, `total_runs`, `success_rate`, `period` |
| `workflow.runs.filtered` | Filter change | `filter_type`, `filter_value` |
| `workflow.runs.expanded` | Expand run details | `run_id`, `status`, `step_count` |
| `workflow.runs.retried` | Retry button clicked | `run_id`, `original_error`, `retry_count` |
| `workflow.runs.debug_opened` | Debug button clicked | `run_id`, `failed_step` |
| `workflow.runs.step_copied` | Step data copied | `run_id`, `step_number`, `data_type` (input/output) |
| `workflow.runs.exported` | Export clicked | `run_count`, `filters_applied` |
| `workflow.runs.live_watched` | Live run banner visible > 5s | `run_id` |

---
## 15. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/workflows/[id]/runs/+page.svelte`
- **Server load**: `+page.server.ts` → fetch first page of runs + summary stats
- **Step detail**: Lazy-loaded via client-side fetch on expand
- **JSON display**: `svelte-highlight` or `prismjs` for syntax highlighting
- **WebSocket**: `workflow-run-{id}` channel for live run progress
- **Export**: Server generates CSV with all runs matching current filters

### Data Fetching Strategy
```
+page.server.ts:
  Promise.all([
    workflowService.listRuns({ workflow_id, limit: 10, status, period }),
    workflowService.getRunStats({ workflow_id, period: '30d' })
  ])

Client-side:
  onExpand(run_id) → workflowService.getRunDetail(run_id) // lazy
  onFilter() → workflowService.listRuns({ ...filters })
  WebSocket → subscribe to live run events
```


---
## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W101] Workflow List | Parent list of all workflows |
| [W102] Workflow Builder | Edit/debug workflow (linked from Debug/Edit step) |
| [W104] Workflow Approvals | If run paused for human approval |
| [M045] Mobile Workflow Runs | Mobile equivalent |
---
## Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached data | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được dữ liệu. [Thử lại]" | Retry |
| Not found | 404 | "Không tìm thấy" → navigate back | Back |
| Permission denied | 403 | "Không có quyền truy cập" | Contact admin |

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
