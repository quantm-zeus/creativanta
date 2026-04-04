# Screen: Web — Script List

> **Screen ID**: W015
> **Module**: M06 — Script Lab
> **Route**: `/scripts`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §13, A1 Schema (scripts, script_sections, script_reviews), B5 RBAC §2.7

---

## 1. Purpose & Context

Script List displays all scripts in the workspace with status filtering, search, and quick stats. The bridge between the Idea Board (upstream) and the AI Studio/Publish pipeline (downstream). Designed for rapid triage — see what needs writing, reviewing, or is ready for production.

### User Goals
- See all scripts organized by status for pipeline tracking
- Quickly identify scripts needing review or approval
- Find scripts to edit, produce, or export as asset briefs
- Monitor content velocity (scripts created, approved, produced per period)

### Business Goals
- Accelerate idea → script → production pipeline
- Ensure review bottlenecks are visible and actionable
- Track content output volume for team productivity

### Entry Points
- Sidebar: "📝 Script" under Content
- Idea Board (W012): "📝 Viết script" creates and redirects here
- Notification: "📝 Script awaiting review" → deep link with `status=in_review`
- AI Copilot: "Danh sách script đang chờ duyệt" → navigate with filter
- Direct URL: `/scripts`

### Exit Points
- Click script row → `/scripts/[id]` (Script Editor W021)
- "+ Tạo mới" → `/scripts/new`
- "📋 Asset brief" → `/scripts/[id]/brief` (Asset Brief W023)
- "📤 Produce" → `/studio/video?script_id=[id]`

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `script:read` permission
- At least one script exists, or user has `script:create` to make new ones

### Postconditions
- Status changes (submit review, approve, reject) are persisted and audited
- Notifications sent to relevant users on status transitions
- Analytics events dispatched for all actions

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + full table/card view |
| Tablet (768-1279px) | App Shell (collapsed) + compact list |
| Mobile (≤767px) | Redirect to M019 Mobile Script List |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 📝 Script                    [+ Tạo mới] [View: ▦|☰]              │
├──────────────────────────────────────────────────────────────────────┤
│ Filter: [Status ▾] [Platform ▾] [Author ▾]  🔍 Search              │
├──────────────────────────────────────────────────────────────────────┤
│ Stats: 📝 Total: 45 · ✍ Draft: 12 · 👁 In Review: 5 · ✅ Approved: 28│
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Script Row ────────────────────────────────────────────────────┐ │
│ │ 📝 "5 tips nấu ăn nhanh"                    [✍ Draft]         │ │
│ │ 🎵 TikTok · Short-form · Words: 134 · Duration: ~52s          │ │
│ │ From idea: #42 "5 sai lầm..." · Author: Quân · 2h ago         │ │
│ │ [→ Mở] [📤 Gửi review] [📋 Asset brief]                      │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Script Row ────────────────────────────────────────────────────┐ │
│ │ 📝 "Serum Vitamin C review"                  [👁 In Review]    │ │
│ │ 📸 Instagram · Short-form · Words: 98 · Duration: ~30s         │ │
│ │ Reviewer: Admin · Submitted: 1d ago                             │ │
│ │ [→ Mở] [✅ Approve] [❌ Reject]                                │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Script Row ────────────────────────────────────────────────────┐ │
│ │ 📝 "Haul tháng 3"                           [✅ Approved]      │ │
│ │ 📺 YouTube · Long-form · Words: 1,200 · Duration: ~8m         │ │
│ │ Approved by: Admin · 3d ago                                     │ │
│ │ [→ Mở] [📋 Asset brief] [📤 Produce]                          │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ [Tải thêm ↓] (cursor-based, 20/page)                               │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
ScriptListPage
├── AppShell (shared)
├── PageHeader
│   ├── PageTitle ("📝 Script" + count badge)
│   ├── CreateButton ("+ Tạo mới", primary CTA)
│   └── ViewToggle (Card ▦ | List ☰)
├── FilterBar
│   ├── StatusFilter (All / Draft / In Review / Approved / Archived)
│   ├── PlatformFilter (TikTok, Instagram, YouTube, All)
│   ├── AuthorFilter (team members)
│   └── SearchInput (Meilisearch — instant results)
├── StatsBar
│   ├── TotalCount (📝)
│   ├── DraftCount (✍)
│   ├── InReviewCount (👁)
│   └── ApprovedCount (✅)
├── ScriptList (or ScriptTable based on ViewToggle)
│   └── ScriptRow[]
│       ├── ScriptTitle (max 2 lines, truncated)
│       ├── StatusBadge (✍ Draft / 👁 In Review / ✅ Approved / 📁 Archived)
│       ├── PlatformIcon + Format (short-form / long-form)
│       ├── WordCount ("Words: 134")
│       ├── DurationEstimate ("~52s", computed from word count × platform rate)
│       ├── LinkedIdeaBadge ("From idea: #42", tappable → Idea Detail)
│       ├── AuthorInfo + EditTime (relative)
│       ├── ReviewerInfo (if in review/approved: reviewer name + timestamp)
│       └── ActionBar
│           ├── OpenLink ("→ Mở")
│           ├── SubmitReviewButton (draft → "📤 Gửi review")
│           ├── ApproveButton (if reviewer + in_review → "✅ Approve")
│           ├── RejectButton (if reviewer + in_review → "❌ Reject")
│           ├── AssetBriefButton (approved → "📋 Asset brief")
│           └── ProduceButton (approved → "📤 Produce")
├── BulkActionBar (appears when ☐ checkboxes selected)
│   ├── SelectedCount
│   ├── BulkArchiveButton
│   └── BulkExportButton
└── LoadMore (cursor-based pagination)
```

---

## 5. Data Binding & Display Format

| UI Element | Source | API | Display Format | Cache |
|---|---|---|---|---|
| Title | `scripts.title` | `ScriptService/List(filters, cursor)` | Text, max 80 chars | 5m |
| Status | `scripts.status` | same | Color badge + icon | 5m |
| Platform | `scripts.target_platform` | same | Platform icon + name | 5m |
| Word count | `scripts.word_count` (computed from sections) | same | "Words: 134" | 5m |
| Duration | Computed: `word_count × platform_rate` | Client-side | "~52s" or "~8m" | 5m |
| Linked idea | `scripts.idea_id → ideas.title` | JOIN in list | "From idea: #42" | 5m |
| Author | `scripts.created_by → users.name` | JOIN in list | "Author: Quân" | 5m |
| Reviewer | `script_reviews.reviewer_id → users.name` | JOIN | "Reviewer: Admin" | 5m |
| Stats | Aggregated from `scripts` by status | `ScriptService/GetStats` | Counts | 5m |
| Last edited | `scripts.updated_at` | same | Relative time "2h ago" | 5m |

### Duration Estimation Rates
| Platform | Words/second |
|---|---|
| TikTok (short-form) | 2.5 |
| Instagram Reel | 2.5 |
| YouTube Shorts | 2.5 |
| YouTube (long-form) | 2.5 |
| Podcast | 2.0 |

---

## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Navigation | Permission |
|---|---|---|---|---|---|---|---|
| 1 | Create script | "+ Tạo mới" | Primary CTA | — | — | → `/scripts/new` | `script:create` |
| 2 | Open script | Click row or "→ Mở" | Navigation | — | — | → `/scripts/[id]` | `script:read` |
| 3 | Submit for review | "📤 Gửi review" | Status change | `ScriptService/Update(id, status=in_review)` | Badge → "👁 In Review" + toast "Đã gửi review" + notification to reviewers | — | `script:edit` |
| 4 | Approve | "✅ Approve" | Status change | `ScriptService/Approve(id)` | Badge → "✅ Approved" + toast "Đã duyệt" + notification to author | — | `script:approve` |
| 5 | Reject | "❌ Reject" → reason dialog | Status change | `ScriptService/Reject(id, reason)` | Badge → "✍ Draft" + toast "Đã trả lại" + notification with reason | — | `script:approve` |
| 6 | Go to asset brief | "📋 Asset brief" | Navigation | — | — | → `/scripts/[id]/brief` | `script:read` |
| 7 | Produce with AI | "📤 Produce" | Navigation | — | — | → `/studio/video?script_id=[id]` | `asset:generate` |
| 8 | Filter | Change any filter | Filter | Refetch with params | List updates with fade | — | `script:read` |
| 9 | Search | Type in search input | Debounced 300ms | Meilisearch query | Instant results | — | `script:read` |
| 10 | Toggle view | Click ▦ or ☰ | Toggle | — (localStorage) | Switch view mode | — | Any |
| 11 | Load more | Scroll bottom or "Tải thêm" | Pagination | `ScriptService/List(cursor)` | More rows append | — | `script:read` |

---

## 7. Validation Rules

### Submit for Review
| Field | Rule | Error |
|---|---|---|
| Script content | At least one non-empty section | "Script phải có ít nhất 1 đoạn nội dung" |
| Title | Required, min 5 chars | "Tiêu đề ít nhất 5 ký tự" |

### Reject
| Field | Rule | Error |
|---|---|---|
| Reason | Required, min 10 chars | "Vui lòng nhập lý do từ chối (tối thiểu 10 ký tự)" |

---

## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial load | StatsBar shimmer + 5 row skeletons | Wait |
| LOADED | Scripts available | Stats + script rows | Normal interaction |
| EMPTY | No scripts at all | Illustration + "Chưa có script nào. Chuyển ý tưởng thành script hoặc tạo mới. [+ Tạo script đầu tiên] [→ Xem ý tưởng]" | Create or go to ideas |
| EMPTY_FILTERED | Filter active, no match | "Không có script phù hợp. [Xóa bộ lọc]" | Clear filters |
| EMPTY_SEARCH | Search, no results | "Không tìm thấy script '{query}'." | Change query |
| REVIEW_PENDING | ≥1 script awaiting user's review | Orange badge on "In Review" filter: "👁 5 chờ bạn duyệt" | Filter to review |
| ERROR | API failed | Error banner: "Không tải được danh sách script. [Thử lại]" | Retry |

---

## 9. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View all scripts | ✅ | ✅ | ✅ | ✅ | Own only | ✅ (read-only) |
| Create script | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Submit for review | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Approve/Reject | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Delete/Archive | ✅ | ✅ | ✅ | Own only | ❌ | ❌ |
| Produce with AI | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

### Visibility Rules
- **Contributor**: Can only see own scripts in list. Other scripts hidden.
- **Viewer**: Can see all scripts (read-only). No action buttons shown except "Open".

---

## 10. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Script status changes | SSE `/events/scripts` | Real-time |
| New scripts (from other users) | SSE | Real-time |
| Stats refresh | Polling + SSE-driven invalidation | Every 5 minutes |

### Real-time UX
- **New script**: Row slides in at top with green highlight pulse (3s)
- **Status change**: Badge morphs with color transition (300ms)
- **Review submitted**: Toast to reviewer: "📝 Có script chờ duyệt từ {author}"

---

## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| Script with no sections (empty body) | Show "📝 Trống" label, disable "Submit review" action |
| Script linked to deleted idea | Show "(Idea đã xóa)" with strikethrough, script still functional |
| Very long title (> 80 chars) | Truncate with "..." in list, full title in tooltip |
| 100+ scripts | Cursor-based pagination, 20/page. Search recommended |
| Duration estimation for mixed content | Use dominant platform rate |
| Multiple reviewers assigned | Show first reviewer name + "(+1 reviewer)" |

---

## 12. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached" | Auto-retry when online |
| API error (5xx) | Server failure | Error banner: "Không tải được script. [Thử lại]" | Retry button |
| Approve failed | Script already approved/rejected | Toast: "Script đã được xử lý bởi {user}" | Auto-refresh |
| Submit review failed | Script has no content | Toast: "Script phải có nội dung trước khi gửi review" | Edit script |
| Search failed | Meilisearch down | Fallback to SQL LIKE. Toast: "Tìm kiếm nâng cao tạm thời không khả dụng" | Automatic fallback |

---

## 13. Accessibility

| Element | Requirement |
|---|---|
| Script rows | `role="article"`, `aria-label="Script: {title}, trạng thái {status}, {platform}"` |
| Status badges | Color + icon + text (never color-only) |
| Filter dropdowns | `aria-expanded`, `aria-haspopup="listbox"` |
| Action buttons | Descriptive `aria-label`: "Duyệt script '{title}'" |
| Stats bar | `aria-label="Tổng: 45 script, 12 nháp, 5 chờ duyệt, 28 đã duyệt"` |
| Keyboard | Tab through rows, Enter to open, Space to select |
| Review notifications | `aria-live="polite"` for real-time updates |

---

## 14. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | App Shell + stats bar shimmer + 5 row skeletons |
| Stats data | 200ms | Stat counters animate in |
| Script rows | 300-500ms | Rows populate with stagger fade-in |
| Search results | < 100ms | Rows crossfade to results (Meilisearch) |
| Status change | Instant | Badge color transition (300ms) |

---

## 15. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (first script row visible) |
| TTI | < 2.0s |
| Search latency | < 100ms (Meilisearch) |
| Status change response | < 500ms |
| Items per page | 20 (cursor-based) |
| Bundle size | < 25KB page-specific JS |

---

## 16. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `scripts.list.viewed` | Page load | `total_count`, `draft_count`, `review_count`, `approved_count` |
| `scripts.created` | New script from list | `script_id`, `from_idea` (boolean) |
| `scripts.submitted_review` | Submit for review | `script_id`, `word_count`, `platform` |
| `scripts.approved` | Approve script | `script_id`, `time_in_review` |
| `scripts.rejected` | Reject script | `script_id`, `reason_length` |
| `scripts.filtered` | Filter applied | `filter_type`, `filter_value` |
| `scripts.searched` | Search query | `query`, `results_count` |
| `scripts.produce_clicked` | Produce button | `script_id`, `platform` |

---

## 17. SvelteKit Implementation Notes

### Route & Server Load
- **Route**: `src/routes/(app)/scripts/+page.svelte`
- **Server load**: `+page.server.ts` → fetch scripts + stats
- **SSR**: Server renders first page of script rows
- **Search**: Client-side Meilisearch via `meilisearch-js` SDK
- **View mode**: Stored in `localStorage('script_view_mode')`
- **Status filter**: URL-based `?status=in_review` → bookmarkable

### Data Fetching Strategy
```
+page.server.ts:
  Promise.all([
    scriptService.list({ status, platform, author, cursor, limit: 20 }),
    scriptService.getStats()
  ])

Client-side:
  onSearch(query) → meilisearchClient.index('scripts').search(query)
  onSubmitReview(id) → scriptService.update(id, { status: 'in_review' })
  onApprove(id) → scriptService.approve(id)
  onReject(id, reason) → scriptService.reject(id, reason)
```

### Duration Estimation
- Computed client-side: `Math.round(word_count / platform_rate)`
- Display format: `< 60s → "${n}s"` / `≥ 60s → "${m}m ${s}s"`

---

## 18. Localization Notes

- Primary language: Vietnamese
- Word count: "134 từ"
- Duration: "~52 giây" / "~8 phút"
- Status: "Nháp" (Draft), "Chờ duyệt" (In Review), "Đã duyệt" (Approved), "Lưu trữ" (Archived)
- Relative time: "2 giờ trước", "1 ngày trước"
- Reviewer labels: "Người duyệt: Admin · Gửi 1 ngày trước"
- Actions: "Gửi review", "Duyệt", "Trả lại"
- Tone: Creative, action-oriented

---

## 19. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-script-draft` | Draft status badge (✍ amber) |
| `--color-script-review` | In Review status badge (👁 blue) |
| `--color-script-approved` | Approved status badge (✅ green) |
| `--color-script-archived` | Archived status badge (📁 gray) |
| `--color-accent` | Primary CTAs (Create, Submit) |
| `--color-success` | Approve button |
| `--color-danger` | Reject button |
| `--color-surface-elevated` | Script rows |

---

## 20. Related Screens

| Screen | Relationship |
|---|---|
| [W016] Script Editor | Edit individual script |
| [W017] Script Review | Review workflow detail |
| [W020] Asset Brief | Production brief from script |
| [W012] Idea Board | Upstream ideas → scripts |
| [W021] Studio Launcher | AI production from script |
| [M010] Mobile Script List | Mobile equivalent |
| [S007] Confirmations | Reject confirmation |

---

## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Full Tier A rewrite**: Expanded from 239-line Tier C to full 21 sections. Added: proper Preconditions/Postconditions, screen-specific Data Binding with duration rates, 11 User Actions with full API/permission mapping, validation rules, 7 states, full RBAC matrix, real-time updates (SSE), 6 edge cases, 5 error scenarios, semantic accessibility, 5-stage loading behavior, 6 performance KPIs, 8 analytics events, SvelteKit implementation notes, localization with script-specific formats, 8 per-status design tokens. Removed ALL generic boilerplate. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
