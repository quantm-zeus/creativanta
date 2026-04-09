# Screen: Web — Capability Matrix

> **Screen ID**: W130
> **Module**: M22 — Capability Matrix
> **Route**: `/settings/capabilities`
> **Platform**: Web (SvelteKit)
> **Upstream**: PRD §26 (M22), Product Freeze §30, B4 Connectors, S26 §9

---

## 1. Purpose & Context

The Capability Matrix is the transparency layer showing users exactly which features are available, degraded, or unavailable based on their connected platforms, subscription tier, and current platform health. It is the single source of truth for "can I do X right now?" — replacing vague error messages with proactive capability awareness.

### User Story
> As a creator, I want to see which features are available across my connected platforms so I can plan my workflow around current capabilities and understand WHY something isn't working.

### Entry Points
- Sidebar: "🔧 Capabilities" (under Settings group)
- Error/degraded state on any feature → "Xem tình trạng dịch vụ →"
- Copilot: "Tại sao tôi không publish được?"
- Platform Health widget on Dashboard → "Xem chi tiết →"

### Exit Points
- Click "Connect" → Settings/Connectors
- Click repair action → respective repair flow
- Click "Upgrade" → Billing/Plan page

---

## 2. Preconditions / Postconditions

### Preconditions
- User authenticated with valid session
- At least one connected platform for full display

### Postconditions
- User understands current system capabilities
- Repair/connect actions initiated if needed

---

## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | App Shell (sidebar 240px) + Main Content (matrix grid) |
| Tablet (768-1279px) | Collapsed sidebar + scrollable matrix |
| Mobile | Redirect to mobile equivalent |

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ⚙️ Capabilities          [Platform Filter ▾] [Status Filter ▾]      │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ System Status (full width) ──────────────────────────────────┐   │
│ │ 🟢 Hệ thống hoạt động bình thường — 23/23 dịch vụ khả dụng   │   │
│ │ Cập nhật: 2 phút trước                                        │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Platform Capabilities ─────────────────────────────────────────┐ │
│ │           │ TikTok    │ Instagram │ YouTube  │ Shopee   │ Lazada│ │
│ │ ──────────┼───────────┼───────────┼──────────┼──────────┼───────│ │
│ │ Publish   │ 🟢 OK     │ 🟢 OK     │ 🟡 Slow  │ N/A      │ N/A  │ │
│ │ Analytics │ 🟢 OK     │ 🟢 OK     │ 🟡 Stale │ 🟢 OK    │ —    │ │
│ │ Inbox     │ 🟢 OK     │ 🟡 Rate   │ 🟢 OK    │ 🟢 OK    │ —    │ │
│ │ Orders    │ N/A       │ N/A       │ N/A      │ 🟢 OK    │ 🟢 OK│ │
│ │ Products  │ 🟢 OK     │ N/A       │ N/A      │ 🟢 OK    │ 🟢 OK│ │
│ │ Live      │ 🟢 OK     │ 🔴 Down   │ 🟢 OK    │ 🟢 OK    │ —    │ │
│ │ Token     │ ✅ Valid   │ ✅ Valid   │ ⚠️ 2d    │ ✅ Valid  │ ⚫ — │ │
│ │ ──────────┼───────────┼───────────┼──────────┼──────────┼───────│ │
│ │ [Kết nối Lazada →]                                              │ │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Tier Feature Gates ────────────────────────────────────────────┐ │
│ │ Your plan: Pro (15 accounts, 2K credits/mo)                     │ │
│ │                                                                  │ │
│ │ ✅ AI Video — Quick Edit, Clip Factory, Multi-Merge, AI Remix   │ │
│ │ ✅ Unlimited Link-in-Bio links + Custom Domain                  │ │
│ │ ✅ All Media Kit templates                                      │ │
│ │ ✅ Rate Card AI pricing suggestions                             │ │
│ │ ✅ Unlimited Brand Deals                                        │ │
│ │ 🔒 Multi-Creator workspace (Business plan) [Nâng cấp →]        │ │
│ │ 🔒 Custom onboarding templates (Business plan) [Nâng cấp →]    │ │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ AI Provider Status ────────────────────────────────────────────┐ │
│ │ Gemini: 🟢 OK | Claude: 🟢 OK | GPT-4: 🟡 Rate Limited (80%) │ │
│ │ HeyGen: 🟢 OK | Stability: 🟢 OK                               │ │
│ │ AI Credits: 1,456 / 2,000 remaining    [→ Mua thêm credits]    │ │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Recent Issues ─────────────────────────────────────────────────┐ │
│ │ 🟡 Instagram Live bị gián đoạn — 14:30 hôm nay                 │ │
│ │    "Facebook API đang gặp sự cố. Dự kiến khôi phục: 1-2h."     │ │
│ │ ▶ YouTube Analytics chạy chậm — 10:00 hôm nay (đã khôi phục)  │ │
│ └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
CapabilityMatrixPage
├── AppShell (shared)
│   ├── Sidebar + TopBar
├── PageHeader
│   ├── Title ("Trạng thái dịch vụ & Khả năng")
│   └── FilterBar (platform filter, status filter)
├── SystemStatusBanner
│   ├── OverallStatus (🟢/🟡/🔴)
│   ├── ServiceCount ("23/23 khả dụng")
│   └── LastUpdated (relative timestamp)
├── PlatformCapabilityMatrix
│   ├── MatrixHeader (platform columns)
│   └── CapabilityRow[]
│       ├── CapabilityName (Publish, Analytics, Inbox, Orders, Products, Live)
│       └── PlatformStatusCell[]
│           ├── StatusDot (🟢 OK / 🟡 Degraded / 🔴 Down / ⚫ Not Connected / N/A)
│           ├── StatusLabel
│           └── ActionLink (Connect / Repair / Details)
├── TierFeatureGatesCard
│   ├── CurrentPlanBadge
│   ├── AvailableFeature[] (✅ with descriptions)
│   ├── LockedFeature[] (🔒 with required tier + upgrade CTA)
│   └── UpgradeLink (inline upsell, NOT force redirect per PRD §32J.4)
├── AIProviderStatusCard
│   ├── ProviderStatus[] (Gemini, Claude, GPT, HeyGen, Stability)
│   │   ├── ProviderName
│   │   ├── StatusDot + Label
│   │   └── DetailNote (rate limit %, error note)
│   ├── CreditBalance (used / total)
│   └── PurchaseLink
└── RecentIssuesCard
    └── IssueItem[]
        ├── SeverityDot
        ├── Platform + Description
        ├── Timestamp
        └── ExpectedResolution (if ongoing)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| System status | Composite from all services | `CapabilityService/GetSystemStatus` | 🟢/🟡/🔴 + count | 2m TTL |
| Platform matrix | `connectors` + platform health + capability registry | `CapabilityService/GetMatrix(workspaceId)` | Grid cells with status | 5m TTL |
| Token status | `oauth_tokens` expiry | `ConnectorService/GetTokenStatus` | ✅ Valid / ⚠️ Xd / ⚫ Not connected | 15m TTL |
| Tier gates | `subscription_tier` + feature flag registry | `TierService/GetFeatureGates(tierId)` | ✅/🔒 per feature | 30m TTL |
| AI providers | `ai_provider_health` from monitoring | `AIService/GetProviderStatus` | Status per provider + rate limit % | 2m TTL |
| Credits | `ai_credit_transactions` balance projection | `CreditService/GetBalance` | "1,456 / 2,000" | Real-time |
| Recent issues | `platform_incidents` last 48h | `CapabilityService/GetRecentIssues` | Timeline | 5m TTL |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Filter by platform | Platform filter dropdown | Client-side filter | — | Matrix columns filtered | Any role |
| 2 | Filter by status | Status filter dropdown | Client-side filter | — | Only matching rows shown | Any role |
| 3 | Connect platform | Click "Kết nối" on ⚫ cell | — | — | Navigate → `/settings/connectors/new?platform=[x]` | `account:connect` |
| 4 | Repair token | Click "Làm mới" on ⚠️ cell | `ConnectorService/RefreshToken(connectorId)` | Token refreshed | Status → 🟢 + toast "Đã làm mới token" | `account:connect` |
| 5 | Upgrade plan | Click "Nâng cấp" on 🔒 feature | — | — | Navigate → `/settings/billing/upgrade` | `workspace:billing:read` |
| 6 | Purchase credits | Click "Mua thêm credits" | — | — | Navigate → `/settings/credits/purchase` | `credits:top_up` |
| 7 | View issue detail | Click issue item | — | — | Expand inline with full description | Any role |
| 8 | Refresh status | Click "Cập nhật" | `CapabilityService/GetMatrix(workspaceId)` | — | All data refreshes | Any role |

---

## 7. State Machine

```
┌─────────────┐
│   LOADING   │ ← Initial load
└──────┬──────┘
       │
       ├── All services OK → ALL_HEALTHY (🟢 banner)
       ├── Some degraded → PARTIALLY_DEGRADED (🟡 banner)
       ├── Critical down → CRITICAL_ISSUE (🔴 banner + pulsing)
       ├── No platforms → NO_PLATFORMS (empty state: "Kết nối platform đầu tiên")
       └── API fail → ERROR (retry)
```

| State | Visual |
|---|---|
| LOADING | Skeleton shimmer for matrix + status cards |
| ALL_HEALTHY | 🟢 "Hệ thống hoạt động bình thường" — calm, green accent |
| PARTIALLY_DEGRADED | 🟡 "Một số dịch vụ đang bị ảnh hưởng" — yellow banner + affected cells highlighted |
| CRITICAL_ISSUE | 🔴 "Sự cố nghiêm trọng đang được xử lý" — red pulsing banner + incident link |
| NO_PLATFORMS | Empty state: "Chưa kết nối platform nào. [Kết nối ngay →]" |
| ERROR | "Không tải được trạng thái dịch vụ. [Thử lại]" |

---

## 8. Permission Matrix

| Widget/Action | Owner | Admin | Manager | Editor | Contributor | Viewer | External |
|---|---|---|---|---|---|---|---|
| View capability matrix | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| View tier gates | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Connect platform | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Repair token | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Upgrade plan | ✅ (link) | ✅ (link) | ✅ (view) | ❌ | ❌ | ❌ | ❌ |
| Purchase credits | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |

---

## 9. Operator Mode Variations

| Mode | Visible Capabilities | Hidden |
|---|---|---|
| Creator | Publish, Analytics, Inbox, Ideas, Scripts, Studio | Orders, Products (if no commerce) |
| Seller | Products, Orders, Offers, Campaigns, Analytics | Studio (if no content creation) |
| Affiliate | Products, Affiliate Links, Analytics | Orders, Store |
| Live Operator | Live, Products, Analytics | (all commerce visible) |
| Agency/MCN | All capabilities visible (multi-creator) | — |
| Brand Collab | Creator Pro, Analytics, Publish | Orders (view only) |

> Matrix auto-filters to show relevant capabilities based on active operator mode(s). User can toggle "Hiện tất cả" to see full matrix.

---

## 10. Navigation Map

```
Capability Matrix (/settings/capabilities)
├── → /settings/connectors/new?platform=[x]   (Connect platform)
├── → /settings/billing/upgrade                (Upgrade plan)
├── → /settings/credits/purchase               (Buy credits)
├── → /settings/connectors                     (Manage connections)
└── ← / (Home Dashboard)                      (via sidebar)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network error | No internet | Banner "Đang offline — trạng thái có thể đã cũ" + show cached data | Auto-refresh on reconnect |
| Single platform API fail | Platform health check fails | Cell shows 🔴 with "Đang kiểm tra..." | Auto-retry 30s |
| Token refresh failed | OAuth re-auth needed | Cell shows "Đăng nhập lại" link | Navigate to re-auth flow |
| Auth expired | 401 | Redirect to login | Re-authenticate |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Matrix grid | `role="grid"`, `aria-label` per cell "TikTok Publish: Available" |
| Status banner | `role="status"`, `aria-live="polite"` |
| Status dots | Not color-only — include text labels ("OK", "Degraded", "Down") |
| Tier features | `aria-label` indicating locked/available + required tier |
| Focus order | Status → Matrix → Tier Gates → AI Providers → Recent Issues |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Shell render | 0ms | App shell + page header |
| Status banner | 100-300ms | Skeleton → status text |
| Matrix cells | 200-600ms | Skeleton grid → status dots populate |
| Tier gates | 300-800ms | Feature list populates |
| AI providers | 300-800ms | Provider status cards |
| Recent issues | 400-1000ms | Issue list |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s |
| Matrix render | < 500ms (after data) |
| Status refresh | < 2s |
| Token refresh action | < 3s |

---

## 15. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| Overall system status | Polling | Every 2 minutes |
| Platform status | Polling | Every 5 minutes |
| AI credits | SSE `/events/credits` | Real-time |
| Incidents | SSE `/events/incidents` | Real-time |

---

## 16. Localization Notes

- Primary language: Vietnamese
- Status labels: "Khả dụng", "Chậm", "Gián đoạn", "Không kết nối", "Không áp dụng"
- Dates: DD/MM/YYYY format
- Timestamps: relative ("2 phút trước")
- Credit numbers: dot separator (1.456)

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `capability.viewed` | Page load | `workspace_id`, `connected_platforms[]`, `tier`, `active_modes[]` |
| `capability.platform_connect_clicked` | Click connect | `platform` |
| `capability.token_refresh` | Click repair | `platform`, `result` |
| `capability.upgrade_clicked` | Click upgrade | `current_tier`, `target_feature` |
| `capability.credits_purchase_clicked` | Click buy credits | `remaining_credits` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-success` | 🟢 OK status |
| `--color-warning` | 🟡 Degraded status |
| `--color-danger` | 🔴 Down status |
| `--color-text-muted` | N/A cells, disabled features |
| `--color-surface-primary` | Card backgrounds |
| `--color-accent` | Connect/Repair CTAs |
| `--spacing-grid-gap` | Matrix cell gaps |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W001] Home Dashboard | Platform Health widget links here |
| [W117] Platform Connectors | Manage connections |
| [W119] Billing & Plans | Upgrade for locked features |
| [W120] AI Credits | Credit balance detail |
| [S006] Error States | Degraded state patterns |
| [M057] Mobile Settings | Mobile equivalent (capability in settings) |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 1.0 | Initial specification — aligned to PRD §26 M22 Capability Matrix, Freeze §30, B4 Connectors | System |
