# Screen: Mobile — Idea Board

> **Screen ID**: M017
> **Module**: M05 — Idea Engine
> **Route**: `/ideas` (bottom tab: 💡)
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 01 §4, Product Freeze §12/§13, A1 Schema (ideas, idea_scores, idea_tags), B5 RBAC §2.7

---
## 1. Purpose & Context

Mobile Idea Board — a vertical card list (not Kanban) optimized for one-thumb mobile operation. Ideas sortable by status, AI score, or date, with swipe gestures for rapid status progression. Provides quick add via FAB, filter by status chips, and AI idea generation. This is the mobile entry point for the content pipeline.

### User Goals
- Browse and triage content ideas while on the go (commute, between activities)
- Quickly change idea status with intuitive swipe gestures (inbox → evaluating → approved → in script)
- Capture new ideas immediately via quick add (before forgetting)
- Use AI to generate ideas based on trends and past performance

### Business Goals
- Maintain a healthy content pipeline (target: 10+ ideas in "Inbox" at all times)
- Reduce idea-to-script conversion time (mobile triage enables faster progression)
- Increase AI-generated idea adoption (mobile-first generation experience)
- Prevent content droughts (alerts when pipeline runs low)

### When This Screen Is Used
- **Commute triage**: Review overnight AI-scored ideas, swipe to advance
- **Inspiration capture**: Quick add an idea before it's forgotten
- **Content planning**: Browse pipeline before deciding what to write next
- **AI exploration**: Generate ideas based on trending topics

### Entry Points
- Bottom nav: 💡 Ideas tab (2nd position)
- Home Dashboard (M001): "Ideas Pipeline" KPI tap
- Push notification: "🤖 AI scored 5 new ideas — 2 scored 90+"
- Trend detail (M014): "💡 Tạo ý tưởng từ xu hướng" → creates idea and opens board
- Script editor (M020): "← Back to ideas"

### Exit Points
- Tap idea card → Idea Detail (M018 — push navigation)
- "🤖 AI Gen" → AI Idea Generator (M019 — push navigation)
- Swipe left "📝 Script" → Script Editor (M020) with idea pre-linked
- Tab navigation: any other bottom tab

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `idea:read` permission (Contributor+ roles)
- Active workspace selected

### Postconditions
- Status change via swipe → `ideas.status` updated, position recalculated
- Quick add → new `idea` record created with status "inbox" and position 0
- AI generation → new ideas created in "inbox" status
- Filter state persisted per session (not persisted long-term)

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ 💡 Ý tưởng (45)                  [Sort ▾] [Filter ▾] [🤖 AI Gen]  │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Status Chips (horizontal scroll) ──────────────────────────────┐ │
│ │ [✱ Tất cả (45)] [📥 Inbox (12)] [🔍 Đánh giá (8)]            │ │
│ │ [✅ Duyệt (15)] [📝 Script (7)] [☑ Xong (3)]                  │ │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Pipeline Health Banner (conditional - if Inbox < 5) ──────────┐ │
│ │ ⚠️ Pipeline thấp! Chỉ 3 ý tưởng trong Inbox.                  │ │
│ │ [🤖 AI gợi ý thêm →]                                           │ │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Idea Card ────────────────────────────────────────────────────┐  │
│ │ 💡 "5 sai lầm skincare mỗi sáng"                    ⭐ 88     │  │
│ │ 📥 Inbox · 🎵 TikTok · Source: 🤖 AI · 2h ago               │  │
│ │ Tags: [skincare] [mistakes] [+2]                               │  │
│ │ 📊 Predicted: 50K-100K views · Engagement: High                │  │
│ │                                      ← swipe: 📝 | ✅ →      │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Idea Card ────────────────────────────────────────────────────┐  │
│ │ 💡 "POV budget skincare 100K"                        ⭐ 82     │  │
│ │ 🔍 Đánh giá · 🎵 TikTok · Source: 🔥 Trend · 1d ago         │  │
│ │ Tags: [skincare] [budget]                                       │  │
│ │ 📊 Predicted: 30K-60K views · Trend: +180%                     │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Idea Card ────────────────────────────────────────────────────┐  │
│ │ 💡 "Review serum Vitamin C 200K"                     ⭐ 65     │  │
│ │ ✅ Đã duyệt · 📸 Instagram · Source: ✋ Manual · 3d ago       │  │
│ │ Tags: [review] [serum]                                          │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ... pull up for more (infinite scroll) ...                           │
│                                                                      │
│ ┌─ FAB ───────┐                                                      │
│ │ [+ Thêm]    │                                                      │
│ └─────────────┘                                                      │
│                                                                      │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [💡•] [🎬] [💬] [📊]                                          │
└──────────────────────────────────────────────────────────────────────┘
```

### Quick Add Bottom Sheet (FAB tap)
```
┌─────────────────────────────────────────────────────────────────┐
│ + Thêm ý tưởng mới                                              │
│                                                                   │
│ Tiêu đề *                                                        │
│ ┌─────────────────────────────────────────────────────────────┐  │
│ │ VD: "So sánh kem chống nắng dưới 200K"                     │  │
│ └─────────────────────────────────────────────────────────────┘  │
│                                                                   │
│ Mô tả (tùy chọn)                                                │
│ ┌─────────────────────────────────────────────────────────────┐  │
│ │                                                             │  │
│ └─────────────────────────────────────────────────────────────┘  │
│                                                                   │
│ Nền tảng: [🎵 TikTok ▾]                                        │
│ Tags: [skincare] [+ Thêm tag]                                    │
│                                                                   │
│ [🤖 AI đánh giá ngay]  ←─ AI scores the idea immediately       │
│                                                                   │
│ [Tạo ý tưởng →]                                                  │
└─────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
MobileIdeaBoardPage
├── AppBar
│   ├── Title ("💡 Ý tưởng") + TotalCount
│   ├── SortButton (Score ↓ / Date ↓ / Status)
│   ├── FilterButton (platform, source, score range)
│   └── AIGenerateButton ("🤖 AI Gen")
├── StatusFilterChips (horizontal ScrollView)
│   └── StatusChip[] (All, Inbox, Evaluating, Approved, In Script, Done)
│       ├── StatusIcon
│       ├── Label
│       └── Count
├── PipelineHealthBanner (conditional — shown if Inbox count < 5)
│   ├── WarningText ("Pipeline thấp!")
│   └── AIGenerateCTA ("🤖 AI gợi ý thêm →")
├── IdeaCardList (pull-to-refresh + infinite scroll)
│   └── IdeaCard[] (swipeable — Dismissible widget)
│       ├── IdeaTitle (bold, max 2 lines)
│       ├── ScoreBadge (color-coded: 🟢 ≥80, 🟡 50-79, 🔴 <50)
│       ├── StatusChip (Inbox/Evaluating/Approved/In Script/Done)
│       ├── PlatformIcon (🎵/📸/📺)
│       ├── SourceBadge (🤖 AI / 🔥 Trend / ✋ Manual / 💡 Opportunity)
│       ├── TagChips (max 2 visible + "+N" badge)
│       ├── PredictionRow (conditional)
│       │   ├── ViewPrediction ("50K-100K views")
│       │   └── EngagementLevel ("High" / "Medium" / "Low")
│       ├── TrendGrowth (if from trend: "+180%")
│       ├── RelativeTime ("2h ago")
│       ├── SwipeLeftAction → StatusAdvance or Write Script
│       └── SwipeRightAction → Approve / Advance
├── FAB ("+ Thêm ý tưởng")
│   └── QuickAddBottomSheet (modal)
│       ├── TitleInput (required)
│       ├── DescriptionInput (optional)
│       ├── PlatformSelector
│       ├── TagInput (chip input)
│       ├── AIScoreButton ("🤖 AI đánh giá ngay")
│       └── CreateButton ("Tạo ý tưởng →")
└── BottomNavBar (💡 tab highlighted)
```

---
## 5. Displayed Data

| Element | Source | API | Display Format | Cache |
|---|---|---|---|---|
| Ideas list | `ideas ORDER BY position, ai_score DESC` | `IdeaService/ListMobile(status, sort, cursor)` | Card list, 20 per page | 5m |
| AI score | `ideas.ai_score` | Included | Badge: 🟢 ≥80, 🟡 50-79, 🔴 <50. Number on badge. | 5m |
| Status | `ideas.status` | Included | Chip: Inbox/Evaluating/Approved/In Script/Done | 5m |
| Platform | `ideas.target_platform` | Included | Platform icon | 5m |
| Source | `ideas.source_type` | Included | Badge: "🤖 AI" / "🔥 Trend" / "✋ Manual" / "💡 Opportunity" | 5m |
| Tags | `idea_tags` join | Included | Chip list (max 2 visible + "+N") | 5m |
| Prediction | `ideas.predicted_views`, `ideas.predicted_engagement` | Included | "50K-100K views" range, engagement level | 5m |
| Linked trend growth | `trends.growth_rate` (join via from_trend_id) | Included | "+180%" | 5m |
| Status counts | `COUNT GROUP BY status` | `IdeaService/GetStatusCounts()` | Per-chip count | 5m |
| Pipeline health | Computed: `COUNT WHERE status='inbox'` | Same as counts | Warning if < 5 | 5m |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | Open idea detail | Tap card | Navigate | — | Push → M018 Idea Detail | `idea:read` |
| 2 | Quick add | Tap FAB → Fill bottom sheet → "Tạo" | Create | `IdeaService/Create(title, desc, platform, tags)` | Bottom sheet closes. Card appears in list (Inbox, position 0). Haptic success. | `idea:create` |
| 3 | AI score on create | "🤖 AI đánh giá ngay" in bottom sheet | AI | `CopilotService/ScoreIdea(title, desc)` | Score badge appears on bottom sheet before creation. | `copilot:use_help` |
| 4 | Swipe advance | Swipe right on card → threshold reveal | Status | `IdeaService/Update(id, status=next_status)` | Card animates to updated status. Haptic medium. Toast "→ {new_status}". Chip counts update. | `idea:update` |
| 5 | Swipe to script | Swipe left on card → threshold reveal (blue) | Navigate | `IdeaService/Update(id, status='in_script')` | Status updated. Push → M020 Script Editor with idea_id pre-linked. | `idea:update` + `script:create` |
| 6 | Filter by status | Tap status chip | Filter | `IdeaService/ListMobile(status=...)` | List shows only matching status. Active chip highlighted. | `idea:read` |
| 7 | Sort ideas | Tap sort button → picker | Sort | `IdeaService/ListMobile(sort=...)` | List reorders. | `idea:read` |
| 8 | Filter by platform/source | Filter button → filter drawer | Filter | `IdeaService/ListMobile(filters)` | List filters. Active filter badge on button. | `idea:read` |
| 9 | Pull refresh | Pull-down gesture | Refresh | Refetch list | List updates. Haptic light. | `idea:read` |
| 10 | AI generate ideas | "🤖 AI Gen" in app bar or pipeline banner | Navigate | — | Push → M019 AI Idea Generator page | `idea:generate` |
| 11 | Long press context menu | Long press card | Menu | — | Bottom sheet: [Edit tags, Change platform, Delete, Share] | `idea:update` |
| 12 | Delete idea | Long press → "🗑 Xóa" → confirm | Destructive | `IdeaService/Delete(id)` | Confirmation dialog → card fades out. Toast "Đã xóa." | `idea:delete` |
| 13 | Infinite scroll | Scroll to bottom | Paginate | `IdeaService/ListMobile(cursor=next)` | More cards loaded. | `idea:read` |

---
## 7. Validation Rules

### Quick Add
| Check | Rule | Error |
|---|---|---|
| Title | Required, 5-200 chars | "Tiêu đề phải từ 5-200 ký tự" |
| Description | Optional, max 2000 chars | "Mô tả tối đa 2000 ký tự" |
| Tags | Optional, max 10 tags | "Tối đa 10 tags" |
| Tag name | Alphanumeric + hyphen, 2-30 chars | "Tag không hợp lệ" |
| Platform | Optional (defaults to primary workspace platform) | — |

---
## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial page load | Card shimmer list (6 placeholders) | Wait |
| LOADED | Data ready, ideas present | Card list with status chips and counts | Interact |
| EMPTY_ALL | Zero ideas in workspace | "🌱 Chưa có ý tưởng! Bắt đầu bằng cách: [+ Tạo thủ công] hoặc [🤖 AI gợi ý]" | Create or generate |
| EMPTY_FILTERED | Filter active, 0 matches | "Không có ý tưởng {status}. [Xem tất cả →]" | Clear filter |
| LOW_PIPELINE | Inbox count < 5 | Yellow banner: "⚠️ Pipeline thấp! [🤖 AI gợi ý thêm →]" | Generate more |
| SWIPING | User swiping a card | Card reveals colored background (blue left, green right) | Complete or cancel |
| QUICK_ADDING | Bottom sheet open | Modal bottom sheet with form | Fill and create |
| REFRESHING | Pull-to-refresh | Refresh indicator. Existing list visible. | Wait |
| ERROR | API failed | "Không tải được ý tưởng. [Kéo xuống để thử lại]" | Pull refresh |
| OFFLINE | No network | Cached ideas viewable. Quick add queued. Banner "📡 Ngoại tuyến" | View cached |

---
## 9. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View all ideas | ✅ | ✅ | ✅ | ✅ | ✅ (own only) | ✅ (read) | ❌ |
| Create idea | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Swipe advance | ✅ | ✅ | ✅ | ✅ | ⚠️ own only | ❌ | ❌ |
| Delete idea | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| AI generate | ✅ | ✅ | ✅ | ✅ | ⚠️ credit limited | ❌ | ❌ |
| AI score | ✅ | ✅ | ✅ | ✅ | ⚠️ credit limited | ❌ | ❌ |

### Visibility Rules
- **Contributor**: Sees only own ideas. Status chips show own counts only.
- **Viewer**: Read-only. No FAB. No swipe. See all ideas but cannot modify.
- **External**: 💡 tab hidden from bottom nav.

---
## 10. Mobile-specific UX

### Gestures & Haptics
| Gesture | Target | Haptic | Result |
|---|---|---|---|
| Tap card | IdeaCard | Light | Push → Idea Detail (M018) |
| Swipe right | IdeaCard | Medium (at threshold) | Green reveal — advance to next status |
| Swipe left | IdeaCard | Medium (at threshold) | Blue reveal — advance to "In Script" + open editor |
| Long press | IdeaCard | Heavy | Context menu bottom sheet |
| Pull down | Page | Light | Refresh |
| Tap FAB | FAB button | Light | Quick add bottom sheet |
| Tap status chip | StatusChip | Light | Filter by status |

### Swipe Status Progression Logic
| Current Status | Swipe Right → | Swipe Left → |
|---|---|---|
| Inbox | → Evaluating | → In Script (create script) |
| Evaluating | → Approved | → In Script (create script) |
| Approved | → In Script | → In Script (create script) |
| In Script | → Done | (no action) |
| Done | (no action) | (no action) |

### Score Badge Animation
- New AI score: Badge pulses with glow (gold → transparent, 2s)
- High score (≥90): Brief confetti particle around badge

### Offline Behavior
- **Available offline**: Cached idea list, status filter
- **Unavailable offline**: AI generation, AI scoring, server sort
- **Queue offline**: Quick add → saved locally → synced when online
- Visual: Banner "📡 Ngoại tuyến — ý tưởng mới sẽ đồng bộ khi có mạng"

---
## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| 0 ideas | Full-page empty state with dual CTA (manual + AI) |
| 500+ ideas (heavy user) | Infinite scroll. Status chips for triage. Sort by score to surface best. |
| Swipe on "Done" idea | No action. Slight bounce-back. |
| AI score returns 0 | Badge shows "—" with tooltip "Không đủ dữ liệu để đánh giá" |
| Duplicate idea title | Allow (ideas can have same title, different content/angle) |
| Quick add while offline | Saved locally. Badge on FAB shows "1 pending sync". |
| AI generation rate limit | Toast: "Đã dùng hết quota AI hôm nay. Thử lại ngày mai." |
| Idea from deleted trend | Show idea normally. Source shows "🔥 Trend (đã xóa)". |
| Status chip count mismatch | Counts refresh with pull-to-refresh. |

---
## 12. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| New AI-scored ideas | Push notification | Real-time (batch scored) |
| Team member status change | SSE fallback | Real-time |
| New ideas (from AI/other member) | Push + SSE | Real-time |

### Real-time UX
- **New idea (from AI batch)**: Card slides in at top with "🆕" badge + glow.
- **Score update**: Badge value animates (counter animation).
- **Team member advances idea**: Card status updates inline with brief highlight.

---
## 13. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `ideas.mobile.viewed` | Tab opened | `total_count`, `inbox_count`, `filter`, `source` |
| `ideas.mobile.created` | Quick add completed | `has_ai_score`, `platform`, `tag_count` |
| `ideas.mobile.swiped` | Swipe action completed | `idea_id`, `old_status`, `new_status`, `ai_score` |
| `ideas.mobile.detail_opened` | Card tapped | `idea_id`, `score`, `status` |
| `ideas.mobile.deleted` | Delete confirmed | `idea_id`, `status`, `age_days` |
| `ideas.mobile.ai_gen_opened` | AI Gen tapped | `pipeline_count`, `source` (banner/button) |
| `ideas.mobile.filtered` | Status chip tapped | `status_filter` |
| `ideas.mobile.sorted` | Sort changed | `sort_field` |

---
## 14. Performance Requirements

| Metric | Target |
|---|---|
| Cold open to interactive | < 1.5s |
| Card list scroll | 60fps |
| Swipe gesture recognition | < 100ms |
| Status update after swipe | < 500ms (optimistic) |
| Quick add → card appears | < 1s |
| Pull-to-refresh | < 2s |
| AI score computation | < 3s |

---
## 15. Flutter Implementation Notes

### Widget Structure
- **Route**: `/ideas` → `IdeaBoardPage extends ConsumerStatefulWidget`
- **State**: Riverpod `ideaListProvider(statusFilter, sortField)` — paginated
- **Card list**: `ListView.builder` with `Dismissible` for swipe
- **Status chips**: `SingleChildScrollView` + `ChoiceChip[]`
- **FAB**: `FloatingActionButton` → `showModalBottomSheet(QuickAddForm)`
- **Infinite scroll**: `ScrollController` + `onEndReached` → load next cursor

### Swipe Implementation
```dart
Dismissible(
  key: Key(idea.id),
  direction: DismissDirection.horizontal,
  confirmDismiss: (direction) async {
    if (direction == DismissDirection.startToEnd) {
      // Swipe right → advance status
      return await ideaService.advanceStatus(idea.id);
    } else {
      // Swipe left → move to script
      await ideaService.update(idea.id, status: 'in_script');
      Navigator.push(context, ScriptEditorPage(ideaId: idea.id));
      return false; // don't dismiss, we navigated
    }
  },
  background: Container(color: Colors.green, child: Icon(Icons.check)),
  secondaryBackground: Container(color: Colors.blue, child: Icon(Icons.edit)),
)
```

---
## 16. Navigation Map

```
Mobile Idea Board (/ideas — bottom tab 💡)
├── → /ideas/[id] (tap card → M018 Idea Detail)
├── → /ideas/generate (🤖 AI Gen → M019 AI Generator)
├── → /scripts/new?idea_id=[id] (swipe left → M020 Script Editor)
```

---
## 17. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — ý tưởng mới sẽ đồng bộ khi có mạng" | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được ý tưởng. [Kéo xuống để thử lại]" | Pull refresh |
| Quick add failed | Create API error | Toast: "Không tạo được ý tưởng. [Thử lại]" + form preserved | Retry submit |
| AI score failed | Copilot timeout | Score badge shows "—" with "AI đang bận. Thử sau." | Retry from detail |
| Swipe sync failed | Status update rejected | Card bounces back to original status. Toast: "Không cập nhật được." | Retry swipe |
| Delete failed | API error on delete | Toast: "Không xóa được. Thử lại." | Retry from context menu |

---
## 18. Accessibility

| Element | Requirement |
|---|---|
| Idea cards | `Semantics(label: "Ý tưởng: 5 sai lầm skincare, điểm AI 88, trạng thái Inbox, TikTok")` |
| Score badges | Color not sole indicator — number always visible + `Semantics(label: "Điểm AI: 88 trên 100")` |
| Status chips | `Semantics(selected:)` on active filter |
| Swipe gestures | Also available via long-press context menu for accessibility |
| FAB | `Semantics(button: true, label: "Thêm ý tưởng mới")`, minimum 56dp |
| Pipeline banner | `Semantics(liveRegion: true)` to announce when pipeline is low |
| Tag chips | `Semantics(label: "Tag: skincare")` |

---
## 19. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + status chips + card shimmer |
| Idea list | 200-500ms | Cards fade in with staggered animation |
| Status counts | 200-300ms | Chip counts populate |
| Quick add sheet | <200ms | Bottom sheet slides up |
| AI score in quick add | 1-3s | Score badge animates in |
| Swipe status update | <500ms | Optimistic — immediate visual, sync behind |

---
## 20. Localization Notes

- Primary language: Vietnamese
- Score display: "⭐ 88" (numeric)
- Prediction ranges: "50K-100K views"
- Status labels: "Inbox", "Đánh giá", "Đã duyệt", "Đang viết script", "Xong"
- Source labels: "AI", "Xu hướng", "Thủ công", "Cơ hội"
- Pipeline warning: "Pipeline thấp! Chỉ {n} ý tưởng trong Inbox."
- Tag format: lowercase, hyphenated (English)
- Relative time: "2 giờ trước", "1 ngày trước"

---
## 21. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | FAB, active status chip, AI Gen button |
| `--color-success` | Score ≥80 (🟢), swipe right background (advance) |
| `--color-warning` | Score 50-79 (🟡), pipeline low banner |
| `--color-danger` | Score <50 (🔴), delete action |
| `--color-info` | Swipe left background (blue — to script) |
| `--color-surface-elevated` | Idea cards |
| `--color-text-primary` | Idea titles |
| `--color-text-secondary` | Tags, timestamps, predictions |

---
## 22. Related Screens

| Screen | Relationship |
|---|---|
| [W017] Web Idea Board | Web equivalent (Kanban board) |
| [M018] Mobile Idea Detail | Detail view for single idea |
| [M019] Mobile AI Idea Generator | AI idea generation |
| [M020] Mobile Script Editor | Downstream — write script from idea |
| [M001] Mobile Home Dashboard | Pipeline KPI + 💡 bottom tab |

---
## 23. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | **Structure fix**: Removed duplicate template sections (§5/§6/§11/§12/§13/§16/§18). Added detailed Error Handling (6 scenarios), Accessibility with semantic labels, progressive Loading timeline, expanded Localization with Vietnamese label rules, Design Tokens with score-specific colors. Renumbered to 23-section structure. | System |
| 2026-03-28 | 2.0 | Full Tier A rewrite. Added pipeline health banner, swipe progression, quick add, AI scoring, 13 actions, 10 states, RBAC matrix, Flutter swipe code. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
