# Screen: Web — Store Pages & Editor

> **Screen ID**: W072
> **Module**: M15 — see canonical feature owner in screen_task_map.csv
> **Route**: `/store` (list) or `/store/[id]/edit` (editor)
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 06 §10, A1 Schema (store_pages, store_sections, store_themes, products, orders), B5 RBAC §2.7

---

## 1. Purpose & Context

Store Pages is the no-code micro-storefront builder — creators build product landing pages with a visual drag-and-drop editor, then publish to `creativanta.link/shop/{slug}`. Supports hero banners, product grids, testimonials, about sections, FAQ, and custom HTML. Includes live preview, theme customization, and per-page conversion tracking (views → orders).

### User Goals
- Create beautiful product landing pages without coding
- Customize storefront appearance (theme, colors, fonts, sections)
- Preview changes in real-time before publishing
- Track page performance (views, orders, conversion rate)
- Share store URLs on social platforms and link-in-bio

### Business Goals
- Enable independent storefronts beyond marketplace platforms
- Increase conversion through purpose-built landing pages
- Drive direct sales (no platform commission) via own storefront
- Support brand storytelling through custom page sections

### When This Screen Is Used
- **List view**: Managing multiple store pages, checking performance
- **Editor**: Building or editing a specific store page
- **Pre-launch**: Setting up store page before product launch campaign
- **Post-campaign**: Reviewing conversion data per page

### Entry Points
- Sidebar: Commerce → "🏪 Store Pages"
- Link-in-Bio (W070): "Add store page" link
- Product Detail (W061): "🏪 Create store page" action
- AI Copilot: "Tạo landing page cho bộ sưu tập Summer Skincare"

### Exit Points
- "👁 Preview" → live preview in new tab (public URL)
- "📊 Analytics" → per-page conversion analytics
- "📤 Share" → copy public URL or share to platforms
- Click product in editor → Product Detail (W061)

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid workspace session
- User has `store:manage` permission (Editor+ for editing)
- At least 1 product exists for product section inclusion

### Postconditions
- Page creation/edits auto-saved every 5 seconds
- Publish action deploys to CDN (creativanta.link/shop/{slug})
- Analytics tracking pixel embedded in published pages
- Audit log: `store.page.created` / `store.page.published`

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | **List**: Full cards. **Editor**: 30% section panel + 70% live preview |
| Tablet (768-1279px) | **List**: Stacked cards. **Editor**: Toggle between panel/preview |
| Mobile (≤767px) | List only (redirect to desktop for editor) |

### ASCII Wireframe — Store List
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🏪 Store Pages (3)                               [+ Tạo page mới] │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Page Card ─────────────────────────────────────────────────────┐ │
│ │ [🖼 Thumbnail]  🏪 "Summer Skincare Collection"   [🟢 Published]│ │
│ │                  creativanta.link/shop/summer-skincare  [📋]    │ │
│ │                  Products: 8 · Last edited: 2d ago              │ │
│ │                                                                  │ │
│ │                  ┌────────┐ ┌────────┐ ┌────────┐               │ │
│ │                  │ Views  │ │ Orders │ │ CVR    │               │ │
│ │                  │ 1,234  │ │ 45     │ │ 3.6%   │               │ │
│ │                  └────────┘ └────────┘ └────────┘               │ │
│ │                                                                  │ │
│ │ [✏ Editor] [👁 Preview] [📊 Analytics] [📤 Share] [📋] [⋮]   │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Page Card (draft) ─────────────────────────────────────────────┐ │
│ │ [📋 Empty]   📋 "New Year Collection"              [📋 Draft]  │ │
│ │              Sections: 0 · Created: 1d ago                      │ │
│ │              [✏ Editor] [📤 Publish] [🗑 Delete]               │ │
│ └──────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘
```

### ASCII Wireframe — Visual Editor
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Store   ✏ Editor: "Summer Skincare"   [💾 Auto-saved] [👁] [🚀] │
├──────────────────────────┬───────────────────────────────────────────┤
│ ── Section Panel (30%) ──│── Live Preview (70%) ─────────────────────│
│                          │                                           │
│ Sections (drag to sort): │ ┌────────────────────────────────────────┐│
│                          │ │                                        ││
│ ⠿ 🖼 Hero Banner       │ │  🖼 [Hero image with gradient overlay] ││
│   Image: [📷 Upload]    │ │  "Summer Skincare Collection"          ││
│   Title: [Summer Sk...]  │ │  "Glow from within this summer"       ││
│   Subtitle: [Glow...]   │ │  [Shop Now →]                          ││
│   CTA text: [Shop now]  │ │                                        ││
│   CTA link: [#products]  │ └────────────────────────────────────────┘│
│                          │                                           │
│ ⠿ 🛍 Featured Products  │ ┌────────────────────────────────────────┐│
│   Layout: [Grid 3] [2]  │ │ ┌──────┐ ┌──────┐ ┌──────┐           ││
│   Products: 6 ✏         │ │ │Prod 1│ │Prod 2│ │Prod 3│           ││
│   Show price: ☑         │ │ │ 250K │ │ 180K │ │ 320K │           ││
│   Show stock: ☐         │ │ └──────┘ └──────┘ └──────┘           ││
│                          │ │ ┌──────┐ ┌──────┐ ┌──────┐           ││
│ ⠿ 📝 About Us           │ │ │Prod 4│ │Prod 5│ │Prod 6│           ││
│   Text: [Rich editor ▾] │ │ └──────┘ └──────┘ └──────┘           ││
│                          │ └────────────────────────────────────────┘│
│ ⠿ ⭐ Testimonials       │                                           │
│   Items: 3 reviews ✏    │ ┌────────────────────────────────────────┐│
│                          │ │ "Our story..." paragraph text          ││
│ [+ Add section ▾]       │ └────────────────────────────────────────┘│
│                          │                                           │
│ ── Page Settings ──      │ ┌────────────────────────────────────────┐│
│ SEO Title: [Summer...]   │ │ ⭐ "Amazing products!" — @user1       ││
│ SEO Desc: [Shop our...]  │ │ ⭐ "Love this serum!" — @user2        ││
│ Theme: [Modern ▾]       │ │ ⭐ "Best skincare!" — @user3           ││
│ Primary: [🎨 #coral]    │ └────────────────────────────────────────┘│
│ Font: [Inter ▾]         │                                           │
│ Corners: [Rounded ▾]    │ ── Mobile Preview Toggle ──               │
│ Favicon: [📷 Upload]    │ [🖥 Desktop] [📱 Mobile]                 │
└──────────────────────────┴───────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
StorePages (two views)
│
├── StoreListPage (/store)
│   ├── AppShell (shared)
│   ├── PageHeader ("🏪 Store Pages" + count + "+" button)
│   └── PageCardList
│       └── PageCard[]
│           ├── Thumbnail (page screenshot or placeholder)
│           ├── PageName + StatusBadge (🟢 Published / 📋 Draft)
│           ├── PublicURL (copyable)
│           ├── PageMeta (product count, last edited)
│           ├── PerformanceMetrics (views, orders, CVR)
│           └── ActionBar (Editor, Preview, Analytics, Share, Menu)
│
└── StoreEditorPage (/store/[id]/edit)
    ├── AppShell (shared)
    ├── EditorHeader
    │   ├── BackLink ("← Store")
    │   ├── PageName (editable inline)
    │   ├── AutoSaveIndicator ("💾 Auto-saved" / "Saving...")
    │   ├── PreviewButton ("👁" → opens public URL)
    │   └── PublishButton ("🚀 Publish" — primary CTA)
    ├── SplitPaneLayout (resizable 30/70 split)
    │   ├── SectionPanel (left — 30%)
    │   │   ├── SectionList (drag-sortable)
    │   │   │   └── SectionEditor[] (per section type)
    │   │   │       ├── DragHandle ("⠿")
    │   │   │       ├── SectionTypeIcon + Label
    │   │   │       ├── SectionConfig (type-specific form fields)
    │   │   │       ├── CollapseToggle
    │   │   │       └── DeleteButton ("🗑")
    │   │   ├── AddSectionButton ("+ Add section" → dropdown)
    │   │   │   └── SectionTypeOption[] (Hero, Products, About, Testimonials, etc.)
    │   │   └── PageSettingsPanel
    │   │       ├── SEOTitleInput
    │   │       ├── SEODescriptionInput
    │   │       ├── ThemeSelector (Modern / Minimal / Bold / Classic)
    │   │       ├── PrimaryColorPicker
    │   │       ├── SecondaryColorPicker
    │   │       ├── FontSelector (Inter / Roboto / Playfair / etc.)
    │   │       ├── CornerRadiusSelector (Rounded / Sharp / Pill)
    │   │       └── FaviconUpload
    │   └── LivePreviewPane (right — 70%)
    │       ├── PreviewFrame (iframe rendering page in real-time)
    │       ├── DeviceToggle ([🖥 Desktop] [📱 Mobile])
    │       └── PreviewRefreshButton
    └── UnsavedChangesGuard (auto-save, but confirm on publish)
```

### Section Type Configs
| Section Type | Config Fields |
|---|---|
| 🖼 Hero Banner | Image upload, title, subtitle, CTA text, CTA link, overlay opacity |
| 🛍 Featured Products | Product multi-select, layout (grid 2/3/4), show price, show stock, show ratings |
| 📝 About Us | Rich text editor (markdown preview), optional side image |
| ⭐ Testimonials | Review items (author, text, rating, avatar), max 6 |
| 🖼 Gallery | Image uploads (max 12), layout (grid/masonry/slider), lightbox toggle |
| 🎬 Video | Video URL (YouTube/TikTok embed), autoplay toggle, aspect ratio |
| ❓ FAQ | Q&A pairs (accordion), max 20 items |
| 🔧 Custom HTML | Code editor (HTML/CSS), preview sandbox, Pro+ only |

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Page list | `store_pages` | `StoreService/ListPages(workspace_id)` | Cards with thumbnails | 5m |
| Page data (editor) | `store_pages` + `store_sections` | `StoreService/GetPage(page_id)` | Editor form + preview | No cache |
| Sections | `store_sections` ordered by `sort_order` | Included in page data | Section editor list | — |
| Products (selector) | `products` WHERE active | `ProductService/List(workspace_id)` | Search + checkbox list | 5m |
| Page views | `page_analytics.views` | `StoreService/GetPageStats(page_id)` | Integer ("1,234") | 15m |
| Page orders | `orders WHERE source = 'store_page' AND page_id` | Same above | Integer ("45") | 15m |
| CVR | Orders / Views × 100 | Computed | Percentage ("3.6%") | — |
| Themes | `store_themes` (static catalog) | `StoreService/GetThemes()` | Dropdown with previews | 1h |
| Auto-save state | Client-side diff | — | "💾 Saved" / "Saving..." / "Unsaved" | — |
| Public URL | `store_pages.slug` | — | "creativanta.link/shop/{slug}" | — |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Create page | "+ Tạo page mới" | `StoreService/CreatePage(data)` | New `store_pages` (draft) | Navigate → `/store/[new_id]/edit` | `store:manage` |
| 2 | Open editor | "✏ Editor" | — | — | Navigate → `/store/[id]/edit` | `store:manage` |
| 3 | Preview page | "👁 Preview" | — | — | Open public URL in new tab | `store:manage` |
| 4 | Publish page | "🚀 Publish" | `StoreService/Publish(id)` | `status = 'published'`, deploy to CDN | Confirmation → Toast "✅ Store page live!" + copy URL | `store:manage` |
| 5 | Unpublish | "⋮" → "Gỡ xuống" | `StoreService/Unpublish(id)` | `status = 'draft'`, CDN removed | Badge → 📋. Toast "Page đã gỡ xuống" | `store:manage` |
| 6 | Auto-save | Every 5s if dirty | `StoreService/UpdatePage(id, sections)` | Sections updated | "💾 Saved" indicator animates | `store:manage` |
| 7 | Add section | "+ Add section" → select type | Client-side | — | New section editor appears at bottom | `store:manage` |
| 8 | Delete section | Section "🗑" button | Client-side + auto-save | Section removed | Section removed with animation. Undo toast (5s). | `store:manage` |
| 9 | Reorder sections | Drag-sort | Client-side + auto-save | `sort_order` updated | Sections reorder in panel + preview updates | `store:manage` |
| 10 | Change theme | Theme selector | Client-side + auto-save | `theme_id` updated | Live preview reflects new theme instantly | `store:manage` |
| 11 | Change colors | Color picker | Client-side + auto-save | `primary_color` / `secondary_color` | Live preview updates colors instantly | `store:manage` |
| 12 | Upload image | Image upload in section | `UploadService/Upload(file)` | `asset_url` stored | Image appears in section and preview | `store:manage` |
| 13 | Select products | Product selector in Product section | Client-side | — | Selected products appear in preview grid | `store:manage` |
| 14 | Share URL | "📤 Share" | — (clipboard) | — | Toast "📋 Đã copy link store" | Any |
| 15 | View analytics | "📊 Analytics" | — | — | Navigate → `/store/[id]/analytics` | `store:manage` |
| 16 | Duplicate page | "📋 Duplicate" | `StoreService/DuplicatePage(id)` | New draft page | Toast "📋 Page đã nhân bản" → new card | `store:manage` |
| 17 | Delete page | "🗑 Delete" → confirm | `StoreService/DeletePage(id)` | Soft delete | Confirmation → card removed | `store:manage` |
| 18 | Toggle preview device | "[🖥] [📱]" toggle | Client-side iframe resize | — | Preview switches between desktop/mobile viewport | `store:manage` |

---

## 7. Validation Rules

### Page Settings
| Field | Rule | Error |
|---|---|---|
| Page name | Required, 3-100 chars | "Tên page 3-100 ký tự" |
| Slug | Required, 3-50 chars, alphanumeric + hyphen, unique | "Slug 3-50 ký tự. Slug đã tồn tại." |
| SEO title | Optional, max 60 chars | "Tiêu đề SEO tối đa 60 ký tự" |
| SEO description | Optional, max 160 chars | "Mô tả SEO tối đa 160 ký tự" |

### Section Content
| Section | Rule | Error |
|---|---|---|
| Hero image | Max 5MB, JPG/PNG/WebP | "Ảnh tối đa 5MB (JPG, PNG, WebP)" |
| Featured Products | 1-12 products selected | "Chọn 1-12 sản phẩm" |
| Testimonials | 1-6 items, each with text + author | "Cần ít nhất tên và đánh giá" |
| Gallery images | 1-12 images, max 5MB each | "Tối đa 12 ảnh, mỗi ảnh ≤ 5MB" |
| FAQ items | 1-20, each with question + answer | "Cần câu hỏi và trả lời" |
| Custom HTML | Max 50KB, no `<script>` (sandboxed) | "HTML tối đa 50KB, không hỗ trợ script" |

### Publish Guard
| Check | Error |
|---|---|
| At least 1 section | "Thêm ít nhất 1 section trước khi publish" |
| Hero or Product section exists | "Cần có ít nhất hero banner hoặc sản phẩm" |
| All images uploaded | "Có ảnh chưa tải xong" |

---

## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LIST_LOADING | List page loading | Card skeletons | Wait |
| LIST_LOADED | Cards displayed | Page cards with metrics | Select page |
| LIST_EMPTY | No store pages | Illustration: "Tạo store page đầu tiên! [+ Tạo page mới]" | Create |
| EDITOR_LOADING | Editor loading page data | Split pane skeleton | Wait |
| EDITOR_LOADED | Page data loaded | Section panel + live preview | Edit |
| EDITING | User making changes | "Unsaved" indicator | Continue |
| AUTO_SAVING | Auto-save in progress | "💾 Saving..." indicator | Continue editing |
| SAVED | Auto-save completed | "💾 Saved" (fades after 2s) | Continue |
| PREVIEWING_MOBILE | Mobile preview toggle | Preview iframe at 375px width | Toggle back |
| PUBLISHING | Publish in progress | Button spinner + "Đang publish..." | Wait |
| PUBLISHED | Just published | Toast + "✅ Live!" + copy URL | Share |
| UPLOADING_IMAGE | Image being uploaded | Section image shows upload progress | Wait |
| ERROR | Save/load failed | Toast with retry | Retry |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View store pages | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| View analytics | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Create/edit pages | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Publish/unpublish | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Delete pages | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Custom HTML section | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Theme customization | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

---

## 10. Navigation Map

```
Store Pages (/store)
├── → /store/new                        (Create page)
├── → /store/[id]/edit                  (Editor)
├── → /store/[id]/analytics             (Analytics)
├── → creativanta.link/shop/{slug}      (Preview — external)
├── → /products/[id]                    (Product click in editor)
├── ← /                                 (Sidebar nav)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Auto-save failed | Network error during save | "⚠️ Không lưu được. Thử lại trong 10s..." + auto-retry | Auto-retry 3x |
| Image upload failed | File too large or server error | Section: "❌ Tải ảnh lỗi. [Thử lại]" | Retry upload |
| Publish failed | CDN deployment error | Toast: "❌ Publish lỗi. Thử lại." | Retry |
| Slug conflict | Slug taken on publish | Inline: "Slug đã tồn tại. Chọn slug khác." | Change slug |
| Template load failed | Theme assets missing | Preview shows fallback theme | Select different theme |
| Products unavailable | Selected products deleted/archived | Warning in section: "⚠️ 2 sản phẩm không còn khả dụng" | Remove or replace |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Section list | `role="listbox"`, drag handles `aria-roledescription="sortable"` |
| Live preview | `<iframe title="Live preview of store page">`, not focusable for keyboard users |
| Theme selector | `aria-label="Chọn giao diện"` with visual preview descriptions |
| Color picker | `aria-label="Chọn màu chính"` with hex value announced |
| Image uploads | `aria-label="Tải ảnh hero banner"` with progress announcement |
| Publish button | `aria-label="Xuất bản store page — page sẽ public"` |
| Auto-save indicator | `role="status"`, `aria-live="polite"` |
| Device toggle | `role="radiogroup"`, `aria-label="Chế độ xem trước"` |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| List mount | 0ms | App Shell + card skeletons |
| List data | 200-500ms | Cards populate with stagger |
| Editor mount | 0ms | Split pane layout skeleton |
| Editor data | 300-600ms | Sections populate left. Preview iframe loads right. |
| Preview render | 500-1000ms | iframe renders page with sections |
| Image upload | 1-5s | Progress bar in section config |
| Theme switch | 200-500ms | Preview refreshes with new theme |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Editor LCP | < 2.0s (preview pane visible) |
| Preview update | < 500ms after edit (debounced) |
| Auto-save | < 300ms round-trip |
| Image upload | Progress within 1s, complete < 5s |
| Section drag | 60fps during drag |
| CDN publish | < 5s deployment |
| Page load (public) | < 2s LCP (published page) |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Auto-save | Debounced 5s after edit | On change |
| Preview | Debounced 500ms | On section edit |
| Page analytics | Polling | Every 15 minutes (list view) |
| Collaborative editing | Not supported (single editor lock) | — |

---

## 16. Localization Notes

- Editor UI: Vietnamese
- Store page content: Creator-authored (any language)
- Dates: `dd/MM/yyyy`
- Default CTA: "Mua ngay" (editable)
- Section names: Vietnamese ("Sản phẩm nổi bật", "Đánh giá khách hàng")

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `store.list.viewed` | List page load | `page_count`, `published_count` |
| `store.page.created` | New page created | `page_id` |
| `store.editor.opened` | Editor loaded | `page_id`, `section_count`, `status` |
| `store.section.added` | Section added | `section_type`, `position` |
| `store.section.deleted` | Section removed | `section_type`, `position` |
| `store.section.reordered` | Drag-sort | `section_type`, `from_position`, `to_position` |
| `store.theme.changed` | Theme selector | `old_theme`, `new_theme` |
| `store.page.published` | Publish action | `page_id`, `section_count`, `product_count` |
| `store.page.shared` | URL copied | `page_id` |
| `store.preview.toggled` | Device toggle | `device` (desktop/mobile) |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-surface-primary` | Editor panel background |
| `--color-surface-elevated` | Section config cards, page cards |
| `--color-accent` | Publish button, save indicator |
| `--color-success` | 🟢 Published badge, "Saved" indicator |
| `--color-border-drag` | Drag handle active state |
| `--color-preview-bg` | Preview pane background (neutral grey) |
| `--font-mono` | Slug display, Custom HTML editor |
| `--spacing-panel-gap` | Section config vertical gap (12px) |
| `--radius-card` | Section config panels (8px) |
| `--shadow-drag` | Shadow during section drag |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Route (list)**: `src/routes/(app)/store/+page.svelte`
- **Route (editor)**: `src/routes/(app)/store/[id]/edit/+page.svelte`
- **Preview**: `<iframe>` renders `creativanta.link/shop/{slug}?preview=true` with auth token
- **Drag-sort**: `@dnd-kit/sortable` or `svelte-dnd-action`
- **Rich text**: `tiptap` editor for About Us section
- **Auto-save**: Debounced with `$effect` tracking form state changes
- **Theme system**: CSS custom properties applied via `<style>` injection in preview iframe
- **Image upload**: Direct to S3 via presigned URL, thumbnail generated server-side
- **Custom HTML**: Sandboxed `<iframe>` with CSP restrictions

### Data Architecture
```
store_pages:
  id, workspace_id, name, slug, status, theme_id,
  primary_color, secondary_color, font_family, corner_radius,
  seo_title, seo_description, favicon_url,
  published_at, created_at, updated_at

store_sections:
  id, page_id, type, sort_order, config (JSONB), created_at

// config examples:
{ type: "hero", image_url: "...", title: "...", cta_text: "...", cta_link: "..." }
{ type: "products", product_ids: [...], layout: "grid_3", show_price: true }
{ type: "testimonials", items: [{ author: "...", text: "...", rating: 5 }] }
```

---

## 20. Related Screens & Revision History

### Related Screens
| Screen | Relationship |
|---|---|
| [W061] Product Detail | Products selected in store sections |
| [W070] Affiliate Manager | Store pages as link-in-bio items |
| [W067] Offer Detail | Offers can be displayed on store pages |
| [M026] Mobile Commerce Dashboard | Mobile equivalent (view only) |

### Revision History
| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Full 20-point rewrite. Added: real APIs (StoreService), complete visual editor spec (8 section types with config), split-pane layout, auto-save mechanism, theme customization, SEO settings, 18 actions, 13 states, CDN publish flow, image upload pipeline, Custom HTML sandboxing, and comprehensive drag-sort accessibility. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C) | System |
