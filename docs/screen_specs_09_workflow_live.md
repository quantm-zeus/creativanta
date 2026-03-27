# Screen Specs 09 — Workflow, Automation, Live & Seeding (M18-M22)

> **Upstream**: Product Freeze §28-32, Pack 05 (Agent/Workflow), A1 Schema (workflows, workflow_runs, agent_runs, recipe_templates, live_sessions, cue_cards, highlights, sample_requests)
> **Screens**: 14 web + 6 mobile screens
> **Screen Numbers**: §78-§91 (per screen_index.md canonical numbering)

---

## 78. Workflow List

**Route**: `/workflows`
**Purpose**: List all automation workflows — active, draft, disabled. Shows run history and trigger info.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ⚡ Workflows              [+ Tạo workflow] [📋 Templates]       │
├──────────────────────────────────────────────────────────────────┤
│ Tabs: [Active (5)] [Draft (3)] [Disabled (2)]                   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Workflow Card ─────────────────────────────────────────────┐ │
│ │ ⚡ "Auto-respond to purchase inquiries"    [🟢 Active]      │ │
│ │ Trigger: New comment with purchase intent                   │ │
│ │ Steps: 4 · Last run: 15m ago · Runs (7d): 23 · Errors: 0  │ │
│ │ [→ Edit] [📊 Runs] [⏸ Disable] [📋 Duplicate]              │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Workflow Card ─────────────────────────────────────────────┐ │
│ │ ⚡ "Daily content pipeline"                [🟢 Active]      │ │
│ │ Trigger: Cron 10:00 daily                                   │ │
│ │ Steps: 7 · Last run: Today 10:00 · Runs: 30 · Errors: 1   │ │
│ │ ⚠️ Last run had 1 warning                                   │ │
│ │ [→ Edit] [📊 Runs] [⏸ Disable]                              │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## 79. Workflow Builder

**Route**: `/workflows/[id]` or `/workflows/new`
**Purpose**: Visual workflow builder — drag-drop nodes, configure triggers, actions, conditions. Powered by Activepieces.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Workflows   "Auto-respond..."         [💾 Save] [▶ Test] [⋮]│
├── Node Palette (left, 220px) ──┬── Canvas (center) ──────────────┤
│                                │                                  │
│ Triggers:                      │  ┌──────────┐                   │
│ ├ 📨 New Comment               │  │ 📨 Trigger│                   │
│ ├ 📦 New Order                 │  │ New Comment│                  │
│ ├ ⏰ Schedule (Cron)           │  │ w/ Purchase│                  │
│ ├ 🔗 Webhook                  │  │ Intent    │                   │
│                                │  └────┬─────┘                   │
│ Actions:                       │       │                          │
│ ├ 💬 Reply to Comment          │  ┌────▼─────┐                   │
│ ├ 📧 Send Notification         │  │ 🤖 AI     │                   │
│ ├ 🤖 AI Generate              │  │ Generate  │                   │
│ ├ 📤 Create Publish Item       │  │ Reply     │                   │
│ ├ 📋 Create Task              │  └────┬─────┘                   │
│ ├ 📊 Update Record            │       │                          │
│ ├ 🔗 HTTP Request              │  ┌────▼─────┐                   │
│ ├ ⏸ Wait / Delay              │  │ ✅ Need   │                   │
│                                │  │ Approval?│                   │
│ Conditions:                    │  └──┬────┬──┘                   │
│ ├ ❓ If/Else                   │ Yes │    │ No                   │
│ ├ 🔀 Switch                   │ ┌───▼──┐ ┌▼──────┐             │
│ ├ 🔁 Loop                     │ │ 📋   │ │ 💬    │             │
│                                │ │Create│ │ Send  │             │
│ Utilities:                     │ │Task  │ │ Reply │             │
│ ├ 📝 Set Variable             │ └──────┘ └───────┘             │
│ ├ 🧮 Transform                │                                  │
│ ├ 📧 Send Email               │                                  │
│                                │                                  │
├────────────────────────────────┤── Config Panel (right, 320px)───┤
│                                │                                  │
│                                │ ┌─ Selected: AI Generate ─────┐│
│                                │ │ Provider: [Gemini ▾]        ││
│                                │ │ Prompt: [Generate reply     ││
│                                │ │  for {{trigger.comment}}    ││
│                                │ │  about product             ││
│                                │ │  {{trigger.product_name}}] ││
│                                │ │ Max tokens: [500 ▾]        ││
│                                │ │ Temperature: [0.7]          ││
│                                │ │ Credit cost: ~2 per run     ││
│                                │ └─────────────────────────────┘│
└────────────────────────────────┴─────────────────────────────────┘
```

### Behavior
- **Canvas**: Drag nodes from palette, connect with lines
- **Click node**: Config panel opens on right
- **Double-click node**: Inline edit
- **Test**: "▶ Test" runs with sample data → shows output per node
- **Variables**: `{{trigger.x}}` syntax for referencing data between nodes
- **Validation**: Red indicators on nodes with missing required fields
- **Save**: Saves to Activepieces via `WorkflowService/Update`
- **Publish**: "Activate" toggle → workflow starts processing

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Add node | Drag from palette | — (client) | Node appears on canvas |
| Connect nodes | Drag line between ports | — (client) | Edge created |
| Configure node | Click node | — (client) | Config panel opens |
| Test workflow | "▶ Test" | `WorkflowService/Test` | Test run with sample data |
| Save | "💾 Save" | `WorkflowService/Update` | Toast "Saved" |
| Activate | Toggle "Active" | `WorkflowService/Update(active=true)` | Workflow starts |
| Delete node | Select + Delete key | — (client) | Node removed |

---

## 80. Workflow Run History

**Route**: `/workflows/[id]/runs`
**Purpose**: Execution history of a workflow — status, duration, errors, per-step logs.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Workflow   📊 Run History: "Auto-respond..."                  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Run Row ───────────────────────────────────────────────────┐ │
│ │ #45 · 15m ago · Duration: 2.3s · ✅ Completed              │ │
│ │ Trigger: Comment from @nguyenvana · Actions: 3/3 OK        │ │
│ │ [→ View details]                                            │ │
│ └──────────────────────────────────────────────────────────────┘ │
│ ┌─ Run Row ───────────────────────────────────────────────────┐ │
│ │ #44 · 1h ago · Duration: 5.1s · ⚠️ Completed with warning │ │
│ │ Trigger: Comment from @lehoa · Warning: Reply too long      │ │
│ │ [→ View details]                                            │ │
│ └──────────────────────────────────────────────────────────────┘ │
│ ┌─ Run Row ───────────────────────────────────────────────────┐ │
│ │ #43 · 3h ago · Duration: 0s · ❌ Failed                    │ │
│ │ Error: AI provider timeout · Step: AI Generate              │ │
│ │ [→ View details] [🔄 Retry]                                 │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

### Run Detail View
```
┌─ Per-Step Execution ──────────────────────────────────────────┐
│ Step 1: Trigger        ✅ 0.1s   Input → Output data          │
│ Step 2: AI Generate    ✅ 1.8s   Prompt → Generated reply     │
│ Step 3: Need Approval? ✅ 0.0s   Result: No (auto)            │
│ Step 4: Send Reply     ✅ 0.4s   Reply posted to TikTok       │
└───────────────────────────────────────────────────────────────┘
```

---

## 81. Recipe Templates

**Route**: `/workflows/templates`
**Purpose**: Pre-built workflow templates — one-click deploy common automations.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 📋 Templates                      [🔍 Search templates]         │
├──────────────────────────────────────────────────────────────────┤
│ Categories: [All] [Engagement] [Commerce] [Content] [Analytics] │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Template Card ─────────────────────────────────────────────┐ │
│ │ ⚡ Auto-respond to purchase inquiries                       │ │
│ │ Trigger: New comment with purchase intent                   │ │
│ │ Actions: AI reply → Approval check → Send reply             │ │
│ │ Used by: 1,234 workspaces · ⭐ 4.8/5                       │ │
│ │ [▶ Preview flow] [📥 Use template]                          │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Template Card ─────────────────────────────────────────────┐ │
│ │ ⚡ Daily content pipeline                                   │ │
│ │ Trigger: Cron 10:00 · Check trends → Generate ideas →      │ │
│ │ Create scripts → Queue for review                           │ │
│ │ [▶ Preview flow] [📥 Use template]                          │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## 82. Approval Queue

**Route**: `/approvals`
**Purpose**: Centralized approval queue — scripts, assets, workflows, publish items awaiting approval.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ✅ Phê duyệt                         Pending: 8                 │
├──────────────────────────────────────────────────────────────────┤
│ Filter: [Tất cả ▾] [Scripts ▾] [Assets ▾] [Publish ▾]         │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Approval Item ─────────────────────────────────────────────┐ │
│ │ 📝 Script: "5 tips nấu ăn nhanh"                            │ │
│ │ Requested by: Quân · 2h ago · Priority: Normal              │ │
│ │ From idea: #23 · Word count: 245                             │ │
│ │ [👁 Preview] [✅ Approve] [📝 Request changes] [❌ Reject]  │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Approval Item ─────────────────────────────────────────────┐ │
│ │ 🎬 Asset: "Serum VitC product video"                        │ │
│ │ Requested by: Hoa · 5h ago · Priority: High                 │ │
│ │ [👁 Preview] [✅ Approve] [📝 Request changes] [❌ Reject]  │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

### Inline Preview
- Click "👁 Preview" → slide-out panel showing content
- Approve/reject without leaving queue
- Batch approve: select multiple → "Approve all selected"

---

## 83. Task Queue

**Route**: `/tasks`
**Purpose**: All tasks — workflow-generated, manual, follow-ups. Kanban or list view.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 📋 Tasks                     [+ Tạo task] [View: ▦|☰]          │
├──────────────────────────────────────────────────────────────────┤
│ Filter: [Assigned to me ▾] [Priority ▾] [Source ▾]             │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Kanban: [To Do (5)] [In Progress (3)] [Done (12)]              │
│ Cards: task title + priority + due date + source + assignee     │
│ Drag between columns to update status                           │
└──────────────────────────────────────────────────────────────────┘
```

---

## 84. Agent Runs

**Route**: `/agents`
**Purpose**: Monitor AI agent executions — agents that perform multi-step autonomous tasks.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🤖 AI Agents                                                    │
├──────────────────────────────────────────────────────────────────┤
│ Tabs: [Running (1)] [Completed (8)] [Paused (1)] [Failed (0)]  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Agent Run ─────────────────────────────────────────────────┐ │
│ │ 🤖 Content Research Agent                [🟢 Running]       │ │
│ │ Task: "Research top 5 skincare trends for March 2026"       │ │
│ │ Progress: Step 3/5 · "Analyzing competitor content..."      │ │
│ │ Duration: 45s · Credits: 12 used so far                      │ │
│ │ [👁 View log] [⏸ Pause] [❌ Cancel]                         │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Agent Run ─────────────────────────────────────────────────┐ │
│ │ 🤖 Reply Drafting Agent              [⏸ Paused — needs input]│ │
│ │ Task: "Draft replies for high-priority threads"              │ │
│ │ Paused at: Step 2 — "Which tone? Formal or casual?"         │ │
│ │ [💬 Provide input] [▶ Resume] [❌ Cancel]                    │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## 85-88. Live Commerce Screens

### 85. Live Session Planner (`/live/plan`)
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🔴 Live Session Planner                    [+ Tạo phiên live]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Upcoming Session ──────────────────────────────────────────┐ │
│ │ 🔴 "Spring Sale Live — Skincare"        Tối nay 19:00      │ │
│ │ Platform: TikTok Live · Duration: 2h planned                │ │
│ │ Products: 8 · Cue cards: 12 · Special offers: 3            │ │
│ │ [📋 Prepare] [→ War Room] [✏️ Edit]                        │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

### 86. Live Session Setup (`/live/[id]/setup`)

**Purpose**: Prepare everything for a live session — product lineup, cue cards, special offers, equipment.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Live   ⚙️ Setup: "Spring Sale"            [✅ Bắt đầu live →]  │
├──────────────────────────────────────────────────────────────────┤
│ Tabs: [Sản phẩm (8)] [Cue Cards (12)] [Offers (3)] [Checklist]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ── Sản phẩm Tab (Drag-reorder) ──                                 │
│ ┌─ Product Order ───────────────────────────────────────────┐ │
│ │ ≡ 1. Serum Vitamin C ─ 299K → 249K 🔥 ─ Stock: 245       │ │
│ │   Talking points: 3 · Duration: ~10 min                    │ │
│ │ ≡ 2. Kem chống nắng ─ 199K ─ Stock: 180                    │ │
│ │   Talking points: 2 · Duration: ~8 min                     │ │
│ │ ≡ 3. Combo set ─ 549K → 449K ─ Stock: 56                   │ │
│ │ [+ Thêm sản phẩm từ catalog]                                │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ── Cue Cards Tab ──                                               │
│ ┌─ Cue Card Editor ─────────────────────────────────────────┐ │
│ │ ⏱ 0:00 ─ "Chào mừng, giới thiệu chương trình"                │ │
│ │ ⏱ 0:05 ─ "Serum VitC: điểm nổi bật, demo"                   │ │
│ │ ⏱ 0:15 ─ "Flash sale: giảm 50K chỉ trong 5 phút!"            │ │
│ │ [+ Thêm cue card]                                             │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ── Checklist Tab ──                                               │
│ ┌─ Equipment & Readiness ────────────────────────────────────┐ │
│ │ ☑ Camera đã sẵn sàng                                          │ │
│ │ ☑ Micro kết nối                                                │ │
│ │ ☑ Ánh sáng kiểm tra                                             │ │
│ │ ☐ Internet speed test (≥ 10 Mbps)                             │ │
│ │ ☑ Sản phẩm bày trưng bày                                      │ │
│ └──────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

### 87. Live War Room (`/live/[id]/war-room`)
```
┌─ Full Screen (no sidebar) ───────────────────────────────────────┐
│ 🔴 LIVE · "Spring Sale" · 00:45:23 · 👁 1,234 viewers          │
├──────────────────────────────────────────────────────────────────┤
│ ┌─ Product Queue (left, 25%) ──┬─ Chat Triage (center, 50%)───┐│
│ │                               │                               ││
│ │ Now: Serum VitC              │ [Live chat stream]             ││
│ │ ├ Price: 299K → 249K 🔥      │ AI-highlighted: purchase      ││
│ │ ├ Stock: 45 remaining        │ intents in green background   ││
│ │ ├ Orders this session: 12    │                               ││
│ │ └ [📋 Cue Card]              │ [Quick reply...]              ││
│ │                               │                               ││
│ │ Next: Kem chống nắng         │ ┌─ Right Panel (25%) ────────┐││
│ │ After: Combo set              │ │ 📊 Live Stats              │││
│ │                               │ │ Total orders: 45           │││
│ │ [▼ Next product]             │ │ Revenue: 12.5M             │││
│ │ [⏱ Timer: 3:00 remaining]   │ │ Viewers peak: 1,890        │││
│ │                               │ │ Engagement: 12%            │││
│ │ ┌─ Quick Actions ──────────┐ │ │─────────────────────────────│││
│ │ │ [🔥 Flash Sale NOW]      │ │ │ 🔔 Alerts                   │││
│ │ │ [📌 Highlight]           │ │ │ ⚠️ 3 negative comments     │││
│ │ │ [🏷 Show coupon]        │ │ │ ⚠️ Stock < 10 for Serum    │││
│ │ │ [📸 Pin product]        │ │ │ 💡 Viewer spike — show      │││
│ │ └──────────────────────────┘ │ │    offer NOW                │││
│ │                               │ └─────────────────────────────┘││
│ └───────────────────────────────┴──────────────────────────────┘ │
│ [End Session] [📊 Post-Live Summary]                             │
└──────────────────────────────────────────────────────────────────┘
```

### 88. Post-Live Summary (`/live/[id]/summary`)

**Purpose**: Comprehensive post-session analytics with AI-generated insights.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Live   📊 Post-Live: "Spring Sale"          [📥 Export Report]  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Session Metrics ─────────────────────────────────────────┐ │
│ │ ⏱ Duration   │ 👁 Peak Viewers │ 📦 Orders  │ 💰 Revenue    │ │
│ │ 1h 45min     │ 1,890          │ 78        │ 18.5M VND   │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Viewer Timeline Chart ───────────────────────────────────┐ │
│ │ [Area chart: viewers over time + order spikes marked]       │ │
│ │ Markers: 🔥 Flash sale moments · 📦 Order clusters              │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ Tabs: [Performance] [Products] [Chat Analytics] [AI Insights]    │
│                                                                  │
│ ── Products Tab ──                                                │
│ ┌─ Per-Product Performance ────────────────────────────────┐ │
│ │ 1. Serum VitC: 34 orders · 8.5M · Best moment: 0:15-0:25   │ │
│ │ 2. Combo set: 22 orders · 5.8M · Best moment: 0:45-0:55    │ │
│ │ 3. Kem chống nắng: 15 orders · 3.0M · Flash sale peak       │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ── AI Insights Tab ──                                             │
│ ┌─ AI-Generated Improvement Suggestions ───────────────────┐ │
│ │ 💡 "Viewer peak ở phút 15 khi flash sale — thử tạo 2     │ │
│ │    flash sale moments thay vì 1 trong lần tới"              │ │
│ │ 💡 "34% tin nhắn là hỏi giá — pin giá sản phẩm lên màn   │ │
│ │    hình sớm hơn"                                            │ │
│ │ 💡 "Avg order value tăng 25% khi demo combo — tăng thời │ │
│ │    lượng demo combo"                                         │ │
│ └──────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## 89-91. Seeding Module Screens

### 89. Sample Request Manager (`/seeding/requests`)

**Purpose**: Manage sample product requests from creators/influencers for review content.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🌱 Seeding Requests                [+ Tạo yêu cầu] [Filter ▾]     │
├──────────────────────────────────────────────────────────────────┤
│ Pipeline: [Requested(5)] → [Approved(3)] → [Shipped(2)] →       │
│           [Received(8)] → [Review Published(12)]                │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Request Card ───────────────────────────────────────────┐ │
│ │ 📦 Serum Vitamin C → @skincare_queen (45K followers)       │ │
│ │ Status: [🟡 Shipped] · Tracking: VNPOST-123456               │ │
│ │ Expected review: 05/04/2026 · Platform: TikTok               │ │
│ │ Creator profile: 45K followers · 4.8% engagement              │ │
│ │ [📱 Track] [💬 Contact] [📊 Profile] [✅ Mark received]       │ │
│ └──────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

### 90. Creator Assignment (`/seeding/assignments`)

**Purpose**: Assign products to creators and track their content deliverables.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🌱 Creator Assignment               [+ Assign sản phẩm]           │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Assignment Table ────────────────────────────────────────┐ │
│ │ Creator       │ Product     │ Status          │ Deadline  │ │
│ │───────────────┼─────────────┼─────────────────┼───────────┤ │
│ │ @skincare_qn  │ Serum VitC  │ 🟢 Published     │ Done      │ │
│ │ @cooking_tips │ Giả vị      │ 🟡 Creating      │ 05/04     │ │
│ │ @beauty_vn    │ Kem CN     │ 🟠 Received      │ 10/04     │ │
│ │ @tech_review  │ -          │ ⚪ Assigned      │ Pending   │ │
│ └──────────────────────────────────────────────────────────┘ │
│                                                                  │
│ Status flow: Assigned → Shipped → Received → Creating → Published│
└──────────────────────────────────────────────────────────────────┘
```

### 91. Seeding Campaign Dashboard (`/seeding/campaigns`)

**Purpose**: Campaign-level view of seeding effectiveness + ROI.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🌱 Seeding Campaigns                   [+ Tạo campaign mới]     │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Campaign Card ──────────────────────────────────────────┐ │
│ │ 🌱 "Spring Skincare Seeding"             [🟢 Running]       │ │
│ │ Products: 3 seeded · Creators: 8 · Content: 5 published    │ │
│ │ Cost: 2.4M (samples) · Revenue attributed: 18.5M           │ │
│ │ ROI: 7.7x · Total reach: 234K                               │ │
│ │ [📊 Dashboard] [🎥 Content gallery] [✏️ Edit]                │ │
│ └──────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## Mobile Screens

### M8. Mobile Workflow Monitor

**Route**: `/workflows` (mobile)
**Purpose**: Monitor workflow runs with quick triage for failures.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ⚙️ Workflows                                [+ Tạo mới]         │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Tabs: [🔄 Running (2)] [✅ Done (15)] [🔴 Failed (1)]           │
│                                                                  │
│ ┌─ Workflow Card ────────────────────────────────────────────┐  │
│ │ ⚙️ "Auto-publish TikTok"                    [🔄 Running]  │  │
│ │ Step 3/5: Uploading video · Est. 2 min                     │  │
│ │ [████████████░░░░] 60%                                     │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Workflow Card ────────────────────────────────────────────┐  │
│ │ ⚙️ "Morning Brief Generator"                [🔄 Running]  │  │
│ │ Step 2/3: Fetching TikTok data                             │  │
│ │ [████████░░░░░░░░] 40%                                     │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Workflow Card ────────────────────────────────────────────┐  │
│ │ ⚙️ "Shopee Order Sync"                       [🔴 Failed]  │  │
│ │ Error: "API rate limit exceeded"                            │  │
│ │ [🔄 Retry] [📋 View logs]                                 │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Pull-to-refresh · Push notifications on failure                  │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M8 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View history | Tap card | — | → Run history bottom sheet |
| Retry | "Retry" on failed | `WorkflowService/Retry` | Re-queued |
| View logs | "View logs" | — | Log viewer bottom sheet |
| Filter | Tap tab | — | List filtered by status |
| Pull-to-refresh | Pull down | `WorkflowService/ListRuns` | Runs refreshed |

---

### M35. Mobile Approval Queue

**Route**: `/workflows/approvals` (mobile)
**Purpose**: Swipe-to-approve/reject workflow for pending items.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Chờ duyệt                                  [Pending: 5]       │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Approval Item ────────────────────────────────────────────┐  │
│ │ 📝 Script: "5 tips skincare"                               │  │
│ │ Author: @minh · Submitted: 30 min ago                      │  │
│ │ [📖 Preview]                                                │  │
│ │ ← Swipe R: [✅ Approve] · Swipe L: [❌ Reject]            │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Approval Item ────────────────────────────────────────────┐  │
│ │ 📤 Publish: "Serum review" → TikTok                        │  │
│ │ Scheduled: 18:00, 27/3 · Auto-approved if no action by     │  │
│ │ 17:00                                                       │  │
│ │ [📖 Preview]                                                │  │
│ │ ← Swipe R: [✅ Approve] · Swipe L: [❌ Reject]            │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Approval Item ────────────────────────────────────────────┐  │
│ │ ↩ Refund: Order #12450 · 350,000đ                         │  │
│ │ Reason: Product damaged · Evidence: 2 photos               │  │
│ │ [📖 Preview]                                                │  │
│ │ ← Swipe R: [✅ Approve] · Swipe L: [❌ Reject]            │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Pull-to-refresh                                                  │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M35 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Preview | "Preview" | — | Bottom sheet with content preview |
| Approve | Swipe right | `ApprovalService/Approve` | Item approved |
| Reject | Swipe left → reason | `ApprovalService/Reject` | Item rejected |
| Pull-to-refresh | Pull down | `ApprovalService/List` | Queue refreshed |

---

### M36. Mobile Live War Room

**Route**: `/live/[sessionId]` (mobile)
**Purpose**: Simplified live selling control with chat stream and product queue.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ 🔴 LIVE · 1.2K viewers · 45 min           [🛑 End live]         │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ── Product Queue (horizontal scroll) ──                          │
│ ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐                │
│ │ [🖼]    │ │ [🖼]    │ │ [🖼]    │ │ [🖼]    │                │
│ │ Serum   │ │ Toner   │ │ Cream   │ │ Mask    │                │
│ │ 350K    │ │ 280K    │ │ 450K    │ │ 150K    │                │
│ │ [📌NOW] │ │ [Next]  │ │ [Queue] │ │ [Queue] │                │
│ └─────────┘ └─────────┘ └─────────┘ └─────────┘                │
│                                                                  │
│ ┌─ Chat Stream (scrollable) ─────────────────────────────────┐  │
│ │ 👤 A: "Serum này dùng cho da dầu được không?"              │  │
│ │ 👤 B: "Mua rồi, rất thích! 💕"                             │  │
│ │ 👤 C: "Còn mấy cái?"                                       │  │
│ │ 🤖 AI: "Purchase intent detected: 3 messages"              │  │
│ │ 👤 D: "Ship COD được không ạ?"                              │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Floating Quick Actions ───────────────────────────────────┐  │
│ │ [⚡ Flash Sale] [➡️ Next Product] [📢 Announce]            │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Stats Bar ────────────────────────────────────────────────┐  │
│ │ 💰 12 orders · 4.2M revenue · 📈 Conversion: 8.5%        │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

#### M36 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Next product | "Next Product" | `LiveService/NextProduct` | Product queue advances |
| Flash sale | "Flash Sale" → confirm | `LiveService/TriggerFlashSale` | Price drops, haptic |
| Announce | "Announce" | `LiveService/Announce` | Message pinned in chat |
| End live | "End live" → confirm | `LiveService/EndSession` | Session closes |

---

### M37. Mobile Task Queue

**Route**: `/tasks` (mobile)
**Purpose**: Central task queue with priority badges and completion tracking.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ 📋 Tasks                                    [Filter ▾] [Sort ▾] │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Tabs: [⏰ Pending (8)] [✅ Done (24)] [🔴 Overdue (1)]          │
│                                                                  │
│ ┌─ Task (high priority) ─────────────────────────────────────┐  │
│ │ 🔴 Review 5 pending scripts                                │  │
│ │ Priority: High · Due: 2h · Source: Auto                    │  │
│ │ ← Swipe R: [✅ Done]                                      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Task ─────────────────────────────────────────────────────┐  │
│ │ 🟡 Reply to 3 purchase intents in inbox                    │  │
│ │ Priority: Medium · Due: 4h · Source: InboxService          │  │
│ │ ← Swipe R: [✅ Done]                                      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Task ─────────────────────────────────────────────────────┐  │
│ │ 🟢 Update product descriptions                             │  │
│ │ Priority: Low · Due: 2d · Source: Manual                   │  │
│ │ ← Swipe R: [✅ Done]                                      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Pull-to-refresh                                                  │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M37 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Complete | Swipe right | `TaskService/Complete` | Task marked done |
| View detail | Tap task | — | → Linked screen (inbox, scripts, etc.) |
| Filter | Tap tab | — | List filtered by status |
| Pull-to-refresh | Pull down | `TaskService/List` | Tasks refreshed |

