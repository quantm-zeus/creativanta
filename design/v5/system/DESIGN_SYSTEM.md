# Creativanta Go — Approved V5 Product Prototype Design System

Owner approved the **Creativanta Go V4** visual direction on 2026-10-31, then authorized a separate project for all screens with interactions.

## Scope and status

- V5 OpenDesign project: **Creativanta V5 — Full Product Design · Approved Go System**, ID `79d55843-25dc-478e-805c-6972bd15ad35`.
- Visual system **approved for the interactive design prototype**, NOT a formal override of canonical product-contract design tokens in `docs/06_quality_ops/`. Production changes require reconciling their token sources.
- Prototype coverage: **135 Web + 61 Mobile + 37 Admin canonical routes; 12 shared interactive UI patterns**, organized from source documentation. 245 design items.
- All artifacts are offline/self-contained HTML with in-memory demonstration state. No real accounts, backend, API calls, payments, uploading, AI generation, or publishing.
- All UI changes are deliberately contained within `design/v5/`; existing docs and previous OpenDesign projects remain unchanged.

## Brand and visual language

| Role | Approved prototype value | Usage |
|---|---|---|
| Paper | `#FBF9F5` | Primary backgrounds, quiet breathing room |
| Canvas | `#F6F3ED` | Secondary surfaces and separators |
| Card | `#FFFEFA` | Interactive surfaces |
| Ink | `#242924` | Main typography |
| Charcoal | `#151B17` | High emphasis |
| Muted | `#7D837B` | Labels and descriptions |
| Border | `#E8E5DC` | Fine outlines |
| Vermilion | `#D94A31` | Major actions, active navigation and emphasis |
| Forest | `#274333` | Calm contrast, reliable controls |
| Positive | `#EAF3EA` | Verified statuses |

Typography: Inter or Be Vietnam Pro with system fallbacks; editorial accent Georgia *italic* only in prominent headlines. Weight primarily 400/650/750, line heights 1.4–1.8. Main spacing tokens 4/8/12/16/24/32/48px. Radius control 11px, cards 17px, hero 23px.

## Interaction and navigation principles

1. **Jobs-first, not specs-first.** Primary Web navigation uses Tổng quan / Khám phá / Sáng tạo / Xuất bản / Khách hàng / Kinh doanh / Phân tích / Tự động hóa, with Cài đặt in utility space. Admin uses task-oriented operations groups. Mobile keeps only Hôm nay / Khám phá / Sáng tạo / Hộp thư / Thêm in a bottom nav. All long-tail screens are accessible from search.
2. **Each purpose receives a suitable composition:** analytics charts, dense tables with internal horizontal scroll, content editors/forms, publishing calendar, approval queues with confirmation, conversational inbox, workflow diagrams, detail sheets, settings and search.
3. **Interaction has visible feedback.** Local filtering/sorting, record creation and editing, form draft-save, selected tab/date/period, modal/side sheets, demo CSV export, acknowledgement or approval confirm, toast, retry/empty/error demonstration. Source-described actions are displayed via contextual task access; not all external API semantics are implemented.
4. **Risk is visibly constrained.** Publishing, deleting, revoking, suspending, payment and other side effects never call a backend. These paths only simulate a confirmation; status is explicitly marked DEMO.
5. **Navigation remains contiguous.** Each screen carries its canonical ID/route in the internal registry, with links into related screens. The Start Here library offers a deep link into each platform.
6. **Responsive.** Validated with Chromium at Web 1440/820/390/360px, Admin 1440/390px, Mobile 1440/820/390/360px. Phone renders without extraneous device frame on a physical small browser and maintains a five-item touch navigation. Screens are tested for zero document-level horizontal overflow at these breakpoints.
7. **Accessibility direction:** keyboard Escape dismiss, labeled forms, semantic tabs/regions, focus rings, readable text, motion reduction. This is not a formal WCAG audit.

## Prototype sources

- `system/tokens.json` for machine-readable tokens and scope.
- `web/style.css` + `web/approved-go.css` + `web/full.css`, corresponding JS, for Web/Admin; V4 Go-approved art direction intentionally carried forward.
- `mobile/mobile.css` + `mobile/full.css`, corresponding JS, for mobile-native experience.
- `shared/` for 12 interactive patterns; master document artifact `creativanta-v5-shared-system.html`.
- `generate_specs.py`: extracts canonical screen index/sources and parseable action tables into `screen_specs.json`; `build.py`, `build_mobile.py`, `build_shared.py`, `build_index.py` produce deterministic HTML artifacts.
- `qa/qa_all.js` and `qa/qa_index.js`: executable Chromium route+responsive smoke checks; screenshot evidence in `qa/screenshots/`; results in `qa/results.json`.

## Handoff cautions

**Design coverage is not implementation acceptance.** 233 screen IDs are browsable, with reusable domain-specific layouts and prototype interactions. Individual complex product screens require deeper per-screen UX review, source contract reconciliation, permission/error-state verification and actual Flutter/Web implementation; 1,273 source-described actions in 128 screen docs are indexed but NOT validated as 1,273 independently correct production flows. 105 screen docs have no extractable action tables, so corresponding layouts use the appropriate reusable controls. No source app has been deployed or pushed by this task. Production readiness remains gated by D0–D5 in `docs/00_index/BUILD_EXECUTION_CONTRACT.md`.
