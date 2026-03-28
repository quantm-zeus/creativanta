# Screen: Mobile — Reconciliation

> **Screen ID**: M044
> **Module**: M19 — Operating Ledger / Profit Graph / Proof Center
> **Route**: `/m/finance/reconcile`
> **Platform**: Mobile (Flutter)
> **Upstream**: Pack 06 §Commerce/Finance, Pack 01 §Trust UX, A1 Schema (reconciliation_records, evidence_objects), S009 Trust Badge, B5 RBAC §2.9

---

## 1. Purpose & Context

Mobile-optimized reconciliation interface using swipe-to-match interaction. Matches imported/estimated financial entries with official records to improve profit truth accuracy. Designed like a card-swiping interface (similar to approval queue) for fast processing.

### User Story
> As a seller, I want to quickly match my imported revenue data with official bank transfers so my profit calculations are trustworthy.

### Business Goal
- Improve workspace financial trust score (target: >90% Official/Verified)
- Close reconciliation gaps within 48h of data availability
- Surface reconciliation needs as actionable cards (not hidden reports)
- Support the Proof/Trust System with real evidence linkage

### When to Use
- Dashboard card: "⚠️ 5 entries cần reconcile" 
- Finance overview: "Trust: 82% — [Cải thiện →]"
- Morning Brief: "Có 3 giao dịch mới cần xác nhận"
- Push notification: "Revenue tuần trước chưa match. Xác nhận ngay."

### Entry Points
- Finance screen → "🔄 Reconcile" button/badge
- Dashboard alert: "⚠️ {n} entries need matching"
- Morning Brief finance section → "Reconcile" CTA
- Push notification → deep link

### Exit Points
- All reconciled → celebration empty state → back to Finance
- Back → Finance overview
- "Xem chi tiết" → open specific reconciliation record

---

## 2. Preconditions / Postconditions

### Preconditions
- User has `finance:reconcile` permission
- Unreconciled items exist (imported + estimated entries with no match)
- Connected commerce platform(s) for import data

### Postconditions
- Reconciliation record updated: `status = fully_reconciled` / `partially_reconciled`
- Source class upgraded: Imported → Official, Estimated → Confirmed
- Profit snapshots recalculated with improved accuracy
- Trust score updated
- Evidence object created linking match
- Audit event: `finance.reconciled`

---

## 3. Layout Structure

### ASCII Wireframe
```
┌─ Status Bar ─────────────────────────────────────────────────────────┐
│ ← Reconciliation                                    [📊 Tổng quan]  │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ ┌─ Trust Improvement Preview ─────────────────────────────────────┐  │
│ │ 📊 Trước: 🟡 82% Official                                      │  │
│ │ 📊 Sau khi hoàn tất: 🟢 89% Official (+7pp)                    │  │
│ │ ███████████████████████████████░░░░░░░░  82% → 89%              │  │
│ │                                                                 │  │
│ │ 📋 Items pending: 5     💰 Total: 23.500.000đ                  │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ Segments: [Tất cả (5)] [💰 Revenue (3)] [📦 Costs (2)]             │
│                                                                       │
│ ┌─ Reconcile Card — Auto-Match (High Confidence) ─────────────── ┐  │
│ │ 🟡 IMPORTED                                                     │  │
│ │ 💰 Brand deal "Serum review"                                    │  │
│ │ Số tiền: 12.000.000đ · Ngày: 12/03/2026                        │  │
│ │                                                                 │  │
│ │ 🔗 Gợi ý match:                                                │  │
│ │ 🟢 Chuyển khoản NH · 12/03 · 12.000.000đ                       │  │
│ │ Confidence: ████████████████████████████ 95% ✅                  │  │
│ │                                                                 │  │
│ │ ← ❌ Sai match      [👁 Chi tiết]      ✅ Xác nhận →           │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Reconcile Card — Partial Match (Medium Confidence) ──────────┐  │
│ │ 🟡 IMPORTED                                                     │  │
│ │ 📦 Shopee settlement T2/2026                                    │  │
│ │ Số tiền: 8.500.000đ · Ngày: 01/03/2026                         │  │
│ │                                                                 │  │
│ │ 🔗 Gợi ý match:                                                │  │
│ │ 🟡 Chuyển khoản NH · 03/03 · 8.200.000đ                        │  │
│ │ ⚠️ Chênh lệch: 300.000đ (3.5%)                                │  │
│ │ Confidence: ██████████████████░░░░░░░░░░ 72%                    │  │
│ │                                                                 │  │
│ │ ← ❌ Sai   [📝 Điều chỉnh]   [👁 Chi tiết]   ✅ Chấp nhận → │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Reconcile Card — No Match ─────────────────────────────────── ┐  │
│ │ ⬜ ESTIMATED                                                    │  │
│ │ 📊 Platform revenue estimate — 5.500.000đ                       │  │
│ │ Ngày: 28/02/2026 · Nguồn: Shopee API                           │  │
│ │                                                                 │  │
│ │ ❌ Không tìm thấy match tự động                                 │  │
│ │                                                                 │  │
│ │ [📸 Scan bank statement]    [📝 Nhập thủ công]    [⏭ Bỏ qua]  │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ Pull-to-refresh ↻                                                    │
├──────────────────────────────────────────────────────────────────────┤
│ [🏠] [📋] [➕] [💬] [👤]                                            │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
ReconciliationScreen
├── AppBar
│   ├── BackButton
│   ├── Title ("Reconciliation")
│   └── OverviewButton (📊 → summary stats)
├── TrustImprovementCard
│   ├── BeforeScore (current %)
│   ├── AfterScore (projected %)
│   ├── ImprovementBadge (+Npp)
│   ├── ProgressBar (dual: current + projected)
│   ├── PendingCount
│   └── TotalAmount
├── SegmentBar
│   ├── AllSegment
│   ├── RevenueSegment
│   └── CostsSegment
├── ReconcileList (scrollable, pull-to-refresh)
│   └── SwipeableReconcileCard[]
│       ├── SourceClassBadge (🟡 Imported / ⬜ Estimated / 🔴 Unreconciled)
│       ├── EntryTypeIcon + EntryTitle
│       ├── AmountDisplay (formatted VND)
│       ├── DateDisplay
│       ├── MatchSuggestion (conditional — if match found)
│       │   ├── MatchIcon (🟢 bank transfer / 📦 settlement)
│       │   ├── MatchDetails
│       │   ├── DiscrepancyWarning (if amounts differ)
│       │   └── ConfidenceBar (0-100% with color)
│       ├── NoMatchView (conditional — if no match)
│       │   ├── ScanBankStatementButton
│       │   ├── ManualEntryButton
│       │   └── SkipButton
│       └── SwipeActions
│           ├── LeftAction (❌ Wrong match / Skip — red)
│           └── RightAction (✅ Accept match — green)
├── ManualMatchBottomSheet (conditional)
│   ├── Title ("Nhập match thủ công")
│   ├── AmountInput
│   ├── DateInput
│   ├── ReferenceInput (bank ref / receipt #)
│   ├── AttachmentButton (bank statement / receipt)
│   └── ConfirmButton
├── DiscrepancyBottomSheet (conditional — when amounts differ)
│   ├── OriginalAmount
│   ├── MatchedAmount
│   ├── Difference + Percentage
│   ├── ReasonSelector
│   │   ├── "Phí nền tảng"
│   │   ├── "Phí giao hàng"
│   │   ├── "Chiết khấu"
│   │   └── "Khác"
│   └── AcceptWithDiscrepancyButton
├── EmptyState (conditional — all reconciled)
│   ├── CelebrationIllustration
│   ├── Message ("🎉 Hoàn tất! Trust score: 89%")
│   └── ViewFinanceButton
└── BottomNavBar (shared)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Trust score (before) | `workspace.trust_score` | `TrustService/GetScore` | "82%" + progress bar | 5m TTL |
| Trust score (after) | Projected from pending items | same | "89%" + projected bar | Computed |
| Pending items | `reconciliation_records WHERE status IN (awaiting, imported_only, inferred)` | `ReconciliationService/ListPending` | Card list | No cache |
| Match suggestions | AI-matched records | `ReconciliationService/GetSuggestions(id)` | Match card with confidence | No cache |
| Amount | `reconciliation_records.amount` | same | VND formatted (12.000.000đ) | No cache |
| Confidence | Match confidence score | same | Percentage + color bar | No cache |
| Discrepancy | Computed (entry - match) | Client | Amount + "3.5%" | Computed |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Accept match | Swipe right on card (+haptic) | `ReconciliationService/Confirm(id, match_id)` | `status = fully_reconciled`, source class → Official | Card slides off + trust score animates up + count decreases | `finance:reconcile` |
| 2 | Reject match | Swipe left on card | `ReconciliationService/RejectMatch(id, match_id)` | Match removed from suggestions | Card stays, "Searching for alternative..." or manual entry prompt | `finance:reconcile` |
| 3 | View detail | Tap "👁 Chi tiết" | — | — | Open ReconciliationDetailBottomSheet | `finance:read` |
| 4 | Manual match | Tap "📝 Nhập thủ công" | — | — | Open ManualMatchBottomSheet | `finance:reconcile` |
| 5 | Confirm manual match | Submit manual match form | `ReconciliationService/ManualMatch(id, data)` | `status = fully_reconciled` | Card removed + toast | `finance:reconcile` |
| 6 | Scan bank statement | Tap "📸 Scan" | Camera → `AIService/ScanBankStatement` | — | AI extracts amount/date → auto-fills manual match | `finance:reconcile` |
| 7 | Accept with discrepancy | Confirm in discrepancy sheet | `ReconciliationService/ConfirmWithDiscrepancy(id, reason)` | `status = partially_reconciled` | Card removed + toast with warning | `finance:reconcile` |
| 8 | Skip item | Tap "⏭ Bỏ qua" | `ReconciliationService/Skip(id)` | Item moves to skipped (temporary) | Card fades + toast "Đã bỏ qua. Sẽ hiện lại sau 7 ngày." | `finance:reconcile` |
| 9 | Adjust entry | Tap "📝 Điều chỉnh" on partial match | — | — | Open amount adjustment input | `finance:reconcile` |
| 10 | Pull to refresh | Pull down gesture | `ReconciliationService/ListPending` | — | List refreshes + trust score updates | `finance:reconcile` |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching pending items | Shimmer trust card + skeleton cards |
| LOADED | Items pending | Trust preview + reconcile cards sorted by confidence |
| ALL_RECONCILED | Zero pending | 🎉 Celebration: "Tất cả đã reconcile! Trust: {score}%" |
| MATCHING | Swipe confirm in progress | Card animates out + trust bar animates |
| PARTIAL_MATCH | Discrepancy detected | Discrepancy bottom sheet opens |
| MANUAL_ENTRY | No auto-match | Manual match bottom sheet |
| SCANNING | Bank statement scan in progress | Camera → "🤖 Đang đọc..." |
| ERROR | API failure | Toast: "Không thể xác nhận. Thử lại." |
| OFFLINE | No network | Banner: "Đang offline. Reconciliation cần kết nối mạng." |
| STALE_DATA | Data >1h old | Warning: "Dữ liệu có thể đã cũ. [🔄 Làm mới]" |

---

## 8. Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Manual match amount | Required, > 0 | "Vui lòng nhập số tiền" |
| Manual match date | Required, ≤ today | "Ngày không hợp lệ" |
| Manual match reference | Recommended (not required) | Warning: "Nên nhập mã tham chiếu để dễ tracking" |
| Discrepancy acceptance | Must select reason | "Vui lòng chọn lý do chênh lệch" |
| Discrepancy threshold | Auto-accept if <1%, warn if 1-5%, block if >5% | ">5%: Chênh lệch quá lớn. Vui lòng kiểm tra kỹ." |

---

## 9. Permission Matrix

| Action | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View reconciliation | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Accept/reject match | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Manual match | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Skip item | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Adjust amounts | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |

---

## 10. Navigation Map

```
Reconciliation (/m/finance/reconcile)
├── → ReconciliationDetailBottomSheet (via "Chi tiết")
├── → ManualMatchBottomSheet (via "Nhập thủ công")
├── → DiscrepancyBottomSheet (via partial match)
├── → Camera (via "Scan bank statement")
├── → /m/finance (on all reconciled or back)
└── ← /m/finance (via back button)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network error | No connectivity | Banner: "Cần kết nối mạng để reconcile." | Auto-retry when online |
| Confirm failed | API error | Toast + card returns to position | Re-swipe to retry |
| Stale match | Data changed since suggestion | "Match đã thay đổi. [Làm mới]" | Refresh card |
| Bank scan failed | OCR error | "Không đọc được. Nhập thủ công." | Switch to manual |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Swipe actions | Tap fallback buttons for reduced-motion |
| Confidence bar | Number + color (not color alone) |
| Trust improvement | Announced: "Trust score sẽ tăng từ 82% lên 89%" |
| Cards | Full label: "Brand deal Serum review, 12 triệu đồng, nguồn Imported, cần xác nhận" |
| Amount discrepancy | Clearly announced: "Chênh lệch 300 nghìn đồng, tức 3.5%" |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | Shimmer + skeleton |
| Data fetch | 300-800ms | Trust card populates → cards animate in (stagger) |
| Match confirm | 200ms | Card slides off + trust bar smoothly updates |
| Bank scan | 2-5s | Camera → processing overlay |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Screen render | <1.5s |
| Swipe response | <100ms |
| Match confirmation | <500ms |
| Trust score recalc | <1s (done server-side, pushed to client) |

---

## 15. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| New unreconciled items | SSE `/events/reconciliation` | Real-time |
| Trust score | SSE `/events/trust` | On-change |

---

## 16. Localization Notes

- Currency: VND only (no decimals)
- Percentages: Vietnamese locale (")
- Source class badges: use canonical colors (🟢 Official, 🟡 Imported, ⬜ Estimated, 🔴 Unreconciled)
- Tone: Precise, trustworthy, not alarming

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `reconciliation.viewed` | Screen load | `pending_count`, `current_trust_score` |
| `reconciliation.confirmed` | Accept match | `entry_type`, `confidence`, `discrepancy_pct` |
| `reconciliation.rejected` | Reject match | `entry_type`, `confidence` |
| `reconciliation.manual_match` | Manual match submitted | `entry_type`, `has_attachment` |
| `reconciliation.skipped` | Skip item | `entry_type` |
| `reconciliation.completed` | All items done | `new_trust_score`, `items_processed` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-source-official` | 🟢 Official badge/bar |
| `--color-source-imported` | 🟡 Imported badge/bar |
| `--color-source-estimated` | ⬜ Estimated badge/bar |
| `--color-source-unreconciled` | 🔴 Unreconciled badge/bar |
| `--color-success` | Accept swipe background, trust improvement |
| `--color-danger` | Reject swipe background |
| `--color-warning` | Discrepancy warning |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W084] Web Reconciliation Center | Web equivalent (full-featured table view) |
| [W085] Web Proof Browser | Linked — proof bundles from reconciliation |
| [M040] Mobile Finance | Parent screen |
| [M041] Mobile Finance Summary | Updated after reconciliation |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | Full 20-point upgrade from 63-line Tier C. Added trust improvement preview with animated progress bar, 3 card types (auto-match/partial/no-match), discrepancy handling with threshold rules, bank statement scanning, manual match form, skip with re-surface logic, 10 actions, 10 states, canonical source class colors, full evidence/proof integration. Fixed Screen ID (M036→M044). | System |
| 2026-03-28 | 2.0 | Expanded from sparse | System |
| 2026-03-28 | 1.0 | Initial specification | System |
