---
layer: contracts
canonical: true
created: 2026-04-01
last_updated: 2026-04-09
status: READY
---

# Error Catalog

> Canonical registry of application error codes, HTTP/gRPC status mapping, user messages, and retryability.
> Referenced from: `protobuf_contracts.md` (errors.proto), screen docs (error states), API endpoint map.

> Coverage note: the catalog below is canonical for all active domains in the current corpus. Additional domain-specific subcodes may be added later, but implementers MUST register them here before use instead of inventing prefixes or code ranges ad hoc.

## Error Code Convention

```
<DOMAIN>_<CATEGORY>_<NUMBER>
```

- **Domain**: AUTH, BILLING, COMMERCE, CONTENT, ENGAGEMENT, FINANCE, LIVE, PUBLISH, AI, WORKFLOW, SEEDING, CREATOR_PRO, ADMIN, SYSTEM, INTELLIGENCE, CONNECTOR, NOTIFICATION, GAMIFICATION
- **Category**: INVALID, NOTFOUND, FORBIDDEN, CONFLICT, LIMIT, INTERNAL, EXTERNAL, TIMEOUT
- **Number**: 3-digit sequential per domain-category

Example: `AUTH_INVALID_001`, `BILLING_LIMIT_003`, `AI_EXTERNAL_002`

## Error Response Shape

```json
{
  "error": {
    "code": "BILLING_LIMIT_003",
    "message": "Credit balance insufficient for this operation.",
    "details": {
      "required_credits": 5.0,
      "available_credits": 2.3,
      "purchase_url": "/settings/credits"
    },
    "retryable": false,
    "user_message": "Bạn không đủ credit AI. Vui lòng nạp thêm credit.",
    "user_message_en": "Insufficient AI credits. Please purchase more credits.",
    "help_url": "/support/articles/credit-balance"
  }
}
```

## gRPC ↔ HTTP Status Mapping

| gRPC Status | HTTP Status | When to Use |
|---|---|---|
| OK | 200 | Success |
| INVALID_ARGUMENT | 400 | Validation failure, malformed request |
| UNAUTHENTICATED | 401 | Missing/expired/invalid auth token |
| PERMISSION_DENIED | 403 | Authenticated but lacks required RBAC permission |
| NOT_FOUND | 404 | Resource does not exist or is soft-deleted |
| ALREADY_EXISTS | 409 | Unique constraint violation (duplicate slug, email) |
| FAILED_PRECONDITION | 412 | State machine violation (invalid transition) |
| RESOURCE_EXHAUSTED | 429 | Rate limit or credit limit exceeded |
| INTERNAL | 500 | Server error, unhandled exception |
| UNAVAILABLE | 503 | Service temporarily unavailable (circuit breaker open) |
| DEADLINE_EXCEEDED | 504 | Request timeout, upstream provider timeout |

---

## Auth Errors (AUTH_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| AUTH_INVALID_001 | INVALID_ARGUMENT | 400 | Invalid email format or missing required auth fields | No | "Email không hợp lệ." |
| AUTH_INVALID_002 | INVALID_ARGUMENT | 400 | Password does not meet requirements (length, complexity) | No | "Mật khẩu không đúng yêu cầu." |
| AUTH_NOTFOUND_001 | NOT_FOUND | 404 | User account not found (email not registered) | No | "Tài khoản không tồn tại." |
| AUTH_FORBIDDEN_001 | UNAUTHENTICATED | 401 | Invalid credentials (wrong password) | No | "Email hoặc mật khẩu không đúng." |
| AUTH_FORBIDDEN_002 | PERMISSION_DENIED | 403 | Account suspended by admin | No | "Tài khoản đã bị tạm ngưng." |
| AUTH_FORBIDDEN_003 | PERMISSION_DENIED | 403 | MFA verification failed | No | "Mã xác thực không đúng." |
| AUTH_LIMIT_001 | RESOURCE_EXHAUSTED | 429 | Login request/failed-credential limit exceeded; auth contract defines window and lock | Yes (backoff) | "Quá nhiều lần thử. Vui lòng đợi theo thời gian hiển thị." |
| AUTH_CONFLICT_001 | ALREADY_EXISTS | 409 | Email already registered | No | "Email đã được sử dụng." |

## Billing Errors (BILLING_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| BILLING_LIMIT_001 | RESOURCE_EXHAUSTED | 429 | Monthly AI credit limit exceeded | No | "Đã hết credit AI tháng này." |
| BILLING_LIMIT_002 | RESOURCE_EXHAUSTED | 429 | Feature not available on current plan tier | No | "Tính năng này cần nâng cấp gói." |
| BILLING_LIMIT_003 | RESOURCE_EXHAUSTED | 429 | Insufficient credit balance for operation | No | "Không đủ credit AI." |
| BILLING_FORBIDDEN_001 | PERMISSION_DENIED | 403 | Only workspace Owner can modify billing | No | "Chỉ chủ workspace mới có thể thay đổi thanh toán." |
| BILLING_EXTERNAL_001 | UNAVAILABLE | 503 | Payment gateway error (Stripe/VNPay) | Yes (retry) | "Lỗi cổng thanh toán. Vui lòng thử lại." |
| BILLING_CONFLICT_001 | FAILED_PRECONDITION | 412 | Cannot remove last payment method on paid plan | No | "Không thể xóa phương thức thanh toán cuối cùng." |
| BILLING_CONFLICT_002 | FAILED_PRECONDITION | 412 | Quote expired/changed, confirmed credit ceiling mismatch or inconsistent reservation input | No | "Báo giá đã thay đổi hoặc hết hạn. Vui lòng xác nhận lại." |

## AI / Production Errors (AI_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| AI_EXTERNAL_001 | UNAVAILABLE | 503 | AI provider API error (Veo/Kling/Runway/ElevenLabs) | Yes (retry with backoff) | "Nhà cung cấp AI tạm thời lỗi. Đang thử lại..." |
| AI_EXTERNAL_002 | DEADLINE_EXCEEDED | 504 | AI generation timeout (provider did not respond in time) | Yes (retry once) | "Tạo nội dung mất quá lâu. Đang thử lại." |
| AI_LIMIT_001 | RESOURCE_EXHAUSTED | 429 | AI generation rate limit (per workspace per minute) | Yes (backoff 60s) | "Quá nhiều yêu cầu AI. Vui lòng đợi 1 phút." |
| AI_INVALID_001 | INVALID_ARGUMENT | 400 | Invalid generation parameters (resolution, duration out of bounds) | No | "Thông số tạo video không hợp lệ." |
| AI_FORBIDDEN_001 | PERMISSION_DENIED | 403 | Content flagged by safety filter | No | "Nội dung bị chặn bởi bộ lọc an toàn." |
| AI_INTERNAL_001 | INTERNAL | 500 | Generation pipeline internal error | Yes (retry with different provider if available) | "Lỗi hệ thống tạo nội dung." |

## Commerce Errors (COMMERCE_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| COMMERCE_NOTFOUND_001 | NOT_FOUND | 404 | Product not found or archived | No | "Sản phẩm không tồn tại." |
| COMMERCE_CONFLICT_001 | FAILED_PRECONDITION | 412 | Invalid order state transition | No | "Không thể thay đổi trạng thái đơn hàng." |
| COMMERCE_CONFLICT_002 | ALREADY_EXISTS | 409 | Coupon code already exists | No | "Mã giảm giá đã tồn tại." |
| COMMERCE_LIMIT_001 | RESOURCE_EXHAUSTED | 429 | Stock insufficient for order | No | "Sản phẩm hết hàng." |
| COMMERCE_EXTERNAL_001 | UNAVAILABLE | 503 | E-commerce platform sync failure (Shopee/Lazada API) | Yes (retry) | "Đồng bộ sàn thương mại thất bại." |

## Content Errors (CONTENT_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| CONTENT_NOTFOUND_001 | NOT_FOUND | 404 | Idea, script, asset brief, or continuity object not found or archived | No | "Nội dung không tồn tại hoặc đã được lưu trữ." |
| CONTENT_INVALID_001 | INVALID_ARGUMENT | 400 | Required content fields missing before promotion, submission, or handoff | No | "Thiếu dữ liệu bắt buộc để tiếp tục." |
| CONTENT_CONFLICT_001 | FAILED_PRECONDITION | 412 | Invalid content lifecycle or approval state transition | No | "Không thể chuyển trạng thái nội dung này." |
| CONTENT_CONFLICT_002 | ALREADY_EXISTS | 409 | Review target changed since the reviewer loaded it | No | "Nội dung đã được cập nhật. Vui lòng tải lại trước khi duyệt." |

## Engagement Errors (ENGAGEMENT_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| ENGAGEMENT_NOTFOUND_001 | NOT_FOUND | 404 | Thread, message, contact, or follow-up task not found | No | "Cuộc hội thoại hoặc liên hệ không tồn tại." |
| ENGAGEMENT_CONFLICT_001 | FAILED_PRECONDITION | 412 | Invalid thread status transition or reply attempted on stale/closed thread | No | "Không thể thao tác trên cuộc hội thoại này ở trạng thái hiện tại." |
| ENGAGEMENT_EXTERNAL_001 | UNAVAILABLE | 503 | Platform reply/send/sync request failed | Yes (retry) | "Kết nối nền tảng đang lỗi. Vui lòng thử lại." |
| ENGAGEMENT_LIMIT_001 | RESOURCE_EXHAUSTED | 429 | Auto-reply circuit breaker or reply throttle limit reached | Yes (backoff) | "Hệ thống đang tạm dừng trả lời tự động để tránh lặp." |

## Publish Errors (PUBLISH_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| PUBLISH_FORBIDDEN_001 | PERMISSION_DENIED | 403 | Connected account token expired | No (re-auth needed) | "Kết nối nền tảng đã hết hạn. Vui lòng kết nối lại." |
| PUBLISH_FORBIDDEN_002 | FAILED_PRECONDITION | 412 | Content blocked by packaging QA (compliance = blocked) | No | "Nội dung không đạt kiểm tra chất lượng." |
| PUBLISH_EXTERNAL_001 | UNAVAILABLE | 503 | Platform API error during publish | Yes (retry per schedule) | "Lỗi nền tảng khi đăng bài. Đang thử lại." |
| PUBLISH_EXTERNAL_002 | DEADLINE_EXCEEDED | 504 | Platform API timeout | Yes (retry once) | "Nền tảng phản hồi quá chậm." |
| PUBLISH_CONFLICT_001 | FAILED_PRECONDITION | 412 | Cannot publish — asset still generating | No | "Nội dung đang được tạo. Vui lòng đợi." |

## Finance Errors (FINANCE_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| FINANCE_NOTFOUND_001 | NOT_FOUND | 404 | Settlement, evidence object, proof bundle, or reconciliation record not found | No | "Dữ liệu tài chính không tồn tại." |
| FINANCE_CONFLICT_001 | FAILED_PRECONDITION | 412 | Invalid reconciliation state transition or override attempted on incompatible record state | No | "Không thể đối soát ở trạng thái hiện tại." |
| FINANCE_FORBIDDEN_001 | PERMISSION_DENIED | 403 | Financial detail or override action requires finance visibility/permissions | No | "Bạn không có quyền truy cập dữ liệu tài chính này." |
| FINANCE_EXTERNAL_001 | UNAVAILABLE | 503 | Settlement import/export or upstream financial data source unavailable | Yes (retry) | "Nguồn dữ liệu tài chính tạm thời không khả dụng." |

## Live Errors (LIVE_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| LIVE_NOTFOUND_001 | NOT_FOUND | 404 | Live session, cue, or highlight not found | No | "Phiên live không tồn tại." |
| LIVE_INVALID_001 | INVALID_ARGUMENT | 400 | Run-of-show, offer linkage, or session setup payload is incomplete | No | "Thiết lập phiên live chưa đầy đủ." |
| LIVE_CONFLICT_001 | FAILED_PRECONDITION | 412 | Invalid live session lifecycle transition | No | "Không thể chuyển trạng thái phiên live." |
| LIVE_EXTERNAL_001 | UNAVAILABLE | 503 | Streaming platform metrics/control channel unavailable or disconnected | Yes (retry) | "Kết nối nền tảng live đang gián đoạn." |

## Seeding Errors (SEEDING_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| SEEDING_NOTFOUND_001 | NOT_FOUND | 404 | Sample request, shipment, or outcome record not found | No | "Yêu cầu gửi mẫu không tồn tại." |
| SEEDING_INVALID_001 | INVALID_ARGUMENT | 400 | Carrier or tracking information missing/invalid for shipment action | No | "Thông tin vận chuyển không hợp lệ." |
| SEEDING_CONFLICT_001 | FAILED_PRECONDITION | 412 | Invalid sample request lifecycle transition | No | "Không thể chuyển trạng thái gửi mẫu." |
| SEEDING_EXTERNAL_001 | UNAVAILABLE | 503 | Carrier tracking provider unavailable | Yes (retry) | "Không thể lấy trạng thái vận chuyển lúc này." |

## Creator Pro Errors (CREATOR_PRO_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| CREATOR_PRO_NOTFOUND_001 | NOT_FOUND | 404 | Media kit, rate card, link-in-bio page, or brand deal not found | No | "Tài nguyên Creator Pro không tồn tại." |
| CREATOR_PRO_CONFLICT_001 | FAILED_PRECONDITION | 412 | Invalid brand deal or deliverable pipeline transition | No | "Không thể cập nhật trạng thái hợp tác này." |
| CREATOR_PRO_LIMIT_001 | RESOURCE_EXHAUSTED | 429 | Current workspace plan does not allow this Creator Pro action | No | "Tính năng Creator Pro này yêu cầu gói cao hơn." |

## Workflow Errors (WORKFLOW_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| WORKFLOW_CONFLICT_001 | FAILED_PRECONDITION | 412 | Invalid workflow state transition | No | "Không thể thay đổi trạng thái workflow." |
| WORKFLOW_LIMIT_001 | RESOURCE_EXHAUSTED | 429 | Max concurrent workflow runs exceeded | Yes (queue) | "Đã đạt giới hạn workflow đang chạy." |
| WORKFLOW_NOTFOUND_001 | NOT_FOUND | 404 | Workflow or recipe template not found | No | "Workflow không tồn tại." |

## Admin Errors (ADMIN_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| ADMIN_NOTFOUND_001 | NOT_FOUND | 404 | Target user, workspace, case, incident, or ticket not found | No | "Đối tượng quản trị không tồn tại." |
| ADMIN_FORBIDDEN_001 | PERMISSION_DENIED | 403 | Internal admin role lacks permission for requested action | No | "Bạn không có quyền quản trị cho thao tác này." |
| ADMIN_CONFLICT_001 | FAILED_PRECONDITION | 412 | Impersonation, moderation, or export action blocked by current policy/state | No | "Thao tác quản trị bị chặn bởi chính sách hoặc trạng thái hiện tại." |
| ADMIN_LIMIT_001 | RESOURCE_EXHAUSTED | 429 | Admin export or bulk operation exceeds allowed scope/window | No | "Phạm vi thao tác quản trị vượt quá giới hạn cho phép." |

## System Errors (SYSTEM_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| SYSTEM_INTERNAL_001 | INTERNAL | 500 | Unhandled server error | No | "Lỗi hệ thống. Vui lòng thử lại sau." |
| SYSTEM_CONFLICT_001 | ALREADY_EXISTS | 409 | Idempotency key reused with a different request hash | No | "Mã yêu cầu đã dùng cho nội dung khác. Vui lòng tải lại." |
| SYSTEM_TIMEOUT_001 | DEADLINE_EXCEEDED | 504 | Request processing timeout | Yes (retry once) | "Yêu cầu hết thời gian chờ." |
| SYSTEM_LIMIT_001 | RESOURCE_EXHAUSTED | 429 | Global rate limit exceeded | Yes (backoff) | "Quá nhiều yêu cầu. Vui lòng chờ." |

## Intelligence Errors (INTELLIGENCE_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| INTEL_NOTFOUND_001 | NOT_FOUND | 404 | Trend/signal not found | No | "Xu hướng không tồn tại." |
| INTEL_NOTFOUND_002 | NOT_FOUND | 404 | Competitor entity not found | No | "Đối thủ không tồn tại." |
| INTEL_NOTFOUND_003 | NOT_FOUND | 404 | Opportunity not found | No | "Cơ hội không tồn tại." |
| INTEL_CONFLICT_001 | ALREADY_EXISTS | 409 | Duplicate competitor registration | No | "Đối thủ đã được đăng ký." |
| INTEL_STALE_001 | FAILED_PRECONDITION | 412 | Trend data older than 24h threshold | Yes | "Dữ liệu xu hướng đã cũ, đang cập nhật." |

## Connector Errors (CONNECTOR_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| CONN_AUTH_001 | UNAUTHENTICATED | 401 | OAuth token expired or invalid | Yes (refresh) | "Kết nối đã hết hạn, vui lòng kết nối lại." |
| CONN_AUTH_002 | PERMISSION_DENIED | 403 | Token revoked by platform | No | "Quyền truy cập đã bị thu hồi bởi nền tảng." |
| CONN_SYNC_001 | UNAVAILABLE | 503 | Platform API unavailable during sync | Yes | "Nền tảng tạm thời không khả dụng, đang thử lại." |
| CONN_SYNC_002 | DEADLINE_EXCEEDED | 504 | Sync timeout — platform too slow | Yes | "Đồng bộ hết thời gian, đang thử lại." |
| CONN_RATE_001 | RESOURCE_EXHAUSTED | 429 | Platform rate limit hit | Yes (backoff) | "Đã đạt giới hạn API nền tảng, vui lòng chờ." |
| CONN_REPAIR_001 | FAILED_PRECONDITION | 412 | Connection repair wizard blocked by active sync | No | "Không thể sửa kết nối khi đang đồng bộ." |

## Notification Errors (NOTIFICATION_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| NOTIF_DELIVERY_001 | UNAVAILABLE | 503 | Push notification delivery failed | Yes | "Không gửi được thông báo, sẽ thử lại." |
| NOTIF_TEMPLATE_001 | NOT_FOUND | 404 | Notification template not found | No | "Mẫu thông báo không tồn tại." |
| NOTIF_QUIET_001 | FAILED_PRECONDITION | 412 | Notification suppressed by quiet hours | No | "Thông báo sẽ được gửi sau giờ im lặng." |
| NOTIF_PREF_001 | FAILED_PRECONDITION | 412 | User disabled this notification channel | No | "Người dùng đã tắt kênh thông báo này." |

## Gamification Errors (GAMIFICATION_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| GAMIF_NOTFOUND_001 | NOT_FOUND | 404 | Achievement definition not found | No | "Thành tựu không tồn tại." |
| GAMIF_CONFLICT_001 | ALREADY_EXISTS | 409 | Achievement already unlocked for this user | No | "Thành tựu đã được mở khóa." |
| GAMIF_PRECOND_001 | FAILED_PRECONDITION | 412 | Challenge not active or has expired | No | "Thử thách đã kết thúc hoặc chưa bắt đầu." |
| GAMIF_PRECOND_002 | FAILED_PRECONDITION | 412 | Streak already claimed for today | No | "Streak hôm nay đã được ghi nhận." |

---

## Retry Policy

| Retryable Class | Strategy | Max Retries | Backoff |
|---|---|---|---|
| AI provider errors | Exponential backoff + jitter | 3 | 2s, 4s, 8s |
| Platform API errors | Fixed interval | 3 | 30s, 60s, 120s |
| Payment gateway errors | Fixed interval | 2 | 5s, 15s |
| Rate limit (429) | Wait for Retry-After header or backoff | 3 | Per Retry-After |
| Internal server errors | No auto-retry — alert ops | 0 | — |

## Error Handling Rules

1. **All errors MUST include `code` field** — generic HTTP status alone is insufficient.
2. **User-facing messages MUST be in the user's locale** — Vietnamese primary, English fallback.
3. **Retryable errors MUST include `Retry-After` header** when applicable.
4. **FAILED_PRECONDITION (412) MUST include**: current state, attempted transition, valid transitions from current state.
5. **Financial errors MUST NOT leak amounts** to unauthorized users — only the workspace member who initiated the action sees amount details.
