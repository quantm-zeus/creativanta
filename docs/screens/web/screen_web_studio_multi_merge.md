# Screen: Web — Multi-Merge Mode

> **Screen ID**: W27
> **Module**: M07 — AI Studio
> **Route**: `/studio/multi-merge`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4.4, Pack 04, A1 Schema (assets, generation_queue)

---

## 1. Purpose & Context

Combine multiple media files (videos + images) into one polished video with AI transitions, voice-over, and music. Timeline-based editor with drag-to-reorder and transition controls.

### User Story
> As a creator, I want to merge several clips and images into one video with smooth transitions and matching music.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Studio   🔀 Multi-Merge                     [Media: 5/20 max]   │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Media Drop Zone ──────────────────────────────────────────────┐  │
│ │ [Drop media here ↓] or [📎 Upload] or [📂 From library]       │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Timeline Editor ──────────────────────────────────────────────┐  │
│ │ ┌────┐ → ┌────┐ → ┌────┐ → ┌────┐ → ┌────┐                 │  │
│ │ │ V1 │   │ I1 │   │ V2 │   │ I2 │   │ V3 │                 │  │
│ │ │30s │   │ 3s │   │15s │   │ 3s │   │20s │                 │  │
│ │ └────┘   └────┘   └────┘   └────┘   └────┘                 │  │
│ │ [drag to reorder]  Transitions: → between items              │  │
│ │ Click → to edit transition: [Fade|Cut|Zoom|Glitch]           │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Settings ─────────────────────────────────────────────────────┐  │
│ │ Duration target: [60s ▾]    Auto-adjust timing: [ON ▾]        │  │
│ │ Transitions: [Auto AI ▾]                                       │  │
│ │ Voice-over: [🎭 Character: Mila ▾] [🎤 Record own]            │  │
│ │ Music: [🎵 Auto-select ▾] [📎 Upload] [🎵 Generate AI]       │  │
│ │ Aspect: [9:16 ●] [16:9 ○] [1:1 ○]                            │  │
│ │ Pacing: [Fast ○] [Medium ●] [Slow ○]                          │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ [▶ Preview — free] [Credits: ~20] [🚀 Create video]                 │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
MultiMergePage
├── AppShell (shared)
├── PageHeader (← Studio, title, media count)
├── MediaDropZone (upload, library select)
├── TimelineEditor
│   ├── TimelineItem[] (draggable)
│   │   ├── Thumbnail
│   │   ├── DurationLabel
│   │   ├── TrimHandle
│   │   └── RemoveButton
│   └── TransitionMarker[] (between items, clickable)
│       └── TransitionPicker (Fade/Cut/Zoom/Glitch/Slide)
├── SettingsPanel
│   ├── DurationTarget
│   ├── TransitionSelector
│   ├── VoiceOverControl (character select or record)
│   ├── MusicControl (auto/upload/generate)
│   ├── AspectRatioSelector
│   └── PacingSelector
└── ActionBar
    ├── PreviewButton
    ├── CreditEstimate
    └── CreateButton
```

---

## 4-5. Data & Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Add media | Upload/drop | Upload to R2 | Thumbnail on timeline | `asset:generate` |
| 2 | Reorder | Drag-drop | — (client) | Timeline reorders | `asset:generate` |
| 3 | Remove media | ✂️ on item | — (client) | Item removed | `asset:generate` |
| 4 | Edit transition | Click → between | — (client) | Picker dropdown | `asset:generate` |
| 5 | Record voice-over | 🎤 Record | Browser MediaRecorder | Audio captured | `asset:generate` |
| 6 | AI voice-over | Select character | `AIService/GenerateVoice` | Voice generated | `asset:generate` |
| 7 | AI music | 🎵 Generate | `AIService/GenerateMusic` | Music → timeline | `asset:generate` |
| 8 | Preview | ▶ Preview | Client-side composite | Preview modal | `asset:generate` |
| 9 | Create | 🚀 Create | `AssetService/Generate(type=merge)` | → Queue | `asset:generate` |

---

## 6. Edge Cases

| Edge Case | Handling |
|---|---|
| 20/20 media limit reached | Upload disabled: "Đạt giới hạn 20 file. [Xóa bớt để thêm]" |
| Single media file | Warning: "Multi-merge cần ít nhất 2 file. [Thêm media]" |
| Voice recording fail (mic denied) | Toast: "Không truy cập mic. [Cài đặt quyền] [Dùng AI voice]" |
| Mixed aspect ratios | Auto-crop/pad with black bars or blur: "Tự động điều chỉnh tỷ lệ" |
| Total duration > 5 min | Warning: "Tổng thời lượng dài. Ước tính {n} credits. [Tiếp tục?]" |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" | Auto-retry online |
| Upload failed | File error | Toast: "Không upload được {filename}. [Thử lại]" | Retry |
| AI voice-over failed | Service error | Toast: "Không tạo voice-over. [Thử lại] [Ghi âm thủ công]" | Fallback |
| AI music failed | Service error | Toast: "Không tạo nhạc. [Thử lại] [Upload nhạc]" | Fallback |
| Create video failed | Queue error | Banner: "Lỗi tạo video. Credits hoàn trả. [Thử lại]" | Retry |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Timeline items | `role="listbox"`, items as `role="option"` with drag `aria-label` |
| Drag-drop | `aria-grabbed`, `aria-dropeffect`, keyboard arrow keys to reorder |
| Transition markers | `aria-label="Chuyển cảnh: {type} giữa {item1} và {item2}"` |
| Voice recording | `aria-label="Ghi âm giọng"`, visual indicator + timer |
| Volume/pacing selectors | Standard form controls with `aria-label` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Drop zone + settings |
| Media upload | 1-5s per file | Progress bar per file |
| Timeline render | 200ms after upload | Items appear with stagger |
| Preview composite | 3-10s | Spinner in preview modal |
| AI voice/music | 10-20s | Progress in respective control |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `multi_merge.opened` | Page load | `source` |
| `multi_merge.media_added` | Upload/library | `media_count`, `media_types` |
| `multi_merge.reordered` | Drag-drop | `item_count` |
| `multi_merge.transition_changed` | Transition edit | `from_type`, `to_type` |
| `multi_merge.voice_recorded` | Mic recording | `duration` |
| `multi_merge.created` | Generate click | `media_count`, `duration`, `credits`, `platform` |
| `multi_merge.completed` | SSE complete | `total_time` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/studio/multi-merge/+page.svelte`
- **Timeline**: `SortableJS` for drag-drop reorder
- **Voice recording**: Browser `MediaRecorder` API
- **AI voice**: `AIService/GenerateVoice(character, script)` → audio
- **AI music**: `AIService/GenerateMusic(style, duration)` → audio
- **Preview**: Client-side composite via canvas/ffmpeg.wasm
- **Create**: `AssetService/Generate(type=merge)` → SSE progress

---

## 12. Localization Notes

- Actions: "Kéo thả media", "Ghi âm giọng", "Tạo video"
- Transitions: "Fade", "Cut", "Zoom", "Glitch", "Slide", "AI tự động"
- Duration: "Thời lượng mục tiêu", "Tự động điều chỉnh"
- Pacing: "Nhanh", "Trung bình", "Chậm"
- Aspect: "Dọc (TikTok)", "Ngang (YouTube)", "Vuông (Instagram)"

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-studio-merge` | Merge mode accent |
| `--color-timeline-item` | Timeline item bg |
| `--color-timeline-transition` | Transition marker |
| `--color-timeline-drag` | Dragging item highlight |
| `--color-recording` | Active recording indicator (red) |
| `--color-credit-warning` | Low credit warning |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Panels |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W024] AI Studio Launcher | Parent |
| [W038] Studio Queue | After creation |
| [M54] Mobile Multi-Merge | Mobile equivalent |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: 5 edge cases (media limit, mic), 5 errors, timeline accessibility, 7 analytics, SvelteKit impl (SortableJS, MediaRecorder), 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
