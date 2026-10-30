# Screen: Web — Workflow Builder

> **Screen ID**: W101
> **Module**: M20 — Workflow Studio
> **Route**: `/workflows/[id]` or `/workflows/new`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 05, Product Freeze §28, A1 Schema (workflows)

---

## 1. Purpose & Context

Visual drag-drop workflow builder powered by Activepieces. Three panels: node palette (left), canvas (center), config panel (right). Supports triggers, actions, conditions, and utilities.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Workflows   "Auto-respond..."           [💾 Save] [▶ Test] [⋮]  │
├── Palette (220px) ──┬── Canvas ──────────────┬── Config (320px) ────┤
│ Triggers:            │  ┌──────────┐          │ Selected: AI Generate│
│ ├ 📨 New Comment     │  │ 📨 Trigger│          │ Provider: [Gemini ▾] │
│ ├ 📦 New Order       │  │ New Comment│         │ Prompt: [Generate   │
│ ├ ⏰ Schedule        │  └────┬─────┘          │  reply for           │
│ ├ 🔗 Webhook        │       │                 │  {{trigger.comment}} │
│                      │  ┌────▼─────┐          │  about product       │
│ Actions:             │  │ 🤖 AI     │          │  {{product_name}}]  │
│ ├ 💬 Reply           │  │ Generate  │          │ Max tokens: [500 ▾] │
│ ├ 📧 Send Notif      │  └────┬─────┘          │ Temperature: [0.7]  │
│ ├ 🤖 AI Generate    │       │                 │ Credit cost: ~2/run │
│ ├ 📤 Create Publish  │  ┌────▼─────┐          │                      │
│ ├ 📋 Create Task    │  │ ✅ Need   │          │                      │
│ ├ 📊 Update Record  │  │ Approval? │          │                      │
│                      │  └──┬────┬──┘          │                      │
│ Conditions:          │ Y   │    │  N           │                      │
│ ├ ❓ If/Else         │ ┌───▼──┐┌▼──────┐     │                      │
│ ├ 🔀 Switch         │ │Create││ Send  │     │                      │
│ ├ 🔁 Loop           │ │Task  ││ Reply │     │                      │
│                      │ └──────┘└───────┘     │                      │
│ Utilities:           │                        │                      │
│ ├ 📝 Set Variable   │                        │                      │
│ ├ 🧮 Transform      │                        │                      │
└──────────────────────┴────────────────────────┴──────────────────────┘
```

---

## 3-5. Component & Actions

```
WorkflowBuilderPage
├── AppShell
├── Toolbar (back, title, save, test, menu)
├── ThreeColumnLayout
│   ├── NodePalette (left, 220px)
│   │   ├── TriggerSection (Comment, Order, Schedule, Webhook)
│   │   ├── ActionSection (Reply, Notify, AI Gen, Publish, Task, Update)
│   │   ├── ConditionSection (If/Else, Switch, Loop)
│   │   └── UtilitySection (Variable, Transform, Email)
│   ├── Canvas (center, flexible)
│   │   ├── CanvasNode[] (draggable, connectable)
│   │   ├── Edge[] (connection lines between nodes)
│   │   └── DropZone (for new nodes)
│   └── ConfigPanel (right, 320px)
│       └── NodeConfig (dynamic form based on selected node type)
```

| # | Action | Trigger | API | Result |
|---|---|---|---|---|
| 1 | Add node | Drag from palette | — (client) | Node on canvas |
| 2 | Connect | Drag line between ports | — (client) | Edge created |
| 3 | Configure | Click node | — (client) | Config panel shows |
| 4 | Test | "▶ Test" | `WorkflowService/Test` | Sample data run |
| 5 | Save | "💾 Save" | `WorkflowService/Update` | Toast "Saved" |
| 6 | Activate | Toggle active | `WorkflowService/Update(active=true)` | Live |
| 7 | Delete node | Select + Delete | — (client) | Node removed |

### Technical Notes
- Route: `src/routes/(app)/workflows/[id]/+page.svelte`
- Canvas: Activepieces embedded editor or custom SvelteFlow
- Variables: `{{trigger.x}}` syntax

### Related Screens: [W78] List, [W80] Runs, [W81] Templates

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" — auto-save paused | Retry online |
| Save fail | API error | Toast: "Không lưu được workflow. [Thử lại]" | Retry (local state preserved) |
| Test fail | Execution error | Config panel: "❌ Step {n} failed: {error}" | Fix step |
| Invalid flow | Missing connections | Red border on disconnected nodes + tooltip | Connect nodes |
| Credit estimate fail | Pricing API error | Credit cost: "~? credits" | Retry |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Canvas | `role="application"`, `aria-label="Workflow canvas with {n} nodes"` |
| Nodes | `role="button"`, `aria-label="{node_type}: {node_name}"`, focusable |
| Edges | `aria-hidden="true"` (visual only, described by node connections) |
| Palette | `role="listbox"`, items draggable with keyboard alternative |
| Config panel | `role="form"`, `aria-label="Configure {node_type}"` |
| Toolbar | `role="toolbar"`, buttons with `aria-label` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Toolbar + empty canvas |
| Workflow load | 200-400ms | Nodes and edges populate |
| Config panel | 100ms | Opens on node click |
| Test run | 2-10s | Step-by-step progress in panel |
| Save | 300-500ms | Button loading → "Đã lưu ✅" |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `workflow.builder_opened` | Page load | `workflow_id`, `is_new` |
| `workflow.node_added` | Drag node to canvas | `node_type` |
| `workflow.node_configured` | Config saved | `node_type`, `config_fields` |
| `workflow.edge_created` | Connect nodes | `from_type`, `to_type` |
| `workflow.tested` | "▶ Test" | `node_count`, `success`, `duration` |
| `workflow.saved` | "💾 Save" | `node_count`, `is_active` |
| `workflow.activated` | Toggle active | `workflow_id` |
| `workflow.node_deleted` | Delete node | `node_type` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/workflows/[id]/+page.svelte`
- **Server load**: `+page.server.ts` → `WorkflowService/Get(id)` or empty for new
- **Canvas**: Activepieces embedded editor or custom SvelteFlow with D3-based edges
- **Drag-drop**: Palette → canvas using `@svelte-dnd-action` or native DnD API
- **Variables**: `{{trigger.x}}` interpolated in config fields, autocomplete from trigger schema
- **Auto-save**: Debounced 5s after last change, visual indicator "Đang lưu..."
- **Test**: `WorkflowService/Test(workflow_id, sample_data)` → SSE step results

---

## 12. Localization Notes

- Toolbar: "Lưu", "Kiểm tra", "Kích hoạt"
- Palette: "Triggers", "Actions", "Điều kiện", "Tiện ích"
- Config: "Cấu hình {node_type}", "Biến:", "Credits/lần chạy:"
- Tone: Technical, builder-focused

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-accent` | Save CTA, active toggle |
| `--color-node-trigger` | Trigger node color |
| `--color-node-action` | Action node color |
| `--color-node-condition` | Condition node color |
| `--color-node-utility` | Utility node color |
| `--color-edge` | Connection lines |
| `--color-surface-elevated` | Config panel, node cards |
| `--color-danger` | Invalid connections, test errors |

---

## 14. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (save, test), canvas/panel a11y, 8 analytics, SvelteKit impl (Activepieces, drag-drop, auto-save), localization, 8 design tokens (node-type). | System |
| 2026-03-28 | 1.0 | Initial specification | System |

## Preflight before activation

Show a review panel for per-node target, permission, capability, approval and quoted maximum spend from WorkflowService/Test. Unknown inputs/quotes remain visible and block a paid bounded plan. Simulation is labeled throughout. Graph/target/budget changes invalidate approval and show a diff requiring renewed confirmation; do not silently resume changed actions.
