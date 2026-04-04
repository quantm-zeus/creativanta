# Screen: Web — Settings: Brand Voice & Identity

> **Screen ID**: W118
> **Module**: M23 — Settings
> **Route**: `/settings/brand`
> **Platform**: Web (SvelteKit)
> **Upstream**: Product Freeze §27, A1 Schema (brand_packs)

---

## 1. Purpose & Context

Configure brand identity: voice profile, visual guidelines, target audience, and content themes. Used by AI Copilot, Script Editor, and all Studio modes to maintain brand consistency.

### User Story
> As a creator building a brand, I want to define my brand voice and visual identity so AI always generates content that matches my style.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Settings   🎨 Thương hiệu & Brand Voice                         │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Brand Packs ──────────────────────────────────────────────────┐  │
│ │ Active: [✅ My Skincare Brand ▾]         [+ Tạo mới]          │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Voice Profile ────────────────────────────────────────────────┐  │
│ │ Tone: [Thân thiện ○] [Chuyên nghiệp ●] [Hài hước ○] [Sang trọng ○]  │
│ │ Language level: [Casual ○] [Semi-formal ●] [Formal ○]          │  │
│ │ Pronouns: [Mình - bạn ●] [Tôi - bạn ○] [Chúng tôi ○]        │  │
│ │ Key phrases: [Chăm da đúng cách] [Glowing skin] [+ Thêm]    │  │
│ │ Forbidden words: [giá rẻ] [nhưng] [+ Thêm]                   │  │
│ │ Sample text:                                                     │  │
│ │ [Mình muốn chia sẻ với bạn 5 tips skincare đơn giản...   ]    │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Visual Identity ──────────────────────────────────────────────┐  │
│ │ Logo: [📸 Upload]    Colors: [████ Primary] [████ Secondary]   │  │
│ │ Font preference: [Modern sans ▾]                                │  │
│ │ Photo style: [Bright & clean ●] [Dark & moody ○] [Colorful ○] │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Target Audience ──────────────────────────────────────────────┐  │
│ │ Age: [18-35 ▾]  Gender: [Female primary ▾]                    │  │
│ │ Interests: [Skincare] [Beauty] [Lifestyle] [+ Add]            │  │
│ │ Pain points: [Da dầu] [Mụn] [Chống nắng] [+ Add]            │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Content Themes ───────────────────────────────────────────────┐  │
│ │ Pillars: [Skincare Tips] [Product Reviews] [Routines] [+ Add] │  │
│ │ Posting frequency: [5x/week ▾]                                 │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ [💾 Lưu thay đổi]                                                  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3-5. Component & Actions

```
BrandSettingsPage
├── AppShell
├── PageHeader
├── BrandPackSelector (active pack, create new)
├── VoiceProfileSection
│   ├── ToneSelector (4 options)
│   ├── LanguageLevelSelector
│   ├── PronounSelector
│   ├── KeyPhrasesChips (editable)
│   ├── ForbiddenWordsChips (editable)
│   └── SampleTextArea
├── VisualIdentitySection
│   ├── LogoUploader
│   ├── ColorPickers (primary, secondary)
│   ├── FontSelector
│   └── PhotoStyleSelector
├── TargetAudienceSection
│   ├── AgeRange, GenderSelector
│   ├── InterestsChips
│   └── PainPointsChips
├── ContentThemesSection
│   ├── PillarChips
│   └── PostingFrequencySelector
└── SaveButton
```

| # | Action | Trigger | API | Result |
|---|---|---|---|---|
| 1 | Switch pack | Dropdown | — | Pack loaded |
| 2 | Create pack | "+ Tạo mới" | `BrandPackService/Create` | New empty pack |
| 3 | Save | "💾 Lưu" | `BrandPackService/Update` | Changes saved |
| 4 | Upload logo | File picker | Upload to R2 | Logo displayed |

### Technical Notes
- Route: `src/routes/(app)/settings/brand/+page.svelte`
- Brand pack: JSON config used across all AI features
- Permission: `workspace:settings:manage`

### Related Screens: [W08] Settings Hub (parent), all Copilot/Studio modes (consumers)

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

---

## 6. Edge Cases

| Edge Case | Handling |
|---|---|
| No brand packs exist | Default empty pack created on first visit |
| Pack name already exists | "Tên pack đã tồn tại. Chọn tên khác." |
| Logo too large (>2MB) | "File quá lớn (max 2MB). Chọn file nhỏ hơn." |
| Forbidden word in key phrases | Warning: "'{word}' cũng nằm trong danh sách cấm. Kiểm tra lại." |
| Sample text exceeds 500 chars | Character counter turns red, save disabled |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached pack | Retry online |
| Logo upload fail | R2 error | Toast: "Không upload được logo. [Thử lại]" | Retry |
| Save fail | API error | Toast: "Không lưu được. [Thử lại]" | Retry |
| Pack create fail | API error | Toast: "Không tạo được brand pack. [Thử lại]" | Retry |
| Color picker invalid | Invalid hex | Inline: "Mã màu không hợp lệ" | Fix input |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Tone radio group | `role="radiogroup"`, `aria-label="Brand tone selection"` |
| Chip inputs | `role="listbox"`, chips removable with `aria-label="Remove: {word}"` |
| Color pickers | `aria-label="Primary brand color"`, swatch + hex input |
| Sample text | `aria-label="Brand voice sample text"`, `maxlength` enforced |
| Pack selector | `aria-label="Active brand pack: {name}"` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Section skeletons |
| Active pack | 200-400ms | Fields populate |
| Logo preview | 300-600ms | Logo image loads |
| Color swatches | 100-200ms | Colors render |
| Save | 500-2000ms | Button spinner → toast |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `settings_brand.viewed` | Page load | `active_pack`, `source` |
| `settings_brand.pack_switched` | Pack dropdown change | `old_pack`, `new_pack` |
| `settings_brand.pack_created` | "+ Tạo mới" | `pack_name` |
| `settings_brand.tone_changed` | Tone radio change | `old_tone`, `new_tone` |
| `settings_brand.phrase_added` | Key phrase added | `phrase` |
| `settings_brand.forbidden_added` | Forbidden word added | `word` |
| `settings_brand.logo_uploaded` | Logo changed | `file_size`, `file_type` |
| `settings_brand.saved` | "💾 Lưu" | `sections_modified` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/settings/brand/+page.svelte`
- **Server load**: `+page.server.ts` → `BrandPackService/GetActive(workspace_id)` + `BrandPackService/List`
- **Pack switch**: Client-side swap → `BrandPackService/Get(pack_id)` → populate form
- **Logo upload**: `FormData` → `BrandPackService/UploadLogo(file)` → R2 CDN URL
- **Color pickers**: Svelte component with hex input + HSL swatch
- **Chips**: Custom Svelte component with add/remove, Enter to add, Backspace to remove
- **Save**: `BrandPackService/Update(pack_id, data)` → triggers cache invalidation across AI consumers
- **Brand pack consumption**: All AI features read `brand_pack` via server-side context injection

---

## 12. Localization Notes

- Tones: "Thân thiện", "Chuyên nghiệp", "Hài hước", "Sang trọng"
- Language levels: "Thân mật", "Bán trang trọng", "Trang trọng"
- Pronouns: "Mình-Bạn", "Tôi-Bạn", "Chúng tôi"
- Labels: "Từ khóa thương hiệu", "Từ cấm", "Mẫu văn bản"
- Photo: "Sáng & sạch", "Tối & mood", "Sặc sỡ"
- Tone: Creative, expressive

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-accent` | Save CTA, active pack |
| `--color-brand-primary` | User-configured primary color preview |
| `--color-brand-secondary` | User-configured secondary color preview |
| `--color-chip-bg` | Key phrase and forbidden word chips |
| `--color-chip-remove` | Chip remove (×) button |
| `--color-surface-elevated` | Section cards |
| `--color-danger` | Forbidden word chips |
| `--color-text-secondary` | Help text, descriptions |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W007] Settings Hub | Parent navigation |
| [W123] AI Preferences | AI feature consumers of brand pack |
| [W021] Studio Launcher | Content generation using brand voice |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (pack conflict, forbidden conflict), 5 errors, chip/form a11y, 8 analytics, SvelteKit impl, localization, 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
