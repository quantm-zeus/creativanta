---
layer: features
module: S24
domain: platform
status: SPECIFIED
created: 2026-04-01
canonical: true
upstream: PRD v3.1 §24
---

# S24 — Public API & Developer Platform

> **Upstream**: PRD §24, Pack 09 (Platform)
> **DB tables**: `api_keys`, `api_usage_daily`, `api_webhook_subscriptions`, `webhook_events`, `consent_records`
> **Screens**: 2 (API key management, usage dashboard)

---

## 1. Purpose

Public API allows third-party developers and advanced users to programmatically access Creativanta functionality. Includes API key management, rate limiting, OAuth scopes, and usage tracking.

### Scope

**Covers**: API key CRUD, scoped permissions, rate limiting, usage metering, key rotation/revocation, webhook delivery, public search endpoints.

**Does NOT cover (Non-goals for this module)**:
- Internal gRPC/ConnectRPC contracts (owned by `04_contracts/protobuf_contracts.md`)
- OAuth2 provider implementation (Clerk handles identity)
- Marketplace or app store for third-party integrations (not in v1)
- SDK generation (deferred to post-launch)

### Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Developer | Owner/Admin | Create API keys, configure scopes, monitor usage |
| External App | System (via API key) | Make authenticated API calls |
| System | System | Enforce rate limits, track usage, rotate expiring keys |

## 2. Business Rules

| Rule | Description |
|------|-------------|
| RULE-S24-001 | API keys are workspace-scoped. Tier caps live in `01_business/pricing_and_credits.md`: Starter=3, Pro=10, Business=25, Enterprise=custom |
| RULE-S24-002 | Per-key rate limits are fixed across tiers: **100 req/min read**, **30 req/min write**. Secondary IP limit: **1000 req/min**. Tier differences are enforced through access mode + monthly quota, not different per-minute limits |
| RULE-S24-003 | API access mode is tier-gated: Starter=`read-only`, Pro=`read/write`, Business=`full`, Enterprise=`custom`. API keys support scoped permissions within that tier envelope |
| RULE-S24-004 | Key rotation required every 90 days (warning at 75 days) |
| RULE-S24-005 | Usage is metered into `api_usage_daily`. Standard REST calls consume API request quota, **not AI credits**. If an API-triggered action invokes AI generation, the normal AI credit rules still apply and are recorded in `billable_ai_credits` |
| RULE-S24-006 | Webhook delivery uses exponential backoff with **3 retries** (1s / 10s / 60s). After 100 consecutive failures the webhook subscription is auto-suspended |

## 3. Key Flows

### 3.1 API Key Lifecycle
1. Developer creates API key with selected scopes
2. Key displayed once (SHA256 hash stored)
3. Key used in `Authorization: Bearer <key>` header
4. Usage tracked per-key, per-endpoint
5. Key can be rotated (new key generated, old key has 24h grace period)
6. Key revocation is immediate

### 3.2 Rate Limiting
1. Rate limits enforced per-key using sliding window
2. Response headers: `X-RateLimit-Limit`, `X-RateLimit-Remaining`, `X-RateLimit-Reset`
3. Exceeded → HTTP 429 with `Retry-After` header
4. Burst allowance: 2x limit for 10-second windows
5. Monthly quota enforced by tier: Starter 10k, Pro 100k, Business 1M, Enterprise custom

## 4. State Machine — API Key

| From | To | Trigger | Condition |
|------|----|---------|-----------|
| — | active | Key created | — |
| active | rotating | Rotation initiated | New key generated |
| rotating | active | Grace period expires | Old key invalidated |
| active | revoked | Manual revoke | Immediate |
| active | expired | 90-day auto-expire | No rotation |

## 4.1 Edge Cases

### EC-S24-001: API key used during rotation grace period
- Condition: Both old and new key are valid during 24h rotation window
- Expected behavior: Both keys accepted. Usage metered to the SAME key entity. After grace period, old key returns 401 with body: `{"error": "key_expired", "message": "This key has been rotated. Use the new key."}`

### EC-S24-002: Rate limit exceeded by a burst of parallel requests
- Condition: Client sends 200 requests simultaneously (above 100/min Starter limit)
- Expected behavior: First 100 succeed. Remaining 100 get 429. Sliding window starts from first request. `X-RateLimit-Reset` indicates when next requests are allowed.

### EC-S24-003: API credit deduction for failed requests
- Condition: API call fails due to server error (5xx)
- Expected behavior: Standard API request quota is counted once the request passes authentication and routing. **Billable AI credits** are NOT deducted for 5xx errors. If the request triggers an AI operation and fails before provider execution, `billable_ai_credits = 0`. Metering records include `billable_ai_credits` and `request_counted: true/false`.

## 5. API Surface

> See `04_contracts/api_endpoint_map.md` §4 (Public API) + §32 Extended

| Service | Key RPCs |
|---------|----------|
| `APIKeyService` | Create, List, Revoke, Rotate, GetUsage, GetUsageStats, UpdateScopes |
| `SearchService` | PublicSearch, GetPublicProfile |

### 5.1 Webhook Events (13 eligible)

> Full list with payloads: `04_contracts/domain_event_catalog.md §21`

| Webhook Name | Internal Event | Description |
|---|---|---|
| `content.published` | `publish.succeeded` | Content successfully published to platform |
| `content.publish_failed` | `publish.failed` | Publish attempt failed |
| `order.created` | `order.imported` | New order imported from commerce platform |
| `order.updated` | `order.state_changed` | Order status changed |
| `refund.completed` | `refund.completed` | Refund fully processed |
| `engagement.thread_created` | `thread.created` | New engagement thread (comment/DM) |
| `asset.ready` | `asset.generation_completed` | AI asset generation complete |
| `workflow.completed` | `workflow_run.completed` | Workflow execution finished |
| `billing.plan_changed` | `subscription.changed` | Subscription tier changed |
| `billing.credits_exhausted` | `credits.exhausted` | Credit balance reached zero |
| `brand_deal.updated` | `brand_deal.status_changed` | Brand deal status transition |
| `live.ended` | `live.session_ended` | Live commerce session ended |
| `gamification.achievement` | `achievement.unlocked` | Achievement badge earned |

**Delivery**: HTTP POST with HMAC-SHA256 signature, 3 retries with exponential backoff (1s/10s/60s). 100 consecutive failures → webhook auto-suspended.

### 5.2 OAuth2 Scopes (Third-Party Apps)

> For third-party app integrations (future v2)

| Scope | Access |
|---|---|
| `read:content` | Read assets, scripts, published items |
| `read:analytics` | Read engagement, performance metrics |
| `read:orders` | Read order and commerce data |
| `write:content` | Create/update scripts, assets, publish items |
| `write:orders` | Update order status, manage refunds |

- **Grant type**: Authorization Code with PKCE (no implicit grant)
- **Access token expiry**: 1 hour
- **Refresh token expiry**: 30 days
- **Consent screen**: shows requested scopes with human-readable descriptions

## 6. Acceptance Criteria

```gherkin
Feature: API Key Management
  Scenario: Create and use API key
    Given a workspace on Pro tier
    When developer creates key with read-only scope
    Then key is displayed once
    And subsequent API calls with this key return data within scope
    And calls outside scope return 403

Feature: Rate Limiting
  Scenario: Rate limit exceeded
    Given a Starter tier API key (100/min)
    When 101 requests sent in 1 minute
    Then 101st request returns 429
    And response includes Retry-After header
```

## 7. Native Integrations Roadmap

> Source: Legacy S24 §7-8. These are P2 integrations — NOT launch-blocking.

| Phase | Integration | Type |
|---|---|---|
| P2 | Zapier | Trigger/Action via Public API webhooks |
| P2 | Make (Integromat) | Trigger/Action via Public API |
| P2 | Google Analytics | Native (analytics event forwarding) |
| P2 | Google Calendar | Native (content schedule sync) |
| P2 | Google Sheets | Native (export/import) |
| P3 | Shopify | Native (commerce sync) |
| P3 | WooCommerce | Native (commerce sync) |
| P3 | Notion | Native (content planning) |
| P3 | Canva | Native (design import) |
| P3 | Slack/Discord | Native (notifications) |

> Note: Zapier/Make integrations are enabled by the S24 webhook architecture. No additional backend work required beyond webhook infrastructure.

## 8. Cross-references

- **DB**: `04_contracts/database_schema.md` §18 (`api_keys`, `api_usage_daily`, `api_webhook_subscriptions`, `webhook_events`, `consent_records`)
- **API**: `04_contracts/api_endpoint_map.md` §4
- **Security**: `06_quality_ops/security_threat_model.md` (API abuse prevention)
- **Webhooks**: `04_contracts/domain_event_catalog.md` §21 (13 webhook-eligible events)
- **OAuth Security**: `06_quality_ops/security_threat_model.md` §1B (OAuth token storage, PKCE)
