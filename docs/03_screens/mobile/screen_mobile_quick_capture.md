# Screen: Mobile — Quick Capture

> **Screen ID**: M004
> **Module**: M05 — Content Pipeline
> **Route**: `/capture` (mobile overlay)
> **Platform**: Mobile (Flutter)
> **Upstream**: A1 Schema (ideas, quick_captures), B5 RBAC §2.7

---
## 1. Purpose & Context

Ultra-fast idea capture — text, voice memo, or photo, designed to save in under 3 seconds. Captures inspiration anytime, anywhere. Opens as a modal overlay (not a full page) to minimize context switching.

### Entry Points
- Home widget: "💡 Quick idea?" shortcut
- Camera shortcut: Long-press camera on home screen widget
- Push: "💡 Chưa ghi ý tưởng hôm nay? Capture ngay!"
- FAB from Idea Board (M017): "+" button

### Exit Points
- "💾 Save" → toast "✅ Đã lưu!" → dismiss to previous screen
- "✕ Close" → dismiss without saving (confirm if content entered)

---
## 2. Preconditions / Postconditions

### Preconditions
- `idea:create` permission (Contributor+)
- Microphone permission for voice mode · Camera permission for photo mode

### Postconditions
- New `ideas` record created with status "inbox", position 0
- If voice → audio file uploaded + AI transcription stored
- Capture logged for analytics

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│                                                           [✕ Close] │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Capture Modes ───────────────────────────────────────────────┐   │
│ │ [📝 Text •] [🎤 Voice] [📸 Photo]                            │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── Text Mode (default) ──                                            │
│ ┌─────────────────────────────────────────────────────────────────┐ │
│ │ Ghi ý tưởng nhanh...                                          │ │
│ │                                                                 │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ Tags: [🏷 cooking ✕] [+ Thêm tag]                                  │
│ Platform: [🎵 TikTok ▾]                                            │
│                                                                      │
│ ── Voice Mode ──                                                     │
│ [🔴 Đang ghi... 00:15]  [⏹ Dừng]                                  │
│ AI tự chuyển thành text khi dừng                                    │
│                                                                      │
│ ── Photo Mode ──                                                     │
│ [📸 Camera / Chọn ảnh]                                              │
│ Caption: [Ghi chú thêm...                                       ]  │
│                                                                      │
│ [💾 Lưu vào Idea Board]                                             │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
QuickCapturePage (modal overlay, not full page)
├── DragHandle (modal sheet indicator)
├── CloseButton ("✕")
├── ModeSelector (SegmentedControl)
│   ├── TextModeTab ("📝 Text")
│   ├── VoiceModeTab ("🎤 Voice")
│   └── PhotoModeTab ("📸 Photo")
├── ModeContent (switches per mode)
│   ├── TextModeContent
│   │   ├── TextInput (multiline, auto-focus, max 2000 chars)
│   │   ├── TagInput (chip input, max 10 tags)
│   │   └── PlatformSelector (dropdown)
│   ├── VoiceModeContent
│   │   ├── RecordingIndicator ("🔴 Đang ghi... 00:15")
│   │   ├── WaveformVisualizer (animated)
│   │   ├── StopButton ("⏹ Dừng")
│   │   └── TranscriptionResult (appears after stop)
│   └── PhotoModeContent
│       ├── PhotoPicker (camera or gallery)
│       ├── PhotoPreview (thumbnail)
│       └── CaptionInput (optional text)
└── SaveButton ("💾 Lưu vào Idea Board")
```

---
## 5. Data Binding & Display Format

| Element | Source | API | Format | Cache |
|---|---|---|---|---|
| Tags autocomplete | `idea_tags` distinct | `IdeaService/GetTags()` | Chip suggestions | 10m |
| Platform options | Workspace connected platforms | Session data | Dropdown | Static |
| Voice transcription | On-device STT | `speech_to_text` package | Text result | — |

---
## 6. Actions Table

| # | Action | Trigger | API Call | Permission |
|---|---|---|---|---|
| 1 | Switch to text mode | Tap "📝" tab | — | Any |
| 2 | Switch to voice mode | Tap "🎤" tab | — | Any |
| 3 | Switch to photo mode | Tap "📸" tab | — | Any |
| 4 | Type idea | Type in text field | — | `idea:create` |
| 5 | Start recording | Enter voice mode / tap record | On-device STT | `idea:create` |
| 6 | Stop recording | Tap "⏹" | AI transcription | `idea:create` |
| 7 | Capture/select photo | Camera shutter or gallery | Upload to CDN | `idea:create` |
| 8 | Add tag | Type + enter on tag input | — | `idea:create` |
| 9 | Select platform | Tap dropdown | — | `idea:create` |
| 10 | Save | "💾 Lưu" | `IdeaService/Create(title, desc, platform, tags, media_url)` | `idea:create` |
| 11 | Close | "✕" | — (confirm if content) | Any |

---
## 7. Validation Rules

| Field | Rule | Error |
|---|---|---|
| Text content | Min 3 chars (text mode) | "Nhập ít nhất 3 ký tự" |
| Text max | Max 2000 chars | "Tối đa 2000 ký tự" |
| Voice duration | Max 120 seconds | Auto-stop at 120s |
| Photo | Max 10MB, JPG/PNG/WebP | "File quá lớn hoặc định dạng không hỗ trợ" |
| Tags | Max 10, 2-30 chars each | "Tối đa 10 tags" |

---
## 8. States

| State | Condition | Visual |
|---|---|---|
| TEXT_MODE | Default open | Text input auto-focused, keyboard visible |
| VOICE_IDLE | Voice tab selected, not recording | "Nhấn để bắt đầu ghi âm" |
| VOICE_RECORDING | Recording active | "🔴 Đang ghi..." + waveform + timer |
| VOICE_TRANSCRIBING | AI processing audio | "🤖 Đang chuyển thành text..." spinner |
| VOICE_DONE | Transcription complete | Text result shown (editable) |
| PHOTO_IDLE | Photo tab selected | Camera/gallery picker |
| PHOTO_PREVIEW | Photo selected | Thumbnail preview + caption input |
| SAVING | Submitting | Save button shows spinner |
| SAVED | Success | "✅ Đã lưu!" toast → auto-dismiss after 1.5s |
| ERROR | Save failed | Toast: "Không lưu được. [Thử lại]" |

---
## 9. Permissions & Role-based Behavior

| Action | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| Open capture | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Save idea | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Voice capture | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

---
## 10. Mobile-specific UX

### Gestures & Haptics
| Gesture | Haptic | Result |
|---|---|---|
| Tap save | Success vibration | Idea saved, modal dismisses |
| Recording start | Heavy | Confirm recording active |
| Recording stop | Medium | Confirm recording stopped |
| Swipe down modal | — | Dismiss (confirm if content) |

### Performance Target: <3 seconds from open to saved
### Keyboard: Auto-shows on text mode open. Dismisses on voice/photo switch.
### Offline: Text/voice captured locally → queued for sync. Banner: "📡 Sẽ đồng bộ khi có mạng"

---
## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| Save while offline | Queue locally, sync when online. Badge: "1 đang chờ" |
| Voice permission denied | "🎤 Cần quyền microphone. [Mở Settings →]" |
| Camera permission denied | "📸 Cần quyền camera. [Mở Settings →]" |
| Accidental close | If content entered, confirm: "Bỏ ý tưởng?" |
| Voice transcription fails | Show "Không nhận được giọng nói. [🎤 Thử lại]" |

---
## 12. Error Handling

| Error | UI Response | Recovery |
|---|---|---|
| Save failed | Toast: "Không lưu được" | Retry button |
| Upload failed | Toast: "Upload ảnh thất bại" | Retry |
| STT failed | "Không chuyển được giọng nói" | Retry or type manually |
| Offline | Queue locally + banner | Auto-sync |

---
## 13. Accessibility

| Element | Requirement |
|---|---|
| Mode tabs | `Semantics(selected, label: "Chế độ text, đang chọn")` |
| Record button | `Semantics(button, label: "Bắt đầu ghi âm")` |
| Save button | `Semantics(button, label: "Lưu ý tưởng"), min 48dp` |
| Text input | `Semantics(textField, hint: "Ghi ý tưởng nhanh")` |

---
## 14. Analytics / Tracking Events

| Event | Properties |
|---|---|
| `capture.opened` | `source`, `mode` |
| `capture.saved` | `mode`, `char_count`, `has_tags`, `has_photo`, `platform` |
| `capture.voice_duration` | `duration_seconds` |
| `capture.abandoned` | `mode`, `had_content` |

---
## 15. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Save button, active mode tab |
| `--color-danger` | Recording indicator (🔴) |
| `--color-success` | Saved toast (✅) |
| `--color-surface-elevated` | Modal background |

---
## 16. Related Screens

| Screen | Relationship |
|---|---|
| [M017] Idea Board | Destination for saved ideas |
| [M001] Home Dashboard | Entry via widget shortcut |
| [W010] Web Idea Board | Web equivalent (inline create) |

---
## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 2.0 | **Full Tier A rewrite** from Tier C. Added 17-section structure: mode switching, voice STT, photo capture, specific validation, 10 states, RBAC, offline queue, edge cases, accessibility, analytics. Replaced ALL template placeholders. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
