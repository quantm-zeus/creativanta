# Screen: Web — Product Showcase Mode

> **Screen ID**: W29
> **Module**: M07 — AI Studio
> **Route**: `/studio/product-showcase`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 04, Product Freeze §15, A1 Schema (assets, products)

---

## 1. Purpose & Context

AI-generated product showcase videos from product images + description. Creates professional product demos, unboxing simulations, and feature highlights with AI voice-over and music.

### User Story
> As a seller-creator, I want to create professional product videos from just my product photos without filming.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Studio   🛍️ Product Showcase                   Credits: ~15      │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Product Selection ────────────────────────────────────────────┐  │
│ │ [🛍 Chọn sản phẩm từ catalog ▾] or [📸 Upload ảnh riêng]    │  │
│ │ Selected: Serum Vitamin C 30ml · 299K · [4 images loaded]      │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Style Selection ──────────────────────────────────────────────┐  │
│ │ [🎯 Demo style] [🎁 Unboxing] [📝 Feature highlight]         │  │
│ │ [🔮 Before/After] [📐 360° View] [🎬 Lifestyle]              │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Configuration ────────────────────────────────────────────────┐  │
│ │ Duration: [30s ▾]   Platform: [☑ TikTok] [☑ Reels]           │  │
│ │ Background: [Studio white ▾] [Lifestyle ▾] [Custom ▾]        │  │
│ │ Voice-over: [🎭 Mila ▾] Script: [Auto from description ▾]    │  │
│ │ Music: [🎵 Auto-match ▾]   Text overlay: [☑ Show price]      │  │
│ │ CTA: [Shop link ▾]                                            │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ [▶ Preview — free] [🚀 Generate — 15 credits]                      │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
ProductShowcasePage
├── AppShell (shared)
├── PageHeader
├── ProductSelector (catalog dropdown or manual upload)
├── StyleGrid (6 showcase styles, selectable)
├── ConfigurationForm
│   ├── DurationSelector
│   ├── PlatformCheckboxes
│   ├── BackgroundSelector (studio/lifestyle/custom)
│   ├── VoiceOverSelector (character + script source)
│   ├── MusicSelector
│   ├── TextOverlayOptions (price, name, features)
│   └── CTASelector
└── ActionBar (Preview, Generate)
```

---

## 4-5. Data & Actions

| # | Action | Trigger | API | Credits | Result |
|---|---|---|---|---|---|
| 1 | Select product | Dropdown | `ProductService/Get(id)` | 0 | Product loaded |
| 2 | Upload images | File picker | Upload to R2 | 0 | Images available |
| 3 | Select style | Click style card | — (client) | 0 | Style selected |
| 4 | Preview | ▶ Preview | Client mock | 0 | Preview modal |
| 5 | Generate | 🚀 | `AssetService/Generate(type=product_showcase)` | ~15 | → Queue |

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| EMPTY | No product selected | Product selector + "Chọn sản phẩm để bắt đầu" |
| CONFIGURED | Product + style selected | Settings form + estimated credits |
| PREVIEWING | Preview requested | Preview modal with mock animation |
| GENERATING | Job submitted | SSE progress: "Đang tạo showcase... 45%" |
| COMPLETE | Video ready | "✅ Video showcase sẵn sàng!" → Queue link |

---

## 7. Edge Cases

| Edge Case | Handling |
|---|---|
| Product has < 2 images | Warning: "Nên có ít nhất 4 ảnh cho showcase tốt nhất. [Upload thêm]" |
| Product has no description | Auto-script disabled: "Nhập script thủ công" |
| 360° view with only 2 images | Style disabled: "Cần 8+ ảnh cho chế độ 360°" |
| Product price = 0 / not set | "Show price" toggle hidden |
| Insufficient credits | CTA disabled: "Cần thêm {n} credits. [Mua credits]" |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" | Auto-retry online |
| Product fetch failed | Catalog error | Toast: "Không tải sản phẩm. [Thử lại] [Upload thủ công]" | Fallback |
| Image upload failed | File error | Toast: "Không upload được ảnh. [Thử lại]" | Retry |
| Generation failed | AI error | Banner: "Lỗi tạo video. Credits không bị trừ. [Thử lại]" | Retry |
| Auto-script failed | AI error | Toast: "Không tạo script tự động. [Nhập thủ công]" | Manual |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Style grid | `role="radiogroup"`, `aria-label="Chọn phong cách showcase"` |
| Style cards | `role="radio"`, `aria-checked`, `aria-label="{style_name}: {description}"` |
| Product selector | `aria-haspopup="listbox"`, `aria-label="Chọn sản phẩm"` |
| Config form | `role="region"`, `aria-label="Cài đặt video"` |
| Credit display | `aria-live="polite"` — updates with options |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Product selector + style grid |
| Product load | 200-400ms | Product info populates |
| Product images | 300-500ms | Images load in selector |
| Preview | 2-5s | Preview modal spinner |
| Generation | 30s-3min | SSE progress bar |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `showcase.opened` | Page load | `source` |
| `showcase.product_selected` | Product chosen | `product_id`, `image_count` |
| `showcase.style_selected` | Style clicked | `style` (demo/unboxing/etc.) |
| `showcase.previewed` | Preview clicked | `product_id`, `style` |
| `showcase.started` | Generate clicked | `product_id`, `style`, `platform`, `credits` |
| `showcase.completed` | SSE complete | `duration`, `total_time` |
| `showcase.failed` | Error | `error_type` |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/studio/product-showcase/+page.svelte`
- **Server load**: `+page.server.ts` → fetch user products (for selector)
- **Product integration**: `ProductService/Get(id)` → images, description, price
- **Auto-script**: `AIService/GenerateScript(product, style)` → editable text
- **Generate**: `AssetService/Generate(type=product_showcase)` → SSE
- **Image upload**: R2 for custom images (not in catalog)

---

## 13. Localization Notes

- Styles: "🎯 Demo", "🎁 Mở hộp", "📝 Tính năng", "🔮 Trước/Sau", "📐 360°", "🎬 Lifestyle"
- Product: "Chọn sản phẩm từ catalog", "Upload ảnh riêng"
- Config: "Thời lượng", "Nền tảng", "Phông nền", "Giọng đọc", "Nhạc nền"
- CTA: "Hiện link mua hàng", "Hiện giá"
- Progress: "Đang tạo showcase... 45%"

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-studio-showcase` | Showcase mode accent (amber) |
| `--color-style-demo` | Demo style card |
| `--color-style-unboxing` | Unboxing style card |
| `--color-style-feature` | Feature highlight card |
| `--color-style-selected` | Selected style border |
| `--color-credit-warning` | Low credit warning |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Cards |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W024] AI Studio Launcher | Parent |
| [W056] Product Detail | Product source |
| [W038] Studio Queue | Job tracking |
| [W039] Asset Library | Output storage |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Added 5 states, 5 edge cases (image count, 360° req), 5 errors, style grid accessibility, SSE progress, 7 analytics, SvelteKit impl (catalog integration), 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
