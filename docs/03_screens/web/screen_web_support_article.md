# Screen: Web — Help Article Viewer

> **Screen ID**: W098
> **Module**: S19 — Help Center
> **Route**: `/support/articles/[slug]`
> **Platform**: Web (SvelteKit)
> **Upstream**: A1 Schema (kb_articles, article_ratings), B5 RBAC §2.9

---

## 1. Purpose & Context

Individual help article with table-of-contents sidebar, related articles, breadcrumb navigation, feedback system, and escalation path to ticket creation.

### User Goals
- Find answer to their question/issue
- Navigate article sections with sidebar TOC
- Rate article helpfulness
- Escalate to ticket if article doesn't resolve issue

### Entry Points
- Support Center (W113): click on article
- Ticket Create (W114): KB search result
- Copilot: "📖 Here's an article that might help"
- External search (indexed by Google)

### Exit Points
- "Tạo ticket" → Ticket Create (W114) with article context
- Related article → another article
- "← Trung tâm hỗ trợ" → Support Center (W113)

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Trung tâm hỗ trợ   📖 Cách kết nối TikTok Shop                  │
├──────────────────────────┬───────────────────────────────────────────┤
│ Sidebar (25%)            │ Article Content (75%)                      │
│ ┌─ In This Article ───┐ │ Breadcrumb: Hỗ trợ > Connectors > TikTok │
│ │ ▸ Yêu cầu trước     │ │                                           │
│ │ ▸ Bước 1: Tạo shop  │ │ # Cách kết nối TikTok Shop               │
│ │ ▸ Bước 2: Kết nối   │ │ ✏️ Cập nhật: 25/3/2026 · ⏱ Đọc ~5 phút │
│ │ ▸ Bước 3: Xác minh  │ │ 👁 1,234 lượt xem · 👍 92% hữu ích     │
│ │ ▸ Xử lý lỗi         │ │                                           │
│ │ ▸ Câu hỏi thường gặp│ │ ## Yêu cầu trước khi bắt đầu            │
│ └─────────────────────┘ │ ✅ TikTok Business account (không phải    │
│                          │    personal)                               │
│ ┌─ Related Articles ──┐ │ ✅ Shop đã đăng ký trên TikTok Shop      │
│ │ 📖 Fix lỗi 401      │ │ ✅ Creativanta Pro plan trở lên           │
│ │ 📖 Sync đơn hàng    │ │                                           │
│ │ 📖 Cài đặt webhook  │ │ ## Bước 1: Tạo shop trên TikTok          │
│ └─────────────────────┘ │ [📸 Screenshot hướng dẫn]                 │
│                          │ 1. Vào TikTok Seller Center...             │
│ ┌─ Tags ───────────────┐│ 2. Chọn "Đăng ký shop mới"...            │
│ │ #TikTok #Shop        ││                                           │
│ │ #Connector #Setup    ││ ## Xử lý lỗi thường gặp                  │
│ └─────────────────────┘ │ | Lỗi | Nguyên nhân | Cách xử lý |        │
│                          │ | 401 | Token hết hạn | Re-authorize |    │
│                          │ | 403 | Thiếu quyền | Check scopes |     │
│                          │ | 429 | Rate limit | Đợi 15 phút |       │
│                          │                                           │
│                          │ ┌─ Feedback ─────────────────────────┐    │
│                          │ │ Bài viết này hữu ích không?         │    │
│                          │ │ [👍 Có, cảm ơn!] [👎 Chưa đủ]     │    │
│                          │ │ (If 👎) "Chi tiết thêm:" [____]    │    │
│                          │ └─────────────────────────────────────┘   │
│                          │                                           │
│                          │ [📝 Vẫn cần giúp? → Tạo ticket]          │
│                          │ (Auto-fills: article context + category)  │
└──────────────────────────┴───────────────────────────────────────────┘
```

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Content skeleton |
| LOADED | Article ready | Full article with TOC |
| NOT_FOUND | Invalid slug | "Bài viết không tồn tại. [← Về trang hỗ trợ]" |
| OUTDATED | Last update > 90 days | Yellow banner: "⚠️ Bài viết này có thể đã cũ (cập nhật {date})." |
| RATED | User submitted feedback | "Cảm ơn phản hồi! ✅" |
| ERROR | API failed | Error with retry |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached article | Retry online |
| Article not found | Invalid slug | "Bài viết không tồn tại. [← Về trang hỗ trợ]" | Navigate back |
| Feedback fail | API error | Toast: "Không gửi được phản hồi. [Thử lại]" | Retry |
| Related articles fail | API error | Section hidden gracefully | N/A |
| Image load fail | CDN error | Placeholder: "[📸 Ảnh không tải được]" | Reload |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Article content | Semantic HTML headings (h1-h6), proper reading order |
| TOC sidebar | `role="navigation"`, `aria-label="Table of contents"` |
| Feedback buttons | `aria-label="Rate article helpful"` / `aria-label="Rate article not helpful"` |
| Related articles | `role="navigation"`, `aria-label="Related articles"` |
| Outdated banner | `role="alert"`, `aria-label="This article may be outdated"` |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Content skeleton + sidebar skeleton |
| Article content | 200-400ms | Markdown renders |
| TOC | 50ms (client) | Generated from rendered headings |
| Related articles | 300-500ms | Sidebar populates |
| View count | 200-300ms | Meta line updates |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `support.article_viewed` | Page load | `article_id`, `slug`, `category`, `source` |
| `support.article_scrolled` | 50%/100% scroll | `article_id`, `scroll_pct` |
| `support.article_rated_helpful` | "👍 Có" | `article_id` |
| `support.article_rated_unhelpful` | "👎 Chưa đủ" | `article_id`, `feedback_text` |
| `support.toc_clicked` | TOC link clicked | `article_id`, `heading` |
| `support.related_clicked` | Related article clicked | `from_article`, `to_article` |
| `support.escalated` | "→ Tạo ticket" | `article_id` |
| `support.article_shared` | Share button | `article_id`, `method` |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/support/articles/[slug]/+page.svelte`
- **Server load**: `+page.server.ts` → `KBService/GetArticle(slug)` + `GetRelated(article_id)` + increment view count
- **Markdown rendering**: `mdsvex` or `marked` with syntax highlighting via `shiki`
- **TOC generation**: Client-side from rendered headings, intersection observer for active section
- **Feedback**: `KBService/RateArticle(article_id, helpful, feedback_text)` — single rate per user
- **Outdated detection**: `updated_at < now - 90 days` → shows warning banner
- **SEO**: Server-rendered, `meta description` from article summary, `og:title`

---

## 13. Localization Notes

- Meta: "Cập nhật: {date}", "Đọc ~{min} phút", "{count} lượt xem"
- Feedback: "Bài viết này hữu ích không?", "Có, cảm ơn!", "Chưa đủ"
- Escalation: "Vẫn cần giúp? → Tạo ticket"
- Outdated: "Bài viết này có thể đã cũ (cập nhật {date})"
- Tone: Helpful, instructional

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-accent` | TOC active link, escalation CTA |
| `--color-success` | Helpful badge, rated confirmation |
| `--color-warning` | Outdated banner |
| `--color-surface-elevated` | Sidebar, feedback section |
| `--color-text-secondary` | Meta line (views, date) |
| `--color-border` | TOC section dividers |
| `--font-body` | Article content (readable, 1.6 line-height) |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W097] Support Center | Parent |
| [W099] Ticket Create | Escalation |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (not found, feedback), TOC/feedback a11y, 8 analytics, SvelteKit impl (markdown, TOC, feedback, SEO), localization, 7 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
