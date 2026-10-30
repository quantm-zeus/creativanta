# Screen: Web — AI Agent Runs

> **Screen ID**: W106
> **Module**: M20 — see canonical feature owner in screen_task_map.csv
> **Route**: `/agents`
> **Platform**: Web (SvelteKit)
> **Upstream**: PRD §28, A1 Schema (`agent_runs`, `agent_run_steps`, `agent_outputs`), B5 RBAC §2.7

---

## 1. Purpose & Context

Monitor AI agent executions — agents that perform multi-step autonomous tasks like research, content generation, or batch operations. Agents differ from workflows in that they make decisions autonomously and can pause for human input.

### User Goals
- Monitor running agents with real-time progress
- Provide input when agents pause for decisions
- Review completed agent outputs
- Cancel runaway agents

### Entry Points
- Sidebar: "🤖 AI Agents" (with running count badge)
- Workflow Builder: "Launch agent" step
- AI Studio: "🤖 Research agent" button

### Exit Points
- "👁 View output" → generated content/data
- "🔄 Run again" → re-launch with same config

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🤖 AI Agents                                                        │
├──────────────────────────────────────────────────────────────────────┤
│ Tabs: [🟢 Running (1)] [⏸ Paused (1)] [✅ Completed (8)] [❌ (0)]│
│                                                                      │
│ ┌─ Agent Run (running) ─────────────────────────────────────────┐   │
│ │ 🤖 Content Research Agent                    [🟢 Running]    │   │
│ │ Task: "Research top 5 skincare trends for March 2026"         │   │
│ │ Progress: Step 3/5 · "Analyzing competitor content..."        │   │
│ │ [░░░░████████████░░░░░░░] 60%                                 │   │
│ │ Duration: 45s · Credits used: 12                               │   │
│ │ Live log:                                                       │   │
│ │   → Searched 8 trend databases                                 │   │
│ │   → Found 23 trending topics                                   │   │
│ │   → Analyzing competitor content... (current)                  │   │
│ │ [👁 View full log] [⏸ Pause] [❌ Cancel]                     │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Agent Run (paused) ──────────────────────────────────────────┐   │
│ │ 🤖 Reply Drafting Agent              [⏸ Paused — needs input]│   │
│ │ Task: "Draft replies for high-priority threads"                │   │
│ │ Paused at: Step 2/4 · "Which tone should I use?"              │   │
│ │                                                                │   │
│ │ 🤖 Agent asks: "3 threads are from potential customers.       │   │
│ │   Should I reply in formal or casual tone?"                    │   │
│ │ [💬 Formal] [💬 Casual] [💬 Custom: ____]                    │   │
│ │                                                                │   │
│ │ Duration: 2m (paused for 10m) · Credits: 8                    │   │
│ │ [▶ Resume with choice] [❌ Cancel]                            │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Agent Run (completed) ───────────────────────────────────────┐   │
│ │ 🤖 Clip Factory Agent                [✅ Done · 1h ago]      │   │
│ │ Task: "Generate 3 clips from serum review video"               │   │
│ │ Results: 3 clips generated · Duration: 2m 30s · Credits: 15   │   │
│ │ Output: [🎬 Clip 1 (30s)] [🎬 Clip 2 (15s)] [🎬 Clip 3 (45s)]│  │
│ │ [👁 View outputs] [🔄 Run again] [📥 Download all]            │   │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Agent card skeletons |
| LOADED | Agents listed | Tab-filtered agent list |
| NO_AGENTS | Never used agents | "Chưa chạy AI agent nào. Agents giúp tự động hóa nghiên cứu, tạo nội dung, và phân tích." |
| AGENT_RUNNING | Live execution | Progress bar with live log |
| AGENT_PAUSED | Awaiting human input | Input prompt with choice buttons |
| ERROR | API failed | Error with retry |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached agents | Retry online |
| Agent crash | Runtime error | Card: "❌ Agent gặp lỗi. [Xem log] [🔄 Chạy lại]" | Re-run |
| Cancel fail | API error | Toast: "Không hủy được agent. [Thử lại]" | Retry |
| Input timeout | No human input >30min | Agent auto-cancels + notification | Re-launch |
| Credit insufficient | Mid-execution | Agent pauses: "⚠️ Hết credits. [Nạp thêm →]" | Top-up → resume |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Tab bar | `role="tablist"`, tabs with `aria-selected` and count in label |
| Agent cards | `role="article"`, `aria-label="{agent_name}, status: {status}, progress: {pct}%"` |
| Live log | `role="log"`, `aria-live="polite"` |
| Human input prompt | `role="dialog"`, `aria-label="Agent needs your input"` |
| Progress bar | `role="progressbar"`, `aria-valuenow`, `aria-label="Step {n}/{total}"` |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Tab bar + agent card skeletons |
| Agent list | 200-400ms | Cards populate per tab |
| Running agents | Real-time | Live log updates via SSE |
| Outputs | 300-600ms | Output thumbnails lazy-load |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `agents.viewed` | Page load | `running`, `paused`, `completed` |
| `agents.tab_switched` | Tab change | `tab` |
| `agents.input_provided` | Human input submitted | `agent_id`, `choice` |
| `agents.cancelled` | "❌ Cancel" confirmed | `agent_id`, `step`, `credits_used` |
| `agents.paused` | "⏸ Pause" | `agent_id` |
| `agents.resumed` | "▶ Resume" | `agent_id` |
| `agents.output_viewed` | "👁 View outputs" | `agent_id`, `output_type` |
| `agents.rerun` | "🔄 Run again" | `agent_id` |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/agents/+page.svelte`
- **Server load**: `+page.server.ts` → `AgentService/ListRuns(workspace_id)` grouped by status
- **Live updates**: SSE from `AgentService/StreamRun(agent_id)` for running agents
- **Human-in-loop**: `AgentService/ProvideInput(agent_id, choice)` → agent resumes
- **Cancel**: `AgentService/CancelRun(agent_id)` — optimistic UI
- **Re-run**: `AgentService/LaunchAgent(same_config)` → new run created
- **Auto-cancel**: Server cron cancels agents paused >30min without input

---

## 13. Localization Notes

- Tabs: "🟢 Đang chạy", "⏸ Tạm dừng", "✅ Hoàn thành", "❌ Lỗi"
- Progress: "Bước {n}/{total}", "~{min} phút còn lại"
- Input: "Agent hỏi:", "Chọn:", "Nhập tùy chỉnh:"
- Tone: Technical, monitoring-focused

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-agent-running` | 🟢 Running badge, progress |
| `--color-agent-paused` | ⏸ Paused badge |
| `--color-agent-completed` | ✅ Done badge |
| `--color-agent-failed` | ❌ Error badge |
| `--color-accent` | Input CTA, re-run |
| `--color-surface-elevated` | Agent cards |
| `--font-mono` | Live log text |
| `--font-metric` | Credits, step counts (tabular-nums) |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W100] Workflow List | Workflows can launch agents |
| [W102] Run History | Workflow execution history |
| [W021] Studio Launcher | Agent launch point |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (crash, cancel, credits), card/log a11y, 8 analytics, SvelteKit impl (SSE, human-in-loop), localization, 8 design tokens (agent-status). | System |
| 2026-03-28 | 1.0 | Initial specification | System |
