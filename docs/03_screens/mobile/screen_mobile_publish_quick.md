# Screen: Mobile — Quick Publish

> **Screen ID**: M006
> **Module**: M11 — Publish Hub
> **Route**: `/publish/quick` (modal push navigation)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 01 §4, Product Freeze §18-19, A1 Schema (publish_jobs, publish_items, connectors), B5 RBAC §2.7

---
## 1. Purpose & Context

Mobile Quick Publish is a streamlined single-screen flow for publishing content directly from mobile. Users select media (from device gallery or AI Studio assets), add AI-assisted captions and hashtags, choose target platforms with real-time compatibility checks, set schedule or publish immediately — all optimized for one-thumb, one-flow completion in under 60 seconds.

### User Goals
- Publish content to multiple platforms from phone without needing desktop
- Get AI-written captions and hashtags that match platform best practices
- Verify content compatibility per platform before publishing (aspect ratio, duration, file size)
- Schedule posts for optimal engagement times (AI-suggested)

### Business Goals
- Increase mobile publishing rate (target: 40% of all publishes from mobile)
- Reduce time-to-publish (target: < 60 seconds average)
- Drive AI caption/hashtag adoption (reduces publishing friction)
- Enable spontaneous "capture and publish" mobile workflow

### When This Screen Is Used
- Spontaneous publishing: Captured content → immediate publish
- Post-production: AI Studio asset completed → publish
- Scheduled content: Pre-prepared script → quick schedule
- Share to platform: From camera roll or gallery

### Entry Points
- Home Dashboard (M001): Quick Action "📤 Đăng bài nhanh"
- Studio Launcher (M021): "📤 Publish" on completed job
- Asset Preview: "📤 Đăng bài" button
- Script detail: "📤 Publish script assets"
- Deep link from push notification: "Asset ready — publish now"
- iOS Share Sheet: Share media → Creativanta → Quick Publish

### Exit Points
- "✅ Đã đăng thành công!" → Pop back to previous screen
- "⏰ Đã lên lịch!" → Pop back with scheduled indicator
- "← Cancel" → Confirmation dialog → Pop back (discard draft)
- Error → stay on page with retry

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `publish:create` permission (Editor+ roles)
- At least one platform connected and token valid in active workspace
- Media file available (gallery pick or asset reference)

### Postconditions
- Successful publish: `publish_job` created, content pushed to platform API(s)
- Schedule: `publish_job` created with `scheduled_at`, added to publish calendar
- Draft saved: if user navigates away, draft auto-saved for 24h
- Analytics event logged (publish method, platforms, AI features used)

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Cancel   📤 Đăng bài nhanh                   [Publish →]         │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Step 1: Media ──────────────────────────────────────────────────┐│
│ │ [📸 Từ thư viện] [🎬 Từ AI Studio] [📷 Chụp ngay]              ││
│ │                                                                    ││
│ │ ┌─────────────────────────────────────────────────────────────┐   ││
│ │ │ 🎬 skincare_tips_final.mp4                                  │   ││
│ │ │ [Video preview — first frame thumbnail]                     │   ││
│ │ │                                                             │   ││
│ │ │ Duration: 52s · Size: 45MB · Ratio: 9:16                   │   ││
│ │ │ [👁 Preview] [✂ Trim] [✕ Remove]                          │   ││
│ │ └─────────────────────────────────────────────────────────────┘   ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Step 2: Caption ────────────────────────────────────────────────┐│
│ │ ┌─────────────────────────────────────────────────────────────┐   ││
│ │ │ Chia sẻ 5 tips skincare buổi sáng cho da căng bóng ✨      │   ││
│ │ │                                                             │   ││
│ │ │ Comment "link" để nhận trọn bộ skincare routine 💕         │   ││
│ │ │ #skincare #beautytips #morningroutine                       │   ││
│ │ └─────────────────────────────────────────────────────────────┘   ││
│ │ Ký tự: 142/2200                                                   ││
│ │ [🤖 AI viết caption] [📋 Từ script] [🔄 Viết lại]              ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Step 3: Hashtags ───────────────────────────────────────────────┐│
│ │ [#skincare] [#beauty] [#tips] [#morningroutine] [#viral]         ││
│ │ [#glowup] [+ Thêm]                                               ││
│ │ 6/30 hashtags · [🤖 AI gợi ý thêm]                              ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Step 4: Platforms ──────────────────────────────────────────────┐│
│ │ Chọn nền tảng đăng:                                               ││
│ │                                                                    ││
│ │ [✅ 🎵 TikTok]     🟢 Ready                                     ││
│ │   9:16 ✅ · <3min ✅ · Caption ✅                                ││
│ │                                                                    ││
│ │ [✅ 📸 IG Reels]   🟡 Warning                                    ││
│ │   9:16 ✅ · <90s ✅ · Caption: 🟡 dài (tự cắt 2200→2200)       ││
│ │                                                                    ││
│ │ [☐ 📺 YouTube Shorts] 🟡 Warning                                ││
│ │   9:16 ✅ · <60s ❌ Video quá dài (52s > 60s Shorts limit)       ││
│ │   💡 Gợi ý: Trim video < 60s hoặc đăng dạng thường               ││
│ │                                                                    ││
│ │ [☐ 🛍 Shopee Video] ⚫ Not connected                            ││
│ └──────────────────────────────────────────────────────────────────┘│
│                                                                      │
│ ┌─ Step 5: Schedule ──────────────────────────────────────────────┐ │
│ │ [◉ Đăng ngay] [○ Lên lịch]                                      │ │
│ │                                                                    │ │
│ │ 🤖 AI gợi ý: "Đăng lúc 19:00 hôm nay — engagement cao nhất     │ │
│ │ dựa trên dữ liệu 30 ngày qua"                                    │ │
│ │ [⏰ Áp dụng 19:00 →]                                              │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌──────────────────────────────────────────────────────────────────┐ │
│ │          [📤 Đăng bài (2 nền tảng) — 0 credits]                 │ │
│ └──────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
MobileQuickPublishPage
├── AppBar
│   ├── CancelButton ("← Cancel" with unsaved changes dialog)
│   ├── PageTitle ("📤 Đăng bài nhanh")
│   └── PublishButton (text button, becomes active when valid)
├── ScrollableForm (keyboard-aware)
│   ├── MediaSection ("Step 1")
│   │   ├── SourceSelector
│   │   │   ├── GalleryButton ("📸 Từ thư viện" → image_picker)
│   │   │   ├── StudioButton ("🎬 Từ AI Studio" → asset picker)
│   │   │   └── CameraButton ("📷 Chụp ngay" → camera)
│   │   └── MediaPreview (conditional — shown after selection)
│   │       ├── Thumbnail (large preview with tap-to-play for video)
│   │       ├── FileInfo ("Duration: 52s · Size: 45MB · Ratio: 9:16")
│   │       ├── PreviewButton ("👁 Preview" → fullscreen player)
│   │       ├── TrimButton ("✂ Trim" → in-app trimmer, video only)
│   │       └── RemoveButton ("✕ Remove")
│   ├── CaptionSection ("Step 2")
│   │   ├── CaptionTextarea (auto-resize, character counter)
│   │   ├── CharacterCounter ("142/2200" — color changes near limit)
│   │   ├── AIWriteButton ("🤖 AI viết caption" → streaming fill)
│   │   ├── FromScriptButton ("📋 Từ script" → script selector)
│   │   └── RewriteButton ("🔄 Viết lại" → AI rewrites existing)
│   ├── HashtagSection ("Step 3")
│   │   ├── HashtagChipGroup (editable chips, tappable to remove)
│   │   ├── AddHashtagInput (text input with # auto-prefix)
│   │   ├── HashtagCounter ("6/30 hashtags")
│   │   └── AISuggestButton ("🤖 AI gợi ý thêm")
│   ├── PlatformSection ("Step 4")
│   │   └── PlatformCheckCard[]
│   │       ├── PlatformCheckbox (toggle on/off)
│   │       ├── PlatformIcon + Name
│   │       ├── CompatibilityStatus (🟢 Ready / 🟡 Warning / 🔴 Error / ⚫ Not connected)
│   │       ├── CheckResults
│   │       │   ├── AspectRatioCheck ("9:16 ✅")
│   │       │   ├── DurationCheck ("<3min ✅" or "❌ Video quá dài")
│   │       │   ├── FileSizeCheck ("45MB ✅" or "❌ Quá lớn")
│   │       │   └── CaptionLengthCheck ("✅" or "🟡 dài — tự cắt")
│   │       └── Suggestion (optional — "💡 Trim video < 60s")
│   └── ScheduleSection ("Step 5")
│       ├── PublishNowRadio ("◉ Đăng ngay")
│       ├── ScheduleRadio ("○ Lên lịch")
│       ├── DateTimePicker (conditional — shown when "Lên lịch" selected)
│       └── AISuggestion ("🤖 Đăng lúc 19:00..." + apply button)
└── PublishButton (sticky bottom — primary CTA)
    ├── ButtonLabel ("📤 Đăng bài (2 nền tảng) — 0 credits")
    └── LoadingState (spinner when publishing)
```

---
## 5. Displayed Data

| Element | Source | API | Display Format | Cache |
|---|---|---|---|---|
| Media metadata | Device file system / studio_assets | `FileService/GetMetadata` | Duration, size, ratio | — |
| Connected platforms | `connectors WHERE status='active'` | `ConnectorService/GetAllStatus()` | Platform list with status | 5m |
| Platform compatibility | Computed from media + platform rules | `PublishService/CheckCompatibility(media, platforms[])` | Per-platform check results | On-demand |
| AI caption | AI-generated | `CopilotService/Query(mode=caption, context)` | Streaming text fill | — |
| AI hashtags | AI-generated | `CopilotService/Query(mode=hashtags, context)` | Chip list | — |
| Best time suggestion | ML model on engagement data | `CopilotService/Query(mode=best_time)` | "Đăng lúc 19:00 hôm nay" | 30m |
| Character limits | Static config per platform | Included in compatibility | Counter color: green/yellow/red | — |
| Script content | `scripts.body` | `ScriptService/Get(id)` | Pre-fill caption from script | — |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | Select from gallery | Tap "📸 Từ thư viện" | Picker | Device gallery picker | Media preview appears. Platform checks run. | `publish:create` |
| 2 | Select from studio | Tap "🎬 Từ AI Studio" | Navigate | Asset picker modal | Select asset. Preview appears. | `publish:create` |
| 3 | Capture photo/video | Tap "📷 Chụp ngay" | Camera | Camera opens | Capture. Preview appears. | `publish:create` |
| 4 | Preview media | Tap "👁 Preview" | View | — | Fullscreen media player | `publish:create` |
| 5 | Trim video | Tap "✂ Trim" | Edit | In-app trimmer | Video trimmed → metadata updates → re-check compatibility | `publish:create` |
| 6 | Remove media | Tap "✕ Remove" | Remove | — | Media cleared, back to step 1 | `publish:create` |
| 7 | AI write caption | Tap "🤖 AI viết" | AI | `CopilotService/Query(mode=caption)` | Caption streams into textarea (typing animation) | `copilot:use_help` |
| 8 | Load from script | Tap "📋 Từ script" | Select | Script picker modal | Caption pre-filled from script text | `script:read` |
| 9 | Rewrite caption | Tap "🔄 Viết lại" | AI | `CopilotService/Query(mode=rewrite)` | Existing caption replaced with AI version | `copilot:use_help` |
| 10 | AI suggest hashtags | Tap "🤖 AI gợi ý" | AI | `CopilotService/Query(mode=hashtags)` | Hashtag chips added | `copilot:use_help` |
| 11 | Add hashtag | Type in add input + Enter | Input | — | New chip added. Counter updates. | `publish:create` |
| 12 | Remove hashtag | Tap chip ✕ | Remove | — | Chip removed. Counter updates. | `publish:create` |
| 13 | Toggle platform | Tap platform checkbox | Toggle | `PublishService/CheckCompatibility` (if newly added) | Platform enabled/disabled. Check results shown. | `publish:create` |
| 14 | Apply AI time | Tap "⏰ Áp dụng 19:00 →" | Apply | — | Schedule radio selected. Time set to suggested. | `publish:create` |
| 15 | Pick schedule date/time | Tap date picker | Picker | — | DateTime selected | `publish:create` |
| 16 | Publish now | Tap bottom "📤 Đăng bài" (with "Đăng ngay" selected) | Primary CTA | `PublishService/Execute(media, caption, hashtags, platforms[])` | Full-screen overlay → success → pop back | `publish:create` |
| 17 | Schedule | Tap bottom button (with "Lên lịch" selected) | Primary CTA | `PublishService/Schedule(media, caption, hashtags, platforms[], scheduled_at)` | Confirmation → success → pop back | `publish:create` |
| 18 | Cancel | Tap "← Cancel" | Destructive | — | Confirmation dialog if changes made → pop back | — |

---
## 7. Validation Rules

### Media
| Check | Rule | Error |
|---|---|---|
| Media required | At least 1 media file | "📸 Chọn ảnh hoặc video để đăng" |
| File size max | Per platform max (TikTok: 287MB, IG: 100MB, YT: 256MB) | "File quá lớn cho {platform}. Tối đa {max}MB." |
| Duration max | Per platform (TikTok: 3min, IG Reels: 90s, YT Shorts: 60s) | "Video quá dài cho {platform}. Tối đa {max}." |
| Aspect ratio | Platform preference (TikTok: 9:16 preferred) | Warning: "🟡 Video 16:9 sẽ hiển thị letterbox trên TikTok" |
| File format | mp4, mov, jpg, png, webp | "Định dạng không được hỗ trợ" |

### Caption
| Check | Rule | Error |
|---|---|---|
| Caption max | Platform-specific (TikTok: 2200, IG: 2200, YT: 5000) | Per-platform truncation warning |
| Empty caption | Allowed but warning | "⚠️ Nên viết caption để tăng engagement" |

### Platform
| Check | Rule | Error |
|---|---|---|
| At least one | ≥1 platform selected | "Chọn ít nhất 1 nền tảng" |
| Connected | Platform must be connected | Show "⚫ Not connected" |
| Token valid | Platform token not expired | "🔴 Token hết hạn — kết nối lại" |

### Schedule
| Check | Rule | Error |
|---|---|---|
| Future time | Scheduled time must be > 5 minutes from now | "Thời gian phải sau ít nhất 5 phút" |
| Max future | Within 90 days | "Tối đa lên lịch trước 90 ngày" |

### Hashtags
| Check | Rule | Error |
|---|---|---|
| Max count | Platform max (TikTok: 30, IG: 30) | "Tối đa {max} hashtags cho {platform}" |
| Format | Must start with #, alphanumeric, no spaces | Auto-format on input |

---
## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| EMPTY | No media selected | "📸 Chọn media để bắt đầu" — only media source buttons visible. Other sections greyed. | Pick media |
| MEDIA_SELECTED | Media chosen | Full form visible. Platform checks run automatically. | Fill form |
| AI_GENERATING | AI writing caption/hashtags | Textarea shows typing animation. AI buttons disabled. | Wait (< 5s typical) |
| CHECKING_PLATFORMS | Platform compatibility running | Each platform shows spinner → ✅/🟡/🔴 | Wait (< 2s) |
| READY | All validation passed, ≥1 platform ✅ | Bottom button enabled: "📤 Đăng bài ({count} nền tảng)" | Publish or schedule |
| HAS_WARNINGS | Some platforms have 🟡 warnings | Button enabled with warning: "📤 Đăng (có cảnh báo)" | Review warnings or publish anyway |
| HAS_ERRORS | Selected platform has 🔴 errors | Bottom button disabled. Red text: "Sửa lỗi trước khi đăng" | Fix errors |
| PUBLISHING | API call in progress | Full-screen overlay with progress per platform | Wait |
| PUBLISHING_PARTIAL | Some platforms succeeded, some failed | Mixed results screen. "✅ TikTok OK · ❌ IG failed" | Retry failed |
| SUCCESS | All platforms published | "✅ Đăng thành công!" with confetti → auto-pop back (3s) | View or go back |
| SCHEDULED | Scheduled successfully | "⏰ Đã lên lịch cho {time}!" → pop back | Go back |
| DRAFT_SAVED | User navigated away mid-form | Invisible — draft saved to local storage | Resume later |
| ERROR | API failed | Error dialog with retry or cancel options | Retry or cancel |

---
## 9. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| Access quick publish | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| AI caption/hashtags | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Select platforms | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Publish immediately | ✅ | ✅ | ✅ | ❌ (needs approval) | ❌ | ❌ | ❌ |
| Schedule | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Editor**: Can create publish jobs but status is "Pending approval". Manager/Admin must approve before content goes live.
- **Contributor/Viewer/External**: No access to publish flow.

---
## 10. Mobile-specific UX

### Gestures & Haptics
| Gesture | Target | Haptic | Result |
|---|---|---|---|
| Tap media source | Source button | Light | Open picker/camera |
| Swipe left on hashtag | Chip | Light | Remove hashtag |
| Long press caption | Textarea | — | Select text for editing |
| Tap platform card | Platform row | Light | Toggle on/off |
| Bottom button tap | Publish CTA | Medium (on publish start) | Begin publishing |

### Keyboard Behavior
- Caption textarea: soft keyboard appears, form scrolls up
- Hashtag input: keyboard with # button prominent
- "Done" on keyboard: scroll to next section

### Publishing Overlay Animation
```
Phase 1: "📤 Đang upload media..."                  (0-50%)
Phase 2: "📤 Đang đăng lên TikTok..."               (50-75%)
Phase 3: "📤 Đang đăng lên Instagram Reels..."       (75-100%)
Phase 4: "✅ Đăng thành công! 🎉"                    (done — confetti burst)
```

### Offline Behavior
- **Available offline**: Media selection from gallery, caption writing
- **Unavailable offline**: AI features, platform checks, actual publishing
- Draft saved locally → sync and publish when back online

---
## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| No platforms connected | Platform section shows: "Kết nối ít nhất 1 nền tảng. [→ Cài đặt]" |
| All platforms have errors | Button disabled: "Sửa lỗi hoặc kết nối nền tảng phù hợp" |
| Media > 250MB | Show upload progress with estimated time. Allow background upload. |
| Platform rate limit during publish | "🟡 TikTok: Rate limited — tự đăng lại sau 5 phút" (auto-retry) |
| Caption in wrong language for platform | AI warning: "⚠️ Caption tiếng Việt trên YouTube? Nên thêm English subtitle." |
| Network lost during publish | "📡 Mất kết nối — đang lưu draft. Tự đăng lại khi có mạng." |
| User force-quits during publish | Draft saved. Resume on next open with "Bạn có bài chưa đăng xong." |
| Camera permission denied | "📷 Cần quyền truy cập camera. [Mở Cài đặt]" |
| Gallery permission denied | Show system permission dialog. On deny: show explanation + settings link. |

---
## 12. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `publish.quick.opened` | Page opens | `source` (dashboard/studio/asset/script/share_sheet) |
| `publish.quick.media_selected` | Media chosen | `source` (gallery/studio/camera), `type` (video/image), `size_mb` |
| `publish.quick.ai_caption_used` | AI caption generated | `mode` (write/rewrite), `length` |
| `publish.quick.ai_hashtags_used` | AI hashtags generated | `count` |
| `publish.quick.platform_selected` | Platform toggled | `platform`, `compatibility_status` |
| `publish.quick.ai_time_applied` | AI time suggestion used | `suggested_time` |
| `publish.quick.published` | Publish successful | `platforms[]`, `schedule_type` (now/scheduled), `ai_features_used` |
| `publish.quick.failed` | Publish failed | `platform`, `error_type` |
| `publish.quick.cancelled` | User cancelled | `filled_sections[]`, `time_spent_seconds` |

---
## 13. Performance Requirements

| Metric | Target |
|---|---|
| Page open (empty state) | < 500ms |
| Media selection → preview | < 1s |
| Platform compatibility check | < 2s per platform |
| AI caption generation | < 5s (streamed) |
| AI hashtag suggestion | < 3s |
| Publish per platform | < 30s (media upload + API call) |
| Total flow (open → published) | < 60s (target UX) |

---
## 14. Flutter Implementation Notes

### Widget Structure
- **Route**: `/publish/quick` → `QuickPublishPage extends ConsumerStatefulWidget`
- **State**: Riverpod `quickPublishProvider` (form state + validation + API)
- **Media picker**: `image_picker` package (gallery + camera)
- **Video trim**: `video_trimmer` package
- **Caption**: `TextFormField` with auto-resize
- **Platform checks**: Parallel async calls, riverpod `FutureProvider` per platform
- **AI features**: `CopilotService/Query` with streaming response

### Draft Auto-Save
```dart
// Save draft every 10 seconds while form has content
Timer.periodic(Duration(seconds: 10), (_) {
  if (hasUnsavedChanges) {
    draftStore.save(DraftPublish(
      media: selectedMedia,
      caption: captionController.text,
      hashtags: selectedHashtags,
      platforms: selectedPlatforms,
    ));
  }
});

// On page open, check for draft
onInit() {
  final draft = draftStore.get('quick_publish');
  if (draft != null) {
    showDialog('Bạn có bài chưa đăng. [Tiếp tục] [Xóa draft]');
  }
}
```

### Publishing Flow
```dart
Future<void> publishToAll() async {
  setState(() => state = PublishState.publishing);
  
  final results = <PlatformPublishResult>[];
  for (final platform in selectedPlatforms) {
    setState(() => currentPlatform = platform);
    try {
      final result = await publishService.execute(
        media: selectedMedia,
        caption: captionText,  // platform-truncated
        hashtags: selectedHashtags,
        platform: platform,
      );
      results.add(PlatformPublishResult.success(platform, result));
    } catch (e) {
      results.add(PlatformPublishResult.failure(platform, e));
    }
  }
  
  if (results.every((r) => r.isSuccess)) {
    setState(() => state = PublishState.success);
    HapticFeedback.heavyImpact();
  } else {
    setState(() => state = PublishState.partialFailure(results));
  }
}
```

---
## 15. Navigation Map

```
Quick Publish (/publish/quick)
├── → Gallery picker (OS-level, returns to page)
├── → Camera (OS-level, returns to page)
├── → /studio/assets (studio asset picker, returns with selection)
├── → /scripts (script selector for caption, returns with text)
├── → Video trimmer (in-app modal, returns trimmed video)
← pop back to source screen on success/cancel
```


---
## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W043] Web Publish Queue | Web equivalent (more complex, multi-item) |
| [W044] Web Package & Upload | Web packaging flow |
| [M001] Mobile Home Dashboard | Entry via quick action |
| [M021] Mobile Studio | Entry via completed asset |
| [M025] Mobile Calendar | Schedule view destination |
---
## Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached data | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được dữ liệu. [Thử lại]" | Retry |
| Not found | 404 | "Không tìm thấy" → navigate back | Back |
| Permission denied | 403 | "Không có quyền truy cập" | Contact admin |

---
## Accessibility

| Element | Requirement |
|---|---|
| Interactive elements | Minimum 48×48dp tap targets |
| Icons with meaning | `Semantics(label:)` descriptive text |
| Status indicators | Color not sole indicator; text/icon also present |
| Dynamic content | `Semantics(liveRegion: true)` for updates |
| Contrast | 4.5:1 minimum ratio |

---
## Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + shimmer placeholders |
| Primary data | 200-500ms | Content populates progressively |
| User action | <1s | Inline spinner → result feedback |

---
## Localization Notes

- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator: "1.200.000đ")
- Date: DD/MM/YYYY
- Numbers: dot separator (1.234)
- Relative time: "2 giờ trước", "1 ngày trước"
- Tone: Friendly, action-oriented

---
## Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Primary actions, CTAs |
| `--color-success` | Positive states, confirmations |
| `--color-warning` | Warning indicators |
| `--color-danger` | Error states, destructive actions |
| `--color-surface-elevated` | Cards, elevated surfaces |

---
## Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | Patch | Removed duplicate template sections. Replaced with screen-specific Error Handling, Accessibility, Loading, Localization, Design Tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
