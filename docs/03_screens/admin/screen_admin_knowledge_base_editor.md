# Screen: Admin — Knowledge Base Editor

> **Screen ID**: A034
> **Module**: S26 — Internal Admin & Support Operations
> **Route**: `/admin/support/kb`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: A1 Schema (`kb_categories`, `kb_articles`, `kb_article_versions`, `article_ratings`), A3 API (`KBAdminService/*`, `KBService/*`), B5 RBAC §3

---
## 1. Purpose & Context

Editorial surface for knowledge base articles, stale-content review, localized publishing, and version history. This is the canonical admin write surface behind the Help Center.

### Entry Points
- A026 Support Queue → "Create article from repeated issue"
- A001 Admin Dashboard → stale KB widget
- Direct admin nav: Support → Knowledge Base

### Exit Points
- Published article → W098 Help Article Viewer
- Related ticket set → A026 Support Queue filtered by category

---
## 2. Preconditions / Postconditions

### Preconditions
- Role: Super Admin, Operations Admin, or Support Admin
- VPN + MFA active

### Postconditions
- Draft/publish actions create `kb_article_versions`
- Publish updates search index and article freshness timer
- All edits audit-logged with version number and change note

---
## 3. Screen Layout

### ASCII Wireframe
```text
┌─ Admin Shell ───────────────────────────────────────────────────────────┐
│ 📚 Knowledge Base                   [New article] [Stale only ▢]       │
├─────────────────────────────────────────────────────────────────────────┤
│ Left: Article list                 │ Right: Editor / Preview           │
│ Draft (12) Published (184) Review │ Title [______________]            │
│ ───────────────────────────────── │ Category [AI Studio ▾]            │
│ ⚠ Connect TikTok article stale    │ Status [Draft ▾] Locale [vi-VN]  │
│ Draft: Public API auth            │ Markdown editor / preview tabs    │
│ Published: Billing credits FAQ    │ Related articles + target modules │
│                                   │ Publish checklist + version note  │
└─────────────────────────────────────────────────────────────────────────┘
```

---
## 4. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Article list | `kb_articles` | `KBAdminService/ListArticles` | Status-grouped rows | No cache |
| Stale queue | `kb_articles WHERE last_reviewed_at < now()-90d` | `KBAdminService/ListStaleArticles` | Warning badges | No cache |
| Article detail | `kb_articles`, `kb_article_versions` | `KBAdminService/GetArticle` | Split editor form | No cache |
| Version history | `kb_article_versions` | `KBAdminService/GetVersionHistory` | Timeline drawer | No cache |
| Helpfulness summary | `article_ratings` aggregation | `KBAdminService/GetArticle` | % helpful + count | 5m TTL |

---
## 5. User Actions

| # | Action | Trigger | API Call | Result | Permission |
|---|---|---|---|---|---|
| 1 | Create draft | "New article" | `KBAdminService/CreateArticle` | Empty editor opens | `admin:support:manage` |
| 2 | Save draft | Ctrl/Cmd+S | `KBAdminService/UpdateArticle` | Version note required on major changes | `admin:support:manage` |
| 3 | Publish article | "Publish" | `KBAdminService/PublishArticle` | Status → published, index refresh queued | `admin:support:manage` |
| 4 | Archive article | Row action | `KBAdminService/ArchiveArticle` | Status → archived | `admin:support:manage` |
| 5 | View public article | "Open public" | `KBService/GetArticle` | Opens W098 in new tab | `admin:support:manage` |

---
## 6. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching list/detail | Skeleton list + editor |
| DRAFT_EDITING | Unsaved changes | Dirty-dot indicator |
| REVIEW_REQUIRED | Stale or low helpfulness | Amber sidebar badge |
| PREVIEW | Preview tab active | Rendered markdown |
| PUBLISHED | Publish success | Green toast + public link |
| ERROR | Save/publish failed | Inline error card |

---
## 7. Validation Rules

| Field | Rule | Error |
|---|---|---|
| Title | Required, 10-255 chars | "Article title is required" |
| Slug | Required, unique, lowercase-hyphenated | "Slug must be unique and URL-safe" |
| Category | Required | "Select a category" |
| Body markdown | Required | "Article body cannot be empty" |
| Publish | Must have summary + estimated_read_minutes + locale | "Complete publish checklist before publishing" |

---
## 8. Related Screens

| Screen | Relationship |
|---|---|
| [screen_admin_support_queue.md](/Users/quantm/Documents/My Projects/creativanta/docs/03_screens/admin/screen_admin_support_queue.md) | Ticket-driven article creation |
| [screen_web_support_center.md](/Users/quantm/Documents/My Projects/creativanta/docs/03_screens/web/screen_web_support_center.md) | User-facing consumer |
| [screen_web_support_article.md](/Users/quantm/Documents/My Projects/creativanta/docs/03_screens/web/screen_web_support_article.md) | Public article rendering |

---
## 9. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-04-06 | 1.0 | Created to resolve missing S26 knowledge-base editing surface and bind help-center content maintenance to canonical schema/API. | System |
