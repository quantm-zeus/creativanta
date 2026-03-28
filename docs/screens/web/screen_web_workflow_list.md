# Screen: Web — Workflow List

> **Screen ID**: W101
> **Module**: M20 — Workflow Studio
> **Route**: `/workflows`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 05, PRD §28 Workflow Studio, A1 Schema (workflows, workflow_runs, workflow_templates), B5 RBAC §2.7

---
## 1. Purpose & Context

List all automation workflows with status, trigger type, run history, and error alerts. This is the gateway to the visual workflow builder. Workflows automate repetitive tasks: auto-replies, scheduling, content pipelines, commerce actions, and custom business logic.

### User Goals
- View all workflows with their current status and health
- Quickly identify workflows with errors or warnings
- Create new workflows from scratch or templates
- Enable/disable workflows without deleting them

### Business Goals
- Centralize automation management in one view
- Surface workflow errors proactively before they impact operations
- Enable workflow sharing via templates
- Track automation ROI (time saved, actions automated)

### Entry Points
- Sidebar: "⚡ Workflows"
- Home Dashboard: "3 workflows triggered today" card
- Notification: "Workflow 'Auto-respond' failed — review"
- Copilot: "Tạo workflow mới cho auto-reply"

### Exit Points
- "+ Tạo workflow" → Visual Workflow Builder (W102)
- "📋 Templates" → Template Gallery (W106)
- "→ Edit" → Visual Workflow Builder with selected workflow
- "📊 Runs" → Run History (W103)

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `workflow:read` permission (Owner, Admin, Manager)

### Postconditions
- Disabled workflows stop triggering
- Duplicated workflows created in "draft" status
- Deleted workflows are soft-deleted (recoverable for 30 days)

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ⚡ Workflows                    [+ Tạo workflow] [📋 Templates]    │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary Bar ─────────────────────────────────────────────────┐   │
│ │ 🟢 5 active · 📋 3 draft · ⏸ 2 disabled · ⚠️ 1 error       │   │
│ │ Runs (7d): 156 · Actions performed: 892 · Time saved: ~12h  │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Tabs: [🟢 Active (5)] [📋 Draft (3)] [⏸ Disabled (2)]             │
│ Search: [🔍 Search workflows...]                                    │
│                                                                      │
│ ┌─ Workflow Card ───────────────────────────────────────────────┐   │
│ │ ⚡ "Auto-respond to purchase inquiries"       [🟢 Active]    │   │
│ │ Trigger: 💬 New comment with purchase intent                  │   │
│ │ Steps: 4 actions · Created: 15/2                              │   │
│ │                                                                  │   │
│ │ Run stats (7d):                                                 │   │
│ │ ✅ 23 runs · 0 errors · Last run: 15m ago                     │   │
│ │ Avg execution: 2.3s · Success rate: 100%                      │   │
│ │                                                                  │   │
│ │ [→ Edit] [📊 Runs] [⏸ Disable] [📋 Duplicate] [⋮]          │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Workflow Card ───────────────────────────────────────────────┐   │
│ │ ⚡ "Daily content pipeline"                   [🟢 Active]    │   │
│ │ Trigger: ⏰ Cron: 10:00 daily                                 │   │
│ │ Steps: 7 actions · Created: 01/3                              │   │
│ │                                                                  │   │
│ │ Run stats (7d):                                                 │   │
│ │ ✅ 6 runs · ⚠️ 1 warning · Last run: Today 10:00             │   │
│ │ ⚠️ "Step 4 'AI generate' timed out — retried successfully"    │   │
│ │                                                                  │   │
│ │ [→ Edit] [📊 Runs] [⏸ Disable] [📋 Duplicate] [⋮]          │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Workflow Card (error) ───────────────────────────────────────┐   │
│ │ ⚡ "Notify team on new orders"                [🔴 Error]     │   │
│ │ Trigger: 📦 New order received                                │   │
│ │ ⚠️ "Webhook endpoint unreachable since 24/3 — 12 runs failed" │  │
│ │                                                                  │   │
│ │ [→ Fix] [📊 Runs] [⏸ Disable] [⋮]                           │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Pagination: [← Trước] Page 1/1 [Tiếp →]                           │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
WorkflowListPage
├── AppShell (shared)
├── PageHeader
│   ├── PageTitle ("⚡ Workflows")
│   ├── CreateButton ("+ Tạo workflow", primary CTA)
│   └── TemplatesButton ("📋 Templates")
├── SummaryBar
│   ├── StatusCounts (active, draft, disabled, error)
│   ├── RunCount (7d)
│   ├── ActionsPerformed (7d)
│   └── TimeSaved (estimated from manual equivalent)
├── FilterBar
│   ├── StatusTabs (Active, Draft, Disabled)
│   └── SearchInput
├── WorkflowList
│   └── WorkflowCard[]
│       ├── WorkflowName + StatusBadge
│       ├── TriggerInfo
│       │   ├── TriggerIcon (💬 Comment, ⏰ Cron, 📦 Order, etc.)
│       │   └── TriggerDescription
│       ├── StepCount + CreatedDate
│       ├── RunStats
│       │   ├── RunCount (7d)
│       │   ├── ErrorCount
│       │   ├── LastRunTime (relative)
│       │   ├── AvgExecution (seconds)
│       │   └── SuccessRate (%)
│       ├── WarningBanner (if errors or warnings exist)
│       └── ActionBar
│           ├── EditButton ("→ Edit" / "→ Fix" if error)
│           ├── RunHistoryButton ("📊 Runs")
│           ├── DisableButton ("⏸ Disable") / EnableButton ("▶ Enable")
│           ├── DuplicateButton ("📋 Duplicate")
│           └── MoreMenu (⋮ → Delete, Export, Share)
├── Pagination
```

---
## 5. Trigger Types

| Trigger | Icon | Description |
|---|---|---|
| New comment | 💬 | Fires when new comment matches criteria |
| Scheduled (Cron) | ⏰ | Fires at set time/interval |
| New order | 📦 | Fires when new order received |
| Webhook | 🔗 | Fires on external webhook call |
| Content published | 📤 | Fires when content successfully published |
| Manual | 👆 | User-triggered on demand |
| Trend detected | 📈 | Fires when trend radar identifies new trend |
| Form submission | 📝 | Fires when external form submitted |

---
## 6. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Create workflow | "+ Tạo" | — | → Visual Builder (W102) | `workflow:manage` |
| 2 | View templates | "📋 Templates" | — | → Template Gallery | `workflow:read` |
| 3 | Edit/Fix | "→ Edit" / "→ Fix" | — | → Builder with loaded workflow | `workflow:manage` |
| 4 | View runs | "📊 Runs" | — | → Run History (W103) | `workflow:read` |
| 5 | Disable | "⏸" → confirm | `WorkflowService/Disable(id)` | Workflow paused, toast | `workflow:manage` |
| 6 | Enable | "▶ Enable" | `WorkflowService/Enable(id)` | Workflow activated | `workflow:manage` |
| 7 | Duplicate | "📋 Duplicate" | `WorkflowService/Clone(id)` | New draft workflow | `workflow:manage` |
| 8 | Delete | ⋮ → "Delete" → confirm | `WorkflowService/Delete(id)` | Soft-delete (30d recovery) | `workflow:manage` |
| 9 | Search | Search input | Client-side filter | Filtered list | `workflow:read` |

---
## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Summary shimmer + card skeletons |
| LOADED | Data received | Workflow cards with run stats |
| EMPTY | No workflows | "Chưa tạo workflow nào. Tự động hóa công việc lặp lại để tiết kiệm thời gian! [+ Tạo workflow] [📋 Xem templates]" |
| HAS_ERRORS | One or more workflows in error state | Red cards float to top, summary shows error count |
| EMPTY_TAB | No items in selected tab | "Không có workflow nào ở trạng thái này." |
| ERROR | API failed | Error with retry |

---
## 8. Permissions

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View workflows | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Create workflow | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Edit workflow | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Disable/enable | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Delete workflow | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| View run history | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

---

## 9. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached workflows | Retry online |
| Enable fail | API error | Toast: "Không kích hoạt được. [Thử lại]" | Retry |
| Disable fail | API error | Toast: "Không tắt được workflow. [Thử lại]" | Retry |
| Delete fail | API error | Toast: "Không xóa được. [Thử lại]" | Retry |
| Duplicate fail | API error | Toast: "Không nhân bản được. [Thử lại]" | Retry |

---

## 10. Accessibility

| Element | Requirement |
|---|---|
| Summary bar | `role="status"`, `aria-label="{active} active, {error} errors, {runs} runs this week"` |
| Workflow cards | `role="article"`, `aria-label="{name}, status: {status}, last run: {time}"` |
| Status badge | Color + text + icon (🟢/📋/⏸/🔴) |
| Error banner | `role="alert"`, `aria-label="Workflow error: {message}"` |
| Action buttons | `aria-label="{action} workflow {name}"` |
| Tabs | `role="tablist"`, `aria-selected` |

---

## 11. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Summary bar shimmer + card skeletons |
| Summary stats | 100-300ms | Counts populate |
| Workflow cards | 300-600ms | Cards stagger in |
| Run stats | 500-800ms | Per-card run history populates |

---

## 12. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `workflow.list_viewed` | Page load | `active`, `draft`, `disabled`, `error` |
| `workflow.created` | "+ Tạo workflow" | `from` (scratch/template) |
| `workflow.edited` | "→ Edit" | `workflow_id` |
| `workflow.disabled` | "⏸ Disable" | `workflow_id` |
| `workflow.enabled` | "▶ Enable" | `workflow_id` |
| `workflow.duplicated` | "📋 Duplicate" | `workflow_id` |
| `workflow.deleted` | "Delete" confirmed | `workflow_id` |
| `workflow.tab_switched` | Tab change | `tab` |

---

## 13. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/workflows/+page.svelte`
- **Server load**: `+page.server.ts` → `WorkflowService/ListWorkflows(workspace_id)` + `GetWorkflowStats(7d)`
- **Run stats**: Computed per-workflow from `workflow_runs` table (7d window)
- **Error detection**: Server flags workflows with >3 consecutive failures
- **Disable**: `WorkflowService/Disable(id)` — stops trigger listener
- **Soft-delete**: Sets `deleted_at`, recoverable for 30 days
- **Time saved**: Estimated from `avg_manual_time × run_count`

---

## 14. Localization Notes

- Status: "🟢 Đang hoạt động", "📋 Nháp", "⏸ Đã tắt", "🔴 Lỗi"
- Stats: "lần chạy", "hành động", "thời gian tiết kiệm"
- Actions: "Chỉnh sửa", "Tắt", "Nhân bản", "Xóa"
- Tone: Operational, automation-focused

---

## 15. Design Tokens

| Token | Usage |
|---|---|
| `--color-wf-active` | 🟢 Active badge |
| `--color-wf-draft` | 📋 Draft badge |
| `--color-wf-disabled` | ⏸ Disabled badge |
| `--color-wf-error` | 🔴 Error badge + banner |
| `--color-accent` | Create CTA |
| `--color-surface-elevated` | Workflow cards |
| `--font-metric` | Run counts, success rate (tabular-nums) |
| `--color-success` | 100% success rate indicator |

---

## 16. Related Screens

| Screen | Relationship |
|---|---|
| [W102] Visual Workflow Builder | Create/edit workflows |
| [W103] Run History | Workflow execution history |
| [W104] Workflow Approvals | Approval step management |
| [W105] Workflow Tasks | Task step management |
| [W106] Template Gallery | Pre-built workflow templates |
| [W107] Workflow Agents | AI agent configuration |

---

## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (enable, delete), card/summary a11y, 8 analytics, SvelteKit impl (run stats, soft-delete, time saved), localization, 8 design tokens (wf-status). | System |
| 2026-03-28 | 1.0 | Initial specification | System |
