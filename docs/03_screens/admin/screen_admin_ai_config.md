# Screen: Admin — AI Model Configuration

> **Screen ID**: A013
> **Module**: S26 — see canonical feature owner in screen_task_map.csv
> **Route**: `/admin/ai/config`
> **Platform**: Admin Web (SvelteKit) — VPN-only access
> **Upstream**: Pack 04 §AI/Media, Pack 08 §Credits, S26 §AI Operations, A3 API (`AdminAIService`), B5 RBAC §3

---

## 1. Purpose & Context

Admin-only screen for configuring AI model parameters — feature-to-model mapping, temperature/token limits, system prompts, safety guidelines, and per-plan rate limits. This controls the AI behavior across the entire platform.

### User Story
> As an admin, I want to configure which AI model handles each feature and set safety parameters so I can optimize cost, quality, and safety.

### Business Goal
- Control AI operational costs by routing features to cost-appropriate models
- Ensure safety guidelines are enforced across all AI features
- Enable A/B testing of different models per feature
- Manage rate limits to prevent abuse

### When to Use
- Adjusting AI model allocation for cost optimization
- Updating system prompts or safety guidelines
- Changing rate limits per subscription tier
- Testing new model versions before rollout

### Entry Points
- Admin sidebar → "🤖 AI" → "⚙️ Configuration"
- AI Operations dashboard → "Configure" link

### Exit Points
- Save → stay on page (success toast)
- Navigate to AI Providers → `/admin/ai/providers`
- Navigate to AI Credits → `/admin/ai/credits`

---

## 2. Preconditions / Postconditions

### Preconditions
- Admin user authenticated via internal auth
- VPN connection active
- Role: `tech_admin` or `super_admin`

### Postconditions
- Configuration changes saved through the canonical `AdminAIService` configuration surface
- Changes propagate to AI routing service within 30s
- Audit event logged: `admin.ai_config.updated`
- All active AI requests continue with previous config until completion

---

## 3. Layout Structure

### ASCII Wireframe
```
┌─ Admin Shell ────────────────────────────────────────────────────────┐
│ ⚙️ AI Configuration                     [💾 Save All] [↩ Discard]  │
│ Last saved: 2026-03-28 14:30 by admin@creativanta.app               │
├──────────────────────────────────────────────────────────────────────┤
│                                                                       │
│ ┌─ Feature → Model Mapping ──────────────────────────────────────┐  │
│ │ Feature              │ Model         │ Temp │ MaxTok │ $/req   │  │
│ │──────────────────────│───────────────│──────│────────│─────────│  │
│ │ Script generation    │ [Gemini 2.5▾] │ [0.8]│ [2000] │ ~$0.03  │  │
│ │ AI replies (inbox)   │ [Claude 4 ▾]  │ [0.3]│ [500]  │ ~$0.01  │  │
│ │ Trend analysis       │ [Gemini 2.5▾] │ [0.2]│ [3000] │ ~$0.04  │  │
│ │ Idea generation      │ [GPT-4o   ▾]  │ [0.7]│ [1500] │ ~$0.03  │  │
│ │ Image generation     │ [Flux 2   ▾]  │ [—]  │ [—]    │ ~$0.05  │  │
│ │ Video generation     │ [Veo 3.1  ▾]  │ [—]  │ [—]    │ ~$0.20  │  │
│ │ Caption AI           │ [Claude 4 ▾]  │ [0.5]│ [300]  │ ~$0.008 │  │
│ │ Copilot queries      │ [Gemini 2.5▾] │ [0.4]│ [1000] │ ~$0.02  │  │
│ │ Performance coach    │ [Gemini 2.5▾] │ [0.3]│ [2000] │ ~$0.04  │  │
│ │ Creative DNA analyze │ [GPT-4o   ▾]  │ [0.2]│ [4000] │ ~$0.06  │  │
│ │ Content moderation   │ [Claude 4 ▾]  │ [0.1]│ [500]  │ ~$0.01  │  │
│ │ Translation          │ [GPT-4o   ▾]  │ [0.3]│ [3000] │ ~$0.04  │  │
│ │                                                                  │  │
│ │ Est. daily cost: $142.50 (based on last 7d avg volume)          │  │
│ │ [+ Add feature mapping] [📊 Cost simulator]                     │  │
│ └──────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Fallback Configuration ───────────────────────────────────────┐  │
│ │ Primary failure → Fallback model:                               │  │
│ │ Gemini fail → [GPT-4o ▾]   GPT fail → [Claude 4 ▾]            │  │
│ │ All LLM fail → [Queue + notify] ☑ Auto-retry after 60s         │  │
│ │                                                                 │  │
│ │ Circuit breaker: [3] consecutive failures → disable for [300s] │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ System Prompts ───────────────────────────────────────────────┐  │
│ │ Base system prompt:                                             │  │
│ │ ┌──────────────────────────────────────────────────────────┐   │  │
│ │ │ You are a creative assistant for Vietnamese creators     │   │  │
│ │ │ and sellers. Always respond in the user's language.      │   │  │
│ │ │ Never fabricate statistics or metrics. Use only data     │   │  │
│ │ │ from the workspace graph...                              │   │  │
│ │ └──────────────────────────────────────────────────────────┘   │  │
│ │ [Characters: 1,247 / 4,000]                                    │  │
│ │                                                                 │  │
│ │ Safety guidelines:                                              │  │
│ │ ┌──────────────────────────────────────────────────────────┐   │  │
│ │ │ NEVER generate content that: promotes illegal activity,  │   │  │
│ │ │ contains explicit material, makes false health claims,   │   │  │
│ │ │ impersonates real people without consent...              │   │  │
│ │ └──────────────────────────────────────────────────────────┘   │  │
│ │ [Characters: 892 / 2,000]                                      │  │
│ │                                                                 │  │
│ │ [🔄 Reset to default] [📋 View prompt history]                 │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ Rate Limits per Tier ─────────────────────────────────────────┐  │
│ │ Tier      │ req/min │ req/hour │ req/day │ concurrent │        │  │
│ │ Free      │ [5]     │ [50]     │ [200]   │ [1]        │ [✏]   │  │
│ │ Starter   │ [15]    │ [200]    │ [1000]  │ [2]        │ [✏]   │  │
│ │ Pro       │ [30]    │ [500]    │ [3000]  │ [3]        │ [✏]   │  │
│ │ Business  │ [60]    │ [1000]   │ [10000] │ [5]        │ [✏]   │  │
│ │ Enterprise│ [custom]│ [custom] │ [custom]│ [custom]   │ [✏]   │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ┌─ A/B Test Config ──────────────────────────────────────────────┐  │
│ │ Active tests: 2                                                 │  │
│ │ · Script gen: Gemini 2.5 (80%) vs GPT-4o (20%) — Day 5/14     │  │
│ │ · Caption AI: Claude 4 (50%) vs Gemini (50%) — Day 2/7        │  │
│ │ [+ New A/B test] [📊 View results]                              │  │
│ └─────────────────────────────────────────────────────────────────┘  │
│                                                                       │
│ ⚠️ Unsaved changes                               [💾 Save All]     │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 4. Component Hierarchy

```
AIConfigPage
├── AdminShell (shared)
├── PageHeader
│   ├── Title ("⚙️ AI Configuration")
│   ├── LastSavedInfo
│   ├── SaveAllButton (primary)
│   └── DiscardButton (secondary)
├── FeatureModelMappingSection
│   ├── SectionHeader
│   ├── MappingTable
│   │   └── MappingRow[]
│   │       ├── FeatureName
│   │       ├── ModelSelector (dropdown)
│   │       ├── TemperatureInput (number, 0.0-2.0, step 0.1)
│   │       ├── MaxTokensInput (number)
│   │       ├── CostEstimate (readonly, computed)
│   │       └── EditRowButton
│   ├── DailyCostEstimate
│   ├── AddMappingButton
│   └── CostSimulatorButton
├── FallbackConfigSection
│   ├── FallbackChain[]
│   │   ├── PrimaryModel
│   │   ├── FallbackModelSelector
│   │   └── RetryConfig
│   └── CircuitBreakerConfig
│       ├── FailureThreshold (number)
│       └── CooldownDuration (number, seconds)
├── SystemPromptsSection
│   ├── BasePromptEditor (textarea, max 4000 chars)
│   ├── SafetyGuidelinesEditor (textarea, max 2000 chars)
│   ├── CharacterCounter (per editor)
│   ├── ResetButton
│   └── PromptHistoryButton
├── RateLimitsSection
│   ├── RateLimitTable
│   │   └── TierRow[]
│   │       ├── TierName
│   │       ├── PerMinuteInput
│   │       ├── PerHourInput
│   │       ├── PerDayInput
│   │       ├── ConcurrentInput
│   │       └── EditButton
├── ABTestSection
│   ├── ActiveTestList
│   │   └── ABTestRow[]
│   │       ├── FeatureName
│   │       ├── ModelA + weight%
│   │       ├── ModelB + weight%
│   │       ├── Progress (day X/Y)
│   │       └── StopButton
│   ├── NewTestButton
│   └── ViewResultsButton
└── UnsavedChangesBanner (sticky bottom, conditional)
```

---

## 5. Data Binding & Display Format

| UI Element | Data Source | API | Display Format | Cache |
|---|---|---|---|---|
| Feature mappings | `AdminAIService` configuration projection | `AdminAIService/GetConfig` | Table rows | No cache (admin) |
| Model options | `AdminAIService` model catalog projection | `AdminAIService/ListModels` | Dropdown options | Session |
| Cost estimate | Computed from mapping × volume | `AdminAIService/EstimateCost` | "$142.50" USD | No cache |
| System prompts | `AdminAIService` prompt projection | `AdminAIService/GetPrompts` | Markdown-rendered text | No cache |
| Rate limits | `AdminAIService` rate-limit projection by tier | `AdminAIService/GetRateLimits` | Table rows | No cache |
| A/B tests | `AdminAIService` A/B test projection | `AdminAIService/ListABTests` | Test cards | No cache |
| Last saved | Response metadata from `AdminAIService/GetConfig` | same | Relative time + actor email | No cache |

---

## 6. Actions Table

| # | Action | Trigger | API Call | Mutation | UI Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Change model for feature | Select from dropdown | — (local) | — | Unsaved changes banner appears | `tech_admin` |
| 2 | Adjust temperature | Change number input | — (local) | — | Cost estimate updates | `tech_admin` |
| 3 | Save all changes | Click "💾 Save All" | `AdminAIService/UpdateConfig(payload)` | Multiple config rows updated | Toast "Configuration saved" + last-saved updates | `tech_admin` |
| 4 | Discard changes | Click "↩ Discard" | — | — | Revert to last saved state | `tech_admin` / `super_admin` |
| 5 | Reset prompts | Click "🔄 Reset to default" | Confirmation → `AdminAIService/ResetPrompts` | Restore default prompts | Editors revert to defaults | `super_admin` |
| 6 | View prompt history | Click "📋 View prompt history" | `AdminAIService/GetPromptHistory` | — | Open history drawer with diff view | `tech_admin` |
| 7 | Edit rate limit | Click ✏ on tier row | — | — | Row becomes editable | `tech_admin` |
| 8 | Save rate limits | Save editable row | `AdminAIService/UpdateRateLimits` | Rate limit updated | Toast "Rate limits updated" | `tech_admin` |
| 9 | Create A/B test | Click "+ New A/B test" | — | — | Open A/B test creation dialog | `tech_admin` |
| 10 | Stop A/B test | Click "Stop" on test row | `AdminAIService/StopABTest(id)` | Test ended, winner applied | Toast "A/B test stopped. Winner: {model}" | `tech_admin` |
| 11 | Open cost simulator | Click "📊 Cost simulator" | — | — | Open cost simulation drawer | `tech_admin` |

---

## 7. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Fetching config | Shimmer table + skeleton editors |
| LOADED | Config ready, no changes | Full page, Save button disabled |
| EDITING | Config being changed | Unsaved changes banner (sticky bottom), Save button enabled |
| SAVING | Submitting changes | Save button shows spinner, inputs disabled |
| SAVED | Just saved successfully | Toast "✅ Configuration saved", banner gone |
| SAVE_ERROR | Save failed | Toast error + "Thử lại" button, unsaved changes preserved |
| VALIDATION_ERROR | Invalid config values | Red highlights on invalid fields |
| ROLLBACK_AVAILABLE | Recent change caused issues | Yellow banner: "⚠️ Last change may have caused errors. [Rollback to previous config]" |

---

## 8. Validation Rules

| Field | Rule | Error Message |
|---|---|---|
| Temperature | 0.0 – 2.0, step 0.1 | "Temperature must be between 0.0 and 2.0" |
| Max tokens | 1 – 128000, integer | "Max tokens must be 1-128000" |
| System prompt | Required, max 4000 chars | "System prompt is required (max 4000 characters)" |
| Safety guidelines | Required, max 2000 chars | "Safety guidelines are required" |
| Rate limit (req/min) | 1 – 1000, integer | "Rate limit must be 1-1000" |
| A/B test weights | Must sum to 100% | "Weights must sum to 100%" |
| A/B test duration | 1 – 30 days | "Test duration: 1-30 days" |

### Cross-field Validation
- Fallback model must differ from primary model
- At least one feature must map to each active provider (no orphan providers)
- Rate limits must increase with tier (Free < Starter < Pro < Business)

---

## 9. Permission Matrix

| Action | Super Admin | Technical Admin | Operations Admin | Support Admin | Analyst / Auditor |
|---|---|---|---|---|---|
| View config | ✅ | ✅ | ❌ | ❌ | ❌ |
| Edit model mapping | ✅ | ✅ | ❌ | ❌ | ❌ |
| Edit prompts | ✅ | ✅ | ❌ | ❌ | ❌ |
| Reset prompts | ✅ | ❌ | ❌ | ❌ | ❌ |
| Edit rate limits | ✅ | ✅ | ❌ | ❌ | ❌ |
| Manage A/B tests | ✅ | ✅ | ❌ | ❌ | ❌ |
| Rollback config | ✅ | ❌ | ❌ | ❌ | ❌ |

---

## 10. Navigation Map

```
AI Config (/admin/ai/config)
├── → /admin/ai/providers    (via related link)
├── → /admin/ai/credits      (via related link)
├── → /admin/ai/ops          (via AI Operations link)
├── → Prompt History Drawer   (inline)
├── → Cost Simulator Drawer   (inline)
├── → A/B Test Dialog         (modal)
└── ← /admin/ai              (via breadcrumb)
```

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Config load failed | API error | Full-page error: "Cannot load AI configuration" | Retry button |
| Save failed | API error | Toast: "Save failed. Your changes are preserved." + retry | Retry button |
| Model unavailable | Provider down | Warning badge on model selector | Select different model |
| Concurrent edit | Another admin editing | Warning: "Config was modified by {admin} at {time}. Reload?" | Reload or force save |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Table | Proper `<th>` headers, sortable column announcements |
| Dropdowns | Keyboard navigable, screen reader announces selected model |
| Text editors | `aria-label`, `aria-describedby` for character count |
| Unsaved changes banner | `role="alert"`, `aria-live="polite"` |
| Rate limit inputs | Grouped with `fieldset` + `legend` per tier |

---

## 13. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Page load | <1s | Admin Shell + shimmer tables |
| Config fetch | 200-500ms | Data populates progressively |
| Save action | 500ms-2s | Button spinner, inputs disabled |
| Cost estimate | <300ms | Inline update (debounced 500ms from change) |

---

## 14. Performance Requirements

| Metric | Target |
|---|---|
| Page load | <2s |
| Save response | <2s |
| Cost estimate update | <500ms |

---

## 15. Real-time Updates

| Data | Channel | Frequency |
|---|---|---|
| Config changes by others | SSE `/admin/events/ai-config` | Real-time (concurrent edit detection) |
| A/B test results | Polling | 5m |

---

## 16. Localization Notes

- Admin interface is English-only (internal tool)
- Cost displayed in USD
- Dates in ISO format (YYYY-MM-DD HH:mm)

---

## 17. Analytics / Tracking Events

| Event | Trigger | Properties |
|---|---|---|
| `admin.ai_config.viewed` | Page load | `admin_role` |
| `admin.ai_config.saved` | Save all | `changed_features[]`, `models_changed[]` |
| `admin.ai_config.prompt_updated` | Prompt edited | `prompt_type`, `char_count` |
| `admin.ai_config.ab_test_created` | New A/B test | `feature`, `model_a`, `model_b` |
| `admin.ai_config.rollback` | Config rollback | `rollback_to_version` |

---

## 18. Design Tokens Reference

| Token | Usage |
|---|---|
| `--color-admin-surface` | Card backgrounds |
| `--color-admin-accent` | Save button, active states |
| `--color-admin-warning` | Unsaved changes banner |
| `--color-admin-danger` | Reset/rollback buttons |
| `--font-mono` | Cost estimates, rate limits |

---

## 19. Related Screens

| Screen | Relationship |
|---|---|
| [A011] AI Operations | Operational monitoring |
| [A012] AI Providers | Provider management |
| [A014] AI Credits | Credit pools management |
| [A001] Admin Dashboard | Overview dashboard |

---

## 20. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-28 | 3.0 | Full 20-point upgrade from 65-line Tier C. Added complete wireframe, component hierarchy, 12 feature mappings, fallback config section, A/B testing section, cost simulator, full actions table with API calls, permission matrix (S26 5-role admin RBAC), cross-field validation, concurrent edit handling. Fixed module reference (Admin→M23/S26). | System |
| 2026-03-28 | 2.0 | Expanded from sparse | System |
| 2026-03-28 | 1.0 | Initial specification | System |
