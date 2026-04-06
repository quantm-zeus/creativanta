# Screen: Mobile — Agent Runs

> **Screen ID**: M053
> **Module**: M21 — Recipe & Agent Center
> **Route**: `/agents` (mobile)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (`agent_runs`, `agent_run_steps`, `agent_outputs`), B5 RBAC §2.7

---

## 1. Purpose & Context

Monitor AI agent executions on mobile — running/paused/completed/failed cards with progress, retry, and output viewing.

### Entry Points - Sidebar: "🤖 Agents" / Push: "🤖 Agent completed"
### Exit Points - "👁 View output" → output gallery

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Agent Runs                                                        │
├──────────────────────────────────────────────────────────────────────┤
│ Chips: [All] [🟢 Running (2)] [✅ Done (15)] [❌ Failed (1)]      │
│ ┌─ Run Card (running) ─────────────────────────────────────────┐   │
│ │ 🤖 Clip Factory Agent               [🟢 Running]             │   │
│ │ "Generate serum review clip" · 5 min ago                       │   │
│ │ Step 3/5 · "Rendering video..." · [████████░░ 60%]           │   │
│ │ Credits: 12 so far · [⏸ Cancel]                               │   │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Run Card (done) ────────────────────────────────────────────┐    │
│ │ 🤖 Script Writer Agent              [✅ Done · 1h ago]       │    │
│ │ 3 outputs · 15 credits · 2m 30s                               │    │
│ │ [👁 View outputs] [🔄 Run again]                              │    │
│ └────────────────────────────────────────────────────────────────┘   │
│ ┌─ Run Card (failed) ──────────────────────────────────────────┐    │
│ │ 🤖 Trend Analyzer                   [🔴 Failed · 2h ago]     │    │
│ │ Error: "Timeout — API unavailable"                             │    │
│ │ [🔄 Retry] [👁 View logs]                                     │    │
│ └────────────────────────────────────────────────────────────────┘   │
│ Pull-to-refresh                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7. States
| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Card shimmer |
| LOADED | Agents listed | Filtered list |
| EMPTY | No agents run | "Chưa chạy AI agent nào." |
| AGENT_RUNNING | Live execution | Progress bar + step info |
| ERROR | API failed | Error with retry |

---

## 2. Preconditions / Postconditions
### Preconditions
- User authenticated with valid session
- Required module permissions granted
### Postconditions
- User actions persisted to backend
- Related screens updated via state management
- Analytics events dispatched

---

## 4. Component Hierarchy
```
AgentRunsScreen
├── AppBar
│   ├── BackButton
│   ├── Title ("Agent Runs")
│   └── FilterChipsButton
├── ContentArea (scrollable, pull-to-refresh)
│   ├── StatusChips (All / Running / Done / Failed)
│   ├── RunList
│   │   └── AgentRunCard[]
│   │       ├── AgentName + StatusBadge
│   │       ├── TaskSummary
│   │       ├── StepProgress
│   │       ├── CreditsUsed
│   │       ├── OutputPreviewChips (done only)
│   │       └── ActionRow (view outputs / retry / cancel)
│   ├── EmptyState
│   └── ErrorBanner (conditional)
└── BottomNavBar (shared)
```

---

## 5. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Agent runs | `agent_runs` filtered by `current_state` | `AgentService/ListRuns` | Card list grouped by status chip | 15s stale max |
| Step progress | Latest `agent_run_steps` summary included in run payload | `AgentService/StreamRun` for live runs | "Step 3/5 · Rendering video..." | Live / no cache |
| Outputs | `agent_outputs` count + preview metadata | Included in run summary or streamed detail | Chips like "3 outputs" / preview thumbnails | No cache |
| Credits used | `agent_runs.credits_used` | `AgentService/ListRuns` | Integer badge ("12 credits") | No cache |
| User-facing text | i18n keys | — | Vietnamese | Static |


---
## 19. Related Screens
| Screen | Relationship |
|---|---|
| [W106] Web AI Agent Runs | Web equivalent |
---
## Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached data | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được dữ liệu. [Thử lại]" | Retry |
| Not found | 404 | "Không tìm thấy" → navigate back | Back |
| Permission denied | 403 | "Không có quyền truy cập" | Contact admin |

---
## Accessibility

| Element | Requirement |
|---|---|
| Interactive elements | Minimum 48×48dp tap targets |
| Icons with meaning | `Semantics(label:)` descriptive text |
| Status indicators | Color not sole indicator; text/icon also present |
| Dynamic content | `Semantics(liveRegion: true)` for updates |
| Contrast | 4.5:1 minimum ratio |

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
