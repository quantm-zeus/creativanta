> **Screen ID**: S012

# Shared Component: Onboarding Tooltip Sequence

> **Component ID**: S12
> **Type**: Shared UI Component
> **Used across**: Web, Mobile

---

## 1. Purpose

Step-by-step guided tooltips that highlight key features during first use. Progressive disclosure — shows one feature at a time, non-blocking.

---

## 2. Tooltip Anatomy

```
                    ┌─ Tooltip ──────────────────────────┐
                    │ Step 2/6                           │
                    │ 🎬 AI Studio                       │
                    │ Tạo video với AI — từ text         │
                    │ thành video chỉ trong vài phút.    │
                    │                                    │
                    │ [← Back] [Skip tour] [Next →]      │
                    └────────────────────────────────────┘
                              ▼ (points to Studio nav)
```

## 3. Tour Sequences

### 3a. New User Tour (Web — 6 steps)
| Step | Target Element | Message |
|---|---|---|
| 1 | Dashboard Quick Stats | "Đây là tổng quan workspace" |
| 2 | AI Studio nav item | "Tạo video với AI" |
| 3 | Ideas nav item | "Quản lý ý tưởng nội dung" |
| 4 | Inbox nav item | "Inbox hợp nhất từ tất cả nền tảng" |
| 5 | Settings → Connections | "Kết nối TikTok, Shopee..." |
| 6 | Copilot (⌘K) | "AI assistant — hỏi bất cứ gì" |

### 3b. New User Tour (Mobile — 4 steps)
| Step | Target | Message |
|---|---|---|
| 1 | Quick Actions row | "Hành động nhanh" |
| 2 | Bottom tab: Studio | "Tạo video AI" |
| 3 | Bottom tab: Inbox | "Tin nhắn đa nền tảng" |
| 4 | Floating Copilot button | "AI assistant" |

## 4. Behavior Rules

- **Persistence**: Tour state saved to `localStorage` / `SharedPreferences`
- **Skip**: "Skip tour" skips remaining steps; never shows again
- **Re-trigger**: Settings → "Xem lại hướng dẫn" resets tour
- **Context-aware**: Only shows on first visit to each screen
- **Non-blocking**: Backdrop dimming with highlight on target

## 5. Styling

- **Background**: `rgba(0,0,0,0.5)` backdrop
- **Highlight**: Target element cut-out with 4px border-radius + glow
- **Tooltip**: Floating card, 320px max-width, arrow pointing to target
- **Progress**: Step indicator "2/6" with dots

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

---

## 2. Preconditions / Postconditions
### Preconditions
- User authenticated with valid session
- Required module permissions granted
### Postconditions
- User actions persisted to backend
- Analytics events dispatched

---

## 4. Component Hierarchy
```
OnboardingTooltipSequence
├── HighlightOverlay
├── TargetAnchorResolver
├── TooltipCard
│   ├── StepIndicator
│   ├── Title
│   ├── BodyCopy
│   └── ActionRow (Back / Skip / Next)
└── TourStateController
```

---

## 5. Data Binding & Display Format
| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Primary data | Parent screen state or canonical contract object(s) | Resolve via owning feature doc + API/schema contracts | Exact DTO fields from canonical contracts | Per endpoint policy |
| List items | Parent screen list/query contract(s) | Resolve via API endpoint map before implementation | Card or row layout per wireframe | Per endpoint policy |
| Summary stats | Parent screen aggregates/projections | Resolve via feature rules + API contracts | Count / KPI / chip formatting per screen | Short-lived cache only if contract allows |
| User-facing text | i18n keys | — | Vietnamese | Static |

---
## Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" + cached data | Pull-to-refresh when online |
| API error | Server 5xx | Toast: "Không tải được dữ liệu. [Thử lại]" | Retry |
| Not found | 404 | "Không tìm thấy" → navigate back | Back |
| Permission denied | 403 | "Không có quyền truy cập" | Contact admin |

---
## Accessibility

| Element | Requirement |
|---|---|
| Interactive elements | Minimum 48×48dp tap targets |
| Icons with meaning | `Semantics(label:)` descriptive text |
| Status indicators | Color not sole indicator; text/icon also present |
| Dynamic content | `Semantics(liveRegion: true)` for updates |
| Contrast | 4.5:1 minimum ratio |

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
