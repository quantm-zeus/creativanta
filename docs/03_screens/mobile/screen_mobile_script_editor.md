# Screen: Mobile — Script Editor

> **Screen ID**: M014
> **Module**: M06 — Script Lab
> **Route**: `/scripts/[id]` (mobile app)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 01 §4, Product Freeze §13, A1 Schema (scripts, script_sections, script_reviews), B5 RBAC §2.7

---
## 1. Purpose & Context

The Mobile Script Editor allows creators to view, edit, and approve scripts on-the-go. It features section-by-section editing (Hook, Body, CTA), per-section AI regeneration, a readthrough timer for duration calibration, and voice-to-text input. Optimized for one-thumb editing with large touch targets and haptic feedback on actions.

### User Goals
- Review and fine-tune AI-generated scripts before recording
- Quickly adjust script sections while on location or commuting
- Use readthrough timer to practice timing before recording
- Approve scripts to advance them to production pipeline

### Business Goals
- Enable mobile-first workflow (script → recording without returning to desktop)
- Reduce content bottleneck by allowing approval anywhere
- Increase AI credit usage through mobile regeneration

### When This Screen Is Used
- After AI generates script (notification → tap → edit)
- Before recording (last-minute script review + readthrough)
- Team review (reviewer checks script on mobile, approves/rejects)

### Entry Points
- Script List (M013): tap script card
- Idea Board (M008): "📝 Viết script →" CTA
- Push notification: "Script mới đã tạo" → deep link
- Copilot (M060): "📝 Tạo script →" CTA in AI response

### Exit Points
- "← Scripts" → Script List (M013)
- "Approve" → stays, status→approved, toast
- "→ Production" → AI Studio mode picker

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `script:read` permission (all members except External)
- Script exists and belongs to user's workspace
- If editing: user has `script:update` permission

### Postconditions
- Auto-save persists all edits (last-write-wins with conflict detection)
- Status changes logged in `script_history`
- AI regeneration consumes credits from workspace balance

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Scripts   ✏️ "5 tips nấu ăn"              [💾 Saved] [⋮]        │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Metadata Bar ─────────────────────────────────────────────────┐  │
│ │ 🎵 TikTok · 30-60s · Status: Draft · Source: 🤖 AI          │  │
│ │ From idea: #42 ⭐85 · Last edit: 2h ago                       │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Section: HOOK (0-3s) ──────────────────────────────────────┐    │
│ │ 🎣 Hook                                      12/20 words 🟢 │    │
│ │ ┌─ Editable Text ──────────────────────────────────────────┐ │    │
│ │ │ "Bạn có biết 5 mẹo đơn giản giúp nấu ăn ngon hơn?"    │ │    │
│ │ └──────────────────────────────────────────────────────────┘ │    │
│ │ [🤖 Regenerate] [🔊 Read aloud] [🎤 Voice input]           │    │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Section: BODY (3-50s) ──────────────────────────────────────┐   │
│ │ 📖 Body                                      89/150 words 🟡│   │
│ │ ┌─ Editable Text ──────────────────────────────────────────┐ │   │
│ │ │ "Mẹo 1: Luôn chuẩn bị nguyên liệu trước khi nấu. Mẹo  │ │   │
│ │ │  2: Thứ tự apply sản phẩm quan trọng hơn bạn nghĩ..."  │ │   │
│ │ └──────────────────────────────────────────────────────────┘ │   │
│ │ [🤖 Regenerate] [🔊 Read aloud] [🎤 Voice input]            │   │
│ │ ⚠️ Hơi dài cho TikTok 30s (target: ≤80 words)              │   │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Section: CTA (50-60s) ─────────────────────────────────────┐    │
│ │ 🎯 CTA                                       8/30 words 🟢  │    │
│ │ ┌─ Editable Text ──────────────────────────────────────────┐ │    │
│ │ │ "Follow để xem thêm tips hữu ích mỗi ngày!"            │ │    │
│ │ └──────────────────────────────────────────────────────────┘ │    │
│ │ [🤖 Regenerate] [🔊 Read aloud]                              │    │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Readthrough Timer ──────────────────────────────────────────┐    │
│ │ [▶ Start Timer]  Total: 58s / 60s target ✅                  │    │
│ │ Auto-detects pace per section. Tap timer to reset.            │    │
│ └──────────────────────────────────────────────────────────────┘    │
│                                                                      │
│ ┌─ Bottom Actions ─────────────────────────────────────────────┐    │
│ │ [📤 Gửi review] [✅ Approve] [🎬 → Production]             │    │
│ └──────────────────────────────────────────────────────────────┘    │
│                                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                           │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
MobileScriptEditorPage
├── AppBar
│   ├── BackButton ("← Scripts")
│   ├── ScriptTitle (editable inline, long-press to edit)
│   ├── SaveStatusIndicator ("💾 Saved" / "Saving..." / "❌ Unsaved")
│   └── MoreMenu (⋮ → Duplicate, Export, Delete, View version history)
├── MetadataBar (non-editable summary)
│   ├── PlatformBadge (🎵 TikTok / 🎬 IG / etc.)
│   ├── DurationRange ("30-60s")
│   ├── StatusBadge (Draft / In Review / Approved)
│   ├── SourceBadge (🤖 AI / ✍ Manual)
│   ├── LinkedIdeaChip (tap → Idea Detail)
│   └── LastEditTime
├── SectionList (scrollable, vertically stacked)
│   └── ScriptSection[] (collapsible)
│       ├── SectionHeader
│       │   ├── SectionIcon (🎣/📖/🎯)
│       │   ├── SectionName ("Hook", "Body", "CTA")
│       │   ├── TimeRange ("0-3s")
│       │   ├── WordCounter ("12/20 words")
│       │   ├── LengthIndicator (🟢/🟡/🔴 based on platform guidelines)
│       │   └── CollapseToggle
│       ├── TextEditor (multiline, auto-expanding)
│       ├── PlatformGuidanceNote (conditional — ⚠️ warning if too long)
│       └── SectionActionBar
│           ├── RegenerateButton ("🤖 Regenerate" → AI rewrites section)
│           ├── ReadAloudButton ("🔊" → TTS playback)
│           └── VoiceInputButton ("🎤" → speech-to-text into editor)
├── ReadthroughTimer
│   ├── PlayPauseButton
│   ├── TimerDisplay (current / target)
│   ├── PaceIndicator (✅ on track / ⚠️ too fast/slow)
│   └── ResetButton
├── BottomActionBar (fixed above bottom nav)
│   ├── SendReviewButton ("📤 Gửi review")
│   ├── ApproveButton ("✅ Approve", Manager+ only)
│   └── GoToProductionButton ("🎬 → Production")
└── BottomNavBar
```

---
## 5. Displayed Data

| Element | Source | API | Display Format | Cache |
|---|---|---|---|---|
| Title | `scripts.title` | `ScriptService/Get(id)` | Editable text, max 200 chars | 5m |
| Sections | `script_sections` ordered by position | same | List of editor blocks | 5m |
| Section content | `script_sections.content` | same | Plaintext (mobile — no rich text) | 5m |
| Platform | `scripts.target_platform` | same | Platform badge icon | 5m |
| Duration target | `scripts.target_duration` | same | "30-60s" | 5m |
| Word count | Computed client-side | — | "12/20" per section | — |
| Platform guidelines | Static config per platform | Client-side | Max word counts, time ranges | — |
| Linked idea | `scripts.idea_id` → `ideas.title` | Join | Idea # + score badge | 5m |
| Status | `scripts.status` | same | Badge (Draft/In Review/Approved) | 5m |
| Auto-save | — | `ScriptService/Update` (debounced 2s) | "💾 Saved" indicator | — |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | Edit section text | Tap section → keyboard opens | Edit | Auto-save 2s after last keystroke `ScriptService/Update` | "💾 Saved" indicator | `script:update` |
| 2 | Regenerate section | "🤖 Regenerate" | AI action | `CopilotService/RegenerateSection(section_id)` | Section shimmers → new text appears. Haptic medium. | `copilot:use_creative` |
| 3 | Read aloud | "🔊" | TTS | Client-side TTS (on-device) | Audio plays, words highlighted in editor | Any |
| 4 | Voice input | "🎤" → speak | Input | On-device STT → text into editor | Transcribed text replaces section content | `script:update` |
| 5 | Start timer | "▶ Start" | Timer | — | Timer counts up, per-section timing logged | Any |
| 6 | Send for review | "📤 Gửi review" | Status | `ScriptService/Update(status=in_review)` | Toast "Script đã gửi review". Notification to reviewers. | `script:submit_review` |
| 7 | Approve | "✅ Approve" | Status | `ScriptService/Update(status=approved)` | Toast "Script đã duyệt ✅". Haptic success. | `script:approve` (Manager+) |
| 8 | Go to production | "🎬 → Production" | Navigate | — | → AI Studio mode picker with script context | `asset:generate` |
| 9 | Edit title | Long-press title → edit mode | Edit | `ScriptService/Update(title)` | Title updates, auto-save | `script:update` |
| 10 | Duplicate | ⋮ → "Duplicate" | Create | `ScriptService/Duplicate(id)` | Toast "Script đã nhân bản" → new script created | `script:create` |
| 11 | Delete | ⋮ → "Xóa" → confirm | Destructive | `ScriptService/Delete(id)` | Confirmation dialog (S007) → navigate ← Scripts | `script:delete` |
| 12 | Export | ⋮ → "Xuất file" | Export | Client-side | Share sheet with TXT content | `script:read` |
| 13 | View history | ⋮ → "Lịch sử phiên bản" | Navigate | — | Bottom sheet: version list, tap to view read-only | `script:read` |

---
## 7. Validation Rules

| Field | Rule | Visual | Severity |
|---|---|---|---|
| Title | Required, 5-200 chars | Red border if empty | Block save |
| Hook section | Required if TikTok/IG platform | ⚠️ warning chip | Warning only |
| Body word count | TikTok ≤ 150 words, IG ≤ 200, YT ≤ 2000 | 🟡/🔴 indicator | Warning |
| CTA section | Recommended for all platforms | 🟡 if missing | Warning |
| Duration match | Readthrough vs target ±15% | ✅/⚠️ indicator | Info |

---
## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Fetching script | Section shimmer placeholders | Wait |
| VIEWING | Read-only mode (Viewer role or Approved status) | Text fields disabled, no action buttons except Export | Read only |
| EDITING | Active editing | Text fields editable, auto-save active | Edit text |
| REGENERATING | AI regenerating section | Section shimmers with "🤖 Đang tạo lại..." | Wait (cancel available) |
| SAVING | Auto-save in progress | "💾 Saving..." flash (< 1s) | Continue editing |
| SAVED | Auto-save complete | "💾 Saved ✓" for 3s | Continue |
| REVIEWING | Script in review status | Banner: "📋 Đang chờ review bởi [name]". Editor editable for reviewer. | Approve/Reject |
| APPROVED | Script approved | Green banner "✅ Approved by [name] · [date]". Editor read-only (unless Owner/Admin). | View only |
| TIMER_RUNNING | Readthrough timer active | Timer counts up, per-section indicator shows pace | Practice reading |
| ERROR | Save/fetch failed | Toast: "❌ Không lưu được. [Thử lại]". Content preserved client-side. | Retry |
| OFFLINE | No network | Banner: "📡 Ngoại tuyến — chỉnh sửa sẽ đồng bộ khi có mạng". Editable, queue for sync. | Edit offline |

---
## 9. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View script | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ✅ | ❌ |
| Edit script | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ❌ | ❌ |
| AI regenerate | ✅ | ✅ | ✅ | ✅ | ⚠️ credits | ❌ | ❌ |
| Voice input | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Send for review | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ❌ | ❌ |
| Approve/Reject | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Delete | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Go to production | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Contributor**: Can only view/edit scripts they created. "Approve" button hidden.
- **Viewer**: All action buttons hidden except "📥 Export". Text fields are read-only.
- **Editor**: Can edit and send for review but cannot approve. "✅ Approve" hidden.

---
## 10. Mobile-specific UX

### Gestures & Haptics
- **Swipe section left → right**: Toggle collapse/expand section
- **Long press section**: Copy section text to clipboard (haptic light)
- **Long press title**: Enter edit mode for title
- **Haptic light**: On auto-save complete
- **Haptic medium**: On regenerate complete
- **Haptic success**: On approve action

### Keyboard Behavior
- Keyboard opens automatically when tapping into a section
- "Done" button on keyboard dismisses and saves
- Section auto-scrolls to keep cursor visible above keyboard

### Dark Mode
- Full dark mode support
- Editor background: `surface-container` 
- Section headers: slightly elevated surface

### Offline Behavior
- Script content cached for offline reading
- Edits queued in local storage, synced on reconnection
- "🔊 Read aloud" works offline (on-device TTS)
- "🤖 Regenerate" disabled offline with grey overlay

---
## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| Script deleted by another user while editing | Banner: "Script đã bị xóa bởi [user]." Navigate back on dismiss. |
| Concurrent edit (two users) | Show banner: "⚠️ [Name] đang chỉnh sửa. Thay đổi của bạn có thể bị ghi đè." Last-write-wins. |
| AI regeneration returns empty | Show: "🤖 Không tạo được nội dung mới. Thử prompt khác." Section content preserved. |
| Very long script (>10 sections) | Each section collapsible. Only expanded sections render full editor for performance. |
| Timer exceeds target duration | Timer color changes to red. "⚠️ Vượt thời lượng target: +12s." |
| No credits for regeneration | "🤖 Regenerate" shows tooltip: "Hết AI credits. [Nạp thêm →]." Button disabled. |
| Platform changed after script written | Re-evaluate all section guidelines. Show warnings if content now exceeds new platform limits. |

---
## 12. Performance Requirements

| Metric | Target |
|---|---|
| Open to interactive | < 800ms |
| Auto-save latency | < 500ms |
| AI regeneration | First token < 2s, completion < 5s |
| TTS start | < 500ms |
| Scroll performance | 60fps with all sections expanded |

---
## 13. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `script.editor.opened` | Page opens | `script_id`, `platform`, `status`, `source` (list/idea/notification/copilot) |
| `script.section.edited` | Section text changed (on save) | `section_type` (hook/body/cta), `word_count`, `edit_duration` |
| `script.section.regenerated` | AI regenerate | `section_type`, `credits_used`, `latency_ms` |
| `script.timer.started` | Timer started | `script_id`, `target_duration` |
| `script.timer.completed` | Timer stopped | `actual_duration`, `target_duration`, `delta` |
| `script.reviewed` | Sent for review | `script_id`, `word_count` |
| `script.approved` | Approved | `script_id`, `reviewer_id` |
| `script.voice_input` | Voice input used | `section_type`, `duration_seconds`, `word_count` |

---
## 14. Navigation Map

```
Mobile Script Editor (/scripts/[id])
├── ← /scripts (back to list)
├── → /ideas/[idea_id] (tap linked idea chip)
├── → /studio (via "→ Production" button)
├── → /settings/billing/credits (via credit top-up)
```

---
## 15. Flutter Implementation Notes

### Widget Structure
- **Route**: `/scripts/:id` → `ScriptEditorPage`
- **State management**: Riverpod `scriptDetailProvider(id)` + `scriptSectionsProvider(id)`
- **Text editing**: `TextEditingController` per section (not ProseMirror — plaintext on mobile)
- **Auto-save**: Debounced 2s via `Timer` → `ScriptService.update()` 
- **TTS**: `flutter_tts` package (on-device)
- **STT**: `speech_to_text` package (on-device)
- **Timer**: `Stopwatch` + `Timer.periodic(1s)` for UI update

### Data Fetching
```
onInit:
  scriptService.get(id) → script metadata + sections
  
onEdit(section_id, text):
  debounce(2s) → scriptService.updateSection(section_id, text)
  
onRegenerate(section_id):
  copilotService.regenerateSection(section_id) → Stream<Token> → update text
```


---
## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W021] Web Script Editor | Web equivalent (richer, split-panel with AI chat) |
| [M013] Script List | Parent list |
| [M008] Mobile Idea Board | Upstream idea source |
| [M060] Mobile Copilot | AI context for script creation |
| [M021] Mobile Studio | Downstream production |
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
