# Screen Specs 03 — Content Creation (M05-M06, M08-M09)

> **Upstream**: Pack 01 §4, Product Freeze §12-14, A1 Schema (ideas, scripts, hooks, angles, assets, asset_briefs), Pack 04 (AI/Media)
> **Screens**: 12 web + 4 mobile screens

---

## 17. Idea Board

**Route**: `/ideas`
**Purpose**: Kanban/list view of content ideas. Ideas are the entry point for the content creation pipeline. Source: manual, AI-generated, or converted from opportunities/trends.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ✨ Ý tưởng           [+ Tạo mới] [🤖 AI Generate] [View ▦|☰]   │
├──────────────────────────────────────────────────────────────────┤
│ Filter: [Tất cả ▾] [Nguồn ▾] [Format ▾]    Sort: [Mới nhất ▾]  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Kanban Columns ───────────────────────────────────────────┐  │
│ │ Mới (12)           │ Đã chọn (4)     │ Đã chuyển (8)      │  │
│ │ ┌──────────────┐   │ ┌──────────────┐│ ┌──────────────┐   │  │
│ │ │ 💡 "Review    │   │ │ 💡 "5 tips   ││ │ 💡 "Unboxing │   │  │
│ │ │ serum mới"   │   │ │ nấu ăn"      ││ │ camera"      │   │  │
│ │ │              │   │ │              ││ │              │   │  │
│ │ │ 🤖 AI · Food │   │ │ 🔥 Trend     ││ │ ✍️ Manual    │   │  │
│ │ │ ⭐ 75/100     │   │ │ ⭐ 88/100     ││ │ → Script #42│   │  │
│ │ │ Short-form   │   │ │ Short-form   ││ │ Long-form   │   │  │
│ │ │              │   │ │              ││ │              │   │  │
│ │ │ [→ Script]   │   │ │ [→ Script]   ││ │ ✅ Completed │   │  │
│ │ │ [⋮]          │   │ │ [⋮]          ││ │              │   │  │
│ │ └──────────────┘   │ └──────────────┘│ └──────────────┘   │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### Idea Card
| Field | Source | Display |
|---|---|---|
| Title | `ideas.title` | Bold primary text |
| Score | `ideas.idea_score` | ⭐ color-coded badge |
| Source | `ideas.source_type` | Icon: 🤖 AI / 🔥 Trend / ✍️ Manual / 💡 Opportunity |
| Format | `ideas.format_type` | Chip: Short-form / Long-form / Livestream / Image |
| Category | `ideas.category` | Chip |
| Status | `ideas.status` | Kanban column placement |
| Converted to | `ideas.script_id` | Link "→ Script #42" if exists |
| Created | `ideas.created_at` | Relative time |

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Create idea (manual) | Click "+ Tạo mới" | — | → Create modal |
| AI generate | Click "🤖 AI Generate" | — | → `/ideas/generate` |
| Convert to script | Click "→ Script" | `ScriptService/Create(from_idea_id)` | → `/scripts/[new_id]` |
| Move status | Drag between columns | `IdeaService/Update(status)` | Card moves |
| Delete | ⋮ → "Xóa" → confirm | `IdeaService/Delete` | Card removed |
| Edit | Click card | — | → `/ideas/[id]` |
| Duplicate | ⋮ → "Nhân bản" | `IdeaService/Create(clone)` | New card in "Mới" |
| Bulk select | Checkbox mode | — | Bottom bar: Delete / Move / Convert |

### Create Idea Modal
```
┌─ Modal ────────────────────────────────────────────────────────┐
│ Tạo ý tưởng mới                                               │
│                                                                │
│ Tiêu đề: [_____________________________________________]       │
│ Mô tả:   [_____________________________________________]       │
│          [_____________________________________________]       │
│ Format:  ○ Short-form  ● Long-form  ○ Livestream  ○ Image      │
│ Nguồn:   [Thủ công ▾]  Từ trend: [chọn trend ▾] (optional)   │
│ Tags:    [cooking, recipe, ...] (tag input)                    │
│                                                                │
│ [Hủy]                                          [Tạo ✓]        │
└────────────────────────────────────────────────────────────────┘
```

### States
- **Loading**: 6 card skeletons in kanban
- **Empty**: "Chưa có ý tưởng nào! 💡" + "Tạo ý tưởng đầu tiên" CTA + "Để AI gợi ý" CTA + suggested recipe link
- **Error**: Toast + retry

---

## 18. Idea Generator (AI)

**Route**: `/ideas/generate`
**Purpose**: AI-powered batch idea generation. User provides context, AI generates 3-5 ideas with scores.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Ý tưởng    🤖 AI Idea Generator              [Credits: ~3]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Input Section ─────────────────────────────────────────────┐ │
│ │ Lĩnh vực: [Food & Cooking ▾]                                │ │
│ │ Nền tảng: [☑ TikTok] [☑ YouTube] [☐ Instagram]             │ │
│ │ Format:   [☑ Short-form] [☐ Long-form]                      │ │
│ │ Số ý tưởng: [5 ▾]                                           │ │
│ │ Gợi ý thêm: [Tập trung vào AI tools cho nấu ăn     ]       │ │
│ │                                                              │ │
│ │ ☑ Dựa trên xu hướng hiện tại                                │ │
│ │ ☑ Phân tích đối thủ                                         │ │
│ │                                                              │ │
│ │ [🤖 Tạo ý tưởng — 3 credits]                                │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Results (after generation) ────────────────────────────────┐ │
│ │                                                              │ │
│ │ ┌─ Generated Idea 1 ────────────────────────────────────┐   │ │
│ │ │ ☑ "5 AI tools giúp nấu ăn nhanh gấp đôi"            │   │ │
│ │ │ Score: ⭐ 85/100 · Format: Short-form · Platform: TT  │   │ │
│ │ │ Why: Xu hướng "AI cooking" +340%, ít đối thủ VN      │   │ │
│ │ │ Hook suggestion: "Bạn có biết AI giúp nấu phở..."    │   │ │
│ │ └───────────────────────────────────────────────────────┘   │ │
│ │                                                              │ │
│ │ ┌─ Generated Idea 2 ────────────────────────────────────┐   │ │
│ │ │ ☐ "Review top 3 app nấu ăn AI 2026"                  │   │ │
│ │ │ Score: ⭐ 72/100 · Format: Long-form · Platform: YT   │   │ │
│ │ │ ...                                                    │   │ │
│ │ └───────────────────────────────────────────────────────┘   │ │
│ │                                                              │ │
│ │ [Lưu 2 ý tưởng đã chọn] [🔄 Tạo lại]                      │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

### Behavior
- Click "Tạo ý tưởng" → streaming response from `CopilotService/Query(mode=idea_generation)`
- Ideas appear one by one with typing animation
- Each idea has checkbox for selection
- "Lưu" → batch `IdeaService/Create` for all selected
- "Tạo lại" → re-generates new set (costs credits again)
- Credit estimator updates based on number of ideas

### States
- **Generating**: Streaming animation, ideas appearing one by one
- **Generated**: All ideas shown with checkboxes
- **No credits**: "Hết credits. [Nạp thêm →]" with disabled button
- **AI Error**: "AI không phản hồi. [Thử lại] hoặc [Tạo thủ công →]"

---

## 19. Idea Detail

**Route**: `/ideas/[id]`
**Purpose**: Full detail of an idea with editing, related content, and conversion actions.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Ý tưởng   "5 tips nấu ăn nhanh"    [⭐ 88] [Status ▾] [⋮]   │
├──────────────────────────────────┬───────────────────────────────┤
│ Main (65%)                       │ Right Panel (35%)              │
│                                  │                                │
│ ┌─ Editable Fields ──────────┐  │ ┌─ Trust ────────────────────┐│
│ │ Title: [5 tips nấu ăn...] │  │ │ Source: AI Generated        ││
│ │ Description:               │  │ │ Confidence: High            ││
│ │ [Multi-line text editor]   │  │ │ Based on: Trend #xyz        ││
│ │                            │  │ │ [Why this score? ▾]         ││
│ │ Format: [Short-form ▾]    │  │ └─────────────────────────────┘│
│ │ Category: [Food ▾]        │  │                                │
│ │ Tags: [cooking, AI, tips]  │  │ ┌─ Related Objects ──────────┐│
│ └────────────────────────────┘  │ │ 🔥 Trend: AI cooking       ││
│                                  │ │ 📝 Script: 5 tips... (if)  ││
│ ┌─ AI Hook Suggestions ─────┐  │ │ 🔍 Opp: Product gap (if)   ││
│ │ 1. "Bạn có biết 90%..."   │  │ └─────────────────────────────┘│
│ │ 2. "Tôi đã thử và..."     │  │                                │
│ │ 3. "Sai lầm lớn nhất..."  │  │ ┌─ Actions ─────────────────┐ │
│ │ [🔄 Gợi ý thêm — 1 cr]   │  │ │ [📝 Chuyển thành Script]  │ │
│ └────────────────────────────┘  │ │ [📋 Nhân bản]              │ │
│                                  │ │ [🗑 Xóa]                  │ │
│ ┌─ Notes ────────────────────┐  │ └─────────────────────────────┘│
│ │ [Free-form notes area]     │  │                                │
│ └────────────────────────────┘  │ ┌─ Activity Log ─────────────┐│
│                                  │ │ Today: Score updated        ││
│ [Lưu thay đổi]                  │ │ Yesterday: Created by AI    ││
│                                  │ └─────────────────────────────┘│
└──────────────────────────────────┴───────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Save edits | Click "Lưu" / Ctrl+S | `IdeaService/Update` | Toast "Đã lưu" |
| Convert to script | Primary CTA | `ScriptService/Create(from_idea_id)` | → `/scripts/[new_id]` |
| Generate hooks | "Gợi ý thêm" | `CopilotService/Query(hook_suggestions)` | New hooks appear |
| Delete | "Xóa" → confirm | `IdeaService/Delete` | → `/ideas` |
| Duplicate | "Nhân bản" | `IdeaService/Create(clone)` | → `/ideas/[new_id]` |
| Change status | Status dropdown | `IdeaService/Update` | Status badge updates |

---

## 20. Script List

**Route**: `/scripts`
**Purpose**: All scripts in workspace — filterable by status, format, assignee.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 📝 Scripts         [+ Tạo mới]    [Filter ▾] [Sort: Mới nhất ▾] │
├──────────────────────────────────────────────────────────────────┤
│ Status tabs: [Tất cả (24)] [Draft (12)] [Đang duyệt (5)]       │
│              [Đã duyệt (4)] [Cần sửa (3)]                      │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Script Row ────────────────────────────────────────────────┐ │
│ │ 📝 "5 tips nấu ăn nhanh cho bận rộn"                       │ │
│ │ Short-form · Food · Draft · Cập nhật 2h trước              │ │
│ │ Từ ý tưởng: [💡 #23] · Người tạo: Quân                    │ │
│ │ Word count: 245 · Hook: ✅ · CTA: ✅                       │ │
│ │                                             [→ Mở Editor]  │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Script Row ────────────────────────────────────────────────┐ │
│ │ 📝 "Review serum Vitamin C chi tiết"                       │ │
│ │ Long-form · Beauty · Đang duyệt · 1 ngày trước             │ │
│ │ Assignee: Hoa · 🔴 Chờ duyệt từ Admin                      │ │
│ │                                   [→ Duyệt] [→ Mở Editor]  │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ [Tải thêm ↓]                                                    │
└──────────────────────────────────────────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Create new | "+ Tạo mới" | — | → `/scripts/new` (empty editor) |
| Open editor | Click row / "Mở Editor" | — | → `/scripts/[id]` |
| Quick review | "Duyệt" | — | → `/scripts/[id]/review` |
| Filter by status | Click status tab | Refetch with filter | List updates |
| Sort | Sort dropdown | Refetch | List reorders |
| Bulk select | Checkbox mode | — | Bottom bar: Delete / Assign / Move status |

---

## 21. Script Editor

**Route**: `/scripts/[id]`
**Purpose**: Rich text editor for scripts with AI assistance, section structure, platform preview, and collaboration features.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Scripts   "5 tips nấu ăn"  [Draft ▾] [💾 Saved 30s ago] [⋮]  │
├─────────────────────────────────┬────────────────────────────────┤
│ Editor (60%)                    │ Preview Panel (40%)             │
│                                 │                                 │
│ ┌─ Title ──────────────────┐   │ ┌─ Platform Tabs ─────────────┐│
│ │ [5 tips nấu ăn nhanh   ]│   │ │ [TikTok] [YouTube] [Reels]  ││
│ └───────────────────────────┘   │ └─────────────────────────────┘│
│                                 │                                 │
│ ┌─ Format Bar ─────────────┐   │ ┌─ Device Preview ────────────┐│
│ │ [B] [I] [H1] [H2] [•]   │   │ │ ┌─────────────────┐         ││
│ │ [🤖 AI] [Timer] [Notes]  │   │ │ │ 📱 iPhone Frame │         ││
│ └───────────────────────────┘   │ │ │                 │         ││
│                                 │ │ │ Hook: (3s)      │         ││
│ ┌─ Section: HOOK (0-3s) ───┐   │ │ │ "Bạn có biết    │         ││
│ │ ⏱ 0-3 giây               │   │ │ │  rằng 90%..."   │         ││
│ │                           │   │ │ │                 │         ││
│ │ "Bạn có biết rằng 90%    │   │ │ │ Body text       │         ││
│ │  người nấu ăn mắc sai   │   │ │ │ appears here    │         ││
│ │  lầm này?"               │   │ │ │                 │         ││
│ │                           │   │ │ │ CTA: "Follow   │         ││
│ │ [🤖 AI Suggest Hook]     │   │ │ │  để xem p2"     │         ││
│ └───────────────────────────┘   │ │ └─────────────────┘         ││
│                                 │ │                              ││
│ ┌─ Section: BODY ───────────┐   │ │ ⚠️ Vượt 300 ký tự (TT)    ││
│ │ ⏱ 3-25 giây              │   │ │ ✅ Phù hợp YouTube          ││
│ │                           │   │ └──────────────────────────────┘│
│ │ Tip 1: Sử dụng nồi áp   │   │                                 │
│ │ suất cho thời gian nấu   │   │ ┌─ Script Stats ──────────────┐│
│ │ nhanh hơn 40%            │   │ │ Words: 245 / 300 max (TT)   ││
│ │                           │   │ │ Est. duration: 45s           ││
│ │ Tip 2: Chuẩn bị nguyên   │   │ │ Reading speed: slow/normal   ││
│ │ liệu theo batch...       │   │ │ Sections: 3/3 complete       ││
│ │                           │   │ │ Hook: ✅ Has hook             ││
│ │ [🤖 AI Expand Section]   │   │ │ CTA: ✅ Has CTA              ││
│ └───────────────────────────┘   │ └──────────────────────────────┘│
│                                 │                                 │
│ ┌─ Section: CTA (last 3-5s) ┐  │ ┌─ AI Copilot ───────────────┐│
│ │ ⏱ 25-30 giây              │  │ │ 💬 "You can ask me to:     ││
│ │                            │  │ │  - Generate hooks            ││
│ │ "Follow để xem phần 2    │  │ │  - Expand this section       ││
│ │  với 5 tips nâng cao!"   │  │ │  - Suggest CTAs              ││
│ │                            │  │ │  - Translate to English"     ││
│ │ [🤖 AI Suggest CTA]      │  │ │                              ││
│ └────────────────────────────┘  │ │ [Ask Copilot...        💬]  ││
│                                 │ └──────────────────────────────┘│
│ ┌─ Action Bar ──────────────┐  │                                 │
│ │ [Lưu] [Gửi duyệt]       │  │                                 │
│ │ [Tạo Brief sản xuất →]   │  │                                 │
│ └────────────────────────────┘  │                                 │
└─────────────────────────────────┴────────────────────────────────┘
```

### Components Detail

#### 21.1 Rich Text Editor (TipTap)
- Structured sections: HOOK → BODY → CTA (enforced structure for short-form)
- Section timestamps (estimated / user-set)
- Per-section AI assist button → opens Copilot sidebar with section context
- Auto-save every 30 seconds
- Undo/redo (Ctrl+Z / Ctrl+Shift+Z)
- Character/word count per section with platform limit warnings
- Inline comments (for team review)

#### 21.2 Platform Preview Panel
- Tab for each connected platform
- Mock device frame showing formatted content
- Character limit indicators (TikTok: 300, YouTube desc: 5000, etc.)
- ⚠️ Warning if content exceeds platform limits
- Live-updates as user types

#### 21.3 Copilot Integration
- Per-section "🤖 AI Suggest" → CopilotService/Query(mode=script_assist, section=hook|body|cta)
- Streaming response appears inline below section
- User can: Accept (inserts text) / Reject / Regenerate
- Full copilot panel in right sidebar: free-text chat about this script

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Save | Ctrl+S / auto-30s / "Lưu" | `ScriptService/Update` | Toast "Đã lưu" |
| Submit for review | "Gửi duyệt" | `ScriptService/SubmitApproval` | Status → "Đang duyệt" + notification to admin |
| AI suggest section | "🤖 AI Suggest" | `CopilotService/Query` (streaming) | Text appears below section |
| Accept AI suggestion | "✅ Chấp nhận" on suggestion | — (client insert) | Text inserted into editor |
| Create asset brief | "Tạo Brief sản xuất" | `AssetBriefService/Create(script_id)` | → `/scripts/[id]/brief` |
| Delete | ⋮ → "Xóa" → confirm | `ScriptService/Delete` | → `/scripts` |
| Duplicate | ⋮ → "Nhân bản" | `ScriptService/Create(clone)` | → `/scripts/[new_id]` |
| Change status | Status dropdown (admin) | `ScriptService/Update` | Status badge updates |
| Platform preview switch | Click platform tab | — (client) | Preview re-renders |

### States
- **Loading**: Editor skeleton + preview skeleton
- **Empty (new)**: Template selector modal → choose format → pre-filled structure
- **Dirty**: Unsaved indicator "●" + browser leave warning
- **Saving**: "💾 Saving..." in topbar
- **Review mode**: Editor read-only for reviewer, approve/reject buttons visible
- **AI generating**: Skeleton text + "generating..." below section
- **Offline**: "Offline — changes saved locally" banner

---

## 22. Script Approval Review

**Route**: `/scripts/[id]/review`
**Purpose**: Review interface for approvers — read-only script view with approve/reject/comment actions.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Scripts   Duyệt: "5 tips nấu ăn"            [🔴 Đang chờ]    │
├──────────────────────────────────┬───────────────────────────────┤
│ Script Content (read-only, 65%) │ Review Panel (35%)             │
│                                  │                                │
│ ┌─ Script sections ──────────┐  │ ┌─ Review Actions ────────────┐│
│ │ Full script rendered with  │  │ │ [✅ Duyệt]                  ││
│ │ section markers, platform  │  │ │ [📝 Yêu cầu chỉnh sửa]    ││
│ │ preview on hover           │  │ │ [❌ Từ chối]                ││
│ │                            │  │ └─────────────────────────────┘│
│ │ Click word → add comment   │  │                                │
│ │ Highlight → add annotation │  │ ┌─ Comment Thread ────────────┐│
│ └────────────────────────────┘  │ │ Minh: "Hook quá dài, cân    ││
│                                  │ │ nhắc rút ngắn xuống 2s"    ││
│                                  │ │ ---                         ││
│                                  │ │ Quân: "Đã sửa, hook giờ    ││
│                                  │ │ chỉ còn 1.5s"              ││
│                                  │ │                             ││
│                                  │ │ [Thêm comment...]           ││
│                                  │ └─────────────────────────────┘│
│                                  │                                │
│                                  │ ┌─ Script Info ──────────────┐ │
│                                  │ │ Author: Quân               │ │
│                                  │ │ Created: 2d ago            │ │
│                                  │ │ From idea: #23             │ │
│                                  │ │ Format: Short-form         │ │
│                                  │ │ Words: 245                 │ │
│                                  │ └─────────────────────────────┘│
└──────────────────────────────────┴───────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Approve | "✅ Duyệt" | `ApprovalService/Approve(approval_request_id)` | Status → Approved, notification to author |
| Request changes | "📝 Yêu cầu chỉnh sửa" | `ApprovalService/RequestChanges(comment)` | Status → Needs Revision, notification |
| Reject | "❌ Từ chối" → reason modal | `ApprovalService/Reject(reason)` | Status → Rejected, notification |
| Add comment | Click text → type | `CommentService/Create(script_id, position)` | Comment appears in thread |

---

## 23. Asset Brief Editor

**Route**: `/scripts/[id]/brief`
**Purpose**: Production brief for the video/media team — shot list, style notes, requirements.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Script   Brief sản xuất: "5 tips nấu ăn"           [💾 Lưu]  │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Shot List ─────────────────────────────────────────────────┐ │
│ │ # │ Scene      │ Duration │ Visual Description  │ Audio    │ │
│ │ 1 │ Hook       │ 3s       │ Close-up food shot  │ Music +  │ │
│ │   │            │          │ with text overlay    │ VO start │ │
│ │ 2 │ Tip 1      │ 6s       │ Cooking demo, fast  │ VO cont  │ │
│ │   │            │          │ cuts                 │          │ │
│ │ 3 │ Tip 2      │ 6s       │ Before/after        │ VO cont  │ │
│ │ + │ [Thêm scene]                                            │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Style Notes ───────────────────────────────────────────────┐ │
│ │ Lighting:    [Tự nhiên ▾]                                   │ │
│ │ Color grade: [Warm / Bright ▾]                              │ │
│ │ Pace:        [○ Slow  ● Fast  ○ Mixed]                      │ │
│ │ Music mood:  [Upbeat / Energetic ▾]                         │ │
│ │ Text style:  [Bouncing captions ▾]                          │ │
│ │ Reference:   [📎 Upload] [🔗 Paste URL]                    │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Requirements ──────────────────────────────────────────────┐ │
│ │ ☑ Must include product close-up                             │ │
│ │ ☑ Text overlays for each tip                                │ │
│ │ ☑ CTA end screen                                            │ │
│ │ ☐ Subtitles (auto-generated)                                │ │
│ │ [+ Thêm yêu cầu]                                           │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ [Lưu brief] [🤖 AI Fill from Script — 2cr] [→ Tạo video AI]   │
└──────────────────────────────────────────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Save | "Lưu" / Ctrl+S | `AssetBriefService/Update` | Toast "Đã lưu" |
| AI auto-fill | "AI Fill" | `CopilotService/Query(brief_from_script)` | Fields populated |
| Add scene | "+ Thêm scene" | — (client) | New row in shot list |
| Remove scene | ⋮ on row → "Xóa" | — (client) | Row removed |
| Reorder scenes | Drag handle | — (client) | Row moves |
| Generate video | "Tạo video AI" | — | → `/studio?brief_id=[id]` |
| Upload reference | "📎 Upload" | Upload to R2 | Thumbnail preview |

---

## 27. Continuity Packs

**Route**: `/continuity`
**Purpose**: Manage character packs, brand packs, and voice packs for consistent AI-generated content.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🧬 Continuity                                       [+ Tạo mới] │
├──────────────────────────────────────────────────────────────────┤
│ Tabs: [🎭 Characters (3)] [🎨 Brand Packs (2)] [🎤 Voices (1)] │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Character Card ────────────────────────────────────────────┐ │
│ │ [Avatar] Mila                              [Default ⭐]     │ │
│ │ Style: Friendly, energetic · Vietnamese + English           │ │
│ │ Used in: 12 scripts, 8 videos                               │ │
│ │ Voice: ElevenLabs - Custom clone                            │ │
│ │ [✏️ Edit] [📋 Duplicate] [→ Use in Studio]                  │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ┌─ Character Card ────────────────────────────────────────────┐ │
│ │ [Avatar] Chef Hùng                                          │ │
│ │ Style: Expert, calm · Vietnamese only                       │ │
│ │ Used in: 5 scripts, 3 videos                                │ │
│ │ [✏️ Edit] [📋 Duplicate] [→ Use in Studio]                  │ │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

### Sub-tabs

**Characters**: Personality, speaking style, visual appearance, voice settings
**Brand Packs**: Colors, fonts, logo, tagline, visual style, brand guidelines
**Voice Packs**: Uploaded samples, ElevenLabs voice IDs, language(s)

### Create Character Modal
```
┌─ Full Page: Tạo Character ─────────────────────────────────────┐
│ Tabs: [Personality] [Visual] [Voice] [Preview]                  │
│                                                                  │
│ ── Personality ──                                                │
│ Name: [Mila                     ]                                │
│ Role: [Content creator, food lover]                              │
│ Tone: [Friendly ▾] [Energetic ▾] [Casual ▾]                    │
│ Languages: [☑ Vietnamese] [☑ English]                           │
│ Speaking speed: [○ Slow  ● Normal  ○ Fast]                      │
│ Catchphrases: [tag input]                                        │
│                                                                  │
│ ── Visual (tab 2) ──                                             │
│ Avatar: [📎 Upload] or [🤖 Generate — 5cr]                     │
│ Style: [Anime ▾] / [Realistic ▾] / [Cartoon ▾]                 │
│                                                                  │
│ ── Voice (tab 3) ──                                              │
│ Source: ○ ElevenLabs preset  ● Custom clone                     │
│ Sample: [📎 Upload 30s-5min audio]                              │
│ Consent: ☑ I confirm this voice is mine or I have permission    │
│                                                                  │
│ [Hủy]                                          [Lưu Character]  │
└──────────────────────────────────────────────────────────────────┘
```

---

## 28. Derivative Manager

**Route**: `/derivatives`
**Purpose**: Manage content derivatives — repurposed/remixed versions of original content for different platforms.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 📦 Derivatives                         [Filter: Source ▾]        │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Source Group: "5 tips nấu ăn" ─────────────────────────────┐ │
│ │ Original: 📹 TikTok video (60s) · Published 3d ago          │ │
│ │                                                              │ │
│ │ Derivatives:                                                 │ │
│ │ ├── 📹 YouTube Shorts (60s) · [Published] · [📊 Stats]     │ │
│ │ ├── 📹 Instagram Reel (30s) · [Draft] · [✏️ Edit] [📤 Pub] │ │
│ │ ├── 📸 Thumbnail set (3 variants) · [Generated]             │ │
│ │ └── 📝 Blog post (AI-written) · [Draft] · [✏️ Edit]        │ │
│ │                                                              │ │
│ │ [+ Tạo derivative mới]                                      │ │
│ └──────────────────────────────────────────────────────────────┘ │
│                                                                  │
│ ... more source groups ...                                       │
└──────────────────────────────────────────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Create derivative | "+ Tạo" → choose type | Modal: select platform + format | → respective editor |
| Edit derivative | "✏️ Edit" | — | → editor for that content type |
| Publish derivative | "📤 Pub" | — | → publish flow for this item |
| View stats | "📊 Stats" | — | → analytics for published derivative |
| Delete | ⋮ → "Xóa" | `DerivativeService/Delete` | Item removed |

---

## Mobile Screens

### M17. Mobile Idea Board

**Route**: `/ideas` (mobile)
**Purpose**: Vertical card list of ideas with swipe actions and FAB creation.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Ý tưởng                                   [🔍] [Sort ▾]      │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Filter: [All] [Draft] [Ready] [In Script] [Published]            │
│                                                                  │
│ ┌─ Idea Card ────────────────────────────────────────────────┐  │
│ │ 💡 "5 tips chăm sóc da mùa hè"          [🟢 Ready]       │  │
│ │ Score: 82 · TikTok · Created 2h ago                        │  │
│ │ Tags: skincare, summer, tips                                │  │
│ │ ← Swipe R: [📝 → Script] · Swipe L: [🗑 Xóa]            │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Idea Card ────────────────────────────────────────────────┐  │
│ │ 💡 "Review serum retinol dưới 200K"      [🟡 Draft]       │  │
│ │ Score: 78 · YouTube · Created 1d ago                       │  │
│ │ Tags: skincare, budget, review                              │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Pull-to-refresh · Long press → multi-select                      │
│                                                                  │
│                                              [+ Tạo ý tưởng] ⊕  │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M17 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View detail | Tap card | — | → M18 Idea Detail |
| Convert to script | Swipe right | `ScriptService/CreateFromIdea` | Script created, toast |
| Delete | Swipe left → confirm | `IdeaService/Delete` | Card removed |
| Create idea | FAB "+" | — | → Create bottom sheet (title + platform + tags) |
| Multi-select | Long press | — | Selection mode: batch delete/move |
| Filter | Tap chip | — | List filtered by status |

---

### M18. Mobile Idea Detail

**Route**: `/ideas/[id]` (mobile)
**Purpose**: View and edit a single idea with AI suggestions.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Ý tưởng   💡 5 tips chăm sóc da mùa hè         [✏️ Edit]    │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Status + Meta ────────────────────────────────────────────┐  │
│ │ Status: [🟢 Ready ▾]  · Platform: [TikTok ▾]              │  │
│ │ Score: 82/100 · Created: 2h ago · Updated: 30 min ago      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Content ──────────────────────────────────────────────────┐  │
│ │ Title: 5 tips chăm sóc da mùa hè                          │  │
│ │ Outline:                                                    │  │
│ │ 1. Dùng SPF 50+ mỗi ngày                                  │  │
│ │ 2. Double cleansing buổi tối                                │  │
│ │ 3. Serum Vitamin C buổi sáng                               │  │
│ │ 4. Mặt nạ đất sét 2 lần/tuần                              │  │
│ │ 5. Uống đủ nước                                            │  │
│ │ [Tap to edit ✏️]                                            │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ AI Hook Suggestions (expandable) ─── [▾] ─────────────────┐  │
│ │ Hook 1: "POV: Da bạn sau 1 tuần làm theo 5 bước này"      │  │
│ │ Hook 2: "Chuyên gia da liễu sốc khi thấy routine này"     │  │
│ │ [📋 Copy] [✏️ Edit] [🔄 Refresh]                          │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Tags: [skincare ×] [summer ×] [tips ×] [+ Add]                  │
│                                                                  │
│ ┌─ Sticky Bottom Bar ────────────────────────────────────────┐  │
│ │ [📝 → Script] [📤 Share] [🗑 Xóa]                        │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

#### M18 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Edit field | Tap field | — | Modal editor for that field |
| Change status | Status dropdown | `IdeaService/Update` | Status updated |
| Convert to script | "→ Script" | `ScriptService/CreateFromIdea` | → Script editor |
| Refresh AI hooks | "Refresh" | `AIService/GenerateHooks` | New hooks generated |
| Delete | "Xóa" → confirm | `IdeaService/Delete` | → Back to M17 |

---

### M19. Mobile Script List

**Route**: `/scripts` (mobile)
**Purpose**: Browse scripts with status badges and quick navigation.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Scripts                                    [🔍] [+ Tạo mới]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Tabs: [All] [Draft] [Review] [Approved] [Published]              │
│                                                                  │
│ ┌─ Script Row ───────────────────────────────────────────────┐  │
│ │ 📝 "5 tips skincare mùa hè"    [🟡 Draft]    · 2h ago    │  │
│ │    TikTok · 450 words · Last edit: 30 min ago              │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Script Row ───────────────────────────────────────────────┐  │
│ │ 📝 "Serum retinol review"      [🟢 Approved]  · 1d ago   │  │
│ │    YouTube · 1200 words · Ready to publish                 │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Script Row ───────────────────────────────────────────────┐  │
│ │ 📝 "Unboxing haul tháng 3"     [🔵 Review]    · 3d ago   │  │
│ │    TikTok · 300 words · Awaiting review                    │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Pull-to-refresh · Infinite scroll                                │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M19 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Open script | Tap row | — | → M20 Script Editor |
| Create | "+ Tạo mới" | — | → M20 with blank script |
| Filter | Tap tab | — | List filtered by status |
| Pull-to-refresh | Pull down | `ScriptService/List` | List refreshed |

---

### M20. Mobile Script Editor (Simplified)

**Route**: `/scripts/[id]/edit` (mobile)
**Purpose**: Simplified single-panel script editor with AI assist and platform preview.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Script   "5 tips skincare"             [🟡 Draft] [💾 Auto]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Section tabs: [Hook] [Body] [CTA] [Hashtags] [Notes]             │
│                                                                  │
│ ── Hook Section ──                                               │
│ ┌─ Editor (full-width) ─────────────────────────────────────┐   │
│ │ "POV: Da bạn sau 1 tuần làm theo 5 bước đơn giản này     │   │
│ │  mà không cần đi spa!"                                     │   │
│ │                                                            │   │
│ │ Word count: 25 / 50 recommended                            │   │
│ │ ⚠ "Hook nên dưới 15 từ cho TikTok"                        │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ ── Body Section ──                                               │
│ ┌─ Editor ──────────────────────────────────────────────────┐   │
│ │ "Tip 1: Dùng SPF 50+ mỗi ngày..."                        │   │
│ │ "Tip 2: Double cleansing buổi tối..."                      │   │
│ │ (full text scrollable)                                     │   │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ [🤖 AI Assist]  ← floating button → bottom sheet:               │
│   "Viết lại ngắn hơn" / "Thêm hook" / "Sửa ngữ pháp"          │
│                                                                  │
│ [📱 Preview] ← slide-up sheet: platform preview                  │
│                                                                  │
│ ┌─ Sticky Bottom Bar ────────────────────────────────────────┐  │
│ │ [📤 Gửi duyệt]                                            │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

#### M20 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Edit text | Tap section | — (in-place) | Text editable, auto-save |
| Switch section | Tap tab | — | Section content swaps |
| AI assist | "🤖" floating button | — | Bottom sheet with AI options |
| AI rewrite | Select AI option | `AIService/RewriteScript` | Text replaced with suggestion |
| Platform preview | "📱 Preview" | — | Slide-up platform mockup |
| Submit review | "Gửi duyệt" | `ScriptService/SubmitForReview` | Status → Review |

