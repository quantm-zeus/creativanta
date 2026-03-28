# Screen: Web — A/B Testing Engine

> **Screen ID**: W32
> **Module**: M07 — AI Studio
> **Route**: `/studio/ab-test`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 04, A1 Schema (ab_tests, ab_variants)

---

## 1. Purpose & Context

Generate N video variants (different hooks, CTAs, thumbnails, music) → publish all → auto-pick winner based on engagement metrics after test duration.

### User Story
> As a creator optimizing my content, I want to test different hooks and thumbnails and let the system automatically identify the best performer.

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Studio   🧪 A/B Testing Engine                                    │
├──────────────────────────────────────────────────────────────────────┤
│ ┌─ Source ───────────────────────────────────────────────────────┐  │
│ │ Base video: [Select from library ▾]                            │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Variant Dimensions ───────────────────────────────────────────┐  │
│ │ ☑ Hook variation (AI generates 3 hook styles)                  │  │
│ │ ☑ Thumbnail variation (3 variants)                             │  │
│ │ ☐ CTA variation (text + placement)                             │  │
│ │ ☐ Music variation (different energy levels)                    │  │
│ │ Total variants: 3 · Credits: ~15                               │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Test Settings ────────────────────────────────────────────────┐  │
│ │ Winner criteria: [Engagement rate ▾]                           │  │
│ │ Test duration: [24h ▾]                                         │  │
│ │ Auto-winner: [☑ ON — keep winner, option to hide loser]       │  │
│ │ Platform: [TikTok ▾]                                           │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ [🧪 Generate variants — 15 credits] [📤 Publish all]               │
│                                                                      │
│ ── Active Tests (below) ──                                           │
│ ┌─ Test Result Card ─────────────────────────────────────────────┐  │
│ │ 🧪 "Serum review" — Hook test · 18h remaining                 │  │
│ │ Variant A: 2.4K views · 8.2% eng  🏆 Leading                  │  │
│ │ Variant B: 1.8K views · 6.1% eng                               │  │
│ │ Variant C: 2.1K views · 5.4% eng                               │  │
│ │ [📊 Full analytics] [⏹ End early]                             │  │
│ └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3-5. Component Hierarchy & Actions

```
ABTestingPage
├── AppShell (shared)
├── PageHeader
├── SourceSelector (video library)
├── VariantDimensions (checkbox grid)
├── TestSettings (criteria, duration, auto-winner)
├── ActionBar (Generate, Publish)
└── ActiveTestsList
    └── TestResultCard[]
        ├── TestName + RemainingTime
        ├── VariantRow[] (views, engagement, leader badge)
        ├── AnalyticsButton
        └── EndEarlyButton
```

---

## 6. Winner Criteria Options

| Criteria | Description |
|---|---|
| Engagement rate | Likes + comments + shares / views |
| View completion | % viewers watching full video |
| Click-through | CTA click rate |
| Sales conversion | Orders generated |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| SETUP | No base video selected | Source selector + dimension checkboxes |
| VARIANTS_READY | Variants generated | Variant previews with credit count |
| TESTING | Published, collecting data | Live metrics cards with polling indicator |
| COMPLETE | Winner determined | 🏆 Winner badge + comparison stats |
| DRAW | No clear winner | "Kết quả không rõ ràng. [Kéo dài] [Chọn thủ công]" |

---

## 8. Edge Cases

| Edge Case | Handling |
|---|---|
| Statistical insignificance | Warning: "Chưa đủ dữ liệu (< 1000 views). Kéo dài thêm?" |
| Platform publish rate limit | Queue variants: "Đăng variant 2/3 · Chờ 5 phút trước variant tiếp" |
| All variants similar performance | Show: "Hiệu suất tương đương. Chọn thủ công hoặc kéo dài test." |
| Test ended early (< 1h) | Confirm: "Dữ liệu quá ít. Kết quả có thể không chính xác. [Kết thúc?]" |
| Insufficient credits | CTA disabled: "Cần thêm {n} credits cho {variant_count} variants. [Mua credits]" |

---

## 9. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" | Auto-retry online |
| Variant generation failed | AI error | Toast: "Không tạo variant. Credits hoàn trả. [Thử lại]" | Retry |
| Publish failed | Platform API error | Toast: "Không đăng variant {n}. [Thử lại]" | Retry individual |
| Metrics unavailable | Platform API down | Banner: "Metrics tạm không khả dụng. Tự động thử lại." | Auto-retry 5m |
| Auto-winner failed | Cron error | Toast: "Không chọn winner tự động. [Chọn thủ công]" | Manual pick |

---

## 10. Accessibility

| Element | Requirement |
|---|---|
| Variant comparison | `role="region"`, `aria-label="So sánh variant {id}"` |
| Leader badge | `aria-label="Variant {id} đang dẫn đầu"` |
| Dimension checkboxes | `role="group"`, `aria-label="Chọn yếu tố test"` |
| Active tests list | `role="list"`, test cards `role="listitem"` |
| Metric values | `aria-live="polite"` — updates on poll |

---

## 11. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Source selector + dimensions |
| Active tests load | 200-400ms | Test cards skeleton |
| Variant generation | 10-30s | Progress: "Đang tạo {n} variants..." |
| Metric poll | Every 5m | Subtle refresh indicator |
| Test results | 200ms | Winner badge animates in |

---

## 12. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `ab_test.setup_opened` | Page load | `source` |
| `ab_test.variants_generated` | Generation complete | `dimensions`, `variant_count`, `credits` |
| `ab_test.published` | All variants published | `platform`, `variant_count` |
| `ab_test.ended_early` | Manual end | `test_id`, `duration_hours` |
| `ab_test.winner_picked` | Auto or manual | `test_id`, `winner_variant`, `criteria`, `auto` |
| `ab_test.analytics_viewed` | Full analytics click | `test_id` |
| `ab_test.failed` | Error | `error_type` |

---

## 13. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/studio/ab-test/+page.svelte`
- **Server load**: `+page.server.ts` → fetch active tests
- **Variant gen**: `AIService/GenerateVariants(base_asset, dimensions)` → SSE
- **Publish**: `PublishService/PublishVariants(variants, platform)` → batch
- **Metric polling**: `setInterval(5m)` → `ABTestService/GetMetrics(test_id)`
- **Auto-winner**: Server cron `ABTestService/EvaluateTest(test_id)` after duration
- **Statistical**: Requires minimum 1000 views / variant for significance

---

## 14. Localization Notes

- Dimensions: "Hook", "Thumbnail", "CTA", "Nhạc nền"
- Criteria: "Tỷ lệ tương tác", "Xem hết", "Click CTA", "Chuyển đổi mua hàng"
- Duration: "24 giờ", "48 giờ", "72 giờ", "1 tuần"
- Status: "Đang test", "Hoàn thành", "Không rõ ràng"
- Winner: "🏆 Chiến thắng", "Đang dẫn đầu"

---

## 15. Design Tokens

| Token | Usage |
|---|---|
| `--color-variant-a` | Variant A accent (blue) |
| `--color-variant-b` | Variant B accent (green) |
| `--color-variant-c` | Variant C accent (orange) |
| `--color-winner` | Winner highlight (gold) |
| `--color-leader-badge` | Leading variant badge |
| `--color-metric-positive` | Positive metric change |
| `--color-metric-negative` | Negative metric change |
| `--color-surface-elevated` | Cards |

---

## 16. Related Screens

| Screen | Relationship |
|---|---|
| [W024] AI Studio Launcher | Parent |
| [W109] Analytics | Test results deep-dive |
| [W038] Studio Queue | Variant generation tracking |

---

## 17. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A upgrade**: 5 states, 5 edge cases (statistical significance), 5 errors, variant comparison accessibility, metric polling, 7 analytics, SvelteKit impl, 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
