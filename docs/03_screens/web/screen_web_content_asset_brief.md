# Screen: Web — Asset Brief Editor

> **Screen ID**: W23
> **Module**: M04 — Content Creation (Scripts → Production)
> **Route**: `/scripts/[id]/brief`
> **Platform**: Web (SvelteKit)
> **Upstream**: Pack 01 §4, Product Freeze §14, A1 Schema (asset_briefs, brief_shots)

---

## 1. Purpose & Context

The Asset Brief is the visual production plan that bridges Script → AI Studio. It defines shot-by-shot visual notes, reference images, color palettes, and product placements. This document guides both AI generation and human production.

### User Story
> As a creator preparing to produce content, I want to plan the visual details — shots, references, style — so AI can generate matching visuals or I can follow it during filming.

### Entry Points
- Script Editor: "📋 Asset brief" button
- Script detail side panel: Brief tab
- Direct URL: `/scripts/[id]/brief`

### Exit Points
- "🎬 Produce" → AI Studio with brief context
- "← Script" → back to script editor

---

## 2. Layout Structure

### ASCII Wireframe
```
┌─ App Shell ──────────────────────────────────────────────────────────┐
│ ← Script   📋 Asset Brief: "5 tips nấu ăn"     [💾 Saved]         │
├──────────────────────────────────────────────────────────────────────┤
│                                                                      │
│ ┌─ Overall Style ────────────────────────────────────────────────┐  │
│ │ Mood: [Fun & Educational ▾]  Palette: [🎨 Warm tones ▾]      │  │
│ │ Aspect: [9:16 (TikTok) ▾]   Text style: [Bold overlay ▾]     │  │
│ │ Reference board: [📸 Drop images here or click to upload]      │  │
│ └────────────────────────────────────────────────────────────────┘  │
│                                                                      │
│ ┌─ Shot 1 (Hook: 0-5s) ─────────────────────────────────────────┐ │
│ │ Script: "Bạn có đang mắc 5 sai lầm..."                         │ │
│ │ Visual note: [Close-up face with surprised expression         ] │ │
│ │ Camera: [Close-up ▾]  Movement: [Static ▾]  Duration: [5s ▾]  │ │
│ │ Text overlay: [✅ Show text: "5 SAI LẦM"]                      │ │
│ │ Product placement: [❌ None]                                    │ │
│ │ References: [📸 📸] [+ Add ref]                                │ │
│ │ AI Generation prompt: [Auto-generated from notes, editable]    │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ┌─ Shot 2 (Body: 5-15s) ─────────────────────────────────────────┐ │
│ │ Script: "Tip 1: Không rửa mặt bằng nước nóng..."              │ │
│ │ Visual note: [Split screen: wrong technique vs correct       ] │ │
│ │ Camera: [Medium ▾]  Movement: [Pan left ▾]  Duration: [10s ▾] │ │
│ │ Text overlay: [✅ "Tip 1: NƯỚC NGUỘI"]                         │ │
│ │ Product placement: [Serum VitC ▾ — background placement]      │ │
│ │ References: [📸] [+ Add ref]                                   │ │
│ └──────────────────────────────────────────────────────────────────┘ │
│                                                                      │
│ ... more shots ...                                                   │
│                                                                      │
│ [+ Add shot]                                                         │
│                                                                      │
│ ┌─ Bottom Actions ───────────────────────────────────────────────┐  │
│ │ [🎬 Sản xuất với AI Studio]  [📤 Export PDF]  [📋 Copy brief] │  │
│ └────────────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Hierarchy

```
AssetBriefEditorPage
├── AppShell (shared)
├── PageHeader
│   ├── BackButton (→ script)
│   ├── Title
│   └── SaveStatus
├── OverallStyleSection
│   ├── MoodSelector
│   ├── PaletteSelector
│   ├── AspectRatioSelector
│   ├── TextStyleSelector
│   └── ReferenceBoardUploader
├── ShotList (sortable)
│   └── ShotCard[] (draggable, collapsible)
│       ├── ShotHeader (number + section label + time range)
│       ├── ScriptExcerpt (read-only, from linked script section)
│       ├── VisualNoteTextarea
│       ├── CameraSelector
│       ├── MovementSelector
│       ├── DurationInput
│       ├── TextOverlayToggle + TextInput
│       ├── ProductPlacementSelector
│       ├── ReferenceImages (upload + gallery)
│       └── AIPromptTextarea (auto-generated, editable)
├── AddShotButton
└── BottomActions
    ├── ProduceWithAIButton
    ├── ExportPDFButton
    └── CopyBriefButton
```

---

## 4-5. Data & Actions

| UI Element | Source | API |
|---|---|---|
| Script excerpt | `script_sections.content` | `ScriptService/Get(id)` |
| Brief data | `asset_briefs` + `brief_shots` | `BriefService/Get(script_id)` |
| Products | `products` (workspace) | `ProductService/List` |
| References | `brief_shots.references` (uploaded images) | File upload API |

| # | Action | Trigger | API | Result | Permission |
|---|---|---|---|---|---|
| 1 | Auto-save | 2s after edit | `BriefService/Update` | "💾 Saved" | `script:update` |
| 2 | Add shot | "+ Add shot" | `BriefService/AddShot` | New shot card | `script:update` |
| 3 | Reorder shots | Drag shot | `BriefService/ReorderShots` | Shots reorder | `script:update` |
| 4 | Delete shot | Shot ⋮ → "Xóa" | `BriefService/DeleteShot` | Shot removed | `script:update` |
| 5 | Upload reference | Drop or click | File upload → S3 | Image added | `script:update` |
| 6 | Produce with AI | "🎬 Sản xuất" | — | → `/studio/video?brief_id=[id]` | `asset:generate` |
| 7 | Export PDF | "📤 Export" | Client-side | PDF download | `script:read` |
| 8 | Copy brief | "📋 Copy" | — | Clipboard (formatted text) | `script:read` |

---

## 6. User Actions

| # | Action | Trigger | Type | API Call | Result | Permission |
|---|---|---|---|---|---|---|
| 1 | Auto-save | 2s after any edit | Auto | `BriefService/Update` debounced | "💾 Saved ✓" | `script:update` |
| 2 | Add shot | "+ Thêm shot" | Create | `BriefService/AddShot` | New shot card appends | `script:update` |
| 3 | Reorder shots | Drag shot | Reorder | `BriefService/ReorderShots(order[])` | Shots reorder with animation | `script:update` |
| 4 | Delete shot | ⋮ → "Xóa" → confirm | Delete | `BriefService/DeleteShot(id)` | Shot removed | `script:update` |
| 5 | Upload reference | Drop/click image | Upload | `FileService/Upload(presigned_url)` | Thumbnail appears | `script:update` |
| 6 | Produce with AI | "🎬 Sản xuất" | Navigate | — | → `/studio/video?brief_id=[id]` | `asset:generate` |
| 7 | Export PDF | "📤 Export" | Export | Client-side `pdf-lib` | PDF downloads | `script:read` |
| 8 | Copy brief | "📋 Copy" | Clipboard | — | Structured text → clipboard | `script:read` |
| 9 | Edit AI prompt | Edit auto-generated text | Auto-save | `BriefService/UpdateShot(shot_id, { ai_prompt })` | Prompt marked "Manual" | `script:update` |

---

## 7. Validation Rules

| Field | Rule | Error |
|---|---|---|
| Visual note | Optional (recommended) | Warning: "Nên mô tả visual" (non-blocking) |
| Duration | Required, integer, 1-300s | "Thời lượng từ 1 đến 300 giây" |
| Reference images | Max 5/shot, 10MB each, JPG/PNG/WebP | "Tối đa 5 ảnh, 10MB/ảnh" |
| Text overlay | Max 50 chars | "Tối đa 50 ký tự" |

---

## 8. States

| State | Condition | Visual |
|---|---|---|
| LOADING | Initial fetch | Shot card skeletons |
| LOADED | Brief data received | Full editor with shots |
| EMPTY_BRIEF | No shots defined | Auto-generate from script sections + message |
| SAVING | Auto-save in progress | "💾 Saving..." |
| SAVED | Auto-save complete | "💾 Saved ✓" (3s fade) |
| SAVE_FAILED | Auto-save error | "⚠️ Chưa lưu. [Thử lại]" (persistent) |
| READONLY | Script archived / no edit perm | Fields disabled, banner "Chỉ xem" |
| ERROR | API failed | Error page with retry |

---

## 9. Permission Matrix

| Feature | Owner | Admin | Manager | Editor | Contributor | Viewer |
|---|---|---|---|---|---|---|
| View brief | ✅ | ✅ | ✅ | ✅ | Own scripts | ✅ (read-only) |
| Edit brief | ✅ | ✅ | ✅ | ✅ | Own scripts | ❌ |
| Produce with AI | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Export/Copy | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

---

## 10. Edge Cases

| Edge Case | Handling |
|---|---|
| Script with no sections | Empty brief, "+ Thêm shot" only |
| Script sections changed after brief | Banner: "Script đã thay đổi. [Cập nhật shots]" |
| Product in placement deleted | "(Sản phẩm đã xóa)" placeholder |
| 20+ sections in script | All shots collapsed by default |
| AI prompt exceeds token limit | Truncate with warning |
| Concurrent editing | Last-write-wins + stale warning |

---

## 11. Error Handling

| Error Type | Trigger | UI Response | Recovery |
|---|---|---|---|
| Network offline | No connectivity | Banner: "📡 Ngoại tuyến — thay đổi sẽ lưu khi có mạng" | Auto-sync on reconnect |
| Auto-save failed | Server error | Header: "⚠️ Chưa lưu. [Thử lại]" | Retry button |
| Image upload failed | S3 URL expired | Toast: "Không tải được ảnh. [Thử lại]" | Retry with new URL |
| Script not found | Deleted script | Error page: "Script không tồn tại" | Navigate back |
| PDF export failed | Client error | Toast: "Không xuất được PDF. [Thử lại]" | Retry |

---

## 12. Accessibility

| Element | Requirement |
|---|---|
| Shot cards | `role="article"`, `aria-label="Shot {n}: {label}, {duration}s"` |
| Drag handle | `aria-label="Kéo để sắp xếp"`, keyboard: Ctrl+↑/↓ |
| Save status | `aria-live="polite"` |
| Image upload | `aria-label="Tải ảnh cho shot {n}"` |
| Collapsible | `aria-expanded` on shot header |

---

## 13. Performance Requirements

| Metric | Target |
|---|---|
| LCP | < 1.5s (first shot card) |
| Auto-save latency | < 500ms |
| Image upload | < 3s per 10MB |
| PDF export | < 5s for 10-shot brief |
| Drag reorder | 60fps |

---

## 14. Analytics Events

| Event | Trigger | Properties |
|---|---|---|
| `brief.viewed` | Page load | `script_id`, `shot_count` |
| `brief.shot_added` | Add shot | `script_id`, `shot_count` |
| `brief.reference_uploaded` | Upload image | `script_id`, `shot_id` |
| `brief.ai_prompt_edited` | Edit prompt | `script_id`, `shot_id` |
| `brief.produced` | Produce with AI | `script_id`, `total_duration` |
| `brief.exported_pdf` | Export PDF | `script_id` |

---

## 15. SvelteKit Implementation Notes

- **Route**: `src/routes/(app)/scripts/[id]/brief/+page.svelte`
- **Server load**: `+page.server.ts` → fetch brief + script sections + products
- **Auto-save**: Client debounce(2s) → `BriefService/Update`
- **AI Prompt**: Client-side template: `"[mood] scene, [camera], [movement]. [visual_note]. Style: [palette]."`
- **Images**: Presigned URL → PUT S3 → save URL to `brief_shots.references`
- **PDF**: Client-side `pdf-lib` with embedded reference images

---

## 16. Localization Notes

- Camera: "Cận" (Close-up), "Trung" (Medium), "Toàn" (Wide)
- Movement: "Tĩnh" (Static), "Quay ngang" (Pan), "Theo dõi" (Track)
- Save: "💾 Đã lưu", "💾 Đang lưu...", "⚠️ Chưa lưu"
- Duration: "5 giây"
- Product placement: "Chèn sản phẩm" / "Nền" / "Không"

---

## 17. Design Tokens

| Token | Usage |
|---|---|
| `--color-accent` | Primary CTAs |
| `--color-success` | Save confirmed |
| `--color-warning` | Unsaved, recommendations |
| `--color-danger` | Delete, save failed |
| `--color-surface-elevated` | Shot cards |
| `--color-surface-drag` | Dragging shot (elevated shadow) |

---

## 18. Related Screens

| Screen | Relationship |
|---|---|
| [W021] Script Editor | Parent script |
| [W030] AI Studio Launcher | AI production target |
| [W025] AI Video Editor | Alternative production |
| [W020] Script List | Parent list |
| [W027] Continuity OS | Brand consistency |

---

## 19. Revision History

| Date | Version | Change | Author |
|---|---|---|---|
| 2026-03-29 | 2.0 | **Tier A rewrite**: Expanded collapsed §6-20. Added 9 actions, 8 states, RBAC, 6 edge cases, 5 error scenarios, accessibility, 6 perf KPIs, 6 analytics, SvelteKit impl (AI prompt gen, S3 upload), localization, design tokens. Removed generic boilerplate. | System |
| 2026-03-28 | 1.0 | Initial specification | System |
