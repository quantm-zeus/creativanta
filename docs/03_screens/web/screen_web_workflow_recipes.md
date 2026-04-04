# Screen: Web — Recipe Templates

> **Screen ID**: W103
> **Module**: M20 — Workflow Studio (Templates)
> **Route**: `/workflows/templates`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 05, PRD §28, A1 Schema (workflow_templates), B5 RBAC §2.7

---

## 1. Purpose & Context

Pre-built workflow templates — one-click deploy common automation recipes for content creation, engagement, commerce, and analytics. Templates are curated by Creativanta and rated by the community.

### User Goals
- Browse proven automation recipes by category
- Preview the workflow flow before deploying
- One-click deploy a template to their workspace
- Find inspiration for custom workflows

### Business Goals
- Lower barrier to workflow adoption (< 1 min to automate)
- Track popular templates for product direction
- Enable community-driven template ratings

### Entry Points
- Workflow List (W101): "📋 Templates" button
- Sidebar: Workflows → "📋 Templates"
- Copilot: "Suggest workflows for engagement"

### Exit Points
- "📥 Use template" → Workflow Builder (W102) with template pre-loaded
- "▶ Preview" → Read-only workflow canvas modal

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Workflows   📋 Workflow Templates     [🔍 Search templates...]   │
├──────────────────────────────────────────────────────────────────────┤
│ Categories: [🔥 Popular] [💬 Engagement] [🛍 Commerce]             │
│             [📤 Content] [📊 Analytics] [⚡ Productivity]          │
│                                                                      │
│ ┌─ Template Card ───────────────────────────────────────────────┐   │
│ │ ⚡ "Auto-respond to purchase inquiries"                       │   │
│ │ 💬 Engagement · Used by 1,234 workspaces · ⭐ 4.8/5 (89)    │   │
│ │                                                                │   │
│ │ Trigger: New comment with purchase intent                      │   │
│ │ Steps: AI detect intent → Generate reply → Approval check     │   │
│ │        → Send reply (4 steps)                                  │   │
│ │                                                                │   │
│ │ Estimated setup: < 2 min · Credits/run: ~5                    │   │
│ │ [▶ Preview flow] [📥 Use template]                            │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Template Card ───────────────────────────────────────────────┐   │
│ │ ⚡ "Daily content pipeline"                                    │   │
│ │ 📤 Content · Used by 890 · ⭐ 4.6/5 (56)                     │   │
│ │                                                                │   │
│ │ Trigger: Cron 10:00 daily                                      │   │
│ │ Steps: Check trends → Generate 3 ideas → Create scripts →    │   │
│ │        Queue for review (7 steps)                              │   │
│ │                                                                │   │
│ │ Estimated setup: < 5 min · Credits/run: ~25                   │   │
│ │ [▶ Preview flow] [📥 Use template]                            │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Template Card ───────────────────────────────────────────────┐   │
│ │ ⚡ "Order fulfillment notifications"                           │   │
│ │ 🛍 Commerce · Used by 2,100 · ⭐ 4.9/5 (120)                 │   │
│ │ Trigger: New order → Notify team → Update status → Thank      │   │
│ │ [▶ Preview] [📥 Use]                                           │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Template Card ───────────────────────────────────────────────┐   │
│ │ ⚡ "Weekly analytics digest"                                   │   │
│ │ 📊 Analytics · Used by 650 · ⭐ 4.5/5                         │   │
│ │ Trigger: Cron Monday 9AM → Compile stats → Send email         │   │
│ │ [▶ Preview] [📥 Use]                                           │   │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
RecipeTemplatesPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Workflows")
│   ├── PageTitle ("📋 Workflow Templates")
│   └── SearchInput
├── CategoryChips (Popular, Engagement, Commerce, Content, Analytics, Productivity)
├── TemplateGrid
│   └── TemplateCard[]
│       ├── TemplateName + Icon
│       ├── CategoryBadge + UsageCount + Rating
│       ├── TriggerDescription
│       ├── StepsSummary (text flow + step count)
│       ├── SetupTimeEstimate + CreditCostEstimate
│       └── ActionBar
│           ├── PreviewButton ("▶ Preview flow")
│           └── UseButton ("📥 Use template")
├── PreviewModal (read-only workflow canvas)
│   ├── WorkflowCanvasPreview (visual flow)
│   ├── StepList (each step with description)
│   ├── RequirementsNote (connected platforms, permissions)
│   └── UseButton
```

---

## 5. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Card skeletons |
| LOADED | Templates available | Grid with cards |
| SEARCH_RESULTS | User searching | Filtered template list |
| NO_RESULTS | Search yields nothing | "Không tìm thấy template. [← Xem tất cả]" |
| PREVIEW_OPEN | Preview modal visible | Read-only workflow canvas |
| DEPLOYING | Template being deployed | "Đang tạo workflow từ template..." spinner |
| ERROR | API failed | Error with retry |

---

## 6. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached templates | Retry online |
| Deploy fail | API error | Toast: "Không tạo được workflow từ template. [Thử lại]" | Retry |
| Preview load fail | Template data error | Modal: "Không tải được preview" | Close + retry |
| Search fail | Meilisearch down | Fallback to category browsing | N/A |
| Platform missing | Required connector not connected | Alert: "Template cần kết nối {platform}. [→ Cài đặt]" | Connect first |

---

## 7. Accessibility

| Element | Requirement |
|---|---|
| Category chips | `role="tablist"`, `aria-selected` |
| Template cards | `role="article"`, `aria-label="{name}, {category}, rated {rating}, used by {count}"` |
| Preview modal | `role="dialog"`, `aria-label="Preview: {template_name}"`, trap focus |
| Rating | `aria-label="Rating: {rating} out of 5, {count} reviews"` |
| Use button | `aria-label="Deploy template: {name}"` |

---

## 8. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Category chips + card skeletons |
| Templates | 200-400ms | Cards populate per category |
| Search | 100-300ms | Filtered results |
| Preview modal | 300-500ms | Canvas preview renders |
| Deploy | 1-3s | "Đang tạo workflow..." spinner |

---

## 9. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `workflow.templates_viewed` | Page load | `category` (default: popular) |
| `workflow.template_previewed` | "▶ Preview" | `template_id`, `category` |
| `workflow.template_deployed` | "📥 Use template" | `template_id`, `category` |
| `workflow.template_searched` | Search query | `query`, `results_count` |
| `workflow.category_switched` | Category chip clicked | `category` |
| `workflow.template_rated` | Rating submitted | `template_id`, `rating` |
| `workflow.deploy_failed` | Deploy error | `template_id`, `error` |
| `workflow.missing_platform` | Platform required | `template_id`, `platform` |

---

## 10. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/workflows/templates/+page.svelte`
- **Server load**: `+page.server.ts` → `TemplateService/ListTemplates(category?)` + `GetPopular`
- **Search**: Client-side Meilisearch → `workflow_templates` index
- **Deploy**: `TemplateService/Deploy(template_id, workspace_id)` → creates workflow in draft → redirect to builder
- **Preview**: Modal with read-only SvelteFlow canvas rendering template nodes
- **Platform check**: Before deploy, verify required connectors via `ConnectorService/CheckRequirements`

---

## 11. Localization Notes

- Categories: "Phổ biến", "Tương tác", "Thương mại", "Nội dung", "Phân tích", "Năng suất"
- Cards: "Được dùng bởi {n} workspace", "Thời gian cài: ~{min} phút", "Credits/lần: ~{n}"
- Actions: "Xem trước", "Sử dụng template"
- Tone: Inspirational, low-barrier

---

## 12. Design Tokens

| Token | Usage |
|---|---|
| `--color-accent` | Use template CTA |
| `--color-category-active` | Selected category chip |
| `--color-rating` | ⭐ Star rating |
| `--color-surface-elevated` | Template cards |
| `--font-metric` | Usage count, credits (tabular-nums) |
| `--radius-card` | Card corners |
| `--color-border` | Card borders |

---

## 13. Related Screens

| Screen | Relationship |
|---|---|
| [W100] Workflow List | Parent |
| [W101] Workflow Builder | Destination after "Use template" |

---

## 14. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (deploy, preview), card/preview a11y, 8 analytics, SvelteKit impl (deploy, search, platform check), localization, 7 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
