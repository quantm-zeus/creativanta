# Screen: Web — Idea Detail

> **Screen ID**: W013
> **Module**: M05 — Idea Engine
> **Route**: `/ideas/[id]`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §12/§13, A1 Schema (ideas, idea_scores, idea_tags, idea_references)

---

## 1. Purpose & Context

Full detail view of a single idea. Shows the idea's origin (manual/AI/trend/opportunity), AI score breakdown, attached references, linked scripts, and conversion actions. Also serves as the editing interface for idea enrichment.

### User Story
> As a creator, I want to review a content idea in detail — its score, source data, references — and decide whether to develop it into a script.

### Entry Points
- Idea Board: click idea card
- AI Idea Generator: after saving, click idea
- Notification: "AI scored your idea"
- Direct URL: `/ideas/[id]`

### Exit Points
- "📝 Viết script" → `/scripts/new?idea_id=[id]`
- "← Ý tưởng" → `/ideas`
- Delete → `/ideas`

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Ý tưởng   "5 sai lầm skincare mỗi sáng"     ⭐ 88 [Status ▾]  │
├──────────────────────────────────┬───────────────────────────────────┤
│ Main Content (65%)               │ Side Panel (35%)                   │
│                                  │                                    │
│ ┌─ Description ──────────────┐  │ ┌─ Quick Info ──────────────────┐│
│ │ [Rich text: Mô tả ý tưởng │  │ │ Status: 🟡 Evaluating         ││
│ │  - Chi tiết concept        │  │ │ Score: ⭐ 88/100              ││
│ │  - Target audience         │  │ │ Platform: 🎵 TikTok          ││
│ │  - Expected format]        │  │ │ Source: 🔥 From trend         ││
│ └────────────────────────────┘  │ │ Created: 26/03/2026           ││
│                                  │ │ By: Quân                      ││
│ ┌─ Score Breakdown ──────────┐  │ └──────────────────────────────┘│
│ │ Relevance   ██████████ 92  │  │                                  │
│ │ Timeliness  ████████░░ 88  │  │ ┌─ Actions ─────────────────────┐│
│ │ Competition █████████░ 85  │  │ │ [📝 Viết script]              ││
│ │ Audience    ████████░░ 82  │  │ │ [🔄 Rescore]                  ││
│ │ Overall     ████████░░ 88  │  │ │ [📤 Move to: Approved ▾]     ││
│ └────────────────────────────┘  │ │ [🗑 Xóa]                      ││
│                                  │ └──────────────────────────────┘│
│ ┌─ Source Reference ─────────┐  │                                  │
│ │ From: 🔥 Trend "morning   │  │ ┌─ Tags ─────────────────────────┐│
│ │  skincare routine" ⭐ 78   │  │ │ [skincare] [mistakes] [morning]││
│ │ [→ Xem trend gốc]         │  │ │ [+ Add tag]                    ││
│ └────────────────────────────┘  │ └──────────────────────────────┘│
│                                  │                                  │
│ ┌─ References & Inspiration ─┐  │ ┌─ Linked Scripts ──────────────┐│
│ │ [📸 Screenshot from...]    │  │ │ 📝 Script #23 "5 tips..."     ││
│ │ [🔗 URL: tiktok.com/...]   │  │ │    Status: Draft · 2h ago     ││
│ │ [📝 Note: "Focus on..."]   │  │ │ [→ Open script]               ││
│ │ [+ Add reference]          │  │ └──────────────────────────────┘│
│ └────────────────────────────┘  │                                  │
│                                  │ ┌─ Activity Log ────────────────┐│
│ ┌─ AI Copilot Analysis ─────┐  │ │ 📝 Quân edited · 2h ago       ││
│ │ 🤖 "Ý tưởng 'sai lầm'    │  │ │ 🤖 AI scored 88 · 3h ago     ││
│ │  format rất phổ biến trên │  │ │ ✨ Created from trend · 1d ago ││
│ │  TikTok VN. Hook dạng     │  │ └──────────────────────────────┘│
│ │  câu hỏi sẽ hiệu quả."   │  │                                  │
│ └────────────────────────────┘  │                                  │
└──────────────────────────────────┴───────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
IdeaDetailPage
├── AppShell (shared)
├── PageHeader
│   ├── BackButton
│   ├── IdeaTitle (editable inline)
│   ├── ScoreBadge
│   └── StatusDropdown (Inbox/Evaluating/Approved/In Script/Done)
├── SplitView
│   ├── MainPanel (65%)
│   │   ├── DescriptionEditor (rich text, editable)
│   │   ├── ScoreBreakdownChart
│   │   │   └── ScoreBar[] (relevance, timeliness, competition, audience)
│   │   ├── SourceReferenceCard
│   │   │   ├── SourceType + SourceLink
│   │   │   └── ViewOriginalButton
│   │   ├── ReferencesSection
│   │   │   ├── ReferenceItem[] (screenshots, URLs, notes)
│   │   │   └── AddReferenceButton
│   │   └── AICopilotAnalysisCard
│   │       ├── AnalysisText
│   │       └── RegenerateButton
│   └── SidePanel (35%)
│       ├── QuickInfoCard
│       ├── ActionsCard (write script, rescore, move, delete)
│       ├── TagEditor
│       │   ├── TagChip[] (removable)
│       │   └── AddTagInput
│       ├── LinkedScriptsCard
│       │   └── ScriptLink[]
│       └── ActivityLog
│           └── ActivityItem[] (edit, score, create events)
```

---

## 4. Data Binding

| UI Element | Source | API |
|---|---|---|
| Title | `ideas.title` | `IdeaService/Get(id)` |
| Description | `ideas.description` (rich text JSON) | same |
| Score | `ideas.ai_score` | same |
| Score breakdown | `idea_scores` | same |
| Source | `ideas.source_type` + `ideas.from_trend_id` or `from_opportunity_id` | same |
| Tags | `idea_tags` | same |
| References | `idea_references` (images, URLs, notes) | same |
| Linked scripts | `scripts WHERE idea_id = [id]` | same |
| AI analysis | `ideas.ai_analysis` or on-demand | `CopilotService/Query` |
| Activity | `activity_log WHERE entity_type=idea AND entity_id=[id]` | `ActivityService/List` |

---

## 5. Actions Table

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Edit title | Click title → inline edit | `IdeaService/Update(title)` | Auto-save | `idea:create` |
| 2 | Edit description | Type in rich text editor | `IdeaService/Update(description)` | Auto-save (2s debounce) | `idea:create` |
| 3 | Write script | "📝 Viết script" | — | → `/scripts/new?idea_id=[id]` | `script:create` |
| 4 | Rescore | "🔄 Rescore" | `IdeaService/Rescore(id)` | Score updates + animation | `idea:create` |
| 5 | Change status | Status dropdown | `IdeaService/Update(status)` | Badge updates | `idea:create` |
| 6 | Add tag | "+ Add tag" | `IdeaService/AddTag(tag)` | Tag chip added | `idea:create` |
| 7 | Remove tag | Click ✕ on tag | `IdeaService/RemoveTag(tag)` | Tag removed | `idea:create` |
| 8 | Add reference | "+ Add reference" | Modal → upload/URL/note | `IdeaService/AddReference` | `idea:create` |
| 9 | View source | "→ Xem trend gốc" | — | Navigate to source page | `trend:read` |
| 10 | Open script | Click linked script | — | → `/scripts/[script_id]` | `script:read` |
| 11 | Delete | "🗑 Xóa" → confirm | `IdeaService/Delete(id)` | → `/ideas` | `idea:create` |
| 12 | Regenerate AI | Refresh on AI card | `CopilotService/Query(mode=idea_analysis)` | Analysis updates | `copilot:use_help` |

---

## 6. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Split-view skeletons |
| LOADED | Idea data received | Full detail with editable fields |
| SAVING | Auto-save in progress | "💾 Saving..." |
| SAVED | Auto-save complete | "💾 Saved ✓" (3s) |
| RESCORING | Rescore in progress | Score section spinner |
| NOT_FOUND | Idea deleted/invalid | "Ý tưởng không tồn tại. [← Quay lại]" |
| ERROR | API failed | Error page with retry |

---

## 7. Validation Rules

| Field | Rule | Error |
|---|---|---|
| Title | 5-200 chars | "Tiêu đề phải từ 5-200 ký tự" |
| Tags | Max 10 | "Tối đa 10 tag" |
| Reference URL | Valid URL format | "URL không hợp lệ" |

---

## 8. Permission Matrix

| Action | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View | ✅ | ✅ | ✅ | ✅ | Own ideas | ✅ (read-only) |
| Edit | ✅ | ✅ | ✅ | ✅ | Own ideas | ❌ |
| Delete | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Rescore | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Write script | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |

---

## 9. Edge Cases

| Edge Case | Handling |
|---|---|
| Idea linked to deleted trend | Show "(Trend đã xóa)" with strikethrough |
| Rescore returns different score | Score breakdown animates transition (old → new) |
| 10+ references | Scrollable section with lazy-loaded images |
| Script already exists from this idea | Button changes: "📝 Xem script" instead of "Viết script" |
| AI analysis unavailable | Card hidden; button "🤖 Yêu cầu phân tích" visible |

---

## 10. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — chế độ chỉ đọc" | Auto-sync on reconnect |
| Auto-save failed | Server error | Header: "⚠️ Chưa lưu. [Thử lại]" | Retry |
| Rescore failed | AI service error | Toast: "Không chấm điểm lại được. [Thử lại]" | Retry |
| Reference upload failed | File error | Toast: "Không tải lên được. [Thử lại]" | Retry |
| Delete failed | Server error | Toast: "Không xóa được. [Thử lại]" | Retry |
| AI analysis failed | Copilot error | Card: "🤖 Không phân tích được. [Thử lại]" | Retry |

---

## 11. Accessibility

| Element | Requirement |
|---|---|
| Score bars | `role="meter"`, `aria-valuenow`, `aria-label="Relevance: 92/100"` |
| Rich text editor | `role="textbox"`, `aria-multiline`, `aria-label="Mô tả ý tưởng"` |
| Tags | `role="list"`, removable chips with `aria-label="Xóa tag {name}"` |
| Reference images | `alt="Tham khảo {index}: {type}"` |
| Status dropdown | `aria-expanded`, `aria-haspopup="listbox"` |
| Activity log | `aria-label="Nhật ký hoạt động"` |

---

## 12. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Split-view skeleton |
| Main content | 200-400ms | Title, description, score populate |
| Score breakdown | 300ms | Bars animate from 0 to value |
| Side panel | 400ms | Quick info, tags, activity load |
| References | 500-800ms | Images lazy-load with blur placeholder |

---

## 13. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (title + score visible) |
| TTI | < 2.0s |
| Auto-save | < 500ms |
| Rescore | < 3s (AI round-trip) |
| Reference image load | < 2s per image |

---

## 14. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `idea.detail.viewed` | Page load | `idea_id`, `score`, `source_type`, `status` |
| `idea.edited` | Title/description saved | `idea_id`, `field_changed` |
| `idea.scored` | Rescore completed | `idea_id`, `old_score`, `new_score` |
| `idea.status_changed` | Status dropdown | `idea_id`, `old_status`, `new_status` |
| `idea.script_created` | Write script clicked | `idea_id` |
| `idea.reference_added` | Reference uploaded | `idea_id`, `ref_type` ('image'/'url'/'note') |
| `idea.deleted` | Delete confirmed | `idea_id` |
| `idea.ai_analysis_viewed` | AI card visible | `idea_id` |

---

## 15. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/ideas/[id]/+page.svelte`
- **Server load**: `+page.server.ts` → fetch idea + scores + references + linked scripts
- **SSR**: Server renders main content; side panel loads client-side
- **Auto-save**: ProseMirror editor with debounce(2s) → `IdeaService/Update`
- **Score bars**: Custom SVG with CSS transition on `width`
- **References**: Image upload via presigned URL; URL/note stored inline
- **AI analysis**: On-demand `CopilotService/Query(mode=idea_analysis)`

---

## 16. Localization Notes

- Score: "88/100 điểm", "Rất tốt" (≥85), "Tốt" (70-84), "Trung bình" (50-69), "Cần cải thiện" (<50)
- Source types: "Từ xu hướng" (trend), "AI gợi ý" (AI), "Thủ công" (manual), "Từ cơ hội" (opportunity)
- Status: "Hộp thư" (Inbox), "Đang đánh giá" (Evaluating), "Đã duyệt" (Approved), "Đang viết script" (In Script), "Hoàn thành" (Done)
- Actions: "Viết script", "Chấm điểm lại", "Xóa"
- Relative time: "2 giờ trước", "1 ngày trước"

---

## 17. Design Tokens

| Token | Usage |
|---|---|
| `--color-score-excellent` | Score ≥ 85 (🟢 green) |
| `--color-score-good` | Score 70-84 (🔵 blue) |
| `--color-score-average` | Score 50-69 (🟡 amber) |
| `--color-score-low` | Score < 50 (🔴 red) |
| `--color-accent` | Primary CTAs (Write script) |
| `--color-success` | Save confirmed |
| `--color-surface-elevated` | Cards, panels |
| `--color-ai-accent` | AI analysis card highlight |

---

## 18. Related Screens

| Screen | Relationship |
|---|---|
| [W012] Idea Board | Parent list |
| [W014] AI Idea Generator | Source if AI-generated |
| [W016] Script Editor | Downstream conversion |
| [M009] Mobile Idea Detail | Mobile equivalent |
| [W039] Trend Detail | Source trend |

---

## 19. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A rewrite**: Expanded §6-20 into 14 proper sections. Added 7 states, 3 validation rules, RBAC, 5 edge cases, 6 error scenarios, accessibility for score bars and rich text, 5-stage loading, 5 perf KPIs, 8 analytics events, SvelteKit impl, idea-specific localization with score tiers, 8 design tokens with score colors. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
