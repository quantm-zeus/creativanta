# Screen: Web — Finance: Cost Detail

> **Screen ID**: W083
> **Module**: M19 — Operating Ledger (Costs)
> **Route**: `/finance/costs`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 06 §Finance, PRD §33 Profit OS, A1 Schema (cost_entries, billing_events), B5 RBAC §2.8

---

## 1. Purpose & Context

Cost breakdown by category — platform fees, AI credits, advertising, shipping, COGS, and custom costs. Period trends with optimization hints from the AI Copilot. This is the cost truth layer: every cost is categorized, source-attributed, and deducted from revenue in Profit OS.

### User Goals
- Understand total costs and where money goes (fees, ads, AI, shipping, goods)
- Compare cost trends across periods
- Add custom/manual cost entries for complete profit picture
- Get AI-generated optimization hints to reduce costs

### Business Goals
- Enable accurate profit calculation (Revenue - Costs = Profit per PRD §33)
- Identify cost optimization opportunities automatically
- Track cost-to-revenue ratio for financial health monitoring
- Support tax deduction documentation with exportable cost data

### Entry Points
- Finance Dashboard (W081): "📉 Chi phí" card
- Sidebar: Finance → "📉 Chi phí"
- Copilot: "Chi phí AI tháng này bao nhiêu?"

### Exit Points
- Click category row → drill into that category's items
- "+ Thêm chi phí" → Add custom cost modal
- "← Finance" → Finance Dashboard
- Export → CSV/PDF download

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `profit:read` or `profit:read` permission (Owner, Admin, Manager)

### Postconditions
- Custom cost entries are saved to `cost_entries` table
- All cost changes update Profit Dashboard (W081) in real-time

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Finance   📉 Chi phí chi tiết       [Period: 30d ▾] [+ Thêm]    │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Cost Summary ────────────────────────────────────────────────┐   │
│ │ 💸 Tổng chi phí: 16,500,000 VND · ↓5% vs kỳ trước 🟢       │   │
│ │ Cost/Revenue ratio: 36.7% (target: < 40%)                     │   │
│ │                                                                │   │
│ │ [Stacked bar chart: cost categories over period]               │   │
│ │ [████ Platform fees 52%] [████ Ads 25%] [██ AI 13%] [█ Ship 10%]│  │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Category Breakdown ──────────────────────────────────────────┐   │
│ │ Category        │ Amount  │ % Total │ Trend  │ Source        │   │
│ │ ─────────────── ──────── ──────── ─────── ─────────────── │      │
│ │ 📊 Platform fees│ 8.5M   │ 52%    │ ↑8%   │ [🟢 Official] │   │
│ │   ├ TikTok comm │ 5.2M   │ 32%    │ ↑10%  │ [🟢]          │   │
│ │   ├ Shopee comm  │ 2.1M   │ 13%    │ ↑5%   │ [🟢]          │   │
│ │   └ Payment fees │ 1.2M   │ 7%     │ ≈      │ [🟢]          │   │
│ │ 📢 Advertising  │ 4.2M   │ 25%    │ ↓15%  │ [🔵 Imported] │   │
│ │   ├ TikTok Ads  │ 2.8M   │ 17%    │ ↓20%  │ [🔵]          │   │
│ │   └ FB/IG Ads   │ 1.4M   │ 8%     │ ↑5%   │ [🔵]          │   │
│ │ 🤖 AI Credits   │ 2.1M   │ 13%    │ ↑20%  │ [🟢 Official] │   │
│ │   ├ Text gen    │ 1.2M   │ 7%     │ ↑25%  │ [🟢]          │   │
│ │   └ Image/video │ 0.9M   │ 6%     │ ↑10%  │ [🟢]          │   │
│ │ 🚚 Shipping     │ 1.7M   │ 10%    │ ≈      │ [🟢 Official] │   │
│ │ 📦 COGS         │ 0.0    │ 0%     │ —      │ [🔵 Imported] │   │
│ │   ⚠️ "Chưa nhập giá vốn sản phẩm"  [+ Cập nhật →]            │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Custom Costs ────────────────────────────────────────────────┐   │
│ │ Date      │ Description        │ Amount    │ Category  │ [⋮] │   │
│ │ 25/3     │ Thuê studio quay   │ 500,000đ │ Production│ ✏🗑 │   │
│ │ 20/3     │ Sample gửi KOL     │ 300,000đ │ Marketing │ ✏🗑 │   │
│ │ [+ Thêm chi phí thủ công]                                     │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ AI Optimization Hints ──────────────────────────────────────┐    │
│ │ 💡 "AI credit usage ↑20% — cân nhắc upgrade plan để giảm    │    │
│ │    đơn giá, tiết kiệm ~400K/tháng" [→ AI Settings]          │    │
│ │ 💡 "Ad ROAS trên Shopee ↓ từ 5.2x → 3.1x — review ad       │    │
│ │    targeting hoặc tạm pause" [→ Campaign Manager]             │    │
│ │ 💡 "Chưa nhập COGS — margin bị tính thiếu. Cập nhật giá     │    │
│ │    vốn để có profit chính xác" [→ Product Settings]           │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ [📤 Export CSV] [📄 Export Tax Report]                               │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
CostDetailPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Finance")
│   ├── PageTitle ("📉 Chi phí chi tiết")
│   ├── PeriodSelector
│   └── AddCostButton ("+ Thêm chi phí", primary CTA)
├── CostSummaryCard
│   ├── TotalCost (animated counter)
│   ├── PeriodComparison (↑↓ vs previous)
│   ├── CostRevenueRatio (with health indicator: 🟢 < 40%, 🟡 40-60%, 🔴 > 60%)
│   └── StackedBarChart
│       └── CategorySegment[] (platform fees, ads, AI, shipping, COGS, custom)
├── CategoryBreakdownTable
│   ├── CategoryRow[] (expandable with sub-categories)
│   │   ├── CategoryIcon + Name
│   │   ├── Amount (formatted VND)
│   │   ├── PercentOfTotal
│   │   ├── TrendIndicator (↑↓≈ + %)
│   │   ├── TrustBadge (S009)
│   │   └── SubCategoryRows[] (expandable)
│   └── TotalRow
├── CustomCostsSection
│   ├── CustomCostTable
│   │   └── CustomCostRow[]
│   │       ├── Date
│   │       ├── Description
│   │       ├── Amount
│   │       ├── Category
│   │       ├── EditButton
│   │       └── DeleteButton
│   └── AddCustomCostButton
├── AIOptimizationHints
│   └── HintCard[]
│       ├── HintIcon (💡)
│       ├── HintText
│       └── ActionLink
├── ExportButtons
│   ├── ExportCSV
│   └── ExportTaxReport
└── AddCostModal
    ├── DatePicker (required)
    ├── DescriptionInput (required, 3-200 chars)
    ├── AmountInput (required, > 0)
    ├── CategorySelector (Production, Marketing, Equipment, Freelancer, Other)
    ├── ReceiptUpload (optional — photo/PDF)
    ├── NotesInput (optional)
    └── SaveButton
```

---

## 5. Displayed Data

| Field | Source | Format | Source Class |
|---|---|---|---|
| Total costs | `SUM(billing_events WHERE type IN cost_types)` | VND "16.5M" | Mixed |
| Platform fees | `SUM(orders.platform_fee + platform_commission)` | VND | Official |
| Advertising | `SUM(ad_spend)` or manual import | VND | Imported |
| AI credits | `SUM(ai_usage.cost)` | VND | Official |
| Shipping | `SUM(orders.shipping_fee WHERE paid_by=seller)` | VND | Official |
| COGS | `SUM(products.cogs × order_items.quantity)` | VND | Imported |
| Custom costs | `cost_entries WHERE type=custom` | VND | Imported |
| Cost/Revenue ratio | Computed: total costs / total revenue × 100 | "36.7%" | Computed |
| Optimization hints | AI-generated based on trend analysis | Text + action | AI |

---

## 6. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Add custom cost | "+ Thêm" → modal | `CostService/Create` | New row in custom costs table, toast | `cost:manage` |
| 2 | Edit custom cost | "✏" on row | `CostService/Update` | Updated in table | `cost:manage` |
| 3 | Delete custom cost | "🗑" → confirm | `CostService/Delete` | Removed, profit recalculated | `cost:manage` |
| 4 | Expand category | Click category row | — (client-side) | Sub-categories expand | `profit:read` |
| 5 | Change period | Period selector | Refetch | All data updates | `profit:read` |
| 6 | Export CSV | "📤 Export" | Client-side | CSV download | `profit:read` |
| 7 | Export Tax Report | "📄 Tax Report" | Server-side PDF | PDF with receipts | `profit:read` |
| 8 | Follow hint | Click hint action link | — | Navigate to suggested screen | `profit:read` |
| 9 | Upload receipt | In add/edit modal | File upload | Receipt attached to cost entry | `cost:manage` |

---

## 7. Validation Rules (Add/Edit Custom Cost)

| Field | Rule | Error |
|---|---|---|
| Date | Required, not future | "Ngày không thể trong tương lai" |
| Description | Required, 3-200 chars | "Mô tả phải từ 3-200 ký tự" |
| Amount | Required, > 0, max 999,999,999 | "Số tiền phải lớn hơn 0" |
| Category | Required | "Vui lòng chọn danh mục" |
| Receipt | Optional, max 5MB, JPG/PNG/PDF | "File tối đa 5MB, định dạng JPG, PNG hoặc PDF" |

---

## 8. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Summary shimmer, table skeletons |
| LOADED | Data received | Full cost breakdown |
| EMPTY | No costs in period | "Chưa có chi phí nào trong kỳ. Chi phí platform sẽ tự động cập nhật khi có đơn hàng." |
| ERROR | API failed | Error with retry |
| COGS_MISSING | Products exist but COGS not entered | Warning card: "⚠️ Giá vốn (COGS) chưa được nhập cho {count} sản phẩm. Profit sẽ bị tính thiếu." |

---

## 9. Permissions

| Feature | Owner | Admin | Manager | Editor |
|---|---|---|---|---|
| View costs | ✅ | ✅ | ✅ | ❌ |
| View AI hints | ✅ | ✅ | ✅ | ❌ |
| Add custom cost | ✅ | ✅ | ❌ | ❌ |
| Edit/delete cost | ✅ | ✅ | ❌ | ❌ |
| Export | ✅ | ✅ | ✅ | ❌ |
| Upload receipts | ✅ | ✅ | ❌ | ❌ |

---

## 10. Cost Categories (canonical)

| Category | Source | Automated? | Description |
|---|---|---|---|
| Platform fees | `orders` table | ✅ Auto | Commission, payment, service fees from platforms |
| Advertising | Ad platform API or manual | ⚠️ Semi | TikTok/Facebook ad spend — imported or manual |
| AI Credits | `ai_usage` table | ✅ Auto | Creativanta AI usage costs |
| Shipping | `orders` table | ✅ Auto | Seller-paid shipping costs |
| COGS | `products.cogs` × `order_items.quantity` | ⚠️ Semi | Cost of goods sold — requires user input |
| Custom | `cost_entries` table | ❌ Manual | Studio rent, equipment, freelancers, etc. |

---
## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| COGS missing for all products | Persistent warning: "⚠️ Giá vốn chưa nhập. Profit bị tính thiếu. [Cập nhật →]" |
| Cost/Revenue ratio > 60% | Red alert: "🔴 Chi phí chiếm {ratio}% doanh thu — vượt ngưỡng 60%!" |
| Duplicate receipt upload | Toast: "File này đã được đính kèm cho chi phí #{id}. Tiếp tục?" |
| Custom cost > 100M VND | Confirm dialog: "Số tiền lớn — xác nhận {amount}?" |
| Ad spend reimport overwrites | Dialog: "Dữ liệu quảng cáo {platform} đã tồn tại. Ghi đè?" |

---

## 12. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached data | Auto-retry online |
| Cost save fail | API error | Toast: "Không lưu được. [Thử lại]" | Retry |
| Receipt upload fail | S3 error / file too large | Toast: "Upload thất bại. Kiểm tra file (max 5MB)." | Retry |
| Aggregation timeout | ClickHouse slow | "Đang tính toán..." spinner | Auto-retry |
| Delete fail | Concurrent edit | Toast: "Không xóa được — chi phí đã thay đổi." | Reload |

---

## 13. Accessibility

| Element | Requirement |
|---|---|
| Category tree | `role="tree"`, expandable rows with `aria-expanded` |
| Cost ratio bar | `role="meter"`, `aria-valuenow`, `aria-label="Tỷ lệ chi phí/doanh thu: {ratio}%"` |
| Add cost modal | `role="dialog"`, `aria-modal="true"`, focus trap |
| Custom cost table | `role="table"`, action buttons with `aria-label="Sửa chi phí: {desc}"` |
| AI hints | `role="alert"`, not color-only |

---

## 14. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Summary shimmer + table skeleton |
| Cost summary | 200-400ms | Counter animates, ratio bar fills |
| Category table | 400-800ms | Rows stagger in |
| Custom costs | 500-800ms | Table populates |
| AI hints | 1-2s | Cards fade in |
| Modal | 0ms | Instant overlay |

---

## 15. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `finance_costs.viewed` | Page load | `period`, `total_costs`, `cost_ratio` |
| `finance_costs.period_changed` | Period selector | `from_period`, `to_period` |
| `finance_costs.category_expanded` | Category expand | `category` |
| `finance_costs.custom_cost_added` | Cost created | `amount`, `category` |
| `finance_costs.custom_cost_edited` | Cost updated | `cost_id`, `field_changed` |
| `finance_costs.custom_cost_deleted` | Cost deleted | `cost_id`, `amount` |
| `finance_costs.hint_followed` | AI hint CTA | `hint_type`, `target_route` |
| `finance_costs.exported` | Export | `format` |

---

## 16. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/finance/costs/+page.svelte`
- **Server load**: `+page.server.ts` → `CostService/GetBreakdown(period)` from ClickHouse
- **Category tree**: Expandable rows with Svelte `slide` transition
- **Add/Edit modal**: SvelteKit form action with progressive enhancement
- **Optimistic UI**: Custom cost add shows immediately, revert on server error
- **Receipt upload**: Direct S3 presigned URL upload, link stored in `cost_entries.receipt_url`
- **AI hints**: `CopilotService/GetCostOptimization(period)` — lazy loaded
- **COGS warning**: Persistent if `products WHERE cogs IS NULL` count > 0

---

## 17. Design Tokens

| Token | Usage |
|---|---|
| `--color-cost-platform` | Platform fees category |
| `--color-cost-ads` | Advertising category |
| `--color-cost-ai` | AI credits category |
| `--color-cost-shipping` | Shipping category |
| `--color-cost-cogs` | COGS category |
| `--color-cost-custom` | Custom costs category |
| `--color-ratio-healthy` | Cost ratio <40% (green) |
| `--color-ratio-danger` | Cost ratio >60% (red) |
| `--color-surface-elevated` | Cards |

---

## 18. Related Screens

| Screen | Relationship |
|---|---|
| [W081] Profit Dashboard | Parent finance overview |
| [W082] Revenue Detail | Revenue counterpart |
| [W084] Reconciliation | Verify cost data |
| [W120] AI Credits | AI credit usage detail |
| [M043] Mobile Costs | Mobile equivalent |

---

## 19. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (COGS missing, ratio alert), 5 errors, tree/modal a11y, 8 analytics, SvelteKit impl (optimistic UI, S3 receipt), 9 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
