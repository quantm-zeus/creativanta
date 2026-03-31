# Screen: Web — Channel Posts

> **Screen ID**: W044
> **Module**: M08 — Publish & Schedule
> **Route**: `/publish/posts`
> **Platform**: Web (SvelteKit)
> **Upstream**: Product Freeze §16, A1 Schema (published_posts, engagement_snapshots, publish_items, assets), B5 RBAC §2.7

---

## 1. Purpose & Context

Channel Posts is the retrospective content library — a unified view of all published content across every connected platform (TikTok, Instagram, YouTube, X/Twitter, Facebook). It shows per-post performance metrics, cross-platform comparison insights, and provides quick actions for derivative creation, engagement follow-up, and analytics deep-dive. This is the "what did I publish and how is it doing" command center.

### User Story
> As a creator publishing to 3-5 platforms, I want to see all my published content in one view, compare performance across platforms, and quickly act on high-performers (create derivatives) or underperformers (analyze and learn).

### Business Goals
- Provide single-pane-of-glass visibility across all platforms
- Drive derivative creation from high-performing content (increase output volume)
- Surface cross-platform comparison insights to guide future publishing strategy
- Enable rapid engagement follow-up (comment management)

### When This Screen Is Used
- **Daily review**: Creator checks yesterday's performance
- **Weekly analysis**: Reviewing top performers and underperformers
- **Content planning**: Identifying content worth re-purposing
- **Engagement management**: Quick access to comment threads

### Entry Points
- Sidebar: Publish → "📊 Bài đã đăng"
- Publish Queue ([W043]): "Published" tab
- Home Dashboard: "📊 Recent performance" widget → "Xem tất cả"
- Direct URL: `/publish/posts`

### Exit Points
- Click post row → `/publish/[id]` (Publish Item Detail W045)
- "📊 Analytics" → `/analytics/posts/[post_id]` (Post Analytics Detail W075)
- "💬 Comments" → `/engagement/threads/[thread_id]` (Thread Detail)
- "🔄 Create derivative" → `/content/derivatives/new?source=[id]` (Derivative Manager W028)

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid session
- User has `publish:read` permission minimum
- At least one platform connector configured (otherwise redirect to Connector setup)
- Engagement data synced from platform APIs (may be up to 1h delayed)

### Postconditions
- Page view logged for analytics
- Filter/sort selections persisted to `localStorage` (restored on next visit)
- New posts synced during session via SSE are added to list (no manual refresh needed)

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell (sidebar 240px) + Full-width post list with metric columns |
| Tablet (768-1279px) | App Shell (collapsed sidebar) + Card-based post list (metrics stacked) |
| Mobile (≤767px) | Redirect to Mobile Channel Posts equivalent |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 📊 Bài đã đăng              [Platform ▾] [Period: 30d ▾] [Sort ▾] │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Summary Bar ───────────────────────────────────────────────────┐ │
│ │ Posts (30d): 24 · 5 platforms · Reach: 245K · Avg ER: 5.8%    │ │
│ │ 🏆 Top: "5 tips nấu ăn" (ER: 8.2%) · 📉 Lowest: "Budget.."  │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Post Row ──────────────────────────────────────────────────────┐ │
│ │ [🎬 Thumb] │ "5 tips nấu ăn nhanh"                             │ │
│ │            │ 🎵 TikTok · 27/3 19:05 · 45s                      │ │
│ │────────────┼────────────────────────────────────────────────────│ │
│ │            │ 👁 24.3K  ❤ 1.2K  💬 89  📤 45  │  ER: 8.2%     │ │
│ │            │ 🏆 Top performer this week                         │ │
│ │            │ [📊 Analytics] [💬 89] [🔄 Derivative] [→ Detail] │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Post Row (cross-posted, grouped) ─────────────────────────────┐ │
│ │ [🎬 Thumb] │ "5 tips nấu ăn nhanh"                             │ │
│ │            │ 📸 IG Reels · 27/3 19:35 · 45s                    │ │
│ │────────────┼────────────────────────────────────────────────────│ │
│ │            │ 👁 3.2K reach  ❤ 234  💬 18  │  ER: 5.1%         │ │
│ │            │ ↗ Cross-post of TikTok (TikTok 7.5× more views)  │ │
│ │            │ [📊 Analytics] [💬 18] [→ Detail]                  │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Post Row (low performance) ───────────────────────────────────┐ │
│ │ [🎬 Thumb] │ "Review serum XYZ"                                 │ │
│ │            │ 📸 IG Reels · 25/3 12:00 · 60s                    │ │
│ │────────────┼────────────────────────────────────────────────────│ │
│ │            │ 👁 800  ❤ 34  💬 5       │  ER: 2.1%              │ │
│ │            │ 📉 Below your average (ER -55% vs 30d avg)        │ │
│ │            │ [📊 Analytics] [💬 5] [→ Detail]                   │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ... (more posts)                                                     │
│                                                                      │
│ [Tải thêm ↓]  (infinite scroll, 20 per page)                        │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
ChannelPostsPage
├── AppShell (shared)
│   ├── Sidebar
│   └── TopBar
├── PageHeader
│   ├── Title ("📊 Bài đã đăng")
│   └── FilterBar
│       ├── PlatformFilter (All / TikTok / IG / YouTube / X / Facebook)
│       ├── PeriodFilter (7d / 30d / 90d / Custom range)
│       └── SortSelector (Newest / Views ↓ / ER ↓ / Comments ↓ / Shares ↓)
├── SummaryBar
│   ├── PostCount ("24 posts in 30 days")
│   ├── PlatformCount ("5 platforms")
│   ├── TotalReach ("245K")
│   ├── AvgEngagementRate ("5.8%")
│   ├── TopPerformer (🏆 title + ER)
│   └── LowestPerformer (📉 title + ER, hidden if < 5 posts)
├── PostList
│   └── PostRow[] (sorted by selected sort)
│       ├── ThumbnailImage (64×64, rounded corners, click → detail)
│       ├── PostInfo
│       │   ├── PostTitle (truncated at 60 chars)
│       │   ├── PlatformBadge (icon + name + color)
│       │   ├── PostedTimestamp ("27/3 19:05")
│       │   └── ContentDuration ("45s" for video, "Image" for carousel)
│       ├── MetricsRow
│       │   ├── Views (👁 + compact number)
│       │   ├── Likes (❤ + compact number)
│       │   ├── Comments (💬 + count)
│       │   ├── Shares (📤 + count)
│       │   └── EngagementRate ("ER: 8.2%")
│       ├── InsightBadge (conditional)
│       │   ├── TopPerformerBadge ("🏆 Top performer this week")
│       │   ├── CrossPostInsight ("↗ Cross-post, TikTok 7.5× more views")
│       │   ├── UnderperformerAlert ("📉 Below avg, ER -55%")
│       │   └── ViralAlert ("🚀 Going viral! +500% avg views")
│       └── ActionBar
│           ├── AnalyticsButton ("📊 Analytics")
│           ├── CommentsButton ("💬 {count}" → thread detail)
│           ├── DerivativeButton ("🔄 Derivative" — only for top performers)
│           └── DetailLink ("→ Detail")
├── InfiniteScrollLoader (loads next 20 posts)
└── EmptyState (when no published posts)
    ├── Illustration (empty inbox)
    ├── Message ("Chưa publish content nào")
    └── CTAButton ("→ Tạo content đầu tiên")
```

---

## 5. Displayed Data / Data Binding

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Post list | `published_posts` joined with `publish_items` and `assets` | `PublishService/ListPosts(filters, page)` | Post rows with thumbnails | 5m TTL |
| Thumbnail | `assets.thumbnail_url` via `publish_items.asset_id` | Included in list response | 64×64 image, `object-fit: cover` | 24h (CDN) |
| Post title | `publish_items.title` | Included in list response | Truncated at 60 chars | 5m TTL |
| Platform | `published_posts.platform` | Included | Platform icon + name (color-coded) | Static |
| Posted timestamp | `published_posts.published_at` | Included | "27/3 19:05" (DD/M HH:mm) | Static |
| Views | `engagement_snapshots.views` (latest snapshot) | `AnalyticsService/BatchGetPostMetrics(post_ids)` | Compact: "24.3K" | 15m TTL |
| Likes | `engagement_snapshots.likes` | Same | Compact: "1.2K" | 15m TTL |
| Comments | `engagement_snapshots.comments` | Same | Integer | 15m TTL |
| Shares | `engagement_snapshots.shares` | Same | Integer | 15m TTL |
| Engagement rate | Computed: `(likes + comments + shares) / views × 100` | Same (computed client-side) | "8.2%" (1 decimal) | Computed |
| Summary totals | Aggregated from above | `AnalyticsService/GetChannelsSummary(period)` | Compact numbers | 15m TTL |
| Top performer | Highest ER in period | `AnalyticsService/GetTopPerformer(period)` | Title + ER badge | 30m TTL |
| Cross-post insight | Join `published_posts` on `publish_item_id` (same content, different platforms) | `PublishService/GetCrossPostInsights(post_id)` | "TikTok 7.5× more views" | 30m TTL |

---

## 6. User Actions

| # | Action | Trigger | API Call | System Response | Permission |
|---|---|---|---|---|---|
| 1 | View post detail | Click row or "→ Detail" | — | Navigate → `/publish/[id]` | `publish:read` |
| 2 | View analytics | Click "📊 Analytics" | — | Navigate → `/analytics/posts/[post_id]` | `analytics:read` |
| 3 | View comments | Click "💬 {count}" | — | Navigate → `/engagement/threads/[thread_id]` | `engagement:read` |
| 4 | Create derivative | Click "🔄 Derivative" | — | Navigate → `/content/derivatives/new?source=[publish_item_id]` | `content:create` |
| 5 | Filter by platform | Change platform dropdown | Client-side + refetch `ListPosts(filter)` | List updates with filtered posts | `publish:read` |
| 6 | Filter by period | Change period dropdown | Refetch `ListPosts(filter)` + `GetChannelsSummary(period)` | List + summary update | `publish:read` |
| 7 | Sort posts | Change sort dropdown | Client-side (if all loaded) or refetch | List re-ordered | `publish:read` |
| 8 | Load more | Scroll to bottom → auto-load | `ListPosts(page+1)` | Next 20 posts append to list | `publish:read` |
| 9 | View cross-post comparison | Click "↗ Cross-post" insight badge | — | Navigate → `/publish/[publish_item_id]` (shows all platforms) | `publish:read` |

---

## 7. States / State Machine

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial page load | Summary bar skeletons + 5 post row skeletons with shimmer |
| LOADED | Posts received | Full post list with metrics. Summary bar populated. |
| EMPTY | No published posts at all | Illustration + "Chưa publish content nào. [→ Tạo content đầu tiên]" |
| FILTERED_EMPTY | Filter yields no results | "Không có bài nào trên {platform} trong {period}. [Xóa bộ lọc]" |
| LOADING_MORE | Infinite scroll loading next page | Spinner at bottom of list |
| METRICS_LOADING | Posts loaded but metrics still fetching | Post rows visible with "—" for metrics, shimmer on metric columns |
| ERROR | API failed | "Không tải được bài đã đăng. [Thử lại]" |

---

## 8. Validation Rules

N/A — This is a read-only list screen. No form inputs. Filter and sort are UI controls with predefined options.

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View posts list | ✅ | ✅ | ✅ | ✅ | ✅ (own posts only) | ✅ (read) | ❌ |
| View metrics | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ✅ | ❌ |
| Navigate to analytics | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ✅ | ❌ |
| Navigate to comments | ✅ | ✅ | ✅ | ✅ | ✅ (own) | ❌ | ❌ |
| Create derivative | ✅ | ✅ | ✅ | ✅ | ⚠️ credit check | ❌ | ❌ |
| Filter/sort controls | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |

### Contributor Constraints
- Only sees posts from their own publish items (`publish_items.created_by = user_id`)
- Summary bar shows personal stats only (not workspace aggregate)

---

## 10. Navigation Map

```
Channel Posts (/publish/posts)
├── → /publish/[id]                                  (Click row → Publish Item Detail)
├── → /analytics/posts/[post_id]                     (📊 Analytics per post)
├── → /engagement/threads/[thread_id]                (💬 Comment thread)
├── → /content/derivatives/new?source=[id]           (🔄 Create derivative)
└── ← /publish                                       (Sidebar: Publish section)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network error | No internet | Full-page: "Không tải được bài đã đăng. [Thử lại]" | Retry button |
| Metrics fetch failure | Platform API rate-limited or sync issue | Post rows show "—" for metrics with tooltip: "Đang đồng bộ metrics..." | Auto-retry in 15m |
| Thumbnail not available | CDN error / asset deleted | Grey placeholder with content type icon (🎬/📸) | No action needed |
| Infinite scroll fails | Network error on pagination | "Không tải thêm được. [Thử lại]" button at bottom | Click to retry page load |
| Platform connector disconnected | OAuth expired for a platform | Banner: "⚠️ {platform} bị ngắt kết nối. Metrics có thể không chính xác. [Kết nối lại →]" | Navigate to Settings/Connectors |
| Cross-post insight unavailable | Related posts not found | Insight badge hidden (graceful degradation) | No action |
| Auth expired | 401 | Redirect to `/auth/login` | Re-authenticate |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Post list | `role="list"`, each post row `role="listitem"` |
| Post rows | `aria-label="5 tips nấu ăn, TikTok, 24,300 views, 8.2% engagement rate"` |
| Thumbnail images | `alt="Thumbnail for: 5 tips nấu ăn nhanh"` |
| Platform badges | `aria-label="Platform: TikTok"` (icon + text, not color alone) |
| Insight badges | `aria-label` with full context: "Top performer this week: 8.2% engagement" |
| Metric numbers | `aria-label="24 thousand 3 hundred views"` (not "24.3K") |
| Filter controls | Labels associated with select elements. `aria-expanded` on dropdowns. |
| Infinite scroll | `role="status"` on loading indicator. Announce: "Đang tải thêm bài viết..." |
| Keyboard | Tab through post rows → Enter to open detail. Tab to action buttons within row. |
| Color contrast | All text meets WCAG 2.1 AA (4.5:1 ratio) |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Shell render | 0ms | App Shell renders (SSR). Page title + filter bar visible. |
| Summary bar | 100-400ms | Summary numbers animate from 0 to value (counter animation) |
| Post rows | 200-600ms | Rows appear with staggered fade-in (50ms apart). Thumbnails load lazily. |
| Metrics | 300-800ms | Metric columns populate. If delayed, show "—" with shimmer. |
| Insight badges | 500-1000ms | Computed badges (top performer, cross-post) appear after metrics |

---

## 14. Performance Requirements

| Metric | Target | Measurement |
|---|---|---|
| LCP | < 2.0s | First post row with thumbnail |
| FID | < 100ms | First click on filter or post row |
| CLS | < 0.05 | No shift when metrics or insights load asynchronously |
| TTI | < 2.5s | All filter controls + post action buttons interactive |
| Thumbnail lazy load | < 200ms per image | Each thumbnail loads as row enters viewport |
| Infinite scroll trigger | 300px before bottom | Pre-fetches next page before user reaches end |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| New posts published | SSE `/events/publish` | Real-time — new row slides in at top with highlight animation |
| Metric updates | Polling | Every 15 minutes (constrained by platform API sync) |
| Connector status changes | SSE `/events/connectors` | Real-time — banner appears if connector disconnects |

### Real-time UX
- **New post published**: Row slides in at top of list with blue glow highlight for 3s. Summary bar increments.
- **Metric refresh**: Numbers animate to new values (smooth counter transition, no jarring jump).

---

## 16. Localization Notes

- Primary language: Vietnamese
- Metric numbers: compact format with dot separator (24.3K = "24,3K" in Vietnamese context — but displayed as "24.3K" for consistency with platform reporting)
- Engagement rate: "8,2%" (Vietnamese uses comma for decimals)
- Timestamps: "27/3 19:05" (DD/M HH:mm)
- Relative time: Not used on this screen (absolute timestamps preferred for historical review)
- Period labels: "7 ngày", "30 ngày", "90 ngày", "Tùy chỉnh"
- Platform names: English (TikTok, Instagram, YouTube, X) — not translated
- Tone: Analytical, data-driven — "Top performer" not "Bài tốt nhất"

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `channel_posts.viewed` | Page load | `source`, `platform_filter`, `period`, `sort_by`, `post_count` |
| `channel_posts.post.clicked` | Click post row | `post_id`, `platform`, `position_in_list` |
| `channel_posts.analytics.opened` | Click "📊 Analytics" | `post_id`, `platform`, `er` |
| `channel_posts.comments.opened` | Click "💬 {count}" | `post_id`, `platform`, `comment_count` |
| `channel_posts.derivative.created` | Click "🔄 Derivative" | `post_id`, `platform`, `er`, `views` |
| `channel_posts.filter.changed` | Change platform/period filter | `platform_filter`, `period`, `previous_filter` |
| `channel_posts.sort.changed` | Change sort | `sort_by`, `previous_sort` |
| `channel_posts.scroll.load_more` | Infinite scroll triggers | `page_number`, `total_loaded` |
| `channel_posts.insight.clicked` | Click insight badge (cross-post, top performer) | `insight_type`, `post_id` |
| `channel_posts.empty_state.cta` | Click CTA in empty state | `cta_target` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | "Create derivative" CTA, filter active state |
| `--color-success` | Positive ER delta, top performer badge background |
| `--color-warning` | Underperformer alert badge |
| `--color-danger` | Negative ER delta ("📉 -55%") |
| `--color-surface-primary` | Page background |
| `--color-surface-elevated` | Post rows, summary bar |
| `--color-text-primary` | Post titles, main content |
| `--color-text-secondary` | Timestamps, platform names, metric labels |
| `--color-text-link` | Action buttons ("Analytics", "Comments"), links |
| `--color-platform-tiktok` | TikTok badge accent (#00f2ea) |
| `--color-platform-instagram` | Instagram badge accent (#E1306C) |
| `--color-platform-youtube` | YouTube badge accent (#FF0000) |
| `--color-platform-twitter` | X/Twitter badge accent (#000000) |
| `--color-platform-facebook` | Facebook badge accent (#1877F2) |
| `--font-metric` | View/like/comment numbers (tabular-nums, monospace) |
| `--radius-thumbnail` | Thumbnail border-radius (8px) |
| `--radius-card` | Post row border-radius (12px) |
| `--shadow-card` | Post row elevation shadow |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/publish/posts/+page.svelte`
- **Server load**: `+page.server.ts` → fetch first page of posts + summary stats
- **URL params**: `?platform=tiktok&period=30d&sort=views` (persisted in URL for shareable links)

### Data Fetching Strategy
```
+page.server.ts:
  const [posts, summary] = await Promise.all([
    publishService.listPosts({ platform, period, sort, page: 1, limit: 20 }),
    analyticsService.getChannelsSummary({ period })
  ])

+page.svelte onMount:
  // Fetch metrics batch after initial render (async, non-blocking)
  const postIds = posts.map(p => p.post_id)
  const metrics = await analyticsService.batchGetPostMetrics(postIds)
```

### Infinite Scroll
```
IntersectionObserver on sentinel element 300px from bottom
→ loadMore() → publishService.listPosts({ page: currentPage + 1 })
→ append to store
```

### Cross-Post Grouping
- Posts from the same `publish_item_id` are visually grouped
- The variant with highest views is shown as primary; others show "↗ Cross-post" badge
- Grouping computed client-side from `publish_item_id` field

### Filter/Sort Persistence
- Stored in URL query params (shareable) AND `localStorage` (default on return visit)
- URL params take precedence over localStorage

---

## 20. Related Screens

| Screen | Relationship |
|---|---|
| [W043] Publish Queue | Parent: scheduled/draft content (before publish) |
| [W045] Publish Item Detail | Child: detailed view of single publish item |
| [W075] Post Analytics Detail | Deep analytics for individual post |
| [W028] Derivative Manager | Create derivative from high-performing content |
| [W052] Engagement Thread Detail | Comment management for published post |
| [M044] Mobile Channel Posts | Mobile equivalent |

---

## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Full Tier A rewrite**: Upgraded from 181-line Tier C with generic boilerplate to 420+ line full spec. Added: complete component hierarchy, screen-specific data binding with cross-post insights and batch metrics, 7-role RBAC permission matrix (B5 §2.7), 7 screen-specific error cases (stale metrics, connector disconnection, thumbnail CDN), 10 analytics events, SSE for new post notifications, platform color tokens, infinite scroll spec, cross-post grouping logic. Removed all generic boilerplate. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C) | System |
