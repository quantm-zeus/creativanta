# Screen: Web — Post Analytics Detail

> **Screen ID**: W078
> **Module**: M23 — Analytics & Reporting
> **Route**: `/analytics/post/[id]`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 02, PRD §23.23, A1 Schema (content_items, engagement_events, audience_demographics, attribution_events), B5 RBAC §2.7

---

## 1. Purpose & Context

Per-post deep analytics — real-time metrics, reach curve over 72h, audience demographics, AI-powered performance analysis, peer comparison, and revenue attribution.

### User Goals
- Understand why a post performed well or poorly
- See reach curve to identify viral windows
- Get AI analysis of what worked / didn't work
- See attributed revenue from this specific content

### Business Goals
- Enable data-driven content optimization
- Track content-to-commerce attribution
- Feed AI coaching with per-post insights
- Enable A/B testing of content approaches

### Entry Points
- Content list: click on any published content
- Analytics Dashboard (W074): click on content row
- Performance Coach (W076): "📊 Stats" on content insight card

### Exit Points
- "→ Edit" → Content Editor
- "📦 Derivatives" → Derivative Manager (W028)
- "💡 Similar content" → filtered content list

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Analytics   📊 "5 tips nấu ăn"            [📥 Export] [→ Edit]  │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Post Preview ────────────────────────────────────────────────┐   │
│ │ [🖼 Thumbnail]  🎵 TikTok · Published 3d ago · 60s          │   │
│ │ Status: 🟢 Active · Script: #42 · Source idea: #23           │   │
│ │ Tags: #cooking #tips #food · Sound: "Trending beat xyz"      │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Metrics Grid ────────────────────────────────────────────────┐   │
│ │ 👁 Views    │ ❤️ Likes  │ 💬 Comments │ 📤 Shares │ 📌 Saves│  │
│ │ 50,234     │ 3,120    │ 456        │ 234      │ 567     │      │
│ │ ↑120%      │ ↑85%     │ ↑200%      │ ↑150%    │ ↑95%    │      │
│ │                                                                │   │
│ │ ER: 6.2% (↑45% vs your avg)                                   │   │
│ │ Watch time avg: 42s / 60s (70% completion)                     │   │
│ │ Followers gained: +234 from this post                          │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Tabs: [📈 Reach] [🤖 AI Analysis] [👥 Audience] [💰 Revenue]      │
│                                                                      │
│ ── 📈 Reach Tab ──                                                   │
│ ┌─ Reach Timeline (72h) ───────────────────────────────────────┐    │
│ │ [Area chart: cumulative views over 72 hours]                   │    │
│ │ Peak: Hour 3 (12,500 views/hr) · Viral window: 0-8h          │    │
│ │ Discovery sources: FYP 72% · Following 18% · Search 10%      │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── 🤖 AI Analysis Tab ──                                            │
│ ┌─ AI Content Analysis ────────────────────────────────────────┐    │
│ │ Overall score: 85/100 (A)                                      │    │
│ │                                                                │    │
│ │ ✅ What worked:                                                │    │
│ │ • Hook: 3s opening retained 65% viewers (vs 40% avg)         │    │
│ │ • Trending sound: +35% discoverability boost                   │    │
│ │ • List format: high engagement in your niche                   │    │
│ │                                                                │    │
│ │ ❌ What didn't work:                                           │    │
│ │ • CTA: No explicit follow CTA → missed +50 potential followers│    │
│ │ • Length: 60s slightly long → optimal is 45-55s in your niche │    │
│ │                                                                │    │
│ │ 💡 Recommendations:                                            │    │
│ │ • Add "Follow for more tips" text overlay at end               │    │
│ │ • Trim to ~50s — cut the slow intro segment                   │    │
│ │ • Create more 'tips' format content (3/5 top posts)           │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── 👥 Audience Tab ──                                                │
│ ┌─ Demographics ────────────────────────────────────────────────┐    │
│ │ Age: 18-24 (45%) · 25-34 (30%) · 35-44 (15%) · Other (10%)  │    │
│ │ Gender: Female 65% · Male 30% · Other 5%                      │    │
│ │ Top cities: HCM (35%) · Hà Nội (25%) · Đà Nẵng (12%)        │    │
│ │ [Bar charts for age + geo distribution]                        │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ── 💰 Revenue Tab ──                                                 │
│ ┌─ Revenue Attribution ────────────────────────────────────────┐     │
│ │ 🛒 Orders attributed: 12 · Revenue: 4.2M VND                 │     │
│ │ ROAS: 8.4× · CPA: 0đ (organic)                               │     │
│ │ Top products sold: Serum VitC (8), Kem CN (4)                 │     │
│ │ Source: [🟢 Official — TikTok Shop attribution]               │     │
│ │ [📊 View order details →]                                      │     │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
PostAnalyticsDetailPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Analytics")
│   ├── PageTitle ("📊 {post_title}")
│   ├── ExportButton
│   └── EditButton
├── PostPreview
│   ├── Thumbnail
│   ├── PlatformBadge + PublishDate + Duration
│   ├── Status + LinkedScript + SourceIdea
│   └── Tags + Sound
├── MetricsGrid
│   ├── MetricCard[] (Views, Likes, Comments, Shares, Saves)
│   │   └── Value + PercentChange (vs user average)
│   ├── EngagementRate + ComparisonNote
│   ├── WatchTime (avg / total) + CompletionRate
│   └── FollowersGained
├── AnalyticsTabs
│   ├── ReachTab
│   │   ├── ReachTimeline (72h area chart)
│   │   ├── PeakAnnotation (hour + views/hr)
│   │   ├── ViralWindow
│   │   └── DiscoverySources (FYP %, Following %, Search %)
│   ├── AIAnalysisTab
│   │   ├── OverallScore + Grade
│   │   ├── WhatWorkedSection (✅ items)
│   │   ├── WhatDidntWorkSection (❌ items)
│   │   └── RecommendationsSection (💡 actionable items)
│   ├── AudienceTab
│   │   ├── AgeDistribution (bar chart)
│   │   ├── GenderDistribution
│   │   └── GeoDistribution (top cities)
│   └── RevenueTab
│       ├── OrdersAttributed + Revenue
│       ├── ROAS + CPA
│       ├── TopProductsSold
│       ├── SourceClassBadge (S009)
│       └── OrderDetailsLink
```

---

## 5. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Metrics shimmer |
| LOADED | Full data | Complete analytics |
| PARTIAL_DATA | Analytics still processing | "📊 Analytics đang xử lý. Dữ liệu đầy đủ trong 24-48h." |
| NO_REVENUE | No orders attributed | "Chưa có doanh thu trực tiếp từ bài viết này." |
| ERROR | API failed | Error with retry |

---
## 6. Edge Cases

| Edge Case | Handling |
|---|---|
| Analytics still processing (< 24h post) | Banner: "📊 Analytics đang xử lý. Dữ liệu đầy đủ trong 24-48h." |
| Post deleted from platform | Banner: "Bài viết đã bị xóa trên {platform}. Hiển thị dữ liệu cuối cùng." |
| No revenue attributed | Revenue tab: "Chưa có doanh thu trực tiếp từ bài viết này." |
| Post < 24h old (reach curve incomplete) | Chart shows partial data + dashed projection |
| AI analysis not yet generated | Tab: "🤖 Đang phân tích... Quay lại sau 30 phút." |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached data | Auto-retry online |
| Post not found | 404 | Full-page: "Bài viết không tồn tại. [← Quay lại]" | Back |
| Reach curve fail | ClickHouse timeout | Chart: "Không tải được biểu đồ. [Thử lại]" | Retry |
| AI analysis fail | CopilotService error | Tab: "Phân tích không khả dụng. [Thử lại]" | Retry |
| Revenue data fail | Attribution service error | Tab: "Dữ liệu doanh thu tạm thời không khả dụng." | Auto-retry |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Metrics grid | `role="region"`, each card `aria-label="{metric}: {value}, {delta}%"` |
| Reach timeline chart | `role="img"`, `aria-label="Biểu đồ lượt xem qua 72 giờ. Đỉnh: {peak}"` + data table fallback |
| Tab container | `role="tablist"`, `role="tab"` with `aria-selected` |
| AI analysis sections | `role="article"`, ✅/❌ not color-only |
| Revenue attribution | `aria-label="Doanh thu: {value}đ, ROAS: {n}×"` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Post preview + metric skeletons |
| Metrics grid | 200-400ms | Numbers animate from 0 → value |
| Reach chart | 300-800ms | Area chart draws left→right |
| AI analysis | 500-1500ms | Text fades in (pre-generated) |
| Demographics | 500-1000ms | Bar charts animate |
| Revenue | 300-500ms | Values populate |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `post_analytics.viewed` | Page load | `post_id`, `platform`, `views`, `source` |
| `post_analytics.tab_changed` | Tab switch | `tab_name`, `post_id` |
| `post_analytics.exported` | Export | `format`, `post_id` |
| `post_analytics.edit_clicked` | Edit button | `post_id` |
| `post_analytics.derivative_clicked` | Derivative link | `post_id` |
| `post_analytics.ai_recommendation_viewed` | AI section visible | `recommendation_count` |
| `post_analytics.revenue_detail_clicked` | Order details link | `post_id`, `revenue` |
| `post_analytics.similar_content_clicked` | Similar content link | `post_id` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/analytics/post/[id]/+page.svelte`
- **Server load**: `+page.server.ts` → `AnalyticsService/GetPostDetail(id)` with content join
- **Reach curve**: ClickHouse `engagement_events` aggregated by hour (72h window)
- **Discovery sources**: Platform API → FYP %, Following %, Search %
- **AI analysis**: Pre-generated by `PostAnalyzer` cron, stored in `content_items.ai_analysis` (JSON)
- **Revenue**: `AttributionService/GetByContent(post_id)` — TikTok Shop / Shopee attribution
- **Tabs**: Lazy-loaded — Audience/Revenue fetch on tab activation
- **Export**: CSV/PDF with chart snapshots via `pdf-lib`

---

## 12. Localization Notes

- Metrics: "Lượt xem", "Thích", "Bình luận", "Chia sẻ", "Lưu"
- Completion: "Xem hết: 70%", "TB xem: 42s / 60s"
- Discovery: "Nguồn: FYP 72% · Following 18% · Tìm kiếm 10%"
- Revenue: "Đơn hàng: 12 · Doanh thu: 4.2M VND · ROAS: 8.4×"
- AI: "✅ Hiệu quả", "❌ Chưa tốt", "💡 Đề xuất"

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-metric-views` | Views icon/accent |
| `--color-metric-engagement` | Engagement rate accent |
| `--color-metric-revenue` | Revenue accent (gold) |
| `--color-reach-curve` | Area chart fill gradient |
| `--color-delta-positive` | ↑ positive change (green) |
| `--color-delta-negative` | ↓ negative change (red) |
| `--color-discovery-fyp` | FYP source segment |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W075] Analytics Overview | Parent dashboard |
| [W076] Analytics Detail | Platform-level analytics |
| [W077] Performance Metrics | Weekly coaching |
| [W018] Derivative Manager | Content repurposing |
| [M037] Mobile Post Analytics | Mobile equivalent |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (processing, deleted), 5 errors, chart/tab a11y, 8 analytics, SvelteKit impl (ClickHouse reach, attribution), 9 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
