# Screen: Mobile — Workflow Recipes / Templates

> **Screen ID**: M054
> **Module**: M21 — Workflow Marketplace / Recipe Economy / Agent Center
> **Route**: `/m/workflows/templates`
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 03 §Workflow/Agent, A1 Schema (workflow_templates, template_ratings), B5 RBAC §2.7

---

## 1. Purpose & Context

Browse, search, and deploy pre-built workflow templates (recipes) on mobile. Features category filters, community ratings, credit cost estimates, and one-tap deployment. Designed to make workflow adoption dead-simple, even for non-technical users.

### User Story
> As a creator who doesn't know coding, I want to browse ready-made workflow recipes and deploy them with one tap so I can automate repetitive tasks immediately.

### Business Goal
- Lower barrier to workflow adoption (target: 70% of users deploy ≥1 recipe in first week)
- Drive workflow marketplace engagement
- Reduce custom workflow support requests
- Monetize premium recipes (future marketplace revenue)

### When to Use
- New user onboarding: "Không cần code — chọn template và bắt đầu"
- Exploring automation possibilities
- Finding solutions for specific tasks (auto-replies, content pipelines, reporting)
- Replacing manual processes with automated ones

### Entry Points
- Workflows tab → "📋 Templates" segment
- Onboarding flow → "Pick your first recipe"
- Copilot: "Tôi muốn tự động trả lời comment" → suggests recipe
- Dashboard: "💡 Workflows can automate this" → shows relevant templates
- Push: "🆕 New popular template: Auto-engage"

### Exit Points
- "📥 Use" → Deploy → navigate to workflow runs or editor
- Template detail → view steps → decide
- Back → Workflow list

---

## 2. Preconditions / Postconditions

### Preconditions
- User is authenticated
- User has `workflow:read` permission
- Template marketplace data loaded

### Postconditions
- Template deployed as active workflow or draft
- Credits deducted per-run when workflow executes
- First-run tutorial attached (for beginners)
- Analytics: `recipe.deployed`

---

## 3. Layout Structure

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Recipes                                       [🔍 Tìm kiếm]     │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ ┌─ Featured Banner ───────────────────────────────────────────────┐  │
│ │ 🔥 Template tuần này                                            │  │
│ │ "Auto-respond to purchase inquiries"                            │  │
│ │ 1,234 người dùng · ⭐ 4.8/5                                    │  │
│ │ [📥 Dùng ngay]                                                  │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ Categories (scrollable):                                              │
│ [🔥 Popular] [💬 Engagement] [🛍 Commerce] [📤 Content]             │
│ [📊 Analytics] [🤖 AI Tools] [📦 Operations]                        │
│                                                                       │
│ ┌─ Template Card ─────────────────────────────────────────────────┐  │
│ │ ⚡ "Auto-respond to purchase inquiries"                         │  │
│ │ 💬 Engagement · 1,234 lượt dùng · ⭐ 4.8/5                     │  │
│ │                                                                 │  │
│ │ 📋 4 bước · ~5 cr/lần · ⏱ Setup < 2 phút                      │  │
│ │ 🟢 Miễn phí                                                    │  │
│ │                                                                 │  │
│ │ "Tự động trả lời khi khách hỏi về sản phẩm."                  │  │
│ │                                                                 │  │
│ │ [📥 Dùng template]                [👁 Xem chi tiết]            │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Template Card ─────────────────────────────────────────────────┐  │
│ │ ⚡ "Daily content pipeline"                                     │  │
│ │ 📤 Content · 890 lượt dùng · ⭐ 4.6/5                          │  │
│ │                                                                 │  │
│ │ 📋 7 bước · ~25 cr/lần · ⏱ Setup < 5 phút                     │  │
│ │ ⭐ Pro                                                          │  │
│ │                                                                 │  │
│ │ "Tạo content hàng ngày: idea → script → draft → review."      │  │
│ │                                                                 │  │
│ │ [📥 Dùng template]                [👁 Xem chi tiết]            │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Template Card ─────────────────────────────────────────────────┐  │
│ │ ⚡ "Smart seeding follow-up"                                    │  │
│ │ 🛍 Commerce · 456 lượt dùng · ⭐ 4.5/5                         │  │
│ │                                                                 │  │
│ │ 📋 5 bước · ~8 cr/lần · ⏱ Setup < 3 phút                      │  │
│ │ 🟢 Miễn phí                                                    │  │
│ │                                                                 │  │
│ │ "Follow-up seeding KOC tự động sau khi gửi mẫu."              │  │
│ │                                                                 │  │
│ │ [📥 Dùng template]                [👁 Xem chi tiết]            │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ Pull-to-refresh ↻                                                    │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [📋] [➕] [💬] [👤]                                            │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
RecipesScreen
├── AppBar
│   ├── BackButton
│   ├── Title ("Recipes")
│   └── SearchButton (opens search overlay)
├── FeaturedBanner (carousel — top recipes of the week)
│   ├── BannerImage/Gradient
│   ├── TemplateTitle
│   ├── UsageStats
│   └── QuickUseButton
├── CategoryChips (horizontal scroll)
│   └── CategoryChip[]
│       ├── CategoryIcon
│       ├── CategoryLabel
│       └── ActiveIndicator
├── TemplateList (scrollable, pull-to-refresh)
│   └── TemplateCard[]
│       ├── TemplateIcon + Title
│       ├── CategoryBadge + UsageCount + StarRating
│       ├── MetaRow
│       │   ├── StepCount ("📋 4 bước")
│       │   ├── CreditCost ("~5 cr/lần")
│       │   └── SetupTime ("⏱ < 2 phút")
│       ├── PriceTier ("🟢 Miễn phí" / "⭐ Pro" / "💎 Business")
│       ├── Description (1-2 lines, truncated)
│       └── ActionRow
│           ├── UseTemplateButton (primary CTA)
│           └── ViewDetailButton (secondary)
├── SearchOverlay (conditional — from search icon)
│   ├── SearchInput
│   └── SearchResults
├── TemplateDetailBottomSheet (conditional — from "Xem chi tiết")
│   ├── TemplateHeader (icon + title + rating)
│   ├── Description (full text)
│   ├── StepList (visual pipeline: Step 1 → 2 → 3 → ...)
│   │   └── StepItem[]
│   │       ├── StepNumber
│   │       ├── StepName
│   │       ├── StepType (AI / Manual / Condition / Action)
│   │       └── CreditCost
│   ├── Reviews (top 3 with ratings)
│   ├── RequirementsList (connected accounts, permissions needed)
│   ├── UseTemplateButton (full-width CTA)
│   └── ShareButton
├── DeployConfirmDialog (conditional — from "Dùng template")
│   ├── TemplateSummary
│   ├── DeployModeSelector
│   │   ├── ActiveRadio ("Kích hoạt ngay")
│   │   └── DraftRadio ("Lưu nháp để chỉnh sửa")
│   ├── ConnectionCheck (missing connections → warning)
│   └── DeployButton
└── BottomNavBar (shared)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Featured templates | `workflow_templates WHERE featured=true` | `TemplateService/GetFeatured` | Carousel banner cards | 1h TTL |
| Template list | `workflow_templates` | `TemplateService/ListTemplates(category, page)` | Card list | 15m TTL |
| Usage count | `workflow_templates.usage_count` | included | "1,234 lượt dùng" | 15m TTL |
| Star rating | `template_ratings` avg | included | "⭐ 4.8/5" | 15m TTL |
| Credit cost | `workflow_templates.estimated_credits` | included | "~5 cr/lần" | Static |
| Step count | `workflow_template_steps` count | included | "📋 4 bước" | Static |
| Setup time | `workflow_templates.setup_minutes` | included | "⏱ < 2 phút" | Static |
| Price tier | `workflow_templates.plan_required` | included | Badge: 🟢/⭐/💎 | Static |
| Reviews | `template_ratings` | `TemplateService/GetReviews(id)` | Star + text | 30m TTL |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Filter by category | Tap category chip | `TemplateService/ListTemplates(category)` | — | List filters | Any |
| 2 | Search templates | Type in search overlay | `TemplateService/SearchTemplates(q)` | — | Search results replace list | Any |
| 3 | View detail | Tap "👁 Xem chi tiết" | `TemplateService/GetTemplate(id)` | — | Open TemplateDetailBottomSheet | Any |
| 4 | Use template | Tap "📥 Dùng template" | — | — | Open DeployConfirmDialog | `workflow:create` |
| 5 | Deploy as active | Confirm deploy (active mode) | `TemplateService/Deploy(id, active=true)` | Create workflow from template, activate | Toast "✅ Workflow đã kích hoạt!" → navigate to runs | `workflow:create` |
| 6 | Deploy as draft | Confirm deploy (draft mode) | `TemplateService/Deploy(id, active=false)` | Create workflow from template, draft | Toast "📝 Đã lưu nháp" → navigate to editor | `workflow:create` |
| 7 | Rate template | Tap star rating in detail sheet | — | — | Open RatingBottomSheet | Any (who deployed) |
| 8 | Share template | Tap share in detail sheet | — | — | System share sheet with deep link | Any |
| 9 | Pull to refresh | Pull gesture | `TemplateService/ListTemplates` | — | List refreshes | Any |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching templates | Shimmer featured banner + skeleton cards |
| LOADED | Templates available | Featured + category + cards |
| EMPTY | No templates in category | "Chưa có template cho danh mục này." |
| SEARCH_RESULTS | Search query active | Filtered results list |
| SEARCH_EMPTY | Search no results | "Không tìm thấy template. Thử từ khóa khác?" |
| DEPLOYING | Template being deployed | Dialog shows "Đang tạo workflow..." spinner |
| DEPLOYED | Deploy successful | Success toast → navigate away |
| DEPLOY_FAILED | Deploy error | Toast: "Không thể tạo workflow. Thử lại." |
| PLAN_REQUIRED | Template requires higher plan | Upsell prompt: "Template này yêu cầu Pro. [Nâng cấp →]" |
| CONNECTION_MISSING | Template needs unconnected platform | Warning: "Cần kết nối TikTok để dùng template. [Kết nối →]" |
| ERROR | API failure | Error state with retry |

---

## 8. Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Deploy mode | Must select one (active/draft) | "Chọn chế độ triển khai" |
| Connection check | All required connections present | "Cần kết nối {platform} trước khi kích hoạt" |
| Credit balance | Sufficient for first run | "Cần ít nhất {n} credits. [Nạp thêm →]" |

---

## 9. Permission Matrix

| Action | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| Browse templates | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| View details | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Deploy template | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Rate template | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

---

## 10. Navigation Map

```
Recipes (/m/workflows/templates)
├── → TemplateDetailBottomSheet        (via "Xem chi tiết")
├── → DeployConfirmDialog              (via "Dùng template")
├── → /m/workflows/runs                (after deploy as active)
├── → /m/workflows/[id]/edit           (after deploy as draft)
├── → /m/settings/connections          (via connection warning)
├── → /m/settings/billing              (via plan upgrade prompt)
├── → SearchOverlay                    (via search icon)
└── ← /m/workflows                    (via back)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Template list failed | API error | Full-screen error with retry | Pull-to-refresh |
| Deploy failed | Server error | Toast: "Deploy thất bại. Thử lại." | Retry button |
| Plan required | Template tier > user tier | Upsell prompt with upgrade CTA | Upgrade or choose free template |
| Connection missing | Template needs unconnected platform | Warning with connection CTA | Connect platform |
| Credits insufficient | Not enough credits for run | Warning with buy credits CTA | Buy credits |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Category chips | `Semantics(selected: true/false)`, scrollable |
| Template cards | Full label: "Auto-respond, 4 bước, 5 credits, 4.8 sao, miễn phí" |
| Star rating | `Semantics(label: "Đánh giá 4.8 trên 5 sao")` |
| Deploy dialog | Focus trap, clear action labels |
| Featured banner | Auto-scroll pauses on touch, manual navigation available |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + shimmer banner + skeleton cards |
| Featured load | 200-300ms | Banner animates in |
| Template list | 300-600ms | Cards stagger in (50ms each) |
| Deploy action | 1-3s | Dialog spinner → success toast → navigate |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Screen render | <1.5s |
| Template list | <500ms |
| Deploy action | <3s |
| Search response | <300ms |
| Image load (template icons) | <500ms with placeholder |

---

## 15. Real-time Updates

N/A — Template catalog is read-only, cached with 15m TTL. Feature banner refreshes hourly.

---

## 16. Localization Notes

- Vietnamese labels for all UI
- Template descriptions: Vietnamese (curated by Creativanta team)
- Credit abbreviation: "cr" (universal)
- Numbers: dot separator (1.234 lượt dùng)

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `recipes.viewed` | Screen load | `source`, `category_default` |
| `recipes.category_selected` | Tap category | `category` |
| `recipes.template_viewed` | Open detail | `template_id`, `template_name`, `category` |
| `recipes.template_deployed` | Deploy confirmed | `template_id`, `mode` (active/draft), `category` |
| `recipes.template_rated` | Submit rating | `template_id`, `rating` |
| `recipes.search` | Search executed | `query`, `result_count` |
| `recipes.upsell_shown` | Plan required shown | `template_id`, `required_plan` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Use template CTA button |
| `--color-surface-elevated` | Template cards |
| `--color-success` | Free badge |
| `--color-warning` | Pro badge (⭐) |
| `--color-premium` | Business badge (💎) |
| `--radius-card` | Template card radius |
| `--gradient-featured` | Featured banner gradient |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W103] Web Recipe Templates | Web equivalent (grid layout with preview) |
| [M050] Workflow Monitor | Destination after deploy-as-active |
| [W101] Workflow Builder | Destination after deploy-as-draft |
| [M052] Task Queue | Tasks generated by deployed workflows |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | Full 20-point upgrade from 62-line Tier C. Added featured banner carousel, template detail bottom sheet with step pipeline visualization, deploy confirm dialog with mode selector, connection/credit/plan pre-checks, review section, 11 states, beginner-friendly UX. Fixed Screen ID (M060→M053), module (M20→M21). | System |
