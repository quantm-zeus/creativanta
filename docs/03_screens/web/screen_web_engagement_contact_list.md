# Screen: Web — Contact List

> **Screen ID**: W51
> **Module**: M09 — Engagement (CRM Lite)
> **Route**: `/contacts`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §20, A1 Schema (entities, threads, orders)

---

## 1. Purpose & Context

Contact List is a lightweight CRM showing all people who have interacted with the creator — commenters, DM senders, buyers, collaborators. AI auto-enriches profiles with purchase history, engagement frequency, and customer value scoring.

### User Story
> As a creator, I want to see all the people who interact with me across platforms, with their purchase history and engagement data, so I can identify my most valuable fans and customers.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 👤 Liên hệ (2,345)          [🔍 Search] [Segment ▾] [Sort ▾]     │
├──────────────────────────────────────────────────────────────────────┤
│ Segments: [Tất cả] [🛍 Buyers (234)] [🔥 Top fans (45)] [💬 Active (890)]│
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Contact Row ───────────────────────────────────────────────────┐ │
│ │ [😊] Nguyễn Văn A         🎵 TikTok + 🛍 Shopee              │ │
│ │ Followers: 12K · Purchases: 3 (847K VND) · Eng: 23 interactions│ │
│ │ Customer value: ★★★★☆ (High) · Last active: 2h ago           │ │
│ │ Tags: [loyal-customer] [skincare-fan]                           │ │
│ │ [→ Profile] [💬 Message] [🏷 Tag]                              │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Contact Row ───────────────────────────────────────────────────┐ │
│ │ [😄] Lê Hoa               📸 Instagram                        │ │
│ │ Followers: 500 · Purchases: 0 · Eng: 45 interactions           │ │
│ │ Customer value: ★★★☆☆ (Medium) · Last active: 1d ago         │ │
│ │ [→ Profile] [💬 Message] [🏷 Tag]                              │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ [Tải thêm ↓]                                                        │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
ContactListPage
├── AppShell (shared)
├── PageHeader
│   ├── Title + TotalCount
│   ├── SearchInput (Meilisearch)
│   ├── SegmentFilter
│   └── SortDropdown (value, recent, interactions)
├── SegmentChips (Tất cả / Buyers / Top fans / Active)
└── ContactList
    └── ContactRow[]
        ├── Avatar
        ├── Name
        ├── PlatformBadges
        ├── MetricsRow (followers, purchases, total spend, interactions)
        ├── CustomerValueRating (★★★★★)
        ├── LastActiveTime
        ├── TagChips
        └── ActionButtons (Profile, Message, Tag)
```

---

## 4-5. Data & Actions

| UI Element | Source | API |
|---|---|---|
| Name | `entities.display_name` | `EntityService/List(segment, sort)` |
| Platforms | `entities.platform_ids` | same |
| Purchases | `COUNT(orders WHERE buyer_entity_id)` | same |
| Total spend | `SUM(orders.total)` | same |
| Interactions | `COUNT(messages WHERE entity_id)` | same |
| Value score | `entities.customer_value` (computed) | same |
| Tags | `entity_tags` | same |

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | View profile | "→ Profile" | — | → `/contacts/[id]` | `contact:read` |
| 2 | Message | "💬 Message" | — | → `/inbox?entity=[id]` | `inbox:read` |
| 3 | Tag | "🏷 Tag" → tag input | `EntityService/AddTag` | Tag added | `contact:manage` |
| 4 | Search | Search input | Meilisearch | Results filter | `contact:read` |
| 5 | Segment | Segment chip | Refetch | List filters | `contact:read` |
| 6 | Sort | Sort dropdown | Refetch | List reorders | `contact:read` |

---

## 6. Customer Value Scoring

| Stars | Label | Criteria |
|---|---|---|
| ★★★★★ | VIP | 5+ purchases OR 100+ interactions |
| ★★★★☆ | High | 3-4 purchases OR 50+ interactions |
| ★★★☆☆ | Medium | 1-2 purchases OR 20+ interactions |
| ★★☆☆☆ | Low | 0 purchases + 5-19 interactions |
| ★☆☆☆☆ | New | < 5 interactions |

### Scoring Computation
- Computed daily via cron job → `entities.customer_value`
- Purchase data: `SUM(orders.total WHERE buyer_entity_id = entity_id)`
- Interaction data: `COUNT(messages WHERE entity_id = entity_id)`
- VIP override: manual tag `[VIP]` always shows ★★★★★

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Segment chips + 5 row skeletons |
| LOADED | Contacts available | Segments + contact rows |
| EMPTY | No contacts at all | Illustration: "Chưa có liên hệ. Đăng bài để thu hút tương tác! [→ Tạo bài đăng]" |
| EMPTY_FILTERED | Segment/search active, no match | "Không có liên hệ phù hợp. [Xóa bộ lọc]" |
| ERROR | API failed | Error banner with retry |

---

## 8. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View contacts | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| View purchase data | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Manage tags | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Send message | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |

---

## 9. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached" | Auto-retry online |
| API error (5xx) | Server failure | Error banner: "Không tải được liên hệ. [Thử lại]" | Retry |
| Search failed | Meilisearch down | Fallback SQL LIKE. Toast: "Tìm kiếm nâng cao tạm thời không khả dụng" | Auto-fallback |
| Tag failed | Save error | Toast: "Không gắn tag được. [Thử lại]" | Retry |
| Permission denied | 403 | "Không có quyền xem liên hệ" | Contact admin |

---

## 10. Accessibility

| Element | Requirement |
|---|---|
| Contact rows | `role="article"`, `aria-label="{name}, {value_label}, {interaction_count} tương tác"` |
| Rating stars | `aria-label="Giá trị khách hàng: {stars}/5 ({label})"` |
| Segment chips | `role="tablist"`, `aria-selected` on active |
| Platform badges | `aria-label="Nền tảng: {platforms}"` |
| Tags | `role="list"`, chips with `aria-label="Tag: {name}"` |

---

## 11. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | App Shell + segment chips + row skeletons |
| Segment counts | 200ms | Counts animate in on chips |
| Contact rows | 300-500ms | Rows populate with stagger |
| Rating stars | 400ms | Stars fill animation |
| Search results | < 100ms | Rows crossfade (Meilisearch) |

---

## 12. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (first contact row) |
| TTI | < 2.0s |
| Search latency | < 100ms (Meilisearch) |
| Segment switch | < 500ms |
| Tag add | < 500ms |

---

## 13. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `contacts.viewed` | Page load | `total_count`, `segment`, `sort` |
| `contacts.searched` | Search query | `query`, `results_count` |
| `contacts.segmented` | Segment chip | `segment`, `count` |
| `contacts.profile_viewed` | Click profile | `entity_id`, `value_tier` |
| `contacts.messaged` | Click message | `entity_id` |
| `contacts.tagged` | Add tag | `entity_id`, `tag_name` |
| `contacts.sorted` | Sort changed | `sort_by` |

---

## 14. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/contacts/+page.svelte`
- **Server load**: `+page.server.ts` → fetch contacts + segment counts
- **Search**: Meilisearch via `meilisearch-js` (index: `entities`)
- **Segments**: URL-based `?segment=buyers` → bookmarkable
- **Auto-enrichment**: Entities auto-created from comments, DMs, orders via webhooks
- **Value scoring**: Daily cron → `entities.customer_value` (integer 1-5)

---

## 15. Localization Notes

- Value labels: "VIP", "Cao", "Trung bình", "Thấp", "Mới"
- Segments: "Tất cả", "Người mua" (Buyers), "Fan hàng đầu" (Top fans), "Hoạt động" (Active)
- Metrics: "12K người theo dõi", "3 đơn hàng (847K VND)", "23 tương tác"
- Relative time: "2 giờ trước", "1 ngày trước"
- Currency: VND (no decimals, dot separator: "847.000đ")

---

## 16. Design Tokens

| Token | Usage |
|---|---|
| `--color-value-vip` | ★★★★★ VIP (gold) |
| `--color-value-high` | ★★★★☆ High (green) |
| `--color-value-medium` | ★★★☆☆ Medium (blue) |
| `--color-value-low` | ★★☆☆☆ Low (gray) |
| `--color-value-new` | ★☆☆☆☆ New (light gray) |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Contact rows |
| `--font-mono` | Entity handles |

---

## 17. Related Screens

| Screen | Relationship |
|---|---|
| [W052] Contact Detail | Profile view |
| [W049] Unified Inbox | Message integration |
| [W061] Order List | Purchase history source |
| [M010] Mobile Contacts | Mobile equivalent |

---

## 18. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Added customer value scoring formula, 5 states, RBAC, 5 error scenarios, accessibility for rating stars, 5-stage loading, 5 perf KPIs, 7 analytics, SvelteKit impl, contact-specific localization, 8 design tokens with value-tier colors. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
