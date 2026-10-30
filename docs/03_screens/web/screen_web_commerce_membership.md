# Screen: Web — Membership Plans

> **Screen ID**: W071
> **Module**: M15 — see canonical feature owner in screen_task_map.csv
> **Route**: `/memberships`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 06 §9, A1 Schema (membership_plans, membership_subscriptions, membership_benefits, subscription_invoices, membership_content), B5 RBAC §2.7

---

## 1. Purpose & Context

Membership Plans is the creator's subscription management dashboard — create and manage paid membership tiers for audiences. Supports custom pricing, drag-sortable benefits, subscriber lifecycle management, MRR/churn analytics, and multi-provider billing (Stripe, VNPay). This is a recurring revenue engine that complements one-time product sales.

### User Goals
- Create subscription plans with tiered pricing and exclusive benefits
- Monitor subscriber count, MRR growth, and churn rate
- Manage individual subscriber statuses (active, trial, cancelled)
- Track trial-to-paid conversion rates
- Understand subscriber LTV (Lifetime Value)

### Business Goals
- Generate predictable recurring revenue
- Increase creator stickiness through membership management tools
- Support flexible billing (monthly, quarterly, yearly) with multiple payment gateways
- Track LTV/churn for financial planning and Proof Graph integration (M19)

### When This Screen Is Used
- Launching: Creator sets up first membership tier
- Monitoring: Daily/weekly MRR and subscriber count check
- Optimizing: Analyzing churn and benefit effectiveness
- Managing: Handling subscriber inquiries, cancellations, refunds

### Entry Points
- Sidebar: Commerce → "🎖 Thành viên"
- Home Dashboard (W001): MRR widget click
- Creator Pro (W088): Membership revenue row
- AI Copilot: "Tạo gói thành viên VIP 199K/tháng"

### Exit Points
- Click subscriber count → Subscriber List sub-view
- Click "📊 Analytics" → Membership Analytics
- Click "✏ Edit" → Plan edit form
- "Tạo gói mới" → Create plan modal

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid workspace session
- User has `membership:read` permission (Manager+ for financial data)
- Billing provider connected (Stripe or VNPay) for paid plans

### Postconditions
- Page view logged: `membership.plans.viewed`
- Plan creation/changes trigger webhook to billing provider
- MRR recalculated on any subscription change

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell + MRR summary + plan cards full width |
| Tablet (768-1279px) | App Shell (collapsed) + stacked cards |
| Mobile (≤767px) | Redirect to Mobile Membership (M052) |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ 🎖 Gói thành viên (3 plans)                      [+ Tạo gói mới]  │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ MRR Summary ──────────────────────────────────────────────────┐  │
│ │ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌───────┐│  │
│ │ │ 💰 MRR   │ │ 👥 Subs  │ │ 📉 Churn │ │ 💎 LTV   │ │ Trial ││  │
│ │ │ 46.6M    │ │ 323      │ │ 5.2%     │ │ 2.8M     │ │ 42%   ││  │
│ │ │ ↑+12%    │ │ ↑+18     │ │ ↓-1.8pp  │ │ ↑+200K   │ │ conv  ││  │
│ │ └──────────┘ └──────────┘ └──────────┘ └──────────┘ └───────┘│  │
│ │ [████████████████████████░░░░░░] MRR trend (6 months)          │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Plan Card: VIP Club ──────────────────────────────────────────┐  │
│ │ 🎖 "VIP Club" · 199,000 VND/month                [🟢 Active] │  │
│ │ Billing: Stripe + VNPay · Trial: 7 ngày miễn phí              │  │
│ │                                                                  │  │
│ │ 👥 Subscribers: 234 (↑18 this month)                           │  │
│ │ ├── Active: 210 · Trial: 12 · Past due: 8 · Cancelled: 4     │  │
│ │                                                                  │  │
│ │ Benefits:                                                       │  │
│ │ ├── 🔒 Exclusive content (members-only posts)                  │  │
│ │ ├── 💬 Priority DM access                                      │  │
│ │ ├── 🛒 20% discount on all products                            │  │
│ │ ├── 📱 Early access to new content (48h before public)         │  │
│ │ └── 🎁 Monthly exclusive gift                                  │  │
│ │                                                                  │  │
│ │ Revenue (30d): 46.6M VND · New: 24 · Cancelled: 6 · Net: +18 │  │
│ │ Churn rate: 2.6% · Avg LTV: 3.2M · Trial→Paid: 45%           │  │
│ │                                                                  │  │
│ │ [✏ Edit] [📊 Analytics] [👥 Subscribers (234)] [📋 Duplicate] │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Plan Card: Basic Fan ─────────────────────────────────────────┐  │
│ │ 🏷 "Basic Fan" · 49,000 VND/month                [🟢 Active] │  │
│ │ Billing: Stripe · No trial                                     │  │
│ │ 👥 89 subscribers · Revenue: 4.4M VND                         │  │
│ │ Benefits: Behind-the-scenes, Comment badge                     │  │
│ │ [✏] [📊] [👥] [📋]                                           │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Plan Card: Platinum (draft) ──────────────────────────────────┐  │
│ │ 📋 "Platinum" · 499,000 VND/month                [📋 Draft]   │  │
│ │ 0 subscribers · Not published · 8 benefits configured          │  │
│ │ [✏ Edit] [📤 Publish] [🗑 Delete]                              │  │
│ └──────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
MembershipPlansPage
├── AppShell (shared)
├── PageHeader
│   ├── PageTitle ("🎖 Gói thành viên" + plan count)
│   └── CreatePlanButton ("+ Tạo gói mới")
├── MRRSummaryBar
│   ├── MetricCard("💰 MRR", VND + trend)
│   ├── MetricCard("👥 Subscribers", count + monthly net)
│   ├── MetricCard("📉 Churn", percentage + trend)
│   ├── MetricCard("💎 LTV", VND avg + trend)
│   ├── MetricCard("Trial→Paid", conversion % )
│   └── MRRTrendMiniChart (sparkline, 6 months)
├── PlanCardList
│   └── PlanCard[] (repeating, ordered by subscriber count desc)
│       ├── PlanHeader
│       │   ├── PlanIcon (tier-specific emoji)
│       │   ├── PlanName
│       │   ├── PriceLabel ("199,000 VND/month")
│       │   └── StatusBadge (🟢 Active / 📋 Draft / ⏸ Paused)
│       ├── BillingInfo
│       │   ├── PaymentProviders ("Stripe + VNPay")
│       │   └── TrialInfo ("7 ngày miễn phí" or "No trial")
│       ├── SubscriberSummary
│       │   ├── TotalCount ("234" + monthly change)
│       │   └── StatusBreakdown (Active, Trial, Past due, Cancelled)
│       ├── BenefitList (ordered)
│       │   └── BenefitItem[] (icon + description)
│       │       ├── BenefitIcon (🔒 / 💬 / 🛒 / 📱 / 🎁 / ⭐ / 🎤)
│       │       └── BenefitDescription
│       ├── RevenueSnapshot
│       │   ├── Revenue30d (VND)
│       │   ├── NewSubscribers (count)
│       │   ├── CancelledSubscribers (count)
│       │   ├── NetChange (new - cancelled)
│       │   ├── ChurnRate (plan-specific)
│       │   ├── AvgLTV
│       │   └── TrialConversion (%)
│       └── ActionBar
│           ├── EditButton ("✏ Edit")
│           ├── AnalyticsButton ("📊 Analytics")
│           ├── SubscribersButton ("👥 Subscribers (234)")
│           └── DuplicateButton ("📋 Duplicate")
├── DraftPlanCard (simplified — no subscribers/revenue)
│   ├── PlanName + Price + "📋 Draft" badge
│   ├── BenefitCount ("8 benefits configured")
│   └── DraftActions: [✏ Edit] [📤 Publish] [🗑 Delete]
├── EmptyState ("Chưa tạo gói thành viên. Bắt đầu recurring revenue!")
└── CreatePlanModal
    ├── PlanNameInput
    ├── PriceInput + CurrencySelector (VND)
    ├── BillingCycleSelector (Monthly / Quarterly / Yearly)
    ├── TrialToggle + TrialDurationInput (days)
    ├── PaymentProviderCheckboxes (Stripe ☑, VNPay ☑)
    ├── BenefitBuilder (drag-sortable list)
    │   └── BenefitRow[] (icon selector + description + type)
    │       ├── IconPicker
    │       ├── DescriptionInput
    │       └── DragHandle
    ├── ContentGatingConfig
    │   ├── GatingMode (all content / selected content / tag-based)
    │   └── ContentSelector (if selected mode)
    └── ActionButtons: [Cancel] [Save Draft] [📤 Publish]
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| MRR total | `SUM(subscriptions.price WHERE status=active)` | `MembershipService/GetMRRSummary(workspace_id)` | VND compact ("46.6M") | 5m |
| Total subscribers | `COUNT(subscriptions WHERE status IN (active, trial, past_due))` | Same above | Integer + net change | 5m |
| Churn rate | `cancelled_30d / active_start_30d × 100` | Same above | Percentage ("5.2%") | 5m |
| Avg LTV | `AVG(subscriber_revenue_total)` | Same above | VND compact ("2.8M") | 15m |
| Trial conversion | `paid_after_trial / total_trials × 100` | Same above | Percentage ("42%") | 15m |
| MRR trend | 6-month monthly aggregation | `MembershipService/GetMRRTrend(6)` | Sparkline data points | 30m |
| Plan list | `membership_plans` + stats | `MembershipService/ListPlans(workspace_id)` | Plan cards | 5m |
| Plan price | `membership_plans.price` | — | VND formatted + "/month" | — |
| Subscriber count | `COUNT(subscriptions WHERE plan_id)` | Included in plans | Integer | 5m |
| Subscriber breakdown | `GROUP BY subscription_status` | Included in plans | Active/Trial/Past due/Cancelled | 5m |
| Benefits | `membership_benefits` ordered by `sort_order` | Included in plans | Icon + text list | — |
| Plan revenue 30d | `SUM(subscription_invoices.amount WHERE 30d AND plan_id)` | Included in plans | VND compact | 5m |
| New/Cancelled 30d | `COUNT WHERE created_at/cancelled_at IN 30d` | Included in plans | Integer | 5m |
| Payment providers | `membership_plans.payment_providers[]` | — | "Stripe + VNPay" | — |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Create plan | "+ Tạo gói mới" → modal submit | `MembershipService/CreatePlan(data)` | New `membership_plans` row + benefits | Modal → card appears. Toast "✅ Gói thành viên đã tạo" | `membership:manage` |
| 2 | Edit plan | "✏ Edit" | — | — | Navigate → `/memberships/[id]/edit` or inline editor | `membership:manage` |
| 3 | View analytics | "📊 Analytics" | — | — | Navigate → `/memberships/[id]/analytics` | `membership:read` |
| 4 | View subscribers | "👥 Subscribers" | — | — | Navigate → `/memberships/[id]/subscribers` | `membership:read` |
| 5 | Duplicate plan | "📋 Duplicate" | `MembershipService/DuplicatePlan(id)` | New plan (draft) | New draft card. Toast "📋 Gói đã nhân bản (draft)" | `membership:manage` |
| 6 | Publish draft | "📤 Publish" (draft only) | `MembershipService/Publish(id)` | `status = 'active'` | Confirmation modal → badge → 🟢. Toast "📤 Gói đã publish" | `membership:manage` |
| 7 | Archive plan | "⋮" → "Lưu trữ" (active, no subscribers) | `MembershipService/Archive(id)` | `status = 'archived'` | Card removed. Toast "Đã lưu trữ" | `membership:manage` |
| 8 | Delete draft | "🗑 Delete" (draft only) | `MembershipService/Delete(id)` | Soft delete | Confirmation → card removed | `membership:manage` |
| 9 | Pause plan | "⋮" → "Tạm dừng" (stops new signups) | `MembershipService/Pause(id)` | `status = 'paused'` | Badge → ⏸. Existing subscribers unaffected. | `membership:manage` |
| 10 | Resume plan | "⋮" → "Tiếp tục" (paused) | `MembershipService/Resume(id)` | `status = 'active'` | Badge → 🟢. | `membership:manage` |
| 11 | Reorder benefits | Drag-sort in create/edit modal | Client-side state | — | Benefits reorder with animation | `membership:manage` |
| 12 | Change price | Edit plan → price change | `MembershipService/UpdatePlan(id, {price})` | `plans.price = new_price` | Warning: "Thay đổi giá chỉ áp dụng cho subscriber mới." | `membership:manage` |

---

## 7. Validation Rules

### Create/Edit Plan
| Field | Rule | Error |
|---|---|---|
| Plan name | Required, 3-100 chars, unique per workspace | "Tên gói 3-100 ký tự. Tên đã tồn tại." |
| Price | Required, ≥ 10,000 VND (or 0 for free tier) | "Giá tối thiểu 10,000đ (hoặc 0 cho gói miễn phí)" |
| Billing cycle | Required, one of: monthly/quarterly/yearly | "Chọn chu kỳ thanh toán" |
| Trial duration | If enabled: 1-30 days | "Thời gian dùng thử 1-30 ngày" |
| Payment provider | At least 1 required for paid plans | "Chọn ít nhất 1 cổng thanh toán" |
| Benefits | At least 1 benefit required | "Thêm ít nhất 1 quyền lợi" |
| Benefit description | 3-200 chars each | "Mô tả quyền lợi 3-200 ký tự" |

### Publish Guard
| Check | Error |
|---|---|
| All required fields | "Vui lòng điền đầy đủ trước khi publish" |
| Payment provider connected | "Kết nối Stripe hoặc VNPay trước khi publish gói trả phí" |
| At least 1 benefit | "Cần ít nhất 1 quyền lợi để publish" |

---

## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| LOADING | Initial load | MRR shimmer + card skeletons | Wait |
| LOADED | Data received | MRR bar + plan cards | Interact |
| EMPTY | No plans | Illustration: "Chưa tạo gói thành viên. Tạo recurring revenue bằng exclusive content! [+ Tạo gói mới]" | Create first |
| CREATING | Modal submission | Modal button spinner | Wait |
| HIGH_CHURN | Any plan churn > 10% | Warning banner: "⚠️ Churn rate cao (>10%). Xem xét cải thiện benefits hoặc giá." | Review benefits |
| PAST_DUE_ALERT | Past due subscribers > 5% | Warning: "⚠️ {count} subscribers chưa thanh toán. [Xem danh sách]" | Review subscribers |
| TRIAL_NO_CONVERT | Trial conversion < 20% | Info: "💡 Trial→Paid thấp. Thử rút ngắn trial hoặc cải thiện benefits." | Optimize |
| BILLING_NOT_CONNECTED | No payment provider configured | Banner: "⚠️ Chưa kết nối cổng thanh toán. [Kết nối Stripe →]" | Connect billing |
| ERROR | API failed | Retry prompt | Retry |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View plans & benefits | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| View MRR & financial data | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| View subscribers | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Create/edit plans | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Publish/pause plans | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Delete/archive plans | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| View analytics | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |

### Visibility Rules
- **Editor**: Can view plan names and benefits only. MRR, subscriber counts, and revenue hidden.
- **Contributor/Viewer/External**: Sidebar item hidden. No access.

---

## 10. Navigation Map

```
Membership Plans (/memberships)
├── → /memberships/[id]/edit               (Click "✏ Edit")
├── → /memberships/[id]/analytics          (Click "📊 Analytics")
├── → /memberships/[id]/subscribers        (Click "👥 Subscribers")
├── → /settings/billing                    (Billing not connected CTA)
├── ← /                                    (Sidebar nav)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Offline" + cached plan cards | Auto-refresh |
| API error (load) | Server 5xx | "Không tải được gói thành viên. [Thử lại]" | Retry |
| Create failed | Validation or server error | Modal inline errors or toast | Fix and retry |
| Billing sync failed | Stripe/VNPay API error | Banner: "⚠️ Đồng bộ thanh toán lỗi. Subscriber mới có thể chưa được xử lý." | Auto-retry |
| Plan name conflict | Name already exists | Modal error: "Tên gói đã tồn tại" | Change name |
| Delete active plan | Attempt to delete plan with subscribers | Dialog: "Không thể xóa gói có subscribers. Chuyển subscribers hoặc lưu trữ." | Archive instead |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| MRR metric cards | `role="status"`, `aria-label` with full value |
| Plan cards | `role="article"`, `aria-label="Gói VIP Club, 199,000 đồng mỗi tháng, 234 thành viên"` |
| Benefit list | `role="list"`, each item `role="listitem"` |
| Drag-sort benefits | `aria-roledescription="sortable list"`, `aria-label` per item with position |
| Status badges | Not color-only — includes text label |
| Action buttons | Descriptive `aria-label` |
| MRR chart | Alt text summary + data table fallback |
| Create modal | Focus trap, `role="dialog"`, `aria-labelledby` |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App Shell + MRR bar shimmer |
| MRR data | 100-300ms | Shimmer → animated counters |
| Plan cards | 200-500ms | Card skeletons → cards populate with stagger |
| MRR mini chart | 300-600ms | Chart placeholder → sparkline renders |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (MRR summary bar) |
| CLS | < 0.05 |
| TTI | < 2.0s |
| Plan list | < 500ms |
| Create modal open | < 200ms |
| Benefit drag-sort | 60fps |

---

## 15. Real-time Updates

| Data | Method | Frequency |
|---|---|---|
| Subscriber counts | Polling | Every 5 minutes |
| MRR | Polling | Every 5 minutes |
| New subscription | SSE `/events/memberships` | Real-time (subscriber count badge) |
| Payment webhook | Background | Immediate (Stripe/VNPay webhooks) |
| Churn data | Batch | Computed daily at midnight |

---

## 16. Localization Notes

- Primary language: Vietnamese (vi-VN)
- Currency: VND ("199,000 VND/month", "46.6M VND")
- Billing cycles: "mỗi tháng", "mỗi quý", "mỗi năm"
- Trial: "{N} ngày miễn phí" or "Không dùng thử"
- Churn: Percentage ("5.2%")
- LTV: VND compact ("2.8M")

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `membership.plans.viewed` | Page load | `plan_count`, `total_mrr`, `total_subscribers` |
| `membership.plan.created` | Plan created | `plan_id`, `price`, `trial_days`, `benefit_count` |
| `membership.plan.published` | Plan published | `plan_id`, `price` |
| `membership.plan.edited` | Plan edited | `plan_id`, `changed_fields[]` |
| `membership.plan.paused` | Plan paused | `plan_id`, `subscriber_count_at_pause` |
| `membership.plan.duplicated` | Plan duplicated | `source_plan_id` |
| `membership.subscribers.viewed` | View subscriber list | `plan_id`, `subscriber_count` |
| `membership.analytics.viewed` | View plan analytics | `plan_id` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-surface-elevated` | Plan cards, MRR cards |
| `--color-accent` | Create button, active tab |
| `--color-success` | 🟢 Active badge, positive MRR trend |
| `--color-warning` | High churn warning, past due alert |
| `--color-danger` | Delete action, negative trends |
| `--color-membership-vip` | VIP tier card accent (gold) |
| `--color-membership-basic` | Basic tier card accent (silver) |
| `--font-metric-lg` | MRR value (32px bold) |
| `--font-price` | Plan price display (24px bold) |
| `--spacing-card-gap` | Gap between plan cards (24px) |
| `--radius-card` | Card radius (16px — premium feel) |

---

## 19. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(app)/memberships/+page.svelte`
- **Server load**: `+page.server.ts` → fetch plans + MRR summary
- **Benefit builder**: `@dnd-kit/sortable` for drag-reorder with keyboard support
- **Billing integration**: Stripe Customer Portal for subscriber management, VNPay via webhook
- **Content gating**: `membership_content` junction table determines which posts are members-only
- **MRR calculation**: `SUM(active_subscriptions.price)` computed server-side, cached 5m

### Data Fetching
```
+page.server.ts:
  const [plans, mrrSummary] = await Promise.all([
    membershipService.listPlans(workspace_id),       // plans + subscriber stats + benefits
    membershipService.getMRRSummary(workspace_id),    // MRR, churn, LTV, conversion
  ]);
  // Plans include: benefits (ordered), subscriber breakdown, 30d revenue
  // MRR trend data lazy-loaded client-side for sparkline
```

### Billing Webhook Flow
```
Stripe webhook → /api/webhooks/stripe:
  invoice.paid      → activate subscription
  invoice.failed    → mark past_due
  customer.subscription.deleted → mark cancelled, recalc MRR
  customer.subscription.trial_will_end → notify creator (push + email)
```

---

## 20. Related Screens & Revision History

### Related Screens
| Screen | Relationship |
|---|---|
| [W061] Product Detail | Products can have membership-only pricing |
| [W082] Revenue Detail | Membership revenue in financial reports |
| [W088] Creator Pro | Membership as revenue stream |
| [W119] Billing & Plans | Payment provider configuration |
| [M026] Mobile Commerce Dashboard | Mobile equivalent (membership section) |

### Revision History
| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: Full 20-point rewrite. Added: real APIs (MembershipService), MRR/churn/LTV analytics, subscriber lifecycle states, drag-sort benefit builder, multi-provider billing (Stripe + VNPay webhooks), content gating config, 12 actions, 9 states, trial management, and comprehensive RBAC. | System |
| 2026-03-28 | 1.0 | Initial specification (Tier C) | System |
