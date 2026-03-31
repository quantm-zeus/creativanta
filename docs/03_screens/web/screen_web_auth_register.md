# Screen: Web — Authentication: Register

> **Screen ID**: W011
> **Module**: Auth
> **Route**: `/register`
> **Platform**: Web (SvelteKit)
> **Upstream**: Product Freeze §27 (Identity/Auth), A1 Schema (users, workspaces), B4 Connectors (OAuth providers)

---
## 1. Purpose & Context

The Registration page is the entry point for new users into the Creativanta ecosystem. It supports email/password registration and social OAuth (Google, Apple). After registration, users go through email verification → workspace creation → onboarding wizard, which is the critical funnel from anonymous visitor to active creator.

### User Goals
- Create an account quickly (< 2 minutes from landing to onboarding)
- Use existing social login for frictionless registration
- Understand what Creativanta offers before committing

### Business Goals
- Maximize registration conversion rate (target: >40% from landing page)
- Capture verified email for lifecycle marketing
- Establish workspace context early for personalized onboarding
- Minimize registration abandonment

### When This Screen Is Used
- First-time visitor from marketing, referral, or organic traffic
- User who was previously on free trial and wants to create a full account
- Invited team member who needs to create their account (invited flow variant)

### Entry Points
- Direct URL: `/register`
- Marketing landing page CTA: "Bắt đầu miễn phí"
- Login page: "Chưa có tài khoản? Đăng ký →"
- Referral link: `/register?ref=[code]`
- Team invitation email: `/register?invite=[token]`

### Exit Points
- Successful registration → Email verification → Workspace creation → Onboarding (W006)
- OAuth success → Workspace creation → Onboarding (W006)
- "Đăng nhập" link → Login (W010)

---
## 2. Preconditions / Postconditions

### Preconditions
- User is NOT authenticated (redirect to `/` if already logged in)
- OAuth providers are configured and reachable
- If invite token present: token is valid and not expired

### Postconditions
- User record created in `users` table
- If email registration: verification email sent, `email_verified = false`
- If OAuth: `email_verified = true` (from provider), skip email verification
- If invite token: user auto-added to inviting workspace with assigned role
- Registration event logged for analytics

---
## 3. Screen Layout

### Responsive Behavior
| Breakpoint | Layout |
|---|---|
| Desktop (≥1280px) | Split panel: 50% brand + 50% form |
| Tablet (768-1279px) | Split panel: 40% brand + 60% form |
| Mobile (≤767px) | Full-width form only, brand as compact header |

### ASCII Wireframe
```
┌──────────────────────────────────────────────────────────────────────┐
│ ┌─ Brand Panel (50%) ────────────────┐ ┌─ Form Panel (50%) ─────────┐│
│ │                                     │ │                             ││
│ │ [Creativanta Logo]                  │ │ Tạo tài khoản miễn phí     ││
│ │                                     │ │ Bắt đầu hành trình creator ││
│ │ "Biến xu hướng thành                │ │ chuyên nghiệp của bạn      ││
│ │  doanh thu — tự động                │ │                             ││
│ │  bằng AI"                           │ │ [🔵 Tiếp tục với Google]   ││
│ │                                     │ │ [⬛ Tiếp tục với Apple]    ││
│ │ ✅ AI tạo nội dung tự động         │ │                             ││
│ │ ✅ Quản lý đa nền tảng 1 nơi      │ │ ────── hoặc ──────          ││
│ │ ✅ Phân tích lợi nhuận thực        │ │                             ││
│ │ ✅ Miễn phí 500 AI credits         │ │ Họ và tên *                 ││
│ │                                     │ │ [                         ] ││
│ │ ──── Trust Signals ────             │ │ Email *                     ││
│ │ 🔒 Bảo mật end-to-end             │ │ [                         ] ││
│ │ 🌐 Kết nối TikTok, Shopee, YT     │ │ Mật khẩu *                  ││
│ │ ⭐ 4.8/5 từ 1,200+ creators       │ │ [                    👁   ] ││
│ │                                     │ │ [████████░░] Mạnh           ││
│ │ [Background: animated gradient     │ │                             ││
│ │  or hero illustration]              │ │ ☐ Tôi đồng ý với           ││
│ │                                     │ │   Điều khoản sử dụng và    ││
│ │                                     │ │   Chính sách bảo mật       ││
│ │                                     │ │                             ││
│ │                                     │ │ [  Đăng ký miễn phí →  ]   ││
│ │                                     │ │                             ││
│ │                                     │ │ Đã có tài khoản?           ││
│ │                                     │ │ [Đăng nhập →]              ││
│ └─────────────────────────────────────┘ └─────────────────────────────┘│
└──────────────────────────────────────────────────────────────────────┘
```

### Invite Variant
```
┌─ Form Panel (invite flow) ─────────────────────────┐
│ 🎉 Bạn được mời tham gia workspace "Beauty Hub"    │
│ Bởi: linh@example.com · Vai trò: Editor             │
│                                                       │
│ [🔵 Tiếp tục với Google]                             │
│ [⬛ Tiếp tục với Apple]                              │
│ ────── hoặc ──────                                    │
│ [form fields same as above]                           │
└───────────────────────────────────────────────────────┘
```

---
## 4. Component Hierarchy

```
RegisterPage
├── BrandPanel (left, hidden on mobile)
│   ├── Logo
│   ├── Headline ("Biến xu hướng thành doanh thu — tự động bằng AI")
│   ├── ValuePropositionList
│   │   └── ValueProp[] (icon + text)
│   ├── TrustSignals
│   │   └── TrustItem[] (icon + text)
│   └── BackgroundDecoration (animated gradient or illustration)
├── FormPanel (right)
│   ├── MobileHeader (logo + compact headline, visible only on ≤767px)
│   ├── InviteBanner (conditional — only if invite token present)
│   │   ├── WorkspaceName
│   │   ├── InviterEmail
│   │   └── AssignedRole
│   ├── PageTitle ("Tạo tài khoản miễn phí")
│   ├── Subtitle
│   ├── OAuthButtonGroup
│   │   ├── GoogleOAuthButton ("Tiếp tục với Google")
│   │   └── AppleOAuthButton ("Tiếp tục với Apple")
│   ├── Divider ("hoặc")
│   ├── RegisterForm
│   │   ├── NameInput (text, autofocus on desktop)
│   │   ├── EmailInput (email type)
│   │   ├── PasswordInput
│   │   │   ├── TextField (type="password")
│   │   │   ├── ToggleVisibility (👁 icon)
│   │   │   └── StrengthIndicator (bar + label)
│   │   ├── TermsCheckbox
│   │   │   ├── Checkbox
│   │   │   └── LegalLinks ("Điều khoản sử dụng" + "Chính sách bảo mật")
│   │   └── SubmitButton ("Đăng ký miễn phí →")
│   ├── LoginLink ("Đã có tài khoản? Đăng nhập →")
│   └── ReferralBadge (conditional — "Giới thiệu bởi: [name]" if ref code)
```

---
## 5. Displayed Data

| Element | Source | Display Format |
|---|---|---|
| Invite workspace name | Invite token decode | Bold text |
| Inviter email | Invite token decode | Truncated email |
| Assigned role | Invite token decode | Role badge (e.g., "Editor") |
| Referral source | URL param `ref` | "Giới thiệu bởi: [referrer name]" |
| Password strength | Client-side computation | Bar (weak/fair/strong) + label |
| Trust signals | Static content | Icon + text list |

---
## 6. User Actions

| # | Action | Trigger | Type | API Call | System Response | Navigation | Error |
|---|---|---|---|---|---|---|---|
| 1 | Google OAuth | Click "Tiếp tục với Google" | Primary | Redirect to Google OAuth | AuthCallback → user created → workspace create | → Workspace creation → Onboarding | OAuth cancel: return to register. OAuth error: "Không thể đăng nhập với Google. Thử lại." |
| 2 | Apple OAuth | Click "Tiếp tục với Apple" | Primary | Redirect to Apple OAuth | Same as Google | Same | Same |
| 3 | Email register | Click "Đăng ký miễn phí →" | Primary | `AuthService/Register(name, email, password)` | Success → verification email sent → show verification page | → Email verification page | See validation rules |
| 4 | Toggle password visibility | Click 👁 icon | Toggle | — (client-side) | Password field toggles text/password type | — | — |
| 5 | View terms | Click "Điều khoản sử dụng" | Navigation | — | — | → `/legal/terms` (new tab) | — |
| 6 | View privacy | Click "Chính sách bảo mật" | Navigation | — | — | → `/legal/privacy` (new tab) | — |
| 7 | Go to login | Click "Đăng nhập →" | Navigation | — | — | → `/login` | — |

---
## 7. Validation Rules

| Field | Rule | Real-time? | Error Message |
|---|---|---|---|
| Name | Required, 2-50 characters, no special chars except Vietnamese diacritics | On blur | "Vui lòng nhập họ tên (2-50 ký tự)" |
| Email | Required, valid email format | On blur | "Email không hợp lệ" |
| Email | Must be unique (not already registered) | On submit (server) | "Email này đã được đăng ký. [Đăng nhập →]" |
| Password | Required, min 8 characters | On input | "Mật khẩu phải có ít nhất 8 ký tự" |
| Password | Must contain letter + number | On input | "Mật khẩu phải có chữ cái và số" |
| Password | Must not be in common password list | On submit (server) | "Mật khẩu quá phổ biến. Chọn mật khẩu khác." |
| Terms | Must be checked | On submit | "Vui lòng đồng ý với Điều khoản sử dụng" (checkbox highlights red) |
| Invite token | If present, must be valid and not expired | On page load | "Link mời đã hết hạn hoặc không hợp lệ. [Yêu cầu mời lại]" |

### Password Strength Indicator
| Level | Color | Criteria | Label |
|---|---|---|---|
| Weak | 🔴 Red | < 8 chars or only letters | "Yếu" |
| Fair | 🟡 Yellow | 8+ chars, letter + number | "Trung bình" |
| Strong | 🟢 Green | 12+ chars, letter + number + special char | "Mạnh" |

---
## 8. States

| State | Condition | Visual | User Action |
|---|---|---|---|
| DEFAULT | Page loaded, ready for input | Empty form, OAuth buttons active, name field focused | Fill form or use OAuth |
| FILLING | User is typing | Real-time validation feedback on fields | Continue filling |
| SUBMITTING | Form submitted, API processing | Submit button shows spinner, form disabled | Wait |
| SUCCESS | Registration complete | Redirect to email verification page (or workspace creation if OAuth) | — |
| ERROR_VALIDATION | Client-side validation failed | Red borders on invalid fields, error messages below | Fix fields |
| ERROR_SERVER | Server returned error (500/503) | Toast: "Lỗi hệ thống. Vui lòng thử lại." Form re-enabled. | Retry |
| ERROR_DUPLICATE | Email already exists | Email field red, message: "Email đã được đăng ký. [Đăng nhập →]" | Click login link |
| INVITE_VALID | Valid invite token detected | Invite banner shown at top of form | Register to join workspace |
| INVITE_INVALID | Invalid/expired invite token | Error banner: "Link mời không hợp lệ. [Yêu cầu mời lại]" | Request new invite |
| OAUTH_LOADING | OAuth redirect in progress | Full-page spinner: "Đang kết nối với {provider}..." | Wait |
| OAUTH_ERROR | OAuth returned error | Toast: "Không thể đăng nhập với {provider}. Vui lòng thử lại." | Retry or use email |

---
## 9. Permissions & Role-based Behavior

N/A — This is a public page, no authentication required. If user is already authenticated, redirect to `/`.

---
## 10. Navigation Map

```
Register (/register)
├── ← Landing page (browser back)
├── → /auth/verify-email (after email registration success)
├── → /workspace/create (after OAuth success)
├── → /login (via "Đăng nhập" link)
├── → /legal/terms (new tab)
├── → /legal/privacy (new tab)
├── → Google OAuth (external redirect, returns to callback)
├── → Apple OAuth (external redirect, returns to callback)
```

---
## 11. Edge Cases

| Edge Case | Handling |
|---|---|
| User has cookies disabled | Show notice: "Cookies cần được bật để tạo tài khoản." |
| OAuth popup blocked | Show: "Popup bị chặn. Cho phép popup hoặc dùng đăng ký email." |
| User navigates away during OAuth | OAuth callback handles gracefully — if user returns, resume flow |
| Email with + alias (e.g., user+test@gmail.com) | Accept as valid — treat as unique email |
| Very long name (50+ chars) | Truncate at 50, show remaining count |
| Referral code invalid | Silently ignore (don't show error, just register without referral) |
| Invite token for already-registered user | Show "Bạn đã có tài khoản. [Đăng nhập →] để chấp nhận lời mời." |
| Rate limit on registration (bot protection) | After 3 failed attempts: show CAPTCHA (hCaptcha) |
| Dark mode | Full dark mode support — brand panel gradient adapts |

---
## 12. Accessibility

| Element | Requirement |
|---|---|
| Form | `role="form"`, `aria-label="Đăng ký tài khoản"` |
| Name input | `aria-required="true"`, `autocomplete="name"` |
| Email input | `aria-required="true"`, `autocomplete="email"`, `type="email"` |
| Password input | `aria-required="true"`, `autocomplete="new-password"` |
| Password strength | `role="status"`, `aria-live="polite"`, announces strength changes |
| Toggle visibility | `aria-label="Hiện/ẩn mật khẩu"`, `aria-pressed` |
| Error messages | `role="alert"`, `aria-live="assertive"` |
| OAuth buttons | `aria-label="Đăng ký với Google/Apple"` |
| Terms link | Opens in new tab, `aria-label` indicates external link |
| Submit button | `aria-disabled="true"` when form invalid |
| Tab order | Logo → OAuth buttons → Name → Email → Password → Terms → Submit → Login link |

---
## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | SSR — full form visible immediately |
| Hydration | 0-300ms | Form becomes interactive |
| OAuth redirect | 0-2s | Full-page spinner with provider name |
| OAuth callback | 1-3s | Spinner: "Đang tạo tài khoản..." |
| Email registration | 1-3s | Submit button spinner |

---
## 14. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.0s (form panel is LCP element) |
| FID | < 50ms |
| CLS | < 0.01 (no layout shifts — form has fixed dimensions) |
| TTI | < 1.5s |
| Bundle size | < 25KB page-specific JS |
| Form validation | < 10ms per field |

---
## 15. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `auth.register.page_viewed` | Page load | `source` (direct/referral/invite), `ref_code`, `has_invite` |
| `auth.register.oauth_started` | OAuth button clicked | `provider` (google/apple) |
| `auth.register.oauth_success` | OAuth callback success | `provider`, `latency_ms` |
| `auth.register.oauth_error` | OAuth callback error | `provider`, `error_type` |
| `auth.register.form_started` | First field interaction | `first_field` |
| `auth.register.form_submitted` | Submit button clicked | `has_referral`, `password_strength` |
| `auth.register.success` | Registration complete | `method` (email/google/apple), `has_invite`, `has_referral` |
| `auth.register.error` | Registration failed | `error_type` (validation/duplicate/server) |
| `auth.register.terms_clicked` | Terms link clicked | — |
| `auth.register.login_clicked` | Login link clicked | — |

---
## 16. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-surface-primary` | Form panel background |
| `--color-surface-brand` | Brand panel background (gradient) |
| `--color-primary` | Submit button, links |
| `--color-text-primary` | Form labels, headings |
| `--color-text-secondary` | Subtitles, helper text |
| `--color-error` | Validation error borders and messages |
| `--color-success` | Strong password indicator |
| `--color-warning` | Fair password indicator |
| `--spacing-form-gap` | Gap between form fields (16px) |
| `--radius-input` | Input border radius (8px) |
| `--radius-button` | Button border radius (8px) |
| `--shadow-form` | Form panel shadow (desktop only) |
| `--font-heading-lg` | "Tạo tài khoản" heading |
| `--font-body` | Form labels and text |

---
## 17. Technical Implementation Notes

### SvelteKit Specifics
- **Route**: `src/routes/(auth)/register/+page.svelte`
- **Server load**: `+page.server.ts` — validate invite token if present, redirect if user already authenticated
- **Auth**: Clerk SSO for OAuth, custom email/password API for email registration
- **No SSR form state**: Form is purely client-side, no server load for form data
- **SEO**: `noindex, nofollow` — registration pages should not be indexed

### OAuth Flow
```
1. User clicks "Tiếp tục với Google"
2. Redirect to Google OAuth consent screen
3. Google redirects back to /auth/callback/google
4. +page.server.ts: exchange code for tokens → create user → create session
5. Redirect to /workspace/create
```

### Email Registration Flow
```
1. Client-side validation passes
2. POST /api/auth/register (name, email, password, invite_token?, ref_code?)
3. Server: create user, send verification email
4. Client: redirect to /auth/verify-email?email=xxx
5. User clicks email link → /auth/verify?token=xxx
6. Server: verify token → email_verified = true → redirect to /workspace/create
```

### Bot Protection
- hCaptcha embedded (lazy-loaded, appears after 3 failed attempts)
- Rate limit: max 5 registration attempts per IP per hour
- Honeypot field (hidden input, bot detection)

---
## 5. Data Binding & Display Format
*(Refer to screen-specific data binding in section above)*


---
## 19. Related Screens

| Screen | Relationship |
|---|---|
| [W010] Login | Alternative auth path |
| [W006] Onboarding Wizard | Post-registration destination |
| Email Verification Page | Intermediate step for email registration |
| Workspace Creation | Intermediate step after verified |
---
## Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached data | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được dữ liệu. [Thử lại]" | Retry |
| Not found | 404 | "Không tìm thấy" → navigate back | Back |
| Permission denied | 403 | "Không có quyền truy cập" | Contact admin |

---
## Localization Notes

- Primary language: Vietnamese
- Currency: VND (no decimals, dot separator: "1.200.000đ")
- Date: DD/MM/YYYY
- Numbers: dot separator (1.234)
- Relative time: "2 giờ trước", "1 ngày trước"
- Tone: Friendly, action-oriented

---
## Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | Patch | Removed duplicate template sections. Replaced with screen-specific Error Handling, Accessibility, Loading, Localization, Design Tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
