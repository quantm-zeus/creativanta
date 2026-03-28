# Screen: Web — Financial Reports

> **Screen ID**: W087
> **Module**: M19 — Operating Ledger (Reports)
> **Route**: `/profit/reports`
> **Platform**: Web (SvelteKit)
> **Upstream**: PRD §33.5 Reporting, A1 Schema (financial_snapshots, orders, cost_entries), B5 RBAC §2.8

---

## 1. Purpose & Context

Generate P&L statements, cash flow summaries, and custom financial reports with trust annotations (source class badges) and multi-format export (CSV, PDF, Google Sheets).

### User Goals
- Generate standard financial reports (P&L, margin trend, channel breakdown)
- Build custom reports with date/platform/product filters
- Understand data confidence via trust annotations
- Export for accounting or tax filing

### Business Goals
- Provide tax-ready financial summaries
- Surface trust level of financial data (reconciled vs estimated)
- Enable period-over-period comparison
- Support custom report building for niche analysis

### Entry Points
- Sidebar: Finance → "📊 Báo cáo"
- Profit Dashboard (W081): "📊 Reports" link
- Finance → any module: "📥 Export report"

### Exit Points
- Export → CSV/PDF/Google Sheets download
- Click line item → Revenue Detail (W082) or Cost Detail (W083)

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `profit:read` permission (Owner, Admin)
- Financial data exists for selected period

### Postconditions
- Generated reports cached for 24h (or until new data arrives)
- Export logged for audit trail

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Finance   📊 Báo cáo tài chính              [+ Tạo báo cáo]    │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Report Templates ───────────────────────────────────────────┐    │
│ │ [📊 P&L Statement] [💰 Revenue by Channel] [📉 Cost Analysis]│   │
│ │ [📈 Margin Trend]  [📋 Tax Summary]       [📦 Product P&L]  │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Custom Report Builder ──────────────────────────────────────┐    │
│ │ Date range: [01/03/2026] → [31/03/2026]                      │    │
│ │ Group by: [● Daily] [○ Weekly] [○ Monthly] [○ Quarterly]     │    │
│ │ Filters:                                                       │    │
│ │ • Platform: [All ▾] Channels: [All ▾]                         │    │
│ │ • Product: [All ▾] Category: [All ▾]                          │    │
│ │ Include: [☑ Revenue] [☑ Costs] [☑ Net] [☑ Commission]       │    │
│ │          [☐ Tax] [☐ Shipping] [☐ Refunds]                    │    │
│ │ Trust filter: [☑ Official] [☑ Imported] [☑ Inferred]         │    │
│ │               [☐ Estimated] [☐ Unreconciled]                  │    │
│ │ [📊 Generate report]                                          │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Generated Report ──────────────────────────────────────────┐     │
│ │ 📊 P&L Statement — March 2026                               │     │
│ │                                                                │     │
│ │ Line Item          │ Amount      │ % of Rev │ Source Class   │     │
│ │ ═══════════════════╪═════════════╪══════════╪═══════════════ │     │
│ │ Revenue            │ 45,200,000  │ 100%     │ [🟢 Mixed]    │     │
│ │ ├ TikTok Shop     │ 28,500,000  │ 63.1%   │ [🟢 Official]  │     │
│ │ ├ Shopee          │ 12,400,000  │ 27.4%   │ [🟢 Official]  │     │
│ │ └ Sponsorship     │  4,300,000  │  9.5%   │ [🟡 Imported]  │     │
│ │ ───────────────────┼─────────────┼──────────┼─────────────── │     │
│ │ COGS              │ -12,100,000 │ 26.8%   │ [🟢 Mixed]     │     │
│ │ Gross Profit      │  33,100,000 │ 73.2%   │                 │     │
│ │ ───────────────────┼─────────────┼──────────┼─────────────── │     │
│ │ Operating Expenses│  -6,200,000 │ 13.7%   │ [🟡 Mixed]     │     │
│ │ ├ AI Credits      │  -1,500,000 │  3.3%   │ [🟢 Official]  │     │
│ │ ├ Platform fees   │  -3,200,000 │  7.1%   │ [🟢 Official]  │     │
│ │ └ Other costs     │  -1,500,000 │  3.3%   │ [🟡 Imported]  │     │
│ │ ═══════════════════╪═════════════╪══════════╪═══════════════ │     │
│ │ Net Profit        │  26,900,000 │ 59.5%   │                 │     │
│ │                                                                │     │
│ │ ⚠️ Trust: 85% reconciled · 12% imported · 3% estimated       │     │
│ │ Coverage: [████████████████████░░░] 85%                        │     │
│ │                                                                │     │
│ │ [📥 CSV] [📥 PDF] [📄 Google Sheets] [📋 Copy table]        │     │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Saved Reports ──────────────────────────────────────────────┐    │
│ │ 📊 Feb 2026 P&L (saved 01/3) · [📥 Re-download] [🗑 Delete]│    │
│ │ 📊 Q4 2025 Summary (saved 05/1) · [📥] [🗑]                 │    │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
FinancialReportsPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Finance")
│   ├── PageTitle ("📊 Báo cáo tài chính")
│   └── CreateReportButton
├── ReportTemplates
│   └── TemplateCard[] (P&L, Revenue by Channel, etc.)
├── CustomReportBuilder
│   ├── DateRangePicker
│   ├── GroupBySelector (Daily/Weekly/Monthly/Quarterly)
│   ├── Filters (Platform, Channel, Product, Category)
│   ├── IncludeToggles (Revenue, Costs, Net, Commission, Tax, etc.)
│   ├── TrustFilter (source class checkboxes)
│   └── GenerateButton
├── GeneratedReport
│   ├── ReportTitle + Period
│   ├── PLTable
│   │   └── LineItem[] (hierarchical, collapsible)
│   │       ├── ItemName
│   │       ├── Amount (VND, right-aligned)
│   │       ├── PercentOfRevenue
│   │       └── SourceClassBadge (S009)
│   ├── TrustSummary (reconciled %, imported %, estimated %)
│   ├── CoverageBar
│   └── ExportBar (CSV, PDF, Google Sheets, Copy)
├── SavedReportsSection
│   └── SavedReport[] (date, re-download, delete)
```

---

## 5. Report Templates

| Template | Content | Use Case |
|---|---|---|
| P&L Statement | Revenue - COGS - Operating = Net Profit | Monthly/quarterly overview |
| Revenue by Channel | Revenue breakdown by platform + channel | Channel strategy |
| Cost Analysis | Cost categories with trends | Cost optimization |
| Margin Trend | Gross/Net margin over time (chart) | Profitability tracking |
| Tax Summary | Revenue + deductible expenses formatted for tax | Tax filing |
| Product P&L | Per-product revenue vs COGS | Product portfolio analysis |

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Skeleton |
| IDLE | Page loaded, no report generated | Template tiles + builder visible |
| GENERATING | Report being generated | "📊 Đang tạo báo cáo..." spinner |
| REPORT_READY | Report generated | Full P&L table with export options |
| NO_DATA | No financial data in period | "Chưa có dữ liệu tài chính trong khoảng thời gian này." |
| LOW_TRUST | > 30% of data is estimated/unreconciled | Warning: "⚠️ Báo cáo có {pct}% dữ liệu estimated. Xem xét reconciliation trước khi dùng cho mục đích thuế." |
| ERROR | Generation failed | Error with retry |

---

## 7. Permissions

| Feature | Owner | Admin | Manager+ |
|---|---|---|---|
| View reports | ✅ | ✅ | ❌ |
| Generate reports | ✅ | ✅ | ❌ |
| Export | ✅ | ✅ | ❌ |
| View trust annotations | ✅ | ✅ | ❌ |

---
## 8. Edge Cases

| Edge Case | Handling |
|---|---|
| Low trust report (>30% estimated) | Warning: "⚠️ Báo cáo có {pct}% estimated. Reconciliation trước khi dùng cho thuế." |
| Very large dataset (>1Y, all products) | "Dữ liệu lớn — tạo báo cáo có thể mất 30s+" spinner |
| Saved report data changed | Badge: "⚠️ Dữ liệu gốc đã thay đổi. [Tạo lại]" |
| No costs entered | P&L shows revenue only: "⚠️ Chưa nhập chi phí — Net Profit = Revenue" |
| Custom period invalid (end < start) | Inline error: "Ngày kết thúc phải sau ngày bắt đầu" |

---

## 9. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" | Retry online |
| Generation timeout | Large report | "⏳ Báo cáo đang tạo... Sẽ thông báo khi xong." | Background + notification |
| Google Sheets auth fail | Token expired | "Đăng nhập lại Google. [Authorize]" | Re-auth |
| Export PDF fail | pdf-lib error | Toast: "Không xuất PDF. [Thử CSV]" | Fallback CSV |
| Saved report too old | >90d auto-purge | "Báo cáo đã hết hạn. [Tạo lại]" | Re-generate |

---

## 10. Accessibility

| Element | Requirement |
|---|---|
| Report template cards | `role="button"`, `aria-label="Tạo báo cáo: {name}"` |
| P&L table | `role="table"`, hierarchical rows with `aria-level` |
| Coverage bar | `role="progressbar"`, `aria-valuenow`, `aria-label="Độ tin cậy: {pct}%"` |
| Source badges | `aria-label="Nguồn: {class}"`, not color-only |
| Export buttons | `aria-label="Xuất {format}"` |

---

## 11. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Template grid + builder form |
| Template load | 100ms | Instant (static) |
| Report generation | 2-10s | "📊 Đang tạo..." spinner |
| P&L table | 0ms (after gen) | Table populates instantly |
| Export | 1-5s | Button spinner |

---

## 12. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `finance_reports.viewed` | Page load | — |
| `finance_reports.template_selected` | Template click | `template_name` |
| `finance_reports.custom_generated` | Custom generate | `date_range`, `group_by`, `filters` |
| `finance_reports.exported` | Export | `format`, `report_type` |
| `finance_reports.saved_downloaded` | Re-download saved | `report_id`, `age_days` |
| `finance_reports.trust_filter_applied` | Trust filter | `included_classes` |
| `finance_reports.low_trust_warning` | Low trust shown | `trust_pct` |
| `finance_reports.line_item_drilled` | Row click | `line_item`, `amount` |

---

## 13. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/finance/reports/+page.svelte`
- **Server load**: `+page.server.ts` → `FinanceService/GetReportTemplates()` + `FinanceService/GetSavedReports()`
- **Report generation**: `FinanceService/GenerateReport(config)` → streaming response
- **P&L table**: `<CollapsibleTable>` component with hierarchical rows
- **Export CSV**: Client-side via `papaparse`
- **Export PDF**: Server-side `pdf-lib` with trust annotations
- **Google Sheets**: `FinanceService/ExportToSheets(report_id)` → Google Sheets API
- **Saved reports**: Cached 24h, auto-purged after 90d
- **Trust annotations**: Every line item shows S009 source class badge

---

## 14. Localization Notes

- Currency: VND — "45.200.000đ"
- Report period: "Tháng 3/2026", "Q1 2026"
- P&L terms: "Doanh thu", "COGS", "Lợi nhuận gộp", "Chi phí", "Lợi nhuận ròng"
- Trust: "🟢 Chính thức", "🟡 Nhập liệu", "⚪ Ước tính"
- Status: "Đang tạo", "Sẵn sàng", "Đã hết hạn"
- Tone: Formal, report-oriented

---

## 15. Design Tokens

| Token | Usage |
|---|---|
| `--color-revenue-line` | Revenue row (blue) |
| `--color-cost-line` | Cost row (red) |
| `--color-profit-line` | Net profit row (green, bold) |
| `--color-trust-official` | 🟢 Official badge |
| `--color-trust-imported` | 🟡 Imported badge |
| `--color-trust-estimated` | ⚪ Estimated badge |
| `--color-table-header` | Table header bg |
| `--color-table-total` | Total/subtotal row bg |
| `--color-surface-elevated` | Cards |

---

## 16. Related Screens

| Screen | Relationship |
|---|---|
| [W081] Profit Dashboard | Financial overview |
| [W082] Revenue Detail | Revenue line item drill-down |
| [W083] Cost Detail | Cost line item drill-down |
| [W084] Reconciliation | Fix trust gaps before reporting |

---

## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (low trust, large dataset), 5 errors (Sheets auth, gen timeout), P&L/coverage a11y, 8 analytics, SvelteKit impl (streaming gen, Sheets API), localization, 9 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
