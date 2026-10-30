---
layer: contracts
canonical: true
last_verified: 2026-10-29
---

# Platform Connector Specifications

## 1. Capability is an account/action decision

All six platforms remain full product scope. This document specifies candidate integration paths and safe execution defaults; it does not claim Creativanta has received partner approval. An API's existence does not establish access for this app, account, country or commercial use.

Runtime values remain the schema enum: native, read_only, manual, degraded, unsupported. Start every unverified action as manual when an authorized import/export/handoff exists, otherwise unsupported. Promote only the specific account/action after its access record and live/sandbox probe pass. A read probe cannot authorize writes. Preserve capability snapshots at scheduling and execution and recheck immediately before external effects.

## 2. Per-platform access and fallback registry

| Platform/action | Candidate API product | Access evidence required | Until verified |
|---|---|---|---|
| TikTok own profile/video metrics | Display API / approved business product | Approved app product, exact scopes granted by target creator, endpoint probe and allowed fields | User-authorized import |
| TikTok direct video/photo publish | Content Posting API | Approved video.publish; latest creator_info; audited public-post eligibility or explicitly private test restriction; account posting/duration/privacy options | Export/manual upload with proof |
| TikTok comments/replies | Separately approved commercial/business product | Exact comment read/reply endpoint and commercial entitlement; Login Kit does not grant this capability | Native-app handoff + manual thread/evidence |
| TikTok Shop catalog/orders/refunds/settlements | TikTok Shop partner/open platform for target market | Separate Shop app approval, seller grant, account/shop identity, exact product/order/finance permissions and signature protocol | Seller-authorized CSV/report import |
| TikTok live control/metrics | Approved Shop/business product if available | Separate metrics/control/pinning entitlement and source freshness; never infer start/stop support | Manual live plan/cue/pin with labeled imported metrics |
| Shopee catalog/orders/inventory/returns/finance | Shopee Open Platform | Partner application and shop authorization; actual API group permissions; signed-request/refresh implementation and market eligibility | Seller export/CSV; manual stock/return entries |
| Shopee chat/promotions | Approved chat/marketing APIs | Distinct entitlement, messaging-window/opt-in/rate limits and tested write endpoint | Handoff and manual records |
| Lazada catalog/orders/logistics/finance | Lazada Open Platform | Partner registration, seller authorization, exact API permissions and request signing | Seller-authorized import/manual workflow |
| Lazada chat | Approved messaging API if available | Exact endpoint/product approval and conversation policy | Native-app handoff |
| YouTube upload/playlists/comments | YouTube Data API | Enabled project, user grant, required endpoint scopes, quota budget and public-upload/audit eligibility | Export/manual upload and authorized data import |
| YouTube analytics/revenue | YouTube Analytics/Reporting API | Channel/content-owner role, analytics scope; monetary revenue scope and YPP entitlement separately verified | Authorized reports, revenue labeled imported |
| YouTube live | Live Streaming/Data API | Channel live eligibility and API operation support; polling or documented stream events | Manual session control and imported metrics |
| Instagram publish/insights/comments/DM | Current Instagram API with selected login product | Eligible professional account, correct login-product scopes, app review/advanced access; messaging permissions/window separately verified | Export/import and native inbox handoff |
| Instagram stories/shopping/live | Relevant current Meta product | Exact eligible account/action/region support; no inference from photo/reel publishing | Manual or unsupported, with reason |
| Facebook Pages publish/reels/comments/insights | Pages/Graph API | Page grant/tasks, app review, correct version/permissions, token and endpoint probe | Export/import/manual |
| Facebook Messenger/shop/live/ads | Relevant Messenger/Commerce/Live/Marketing API | Separate product permission and messaging/commerce/live policy; ads remain separately configured | Native console handoff/import |

No general content-publish API is assumed for Shopee/Lazada. Community posts, DM, live control and competitor data are not enabled merely because another endpoint succeeds. Wildcard scopes such as shop.* and undocumented scope names are prohibited in executable configuration.

## 3. Source restrictions

Trend/competitor analysis may use authorized account data, licensed commercial datasets, user imports/manual observations, or an explicitly permitted public endpoint. A connected creator account does not grant arbitrary competitor data. Do not use TikTok Research API as a commercial data-source fallback: its eligibility excludes commercial users. No scraping/anti-bot bypass is an implementation dependency.

TikTok direct posting requires current creator info, user control of privacy/interactions/disclosure, content preview and explicit consent. Unaudited clients are limited to private/test posting under TikTok's rules. Do not add promotional watermarks to TikTok delivery; a plan watermark rule cannot override provider policy. A publish log proves distribution, not attributable sales or profit.

## 4. Access record and health computation

The canonical JSON shape for per-action access evidence is in database_schema.md §25.6. For each action record exact platform API product/version, documented endpoint and method, required/granted scopes, app approval status, account/market restrictions, docs/evidence references, checked_at, valid_until and last probe outcome. Evidence contains no tokens. Documentation review is not granted entitlement.

An action is native only if product approval, required scope subset, account/region eligibility, supported endpoint, healthy token/probe and policy constraints all pass. Verified read without write is read_only. Temporary outage on a verified route is degraded. Missing access with authorized handoff is manual; no lawful path is unsupported. Expired evidence cannot silently retain native; require refresh/probe and show the reason. Config verification expires within seven days; tokens/limits/health are checked at execution regardless.

## 5. Authorization and synchronization

Use each provider's documented authorization/signing scheme. Browser/mobile OAuth uses PKCE where supported; partner-key HMAC flows must not be replaced by invented generic OAuth. Verify state/redirect, workspace, one-time nonce, token storage and least-privilege grants. API adapters bind account identity from verified provider results, not client IDs.

Baseline sync targets (not guaranteed freshness): comments 5min; orders 15min plus verified webhooks; products/metrics 1h; settlements daily. Provider quota and scale determine actual schedules. Persist per-account cursor/watermark, overlap windows for late updates and idempotent source identities. A webhook's provider-specific event name/signature must be verified against the pinned API version before deployment; normalized internal events use domain_event_catalog.md. Do not trust a guessed header or provider event alias.

Budget limits per app, account and endpoint from verified configuration and response headers; use Retry-After/backoff/jitter and fair scheduling. Numeric rate-limit examples in old docs are not contractual provider limits. Never log tokens; revoke/delete credentials and stop workers on disconnect.

## 6. Adapter behavior

Adapters expose authorization, token refresh, capability assessment, publish/status, comments/reply, products/orders/settlements and health as separately supported operations. Unsupported operations return a typed capability/precondition error with fallback; **never return an empty success list** to mean unsupported. Every submitted operation persists external_effects identity and unknown-result recovery per [queue design](../05_system/queue_retry_design.md). Tenant scope, RBAC and consent are rechecked by domain owners before adapter calls.

## 7. Acceptance and external gates

Each action must pass: authorized account success; missing permission; wrong account/market; expired/revoked token; quota exhaustion; duplicate webhook; out-of-order update; unknown write result; disconnect during sync; stale evidence; manual proof/import path. Capture actual endpoint/API version/permission/probe evidence in the slice packet. A fake adapter passes development fixtures only, never the external-access gate. Partner approval is an explicit external gate, not a reason to remove its product workflow.

## 8. Official references checked 2026-10-29

- [TikTok content-sharing requirements](https://developers.tiktok.com/docs/en/content-sharing-guidelines)
- [TikTok Research eligibility](https://developers.tiktok.com/docs/en/research-api-faq)
- [TikTok developer products](https://developers.tiktok.com/products/)
- [Shopee Open Platform](https://open.shopee.com/)
- [Lazada Open Platform](https://open.lazada.com/)
- [YouTube Data API](https://developers.google.com/youtube/v3)
- [YouTube Analytics authorization](https://developers.google.com/youtube/analytics/guides/authorization)
- [Instagram Platform](https://developers.facebook.com/docs/instagram-platform/)
- [Facebook Pages API](https://developers.facebook.com/docs/pages-api/)

The first two references were rechecked during remediation; the remaining links are official implementation entry points and require action-level verification during their owning phase. This list is not a claim that every provider grants the requested access.
