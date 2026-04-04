# Screen: Web — Support Ticket Create

> **Screen ID**: W099
> **Module**: S19 — Help Center
> **Route**: `/support/new`
> **Platform**: Web (SvelteKit)
> **Upstream**: A1 Schema (support_tickets, kb_articles), B5 RBAC §2.9

---

## 1. Purpose & Context

User-facing form to submit support tickets with AI self-help pre-check, category selection, description, and file attachments. Encourages self-resolution via knowledge base before creating a ticket.

### User Goals
- Find answers to common issues without waiting for support
- Submit a clear, well-categorized ticket when self-help fails
- Attach screenshots and error logs for faster resolution
- Auto-include system context to avoid back-and-forth

### Entry Points
- Support Center (W113): "📝 Tạo ticket" button
- Help Article (W115): "Vẫn cần giúp? → Tạo ticket"
- In-app error: "Report this issue"

### Exit Points
- Ticket created → Ticket Detail (`/support/[id]`)
- Self-help resolved → closes form

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Hỗ trợ   📝 Tạo yêu cầu hỗ trợ                                 │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Step 1: AI Self-Help (pre-form) ────────────────────────────┐   │
│ │ 🤖 "Mô tả vấn đề của bạn, tôi sẽ tìm bài hướng dẫn"       │   │
│ │ [Tìm kiếm bài hướng dẫn...                            🔍]   │   │
│ │                                                                │   │
│ │ Gợi ý phổ biến:                                               │   │
│ │ [Kết nối TikTok] [Lỗi thanh toán] [AI credit] [Sync lỗi]   │   │
│ │                                                                │   │
│ │ ── Search Results ──                                           │   │
│ │ 📖 "Cách kết nối TikTok Shop" — match 92% [Xem →]           │   │
│ │ 📖 "Xử lý lỗi 401 khi kết nối" — match 78% [Xem →]         │   │
│ │                                                                │   │
│ │ [✅ Đã giải quyết — đóng] [❌ Không giải quyết — tạo ticket] │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Step 2: Ticket Form (shown after "tạo ticket") ─────────────┐   │
│ │ Category: [Connector ▾ | AI & Credits | Commerce | Billing    │   │
│ │           | Publishing | Account | Other]                      │   │
│ │ Priority: [🟢 Low] [🟡 Normal ▾] [🔴 High] [⚡ Urgent]     │   │
│ │ ℹ️ Urgent = service down / data loss / security               │   │
│ │                                                                │   │
│ │ Subject: [Không thể kết nối TikTok Shop               ]      │   │
│ │ Description:                                                   │   │
│ │ [Rich text editor ─────────────────────────────────────]       │   │
│ │ [│ Mô tả chi tiết vấn đề...                           │]      │   │
│ │ [│ • What happened?                                     │]      │   │
│ │ [│ • What did you expect?                               │]     │   │
│ │ [│ • Steps to reproduce?                                │]     │   │
│ │ [────────────────────────────────────────────────────────]      │   │
│ │                                                                │   │
│ │ Attachments: [📎 Drag & drop or click] (max 5 files, 10MB)   │   │
│ │ [screenshot.png ✕] [error_log.txt ✕]                          │   │
│ │                                                                │   │
│ │ Auto-detected context:                                         │   │
│ │ ☑ Include workspace config (plan, connected platforms)        │   │
│ │ ☑ Include browser info (user agent, viewport)                 │   │
│ │ ☑ Include recent error logs (last 24h — 3 errors found)       │   │
│ │ ℹ️ Context helps our team resolve issues faster.               │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ [Gửi yêu cầu hỗ trợ]                                                │
│ Estimated response time: ~4 hours (based on queue)                  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| SELF_HELP | Initial state | Search box + suggestions |
| SEARCHING | AI searching KB | Loading results |
| ARTICLES_FOUND | KB matches | Article list with match % |
| FORM_VISIBLE | User clicked "tạo ticket" | Full ticket form |
| SUBMITTING | Form submitted | Spinner: "Đang gửi..." |
| SUBMITTED | Success | Redirect to ticket + "✅ Ticket #{id} đã tạo. Thời gian phản hồi dự kiến: ~4h" |
| ERROR | Submit failed | Error with retry |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" — form saved locally | Submit when online |
| Submit fail | API error | Toast: "Không gửi được ticket. [Thử lại]" | Retry (form preserved) |
| Upload fail | File too large / upload error | Inline: "⚠️ File {name} quá lớn (max 10MB)" | Remove/resize |
| AI search fail | Meilisearch down | Skip self-help → show form directly | N/A |
| Context collection fail | System info unavailable | Checkboxes disabled with note | Submit without context |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Step indicator | `role="progressbar"`, `aria-label="Step {n} of 2"` |
| Self-help search | `role="searchbox"`, `aria-label="Describe your issue to find help articles"` |
| Search results | `role="listbox"`, results with `aria-label="{title} — {match}% match"` |
| Category selector | `role="radiogroup"`, `aria-label="Ticket category"` |
| Priority selector | `role="radiogroup"`, `aria-label="Priority level"` |
| File upload | `aria-label="Attach files, max 5 files 10MB each"` |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Self-help search box |
| AI search | 100-500ms | Instant search results |
| Form transition | 300ms | Slide-down animation to ticket form |
| Submit | 1-3s | "Đang gửi..." spinner on button |
| Redirect | 200ms | → Ticket detail page |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `support.create_started` | Page load | `entry_point` (center/article/error) |
| `support.self_help_searched` | Search query | `query`, `results_count` |
| `support.self_help_resolved` | "✅ Đã giải quyết" | `query`, `article_id_clicked` |
| `support.self_help_skipped` | "❌ Không giải quyết" | `query`, `results_count` |
| `support.category_selected` | Category chosen | `category` |
| `support.priority_selected` | Priority chosen | `priority` |
| `support.files_attached` | Files uploaded | `file_count`, `total_size` |
| `support.ticket_submitted` | "Gửi" confirmed | `category`, `priority`, `has_attachments`, `has_context` |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/support/new/+page.svelte`
- **Self-help**: Meilisearch instant search → `kb_articles` index with debounce 300ms
- **Form validation**: Client-side Zod schema: subject (required, 10-200 chars), description (required, 20+ chars)
- **File upload**: `SupportService/UploadAttachment` → S3, max 5 files, 10MB each
- **Auto-context**: Client collects: user agent, viewport, plan info, connected platforms, recent errors from `ErrorLogService/GetRecent(24h)`
- **Submit**: `SupportService/CreateTicket(data)` → redirect to `/support/[ticket_id]`
- **Deflection rate**: Tracked: users who self-resolved vs created ticket

---

## 13. Localization Notes

- Steps: "Bước 1: Tìm kiếm giải pháp", "Bước 2: Tạo ticket"
- Self-help: "Mô tả vấn đề của bạn, tôi sẽ tìm bài hướng dẫn"
- Form: "Danh mục", "Mức ưu tiên", "Tiêu đề", "Mô tả chi tiết"
- Submit: "Gửi yêu cầu hỗ trợ", "Thời gian phản hồi dự kiến: ~{hours}h"
- Tone: Supportive, step-by-step

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-accent` | Submit CTA, self-help search |
| `--color-success` | Self-resolved confirmation |
| `--color-priority-low` | 🟢 Low priority |
| `--color-priority-normal` | 🟡 Normal priority |
| `--color-priority-high` | 🔴 High priority |
| `--color-surface-elevated` | Form sections |
| `--radius-card` | Form cards |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W097] Support Center | Parent |
| [W098] Help Article | KB article viewer |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (submit fail, upload), form/step a11y, 8 analytics, SvelteKit impl (AI self-help, context collection, deflection), localization, 7 design tokens (priority-specific). | System |
| 2026-03-28 | 1.0 | Initial specification | System |
