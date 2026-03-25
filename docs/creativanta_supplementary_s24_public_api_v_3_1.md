# Creativanta — Supplementary Spec S24 — Public API & Integrations v3.1

## 0. Traceability Header

- **Upstream**: PRD §32B (Real-time), Tech Stack ADR (gRPC/REST), Pack 02 (Schema), Pack 05 (Connector)
- **Pack dependencies**: Pack 02 (API contract), Pack 05 (Connector hub), Pack 08 (Tier limits)
- **See also**: S26 §17 (Public API Key Management) — admin-side API key lifecycle, abuse detection, suspend/revoke. S26 §16 — outbound webhook delivery monitoring.
- **Scope**: v1 — basic public API + webhooks. P2 — developer portal, marketplace.

---

## 1. Mục tiêu

Mở Public API cho third-party developers và integrations, tạo ecosystem quanh Creativanta platform.

---

## 2. Public REST API v1

### 2.1 Base URL
```
https://api.creativanta.com/v1/
```

### 2.2 API Endpoints

| Resource | Method | Endpoint | Description |
|---|---|---|---|
| **Workspace** | GET | /workspaces | List workspaces |
| **Content** | GET | /content | List content items |
| | GET | /content/{id} | Get content detail |
| | POST | /content | Create content draft |
| **Publish** | GET | /publish/queue | List publish queue |
| | POST | /publish | Schedule publish |
| **Analytics** | GET | /analytics/content/{id} | Content performance |
| | GET | /analytics/overview | Dashboard metrics |
| **Commerce** | GET | /orders | List orders |
| | GET | /products | List products |
| **Profit** | GET | /profit/summary | Profit summary |
| | GET | /profit/per-content | Revenue per content |
| **Contacts** | GET | /threads | List inbox threads |

### 2.3 Response Format

```json
{
  "data": { ... },
  "meta": {
    "pagination": {
      "page": 1,
      "per_page": 20,
      "total": 150,
      "total_pages": 8
    }
  },
  "errors": null
}
```

### 2.4 Error Format

```json
{
  "data": null,
  "errors": [
    {
      "code": "RESOURCE_NOT_FOUND",
      "message": "Content with ID xxx not found",
      "field": null
    }
  ]
}
```

---

## 3. Authentication

### 3.1 API Key Auth
- Generated from Settings → Developer → API Keys
- Header: `Authorization: Bearer {api_key}`
- Per-workspace scoping
- Key rotation: user can regenerate, old key expires in 24h

### 3.2 OAuth 2.0 (for third-party apps)
- Grant type: Authorization Code
- Scopes: `read:content`, `write:content`, `read:analytics`, `read:commerce`, `write:publish`
- Token expiry: 1 hour (access), 30 days (refresh)
- PKCE required for public clients

### 3.3 Tier Access

| Feature | Free | Starter | Pro | Business | Enterprise |
|---|---|---|---|---|---|
| API access | ❌ | ✅ (read) | ✅ (read+write) | ✅ | ✅ |
| API keys | 0 | 1 | 3 | 10 | Unlimited |
| OAuth apps | 0 | 0 | 1 | 5 | Unlimited |
| Webhooks | 0 | 3 | 10 | 50 | Unlimited |

---

## 4. Rate Limiting

### 4.1 Per-Plan Limits

| Plan | Requests/minute | Requests/day | Burst (per second) |
|---|---|---|---|
| Starter | 30 | 5,000 | 5 |
| Pro | 60 | 20,000 | 10 |
| Business | 120 | 100,000 | 20 |
| Enterprise | 300 | 500,000 | 50 |

### 4.2 Rate Limit Headers

```
X-RateLimit-Limit: 60
X-RateLimit-Remaining: 45
X-RateLimit-Reset: 1710000000
Retry-After: 30  (only on 429)
```

### 4.3 Rate Limit Response
- HTTP 429 Too Many Requests
- Retry-After header with seconds until reset
- Graceful back-off recommended

---

## 5. Webhooks

### 5.1 Supported Events

| Event Type | Payload | Trigger |
|---|---|---|
| `content.created` | Content object | New content draft |
| `content.published` | Publish Item | Content published to platform |
| `content.performance_update` | Analytics snapshot | Daily metrics update |
| `order.created` | Order object | New order imported |
| `order.status_changed` | Order + old/new status | Order status transition |
| `profit.daily_summary` | Daily P&L | End of day calculation |
| `thread.created` | Thread object | New inbox thread |
| `thread.intent_updated` | Thread + intent | Intent detection change |
| `workflow.completed` | Workflow Run | Workflow execution done |
| `workflow.failed` | Workflow Run + error | Workflow execution failed |
| `subscription.changed` | Subscription event | Plan upgrade/downgrade |
| `connector.degraded` | Connector status | Platform connection issue |
| `alert.triggered` | Alert object | Any system alert |

### 5.2 Webhook Security
- HMAC-SHA256 signature in `X-Creativanta-Signature` header
- Signing secret generated per webhook endpoint
- Timestamp included to prevent replay attacks (window: 5 min)
- Retry policy: 3 retries with exponential backoff (1s, 10s, 60s)
- Webhook delivery log: last 7 days of deliveries visible in dashboard

### 5.3 Webhook Management UI
- Settings → Developer → Webhooks
- Add/edit/delete endpoints
- Select events per endpoint
- Test webhook (send sample payload)
- Delivery log with status + response code

---

## 6. Developer Portal (P2 Roadmap)

### 6.1 v1 Scope
- API documentation: auto-generated from OpenAPI spec
- Inline code examples (curl, JavaScript, Python)
- Authentication guide
- Webhook guide
- Hosted at: docs.creativanta.com/api

### 6.2 P2 Scope (Post-Launch)
- Interactive API explorer (try-it-out)
- SDK packages (JavaScript, Python)
- App marketplace for third-party integrations
- OAuth app registration self-serve
- Community developer forum

---

## 7. Zapier / Make.com Integration (P2)

### 7.1 Architecture
- Creativanta registers as Zapier/Make integration
- Uses Public API REST endpoints
- Triggers: webhook events → Zapier/Make
- Actions: API calls from Zapier/Make

### 7.2 Supported Triggers (Zapier)
- New content published
- New order created
- New inbox thread
- Profit daily summary
- Alert triggered

### 7.3 Supported Actions (Zapier)
- Create content draft
- Schedule publish
- Add note to thread
- Trigger workflow

---

## 8. Native Integrations (v1 Basics + P2 Expansion)

### 8.1 v1 Native Integrations

| Integration | Type | Purpose |
|---|---|---|
| Google Analytics | Data import | Website traffic → content ROI |
| Google Calendar | Sync | Content calendar ↔ Google Calendar |
| Google Sheets | Export | One-click data export |

### 8.2 P2 Native Integrations

| Integration | Type | Purpose |
|---|---|---|
| Shopify | Commerce | Product sync, order import |
| WooCommerce | Commerce | Product sync, order import |
| Notion | Content | Script drafts ↔ Notion pages |
| Canva | Design | Import designs as assets |
| Mailchimp | Marketing | Subscriber sync, email campaigns |
| Slack | Notification | Alert delivery to Slack channels |
| Discord | Notification | Alert delivery to Discord |

---

## 9. Technical Implementation

### 9.1 API Gateway
- Rate limiting enforced at Rust middleware layer (Tower)
- API key validation via Dragonfly cache
- Request logging for analytics + abuse detection
- OpenAPI 3.1 spec auto-generated from Axum router

### 9.2 Webhook Delivery
- Rust async worker processes webhook queue
- Redis Streams (via Dragonfly) for reliable delivery
- Dead-letter queue after 3 failed attempts
- Dashboard shows delivery status

---

## 10. Acceptance Scenarios

- Developer tạo API key → gọi GET /content → nhận danh sách content JSON
- Developer đăng ký webhook content.published → publish content → webhook delivered ≤ 5s
- Developer vượt rate limit → nhận 429 + Retry-After header → retry success
- Developer dùng OAuth → user authorize → app nhận token → gọi API thành công
- Webhook delivery fails → retry 3 times → log failure → admin sees in dashboard
