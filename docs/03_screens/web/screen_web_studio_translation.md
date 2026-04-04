# Screen: Web — Translation Studio

> **Screen ID**: W033
> **Module**: M07 — AI Studio
> **Route**: `/studio/translate`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 04, A1 Schema (assets)

---

## 1. Purpose & Context

Translate existing videos into other languages. AI replaces voice-over with translated speech (lip-sync optional), translates on-screen text/captions, and adapts cultural references.

### User Story
> As a creator expanding to new markets, I want to translate my Vietnamese videos into English (or vice versa) while keeping natural-sounding voice-over.

---

## 2-5. Layout & Actions

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Studio   🌐 Translation Studio                  Credits: ~20     │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Source Video ─────────────────────────────────────────────────┐  │
│ │ [📎 Upload video or select from library ▾]                     │  │
│ │ Detected language: Vietnamese 🇻🇳                               │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Translation Settings ─────────────────────────────────────────┐  │
│ │ Target: [🇺🇸 English ▾] [🇯🇵 Japanese ▾] [🇰🇷 Korean ▾] [+ Add]│  │
│ │ Voice: [● Same voice (cloned) ○ New character ▾]              │  │
│ │ Lip sync: [☑ Enabled (+10 cr)]                                │  │
│ │ On-screen text: [☑ Translate captions] [☑ Translate overlays] │  │
│ │ Cultural adaptation: [☑ Localize references]                  │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Script Review ────────────────────────────────────────────────┐  │
│ │ Original (VN)          │ Translation (EN)                      │  │
│ │ "Xin chào các bạn"     │ "Hey everyone"                       │  │
│ │ "Hôm nay review serum" │ "Today I'm reviewing this serum"     │  │
│ │ [✏ Edit translation]                                           │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ [▶ Preview — free] [🚀 Translate — 20-30 credits]                  │
└──────────────────────────────────────────────────────────────────────┘
```

### Actions
| # | Action | Credits | Result |
|---|---|---|---|
| 1 | Upload/select video | 0 | Language detected, transcript extracted |
| 2 | Select target languages | 0 | Translation preview generated |
| 3 | Edit translations | 0 | Manual corrections |
| 4 | Translate | ~20-30 cr per language | → Queue |

---

## 4. Component Hierarchy
```
TranslationStudioPage
├── AppShell (shared)
├── PageHeader (BackButton, Title, CreditBalance)
├── SourceVideoSection
│   ├── VideoUploader / LibrarySelector
│   └── DetectedLanguageBadge
├── TranslationSettingsForm
│   ├── TargetLanguageChips (multi-select + add)
│   ├── VoiceSelector (cloned / new character)
│   ├── LipSyncToggle (+10 cr)
│   ├── CaptionTranslateToggle
│   ├── OverlayTranslateToggle
│   └── CulturalAdaptationToggle
├── ScriptReviewPanel (side-by-side)
│   ├── OriginalColumn (read-only)
│   └── TranslationColumn[] (per language, editable)
└── ActionBar (Preview — free, Translate — credits)
```

---

## 5. Credit Estimation

| Feature | Credits | Notes |
|---|---|---|
| Base translation | ~20 cr/language | For 60s video |
| Lip sync add-on | +10 cr/language | AI mouth adjustment |
| Cultural adaptation | +5 cr/language | Reference localization |
| Multi-language discount | -10% per additional | Max 30% discount |

Formula: `total = languages × (base + lip_sync + cultural) × (1 - discount)`

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| EMPTY | No video selected | Upload zone + "Chọn video để bắt đầu" |
| ANALYZING | Video uploaded | Spinner: "🔍 Đang phân tích ngôn ngữ..." |
| CONFIGURED | Languages selected | Script review panel + settings |
| TRANSLATING | Job submitted | SSE progress: "Đang dịch... 45%" + step indicators |
| COMPLETE | Translation done | "✅ Bản dịch sẵn sàng!" + preview + download links |

---

## 7. Edge Cases

| Edge Case | Handling |
|---|---|
| Video has no speech | Warning: "Video không có lời nói — chỉ dịch phụ đề và overlay" |
| Unsupported language pair | Disable language chip: "Chưa hỗ trợ {lang}. [Yêu cầu]" |
| Video > 10 min | Warning: "Video dài — ước tính {n} credits. [Tiếp tục?]" |
| Translation edit changes meaning | AI diff check: "⚠️ Bản dịch khác biệt đáng kể so với gốc" |
| Insufficient credits | CTA disabled: "Cần thêm {n} credits. [Mua credits]" |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — không thể dịch" | Auto-retry online |
| Upload failed | File too large / format | Toast: "Không upload được. Tối đa 500MB, MP4/MOV" | Retry with valid file |
| Translation failed | AI service error | Banner: "Lỗi dịch thuật. Credits không bị trừ. [Thử lại]" | Retry (credits refunded) |
| Voice cloning failed | Voice model error | Toast: "Không nhân bản giọng được. Dùng giọng mặc định?" | Fallback voice |
| Lip sync failed | Partial failure | Toast: "Lip sync không thành công. Video vẫn có voice-over" | Accept without lip sync |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Script review columns | `role="region"`, `aria-label="Bản gốc {lang}"` / `"Bản dịch {lang}"` |
| Language chips | `role="group"`, `aria-label="Ngôn ngữ đích"`, chips with `aria-selected` |
| Credit display | `aria-live="polite"` — updates when options change |
| Progress bar (translating) | `role="progressbar"`, `aria-valuenow`, `aria-label="Tiến trình dịch"` |
| Toggle switches | `aria-checked`, descriptive labels |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Upload zone + settings skeleton |
| Video analysis | 2-5s | Spinner: "Đang phân tích..." |
| Script extraction | 3-8s | Original column populates line-by-line |
| Translation preview | 1-2s per lang | Translation column populates |
| Generation progress | 30s-3min | SSE progress bar with step labels |

---

## 11. Performance Requirements

| Metric | Target |
|---|---|
| Page load | < 1.5s |
| Video upload | Chunked, resumable |
| Script extraction | < 10s for 60s video |
| Translation preview | < 3s per language |
| SSE latency | < 500ms update interval |

---

## 12. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `translate.opened` | Page load | `source` (launcher/library) |
| `translate.video_uploaded` | Video selected | `duration`, `detected_language` |
| `translate.languages_selected` | Languages chosen | `target_languages`, `count` |
| `translate.script_edited` | Manual edit | `language`, `edit_count` |
| `translate.started` | Generate clicked | `languages`, `lip_sync`, `credits_used` |
| `translate.completed` | SSE complete | `duration`, `languages_count` |
| `translate.failed` | Error | `error_type` |

---

## 13. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/studio/translate/+page.svelte`
- **Upload**: Chunked upload to R2 via `AssetService/Upload`
- **Analysis**: `AIService/AnalyzeVideo(asset_id)` → detected language + transcript
- **Translation**: `AIService/TranslateScript(transcript, target_langs)` → preview
- **Generate**: `AssetService/Generate(type=translation)` → SSE `/events/assets/{id}`
- **Voice cloning**: Preserves creator's voice characteristics via voice model
- **Lip sync**: Premium feature, AI-adjusted mouth movements
- **Multi-language**: Can generate multiple versions simultaneously

---

## 14. Localization Notes

- Supported languages: "Tiếng Anh 🇺🇸", "Tiếng Nhật 🇯🇵", "Tiếng Hàn 🇰🇷", "Tiếng Trung 🇨🇳"
- Status: "Đang phân tích", "Đang dịch", "Hoàn thành"
- Labels: "Bản gốc", "Bản dịch", "Nhân bản giọng", "Đồng bộ môi"
- Credits: "{n} credits" (no Vietnamese word)
- Progress: "Đang dịch... 45% · Còn ~2 phút"

---

## 15. Design Tokens

| Token | Usage |
|---|---|
| `--color-studio-translate` | Translation mode accent (teal) |
| `--color-lang-source` | Source language column bg |
| `--color-lang-target` | Target language column bg |
| `--color-credit-warning` | Low credit warning (amber) |
| `--color-credit-ok` | Sufficient credits (green) |
| `--color-progress-active` | Progress bar fill |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards, panels |

---

## 16. Related Screens

| Screen | Relationship |
|---|---|
| [W021] Studio Launcher | Parent |
| [W030] Studio Queue | Job tracking |
| [W029] Asset Library | Output storage |

---

## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Added component hierarchy, credit estimation formula, 5 states, 5 edge cases, 5 error scenarios, bilingual accessibility, SSE progress, 5 perf KPIs, 7 analytics, SvelteKit impl, language localization, 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
