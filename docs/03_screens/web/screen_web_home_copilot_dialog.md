# Screen: Web — Copilot Dialog

> **Screen ID**: W008
> **Module**: M01 — Home & Decision (AI Copilot)
> **Route**: Overlay/Sidebar (global, accessible from any page)
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §9, CopilotService

---

## 1. Purpose & Context

The AI Copilot is a conversational AI assistant that slides in from the right side of any page. It can answer questions about the workspace data, suggest actions, generate content, and help with decision-making. Context-aware: it knows what page the user is on and can reference visible data.

### User Story
> As a creator, I want to ask my AI assistant questions and get help with tasks without leaving my current workflow.

### Entry Points
- Quick Action: "🤖 Hỏi AI Copilot" (from any page)
- Keyboard: Cmd+J
- TopBar: 🤖 icon
- Script Editor: AI tab in side panel

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ Current Page Content ──────────────┬─ Copilot Sidebar (400px) ─────┐
│                                      │                                │
│ ... current page ...                 │ 🤖 AI Copilot         [✕]    │
│                                      │                                │
│                                      │ Context: 📊 Analytics page    │
│                                      │                                │
│                                      │ 💬 Conversation:              │
│                                      │                                │
│                                      │ You: "Tháng này nội dung nào │
│                                      │  hoạt động tốt nhất?"         │
│                                      │                                │
│                                      │ 🤖: "Dựa trên dữ liệu 30    │
│                                      │  ngày qua, top 3 bài:        │
│                                      │  1. '5 tips nấu ăn' - 24K    │
│                                      │  2. 'Serum review' - 8.5K    │
│                                      │  3. 'Haul tháng 3' - 3.2K   │
│                                      │                                │
│                                      │  Video skincare có eng rate   │
│                                      │  cao hơn food 2x. Gợi ý:     │
│                                      │  tập trung skincare tiếp."   │
│                                      │                                │
│                                      │ [💡 Tạo ý tưởng skincare]   │
│                                      │ [📊 Xem chi tiết analytics]  │
│                                      │                                │
│                                      │ You: "Tạo 5 ý tưởng video   │
│                                      │  skincare cho tuần này"       │
│                                      │                                │
│                                      │ 🤖: "Đang tạo ý tưởng..."  │
│                                      │ ██████░░░░░░ 60%              │
│                                      │                                │
│                                      │ ┌─ Quick Suggestions ────────┐│
│                                      │ │ "Xu hướng tuần này?"       ││
│                                      │ │ "Phân tích đối thủ"        ││
│                                      │ │ "Revenue tháng này?"       ││
│                                      │ └────────────────────────────┘│
│                                      │                                │
│                                      │ [Type your question...  ] [→]│
│                                      │ AI Credits: 12/100            │
└──────────────────────────────────────┴────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
CopilotSidebar (global overlay component)
├── SidebarHeader
│   ├── CopilotIcon + Title
│   ├── ContextBadge (current page indicator)
│   └── CloseButton
├── ConversationArea (scrollable)
│   └── MessageBubble[]
│       ├── UserMessage (right-aligned)
│       │   └── MessageText
│       └── CopilotMessage (left-aligned)
│           ├── MessageText (markdown rendered, streaming)
│           ├── ActionButtons[] (contextual: create idea, view detail, etc.)
│           ├── DataCards[] (embedded charts/tables when relevant)
│           └── ProgressIndicator (when generating)
├── QuickSuggestions (expandable)
│   └── SuggestionChip[] (contextual based on current page)
├── InputArea
│   ├── TextInput (auto-resize, max 500 chars)
│   ├── AttachButton (for images/files context)
│   └── SendButton
└── CreditIndicator
```

---

## 4-5. Data & Actions

| UI Element | Source | API |
|---|---|---|
| Conversation | Client-side state (session) | N/A |
| Context | Current route + page data | Client-side |
| AI responses | `CopilotService/Query` | Streaming RPC |
| Quick suggestions | `CopilotService/GetSuggestions(context)` | Pre-computed |
| Credits | `AdminBillingService/GetCreditBalance` | Cached |

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Send message | Type + Enter or → | `CopilotService/Chat(message, context)` | AI streaming response | `copilot:use_help` |
| 2 | Use suggestion | Click suggestion chip | Same as send | Response based on suggestion | `copilot:use_help` |
| 3 | Click action | Click action button in response | Varies | Navigate or create entity | Varies |
| 4 | Close | ✕ or Esc | — | Sidebar closes, conversation preserved | Any |
| 5 | Clear history | ⋮ → "Xóa cuộc trò chuyện" | — (client) | Conversation reset | Any |
| 6 | Attach file | 📎 button → file picker | Context added to next message | File preview shown | Any |

---

## 6-20. Standard Sections

### States
| State | Visual |
|---|---|
| CLOSED | Hidden |
| OPEN_EMPTY | Welcome message + quick suggestions |
| OPEN_CONVERSATION | Chat history visible |
| AI_RESPONDING | Typing indicator, then streaming text |
| AI_ERROR | "AI không phản hồi. [Thử lại]" |
| CREDITS_EXHAUSTED | "Hết credit. [Nạp thêm →]" |

### Copilot Modes
| Mode | Context | Capabilities |
|---|---|---|
| `help` | General questions | Q&A, basic suggestions |
| `deep` | Analytics, research | Data analysis, reports |
| `create` | Content creation | Generate ideas, scripts |
| `reply` | Inbox | Suggest replies |
| `script_assist` | Script editor | Writing assistance |
| `trend_analysis` | Trend detail | Trend analysis |
| `benchmark` | Benchmark view | Competitive analysis |

### Credit Consumption
| Mode | Cost | Notes |
|---|---|---|
| help | 0.1 credit/message | Basic Q&A |
| deep | 0.5 credit/message | Heavy analysis |
| create | 2 credits/batch | Idea/script generation |

### Permission Matrix
- `copilot:use_help` (all roles except Viewer): basic help mode
- `copilot:use_analytics` (Owner, Admin, Manager): deep analysis mode
- `copilot:use_creative` (Owner, Admin, Manager, Editor): content creation mode

### Performance
- Sidebar open: < 200ms animation
- First token: < 1s
- Streaming: tokens appear progressively
- Conversation preserved in sessionStorage

### Accessibility
- `role="complementary"` on sidebar
- `role="log"` on conversation area
- `aria-live="polite"` for new messages
- Keyboard: Cmd+J toggle, Escape close

### Technical Notes
- Component: `src/lib/components/CopilotSidebar.svelte`
- Global: mounted in `+layout.svelte`, toggled via Svelte 5 `$state` rune
- Streaming: SSE endpoint for progressive token display
- Context: `$page.route` + `$state` for page-specific data
- Session: conversations stored per session, cleared on tab close

### Related Screens
Every screen (Copilot is globally accessible)

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

---

## 2. Preconditions / Postconditions
### Preconditions
- User authenticated with valid session
- Required module permissions granted
### Postconditions
- User actions persisted to backend
- Analytics events dispatched

---

## 5. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Primary data | Parent screen state or canonical contract object(s) | Resolve via owning feature doc + API/schema contracts | Exact DTO fields from canonical contracts | Per endpoint policy |
| List items | Parent screen list/query contract(s) | Resolve via API endpoint map before implementation | Card or row layout per wireframe | Per endpoint policy |
| Summary stats | Parent screen aggregates/projections | Resolve via feature rules + API contracts | Count / KPI / chip formatting per screen | Short-lived cache only if contract allows |
| User-facing text | i18n keys | — | Vietnamese | Static |

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
