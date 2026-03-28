# Screen: Web — Tax Report Export

> **Screen ID**: W092
> **Module**: S16 — Creator Pro Tools
> **Route**: `/creator-pro/tax-export`
> **Platform**: Web (SvelteKit)
> **Upstream**: A1 Schema (income_entries, expense_entries, tax_reports), S009 Trust Badge, B5 RBAC §2.7

---

## 1. Purpose & Context

Export income reports for tax filing — monthly/quarterly/yearly with income & expense breakdown by source, net calculation, multi-format export, and trust-level annotations.

### User Goals
- Generate accurate income reports for tax purposes
- See income breakdown by platform and type
- Download in accountant-friendly formats (PDF, Excel, CSV)
- Verify data trust levels before filing

### Entry Points
- Creator Pro Dashboard (W088): "📊 Tax reports"
- Sidebar: Creator Pro → "📊 Báo cáo thuế"

### Exit Points
- "📥 Export" → file download
- "📧 Gửi email" → email with attachment

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Creator Pro   📊 Báo cáo thuế                                    │
├──────────────────────────────────────────────────────────────────────┤
│ Period: [● Tháng] [○ Quý] [○ Năm]  ·  Kỳ: [Tháng 3/2026 ▾]       │
│                                                                      │
│ ┌─ Income Summary ─────────────────────────────────────────────┐    │
│ │ Source                  │ Amount        │ %     │ Trust        │    │
│ │ ─────────────────────────┼───────────────┼───────┼─────────── │    │
│ │ 🎵 Affiliate (TikTok)  │ 15,200,000   │ 33.6% │ [🟢 Official]│   │
│ │ 🛒 Affiliate (Shopee)  │  8,400,000   │ 18.6% │ [🟢 Official]│   │
│ │ 🤝 Brand sponsorship   │ 12,000,000   │ 26.5% │ [🟡 Imported]│   │
│ │ 🏪 Product sales       │  6,800,000   │ 15.0% │ [🟢 Official]│   │
│ │ 🎖 Membership           │  2,850,000   │  6.3% │ [🟢 Official]│   │
│ │ ─────────────────────────┼───────────────┼───────┼───────────  │   │
│ │ TOTAL INCOME            │ 45,250,000   │ 100%  │ 82% Official │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Expenses ───────────────────────────────────────────────────┐    │
│ │ 🤖 AI Credits:          -380,000                              │    │
│ │ 💳 Subscription (Pro):  -699,000                              │    │
│ │ 📦 Sample products:      -250,000                             │    │
│ │ TOTAL expenses:        -1,329,000                              │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Net Income ─────────────────────────────────────────────────┐    │
│ │ Thu nhập ròng trước thuế: 43,921,000 VND                      │    │
│ │ Estimated tax (10%): ~4,392,100 VND                           │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Trust Summary ──────────────────────────────────────────────┐    │
│ │ 🔰 Data trust: 82% Official · 18% Imported                   │    │
│ │ ⚠️ Brand sponsorship (12M) là imported — xác nhận thủ công.  │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Format: [● PDF] [○ Excel] [○ CSV]                                  │
│ Language: [● Tiếng Việt] [○ English]                                │
│ [📥 Export] [📧 Gửi qua email]                                     │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Aggregating data | Table skeleton |
| LOADED | Report ready | Income/expense tables |
| NO_DATA | No income for period | "Chưa có dữ liệu thu nhập trong kỳ này" |
| PARTIAL_DATA | Platforms not synced | "⚠️ Một số nền tảng chưa sync: {list}. Dữ liệu có thể thiếu." |
| EXPORTING | Generating export file | Spinner: "Đang tạo file..." |
| LOW_TRUST | < 70% Official | Warning: "⚠️ Dữ liệu chưa đủ tin cậy. Xem xét reconcile trước khi nộp thuế." |
| ERROR | API failed | Error with retry |

---

## 8. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached report | Retry online |
| Aggregation fail | Backend processing error | Toast: "Không tổng hợp được dữ liệu. [Thử lại]" | Retry |
| Export fail | PDF/Excel generation error | Toast: "Không tạo được file. [Thử lại]" | Retry |
| Platform not synced | Missing platform data | Inline: "⚠️ {platform} chưa sync. Dữ liệu có thể thiếu." | Manual sync |
| Email send fail | SMTP error | Toast: "Gửi email thất bại. [Thử lại]" | Retry |

---

## 9. Accessibility

| Element | Requirement |
|---|---|
| Income table | `role="table"`, `aria-label="Income summary for {period}"` |
| Trust badges | `aria-label="{source}: {trust_level}"` (e.g., "Official" / "Imported") |
| Period selector | `role="radiogroup"`, `aria-label="Report period"` |
| Net income | `role="status"`, `aria-label="Net income before tax: {amount}"` |
| Format selector | `role="radiogroup"`, `aria-label="Export format"` |

---

## 10. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Period selector + table skeleton |
| Income aggregation | 500-2000ms | Rows populate with amounts |
| Expenses | 300-600ms | Expense section populates |
| Tax estimate | 200-400ms | Net income + estimate appear |
| Trust analysis | 300-500ms | Trust badges populate |

---

## 11. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `tax_export.viewed` | Page load | `period_type`, `period_value` |
| `tax_export.period_changed` | Period selector change | `old_period`, `new_period` |
| `tax_export.exported` | "📥 Export" | `format` (PDF/Excel/CSV), `period`, `total_income` |
| `tax_export.emailed` | "📧 Gửi qua email" | `format`, `period` |
| `tax_export.trust_warning_viewed` | Low trust warning shown | `trust_pct`, `low_trust_sources` |
| `tax_export.source_drilled` | Click income source row | `source`, `amount` |
| `tax_export.reconcile_started` | "→ Reconcile" from trust warning | `source` |
| `tax_export.language_changed` | Language selector change | `new_language` |

---

## 12. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/creator-pro/tax-export/+page.svelte`
- **Server load**: `+page.server.ts` → `TaxReportService/GetReport(workspace_id, period)` → aggregates all income sources
- **Aggregation**: Server joins `income_entries` (platform APIs) + `brand_deal` payments + `product_sales` + `membership` revenue
- **Trust badges**: From `data_trust_audit` table: "official" (API-sourced), "imported" (manual CSV), "reconciled"
- **Period change**: Client triggers `invalidateAll()` → server re-aggregates
- **PDF**: Server-side Puppeteer template rendering with Vietnamese tax format
- **Excel**: Server-side `xlsx` library with formatted sheets
- **CSV**: Client-side Blob download
- **Tax estimate**: Configurable tax rate (default 10%), shown as informational

---

## 13. Localization Notes

- Period: "Tháng", "Quý", "Năm"
- Income: "Thu nhập", "Chi phí", "Thu nhập ròng trước thuế"
- Trust: "🟢 Chính thức", "🟡 Nhập thủ công", "🔵 Đã đối soát"
- Tax: "Thuế ước tính ({rate}%): ~{amount} VND"
- Format: "PDF", "Excel", "CSV"
- Tone: Formal, financial-accuracy-focused

---

## 14. Design Tokens

| Token | Usage |
|---|---|
| `--color-trust-official` | 🟢 Official badge |
| `--color-trust-imported` | 🟡 Imported badge |
| `--color-trust-reconciled` | 🔵 Reconciled badge |
| `--color-danger` | Low trust warning |
| `--color-accent` | Export CTA |
| `--color-surface-elevated` | Section cards |
| `--font-metric` | Amounts (tabular-nums) |
| `--color-text-secondary` | Tax estimates, notes |

---

## 15. Related Screens

| Screen | Relationship |
|---|---|
| [W088] Creator Pro | Parent |
| [W081] Finance Dashboard | Workspace-level finance |
| [W084] Reconciliation | Fix trust gaps |

---

## 16. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (export fail, data gaps), table/trust a11y, 8 analytics, SvelteKit impl (aggregation, multi-format export), localization, 8 design tokens (trust-specific). | System |
| 2026-03-28 | 1.0 | Initial specification | System |
