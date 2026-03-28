# Screen: Web — Support Center

> **Screen ID**: W113
> **Module**: M25 — Support & Help
> **Route**: `/support`
> **Platform**: Web (SvelteKit)
> **Upstream**: A1 Schema (support_tickets, kb_articles, ticket_messages), B5 RBAC §2.7

---

## 1. Purpose & Context

Help center with self-service knowledge base, AI-powered search, and support ticket system — FAQ categories, article search, live ticket management, and status tracking.

### User Goals
- Find answers to common questions without contacting support
- Create and track support tickets for complex issues
- Search articles by keyword or category
- Check ticket status and respond to support replies

### Business Goals
- Deflect support tickets via self-service (target: 70% self-resolved)
- Track common issues for product improvement
- Reduce average response time with categorized routing
- Build searchable knowledge base for AI context

### Entry Points
- Sidebar: "🆘 Hỗ trợ"
- Footer: "Help" link
- Copilot: "Tôi cần hỗ trợ" → opens support center
- Error screens: "📞 Liên hệ hỗ trợ" button

### Exit Points
- Click article → Article Viewer (W114)
- "+ Tạo ticket" → Ticket Creation (W115)
- Click ticket → Ticket Detail (W116)

---

## 2. Preconditions / Postconditions

### Preconditions
- User is authenticated
- Knowledge base articles are indexed in Meilisearch

### Postconditions
- Ticket creation notifies support team
- Article search queries logged for content gap analysis

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🆘 Trung tâm hỗ trợ                                                │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Search ──────────────────────────────────────────────────────┐   │
│ │ [🔍 Tìm kiếm hướng dẫn, FAQ... "cách kết nối TikTok"]       │   │
│ │ 💡 Suggestions: kết nối · publish · billing · credits         │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Quick Help Categories ───────────────────────────────────────┐   │
│ │ 🚀 Getting Started (12) │ 🔗 Connections (8) │ 📤 Publish (10)│  │
│ │ 💰 Billing & Credits (6)│ 🤖 AI Studio (9)   │ 📊 Analytics (7)│ │
│ │ 🛍 Commerce (11)        │ ⚡ Workflows (5)    │ ❓ Other (4)   │  │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ My Tickets ──────────────────────────────────────────────────┐   │
│ │ 🟢 Open (2) · 🟡 Waiting (1) · ✅ Resolved (5)              │   │
│ │                                                                  │   │
│ │ #T-042 · [🟢 Open] "Shopee sync chậm" · 2d ago               │   │
│ │   Priority: Medium · Category: Connections                     │   │
│ │   Last reply: "Đội kỹ thuật đang kiểm tra..." (1d ago)       │   │
│ │   [→ View] [💬 Reply]                                         │   │
│ │                                                                  │   │
│ │ #T-041 · [🟡 Waiting for you] "Không đăng TikTok" · 3d ago   │   │
│ │   Priority: High · ⚠️ Support đã phản hồi, cần thêm thông tin│  │
│ │   [→ View] [💬 Reply]                                         │   │
│ │                                                                  │   │
│ │ [+ Tạo ticket mới]                                             │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Popular Articles ────────────────────────────────────────────┐   │
│ │ 📝 Cách kết nối TikTok Shop (đã giúp 234 người)             │   │
│ │ 📝 Hướng dẫn tạo video AI đầu tiên (189 người)              │   │
│ │ 📝 Publish thất bại — cách khắc phục (156 người)             │   │
│ │ 📝 Hiểu về AI Credits và cách mua thêm (128 người)           │   │
│ │ 📝 Cách tạo workflow tự động đầu tiên (98 người)             │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Contact ─────────────────────────────────────────────────────┐   │
│ │ 💬 Live chat (online 9-18h VN) · 📧 support@creativanta.vn  │   │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
SupportCenterPage
├── AppShell (shared)
├── PageHeader
│   └── PageTitle ("🆘 Trung tâm hỗ trợ")
├── SearchSection
│   ├── SearchInput (with Meilisearch instant search)
│   ├── SearchSuggestions (popular queries)
│   └── SearchResults (articles matching query, inline preview)
├── QuickHelpCategories
│   └── CategoryTile[] (icon, name, article count)
│       └── onClick → filtered article list
├── MyTicketsSection
│   ├── StatusSummary (open, waiting, resolved counts)
│   └── TicketCard[]
│       ├── TicketNumber + StatusBadge
│       ├── Subject
│       ├── Age (relative time)
│       ├── Priority + Category
│       ├── LastReplyPreview
│       └── ActionBar (View, Reply)
│   └── CreateTicketButton
├── PopularArticles
│   └── ArticleLink[] (title + help count)
├── ContactSection
│   ├── LiveChatButton (with availability indicator)
│   └── EmailLink
```

---

## 5. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Search | Type in search box | Meilisearch `kb_articles` index | Instant results | Any |
| 2 | Browse category | Click category tile | API filter | Filtered article list | Any |
| 3 | View article | Click article title | — | → Article Viewer (W114) | Any |
| 4 | Create ticket | "+ Tạo ticket" | — | → Ticket Creation Form (W115) | Any |
| 5 | View ticket | "→ View" | — | → Ticket Detail (W116) | Own tickets |
| 6 | Reply to ticket | "💬 Reply" | — | → Ticket Detail with reply focus | Own tickets |
| 7 | Live chat | "💬 Live chat" | — | Opens chat widget | Any (during hours) |

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Category shimmer + ticket skeletons |
| LOADED | Data received | Full support center |
| NO_TICKETS | User has no tickets | "Chưa có ticket nào. Nếu cần hỗ trợ, [+ tạo ticket mới] hoặc tìm kiếm trong Knowledge Base." |
| SEARCHING | User typing in search | Instant search results dropdown |
| SEARCH_NO_RESULTS | Search yields nothing | "Không tìm thấy bài viết. [+ Tạo ticket để được hỗ trợ]" |
| TICKET_NEEDS_REPLY | Support waiting for user reply | Orange highlight on ticket with "⚠️ Cần phản hồi" |
| ERROR | API failed | Error with retry |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached articles | Retry online |
| Search fail | Meilisearch down | Fallback: "🔍 Tìm kiếm chưa khả dụng. Duyệt danh mục bên dưới." | Browse categories |
| Tickets load fail | API error | Toast: "Không tải được tickets. [Thử lại]" | Retry |
| Live chat offline | Outside hours | Badge: "💬 Offline — Hỗ trợ từ 9-18h (VN)" | Email fallback |
| Article not found | Deleted/unpublished | "Bài viết không tồn tại. [← Về trang hỗ trợ]" | Navigate back |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Search input | `role="searchbox"`, `aria-label="Search help articles"` |
| Category tiles | `role="link"`, `aria-label="{category}: {count} articles"` |
| Ticket cards | `role="article"`, `aria-label="Ticket #{id}: {subject}, status: {status}"` |
| Status badges | Color + text + icon (not color alone) |
| Contact section | `aria-label="Contact support"`, live chat availability announced |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Search bar + category shimmer |
| Categories | 100-300ms | Tiles populate with counts |
| My tickets | 200-400ms | Ticket cards populate |
| Popular articles | 300-500ms | Article links appear |
| Search results | 50-200ms | Instant search (Meilisearch) |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `support.center_viewed` | Page load | `open_tickets`, `ticket_needs_reply` |
| `support.searched` | Search query submitted | `query`, `results_count` |
| `support.article_clicked` | Article link clicked | `article_id`, `source` (search/category/popular) |
| `support.category_browsed` | Category tile clicked | `category`, `article_count` |
| `support.ticket_viewed` | "→ View" on ticket | `ticket_id`, `status` |
| `support.ticket_replied` | "💬 Reply" | `ticket_id` |
| `support.ticket_create_started` | "+ Tạo ticket" | `from_search`, `search_query` |
| `support.live_chat_opened` | "💬 Live chat" | `available` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/support/+page.svelte`
- **Server load**: `+page.server.ts` → `SupportService/GetMyTickets(user_id)` + `KBService/GetPopularArticles` + `KBService/GetCategories`
- **Search**: Client-side Meilisearch instant search → `kb_articles` index with debounce 300ms
- **Categories**: Pre-computed article counts from `KBService/GetCategoryCounts`
- **Live chat**: Intercom/Crisp widget loaded conditionally based on business hours (9-18h VN)
- **Ticket needs reply**: Highlighted with orange badge if support replied and waiting for user

---

## 12. Localization Notes

- Title: "Trung tâm hỗ trợ"
- Search: "Tìm kiếm hướng dẫn, FAQ..."
- Ticket status: "🟢 Đang mở", "🟡 Chờ phản hồi", "✅ Đã giải quyết"
- Popular: "Bài viết phổ biến", "đã giúp {count} người"
- Tone: Supportive, helpful

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-ticket-open` | 🟢 Open ticket |
| `--color-ticket-waiting` | 🟡 Waiting for reply |
| `--color-ticket-resolved` | ✅ Resolved |
| `--color-accent` | Search, create ticket CTA |
| `--color-surface-elevated` | Category tiles, ticket cards |
| `--color-text-secondary` | Help counts, relative times |
| `--color-chat-online` | Live chat available indicator |
| `--radius-card` | Category tiles, cards |

---

## 14. Related Screens

| Screen | Relationship |
|---|---|
| [W114] Article Viewer | Knowledge base article detail |
| [W115] Ticket Creation | Create new support ticket |
| [W116] Ticket Detail | Ticket conversation thread |
| [M042] Mobile Support | Mobile equivalent |

---

## 15. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (search fail, chat offline), search/ticket a11y, 8 analytics, SvelteKit impl (Meilisearch, live chat), localization, 8 design tokens (ticket-specific). | System |
| 2026-03-28 | 1.0 | Initial specification | System |
