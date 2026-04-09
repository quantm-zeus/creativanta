# Screen: Admin — AI Credit Management

> **Screen ID**: A014
> **Module**: S26 — Internal Admin & Operations
> **Route**: `/admin/ai/credits`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: S26 §AI Operations, AdminCreditService projections + `ai_credit_transactions`, B5 RBAC §3

---

## 1. Purpose & Context
Manage platform-wide AI credit pools — grant/revoke credits, view consumption patterns, set per-plan allocations, track cost vs. revenue margins, and configure credit pricing.

### User Story
> As a finance admin, I want to manage credit allocations per plan, track consumption margins, and grant/revoke credits so the AI economy stays profitable and users are fairly served.

### Business Goal
- Maintain positive AI credit margin (target: >60%)
- Optimize per-plan allocations based on utilization
- Enable support-driven credit grants (compensation)
- Visibility into credit consumption patterns

### Entry Points
- Admin sidebar → "🤖 AI" → "Credits"
- AI Ops dashboard → "Credits" section
- Workspace Detail → "Grant credits" action

### Exit Points
- Self-contained dashboard
- Drill-down to workspace → `/admin/workspaces/[id]`

---

## 2. Preconditions / Postconditions
### Preconditions
- Admin with `finance_admin` or `super_admin` role
### Postconditions
- Credit transactions logged with audit trail
- Plan allocations updated if changed
- Margin alerts triggered if < threshold

---

## 3. Layout Structure
### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 🤖 AI Credits                      [+ Grant bulk] [📥 Export]      │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Pool Status ───────────────────────────────────────────────────┐ │
│ │ Total pool: 200K cr │ Distributed: 150K │ Consumed: 95K (63%)  │ │
│ │ Available: 55K · Burn rate: 3.2K/day                           │ │
│ │ Platform cost: $450/day · Revenue: $320/day · Margin: 71% ✅   │ │
│ │ Days until pool exhaustion: ~17 days                            │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ ┌─ Plan Allocations ─────────────────────────────────────────────┐ │
│ │ Plan       │Cr/mo│ Users│ Avg used│ Utilization│ Cost/user    │ │
│ │ Free       │  50 │  600 │    35   │ 70% ████░  │ $0.12/mo    │ │
│ │ Starter    │ 200 │  300 │   145   │ 73% ████░  │ $0.48/mo    │ │
│ │ Pro        │ 500 │  150 │   380   │ 76% █████  │ $1.27/mo    │ │
│ │ Business   │2000 │   30 │  1450   │ 73% ████░  │ $4.83/mo    │ │
│ │ Enterprise │Cust │   10 │  5200   │ 65% ███░░  │ $17.33/mo   │ │
│ │ [✏ Edit allocations]                                           │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ ┌─ Consumption Trend (30d) ──────────────────────────────────────┐ │
│ │ [Stacked area: by plan tier] ▁▂▃▄▅▆▇█▇▇█▇                    │ │
│ └─────────────────────────────────────────────────────────────────┘ │
│ ┌─ Recent Grants/Revokes ────────────────────────────────────────┐ │
│ │ +500 → ws_abc (support comp) · admin@... · 1h ago              │ │
│ │ +100 → ws_def (onboarding bonus) · system · 2h ago             │ │
│ │ -200 → ws_ghi (abuse) · admin@... · 5h ago                     │ │
│ │ [View all →]                                                    │ │
│ └─────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy
```
AICreditManagementPage
├── AdminShell (shared)
├── PageHeader (title + grant bulk + export)
├── PoolStatusCard
│   ├── PoolMetrics (total/distributed/consumed/available)
│   ├── BurnRate + ExhaustionForecast
│   └── MarginMetrics (cost/revenue/margin %)
├── PlanAllocationsTable
│   ├── TableHeader (sortable columns)
│   └── PlanRow[] (plan/cr per mo/users/avg used/utilization bar/cost per user)
│   └── EditAllocationsButton
├── ConsumptionTrendChart (stacked area by plan, 30d)
├── RecentTransactionsList
│   └── TransactionRow[] (amount/workspace/reason/admin/time)
├── GrantCreditDialog (modal)
│   ├── WorkspaceSearch
│   ├── AmountInput
│   ├── ReasonSelector (support comp/onboarding/promo/manual)
│   ├── NoteInput
│   └── SubmitButton
├── BulkGrantDialog (modal — for bulk operations)
│   ├── FilterSelector (by plan/tag/specific)
│   ├── AmountInput
│   ├── ReasonInput
│   └── PreviewAffectedCount + SubmitButton
└── EditAllocationsDrawer
    ├── PlanRow[] (editable credit amount per plan)
    ├── ImpactPreview (cost impact)
    └── SaveButton
```

---

## 5. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Pool status | Credit-pool operational projection | `AdminCreditService/GetPoolStatus` | Count + percentage bar | 5m TTL |
| Plan allocations | Plan-allocation projection | `AdminCreditService/GetPlanAllocations` | Table rows | 15m TTL |
| Consumption trend | `ai_credit_transactions` aggregation | `AdminCreditService/GetConsumptionTrend(30d)` | Stacked area chart | 1h TTL |
| Recent transactions | `ai_credit_transactions` | `AdminCreditService/ListTransactions(page)` | List rows | No cache |
| Margin | computed (cost vs revenue) | included in pool | Percentage + indicator | 5m TTL |

---

## 6. Actions Table
| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Grant credits | Submit grant dialog | `AdminCreditService/Grant(ws, amount, reason)` | `ai_credit_transactions` insert | Toast "Granted {n} credits" | `finance_admin` |
| 2 | Revoke credits | Submit revoke action | `AdminCreditService/Revoke(ws, amount, reason)` | `ai_credit_transactions` insert | Toast "Revoked {n} credits" | `finance_admin` |
| 3 | Bulk grant | Submit bulk dialog | `AdminCreditService/BulkGrant(filter, amount)` | Multiple inserts | Progress → "Granted to {n} workspaces" | `finance_admin` |
| 4 | Edit allocations | Save allocation changes | `AdminCreditService/UpdateAllocations(plans)` | Allocation projection updated | Toast "Allocations updated" | `finance_admin` |
| 5 | Export | Click export | `AdminCreditService/Export(format)` | — | CSV download | `finance_admin` |
| 6 | View workspace | Click workspace link | — | — | Navigate to workspace detail | `finance_admin` |

---

## 7. States
| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Shimmer cards + skeleton table |
| LOADED | Data ready | Pool + allocations + chart |
| LOW_MARGIN | Margin < 50% | 🟡 "Credit margin declining! Consider reducing allocations." |
| CRITICAL_MARGIN | Margin < 30% | 🔴 "Credit margin critical! Immediate action required." |
| POOL_LOW | Available < 10% | ⚠️ "Pool running low. ~{n} days remaining." |
| GRANTING | Grant in progress | Dialog spinner |
| ERROR | API failed | Error with retry |

---

## 8. Validation Rules
| Field | Rule | Error Message |
|---|---|---|
| Grant amount | 1-10,000 | "Amount must be 1-10,000 credits" |
| Grant reason | Required | "Reason is required for audit" |
| Revoke amount | ≤ workspace balance | "Cannot revoke more than workspace has" |
| Plan allocation | ≥ 0, ≤ 100,000 | "Allocation must be 0-100,000" |

---

## 9. Permission Matrix
| Action | Super Admin | Finance Admin | Operations Admin | Support Admin | Analyst |
|---|---|---|---|---|---|
| View pool/allocations | ✅ | ✅ | ❌ | ❌ | ❌ |
| Grant credits | ✅ | ✅ | ❌ | ❌ | ❌ |
| Revoke credits | ✅ | ✅ | ❌ | ❌ | ❌ |
| Edit allocations | ✅ | ✅ | ❌ | ❌ | ❌ |
| Bulk grant | ✅ | ✅ | ❌ | ❌ | ❌ |
| Export | ✅ | ✅ | ❌ | ❌ | ❌ |

---

## 10. Navigation Map
```
AI Credits (/admin/ai/credits)
├── → /admin/workspaces/[id]        (via workspace link)
├── → GrantCreditDialog             (via + Grant)
├── → BulkGrantDialog               (via Grant bulk)
├── → EditAllocationsDrawer         (via Edit allocations)
├── → /admin/ai/providers           (related)
└── ← /admin/ai                    (via breadcrumb)
```

---

## 11. Error Handling
| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Grant failed | API error | Toast "Grant failed. Credits not applied." | Retry |
| Workspace not found | Invalid workspace | Dialog error "Workspace not found" | Fix search |
| Allocation save failed | API error | Toast "Save failed" | Retry |
| Insufficient pool | Pool exhausted | "Pool insufficient. [Top up pool]" | Top up |

---

## 12. Accessibility
| Element | Requirement |
|---|---|
| Pool metrics | `role="status"` with descriptive labels |
| Utilization bars | Color + percentage text |
| Table | Proper `<th>` scoping, sortable announced |
| Grant dialog | Focus trap, labeled inputs |

---

## 13. Loading Behavior
| Stage | Duration | Visual |
|---|---|---|
| Page load | <1s | Shimmer |
| Data fetch | 300-500ms | Progressive: pool → table → chart |
| Grant action | 500ms-1s | Dialog spinner |

---

## 14. Performance Requirements
| Metric | Target |
|---|---|
| Page load | <2s |
| Table render | <300ms |
| Grant response | <1s |
| Chart render | <500ms |

---

## 15. Real-time Updates
| Data | Channel | Frequency |
|---|---|---|
| Pool status | Polling | 5m |
| Recent transactions | SSE `/admin/events/credits` | Real-time |

---

## 16. Localization Notes
- Admin interface: English only
- Credits: "cr" abbreviation, no decimals
- Costs: USD for provider costs, VND for revenue

---

## 17. Analytics / Tracking Events
| Event | Trigger | Properties |
|---|---|---|
| `admin.credits.viewed` | Page load | `pool_utilization`, `margin` |
| `admin.credits.granted` | Grant | `workspace_id`, `amount`, `reason` |
| `admin.credits.revoked` | Revoke | `workspace_id`, `amount`, `reason` |
| `admin.credits.allocations_updated` | Save allocations | `plans_changed[]` |

---

## 18. Design Tokens Reference
| Token | Usage |
|---|---|
| `--color-admin-success` | Healthy margin (>60%) |
| `--color-admin-warning` | Low margin (<50%) |
| `--color-admin-danger` | Critical margin (<30%), pool low |

---

## 19. Related Screens
| Screen | Relationship |
|---|---|
| [A012] AI Providers | Provider cost tracking |
| [A013] AI Config | Model settings |
| [A001] Admin Dashboard | Summary metrics |

---

## 20. Revision History
| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | Full 20-point upgrade. Added pool exhaustion forecast, burn rate, cost-per-user, consumption trend chart, bulk grant, edit allocations drawer, 7 states, full RBAC. Fixed ID A14→A012. | System |
