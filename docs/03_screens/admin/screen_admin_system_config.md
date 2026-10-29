# Screen: Admin — System Configuration

> **Screen ID**: A030
> **Module**: Admin — System Configuration
> **Route**: `/admin/config`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: S26 §11, PRD §32H (AI Credits), §32J (Growth), B5 RBAC §3

---

## 1. Purpose & Context

The System Configuration screen is the central control panel for all platform-wide settings. Only Super Admin can modify these configs. It covers pricing, AI credit rates, rate limits, storage limits, SLA configs, AUP rules, email templates, platform connector configs, and maintenance mode.

### User Goals
- Configure global platform settings (pricing, limits, rates)
- Manage AI credit costs per operation type
- Set rate limits and storage quotas per subscription tier
- Toggle maintenance mode for the platform
- Manage email templates for system communications

### Business Goals
- Control AI operation costs and maintain margins (>30%)
- Set appropriate rate limits to prevent abuse
- Enable rapid configuration changes without code deployment

### Entry Points
- Admin Navigation: "⚙️ System Config"
- Only accessible to Super Admin role

### Exit Points
- Nav to other admin screens
- Changes take effect immediately (some require confirmation)

---

## 2. Preconditions / Postconditions

### Preconditions
- Admin authenticated via VPN + MFA
- Role: **Super Admin only** — all other roles receive 403

### Postconditions
- Config changes logged in `admin_audit_log` with old_value + new_value
- Changes propagate to application within 30 seconds (config cache TTL)
- Affected users see updated limits/rates

---

## 3. Screen Layout

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ 🏢 Creativanta Admin  [System Config]  [Super Admin] 👤 admin@...  │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ⚠️ SUPER ADMIN ONLY — All changes are audited and take effect       │
│    within 30 seconds.                                                │
│                                                                      │
│ [💰 Pricing] [🤖 AI Credits] [🚦 Rate Limits] [💾 Storage]          │
│ [⏱ SLA] [📋 AUP Rules] [📧 Emails] [🔗 Connectors] [🔧 System]   │
│                                                                      │
│ ─── Tab: Pricing ────────────────────────────────────────────────── │
│ ┌─ Subscription Tiers ────────────────────────────────────────┐     │
│ │ Free    │ ₫0/mo     │ 50 credits  │ 2 accounts │ [Edit]    │     │
│ │ Starter │ ₫499K/mo  │ 500 credits │ 5 accounts │ [Edit]    │     │
│ │ Pro     │ ₫1.499M/mo│ 2K credits  │ 15 accounts│ [Edit]    │     │
│ │ Business│ ₫4.999M/mo│ 10K credits │ 50 accounts│ [Edit]    │     │
│ │ Enterpr.│ custom    │ custom      │ custom     │ [Edit]    │     │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ─── Tab: AI Credits ─────────────────────────────────────────────── │
│ ┌─ Credit Cost Per Operation ──────────────────────────────────┐    │
│ │ Text generation     │ 1-5 credits  │ Cost: $0.002-0.01│[Edit]│    │
│ │ Image generation    │ 5-15 credits │ Cost: $0.01-0.05 │[Edit]│    │
│ │ Video gen (short)   │ 20-50 credits│ Cost: $0.10-0.25 │[Edit]│    │
│ │ Video gen (long)    │ 50-150       │ Cost: $0.25-1.00 │[Edit]│    │
│ │ Quick Edit          │ 15-40        │ Cost: $0.05-0.15 │[Edit]│    │
│ │ Clip Factory (10)   │ 60-120       │ Cost: $0.30-0.60 │[Edit]│    │
│ │ Analysis/scan       │ 1-10         │ Cost: $0.001-0.02│[Edit]│    │
│ │ Agent execution     │ 10-50        │ Cost: $0.05-0.25 │[Edit]│    │
│ └────────────────────────────────────────────────────────────────┘   │
│ Margin alert threshold: [30%] — current margin: 42% ✅               │
│                                                                      │
│ ─── Tab: System ─────────────────────────────────────────────────── │
│ ┌─ Maintenance Mode ──────────────────────────────────────────┐     │
│ │ Status: 🟢 OFF                                               │     │
│ │ [🔴 Activate Maintenance Mode] ← requires OTP + reason      │     │
│ │ Banner text: [___________________________________]            │     │
│ │ Estimated duration: [__] hours                                │     │
│ └────────────────────────────────────────────────────────────────┘   │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
SystemConfigPage
├── AdminShell (shared)
├── SuperAdminWarningBanner ("All changes are audited")
├── TabNavigation (9 tabs)
├── PricingTab
│   ├── TierTable
│   │   └── TierRow[] (Free, Starter, Pro, Business, Enterprise)
│   │       ├── TierName + Price
│   │       ├── CreditAllocation
│   │       ├── AccountLimit
│   │       ├── FeatureGates (expandable)
│   │       └── EditButton → modal
│   └── CurrencySettings (VND, USD)
├── AICreditTab
│   ├── CreditRateTable
│   │   └── OperationRow[]
│   │       ├── OperationType
│   │       ├── CreditRange (min-max)
│   │       ├── ActualCostUSD (internal)
│   │       ├── MarginIndicator
│   │       └── EditButton → modal
│   ├── MarginAlertConfig
│   └── ProviderCostOverview
├── RateLimitTab
│   ├── GlobalLimits (platform-wide)
│   └── TierLimits (per subscription tier)
├── StorageTab
│   ├── TierQuotas
│   ├── TempFileTTL
│   └── CleanupSchedule
├── SLATab
│   ├── SupportResponseTimes (per tier)
│   └── EscalationTimeouts
├── AUPTab
│   ├── ViolationCategories
│   └── StrikeThresholds
├── EmailTab
│   ├── TemplateList
│   └── TemplateEditor (rich text)
├── ConnectorTab
│   ├── PlatformAPIKeys
│   └── WebhookURLs
└── SystemTab
    ├── MaintenanceModeToggle (OTP + reason required)
    ├── EmergencyModeToggle (OTP + reason required)
    └── VersionInfo (current deploy)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Pricing tiers | `system_config.pricing` | `AdminConfigService/GetPricing` | Currency formatted | No cache |
| AI credit rates | `system_config.ai_rates` | `AdminConfigService/GetAIRates` | Credit range + USD cost | No cache |
| Rate limits | `system_config.rate_limits` | `AdminConfigService/GetRateLimits` | Numbers per period | No cache |
| Maintenance mode | `system_config.maintenance` | `AdminConfigService/GetMaintenance` | Status badge | Real-time |
| Config change history | `admin_audit_log WHERE target_type='config'` | `AdminConfigService/GetChangeHistory` | Timeline | 5m TTL |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Edit tier pricing | Click "Edit" on tier | `AdminConfigService/UpdateTier(tierId, data)` | Config updated | Confirmation modal + reason required + toast "Pricing updated" | Super Admin |
| 2 | Edit credit rate | Click "Edit" on operation | `AdminConfigService/UpdateCreditRate(opType, data)` | Config updated | Confirmation modal + toast "Rate updated" | Super Admin |
| 3 | Toggle maintenance | Click "Activate/Deactivate" | `AdminConfigService/UpdateMaintenance(enabled, opts)` | Maintenance mode toggled | OTP + reason required + banner text + toast | Super Admin |<!-- AUDIT-FIX 2026-04-19: ToggleMaintenance → UpdateMaintenance to match canonical api_endpoint_map.md §18.12 Update* pattern -->
| 4 | Edit email template | Select template + edit | `AdminConfigService/UpdateEmailTemplate(id, html)` | Template updated | Preview + confirmation + toast "Template saved" | Super Admin |
| 5 | Update rate limit | Edit limit value + save | `AdminConfigService/UpdateRateLimit(tierId, limits)` | Config updated | Confirmation + toast | Super Admin |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching config | Skeleton |
| LOADED | Config loaded | Full config interface |
| SAVING | Config change in progress | Save button spinner + "Saving..." |
| SAVED | Config saved | Toast "Configuration updated" |
| ERROR | Save failed | Error inline + rollback to previous value |
| MAINTENANCE_ON | Maintenance active | Red banner pulsing at top of all screens |

---

## 8. Permission Matrix (Admin RBAC)

| Feature | Super Admin | All Other Roles |
|---|---|---|
| View config | ✅ | ❌ (403 page) |
| Edit config | ✅ | ❌ |
| Toggle maintenance | ✅ (OTP) | ❌ |
| View change history | ✅ | ❌ |

---

## 9. Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Tier price | Must be ≥ 0 | "Price must be non-negative" |
| Credit range | min ≤ max, both ≥ 0 | "Min must be ≤ max" |
| Rate limit | Must be positive integer | "Rate limit must be a positive number" |
| Email template | Must contain `{{user_name}}` placeholder | "Template must include user name variable" |
| Maintenance banner | Max 500 chars | "Banner text too long" |
| OTP | 6-digit TOTP code | "Invalid OTP code" |

---

## 10. Navigation Map

```
System Config (/admin/config)
├── Edit tier → confirmation modal (stays on page)
├── Edit rate → confirmation modal (stays on page)
├── View change history → inline panel
└── ← /admin (back to dashboard)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Config save failed | Server error | "Failed to save. Previous value restored." | Retry save |
| OTP invalid | Wrong TOTP code | "OTP không hợp lệ. Thử lại." | Re-enter |
| Concurrent edit | Another admin editing same config | "Config changed by another admin. Reload." | Reload page |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Tabs | `role="tablist"`, keyboard navigable |
| Config tables | `role="grid"`, editable cells have `aria-label` |
| Maintenance toggle | Clear state announcement for screen readers |
| Confirmation modals | Focus trap, Escape to cancel |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Shell + tabs | 0ms | Immediate |
| Config data | 200-500ms | Shimmer → populated tables |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Config load | < 1s |
| Config save | < 2s |
| Cache invalidation | < 30s platform-wide |

---

## 15. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-admin-accent` | Edit buttons, active tab |
| `--color-admin-danger` | Maintenance mode toggle, destructive actions |
| `--color-admin-warning` | Margin warnings, approaching limits |
| `--color-admin-surface` | Config card backgrounds |

---

## 16. Related Screens

| Screen | Relationship |
|---|---|
| [A001] Admin Dashboard | Parent |
| [A009] Feature Flags | Feature-level config |
| [A010] Audit Log | Config change history |
| [A014] AI Credits | AI credit management |

---

## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 1.0 | Initial specification — aligned to S26 §11 system configuration spec | System |
