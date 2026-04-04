# Screen: Web — Forgot Password

> **Screen ID**: W012a
> **Module**: Auth
> **Route**: `/auth/forgot-password`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 02 §S20 (Security), Pack 08 §RBAC, A1 Schema (users)

---

## 1. Purpose & Context

Allows users who have forgotten their password to initiate a password reset flow. This is a critical auth recovery path that must be secure yet user-friendly.

### User Story
> As a user who forgot my password, I want to securely reset it via email verification so I can regain access to my workspace.

### Business Goal
Minimize support tickets for password-related issues while maintaining security.

### When to Use
- User clicks "Quên mật khẩu?" from Login screen
- User receives 401 after failed login attempts

### Entry Points
- Login screen → "Quên mật khẩu?" link
- Direct URL: `/auth/forgot-password`

### Exit Points
- Success → "Check your email" confirmation → redirect to `/auth/login`
- "Quay lại đăng nhập" → `/auth/login`

---

## 2. Preconditions / Postconditions

### Preconditions
- User is NOT authenticated
- User has a registered account

### Postconditions
- Password reset email sent to user's registered email
- Reset token generated with 1-hour expiry
- Audit event logged: `auth.password_reset_requested`

---

## 3. Layout Structure

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1024px) | Centered card (480px max-width) with brand background |
| Tablet (768-1023px) | Centered card (420px max-width) |
| Mobile (≤767px) | Full-width card with padding |

### ASCII Wireframe
```
┌─ Forgot Password ────────────────────────────────────────────────────┐
│                                                                       │
│                    [Creativanta Logo]                                  │
│                                                                       │
│             ┌─ Card ─────────────────────────────────┐               │
│             │                                         │               │
│             │  🔒 Quên mật khẩu?                     │               │
│             │                                         │               │
│             │  Nhập email đã đăng ký. Chúng tôi sẽ   │               │
│             │  gửi link đặt lại mật khẩu cho bạn.    │               │
│             │                                         │               │
│             │  Email                                  │               │
│             │  ┌──────────────────────────────────┐   │               │
│             │  │ email@example.com                │   │               │
│             │  └──────────────────────────────────┘   │               │
│             │                                         │               │
│             │  [████ Gửi link đặt lại ████]          │               │
│             │                                         │               │
│             │  ← Quay lại đăng nhập                  │               │
│             │                                         │               │
│             └─────────────────────────────────────────┘               │
│                                                                       │
└───────────────────────────────────────────────────────────────────────┘
```

### Success State Wireframe
```
┌─ Check Email ─────────────────────────────────────────────────────────┐
│             ┌─ Card ─────────────────────────────────┐               │
│             │                                         │               │
│             │  ✉️ Kiểm tra email của bạn              │               │
│             │                                         │               │
│             │  Chúng tôi đã gửi link đặt lại mật    │               │
│             │  khẩu tới q***@gmail.com.              │               │
│             │                                         │               │
│             │  Link có hiệu lực trong 1 giờ.         │               │
│             │                                         │               │
│             │  Không nhận được email?                 │               │
│             │  [Gửi lại] (disabled 60s countdown)    │               │
│             │                                         │               │
│             │  ← Quay lại đăng nhập                  │               │
│             │                                         │               │
│             └─────────────────────────────────────────┘               │
└───────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
ForgotPasswordPage
├── AuthLayout (shared)
│   ├── BrandLogo
│   └── BackgroundDecoration
├── ForgotPasswordCard (conditional: form OR success)
│   ├── FormView (default)
│   │   ├── LockIcon
│   │   ├── Heading ("Quên mật khẩu?")
│   │   ├── Description
│   │   ├── EmailInput
│   │   │   ├── Label
│   │   │   ├── Input (type="email")
│   │   │   └── ErrorMessage (conditional)
│   │   ├── SubmitButton ("Gửi link đặt lại")
│   │   └── BackToLoginLink
│   └── SuccessView (after submit)
│       ├── MailIcon
│       ├── Heading ("Kiểm tra email của bạn")
│       ├── MaskedEmailDisplay
│       ├── ExpiryNote
│       ├── ResendButton (with countdown)
│       └── BackToLoginLink
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | Display Format |
|---|---|---|
| Masked email | User input | `q***@gmail.com` (first char + *** + @domain) |
| Resend countdown | Client timer | `Gửi lại (45s)` → `Gửi lại` when 0 |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Submit email | Click "Gửi link đặt lại" or Enter | `AuthService/RequestPasswordReset(email)` | Creates reset token, sends email | Switch to Success view | Public |
| 2 | Resend email | Click "Gửi lại" (after countdown) | `AuthService/RequestPasswordReset(email)` | New reset token, invalidates old | Toast "Đã gửi lại email", restart countdown | Public |
| 3 | Back to login | Click "← Quay lại đăng nhập" | — | — | Navigate → `/auth/login` | Public |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| DEFAULT | Page loaded | Empty email form |
| SUBMITTING | Form submitted, waiting API | Button shows spinner + disabled, input readonly |
| SUCCESS | Email sent | Success view with masked email + resend countdown |
| VALIDATION_ERROR | Invalid email format | Inline error under input: "Vui lòng nhập email hợp lệ" |
| RATE_LIMITED | Too many attempts | Toast: "Bạn đã gửi quá nhiều yêu cầu. Vui lòng thử lại sau 5 phút." |
| ERROR | API failure | Toast: "Không thể gửi email. Vui lòng thử lại." + form remains usable |

> **Security note**: API always returns 200 success even if email not found (to prevent email enumeration). UI always shows success view.

---

## 8. Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Email | Required | "Vui lòng nhập email" |
| Email | Valid email format (RFC 5322) | "Vui lòng nhập email hợp lệ" |
| Email | Max 255 characters | "Email không được quá 255 ký tự" |

### Validation Behavior
- **Client-side**: Validate on blur and on submit
- **Server-side**: Rate limit 3 requests per email per hour
- **Error display**: Inline below input field, red text with error icon

---

## 9. Permission Matrix

This is a public page — no authentication required. No RBAC applies.

---

## 10. Navigation Map

```
Forgot Password (/auth/forgot-password)
├── ← /auth/login (Back to login)
├── → Success view (after submit — same page, different view)
└── → /auth/login (after success, "Quay lại đăng nhập")
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network error | No connectivity | Toast: "Không có kết nối mạng. Kiểm tra kết nối và thử lại." | Manual retry |
| Server error (5xx) | API failure | Toast: "Hệ thống đang bảo trì. Vui lòng thử lại sau." | Manual retry |
| Rate limited (429) | >3 requests/hour | Toast + disable form for 5 min | Wait and retry |
| Invalid input | Client validation | Inline error below field | Fix input |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Form | `role="form"`, `aria-label="Quên mật khẩu"` |
| Email input | `aria-required="true"`, `aria-invalid` on error, linked `aria-describedby` for error |
| Submit button | Disabled state announced, loading state announced |
| Success view | `role="status"`, `aria-live="polite"` |
| Focus management | Auto-focus email input on load; focus success heading after submit |
| Keyboard | Enter submits form, Tab order: email → submit → back link |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Page load | <200ms | Instant (static page, SSR) |
| Form submit | 500ms-3s | Button spinner, input disabled |
| Resend cooldown | 60s | Countdown timer in button text |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| LCP | <1.0s (simple form) |
| CLS | 0 (no layout shifts) |
| Bundle size | <15KB (page-specific) |

---

## 15. Real-time Updates

N/A — Static form page.

---

## 16. Localization Notes

- Primary: Vietnamese
- Tone: Calm, reassuring, security-focused
- Email masked format adapts to locale (same pattern all locales)

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `auth.forgot_password.viewed` | Page load | `referrer` |
| `auth.forgot_password.submitted` | Form submit | — (no PII logged) |
| `auth.forgot_password.resend` | Click resend | `resend_count` |
| `auth.forgot_password.back_to_login` | Click back link | — |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-surface-primary` | Card background |
| `--color-text-primary` | Heading, body text |
| `--color-accent` | Submit button |
| `--color-danger` | Error messages |
| `--color-success` | Success icon |
| `--radius-card` | Card border radius (16px) |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W010] Login | Parent — links here |
| [W011] Register | Sibling auth screen |
| [W010] Login | Next step — returns to login after reset via email link |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 1.0 | Initial specification — full 20-point structure | System |
