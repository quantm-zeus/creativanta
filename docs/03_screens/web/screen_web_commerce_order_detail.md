# Screen: Web — Order Detail

> **Screen ID**: W063
> **Module**: M13 — Product Hub / Order Truth
> **Route**: `/orders/[id]`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 06 §Commerce, Product Freeze §22-23, A1 Schema (orders, order_items, refunds), B5 RBAC §2.7

---

## 1. Purpose & Context

Full order detail page showing order items, buyer information, price breakdown with platform fees, delivery timeline, content attribution, and profit calculation. This is where commerce data connects to the Profit OS proof chain — every fee and deduction is itemized and source-attributed.

### User Goals
- View complete order information including all items, fees, and deductions
- Track delivery status through timeline
- Understand true profit per order (not just revenue)
- Contact buyer or create follow-up tasks
- Process refund requests if needed

### Business Goals
- Enable accurate profit calculation per order (PRD §33 Profit OS)
- Attribute revenue to specific content pieces and affiliate links
- Maintain full order audit trail with source class transparency

### Entry Points
- Order List (W062): click order row or "→ Detail"
- Notification: "Order status changed" → deep link `/orders/[id]`
- Home Dashboard: order alert → specific order
- Copilot: "Chi tiết đơn hàng #TK-1234" → navigate here
- Inbox: order-related thread → "View order" link

### Exit Points
- "← Đơn hàng" → back to Order List (W062)
- "💬 Liên hệ người mua" → Inbox thread (W046)
- "📌 Tạo follow-up" → Follow-up task creation
- "🔄 Hoàn tiền" → Refund creation flow
- Content attribution link → Content detail or analytics
- Product link → Product Detail (W061)

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `order:read` permission (Owner, Admin, Manager)
- Order exists and belongs to current workspace
- Platform connector for order source is active (for real-time updates)

### Postconditions
- View event logged for audit trail
- Follow-up tasks created are linked to order
- Refund requests initiated are tracked in order timeline

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Đơn hàng   #TK-1234             [🟢 Đã giao] [📎 Export] [⋮]   │
├──────────────────────────────┬───────────────────────────────────────┤
│ Main Content (65%)           │ Side Panel (35%)                       │
│                              │                                        │
│ ┌─ Order Items ───────────┐ │ ┌─ Buyer Info ──────────────────────┐│
│ │ [📸] Serum VitC 30ml    │ │ │ [👤] Nguyễn Văn A                ││
│ │     SKU: SVT-C30 × 2   │ │ │ @nguyenvana · TikTok              ││
│ │     299,000đ × 2        │ │ │ Previous orders: 3 · Total: 2.4M ││
│ │ [📸] Toner AHA 150ml   │ │ │ Customer value: ★★★★☆            ││
│ │     SKU: TN-AHA × 1    │ │ │ [💬 Liên hệ] [📋 Copy info]     ││
│ │     149,000đ × 1        │ │ └──────────────────────────────────┘││
│ └──────────────────────────┘ │                                      │
│                              │ ┌─ Content Attribution ─────────────┐│
│ ┌─ Price Breakdown ────────┐│ │ 🎬 "5 tips nấu ăn" (TikTok)      ││
│ │ Tạm tính:     747,000đ ││ │ └ 12K views → 3 orders             ││
│ │ Giảm giá:     -74,700đ ││ │ 🔗 Affiliate link #AF-12           ││
│ │ Phí ship:     +30,000đ ││ │ └ Conv: 7.2%                       ││
│ │ ──────────────────────── ││ │ 🏷 Offer: "Giảm 10%"             ││
│ │ Tổng KH trả:  702,300đ ││ │ └ Code: SPRING10                   ││
│ │ ──────────────────────── ││ │ 📊 Campaign: Spring Sale 2026     ││
│ │ Phí sàn:      -56,184đ ││ │ [📊 Xem performance →]            ││
│ │ Hoa hồng:     -70,230đ ││ └──────────────────────────────────┘││
│ │ Phí thanh toán:-14,046đ ││                                      │
│ │ ──────────────────────── ││ ┌─ Actions ──────────────────────────┐│
│ │ Doanh thu thực: 561,840đ││ │ [💬 Liên hệ người mua]            ││
│ │ COGS:          -300,000đ ││ │ [📌 Tạo follow-up task]          ││
│ │ ──────────────────────── ││ │ [🔄 Yêu cầu hoàn tiền]          ││
│ │ Lợi nhuận:     261,840đ ││ │ [📎 Xuất hóa đơn PDF]            ││
│ │ Margin:         35.1%   ││ │ [📋 Copy order info]              ││
│ │ Source: [🟢 Official]   ││ └──────────────────────────────────┘││
│ └──────────────────────────┘│                                      │
│                              │ ┌─ Platform Info ───────────────────┐│
│ ┌─ Order Timeline ─────────┐│ │ Platform: 🎵 TikTok Shop          ││
│ │ 25/3 10:05 ⏳ Đặt hàng  ││ │ Seller: Shop ABC                  ││
│ │ 25/3 10:10 ✅ Xác nhận   ││ │ Sync: 🟢 2m ago                   ││
│ │ 25/3 14:00 📦 Đóng gói  ││ │ [🔄 Force sync]                   ││
│ │ 25/3 16:30 🚚 Vận chuyển ││ └──────────────────────────────────┘││
│ │ 27/3 09:30 🟢 Đã giao   ││                                      │
│ │ Carrier: Giao Hàng       ││                                      │
│ │ Tracking: GHN123456      ││                                      │
│ │ [📋 Copy tracking]       ││                                      │
│ └──────────────────────────┘│                                      │
└──────────────────────────────┴───────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
OrderDetailPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Đơn hàng")
│   ├── OrderNumber ("#TK-1234")
│   ├── StatusBadge (color-coded)
│   ├── ExportButton ("📎 Export")
│   └── MoreMenu (⋮ → Print, Copy link, Report issue)
├── SplitView
│   ├── MainPanel (65%)
│   │   ├── OrderItemsCard
│   │   │   └── OrderItem[]
│   │   │       ├── ProductImage (thumbnail)
│   │   │       ├── ProductName (link to product detail)
│   │   │       ├── SKU
│   │   │       ├── Quantity
│   │   │       ├── UnitPrice
│   │   │       └── LineTotal
│   │   ├── PriceBreakdownCard
│   │   │   ├── Subtotal
│   │   │   ├── DiscountLine (if applicable)
│   │   │   ├── ShippingLine
│   │   │   ├── Divider ("Tổng KH trả")
│   │   │   ├── PlatformFeeLine
│   │   │   ├── CommissionLine
│   │   │   ├── PaymentFeeLine
│   │   │   ├── Divider ("Doanh thu thực")
│   │   │   ├── COGSLine (if entered)
│   │   │   ├── ProfitLine (bold, highlighted)
│   │   │   ├── MarginPercentage
│   │   │   └── TrustBadge (S009 — source class of financial data)
│   │   └── OrderTimeline
│   │       └── TimelineStep[]
│   │           ├── Timestamp
│   │           ├── StatusIcon
│   │           ├── Description
│   │           └── SubInfo (carrier, tracking number)
│   └── SidePanel (35%)
│       ├── BuyerInfoCard
│       │   ├── Avatar
│       │   ├── BuyerName
│       │   ├── Username + Platform
│       │   ├── OrderHistory (count + total)
│       │   ├── CustomerValue (star rating)
│       │   └── ContactButton + CopyButton
│       ├── ContentAttributionCard
│       │   └── AttributionItem[]
│       │       ├── ContentIcon (video, link, offer, campaign)
│       │       ├── ContentTitle
│       │       ├── PerformanceSnippet
│       │       └── ViewLink
│       ├── ActionsCard
│       │   ├── ContactBuyerButton
│       │   ├── CreateFollowUpButton
│       │   ├── RequestRefundButton (conditional)
│       │   ├── ExportInvoiceButton
│       │   └── CopyInfoButton
│       └── PlatformInfoCard
│           ├── PlatformName + Icon
│           ├── SellerName
│           ├── SyncStatus + Timestamp
│           └── ForceSyncButton
```

---

## 5. Displayed Data

| Field | Source | Format | Source Class |
|---|---|---|---|
| Order number | `orders.platform_order_id` | "#TK-1234" | Official |
| Order status | `orders.status` | Color badge | Official |
| Items | `order_items[]` joined with `products` | Product card list | Official |
| Subtotal | `orders.subtotal` | VND format | Official |
| Discount | `orders.discount_amount` | "-74,700đ" | Official |
| Shipping | `orders.shipping_fee` | "+30,000đ" | Official |
| Platform fee | `orders.platform_fee` | "-56,184đ" | Official |
| Commission | `orders.platform_commission` | "-70,230đ" | Official |
| Payment fee | `orders.payment_fee` | "-14,046đ" | Official / Estimated |
| Net revenue | Computed: total - all fees | "561,840đ" | Computed |
| COGS | `products.cogs × quantity` (user-entered) | "-300,000đ" | Imported |
| Profit | Computed: net revenue - COGS | "261,840đ" | Computed |
| Margin | Computed: profit / revenue × 100 | "35.1%" | Computed |
| Buyer | `orders.buyer_name`, `orders.buyer_username` | Full display | Official |
| Buyer history | Aggregated orders by buyer | Count + total | Computed |
| Timeline | `order_events[]` | Timestamped stepper | Official |
| Tracking | `orders.tracking_number`, `orders.carrier` | Tracking # + carrier | Official |
| Attribution | `order_attribution[]` joined | Content + offer + campaign | Inferred |

---

## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Navigation | Permission |
|---|---|---|---|---|---|---|---|
| 1 | Contact buyer | "💬 Liên hệ" | Secondary | — | — | → `/inbox?entity=[buyer_id]` | `thread:reply` |
| 2 | Create follow-up | "📌 Tạo follow-up" | Secondary | `FollowUpTaskService/Create({entity_type: 'order', entity_id})` | Toast "Đã tạo task" | — | `follow_up:manage` |
| 3 | Request refund | "🔄 Hoàn tiền" | Workflow | — | Open refund creation modal | — (modal) | `order:manage` |
| 4 | Export invoice | "📎 Xuất hóa đơn" | Export | Client-side PDF gen | PDF download | — | `order:read` |
| 5 | Copy order info | "📋 Copy" | Utility | — (clipboard) | Structured text copied. Toast "Đã sao chép" | — | `order:read` |
| 6 | Force sync | "🔄 Force sync" | Sync | `ConnectorService/SyncOrder(id)` | Sync spinner → data refresh | — | `order:manage` |
| 7 | Copy tracking | "📋 Copy tracking" | Utility | — (clipboard) | Tracking number copied | — | `order:read` |
| 8 | View content | Click attribution item | Navigation | — | — | → Content detail page | `report:read` |
| 9 | View product | Click product name in items | Navigation | — | — | → `/products/[product_id]` | `product:read` |
| 10 | Print | ⋮ → "In đơn hàng" | Print | — | Browser print dialog | — | `order:read` |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Split view with skeletons for all sections |
| LOADED | Data received | Full order detail |
| NOT_FOUND | Order ID invalid or no access | "Đơn hàng không tồn tại hoặc bạn không có quyền xem" + back link |
| SYNCING | Force sync in progress | PlatformInfoCard shows spinner + "Đang đồng bộ..." |
| REFUND_PROCESSING | Refund submitted | Refund modal shows progress → timeline updates |
| ERROR | API failed | Error page with retry |
| CANCELLED | Order was cancelled | Greyed-out items + "❌ Đơn hàng đã bị hủy" banner at top |
| REFUNDED | Full refund issued | Red refund banner + adjusted price breakdown showing negative net |

---

## 8. Permissions & Role-based Behavior

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View order | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View price breakdown | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View profit/margin | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Contact buyer | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Create follow-up | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Request refund | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Force sync | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Export invoice | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |

### Manager restriction
- Manager can see revenue, fees, and net revenue but NOT profit/COGS/margin (these require `profit:read` per B5 §2.8)
- Profit section shows "Nâng cấp quyền để xem lợi nhuận" for Manager

---

## 9. Edge Cases

| Edge Case | Handling |
|---|---|
| COGS not entered for product | Profit section shows: "Chưa nhập giá vốn (COGS). [Cập nhật →]" with link to product |
| Platform fee not yet finalized | Fee line shows "~56,184đ (ước tính)" with Estimated trust badge |
| Order partially refunded | Show refund line in breakdown + "Hoàn trả: -149,000đ" with adjusted totals |
| No content attribution | Attribution card: "Chưa có dữ liệu content attribution cho đơn này" |
| Buyer info unavailable | Show "Ẩn danh" placeholder (some platforms anonymize buyer data) |
| Multiple delivery attempts | Timeline shows all attempts with different carriers |
| Cross-border order | Show additional customs/import duty lines in breakdown |

---

## 10. Trust & Proof Integration

Every financial line in the Price Breakdown has a source class indicator (S009):
- **Platform fees**: 🟢 Official (from platform API)
- **COGS**: 🔵 Imported (user-entered)
- **Shipping**: 🟢 Official or 🟡 Estimated (if carrier fee estimate)
- **Net revenue**: 🟢 Official (if all inputs are official)
- **Profit**: Mixed (depends on Official revenue + Imported COGS)
- **Attribution**: 🟣 Inferred (correlation-based, not guaranteed)

Clicking any source badge opens the "Why this number?" drawer (S009 §7).

---
## 11. SvelteKit Implementation Notes

### Route & Server Load
- **Route**: `src/routes/(app)/orders/[id]/+page.svelte`
- **Server load**: `+page.server.ts` → fetch order + items + events + attribution
- **SSR**: Server renders full order detail (financial data requires auth)
- **Real-time**: SSE on `/events/orders/[id]` for live status updates

### Data Fetching Strategy
```
+page.server.ts:
  Promise.all([
    orderService.get(id),
    orderService.getEvents(id),
    orderService.getAttribution(id),
    orderService.getPriceBreakdown(id)
  ])

Client-side:
  onForceSync(id) → connectorService.syncOrder(id)
  onRequestRefund(id) → open refund modal
```

### Financial Precision
- All VND calculations use integer arithmetic (no floating point)
- Commission rates stored as basis points (e.g., 1200 = 12.00%)
- Profit calculations happen server-side to prevent client-side rounding errors

---
## 12. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `order.detail.viewed` | Page load | `order_id`, `platform`, `status`, `total_amount` |
| `order.detail.refund_initiated` | Refund button clicked | `order_id`, `refund_type` |
| `order.detail.buyer_contacted` | Contact buyer clicked | `order_id`, `buyer_id` |
| `order.detail.exported` | Invoice exported | `order_id`, `format` |
| `order.detail.synced` | Force sync triggered | `order_id`, `platform` |
| `order.detail.attribution_viewed` | Click attribution item | `order_id`, `content_id` |
| `order.detail.trust_badge_clicked` | Source badge clicked | `order_id`, `field`, `source_class` |

---
## 13. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (order summary section) |
| TTI | < 2.0s |
| Price breakdown render | < 200ms |
| Attribution section | < 500ms (lazy-loaded) |
| Force sync response | < 5s |
| Invoice PDF generation | < 3s |

---
## 14. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — hiển thị dữ liệu cached (chỉ xem)" + cached order visible | Auto-retry when online |
| API error (5xx) | Server failure | Error page: "Không tải được chi tiết đơn hàng. [Thử lại]" | Retry button |
| Order not found | 404 / no access | "Đơn hàng không tồn tại hoặc bạn không có quyền xem. [← Quay lại danh sách]" | Back to list |
| Refund failed | Platform API rejection | Modal error: "Không gửi được yêu cầu hoàn tiền. {platform} từ chối. [Thử lại]" | Retry or contact support |
| Force sync failed | Connector issue | Toast: "Không đồng bộ được. Kiểm tra kết nối {platform}." | Retry later |
| Invoice export failed | PDF generation error | Toast: "Không xuất được hóa đơn. [Thử lại]" | Retry |
| Permission denied | 403 | "Không có quyền xem đơn hàng này" → navigate to order list | Contact admin |

---
## 15. Accessibility

| Element | Requirement |
|---|---|
| Financial data | `aria-label` includes full VND amount: "Tổng tiền: 935 nghìn đồng" |
| Status timeline | `role="list"` with `aria-label="Lịch sử trạng thái đơn hàng"` |
| Trust badges | `aria-label="Nguồn dữ liệu: Chính thức từ nền tảng"` |
| Action buttons | Descriptive labels: "Liên hệ người mua Nguyễn Văn A" |
| Price breakdown table | `role="table"` with proper headers |
| Tab navigation | Full keyboard support, Enter to expand sections |
| Profit section | Not announced if hidden due to permissions |

---
## 16. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | App Shell + split-view skeleton with shimmer |
| Order summary | 200-400ms | Left panel populates — status badge, buyer info |
| Price breakdown | 300-500ms | Financial rows animate in with stagger |
| Timeline | 300-500ms | Events populate top-to-bottom |
| Attribution | 500-800ms | Lazy-loaded section — placeholder → data |

---
## 17. Localization Notes

- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator: "935.000đ")
- Financial formatting: Full precision in breakdown (not abbreviated)
- Abbreviated only in header summary: "935K"
- Order ID: Platform-prefixed "#TK-1234"
- Date in timeline: "15/03/2026 14:30"
- Relative time: "2 giờ trước" for recent events
- Commission: "12% (56,184đ)"
- Negative amounts: Red text with minus sign "-149,000đ"
- Status: "Đã thanh toán", "Đang giao hàng", "Hoàn thành", "Đã hủy"

---
## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-order-status-*` | Per-status colors (see Order List W061 tokens) |
| `--color-trust-official` | Official source badge (🟢) |
| `--color-trust-imported` | Imported source badge (🔵) |
| `--color-trust-estimated` | Estimated source badge (🟡) |
| `--color-trust-inferred` | Inferred source badge (🟣) |
| `--color-profit-positive` | Positive profit/margin (green) |
| `--color-profit-negative` | Negative profit/loss (red) |
| `--color-accent` | Primary CTAs |
| `--color-surface-elevated` | Section cards |
| `--color-text-primary` | Financial amounts |
| `--color-text-secondary` | Labels, timestamps |

---
## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W062] Order List | Parent list |
| [W061] Product Detail | Product from order items |
| [W073] Refund Management | Refund processing |
| [W046] Unified Inbox | Buyer communication |
| [W081] Profit Dashboard | Profit aggregation |
| [W084] Reconciliation | Reconcile order revenue |
| [M027] Mobile Orders | Mobile equivalent |
| [S009] Trust Badge | Source class display on financial data |
| [S007] Confirmations | Refund confirmation |

---
## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A standardization**: Fixed section numbering (1-20 sequential). Removed duplicate §5 and generic boilerplate. Added SvelteKit Implementation Notes (with financial precision rules), 7 Analytics Events, Performance Requirements, screen-specific Error Handling (7 scenarios), Accessibility with financial aria-labels, Loading Behavior (5 stages), Localization with financial-specific formats, and Design Tokens with trust/profit colors. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
