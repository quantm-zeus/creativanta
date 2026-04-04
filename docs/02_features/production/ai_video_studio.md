---
layer: features
module: M07
canonical: true
domain: production
status: READY
last_updated: 2026-03-30
---

# Feature: AI Video Studio (M07)

## Purpose

Content creators today juggle 5-10 separate tools (CapCut for editing, Opus Clip for clipping, separate AI generators for video/image/voice, manual subtitle tools, etc.) — each with its own UI, login, credit system, and no shared context. The result is fragmented, slow, and impossible to maintain brand/character consistency across outputs.

M07 exists as the **unified AI production engine** that orchestrates multi-provider AI generation, editing, clipping, remixing, and post-production — all within one system that shares continuity packs (M08), trend data (M02/M03), and feeds directly into packaging (M10) and publishing (M11). M07 **produces** assets; it does NOT manage their lifecycle after production (that's M09).

## Scope

### Covers (M07 owns production)
- Smart Pipeline Router: 4 pipeline strategies (Native Audio, Audio-First, Post-Prod Lip-Sync, Voice-Over)
- 4 Core Production Modes: Quick Edit (1→1), Clip Factory (1→N), Multi-Merge (N→1), AI Remix Studio (ref→new)
- 11 Extended Features: Product Showcase, Image-to-Video, Thumbnail Studio, Link-to-Video, Translation Studio, AI Sound Studio, Style Learning, Video Agent, Performance Coach, Video A/B Testing, Creator Gamification
- Generation job lifecycle (queued → processing → completed/failed/cancelled)
- Provider routing, failover, circuit breaker (ADR-010)
- Post-production mix (rust-ffmpeg: normalize, ducking, subtitles, aspect ratio)
- Lip-sync orchestration (SyncLabs / Wav2Lip)
- Cost estimation and credit tracking
- BYOK (Bring Your Own API Key) support
- Prompt assembly with continuity pack resolution (M08)

### Does NOT cover (M07 vs M09 boundary)
- **M09 owns**: derivative library browsing, organizing, tagging, collections, lineage inspector, repurpose recommendations, derivative performance tracking
- M07 **creates** clips/variants/remixes → emits events → M09 **manages** their lifecycle
- Packaging and QA scoring (owned by M10)
- Publishing and scheduling (owned by M11)
- Character/pack management (owned by M08)

## Actors

| Actor | Role | Primary Actions |
|---|---|---|
| Creator | Editor+ | Trigger generation, select modes, configure options, review outputs, approve/reject |
| Manager | Manager+ | Approve assets, promote canonical, override QA blocks |
| System (Router) | System | Select provider, choose pipeline strategy, failover, circuit break |
| System (QA) | System | Run post-production checks, compliance scan, drift detection (via M08) |

## Business Rules

1. **RULE-M07-001**: Every generated asset MUST carry full lineage: `source_provider`, `source_model`, `generation_prompt`, `continuity_pack_ids`, `generation_cost_credits`, and `generation_cost_usd`. Assets without lineage are invalid (PRD §23.7 AC, Pack 04 §6).
2. **RULE-M07-002**: Generation failure MUST produce a usable explanation via `generation_jobs.error_message` + `error_code`, and auto-fallback to secondary provider if available. Fallback does NOT change the lineage provider — the new attempt creates a new `generation_jobs` row (Pack 04 §11, ai_provider_guide §7).
3. **RULE-M07-003**: AI Remix output MUST pass originality check: script similarity < 30% vs reference original. If similarity ≥ 30%, the remix is blocked with "Output too similar to reference. [Adjust settings] or [Try 'Loose inspiration' fidelity]." NO footage or audio from the reference is used — only analysis data (Pack 04 §9.5.6).
4. **RULE-M07-004**: Clip Factory Virality Score MUST use live data from Trend Engine (M02/M03) for the Content Relevance component (10% weight). Scores computed without trend data MUST be flagged: "Score based on pattern only — trend data unavailable." This is a competitive differentiator (Pack 04 §9.3.3).
5. **RULE-M07-005**: All video output MUST pass through post-production mix: audio normalization (-14 LUFS target), aspect ratio compliance, subtitle overlay if enabled. Output that skips post-production is non-compliant (Pack 04 §2.4).
6. **RULE-M07-006**: Generation cost MUST be estimated and shown to the user BEFORE triggering generation. User MUST confirm the estimated credit cost. Actual cost is reconciled after completion (PRD §23.7 AC, ai_provider_guide §2.3).
7. **RULE-M07-007**: `generation_jobs.status` and `assets.generation_state` MUST be updated atomically. `assets.generation_state` is derived from the most recent `generation_jobs.status` — they are NOT independent (DB schema §7.4 State Sync Rule).
8. **RULE-M07-008**: Multi-Merge compliance scan MUST pass before export. Blocked results cannot proceed to M10/M11 without explicit Manager+ override with reason (Pack 04 §9.4, Pack 04 §8.3).

---

## Smart Pipeline Router

The system auto-selects the optimal pipeline based on character type, voice settings, and content type:

| Strategy | Flow | When | Lip-Sync |
|---|---|---|---|
| **1. Native Audio** | Script → Veo 3.1/Kling 3.0 → Video+Audio | Default, no voice clone needed | Built-in |
| **2. Audio-First** | Script → ElevenLabs TTS → HeyGen/Kling (audio-driven) → ffmpeg mix | Digital Twin / voice clone | Provider-native |
| **3. Post-Prod Lip-Sync** | Script → [Video gen ∥ TTS gen] → SyncLabs lip-sync → ffmpeg mix | Dubbing / multi-language | SyncLabs / Wav2Lip |
| **4. Simple Voice-Over** | Video gen → TTS → ffmpeg overlay | B-roll / product showcase (no talking head) | N/A |

Reference: Pack 04 §2.3 <!-- Legacy ref: creativanta_detail_design_pack_04_ai_media_continuity_contract_v_3_1.md — superseded by current feature docs + contract layer -->

---

## Core Production Modes

### Mode 1: Quick Edit (1→1)

**Input**: 1 uploaded video → **Output**: 1 improved video

**Key Capabilities**:
- **Text-based editing**: Whisper ASR → transcript → user deletes text = deletes video segment → ffmpeg execute
- **Animated captions**: Trending styles (karaoke, bounce, highlight) via Revideo/ffmpeg drawtext
- **Active speaker detection**: Auto-reframe to active speaker (mediapipe face mesh)
- **Beat-sync music**: Librosa BPM detection → auto-cut on beat
- **AI B-roll generation**: Contextual B-roll via Flux 2/Veo (replaces stock footage)
- **Platform presets**: TikTok/YouTube/Reels pace optimization
- **Smart Hook Library**: 50+ hooks across 6 categories (Question, Shock, Story, Listicle, Contrast, POV)
- **Copyright-safe audio**: ACRCloud fingerprint scan → royalty-free alternatives

**Edge Case (EC-M07-Q01)**: ASR produces poor transcript for non-standard accent/dialect → user edits transcript manually → system re-aligns segments. If alignment fails, show "Auto-alignment failed. [Try segment mode] or [Manual cut]."

### Mode 2: Clip Factory (1→N)

**Input**: 1 long video (3-60min) → **Output**: 5-20 short clips

**Pipeline**: Scene detection → ASR transcription → Key moment ID (LLM) → Clip boundary proposal → Virality Score → Clip review board → Batch process → Export

**Virality Score Algorithm (0-100)**:
```
Score = Engagement Pattern Match (30%)   ← from Trend Engine M02/M03
      + Hook Strength (25%)              ← first 3s analysis
      + Pacing Score (20%)               ← cuts/sec, energy curve
      + Audio Quality (15%)              ← clarity, noise, music fit
      + Content Relevance (10%)          ← topic trend score from M02/M03
```
**Rule**: Virality Score MUST use real trend data. Scores without trend data carry "⚠️ Pattern-only" badge.

**Clip outputs**: standalone clip, subtitle-first version, ratio variants (9:16/16:9/1:1), CTA variant, highlight reel

**Edge Case (EC-M07-C01)**: Video has no speech (music-only content) → ASR returns empty → system falls back to visual-only scene detection + beat analysis. Clips still get Virality Score but Hook Strength uses visual hook pattern instead of speech analysis.

### Mode 3: Multi-Merge (N→1)

**Input**: N videos/images → **Output**: 1 complete video

**Max inputs**: Free 5, Starter 10, Pro 20, Business 50

**Pipeline**: Drag-reorder media → Target duration → AI auto-transitions → Voice-over options (AI/upload/record/none) → Background music (AI-select/library/upload/none, copyright check) → Timeline preview → ffmpeg render → Export

**Auto-transition rules**: Image→Image: Ken Burns + 0.5-1s; Video→Video: crossfade 0.3-0.5s; Image→Video: fade-in 0.5s; Beat-sync override if music selected.

**Edge Case (EC-M07-M01)**: User uploads copyrighted music → ACRCloud detects → show "⚠️ Music detected as copyrighted: [Song Name]. [Replace with royalty-free] or [Proceed at risk]." If user proceeds, compliance flag set on output.

### Mode 4: AI Remix Studio (ref→new)

**Input**: 1 reference video (URL/upload) → **Output**: 1 entirely new video with same creative DNA

**Phase 1 — Analyze** (Creative DNA Extraction):
8-layer analysis: scene detection, script extraction (ASR), hook pattern, pacing/rhythm, visual style, audio profile, engagement structure, transition map → outputs **Creative DNA Blueprint** (JSON)

**Phase 2 — Remix** (Content Recreation):
LLM rewrites script using: Creative DNA structure + user's topic + Brand Pack + Character Pack. Visual generation per reference type (talking head → HeyGen; B-roll → Veo/Kling; text-heavy → Revideo). Assembly matches pacing profile.

**Phase 3 — Polish**:
Side-by-side preview (original vs remix), per-scene editing, compliance scan, Virality Score, platform optimization, schedule publish

**Fidelity Levels**: Match 1:1 | Adapt (default) | Loose inspiration

**Legal Safeguards**:
| Rule | Implementation |
|---|---|
| Script similarity < 30% | LLM text similarity check — block if exceeded |
| No footage reuse | Only analysis data passed to generation |
| No audio reuse | Always generate new voice + music |
| Originality score | Block if > 70% transcript similarity |
| Abuse detection | Max 20 remixes/day/workspace rate limit |

**Edge Case (EC-M07-R01)**: Reference video URL is geo-blocked or DRM-protected → download fails → show "Cannot access video at this URL. [Upload video file instead] or [Try different URL]." No partial analysis occurs.

---

## Extended Features (11)

### EF-01: AI Product Showcase Studio (Photos → Product Video)
- Upload 1-10 product images → AI removes background → generates video in selected style
- **8 styles**: 360° Spin, Tabletop Demo, Flip & Reveal, Virtual Try-On, Lifestyle Context, Unboxing Simulation, Before/After, Review Style
- Product Hub (M13) auto-fills product data; batch mode supports 20 products
- Credits: 8-40 per video depending on style

### EF-02: Image-to-Video Converter (Photo → Video)
- 6 motion styles: Cinematic Pan, Product Rotate, Parallax 3D, Subtle Movement, Zoom In, Custom Prompt
- Duration: 3-15s, loop-friendly option, auto music sync
- Provider: Veo 3.1 / Kling 3.0 image-to-video API
- Credits: 5-15 per generation

### EF-03: AI Thumbnail Studio
- Auto-extract best frame + enhance, generate from prompt, 50+ template styles
- A/B thumbnail testing: create 2-3 variants → auto-pick winner by CTR (via M10 Experiment Lab)
- Brand consistency: Brand Pack fonts/colors/logo auto-applied
- Credits: 3-8 per thumbnail

### EF-04: Link-to-Video Generator (Product URL → Video Ad)
- Paste URL (Shopee/Lazada/TikTok Shop/Amazon/Shopify) → AI crawls product data → auto-generates video ad
- 5 script templates: Problem-Solution, Listicle Review, Testimonial, Flash Sale, Comparison
- Credits: 20-45 per video

### EF-05: AI Translation & Localization Studio
- Pipeline: Whisper ASR → LLM translate → ElevenLabs voice clone → SyncLabs lip-sync → subtitles
- Languages (v1): Vietnamese ↔ English, Thai, Indonesian, Filipino, Japanese, Korean, Mandarin, Spanish
- Integration: Trend Engine ("hot in Thailand → translate to Thai?") + Publish Hub auto-schedule
- Credits: 15-40 per language version

### EF-06: AI Sound Studio ✅ [RESOLVED: API-H-002]
- AI Music Generator (mood → copyright-free BGM), beat-drop sync, speech-to-song
- AI Sound Effects (scene description → contextual SFX), multi-lang voice clone
- Podcast → short clips conversion
- **Previously blocked**: `SoundStudioService` now defined — see `api_endpoint_map.md` §2.8.10 (6 RPCs). Resolved 2026-04-02.
- Credits: 3-25 per operation

### EF-07: AI Style Learning & Transfer
- Upload video with desirable style → AI extracts: caption style, color grade, transition timing, pacing, text overlay, audio mix
- Save as "Style Pack" → integrates with Continuity OS (M08) alongside Brand Pack / Character Pack
- Future: Style Pack Marketplace (community share/sell)
- Credits: 10-20 per style extraction

### EF-08: AI Video Agent (1-Click Pipeline)
- User describes idea in 1 sentence → Agent orchestrates full pipeline → video ready to publish
- Auto: script gen → visual gen → voice-over → music → captions → thumbnail → Virality Score
- Context-aware: reads Brand Pack, Character Pack, Trend Engine data, past performance
- Credits: 30-80 per video

### EF-09: AI Performance Coach ✅ [RESOLVED: API-C-001]
- Post-publish analysis (24h): hook effectiveness, retention rate, engagement comparison
- Weekly report card: best/worst content, format analysis, improvement suggestions
- Proactive coaching: format recommendations, trending sound suggestions, competitor benchmarks
- **Previously blocked**: `PerformanceCoachService` now defined — see `api_endpoint_map.md` §2.8.8 (5 RPCs). Resolved 2026-04-02.
- Credits: 0 (included in plan)

### EF-10: Video A/B Testing Engine
- AI generates variations (hook, CTA, thumbnail, music) → publish all → monitor 24-72h → auto-report winner
- Auto-scale winner (re-schedule to more platforms)
- Uses M10 Experiment Lab for variant tracking
- Credits: 5-15 per variant

### EF-11: Creator Gamification System
- Creator Level (1-50), XP per action, daily streak, weekly quests, achievements
- Streak rewards: 7-day = +50 credits, 30-day = +200 credits
- XP calculation: event-driven (video.published → +5 XP, clip.viral.10k → +20 XP)
- Level thresholds: L1=0, L5=100, L10=500, L20=2000, L50=25000

---

## State Machine

Object: generation_job | DB column: `generation_jobs.status`
see [04_contracts/database_schema.md#7.4](../../04_contracts/database_schema.md)

| From | To | Trigger | Condition |
|---|---|---|---|
| — | queued | Generation request created | Valid request + credit check passed + cost estimate confirmed |
| queued | processing | Worker picks up job | Worker available, provider healthy |
| processing | completed | Provider returns success | Output passes post-production checks |
| processing | failed | Provider error or post-prod failure | `error_code` + `error_message` populated |
| queued/processing | cancelled | User cancels or system timeout | Before completion |
| failed | queued | Auto-retry | `retry_count < max_retries` (default 3) |

**Sync Rule**: When `generation_jobs.status` changes → `assets.generation_state` MUST update atomically:
- job completed → asset `generated`
- job failed (all retries exhausted) → asset `failed`
- job cancelled → asset `cancelled`

## Edge Cases

### EC-M07-001: Provider Circuit Breaker During Active Job
- Condition: Veo 3.1 circuit breaks mid-generation (3 consecutive failures within 300s)
- Expected behavior: Current job marked `failed` with `error_code = 'circuit_breaker'`. System auto-queues retry with fallback provider (Kling 3.0). New `generation_jobs` row created with `provider = 'kling'`. User notified: "Primary provider temporarily unavailable. Retrying with alternative provider." Lineage correctly tracks the provider switch.
- Reference: ai_provider_guide §7, Pack 04 §2.2

### EC-M07-002: Cost Estimation Exceeds User Credit Balance
- Condition: User triggers a Video Agent pipeline (EF-08) with estimated 60 credits, but balance is 45 credits
- Expected behavior: System blocks generation at confirmation step: "Insufficient credits. Estimated cost: 60 credits. Your balance: 45 credits. [Add credits] [Simplify options to reduce cost]." No job created, no credits deducted.
- Reference: RULE-M07-006, ai_provider_guide §2.3

### EC-M07-003: Remix Originality Check Fails
- Condition: AI Remix produces output with 45% script similarity to reference (exceeds 30% threshold)
- Expected behavior: System blocks output with: "Remix is too similar to the reference (45% similarity, max 30%). [Adjust to 'Loose Inspiration' fidelity] or [Edit script manually]." Asset marked `quality_state = 'blocked'`. User can edit the generated script and re-attempt.
- Reference: RULE-M07-003, Pack 04 §9.5.6

### EC-M07-004: Concurrent Clip Factory Processing Limit
- Condition: User triggers Clip Factory on a 60-minute video while another Clip Factory job is already processing for the same workspace
- Expected behavior: System allows concurrent processing up to workspace tier limit (Free: 1 concurrent, Starter: 2, Pro: 5, Business: 10). Beyond limit → job queued with message: "Processing queue full. Your job will start when a current job completes. Position: [N]."
- Reference: Pack 04 §9.3

## Related Contracts

| Topic | File | Section |
|---|---|---|
| DB tables | [04_contracts/database_schema.md](../../04_contracts/database_schema.md) | §7.3 (assets), §7.4 (generation_jobs), §7.5 (continuity_violations) |
| API | [04_contracts/api_endpoint_map.md](../../04_contracts/api_endpoint_map.md) | §2.3 (AssetService: Generate, GetStatus, List, Approve, PromoteCanonical) |
| Events | [04_contracts/domain_event_catalog.md](../../04_contracts/domain_event_catalog.md) | §5 (asset.generation_started/completed/failed, asset.approved, clip.extracted, remix.completed) |
| RBAC | [04_contracts/rbac_permission_matrix.md](../../04_contracts/rbac_permission_matrix.md) | §2.4 (asset:generate — Editor+; asset:approve — Manager+) |
| Pack 04 | Design Pack 04 <!-- Legacy ref: creativanta_detail_design_pack_04_ai_media_continuity_contract_v_3_1.md — superseded by current feature docs + contract layer --> | §2-11 (Pipeline, Modes, Cost, Diagnostics) |
| Provider Guide | [05_system/ai_provider_guide.md](../../05_system/ai_provider_guide.md) | §1-8 (Providers, routing, credits, errors) |

## Related Screens

| Platform | Screen | Notes |
|---|---|---|
| Web | AI Video Studio (mode selection + workspace) | Mode picker, generation dashboard, job queue |
| Web | Quick Edit workspace | Video player + transcript editor + effects panel |
| Web | Clip Factory review board | Clip cards sorted by Virality Score, bulk select/export |
| Web | AI Remix Studio (3-phase wizard) | Analyze → Remix → Polish, side-by-side preview |
| Web | Product Showcase configurator | Photo upload + style selection + options panel |
| Mobile | Generation dashboard (progress, approve, retry) | Simplified mode picker, job status cards |
| Mobile | Clip review (swipe cards) | Swipe to approve/reject, bulk export CTA |

## Acceptance Criteria

1. **Given** a user triggers video generation with estimated cost of 15 credits, **when** the confirmation dialog appears, **then** it MUST show "Estimated cost: 15 credits. Your balance: [N] credits. [Generate] [Cancel]" — and the system MUST NOT start the job until the user confirms.

2. **Given** Veo 3.1 fails 3 times in 5 minutes, **when** the circuit breaker activates, **then** the system MUST auto-retry the failed job with Kling 3.0 (fallback provider) — the new job row MUST have `provider = 'kling'` and the original job MUST have `error_code = 'circuit_breaker'`.

3. **Given** Clip Factory processes a 30-minute video, **when** clips are scored, **then** the Virality Score for each clip MUST include a Content Relevance component (10% weight) sourced from Trend Engine (M02/M03) — if trend data is unavailable, the score MUST carry a "⚠️ Pattern-only" badge.

4. **Given** AI Remix produces output with 35% script similarity to the reference, **when** the originality check runs, **then** the system MUST block the output with a clear message explaining the threshold (< 30%) and offer actionable alternatives (change fidelity level or edit script).

5. **Given** a completed generation job, **when** the asset passes post-production mix, **then** the asset MUST have: audio normalized to -14 LUFS, correct aspect ratio, subtitle overlay (if enabled), and full lineage in `lineage_refs` JSONB.

## Blockers (All Resolved)

> All M07 blockers resolved as of 2026-04-02. See `00_index/OPEN_BLOCKERS.md` for resolution details.

| Blocker ID | Severity | Impact on M07 | Status | Resolution |
|---|---|---|---|---|
| **API-C-001** | CRITICAL | Performance Coach (EF-09) lacked `PerformanceCoachService` proto definition | ✅ RESOLVED (2026-04-02) | `PerformanceCoachService` defined in `api_endpoint_map.md` §2.8.8 (5 RPCs) |
| **API-H-001** | HIGH | Voice clone (M08 dependency) lacked `VoiceCloneService` definition | ✅ RESOLVED (2026-04-02) | `VoiceCloneService` defined in `api_endpoint_map.md` §2.8.9 (6 RPCs) |
| **API-H-002** | HIGH | AI Sound Studio (EF-06) lacked `SoundStudioService` proto definition | ✅ RESOLVED (2026-04-02) | `SoundStudioService` defined in `api_endpoint_map.md` §2.8.10 (6 RPCs) |

## Open Questions

- Voice clone event namespace: PRD uses `gamification.voice_clone.*` but logical namespace is `production.voice_clone.*` or `continuity.voice_clone.*`. EVT-H-001 (event naming convention) has been resolved with CamelCase→dot.notation mapping tables in `runtime_workflow.md` §3.1B/§3.1C, but the specific namespace assignment for voice clone events still needs confirmation in `domain_event_catalog.md`.
