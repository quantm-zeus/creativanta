# Screen: Web — Character Builder & Library

> **Screen ID**: W25-26
> **Module**: M04 — AI Studio
> **Route**: `/studio/characters`
> **Platform**: Web (SvelteKit)

---

## 1. Purpose & Context

Create and manage AI-generated video characters — consistent personas for product demos, tutorials, and UGC-style content. Characters maintain visual consistency across productions.

---

## 2-5. Layout & Actions

### ASCII Wireframe — Character Library
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🎭 Characters                     [+ Tạo character mới]          │
├──────────────────────────────────────────────────────────────────┤
│ ┌─ Character Grid (3 columns) ───────────────────────────────┐  │
│ │ ┌─────────────┐ ┌─────────────┐ ┌─────────────┐            │  │
│ │ │ [Avatar]     │ │ [Avatar]     │ │ [Avatar]     │            │  │
│ │ │ "Mai"        │ │ "Hùng"       │ │ "Linh"       │            │  │
│ │ │ F · 25-30    │ │ M · 30-35    │ │ F · 20-25    │            │  │
│ │ │ Style: warm  │ │ Style: pro   │ │ Style: fun   │            │  │
│ │ │ Used: 12x    │ │ Used: 8x     │ │ Used: 3x     │            │  │
│ │ │ [Use] [Edit] │ │ [Use] [Edit] │ │ [Use] [Edit] │            │  │
│ │ └─────────────┘ └─────────────┘ └─────────────┘            │  │
│ └──────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

### ASCII Wireframe — Character Builder
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Characters   🎭 Tạo Character mới                              │
├──────────────────────────────────────────────────────────────────┤
│ ┌─ Basic Info ───────────────────────────────────────────────┐   │
│ │ Name: [Mai                ]  Age range: [25-30 ▾]          │   │
│ │ Gender: [Female ▾]  Ethnicity: [Vietnamese ▾]              │   │
│ │ Persona: [Warm, friendly beauty advisor       ]            │   │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Visual Style ─────────────────────────────────────────────┐   │
│ │ Face reference: [📎 Upload photo]                           │   │
│ │ Hair: [Long, black ▾]  Skin tone: [🎨 Medium]              │   │
│ │ Outfit preset: [Casual ▾]  [Professional ▾]  [Custom]      │   │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Voice & Behavior ────────────────────────────────────────┐    │
│ │ Voice: [Warm female ▾]  Language: [Vietnamese ▾]           │    │
│ │ Speaking style: [Casual ▾]  Pacing: [Medium ▾]             │    │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Preview ──────────────────────────────────────────────────┐   │
│ │ [🤖 Generate preview — 5 credits]                          │   │
│ │ [3-second preview clip will appear here]                    │   │
│ └──────────────────────────────────────────────────────────────┘  │
│ [💾 Save Character] [Cancel]                                     │
└──────────────────────────────────────────────────────────────────┘
```

### Actions
| # | Action | Trigger | API | Result |
|---|---|---|---|---|
| 1 | Create character | Fill form → Save | `CharacterService/Create` | Character saved |
| 2 | Generate preview | "Generate preview" | `AIService/GenerateCharacterPreview` | Preview clip |
| 3 | Use in production | "Use" on card | — | → Studio mode with character prefilled |
| 4 | Edit | "Edit" on card | — | → Builder with data loaded |
| 5 | Delete | ⋮ → Delete | `CharacterService/Delete` | Character removed |

---

## 4. Component Hierarchy
```
CharacterLibraryPage (Route: /studio/characters)
├── AppShell (shared)
├── PageHeader (Title, CreateButton)
├── CharacterGrid (3 columns)
│   └── CharacterCard[]
│       ├── Avatar (AI-generated)
│       ├── Name + Demographics (gender, age range)
│       ├── StyleLabel
│       ├── UsageCount
│       └── ActionButtons (Use, Edit, ⋮ Delete)

CharacterBuilderPage (Route: /studio/characters/new | /studio/characters/[id]/edit)
├── AppShell (shared)
├── PageHeader (BackButton, Title)
├── BasicInfoForm (name, age, gender, ethnicity, persona)
├── VisualStyleForm
│   ├── FaceReferenceUploader
│   ├── HairSelector, SkinToneSelector
│   └── OutfitPresetSelector
├── VoiceBehaviorForm
│   ├── VoiceSelector, LanguageSelector
│   └── SpeakingStyleSelector, PacingSelector
├── PreviewSection
│   ├── GeneratePreviewButton (5 credits)
│   └── PreviewPlayer (3-second clip)
└── ActionBar (Save, Cancel)
```

---

## 5. States

| State | Condition | Visual |
|---|---|---|
| LIBRARY_LOADING | Fetching characters | 3-column grid skeletons |
| LIBRARY_LOADED | Characters available | Character cards grid |
| LIBRARY_EMPTY | No characters | Illustration: "Chưa có character. [+ Tạo character đầu tiên]" |
| BUILDER_EDITING | Form active | Form fields + preview section |
| PREVIEW_GENERATING | Preview requested | Spinner: "🤖 Đang tạo preview..." (3-5s) |
| PREVIEW_READY | Preview available | 3-second preview clip player |

---

## 6. Edge Cases

| Edge Case | Handling |
|---|---|
| Face reference > 10MB | Toast: "Ảnh quá lớn. Tối đa 10MB" |
| Character name duplicate | Inline error: "Tên đã tồn tại. Chọn tên khác." |
| Preview generation fails | Toast: "Không tạo preview được. Credits không bị trừ. [Thử lại]" |
| Delete character used in assets | Confirm: "Character đang được sử dụng trong {n} video. Xóa?" |
| Character limit reached (plan) | Modal: "Đạt giới hạn {n} characters. [Nâng cấp gói]" |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" | Auto-retry online |
| Upload failed | Face image error | Toast: "Không upload được ảnh. [Thử lại]" | Retry |
| Save failed | Server error | Toast: "Không lưu character. [Thử lại]" | Retry |
| Preview failed | AI service error | Toast: "Không tạo preview. Credits không trừ. [Thử lại]" | Retry |
| Delete failed | Server error | Toast: "Không xóa được. [Thử lại]" | Retry |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Character grid | `role="grid"`, cards with `role="gridcell"` |
| Character card | `aria-label="{name}, {gender}, {age_range}, sử dụng {n} lần"` |
| Form fields | Associated `<label>` + `aria-required` |
| Preview player | `aria-label="Preview character {name}"`, controls |
| Color selectors | `aria-label="Chọn tông da"`, sufficient contrast indicators |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Library load | 0-300ms | Grid skeleton cards |
| Character cards | 300-500ms | Cards populate with avatar stagger |
| Builder form | 0ms (client nav) | Form fields immediate |
| Face upload | 1-3s | Progress bar on upload zone |
| Preview generation | 3-5s | Spinner in preview area |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `character.library_viewed` | Page load | `total_characters` |
| `character.created` | Save new | `gender`, `age_range`, `voice`, `has_face_ref` |
| `character.edited` | Save edit | `character_id`, `fields_changed` |
| `character.deleted` | Delete confirmed | `character_id`, `usage_count` |
| `character.preview_generated` | Preview | `character_id`, `credits_used` |
| `character.used` | "Use" clicked | `character_id`, `target_mode` |
| `character.face_uploaded` | Photo uploaded | `file_size` |

---

## 11. SvelteKit Implementation Notes

- **Library route**: `src/routes/(app)/studio/characters/+page.svelte`
- **Builder route**: `src/routes/(app)/studio/characters/[id]/+page.svelte`
- **Server load**: `+page.server.ts` → fetch characters list
- **Face upload**: R2 via `AssetService/Upload` (image only)
- **Preview**: `AIService/GenerateCharacterPreview(character)` → 3s clip
- **Save**: `CharacterService/Create` or `CharacterService/Update`

---

## 12. Localization Notes

- Gender: "Nữ", "Nam", "Không xác định"
- Age ranges: "18-24", "25-30", "30-35", "35-40", "40+"
- Speaking style: "Thân thiện", "Chuyên nghiệp", "Vui vẻ", "Nghiêm túc"
- Pacing: "Chậm", "Trung bình", "Nhanh"
- Outfit: "Đời thường", "Chuyên nghiệp", "Tùy chỉnh"

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-studio-character` | Character mode accent |
| `--color-character-card` | Card background |
| `--color-character-avatar-placeholder` | No-avatar placeholder |
| `--color-gender-female` | Female indicator |
| `--color-gender-male` | Male indicator |
| `--color-credit-warning` | Low credit warning |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards, panels |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W024] AI Studio Launcher | Parent |
| [W030] Video Agent | Uses characters |
| [W039] Asset Library | Character output |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Added proper dual-view hierarchy, 6 states, 5 edge cases, 5 errors, grid/form accessibility, 7 analytics, SvelteKit impl (R2 upload, preview gen), character-specific localization, 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
