# Screen: Web — Contact Detail

> **Screen ID**: W049
> **Module**: M12 — Unified Inbox & Engagement
> **Route**: `/contacts/[id]`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §20, A1 Schema (entities, threads, orders)

---

## 1. Purpose & Context

Full profile view of a single contact — showing all interactions, purchase history, platform presence, and AI-generated engagement recommendations.

### User Story
> As a creator, I want to see a contact's full history — what they commented, what they bought, how often they engage — so I can personalize my interactions.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Liên hệ   Nguyễn Văn A                     ★★★★☆ High Value   │
├──────────────────────────────────┬───────────────────────────────────┤
│ Main Content (65%)               │ Side Panel (35%)                   │
│                                  │                                    │
│ Tabs: [💬 Interactions] [📦 Orders] [📊 Activity]                 │
│                                  │ ┌─ Profile Card ───────────────┐│
│ ── Interactions Tab ──           │ │ [Avatar]                     ││
│ ┌─ Timeline ─────────────────┐  │ │ Nguyễn Văn A                ││
│ │ 📅 27/3/2026               │  │ │ @nguyenvana                  ││
│ │ 💬 Comment on "5 tips..."  │  │ │                               ││
│ │ "Sản phẩm mua ở đâu?"     │  │ │ 🎵 TikTok: 12K followers    ││
│ │ Intent: 🟢 Purchase       │  │ │ 🛍 Shopee: Buyer             ││
│ │ Your reply: "Link ở bio"  │  │ │                               ││
│ │                            │  │ │ First seen: 15/01/2026       ││
│ │ 📅 25/3/2026               │  │ │ Last active: 2h ago          ││
│ │ 📦 Order #TK-1234         │  │ │ Total spend: 847K VND        ││
│ │ Serum × 2 — 598,000đ      │  │ │ Interactions: 23              ││
│ │ Status: ✅ Delivered       │  │ └──────────────────────────────┘│
│ │                            │  │                                    │
│ │ 📅 20/3/2026               │  │ ┌─ Tags ─────────────────────┐│
│ │ 💬 Comment on "Haul"      │  │ │ [loyal] [skincare] [VIP]   ││
│ │ "Quá đẹp luôn 😍"        │  │ │ [+ Add tag]                ││
│ │ Intent: 🔵 Praise         │  │ └───────────────────────────┘│
│ │                            │  │                                  │
│ │ ... more timeline items... │  │ ┌─ Actions ──────────────────┐│
│ └────────────────────────────┘  │ │ [💬 Gửi tin nhắn]          ││
│                                  │ │ [📧 Gửi email]             ││
│                                  │ │ [🏷 Gắn tag]               ││
│                                  │ │ [📝 Ghi chú]               ││
│                                  │ └──────────────────────────────┘│
│                                  │                                    │
│                                  │ ┌─ AI Insights ───────────────┐│
│                                  │ │ 🤖 "Khách hàng trung thành ││
│                                  │ │ — mua 3 lần trong 3 tháng. ││
│                                  │ │ Xem xét gửi mã giảm giá   ││
│                                  │ │ VIP hoặc mời vào nhóm."    ││
│                                  │ └──────────────────────────────┘│
└──────────────────────────────────┴───────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
ContactDetailPage
├── AppShell (shared)
├── PageHeader (BackButton, Name, ValueRating)
├── SplitView
│   ├── MainPanel (65%)
│   │   ├── TabContainer
│   │   │   ├── InteractionsTab
│   │   │   │   └── Timeline
│   │   │   │       └── TimelineItem[] (comments, orders, DMs, follows)
│   │   │   │           ├── DateHeader
│   │   │   │           ├── EventIcon + Description
│   │   │   │           ├── IntentBadge (if message)
│   │   │   │           └── YourReply (if replied)
│   │   │   ├── OrdersTab
│   │   │   │   └── OrderList (filtered to this entity)
│   │   │   └── ActivityTab
│   │   │       └── EngagementChart (interaction frequency over time)
│   └── SidePanel (35%)
│       ├── ProfileCard (avatar, name, platforms, metrics)
│       ├── TagEditor
│       ├── ActionsCard (message, email, tag, note)
│       └── AIInsightsCard
```

---

## 4-5. Data & Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Send message | "💬 Gửi tin nhắn" | — | → `/inbox?entity=[id]` | `thread:reply` |
| 2 | Add tag | "🏷 Gắn tag" | `EntityService/AddTag` | Tag added | `thread:triage` |
| 3 | Add note | "📝 Ghi chú" | `EntityService/AddNote` | Note saved | `thread:triage` |
| 4 | View order | Click order in timeline | — | → `/orders/[order_id]` | `order:read` |
| 5 | View thread | Click interaction | — | → `/inbox/[thread_id]` | `thread:read` |

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Profile card skeleton + timeline skeletons |
| LOADED | Contact data received | Full profile with timeline |
| NOT_FOUND | Entity deleted/invalid | "Liên hệ không tồn tại. [← Quay lại]" |
| EMPTY_TIMELINE | No interactions yet | "Chưa có tương tác. Liên hệ mới!" |
| ERROR | API failed | Error page with retry |

---

## 7. Edge Cases

| Edge Case | Handling |
|---|---|
| Contact from multiple platforms | Merged profile, tabs show per-platform data |
| Contact with 1000+ interactions | Timeline pagination (50/load), lazy scroll |
| Order links to deleted order | Show "(Đơn hàng đã xóa)" placeholder |
| AI insights unavailable | Card hidden, button "🤖 Yêu cầu phân tích" |
| Anonymous buyer (no social profile) | Show "👤 Khách hàng ẩn danh" with purchase data only |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — chế độ chỉ đọc" | Auto-retry online |
| API error (5xx) | Server failure | Error banner: "Không tải được hồ sơ. [Thử lại]" | Retry |
| Tag failed | Save error | Toast: "Không gắn tag được. [Thử lại]" | Retry |
| Note failed | Save error | Toast: "Không lưu ghi chú được. [Thử lại]" | Retry |
| Message send failed | Platform error | Toast: "Không gửi được. Kiểm tra kết nối {platform}" | Retry |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Timeline items | `role="article"`, `aria-label="{type}: {description}, {date}"` |
| Tabs | `role="tablist"`, `aria-selected` on active |
| Rating stars | `aria-label="Giá trị: {stars}/5 ({label})"` |
| Profile card | `role="region"`, `aria-label="Hồ sơ {name}"` |
| Intent badges | Color + icon + text: "🟢 Purchase (94%)" |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Split-view skeleton |
| Profile card | 200ms | Avatar + name + platforms |
| Timeline items | 300-500ms | Items populate with stagger |
| Orders tab | 400ms | Order rows load |
| AI insights | 500-800ms | AI card generates/loads from cache |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `contact.detail.viewed` | Page load | `entity_id`, `value_tier`, `platform_count` |
| `contact.messaged` | Send message | `entity_id`, `platform` |
| `contact.tagged` | Add tag | `entity_id`, `tag_name` |
| `contact.noted` | Add note | `entity_id` |
| `contact.order_viewed` | Click order in timeline | `entity_id`, `order_id` |
| `contact.thread_viewed` | Click interaction | `entity_id`, `thread_id` |
| `contact.ai_insights_viewed` | AI card loaded | `entity_id` |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/contacts/[id]/+page.svelte`
- **Server load**: `+page.server.ts` → fetch entity + timeline (first 50 items)
- **Timeline merge**: Server merges `threads`, `orders`, `activities` into single timeline, sorted by date
- **AI insights**: Generated on first view, cached 24h in `entity_insights` table
- **Tabs**: Client-side tab switching, Orders tab fetches on activate

---

## 13. Localization Notes

- Value: "VIP", "Cao", "Trung bình", "Thấp", "Mới"
- Tab labels: "💬 Tương tác", "📦 Đơn hàng", "📊 Hoạt động"
- Intent: "🟢 Mua hàng", "🔵 Khen ngợi", "🟡 Hỏi đáp", "🔴 Khiếu nại"
- Metrics: "12K người theo dõi", "847K VND tổng chi", "23 tương tác"
- Date: DD/MM/YYYY, relative: "2 giờ trước"

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-intent-purchase` | 🟢 Purchase intent |
| `--color-intent-praise` | 🔵 Praise/positive |
| `--color-intent-question` | 🟡 Question |
| `--color-intent-complaint` | 🔴 Complaint |
| `--color-value-vip` | ★★★★★ star color (gold) |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards, panels |
| `--color-ai-accent` | AI insights card |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W048] Contact List | Parent list |
| [W046] Unified Inbox | Message integration |
| [W063] Order Detail | Purchase detail |
| [M022] Mobile Contact Detail | Mobile equivalent |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Added 5 states, 5 edge cases, 5 error scenarios, accessibility for timeline/tabs, SvelteKit impl (timeline merge, AI insights), 7 analytics, 5-stage loading, intent/value localization, 8 design tokens with intent colors. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
