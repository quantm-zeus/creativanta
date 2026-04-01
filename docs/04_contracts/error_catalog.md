---
layer: contracts
canonical: true
created: 2026-04-01
last_updated: 2026-04-02
status: READY
---

# Error Catalog

> Canonical registry of application error codes, HTTP/gRPC status mapping, user messages, and retryability.
> Referenced from: `protobuf_contracts.md` (errors.proto), screen docs (error states), API endpoint map.

## Error Code Convention

```
<DOMAIN>_<CATEGORY>_<NUMBER>
```

- **Domain**: AUTH, BILLING, COMMERCE, CONTENT, PUBLISH, AI, WORKFLOW, ADMIN, SYSTEM
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
| AUTH_LIMIT_001 | RESOURCE_EXHAUSTED | 429 | Login rate limit exceeded (5 attempts / 15 min) | Yes (backoff) | "Quá nhiều lần thử. Vui lòng đợi 15 phút." |
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

## Publish Errors (PUBLISH_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| PUBLISH_FORBIDDEN_001 | PERMISSION_DENIED | 403 | Connected account token expired | No (re-auth needed) | "Kết nối nền tảng đã hết hạn. Vui lòng kết nối lại." |
| PUBLISH_FORBIDDEN_002 | FAILED_PRECONDITION | 412 | Content blocked by packaging QA (compliance = blocked) | No | "Nội dung không đạt kiểm tra chất lượng." |
| PUBLISH_EXTERNAL_001 | UNAVAILABLE | 503 | Platform API error during publish | Yes (retry per schedule) | "Lỗi nền tảng khi đăng bài. Đang thử lại." |
| PUBLISH_EXTERNAL_002 | DEADLINE_EXCEEDED | 504 | Platform API timeout | Yes (retry once) | "Nền tảng phản hồi quá chậm." |
| PUBLISH_CONFLICT_001 | FAILED_PRECONDITION | 412 | Cannot publish — asset still generating | No | "Nội dung đang được tạo. Vui lòng đợi." |

## Workflow Errors (WORKFLOW_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| WORKFLOW_CONFLICT_001 | FAILED_PRECONDITION | 412 | Invalid workflow state transition | No | "Không thể thay đổi trạng thái workflow." |
| WORKFLOW_LIMIT_001 | RESOURCE_EXHAUSTED | 429 | Max concurrent workflow runs exceeded | Yes (queue) | "Đã đạt giới hạn workflow đang chạy." |
| WORKFLOW_NOTFOUND_001 | NOT_FOUND | 404 | Workflow or recipe template not found | No | "Workflow không tồn tại." |

## System Errors (SYSTEM_*)

| Code | gRPC | HTTP | Description | Retryable | User Message |
|---|---|---|---|---|---|
| SYSTEM_INTERNAL_001 | INTERNAL | 500 | Unhandled server error | No | "Lỗi hệ thống. Vui lòng thử lại sau." |
| SYSTEM_TIMEOUT_001 | DEADLINE_EXCEEDED | 504 | Request processing timeout | Yes (retry once) | "Yêu cầu hết thời gian chờ." |
| SYSTEM_LIMIT_001 | RESOURCE_EXHAUSTED | 429 | Global rate limit exceeded | Yes (backoff) | "Quá nhiều yêu cầu. Vui lòng chờ." |

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
