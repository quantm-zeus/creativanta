# Creativanta V5 — Full Product Design (Interactive)

**Owner design decision:** the visual language from Creativanta Go V4 was approved on 2026-10-31. V5 is a **brand-new OpenDesign project**, not duplicated from V4, with source-driven design coverage and interactions.

## OpenDesign location

- Project name: **Creativanta V5 — Full Product Design · Approved Go System**
- Project ID: `79d55843-25dc-478e-805c-6972bd15ad35`
- Main entry: **`creativanta-v5-start-here.html`**.
- Other artifacts: `creativanta-v5-web-all.html`, `creativanta-v5-mobile-all.html`, `creativanta-v5-admin-all.html`, `creativanta-v5-shared-system.html`.

## Coverage matrix

| Surface | Canonical screen IDs | Delivery |
|---|---:|---|
| Web | 135 | Standalone HTML with jobs-first navigation, command palette, complete deep-link screen registry, domain-specific layouts + demo actions |
| Mobile | 61 | Independent native-feeling Creativanta Go prototype; full-screen phone / framed desktop preview, 5-item bottom nav, deep-linkable screens + demo actions |
| Admin | 37 | Internal ops navigation, admin approval/analytics/table/form layouts with demo confirmation and search |
| Shared UI | 12 patterns | Live interactive color, type, nav, buttons, forms, table, badges, charts, cards, state, sheets and workflow demo |
| **Total** | **245 design items** | Four primary surface artifacts + Start Here gallery |

Source screen metadata: `design/v5/catalog.json`, specs under `docs/03_screens/`. Verified that all 233 listed screen source docs exist. `build_catalog.py` refreshes the catalog from canonical docs; `generate_specs.py` converts it into `screen_specs.json` with localized navigation labels, related-screen links and parsed actions (1,273 source action rows from 128 specs).

## Visual system

See `system/DESIGN_SYSTEM.md` and `system/tokens.json`. Approved Go V4 direction carried through: warm paper / charcoal / restrained vermilion / forest green; visual jobs-first grouping; editorial headings; restrained data density and neutral trust states. Older OpenDesign chats and artifacts are never imported into this project.

## UX interactions supported

- Job-based sidebar and phone bottom navigation, global search, 233 deep-linked screens, related-screen navigation.
- Local filtering/sorting, simulated record create, select/inspect, form editing and draft saving, CSV mock export.
- Content board, editor, calendar and workflow views with suitable structure and contextual controls.
- Approval and irreversible-looking actions always show a confirmation and **never send API commands**; in-memory demo statuses update with feedback.
- Mobile bottom sheets and quick action flows, notifications, search, demo chat/contacts/orders, localized responsive composition.
- All requested dialogs/controls are **interactive prototypes**, not actual production data entry, AI generation, money movement, publishing or external account authentication.

## Quality evidence

- `qa/qa_all.js`: Chromium route/viewport smoke across all 233 canonical routes. 858 viewport-route checks at Web 1440/820/390/360, Admin 1440/390, Mobile 1440/820/390/360; 12 shared component validations; search, keyboard dismissal, record creation and draft-save checks.
- `qa/qa_index.js`: Start Here supports 4 artifact cards, 233 indexed links, direct search by screen ID; no horizontal overflow at 1440/820/390/360.
- `qa/results.json`: latest actual test run output, including failure count; screenshots in `qa/screenshots/`.

**Acceptance boundary:** A passing route smoke is not a detailed UI review for each unique workflow or WCAG audit. Source actions are indexed but not all independently implemented as complete external behavior. 105 screen specs have no parseable action table. The visual system approval does not supersede canonical implementation/legal/security/authorization gates. The repo's Go backend and actual Web/Mobile app implementations are outside this prototype work.

## Rebuild

```sh
cd /home/whaleorcale/evergreen/services/creativanta
python3 design/v5/build_catalog.py
python3 design/v5/generate_specs.py
python3 design/v5/build.py
python3 design/v5/build_mobile.py
python3 design/v5/build_shared.py
python3 design/v5/build_index.py
```

No GitHub push, production deployment, backend/API mutation or secrets exposure.
