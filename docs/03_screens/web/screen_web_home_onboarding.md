# Screen: Web — Onboarding Setup

> **Screen ID**: W006
> **Module**: M01 — Home & Decision
> **Route**: `/onboarding`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §8

---

## 1. Purpose & Context

Multi-step onboarding wizard activated after first workspace creation. Guides new users through: profile setup → connect platforms → set preferences → choose operator mode → complete. Each step is skippable but encouraged.

### User Story
> As a new user, I want a guided setup that helps me connect my platforms and configure my workspace before using the full app.

### Entry Points
- Auto-redirect after first workspace creation
- Settings: "🔄 Tái thiết lập onboarding"

### Exit Points
- Complete → `/` (Home Dashboard)
- Skip all → `/` (with onboarding banner on Dashboard)

---

## 2. Layout Structure

### ASCII Wireframe
```
┌──────────────────────────────────────────────────────────────────────┐
│                                                                      │
│         🎉 Chào mừng đến Creativanta!                                │
│         Cùng thiết lập workspace của bạn.                            │
│                                                                      │
│         Step [1] — [2] — [3] — [4] — [5]                            │
│         ██████░░░░░░░░░░░░░░░░ 20%                                  │
│                                                                      │
│ ┌─ Step 1: Hồ sơ ───────────────────────────────────────────────┐  │
│ │ Ảnh đại diện: [📸 Upload]                                      │  │
│ │ Tên hiển thị: [Quân Nguyễn                                   ] │  │
│ │ Lĩnh vực: [Beauty & Skincare ▾]                                │  │
│ │ Mô tả ngắn: [Content creator về skincare                    ] │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│         [← Quay lại]                            [Tiếp tục →]       │
│                                    [Bỏ qua bước này]                │
│                                                                      │
└──────────────────────────────────────────────────────────────────────┘
```

**Step 2: Kết nối nền tảng**
```
│ ┌─ Platform Cards ───────────────────────────────────────────────┐  │
│ │ 🎵 TikTok      [Kết nối →]   📸 Instagram   [Kết nối →]     │  │
│ │ 📺 YouTube     [Kết nối →]   🛍 TikTok Shop [Kết nối →]     │  │
│ │ 🛍 Shopee      [Kết nối →]   🔍 Google      [Kết nối →]     │  │
│ │ Đã kết nối: ✅ TikTok, ✅ Instagram                           │  │
│ └────────────────────────────────────────────────────────────────┘  │
```

**Step 3: Cài đặt ưu tiên**
```
│ ┌─ Preferences ──────────────────────────────────────────────────┐  │
│ │ Ngôn ngữ giao diện: [Tiếng Việt ▾]                            │  │
│ │ Múi giờ: [GMT+7 (Hồ Chí Minh) ▾]                              │  │
│ │ Thông báo email: [✅]  Push notification: [✅]                 │  │
│ │ AI language: [Tiếng Việt ▾]                                     │  │
│ └────────────────────────────────────────────────────────────────┘  │
```

**Step 4: Chọn chế độ**
```
│ ┌─ Operator Mode Selection ──────────────────────────────────────┐  │
│ │ ┌─ Creator ──────┐  ┌─ Seller ───────┐  ┌─ Brand ──────────┐ │  │
│ │ │ 🎨             │  │ 🛍             │  │ 🏢              │ │  │
│ │ │ Tập trung nội  │  │ Bán hàng qua   │  │ Quản lý thương  │ │  │
│ │ │ dung sáng tạo  │  │ content        │  │ hiệu            │ │  │
│ │ │ [◉ Selected]   │  │ [☑ Also]       │  │ [○]             │ │  │
│ │ └────────────────┘  └────────────────┘  └─────────────────┘ │  │
│ └────────────────────────────────────────────────────────────────┘  │
```

**Step 5: Hoàn thành**
```
│ ┌─ Complete ─────────────────────────────────────────────────────┐  │
│ │ 🎉 Workspace của bạn đã sẵn sàng!                             │  │
│ │                                                                  │  │
│ │ ✅ Hồ sơ đã thiết lập                                         │  │
│ │ ✅ 2 nền tảng đã kết nối                                      │  │
│ │ ✅ Cài đặt đã cấu hình                                        │  │
│ │ ✅ Chế độ: Creator + Seller                                    │  │
│ │                                                                  │  │
│ │ [🚀 Bắt đầu sử dụng Creativanta]                              │  │
│ └────────────────────────────────────────────────────────────────┘  │
```

---

## 3. Component Hierarchy

```
OnboardingPage
├── ProgressHeader
│   ├── WelcomeTitle
│   ├── StepIndicator (1-5 dots)
│   └── ProgressBar
├── StepContainer
│   ├── Step1_Profile
│   │   ├── AvatarUploader
│   │   ├── DisplayNameInput
│   │   ├── IndustrySelector
│   │   └── BioTextarea
│   ├── Step2_Connections
│   │   └── PlatformCard[] (with OAuth connect buttons)
│   ├── Step3_Preferences
│   │   ├── LanguageSelector
│   │   ├── TimezoneSelector
│   │   ├── NotificationToggles
│   │   └── AILanguageSelector
│   ├── Step4_OperatorMode
│   │   └── ModeCard[] (Creator / Seller / Brand — multi-select)
│   └── Step5_Complete
│       ├── ChecklistSummary
│       └── LaunchButton
└── NavigationBar
    ├── BackButton
    ├── SkipStepLink
    └── NextButton
```

---

## 4-5. Data & Actions

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Upload avatar | Click avatar → file picker | `FileService/Upload` | Preview shows | Any |
| 2 | Save profile | Next from step 1 | `WorkspaceService/UpdateProfile` | Profile saved | Any |
| 3 | Connect platform | Click "Kết nối" | OAuth redirect flow | Platform connected | `account:connect` |
| 4 | Save preferences | Next from step 3 | `WorkspaceService/UpdatePreferences` | Prefs saved | Any |
| 5 | Set operator mode | Next from step 4 | `WorkspaceService/SetModes` | Modes activated | Any |
| 6 | Skip step | "Bỏ qua" | — | Advance without saving | Any |
| 7 | Complete | "Bắt đầu" on step 5 | `WorkspaceService/CompleteOnboarding` | → `/` | Any |

---

## 6-20. Standard Sections

### States
| State | Visual |
|---|---|
| STEP_N | Current step form visible, progress bar at N/5 |
| CONNECTING | OAuth redirect, loading overlay |
| CONNECTED | Platform card shows ✅ |
| COMPLETING | Final step processing |
| COMPLETE | Redirect to Home Dashboard |

### Validation
| Step | Field | Rule | Error |
|---|---|---|---|
| 1 | Display name | Required, 2-50 chars | "Tên phải từ 2-50 ký tự" |
| 1 | Industry | Required | "Chọn lĩnh vực" |
| 4 | Mode | At least 1 selected | "Chọn ít nhất 1 chế độ" |

### Performance
- Lightweight page, no heavy components
- OAuth: redirect-based (no popup)
- Step data persisted between steps

### Technical Notes
- Route: `src/routes/(auth)/onboarding/+page.svelte`
- Step state: URL param `?step=2` for back-navigation support
- OAuth callback: handled by connector service, returns to onboarding
- Completed flag: `workspaces.onboarding_completed_at`

### Related Screens
| Screen | Relationship |
|---|---|
| [W001] Home Dashboard | Target after completion |
| [W117] Settings Connectors | Platform management (post-onboarding) |

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" — form data preserved | Submit when online |
| OAuth fail | Platform auth error | Toast: "Kết nối {platform} thất bại. [Thử lại]" | Retry |
| Save fail | API error on next | Toast: "Không lưu được. [Thử lại]" | Retry (form preserved) |
| Upload fail | Avatar upload error | Inline: "Ảnh không tải được. Thử lại." | Re-upload |
| Complete fail | API error | Toast: "Không hoàn thành được. [Thử lại]" | Retry |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Step indicator | `role="progressbar"`, `aria-valuenow="{step}"`, `aria-valuemax="5"` |
| Form fields | All with `aria-label`, required fields with `aria-required="true"` |
| Platform cards | `role="button"`, `aria-label="Connect {platform}"`, connected: `aria-pressed="true"` |
| Mode cards | `role="checkbox"`, `aria-checked`, `aria-label="{mode} mode"` |
| Navigation | Skip/Next/Back with `aria-label` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Welcome header + step 1 form |
| Step transition | 300ms | Slide animation between steps |
| OAuth redirect | 2-5s | Loading overlay: "Đang kết nối {platform}..." |
| Complete | 200ms | Redirect to Home Dashboard |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `onboarding.started` | Page load | `workspace_id` |
| `onboarding.step_completed` | "Tiếp tục" on step | `step`, `data_provided` |
| `onboarding.step_skipped` | "Bỏ qua" | `step` |
| `onboarding.platform_connected` | OAuth success | `platform` |
| `onboarding.platform_failed` | OAuth error | `platform`, `error` |
| `onboarding.mode_selected` | Mode card toggled | `modes` |
| `onboarding.completed` | "Bắt đầu" on step 5 | `steps_completed`, `platforms_connected`, `modes` |
| `onboarding.abandoned` | Page exit before complete | `last_step`, `time_spent` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(auth)/onboarding/+page.svelte`
- **Step state**: URL param `?step=2` for browser back support
- **OAuth**: Redirect-based flow, callback returns to `/onboarding?step=2&connected={platform}`
- **Form persistence**: Each step auto-saves to `WorkspaceService/UpdateProfile` on "Tiếp tục"
- **Complete flag**: Sets `workspaces.onboarding_completed_at` — prevents re-entry
- **Skip all**: Redirects to Home with persistent banner "Hoàn thành thiết lập →"

---

## 12. Localization Notes

- Steps: "Hồ sơ", "Kết nối nền tảng", "Cài đặt ưu tiên", "Chọn chế độ", "Hoàn thành"
- Actions: "Tiếp tục →", "← Quay lại", "Bỏ qua bước này"
- Complete: "Workspace của bạn đã sẵn sàng!", "Bắt đầu sử dụng Creativanta"
- Tone: Welcoming, encouraging

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-accent` | Next CTA, progress bar fill |
| `--color-success` | Connected platform ✅, completed step |
| `--color-surface-elevated` | Step panels |
| `--color-text-secondary` | Skip link |
| `--color-step-inactive` | Unvisited step dots |
| `--color-step-active` | Current step dot |
| `--radius-card` | Step panels, mode cards |

---

## 14. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (OAuth, save), step/form a11y, 8 analytics, SvelteKit impl (OAuth, step state, persistence), localization, 7 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
