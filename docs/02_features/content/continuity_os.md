---
layer: features
module: M08
canonical: true
domain: content
status: DRAFT
last_updated: 2026-03-30
---

# Feature: Continuity OS (M08)

## Purpose

AI-generated content suffers from a fundamental consistency problem: every new generation can produce visually, tonally, and vocally different outputs, making a creator's brand feel incoherent. Without a system to define and enforce "who am I?", each AI-generated video looks like it was made by a different person.

M08 exists to **solve the AI consistency problem** by providing creators with a structured way to:
1. Build and manage **Characters** (digital twins, AI personas, stock avatars) via a guided wizard
2. Assemble **Continuity Packs** (Character Pack, Brand Pack, Voice Pack, Style Pack) that carry canonical visual/voice/brand references
3. Detect **drift** when AI outputs deviate from canonical references
4. Maintain **approved references** as the single source of truth for "what my brand/character looks like"

Every AI generation request (M07) MUST resolve continuity packs before producing output, and every output MUST be evaluated for drift against the canonical references.

## Scope

### Covers
- Character Builder: 4-step creation wizard (type → profile → preview → save)
- Character types: digital_twin, ai_generated, stock
- Character slot gating per subscription tier
- Digital Twin consent verification flow (face match + consent video)
- Character ↔ Continuity Pack auto-linking (character auto-creates Character Pack)
- Default character selection and management
- Continuity Pack management: create, version, deprecate, retire
- Brand Pack, Voice Pack, Style Pack management
- Approved reference management (first-class objects, not free-text notes)
- Drift detection: none / low / moderate / high severity
- Continuity QA integration with M07 output pipeline
- Drift warnings and block-on-high-drift behavior
- Voice clone creation and attachment to characters

### Does NOT cover (Non-goals for this module)
- AI video/image generation execution (owned by M07)
- Script authoring and approval (owned by M06)
- Asset derivative management (owned by M09)
- Packaging quality scoring (owned by M10)
- Gamification and creator progression (owned by Growth service)

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Creator | Editor+ | Create characters, manage packs, set default character, approve references |
| Manager | Manager+ | Update packs, review drift warnings, promote canonical assets |
| System (QA) | System | Run drift detection on generated outputs, block high-drift assets |
| System (Generation) | System | Resolve continuity packs during prompt assembly |

## Business Rules

1. **RULE-M08-001**: Character creation MUST follow the 4-step wizard: Step 1 (Choose Type) → Step 2 (Profile: visual + voice + personality) → Step 3 (Preview: 15s test video) → Step 4 (Save & Settings). Steps cannot be skipped (PRD §23.8 AC, Pack 04 §12A.3).
2. **RULE-M08-002**: Digital Twin characters MUST pass consent verification BEFORE they can be used in any generation. `consent_verified` MUST be `true`. Consent flow requires: (a) upload source footage, (b) record consent video with standardized declaration, (c) AI face match between source and consent video. If `consent_verified = false`, the character MUST be blocked from selection in generation flows (PRD §23.8 AC, Pack 04 §12B.7).
3. **RULE-M08-003**: Character slots MUST be gated per subscription tier: Free: 1, Starter: 2, Pro: 5, Business: 15, Enterprise: unlimited. When quota is exceeded, the system MUST block creation with "Character limit reached for your plan. [Upgrade] or [Archive existing]" (PRD §23.8 AC, Pack 04 §12B.4).
4. **RULE-M08-004**: When a Character is created, the system MUST auto-create a corresponding Character Pack (continuity_packs row with `pack_type = 'character'`). The `character_pack_id` FK on the Character table MUST reference this pack. Drift detection uses this Character Pack as the canonical reference (Pack 04 §5.1, §12B.3).
5. **RULE-M08-005**: Drift severity levels are: `none`, `low_drift`, `moderate_drift`, `high_drift`. Moderate drift MUST produce a warning badge on the generated asset. High drift MUST block the asset from publish-ready path unless explicitly overridden with reason by Manager+ (Pack 04 §5.3, §8.3).
6. **RULE-M08-006**: Maximum 1 default character per workspace. Setting a new default MUST auto-unset the previous default. When a user opens a video generation flow, the default character MUST be auto-selected. If no default is set, the system MUST prompt "Choose a character" before generation can proceed (Pack 04 §12B.6).
7. **RULE-M08-007**: Continuity packs MUST be versioned (`version INTEGER`). Updates create a new version, not an in-place mutation. Previous versions are retained for lineage tracking. Pack status lifecycle: `draft → active → deprecated → retired` (DB schema §7.2, Pack 04 §5.2).
8. **RULE-M08-008**: Approved references are first-class canonical objects — not free-text notes. Each approved reference MUST have a canonical ID, parent pack/asset/script reference, source/provenance context, and current status (Pack 04 §5.4).

## Main Flow

1. **User opens Character Library**: navigates to "AI Studio → My Characters"
   - calls `CharacterService/List` (Member)
   - Grid view: character cards with avatar, name, type badge, usage count
   - Quota indicator: "2/5 characters used"
   - see [04_contracts/api_endpoint_map.md#2.3](../04_contracts/api_endpoint_map.md)
2. **User starts Character Creation Wizard**: clicks "➕ Create New Character"
   - **Step 1 — Choose Type**: digital_twin (Pro+), ai_generated (all), stock (all)
     - Locked types show tier badge: "🔒 Upgrade to Pro"
   - **Step 2 — Profile Setup**:
     - Visual: upload footage (digital_twin) / text prompt + style (ai_generated) / browse library (stock)
     - Voice: clone (Pro+) / select AI preset / none
     - Personality: tags (max 5) + speaking tone (formal/casual/fun/energetic/calm/inspiring)
     - Optional: Link Brand Pack
   - **Step 3 — Preview**: system generates 15s test video with sample script
     - User reviews visual + voice in 3 aspect ratios
     - Can go back to Step 2 for adjustments
   - **Step 4 — Save**: option to set as default, save to library
   - calls `CharacterService/Create` (Editor+)
   - writes to `characters` table, auto-creates `continuity_packs` row (Character Pack)
   - emits `character.created`
   - see [04_contracts/domain_event_catalog.md#5](../04_contracts/domain_event_catalog.md)
3. **Digital Twin Consent** (if type = digital_twin, runs between Step 1 and Step 2):
   - (a) Upload source footage (30s-5min)
   - (b) Record consent video (in-app): standardized declaration text
   - (c) AI verifies face match between source and consent video
   - If match → `consent_verified = true`, proceed
   - If mismatch → reject with explanation
4. **Character used in generation**: user selects character in M07 video creation flow
   - Default character auto-populated in top bar selector
   - M07 prompt assembly resolves character's Character Pack, Voice Pack, Brand Pack
5. **Drift detection**: after M07 generates output:
   - QA service compares output visual/voice against Character Pack canonical references
   - Severity assigned: none/low/moderate/high
   - If moderate/high → emits `continuity.violation_detected`
   - Asset flagged with drift badge

## Alternate Flows

### A1: Voice Clone Attachment
- Trigger: User selects "Clone Voice" during character creation (Pro+ tier)
- Steps: User uploads voice sample audio (≥30s). System sends to voice clone provider. Clone processed → voice_clone_id stored. Voice Pack created/linked.
- Result: Character has cloned voice available for TTS in M07

### A2: Pack Version Update
- Trigger: User updates the Character Pack's approved references (e.g., new canonical headshot)
- Steps: System creates new pack version (version + 1). Previous version archived but retained. All future generations use new version. Existing assets generated with old version are not retroactively flagged.
- Result: Version history preserved for lineage tracking

### A3: Drift Override
- Trigger: Manager reviews a high-drift asset and determines it's acceptable despite the deviation
- Steps: Manager provides override reason text. Asset unblocked from publish-ready path. Override logged as audit event.
- Result: Asset proceeds with drift warning badge retained + "Overridden by [Manager]" label

### A4: Character Archival
- Trigger: User needs to free up a character slot
- Steps: User archives character → status = 'archived'. Can be un-archived if slots available. After 30 days, archived characters are eligible for hard delete.
- Result: Character removed from active library, slot freed

## Edge Cases

### EC-M08-001: Digital Twin Consent Face Mismatch
- Condition: Source footage shows person A, consent video recorded by person B
- Expected behavior: AI face match fails. System shows: "The face in your consent video doesn't match the source footage. Please re-record the consent video with the same person shown in the source footage." Character creation blocked at consent step. No data retained from failed attempt.
- Reference: Pack 04 §12B.7, EU AI Act compliance

### EC-M08-002: Character Quota Exceeded During Creation
- Condition: Free tier user with 1 character tries to create a second character
- Expected behavior: System blocks at Step 1 with message: "You've reached the character limit for your plan (1/1). [Upgrade Plan] or [Archive existing character] to create a new one." Upgrade CTA links to billing. Archive CTA navigates to character library with archive option highlighted.
- Reference: RULE-M08-003, Pack 04 §12B.4

### EC-M08-003: High Drift on Published Content
- Condition: Asset passes low drift during generation, but a subsequent Character Pack update reveals that older assets now have moderate/high drift relative to the new canonical reference
- Expected behavior: System does NOT retroactively flag or un-publish existing assets. Drift detection is point-in-time (evaluated at generation). Only new generations use updated canonical references. Historical assets retain their original drift evaluation. User can manually re-evaluate if needed.
- Reference: Pack 04 §5.2 (versioned packs)

### EC-M08-004: Voice Clone Provider Unavailable
- Condition: ElevenLabs API is down during voice clone creation
- Expected behavior: Character creation wizard allows proceeding without voice clone — voice section shows "Voice clone temporarily unavailable. [Skip] or [Retry later]." Character saved as `voice_type = 'none'` or `'ai_preset'`. Voice clone can be attached later via character edit.
- Reference: Pack 04 §2.2 (provider failover), API-H-001 blocker

## State Machine

### Character Lifecycle

Object: character | DB column: `characters.status`
see [04_contracts/database_schema.md#7.1](../04_contracts/database_schema.md)

| From | To | Trigger | Condition |
|---|---|---|---|
| — | creating | Wizard started | Type selected |
| creating | ready | Wizard completed + saved | All required fields populated; if digital_twin, `consent_verified = true` |
| creating | failed | Provider error during generation | AI generation fails |
| failed | creating | User retries | Retry attempt |
| ready | archived | User archives | Slot freed |
| archived | ready | User un-archives | Slot available |
| archived | (hard deleted) | 30-day cleanup | Auto after 30 days in archived state |

### Continuity Pack Lifecycle

Object: continuity_pack | DB column: `continuity_packs.status`
see [04_contracts/database_schema.md#7.2](../04_contracts/database_schema.md)

| From | To | Trigger | Condition |
|---|---|---|---|
| — | draft | Pack created | Auto-created with character or manual |
| draft | active | Pack activated | References populated |
| active | deprecated | Newer version activated | Version N+1 created |
| deprecated | retired | Manual or auto after 90 days | No longer referenceable |

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../04_contracts/database_schema.md) | §7.1 (characters), §7.2 (continuity_packs), §7.3 (assets — drift fields) |
| API | [04_contracts/api_endpoint_map.md](../04_contracts/api_endpoint_map.md) | §2.3 (CharacterService: Create, List, Update; ContinuityService: GetPack, UpdatePack) |
| Events | [04_contracts/domain_event_catalog.md](../04_contracts/domain_event_catalog.md) | §5 (character.created, continuity.violation_detected, continuity.pack_updated) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../04_contracts/rbac_permission_matrix.md) | §2.3 (character:create — Editor+; pack:update — Manager+) |
| Pack 04 | [Design Pack 04 — AI/Media/Continuity](../creativanta_detail_design_pack_04_ai_media_continuity_contract_v_3_1.md) | §5 (Continuity Contract), §12A (Character UX), §12B (Character Business Logic) |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | Character Library | Grid of character cards, quota indicator, CRUD actions |
| Web | Character Creation Wizard (4 steps) | Type → Profile → Preview → Save |
| Web | Continuity Pack detail | Pack versions, approved references, drift history |
| Mobile | Character library (list view) | Simplified cards, long-press for actions |
| Mobile | Character creation wizard | Bottom sheet per step |
| Mobile | Character selector (bottom sheet) | Selection before generation |

## Acceptance Criteria

1. **Given** a user starts the Character Creation Wizard, **when** they reach Step 3 (Preview), **then** the system MUST generate a 15-second test video using the character's visual and voice settings — and the user MUST be able to go back to Step 2 to adjust before proceeding to Step 4.

2. **Given** a user selects "Digital Twin" as character type, **when** the consent flow runs and the AI face match between source footage and consent video fails, **then** the system MUST block character creation with a clear explanation — no character data is persisted and the user is prompted to re-record.

3. **Given** a Free-tier user with 1 existing character, **when** they attempt to create a second character, **then** the system MUST block creation and display: "Character limit reached (1/1). [Upgrade] or [Archive existing]" — no partial creation occurs.

4. **Given** a generated asset with `drift_severity = 'high'`, **when** the asset is evaluated by the continuity QA service, **then** the asset MUST be blocked from the publish-ready path — only a Manager+ with explicit override reason can unblock it.

5. **Given** a user creates a new character and saves it, **when** the character is stored, **then** the system MUST auto-create a corresponding Character Pack (`continuity_packs.pack_type = 'character'`) and store the `character_pack_id` FK on the character — the `character.created` event MUST be emitted.

## Open Questions / Blockers

- **API-H-001** (OPEN_BLOCKERS.md): `VoiceCloneService` has no protobuf service definition. Voice clone creation is blocked until this service is defined. Related events use inconsistent namespace (`gamification.voice_clone.*` should be `production.voice_clone.*` or `continuity.voice_clone.*`). Impact: Voice clone feature in the Character Builder Step 2 cannot be fully implemented. Workaround: allow character creation without voice clone; attach voice later when service is defined.
