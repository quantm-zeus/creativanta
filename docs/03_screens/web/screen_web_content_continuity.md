# Screen: Web — Continuity Packs

> **Screen ID**: W019
> **Module**: M08 — Continuity OS
> **Route**: `/continuity`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §14, A1 Schema (character_packs, brand_packs, voice_packs, voice_samples), B5 RBAC §2.6

---

## 1. Purpose & Context

Continuity Packs is the "character bible" for AI-generated content — a management hub for reusable character profiles, brand kits, and voice presets that ensure consistency across all AI-generated videos, scripts, and TTS output. When a creator sets up "Chef Hùng" as a character with specific personality traits, visual style, and cloned voice, every AI Studio job referencing that character will produce consistent output. This eliminates the "every video feels random" problem.

### User Story
> As a creator producing 20+ videos per month with AI, I want to define characters (personality, visual style, voice) once and reuse them across all Studio jobs — ensuring my audience recognizes consistent characters, brand voice, and visual identity.

### Business Goals
- Increase AI content output quality by enforcing consistency
- Drive AI Studio adoption by reducing per-job setup time
- Enable character-driven content franchises (recognizable recurring personas)
- Support voice cloning feature adoption (ElevenLabs integration)
- Reduce content creation decision fatigue (pre-defined presets)

### When This Screen Is Used
- **Onboarding**: New user sets up their first character (guided process)
- **Before AI Studio**: Creator wants to verify character settings before generating
- **Voice setup**: Uploading voice samples for ElevenLabs cloning
- **Brand refresh**: Updating brand visual style, tone guidelines
- **Content expansion**: Creating a new character for a spin-off content series

### Entry Points
- Sidebar: Content → "🧬 Continuity"
- AI Studio ([W024]): "🧬 Manage characters" link in character selector
- Settings: AI Settings ([W095]) → "Character packs"
- Quick Action Menu: (not directly — accessed via Content section)
- Direct URL: `/continuity`

### Exit Points
- "→ Use in Studio" → `/studio?character_id=[id]` (AI Studio pre-selected)
- "← Content" → `/content` (Content section)

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid session
- User has `idea:read` permission
- Workspace exists (character packs are per-workspace)

### Postconditions
- Pack CRUD operations persisted to respective tables (`character_packs`, `brand_packs`, `voice_packs`)
- Voice samples uploaded to R2 and processed by ElevenLabs API
- Analytics events dispatched for feature usage tracking
- Default pack setting saved to workspace preferences

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + Tabbed content area with card grid (3-col) |
| Tablet (768-1279px) | App Shell (collapsed sidebar) + 2-col card grid |
| Mobile (≤767px) | Redirect to Mobile Continuity (M027) |

### ASCII Wireframe (List View)
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🧬 Continuity Packs                                   [+ Tạo mới]  │
├──────────────────────────────────────────────────────────────────────┤
│ Tabs: [🎭 Characters (3)] [🎨 Brand Packs (2)] [🎤 Voices (1)]    │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Character Card ──┐  ┌─ Character Card ──┐  ┌─ Character Card ──┐│
│ │ [Avatar] ⭐ Default │  │ [Avatar]          │  │ [Avatar]          ││
│ │ Mila                │  │ Chef Hùng         │  │ Dr. Lan           ││
│ │                     │  │                    │  │                    ││
│ │ Friendly, energetic │  │ Expert, calm      │  │ Scientific, warm  ││
│ │ VI + EN            │  │ VI only            │  │ VI + EN           ││
│ │                     │  │                    │  │                    ││
│ │ 🎤 Custom clone    │  │ 🎤 ElevenLabs     │  │ 🎤 Not set        ││
│ │ Used: 12 scripts   │  │ Used: 5 scripts    │  │ Used: 0 scripts   ││
│ │       8 videos     │  │       3 videos     │  │       (new)       ││
│ │                     │  │                    │  │                    ││
│ │ [✏ Edit] [📋 Dup]  │  │ [✏ Edit] [📋 Dup]│  │ [✏ Edit]          ││
│ │ [→ Use in Studio]  │  │ [→ Use in Studio] │  │ [→ Use in Studio] ││
│ └─────────────────────┘  └────────────────────┘  └────────────────────┘│
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

### ASCII Wireframe (Create/Edit Character — Full Page)
```
┌─ Full Page: Tạo Character ───────────────────────────────────────────┐
│ ← Continuity   Tạo Character mới                       [💾 Lưu]    │
├──────────────────────────────────────────────────────────────────────┤
│ Tabs: [👤 Personality] [🎨 Visual] [🎤 Voice] [👁 Preview]        │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ── 👤 Personality ──                                                │
│ ┌──────────────────────────────────────────────────────────────────┐│
│ │ Name: [Mila_____________]                                       ││
│ │ Role: [Beauty & lifestyle narrator_____]                        ││
│ │ Tone: [Friendly ▾] Formality: [Casual ▾]                      ││
│ │ Personality keywords: [energetic] [relatable] [+ add]          ││
│ │ Languages: [☑ Vietnamese] [☑ English] [☐ Japanese]            ││
│ │ Speaking speed: [○ Slow ● Normal ○ Fast]                       ││
│ │ Catchphrases: ["Bạn đã thử chưa?"] ["Let's gooo!"] [+ add]   ││
│ │ Backstory (AI context):                                         ││
│ │ ┌──────────────────────────────────────────────────────────┐   ││
│ │ │ Mila is a 25-year-old digital creator who loves sharing │   ││
│ │ │ beauty and cooking tips. She speaks with enthusiasm...   │   ││
│ │ └──────────────────────────────────────────────────────────┘   ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ── 🎨 Visual ──                                                    │
│ ┌──────────────────────────────────────────────────────────────────┐│
│ │ Avatar: [📎 Upload]  or  [🤖 AI Generate — 5 credits]         ││
│ │         [Preview: 🖼 current avatar]                            ││
│ │ Art style: [◉ Realistic] [○ Anime] [○ 3D] [○ Cartoon]        ││
│ │ Appearance: [Long black hair] [Vietnamese features] [+ add]    ││
│ │ Outfit default: [Casual modern] [White tee + apron for cooking]││
│ │ Background default: [Kitchen] [Vanity] [Studio] [Custom: ___] ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ── 🎤 Voice ──                                                     │
│ ┌──────────────────────────────────────────────────────────────────┐│
│ │ Voice source:                                                    ││
│ │ [○ ElevenLabs preset — browse library]                         ││
│ │ [● Custom clone — upload your voice]                            ││
│ │                                                                  ││
│ │ Voice sample: [📎 Upload 30s-5min audio]                       ││
│ │             Status: ✅ Cloned successfully                      ││
│ │             Quality: 🟢 High (4.2/5.0)                         ││
│ │                                                                  ││
│ │ ☑ I confirm this is my voice or I have rights to use it        ││
│ │                                                                  ││
│ │ [▶ Test voice: "Xin chào, tôi là Mila!"]                      ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ [Hủy]                                                  [💾 Lưu]    │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
ContinuityPacksPage
├── AppShell (shared)
│   ├── Sidebar
│   └── TopBar
├── PageHeader
│   ├── Title ("🧬 Continuity Packs")
│   └── CreateButton ("+ Tạo mới" → dropdown: Character / Brand Pack / Voice)
├── PackTypeTabs
│   ├── CharactersTab ("🎭 Characters ({count})")
│   ├── BrandPacksTab ("🎨 Brand Packs ({count})")
│   └── VoicesTab ("🎤 Voices ({count})")
├── TabContent
│   ├── CharactersList (when Characters tab active)
│   │   └── CharacterCard[]
│   │       ├── Avatar (80×80px, rounded)
│   │       ├── DefaultBadge (⭐ if default character)
│   │       ├── CharacterName
│   │       ├── PersonalitySnippet ("Friendly, energetic")
│   │       ├── LanguageBadges ("VI + EN")
│   │       ├── VoiceIndicator ("🎤 Custom clone" / "🎤 ElevenLabs" / "🎤 Not set")
│   │       ├── UsageStats ("Used: 12 scripts, 8 videos")
│   │       └── ActionBar
│   │           ├── EditButton ("✏ Edit")
│   │           ├── DuplicateButton ("📋 Dup")
│   │           ├── UseInStudioButton ("→ Use in Studio")
│   │           └── OverflowMenu (⋮)
│   │               ├── "⭐ Set as default"
│   │               ├── "📤 Export"
│   │               └── "🗑 Delete" (confirm)
│   ├── BrandPacksList (when Brand Packs tab active)
│   │   └── BrandPackCard[]
│   │       ├── BrandColorPalette (4-5 color swatches)
│   │       ├── BrandName
│   │       ├── FontPreview ("Display + Body font")
│   │       ├── ToneDescription ("Professional, trustworthy")
│   │       ├── LogoPreview (small)
│   │       └── ActionBar (Edit / Dup / Use)
│   └── VoicesList (when Voices tab active)
│       └── VoiceCard[]
│           ├── VoiceIcon (🎤)
│           ├── VoiceName
│           ├── SourceBadge ("Clone" / "ElevenLabs preset")
│           ├── QualityIndicator ("🟢 High 4.2/5.0")
│           ├── PreviewPlayButton ("▶ Play sample")
│           ├── LinkedCharacters ("Used by: Mila, Dr. Lan")
│           └── ActionBar (Edit / Delete)
├── CreateCharacterPage (full-page form when creating/editing)
│   ├── PageHeader (back + title + save)
│   ├── FormTabs
│   │   ├── PersonalityTab
│   │   │   ├── NameField (text input)
│   │   │   ├── RoleField (text input)
│   │   │   ├── ToneSelector (dropdown: Friendly / Expert / Funny / Serious / etc.)
│   │   │   ├── FormalitySelector (dropdown: Casual / Semi-formal / Formal)
│   │   │   ├── PersonalityKeywords (chip input, max 5)
│   │   │   ├── LanguageCheckboxes (VI / EN / JP / KR / etc.)
│   │   │   ├── SpeedRadio (Slow / Normal / Fast)
│   │   │   ├── Catchphrases (chip input)
│   │   │   └── BackstoryTextarea (free-text, max 1000 chars)
│   │   ├── VisualTab
│   │   │   ├── AvatarUploader (upload or AI generate)
│   │   │   ├── ArtStyleRadio (Realistic / Anime / 3D / Cartoon)
│   │   │   ├── AppearanceKeywords (chip input)
│   │   │   ├── DefaultOutfit (text input)
│   │   │   └── DefaultBackground (selector + custom text)
│   │   ├── VoiceTab
│   │   │   ├── VoiceSourceRadio (ElevenLabs preset / Custom clone)
│   │   │   ├── VoiceLibraryBrowser (if preset selected)
│   │   │   ├── VoiceSampleUploader (if custom selected)
│   │   │   ├── CloneStatus (processing / ready / failed)
│   │   │   ├── QualityScore
│   │   │   ├── ConsentCheckbox ("I confirm this is my voice...")
│   │   │   └── TestVoiceButton ("▶ Test")
│   │   └── PreviewTab
│   │       ├── CharacterSummaryCard (visual representation)
│   │       ├── SampleScriptPreview (AI-generated sample using this character)
│   │       └── SampleVideoPreview (AI-generated 5s clip using this character)
│   ├── SaveButton ("💾 Lưu Character")
│   └── CancelButton ("Hủy")
└── EmptyState (when tab has no packs)
    ├── Illustration (character creation)
    ├── Message ("Chưa có character nào. Tạo character đầu tiên để AI Studio tạo nội dung nhất quán!")
    └── CTAButton ("+ Tạo Character đầu tiên")
```

---

## 5. Displayed Data / Data Binding

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Character list | `character_packs WHERE workspace_id` | `ContinuityService/ListCharacters(workspace_id)` | Card grid (3-col) | 5m TTL |
| Brand pack list | `brand_packs WHERE workspace_id` | `ContinuityService/ListBrandPacks(workspace_id)` | Card grid | 5m TTL |
| Voice list | `voice_packs WHERE workspace_id` | `ContinuityService/ListVoices(workspace_id)` | Card grid | 5m TTL |
| Avatar | `character_packs.avatar_url` | Included | 80×80 image | CDN |
| Usage stats | `COUNT(studio_jobs WHERE character_id)` + `COUNT(scripts WHERE character_id)` | `ContinuityService/GetUsageStats(character_id)` | "12 scripts, 8 videos" | 1h TTL |
| Voice clone status | `voice_packs.clone_status` | Included | ✅ Cloned / ⏳ Processing / ❌ Failed | Realtime |
| Voice quality | `voice_packs.quality_score` (from ElevenLabs) | Included | "🟢 High (4.2/5.0)" | Per-clone |
| Default character | `workspace_preferences.default_character_id` | `WorkspaceService/GetPreferences` | ⭐ badge on card | 5m TTL |

---

## 6. User Actions

| # | Action | Trigger | API Call | System Response | Permission |
|---|---|---|---|---|---|
| 1 | Create character | "+ Tạo mới" → "Character" | — | Navigate to full-page create form | `idea:create` |
| 2 | Edit character | "✏ Edit" on card | `ContinuityService/Get(id)` | Navigate to edit form with data | `script:edit` |
| 3 | Duplicate character | "📋 Dup" | `ContinuityService/Clone(id)` | Toast: "Đã tạo bản sao: Mila (copy)". New card appears. | `idea:create` |
| 4 | Use in Studio | "→ Use in Studio" | — | Navigate → `/studio?character_id=[id]` | `asset:generate` |
| 5 | Set as default | ⋮ → "⭐ Set as default" | `WorkspaceService/SetDefaultCharacter(id)` | Previous default loses ⭐, new one gets ⭐. Toast: "Đã đặt làm mặc định." | `script:edit` |
| 6 | Delete character | ⋮ → "🗑 Delete" → confirm with usage warning | `ContinuityService/Delete(id)` | Card removed. Toast: "Đã xóa character." | `script:delete` |
| 7 | Upload avatar | Upload button in form | `UploadService/Upload(file)` | Avatar preview updates | `script:edit` |
| 8 | AI generate avatar | "🤖 AI Generate" → style selection | `CopilotService/GenerateAvatar(description, style)` | 4 avatar options → select one. Costs 5 credits. | `script:edit` + credits |
| 9 | Upload voice sample | "📎 Upload" in voice tab | `VoiceService/UploadSample(file)` → ElevenLabs clone | Upload → processing (30s-2min) → clone ready | `script:edit` |
| 10 | Test voice | "▶ Test" → plays sample | `VoiceService/TestVoice(voice_id, text)` | Audio plays: test sentence in cloned voice | `idea:read` |
| 11 | Save character | "💾 Lưu" submit form | `ContinuityService/Create(data)` or `Update(id, data)` | Character saved → navigate back to list | `idea:create` or `script:edit` |
| 12 | Switch tab | Click tab | Client-side | Tab content changes | `idea:read` |

---

## 7. States / State Machine

| State | Condition | Visual |
|---|---|---|
| LOADING | Page loading | Tab header + card skeletons (3 cards) |
| LOADED | Data available | Card grid with all packs. Tab counts visible. |
| EMPTY_TAB | Selected tab has no items | Illustration + "Chưa có {type} nào. [+ Tạo]" |
| CREATING | On create/edit form | Full-page form with tabs. Back to list on save/cancel. |
| VOICE_UPLOADING | Voice sample uploading | Progress bar on upload field |
| VOICE_PROCESSING | ElevenLabs cloning in progress | Status: "⏳ Đang xử lý giọng nói... (~1-2 phút)" with spinner |
| VOICE_READY | Clone successful | Status: "✅ Cloned successfully · Quality: 🟢 High". Test button active. |
| VOICE_FAILED | Clone failed | Status: "❌ Clone thất bại: {error}. [Thử lại]" |
| ERROR | API failed | "Không tải được continuity packs. [Thử lại]" |

---

## 8. Validation Rules

### Character Creation
| Field | Rule | Error Message |
|---|---|---|
| Name | Required, 2-50 chars, unique in workspace | "Tên character là bắt buộc" / "Tên đã tồn tại" |
| Role | Required, 5-200 chars | "Mô tả vai trò là bắt buộc" |
| Languages | At least 1 selected | "Chọn ít nhất 1 ngôn ngữ" |
| Backstory | Optional, max 1000 chars | "Backstory tối đa 1000 ký tự" |
| Avatar | Optional but recommended (AI warning if missing) | Soft warning: "Character không có avatar. AI sẽ dùng style mặc định." |

### Voice Upload
| Field | Rule | Error Message |
|---|---|---|
| Audio format | MP3, WAV, M4A | "Chỉ hỗ trợ MP3, WAV, M4A" |
| Duration | 30s - 5min | "Audio phải dài 30 giây đến 5 phút" |
| Quality | Minimum bitrate 128kbps | "Chất lượng audio quá thấp. Dùng file chất lượng cao hơn." |
| Consent | Required checkbox | "Phải xác nhận quyền sử dụng giọng nói" |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View continuity packs | ✅ | ✅ | ✅ | ✅ | ✅ (read-only) | ✅ (read-only) | ❌ |
| Create character/pack | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Edit character/pack | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Delete character/pack | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Duplicate | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Set default | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Use in Studio | ✅ | ✅ | ✅ | ✅ | ⚠️ credit check | ❌ | ❌ |
| Upload voice / clone | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| AI generate avatar | ✅ | ✅ | ✅ | ✅ | ⚠️ credit check | ❌ | ❌ |

---

## 10. Navigation Map

```
Continuity Packs (/continuity)
├── → /continuity/characters/new              (Create character form)
├── → /continuity/characters/[id]/edit         (Edit character form)
├── → /studio?character_id=[id]                (Use in AI Studio)
├── → /continuity/brands/new                   (Create brand pack)
├── → /continuity/voices/new                   (Create voice)
└── ← /content                                 (Back to content section)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Voice clone failed | ElevenLabs API error or poor audio quality | Voice tab: "❌ Clone thất bại: {error}. [Thử với file khác] [Thử lại]" | Re-upload or retry |
| Voice clone timeout | Processing > 5 min | "⏳ Xử lý lâu hơn dự kiến. Bạn sẽ nhận thông báo khi hoàn tất." | Push notification when done |
| Avatar AI generation fails | Copilot error | Toast: "Không tạo được avatar. [Thử lại] hoặc [📎 Upload thủ công]" | Upload manually |
| Credits insufficient | AI avatar/voice needs credits | Modal: "Cần 5 credits. Còn: 0. [🪙 Mua thêm]" | Buy credits |
| Delete with usage | Character used in 12 scripts, 8 videos | Confirm: "Character này đang được dùng trong 12 scripts và 8 videos. Xóa sẽ không ảnh hưởng nội dung đã tạo. [Xóa] [Hủy]" | Soft delete (keeps historical references) |
| Duplicate name | Creating character with existing name | Inline error: "Tên '{name}' đã tồn tại. Đặt tên khác." | Change name |
| Save fails | Network/server error | Toast: "Không lưu được. [Thử lại]" | Retry (form data preserved) |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Tab panel | `role="tablist"`, `role="tab"` on each, `aria-selected`, `aria-controls` |
| Character cards | `role="article"`, `aria-label="Character: Mila, friendly energetic, used in 12 scripts"` |
| Avatar images | `alt="Avatar of character Mila"` |
| Voice test button | `aria-label="Play voice sample for Mila"` |
| Personality form | All inputs have associated labels, required fields marked with `aria-required` |
| Voice upload | `aria-label="Upload voice sample, MP3 WAV or M4A, 30 seconds to 5 minutes"` |
| Color swatches (brand) | `aria-label="Brand color #FF5733, primary"` |
| Keyboard | Tab: card → card. Enter: open edit. Focus visible on all interactive. |
| Color contrast | All text meets WCAG 2.1 AA (4.5:1 ratio) |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Shell render | 0ms | App Shell renders (SSR). Tab header visible. |
| Tab counts | 100-300ms | Tab badges update ("Characters (3)") |
| Character cards | 200-500ms | Cards fade in with staggered animation (100ms per card) |
| Avatar images | 300-800ms | Avatars load lazily within cards |
| Usage stats | 400-1000ms | Stats populate after cards visible |
| Voice processing | 30s-2min | Real-time status updates during cloning |

---

## 14. Performance Requirements

| Metric | Target | Measurement |
|---|---|---|
| LCP | < 2.0s | First character card with avatar |
| FID | < 100ms | Click on card action button |
| CLS | < 0.05 | No shift when avatar images load (fixed placeholders) |
| TTI | < 2.5s | All card actions interactive |
| Voice clone | < 2 min | ElevenLabs processing time |
| Avatar AI generation | < 15s | 4 avatar options generated |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Voice clone status | Polling | Every 5s during PROCESSING state |
| AI avatar generation | Polling | Every 3s during generation |
| Usage stats | None (cached, low priority) | 1h cache |

---

## 16. Localization Notes

- Primary language: Vietnamese
- Character names: User-defined (any language, any script)
- Tone descriptions: Vietnamese ("Thân thiện, năng động")
- Languages: Display name ("Tiếng Việt", "English") not codes
- Voice quality: "Cao / Trung bình / Thấp" with numeric score
- Credit costs: "5 credits" (no VND — credits are internal currency)
- ElevenLabs: Keep English brand name
- Tone: Creative, encouraging — "Tạo character đầu tiên để AI tạo nội dung nhất quán!"

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `continuity.viewed` | Page load | `tab` (characters/brands/voices), `pack_count`, `source` |
| `continuity.character.created` | Character saved (new) | `character_name`, `has_avatar`, `has_voice`, `language_count` |
| `continuity.character.edited` | Character updated | `character_id`, `fields_changed[]` |
| `continuity.character.duplicated` | Character duplicated | `source_character_id` |
| `continuity.character.deleted` | Character deleted | `character_id`, `usage_count` |
| `continuity.character.used_in_studio` | "→ Use in Studio" clicked | `character_id` |
| `continuity.character.set_default` | Set as default | `character_id`, `previous_default_id` |
| `continuity.voice.uploaded` | Voice sample uploaded | `audio_duration_s`, `audio_format`, `file_size_mb` |
| `continuity.voice.cloned` | Voice clone completed | `voice_id`, `quality_score`, `processing_time_ms` |
| `continuity.voice.clone_failed` | Voice clone failed | `voice_id`, `error_type` |
| `continuity.avatar.ai_generated` | AI avatar generated | `style` (realistic/anime/3D/cartoon), `credits_used` |
| `continuity.brand.created` | Brand pack created | `pack_name`, `color_count`, `has_logo` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | "+ Tạo mới" button, "Use in Studio" CTA |
| `--color-success` | ✅ Voice clone success, ⭐ default badge |
| `--color-warning` | ⏳ Voice processing, missing avatar warning |
| `--color-danger` | ❌ Voice clone failed, delete confirmation |
| `--color-surface-primary` | Page background |
| `--color-surface-elevated` | Character cards, form sections |
| `--color-text-primary` | Character names, form labels |
| `--color-text-secondary` | Usage stats, personality descriptions |
| `--color-border` | Card borders, form field borders |
| `--radius-card` | Card border-radius (12px) |
| `--radius-avatar` | Avatar border-radius (50% for round) |
| `--shadow-card` | Card elevation shadow |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/continuity/+page.svelte` (list)
- **Route**: `src/routes/(app)/continuity/characters/new/+page.svelte` (create)
- **Route**: `src/routes/(app)/continuity/characters/[id]/edit/+page.svelte` (edit)
- **Server load**: `+page.server.ts` → fetch all packs for workspace (grouped by type)

### Data Fetching Strategy
```
+page.server.ts:
  const [characters, brandPacks, voices] = await Promise.all([
    continuityService.listCharacters(workspaceId),
    continuityService.listBrandPacks(workspaceId),
    continuityService.listVoices(workspaceId)
  ])
```

### ElevenLabs Voice Cloning
```
// Voice upload flow:
1. Client uploads audio to R2 (UploadService)
2. Server sends R2 URL to ElevenLabs Clone API
3. ElevenLabs returns clone_id + quality_score
4. Server stores in voice_packs table
5. Client polls for status until READY

// Test voice:
const audioUrl = await voiceService.textToSpeech(voiceId, testText)
// Returns R2 URL to generated audio → play via <audio> element
```

### AI Avatar Generation
```
// Uses CopilotService with image generation:
const avatars = await copilotService.generateAvatar({
  description: characterDescription,
  style: selectedArtStyle,  // realistic, anime, 3D, cartoon
  count: 4  // generate 4 options
})
// Returns: [{ url, thumbnailUrl }] × 4
// User selects one → saves as avatar_url
```

---

## 20. Related Screens

| Screen | Relationship |
|---|---|
| [W021] Studio Launcher | Consumer: uses characters for content generation |
| [W018] Derivative Manager | Consumer: uses characters for derivative creation |
| [W123] AI Preferences | Settings: AI model preferences that affect character output |
| [M001] Mobile Home Dashboard | Mobile equivalent (continuity via dashboard) |

---

## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Full Tier A rewrite**: Upgraded from 163-line Tier C with generic boilerplate to 470+ line full spec. Added: complete component hierarchy for both list and create/edit views, character personality model (tone, formality, catchphrases, backstory), visual style system (art style, appearance, outfit, background), ElevenLabs voice cloning integration with upload/processing/test flow, brand pack color/font/logo management, 7-role RBAC with credit checks, 12 analytics events, voice processing states. Removed all generic boilerplate. Standardized Screen ID from W27 to W019. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C) | System |
