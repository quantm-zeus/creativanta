# Screen: Web — Quick Edit Mode

> **Screen ID**: W022
> **Module**: M07 — AI Studio
> **Route**: `/studio/quick-edit`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4.4, Pack 04, Product Freeze §15, A1 Schema (assets, generation_queue, transcripts), B5 RBAC §2.7

---

## 1. Purpose & Context

Quick Edit Mode is a transcript-based video editor — the "text editor for video" concept. Instead of traditional timeline-based cutting, creators edit video by editing text: AI transcribes the video with word-level timestamps, detects filler words ("ừm", "à") and dead pauses, then the creator simply strikes through text they want to cut. The resulting edit plan is executed by AI with optional enhancements: auto-captions, hooks, beat-sync music, B-roll injection, audio cleanup, and platform optimization.

### User Story
> As a creator who's recorded a 10-minute raw video, I want to clean it up by editing the transcript text — remove ums, awkward pauses, and repetitions — and let AI handle the actual video cuts, add captions, and optimize for TikTok. No timeline editing needed.

### Business Goals
- Lower the barrier to video editing (no editing skills required)
- Maximize AI Studio credit usage (each edit uses credits)
- Reduce video-to-publish cycle time (raw → polished in minutes, not hours)
- Drive premium feature adoption (B-roll, beat-sync, audio enhancement)
- Enable creators who currently outsource editing to self-serve

### When This Screen Is Used
- **Post-recording**: Creator has raw footage → needs cleanup before publishing
- **From Clip Factory**: Selected clip needs polish (filler removal, captions)
- **Batch editing**: Processing multiple raw videos sequentially
- **Content repurposing**: Taking a long video and cleaning up a segment

### Entry Points
- AI Studio Launcher ([W024]): "✂️ Quick Edit" card
- Clip Factory ([W026]): "✏ Edit in Quick Edit" on selected clip
- Generation Queue ([W030]): "✂️ Quick Edit" on completed raw transcription
- Direct URL: `/studio/quick-edit` or `/studio/quick-edit?asset_id=[id]`

### Exit Points
- "🚀 Apply edits" → Generation Queue ([W030]): job processing
- "📤 Publish" (after completion) → Publish Composer ([W048])
- "← Studio" → `/studio` (AI Studio Launcher)
- "💾 Save draft" → stays on page (draft saved)

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid session
- User has `asset:generate` permission
- Sufficient AI credits (minimum 15 for base edit)
- Video file uploaded or `asset_id` provided (supported: MP4, MOV, WebM)
- Video duration ≤ 30 minutes (hard limit for Quick Edit)

### Postconditions
- Transcription stored in `transcripts` table (reusable)
- Edit plan stored as structured JSON (replayable)
- Generation job created in `generation_queue` with all edit instructions
- Credits deducted upon job submission (not upon page load)
- Resulting asset stored in `assets` table when complete

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + Split View: Transcript Panel (40%) / Video Preview (60%) + Edit Plan below |
| Tablet (768-1279px) | App Shell + Stacked: Video on top (collapsed) + Transcript full width + Edit Plan |
| Mobile (≤767px) | Redirect to Mobile Quick Edit (M052) |

### ASCII Wireframe (Step 1: Upload)
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Studio   ✂️ Quick Edit                          🪙 Credits: 320  │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│                                                                      │
│          ┌─────────────────────────────────────────────────┐         │
│          │                                                 │         │
│          │               📎 Upload video                   │         │
│          │         Kéo thả file vào đây                   │         │
│          │  hoặc click để chọn file                       │         │
│          │                                                 │         │
│          │  MP4, MOV, WebM · Tối đa 30 phút              │         │
│          │                                                 │         │
│          │  ─── hoặc ───                                  │         │
│          │                                                 │         │
│          │  [📂 Chọn từ thư viện ▾]                       │         │
│          │                                                 │         │
│          └─────────────────────────────────────────────────┘         │
│                                                                      │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

### ASCII Wireframe (Step 2: Analyzing)
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Studio   ✂️ Quick Edit                          🪙 Credits: 320  │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│          ┌─────────────────────────────────────────────────┐         │
│          │        🔄 Đang phân tích video...               │         │
│          │                                                 │         │
│          │  [████████████░░░░░░░░░░░░░░] 45%              │         │
│          │                                                 │         │
│          │  ✅ Upload hoàn tất                             │         │
│          │  ✅ Trích xuất audio                            │         │
│          │  🔄 Chuyển đổi thành text (Whisper)...          │         │
│          │  ⬜ Phát hiện filler words                      │         │
│          │  ⬜ Phát hiện dead pauses                       │         │
│          │  ⬜ Phân tích cấu trúc nội dung                │         │
│          │                                                 │         │
│          │  ⏱ ~45 giây còn lại                            │         │
│          └─────────────────────────────────────────────────┘         │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

### ASCII Wireframe (Step 3: Editing Canvas — Main)
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Studio   ✂️ Quick Edit · coffee_routine.mp4     🪙 Credits: 320  │
├──────────────────────────────────────────────────────────────────────┤
│ Analysis: 🗑 5 filler words · ⏸ 2 dead pauses · ⏱ 8:42 → ~7:30   │
│ [🪄 Auto-fix all] [⟲ Undo] [⟳ Redo]                               │
├────────────────────────────┬─────────────────────────────────────────┤
│ Transcript (40%)           │ Video Preview (60%)                     │
│                            │                                         │
│ 00:00.0 ─────────────────  │ ┌─────────────────────────────────────┐│
│ "Xin chào các bạn, hôm    │ │                                     ││
│  nay mình sẽ chia sẻ"     │ │      [Video Player: 8:42]           ││
│                            │ │                                     ││
│ 00:03.2 ─────────────────  │ │    00:03 / 08:42                    ││
│ ~~"ừm"~~ 🗑 filler        │ │    [◀] [▶/⏸] [▶▶] [🔊] [⛶]       ││
│                            │ │                                     ││
│ 00:03.8 ─────────────────  │ └─────────────────────────────────────┘│
│ "hôm nay mình sẽ"         │                                         │
│                            │ ┌─ AI Detection Summary ──────────────┐│
│ 00:06.0 ─────────────────  │ │ 🗑 Filler words: 5                 ││
│ ~~[pause 2.1s]~~ ⏸        │ │    "ừm" ×3, "à" ×1, "kiểu" ×1     ││
│                            │ │ ⏸ Dead pauses: 2                    ││
│ 00:08.1 ─────────────────  │ │    @00:06 (2.1s), @02:34 (3.0s)    ││
│ "chia sẻ 5 tips để"       │ │ 🎯 Hook quality: 6/10              ││
│                            │ │    "Mở đầu hơi chậm"                ││
│ 00:10.5 ─────────────────  │ │ ⏱ Estimated savings: 12s            ││
│ "da mặt luôn mịn"         │ │ 📏 Final duration: ~7:30             ││
│                            │ └─────────────────────────────────────┘│
│ ...                        │                                         │
│                            │ [Split: Original | Edited Preview]     │
│ (click word to select)     │                                         │
│ (strikethrough = cut)      │                                         │
│ (yellow bg = AI suggested) │                                         │
├────────────────────────────┴─────────────────────────────────────────┤
│                                                                      │
│ ┌─ Edit Plan ────────────────────────────────────────────────────┐  │
│ │                                 Included        Add-ons        │  │
│ │ ☑ Remove 5 filler words         (saves 8s)     ── included ── │  │
│ │ ☑ Cut 2 dead pauses             (saves 4s)     ── included ── │  │
│ │ ☑ Auto-captions                 Style: [Bounce ▾]   included  │  │
│ │ ☐ Add hook                      Type: [Question ▾]  +3 credits│  │
│ │ ☐ Beat-sync music               Genre: [Chill ▾]    +5 credits│  │
│ │ ☐ AI B-roll injection           Scenes: auto        +10 credits│  │
│ │ ☐ Platform preset               Target: [TikTok ▾]  +3 credits│  │
│ │ ☐ Audio enhancement             Mode: [Noise ▾]     +3 credits│  │
│ │ ☐ Speed ramp (trending)         Style: [Smooth ▾]   +5 credits│  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ Estimated credits: 🪙 15 (base) + 0 (add-ons) = 15 total           │
│ Balance after: 🪙 305 remaining                                     │
│                                                                      │
│ [💾 Save draft]  [▶ Preview — free]  [🚀 Apply edits — 15 credits] │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
QuickEditPage
├── AppShell (shared)
│   ├── Sidebar
│   └── TopBar
├── PageHeader
│   ├── BackLink ("← Studio")
│   ├── Title ("✂️ Quick Edit" + filename when loaded)
│   └── CreditBalance ("🪙 Credits: 320")
├── Step1_Upload (shown when no video loaded)
│   ├── DropZone
│   │   ├── UploadIcon (📎)
│   │   ├── DropText ("Kéo thả file vào đây")
│   │   ├── ClickText ("hoặc click để chọn file")
│   │   ├── FileConstraints ("MP4, MOV, WebM · Tối đa 30 phút")
│   │   └── HiddenFileInput
│   └── LibraryPickerButton ("📂 Chọn từ thư viện ▾") → AssetPickerModal
├── Step2_Analyzing (shown during transcription)
│   ├── ProgressBar (percentage)
│   ├── StageChecklist
│   │   ├── UploadStage ("✅ Upload hoàn tất")
│   │   ├── AudioExtractStage ("✅/🔄 Trích xuất audio")
│   │   ├── TranscriptionStage ("🔄 Chuyển đổi thành text (Whisper)")
│   │   ├── FillerDetectStage ("⬜/🔄 Phát hiện filler words")
│   │   ├── PauseDetectStage ("⬜/🔄 Phát hiện dead pauses")
│   │   └── ContentAnalysisStage ("⬜/🔄 Phân tích cấu trúc nội dung")
│   └── TimeEstimate ("⏱ ~45 giây còn lại")
├── Step3_EditingCanvas (shown when transcript ready)
│   ├── AnalysisSummary
│   │   ├── FillerCount ("🗑 5 filler words")
│   │   ├── PauseCount ("⏸ 2 dead pauses")
│   │   ├── DurationEstimate ("⏱ 8:42 → ~7:30")
│   │   ├── AutoFixButton ("🪄 Auto-fix all" — applies all AI suggestions)
│   │   ├── UndoButton ("⟲ Undo" / ⌘Z)
│   │   └── RedoButton ("⟳ Redo" / ⌘⇧Z)
│   ├── SplitView
│   │   ├── TranscriptPanel (40%)
│   │   │   └── TranscriptSegment[]
│   │   │       ├── Timestamp ("00:03.2")
│   │   │       ├── TextContent
│   │   │       │   ├── NormalWord[] (clickable → select/cut)
│   │   │       │   ├── FillerWord[] (AI-highlighted yellow bg, pre-strikethrough)
│   │   │       │   │   ├── StrikethroughText ("~~ừm~~")
│   │   │       │   │   └── FillerBadge ("🗑 filler")
│   │   │       │   └── PauseIndicator
│   │   │       │       ├── StrikethroughMarker ("~~[pause 2.1s]~~")
│   │   │       │       └── PauseBadge ("⏸")
│   │   │       └── SelectionState (selected word = blue highlight)
│   │   └── VideoPreviewPanel (60%)
│   │       ├── VideoPlayer
│   │       │   ├── Video element (synced with transcript — click word → seek)
│   │       │   ├── CurrentTime / TotalTime
│   │       │   ├── Controls (prev, play/pause, next, volume, fullscreen)
│   │       │   └── TranscriptHighlight (current word underlined in video subtitles)
│   │       ├── AIDetectionSummary
│   │       │   ├── FillerDetails ("🗑 Filler: ừm ×3, à ×1, kiểu ×1")
│   │       │   ├── PauseDetails ("⏸ @00:06 (2.1s), @02:34 (3.0s)")
│   │       │   ├── HookQuality ("🎯 Hook quality: 6/10 — Mở đầu hơi chậm")
│   │       │   ├── TimeSaved ("⏱ Estimated savings: 12s")
│   │       │   └── FinalDuration ("📏 Final duration: ~7:30")
│   │       └── SplitToggle ("Original | Edited Preview")
│   │           ├── OriginalView (full unedited video)
│   │           └── EditedPreview (client-side simulation with cuts applied)
│   ├── EditPlan
│   │   ├── SectionHeader ("Edit Plan")
│   │   └── EditOption[]
│   │       ├── IncludedOptions (always selected, free with base cost)
│   │       │   ├── RemoveFillers ("☑ Remove {n} filler words — saves {n}s")
│   │       │   ├── CutPauses ("☑ Cut {n} dead pauses — saves {n}s")
│   │       │   └── AutoCaptions ("☑ Auto-captions" + StyleSelector: Bounce/Typewriter/Glow/Karaoke)
│   │       └── AddOnOptions (optional, each adds credit cost)
│   │           ├── AddHook ("☐ Add hook" + TypeSelector: Question/Statement/Statistic/Challenge | +3cr)
│   │           ├── BeatSyncMusic ("☐ Beat-sync music" + GenreSelector: Chill/Upbeat/Dramatic/Trending | +5cr)
│   │           ├── BRollInjection ("☐ AI B-roll injection" + auto-detect scenes | +10cr)
│   │           ├── PlatformPreset ("☐ Platform preset" + PlatformSelector: TikTok/IG Reels/YT Shorts | +3cr)
│   │           ├── AudioEnhancement ("☐ Audio enhancement" + ModeSelector: Noise removal/Level normalize/Both | +3cr)
│   │           └── SpeedRamp ("☐ Speed ramp" + StyleSelector: Smooth/Jarring/Beat-matched | +5cr)
│   ├── CreditEstimate
│   │   ├── BaseCost ("🪙 15 (base)")
│   │   ├── AddOnCost ("+ {n} (add-ons)")
│   │   ├── TotalCost ("= {total} total")
│   │   └── BalanceAfter ("Balance after: 🪙 {remaining} remaining")
│   └── ActionBar
│       ├── SaveDraftButton ("💾 Save draft")
│       ├── PreviewButton ("▶ Preview — free")
│       └── ApplyButton ("🚀 Apply edits — {n} credits")
├── AssetPickerModal (for library selection)
├── PreviewModal (split: before/after synced playback)
└── CreditWarningModal (when insufficient credits)
    ├── CurrentBalance ("Bạn có 🪙 {n} credits")
    ├── RequiredAmount ("Cần 🪙 {total} credits")
    ├── Shortage ("Thiếu 🪙 {diff}")
    └── Actions
        ├── "🪙 Mua thêm credits" → Settings/Billing
        └── "Giảm add-ons" (deselect add-ons to fit budget)
```

---

## 5. Displayed Data / Data Binding

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Uploaded video | User's local file or `assets` table | `UploadService/Upload` or `AssetService/Get(asset_id)` | Video player | Session |
| Transcript | Whisper API → `transcripts` table | `AIService/Transcribe(asset_id)` → SSE progress | Word-level text with timestamps | Session (reusable) |
| Filler detection | AI analysis of transcript | `AIService/AnalyzeTranscript(transcript_id)` | Highlighted words with badges | Session |
| Pause detection | AI analysis of audio waveform | Same as above | Pause markers with duration | Session |
| Hook quality score | AI analysis of opening segment | Same as above | Score (1-10) with verbal feedback | Session |
| Credit balance | `ai_credit_transactions` aggregated | `CreditService/GetBalance(workspace_id)` | "🪙 320" | 1m TTL |
| Credit tier costs | Configuration | Hardcoded client-side | Per-feature cost display | Static |
| Caption styles | Configuration | `ContentService/GetCaptionStyles` | Style names in dropdown | 24h TTL |
| Hook templates | Content templates | `ContentService/GetHookTemplates` | Type names in dropdown | 24h TTL |
| Music genres | Music library metadata | `AssetService/ListMusicGenres` | Genre names in dropdown | 24h TTL |

---

## 6. User Actions

| # | Action | Trigger | API Call | System Response | Permission |
|---|---|---|---|---|---|
| 1 | Upload video | Drag-drop or file picker | `UploadService/Upload(file)` (chunked) | Progress bar → upload complete → auto-start analysis | `asset:generate` |
| 2 | Pick from library | "📂 Chọn từ thư viện" → modal | `AssetService/List(type=video)` | Modal with video grid → select → load video | `asset:generate` |
| 3 | Click word in transcript | Click on any word | — (client-side) | Video seeks to word timestamp. Word highlighted blue. | `asset:generate` |
| 4 | Strike through word | Double-click or select + Delete | — (client-side) | Word gets strikethrough styling. Duration estimate updates. | `asset:generate` |
| 5 | Strike through segment | Click + drag to select range → Delete | — (client-side) | Entire range struck through | `asset:generate` |
| 6 | Auto-fix all | "🪄 Auto-fix all" | — (client-side) | All AI-detected fillers and pauses struck through at once | `asset:generate` |
| 7 | Undo edit | "⟲ Undo" or ⌘Z | — (client-side) | Last edit reverted. Undo stack manages history. | `asset:generate` |
| 8 | Redo edit | "⟳ Redo" or ⌘⇧Z | — (client-side) | Last undone edit re-applied | `asset:generate` |
| 9 | Toggle add-on | Click checkbox on edit option | — (client-side) | Credit estimate updates in real-time. Balance preview updates. | `asset:generate` |
| 10 | Change style/settings | Dropdown selectors (caption style, hook type, etc.) | — (client-side) | Selection stored in edit plan | `asset:generate` |
| 11 | Preview | "▶ Preview — free" | — (client-side simulation) | PreviewModal: split player shows original vs. edited (cuts applied client-side) | `asset:generate` |
| 12 | Save draft | "💾 Save draft" | `QuickEditService/SaveDraft(edit_state)` | Toast: "Đã lưu nháp!" | `asset:generate` |
| 13 | Apply edits | "🚀 Apply edits — {n} credits" → confirm | `AssetService/Generate(type=quick_edit, edit_plan)` | Credits deducted. Job created in queue. Navigate → Generation Queue. | `asset:generate` |
| 14 | Restore filler/pause | Click on struck-through word → "Khôi phục" | — (client-side) | Strikethrough removed. Duration estimate updates. | `asset:generate` |

---

## 7. States / State Machine

| State | Condition | Visual |
|---|---|---|
| UPLOAD | No video loaded | Upload drop zone prominently displayed |
| UPLOADING | File uploading | Drop zone replaced by progress bar + file name. Cancel button visible. |
| ANALYZING | Transcription + AI analysis in progress | Progress bar with stage checklist. Time estimate. Cancel button. |
| READY | Transcript loaded, AI suggestions applied | Full editing canvas: transcript panel + video preview + edit plan |
| EDITING | User making edits (striking through, toggling options) | Active editing state. Undo stack tracking. Duration estimate live. |
| PREVIEWING | Preview modal open | Split player: original left, edited right (synced) |
| APPLYING | Submit in progress | Button shows spinner: "🔄 Đang gửi..." All fields locked. |
| DRAFT_SAVED | Draft saved | Small "✅ Đã lưu" indicator near save button |
| ERROR | Any error during processing | Error message with retry action |
| CREDIT_INSUFFICIENT | Not enough credits for selected options | Credit warning modal with purchase/reduce options |

### Processing Pipeline States
```
UPLOAD → UPLOAD_COMPLETE → EXTRACT_AUDIO → TRANSCRIBE (Whisper) →
  DETECT_FILLERS → DETECT_PAUSES → ANALYZE_CONTENT → READY

Each stage: PENDING → IN_PROGRESS → COMPLETE (with checkmark)
Error at any stage → ERROR state with specific message
```

---

## 8. Validation Rules

### Upload
| Rule | Check | Error Message |
|---|---|---|
| File format | MP4, MOV, WebM | "Chỉ hỗ trợ MP4, MOV, WebM" |
| File size | ≤ 2GB | "File quá lớn. Tối đa 2GB." |
| Duration | ≤ 30 minutes | "Video tối đa 30 phút cho Quick Edit" |
| Audio track | Must have audio | "Video không có audio. Quick Edit cần audio để tạo transcript." |

### Edit Plan
| Rule | Check | Error Message |
|---|---|---|
| Credits sufficient | Total cost ≤ balance | CreditWarningModal (not blocking — shows options) |
| At least one edit | At least one cut or add-on | "Chưa có edit nào. Chọn ít nhất 1 thay đổi." |
| B-roll + short video | B-roll requires video > 1 min | "AI B-roll chỉ hoạt động với video ≥ 1 phút" |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| Access Quick Edit | ✅ | ✅ | ✅ | ✅ | ⚠️ credit limited | ❌ | ❌ |
| Upload video | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Edit transcript | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Use add-ons | ✅ | ✅ | ✅ | ✅ | ⚠️ credit check | ❌ | ❌ |
| Apply edits (spend credits) | ✅ | ✅ | ✅ | ✅ | ⚠️ credit check | ❌ | ❌ |
| Save draft | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

---

## 10. Navigation Map

```
Quick Edit (/studio/quick-edit)
├── → /studio/queue                  (After "🚀 Apply edits" — Generation Queue)
├── → /publish/compose?asset_id=x    (After job complete → Publish)
├── → /settings/billing              (Buy credits from warning modal)
├── → AssetPickerModal               (Pick from library — inline modal)
└── ← /studio                        (Back to AI Studio Launcher)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Upload fails | Network error or file rejected | Drop zone: "Upload thất bại: {error}. [Thử lại]" | Retry upload |
| Upload too large | File > 2GB | Toast: "File quá lớn (2.1GB). Tối đa 2GB." | Compress or trim video first |
| Transcription fails | Whisper API error or timeout | Analysis stage: "❌ Không tạo được transcript. [Thử lại]" | Retry transcription |
| Transcription poor quality | Audio too noisy or unclear | Warning: "⚠ Chất lượng transcript thấp. Một số từ có thể không chính xác." | Proceed with manual corrections |
| No speech detected | Silent video or music-only | Error: "Không phát hiện giọng nói trong video. Quick Edit cần audio có giọng nói." | Upload different video |
| Credits insufficient | Select add-ons exceeding balance | CreditWarningModal with options to buy or reduce | Buy credits or deselect add-ons |
| Apply fails | API error during job submission | Button reverts. Toast: "Không gửi được. [Thử lại]" | Retry (edit state preserved) |
| Draft save fails | Network error | Subtle: "⚠ Chưa lưu được" (non-blocking) | Auto-retry in 10s |
| Video format unsupported | Non-video file dropped | Toast: "Định dạng không hỗ trợ. Chỉ MP4, MOV, WebM." | Upload correct format |
| Concurrent editing | Session expired while editing | Modal: "Phiên đã hết hạn. [Lưu nháp & đăng nhập lại]" | Save draft → re-authenticate |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Upload drop zone | `role="button"`, `aria-label="Upload video file, drag and drop or click to browse. Supports MP4, MOV, WebM up to 30 minutes."` |
| Transcript words | `role="button"`, `aria-label="Word: {word}, timestamp {time}. Press Enter to cut."`, `aria-pressed` for struck-through words |
| Filler badges | `aria-label="Filler word detected: {word}"` |
| Pause markers | `aria-label="Dead pause: {duration} seconds at {timestamp}"` |
| Video player | Standard HTML5 video controls + custom keyboard shortcuts |
| Edit plan checkboxes | `role="checkbox"`, `aria-label="Add hook, plus 3 credits"`, `aria-checked` |
| Credit estimate | `aria-live="polite"` — announced when total changes |
| Apply button | `aria-label="Apply edits for {n} credits. {remaining} credits will remain."` |
| Progress stages | `aria-live="polite"` — each stage completion announced |
| Undo/Redo | `aria-label="Undo last edit"`, keyboard shortcut displayed |
| Color contrast | All text meets WCAG 2.1 AA (4.5:1 ratio) |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Shell render | 0ms | App Shell renders (SSR). Upload area visible. |
| Pre-fill from asset | 100-500ms | If `asset_id` param: video loads, analysis starts automatically |
| Upload progress | 2-30s (size dependent) | Progress bar with percentage + speed indicator |
| Transcription | 30-90s (duration dependent) | Stage checklist with progressive checkmarks |
| Filler/pause analysis | 5-15s | Stage checklist progresses |
| Full canvas ready | 0ms after analysis | Split view appears. Transcript populates. AI highlights visible. |

### Duration-Based Estimates
| Video Duration | Upload (50Mbps) | Transcription | Analysis | Total |
|---|---|---|---|---|
| 1 min (60MB) | ~10s | ~10s | ~5s | ~25s |
| 5 min (300MB) | ~48s | ~30s | ~10s | ~90s |
| 10 min (600MB) | ~96s | ~60s | ~15s | ~3 min |
| 30 min (1.5GB) | ~240s | ~150s | ~30s | ~7 min |

---

## 14. Performance Requirements

| Metric | Target | Measurement |
|---|---|---|
| LCP | < 1.5s | Upload area (simple, no data dependencies) |
| FID | < 100ms | First click on transcript word |
| CLS | < 0.05 | No shift when canvas appears (reserved layout) |
| Upload speed | Chunked, resumable | Progressive upload with retry per chunk |
| Transcript sync | < 50ms | Click word → video seeks within 50ms |
| Undo/Redo | < 16ms | Instant — client-side stack operation |
| Credit recalculation | < 16ms | Instant — client-side arithmetic |
| Preview generation | < 2s | Client-side video composition (no server round-trip) |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Transcription progress | SSE `/events/transcription/{job_id}` | Real-time — each stage reports progress percentage |
| Credit balance (ambient) | Polling | Every 1 minute (background AI jobs may consume credits) |
| Generation queue status | SSE `/events/queue` | After apply: track job progress from queue page |

### Transcript Streaming
```
// SSE event stream during transcription:
event: stage_update
data: { stage: "transcribe", progress: 45, eta_seconds: 30 }

event: stage_complete
data: { stage: "transcribe", result: { word_count: 1234 } }

event: analysis_complete
data: { fillers: [...], pauses: [...], hook_score: 6 }

event: ready
data: { transcript_id: "xxx", total_segments: 156 }
```

---

## 16. Localization Notes

- Primary language: Vietnamese
- Filler words: Vietnamese ("ừm", "à", "kiểu", "là", "thì") — language-aware detection
- Timestamps: MM:SS.s format ("03:02.5")
- Duration: "8:42" (minutes:seconds)
- Credit costs: "🪙 15 credits" (internal currency, no VND)
- Stage names: Vietnamese ("Chuyển đổi thành text", "Phát hiện filler words")
- Button labels: Mixed ("🪄 Auto-fix all" — English for clarity)
- Error messages: Vietnamese
- Tone: Technical but approachable

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `quick_edit.opened` | Page load | `source` (studio/clip_factory/queue), `has_asset` (boolean) |
| `quick_edit.video.uploaded` | Upload complete | `file_size_mb`, `duration_s`, `format` |
| `quick_edit.video.from_library` | Selected from library | `asset_id`, `duration_s` |
| `quick_edit.analysis.started` | Transcription begins | `duration_s` |
| `quick_edit.analysis.completed` | All analysis done | `filler_count`, `pause_count`, `hook_score`, `processing_time_s` |
| `quick_edit.auto_fix.used` | "Auto-fix all" clicked | `filler_count`, `pause_count`, `time_saved_s` |
| `quick_edit.word.cut` | Word struck through manually | `word`, `is_filler` (boolean), `timestamp` |
| `quick_edit.word.restored` | Struck-through word restored | `word`, `timestamp` |
| `quick_edit.addon.toggled` | Add-on checkbox toggled | `addon_type`, `enabled` (boolean), `credit_cost` |
| `quick_edit.preview.viewed` | Preview modal opened | `cuts_count`, `addons_enabled[]`, `estimated_duration` |
| `quick_edit.draft.saved` | Draft saved | `cuts_count`, `addons_enabled[]` |
| `quick_edit.applied` | "Apply edits" confirmed | `credits_spent`, `cuts_count`, `addons_enabled[]`, `original_duration_s`, `estimated_duration_s` |
| `quick_edit.abandoned` | Left without applying | `time_spent_s`, `had_edits` (boolean), `reason` (if available) |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Apply button, upload CTA, auto-fix button |
| `--color-success` | ✅ Completed analysis stages, included edit options |
| `--color-warning` | ⚠ Poor transcript quality, low hook score |
| `--color-danger` | File too large errors, credit insufficient |
| `--color-surface-primary` | Page background |
| `--color-surface-elevated` | Transcript panel, edit plan card, analysis summary |
| `--color-surface-input` | Dropdown selectors in edit plan |
| `--color-filler-highlight` | Yellow background for AI-detected filler words |
| `--color-pause-highlight` | Amber background for detected pauses |
| `--color-cut-text` | Strikethrough text color (grey, 50% opacity) |
| `--color-selection` | Blue highlight for selected word |
| `--color-text-primary` | Transcript text, edit plan labels |
| `--color-text-secondary` | Timestamps, credit costs, descriptions |
| `--color-text-credit` | Credit number styling (accent tint) |
| `--font-mono` | Timestamps (monospace for alignment) |
| `--radius-card` | Panel/card border-radius (12px) |
| `--shadow-card` | Panel elevation |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/studio/quick-edit/+page.svelte`
- **Server load**: `+page.server.ts` → minimal (credit balance only). Most data is client-side.
- **URL params**: `?asset_id=[id]` (pre-load from library)

### Transcription Pipeline
```
// 1. Upload video → R2
const { assetId, url } = await uploadService.upload(file, { chunked: true })

// 2. Start transcription (SSE for progress)
const transcribeJob = await aiService.transcribe(assetId)
const eventSource = new EventSource(`/api/events/transcription/${transcribeJob.id}`)

eventSource.addEventListener('stage_update', (e) => {
  const { stage, progress } = JSON.parse(e.data)
  updateProgress(stage, progress)
})

eventSource.addEventListener('ready', (e) => {
  const { transcript_id } = JSON.parse(e.data)
  transcript = await aiService.getTranscript(transcript_id)
  state = 'READY'
})
```

### Edit State Management
```
// Svelte 5 state with undo/redo stack
let editState = $state({
  cuts: [],           // [{ startMs, endMs, type: 'filler'|'pause'|'manual' }]
  addons: {
    captions: { enabled: true, style: 'bounce' },
    hook: { enabled: false, type: 'question' },
    beatSync: { enabled: false, genre: 'chill' },
    broll: { enabled: false },
    platform: { enabled: false, target: 'tiktok' },
    audioEnhance: { enabled: false, mode: 'noise' },
    speedRamp: { enabled: false, style: 'smooth' }
  }
})

// Undo stack
const undoStack = []
const redoStack = []

function applyEdit(edit) {
  undoStack.push(getSnapshot())
  redoStack.length = 0  // clear redo on new edit
  editState.update(state => applyEditToState(state, edit))
}
```

### Credit Calculation
```
function calculateCredits(editState) {
  let total = 15  // base cost (fillers + pauses + captions)
  if (editState.addons.hook.enabled) total += 3
  if (editState.addons.beatSync.enabled) total += 5
  if (editState.addons.broll.enabled) total += 10
  if (editState.addons.platform.enabled) total += 3
  if (editState.addons.audioEnhance.enabled) total += 3
  if (editState.addons.speedRamp.enabled) total += 5
  return total
}
```

### Client-Side Preview
- Preview uses two `<video>` elements (original + edited simulation)
- Edited simulation: skip over cut segments by seeking past them during playback
- No server round-trip — purely client-side video manipulation
- `wavesurfer.js` for audio waveform visualization (optional)

### Transcript-Video Sync
- Each word has `{ startMs, endMs, text, confidence }` from Whisper
- Click on word → `video.currentTime = word.startMs / 1000`
- Video playing → highlight current word in transcript (binary search on timestamps)

---

## 20. Related Screens

| Screen | Relationship |
|---|---|
| [W021] Studio Launcher | Parent: entry point |
| [W023] Clip Factory | Upstream: clips sent to Quick Edit for polish |
| [W030] Studio Queue | Downstream: job processing after apply |
| [W052] Publish Composer | Downstream: publish completed asset |
| [M014] Mobile Quick Edit | Mobile equivalent |

---

## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Full Tier A rewrite**: Upgraded from 291-line Tier B/C with generic boilerplate to 530+ line full spec. Added: 3-step progressive UI (Upload → Analyzing → Editing Canvas), complete transcript panel with word-level interaction, AI detection summary with hook quality scoring, 9 edit plan options with credit cost breakdown, client-side preview architecture, SSE streaming for transcription progress, undo/redo stack specification, Svelte store edit state management, transcript-video sync algorithm, duration-based processing estimates, Vietnamese filler word list, 13 analytics events. Removed all generic boilerplate. Standardized Screen ID from W25 to W022. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier B) | System |
