# Screen: Web — Packaging QA

> **Screen ID**: W056
> **Module**: M08 — Publish & Packaging
> **Route**: `/packaging/[asset_id]`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §18, A1 Schema (publish_items, packaging_qa_results, assets), B5 RBAC §2.7

---

## 1. Purpose & Context

Packaging QA is the automated pre-publish quality gate: before content goes live, it runs a comprehensive checklist of technical, content, brand, and platform-specific checks against the asset. The creator gets a clear pass/warning/fail scorecard with actionable fix suggestions, inline editing for quick fixes, and the option to publish anyway (with warnings acknowledged) or fix and re-check.

### User Story
> As a creator about to publish, I want automated QA checks to catch technical issues (wrong resolution, file too large), content issues (missing hashtags, no product tag), and brand issues (off-brand voice) — before my content goes live and potentially embarrasses me.

### Business Goals
- Prevent platform-side rejections (wrong aspect ratio, file too large, banned content)
- Enforce brand consistency through AI voice checking
- Increase product tag rate for commerce-driven content
- Reduce post-publish corrections and re-uploads
- Build creator confidence in content quality

### When This Screen Is Used
- **After AI Studio output**: Asset generated → "📤 Send to Publish" → QA runs
- **Before manual publish**: Creator uploads asset manually → QA checks before scheduling
- **Re-check after fix**: Creator edits caption/tags → "Re-check" → QA re-runs
- **Batch publish**: Each item in batch goes through individual QA

### Entry Points
- Generation Queue ([W030]): "📤 Send to Publish" on completed job
- Publish Composer ([W048]): Pre-check before scheduling
- Script Review ([W020]): "Publish asset" on approved script
- Direct URL: `/packaging/[asset_id]`

### Exit Points
- "✅ Publish" → `/publish/queue` (Publish Queue W043) with item enqueued
- "🔄 Fix & Re-check" → stays on page, re-runs checks
- "← Back" → previous screen (studio queue, script review, etc.)
- "✏ Edit caption" → inline edit on same page
- "+ Tag product" → product picker modal on same page

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid session
- Asset with given `asset_id` exists and belongs to user's workspace
- User has `publish:create` or `publish:update` permission
- At least one platform connector is configured
- Asset has been fully generated (not in-progress)

### Postconditions
- QA results stored in `packaging_qa_results` table (for audit trail)
- If published: `publish_item` created and enqueued in `publish_queue`
- If published with warnings: warning acknowledgement logged
- All QA check results available for analytics (check pass rates)
- Analytics events dispatched

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + Split View: Content Preview (50%) / QA Panel (50%) |
| Tablet (768-1279px) | App Shell + Stacked: Preview on top, QA panel below |
| Mobile (≤767px) | Redirect to Mobile Packaging QA equivalent |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Publish   📋 Kiểm tra trước khi đăng                              │
├──────────────────────────────────┬───────────────────────────────────┤
│ Content Preview (50%)            │ QA Checks (50%)                   │
│                                  │                                   │
│ ┌─ Video Preview ────────────┐  │ ┌─ Overall Score ───────────────┐│
│ │ [🎬 Video Player]          │  │ │ Score: 7/9 checks passed       ││
│ │ "5 tips nấu ăn nhanh"     │  │ │ [██████████████░░░░] 78%       ││
│ │ Duration: 52s · 1080×1920  │  │ │ 🟡 2 warnings · 0 failures    ││
│ │ Format: MP4 · Size: 45MB   │  │ └────────────────────────────────┘│
│ │ [▶ Play] [🔊] [Full]      │  │                                   │
│ └────────────────────────────┘  │ ┌─ Technical Checks ────────────┐│
│                                  │ │ ✅ Resolution: 1080×1920      ││
│ ┌─ Caption Editor ───────────┐  │ │    ≥720p requirement ✓         ││
│ │ "5 tips nấu ăn nhanh      │  │ │ ✅ Duration: 52s               ││
│ │  không cần kỹ năng! 😊     │  │ │    Range 15-180s for TikTok ✓ ││
│ │  #cooking #tips #easy      │  │ │ ✅ File size: 45MB             ││
│ │  @creativanta"              │  │ │    Max 287MB for TikTok ✓     ││
│ │ [✏️ Edit] 180/300 chars    │  │ │ ✅ Aspect: 9:16 (vertical) ✓  ││
│ └────────────────────────────┘  │ └────────────────────────────────┘│
│                                  │                                   │
│ ┌─ Target Platforms ─────────┐  │ ┌─ Content Checks ──────────────┐│
│ │ ✅ 🎵 TikTok (9:16 ✓)     │  │ │ ✅ Caption present             ││
│ │ ✅ 📸 IG Reels (9:16 ✓)   │  │ │ 🟡 Caption: 180 chars         ││
│ │ ⚠️ ▶ YouTube (16:9 needed) │  │ │    Optimal for TikTok: <100   ││
│ │    [Auto-crop available]    │  │ │    [✏ Shorten caption]        ││
│ └────────────────────────────┘  │ │ ✅ Hashtags: 3 (range: 2-5 ✓) ││
│                                  │ │ 🔴 No product tag detected    ││
│ ┌─ Product Tag ──────────────┐  │ │    Revenue potential: High     ││
│ │ [No product tagged]         │  │ │    [+ Tag product now]        ││
│ │ [+ Tag product]             │  │ └────────────────────────────────┘│
│ └────────────────────────────┘  │                                   │
│                                  │ ┌─ Brand & Safety Checks ───────┐│
│                                  │ │ ✅ Brand voice: 🟢 Match (92%)││
│                                  │ │ ✅ No profanity detected      ││
│                                  │ │ ✅ No copyright issues        ││
│                                  │ └────────────────────────────────┘│
│                                  │                                   │
│                                  │ ┌─ Result Actions ──────────────┐│
│                                  │ │ 🟡 2 warnings remaining       ││
│                                  │ │                                ││
│                                  │ │ [✅ Publish anyway]            ││
│                                  │ │    "Bỏ qua cảnh báo & đăng"  ││
│                                  │ │ [🔄 Fix issues & re-check]    ││
│                                  │ │    "Sửa và kiểm tra lại"     ││
│                                  │ └────────────────────────────────┘│
└──────────────────────────────────┴───────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
PackagingQAPage
├── AppShell (shared)
│   ├── Sidebar
│   └── TopBar
├── PageHeader
│   ├── BackLink ("← Publish" or "← Studio Queue")
│   └── Title ("📋 Kiểm tra trước khi đăng")
├── SplitView
│   ├── PreviewPanel (50%)
│   │   ├── MediaPreview
│   │   │   ├── VideoPlayer (with play, volume, fullscreen controls)
│   │   │   │   └── MediaMeta (duration, resolution, format, file size)
│   │   │   └── ImageGallery (for carousel/image content)
│   │   ├── CaptionEditor
│   │   │   ├── CaptionText (read-only by default)
│   │   │   ├── EditButton ("✏ Edit")
│   │   │   ├── CharCounter ("180/300 chars")
│   │   │   └── InlineEditor (on edit: textarea with real-time char count)
│   │   ├── PlatformChecklist
│   │   │   └── PlatformCheckItem[]
│   │   │       ├── PlatformIcon + Name
│   │   │       ├── CompatibilityStatus (✅/⚠️/❌)
│   │   │       ├── IssueDescription (if not compatible)
│   │   │       └── AutoFixButton (e.g., "Auto-crop available")
│   │   └── ProductTagSection
│   │       ├── TaggedProduct (if exists: product card with image + name + price)
│   │       └── AddProductButton ("+ Tag product" → opens ProductPickerModal)
│   └── QAPanel (50%)
│       ├── OverallScore
│       │   ├── PassCount ("7/9 checks passed")
│       │   ├── ProgressBar (color-coded: green/yellow/red)
│       │   └── SummaryLabel ("🟡 2 warnings · 0 failures")
│       ├── TechnicalChecks
│       │   ├── SectionHeader ("Technical")
│       │   └── CheckItem[]
│       │       ├── StatusIcon (✅/🟡/🔴)
│       │       ├── CheckName ("Resolution")
│       │       ├── CheckValue ("1080×1920")
│       │       ├── Requirement ("≥720p requirement")
│       │       └── FixAction (if failed/warning — button or link)
│       ├── ContentChecks
│       │   ├── SectionHeader ("Content")
│       │   └── CheckItem[] (caption, hashtags, product tag, first comment)
│       ├── BrandChecks
│       │   ├── SectionHeader ("Brand & Safety")
│       │   └── CheckItem[] (brand voice, profanity, copyright)
│       └── ResultActions
│           ├── WarningSummary ("🟡 2 warnings remaining")
│           ├── PublishButton ("✅ Publish anyway" — primary CTA if only warnings)
│           │   └── Sublabel ("Bỏ qua cảnh báo & đăng")
│           ├── FixButton ("🔄 Fix issues & re-check")
│           │   └── Sublabel ("Sửa và kiểm tra lại")
│           └── PublishBlockedState (if 🔴 failures: publish button disabled, "Fix required" tooltip)
├── ProductPickerModal (when "+ Tag product" clicked)
│   ├── SearchInput
│   ├── ProductList (from commerce_products)
│   └── ConfirmButton
└── WarningAcknowledgeModal (when "Publish anyway" with warnings)
    ├── WarningList (list of unresolved warnings)
    ├── AcknowledgeCheckbox ("Tôi hiểu rằng nội dung có thể không tối ưu")
    └── ConfirmPublishButton
```

---

## 5. Displayed Data / Data Binding

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Video/Image preview | `assets.url WHERE id = asset_id` | `AssetService/Get(asset_id)` | Video player or image gallery | Session |
| Media metadata | `assets.{duration_s, resolution, format, file_size_bytes}` | Same | "52s · 1080×1920 · MP4 · 45MB" | Session |
| Caption | `publish_items.caption` (or draft) | `PublishService/GetDraft(asset_id)` | Editable text | Session |
| Hashtags | `publish_items.hashtags[]` | Same | Chip list | Session |
| Target platforms | User selection (from composer) or workspace default | `ConnectorService/ListActive` | Platform icons with compatibility | 1h TTL |
| QA results | `packaging_qa_results` | `PackagingService/RunQA(asset_id, platforms[])` | Check items with status | Per-run |
| Brand voice score | AI analysis of caption vs brand profile | `CopilotService/CheckBrandVoice(caption)` | "🟢 Match (92%)" | Per-run |
| Product tag | `publish_items.product_id → commerce_products` | `PublishService/GetDraft` | Product card or empty | Session |
| Platform rules | Configuration per platform | `PlatformRulesService/Get(platform)` | Used for check thresholds | 24h TTL |

### Platform-Specific Check Rules
| Check | TikTok | IG Reels | YouTube | X/Twitter |
|---|---|---|---|---|
| Max duration | 180s | 90s | 12h | 140s (tweet video) |
| Min resolution | 720p | 720p | 720p | 480p |
| Max file size | 287MB | 650MB | 128GB | 512MB |
| Optimal aspect | 9:16 | 9:16 | 16:9 | 16:9 |
| Max caption | 2200 | 2200 | 5000 | 280 |
| Max hashtags | 100 | 30 | 500 | 5 |

---

## 6. User Actions

| # | Action | Trigger | API Call | System Response | Permission |
|---|---|---|---|---|---|
| 1 | Run QA checks | Page load (auto) | `PackagingService/RunQA(asset_id, platforms[])` | Checks execute sequentially with progress animation | `publish:read` |
| 2 | Edit caption | "✏ Edit" → type → "Save" | `PublishService/UpdateDraft(caption)` | Caption saved + affected checks re-run automatically | `publish:update` |
| 3 | Tag product | "+ Tag product" → picker → select | `PublishService/TagProduct(asset_id, product_id)` | Product tagged → "No product tag" check passes | `publish:update` + `commerce:read` |
| 4 | Remove product tag | Click ✕ on tagged product | `PublishService/UntagProduct(asset_id)` | Product removed → check reverts to 🔴 | `publish:update` |
| 5 | Publish anyway | "✅ Publish anyway" → acknowledge warnings modal → confirm | `PublishService/Execute(asset_id, acknowledge_warnings=true)` | `publish_item` created → navigate to Queue (W043) | `publish:execute` |
| 6 | Publish (all passed) | "✅ Publish" (no warnings) | `PublishService/Execute(asset_id)` | `publish_item` created → navigate to Queue (W043) | `publish:execute` |
| 7 | Fix & re-check | "🔄 Fix & re-check" | `PackagingService/RunQA(asset_id, platforms[])` | All checks re-run with updated data | `publish:read` |
| 8 | Auto-crop for platform | "Auto-crop available" on platform | `AssetService/AutoCrop(asset_id, target_aspect)` | New asset variant created → platform check passes | `asset:generate` |
| 9 | Shorten caption | "✏ Shorten caption" (AI suggestion) | `CopilotService/ShortenCaption(caption, max_length)` | AI-suggested shorter caption → user approves or edits | `publish:update` |
| 10 | Go back | "← Back" | — | Navigate to previous screen | Any |

---

## 7. States / State Machine

| State | Condition | Visual |
|---|---|---|
| LOADING | Page loading, asset fetching | Split layout skeleton: video placeholder (left) + check list skeletons (right) |
| CHECKING | QA checks running | Checks appear one-by-one with loading spinners, turning to ✅/🟡/🔴 sequentially |
| ALL_PASSED | All checks ✅ | Green banner: "✅ Tất cả đều OK!" OverallScore green (100%). Publish button green + prominent. |
| HAS_WARNINGS | Some 🟡, no 🔴 | Yellow banner: "🟡 {n} cảnh báo. Bạn có thể đăng hoặc sửa." Publish button available with acknowledge modal. |
| HAS_FAILURES | Any 🔴 | Red banner: "🔴 {n} lỗi cần sửa trước khi đăng." Publish button DISABLED with tooltip "Sửa lỗi trước". Fix button prominent. |
| RECHECKING | Re-running after fix | Checks show loading spinners on affected items only. Non-affected items keep previous status. |
| PUBLISHING | Publish in progress | Publish button shows spinner: "Đang đăng..." Back button disabled. |
| PUBLISHED | Publish successful | Success: "✅ Đã gửi vào hàng chờ!" → auto-redirect to Queue after 2s |
| ERROR | QA API failed | "Không thể kiểm tra nội dung. [Thử lại]" |

---

## 8. Validation Rules

### Caption Edit
| Field | Rule | Error Message |
|---|---|---|
| Caption | Required if not image-only | "Caption là bắt buộc cho video" |
| Caption length | Per-platform max (see rules table) | "Caption vượt giới hạn {platform}: {current}/{max} ký tự" |
| Hashtags | Per-platform max | "Quá nhiều hashtag cho {platform}: {current}/{max}" |

### Publish Confirmation
| Check | Rule | Block? |
|---|---|---|
| 🔴 Failed checks present | Cannot publish | Block: "Sửa lỗi trước khi đăng" |
| 🟡 Warnings present | Can publish with acknowledgement | Modal: "Bỏ qua {n} cảnh báo?" |
| All ✅ passed | Direct publish | No modal needed |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View QA page | ✅ | ✅ | ✅ | ✅ | ✅ (own content) | ❌ | ❌ |
| Edit caption | ✅ | ✅ | ✅ | ✅ | ⚠️ own only | ❌ | ❌ |
| Tag product | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Publish (execute) | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Publish with warnings override | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Auto-crop (generates new asset) | ✅ | ✅ | ✅ | ✅ | ⚠️ credit check | ❌ | ❌ |
| AI caption shortening | ✅ | ✅ | ✅ | ✅ | ⚠️ credit check | ❌ | ❌ |

---

## 10. Navigation Map

```
Packaging QA (/packaging/[asset_id])
├── → /publish/queue                  (After successful publish)
├── → ProductPickerModal              (Tag product — inline modal)
├── → WarningAcknowledgeModal         (Publish with warnings — inline modal)
├── ← /studio/queue                   (Back to Generation Queue)
├── ← /scripts/[id]/review            (Back to Script Review)
└── ← /publish/composer               (Back to Publish Composer)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Asset not found | 404 on `AssetService/Get` | Full page: "Nội dung không tồn tại hoặc đã bị xóa. [← Quay lại]" | Navigate back |
| QA check timeout | Server takes >30s per check | Check item shows: "⚠ Kiểm tra quá thời gian. [Thử lại]" | Per-check retry |
| Brand voice AI error | Copilot service unavailable | Brand voice check shows "⚠ Không kiểm tra được. Bỏ qua." (non-blocking) | Publish without brand check |
| Caption save fails | Network error during inline edit | Toast: "Không lưu được caption. [Thử lại]" — caption reverts to last saved | Manual retry |
| Product tag fails | Commerce service down | Toast: "Không thể tag sản phẩm. [Thử lại]" | Retry or skip |
| Publish execute fails | Server 5xx on execute | Button reverts to normal state + Toast: "Không đăng được. [Thử lại]" | Retry publish |
| Platform connector expired | OAuth expired for target platform | Per-platform: "⚠ Kết nối {platform} hết hạn. [Kết nối lại →]" → Settings/Connectors | Reconnect OAuth |
| Auto-crop fails | Insufficient credits or processing error | Toast: "Không cắt tự động được. ({error})" | Manual crop or skip platform |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| QA check items | `role="listitem"`, `aria-label="Resolution check: passed, 1080 by 1920"` |
| Check status icons | Triple encoding: ✅ icon + "Pass" text + green color (never color alone) |
| Overall score bar | `role="progressbar"`, `aria-valuenow="78"`, `aria-label="QA score: 7 of 9 checks passed"` |
| Video player | Full keyboard controls: Space=play/pause, M=mute, F=fullscreen |
| Caption editor | `role="textbox"`, `aria-label="Caption text"`, char counter announced on change |
| Publish button | `aria-disabled="true"` when failures present, `aria-label="Publish is blocked: fix 1 error first"` |
| Warning modal | `role="alertdialog"`, `aria-labelledby` pointing to warning list title |
| Focus management | On check completion: focus moves to result summary. On error: focus to first failed check. |
| Color contrast | All text meets WCAG 2.1 AA (4.5:1 ratio) |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Shell render | 0ms | App Shell renders (SSR). Split layout visible. |
| Asset fetch | 100-400ms | Video player loads. Media metadata appears. |
| QA checks start | 200ms | Check items appear as rows with spinning icons |
| Technical checks | 500ms-1s | Fastest: resolution, duration, file size checks complete |
| Content checks | 1-2s | Caption analysis, hashtag validation |
| Brand/Safety checks | 2-5s | AI brand voice analysis (most time-consuming) |
| All checks complete | 2-6s total | Overall score populates. Result actions appear. |

### Check Animation
Each check runs sequentially with visual feedback:
1. Row appears with spinning loader
2. Spinner resolves to ✅/🟡/🔴 with 200ms fade transition
3. Check details (value, requirement) slide in
4. Overall score bar animates to current percentage

---

## 14. Performance Requirements

| Metric | Target | Measurement |
|---|---|---|
| LCP | < 2.0s | Video player area or first check result |
| FID | < 100ms | First interaction (edit caption, etc.) |
| CLS | < 0.1 | Acceptable higher CLS due to progressive check results (expected layout changes) |
| TTI | < 2.5s | Edit/publish buttons interactive |
| Full QA completion | < 6s | All checks finished (including AI brand voice) |
| Video preview load | < 1.5s | Video player renders and is playable |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Check progress | Server-Sent Events during QA run | Real-time (each check result streamed) |
| Caption save | Debounced API (saves 1s after last keystroke) | On edit |

### Real-time UX
- QA checks stream results via SSE: each check result arrives as it completes (not waiting for all)
- Progress bar animates incrementally as each check resolves
- No periodic refresh needed — this is a single-session interaction

---

## 16. Localization Notes

- Primary language: Vietnamese
- Check descriptions: Vietnamese ("Độ phân giải ≥ 720p" not "Resolution ≥ 720p")
- File sizes: MB/GB (universal units)
- Caption char counts: Arabic numerals ("180/300 ký tự")
- Platform names: English (TikTok, IG Reels, YouTube)
- Tone: Informative and encouraging — "Tất cả đều OK!" for all passed, "Cần sửa trước khi đăng" for failures
- Date format: Vietnamese (DD/MM/YYYY)

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `packaging_qa.started` | Page load / QA begins | `asset_id`, `asset_type`, `target_platforms[]`, `source` |
| `packaging_qa.check.completed` | Individual check finishes | `check_name`, `result` (pass/warn/fail), `check_value` |
| `packaging_qa.completed` | All checks finish | `total_checks`, `passed`, `warnings`, `failures`, `duration_ms` |
| `packaging_qa.caption.edited` | Caption saved | `asset_id`, `old_length`, `new_length` |
| `packaging_qa.caption.ai_shortened` | AI shortening used | `original_length`, `shortened_length`, `accepted` |
| `packaging_qa.product.tagged` | Product tagged | `product_id`, `product_category` |
| `packaging_qa.published` | Publish confirmed | `asset_id`, `warnings_acknowledged`, `check_score`, `platforms[]` |
| `packaging_qa.published_with_warnings` | Published despite warnings | `warning_types[]`, `warning_count` |
| `packaging_qa.fix_and_recheck` | Re-check clicked | `previous_score`, `fix_actions_taken[]` |
| `packaging_qa.auto_crop.used` | Auto-crop for platform | `platform`, `original_aspect`, `target_aspect` |
| `packaging_qa.abandoned` | User leaves without publishing | `check_score`, `time_spent_ms`, `exit_destination` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Publish CTA button (when all passed) |
| `--color-success` | ✅ Check passed, overall score bar (green zone), "All OK" banner |
| `--color-warning` | 🟡 Warning check, overall score bar (yellow zone), warning banner |
| `--color-danger` | 🔴 Failed check, overall score bar (red zone), failure banner |
| `--color-surface-primary` | Page background |
| `--color-surface-elevated` | Check panels, preview panels |
| `--color-text-primary` | Check names, values |
| `--color-text-secondary` | Requirements, sublabels |
| `--color-border` | Panel borders, check item separators |
| `--radius-card` | Panel border-radius (12px) |
| `--radius-progress` | Progress bar border-radius (8px) |
| `--shadow-card` | Panel elevation shadow |
| `--font-mono` | File sizes, resolutions, technical values |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/packaging/[asset_id]/+page.svelte`
- **Server load**: `+page.server.ts` → fetch asset + draft publish item
- **Params**: `[asset_id]` = UUID

### QA Check Execution
```
onMount:
  const sse = new EventSource(`/api/packaging/qa?asset_id=${assetId}`)
  sse.onmessage = (event) => {
    const check = JSON.parse(event.data)
    updateCheckResult(check.name, check.result, check.details)
    updateOverallScore()
  }
  sse.addEventListener('complete', () => sse.close())
```

### Check Categories (Server-side)
1. **Technical** (fast, deterministic): Resolution, duration, file size, aspect ratio, codec
2. **Content** (medium): Caption presence, length, hashtag count, product tag, first comment
3. **Brand/Safety** (slow, AI): Brand voice analysis via Copilot, profanity filter, copyright scan

### Platform Rule Engine
- Rules stored in `platform_publish_rules` config table
- Each platform has: `max_duration`, `min_resolution`, `max_file_size`, `optimal_aspect`, `max_caption_length`, `max_hashtags`
- Rules fetched once and cached client-side for instant validation on edits

### Inline Caption Editing
- Uses `contenteditable` div with live char counter
- Debounced save: 1s after last keystroke → `PublishService/UpdateDraft`
- On save: affected checks (caption length, brand voice) auto re-run

---

## 20. Related Screens

| Screen | Relationship |
|---|---|
| [W030] Generation Queue | Upstream: asset source |
| [W043] Publish Queue | Downstream: after QA pass |
| [W048] Publish Composer | Alternative entry: manual compose |
| [W020] Script Review | Alternative entry: approved script assets |
| [M056] Mobile Packaging QA | Mobile equivalent |

---

## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Full Tier A rewrite**: Upgraded from 205-line Tier C with generic boilerplate to 440+ line full spec. Added: complete component hierarchy, screen-specific QA check rules per platform (TikTok/IG/YT/X), 7-role RBAC permission matrix with warning override logic, 8 screen-specific error cases (AI timeout, OAuth expiry, auto-crop failure), 11 analytics events, SSE streaming for progressive check results, inline caption editing, AI caption shortening, product tag workflow. Removed all generic boilerplate. Standardized Screen ID from W43 to W056. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C) | System |
