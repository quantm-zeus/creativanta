# Screen: Web — AI Video Agent

> **Screen ID**: W031
> **Module**: M07 — AI Studio
> **Route**: `/studio/agent`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 04, Product Freeze §15, A1 Schema (assets, generation_queue)

---

## 1. Purpose & Context

1-click full pipeline — describe what you want → AI handles entire production from script to ready-to-publish. The most powerful and expensive studio mode: text prompt → complete video with script, visuals, voice-over, music, and captions.

### User Story
> As a creator, I want to describe a video concept in plain text and have AI produce a complete, publish-ready video automatically.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Studio   🤖 Video Agent                         Credits: ~50     │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Prompt Input ─────────────────────────────────────────────────┐  │
│ │ Mô tả video bạn muốn:                                         │  │
│ │ [Review serum Vitamin C 30ml, phong cách                    ]  │  │
│ │ [trẻ trung năng động, target TikTok 18-25 tuổi            ]  │  │
│ │                                                                  │  │
│ │ Quick suggestions:                                               │  │
│ │ [📝 Product review] [🎯 Tutorial] [📊 Top 5 listicle]        │  │
│ │ [😂 Funny reaction] [📖 Storytelling] [🔥 Trend response]    │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Options ──────────────────────────────────────────────────────┐  │
│ │ Character: [Mila ▾]  Brand Pack: [My Brand ▾]                 │  │
│ │ Product: [Serum Vitamin C ▾]                                   │  │
│ │ Duration: [30s ▾]  Platform: [☑ TikTok] [☐ YouTube]          │  │
│ │ Style Pack: [My Skincare Style ▾]                              │  │
│ │ Quality: [● Standard ~30cr] [○ Premium ~60cr]                  │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ [🚀 Generate Video — ~50 credits]                                   │
│                                                                      │
│ ── Pipeline Progress (after generate) ──                             │
│ ┌────────────────────────────────────────────────────────────────┐  │
│ │ ✅ Script generated (3s)                                       │  │
│ │ ✅ Scenes planned (2s)                                         │  │
│ │ ████████░░ Generating visuals... (Scene 3/5)                   │  │
│ │ ○ Voice-over                                                    │  │
│ │ ○ Music & SFX                                                   │  │
│ │ ○ Assembly & export                                             │  │
│ │ Estimated: ~3 minutes                                           │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ── After completion ──                                               │
│ [Video preview player]                                               │
│ [📤 Publish] [✏ Edit in Quick Edit] [🔄 Regenerate] [📥 Download] │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
VideoAgentPage
├── AppShell (shared)
├── PageHeader
├── PromptInput
│   ├── Textarea (auto-resize, max 1000 chars)
│   └── QuickSuggestionChips
├── OptionsForm
│   ├── CharacterSelector
│   ├── BrandPackSelector
│   ├── ProductSelector (optional)
│   ├── DurationSelector
│   ├── PlatformCheckboxes
│   ├── StylePackSelector (optional)
│   └── QualitySelector (Standard/Premium)
├── GenerateButton (credit cost displayed)
├── PipelineProgress (shown during generation)
│   └── StageItem[] (with ✅/████/○ indicators)
│       ├── ScriptGeneration
│       ├── ScenePlanning
│       ├── VisualGeneration (with scene counter)
│       ├── VoiceOver
│       ├── MusicSFX
│       └── AssemblyExport
└── CompletionView
    ├── VideoPreviewPlayer
    └── ActionButtons (Publish, Edit, Regenerate, Download)
```

---

## 4-5. Data & Actions

| # | Action | Trigger | API | Credits | Result |
|---|---|---|---|---|---|
| 1 | Generate | 🚀 Generate | `AssetService/Generate(type=video_agent)` | 30-60 cr | Pipeline starts |
| 2 | Publish | "📤 Publish" | — | 0 | → Publish flow |
| 3 | Edit | "✏ Edit" | — | 0 | → Quick Edit with video loaded |
| 4 | Regenerate | "🔄 Regenerate" | Same API | Same cr | New version generated |
| 5 | Download | "📥 Download" | Direct URL | 0 | File download |

---

## 6. Edge Cases

| Edge Case | Handling |
|---|---|
| Prompt too vague (< 10 chars) | Inline: "Mô tả chi tiết hơn để AI tạo video tốt hơn" |
| Prompt > 1000 chars | Input maxlength enforced: "Tối đa 1000 ký tự" |
| Pipeline fails at visual stage | Partial refund: "Lỗi tại bước 3. Hoàn 80% credits. [Thử lại]" |
| Character not available (deleted) | Fallback: "Character đã bị xóa. [Chọn character khác]" |
| Premium quality, insufficient credits | Show both options: "Standard 30cr ✅ / Premium 60cr ❌ (Thiếu {n})" |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" | Auto-retry online |
| Pipeline failed | Any stage error | Banner: "Lỗi tại bước {stage}. Credits hoàn trả. [Thử lại]" | Retry |
| SSE connection lost | Network issue | Banner: "Mất kết nối. [Reconnect]" — auto-reconnect 3x | Auto-reconnect |
| Publish failed | Platform error | Toast: "Không đăng được. [Thử lại] [Lưu video]" | Retry / save |
| Regenerate failed | Credit check | Toast: "Không đủ credits cho bản mới. [Mua thêm]" | Buy credits |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Prompt textarea | `aria-label="Mô tả video bạn muốn tạo"`, char counter announced |
| Quick suggestion chips | `role="list"`, chips as `role="listitem"` buttons |
| Pipeline progress | `role="list"`, stages as `role="listitem"` with `aria-current="step"` |
| Stage status | `aria-label="Bước {n}: {name} — {status}"` (✅/đang/chờ) |
| Completion actions | Standard buttons with descriptive `aria-label` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Prompt input + options |
| Options load | 200ms | Character/brand/style selectors |
| Pipeline start | 0ms | Progress panel replaces options |
| Script (stage 1) | 3-5s | ✅ checkmark |
| Visual gen (stage 3) | 60-120s | Progress bar with scene counter |
| Total pipeline | 100-200s | All stages complete → video player |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `video_agent.opened` | Page load | `source` |
| `video_agent.started` | Generate clicked | `prompt_length`, `character`, `quality`, `platform`, `credits` |
| `video_agent.stage_completed` | Stage done | `stage`, `duration` |
| `video_agent.completed` | Pipeline done | `total_time`, `quality`, `credits_used` |
| `video_agent.published` | Publish clicked | `platform` |
| `video_agent.edited` | Edit in Quick Edit | `video_id` |
| `video_agent.regenerated` | Regenerate | `credits` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/studio/agent/+page.svelte`
- **Generate**: `AssetService/Generate(type=video_agent, prompt, options)` → SSE
- **SSE progress**: `/events/assets/{job_id}` → 6-stage pipeline updates
- **Quality tiers**: Standard (faster, 720p) / Premium (1080p, better audio)
- **Character**: `CharacterService/Get(id)` for voice + visual
- **Style pack**: `StylePackService/Get(id)` for consistency
- **Post-gen**: Video available in Asset Library, publish via PublishService

---

## 12. Localization Notes

- Prompt placeholder: "Mô tả video bạn muốn: review sản phẩm, hướng dẫn, top 5..."
- Quick suggestions: "📝 Review sản phẩm", "🎯 Hướng dẫn", "📊 Top 5", "😂 Vui nhộn", "📖 Kể chuyện", "🔥 Theo trend"
- Quality: "Chuẩn (~30 cr)", "Cao cấp (~60 cr)"
- Pipeline: "Tạo kịch bản", "Lên kế hoạch cảnh", "Tạo hình ảnh", "Giọng đọc", "Nhạc & hiệu ứng", "Ghép & xuất"
- Status: "Ước tính: ~3 phút"

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-studio-agent` | Agent mode accent (premium feel) |
| `--color-pipeline-complete` | Completed stage (green check) |
| `--color-pipeline-active` | Active stage (blue progress) |
| `--color-pipeline-pending` | Pending stage (gray) |
| `--color-quality-standard` | Standard tier |
| `--color-quality-premium` | Premium tier (gold) |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W021] Studio Launcher | Parent |
| [W022] Quick Edit | Post-generation editing |
| [W053] Publish Queue | Publish target |
| [W030] Studio Queue | Job tracking |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: 5 edge cases (prompt, partial failure), 5 errors, pipeline accessibility, 7 analytics, SvelteKit impl (SSE pipeline), 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
