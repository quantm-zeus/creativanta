# Screen: Mobile — Cost Entry

> **Screen ID**: M043
> **Module**: M19 — Operating Ledger / Profit Graph / Proof Center
> **Route**: `/m/finance/costs/new`
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 06 §Commerce/Finance, A1 Schema (cost_items, billing_events), S009 Trust Badge, B5 RBAC §2.9

---

## 1. Purpose & Context

Mobile-optimized cost entry form for logging expenses on the go — supports receipt scanning with AI auto-fill, manual entry, recurring costs, and source class tagging. Critical for maintaining accurate Profit OS calculations.

### User Story
> As a seller, I want to quickly log a shipping cost or product cost from my phone right after purchase so my profit calculations stay accurate.

### Business Goal
- Maintain accurate profit truth (COGS, shipping, marketing costs)
- Enable on-the-go expense logging (reduce data entry lag)
- Improve profit snapshot accuracy via timely cost recording
- Support source class tagging for trust/proof system

### When to Use
- After paying a supplier or shipping cost
- Logging recurring subscription costs
- Scanning paper receipts for digital record
- Quick entry triggered from profit alert ("Margin dropping — check costs")

### Entry Points
- Finance screen → "➕ Thêm chi phí" FAB
- Dashboard alert: "⚠️ Profit margin dưới 15%" → "Kiểm tra chi phí" → this screen
- Camera quick action → auto-opens in scan mode
- Copilot: "Thêm chi phí giao hàng 250K" → auto-fills

### Exit Points
- Save → toast + back to Finance overview
- Cancel → discard confirmation if form dirty → back to Finance
- "Xem chi phí" → navigate to cost list

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `finance:write` permission
- At least 1 product or category exists (for cost allocation)

### Postconditions
- Cost item created in `cost_items` table
- Profit snapshots recalculated for affected products/periods
- Source class assigned (Official if receipt scanned, Estimated if manual estimate)
- Audit event: `finance.cost_item.created`

---

## 3. Layout Structure

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Thêm chi phí                                         [💾 Lưu]    │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ ┌─ Receipt Scan Section ──────────────────────────────────────────┐  │
│ │ ┌────────────────────────────────────────────────────────────┐  │  │
│ │ │                📸                                          │  │  │
│ │ │         Scan hóa đơn                                      │  │  │
│ │ │    AI sẽ tự động điền thông tin                           │  │  │
│ │ │                                                            │  │  │
│ │ │  [📸 Chụp hóa đơn]     [📂 Chọn từ thư viện]             │  │  │
│ │ └────────────────────────────────────────────────────────────┘  │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ── Hoặc nhập thủ công ──────────────────────────────────────────     │
│                                                                       │
│ Loại chi phí *                                                        │
│ ┌──────────────────────────────────────────────────────────────────┐  │
│ │ [📦 COGS (Giá vốn)]                                             │  │
│ │ [🚚 Phí giao hàng]                                              │  │
│ │ [📢 Marketing/Quảng cáo]                                        │  │
│ │ [🤖 AI Credits]                                                  │  │
│ │ [📋 Subscription]                                                │  │
│ │ [🏷 Phí nền tảng]                                               │  │
│ │ [📎 Khác]                                                        │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ Số tiền *                                                             │
│ [250.000                                                     ] VND   │
│                                                                       │
│ Ngày *                                                                │
│ [28/03/2026                                                  ] 📅   │
│                                                                       │
│ Sản phẩm liên quan                                                    │
│ [🔍 Tìm sản phẩm...                  ] (optional)                   │
│                                                                       │
│ Ghi chú                                                              │
│ [Phí giao hàng GHTK tháng 3                                 ]       │
│                                                                       │
│ Hóa đơn/Biên lai                                                     │
│ [📸 receipt_march.jpg   ✕]    [+ Thêm ảnh]                          │
│                                                                       │
│ ┌─ Trust & Proof ─────────────────────────────────────────────────┐  │
│ │ Source class: [🟢 Official ▾ | 🟡 Imported | ⬜ Estimated]     │  │
│ │ ℹ️ "Official: có hóa đơn/biên lai. Estimated: ước tính."      │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Recurring ─────────────────────────────────────────────────────┐  │
│ │ [○] Chi phí một lần                                             │  │
│ │ [●] Lặp lại hàng tháng  Ngày: [28 ▾]  Kết thúc: [Không ▾]    │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ [████████████████ 💾 Lưu chi phí ████████████████████]               │
│                                                                       │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [📋] [➕] [💬] [👤]                                            │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
CostEntryScreen
├── AppBar
│   ├── BackButton
│   ├── Title ("Thêm chi phí")
│   └── SaveButton (enabled when form valid)
├── ScrollableForm
│   ├── ReceiptScanSection
│   │   ├── ScanPlaceholder (when no image)
│   │   │   ├── CameraButton ("📸 Chụp hóa đơn")
│   │   │   └── GalleryButton ("📂 Chọn từ thư viện")
│   │   └── ScannedReceiptPreview (when image captured)
│   │       ├── ReceiptThumbnail
│   │       ├── AIStatusBadge ("🤖 Đang đọc..." / "✅ Đã nhận dạng")
│   │       └── RemoveButton
│   ├── Divider ("Hoặc nhập thủ công")
│   ├── CategorySelector
│   │   └── CategoryChip[] (7 categories — single select)
│   │       ├── CategoryIcon
│   │       └── CategoryLabel
│   ├── AmountInput
│   │   ├── NumberInput (formatted VND)
│   │   └── CurrencySuffix ("VND")
│   ├── DatePicker
│   │   ├── DateInput (readonly)
│   │   └── CalendarButton
│   ├── ProductLinker (optional)
│   │   ├── SearchInput ("Tìm sản phẩm...")
│   │   └── SelectedProductChip (if linked)
│   ├── NoteInput (textarea, max 500 chars)
│   ├── AttachmentSection
│   │   ├── AttachmentThumbnail[] (max 3)
│   │   └── AddAttachmentButton
│   ├── TrustProofSection
│   │   ├── SourceClassSelector (dropdown: Official/Imported/Estimated)
│   │   └── HelpText
│   ├── RecurringSection
│   │   ├── RecurringToggle (one-time / monthly)
│   │   ├── DayOfMonthSelector (if recurring)
│   │   └── EndDateSelector (if recurring)
│   └── SubmitButton ("💾 Lưu chi phí")
├── BottomNavBar (shared)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Categories | Static list (7 types) | — | Icon + Vietnamese label | Static |
| Product search | `products` table | `ProductService/Search(q)` | Dropdown with product name + image | Session |
| Scanned data | AI OCR from receipt image | `AIService/ScanReceipt(image)` | Auto-fills amount + date + note | No cache |
| Source class | Static (3 options) | — | Canonical badge colors | Static |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Scan receipt | Tap "📸 Chụp" | Camera → `AIService/ScanReceipt` | — | Camera opens → AI processes → auto-fills fields | `finance:write` |
| 2 | Pick from gallery | Tap "📂 Chọn" | Gallery → `AIService/ScanReceipt` | — | Gallery opens → AI processes → auto-fills | `finance:write` |
| 3 | Select category | Tap category chip | — (local) | — | Chip highlighted, source class auto-suggest | `finance:write` |
| 4 | Enter amount | Type in amount field | — (local) | — | Live VND formatting (250.000) | `finance:write` |
| 5 | Select date | Tap date field | — (local) | — | Native date picker opens | `finance:write` |
| 6 | Link product | Search + select product | `ProductService/Search` | — | Product chip appears below search | `finance:write` |
| 7 | Add attachment | Tap "+ Thêm ảnh" | Camera/Gallery | — | Thumbnail added (max 3) | `finance:write` |
| 8 | Set source class | Select from dropdown | — (local) | — | Badge changes color + help text updates | `finance:write` |
| 9 | Toggle recurring | Tap recurring radio | — (local) | — | Show/hide recurring options | `finance:write` |
| 10 | Save cost | Tap "💾 Lưu chi phí" | `CostService/CreateCostItem(payload)` | `cost_items` insert + profit recalc trigger | Toast "✅ Đã lưu chi phí {amount}" → navigate back | `finance:write` |
| 11 | Discard | Tap back (with dirty form) | — | — | Confirmation: "Bạn có chắc muốn hủy? Dữ liệu sẽ mất." | Any |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| EMPTY | Fresh form, no input | Scan section prominent, empty fields below |
| SCANNING | AI reading receipt | Receipt thumbnail + "🤖 Đang đọc hóa đơn..." spinner overlay |
| AUTO_FILLED | AI extracted data | Pre-filled fields with 🤖 badge on each auto-filled field (editable) |
| SCAN_FAILED | OCR failed | Toast: "Không đọc được hóa đơn. Vui lòng nhập thủ công." |
| FILLING | User manually filling | Standard form interaction |
| VALIDATION_ERROR | Required fields missing | Red highlight on missing fields |
| SAVING | Submitting form | Save button shows spinner, form disabled |
| SAVED | Success | Toast "✅ Đã lưu" → auto-navigate back after 1s |
| ERROR | Save failed | Toast: "Không thể lưu. Thử lại." + form stays usable |

---

## 8. Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Category | Required | "Vui lòng chọn loại chi phí" |
| Amount | Required, > 0 | "Vui lòng nhập số tiền" |
| Amount | Max 999,999,999 VND | "Số tiền tối đa 999.999.999đ" |
| Date | Required, ≤ today | "Ngày không được ở tương lai" |
| Source class | Required | "Vui lòng chọn nguồn dữ liệu" |
| Note | Max 500 characters | "Ghi chú tối đa 500 ký tự" |
| Attachments | Max 3 files, ≤5MB each | "Tối đa 3 ảnh, mỗi ảnh ≤ 5MB" |
| Recurring day | 1-28 (avoids month-end issues) | "Chọn ngày từ 1-28" |

### Auto-fill Validation
- AI-extracted values are pre-filled but always editable
- If AI confidence < 70% on a field, show warning: "⚠️ Giá trị này có thể không chính xác"

---

## 9. Permission Matrix

| Action | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| Open cost entry | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Scan receipt | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Save cost | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Set source=Official | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

---

## 10. Navigation Map

```
Cost Entry (/m/finance/costs/new)
├── → Camera (system camera for receipt scan)
├── → Gallery (system gallery for receipt selection)
├── → Product search results (inline)
├── → Date picker (system date picker)
├── ← /m/finance (on save success or cancel)
└── ← Discard confirmation dialog (if form dirty)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Camera permission denied | No camera access | "Cần quyền camera để scan hóa đơn. [Cài đặt →]" | Open system settings |
| OCR failed | Unreadable receipt | "Không đọc được. Nhập thủ công." | Manual entry |
| Save failed (network) | No connectivity | "Không có kết nối. Lưu nháp?" → local draft | Auto-retry when online |
| Save failed (server) | API error | Toast "Lưu thất bại. Thử lại." | Manual retry |
| Duplicate cost | Same amount+date+category | Warning: "Chi phí tương tự đã tồn tại. Vẫn lưu?" | User confirms or cancels |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Category chips | `Semantics(selected: true/false)` per chip |
| Amount input | `semanticsLabel: "Số tiền chi phí, đơn vị VND"` |
| Scan button | `semanticsLabel: "Chụp ảnh hóa đơn để AI tự động nhập"` |
| AI-filled fields | Announce "Đã tự động nhận dạng" |
| Form errors | `Semantics(error: true)` + screen reader reads error message |
| Save button | Disabled state announced |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen open | <500ms | Empty form renders instantly |
| Receipt scan | 2-5s | Camera → processing overlay with progress |
| AI OCR | 1-3s | "🤖 Đang đọc..." → fields populate with animation |
| Save | 500ms-2s | Button spinner |
| Product search | <300ms | Dropdown results |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Form render | <500ms |
| OCR processing | <5s |
| Save response | <2s |
| Image compression | Client-side before upload (max 1MB) |

---

## 15. Real-time Updates

N/A — This is a form submission screen. No real-time data needed.

---

## 16. Localization Notes

- Currency: VND only (no decimal), dot separator for thousands
- Date format: DD/MM/YYYY (Vietnamese)
- Tone: Simple, action-oriented, beginner-friendly
- Category labels: Vietnamese

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `finance.cost_entry.opened` | Screen opened | `source` (fab, alert, copilot) |
| `finance.cost_entry.scan_started` | Tap scan | `method` (camera, gallery) |
| `finance.cost_entry.scan_success` | OCR completed | `confidence`, `fields_extracted` |
| `finance.cost_entry.scan_failed` | OCR failed | `error_type` |
| `finance.cost_entry.saved` | Save success | `category`, `amount`, `source_class`, `has_receipt`, `is_recurring` |
| `finance.cost_entry.discarded` | Cancel with dirty form | `fields_filled` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-surface-primary` | Form background |
| `--color-accent` | Save button, selected category |
| `--color-success` | Official source badge, save success |
| `--color-warning` | Low-confidence AI fields |
| `--color-danger` | Validation errors |
| `--radius-chip` | Category chip radius |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W083] Web Cost Detail | Web equivalent (more detailed) |
| [M040] Mobile Finance | Parent — returns here after save |
| [M041] Mobile Finance Summary | Updated after cost entry |
| [W081] Profit Dashboard | Affected — profit recalculated |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | Full 20-point upgrade from 62-line Tier C. Added complete wireframe with scan section, component hierarchy, 11 actions with AI OCR integration, 9 states, validation rules with AI confidence warning, duplicate detection, offline draft save, full accessibility. Fixed Screen ID (M035b→M043). | System |
| 2026-03-28 | 2.0 | Expanded from sparse | System |
| 2026-03-28 | 1.0 | Initial specification | System |
