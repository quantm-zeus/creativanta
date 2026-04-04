# Screen: Web — Sound Studio

> **Screen ID**: W028
> **Module**: M07 — AI Studio
> **Route**: `/studio/sound`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 04, Product Freeze §15, A1 Schema (assets)

---

## 1. Purpose & Context

AI audio generation hub with 4 tabs: Music Generation, Beat Sync, Speech-to-Song, and SFX. Includes waveform editor for mixing voice, music, and effects with auto-duck feature.

### User Story
> As a creator, I want to add professional background music, sync beats to my cuts, and add sound effects without manual audio editing.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Studio   🎵 Sound Studio                       Credits: ~8       │
├──────────────────────────────────────────────────────────────────────┤
│ Tabs: [🎵 Music Gen] [🥁 Beat Sync] [🎤 Speech→Song] [🔊 SFX]    │
│                                                                      │
│ ── Music Generation Tab ──                                           │
│ ┌─ Input ────────────────────────────────────────────────────────┐  │
│ │ Video: [📎 Upload or select from library ▾]                    │  │
│ │ Style: [Pop ▾] [Lo-fi ▾] [Epic ▾] [Custom prompt]            │  │
│ │ Mood: [Energetic ○] [Calm ●] [Happy ○] [Dramatic ○]          │  │
│ │ Duration: [30s ▾]   BPM: [Auto ▾] or [120 ▾]                 │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Waveform Editor ──────────────────────────────────────────────┐  │
│ │ [Video waveform ═══════════════════════════]                    │  │
│ │ [Music waveform ───────────────────────────] (after gen)       │  │
│ │ [SFX layer     ·   ·       ·    ·         ] (optional)        │  │
│ │ Volume: Voice [█████████░] 80%                                 │  │
│ │         Music [██████░░░░] 60%                                 │  │
│ │         SFX   [████░░░░░░] 40%                                 │  │
│ │ [AI Auto-duck: ON ▾] — music dips during speech                │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ [▶ Preview — free] [🚀 Apply — 8 credits]                          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
SoundStudioPage
├── AppShell (shared)
├── PageHeader
├── TabContainer
│   ├── MusicGenerationTab
│   │   ├── VideoSelector
│   │   ├── StyleSelector (genre grid)
│   │   ├── MoodSelector
│   │   ├── DurationInput
│   │   └── BPMControl
│   ├── BeatSyncTab
│   │   ├── VideoSelector
│   │   ├── MusicSelector (existing or generate)
│   │   └── BeatDetectionPreview (visual beat markers)
│   ├── SpeechToSongTab
│   │   ├── VoiceUploader
│   │   ├── SongStyleSelector (Pop/R&B/Auto)
│   │   └── PreviewPlayer
│   └── SFXTab
│       ├── VideoSelector
│       ├── SceneAnalysis (detected scenes with suggested SFX)
│       └── SFXLibrary (Whoosh/Impact/Transition/Ambient)
├── WaveformEditor
│   ├── VideoWaveform
│   ├── MusicWaveform
│   ├── SFXLayer
│   ├── VolumeSliders
│   └── AutoDuckToggle
└── ActionBar (Preview, Apply)
```

---

## 4-5. Data & Actions

| # | Action | Tab | API | Credits | Result |
|---|---|---|---|---|---|
| 1 | Generate music | Music Gen | `AIService/GenerateMusic` | ~8 cr | Music track created |
| 2 | Beat sync | Beat Sync | `AIService/BeatSync` | ~5 cr | Video cut synced to beats |
| 3 | Speech to song | Speech→Song | `AIService/SpeechToSong` | ~15 cr | Voice → singing |
| 4 | Add SFX | SFX | `AIService/AddSFX` | ~5 cr | SFX applied to scenes |
| 5 | Auto-duck | Toggle | — (client) | 0 | Music dips during speech |
| 6 | Adjust volume | Sliders | — (client) | 0 | Mix updated |
| 7 | Apply | 🚀 Apply | `AssetService/Generate(type=sound)` | 8 cr | → Queue |

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| EMPTY | No video selected | Video selector per tab |
| LOADED | Video + audio settings ready | Waveform editor shows video track |
| GENERATING | AI audio processing | Spinner: "Đang tạo nhạc..." + progress |
| PREVIEW | Audio generated, mixing | Waveform shows all layers + play button |
| APPLIED | Audio exported | "✅ Âm thanh đã áp dụng!" → Queue |

---

## 7. Edge Cases

| Edge Case | Handling |
|---|---|
| Browser no Web Audio API | Fallback: "Trình duyệt không hỗ trợ. Dùng Chrome/Edge." |
| Video has no audio track | Info: "Video không có âm thanh. Voice-over available." |
| Generated music > video duration | Auto-trim to video length |
| Speech-to-song: unclear speech | Warning: "Giọng nói không rõ. [Upload lại] [Tiếp tục]" |
| SFX scene detection fails | Fallback: manual SFX placement timeline |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" | Auto-retry online |
| Music gen failed | API error | Toast: "Không tạo nhạc. Credits hoàn trả. [Thử lại]" | Retry |
| Beat sync failed | Timing error | Toast: "Không đồng bộ nhịp. [Thử lại với BPM khác]" | Retry |
| Speech-to-song failed | AI error | Toast: "Không tạo bài hát. [Thử lại]" | Retry |
| Apply failed | Export error | Toast: "Không áp dụng âm thanh. [Thử lại]" | Retry |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Tab container | `role="tablist"`, tabs with `role="tab"`, panels `role="tabpanel"` |
| Waveform editor | `aria-label="Trình biên tập waveform"`, keyboard scrub |
| Volume sliders | `role="slider"`, `aria-label="{layer}: {volume}%"`, `aria-valuemin/max/now` |
| Auto-duck toggle | `aria-checked`, `aria-label="Tự động giảm nhạc khi có giọng nói"` |
| Play/stop | Standard media controls, keyboard space for play/pause |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Tab container + video selector |
| Video load | 1-3s | Video waveform renders |
| Music generation | 10-20s | Progress spinner in music track |
| Beat detection | 5-10s | Beat markers appear on timeline |
| SFX scene analysis | 5-10s | Scene markers appear |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `sound.opened` | Page load | `source`, `initial_tab` |
| `sound.music_generated` | Music gen complete | `style`, `mood`, `bpm`, `credits` |
| `sound.beat_synced` | Beat sync complete | `credits` |
| `sound.speech_to_song` | Song created | `credits` |
| `sound.sfx_added` | SFX placed | `sfx_count`, `credits` |
| `sound.mix_adjusted` | Volume changed | `voice_vol`, `music_vol`, `sfx_vol`, `auto_duck` |
| `sound.applied` | Export | `tab`, `credits_total` |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/studio/sound/+page.svelte`
- **Waveform**: `wavesurfer.js` for visualization + playback
- **Auto-duck**: Web Audio API `GainNode` with speech detection envelope
- **Music gen**: `AIService/GenerateMusic(style, mood, bpm, duration)` → audio file
- **Beat sync**: `AIService/BeatSync(video_id, music_id)` → synced cut points
- **Speech-to-song**: `AIService/SpeechToSong(voice_audio, style)` → song file
- **SFX**: `AIService/AnalyzeScenes(video_id)` → scene markers + suggested SFX
- **Mix**: Client-side Web Audio API for real-time preview, server-side for final render

---

## 13. Localization Notes

- Tabs: "🎵 Tạo nhạc", "🥁 Đồng bộ nhịp", "🎤 Lời→Bài hát", "🔊 Hiệu ứng"
- Style: "Pop", "Lo-fi", "Hùng tráng", "Tùy chỉnh"
- Mood: "Năng động", "Nhẹ nhàng", "Vui vẻ", "Kịch tính"
- Mixer: "Giọng nói", "Nhạc nền", "Hiệu ứng", "Tự động giảm nhạc"
- Actions: "Xem trước", "Áp dụng"

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-studio-sound` | Sound mode accent |
| `--color-waveform-video` | Video waveform color |
| `--color-waveform-music` | Music waveform color |
| `--color-waveform-sfx` | SFX layer color |
| `--color-beat-marker` | Beat sync marker |
| `--color-tab-active` | Active tab indicator |
| `--color-tab-inactive` | Inactive tab |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Panels |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W021] Studio Launcher | Parent |
| [W022] Quick Edit | Audio integration |
| [M013] Mobile Studio Launcher | Mobile equivalent (sound via studio) |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: 5 states, 5 edge cases (Web Audio), 5 errors, waveform accessibility, 7 analytics, SvelteKit impl (wavesurfer.js, Web Audio API), 9 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
