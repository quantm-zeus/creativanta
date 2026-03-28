# Screen: Admin — Background Job Monitor

> **Screen ID**: A016
> **Module**: S26 — Internal Admin & Operations
> **Route**: `/admin/jobs`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: S26 §Operations, A1 Schema (background_jobs, job_queues, job_schedules), B5 RBAC §3

---

## 1. Purpose & Context

Real-time monitoring dashboard for all background jobs across the platform — platform sync jobs, AI processing tasks, scheduled exports, report generation, data migrations, and maintenance tasks. Provides visibility into queue health, processing times, and failure rates with retry/kill capabilities.

### User Story
> As an ops admin, I want to monitor all background job queues in real-time so I can detect processing bottlenecks and failed jobs before they impact users.

### Business Goal
- Operational visibility into async processing health
- Proactive failure detection and rapid remediation
- Queue performance optimization (identify slow jobs)
- Capacity planning data (peak processing patterns)

### When to Use
- Monitoring job queue health during deployments
- Investigating user-reported delays (sync, AI processing)
- Retrying failed jobs after upstream service recovery
- Capacity monitoring during peak hours

### Entry Points
- Admin sidebar → "⚙️ Operations" → "Jobs"
- System Health dashboard → "Queue" panel click
- Alert: "🔴 Job queue backed up" → deep link
- Incident: timeline → "View related jobs" link

### Exit Points
- Click workspace ID → Workspace Detail (`/admin/workspaces/[id]`)
- Click "View Logs" → Job Log Detail panel
- Navigate to System Health for infra view

---

## 2. Preconditions / Postconditions

### Preconditions
- Admin user authenticated via internal auth
- VPN connection active
- Role: `ops_admin` or `super_admin`

### Postconditions
- Job status changes reflected in real-time
- Retried jobs re-enter the queue
- Killed jobs marked as `cancelled` with audit trail
- Audit events: `admin.job.retried`, `admin.job.killed`, `admin.job.paused`

---

## 3. Layout Structure

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ ⚙️ Job Monitor                    [Auto-refresh: 5s 🟢] [⏸ Pause] │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ ┌─ Queue Health Summary ──────────────────────────────────────────┐  │
│ │ 🟢 Running   │ ⏳ Queued    │ ✅ Done (1h)  │ ❌ Failed      │  │
│ │    12        │    45        │    234         │    3            │  │
│ │              │              │                │                 │  │
│ │ ⏱ Avg proc: 8.2s ✅  │  Queue lag: 2.3s ✅  │  P95: 32s ✅  │  │
│ │ Workers: 8/10 active  │  Memory: 67% ✅       │  DLQ: 0 ✅    │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Queue Health Sparkline (24h) ──────────────────────────────────┐  │
│ │ ▁▂▃▅▇█▇▅▃▂▁▁▂▃▅▆▇█▇▅▃▂▁ · Peak: 14:30 (156 jobs/min)        │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ Tabs: [🟢 Running (12)] [⏳ Queued (45)] [❌ Failed (3)]            │
│       [💀 Dead Letter (0)] [📅 Scheduled]                            │
│                                                                       │
│ Filter: [Type ▾] [Workspace ▾] [Priority ▾] [🔍 Search job ID]     │
│                                                                       │
│ ┌─ Job Table ─────────────────────────────────────────────────────┐  │
│ │ ID      │ Type          │ Workspace │ Status  │ Time   │ Acts │  │
│ │─────────│───────────────│───────────│─────────│────────│──────│  │
│ │ j_abc12 │ 🔄 TikTok Sync│ ws_abc   │ 🟢 67% │ 30s    │ ⏸ 🗑│  │
│ │         │ Step 3/5: "Fetching orders p.2"              │      │  │
│ │ j_def34 │ 🤖 AI Script  │ ws_def   │ 🟢 45% │ 12s    │ ⏸ 🗑│  │
│ │         │ Model: Gemini 2.5 · Tokens: 1.2K/3K          │      │  │
│ │ j_ghi56 │ 📊 Report Gen │ ws_ghi   │ 🟢 90% │ 2m 15s │ ⏸ 🗑│  │
│ │         │ Generating Excel export (4K rows)             │      │  │
│ │─── Failed ─────────────────────────────────────────────────────│  │
│ │ j_jkl78 │ 🤖 AI Script  │ ws_jkl   │ ❌     │ 45s    │ 🔄 👁│  │
│ │         │ Error: "OpenAI rate limit exceeded"           │      │  │
│ │         │ Attempts: 3/3 · Last: 10m ago                │      │  │
│ │ j_mno90 │ 🔄 Shopee Sync│ ws_mno   │ ❌     │ 2m     │ 🔄 👁│  │
│ │         │ Error: "Connection timeout to Shopee API"    │      │  │
│ │         │ Attempts: 2/3 · Last: 25m ago                │      │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Bulk Actions ──────────────────────────────────────────────────┐  │
│ │ [☑ 2 selected] [🔄 Retry All Failed] [🗑 Clear Completed]     │  │
│ └──────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
JobMonitorPage
├── AdminShell (shared)
├── PageHeader
│   ├── Title ("⚙️ Job Monitor")
│   ├── AutoRefreshToggle (5s/10s/30s/off)
│   └── PauseRefreshButton
├── QueueHealthSummary (4 metric cards)
│   ├── RunningCard (count + processing details)
│   ├── QueuedCard (count + queue lag)
│   ├── CompletedCard (count in last 1h)
│   ├── FailedCard (count + alert if >0)
│   └── SecondaryMetrics
│       ├── AvgProcessingTime
│       ├── QueueLag (with health indicator)
│       ├── P95ProcessingTime
│       ├── ActiveWorkers
│       ├── MemoryUsage
│       └── DeadLetterQueue count
├── QueueSparkline (24h activity chart)
│   ├── SparklineGraph
│   └── PeakAnnotation
├── TabBar
│   ├── RunningTab (count badge)
│   ├── QueuedTab (count badge)
│   ├── FailedTab (count badge, red if >0)
│   ├── DeadLetterTab (count badge)
│   └── ScheduledTab
├── FilterBar
│   ├── TypeFilter (dropdown: Sync/AI/Report/Export/Migration)
│   ├── WorkspaceFilter (search + dropdown)
│   ├── PriorityFilter (High/Normal/Low)
│   └── SearchInput (job ID search)
├── JobTable
│   ├── TableHeader (sortable columns)
│   └── JobRow[]
│       ├── JobIDCell (monospace)
│       ├── TypeCell (icon + label)
│       ├── WorkspaceCell (clickable → ws detail)
│       ├── StatusCell
│       │   ├── ProgressBar (for running jobs)
│       │   ├── StatusBadge (🟢/⏳/❌/💀)
│       │   └── StepInfo ("Step 3/5: Fetching orders")
│       ├── DurationCell
│       ├── ErrorInfo (conditional — for failed jobs)
│       │   ├── ErrorMessage
│       │   └── AttemptCount
│       └── ActionsCell
│           ├── PauseButton (running only)
│           ├── KillButton (running only)
│           ├── RetryButton (failed only)
│           └── ViewLogsButton (all)
├── BulkActions (when rows selected)
│   ├── SelectedCount
│   ├── RetryAllFailedButton
│   └── ClearCompletedButton
└── LogDrawer (opened by View Logs)
    ├── JobDetails (metadata)
    ├── LogStream (auto-scrolling)
    └── CopyLogsButton
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Queue summary | `background_jobs` aggregation | `AdminJobService/GetQueueStats` | Count cards with health indicators | Real-time (SSE) |
| Sparkline | `job_metrics` (24h) | `AdminJobService/GetQueueHistory(24h)` | Mini line chart | 30s TTL |
| Job list | `background_jobs` | `AdminJobService/ListJobs(tab, filters, page)` | Table rows | Real-time |
| Job progress | `background_jobs.progress` | SSE updates | Percentage + progress bar | Real-time |
| Error details | `background_jobs.error` | included in list | Error message + attempt count | Real-time |
| Log stream | Job stdout/stderr | `AdminJobService/StreamLogs(job_id)` | Monospace log lines | Real-time (SSE) |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Toggle auto-refresh | Click refresh toggle | — (client) | — | Polling starts/stops, indicator changes | Any admin |
| 2 | Filter by type | Select type filter | `AdminJobService/ListJobs(type)` | — | Table filters | Any admin |
| 3 | Search job | Type job ID | `AdminJobService/GetJob(id)` | — | Table shows matching job | Any admin |
| 4 | Pause job | Click ⏸ on running job | `AdminJobService/PauseJob(id)` | `job.status = paused` | Status changes to ⏸, row updates | `ops_admin` |
| 5 | Kill job | Click 🗑 on running job | Confirm → `AdminJobService/KillJob(id)` | `job.status = cancelled` | Confirmation dialog → row updates | `ops_admin` |
| 6 | Retry failed job | Click 🔄 on failed job | `AdminJobService/RetryJob(id)` | New job instance, old marked `retried` | Toast "Retrying..." → job moves to Queued | `ops_admin` |
| 7 | Retry all failed | Click "Retry All Failed" | `AdminJobService/RetryAllFailed(filters)` | Multiple retries | Progress toast → all failed move to Queued | `ops_admin` |
| 8 | View logs | Click 👁 | — | — | Open LogDrawer with real-time log stream | Any admin |
| 9 | View workspace | Click workspace ID | — | — | Navigate to `/admin/workspaces/[id]` | Any admin |
| 10 | Clear completed | Click "Clear Completed" | `AdminJobService/ClearCompleted(older_than)` | Completed jobs archived | Completed rows removed from view | `ops_admin` |
| 11 | Switch tab | Click tab | `AdminJobService/ListJobs(status)` | — | Table shows filtered status | Any admin |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Shimmer summary + skeleton table |
| HEALTHY | All metrics green | Green indicators, no alerts |
| QUEUE_BACKED_UP | Queue lag > 30s | 🔴 Red banner: "Queue backed up! Lag: {n}s. Consider scaling workers." |
| HIGH_FAILURE_RATE | >10% jobs failing | 🟡 Warning banner: "High failure rate: {n}%. Check provider status." |
| DEAD_LETTER_PRESENT | DLQ > 0 | 💀 Red badge on DLQ tab + alert |
| WORKER_SHORTAGE | Active workers < 50% capacity | 🟡 Warning: "Workers at {n}% capacity. {k} jobs waiting." |
| PAUSED | Admin paused refresh | Pause indicator active, data static |
| ERROR | API failure | Error banner with retry |

---

## 8. Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Kill confirmation | Must type job ID | "Type job ID to confirm kill" |
| Retry all | Confirmation required | "Retry {n} failed jobs? This will re-queue them." |
| Clear completed | Age filter required | "Clear jobs completed more than {n} hours ago?" |

---

## 9. Permission Matrix

| Action | Super Admin | Ops Admin | AI Admin | Support Admin | Read Only |
|---|---|---|---|---|---|
| View all jobs | ✅ | ✅ | ✅ (AI jobs only) | ✅ | ✅ |
| Pause/resume job | ✅ | ✅ | ❌ | ❌ | ❌ |
| Kill job | ✅ | ✅ | ❌ | ❌ | ❌ |
| Retry job | ✅ | ✅ | ✅ (AI jobs only) | ❌ | ❌ |
| View logs | ✅ | ✅ | ✅ | ✅ | ❌ |
| Clear completed | ✅ | ✅ | ❌ | ❌ | ❌ |
| Change worker count | ✅ | ❌ | ❌ | ❌ | ❌ |

---

## 10. Navigation Map

```
Job Monitor (/admin/jobs)
├── → /admin/workspaces/[id]    (via workspace ID click)
├── → LogDrawer                  (via View Logs)
├── → /admin/system-health       (via summary cross-link)
├── → /admin/ai/ops              (via AI job type filter)
└── ← /admin                     (via breadcrumb)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Stats fetch failed | API error | Summary cards show "—" | Auto-retry on 5s |
| Job list failed | API error | Table error state | Manual retry |
| Kill failed | Job already completed | Toast: "Job already completed" | No action |
| Retry failed | Queue full | Toast: "Queue at capacity. Wait before retrying." | Wait + retry |
| SSE connection lost | Network issue | "Live updates paused. Reconnecting..." | Auto-reconnect |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Summary cards | `role="status"`, `aria-live="polite"` for count updates |
| Table | Proper headers, sortable columns announced |
| Status badges | Text + color (not color alone) |
| Action buttons | `aria-label` with job context |
| Log drawer | Scrollable with keyboard, `aria-live="polite"` for new entries |
| Sparkline | `aria-label` with peak time and volume |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Page load | <1s | Admin Shell + shimmer |
| Initial data | 200-500ms | Summary populates → table rows animate in |
| Real-time updates | Continuous (SSE) | Rows update in-place, summary counts animate |
| Log stream | < 100ms per line | Auto-scrolling log output |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Page load | <2s |
| Table render | <300ms for 50 rows |
| SSE latency | <1s (job status → UI update) |
| Log stream | <100ms per line |

---

## 15. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| Job status changes | SSE `/admin/events/jobs` | Real-time |
| Queue statistics | SSE (same channel) | 5s aggregate push |
| Log entries | SSE `/admin/events/jobs/{id}/logs` | Real-time (per open drawer) |

---

## 16. Localization Notes

- Admin interface: English only
- Durations: "30s", "2m 15s", "1h 5m" format
- Timestamps: ISO format with relative time ("10m ago")

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `admin.jobs.viewed` | Page load | `running_count`, `queued_count`, `failed_count` |
| `admin.jobs.retried` | Retry job | `job_id`, `job_type`, `attempt_number` |
| `admin.jobs.killed` | Kill job | `job_id`, `job_type`, `running_time` |
| `admin.jobs.bulk_retry` | Retry all | `count` |
| `admin.jobs.logs_viewed` | Open log drawer | `job_id` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-admin-success` | Healthy indicators, completed badge |
| `--color-admin-warning` | Queue lag warning, high failure rate |
| `--color-admin-danger` | Failed badge, backed up alert, DLQ |
| `--font-mono` | Job IDs, log stream, durations |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [A024] System Health | Infrastructure overview |
| [A011] AI Operations | AI-specific job monitoring |
| [A001] Admin Dashboard | Summary metrics |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | Full 20-point upgrade from 60-line Tier C. Added queue health sparkline, secondary metrics (P95, workers, memory, DLQ), dead letter queue tab, scheduled jobs tab, filter bar, log drawer with real-time streaming, bulk actions, 8 states with operational alerts, full S26 RBAC matrix. Fixed Screen ID (A16→A016), module (Admin→S26). | System |
