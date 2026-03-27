# Screen Specs 02 — Intelligence Screens (M02-M04)

> **Upstream**: Pack 01 §4, Product Freeze §10/§11, A1 Schema (trends, opportunities, watchlists, competitor_entities), A3 API, B4 Connector Specs
> **Screens**: 8 web + 3 mobile screens

---

## 9. Trend Radar

**Route**: `/intelligence/trends`
**Purpose**: Real-time trend discovery across connected platforms. Grid/list view of trending signals with scoring, filtering, and quick conversion to ideas.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🔥 Xu hướng             [Filter ▾] [Sort ▾] [View: ▦ Grid | ☰ List] │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Filter Bar ──────────────────────────────────────────────┐    │
│ │ Nền tảng: [Tất cả ▾] Thời gian: [7 ngày ▾]              │    │
│ │ Lĩnh vực: [Tất cả ▾] Nguồn: [Tất cả ▾] Watchlist: [▾]  │    │
│ └────────────────────────────────────────────────────────────┘   │
│                                                                  │
│ ┌─ Trend Card ────────────────────────────────────────────────┐  │
│ │ 🔥 "AI cooking assistant"                      ⭐ 92/100   │  │
│ │                                                              │  │
│ │ TikTok · +340% (7d) · 1.2M total views                     │  │
│ │ Lĩnh vực: Food & Cooking                                    │  │
│ │                                                              │  │
│ │ 📈 [Sparkline chart: 7-day trend line]                      │  │
│ │                                                              │  │
│ │ [Source: Official] [Confidence: High] [Freshness: 2h ago]   │  │
│ │                                                              │  │
│ │ [💡 Tạo ý tưởng] [🔄 Remix video] [📌 Lưu watchlist] [→]  │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Trend Card ────────────────────────────────────────────────┐  │
│ │ 🔥 "Minimalist skincare for acne"              ⭐ 78/100   │  │
│ │ Instagram · +180% (3d) · 450K reach                         │  │
│ │ ...                                                          │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ [Tải thêm ↓]                                                    │
└──────────────────────────────────────────────────────────────────┘
```

### Components Detail

#### 9.1 Trend Card
| Field | Source | Display |
|---|---|---|
| Title | `trends.title` | Bold, primary text |
| Strength Score | `trends.strength_score` | Badge: 🟢 ≥80, 🟡 50-79, 🔴 <50 |
| Platform | `trends.source_platform` | Platform icon + name |
| Growth | Computed `(current - prev) / prev * 100` | `+{n}% ({period})` |
| Volume | `trends.volume_metric` | Formatted number + "views/posts" |
| Category | `trends.category` | Chip badge |
| Sparkline | ClickHouse 7-day aggregation | Mini line chart (inline) |
| Source badge | `trends.source_class` | Official / Imported / Estimated |
| Confidence | `trends.confidence_level` | Color-coded badge |
| Freshness | `trends.synced_at` | Relative time |
| Embedding | `trends.embedding` (hidden) | Used for similarity |

#### 9.2 Actions on Trend Card
| Action | Trigger | API | Result |
|---|---|---|---|
| Create idea | Click "Tạo ý tưởng" | `IdeaService/Create(from_trend_id)` | Toast + → `/ideas/[new_id]` |
| Remix video | Click "Remix" | — | → `/studio/remix?url={trend_video_url}` |
| Save to watchlist | Click "Lưu" | `WatchlistService/AddItem` | Toast "Đã lưu" + pin icon |
| View detail | Click card or "→" | — | → `/trends/[id]` |
| Filter | Change filter dropdowns | Refetch with params | List updates |
| Sort | Change sort | Refetch `sort={field}` | List reorders |
| Toggle view | Click Grid/List toggle | `localStorage` | Layout switches |

### States
- **Loading**: 6 trend card skeletons in grid
- **Empty**: "No trends yet — connect a platform to start discovering" + CTA "Kết nối ngay"
- **Empty (with filters)**: "No trends matching your filters. [Xóa bộ lọc]"
- **Error**: "Couldn't load trends. [Thử lại]"
- **Degraded**: Some platforms stale → banner "Dữ liệu TikTok cũ 6 giờ. [Kiểm tra kết nối]"

---

## 10. Trend Detail

**Route**: `/intelligence/trends/[id]`
**Purpose**: Deep-dive into a single trend — full statistics, related content, conversion actions, and explanation panel.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Xu hướng    "AI cooking assistant"           [⭐ 92] [📌] [⋮] │
├─────────────────────────────────┬────────────────────────────────┤
│ Main Content (65%)              │ Right Panel (35%)               │
│                                 │                                 │
│ ┌─ Header ─────────────────┐   │ ┌─ Trust Panel ──────────────┐ │
│ │ 🔥 AI cooking assistant  │   │ │ Source: Official (TikTok)  │ │
│ │ TikTok · Food & Cooking  │   │ │ Confidence: High           │ │
│ │ +340% growth (7d)         │   │ │ Last sync: 2h ago          │ │
│ │ Volume: 1.2M views       │   │ │ Data points: 847           │ │
│ │ Status: 🟢 Trending       │   │ │ [Why this score? ▾]        │ │
│ └───────────────────────────┘   │ └────────────────────────────┘ │
│                                 │                                 │
│ ┌─ Chart: Growth Timeline ──┐   │ ┌─ Related Trends ──────────┐ │
│ │ [Line chart: 30d growth]   │   │ │ • AI recipe videos (85%)  │ │
│ │ x: date, y: views         │   │ │ • Smart cooking tools (72%)│ │
│ │ [7d] [14d] [30d] [90d]    │   │ │ • Kitchen AI reviews (68%)│ │
│ └────────────────────────────┘   │ └────────────────────────────┘ │
│                                 │                                 │
│ ┌─ Top Videos (Carousel) ───┐   │ ┌─ Quick Actions ────────────┐ │
│ │ [Video1] [Video2] [Video3]│   │ │ [💡 Tạo ý tưởng]          │ │
│ │ [▶ Play] [📊 Stats]       │   │ │ [📝 Tạo script]           │ │
│ │ Swipe →                    │   │ │ [🔄 Remix video này]      │ │
│ └────────────────────────────┘   │ │ [📌 Thêm watchlist]       │ │
│                                 │ │ [🔗 Chia sẻ]              │ │
│ ┌─ Platform Breakdown ──────┐   │ └────────────────────────────┘ │
│ │ TikTok: 800K views (67%)  │   │                                │
│ │ YouTube: 250K views (21%) │   │ ┌─ Activity Timeline ────────┐ │
│ │ Instagram: 150K (12%)     │   │ │ Yesterday: +45% spike      │ │
│ └────────────────────────────┘   │ │ 3d ago: First detected     │ │
│                                 │ │ 5d ago: Related trend merge │ │
│ ┌─ My Content on This Trend ┐   │ └────────────────────────────┘ │
│ │ (list of user's content    │   │                                │
│ │  related to this trend)    │   │                                │
│ └────────────────────────────┘   │                                │
└─────────────────────────────────┴────────────────────────────────┘
```

### Data Sources
| Section | API/Source | Cache |
|---|---|---|
| Header | `TrendService/Get(id)` | `trend:{id}` (10m) |
| Chart | ClickHouse `content_performance` | — |
| Top videos | `TrendService/GetRelatedContent(id)` | — |
| Platform breakdown | Aggregated from `trends` metrics | — |
| Related trends | pgvector similarity search | — |
| Trust panel | `trends.source_class`, `confidence_level` | — |
| My content | `PublishItemService/List(trend_id)` | — |
| Activity | `audit_events WHERE target_id = trend.id` | — |

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Create idea | "Tạo ý tưởng" | `IdeaService/Create(from_trend_id)` | → `/ideas/[new_id]` |
| Create script | "Tạo script" | `ScriptService/Create(from_trend_id)` | → `/scripts/[new_id]` |
| Remix video | "Remix" | — | → `/studio/remix?url={video_url}` |
| Add to watchlist | "📌" | `WatchlistService/AddItem` | Pin icon fills |
| Share | "🔗" | Copy link to clipboard | Toast "Đã copy link" |
| Change chart period | Click [7d/14d/30d/90d] | Refetch chart data | Chart updates |
| Why this score | Click "Why?" | — | Score explanation drawer opens |

### States
- **Loading**: Header skeleton + chart placeholder + card skeletons
- **Not found**: "Xu hướng không tồn tại. [← Quay lại]"
- **Stale**: Banner "Dữ liệu cũ {time}. Confidence giảm xuống Medium."

---

## 11. Watchlist Manager

**Route**: `/intelligence/watchlist`
**Purpose**: Manage custom watchlists for tracking specific trends, keywords, and competitors.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 📌 Watchlists                                  [+ Tạo watchlist] │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Watchlist Card ────────────────────────────────────────────┐  │
│ │ 🍳 Food & Cooking Trends                      12 items     │  │
│ │ Last alert: 2h ago · 3 new trends since yesterday          │  │
│ │ [Xem →]  [✏️ Sửa]  [🔔 Alerts: ON]                        │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Watchlist Card ────────────────────────────────────────────┐  │
│ │ 🏆 Competitor Watch                            5 items      │  │
│ │ Last alert: 1d ago · 1 competitor published                 │  │
│ │ [Xem →]  [✏️ Sửa]  [🔔 Alerts: ON]                        │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### Create Watchlist Modal
```
┌─ Modal: Tạo Watchlist ────────────────────────────────────────┐
│ Tên: [______________________________________]                  │
│ Từ khóa: [cooking, recipe, AI] (tag input)                    │
│ Nền tảng: [☑ TikTok] [☑ YouTube] [☐ Instagram]               │
│ Thông báo: [☑ Email] [☑ Push] khi có ≥ [3 ▾] trend mới      │
│                                                                │
│ [Hủy]                                              [Tạo ✓]   │
└────────────────────────────────────────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Create watchlist | Fill form + click "Tạo" | `WatchlistService/Create` | New card appears |
| View watchlist | Click "Xem" | — | → `/trends/watchlists/[id]` (filtered trend list) |
| Edit watchlist | Click "Sửa" | — | Edit modal pre-filled |
| Toggle alerts | Click bell toggle | `WatchlistService/Update` | Toggle state changes |
| Delete watchlist | ⋮ → "Xóa" → confirm | `WatchlistService/Delete` | Card removed |

---

## 12. Competitor Registry

**Route**: `/intelligence/competitors`
**Purpose**: Track competitor creators/brands — their content, posting patterns, and growth.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 🔍 Đối thủ                                    [+ Thêm đối thủ] │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Competitor Row ────────────────────────────────────────────┐  │
│ │ [Avatar] @nguyenvana · TikTok                              │  │
│ │ Followers: 125K (↑8% 30d) · Posts: 45 (30d) · Eng: 4.2%  │  │
│ │ Niche: Food & Cooking · [Source: Official]                 │  │
│ │ Last post: 3h ago · Top content: "Nấu phở 15 phút"       │  │
│ │                                                             │  │
│ │ [📊 So sánh] [📝 Notes] [🔔 Alert: ON] [→ Chi tiết]       │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ... more competitors ...                                         │
└──────────────────────────────────────────────────────────────────┘
```

### Add Competitor Modal
```
┌─ Modal: Thêm đối thủ ────────────────────────────────────────┐
│ Nền tảng: [TikTok ▾]                                         │
│ Username/URL: [@nguyenvana hoặc paste link]                   │
│ Ghi chú: [________________________________________________]  │
│ Thông báo khi đăng bài mới: [☑ Có]                          │
│                                                                │
│ [Hủy]                                              [Thêm ✓]  │
└────────────────────────────────────────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Add competitor | Fill + "Thêm" | `CompetitorService/Create` | New row + initial sync |
| View detail | Click "Chi tiết" | — | → `/research/competitors/[id]` |
| Compare | Click "So sánh" | — | → `/research/benchmarks?ids=[id1,id2]` |
| Add notes | Click "Notes" | `CompetitorService/UpdateNotes` | Inline text area saves |
| Toggle alert | Click bell | `CompetitorService/Update` | Toggle state |
| Remove | ⋮ → "Xóa" → confirm | `CompetitorService/Delete` | Row removed |

---

## 13. Benchmark View

**Route**: `/intelligence/benchmarks`
**Purpose**: Side-by-side comparison of user's metrics vs competitors. Chart-heavy analysis view.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 📊 Benchmark                      [Select competitors ▾]        │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Comparison Header ────────────────────────────────────────┐  │
│ │ [You]           vs  [@nguyenvana]   vs  [@lehoa]           │  │
│ │ 50K followers       125K followers      80K followers      │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Chart: Follower Growth (30d) ─────────────────────────────┐  │
│ │ [Multi-line chart: Your line, Competitor A, Competitor B]   │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Chart: Engagement Rate ───────────────────────────────────┐  │
│ │ [Bar chart grouped by platform]                             │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Chart: Posting Frequency ─────────────────────────────────┐  │
│ │ [Heatmap: day of week × time of day, posts count]          │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Table: Content Performance Comparison ────────────────────┐  │
│ │ Metric        │ You    │ @competitor1 │ @competitor2        │  │
│ │ Avg views     │ 15K    │ 45K          │ 22K                │  │
│ │ Avg eng rate  │ 4.1%   │ 3.8%         │ 5.2%               │  │
│ │ Post frequency│ 12/mo  │ 20/mo        │ 8/mo               │  │
│ │ Top format    │ Short  │ Long         │ Short              │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ AI Insights ──────────────────────────────────────────────┐  │
│ │ "Đối thủ @nguyenvana đăng nhiều hơn bạn 67% nhưng         │  │
│ │  engagement rate của bạn cao hơn 8%. Tập trung vào quality │  │
│ │  over quantity."                                            │  │
│ │ [💡 Tạo strategy từ insight này →]                         │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

### Data Sources
| Section | Source | Cache |
|---|---|---|
| Metrics | ClickHouse `content_performance` + competitor crawled data | — |
| Charts | ClickHouse aggregations | — |
| AI Insights | `CopilotService/Query(mode=analytics, scope=benchmark)` | 1h TTL |

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Select competitors | Dropdown multi-select | Refetch | Charts update |
| Change period | Tab [7d/30d/90d] | Refetch | All charts update |
| Create strategy | "Tạo strategy" | `IdeaService/Create(insight_text)` | → `/ideas/[id]` |
| Export PDF | "📥 Export" | Client-side PDF gen | Download file |

---

## 14. Opportunity Board

**Route**: `/intelligence/opportunities`
**Purpose**: Kanban/list view of scored opportunities. Each opportunity = actionable insight derived from trends, competitor gaps, or AI analysis.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ 💡 Cơ hội                [Filter ▾] [View: ▦ Kanban | ☰ List]   │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Kanban View ──────────────────────────────────────────────┐  │
│ │ New (8)           │ Evaluating (3)   │ Actionable (5)      │  │
│ │ ┌──────────────┐  │ ┌──────────────┐ │ ┌──────────────┐   │  │
│ │ │ Gap: Cooking  │  │ │ Remix trend  │ │ │ Product video │   │  │
│ │ │ AI tips for   │  │ │ "skincare"   │ │ │ for Serum    │   │  │
│ │ │ Vietnamese    │  │ │ ⭐ 72/100     │ │ │ ⭐ 88/100     │   │  │
│ │ │ ⭐ 65/100      │  │ │ [Evaluate →] │ │ │ [Convert →]  │   │  │
│ │ └──────────────┘  │ └──────────────┘ │ └──────────────┘   │  │
│ │ ┌──────────────┐  │                   │ ┌──────────────┐   │  │
│ │ │ ...           │  │                   │ │ ...           │   │  │
│ │ └──────────────┘  │                   │ └──────────────┘   │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### Opportunity Card
| Field | Source | Display |
|---|---|---|
| Title | `opportunities.title` | Bold |
| Score | `opportunities.score` | ⭐ badge, color-coded |
| Type | `opportunities.type` | Chip: Gap / Trend / Competitor / AI |
| Source trend | `opportunities.source_trend_id` | Link to trend |
| Expected impact | `opportunities.expected_impact` | Stars (1-5) |
| Estimated effort | `opportunities.estimated_effort` | Low/Medium/High badge |
| Created | `opportunities.created_at` | Relative time |

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Convert to idea | "Convert →" on Actionable | `OpportunityService/Convert` | → `/ideas/[new_id]` |
| Move stage | Drag card between columns | `OpportunityService/Update(status)` | Card animates to new column |
| Evaluate | Click "Evaluate" | — | → `/opportunities/[id]` |
| Dismiss | ⋮ → "Bỏ qua" | `OpportunityService/Update(status=dismissed)` | Card fades out |
| Filter | Filter bar | Refetch | Board updates |
| Switch view | Kanban/List toggle | `localStorage` | Layout switches |

---

## 15. Opportunity Detail

**Route**: `/intelligence/opportunities/[id]`
**Purpose**: Deep-dive into individual opportunity, showing evidence, expected impact, conversion flow.

### Layout
```
┌─ App Shell ──────────────────────────────────────────────────────┐
│ ← Cơ hội    "Product video for Serum Vitamin C"    [⭐ 88] [⋮]  │
├──────────────────────────────────┬───────────────────────────────┤
│ Main (65%)                       │ Right Panel (35%)              │
│                                  │                                │
│ ┌─ Summary ─────────────────┐   │ ┌─ Trust ────────────────────┐│
│ │ Loại: Product Gap          │   │ │ Source: AI Analysis         ││
│ │ Score: ⭐ 88/100            │   │ │ Confidence: High            ││
│ │ Impact: ★★★★☆ High         │   │ │ Based on: 12 data points   ││
│ │ Effort: Low                │   │ │ [Why this score? ▾]         ││
│ │ Từ xu hướng: [AI cooking →]│   │ └─────────────────────────────┘│
│ └────────────────────────────┘   │                                │
│                                  │ ┌─ Actions ─────────────────┐ │
│ ┌─ Evidence ────────────────┐   │ │ [💡 Chuyển thành ý tưởng] │ │
│ │ 1. Trend "AI cooking" +340%│   │ │ [📝 Tạo script trực tiếp]│ │
│ │ 2. Your product "Serum"    │   │ │ [🔄 Remix top video]     │ │
│ │    has no video content    │   │ │ [❌ Bỏ qua cơ hội]       │ │
│ │ 3. Competitor @x has 3     │   │ └─────────────────────────────┘│
│ │    product videos (avg 25K)│   │                                │
│ └────────────────────────────┘   │ ┌─ Related ─────────────────┐ │
│                                  │ │ 🛍️ Serum Vitamin C         │ │
│ ┌─ AI Recommendation ──────┐    │ │ 🔥 AI cooking assistant    │ │
│ │ "Create a 30s product      │   │ │ 💡 Idea: "Serum review"   │ │
│ │  showcase video combining  │   │ └─────────────────────────────┘│
│ │  trending AI cooking..."   │   │                                │
│ │ [📋 Copy suggestion]       │   │                                │
│ └────────────────────────────┘   │                                │
└──────────────────────────────────┴───────────────────────────────┘
```

### Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Convert to idea | Primary CTA | `OpportunityService/Convert` | Toast + → `/ideas/[new_id]` |
| Create script | "Tạo script" | `ScriptService/Create(opp_id)` | → `/scripts/[new_id]` |
| Remix | "Remix" | — | → `/studio/remix?opp_id=[id]` |
| Dismiss | "Bỏ qua" | `OpportunityService/Update(dismissed)` | → `/intelligence/opportunities` |
| Why score | Click "Why?" | — | Explanation drawer opens |
| Navigate to related | Click related object link | — | → respective route |

---

## 16. Opportunity Convert Flow

**Route**: `/intelligence/opportunities/[id]/convert`
**Purpose**: Guided conversion from opportunity to actionable idea with AI-assisted prefill.

### Layout
```
┌─ Modal / Full-screen (mobile) ────────────────────────────────┐
│ Chuyển thành ý tưởng                            Step 1 of 2   │
├────────────────────────────────────────────────────────────────┤
│                                                                │
│ Từ cơ hội: "Product video for Serum Vitamin C" ⭐ 88           │
│                                                                │
│ ┌─ Step 1: Chọn loại ý tưởng ─────────────────────────────┐  │
│ │ ○ 📝 Script (viết kịch bản mới)                          │  │
│ │ ● 🎬 Video (tạo video AI)                                │  │
│ │ ○ 📸 Image (tạo ảnh/thumbnail)                           │  │
│ │ ○ 🔄 Remix (remix video trending)                        │  │
│ └──────────────────────────────────────────────────────────┘  │
│                                                                │
│ AI Suggestion (editable):                                      │
│ ┌──────────────────────────────────────────────────────────┐  │
│ │ Title: [Serum Vitamin C - Review nhanh 30s           ]   │  │
│ │ Desc:  [Video showcase sản phẩm kết hợp xu hướng     ]   │  │
│ │        [AI cooking assistant để thu hút Gen Z          ]   │  │
│ │ Tags:  [skincare, serum, review] (editable tags)          │  │
│ └──────────────────────────────────────────────────────────┘  │
│                                                                │
│ [Hủy]                            [Tạo ý tưởng →]              │
└────────────────────────────────────────────────────────────────┘
```

### Data
- Pre-filled from: `OpportunityService/Get(id)` + `CopilotService/Query(suggestion_for_opp)`
- Creates: `IdeaService/Create(from_opportunity_id, type, title, description, tags)`

---

## Mobile Screens

### M14. Mobile Trend List

**Route**: `/intelligence/trends` (mobile)
**Purpose**: Browse trending topics with swipe-to-action and filtering.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Xu hướng                                  [🔍] [Period: 7d ▾] │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Filter: [All] [TikTok] [YouTube] [Shopee] [Google] [Instagram]  │
│                                                                  │
│ ┌─ Trend Card ───────────────────────────────────────────────┐  │
│ │ 🔥 Retinol alternatives              Score: 92 · ▲45%    │  │
│ │ TikTok · 125K mentions · Rising fast                       │  │
│ │ ← Swipe L: [📌 Watchlist] · Swipe R: [💡 Ý tưởng]       │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Trend Card ───────────────────────────────────────────────┐  │
│ │ 📈 Glass skin routine                 Score: 87 · ▲32%    │  │
│ │ TikTok + YouTube · 89K mentions · Stable                   │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Trend Card ───────────────────────────────────────────────┐  │
│ │ 🌱 Peptide serums                     Score: 78 · ▲28%    │  │
│ │ Shopee · 45K searches · Emerging                           │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ Pull-to-refresh · Infinite scroll                                │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M14 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View detail | Tap card | — | → M15 Trend Detail |
| Create idea | Swipe right | `IdeaService/CreateFromTrend` | Idea created, toast |
| Save watchlist | Swipe left | `TrendService/AddToWatchlist` | Card bookmarked |
| Filter | Tap chip | — | List filtered |
| Pull-to-refresh | Pull down | `TrendService/List` | Trends refreshed |

---

### M15. Mobile Trend Detail

**Route**: `/intelligence/trends/[id]` (mobile)
**Purpose**: Deep dive into a single trend with chart, analysis, and actions.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Xu hướng   🔥 Retinol alternatives                            │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ ┌─ Sparkline Chart (full width) ─────────────────────────────┐  │
│ │ [Line chart: mentions over 30 days]                        │  │
│ │ Score: 92/100 · ▲45% vs last week                          │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Sources ──────────────────────────────────────────────────┐  │
│ │ TikTok: 125K mentions · YouTube: 34K · Google: 89K        │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Trust Panel (collapsible) ─── [▾ Expand] ─────────────────┐  │
│ │ Source: Official · Confidence: High · Freshness: Live      │  │
│ │ [Why? ▾]                                                    │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ AI Analysis ──────────────────────────────────────────────┐  │
│ │ "Retinol alternatives đang tăng mạnh do xu hướng          │  │
│ │  'skin barrier repair'. Niche phù hợp: skincare 25-35."   │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Related Content ──────────────────────────────────────────┐  │
│ │ 🎬 Top videos sử dụng trend này (3 items)                 │  │
│ │ 💡 Ý tưởng liên quan (2 items)                            │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ┌─ Sticky Bottom Bar ────────────────────────────────────────┐  │
│ │ [💡 Ý tưởng] [🔄 Remix] [📌 Lưu]                         │  │
│ └──────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

#### M15 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| Create idea | "Ý tưởng" | `IdeaService/CreateFromTrend` | → Idea editor pre-filled |
| Remix | "Remix" | — | → M55 AI Remix with trend reference |
| Save | "Lưu" | `TrendService/AddToWatchlist` | Bookmarked |
| View video | Tap related content | — | External link or in-app player |

---

### M16. Mobile Opportunity Board

**Route**: `/intelligence/opportunities` (mobile)
**Purpose**: Kanban-style opportunity pipeline via horizontal swipe between columns.

#### Layout
```
┌─ Status Bar ─────────────────────────────────────────────────────┐
│ ← Cơ hội                                     [🔍] [Filter ▾]    │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│ Column tabs: [New (5)] [Evaluating (3)] [Actionable (2)]        │
│ ← swipe between columns →                                       │
│                                                                  │
│ ── New Column ──                                                 │
│ ┌─ Opportunity Card ─────────────────────────────────────────┐  │
│ │ 🎯 "Peptide serum review" · TikTok                        │  │
│ │ Match: 85% · Est. reach: 45K                               │  │
│ │ From: Trend #78 · Created 2h ago                           │  │
│ └──────────────────────────────────────────────────────────────┘  │
│ ┌─ Opportunity Card ─────────────────────────────────────────┐  │
│ │ 🎯 "Glass skin tutorial" · YouTube                        │  │
│ │ Match: 92% · Est. reach: 120K                              │  │
│ │ From: Trend #92 · Created 5h ago                           │  │
│ └──────────────────────────────────────────────────────────────┘  │
│                                                                  │
│ ── On tap: Bottom Sheet ──                                       │
│ ┌────────────────────────────────────────────────────────────┐  │
│ │ 🎯 Peptide serum review                                    │  │
│ │ Match score: 85% · Platform: TikTok                        │  │
│ │ AI reasoning: "High search volume, low competition..."     │  │
│ │ [💡 Convert to Idea] [🗑 Dismiss] [📤 Share]              │  │
│ │ [→ Move to Evaluating]                                     │  │
│ └────────────────────────────────────────────────────────────┘  │
├──────────────────────────────────────────────────────────────────┤
│ [🏠] [💡] [🎬] [💬] [📊]                                       │
└──────────────────────────────────────────────────────────────────┘
```

#### M16 Actions
| Action | Trigger | API | Result |
|---|---|---|---|
| View detail | Tap card | — | Bottom sheet with full details |
| Convert | "Convert to Idea" | `IdeaService/CreateFromOpportunity` | Idea created |
| Dismiss | "Dismiss" | `OpportunityService/Dismiss` | Card removed |
| Move column | "Move to..." | `OpportunityService/UpdateStage` | Card moves to next column |
| Swipe columns | Swipe left/right | — | Switch between New/Evaluating/Actionable |

