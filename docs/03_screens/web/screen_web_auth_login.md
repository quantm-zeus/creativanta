# Screen: Web — Authentication: Login

> **Screen ID**: W010
> **Module**: Auth
> **Route**: `/login`
> **Platform**: Web (SvelteKit)
> **Upstream**: Product Freeze §27, Pack 01, Pack 02 §S20, A1 Schema (users, sessions)

---
## 1. Purpose & Context

The Login page is the primary authentication entry point for Creativanta web application. It supports email/password login, social OAuth (Google, Apple), and magic link authentication. This is the first impression screen — it must look polished, trustworthy, and load fast.

### User Goals
- Quickly authenticate and access their workspace
- Recover access if password is forgotten

### Business Goals
- Minimize login friction to reduce abandonment
- Establish brand trust from first interaction
- Collect authentication telemetry for security

### When This Screen Is Used
- First visit / returning user opens app
- Session expired — redirect from any authenticated route
- Explicit logout then re-login
- Password reset completion → redirect back to login

### Entry Points
- Direct URL: `/login`
- Redirect from any authenticated route when session expired (with `?redirect=<original_url>`)
- Register page: "Đã có tài khoản? Đăng nhập"
- Password reset completion page

### Exit Points
- Successful login → Workspace Selector (if multiple workspaces) or Dashboard (if single workspace)
- "Đăng ký" link → `/register`
- "Quên mật khẩu" link → `/forgot-password`
- Footer links → `/terms`, `/privacy`

---
## 2. Preconditions / Postconditions

### Preconditions
- User is NOT authenticated (if authenticated, redirect to `/`)
- App loads Clerk SDK (or internal auth service)

### Postconditions
- On success: JWT session created, user redirected to workspace or redirect URL
- On failure: Error shown, attempt logged for rate limiting
- Login event stored in `user_sessions` and audit log

---
## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1024px) | Split layout: 50% Brand Panel (left) + 50% Form Panel (right) |
| Tablet (768-1023px) | Form panel 60% width, brand panel blurred background |
| Mobile (≤767px) | Form only, full width. Brand panel hidden. Logo above form. |

### ASCII Wireframe
```
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│ ┌─ Left Panel (Brand, 50%) ─────┐ ┌─ Right Panel (Form, 50%) ────┐│
│ │                                │ │                                ││
│ │ [Creativanta Logo]             │ │ Đăng nhập                      ││
│ │                                │ │                                ││
│ │ "Nền tảng quản lý nội dung    │ │ [🔵 Đăng nhập với Google]     ││
│ │  thông minh cho creator        │ │ [⬛ Đăng nhập với Apple]      ││
│ │  Việt Nam"                     │ │                                ││
│ │                                │ │ ────── hoặc ──────             ││
│ │ [Background gradient/          │ │                                ││
│ │  animated illustration]        │ │ Email:                         ││
│ │                                │ │ [quanm@gmail.com            ]  ││
│ │                                │ │ Mật khẩu:                      ││
│ │                                │ │ [••••••••••          👁 ]      ││
│ │                                │ │                                ││
│ │                                │ │ [☐ Ghi nhớ đăng nhập]         ││
│ │                                │ │ [Quên mật khẩu?]              ││
│ │                                │ │                                ││
│ │                                │ │ [═══ Đăng nhập ═══]           ││
│ │                                │ │                                ││
│ │                                │ │ Chưa có tài khoản?             ││
│ │                                │ │ [Đăng ký miễn phí →]          ││
│ └────────────────────────────────┘ └────────────────────────────────┘│
│                                                                      │
│ Footer: © 2026 Creativanta · Chính sách bảo mật · Điều khoản       │
│ Ngôn ngữ: [Tiếng Việt ▾]                                            │
└──────────────────────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
LoginPage
├── SplitLayout
│   ├── BrandPanel
│   │   ├── Logo (Creativanta wordmark + icon)
│   │   ├── Tagline ("Nền tảng quản lý nội dung thông minh cho creator Việt Nam")
│   │   └── BackgroundVisual (gradient + animated illustration)
│   └── FormPanel
│       ├── PageTitle ("Đăng nhập")
│       ├── SocialLoginGroup
│       │   ├── GoogleLoginButton (icon + "Đăng nhập với Google")
│       │   └── AppleLoginButton (icon + "Đăng nhập với Apple")
│       ├── DividerWithText ("hoặc")
│       ├── LoginForm
│       │   ├── EmailInput
│       │   │   ├── Label ("Email")
│       │   │   ├── TextInput (type="email", placeholder="email@example.com")
│       │   │   └── ErrorMessage (conditional)
│       │   ├── PasswordInput
│       │   │   ├── Label ("Mật khẩu")
│       │   │   ├── TextInput (type="password")
│       │   │   ├── ToggleVisibility (👁 button)
│       │   │   └── ErrorMessage (conditional)
│       │   ├── OptionsRow
│       │   │   ├── RememberMeCheckbox ("Ghi nhớ đăng nhập")
│       │   │   └── ForgotPasswordLink ("Quên mật khẩu?")
│       │   └── SubmitButton ("Đăng nhập", primary CTA, full-width)
│       ├── RegisterPrompt
│       │   ├── Text ("Chưa có tài khoản?")
│       │   └── RegisterLink ("Đăng ký miễn phí →")
│       └── ErrorBanner (conditional — for general login errors)
├── Footer
│   ├── Copyright ("© 2026 Creativanta")
│   ├── PrivacyLink ("Chính sách bảo mật")
│   ├── TermsLink ("Điều khoản")
│   └── LanguageSelector
└── ToastContainer (for success/error toasts)
```

---
## 5. Displayed Data

| Element | Data Source | Format |
|---|---|---|
| Redirect URL | URL query param `?redirect=` | Hidden, used post-login |
| Remember Me state | localStorage `creativanta_remember` | Boolean |
| Previous email | localStorage (if "remember me" was checked) | Pre-filled in email field |
| Error messages | Auth API error response | Localized Vietnamese text |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | UI Result | Navigation |
|---|---|---|---|---|---|---|
| 1 | Google OAuth login | Click "Đăng nhập với Google" | Primary CTA | OAuth redirect to Google | Loading overlay → redirect | → `/` or redirect URL |
| 2 | Apple OAuth login | Click "Đăng nhập với Apple" | Primary CTA | OAuth redirect to Apple | Loading overlay → redirect | → `/` or redirect URL |
| 3 | Email/password login | Click "Đăng nhập" button | Primary CTA | `POST /api/auth/login` `{email, password, remember}` | Button spinner → redirect | → `/workspaces` or redirect URL |
| 4 | Toggle password visibility | Click 👁 icon | Inline | — | Password field toggles text/password | — |
| 5 | Remember me | Toggle checkbox | Inline | — | Store preference in localStorage | — |
| 6 | Forgot password | Click "Quên mật khẩu?" | Link | — | — | → `/forgot-password` |
| 7 | Register | Click "Đăng ký miễn phí" | Link | — | — | → `/register` |
| 8 | Change language | Click language selector | Inline | — | Page reloads in selected language | — |
| 9 | View privacy policy | Click "Chính sách bảo mật" | Footer link | — | — | → `/privacy` (new tab) |
| 10 | View terms | Click "Điều khoản" | Footer link | — | — | → `/terms` (new tab) |

---
## 7. Validation Rules

### Field Validation (Real-time)

| Field | Rule | Error Message | Trigger |
|---|---|---|---|
| Email | Required | "Vui lòng nhập email" | On blur if empty |
| Email | Valid format (RFC 5322) | "Email không hợp lệ" | On blur |
| Email | Max 255 chars | "Email quá dài" | On input |
| Password | Required | "Vui lòng nhập mật khẩu" | On blur if empty |
| Password | Min 8 characters | "Mật khẩu phải có ít nhất 8 ký tự" | On blur |

### Submit-time Validation

| Rule | Error Message | Display |
|---|---|---|
| Invalid credentials | "Email hoặc mật khẩu không đúng" | Error banner above form |
| Account locked | "Tài khoản đã bị khóa. Vui lòng liên hệ hỗ trợ." | Error banner + support link |
| Account not verified | "Tài khoản chưa được xác minh. [Gửi lại email xác minh →]" | Error banner + resend link |
| Rate limited | "Quá nhiều lần thử. Vui lòng đợi {minutes} phút." | Error banner with countdown |
| Server error | "Đã xảy ra lỗi. Vui lòng thử lại sau." | Error banner |

### Rate Limiting
- Max 5 failed attempts per 15-minute window per IP
- After 5 failures: show countdown timer + suggest password reset
- After 10 failures in 1 hour: temporary IP block (30 minutes)

---
## 8. States

| State | Condition | Visual |
|---|---|---|
| IDLE | Initial page load, no interaction | Clean form, all fields empty (or email pre-filled if "remember me"). SubmitButton enabled. |
| INPUT | User is typing | Real-time validation feedback. Hints show below fields. |
| VALIDATING | Form submitted, field validation running | Inline error messages appear. Form stays interactive. |
| SUBMITTING | API call in progress | SubmitButton shows spinner + "Đang đăng nhập...". Form inputs disabled. Social buttons disabled. |
| SUCCESS | Auth successful | Brief success state (green flash) → immediate redirect. Toast: "Đăng nhập thành công" |
| ERROR_CREDENTIALS | Wrong email/password | Error banner slides in above form. Email field retains value. Password field clears. Focus moves to password field. |
| ERROR_LOCKED | Account locked | Error banner with support link. Form disabled. |
| ERROR_UNVERIFIED | Email not verified | Error banner with "Resend verification" action button. |
| ERROR_RATE_LIMITED | Too many attempts | Error banner with countdown timer. Form disabled until timer expires. |
| ERROR_NETWORK | Network failure | Error banner: "Không có kết nối mạng. Kiểm tra kết nối và thử lại." |
| OAUTH_REDIRECTING | Social button clicked | Full-page loading overlay: "Đang chuyển hướng đến {provider}..." |

---
## 9. Interaction Details

| Interaction | Behavior |
|---|---|
| Tab order | Email → Password → Remember Me → Forgot Password → Submit → Register |
| Enter key | In any form field → submits form (same as clicking Submit) |
| Paste email | Auto-trims whitespace, validates on paste |
| Auto-fill | Browser auto-fill supported. Email + password fields have proper `autocomplete` attributes |
| Password visibility | Toggle on click. Default: hidden. Icon changes: 👁 (show) ↔ 👁‍🗨 (hide) |
| Error dismissal | Click × on error banner OR start typing → error banner fades out |
| OAuth popup | Opens in new window (desktop) or redirect (mobile) |  

---
## 10. Responsive / Adaptive Behavior

| Breakpoint | Behavior |
|---|---|
| ≥1024px | Split layout: Brand panel (50%) + Form panel (50%) |
| 768-1023px | Brand panel becomes blurred background. Form centered, max-width 420px |
| ≤767px | Form only, full width with padding. Logo (compact) above form title. Brand panel hidden. |
| ≤320px | Form inputs stack with max-width 100%. Social buttons stack vertically. |

---
## 11. Permissions & Role-based Behavior

N/A — Login is a pre-authentication screen. No RBAC applies.

---
## 12. Edge Cases & Exception Flows

| Edge Case | Handling |
|---|---|
| User already authenticated | Redirect to `/` immediately. Do not show login form. |
| Redirect URL is external domain | Ignore redirect param. Always redirect to internal routes only (XSS prevention). |
| OAuth callback error | Show error banner: "Đăng nhập qua {provider} thất bại. Vui lòng thử lại." |
| Browser blocks popup (OAuth) | Fallback to redirect-based OAuth flow |
| Clerk/auth service unavailable | Full-page error: "Hệ thống đăng nhập tạm thời không khả dụng. Vui lòng thử lại sau." |
| Account deleted/deactivated | "Tài khoản này không còn hoạt động. Liên hệ support@creativanta.vn." |
| Multiple tabs | Only one active session per browser. Other tabs receive "session changed" event → reload. |

---
## 13. Dependencies

| Dependency | Purpose |
|---|---|
| Auth Service (Clerk / internal) | Authentication provider |
| Google OAuth | Social login |
| Apple OAuth | Social login |
| reCAPTCHA v3 | Bot protection (invisible, score-based) |
| Rate limiter (server) | Brute force protection |

---
## 14. Copy / Text Guidance

| Element | Vietnamese | English |
|---|---|---|
| Page title | "Đăng nhập" | "Sign In" |
| Social Google | "Đăng nhập với Google" | "Sign in with Google" |
| Social Apple | "Đăng nhập với Apple" | "Sign in with Apple" |
| Divider | "hoặc" | "or" |
| Email label | "Email" | "Email" |
| Password label | "Mật khẩu" | "Password" |
| Remember | "Ghi nhớ đăng nhập" | "Remember me" |
| Forgot | "Quên mật khẩu?" | "Forgot password?" |
| Submit | "Đăng nhập" | "Sign In" |
| Register prompt | "Chưa có tài khoản?" | "Don't have an account?" |
| Register link | "Đăng ký miễn phí →" | "Sign up free →" |

---
## 15. Accessibility

| Element | Requirement |
|---|---|
| Form | `role="form"`, `aria-label="Biểu mẫu đăng nhập"` |
| Email input | `aria-required="true"`, `aria-invalid` on error, `aria-describedby` for error message |
| Password input | `aria-required="true"`, toggle button has `aria-label="Hiện mật khẩu"` |
| Error banner | `role="alert"`, `aria-live="assertive"` |
| Social buttons | `aria-label` includes provider name |
| Focus | Auto-focus email field on page load. On error, focus moves to first error field. |
| Keyboard | Full keyboard navigation. Enter submits. Tab cycles through all interactive elements. |
| Color contrast | All text meets WCAG 2.1 AA (4.5:1). Error colors not sole indicator — icon + text used. |
| Screen reader | All icons have `aria-label` or `sr-only` text |

---
## 16. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.0s (form panel render) |
| FCP | < 0.5s (SSR delivers full HTML) |
| CLS | 0 (no layout shift — fixed layout) |
| TTI | < 1.0s |
| Bundle | < 20KB page-specific JS (auth forms are lightweight) |

---
## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `auth.login.page_viewed` | Page load | `has_redirect`, `source` |
| `auth.login.social_clicked` | Social button click | `provider` (google/apple) |
| `auth.login.form_submitted` | Submit button click | — |
| `auth.login.success` | Login successful | `provider` (email/google/apple), `time_to_login_ms` |
| `auth.login.failed` | Login failed | `provider`, `error_type` (credentials/locked/rate_limited) |
| `auth.login.forgot_clicked` | Forgot password link | — |
| `auth.login.register_clicked` | Register link | — |

---
## 18. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(auth)/login/+page.svelte`
- **Layout**: `src/routes/(auth)/+layout.svelte` (no App Shell — standalone auth layout)
- **Server load**: `+page.server.ts` → check if already authenticated, redirect if so
- **Form action**: SvelteKit form actions for progressive enhancement (works without JS)

### Security
- CSRF token included in form (SvelteKit built-in)
- reCAPTCHA v3 score check on server (block if score < 0.3)
- Password never logged or stored in plaintext
- Rate limiter: Redis-based sliding window counter
- Secure cookie: `HttpOnly`, `SameSite=Strict`, `Secure`

---
## 5. Data Binding & Display Format
*(Refer to screen-specific data binding in section above)*


---
## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W011] Register | New account creation |
| [W001] Home Dashboard | Destination after login |
| [W002] Workspace Selector | Destination if user has multiple workspaces |
---
## Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached data | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được dữ liệu. [Thử lại]" | Retry |
| Not found | 404 | "Không tìm thấy" → navigate back | Back |
| Permission denied | 403 | "Không có quyền truy cập" | Contact admin |

---
## Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Screen mount | 0ms | App bar + shimmer placeholders |
| Primary data | 200-500ms | Content populates progressively |
| User action | <1s | Inline spinner → result feedback |

---
## Localization Notes

- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator: "1.200.000đ")
- Date: DD/MM/YYYY
- Numbers: dot separator (1.234)
- Relative time: "2 giờ trước", "1 ngày trước"
- Tone: Friendly, action-oriented

---
## Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-accent` | Primary actions, CTAs |
| `--color-success` | Positive states, confirmations |
| `--color-warning` | Warning indicators |
| `--color-danger` | Error states, destructive actions |
| `--color-surface-elevated` | Cards, elevated surfaces |

---
## Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | Patch | Removed duplicate template sections. Replaced with screen-specific Error Handling, Accessibility, Loading, Localization, Design Tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
