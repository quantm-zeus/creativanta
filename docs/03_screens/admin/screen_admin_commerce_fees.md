# Screen: Admin — Commerce Fee Configuration

> **Screen ID**: A020
> **Module**: Admin — Commerce Operations (S26)
> **Route**: `/admin/commerce/fees`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: Product Freeze §24 (Monetization), A1 Schema (fee_config, fee_rules, fee_history), B5 RBAC §3 (Admin 8-role)

---

## 1. Purpose & Context

The Commerce Fee Configuration screen manages platform commission fees — the revenue Creativanta earns from commerce transactions processed through the platform. Admins configure per-plan, per-channel fee percentages, fee caps, promotional overrides, and effective date ranges. Includes a revenue impact simulation tool to preview financial effects of fee changes before applying them.

### User Goals
- Configure and update platform fee percentages per subscription plan
- Set channel-specific fee overrides (e.g., reduced fee for TikTok Shop promotions)
- Create time-limited promotional fee rules
- Simulate revenue impact of proposed fee changes before committing
- View fee change history for audit compliance

### Business Goals
- Optimize platform revenue through data-driven fee structure
- Support promotional strategies with time-limited fee adjustments
- Maintain audit trail for all fee changes (compliance)
- Prevent accidental fee misconfiguration through simulation and approval

### When This Screen Is Used
- Quarterly: Review and adjust fee structure based on competitive analysis
- Promotional: Set temporary 0% or reduced fees for platform acquisition campaigns
- On-demand: Investigate fee-related support tickets or disputes

### Entry Points
- Admin sidebar: "💰 Commerce" → "Fee Configuration"
- Admin Dashboard (A001): Revenue widget → "Configure fees"
- Commerce Overview (A018): "Fee rules" link

### Exit Points
- Self-contained (fee management is complete within this screen)
- "View revenue impact" → Revenue Dashboard (A022)
- "View audit trail" → Audit Log (A010) filtered to fee changes

---

## 2. Preconditions / Postconditions

### Preconditions
- Admin on VPN with MFA verified
- Role: Super Admin or Finance Admin (fee management)
- Tech Admin may view but not edit

### Postconditions
- Fee rule change logged in `admin_audit_log` with admin ID, old value, new value, reason
- Active fee rules immediately applied to new transactions (no retroactive)
- Revenue impact simulation data is ephemeral (not persisted)

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 💰 Commerce Fee Configuration                       [+ Tạo rule mới]│
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Fee Summary Bar ────────────────────────────────────────────────┐ │
│ │ Active rules: 5 │ Promo rules: 1 │ Fee revenue (30d): 12.5M VND │ │
│ │ Avg fee rate: 2.3% │ Upcoming changes: 1 (effective 01/04)      │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ Tabs: [📋 Active Rules] [📅 Scheduled] [📜 History] [🧪 Simulate] │
│                                                                      │
│ ═══ Tab: Active Rules ═══                                            │
│ ┌─ Fee Rules Table ────────────────────────────────────────────────┐ │
│ │ Plan     │ Channel      │ Rate │ Cap      │ Effective  │ Status  │ │
│ │──────────│──────────────│──────│──────────│────────────│─────────│ │
│ │ Free     │ All          │ 5.0% │ 500K/mo  │ Always     │ 🟢 Act  │ │
│ │ Starter  │ All          │ 3.0% │ 1M/mo    │ Always     │ 🟢 Act  │ │
│ │ Pro      │ All          │ 1.5% │ None     │ Always     │ 🟢 Act  │ │
│ │ Business │ All          │ 1.0% │ None     │ Always     │ 🟢 Act  │ │
│ │ Enterpr. │ All          │ Custom│ Custom  │ Per-contract│ 🟢 Act  │ │
│ │ (Promo)  │ TikTok Shop  │ 0.0% │ —       │ → 31/03/26│ 🟡 Exp  │ │
│ │──────────│──────────────│──────│──────────│────────────│─────────│ │
│ │ Per-row: [✏ Edit] [⏸ Deactivate] [📋 Duplicate] [🗑 Delete]    │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Revenue Impact Preview ─────────────────────────────────────────┐ │
│ │ Current fee revenue (30d): 12.5M VND                              │ │
│ │ Base fee revenue (no cap): 15.2M VND · Cap savings to users: 2.7M │ │
│ │ Promo cost (0% TikTok): -1.5M/mo estimated revenue loss          │ │
│ │ [🧪 Open Full Simulator →]                                       │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ═══ Tab: Simulate (when active) ═══                                  │
│ ┌─ Revenue Impact Simulator ──────────────────────────────────────┐ │
│ │ Scenario: "What if Pro fee → 2%?"                                │ │
│ │ ┌────────────────────────────────────────────────────────────┐   │ │
│ │ │ Plan: [Pro ▾]  New Rate: [2.0%]  New Cap: [None ▾]       │   │ │
│ │ │ Duration: [Permanent ▾]  Start: [2026-04-01]              │   │ │
│ │ │                                                            │   │ │
│ │ │ [🧪 Simulate Impact]                                      │   │ │
│ │ └────────────────────────────────────────────────────────────┘   │ │
│ │                                                                  │ │
│ │ ┌─ Simulation Results ──────────────────────────────────────┐   │ │
│ │ │ Current monthly fee revenue (Pro users): 8.2M VND         │   │ │
│ │ │ Projected with 2% rate:                  10.9M VND        │   │ │
│ │ │ Delta:                                   +2.7M VND (+33%) │   │ │
│ │ │                                                            │   │ │
│ │ │ Affected workspaces: 342 Pro workspaces                    │   │ │
│ │ │ Estimated churn risk: Low (rate still below competitor)    │   │ │
│ │ │                                                            │   │ │
│ │ │ ┌─ Chart ─────────────────────────────────┐               │   │ │
│ │ │ │ [Fee Revenue Trend: 12-month projection]│               │   │ │
│ │ │ │ Current ── /  Proposed ••••              │               │   │ │
│ │ │ └────────────────────────────────────────┘               │   │ │
│ │ │                                                            │   │ │
│ │ │ [✅ Apply This Rule] [📋 Save as Draft] [🗑 Discard]    │   │ │
│ │ └────────────────────────────────────────────────────────────┘   │ │
│ └──────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
AdminFeeConfigPage
├── AdminShell
├── PageHeader
│   ├── PageTitle ("💰 Commerce Fee Configuration")
│   └── CreateRuleButton ("+ Tạo rule mới", opens modal)
├── FeeSummaryBar
│   ├── ActiveRuleCount
│   ├── PromoRuleCount
│   ├── FeeRevenue30d (VND formatted)
│   ├── AvgFeeRate (percentage)
│   └── UpcomingChangesCount
├── TabView
│   ├── ActiveRulesTab
│   │   ├── FeeRulesTable
│   │   │   ├── ColumnHeaders (Plan, Channel, Rate, Cap, Effective, Status)
│   │   │   └── FeeRuleRow[]
│   │   │       ├── PlanBadge (color-coded per plan)
│   │   │       ├── ChannelLabel ("All" or specific platform)
│   │   │       ├── RateValue (percentage, 2 decimal)
│   │   │       ├── CapValue (VND or "None")
│   │   │       ├── EffectiveRange (date range or "Always")
│   │   │       ├── StatusBadge (🟢 Active / 🟡 Expiring / ⏰ Scheduled / ⚫ Inactive)
│   │   │       └── RowActions
│   │   │           ├── EditButton → opens FeeRuleModal
│   │   │           ├── DeactivateButton → confirm dialog
│   │   │           ├── DuplicateButton → opens modal pre-filled
│   │   │           └── DeleteButton → confirm dialog
│   │   └── RevenueImpactPreview
│   │       ├── CurrentRevenue
│   │       ├── BaseRevenue (no caps)
│   │       ├── PromoCost
│   │       └── OpenSimulatorLink
│   ├── ScheduledTab
│   │   └── ScheduledRulesTable (same structure, filtered to scheduled)
│   ├── HistoryTab
│   │   └── FeeChangeHistory (audit log)
│   │       ├── ChangeRow[]
│   │       │   ├── Timestamp
│   │       │   ├── AdminName
│   │       │   ├── Action (created/updated/deleted/activated/deactivated)
│   │       │   ├── OldValue → NewValue (diff view)
│   │       │   └── Reason
│   │       └── DateRangeFilter
│   └── SimulateTab
│       ├── SimulationForm
│       │   ├── PlanSelector
│       │   ├── NewRateInput (percentage)
│       │   ├── NewCapInput (VND or "None")
│       │   ├── DurationSelector (Permanent / Until date)
│       │   ├── StartDatePicker
│       │   └── SimulateButton
│       └── SimulationResults (conditional — after simulation)
│           ├── CurrentRevenue
│           ├── ProjectedRevenue
│           ├── Delta (amount + percentage)
│           ├── AffectedWorkspaces
│           ├── ChurnRiskAssessment
│           ├── ProjectionChart (12-month line chart: current vs proposed)
│           └── ActionBar
│               ├── ApplyRuleButton
│               ├── SaveDraftButton
│               └── DiscardButton
└── FeeRuleModal (create/edit, conditional)
    ├── PlanSelector (required)
    ├── ChannelSelector ("All" or specific platform)
    ├── RateInput (percentage, 0-100)
    ├── CapToggle (has cap / no cap)
    ├── CapAmountInput (if cap enabled, VND)
    ├── EffectiveFrom (date picker)
    ├── EffectiveTo (date picker, optional — "Always" if empty)
    ├── ReasonInput (required, textarea)
    ├── PreviewImpact (auto-calculated)
    └── SaveButton / CancelButton
```

---

## 5. Displayed Data

| Element | Source | API | Display Format |
|---|---|---|---|
| Fee rules | `fee_rules` table | `AdminFeeService/ListRules` | Table rows |
| Fee revenue (30d) | `orders` aggregation × fee rate | `AdminFeeService/GetRevenueStats` | VND formatted |
| Average fee rate | Weighted average across active plans | computed | "2.3%" |
| Change history | `admin_audit_log WHERE entity_type='fee_rule'` | `AdminFeeService/GetHistory` | Timestamped log |
| Simulation results | Computed on-demand | `AdminFeeService/SimulateImpact(params)` | Amounts + percentages |
| Projection chart | 12-month extrapolation | computed from simulation | Line chart |

---

## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Permission |
|---|---|---|---|---|---|---|
| 1 | Create rule | "+ Tạo rule mới" → fill modal → Save | Create | `AdminFeeService/CreateRule(params)` | Modal → toast "Rule đã tạo" → table updated | `admin:fee_schedule:manage` |
| 2 | Edit rule | "✏ Edit" → modify modal → Save | Update | `AdminFeeService/UpdateRule(id, params)` | Modal → toast "Rule đã cập nhật" | `admin:fee_schedule:manage` |
| 3 | Deactivate rule | "⏸" → confirm | Update | `AdminFeeService/DeactivateRule(id, reason)` | Confirmation → status → ⚫ | `admin:fee_schedule:manage` |
| 4 | Delete rule | "🗑" → confirm | Destructive | `AdminFeeService/DeleteRule(id, reason)` | Double confirmation → row removed | `admin:fee_schedule:manage` (Super + Finance only) |
| 5 | Duplicate rule | "📋" → pre-filled modal | Create | — (opens create modal with copied values) | Modal opens pre-filled | `admin:fee_schedule:manage` |
| 6 | Run simulation | Fill params → "🧪 Simulate" | Compute | `AdminFeeService/SimulateImpact(params)` | Results panel updates with projections | `admin:fee_schedule:manage` or `admin:analytics:read` |
| 7 | Apply simulated rule | "✅ Apply" → confirm | Create | `AdminFeeService/CreateRule(from_simulation)` | Confirmation → rule created → tab switches to Active | `admin:fee_schedule:manage` |
| 8 | View history | Click "📜 History" tab | Navigate | `AdminFeeService/GetHistory(date_range)` | History log loads | `admin:fee_schedule:manage` or `admin:audit_log:read` |
| 9 | Export history | Export button in History tab | Export | Client CSV generation | CSV download | `admin:report:export` |

---

## 7. Validation Rules

### Fee Rule (Create/Edit)
| Field | Rule | Error |
|---|---|---|
| Plan | Required, must be valid plan type | "Chọn gói subscription" |
| Channel | Required ("All" or specific platform) | "Chọn kênh áp dụng" |
| Rate | Required, 0.0-100.0, 2 decimal max | "Tỉ lệ phí phải từ 0% đến 100%" |
| Cap amount | If cap enabled: required, >0, max 100M VND | "Số tiền cap phải từ 1 đến 100,000,000 VND" |
| Effective from | Required, cannot be in the past (for new rules) | "Ngày hiệu lực phải từ hôm nay trở đi" |
| Effective to | If set: must be after Effective from | "Ngày kết thúc phải sau ngày bắt đầu" |
| Reason | Required, min 10 chars | "Vui lòng nhập lý do thay đổi" |
| No duplicate | Cannot create rule with same plan+channel+date overlap | "Đã có rule cho plan + channel + thời gian này" |

### Simulation
| Field | Rule | Error |
|---|---|---|
| Rate | Required, 0-100 | "Nhập tỉ lệ phí hợp lệ" |
| Plan | Required | "Chọn plan để simulate" |

---

## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial page load | Table skeleton + stats shimmer | Wait |
| LOADED | Data received | Full table + stats bar | Interact normally |
| CREATING | Create modal open | Modal overlay | Fill form → Save |
| EDITING | Edit modal open | Modal overlay with pre-filled data | Modify → Save |
| SAVING | Form submitted | Modal save button shows spinner | Wait |
| SAVED | Rule saved successfully | Toast "Rule đã lưu" → modal closes → table refreshes | Continue |
| SIMULATING | Simulation running | Simulate button shows spinner | Wait |
| SIMULATED | Simulation complete | Results panel with projections + chart | Review results |
| DELETING | Delete confirmation | Confirmation dialog with reason field | Confirm or cancel |
| ERROR | API failed | Error toast, form remains open for retry | Retry |

---

## 9. Permissions & Role-based Behavior (Admin 8-Role per B5 §3)

| Feature | Super | Ops | Finance | Content | Support | Tech | Analyst | Auditor |
|---|---|---|---|---|---|---|---|---|
| View fee rules | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ✅ |
| Create/edit rules | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Delete rules | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Run simulations | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ |
| Apply simulated rule | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| View history | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ✅ |
| Export | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ | ✅ |

### Visibility Rules
- **Analyst/Auditor**: Can view rules and history (read-only). All action buttons hidden.
- **Operations Admin**: Can view and simulate but cannot create/edit/delete fee rules.
- **All other roles**: No access to this page → redirect to admin dashboard.

---

## 10. Edge Cases

| Edge Case | Handling |
|---|---|
| Two rules for same plan+channel overlap in time | Server rejects: "Đã có rule chồng lịch. Điều chỉnh ngày hoặc deactivate rule cũ." |
| Deleting the only active rule for a plan | Warning: "Plan Free sẽ không có fee rule. Giao dịch sẽ áp dụng default rate 0%." |
| Promo rule expires during high-traffic period | System auto-deactivates at expiry time. Dashboard alert: "Promo rule cho TikTok Shop đã hết hạn." |
| Fee rate change affects in-progress orders | Fee applied at order creation time, not settlement — no retroactive changes |
| Enterprise custom rate | Show "Custom" in rate column. Edit opens negotiation note field instead of rate input. |
| Simulation with 0% fee | Show clear warning: "Tỉ lệ 0% nghĩa là không thu phí. Ước tính mất: {amount}/tháng." |
| History has >1000 entries | Paginated with date range filter |

---

## 11. Navigation Map

```
Admin Fee Config (/admin/commerce/fees)
├── → /admin/commerce (breadcrumb)
├── → /admin/revenue (via "View revenue impact")
├── → /admin/audit (via "View audit trail" in History tab)
├── → /admin (breadcrumb → Admin Dashboard)
```

---
## 5. Data Binding & Display Format
*(Refer to screen-specific data binding in section above)*


---
## 19. Related Screens

| Screen | Relationship |
|---|---|
| [A001] Admin Dashboard | Parent, revenue widget links here |
| [A018] Commerce Overview | Commerce stats context |
| [A022] Revenue Dashboard | Revenue impact of fee changes |
| [A010] Audit Log | Fee change history |
---
## Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached data | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được dữ liệu. [Thử lại]" | Retry |
| Not found | 404 | "Không tìm thấy" → navigate back | Back |
| Permission denied | 403 | "Không có quyền truy cập" | Contact admin |

---
## Accessibility

| Element | Requirement |
|---|---|
| Interactive elements | Minimum 48×48dp tap targets |
| Icons with meaning | `Semantics(label:)` descriptive text |
| Status indicators | Color not sole indicator; text/icon also present |
| Dynamic content | `Semantics(liveRegion: true)` for updates |
| Contrast | 4.5:1 minimum ratio |

---
## Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + shimmer placeholders |
| Primary data | 200-500ms | Content populates progressively |
| User action | <1s | Inline spinner → result feedback |

---
## Localization Notes

- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator: "1.200.000đ")
- Date: DD/MM/YYYY
- Numbers: dot separator (1.234)
- Relative time: "2 giờ trước", "1 ngày trước"
- Tone: Friendly, action-oriented

---
## Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Primary actions, CTAs |
| `--color-success` | Positive states, confirmations |
| `--color-warning` | Warning indicators |
| `--color-danger` | Error states, destructive actions |
| `--color-surface-elevated` | Cards, elevated surfaces |

---
## Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | Patch | Removed duplicate template sections. Replaced with screen-specific Error Handling, Accessibility, Loading, Localization, Design Tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
