# Screen: Web — Settings: API Keys

> **Screen ID**: W127
> **Module**: M26 — Settings (Developer)
> **Route**: `/settings/api`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 10, A1 Schema (api_keys, api_key_scopes, api_usage_logs), B5 RBAC §2.9

---

## 1. Purpose & Context

Manage API access tokens (Pro+ only) — create keys with scoped permissions, rotate keys safely, revoke compromised keys, and monitor usage with rate limit tracking.

### User Goals
- Create API keys with granular scope permissions
- Monitor key usage (requests/day, last used)
- Rotate keys without downtime (new key → deprecation period → old revoked)
- Revoke compromised keys immediately

### Business Goals
- Enable developer integrations with Creativanta API
- Track API usage for billing and capacity planning
- Ensure security through key rotation and scoping

### Entry Points
- Sidebar: Settings → "🔑 API Keys"
- API documentation: "Get your API key" link

### Exit Points
- "📖 API Docs →" → external documentation
- "🧪 API Playground →" → interactive testing

---

## 2. Screen Layout

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Settings   🔑 API Keys                          [+ Create Key]   │
├──────────────────────────────────────────────────────────────────────┤
│ ⚠️ API keys grant access to your workspace data. Keep them safe.   │
│ Never share keys in public repos or client-side code.               │
│                                                                      │
│ ┌─ Key Row ─────────────────────────────────────────────────────┐   │
│ │ "Production" · Created: 15/3/2026 by Nguyễn Quân             │   │
│ │ Key: cr_live_...4a2b [👁 Reveal] [📋 Copy]                  │   │
│ │                                                                │   │
│ │ Scopes: [read:content ✅] [write:content ✅] [read:analytics ✅]│ │
│ │         [read:orders ✅] [write:publish ❌] [admin ❌]        │   │
│ │                                                                │   │
│ │ Usage (today): 145 requests · Rate limit: 10,000/day          │   │
│ │ [████░░░░░░░░░░░░░░░░] 1.5%                                  │   │
│ │ Last used: 2h ago · Total requests: 12,450                    │   │
│ │                                                                │   │
│ │ [✏ Edit scopes] [🔄 Rotate key] [🗑 Revoke]                 │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ Key Row ─────────────────────────────────────────────────────┐   │
│ │ "Staging" · Created: 20/3/2026                                │   │
│ │ Key: cr_test_...8f1c [👁] [📋]                               │   │
│ │ Scopes: [read:content ✅] (read-only)                         │   │
│ │ Usage: 23 requests today · Last: 1d ago                       │   │
│ │ [✏ Edit] [🔄 Rotate] [🗑 Revoke]                            │   │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ ┌─ API Documentation ──────────────────────────────────────────┐    │
│ │ [📖 Full API Docs →] [🧪 API Playground →]                   │    │
│ │ [📋 SDK: TypeScript] [📋 SDK: Python]                         │    │
│ └────────────────────────────────────────────────────────────────┘   │
│                                                                      │
│ Rate limit: 10,000 req/day (Pro) · 50,000 req/day (Business)       │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
APIKeysPage
├── AppShell (shared)
├── PageHeader
│   ├── BackLink ("← Settings")
│   ├── PageTitle ("🔑 API Keys")
│   └── CreateKeyButton
├── SecurityWarning (persistent banner)
├── KeyList
│   └── KeyRow[]
│       ├── KeyName + CreatedDate + CreatorName
│       ├── KeyValue (masked, revealable)
│       ├── CopyButton
│       ├── ScopesList (permission badges)
│       ├── UsageStats (today requests, rate limit, total)
│       ├── RateLimitBar
│       ├── LastUsedTimestamp
│       └── ActionBar
│           ├── EditScopesButton
│           ├── RotateButton
│           └── RevokeButton
├── APIDocSection
│   ├── DocsLink
│   ├── PlaygroundLink
│   └── SDKLinks (TypeScript, Python)
├── RateLimitInfo
└── CreateKeyModal
    ├── KeyNameInput (required)
    ├── ScopeCheckboxes (granular permissions)
    │   ├── read:content, write:content
    │   ├── read:analytics, read:orders
    │   ├── write:publish, admin
    ├── ExpirationSelector (optional: 30d, 90d, 1y, never)
    └── CreateButton (→ shows key ONCE, must copy)
```

---

## 5. Available Scopes

| Scope | Description | Risk Level |
|---|---|---|
| `read:content` | Read content items, drafts, derivatives | Low |
| `write:content` | Create, edit, delete content | Medium |
| `read:analytics` | Read analytics, reports | Low |
| `read:orders` | Read commerce orders | Medium |
| `write:publish` | Publish content to platforms | High |
| `read:finance` | Read financial data | High |
| `admin` | Full workspace admin access | Critical |

---

## 6. User Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Create key | "+ Create" → modal | `APIKeyService/Create` | Key shown once (must copy) | `settings:manage` |
| 2 | Reveal key | "👁 Reveal" | Client-side | Key unmasked for 30s | `settings:manage` |
| 3 | Copy key | "📋" | Clipboard | Toast "Copied" | `settings:manage` |
| 4 | Edit scopes | "✏ Edit" → modal | `APIKeyService/UpdateScopes` | Scopes updated, existing sessions affected | `settings:manage` |
| 5 | Rotate | "🔄 Rotate" → confirm | `APIKeyService/Rotate` | New key generated, old key valid for 24h then revoked | `settings:manage` |
| 6 | Revoke | "🗑 Revoke" → confirm | `APIKeyService/Revoke` | Key immediately invalidated | `settings:manage` |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching | Skeleton rows |
| LOADED | Data received | Key list with usage stats |
| NO_KEYS | No API keys created | "Chưa tạo API key. [+ Create your first key]" |
| KEY_CREATED | Just created a key | ⚠️ "Copy key ngay — sẽ không hiện lại! [📋 Copy]" |
| RATE_LIMITED | Key approaching rate limit (>80%) | Orange warning on usage bar |
| ERROR | API failed | Error with retry |

---

## 8. Tier Gating

| Feature | Free | Starter | Pro | Business |
|---|---|---|---|---|
| API access | ❌ | ❌ | ✅ | ✅ |
| Max keys | — | — | 5 | 20 |
| Rate limit | — | — | 10,000/day | 50,000/day |
| Admin scope | — | — | ❌ | ✅ |

---

## 9. Permissions

Only Owner and Admin can manage API keys.

---

## 10. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached key list | Retry online |
| Create key fail | API error | Toast: "Không tạo được key. [Thử lại]" | Retry |
| Rotate overlap | Old key still active, new key fails | Toast: "Không xoay được key. Key cũ vẫn hoạt động." | Retry |
| Rate limit exceeded | Key hits daily limit | Card shows "🔴 Rate limit reached. Reset: {time}" | Wait or upgrade |
| Revoke fail | API error | Toast: "Không huỷ được key. [Thử lại]" | Retry |

---

## 11. Accessibility

| Element | Requirement |
|---|---|
| Security warning | `role="alert"`, `aria-live="polite"` |
| Key list | `role="list"`, each key `role="listitem"` with `aria-label="{name}: {scope_count} scopes"` |
| Key value (masked) | `aria-label="API key masked. Press reveal to show."` |
| Scope badges | `aria-label="{scope}: {granted/denied}"` |
| Rate limit bar | `role="progressbar"`, `aria-valuenow`, `aria-valuemax` |

---

## 12. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Key row skeletons |
| Key list | 200-500ms | Key rows populate |
| Usage stats | 300-600ms | Rate limit bars animate |
| Scope badges | 200-400ms | Badges fill |
| Create modal | <200ms | Instant open |

---

## 13. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `settings_apikeys.viewed` | Page load | `key_count`, `source` |
| `settings_apikeys.created` | Key created | `key_name`, `scope_count`, `expiration` |
| `settings_apikeys.revealed` | "👁 Reveal" | `key_name` |
| `settings_apikeys.copied` | "📋 Copy" | `key_name` |
| `settings_apikeys.scopes_edited` | Scopes updated | `key_name`, `added_scopes`, `removed_scopes` |
| `settings_apikeys.rotated` | Key rotated | `key_name`, `deprecation_period` |
| `settings_apikeys.revoked` | Key revoked | `key_name`, `total_requests` |
| `settings_apikeys.docs_visited` | "📖 API Docs" or "🧪 Playground" | `destination` |

---

## 14. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/settings/api/+page.svelte`
- **Server load**: `+page.server.ts` → `APIKeyService/List(workspace_id)` + `APIKeyService/GetUsageStats`
- **Create**: Form action `?/create` → `APIKeyService/Create(name, scopes, expiration)` → returns key ONCE
- **Key reveal**: Client-side toggle (key held in server response `data.keys[].raw_key` — shown once per page load)
- **Rotate**: `APIKeyService/Rotate(key_id)` → new key created, old marked deprecated (24h grace)
- **Revoke**: Confirm → `APIKeyService/Revoke(key_id)` → immediate invalidation
- **Rate limits**: `APIKeyService/GetUsage(key_id)` per-key, refreshed every 5m
- **Tier gate**: `load()` checks subscription tier, returns `{ apiEnabled: false }` for Free/Starter

---

## 15. Localization Notes

- Key naming: User-defined (freeform, English expected)
- Scopes: English (`read:content`, `write:publish`)
- Usage: "145 requests hôm nay", "10.000/ngày"
- Security: Vietnamese ("Không chia sẻ key công khai")
- Timestamps: "Tạo: 15/3/2026", "Lần cuối: 2h trước"
- Tone: Security-focused, technical

---

## 16. Design Tokens

| Token | Usage |
|---|---|
| `--color-accent` | Create CTA |
| `--color-danger` | Revoke button, rate limit exceeded |
| `--color-warning` | Rate limit >80%, security warning bg |
| `--color-success` | Scope granted badge |
| `--color-text-secondary` | Key masked text, descriptions |
| `--color-surface-elevated` | Key cards |
| `--color-scope-granted` | ✅ Scope granted (green) |
| `--color-scope-denied` | ❌ Scope denied (neutral) |
| `--font-mono` | Key values (monospace) |

---

## 17. Related Screens

| Screen | Relationship |
|---|---|
| [W120] Workspace Settings | Parent settings |
| External: API Docs | Documentation |
| External: API Playground | Interactive testing |

---

## 18. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (rotate overlap, rate limit), key list a11y, 8 analytics, SvelteKit impl (key reveal, tier gate), localization, 9 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
