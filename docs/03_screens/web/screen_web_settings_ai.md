# Screen: Web — Settings: AI Preferences

> **Screen ID**: W123
> **Module**: M23 — Settings
> **Route**: `/settings/ai`
> **Platform**: Web (SvelteKit)
> **Upstream**: PRD §27, A1 Schema (ai_preferences, ai_models), B5 RBAC §2.9

---

## 1. Purpose & Context

AI behavior preferences — default generation quality, credit usage limits, voice/style defaults, and AI model preferences per feature. Controls how all AI features behave workspace-wide.

### User Goals
- Set default AI quality level (draft vs premium)
- Configure credit usage alerts and spending caps
- Set default voice and tone for AI-generated content
- Choose preferred AI models for different tasks

### Business Goals
- Give users control over AI spending
- Optimize credit usage with quality/cost tradeoffs
- Ensure consistent AI output style across workspace
- Future-proof model selection for upgrades

### Entry Points
- Sidebar: Settings → "🤖 AI Preferences"
- AI Studio: "⚙️ Settings" gear icon

### Exit Points
- "Link to Brand Settings →" → Brand Voice settings
- Self-contained settings page

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Settings   🤖 AI Preferences                                     │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Generation Quality ─────────────────────────────────────────┐    │
│ │ Default quality:                                               │    │
│ │ [○ Draft] — Fastest, low cost (1-3 credits)                    │    │
│ │ [● Standard] — Balanced quality/speed (3-10 credits)          │    │
│ │ [○ Premium] — Best quality, slower (10-25 credits)             │    │
│ │                                                                │    │
│ │ Auto-enhance: [🟢 ON]                                         │    │
│ │ Automatically improve generated content quality               │    │
│ │ Auto-subtitle: [🟢 ON]                                        │    │
│ │ Generate subtitles for all video content                       │    │
│ │ Auto-thumbnail: [🔴 OFF]                                      │    │
│ │ Generate thumbnails for video content                          │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Credit Usage Controls ──────────────────────────────────────┐    │
│ │ Monthly alert at: [80 ▾] % of credits                         │    │
│ │ Notify via: [☑ In-app] [☑ Email] [☐ Push]                    │    │
│ │                                                                │    │
│ │ Hard stop at:                                                  │    │
│ │ [○ Never — use all credits] [● 95%] [○ Custom: ___%]         │    │
│ │ ℹ️ Hard stop prevents accidental credit depletion              │    │
│ │                                                                │    │
│ │ Auto-purchase: [🔴 OFF]                                        │    │
│ │ When enabled, auto-buy 100 credits at threshold               │    │
│ │ [→ Configure auto-purchase in Credit Settings]                 │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Default Voice & Style ──────────────────────────────────────┐    │
│ │ TTS voice: [Vietnamese Female — Natural ▾]                     │    │
│ │ Preview: [▶️ Play sample]                                      │    │
│ │                                                                │    │
│ │ Caption tone: [Casual ▾]                                       │    │
│ │ Options: Formal / Casual / Playful / Professional             │    │
│ │                                                                │    │
│ │ Brand voice: [→ Brand Voice Settings (Brand Settings page)]    │    │
│ │                                                                │    │
│ │ Style pack: [None ▾]                                           │    │
│ │ Options: None / Minimalist / Vibrant / Corporate              │    │
│ │ Style packs control visual defaults for AI image generation   │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Model Preferences (Advanced) ──────────────────────────────┐     │
│ │ ℹ️ Choose preferred AI models. "Auto" selects best for task.  │    │
│ │                                                                │    │
│ │ Feature          │ Model                │ Credits/use          │    │
│ │ ─────────────────┼──────────────────────┼─────────────         │    │
│ │ Text generation  │ [Gemini Pro ▾]       │ ~2-5 cr              │    │
│ │ Script writing   │ [Gemini Pro ▾]       │ ~3-8 cr              │    │
│ │ Image generation │ [Stable Diffusion XL ▾] │ ~5-10 cr          │    │
│ │ Video editing    │ [Auto-select ▾]      │ ~10-25 cr            │    │
│ │ Music/SFX        │ [Suno v3 ▾]          │ ~5-8 cr              │    │
│ │ Voice/TTS        │ [ElevenLabs ▾]       │ ~2-3 cr              │    │
│ │ Translation      │ [Gemini Pro ▾]       │ ~1-2 cr              │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ [💾 Lưu thay đổi] [🔄 Reset to defaults]                          │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
AIPreferencesPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Settings")
│   └── PageTitle ("🤖 AI Preferences")
├── GenerationQualitySection
│   ├── QualityRadioGroup (Draft / Standard / Premium)
│   │   └── CostRange per option
│   ├── AutoEnhanceToggle + Description
│   ├── AutoSubtitleToggle + Description
│   └── AutoThumbnailToggle + Description
├── CreditUsageSection
│   ├── AlertThresholdInput (%)
│   ├── NotifyChannels (In-app, Email, Push checkboxes)
│   ├── HardStopRadioGroup (Never / 95% / Custom)
│   ├── HardStopExplanation
│   └── AutoPurchaseToggle + ConfigLink
├── VoiceStyleSection
│   ├── TTSVoiceSelector + AudioPreview
│   ├── CaptionToneSelector (Formal/Casual/Playful/Professional)
│   ├── BrandVoiceLink (→ Brand Settings)
│   └── StylePackSelector + StylePackDescription
├── ModelPreferencesSection (Advanced, collapsible)
│   └── ModelTable
│       └── ModelRow[] (feature, model selector, credit range)
├── ActionBar
│   ├── SaveButton
│   └── ResetButton
```

---

## 5. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Section skeletons |
| LOADED | Preferences loaded | Interactive settings form |
| SAVING | Save in progress | Save button spinner |
| SAVED | Just saved | Toast: "✅ AI preferences đã cập nhật" |
| ERROR | Save failed | Error with retry |

---

## 6. Permissions

| Feature | Owner | Admin | Manager+ |
|---|---|---|---|
| View preferences | ✅ | ✅ | ✅ |
| Edit quality/voice | ✅ | ✅ | ❌ |
| Edit credit limits | ✅ | ✅ | ❌ |
| Change models | ✅ | ✅ | ❌ |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached preferences | Retry online |
| Model unavailable | Selected model deprecated/removed | Warning on model row: "⚠ Model này sẽ ngừng hỗ trợ. [Chọn model khác]" | Auto-select |
| Hard stop triggered | Credit usage ≥ threshold | Banner: "🛑 Đã đạt giới hạn credit. AI tạm tắt. [Mua thêm]" | Buy credits |
| Voice preview fail | TTS service error | Toast: "Không phát được sample. [Thử lại]" | Retry |
| Save fail | API error | Toast: "Không lưu được. [Thử lại]" | Retry |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Quality radio group | `role="radiogroup"`, `aria-label="Default generation quality"`, each option `aria-describedby` with cost |
| Toggles | `role="switch"`, `aria-checked`, `aria-label="Auto-enhance: {on/off}"` |
| Alert threshold input | `<label>` linked, `aria-describedby` with explanation |
| Model table | `role="table"`, `aria-label="AI model preferences by feature"` |
| Voice preview | `aria-label="Play voice sample: {voice_name}"` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Section skeletons |
| Preferences | 200-400ms | Form fields populate |
| Model list | 300-600ms | Model dropdowns populate |
| Voice samples | 400-800ms | Audio preview buttons active |
| Save | 500-2000ms | Button spinner → toast |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `settings_ai.viewed` | Page load | `quality_level`, `credit_alert_threshold` |
| `settings_ai.quality_changed` | Quality radio change | `old_quality`, `new_quality` |
| `settings_ai.toggle_changed` | Auto-enhance/subtitle/thumbnail toggled | `toggle_name`, `new_value` |
| `settings_ai.alert_changed` | Alert threshold updated | `old_threshold`, `new_threshold` |
| `settings_ai.hard_stop_changed` | Hard stop setting changed | `old_value`, `new_value` |
| `settings_ai.model_changed` | Model selector changed | `feature`, `old_model`, `new_model` |
| `settings_ai.voice_previewed` | "▶️ Play sample" | `voice_name` |
| `settings_ai.reset_defaults` | "🔄 Reset" | — |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/settings/ai/+page.svelte`
- **Server load**: `+page.server.ts` → `AIPreferenceService/Get(workspace_id)` + `ModelService/ListAvailable`
- **Form**: `copilot:use_creative` with progressive enhancement
- **Model availability**: Server filters deprecated models, shows migration notice
- **Voice preview**: Client-side `<audio>` with lazy-loaded sample URL from TTS service
- **Save**: Single "Lưu thay đổi" — all sections saved together
- **Reset**: Confirm modal → `AIPreferenceService/ResetDefaults(workspace_id)`
- **Credit hard stop**: Enforced server-side; client shows banner when activated

---

## 12. Localization Notes

- Quality: "Nháp", "Tiêu chuẩn", "Cao cấp"
- Toggles: "Tự động cải thiện", "Tự động phụ đề", "Tự động thumbnail"
- Credits: "credits/lần sử dụng"
- Models: English names (Gemini Pro, Stable Diffusion XL, ElevenLabs)
- Tone: "Trang trọng", "Thân mật", "Hài hước", "Chuyên nghiệp"
- Tone: Technical, helpful

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-accent` | Save CTA, quality radio active |
| `--color-success` | Toggle ON state |
| `--color-warning` | Credit alert threshold, depletion warning |
| `--color-danger` | Hard stop banner |
| `--color-surface-elevated` | Section cards |
| `--color-text-secondary` | Cost hints, model descriptions |
| `--color-ai-accent` | 🤖 AI feature highlight |
| `--font-metric` | Credit numbers (tabular-nums) |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W128] Credit Purchase | Buy more credits |
| [W021] Studio Launcher | Where AI features are used |
| [W114] Workspace Settings | General settings |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (model unavailable, hard stop), radio/toggle a11y, 8 analytics, SvelteKit impl, localization, 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
