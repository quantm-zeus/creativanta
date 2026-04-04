# Screen: Web — Opportunity Convert

> **Screen ID**: W045
> **Module**: M04 — Opportunity Board
> **Route**: `/intelligence/opportunities/[id]/convert`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, A1 Schema (opportunities, ideas, scripts)

---

## 1. Purpose & Context

Guided wizard to convert an opportunity into actionable content. Users choose between quick idea creation, direct script writing, or multi-piece planning. Pre-filled with AI suggestions from the opportunity analysis.

### User Story
> As a creator, I want a guided flow to turn an opportunity into content quickly, with AI pre-filling the details.

### Entry Points
- Opportunity Detail: "💡 Tạo ý tưởng" or "📝 Viết script"
- Direct URL: `/intelligence/opportunities/[id]/convert`

### Exit Points
- Complete → redirects to created idea/script
- Cancel → back to opportunity detail

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Cơ hội   Chuyển đổi cơ hội thành nội dung                        │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ Cơ hội: "Morning skincare routine" ⭐ 89                            │
│                                                                      │
│ ┌─ Step 1: Chọn hình thức ──────────────────────────────────────┐  │
│ │                                                                  │  │
│ │ ┌─ Option ─────────┐  ┌─ Option ─────────┐  ┌─ Option ──────┐ │  │
│ │ │ 💡 Tạo 1 ý tưởng│  │ 📝 Viết script   │  │ 📦 Batch plan │ │  │
│ │ │ Nhanh, thêm vào │  │ trực tiếp        │  │ Tạo nhiều ý   │ │  │
│ │ │ Idea Board       │  │ từ gợi ý AI      │  │ tưởng + lên   │ │  │
│ │ │ [◉ Selected]     │  │ [○]              │  │ lịch          │ │  │
│ │ └──────────────────┘  └──────────────────┘  └───────────────┘ │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Step 2: Chi tiết (pre-filled from AI) ────────────────────────┐ │
│ │ Title: [Morning skincare routine — step by step            ]   │ │
│ │ Platform: [🎵 TikTok ▾]                                       │ │
│ │ Format: [Short-form (30-60s) ▾]                                │ │
│ │ Tags: [skincare] [morning] [routine] [+ Add]                   │ │
│ │                                                                  │ │
│ │ AI Context (read-only preview):                                 │ │
│ │ "Dựa trên cơ hội: low competition, audience match 92%"        │ │
│ │                                                                  │ │
│ │ Notes: [                                                    ]   │ │
│ └────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ [❌ Hủy]                                    [✅ Tạo và mở →]       │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
OpportunityConvertPage
├── AppShell (shared)
├── PageHeader
│   ├── BackButton
│   └── Title
├── OpportunitySummary (banner)
├── StepWizard
│   ├── Step1_TypeSelector
│   │   └── OptionCard[] (Single idea / Direct script / Batch plan)
│   └── Step2_DetailForm
│       ├── TitleInput (pre-filled from AI suggestion)
│       ├── PlatformSelector
│       ├── FormatSelector
│       ├── TagInput
│       ├── AIContextPreview (read-only)
│       └── NotesTextarea
└── ActionBar
    ├── CancelButton
    └── CreateButton
```

---

## 4-5. Data & Actions

| UI Element | Source | Display |
|---|---|---|
| Opportunity summary | `opportunities` | Title + score badge |
| Pre-filled title | `opportunities.content_suggestions[0].title` | Editable input |
| Pre-filled format | `opportunities.content_suggestions[0].format` | Dropdown |
| AI context | `opportunities.analysis_text` (truncated) | Read-only text |

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Select type | Click option card | — (client) | Step 2 shows relevant form | Any |
| 2 | Create idea | "✅ Tạo và mở" (single idea) | `IdeaService/Create(from_opp, details)` | → `/ideas/[new_id]` | `idea:create` |
| 3 | Create script | "✅ Tạo và mở" (direct script) | `ScriptService/Create(from_opp, details)` | → `/scripts/[new_id]` | `script:create` |
| 4 | Batch create | "✅ Tạo và mở" (batch) | `IdeaService/BulkCreate(suggestions)` | → `/ideas` with toast | `idea:create` |
| 5 | Cancel | "❌ Hủy" | — | Back to opportunity detail | Any |

---

## 6. Edge Cases

| Edge Case | Handling |
|---|---|
| Opportunity expired (> 30d) | Banner: "Cơ hội này đã hết hạn. Bạn vẫn có thể tạo ý tưởng từ nó." |
| Opportunity already converted | Info: "Đã tạo {n} ý tưởng từ cơ hội này. [Tạo thêm?]" |
| Batch plan > 10 ideas | Cap at 10: "Tối đa 10 ý tưởng mỗi lần batch" |
| AI suggestion empty | Pre-fill title from opportunity title, format as default |
| User lacks script:create | "Viết script" option disabled with tooltip: "Cần quyền script:create" |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" | Queue submission for when online |
| Opportunity not found | 404 | "Cơ hội không tồn tại. [Quay lại]" | Back to board |
| Creation failed | API error | Toast: "Không tạo được. [Thử lại]" — form preserved | Retry |
| Batch creation partial | Some fail | Toast: "Tạo {n}/{total}. {failed} thất bại. [Thử lại phần còn lại]" | Retry failed |
| Permission denied | 403 | Toast: "Không có quyền tạo {type}" | Contact admin |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Step wizard | `role="group"`, `aria-label="Bước {n} trên {total}"` |
| Option cards (step 1) | `role="radiogroup"`, cards as `role="radio"` with `aria-checked` |
| Pre-filled inputs | `aria-label` with field name, pre-fill announced |
| AI context (read-only) | `aria-label="Bối cảnh AI từ cơ hội"`, `aria-readonly="true"` |
| Create button | `aria-label="Tạo {type} và mở"`, loading state announced |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Opportunity banner + step 1 options |
| Pre-fill load | 200-500ms | Step 2 fields populate from opportunity |
| Creating | 500ms-2s | Button spinner + disabled form |
| Success redirect | 0ms | Toast "✅ Đã tạo!" + navigate |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `opportunity_convert.opened` | Page load | `opportunity_id`, `score`, `source` |
| `opportunity_convert.type_selected` | Step 1 selection | `type` (idea/script/batch) |
| `opportunity_convert.completed` | Create success | `opportunity_id`, `type`, `platform`, `time_to_convert` |
| `opportunity_convert.failed` | Create error | `opportunity_id`, `type`, `error_type` |
| `opportunity_convert.cancelled` | Cancel click | `opportunity_id`, `step_reached` |
| `opportunity_convert.prefill_edited` | User edits AI pre-fill | `field_changed` |
| `opportunity_convert.batch_count` | Batch plan selected | `idea_count` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/intelligence/opportunities/[id]/convert/+page.svelte`
- **Server load**: `+page.server.ts` → `OpportunityService/Get(id)` + `content_suggestions[0]` for pre-fill
- **Step wizard**: Client-side state (`currentStep: 1|2`)
- **Create (single)**: `IdeaService/Create({ from_opportunity_id, title, platform, format, tags, notes })`
- **Create (script)**: `ScriptService/Create({ from_opportunity_id, ... })` → redirect to editor
- **Create (batch)**: `IdeaService/BulkCreate(suggestions.map(s => ({ ...s, from_opportunity_id })))` → redirect to board
- **Optimistic redirect**: Navigate immediately on success (no confirmation page)

---

## 12. Localization Notes

- Types: "💡 Tạo 1 ý tưởng", "📝 Viết script trực tiếp", "📦 Batch plan (nhiều ý tưởng)"
- Form: "Tiêu đề", "Nền tảng", "Định dạng", "Thẻ", "Ghi chú"
- AI context: "Dựa trên cơ hội: {analysis_summary}"
- Actions: "Hủy", "Tạo và mở →"
- Success: "✅ Đã tạo ý tưởng!", "✅ Đã tạo script!"

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-convert-idea` | Idea option card accent |
| `--color-convert-script` | Script option card accent |
| `--color-convert-batch` | Batch option card accent |
| `--color-step-active` | Active step indicator |
| `--color-step-inactive` | Inactive step indicator |
| `--color-accent` | Primary CTA button |
| `--color-surface-elevated` | Card backgrounds |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W044] Opportunity Detail | Parent |
| [W012] Idea Board | Target for single/batch ideas |
| [W016] Script Editor | Target for direct script |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (expired, batch limit), 5 errors, wizard a11y, 7 analytics, SvelteKit impl (pre-fill, batch create), 7 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
