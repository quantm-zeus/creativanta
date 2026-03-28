# Screen: Web — AI Idea Generator

> **Screen ID**: W18
> **Module**: M04 — Content Creation (Ideas)
> **Route**: `/ideas/generate`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §12, A1 Schema (ideas, idea_scores), CopilotService

---

## 1. Purpose & Context

The AI Idea Generator creates content ideas from natural language prompts, trends, audience data, and product catalog. Users describe what they want ("content ideas about skincare for TikTok"), and AI generates 10+ scored suggestions with titles, hooks, format suggestions, and estimated performance.

### User Story
> As a creator, I want AI to brainstorm content ideas based on my niche, trends, and audience so I can save time and discover angles I wouldn't think of myself.

### Entry Points
- Idea Board: "🤖 AI Generate"
- Quick Action: "✨ Tạo ý tưởng mới"
- Copilot: "Gợi ý ý tưởng cho tôi"
- Direct URL: `/ideas/generate`

### Exit Points
- Save ideas → /ideas (Idea Board with new cards)
- Edit idea → /ideas/[id]
- Discard → back to /ideas

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Ý tưởng   🤖 AI Tạo ý tưởng                                     │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Input Section ────────────────────────────────────────────────┐  │
│ │ Prompt: [Tạo 10 ý tưởng video skincare cho TikTok, đối       ] │  │
│ │         [tượng 18-25 nữ, phong cách fun & educational      ] │  │
│ │                                                                  │  │
│ │ ┌─ Context Options (expandable) ─────────────────────────────┐ │  │
│ │ │ Platform: [☑ TikTok] [☐ IG] [☐ YT]                       │ │  │
│ │ │ Use trends: [☑ Kết hợp xu hướng đang hot]                 │ │  │
│ │ │ Product focus: [☐ Gắn sản phẩm cụ thể: [Serum VitC ▾]]  │ │  │
│ │ │ Audience: [☑ Dựa trên audience data hiện tại]             │ │  │
│ │ │ Style: [Fun ▾] Tone: [Educational ▾]                       │ │  │
│ │ │ Count: [10 ▾]                                              │ │  │
│ │ └────────────────────────────────────────────────────────────┘ │  │
│ │                                                                  │  │
│ │ [🤖 Tạo ý tưởng]  AI Credits: 12 remaining (cost: 2 credits) │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ AI Generating... ─────────────────────────────────────────────┐  │
│ │ 🤖 Đang tạo ý tưởng... ███████░░░░░░ 70%                     │  │
│ │ Tip: AI đang phân tích xu hướng và dữ liệu audience của bạn  │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Generated Ideas (results) ────────────────────────────────────┐  │
│ │                                                                  │  │
│ │ ┌─ Idea Result ──────────────────────────────────────────────┐│  │
│ │ │ ☑ 1. "5 sai lầm skincare bạn đang mắc mỗi sáng"          ││  │
│ │ │ ⭐ 88/100 · Format: Short-form (30-60s) · Hook: question  ││  │
│ │ │ 🤖 "Dạng 'sai lầm' luôn viral trên TikTok VN. Kết hợp   ││  │
│ │ │    xu hướng morning routine và audience skincare 18-25."    ││  │
│ │ │ Tags: [skincare] [mistakes] [morning] [viral]              ││  │
│ │ │ [✏️ Sửa tiêu đề] [🏷 Sửa tags]                           ││  │
│ │ └────────────────────────────────────────────────────────────┘│  │
│ │                                                                  │  │
│ │ ┌─ Idea Result ──────────────────────────────────────────────┐│  │
│ │ │ ☑ 2. "POV: Bạn có 100K để mua skincare — mua gì?"        ││  │
│ │ │ ⭐ 82/100 · Format: Short-form (45s) · Hook: scenario     ││  │
│ │ │ 🤖 "POV format trending. Budget challenge luôn engage."   ││  │
│ │ │ Tags: [skincare] [budget] [challenge]                      ││  │
│ │ │ [✏️ Sửa tiêu đề] [🏷 Sửa tags]                           ││  │
│ │ └────────────────────────────────────────────────────────────┘│  │
│ │                                                                  │  │
│ │ ... more results (scrollable) ...                               │  │
│ │                                                                  │  │
│ │ ┌─ Idea Result (unchecked) ──────────────────────────────────┐│  │
│ │ │ ☐ 7. "So sánh serum Vitamin C 100K vs 500K"               ││  │
│ │ │ ⭐ 61/100 · Format: Long-form (3-5m)                      ││  │
│ │ │ 🤖 "Comparison content works. Lower score due to overlap."││  │
│ │ └────────────────────────────────────────────────────────────┘│  │
│ │                                                                  │  │
│ │ Actions: [☑ Select all] Đã chọn: 8/10                         │  │
│ │ [🔄 Tạo lại] [💾 Lưu đã chọn vào Board] [❌ Hủy bỏ tất cả] │  │
│ └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
AIIdeaGeneratorPage
├── AppShell (shared)
├── PageHeader
│   ├── BackButton (→ /ideas)
│   └── Title
├── InputSection
│   ├── PromptTextarea (auto-resize, max 500 chars)
│   ├── ContextOptions (collapsible)
│   │   ├── PlatformCheckboxes
│   │   ├── UseTrendsToggle
│   │   ├── ProductFocusToggle + ProductSelector
│   │   ├── UseAudienceToggle
│   │   ├── StyleDropdown
│   │   ├── ToneDropdown
│   │   └── CountDropdown (5/10/15/20)
│   ├── CreditInfo ("12 remaining, cost: 2")
│   └── GenerateButton
├── GeneratingIndicator (shown during generation)
│   ├── ProgressBar (indeterminate or stream progress)
│   └── TipText (rotating AI tips)
└── ResultsSection (shown after generation)
    ├── IdeaResultCard[] (selectable)
    │   ├── Checkbox
    │   ├── IdeaNumber
    │   ├── Title (editable inline)
    │   ├── ScoreBadge
    │   ├── FormatSuggestion
    │   ├── HookType
    │   ├── AIExplanation
    │   ├── TagChips (editable)
    │   ├── EditTitleButton
    │   └── EditTagsButton
    ├── SelectAllCheckbox + SelectedCount
    └── ActionBar
        ├── RegenerateButton ("🔄 Tạo lại")
        ├── SaveSelectedButton ("💾 Lưu đã chọn")
        └── DiscardButton ("❌ Hủy")
```

---

## 4. Data Binding & Display Format

| UI Element | Source | Display Format |
|---|---|---|
| Generated title | AI response | Text |
| Score | AI response + scoring model | Badge "⭐ 88/100" |
| Format | AI response | Text "Short-form (30-60s)" |
| Hook type | AI response | Chip: question/scenario/stat/list/POV |
| Explanation | AI response | Italic text |
| Tags | AI response (editable) | Chip list |
| Credit cost | Computed: count × 0.2 | "cost: 2 credits" |

---

## 5. Actions Table

| # | Action | Trigger | API Call | UI Result | Permission |
|---|---|---|---|---|---|
| 1 | Generate | "🤖 Tạo ý tưởng" | `CopilotService/GenerateIdeas(prompt, options)` | Progress → results | `idea:generate` |
| 2 | Toggle selection | Click checkbox | — (client) | Check/uncheck | — |
| 3 | Select all | "☑ Select all" | — (client) | All checked | — |
| 4 | Edit title | "✏️ Sửa" → inline edit → Enter | — (client) | Title updates | — |
| 5 | Edit tags | "🏷 Sửa" → tag editor → save | — (client) | Tags update | — |
| 6 | Regenerate | "🔄 Tạo lại" | Same API, new request | New results replace old | `idea:generate` |
| 7 | Save selected | "💾 Lưu" | `IdeaService/BulkCreate(selected_ideas)` | Navigate to /ideas with toast | `idea:create` |
| 8 | Discard | "❌ Hủy" → confirm | — | Navigate to /ideas | — |

---

## 6. State Machine

```
┌──────────────┐
│   INITIAL    │ ← Prompt input visible, no results
└──────┬───────┘
       │ Click "Tạo ý tưởng"
       ▼
┌──────────────┐
│ GENERATING   │ ← Progress indicator, prompt disabled
└──────┬───────┘
       │ Response complete
       ▼
┌──────────────┐
│  RESULTS     │ ← Ideas displayed, select/edit mode
└──────┬───────┘
       │
       ├── "Tạo lại" → GENERATING
       ├── "Lưu" → SAVING → /ideas
       └── "Hủy" → confirm → /ideas

Special:
├── INSUFFICIENT_CREDITS → "Hết credit AI. [Nạp thêm →]"
├── ERROR → "AI không thể tạo ý tưởng. [Thử lại]"
└── STREAM → Ideas appear one by one (typewriter animation)
```

---

## 7. Validation Rules

### Prompt
| Field | Rule | Error |
|---|---|---|
| Prompt | Required, 10-500 chars | "Prompt phải từ 10-500 ký tự" |
| Credits | Balance ≥ cost | "Không đủ credit. [Nạp thêm →]" |
| Platform | At least 1 selected | "Chọn ít nhất 1 nền tảng" |

### Edit (inline)
| Field | Rule | Error |
|---|---|---|
| Title | 5-200 chars | "Tiêu đề phải từ 5-200 ký tự" |
| Tags | Max 10 | "Tối đa 10 tag" |

---

## 8-20. Standard Sections

### Permission Matrix
- `idea:generate`: Owner, Admin, Manager, Editor (uses AI credits)
- `idea:create`: Required to save results
- Contributors: limited by credit allocation

### Error Handling
| Error | Response |
|---|---|
| AI timeout | "AI mất quá lâu. Thử lại hoặc đơn giản hóa prompt." |
| Insufficient credits | Block generate, show "Nạp thêm" link |
| Partial results | Show what was generated + "AI dừng sớm" warning |

### Accessibility
- Progress bar: `role="progressbar"`, `aria-label="Đang tạo ý tưởng"`
- Checkboxes: full keyboard support
- Inline edit: `role="textbox"`, focus management

### Performance
- Streaming: ideas appear progressively (not all at once)
- Typical generation: 5-15 seconds for 10 ideas
- No heavy assets on this page

### Real-time
- Streaming response via SSE for progressive rendering
- Credits update immediately after generation

### Technical Notes
- Route: `src/routes/(app)/ideas/generate/+page.svelte`
- AI call: streaming RPC via `CopilotService/GenerateIdeas`
- Results stored client-side until saved (not persisted to DB until "Lưu")
- Credit deduction happens at generation start (pre-debit)

### Related Screens
| Screen | Relationship |
|---|---|
| [W17] Idea Board | Parent and save target |
| [W19] Idea Detail | After saving, cards link here |
| [W06] Copilot Dialog | Alternative generation path |

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-27 | 1.0 | Initial specification |

---

## 2. Preconditions / Postconditions
### Preconditions
- User authenticated with valid session
- Required module permissions granted
### Postconditions
- User actions persisted to backend
- Analytics events dispatched

---

## 10. Navigation Map
```
AI Idea Generator (/ideas/generate)
├── → Related detail/action screens
├── → Action result destinations
└── ← Parent screen (via back/breadcrumb)
```

---

## 13. Loading Behavior
| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | Shell + shimmer skeleton |
| Data fetch | 200-500ms | Content populates progressively |
| User action | <1s | Inline spinner → result feedback |

---

## 16. Localization Notes
- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator)
- Date: DD/MM/YYYY
- Numbers: dot separator (1.234)
- Tone: Friendly, action-oriented

---

## 17. Analytics / Tracking Events
| Event | Trigger | Properties |
|---|---|---|
| `ai_idea_generator.viewed` | Screen load | `source` |
| `ai_idea_generator.action` | Primary user action | `action_type`, relevant IDs |
| `ai_idea_generator.error` | Error occurred | `error_type`, `error_code` |

---

## 18. Design Tokens Reference
| Token | Usage |
|---|---|
| `--color-accent` | Primary actions, CTAs |
| `--color-success` | Positive states |
| `--color-warning` | Warning indicators |
| `--color-danger` | Error states, destructive |
| `--color-surface-elevated` | Cards, elevated surfaces |
