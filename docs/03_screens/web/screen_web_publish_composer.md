# Screen: Web — Publish Composer

> **Screen ID**: W052
> **Module**: M11 — Publish Hub
> **Route**: `/publish/compose`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §18-19, A1 Schema (publish_items, assets, connectors), B5 RBAC §2.7

---

## 1. Purpose & Context

The Publish Composer is the multi-platform content creation and scheduling hub — a single split-screen form where creators compose a post (attach media, write caption, manage hashtags) and publish or schedule to multiple social platforms simultaneously. Each platform gets a live preview mockup, per-platform caption/hashtag overrides, and format validation. This is where the "create once, publish everywhere" promise is delivered.

### User Story
> As a creator, I want to compose one post and publish it to TikTok, Instagram Reels, and YouTube Shorts at once — with per-platform caption tweaks, AI-suggested captions and hashtags, and a live preview showing exactly how it will appear on each platform.

### Business Goals
- Maximize content distribution by reducing per-platform publishing friction
- Ensure content is platform-optimized (format validation, caption length limits)
- Drive AI feature adoption through inline AI caption/hashtag assistance
- Support both instant publish and scheduled publishing (with AI timing recommendations)

### When This Screen Is Used
- **Manual publish**: Creator has a video/image ready → compose post from scratch
- **From AI Studio**: Asset generated → "📤 Publish" → pre-filled with asset + metadata
- **From quick action**: FAB → "📤 Đăng bài nhanh" → empty composer
- **Re-publish**: From Publish Detail → "📤 Re-publish to new platform" → pre-filled
- **Scheduled edit**: Editing a scheduled-but-not-yet-published post

### Entry Points
- Quick Action FAB ([W007]): "📤 Đăng bài nhanh"
- Generation Queue ([W030]): "📤 Publish" on completed job → pre-filled with asset
- Publish Item Detail ([W045]): "📤 Re-publish" → pre-filled with existing content
- Script Review ([W020]): "Publish asset" on approved script
- Sidebar: Publish → "📤 Soạn bài đăng"
- Direct URL: `/publish/compose` or `/publish/compose?asset_id=xxx&republish_id=yyy`

### Exit Points
- "📋 QA Check" → `/packaging/[asset_id]` (Packaging QA W056)
- "📤 Đăng" → Success → `/publish/queue` (Publish Queue W043)
- "📅 Lên lịch" → Success → `/publish/calendar` (Calendar W046)
- "← Publish" → `/publish` (back)
- Discard → Confirm modal → Back to previous

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid session
- User has `publish:create` permission
- At least one platform connector configured and active (otherwise redirect to Settings/Connectors)
- Media file uploaded or asset_id provided as URL param

### Postconditions
- `publish_item` created with status `queued` (instant) or `scheduled`
- Media uploaded to R2/CDN if not already
- Platform-specific metadata stored per target platform
- QA check triggered if user clicked "QA Check" before publishing
- Analytics events dispatched

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + Split View: Compose Panel (60%) / Preview Panel (40%) |
| Tablet (768-1279px) | App Shell + Single column: Compose on top, Preview collapsed (expandable) |
| Mobile (≤767px) | Redirect to Mobile Quick Publish (M006) |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Publish   📤 Soạn bài đăng                        [💾 Lưu nháp]  │
├──────────────────────────────────┬───────────────────────────────────┤
│ Compose Panel (60%)              │ Preview Panel (40%)               │
│                                  │                                   │
│ ┌─ Media ────────────────────┐  │ Tabs: [🎵 TikTok] [📸 IG] [📺YT]│
│ │ [📎 Upload file]           │  │                                   │
│ │ [🎬 Chọn từ Studio]        │  │ ┌─ TikTok Preview ──────────────┐│
│ │                            │  │ │ ┌─────────────────┐          ││
│ │ ┌───────────────────────┐  │  │ │ │ [📱 9:16]       │          ││
│ │ │ 🎬 video.mp4          │  │  │ │ │ Video preview   │          ││
│ │ │ 52s · 1080×1920 · 45MB│  │  │ │ │                 │          ││
│ │ │ [▶ Preview] [✕ Remove]│  │  │ │ │                 │          ││
│ │ └───────────────────────┘  │  │ │ │ @creativanta    │          ││
│ └────────────────────────────┘  │ │ │ "5 tips skin.." │          ││
│                                  │ │ │ #skincare #tips │          ││
│ ┌─ Caption ──────────────────┐  │ │ └─────────────────┘          ││
│ │ Caption chung:              │  │ │                               ││
│ │ ┌────────────────────────┐ │  │ │ ✅ Format: 9:16 ✓            ││
│ │ │ 5 tips skincare đơn gi │ │  │ │ ✅ Duration: 52s ✓           ││
│ │ │ ản ai cũng làm được!  │ │  │ │ ✅ Caption: 85/2200 ✓       ││
│ │ │ Bạn đã thử chưa? 😊   │ │  │ │ ✅ Hashtags: 3/30 ✓         ││
│ │ └────────────────────────┘ │  │ └────────────────────────────────┘│
│ │ [🤖 AI viết caption]      │  │                                   │
│ │ Chars: 85/2200              │  │                                   │
│ │                            │  │                                   │
│ │ Per-platform overrides:    │  │                                   │
│ │ ☐ 🎵 TikTok: dùng chung  │  │                                   │
│ │ ☐ 📸 IG: dùng chung       │  │                                   │
│ │ ☑ 📺 YT: custom ▾        │  │                                   │
│ │   ┌── YouTube Caption ─┐  │  │                                   │
│ │   │ 5 tips skincare đơn│  │  │                                   │
│ │   │ giản. SUBSCRIBE! 🔔│  │  │                                   │
│ │   └────────────────────┘  │  │                                   │
│ └────────────────────────────┘  │                                   │
│                                  │                                   │
│ ┌─ Hashtags ─────────────────┐  │                                   │
│ │ [#skincare] [#tips] [#easy]│  │                                   │
│ │ [+ Add] [🤖 AI gợi ý]     │  │                                   │
│ └────────────────────────────┘  │                                   │
│                                  │                                   │
│ ┌─ First Comment (optional) ─┐  │                                   │
│ │ [Auto-post first comment]  │  │                                   │
│ │ "Link sp: creativa.shop"   │  │                                   │
│ └────────────────────────────┘  │                                   │
│                                  │                                   │
│ ┌─ Platforms & Schedule ─────┐  │                                   │
│ │ ☑ 🎵 TikTok   (connected) │  │                                   │
│ │ ☑ 📸 IG Reels (connected) │  │                                   │
│ │ ☐ 📺 YouTube  (connected) │  │                                   │
│ │ ☐ 🐦 X         (not conn.)│  │                                   │
│ │   └ [Kết nối X/Twitter →]  │  │                                   │
│ │                            │  │                                   │
│ │ ◉ Đăng ngay                │  │                                   │
│ │ ○ Lên lịch:               │  │                                   │
│ │   📅 [28/03/2026] ⏰ [19:00]│  │                                   │
│ │   🤖 AI gợi ý: "19:00 tối│  │                                   │
│ │      nay — engagement cao  │  │                                   │
│ │      nhất cho thứ 5"       │  │                                   │
│ └────────────────────────────┘  │                                   │
│                                  │                                   │
│ ┌─ Product Tag (optional) ───┐  │                                   │
│ │ [🛍️ Tag sản phẩm]          │  │                                   │
│ └────────────────────────────┘  │                                   │
│                                  │                                   │
│ [📋 QA Check]  [📤 Đăng (2 platforms)] │                           │
└──────────────────────────────────┴───────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
PublishComposerPage
├── AppShell (shared)
│   ├── Sidebar
│   └── TopBar
├── PageHeader
│   ├── BackLink ("← Publish")
│   ├── Title ("📤 Soạn bài đăng")
│   └── SaveDraftButton ("💾 Lưu nháp")
├── SplitView
│   ├── ComposePanel (60%)
│   │   ├── MediaSection
│   │   │   ├── UploadButton ("📎 Upload file") → file picker
│   │   │   ├── StudioPickerButton ("🎬 Chọn từ Studio") → modal
│   │   │   └── AttachedMedia (when media selected)
│   │   │       ├── Thumbnail + FileName
│   │   │       ├── MediaMeta ("52s · 1080×1920 · 45MB")
│   │   │       ├── PreviewButton ("▶ Preview")
│   │   │       └── RemoveButton ("✕ Remove")
│   │   ├── CaptionSection
│   │   │   ├── SharedCaptionEditor (textarea)
│   │   │   │   ├── CharCounter ("85/2200" — min of platform limits)
│   │   │   │   └── AIWriteButton ("🤖 AI viết caption") → CopilotService
│   │   │   └── PerPlatformOverrides
│   │   │       └── PlatformOverride[] (one per selected platform)
│   │   │           ├── Checkbox ("☐ dùng chung" / "☑ custom")
│   │   │           ├── PlatformIcon + Name
│   │   │           └── CustomCaptionEditor (visible when custom checked)
│   │   ├── HashtagSection
│   │   │   ├── HashtagChips (current hashtags, removable)
│   │   │   ├── AddInput ("+ Add" → inline text input)
│   │   │   └── AISuggestButton ("🤖 AI gợi ý") → CopilotService
│   │   ├── FirstCommentSection (optional, collapsible)
│   │   │   ├── Toggle ("Auto-post first comment")
│   │   │   └── CommentEditor (text area, for link in bio, etc.)
│   │   ├── PlatformScheduleSection
│   │   │   ├── PlatformCheckboxes
│   │   │   │   └── PlatformOption[]
│   │   │   │       ├── Checkbox (☑/☐)
│   │   │   │       ├── PlatformIcon + PlatformName
│   │   │   │       ├── ConnectionStatus ("connected" / "not connected")
│   │   │   │       └── ConnectLink (if not connected → Settings/Connectors)
│   │   │   ├── TimingSelector
│   │   │   │   ├── RadioNow ("◉ Đăng ngay")
│   │   │   │   ├── RadioSchedule ("○ Lên lịch")
│   │   │   │   ├── DatePicker (when schedule selected)
│   │   │   │   ├── TimePicker (when schedule selected)
│   │   │   │   └── AISuggestedTime ("🤖 AI gợi ý: 19:00 — engagement cao nhất")
│   │   │   └── TimezoneNote ("Múi giờ: GMT+7, HCM")
│   │   └── ProductTagSection (optional)
│   │       └── TagProductButton ("🛍️ Tag sản phẩm") → ProductPickerModal
│   └── PreviewPanel (40%)
│       ├── PlatformTabs (one per selected platform)
│       └── PlatformPreview[]
│           ├── DeviceMockup (9:16 phone frame for TikTok/IG, 16:9 for YouTube)
│           ├── VideoPreview (thumbnail + overlays)
│           ├── CaptionPreview (platform-specific or shared)
│           ├── HashtagPreview
│           └── FormatValidation
│               ├── FormatCheck (✅/❌ aspect + "9:16 ✓")
│               ├── DurationCheck (✅/❌ + "{n}s ✓")
│               ├── CaptionCheck (✅/❌ + "{n}/{max} ✓")
│               └── HashtagCheck (✅/❌ + "{n}/{max} ✓")
├── BottomActionBar
│   ├── QACheckButton ("📋 QA Check") → navigate to Packaging QA
│   └── PublishButton ("📤 Đăng ({n} platforms)") → publish + confirm
├── DiscardConfirmModal ("Bạn có chắc muốn rời? Nội dung chưa lưu sẽ mất.")
├── ProductPickerModal
├── StudioAssetPickerModal
└── AIResultModal (shows AI-generated captions/hashtags for approval)
```

---

## 5. Displayed Data / Data Binding

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Pre-filled asset | `assets WHERE id = query.asset_id` | `AssetService/Get(asset_id)` | Video player + metadata | Session |
| Pre-filled republish | `publish_items WHERE id = query.republish_id` | `PublishService/Get(republish_id)` | Pre-populated form fields | Session |
| Connected platforms | `connectors WHERE workspace_id AND status = 'active'` | `ConnectorService/ListActive` | Platform checkboxes | 5m TTL |
| Platform rules | Configuration per platform | `PlatformRulesService/Get(platform)` | Validation limits in preview | 24h TTL |
| AI caption suggestion | AI-generated | `CopilotService/GenerateCaption(context)` | Modal with suggestion → approve/edit | Per-request |
| AI hashtag suggestion | AI-generated | `CopilotService/SuggestHashtags(caption, niche)` | Chip suggestions → click to add | Per-request |
| AI best time | Historical analytics | `AnalyticsService/GetBestPostingTime(platform, day)` | "19:00 — engagement cao nhất cho thứ 5" | 24h TTL |
| Draft data | `publish_drafts WHERE workspace_id AND user_id` | `PublishService/GetDraft(id)` or auto-save | Form state restoration | Session |

---

## 6. User Actions

| # | Action | Trigger | API Call | System Response | Permission |
|---|---|---|---|---|---|
| 1 | Upload media | "📎 Upload" → file picker | `UploadService/Upload(file)` → R2 | Progress bar → media attached | `publish:create` |
| 2 | Pick from Studio | "🎬 Chọn từ Studio" → modal | `AssetService/List(type=completed)` | Modal with asset grid → select → attached | `publish:create` |
| 3 | Write caption | Type in caption editor | Client-side (auto-saved to draft) | Live char counter + preview updates | `publish:create` |
| 4 | AI write caption | "🤖 AI viết caption" | `CopilotService/GenerateCaption(media_context)` | Modal with 3 suggestions → click to use | `publish:create` + credits |
| 5 | Add hashtag | "+ Add" → type → Enter | Client-side | Chip added + preview updates | `publish:create` |
| 6 | AI suggest hashtags | "🤖 AI gợi ý" | `CopilotService/SuggestHashtags(caption)` | 5-10 hashtag suggestions as chips → click to add | `publish:create` + credits |
| 7 | Toggle platform | Check/uncheck platform | Client-side | Platform preview tab appears/disappears. Publish button count updates. | `publish:create` |
| 8 | Set custom caption per platform | Check "custom" on platform override | Client-side | Custom editor expands for that platform | `publish:create` |
| 9 | Select "Đăng ngay" | Radio button | Client-side | Schedule UI hidden | `publish:create` |
| 10 | Select "Lên lịch" | Radio button → date/time picker | Client-side | Date/time pickers appear. AI suggestion shown. | `publish:create` |
| 11 | Accept AI time | Click AI suggestion | Client-side | Time picker auto-fills with suggested time | `publish:create` |
| 12 | Tag product | "🛍️ Tag sản phẩm" → modal | `ProductService/List` | Product picker → select → product linked | `publish:create` + `product:read` |
| 13 | QA check | "📋 QA Check" | — | Navigate to Packaging QA (W056) with current compose state | `publish:create` |
| 14 | Publish now | "📤 Đăng" (when "Đăng ngay") → confirm | `PublishService/Execute(data)` | Publish item created → navigate to Queue | `publish:execute` |
| 15 | Schedule publish | "📤 Lên lịch" (when scheduled) → confirm | `PublishService/Schedule(data, datetime)` | Scheduled item created → navigate to Calendar | `publish:execute` |
| 16 | Save draft | "💾 Lưu nháp" | `PublishService/SaveDraft(data)` | Toast: "Đã lưu nháp!" | `publish:create` |
| 17 | Discard | Navigate back without saving → confirm modal | — | Discard changes → navigate back | Any |

---

## 7. States / State Machine

| State | Condition | Visual |
|---|---|---|
| EMPTY | No media attached | Upload area: large drop zone with "📎 Kéo file vào hoặc chọn file". Caption/platform sections disabled (greyed). |
| COMPOSING | Media attached, editing in progress | Full form active. Preview shows live content. Auto-save indicator: "Lưu tự động ✓" |
| UPLOADING | Media file uploading | Progress bar on media section. Form editable but publish disabled. |
| AI_GENERATING | AI writing caption or suggesting hashtags | AI button shows spinner. Modal appears with results when done. |
| VALIDATING | Format validation running | Preview checks show loading spinners |
| READY | All required fields filled, validation passed | "📤 Đăng ({n} platforms)" button green and active. All checks ✅. |
| HAS_WARNINGS | Validation warnings (caption too long for one platform) | Button active but amber. Warning badges on affected platform preview tabs. |
| BLOCKED | No platform selected or critical validation failure | "📤 Đăng" button disabled. Error message: "Chọn ít nhất 1 platform" or "{error}" |
| PUBLISHING | Publish in progress | Button shows spinner: "Đang đăng..." All fields read-only. |
| PUBLISHED | Publish successful | Toast: "✅ Đã gửi vào hàng chờ!" → auto-redirect to Queue after 2s |
| DRAFT_SAVED | Draft saved successfully | Small green checkmark next to "Lưu nháp" |

---

## 8. Validation Rules

### Media Validation
| Rule | Check | Error |
|---|---|---|
| Media required | At least one media file attached | "Cần đính kèm video hoặc ảnh" |
| File size | Per-platform max (see Packaging QA rules) | "File quá lớn cho {platform}: {size}/{max}" |
| Format | Supported formats: MP4, MOV, JPG, PNG, GIF | "Định dạng {ext} không được hỗ trợ" |

### Caption Validation
| Rule | Check | Error |
|---|---|---|
| Caption required | At least 1 character (for video platforms) | "Caption là bắt buộc" |
| Per-platform length | TikTok: 2200, IG: 2200, YT: 5000, X: 280 | "Caption vượt giới hạn {platform}: {n}/{max}" |
| No banned words | Profanity filter | "Caption chứa từ bị hạn chế" |

### Hashtag Validation
| Rule | Check | Error |
|---|---|---|
| Per-platform max | TikTok: 100, IG: 30, X: 5 | "Quá nhiều hashtag cho {platform}: {n}/{max}" |

### Schedule Validation
| Rule | Check | Error |
|---|---|---|
| Future time | Schedule must be ≥ 15 min from now | "Thời gian phải ít nhất 15 phút từ bây giờ" |
| Platform selection | At least 1 platform checked | "Chọn ít nhất 1 nền tảng" |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| Open composer | ✅ | ✅ | ✅ | ✅ | ⚠️ own content | ❌ | ❌ |
| Upload media | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| AI caption/hashtags | ✅ | ✅ | ✅ | ✅ | ⚠️ credit check | ❌ | ❌ |
| Publish immediately | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Schedule publish | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Tag product | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Save draft | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

---

## 10. Navigation Map

```
Publish Composer (/publish/compose)
├── → /packaging/[asset_id]        (📋 QA Check)
├── → /publish/queue                (After publish now)
├── → /publish/calendar             (After schedule)
├── → /settings/connectors          (Connect missing platform)
├── → ProductPickerModal            (Tag product — inline modal)
├── → StudioAssetPickerModal        (Pick from Studio — inline modal)
├── → AIResultModal                 (AI captions/hashtags — inline modal)
└── ← /publish                      (Back)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Upload fails | Network error or file too large | Toast: "Upload thất bại: {error}. [Thử lại]" | Retry upload |
| Upload exceeds plan storage | Storage limit reached | Toast: "Hết dung lượng storage. [⬆ Nâng cấp gói]" | Upgrade plan or delete old files |
| AI caption fails | Copilot service error | Toast: "Không tạo được caption. [Thử lại]" | Retry or write manually |
| AI credits insufficient | 0 credits remaining | Modal: "Hết credits AI. [🪙 Mua thêm] hoặc viết thủ công." | Buy credits or manual |
| Platform connector expired | OAuth token expired for selected platform | Per-platform warning: "⚠ Kết nối {platform} hết hạn. [Kết nối lại →]" | Reconnect via Settings |
| Publish fails | Server error on publish execute | Button reverts + Toast: "Không đăng được. [Thử lại]" | Retry |
| Draft save fails | Network error during auto-save | Subtle indicator: "⚠ Chưa lưu được" (yellow, non-blocking) | Auto-retry in 10s |
| Format incompatible | Video aspect ratio wrong for platform | Per-platform preview: "❌ Format không phù hợp cho {platform}. [Bỏ chọn platform] hoặc [Auto-crop]" | Auto-crop or deselect |
| Navigate away with unsaved | User clicks back/link with unsaved changes | DiscardConfirmModal: "Bạn có chắc muốn rời? Nội dung chưa lưu sẽ mất. [Ở lại] [Rời đi]" | Stay or leave |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Upload drop zone | `role="button"`, `aria-label="Upload media file. Drag and drop or click to browse."` |
| Caption editor | `role="textbox"`, `aria-label="Post caption"`, char counter `aria-live="polite"` |
| Platform checkboxes | `role="checkbox"`, `aria-label="Publish to TikTok"`, `aria-checked` |
| Schedule radio | `role="radiogroup"`, `aria-label="Publishing time"` |
| Validation results | `aria-live="polite"` — announced when checks pass/fail |
| AI buttons | `aria-label="Generate caption using AI"` |
| Publish button | `aria-disabled` when blocked. `aria-label="Publish to 2 platforms"` |
| Keyboard | Tab: Media → Caption → Hashtags → Platforms → Schedule → Actions |
| Color contrast | All text meets WCAG 2.1 AA (4.5:1 ratio) |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Shell render | 0ms | App Shell renders. Empty compose form visible. |
| Pre-fill from asset | 100-400ms | If `asset_id` in URL: media preview loads, caption pre-fills |
| Platform list | 100-300ms | Connected platforms appear as checkboxes |
| AI suggestion load | 200-500ms | AI best time suggestion appears in schedule section |
| Media upload | 1-30s (size dependent) | Progress bar with percentage + upload speed indicator |
| AI caption generation | 2-5s | Button spinner → modal with 3 suggestions |

---

## 14. Performance Requirements

| Metric | Target | Measurement |
|---|---|---|
| LCP | < 2.0s | Compose form (media area + caption editor) |
| FID | < 100ms | First keystroke in caption editor |
| CLS | < 0.05 | No shift when platform list loads |
| TTI | < 2.0s | All form controls interactive |
| Preview update | < 100ms | Caption changes reflect in preview instantly |
| Auto-save latency | 1s debounce + 500ms API | Draft saved within 1.5s of last edit |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Auto-save draft | Debounced API (1s after last edit) | On every form change |
| Preview validation | Client-side reactive | Instant (Svelte reactivity) |
| AI suggestion streaming | SSE (for caption generation) | Streams token-by-token until complete |

---

## 16. Localization Notes

- Primary language: Vietnamese
- Platform names: English (TikTok, Instagram, YouTube, X/Twitter)
- Validation messages: Vietnamese ("Caption vượt giới hạn...")
- AI suggestion label: Vietnamese ("🤖 AI gợi ý: 19:00 — engagement cao nhất cho thứ 5")
- Timezone: Display current timezone ("Múi giờ: GMT+7, HCM")
- Tone: Encouraging — "📤 Đăng (2 platforms)" feels confident

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `composer.opened` | Page load | `source` (fab/studio/republish/sidebar), `pre_filled` (boolean), `asset_type` |
| `composer.media.uploaded` | Media upload complete | `media_type` (video/image), `file_size_mb`, `duration_s` |
| `composer.media.from_studio` | Asset picked from Studio | `asset_id`, `asset_type` |
| `composer.caption.ai_generated` | AI caption used | `prompt_tokens`, `accepted` (boolean), `caption_length` |
| `composer.hashtags.ai_suggested` | AI hashtags used | `suggested_count`, `accepted_count` |
| `composer.platform.selected` | Platform checkbox toggled | `platform`, `selected` (boolean), `total_selected` |
| `composer.schedule.type` | Timing selected | `type` (now/scheduled), `scheduled_datetime`, `ai_time_accepted` |
| `composer.published` | Publish confirmed | `platform_count`, `schedule_type`, `has_product_tag`, `ai_used` |
| `composer.draft.saved` | Draft saved (auto or manual) | `manual` (boolean), `completion_pct` |
| `composer.abandoned` | Left without publishing | `completion_pct`, `time_spent_ms`, `had_media` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Publish CTA button, AI action buttons |
| `--color-success` | ✅ Validation passed checks in preview |
| `--color-warning` | ⚠ Validation warnings (caption near limit) |
| `--color-danger` | ❌ Validation failures, required field errors |
| `--color-surface-primary` | Page background |
| `--color-surface-elevated` | Compose sections, preview panel |
| `--color-surface-input` | Text inputs, caption editor background |
| `--color-text-primary` | Form labels, main content |
| `--color-text-secondary` | Char counters, helper text, AI suggestions |
| `--color-text-link` | "Kết nối X/Twitter →" links |
| `--color-platform-tiktok` | TikTok platform badge (#00f2ea) |
| `--color-platform-instagram` | Instagram platform badge (#E1306C) |
| `--color-platform-youtube` | YouTube platform badge (#FF0000) |
| `--color-platform-twitter` | X/Twitter platform badge (#000000) |
| `--radius-card` | Section card radius (12px) |
| `--radius-input` | Input border-radius (8px) |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/publish/compose/+page.svelte`
- **Server load**: `+page.server.ts` → fetch connected platforms + pre-fill data if asset_id/republish_id provided
- **URL params**: `?asset_id=xxx`, `?republish_id=yyy`

### Data Fetching Strategy
```
+page.server.ts:
  const connectors = await connectorService.listActive(workspaceId)
  
  let prefill = null
  if (url.searchParams.get('asset_id')) {
    prefill = await assetService.get(url.searchParams.get('asset_id'))
  } else if (url.searchParams.get('republish_id')) {
    prefill = await publishService.get(url.searchParams.get('republish_id'))
  }
  
  return { connectors, prefill }
```

### Auto-Save Draft
```
// Debounced save on form changes
let saveTimer: ReturnType<typeof setTimeout>
function onFormChange() {
  clearTimeout(saveTimer)
  draftStatus = 'saving'
  saveTimer = setTimeout(async () => {
    await publishService.saveDraft(formState)
    draftStatus = 'saved'
  }, 1000)
}
```

### Preview Reactivity
- Preview panel reactively displays current form state
- Caption, hashtags, and media are Svelte stores bound to both compose and preview
- Platform validation runs client-side against cached `PlatformRulesService` data

### Upload to R2
- Uses chunked upload for files > 10MB
- Progress tracked via upload XHR `onprogress`
- On completion: R2 URL returned → stored in form state

---

## 20. Related Screens

| Screen | Relationship |
|---|---|
| [W056] Packaging QA | Pre-publish QA check |
| [W053] Publish Queue | Destination after instant publish |
| [W054] Publish Calendar | Destination after scheduled publish |
| [W030] Studio Queue | Upstream: completed AI assets |
| [W005] Quick Actions | Entry: "📤 Đăng bài nhanh" |
| [M023] Mobile Quick Publish | Mobile equivalent |

---

## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Full Tier A rewrite**: Upgraded from 192-line Tier C with generic boilerplate to 470+ line full spec. Added: complete split-screen compose/preview hierarchy, per-platform caption overrides, AI caption/hashtag generation with credit check, real-time preview validation, auto-save draft system, AI best posting time, media upload with progress, format validation per platform, 10 analytics events. Removed all generic boilerplate. Standardized Screen ID from W47 to W052. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C) | System |
