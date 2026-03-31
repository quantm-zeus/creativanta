# Screen: Web — Inventory & Stock Management

> **Screen ID**: W-COMM-15
> **Module**: M13 — Product Hub / Inventory / Order Truth
> **Route**: `/commerce/inventory`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 02 §Backend Domain, Pack 06 §Commerce, A1 Schema (products, skus, inventory_locations, stock_movements), B5 RBAC §2.5

---

## 1. Purpose & Context

Centralized inventory management view for tracking stock levels across multiple locations and platforms. Essential for Seller Mode and Live Operator Mode users who need real-time stock visibility.

### User Story
> As a seller, I want to see my stock levels across all warehouses and platforms in one place so I can avoid overselling and plan restocking.

### Business Goal
- Prevent overselling and stock-out situations
- Enable proactive inventory management
- Maintain accurate stock truth across connected platforms

### When to Use
- Seller checking stock before live session
- Responding to low-stock alerts
- Planning product restocking
- Reconciling platform-reported vs. actual stock

### Entry Points
- Sidebar: Commerce → "📦 Tồn kho"
- Dashboard alert: "⚠️ 3 sản phẩm sắp hết hàng" → click
- Product detail → "Xem tồn kho" tab
- Quick Actions (⌘K): "inventory" / "tồn kho"

### Exit Points
- Click product → Product Detail (`/commerce/products/[id]`)
- Click "Tạo đơn nhập" → Stock Movement creation flow
- Click "Cài đặt cảnh báo" → Inventory Settings

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `inventory:read` permission
- At least 1 product exists in workspace
- Optional: Connected commerce platform for sync data

### Postconditions
- Stock levels displayed with freshness indicator
- Low-stock alerts visible for items below threshold
- Stock movement history accessible per SKU

---

## 3. Layout Structure

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + Full inventory table with filters sidebar |
| Tablet (768-1279px) | App Shell (collapsed) + Table with horizontal scroll |
| Mobile (≤767px) | Redirect to mobile app |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 📦 Tồn kho                    [🔍 Tìm sản phẩm] [⚙️ Cài đặt]     │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ ┌─ Summary Cards (full width) ────────────────────────────────────┐  │
│ │ 📦 Tổng SKUs    │  ⚠️ Sắp hết     │  ❌ Hết hàng  │  🔄 Synced  │  │
│ │ 1,247            │  23 (cần nhập)  │  5            │  30m ago    │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ Filters: [Trạng thái ▾] [Kho ▾] [Nền tảng ▾] [Danh mục ▾]         │
│                                                                       │
│ ┌─ Inventory Table ───────────────────────────────────────────────┐  │
│ │ ☐ │ Sản phẩm          │ SKU      │ Kho chính│ Shopee │ TikTok  │  │
│ │───│────────────────────│──────────│──────────│────────│─────────│  │
│ │ ☐ │ 🔴 Serum Vitamin C │ SVC-001  │ 5        │ 3      │ 8       │  │
│ │   │ ⚠️ Dưới ngưỡng 10                                          │  │
│ │ ☐ │ 🟢 Kem chống nắng  │ KCN-002  │ 150      │ 120    │ 200     │  │
│ │ ☐ │ 🟡 Son môi đỏ      │ SML-003  │ 12       │ 8      │ 15      │  │
│ │   │ ⚠️ Gần ngưỡng cảnh báo                                    │  │
│ │ ☐ │ ❌ Phấn phủ limited │ PPL-004  │ 0        │ 0      │ 0       │  │
│ │   │ ❌ Hết hàng toàn bộ                                        │  │
│ │                                                                  │  │
│ │ [← 1 2 3 ... 12 →]                                              │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ Bulk: [☑ 2 selected] [📥 Nhập hàng] [🏷 Gán nhãn] [📊 Xuất Excel] │
│                                                                       │
│ ┌─ Stock Movement Log (collapsible) ──────────────────────────────┐  │
│ │ 14:30 │ SVC-001 │ -1 │ Shopee order #12345     │ Auto-sync     │  │
│ │ 14:15 │ KCN-002 │ +50│ Manual stock-in          │ user@team.com │  │
│ │ [→ Xem toàn bộ lịch sử]                                        │  │
│ └──────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
InventoryPage
├── AppShell (shared)
├── PageHeader
│   ├── Title ("📦 Tồn kho")
│   ├── SearchInput (product/SKU search)
│   └── SettingsButton
├── SummaryCards (4 cards)
│   ├── TotalSKUsCard
│   ├── LowStockCard (click → filter low stock)
│   ├── OutOfStockCard (click → filter out of stock)
│   └── SyncStatusCard (last sync time + refresh button)
├── FilterBar
│   ├── StatusFilter (All / In Stock / Low Stock / Out of Stock)
│   ├── LocationFilter (warehouse dropdown)
│   ├── PlatformFilter (Shopee / TikTok / All)
│   └── CategoryFilter
├── InventoryTable
│   ├── TableHeader (sortable columns)
│   ├── InventoryRow[]
│   │   ├── Checkbox
│   │   ├── ProductThumbnail
│   │   ├── ProductName + SKU
│   │   ├── StockCell[] (per location/platform)
│   │   │   ├── StockCount (color-coded)
│   │   │   └── TrendIndicator (↑/↓)
│   │   ├── TotalStock
│   │   ├── StatusBadge (🟢/🟡/🔴/❌)
│   │   └── AlertBanner (conditional — low/out-of-stock)
│   └── Pagination
├── BulkActionBar (visible when items selected)
│   ├── SelectedCount
│   ├── BulkStockInButton
│   ├── BulkTagButton
│   └── ExportButton
└── StockMovementLog (collapsible panel)
    ├── MovementRow[]
    │   ├── Timestamp
    │   ├── SKU
    │   ├── DeltaAmount (+/-)
    │   ├── Reason
    │   └── Actor
    └── ViewAllLink
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Total SKUs | `skus` count | `InventoryService/GetSummary` | Integer | 5m TTL |
| Low Stock Count | `skus WHERE stock < threshold` | `InventoryService/GetSummary` | Integer + "(cần nhập)" | 5m TTL |
| Out of Stock | `skus WHERE stock = 0` | `InventoryService/GetSummary` | Integer | 5m TTL |
| Sync Status | `connectors.last_sync` | `ConnectorService/GetSyncStatus` | "30m ago" relative time | Real-time |
| Stock per Location | `inventory_locations × skus` | `InventoryService/ListStock(filters, page)` | Integer, color-coded | 5m TTL |
| Stock Movement | `stock_movements` | `InventoryService/ListMovements(limit=5)` | Timestamp + SKU + delta + reason | 2m TTL |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Search product | Type in search input (debounced 300ms) | `InventoryService/ListStock(query)` | — | Filter table results | `inventory:read` |
| 2 | Filter by status | Select from StatusFilter | `InventoryService/ListStock(status)` | — | Table filters | `inventory:read` |
| 3 | Sort column | Click column header | Client-side sort | — | Re-order rows | `inventory:read` |
| 4 | Manual stock-in | Click "📥 Nhập hàng" | — | — | Open StockInDrawer | `inventory:write` |
| 5 | Confirm stock-in | Submit StockInDrawer form | `InventoryService/CreateStockMovement` | `stock += amount` | Toast "Đã cập nhật tồn kho", refresh table | `inventory:write` |
| 6 | Bulk stock-in | Select items → "📥 Nhập hàng" | `InventoryService/BulkStockIn` | Multiple stock updates | Toast "Đã cập nhật {n} sản phẩm" | `inventory:write` |
| 7 | Export Excel | Click "📊 Xuất Excel" | `InventoryService/Export(format=xlsx)` | — | Download file | `inventory:read` |
| 8 | View product detail | Click product name | — | — | Navigate → `/commerce/products/[id]` | `product:read` |
| 9 | Sync now | Click refresh on SyncStatusCard | `ConnectorService/TriggerSync(inventory)` | — | Spinner → "Đang đồng bộ..." → updated data | `inventory:write` |
| 10 | Set alert threshold | Click "⚙️ Cài đặt" → threshold form | `InventoryService/UpdateThresholds` | `low_stock_threshold = value` | Toast "Đã cập nhật ngưỡng cảnh báo" | `inventory:write` |
| 11 | View movement history | Click "→ Xem toàn bộ lịch sử" | — | — | Expand/navigate to full log | `inventory:read` |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial page load | Skeleton table + shimmer summary cards |
| LOADED | Data available | Full table with stock data |
| EMPTY | No products | Empty state: "Chưa có sản phẩm nào. [Thêm sản phẩm →]" |
| FILTERED_EMPTY | Filter returns 0 | "Không tìm thấy sản phẩm phù hợp. [Xóa bộ lọc]" |
| SYNCING | Platform sync in progress | Spinner on SyncStatusCard + "Đang đồng bộ..." |
| PARTIAL_DEGRADED | Some platform sync failed | Yellow banner: "⚠️ Tồn kho Shopee chưa đồng bộ xong. Dữ liệu có thể chưa chính xác." |
| ERROR | API failure | Error state with retry |
| STALE | Data >30m old | Stale banner: "Dữ liệu cập nhật 45 phút trước. [🔄 Làm mới]" |

---

## 8. Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Stock-in amount | Required, integer, > 0 | "Số lượng phải lớn hơn 0" |
| Stock-in amount | Max 99,999 | "Số lượng tối đa 99.999" |
| Stock-in reason | Required | "Vui lòng nhập lý do nhập hàng" |
| Alert threshold | Integer, ≥ 0 | "Ngưỡng phải ≥ 0" |

---

## 9. Permission Matrix

| Widget/Action | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View inventory | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Manual stock-in | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Bulk operations | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Export data | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Set thresholds | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Trigger sync | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

---

## 10. Navigation Map

```
Inventory (/commerce/inventory)
├── → /commerce/products/[id]  (via product click)
├── → Stock-in drawer          (via manual/bulk stock-in)
├── → /commerce/inventory/settings  (via settings icon)
├── → /commerce/inventory/movements  (via "Xem toàn bộ lịch sử")
└── ← /commerce (via breadcrumb)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network error | No connectivity | Full page error with retry | "Thử lại" button |
| API error (5xx) | Server failure | Inline error banner | Per-section retry |
| Sync failed | Platform API error | Yellow banner per platform | "Thử đồng bộ lại" |
| Stock update conflict | Concurrent edit | Confirmation dialog: "Tồn kho đã thay đổi. Giá trị hiện tại: {n}. Tiếp tục?" | User confirms or cancels |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Table | `role="table"`, sortable columns announced |
| Status badges | Color is NOT sole indicator — text label required |
| Stock alerts | Low stock alerts use `role="alert"` |
| Keyboard | Full keyboard navigation, Tab through rows and actions |
| Screen reader | Row summaries: "Serum Vitamin C, SKU SVC-001, tồn kho 5, trạng thái sắp hết" |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | App Shell + skeleton table |
| Data load | 200-500ms | Summary cards populate → table rows animate in |
| Sync refresh | 2-15s | Spinner on sync card, table data refreshes progressively |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 2.0s (first table rows + summary cards) |
| TTI | < 2.5s |
| Table render | < 500ms for 50 rows |
| Search response | < 300ms (Meilisearch or SQL LIKE fallback) |
| Export generation | < 5s for < 5000 SKUs |
| Stock-in response | < 1s (optimistic UI + server confirm) |
| Sort/filter | < 500ms |

---

## 15. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| Stock movements (order deductions) | SSE `/events/inventory` | Real-time (on order confirmed/shipped) |
| Manual stock-in from other users | SSE `/events/inventory` | Real-time |
| Low-stock threshold breaches | SSE `/events/inventory` | Real-time (when crossing threshold) |
| Platform sync status | Polling | Every 30 seconds during active sync |

### Real-time UX
- **Stock deduction**: Row stock count animates down with brief red flash
- **Low stock breach**: Row background transitions to warning yellow + badge appears
- **New stock-in**: Row stock count animates up with brief green flash
- **Sync completion**: Summary cards refresh with animated number transition

---

## 16. SvelteKit Implementation Notes

### Route & Server Load
- **Route**: `src/routes/(app)/commerce/inventory/+page.svelte`
- **Server load**: `+page.server.ts` → fetch SKU table + summary stats + sync status
- **SSR**: Server renders summary cards + first 50 rows of inventory table

### Data Fetching Strategy
```
+page.server.ts:
  Promise.all([
    inventoryService.list({ sort, filters, page, limit: 50 }),
    inventoryService.getSummary(),
    connectorService.getSyncStatus('inventory')
  ])

Client-side:
  onSort(column) → inventoryService.list({ sort: column })
  onFilter(params) → inventoryService.list({ filters: params })
  onStockIn(sku_id, amount, reason) →
    inventoryService.stockIn(sku_id, { amount, reason })
  onTriggerSync(platform) → connectorService.syncInventory(platform)
  onExport(format) → inventoryService.export({ format, filters })
```

### Stock-in Drawer
- Opens as slide-in drawer (right side)
- Optimistic UI: stock count updates immediately, reverts on error
- Audit log entry created server-side with user, timestamp, amount, reason

### Low-stock Alert System
- Threshold stored per-product in `products.low_stock_threshold` (default: 10)
- SSE event fires when any SKU crosses threshold
- Dashboard push to Home (W001) via `alerts` channel

---

## 17. Localization Notes

- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator: "299.000đ")
- Stock labels: "Tồn kho", "Sắp hết", "Hết hàng", "Dư thừa"
- Stock-in reason examples: "Nhập hàng", "Trả hàng", "Điều chỉnh", "Kiểm kê"
- Quantities: dot separator (1.234 đơn vị)
- Date: DD/MM/YYYY HH:mm
- Status: "🟢 Đủ hàng", "🟡 Sắp hết", "🔴 Hết hàng"
- Movement log: "↑ +50 (Nhập hàng) · 15/03/2026 14:30 · admin@team.com"
- Alert: "⚠️ {count} SKU sắp hết hàng"
- Sync: "Đồng bộ lần cuối: 2 giờ trước"

---

## 18. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `inventory.viewed` | Page load | `total_skus`, `low_stock_count`, `oos_count` |
| `inventory.stock_in` | Manual stock-in confirmed | `sku_id`, `amount`, `reason`, `location` |
| `inventory.stock_in.bulk` | Bulk stock-in | `sku_count`, `total_units` |
| `inventory.exported` | Export clicked | `format`, `row_count`, `filters_active` |
| `inventory.synced` | Manual sync triggered | `platform`, `result` ('success'/'error') |
| `inventory.filtered` | Filter/sort applied | `filter_type`, `filter_value` |
| `inventory.searched` | Search query | `query`, `results_count` |
| `inventory.threshold_changed` | Threshold updated | `sku_id`, `old_threshold`, `new_threshold` |

---

## 19. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-stock-in` | In-stock indicators (🟢 green) |
| `--color-stock-low` | Low-stock indicators (🟡 amber) |
| `--color-stock-out` | Out-of-stock indicators (🔴 red) |
| `--color-stock-in-flash` | Stock increase animation (green flash) |
| `--color-stock-out-flash` | Stock decrease animation (red flash) |
| `--color-accent` | Primary CTAs (Stock-in, Sync) |
| `--color-surface-primary` | Summary card backgrounds |
| `--color-surface-elevated` | Table rows on hover |
| `--color-text-primary` | SKU codes, stock counts |
| `--color-text-secondary` | Last sync timestamp, movement log |

---

## 20. Related Screens

| Screen | Relationship |
|---|---|
| [W060] Product List | Parent — products with stock data |
| [W061] Product Detail | Detail — stock tab per product |
| [W061] Order List | Linked — orders deduct stock |
| [W073] Refund Management | Refund can restore stock |
| [W071] Samples | Sample shipments deduct stock |
| [M028] Mobile Products | Mobile equivalent (compact stock view) |
| [S009] Trust Badge | Source class on stock data (Official vs Manual) |

---

## 21. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A standardization**: Enhanced Performance Requirements (7 metrics), expanded Real-time Updates with UX behaviors, added SvelteKit Implementation Notes (stock-in drawer, low-stock alert system, SSE integration), enriched Localization with stock-specific formats, expanded Analytics (8 events), added screen-specific Design Tokens (10 tokens with flash colors). | System |
| 2026-03-28 | 1.0 | Initial specification — fills M13 inventory gap | System |
