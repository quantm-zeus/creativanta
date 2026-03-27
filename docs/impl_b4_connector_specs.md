# B4 — Platform Connector Specifications

> **Upstream**: Pack 05 (Connector/Publish), Product Freeze v3.1
> **v1 Connectors**: TikTok, Shopee, Lazada, YouTube, Instagram, Facebook

---

## 1. Connector Lifecycle

```
Disconnected → Connecting → Connected → Syncing → Healthy
                    ↓                       ↓
                Auth Failed            Degraded / Error
                    ↓                       ↓
                Disconnected           Repair Wizard
```

---

## 2. TikTok (Shop + Creator)

| Property | Value |
|---|---|
| **OAuth** | TikTok Login Kit (OAuth 2.0 PKCE) |
| **Scopes** | user.info.basic, video.list, video.publish, comment.list, shop.* |
| **Rate Limits** | 600 req/min (content), 1000 req/min (shop) |
| **Capabilities** | |

| Feature | Capability |
|---|---|
| Publish video | **Native** |
| Read comments | **Native** |
| Reply comments | **Native** |
| Read orders (Shop) | **Native** |
| Read analytics | **Native** |
| DM read/reply | **Manual** (API unavailable) |
| Live management | **Read-only** (no start/stop API) |
| Product catalog | **Native** (TikTok Shop) |

| Data Sync | Frequency | Method |
|---|---|---|
| Videos + metrics | Every 30m | REST API polling |
| Comments | Every 5m | REST API polling |
| Orders (Shop) | Every 15m | REST API + webhooks |
| Settlements (Shop) | Daily 2AM | REST API batch |
| Analytics | Every 1h | REST API |

---

## 3. Shopee

| Property | Value |
|---|---|
| **OAuth** | Shopee Partner API (OAuth 2.0) |
| **Scopes** | shop, order, product, returns, finance, chat |
| **Rate Limits** | 10 req/s per shop |
| **Capabilities** | |

| Feature | Capability |
|---|---|
| Product catalog | **Native** |
| Order lifecycle | **Native** |
| Returns/refunds | **Native** |
| Chat messages | **Native** |
| Settlement reports | **Native** |
| Promotions/vouchers | **Native** |
| Publish content | **Unsupported** (no content API) |
| Analytics | **Native** |

| Data Sync | Frequency | Method |
|---|---|---|
| Orders | Every 10m + webhooks | REST API + Push |
| Products | Every 1h | REST API |
| Chat | Every 2m | WebSocket |
| Settlements | Daily 2AM | REST API batch |
| Returns | Every 15m + webhooks | REST API + Push |

---

## 4. Lazada

| Property | Value |
|---|---|
| **OAuth** | Lazada Open Platform (OAuth 2.0) |
| **Scopes** | product, order, finance, logistics |
| **Rate Limits** | 50 req/s per app, 5000/min |
| **Capabilities** | |

| Feature | Capability |
|---|---|
| Product catalog | **Native** |
| Order lifecycle | **Native** |
| Returns/refunds | **Native** |
| Finance/settlements | **Native** |
| Chat | **Degraded** (limited API) |
| Content publish | **Unsupported** |
| Analytics | **Native** (Seller Center) |

| Data Sync | Frequency | Method |
|---|---|---|
| Orders | Every 15m + webhooks | REST API |
| Products | Every 1h | REST API |
| Settlements | Daily 2AM | REST API batch |
| Returns | Every 15m | REST API |

---

## 5. YouTube (Data API + Content Owner)

| Property | Value |
|---|---|
| **OAuth** | Google OAuth 2.0 |
| **Scopes** | youtube.readonly, youtube.upload, youtube.force-ssl, yt-analytics.readonly |
| **Rate Limits** | 10,000 units/day (quota-based) |
| **Capabilities** | |

| Feature | Capability |
|---|---|
| Upload video | **Native** (resumable upload) |
| Read analytics | **Native** |
| Read comments | **Native** |
| Reply comments | **Native** |
| Manage playlists | **Native** |
| Live stream | **Native** (via Live Streaming API) |
| Community posts | **Degraded** (limited API support) |
| Shorts upload | **Native** |
| Revenue data | **Native** (YouTube Partner Program) |

| Data Sync | Frequency | Method |
|---|---|---|
| Videos + metrics | Every 1h | REST API |
| Comments | Every 10m | REST API |
| Analytics | Every 6h | YouTube Analytics API |
| Revenue | Daily 2AM | YouTube Analytics API |
| Live streams | Real-time | WebSocket |

---

## 6. Instagram (Graph API)

| Property | Value |
|---|---|
| **OAuth** | Facebook/Meta OAuth 2.0 (Instagram Graph API) |
| **Scopes** | instagram_basic, instagram_content_publish, instagram_manage_comments, instagram_manage_insights |
| **Rate Limits** | 200 calls/user/hour |
| **Capabilities** | |

| Feature | Capability |
|---|---|
| Publish photo/reel | **Native** (Container-based) |
| Read insights | **Native** |
| Read comments | **Native** |
| Reply comments | **Native** |
| Stories | **Degraded** (limited publish API) |
| DM management | **Read-only** (limited) |
| Shopping tags | **Native** (Commerce eligible) |
| Live | **Unsupported** (no API) |

| Data Sync | Frequency | Method |
|---|---|---|
| Posts + metrics | Every 1h | REST API |
| Comments | Every 5m | Webhooks + REST |
| Insights | Every 6h | REST API |
| Stories metrics | Every 1h | REST API |

---

## 7. Facebook (Pages API)

| Property | Value |
|---|---|
| **OAuth** | Facebook OAuth 2.0 (Pages API) |
| **Scopes** | pages_read_engagement, pages_manage_posts, pages_messaging, pages_read_user_content |
| **Rate Limits** | 200 calls/user/hour, 4800/app/user |
| **Capabilities** | |

| Feature | Capability |
|---|---|
| Publish post (text/photo/video) | **Native** |
| Read page insights | **Native** |
| Read comments | **Native** |
| Reply comments | **Native** |
| Messenger management | **Native** |
| Shop/Commerce | **Native** (Commerce Manager) |
| Reels | **Native** |
| Live streaming | **Degraded** (limited control) |
| Ads integration | **Manual** (separate Ads API) |

| Data Sync | Frequency | Method |
|---|---|---|
| Posts + metrics | Every 1h | REST API |
| Comments | Webhooks (real-time) | Webhooks |
| Page insights | Every 6h | REST API |
| Messenger | Webhooks (real-time) | Webhooks |

---

## 8. Connector Adapter Pattern (Rust)

```rust
#[async_trait]
pub trait PlatformConnector: Send + Sync {
    fn platform(&self) -> &str;
    
    // Auth
    async fn get_auth_url(&self, redirect_uri: &str) -> Result<String>;
    async fn exchange_token(&self, code: &str) -> Result<OAuthTokens>;
    async fn refresh_token(&self, refresh_token: &str) -> Result<OAuthTokens>;
    
    // Capability
    async fn check_capabilities(&self) -> Result<CapabilityReport>;
    
    // Content
    async fn publish_content(&self, req: PublishRequest) -> Result<PublishResult>;
    async fn get_post_metrics(&self, post_id: &str) -> Result<PostMetrics>;
    
    // Engagement
    async fn get_comments(&self, post_id: &str, cursor: Option<&str>) -> Result<CommentPage>;
    async fn reply_comment(&self, comment_id: &str, text: &str) -> Result<ReplyResult>;
    
    // Commerce (optional)
    async fn get_orders(&self, since: DateTime<Utc>) -> Result<Vec<OrderImport>> {
        Ok(vec![]) // Default: not supported
    }
    async fn get_settlements(&self, period: DateRange) -> Result<Vec<SettlementImport>> {
        Ok(vec![])
    }
    
    // Health
    async fn health_check(&self) -> Result<ConnectorHealth>;
}
```

---

## 9. Capability State Matrix (Summary)

| Action | TikTok | Shopee | Lazada | YouTube | Instagram | Facebook |
|---|---|---|---|---|---|---|
| Publish content | ✅ Native | ❌ | ❌ | ✅ Native | ✅ Native | ✅ Native |
| Read comments | ✅ | ✅ Chat | ✅ Chat | ✅ | ✅ | ✅ |
| Reply comments | ✅ | ✅ Chat | ⚠️ Degraded | ✅ | ✅ | ✅ |
| Read orders | ✅ Shop | ✅ | ✅ | — | ⚠️ Shopping | ⚠️ Commerce |
| Settlements | ✅ Shop | ✅ | ✅ | ✅ Partner | — | — |
| Analytics | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| DM/Chat | 🔧 Manual | ✅ | ⚠️ | — | ⚠️ Read-only | ✅ |
| Live | ⚠️ Read-only | — | — | ✅ | ❌ | ⚠️ |
| Product catalog | ✅ Shop | ✅ | ✅ | — | ⚠️ Shopping | ⚠️ Commerce |

This matrix feeds directly into `capability_snapshots` table and M22 Policy Center.

---

## 10. Implementation Note (Audit v6 — L7)

> This spec provides the connector structure, capability states, sync frequencies, and Rust trait interface. **Detailed per-platform API endpoint mappings, rate limit backoff algorithms, error code mapping, and OAuth flow specifics** will be maintained in code-level documentation within each connector module: `/api/src/connectors/{platform}/README.md`. Implementers should reference each platform's official API documentation alongside this spec.
