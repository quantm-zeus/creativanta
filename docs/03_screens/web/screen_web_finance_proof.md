# Screen: Web — Proof Browser

> **Screen ID**: W085
> **Module**: M19 — Operating Ledger (Proof Chain)
> **Route**: `/finance/proof`
> **Platform**: Web (SvelteKit)
> **Upstream**: PRD §33 Profit OS (§33.5 Proof Chain), A1 Schema (proof_bundles, proof_items, billing_events), B5 RBAC §2.8

---
## 1. Purpose & Context

Browse and verify proof bundles — evidence objects that support financial claims. This is the trust accountability layer of Profit OS: every financial number (revenue, cost, profit) must trace back to proof items. Proof bundles group evidence by period and claim type, showing coverage gaps and confidence levels.

### User Goals
- Verify that financial numbers are backed by real evidence
- Identify gaps in proof coverage (unmatched orders, missing settlements)
- Understand confidence level of financial statements
- Export proof bundles for accounting or audit purposes

### Business Goals
- Ensure financial transparency and accuracy (PRD §33.5)
- Enable trust-based financial reporting where users understand data provenance
- Reduce reconciliation errors by surfacing gaps proactively
- Support potential audit or tax review with exportable evidence

### Entry Points
- Finance Dashboard (W081): "📋 Proof" card or trust badge → drill in
- Reconciliation Center (W084): "View proof" link
- Any Trust Badge (S009): "Why this number?" → "View supporting proof" link
- Sidebar: Finance → "📋 Proof Browser"

### Exit Points
- Click evidence item → Source document (settlement file, order, receipt)
- Click gap → Reconciliation Center (W084) to fix
- Export → PDF bundle download

---
## 2. Preconditions / Postconditions

### Preconditions
- User has `profit:read` permission (Owner, Admin)
- Financial data exists (orders, settlements, cost entries)

### Postconditions
- No data mutations (read-only + export only)
- Export events logged for audit trail

---
## 3. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Finance   📋 Proof Browser                   [Period: Mar 2026 ▾]│
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Proof Overview ──────────────────────────────────────────────┐   │
│ │ 📊 Coverage: 85% [████████████████░░░]                        │   │
│ │ Confidence: [Medium-High ■■■■■■■■■░░░]                        │   │
│ │ Evidence items: 45 (34 Official, 8 Imported, 3 Estimated)     │   │
│ │ Gaps: 5 items need attention                                   │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Proof Bundle: Revenue Claim ─────────────────────────────────┐   │
│ │ 📋 "March 2026 Revenue = 45,200,000 VND"                      │   │
│ │ Coverage: 92% · Confidence: High                               │   │
│ │                                                                  │   │
│ │ ✅ Evidence (supporting):                                       │   │
│ │   🟢 24× TikTok Shop settlement records (25,180,000đ)          │   │
│ │   🟢 18× Shopee settlement records (15,020,000đ)               │   │
│ │   🔵 3× Manual order records (5,000,000đ)                     │   │
│ │                                                                  │   │
│ │ ⚠️ Gaps (not yet covered):                                     │   │
│ │   ❓ 3 TikTok settlements pending (est. 2,800,000đ)           │   │
│ │   ❓ 2 orders without settlement match                         │   │
│ │                                                                  │   │
│ │ [🔍 View all items] [📥 Export PDF] [→ Fix gaps]              │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Proof Bundle: Cost Claim ────────────────────────────────────┐   │
│ │ 📋 "March 2026 Total Costs = 16,500,000 VND"                   │   │
│ │ Coverage: 78% · Confidence: Medium                              │   │
│ │                                                                  │   │
│ │ ✅ Evidence:                                                     │   │
│ │   🟢 Auto-calculated platform fees (8,500,000đ)                │   │
│ │   🟢 AI credit usage from system (2,100,000đ)                  │   │
│ │   🔵 4× Custom cost entries with receipts (800,000đ)           │   │
│ │                                                                  │   │
│ │ ⚠️ Gaps:                                                        │   │
│ │   ❓ COGS not entered for 12 products                          │   │
│ │   ❓ Ad spend for FB/IG not imported this month                │   │
│ │   ❓ 2 custom costs without receipts                            │   │
│ │                                                                  │   │
│ │ [🔍 View all items] [📥 Export]                                │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Proof Bundle: Profit Claim ──────────────────────────────────┐   │
│ │ 📋 "March 2026 Net Profit = 28,700,000 VND"                    │   │
│ │ Coverage: 72% · Confidence: Medium                              │   │
│ │ Derived from: Revenue (92%) - Costs (78%)                       │   │
│ │ ⚠️ "Profit confidence limited by cost coverage gaps"           │   │
│ │ [🔍 View all items] [📥 Export]                                │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ [📥 Export Full Proof Package (ZIP)]                                 │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
ProofBrowserPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Finance")
│   ├── PageTitle ("📋 Proof Browser")
│   └── PeriodSelector (monthly periods)
├── ProofOverviewCard
│   ├── CoverageBar (percentage + progress bar)
│   ├── ConfidenceBand (Medium-High etc. per S009)
│   ├── EvidenceBreakdown (by source class)
│   └── GapCount
├── ProofBundleList
│   └── ProofBundleCard[]
│       ├── ClaimStatement (bold — the financial claim being proved)
│       ├── CoveragePercentage + ConfidenceLevel
│       ├── EvidenceSection
│       │   └── EvidenceItem[]
│       │       ├── SourceClassIcon (🟢/🔵/🟡/🟣/⚪)
│       │       ├── Count + Description
│       │       └── Amount (VND)
│       ├── GapSection
│       │   └── GapItem[]
│       │       ├── GapIcon (❓)
│       │       ├── Description
│       │       └── EstimatedAmount (if applicable)
│       └── ActionBar
│           ├── ViewAllItemsButton (expand full evidence list)
│           ├── ExportPDFButton
│           └── FixGapsButton (→ Reconciliation W084)
├── ExportFullPackageButton ("📥 Export Full Proof Package")
└── EvidenceDrawer (opens on "View all items")
    ├── FilterableEvidenceList
    │   └── EvidenceRow[]
    │       ├── SourceClass Badge
    │       ├── Type (Settlement, Order, Receipt, Cost Entry)
    │       ├── Reference (ID / filename)
    │       ├── Amount
    │       ├── Date
    │       └── ViewSourceButton (link to original)
    └── CloseButton
```

---
## 5. Displayed Data

| Field | Source | Format | Description |
|---|---|---|---|
| Claim statement | `proof_bundles.claim_text` | Text | "March 2026 Revenue = 45.2M VND" |
| Coverage | `proof_bundles.coverage_pct` | "85%" + progress bar | % of claim backed by evidence |
| Confidence | Computed from coverage + source mix | Band name + bar | Overall confidence level |
| Evidence items | `proof_items[]` grouped by source class | Count + amount per class | Supporting evidence |
| Gaps | `proof_bundles.gaps[]` | Description + estimated amount | Missing proof items |
| Period | URL param or selector | "March 2026" | Reporting period |

---
## 6. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Change period | Period selector | `ProofService/GetBundles(period)` | All bundles update | `profit:read` |
| 2 | View all evidence | "🔍 View all items" | — | Evidence drawer opens | `profit:read` |
| 3 | View source document | Click evidence item | — | → Source (settlement PDF, order page, receipt) | `profit:read` |
| 4 | Fix gaps | "→ Fix gaps" | — | → Reconciliation Center (W084) | `profit:read` |
| 5 | Export bundle PDF | "📥 Export PDF" | `ProofService/ExportBundle` | PDF download | `profit:read` |
| 6 | Export full package | "📥 Full Package" | `ProofService/ExportFull` | ZIP with all PDFs + evidence | `profit:read` |

---
## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Overview shimmer + bundle card skeletons |
| LOADED | Data received | Proof bundles with evidence and gaps |
| EMPTY | No financial data for period | "Chưa có dữ liệu tài chính cho kỳ này." |
| ALL_COVERED | 100% coverage | Green celebration: "✅ Tất cả dữ liệu tài chính đã được chứng minh!" |
| GAPS_CRITICAL | Coverage < 50% | Red warning: "⚠️ Thiếu nhiều bằng chứng. Lợi nhuận có thể không chính xác." |
| ERROR | API failed | Error with retry |

---
## 8. Permissions

Only Owner and Admin can access Proof Browser (highly sensitive financial data).

| Feature | Owner | Admin | Manager | Editor+ |
|---|---|---|---|---|
| View proof | ✅ | ✅ | ❌ | ❌ |
| Export proof | ✅ | ✅ | ❌ | ❌ |
| View source docs | ✅ | ✅ | ❌ | ❌ |

---
## 9. Proof Coverage Logic

Coverage percentage is calculated as:

```
Coverage = (Sum of evidence-backed amounts) / (Claim total amount) × 100
```

- **100%**: All amounts in the claim have corresponding evidence items
- **80-99%**: Minor gaps (pending settlements, unmatched orders)
- **50-79%**: Significant gaps (missing imports, COGS not entered)
- **<50%**: Critical — financial numbers are mostly estimated

Confidence is derived from coverage + source class mix:
- 100% coverage + 100% Official → **High**
- 80%+ coverage + mostly Official → **Medium-High**
- 50-80% coverage or mixed sources → **Medium**
- <50% coverage → **Low**

---
## 10. Edge Cases

| Edge Case | Handling |
|---|---|
| 100% coverage all bundles | Green celebration: "🎉 Tuyệt vời! Tất cả dữ liệu tài chính đã được chứng minh." |
| Expired proof document | Badge: "🟠 Proof expired — cần tải lại chứng từ" |
| Cross-period claim (e.g., refund from prev month) | Note: "⚠️ Claim bao gồm mục từ kỳ trước" |
| No financial data for period | Empty: "Chưa có dữ liệu tài chính cho kỳ này." |
| Evidence item source deleted | Badge: "⚫ Nguồn không còn tồn tại" with original reference |

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" — no cached proof (privacy) | Retry online |
| Bundle fetch fail | API error | "Không tải được proof. [Thử lại]" | Retry |
| Evidence source unreachable | Linked settlement/order deleted | "⚠️ Nguồn chứng từ không khả dụng" | Show archived reference |
| Export bundle fail | PDF generation error | Toast: "Không xuất được. [Thử lại]" | Retry |
| Full package ZIP fail | Too many items / timeout | "Giảm khoảng thời gian hoặc export từng bundle." | Export separately |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Coverage bar | `role="progressbar"`, `aria-valuenow`, `aria-label="Độ phủ: {pct}%"` |
| Confidence band | `aria-label="Độ tin cậy: {level}"`, text label (not color-only) |
| Evidence items | `role="list"`, each item `aria-label="{source_class}: {count} mục, {amount}đ"` |
| Gap items | `role="list"`, `aria-label="Thiếu: {description}"` |
| Evidence drawer | `role="dialog"`, `aria-modal="true"`, focus trap |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Overview shimmer + bundle skeletons |
| Proof overview | 200-400ms | Coverage bar fills |
| Bundle cards | 400-800ms | Cards stagger in |
| Evidence drawer | 0ms | Instant overlay |
| Export | 2-10s | Progress bar |

---

## 14. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `finance_proof.viewed` | Page load | `period`, `coverage_pct`, `gap_count` |
| `finance_proof.period_changed` | Period selector | `from_period`, `to_period` |
| `finance_proof.bundle_expanded` | "View all items" | `bundle_type`, `coverage_pct` |
| `finance_proof.evidence_clicked` | Evidence item click | `evidence_type`, `source_class` |
| `finance_proof.gap_fix_clicked` | "Fix gaps" | `bundle_type`, `gap_count` |
| `finance_proof.bundle_exported` | Export PDF | `bundle_type` |
| `finance_proof.full_exported` | Export full package | `bundle_count` |
| `finance_proof.critical_coverage` | Coverage <50% warning | `coverage_pct` |

---

## 15. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/finance/proof/+page.svelte`
- **Server load**: `+page.server.ts` → `ProofService/GetBundles(period)` — aggregates proof_bundles + proof_items
- **Evidence drawer**: Svelte `slide` transition, filterable list with `EvidenceRow` component
- **Coverage bar**: CSS `linear-gradient` segmented by source class
- **Source badges**: S009 trust badge (`<TrustBadge source={item.source_class} />`)
- **Export PDF**: `pdf-lib` with inline evidence references
- **Full ZIP**: Server-side `ProofService/ExportFull` — streams ZIP download
- **No localStorage**: Proof data never cached client-side (privacy)

---

## 16. Design Tokens

| Token | Usage |
|---|---|
| `--color-proof-verified` | 🟢 Official/verified evidence |
| `--color-proof-imported` | 🔵 Imported evidence |
| `--color-proof-manual` | 🟡 Manual entry |
| `--color-proof-estimated` | ⚪ Estimated |
| `--color-proof-expired` | 🟠 Expired proof |
| `--color-confidence-high` | Confidence band: High |
| `--color-confidence-medium` | Confidence band: Medium |
| `--color-confidence-low` | Confidence band: Low |
| `--color-surface-elevated` | Cards |

---

## 17. Related Screens

| Screen | Relationship |
|---|---|
| [W081] Profit Dashboard | Financial overview |
| [W082] Revenue Detail | Revenue claim source |
| [W083] Cost Detail | Cost claim source |
| [W084] Reconciliation | Fix coverage gaps |
| [S009] Trust Badge | Source class taxonomy |

---

## 18. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 edge cases (100% celebration, expired proof), 5 errors, coverage/evidence a11y, 8 analytics, SvelteKit impl (ZIP export), 9 design tokens (confidence). | System |
| 2026-03-28 | 1.0 | Initial specification | System |
