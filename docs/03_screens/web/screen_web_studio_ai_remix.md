# Screen: Web — AI Remix Studio

> **Screen ID**: W28
> **Module**: M07 — AI Studio
> **Route**: `/studio/remix`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4.4, Pack 04, A1 Schema (assets, generation_queue)

---

## 1. Purpose & Context

3-phase pipeline: (1) Input reference video + settings → (2) AI extracts Creative DNA (structure, pacing, style) → (3) Generate original remix with originality safeguards. Includes side-by-side comparison and per-scene editing.

### User Story
> As a creator, I want to analyze a trending video's style and create my own original version that follows the same successful pattern.

---

## 2. Layout Structure

### Phase 1: Input
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Studio   🔄 AI Remix Studio                                       │
├──────────────────────────────────────────────────────────────────────┤
│ Step: [● Input] → [○ DNA Report] → [○ Polish]                      │
│                                                                      │
│ ┌─ Reference ────────────────────────────────────────────────────┐  │
│ │ [📎 Upload video] or [🔗 Paste URL]                            │  │
│ │ URL: [https://tiktok.com/...                              ]    │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Remix Settings ───────────────────────────────────────────────┐  │
│ │ Fidelity: ○ Match 1:1  ● Adapt  ○ Loose                       │  │
│ │ Topic: [Skincare, beauty tips                              ]   │  │
│ │ Character: [🎭 Mila ▾]    Brand Pack: [My Brand ▾]            │  │
│ │ Platforms: [☑ TikTok] [☑ Reels] [☐ YouTube]                   │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ [🔍 Analyze — ~8 credits]                                           │
└──────────────────────────────────────────────────────────────────────┘
```

### Phase 2: Creative DNA Report
```
│ Step: [✓ Input] → [● DNA Report] → [○ Polish]                      │
│                                                                      │
│ ┌─ Creative DNA ─────────────────────────────────────────────────┐  │
│ │ Duration: 28s | Scenes: 6 | Hook: Question                     │  │
│ │ 📊 Structure:                                                    │  │
│ │ [Hook 3s][Problem 5s][Tip1 6s][Tip2 6s][CTA 5s][Outro 3s]     │  │
│ │ 🎵 Audio: Pop, BPM 120, Voice 70% / Music 30%                  │  │
│ │ 🎨 Visual: Bright palette, fast cuts, text overlays             │  │
│ │ 📈 Pacing: Fast → Medium → Fast                                 │  │
│ │ [✏ Edit blueprint] [🔄 Generate Remix — ~35 credits]           │  │
│ └────────────────────────────────────────────────────────────────┘  │
```

### Phase 3: Polish & Export
```
│ Step: [✓ Input] → [✓ DNA Report] → [● Polish]                      │
│                                                                      │
│ ┌─ Side-by-Side Player ──────────────────────────────────────────┐  │
│ │ [Original Video ▶]          │          [Remix Video ▶]         │  │
│ │ Synced playback              │          Synced playback         │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Quality Checks ──────────────────────────────────────────────┐  │
│ │ ✅ Originality: 85% (safe — threshold: ≥70%)                  │  │
│ │ ⭐ Virality Score: 78/100                                      │  │
│ │ ✅ Compliance: pass (no copyright issues)                      │  │
│ │ ✅ Script similarity: 22% (safe — threshold: <30%)             │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Per-Scene Editor ─────────────────────────────────────────────┐  │
│ │ Scene: [1 ▾] Hook — 3s                                         │  │
│ │ [✏ Edit script] [🎨 Edit visual] [🔄 Regenerate — 15 cr]      │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ [📤 Export to platforms] [📅 Schedule publish] [💾 Save draft]      │
```

---

## 3. Component Hierarchy

```
AIRemixStudioPage
├── AppShell (shared)
├── PageHeader (← Studio, title)
├── StepIndicator (Input → DNA Report → Polish)
├── Phase1_InputPanel
│   ├── ReferenceUploader (URL paste or file upload)
│   ├── SettingsForm
│   │   ├── FidelitySelector (Match/Adapt/Loose)
│   │   ├── TopicInput
│   │   ├── CharacterSelector
│   │   ├── BrandPackSelector
│   │   └── PlatformCheckboxes
│   └── AnalyzeButton
├── Phase2_DNAPanel
│   ├── DNASummary (duration, scenes, hook type)
│   ├── StructureTimeline (clickable segments)
│   ├── AudioAnalysis
│   ├── VisualAnalysis
│   ├── PacingChart
│   ├── EditBlueprintButton
│   └── GenerateRemixButton
├── Phase3_PolishPanel
│   ├── SideBySidePlayer (synced original + remix)
│   ├── QualityChecks
│   │   ├── OriginalityScore
│   │   ├── ViralityScore
│   │   ├── ComplianceCheck
│   │   └── ScriptSimilarity
│   ├── PerSceneEditor
│   │   ├── SceneSelector
│   │   ├── EditScriptButton
│   │   ├── EditVisualButton
│   │   └── RegenerateButton
│   └── ExportActions (publish, schedule, save)
```

---

## 4-5. Data & Actions

| # | Action | Trigger | API | Credits | Result |
|---|---|---|---|---|---|
| 1 | Upload/paste reference | File/URL | `AssetService/FetchReference` | 0 | Reference loaded |
| 2 | Analyze | "🔍 Analyze" | `AssetService/AnalyzeCreativeDNA` | ~8 cr | Phase 2 populated |
| 3 | Edit blueprint | "✏ Edit" | — (client) | 0 | Editable DNA structure |
| 4 | Generate remix | "🔄 Generate" | `AssetService/Generate(type=remix)` | ~35 cr | → Queue + Phase 3 |
| 5 | Edit scene | Scene editor buttons | Various | ~15 cr | Scene regenerated |
| 6 | Export | "📤 Export" | `AssetService/Export` | 0 | Platform export |
| 7 | Schedule | "📅 Schedule" | `PublishService/Schedule` | 0 | → Publish queue |

### Legal Safeguards (visible on UI)
- Originality score always displayed
- "No footage reuse" badge
- Script similarity percentage
- Max 20 remixes/day shown in header
- Fidelity level shown throughout flow

---

## 6-20. Standard Sections

### States
| State | Visual |
|---|---|
| PHASE_1 | Input form |
| ANALYZING | DNA analysis progress |
| PHASE_2 | DNA report with editable blueprint |
| GENERATING | Video generation pipeline progress |
| PHASE_3 | Side-by-side with quality checks |
| LOW_ORIGINALITY | Warning "⚠️ Originality < 70%. Increase creative freedom." |

### Technical Notes
- Route: `src/routes/(app)/studio/remix/+page.svelte`
- Phase state: URL param `?phase=2`
- Side-by-side: two synced `<video>` elements
- Quality checks: server-side analysis

### Related Screens
| Screen | Relationship |
|---|---|
| [W24] AI Studio Launcher | Parent |
| [W09] Trend Radar | Reference source |
| [M55] Mobile AI Remix | Mobile equivalent |

### Revision History
| Date | Version | Change |
|---|---|---|
| 2026-03-28 | 1.0 | Initial specification |

---

## 7. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến" | Retry online |
| Analyze fail | AI error or URL invalid | Toast: "Không phân tích được video. [Thử lại]" | Retry/re-upload |
| Insufficient credits | Credit check fails | Alert: "Không đủ credits. [Nạp thêm →]" | Top-up |
| Generation fail | Pipeline error | Toast: "Tạo remix thất bại. [Thử lại]" | Retry |
| Low originality | Score <70% | Warning: "⚠️ Originality <70%. Tăng creative freedom." | Adjust fidelity |

---

## 8. Accessibility

| Element | Requirement |
|---|---|
| Step indicator | `role="progressbar"`, `aria-label="Step {n} of 3: {phase_name}"` |
| Side-by-side player | Each `<video>` with `aria-label="Original video"` / `aria-label="Remix video"` |
| Quality checks | `role="list"`, items with `aria-label="{check}: {value} ({status})"` |
| Scene editor | `role="tabpanel"`, scene selector as `role="tablist"` |
| DNA timeline | `role="img"`, `aria-label="Creative DNA structure: {scene_count} scenes, {duration}s"` |

---

## 9. Loading Behavior

| Stage | Duration | Visual |
|---|---|---|
| Initial render | 0ms | Input form |
| URL analysis | 5-15s | "🔍 Đang phân tích..." progress spinner |
| DNA report | 0ms (after analysis) | Report appears |
| Remix generation | 30-120s | Progress bar with step descriptions |
| Quality checks | 2-5s | Scores populate sequentially |

---

## 10. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `studio.remix_started` | Page load | `entry_point` |
| `studio.reference_uploaded` | URL/file submitted | `source_type` (url/file), `platform` |
| `studio.dna_analyzed` | Analysis complete | `scene_count`, `duration`, `credits_used` |
| `studio.blueprint_edited` | "✏ Edit blueprint" | `changes_made` |
| `studio.remix_generated` | Generation complete | `credits_used`, `originality_score` |
| `studio.scene_regenerated` | Scene regenerate | `scene_idx`, `credits_used` |
| `studio.quality_warning` | Originality <70% | `score`, `fidelity` |
| `studio.remix_exported` | "📤 Export" | `platforms`, `format` |

---

## 11. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/studio/remix/+page.svelte`
- **Phase state**: URL param `?phase=2` for back-navigation
- **Analysis**: `AssetService/AnalyzeCreativeDNA(url)` → SSE progress updates
- **Generation**: `AssetService/Generate(type=remix, dna, settings)` → queue job → poll status
- **Side-by-side**: Two synced `<video>` elements with shared `currentTime`
- **Quality checks**: Server-side analysis after generation complete
- **Credits**: Deducted at analysis (8) + generation (35) + per-scene regen (15)

---

## 12. Localization Notes

- Phases: "Đầu vào", "DNA Sáng tạo", "Chỉnh sửa"
- Settings: "Độ trung thực:", "Chủ đề:", "Nhân vật:", "Thương hiệu:"
- Quality: "Tính gốc:", "Điểm viral:", "Tuân thủ:", "Tương đồng script:"
- Tone: Creative, technical

---

## 13. Design Tokens

| Token | Usage |
|---|---|
| `--color-accent` | Generate CTA, export |
| `--color-ai` | AI analysis, DNA card |
| `--color-success` | Quality check pass (≥70%) |
| `--color-warning` | Quality check caution |
| `--color-danger` | Quality check fail (<70%) |
| `--color-surface-elevated` | Phase panels |
| `--font-metric` | Scores, credits (tabular-nums) |
| `--color-step-active` | Current step indicator |

---

## 14. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-30 | 2.0 | **Tier A upgrade**: 5 errors (analyze, originality), phase/player a11y, 8 analytics, SvelteKit impl (3-phase, DNA, quality), localization, 8 design tokens. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
