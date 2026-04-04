# Screen: Web — Script Editor

> **Screen ID**: W016
> **Module**: M06 — Script Lab
> **Route**: `/scripts/[id]`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §13, A1 Schema (scripts, script_sections, script_reviews, script_versions), B5 RBAC §2.7

---
## 1. Purpose & Context

The Script Editor is the primary content writing workspace — a structured, AI-augmented editor with section-based composition (Hook, Body, CTA), real-time brand voice enforcement, platform-specific guidelines, version history, and a review/approval workflow. Scripts link to ideas upstream and asset briefs downstream, forming the content pipeline backbone.

### User Goals
- Write scripts with AI assistance that matches brand voice and platform best practices
- Structure content with proven section templates (Hook, Body, CTA) for each platform
- Get real-time platform-specific feedback (length, hook duration, CTA clarity)
- Send scripts for team review and track approval workflow
- Link scripts to asset briefs and production pipeline

### Business Goals
- Increase script quality through AI-assisted writing and brand voice enforcement
- Reduce script revision cycles (target: <2 revision rounds)
- Standardize content structure across team members
- Enable content pipeline tracking (idea → script → asset → publish)
- Reduce time-to-publish through structured templates

### When This Screen Is Used
- **Writing session**: Dedicated time to write/refine a script (primary usage)
- **Review cycle**: Author responds to reviewer feedback
- **Reference**: Team member reads an approved script before production
- **Revision**: Editing after publishing to improve performance

### Entry Points
- Script List (W020): click script → edit
- Idea Board (W017): "📝 Viết script" on idea card → creates script linked to idea
- Direct URL: `/scripts/[id]`
- Notification: "📝 Script cần review" → opens in review mode
- Search: global search results → script

### Exit Points
- "📋 Asset brief" → `/scripts/[id]/brief` (Asset Brief W023)
- "📤 Gửi review" → stays on page, status changes, notification sent
- "← Scripts" → `/scripts` (Script List W020)
- "👁 Preview" → modal preview
- "📤 Publish" → Publish Queue (if approved)

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `script:read` permission for view, `script:edit` for edit
- Script exists with valid `script_id`
- Active workspace selected

### Postconditions
- Auto-save: changes persisted every 2s (debounced)
- Version created: new version snapshot on significant milestones (manual save, status change)
- Review submission: status → "in_review", notification sent to reviewers
- Brand voice check results cached per section

---
## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + Split view: Editor 60% + Side Panel 40% |
| Tablet (768-1279px) | App Shell + Editor full-width. Side panel as toggleable slide-over. |
| Mobile (≤767px) | Redirect to M020 Mobile Script Editor |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Scripts  📝 "5 tips nấu ăn"      [💾 Saved] [Status: Draft ▾] [⋮]│
├──────────────────────────────────┬───────────────────────────────────┤
│ Editor (60%)                     │ Side Panel (40%)                   │
│                                  │                                    │
│ ┌─ Script Metadata ──────────┐  │ Tabs: [🤖 AI] [📋 Brief] [📊 Info]│
│ │ Title: [5 tips nấu ăn nha ]│  │                                    │
│ │ Platform: [🎵 TikTok ▾]    │  │ ── AI Assistant Tab ──            │
│ │ Format: [Short-form ▾]     │  │ ┌─ AI Chat ────────────────────┐ │
│ │ Duration: [30-60s ▾]       │  │ │ 🤖 "Script assistant ready." │ │
│ │ From idea: [→ #42 ⭐85]    │  │ │                                │ │
│ │ Brand voice: [→ My Voice]   │  │ │ You: "Viết hook cho video    │ │
│ └────────────────────────────┘  │ │   skincare buổi sáng"         │ │
│                                  │ │                                │ │
│ ┌─ Section: HOOK ──────────┐   │ │ 🤖 AI: "Đây là 3 hook gợi   │ │
│ │ 🎣 Hook (0-5s)           │   │ │   ý cho video skincare:      │ │
│ │ [📝 Rich text editor:     │   │ │   1. 'Bạn có đang mắc...'   │ │
│ │  "Bạn có đang mắc 5 sai  │   │ │   2. 'Glass skin chỉ với...'│ │
│ │   lầm skincare mỗi sáng  │   │ │   3. 'POV: Da bạn sau...'   │ │
│ │   không?"                  │   │ │                                │ │
│ │  Word count: 12/20        │   │ │ [📥 Insert #1] [📥 Insert #2]│ │
│ │  🟢 Hook length: Good     │   │ │ [📥 Insert #3]               │ │
│ │  🟢 Brand voice: Match    │]  │ │                                │ │
│ │ [🤖 AI Suggest hook]      │   │ │ [Type message...      ] [Send]│ │
│ └────────────────────────────┘  │ └──────────────────────────────┘ │
│                                  │                                    │
│ ┌─ Section: BODY ──────────┐   │ ── Brief Tab (Asset Brief) ──     │
│ │ 📖 Body (5-50s)          │   │ ┌─ Visual Notes ────────────────┐│
│ │ [📝 Rich text editor:     │   │ │ Shot 1: Close-up skincare     ││
│ │  "Tip 1: Không rửa mặt   │   │ │ Shot 2: Before/after split    ││
│ │   bằng nước nóng.          │   │ │ Shot 3: Product placement     ││
│ │                            │   │ │ Music: Chill lo-fi             ││
│ │   Tip 2: Thứ tự apply..."]│   │ │ [→ Full brief ✏️]            ││
│ │                            │   │ └──────────────────────────────┘│
│ │  Word count: 89/150       │   │                                    │
│ │  🟡 Hơi dài cho TikTok   │   │ ── Info Tab ──                     │
│ │  🟢 Brand voice: Match    │   │ ┌─ Script Info ────────────────┐│
│ │ [🤖 AI Shorten] [📋 Paste]│   │ │ Created: 26/3 · by Quân      ││
│ └────────────────────────────┘  │ │ Last edit: 2h ago             ││
│                                  │ │ Word count: 134               ││
│ ┌─ Section: CTA ───────────┐   │ │ Est. duration: 52s            ││
│ │ 🎯 CTA (last 5-10s)      │   │ │                                ││
│ │ [📝 Rich text:             │   │ │ Platform guidelines:          ││
│ │  "Follow để xem thêm      │   │ │ ✅ Hook < 5s                  ││
│ │   tips mỗi ngày!"]        │   │ │ ✅ CTA clear                 ││
│ │  Word: 8/30 · 🟢 Good    │   │ │ 🟡 Body hơi dài (89 words)  ││
│ └────────────────────────────┘  │ │ ✅ Hashtags ready             ││
│                                  │ │ 🟢 Brand voice: Match        ││
│ [+ Add section]                  │ └──────────────────────────────┘│
│                                  │                                    │
│ ├─ Inline Review Comments ──┤  │ ┌─ Version History ────────────┐│
│ │ 💬 Reviewer A (1h ago):   │  │ │ ▸ v3 (current) · 2h ago      ││
│ │ "Hook quá dài, nên < 15   │  │ │   v2 · 1d ago · [View] [Restore]│
│ │  words" [✅ Resolved]      │  │ │   v1 · 2d ago · [View]        ││
│ └────────────────────────────┘  │ └──────────────────────────────┘│
│                                  │                                    │
│ ├─ Bottom Actions ──────────┤  │ ┌─ Review Status ───────────────┐│
│ │ [📤 Gửi review] [📋 Asset │  │ │ Reviewer: Lan · Status: Pending│
│ │  brief] [👁 Preview]      │  │ │ Due: 28/3 · [→ Review thread] ││
│ └────────────────────────────┘  │ └──────────────────────────────┘│
└──────────────────────────────────┴───────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
ScriptEditorPage
├── AppShell (shared)
├── PageHeader
│   ├── BackButton ("← Scripts" → W020)
│   ├── ScriptTitle (editable inline — click to edit)
│   ├── SaveStatus ("💾 Saved ✓" / "💾 Saving..." / "❌ Save failed")
│   ├── StatusDropdown (Draft / In Review / Approved / Archived)
│   └── MoreMenu ("⋮")
│       ├── DuplicateScript
│       ├── ExportScript (PDF / TXT / Google Docs)
│       ├── ShareLink (view-only link)
│       ├── MoveToArchive
│       └── DeleteScript (→ confirmation)
├── SplitView (resizable)
│   ├── EditorPanel (60%, scrollable)
│   │   ├── MetadataSection
│   │   │   ├── TitleInput (editable)
│   │   │   ├── PlatformSelector (TikTok / IG Reels / YouTube / Multi)
│   │   │   ├── FormatSelector (Short-form / Long-form / Story / Live)
│   │   │   ├── DurationSelector (15-30s / 30-60s / 1-3min / 3-10min / 10min+)
│   │   │   ├── LinkedIdeaBadge (clickable → idea detail)
│   │   │   └── BrandVoiceIndicator (→ linked brand voice profile)
│   │   ├── SectionList (sortable via drag handle)
│   │   │   └── ScriptSection[] (collapsible, reorderable)
│   │   │       ├── SectionHeader
│   │   │       │   ├── DragHandle (⋮⋮ for reorder)
│   │   │       │   ├── SectionIcon (🎣/📖/🎯/🎬/📊)
│   │   │       │   ├── SectionLabel ("Hook (0-5s)")
│   │   │       │   ├── CollapseToggle
│   │   │       │   └── SectionMenu (rename, delete, duplicate)
│   │   │       ├── RichTextEditor (ProseMirror-based)
│   │   │       │   ├── MiniToolbar (bold, italic, highlight, strikethrough, bullet list, comment)
│   │   │       │   └── EditorContent
│   │   │       ├── SectionFooter
│   │   │       │   ├── WordCounter ("12/20 words" — color-coded)
│   │   │       │   ├── PlatformGuidanceChip (🟢/🟡/🔴 with tooltip)
│   │   │       │   └── BrandVoiceChip (🟢/🟡/🔴 with tooltip)
│   │   │       └── AISuggestButton ("🤖 AI Suggest" — context-aware per section type)
│   │   ├── AddSectionButton ("+ Add section" → section type picker)
│   │   ├── InlineReviewComments (conditional — shown in review mode)
│   │   │   └── ReviewComment[]
│   │   │       ├── ReviewerAvatar + Name + Time
│   │   │       ├── CommentText
│   │   │       ├── HighlightedText (linked text in editor)
│   │   │       └── ResolveButton ("[✅ Resolved]")
│   │   └── BottomActions
│   │       ├── SendReviewButton ("📤 Gửi review")
│   │       ├── AssetBriefButton ("📋 Asset brief")
│   │       └── PreviewButton ("👁 Preview")
│   └── SidePanel (40%, tabbed)
│       ├── TabBar ([🤖 AI] [📋 Brief] [📊 Info])
│       ├── AIAssistantTab
│       │   ├── ChatHistory (scrollable)
│       │   │   └── ChatMessage[] (user messages + AI responses)
│       │   ├── AIInsertButtons (per suggestion: "[📥 Insert #1]")
│       │   └── ChatInput (text input + send button)
│       ├── BriefTab
│       │   ├── VisualNotesList (shot descriptions, music, props)
│       │   └── FullBriefLink ("→ Full brief ✏️" → W023)
│       └── InfoTab
│           ├── ScriptInfo (created, last edit, word count, est. duration)
│           ├── PlatformGuidelinesChecklist (✅/🟡/🔴 per check)
│           ├── BrandVoiceScore (overall match percentage)
│           ├── VersionHistory
│           │   └── VersionItem[] (view/restore per version)
│           └── ReviewStatus (reviewer, status, due date, thread link)
```

---
## 5. Displayed Data

| Element | Source | API | Display Format | Cache |
|---|---|---|---|---|
| Title | `scripts.title` | `ScriptService/Get(id)` | Editable inline | Auto-save |
| Sections | `script_sections ORDER BY position` | same | Rich text editors | Auto-save |
| Section content | `script_sections.content` (ProseMirror JSON) | same | Rich text | Auto-save |
| Platform | `scripts.target_platform` | same | Platform icon + name | — |
| Format | `scripts.format` | same | Dropdown label | — |
| Duration estimate | Computed: `total_word_count × platform_speed_factor` | Client-side | "52s" | — |
| Word count | Computed from content per section | Client-side | "12/20" (color: green<max, yellow near, red>max) | — |
| Platform guidelines | Static rules per platform + word counts | Client-side | Checklist (✅/🟡/🔴) | — |
| Brand voice score | `CopilotService/CheckBrandVoice(sections)` | On-demand (debounced on blur) | "🟢 Match" or "🟡 Partially" or "🔴 Mismatch" | Per check |
| AI chat history | Session-scoped (not persisted) | `CopilotService/Chat(mode=script_assist)` | Chat bubbles | Session |
| Asset brief | `script_briefs` linked | `ScriptService/GetBrief(script_id)` | Brief notes | 5m |
| Version history | `script_versions` | `ScriptService/ListVersions(id)` | List with timestamps | 5m |
| Review comments | `script_reviews.comments` | `ScriptService/GetReview(id)` | Inline comments | Real-time |
| Linked idea | `ideas WHERE id = scripts.idea_id` | Join | Badge: "#42 ⭐85" | 10m |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | Edit section text | Type in editor | Edit | Auto-save (2s debounce) → `ScriptService/UpdateSection` | "💾 Saved ✓" flash. Word count updates live. Platform checks update. | `script:edit` |
| 2 | AI suggest (section) | "🤖 AI Suggest" per section | AI | `CopilotService/Query(mode=script_{section_type}, context)` | Suggestions appear in AI chat tab. Insert buttons available. | `copilot:use_help` |
| 3 | AI chat | Type + send in chat panel | AI | `CopilotService/Chat(context=script_sections)` | AI response streams in chat. Insert buttons for code snippets. | `copilot:use_help` |
| 4 | Insert AI text | "📥 Insert #N" | Insert | Client-side | Text inserted at cursor position in active section. Highlighted briefly. | `script:edit` |
| 5 | AI shorten body | "🤖 AI Shorten" | AI | `CopilotService/Query(mode=shorten, text)` | Shortened version appears in chat. Insert to replace. | `copilot:use_help` |
| 6 | Brand voice check | Section blur (auto) or manual | AI | `CopilotService/CheckBrandVoice(sections)` | Per-section + overall score badge. Suggestions if mismatch. | `copilot:use_help` |
| 7 | Send for review | "📤 Gửi review" | Status | `ScriptService/SubmitReview(id, reviewer_ids)` | Reviewer picker dialog → Status → "In Review". Notification sent. Editor becomes read-only for non-reviewers. | `script:edit` |
| 8 | Add review comment | Click text → add comment | Comment | `ScriptService/AddComment(section_id, text_range, comment)` | Comment appears inline with highlighted text reference. | `script:approve` |
| 9 | Resolve comment | "✅ Resolved" on comment | Status | `ScriptService/ResolveComment(comment_id)` | Comment fades. Counter updates. | `script:edit` |
| 10 | Approve script | "✅ Approve" (reviewer) | Status | `ScriptService/Approve(id)` | Status → "Approved". Green banner. Author notified. | `script:approve` |
| 11 | Request changes | "🔄 Cần sửa" (reviewer) | Status | `ScriptService/RequestChanges(id, comments)` | Status → "Changes Requested". Author notified. Editor re-enabled. | `script:approve` |
| 12 | Add section | "+ Add section" → type picker | Create | `ScriptService/AddSection(type, position)` | Section type picker: [🎣 Hook] [📖 Body] [🎯 CTA] [🎬 Visual] [📊 Data] [📝 Custom] | `script:edit` |
| 13 | Reorder sections | Drag section handle | Reorder | `ScriptService/ReorderSections(positions)` | Sections reorder with smooth animation. | `script:edit` |
| 14 | Delete section | Section menu → "Xóa" → confirm | Delete | `ScriptService/DeleteSection(section_id)` | Section removes. Undo toast (5s). | `script:edit` |
| 15 | Force save | Cmd+S keyboard shortcut | Save | `ScriptService/Update` + create version | "💾 Saved ✓" + new version snapshot | `script:edit` |
| 16 | Create asset brief | "📋 Asset brief" | Navigate | — | → `/scripts/[id]/brief` (W023) | `script:edit` |
| 17 | Preview | "👁 Preview" | View | — | Modal: formatted script with reading mode, estimated timing marks | `script:read` |
| 18 | View old version | Click version in history | View | `ScriptService/GetVersion(version_id)` | Read-only view in modal — side-by-side diff option | `script:read` |
| 19 | Restore version | Version menu → "Restore" → confirm | Restore | `ScriptService/RestoreVersion(version_id)` | Content reverts. New version snapshot created. Toast "Đã khôi phục v{n}." | `script:edit` |
| 20 | Change status | Status dropdown | Status | `ScriptService/Update(status)` | Badge updates. Permissions may change (in_review → read-only for non-reviewer). | `script:edit` |
| 21 | Duplicate script | "⋮ → Duplicate" | Create | `ScriptService/Duplicate(id)` | New script created. Navigate to new script. Toast "Đã tạo bản sao." | `script:create` |
| 22 | Export | "⋮ → Export" → format picker | Export | Client-side generation | PDF/TXT/Google Docs download | `script:read` |
| 23 | Delete | "⋮ → Delete" → type "DELETE" | Destructive | `ScriptService/Delete(id)` | Navigate → /scripts. Toast "Đã xóa." | `script:delete` |

---
## 7. Validation Rules

| Field | Rule | Error | Severity |
|---|---|---|---|
| Title | Required, 5-200 chars | "Tiêu đề phải từ 5-200 ký tự" | Block save |
| Hook section | Required if platform = TikTok/IG Reels | "Video ngắn TikTok/IG cần có Hook" | Warning (🟡) |
| Hook word count | ≤ 20 words (TikTok) / ≤ 30 words (IG) | "Hook quá dài cho {platform}" | Warning (🟡) |
| CTA section | Strongly recommended | "Nên có CTA để tăng engagement" | Warning (🟡) |
| Body word count | Per platform: TikTok ≤ 150, IG ≤ 200, YT Short ≤ 100, YT Long ≤ 2000 | "Nội dung {section} quá dài cho {platform}" | Warning (🟡) |
| Total duration est. | Per platform: TikTok 15-180s, IG Reels 15-90s, YT Shorts 15-60s | "Ước lượng thời lượng không phù hợp format" | Warning (🟡) |
| Brand voice | AI check score ≥ 70/100 | "⚠️ Không khớp brand voice — xem gợi ý trong AI tab" | Warning (🟡) |
| Review submission | All "Block" errors resolved | "Sửa lỗi trước khi gửi review" | Block submit |

---
## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial page load | Editor skeleton + side panel skeleton | Wait |
| LOADED | Script data ready | Full editor with sections populated | Edit |
| EDITING | Active editing | Auto-save timer running. "💾 Saving..." indicator. | Type |
| SAVED | Auto-save success | "💾 Saved ✓" flash (3 seconds) → reverts to last saved timestamp | Continue |
| SAVE_FAILED | Auto-save failed | "❌ Save failed [Retry]" — red indicator. Content preserved client-side. | Retry or continue offline |
| AI_GENERATING | AI generating reply/suggestion | Side panel chat shows typing indicator ("🤖 ") | Wait |
| IN_REVIEW | Status = "in_review" | Yellow banner: "📤 Đang review bởi {reviewer}". Editor read-only for author. Reviewer can comment and approve. | Wait for review / respond to comments |
| CHANGES_REQUESTED | Reviewer requested changes | Orange banner: "🔄 Cần sửa — {reviewer} yêu cầu thay đổi. [Xem comments]". Editor writable again. | Make edits, re-submit |
| APPROVED | Status = "approved" | Green banner: "✅ Approved bởi {reviewer} · {date}". Editor read-only (archive protection). | Proceed to asset brief |
| ARCHIVED | Status = "archived" | Gray banner: "🗃 Archived". Read-only with restore option. | View or restore |
| PREVIEW | Preview modal open | Formatted script with timing marks, no editing | Close preview |
| CONCURRENT_EDIT | Another user editing same script | Banner: "👤 {name} đang chỉnh sửa". Real-time cursor (if implemented) or warning. | Coordinate with team |
| OFFLINE | No network | Banner: "📡 Ngoại tuyến — thay đổi sẽ đồng bộ khi có mạng". Editing continues client-side. | Continue editing |

---
## 9. Permissions & Role-based Behavior

| Action | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View script | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ✅ | ❌ |
| Edit script | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ❌ | ❌ |
| AI assist | ✅ | ✅ | ✅ | ✅ | ⚠️ credit limited | ❌ | ❌ |
| Send for review | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ❌ | ❌ |
| Review (comment) | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Approve | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Delete | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Export | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ✅ | ❌ |
| Restore version | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Contributor**: Can only access own scripts. Cannot see team member scripts.
- **Viewer**: Read-only view. No editor toolbar. No AI panel.
- **During review**: Author can see comments and resolve them, but cannot edit content until reviewer takes action.

---
## 10. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Auto-save sync | Optimistic → server confirm | Every 2s (debounced) |
| AI chat streaming | SSE from `CopilotService/Query` | Real-time per character |
| Brand voice check | On section blur | On-demand (debounced 1s) |
| Review comments | SSE `/events/script/{id}/reviews` | Real-time — new comment appears inline |
| Review status change | SSE | Real-time — banner updates |
| Concurrent edit detection | SSE presence | Every 5s heartbeat |

---
## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| Very long script (3000+ words) | Sections lazy-loaded. Scroll to section. Performance warning: "Script rất dài — cân nhắc chia thành nhiều phần." |
| Auto-save fails repeatedly | Red banner: "❌ Không lưu được — kiểm tra kết nối. Nội dung đã lưu cục bộ." Content preserved in localStorage. |
| AI quota exceeded | AI buttons disabled. Chat shows: "Đã dùng hết quota AI. [Nâng cấp →]". Manual editing continues. |
| Concurrent editing (2 users) | Presence banner with name. If conflict: last-write-wins with version history for recovery. |
| Script deleted while editing | Show dialog: "Script này đã bị xóa bởi {name}. [Tạo bản sao] [Đóng]" |
| Platform changed (mid-edit) | Guidelines re-evaluate. Word counts may turn yellow/red. Toast: "Đã cập nhật hướng dẫn cho {platform}." |
| Review submitted → then edit | Editor becomes read-only. Can only add comments to respond to reviewer. |
| Linked idea deleted | Badge shows "Idea #42 (đã xóa)". Still clickable to see archived idea. |
| Export very long script | Server-side PDF generation for scripts > 2000 words. |
| Offline → come back online | "Đang đồng bộ thay đổi..." → "✅ Đã đồng bộ." If conflict: show diff dialog. |

---
## 12. Keyboard Shortcuts

| Shortcut | Action |
|---|---|
| `Cmd+S` | Force save + version snapshot |
| `Cmd+Enter` | AI suggest for active section |
| `Cmd+B` | Bold |
| `Cmd+I` | Italic |
| `Cmd+Shift+H` | Highlight |
| `Cmd+/` | Toggle comment (review mode) |
| `Cmd+Shift+P` | Preview |
| `Escape` | Close modal / side panel |
| `Tab` | Next section (in editor) |
| `Shift+Tab` | Previous section |

---
## 13. Accessibility

| Element | Requirement |
|---|---|
| Editor | `role="textbox"`, `aria-label="Section: {section_name}"` per section |
| Sections | `role="region"`, sortable via keyboard (focus → arrow keys) |
| AI chat | `role="log"`, `aria-live="polite"` for streaming |
| Review comments | `role="note"`, `aria-label="Comment from {reviewer}"` |
| Status badges | Color + icon + text (not color-only) |
| Word counter | `aria-live="polite"` for screen reader updates |
| Keyboard | Full editing without mouse (see shortcuts above) |

---
## 14. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `script.opened` | Page load | `script_id`, `status`, `platform`, `word_count` |
| `script.edited` | Auto-save fires | `script_id`, `section_edited`, `word_count_delta` |
| `script.ai.suggest_used` | AI suggestion requested | `section_type`, `suggestion_type` (hook/shorten/chat) |
| `script.ai.insert_used` | AI text inserted | `section_type`, `insert_length` |
| `script.ai.voice_check` | Brand voice check run | `score`, `section_count` |
| `script.review.submitted` | Sent for review | `script_id`, `reviewer_ids`, `word_count` |
| `script.review.approved` | Script approved | `script_id`, `review_duration_hours` |
| `script.review.changes` | Changes requested | `script_id`, `comment_count` |
| `script.version.restored` | Version restored | `script_id`, `restored_version` |
| `script.exported` | Script exported | `script_id`, `format` |
| `script.deleted` | Script deleted | `script_id`, `word_count`, `status` |

---
## 15. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (editor rendered) |
| TTI | < 2.0s |
| Auto-save round trip | < 500ms |
| AI suggest response | < 3s (streamed) |
| Rich text editor keypress | < 16ms (60fps typing) |
| Section reorder animation | 60fps |
| Brand voice check | < 5s |
| Version history load | < 1s |

---
## 16. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/scripts/[id]/+page.svelte`
- **Server load**: `+page.server.ts` → `ScriptService/Get(id)` with sections
- **Editor**: ProseMirror with custom schema for script sections
- **Auto-save**: Svelte writable store with `debounce(2000)` → RPC `UpdateSection`
- **AI**: `CopilotService/Query` with SSE streaming into side panel
- **Split view**: Resizable via CSS `resize` or `svelte-split-pane`
- **Rich text toolbar**: Context-sensitive (changes per section type)

### Auto-save Flow
```
keystroke → update Svelte store → debounce 2s
  → ScriptService/UpdateSection (optimistic)
  → on success: update SaveStatus to "Saved ✓"
  → on failure: preserve in localStorage, show retry
  → on significant save: create version snapshot
```

### Brand Voice Integration
```
Section blur → debounce 1s
  → CopilotService/CheckBrandVoice(section_text, brand_profile_id)
  → returns: { score: 85, suggestions: [...], tone_match: true }
  → update section footer badge
```

---
## 17. Navigation Map

```
Script Editor (/scripts/[id])
├── → /scripts/[id]/brief (📋 Asset Brief → W023)
├── → /scripts/[id]/review (review thread)
├── → /ideas/[idea_id] (linked idea click)
├── ← /scripts (back to list → W020)
```


---
## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W015] Script List | Parent list screen |
| [W017] Script Review | Review workflow (inline in editor or separate) |
| [W020] Asset Brief | Visual/production notes linked to script |
| [W012] Idea Board | Upstream — ideas feed into scripts |
| [M011] Mobile Script Editor | Mobile equivalent |
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

---
## Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | Patch | Removed duplicate template sections. Replaced with screen-specific Error Handling, Accessibility, Loading, Localization, Design Tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
