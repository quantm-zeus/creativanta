---
layer: system
canonical: true
source_file: creativanta_detail_design_pack_04_ai_media_continuity_contract_v_3_1.md
last_verified: 2026-03-30
purpose: AI media runtime architecture, generation/prompt/continuity/lineage contracts, video production modes, and character builder
---

# Creativanta — Detail Design Pack 04 — AI / Media / Continuity Contract v3.1

## 0. Traceability Header

- **Upstream sections used**: Product Freeze sections 10–17, 23, 35–37, 39–46.
- **Canonical objects touched**: Script, Asset Brief, Asset, Character Pack, Brand Pack, Voice Pack, Scene Memory, Lookbook, Approved Reference, Prompt Lineage Record, Continuity Rule, Continuity Violation, Evidence Object, Cost Item.
- **State machines touched**: Script lifecycle/approval, Asset generation/approval.
- **Read / write ownership respected**: media services chỉ ghi canonical assets, lineage và continuity records qua media/continuity owners; không overwrite historical truth.
- **Acceptance scenarios inherited**: provider routing, continuity preservation, drift detection, lineage inspection, quality approval, repurpose/clip production, cost attribution.
- **See also**: S26 §6.4 (AI Cost Control Panel) — admin-side AI cost tracking, provider health monitoring, circuit breaker status, margin analysis.

## 1. Mục tiêu

Pack này khóa cách triển khai:
- AI generation
- media orchestration
- continuity packs
- prompt lineage
- QA / drift detection
- repurpose / clip factory

## 2. Runtime Architecture

### 2.1 Core Services
- generation request service
- provider routing service
- prompt assembly service
- continuity resolver
- lineage recorder
- media job orchestrator
- QA / drift evaluation service
- asset registry

### 2.2 Provider Model — Multi-Provider Stack (ADR-010)

Provider có thể là:
- **AI Video Generation**: Veo 3.1 (primary), Kling 3.0 (secondary), Runway Gen-4 (fallback)
- **AI Image Generation**: Flux 2 Pro (primary), GPT Image (secondary), SDXL (budget)
- **TTS / Voice**: ElevenLabs (primary + clone), Google Cloud TTS (budget), OpenAI TTS (fallback)
- **Lip-Sync**: SyncLabs / Sync.so (primary), Wav2Lip via Replicate (budget)
- **AI Avatar**: HeyGen (primary), D-ID (secondary)
- **Music / SFX**: Royalty-free library (Pixabay/Pexels), Suno (via third-party API)
- **Video Processing**: rust-ffmpeg (local), Revideo (template video)
- BYOK provider (user's own API key)

Provider specifics không được rò lên canonical object model.

> **⚡ Future-Proofing Note**: Provider versions listed above (Veo 3.1, Kling 3.0, Runway Gen-4, Flux 2, ElevenLabs, etc.) are current as of document date. The multi-provider adapter pattern (ADR-003, ADR-010) allows version upgrades and new provider additions without contract changes. When a new model version releases, only the provider routing config and cost tables need updating — no changes to canonical objects, state machines, or upstream contracts.

### 2.3 Video Production Pipeline — Smart Pipeline Router

System tự động chọn pipeline tối ưu dựa trên character type, voice settings, và content type:

#### Strategy 1: Native Audio (90% use cases)
```
Script → Veo 3.1 / Kling 3.0 → Video + Audio (đã sync sẵn) ✅
```
- Khi: User muốn "1-click generate", không cần voice clone
- Lip-sync: Built-in trong model

#### Strategy 2: Audio-First Pipeline (Digital Twin / voice clone)
```
Script → ElevenLabs TTS (cloned voice) → Audio (.wav)
    → HeyGen/Kling (audio-driven video + lip-sync)
    → rust-ffmpeg (merge + background music + SFX)
    → Final output ✅
```
- Khi: User cần giọng clone (Digital Twin) hoặc chất lượng voice cao
- Voice: ElevenLabs (Vietnamese, clone, biểu cảm)

#### Strategy 3: Post-Production Lip-Sync (dubbing / multi-language)
```
[Song song]
├─ Video gen (bất kỳ provider, không audio)
└─ ElevenLabs TTS → Audio
          ↓
   SyncLabs Lip-Sync (video + audio → synced video)
          ↓
   rust-ffmpeg → Final mix (music + SFX + subtitles) → Output ✅
```
- Khi: Provider không có native audio, hoặc dubbing sang ngôn ngữ khác
- Lip-sync: SyncLabs (Sync.so) API — zero-shot, multi-language
- Fallback: Wav2Lip via Replicate

#### Strategy 4: Simple Voice-Over (B-roll / product showcase)
```
Video gen (bất kỳ) + TTS voice-over → rust-ffmpeg overlay → Output ✅
```
- Khi: Không có talking head, chỉ narration trên hình ảnh
- Không cần lip-sync — chỉ merge audio track

### 2.4 Post-Production Mix Contract (rust-ffmpeg)

Mọi video output phải đi qua post-production step:
- Merge audio tracks (voice + music + SFX)
- Audio ducking (hạ volume nhạc khi có giọng nói)
- Normalize audio levels (-14 LUFS target)
- Add subtitles/captions overlay (nếu enabled)
- Apply aspect ratio transform (9:16 / 16:9 / 1:1)
- Encode final output (H.264/H.265, target bitrate per quality tier)
- Extract best frame → generate thumbnail

### 2.5 Lip-Sync Contract

| Provider | Method | Quality | Cost/s video | Use case |
|---|---|---|---|---|
| **SyncLabs (Sync.so)** | Zero-shot, multi-language, style preservation | ⭐⭐⭐⭐⭐ | ~$0.05-0.20 | Post-production, dubbing |
| **Wav2Lip** (via Replicate) | Open-source, face lower-half replacement | ⭐⭐⭐⭐ | ~$0.01-0.05 | Budget fallback |
| **Built-in** (Veo 3.1, Kling 3.0) | Native in video model | ⭐⭐⭐⭐ | Included | Native audio strategy |

Rule: Lip-sync output phải qua QA/drift check (§8) so với canonical character visual.

## 3. Generation Request Contract

Mọi generation request phải có:
- request_id
- initiating object refs (script, asset brief, continuity pack, etc.)
- target asset type
- provider route
- constraints
- cost estimation context
- user or system actor
- capability / permission context

## 4. Prompt Assembly Contract

### 4.1 Inputs
- script content
- asset brief
- continuity packs
- approved references
- policy/disclosure constraints
- platform intent if relevant

### 4.2 Output
Prompt assembly output phải tạo:
- prompt package version
- included refs summary
- omitted refs summary if any
- provenance/lineage token

## 5. Continuity Contract

### 5.1 Continuity Packs
Các pack gồm:
- Character (**NEW** — user-facing character builder entity, auto-creates Character Pack)
- Character Pack
- Brand Pack
- Voice Pack
- Scene Memory
- Lookbook / Approved References

### 5.2 Rules
- continuity pack phải versioned
- approved reference là first-class ref, không phải ghi chú text tự do
- drift detection phải so current output với canonical references

### 5.3 Drift Severity
- none
- low drift
- moderate drift
- high drift

Moderate và high drift phải sinh warning hoặc block tùy rule set.

### 5.4 Supporting Continuity Records
Family contract này áp dụng cho: Scene Memory, Lookbook, Approved Reference, Prompt Lineage Record, Continuity Rule, Continuity Violation.

Bắt buộc có:
- canonical id theo subtype
- parent pack/asset/script ref
- source/provenance context
- current status hoặc severity
- related objects/evidence refs khi áp dụng
- version/timestamp context

## 6. Lineage Contract

### 6.1 Mandatory Lineage For
- generated assets
- repurposed assets
- derivatives
- continuity-promoted canonical assets

### 6.2 Lineage Must Capture
- source asset or brief
- provider route
- prompt package version
- continuity refs used
- generation timestamps
- output asset refs

## 7. Asset Job Lifecycle

### 7.1 Generation States
- queued
- generating
- generated
- failed
- cancelled

### 7.2 Approval States
- review_required
- approved
- rejected
- promoted_canonical

### 7.3 Rule
Generation state và approval state là 2 state machines riêng.

## 8. QA / Drift / Safety Contract

### 8.1 QA Checks
- technical output validation
- continuity drift check
- brand rule check
- disclosure/overlay requirement check where relevant
- output completeness check

### 8.2 Result Classes
- pass
- pass_with_warning
- review_required
- blocked

### 8.3 Rule
Blocked outputs không được đưa sang publish-ready path mà không có explicit override + reason.

## 9. Video Production Modes Contract

> **Ref**: PRD M07 (AI Video Studio). Pack này khóa 4 core production modes + 11 extended features ngoài core AI generation.

### 9.1 Mode Overview

| Mode | Input | Output | Core Tech |
|---|---|---|---|
| **🎨 Quick Edit** | 1 video upload | 1 video đã chỉnh | ASR + FFmpeg + LLM |
| **✂️ Clip Factory** | 1 video dài (3-60min) | 5-20 clips ngắn | Scene detection + Virality Score |
| **🔀 Multi-Merge** | N videos/ảnh | 1 video hoàn chỉnh | FFmpeg concat + transitions |
| **🔄 AI Remix Studio** | 1 video reference (URL/upload) | 1 video mới (similar DNA) | 8-layer analysis + LLM + gen |

### 9.2 Quick Edit Contract (1→1)

#### 9.2.1 Enhanced Capabilities (bổ sung cho base editing ở Pack 08 §4)

| Capability | Description | Tech | Credit Cost |
|---|---|---|---|
| **Text-based editing** | Hiển thị transcript, user xóa text = xóa video segment | Whisper ASR → timed transcript, FFmpeg segment cut | 5–10 |
| **Animated captions** | Trending caption styles: karaoke, bounce, highlight | Revideo / rust-ffmpeg drawtext | 3–5 |
| **Active speaker detection** | Auto-reframe video theo người đang nói | Google Video Intelligence / mediapipe face mesh | 5–10 |
| **Beat-sync music** | Cắt video beats khớp nhạc tự động | Librosa BPM detection + FFmpeg cut-on-beat | 5–10 |
| **AI B-roll generation** | Gen AI b-roll contextual thay stock footage | Flux 2 / Veo (image/video gen from context) | 10–20 |
| **Platform presets** | Tối ưu pace riêng cho từng platform | LLM-driven cut frequency rules per platform | 3–5 |
| **Smart Hook Library** | 50+ mẫu hook proven viral, 6 categories | LLM hook template matching + overlay gen | 5–10 |
| **Copyright-safe audio** | Auto-scan audio copyright + gợi ý alternatives | Audio fingerprinting (ACRCloud) + royalty-free library match | 3–5 |

#### 9.2.2 Text-Based Editing Flow
```
Upload video → Whisper ASR → timed transcript
    → User edits transcript (delete text = delete segment)
    → AI highlights: filler words, pauses, repetitions
    → User approves cuts → FFmpeg execute → output
```

#### 9.2.3 Smart Hook Library Categories
| Category | Examples | Count |
|---|---|---|
| Question Hook | "Bạn có biết...?", "Tại sao...?" | 10+ |
| Shock/Stat Hook | "90% người không biết...", "Con số này sẽ khiến bạn sốc" | 10+ |
| Story Hook | "Tôi đã thử X trong 30 ngày..." | 8+ |
| Listicle Hook | "3 cách để...", "Top 5..." | 8+ |
| Contrast Hook | "Thay vì X, hãy thử Y", "Before/After" | 7+ |
| POV Hook | "POV: Bạn là...", "Khi bạn..." | 7+ |

### 9.3 Clip Factory Contract (1→N)

#### 9.3.1 Input Types
- Long video asset (3-60 min)
- Live session recording
- YouTube/TikTok URL (via download + transcode)
- Approved asset derivatives

#### 9.3.2 Processing Pipeline
```
Input video → Scene detection (Google Video Intelligence / FFmpeg)
    → Speech transcription (Whisper ASR)
    → Key moment identification (LLM: hook, climax, takeaway)
    → Clip boundary proposal (N clips, configurable length 15-60s)
    → Virality Score per clip
    → Clip review board → User select → Batch process → Export
```

#### 9.3.3 Virality Score Algorithm

```
Virality Score (0-100) = weighted average of:
├─ Engagement Pattern Match (30%)
│   └─ Compare clip structure vs top-performing patterns from Trend Engine (M02/M03)
├─ Hook Strength (25%)
│   └─ First 3 seconds: pattern interrupt? question? shock value? visual hook?
├─ Pacing Score (20%)
│   └─ Cuts/second, energy progression, climax position, scene variety
├─ Audio Quality (15%)
│   └─ Voice clarity, background noise level, music fit, volume consistency
└─ Content Relevance (10%)
    └─ Topic trend score from Trend Intelligence Engine (M02/M03)
```

Rule: Virality Score PHẢI sử dụng data thực từ Trend Engine (M02/M03), không chỉ pattern chung. Đây là lợi thế cạnh tranh so với Opus Clip/Klap.

#### 9.3.4 Clip Outputs
- clip (standalone short video)
- subtitle-first version (bold captions, TikTok format)
- ratio variants (9:16, 16:9, 1:1 per clip)
- CTA variant (overlay CTA at optimal position)
- highlight reel (top 3-5 clips merged)

#### 9.3.5 Rule
Mọi derivative phải link ngược về source asset/live context. Clip lineage: `source_asset_id` + `start_time` + `end_time`.

### 9.4 Multi-Merge Contract (N→1)

#### 9.4.1 Input Types
- Multiple video files (MP4, MOV, WebM)
- Multiple images (JPG, PNG, WebP)
- Mixed video + images
- Max inputs: Free 5, Starter 10, Pro 20, Business 50

#### 9.4.2 Processing Pipeline
```
User drag-reorder media → set target duration
    → AI auto-generate transitions (cut, fade, zoom, swipe)
    → Voice-over options:
    │   ├─ AI voice (select character from Character Pack)
    │   ├─ Upload audio file
    │   ├─ Record directly
    │   └─ None
    → Background music:
    │   ├─ AI auto-select (mood-matched)
    │   ├─ Choose from library
    │   ├─ Upload (copyright check auto)
    │   └─ None
    → Timeline preview → User adjust → rust-ffmpeg render → Export
```

#### 9.4.3 Auto-Transition Rules
- Image → Image: Ken Burns effect (pan/zoom), 0.5-1s transition
- Video → Video: crossfade, 0.3-0.5s
- Image → Video: fade-in, 0.5s
- AI can override with beat-sync transitions if music selected

### 9.5 AI Remix Studio Contract (ref → new video)

#### 9.5.1 Mục tiêu
User upload/paste URL video reference → AI phân tích cấu trúc (Creative DNA) → tạo video HOÀN TOÀN MỚI với nội dung/brand/nhân vật của user, giữ cùng format/style đã proven viral.

**KHÔNG copy footage. KHÔNG copy script. Chỉ HỌC CẤU TRÚC.**

#### 9.5.2 Phase 1 — Analyze (Creative DNA Extraction)

| Analysis Layer | Tech Stack | Output |
|---|---|---|
| Scene Detection | Google Video Intelligence / FFmpeg scene detection | Scene boundaries, count, timestamps |
| Script Extraction | Whisper ASR → timed transcript + speaker diarization | Timed script with speakers |
| Hook Analysis | LLM: analyze first 3 seconds | Hook type + template classification |
| Pacing Analysis | FFmpeg: cut frequency, scene durations, energy curve | Pacing profile per segment |
| Visual Style | Color palette extraction, composition, text overlay detection | Visual style guide |
| Audio Analysis | Music genre, BPM, mood, SFX positions, voice-to-music ratio | Audio profile |
| Engagement Structure | LLM: Hook → Problem → Solution → CTA mapping | Content structure template |
| Transition Detection | Cut type classification (hard cut, fade, zoom, swipe) | Transition map |

Output: **Creative DNA Blueprint** — JSON object chứa tất cả analysis results.

#### 9.5.3 Phase 2 — Remix (Content Recreation)

**Script Rewrite** (quan trọng nhất):
```
LLM Input:
  - Creative DNA Blueprint (structure, hook type, pacing, duration)
  - User's topic/product/niche
  - User's Brand Pack (tone, vocabulary, style)
  - User's Character (personality, speaking tone)

LLM Strategy:
  "Rewrite script keeping EXACT SAME structure but COMPLETELY NEW content.
   Hook type: [from blueprint]. Structure: [from blueprint].
   Pacing: [from blueprint]. Tone: [from Brand Pack].
   Topic: [user's topic]. Length: [match ±5s].
   DO NOT copy any original phrases."
```

**Visual Generation Strategy** (per reference video type):

| Ref Video Type | Remix Strategy | Providers |
|---|---|---|
| Talking head | Gen AI avatar/character nói script mới | HeyGen + Character Pack + Lip-sync |
| B-roll montage | Gen AI B-roll mới + voice-over | Veo/Kling + ElevenLabs |
| Product showcase | User upload product → AI gen showcase shots | Veo/Kling + product photos |
| Text-heavy | AI gen text animations + music | Revideo template engine |
| Mixed format | Combine strategies per-scene | Smart Pipeline Router (§2.3) |

**Assembly**: Match pacing profile from blueprint → rust-ffmpeg render.

#### 9.5.4 Phase 3 — Polish

| Step | Automated? | Description |
|---|---|---|
| Side-by-side preview | ✅ | Original vs remix, synced playback |
| Per-scene editing | Manual + AI assist | User sửa từng scene: text, visual, timing |
| Compliance scan | ✅ Auto | Copyright, content policy, platform rules |
| Virality Score | ✅ Auto | Predicted score based on Trend Engine data |
| Platform optimization | ✅ Auto | Export cho TikTok/Reels/Shorts/LinkedIn |
| Schedule publish | ✅ | Via Publish Queue (M05) |

#### 9.5.5 Remix Fidelity Levels

| Level | Behavior |
|---|---|
| **Match 1:1** | Giữ chính xác structure, hook type, pacing, scene count. Chỉ thay nội dung. |
| **Adapt** (default) | AI tự điều chỉnh structure phù hợp user's topic. Có thể thêm/bớt scenes. |
| **Loose inspiration** | Chỉ lấy hook type + tổng thể format. AI tự do sáng tạo phần còn lại. |

#### 9.5.6 Legal Safeguards

| Safeguard | Rule | Implementation |
|---|---|---|
| Originality Score | Block nếu script similarity > 70% | LLM + text similarity scoring |
| Script Rewrite Check | Output script similarity < 30% vs original | Automated similarity check |
| No Footage Reuse | KHÔNG lấy bất kỳ frame nào từ video gốc | Only analysis data passed to gen |
| Audio Independence | KHÔNG sử dụng audio gốc | Always gen new voice + select new music |
| Copyright Scan | Pre-export compliance scan | Reuse compliance pipeline (§8) |
| Disclosure | Tùy chọn label "AI-assisted content" | Per platform policy |
| Abuse Detection | Max 20 remixes/day/workspace | Rate limiter + flag mass-cloning |

#### 9.5.7 Remix Blueprint Object

```
RemixBlueprint:
  id: UUID
  workspace_id: FK → Workspace
  reference_source: enum(url, upload)
  reference_url: string (nullable)
  reference_asset_id: FK → Asset (nullable, if uploaded)

  # Creative DNA (Phase 1 output)
  scene_count: integer
  total_duration_secs: float
  hook_type: enum(question, shock, story, listicle, contrast, pov, other)
  content_structure: json  # e.g., {"segments": ["hook", "problem", "tip1", "tip2", "tip3", "cta"]}
  pacing_profile: json     # e.g., {"0-3s": "fast", "3-20s": "medium", "20-25s": "fast"}
  visual_style: json       # colors, composition, text overlay patterns
  audio_profile: json      # genre, BPM, mood, voice-to-music ratio
  transition_map: json     # timestamps + cut types
  script_extracted: text   # original transcript (not shared with user for copyright)

  # Remix Config (User input)
  user_topic: text
  character_id: FK → Character (nullable)
  brand_pack_id: FK → Brand Pack (nullable)
  fidelity: enum(match_1to1, adapt, loose_inspiration)
  target_language: string
  target_platforms: string[]  # ["tiktok", "reels", "shorts"]

  # Output
  remix_asset_id: FK → Asset (nullable, after generation)
  script_rewritten: text
  similarity_score: float  # vs original, must be < 0.30
  virality_score: integer  # 0-100
  status: enum(analyzing, analyzed, generating, generated, failed)
  credits_used: integer

  created_at, updated_at: timestamp
```

#### 9.5.8 Trend Engine Integration
- Trend Engine (M02/M03) feed trending videos trong user's niche → hiển thị "🔄 Remix this" button
- User click → auto-fill reference URL → enter AI Remix Studio
- Closed loop: Trend → Remix → Publish → Analytics → Feed back trend data

---

### 9.6 AI Product Showcase Studio (Photos → Product Video)

> **Ref**: PRD M07, Pack 06 (Commerce), ADR-011 | **Input**: 1-10 ảnh sản phẩm | **Output**: 15-60s product video

#### 9.6.1 Concept
User upload ảnh sản phẩm (nền trắng hoặc bất kỳ) → AI tự động remove background → generate video quảng cáo/showcase sản phẩm theo phong cách user chọn, kèm nhạc, voice-over, text overlay, CTA.

#### 9.6.2 Flow

```
Upload 1-10 ảnh         →   AI remove background   →   Chọn style    →   Tùy chỉnh
(drag-drop / camera)        (Flux 2 / rembg)            (8 options)       options
                                                                            ↓
                         ←   Preview & Edit         ←   AI Generate   ←   Confirm
                              (per-scene adjust)         (Veo 3.1 /        (credit
                                                          Kling 3.0)        estimate)
                                                                            ↓
                              Export / Publish                          Schedule
                              (multi-platform)
```

#### 9.6.3 Showcase Styles (8 Phong cách)

| # | Style | Mô tả | Motion | Best for |
|---|---|---|---|---|
| 🔄 **360° Spin** | Sản phẩm xoay 360° smooth, zoom in chi tiết | Rotate full circle, zoom pulse | Giày, túi, đồ điện tử, mỹ phẩm |
| 🪵 **Tabletop Demo** | Sản phẩm đặt trên bàn, tay người đặt/nhấc/xoay, ánh sáng tự nhiên | Place, pick up, rotate, set down | Skincare, food, gadgets, stationery |
| 🔁 **Flip & Reveal** | Sản phẩm lật qua/vuốt/mở hộp, hiển thị mặt trước/sau/bên trong | Flip, swipe, open, close | Sách, wallet, palette, phone case |
| 👔 **Virtual Try-On** | AI model mặc/đeo/cầm sản phẩm, giống review thật | Model wearing/holding, walk, pose | Quần áo, giày, phụ kiện, kính |
| 🏡 **Lifestyle Context** | Sản phẩm đặt trong bối cảnh thực tế (phòng ngủ, bếp, văn phòng, outdoor) | Pan across scene, product glow | Nội thất, decor, đồ gia dụng |
| 📦 **Unboxing Simulation** | Mô phỏng mở hộp: tay mở nắp, lấy sản phẩm ra, reveal | Open lid, tissue pull, reveal product | Gift sets, premium products, electronics |
| ⚡ **Before/After** | So sánh trước/sau sử dụng sản phẩm (split screen hoặc transition) | Wipe transition, side-by-side | Skincare, cleaning, makeover products |
| 🎤 **Review Style** | AI avatar/character review sản phẩm dựa trên product info + user cung cấp, cầm sản phẩm | Talking head + product insert + zoom | Mọi loại sản phẩm |

#### 9.6.4 Tùy chọn User (Customization Options)

| Category | Options | Default |
|---|---|---|
| **Background** | Auto (AI chọn phù hợp) / Studio white / Studio dark / Lifestyle scene / Custom color / Upload bg | Auto |
| **Duration** | 15s / 30s / 45s / 60s | 30s |
| **Music** | Auto-select mood / Browse library / Upload / None | Auto-select |
| **Voice-over** | None / AI narrate product info / Character voice / User record | None |
| **Text overlay** | Product name + price / Feature highlights / Custom text / None | Product name + price |
| **CTA** | "Mua ngay" / "Link in bio" / "Comment để nhận ưu đãi" / Custom / None | "Mua ngay" |
| **Aspect ratio** | 9:16 (TikTok/Reels) / 1:1 (Instagram/Shopee) / 16:9 (YouTube) / 4:3 (Lazada) | 9:16 |
| **Pacing** | Slow & premium / Medium / Fast & dynamic | Medium |
| **Color grade** | Auto / Warm / Cool / Vintage / Brand-matched (từ Brand Pack) | Auto |
| **Model** (Virtual Try-On) | AI generated / Stock library / Character (from Character Pack) | AI generated |
| **Price display** | Hiện giá / Giá gốc + giá sale / Hidden | Product data auto-fill |

#### 9.6.5 Product Data Integration

Khi user đã có sản phẩm trong Product Hub (M13):
- Auto-fill: tên SP, giá, mô tả, ảnh sản phẩm
- Auto-suggest style: AI phân tích category → recommend style phù hợp (ví dụ: fashion → Virtual Try-On, electronics → 360° Spin)
- Auto-generate script cho voice-over từ product description + reviews
- Price tag auto-update nếu product có sale event

Khi user KHÔNG dùng Product Hub:
- Manual upload ảnh + nhập thông tin text
- Vẫn full feature, chỉ không auto-fill

#### 9.6.6 Technical Pipeline

```
upload photos → background removal (rembg/Flux inpaint)
    ↓
product segmentation (mediapipe / SAM2)
    ↓
style-specific generation:
├── 360° Spin: Veo 3.1 image-to-video (rotation prompt)
├── Tabletop Demo: Kling 3.0 (hand interaction scene gen)
├── Flip & Reveal: Veo 3.1 (motion control prompt)
├── Virtual Try-On: Kolors/Flux (model + garment) → Veo 3.1 (animate)
├── Lifestyle Context: Flux 2 (scene composite) → Veo 3.1 (animate)
├── Unboxing: Kling 3.0 (hand + object interaction)
├── Before/After: Flux 2 (scene pair) → FFmpeg (split/wipe transition)
└── Review Style: HeyGen/Character Pack + product overlay
    ↓
post-production: rust-ffmpeg (music + text overlay + CTA + aspect ratio)
    ↓
output → M09 (derivative mgmt) → M10 (QA) → M11 (publish)
```

#### 9.6.7 Batch Mode

- User có nhiều sản phẩm → "Batch Showcase": chọn style 1 lần → apply cho tất cả
- Upload 20 ảnh SP → AI gen 20 videos → queue → user review → batch export
- Batch pricing: credits per video × quantity, bulk discount ≥10 videos

#### 9.6.8 Credit Pricing

| Style | Credits | Note |
|---|---|---|
| 360° Spin | 8–15 | Image-to-video rotation |
| Tabletop Demo | 15–25 | Hand interaction scene gen |
| Flip & Reveal | 10–18 | Motion control |
| Virtual Try-On | 20–35 | Model gen + garment fitting + animation |
| Lifestyle Context | 12–20 | Scene composite + animate |
| Unboxing Simulation | 15–25 | Complex interaction |
| Before/After | 8–15 | Scene pair + transition |
| Review Style | 20–40 | Character voice + product overlay |

#### 9.6.9 Contract Rules
- Background removal phải clean (no artifacts, soft edges)
- Product must remain recognizable (no distortion, color shift)
- Virtual Try-On: garment proportions must be natural (no stretching, clipping)
- Price tag phải đúng data source (nếu auto-fill từ Product Hub)
- Music phải copyright-free (auto-verified từ library)
- Batch mode: failed items ≠ stop remaining (partial failure handling)
- Output phải pass compliance scan trước khi export

---

### 9.7 Image-to-Video Converter (Ảnh tĩnh → Video động)

> **Ref**: PRD M07 | **Input**: 1 ảnh tĩnh | **Output**: 3-15s video với chuyển động

#### 9.7.1 Concept
Upload bất kỳ ảnh nào → AI biến thành video có chuyển động tự nhiên.

#### 9.7.2 Motion Styles

| Style | Mô tả | Effect |
|---|---|---|
| **Cinematic Pan** | Camera pan ngang/dọc qua ảnh | Smooth camera movement |
| **Product Rotate** | Object trong ảnh xoay nhẹ, zoom chi tiết | Subtle 3D rotation |
| **Parallax 3D** | Tách layers (foreground/background) → 3D depth effect | Ken Burns on steroids |
| **Subtle Movement** | Chuyển động nhẹ tự nhiên (tóc bay, nước chảy, ánh sáng) | Living photo effect |
| **Zoom In** | Từ wide shot zoom vào subject | Focus reveal |
| **Custom Prompt** | User mô tả chuyển động muốn thấy | AI interpret |

#### 9.7.3 Tech
- Provider: Veo 3.1 / Kling 3.0 image-to-video API
- Duration options: 3s / 5s / 8s / 15s
- Output: loop-friendly (cho GIF/social) hoặc one-shot
- Add music: optional, auto-sync

#### 9.7.4 Credits: 5–15 per generation

---

### 9.8 AI Thumbnail Studio

> **Ref**: PRD M10 (Packaging QA) | **Upgrade từ basic thumbnail extraction**

#### 9.8.1 Features
- **Auto-extract**: AI chọn best frame từ video → enhance face/lighting → add text overlay
- **Generate from prompt**: "Thumbnail cho video skincare routine" → 5 options
- **Template library**: 50+ trending thumbnail styles (reaction face, split screen, before/after, bold text...)
- **A/B variants**: Tạo 2-3 thumbnails → publish → auto-pick winner dựa trên CTR (via M10 Experiment Lab)
- **Platform optimization**: YouTube (16:9 bold), TikTok (9:16 cover), Instagram (1:1 clean)
- **Brand consistency**: Auto-apply brand fonts/colors/logo từ Brand Pack

#### 9.8.2 Tech
- Flux 2 / GPT Image cho generation
- mediapipe face detection cho best-frame selection
- Revideo for text overlay rendering
- Credits: 3–8 per thumbnail

---

### 9.9 Link-to-Video Generator (Product URL → Video Ad)

> **Ref**: PRD M07, Pack 06 (Commerce M13) | **Input**: URL sản phẩm | **Output**: 15-60s video ad

#### 9.9.1 Flow

```
Paste URL (Shopee, Lazada, TikTok Shop, Amazon...)
    ↓
AI crawl: tên SP, giá, mô tả, ảnh, reviews, rating
    ↓
Auto-generate:
├── Script: hook + benefits (từ SP description) + social proof (từ reviews) + CTA
├── Visual: product images → Product Showcase style (§9.6) hoặc B-roll gen
├── Voice-over: Character Pack voice hoặc AI voice
├── Subtitles: animated captions
└── Music: trending audio match mood
    ↓
User review → customize → export → publish
```

#### 9.9.2 Supported Platforms (URL scraper)
| Platform | Data extracted |
|---|---|
| Shopee | Name, price, sale price, images, description, reviews, rating, sold count |
| Lazada | Name, price, images, description, reviews |
| TikTok Shop | Name, price, images, description, reviews, video reviews |
| Amazon | Name, price, images, features, reviews, rating |
| Shopify store | Name, price, images, description |
| Generic URL | OG tags, images, title, description |

#### 9.9.3 Script Templates
| Template | Structure | Best for |
|---|---|---|
| **Problem-Solution** | Hook (pain point) → Product intro → Benefit 1-3 → Social proof → CTA | Utility products |
| **Listicle Review** | "5 lý do bạn cần..." → Feature highlights → Price reveal → CTA | Any product |
| **Testimonial** | Best review quote → Product showcase → More reviews → CTA | High-review products |
| **Flash Sale** | Urgency hook → Product → Original price vs sale → Timer → CTA | Sale events |
| **Comparison** | "Tại sao chọn X thay vì Y?" → Point-by-point → Verdict → CTA | Competitive products |

#### 9.9.4 Credits: 20–45 per video

---

### 9.10 AI Translation & Localization Studio

> **Ref**: PRD M07 | **Input**: Video tiếng gốc | **Output**: N videos đa ngôn ngữ

#### 9.10.1 Pipeline

```
Upload video gốc → Whisper ASR (transcript)
    ↓
LLM translate (context-aware, giữ tone/style/cultural nuance)
    ↓
ElevenLabs multilingual voice clone → audio mới
    ↓
SyncLabs lip-sync adjustment (video + new audio → synced)
    ↓
Subtitle generation in target language
    ↓
Output: N videos, mỗi video 1 ngôn ngữ
```

#### 9.10.2 Supported Languages (v1)
Vietnamese ↔ English, Thai, Indonesian, Filipino, Japanese, Korean, Mandarin, Spanish

#### 9.10.3 Integration
- Trend Engine: "Trend này đang hot ở Thailand → dịch video bạn sang Thai?"
- Publish Hub: auto-schedule translated versions trên regional accounts
- Credits: 15–40 per language version (depends on video duration)

---

### 9.11 AI Sound Studio (Enhanced Audio Production)

> **Extends S13.1** | Full audio production suite

#### 9.11.1 New Features (beyond S13.1 basics)

| Feature | Description | Provider |
|---|---|---|
| **AI Music Generator** | Describe mood → generate copyright-free BGM | Stable Audio Open / MusicGen |
| **Beat-drop Sync** | Detect beat drops → auto-sync scene transitions | Librosa + FFmpeg |
| **Speech-to-Song** | Transform voice-over into singing voice | ElevenLabs + Resemble |
| **AI Sound Effects** | Describe scene → contextual SFX (swoosh, pop, ding) | ElevenLabs Sound FX |
| **Multi-language Voice Clone** | Clone voice → generate in other language + lip-sync | ElevenLabs + SyncLabs |
| **Podcast → Short Clips** | Podcast audio → detect highlights → visual clips | Whisper + LLM + Veo |

#### 9.11.2 Credits
| Feature | Credits |
|---|---|
| AI Music gen (30s-3min) | 5–15 |
| Speech-to-Song | 8–20 |
| AI SFX per video | 3–8 |
| Multi-lang voice clone | 10–25 per language |

---

### 9.12 AI Style Learning & Transfer

> **Ref**: PRD M08 (Continuity OS) | Learn editing style → apply consistently

#### 9.12.1 Concept
User upload video có style edit đẹp → AI extract style parameters → save as "Style Pack" → auto-apply cho tất cả video tương lai.

#### 9.12.2 Style Elements Extracted

| Element | Extracted | Applied to |
|---|---|---|
| **Caption style** | Font, size, color, animation type, position | Auto-captions trong Quick Edit |
| **Color grade** | LUT/curves profile, temperature, contrast | Video color grading |
| **Transition timing** | Cut frequency, transition types, rhythm | Clip Factory + Multi-Merge |
| **Pacing** | Scene duration pattern, BPM sync mapping | All editing modes |
| **Text overlay** | Font, position, shadow, entry animation | Title cards, CTAs |
| **Audio mix** | Voice/music ratio, ducking curve | Post-production mix |

#### 9.12.3 Style Pack Integration
- Save Style Pack vào Continuity OS (M08) — giống Brand Pack / Character Pack
- Auto-suggest when editing: "Apply Style Pack 'My Signature'?"
- Style Pack Marketplace (future): users share/sell Style Packs → community → network effect

#### 9.12.4 Credits: 10–20 per style extraction

---

### 9.13 AI Video Agent (1-Click Full Pipeline)

> **Ref**: PRD M21 (Agent Center) | "Gõ 1 câu → video ready to publish"

#### 9.13.1 Concept
User mô tả ý tưởng bằng 1 câu → AI Agent tự động orchestrate toàn bộ M07 pipeline → output video hoàn chỉnh + thumbnail + caption + scheduled.

#### 9.13.2 Pipeline

```
User input: "Tạo video 30s về 5 tips chăm sóc da mùa hè cho TikTok"
    ↓
Agent orchestrate:
├── Step 1: LLM generate script (hook + 5 tips + CTA)
├── Step 2: Veo 3.1 generate B-roll per scene
├── Step 3: Character voice-over (ElevenLabs)
├── Step 4: Trending music auto-select + beat-sync
├── Step 5: Animated captions (Revideo / rust-ffmpeg drawtext)
├── Step 6: Thumbnail generation (Flux 2)
├── Step 7: Virality Score calculation
├── Step 8: Platform optimization (9:16, TikTok pace)
    ↓
Output: video + thumbnail + suggested caption + hashtags
    ↓
User: review → tweak → 1-click publish or schedule
```

#### 9.13.3 Context Awareness
- Agent reads: Brand Pack, Character Pack, Trend Engine data, recent content performance
- Output maintains brand consistency (colors, voice, style)
- Script style learns from user's past best-performing content

#### 9.13.4 Credits: 30–80 per video (depends on output length and complexity)

---

### 9.14 AI Performance Coach (Post-publish Feedback Loop)

> **Ref**: PRD M02/M03 (Trend Engine), S17 (Content Intel) | **UNIQUE — không đối thủ nào có**

#### 9.14.1 Concept
Sau khi video publish, AI phân tích performance và DẠY user cách cải thiện → tạo feedback loop: Create → Publish → Learn → Create better.

#### 9.14.2 Features

**Post-publish Analysis (24h sau publish)**:
- "Video có 12K views nhưng retention rate chỉ 40%. Hook yếu (3s đầu mất 35% viewers). Gợi ý: thử hook 'Question' thay vì 'Statement'"
- "Engagement rate 8% — top 15% trong niche. Pattern: short scenes (2.5s avg), fast pacing, trending sound"

**Weekly Content Report Card**:
- 5 metrics: total views, avg engagement, best content, worst content, growth vs previous week
- Best performing format/hook type analysis
- AI-personalized improvement suggestions
- Best time to post (data-driven, per platform, per user)

**Coaching Suggestions (proactive)**:
- "Bạn chưa thử format Before/After → trending +45% trong niche bạn. Tạo thử?"
- "Sound 'XYZ' đang peak — ghép vào video tiếp? [1-click create]"
- Competitor comparison (anonymized): "Creators cùng niche avg 15K views. Bạn 8K. Gap: posting frequency"

#### 9.14.3 Data Sources
- Platform analytics (via Connected Accounts M12)
- Trend Engine (M02/M03) — niche benchmarks
- Video analysis (M07 stack) — content quality signals
- S17 Content Intel — performance predictions

#### 9.14.4 Credits: 0 (included in plan, uses existing analytics data)

---

### 9.15 Video A/B Testing Engine

> **Ref**: PRD M10 (Experiment Lab), S17 (Content Intel)

#### 9.15.1 Flow

```
User tạo video → "Create A/B Test"
    ↓
AI generate variations:
├── Hook variant: Question / Statement / Shock
├── CTA variant: "Link in bio" / "Comment WANT" / "Ấn theo dõi"
├── Thumbnail variant: 3 styles
├── Music variant: Sound A / Sound B
    ↓
Publish all variants (spread schedule, §5.3 batch publish rules)
    ↓
AI monitor 24-72h → auto-report winner + insight
    ↓
Auto-scale winner (re-schedule to more platforms)
```

#### 9.15.2 Metrics Tracked
Views, watch time, engagement rate, saves, shares, conversions (if commerce linked)

#### 9.15.3 Credits: 5–15 per variant generated

---

### 9.16 Creator Gamification System

> **Ref**: Pack 02 Achievement Context (§3.4) | Retention-focused game layer

#### 9.16.1 Elements

| Element | Mechanic | Reward |
|---|---|---|
| **Creator Level** (1-50) | XP per action: create video +10, publish +5, 1K views +20 | Feature unlock, badge, title |
| **Daily Streak** | Create/publish ≥1 content/day | Bonus credits: streak 7 = +50, streak 30 = +200 |
| **Weekly Quest** | "Tạo 3 Tutorial videos tuần này" | Credit reward + Achievement badge |
| **Achievement System** | "First Viral" (10K views), "Remix Master" (10 remixes), "30-day Streak" | Profile badge, shareable |
| **Creator Score** | Aggregate: quality + consistency + engagement + growth rate | Leaderboard position |
| **Seasonal Challenge** | Monthly themed: "Tháng Shorts", "Tháng Product Review" | Credits + exclusive features |
| **Referral Quests** | "Mời 3 bạn → bonus 100 credits" | Credits + badge |

#### 9.16.2 Integration
- XP and Level → display on user profile/avatar
- Achievements → shareable cards (social media organic growth)
- Streaks → push notification reminder ("Đừng mất streak 15 ngày! 🔥")
- Quests → discover new features (increase feature adoption)
- Seasonal Challenges → create content calendar for community

#### 9.16.3 Schema
- Links to: Pack 02 Achievement Context objects (Achievement Definition, User Achievement Record)
- XP calculation: event-driven (video.published → +5 XP, clip.viral.10k → +20 XP)
- Level thresholds: L1=0, L5=100, L10=500, L20=2000, L50=25000

## 10. Cost Tracking Contract

### 10.1 Required Cost Data
- provider cost estimate
- final cost if available
- workspace scope
- request context
- asset/job linkage

### 10.2 Rule
AI generation cost phải feed được về finance/profit layer khi relevant.

## 11. Diagnostics Contract

Mọi generation failure hoặc degraded output phải có:
- failure type
- provider route used
- likely cause
- retry suitability
- recommended action
- fallback option if any

## 12. FE/UX Notes

FE cho media flows phải support:
- progress states
- retry / reroute
- compare outputs
- approve/promote canonical
- view lineage
- inspect drift / QA warnings
- **character selection** khi tạo AI video (xem §12A)

### 12A. Character Builder UX Contract

#### 12A.1 Entry Points
- Sidebar: "AI Studio" → "My Characters" (character library page)
- Video creation flow: character selector modal (top of script editor)
- Settings: "Default Character" setting
- Command Hub: "character" / "nhân vật" keyword

#### 12A.2 Character Library Page
- Grid view: character cards với avatar, name, type badge, usage count
- Actions per card: Edit, Duplicate, Set Default, Delete
- Top bar: "➕ Tạo nhân vật mới" button + quota indicator ("2/5 characters used")
- Sort: Last used, Name, Created date
- Filter: by type (Digital Twin / AI Generated / Stock)

#### 12A.3 Character Creation Wizard (4 steps)

```
Step 1: Chọn loại nhân vật
┌───────────────────────────────────────────────┐
│  🧑 Digital Twin              [Pro+]          │
│  "Tạo phiên bản AI từ video/ảnh của bạn"     │
│                                                │
│  🎨 AI Generated                               │
│  "Mô tả nhân vật bằng text → AI tạo visual"  │
│                                                │
│  📦 Stock Avatar                                │
│  "Chọn từ thư viện 100+ avatar sẵn có"        │
└───────────────────────────────────────────────┘

Step 2: Thiết lập hình ảnh + giọng nói
┌───────────────────────────────────────────────┐
│  📛 Tên nhân vật: [________________]          │
│                                                │
│  [Visual section — varies by type]             │
│  - Digital Twin: Upload video (30s-5min)       │
│  - AI Generated: Prompt + style selector       │
│  - Stock: Browse grid → select                 │
│                                                │
│  🎤 Giọng nói:                                 │
│  ○ Clone giọng (upload audio) [Pro+]           │
│  ○ Chọn AI voice (150+ giọng)                  │
│  ○ Không cần giọng (visual only)               │
│                                                │
│  🎭 Tính cách / Tone:                          │
│  [ ] Formal  [ ] Casual  [ ] Fun               │
│  [ ] Energetic  [ ] Calm  [ ] Inspiring         │
│                                                │
│  🎨 Link Brand Pack (optional):                │
│  [Select brand pack ▾] hoặc [Tạo mới]          │
└───────────────────────────────────────────────┘

Step 3: Preview & Điều chỉnh
┌───────────────────────────────────────────────┐
│  ▶️ Preview video 15s với script mẫu           │
│  [9:16]  [16:9]  [1:1] — preview 3 tỷ lệ     │
│  🔊 Play voice sample                          │
│  ✏️ Điều chỉnh (quay lại step 2)               │
│  ✅ Hài lòng? → Next                           │
└───────────────────────────────────────────────┘

Step 4: Lưu & Cài đặt
┌───────────────────────────────────────────────┐
│  ⭐ Đặt làm nhân vật mặc định?  [Toggle]       │
│  📁 Lưu thành công! → Về Character Library     │
└───────────────────────────────────────────────┘
```

#### 12A.4 Character Selection trong Video Creation

```
User click "Tạo video AI" / "Generate"
    │
    ├─ Top bar hiển thị: [Avatar] "Nhân vật: {name}" [▾ Đổi]
    │   Click ▾ → Character selector dropdown:
    │   ├─ ⭐ {default character name} (Digital Twin)
    │   ├─ 🎨 {character 2} (AI Generated)
    │   ├─ 📦 {character 3} (Stock)
    │   ├─ ─── ───
    │   └─ ➕ Tạo nhân vật mới
    │
    ▼
    Script editor → Generate → AI dùng selected character
```

#### 12A.5 Mobile UX
- Character library: list view (cards simplified)
- Character creation: same wizard, bottom sheet per step
- Character selection: bottom sheet picker trước generate
- Quick action: long-press character card → "Set Default"

---

## 12B. Character Builder Contract (Business Logic)

> **Ref**: PRD M08 (Continuity OS), §34 (AI Copilot), Pack 04 §5 (Continuity Contract)

### 12B.1 Character Types

| Type | Input | Output | Generation Method | Tier |
|---|---|---|---|---|
| **Digital Twin** | User video 30s-5min + consent | Realistic avatar matching user | AI video synthesis (HeyGen/D-ID API) | Pro+ |
| **AI Generated** | Text prompt + style | Custom character | Text-to-image + animate (Stable Diffusion + AI provider) | All |
| **Stock Avatar** | Selection from library | Pre-built avatar | Platform-provided library | All |

### 12B.2 Character Object Schema

```
Character:
  id: UUID
  workspace_id: FK → Workspace
  name: string (≤ 50 chars)
  type: enum(digital_twin, ai_generated, stock)
  status: enum(creating, ready, failed, archived)

  # Visual Profile
  avatar_url: string                    ← Primary image (headshot)
  avatar_full_body_url: string (nullable) ← Full body image
  source_footage_url: string (nullable) ← (Digital Twin) original video
  generation_prompt: text (nullable)    ← (AI Generated) prompt used
  stock_avatar_id: string (nullable)    ← (Stock) reference ID
  style_config: json                    ← outfit, hair, accessories, background pref
  supported_ratios: string[]            ← ["9:16", "16:9", "1:1"]

  # Voice Profile
  voice_pack_id: FK → Voice Pack (nullable)
  voice_type: enum(cloned, ai_preset, none)
  voice_clone_id: string (nullable)     ← Provider-side voice clone ID
  voice_preset_id: string (nullable)    ← AI voice preset ID
  voice_language: string                ← "vi", "en"

  # Personality Profile
  personality_tags: string[]            ← max 5 tags
  speaking_tone: enum(formal, casual, neutral, fun, energetic, calm, inspiring)
  language_primary: string              ← "vi"
  language_secondary: string (nullable) ← "en"

  # Continuity Links (M08 integration)
  brand_pack_id: FK → Brand Pack (nullable)
  character_pack_id: FK → Character Pack (auto-created)
  scene_memory_refs: UUID[]

  # Usage & Management
  is_default: boolean                   ← Max 1 per workspace
  usage_count: integer                  ← Auto-increment on generate
  last_used_at: timestamp (nullable)
  created_at: timestamp
  updated_at: timestamp

  # Compliance
  consent_verified: boolean             ← (Digital Twin) MANDATORY before use
  consent_video_url: string (nullable)  ← (Digital Twin) consent recording
  ethical_label: enum(human, ai_generated, ai_enhanced)
```

### 12B.3 Character ↔ Continuity OS Integration

```
Character (user-facing)
    │
    ├── auto-creates → Character Pack (Continuity OS canonical object)
    │   ├── Visual references: avatar images, style config
    │   ├── Personality descriptors (for prompt assembly)
    │   └── Linking: character_pack_id stored on Character
    │
    ├── links to → Voice Pack (optional)
    │   ├── Cloned voice data
    │   └── Speaking style/tone parameters
    │
    ├── links to → Brand Pack (optional)
    │   ├── Colors, fonts, logo from brand
    │   └── Applied to video overlays + thumbnails
    │
    └── feeds into → Prompt Assembly (§4)
        ├── visual refs from Character Pack → image generation constraints
        ├── voice refs from Voice Pack → TTS parameters
        ├── personality from Character → tone/style in script prompts
        └── brand refs from Brand Pack → overlay/identity constraints
```

**Rule**: Khi user tạo Character → system tự động tạo 1 Character Pack canonical object. Drift detection (§8) dùng Character Pack để so sánh AI output vs canonical character visual/voice.

### 12B.4 Tier Gating

| Feature | Free | Starter | Pro | Business | Enterprise |
|---|---|---|---|---|---|
| **Character slots** | 1 | 2 | 5 | 15 | Unlimited |
| **Digital Twin** | ❌ | ❌ | ✅ (1) | ✅ (5) | ✅ (unlimited) |
| **AI Generated** | ✅ (1) | ✅ (2) | ✅ (5) | ✅ (15) | ✅ |
| **Stock avatars access** | 10 mẫu | 50 mẫu | All | All | All + custom |
| **Voice clone** | ❌ | ❌ | ✅ (1 voice) | ✅ (5 voices) | ✅ |
| **Default character** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Character versioning** | ❌ | ❌ | ✅ | ✅ | ✅ |

### 12B.5 Credit Costs

| Operation | Credits | Notes |
|---|---|---|
| Create AI Generated character | 5-10 | Depends on complexity |
| Create Digital Twin | 15-30 | Processing-intensive |
| Voice clone setup | 10-20 | One-time per voice |
| Character preview (15s test) | 2-3 | Quick validation |
| Use character in video generation | 0 (included) | Character selection is free, video generation cost applies separately |

### 12B.6 Default Character Logic
- Max 1 default character per workspace
- Setting new default → previous auto-unset
- Default character auto-selected khi user mở video generation flow
- If no default set → system prompts "Chọn nhân vật" trước generate
- If character quota exceeded → cannot create new, must archive/delete existing

### 12B.7 Digital Twin Consent Flow

```
User selects "Digital Twin"
    │
    ▼
[1] Upload source footage (30s-5min video)
    │
    ▼
[2] Record consent video (in-app):
    "Tôi [tên], đồng ý cho Creativanta tạo avatar AI từ 
     hình ảnh và giọng nói của tôi, sử dụng cho mục đích 
     tạo nội dung trong workspace này."
    │
    ▼
[3] AI verifies: consent video face matches source footage face
    │
    ├─ ✅ Match → proceed to processing
    └─ ❌ Mismatch → reject + explain
    │
    ▼
[4] Processing (2-60 min tùy provider)
    │
    ▼
[5] Ready → character available in library
```

**Rule**: Digital Twin KHÔNG THỂ sử dụng nếu consent_verified = false. Per EU AI Act + ethical standards.

### 12B.8 Character Lifecycle States

```
creating → ready
creating → failed (→ retry/delete)
ready → archived (→ unarchive back to ready)
archived → deleted (hard delete after 30 days)
```

---

## 13. Handoff

Detail design tiếp theo phải chốt:
- provider adapter interfaces
- job orchestration queues
- media storage pointers
- lineage schema
- drift evaluation rules per pack type
- **character builder provider integration (HeyGen/D-ID/Synthesia API adapters)**
- **stock avatar library source and update pipeline**
- **voice clone provider selection and integration**



## 14. Acceptance Scenario Inventory

AI/media/continuity pack bắt buộc cover tối thiểu các scenario sau:
- script/asset brief/asset flow giữ continuity refs và prompt lineage đầy đủ
- continuity violation được phát hiện, xếp severity, mở được evidence + repair path
- approved references/lookbook/prompt lineage records truy được qua asset compare và approval flows
- provider failover/retry không làm mất lineage, cost attribution hay canonical asset identity
- repurpose/clip factory kế thừa đúng brand/voice/continuity constraints từ canonical packs
- **character creation wizard (4 steps) hoàn tất → character ready trong library**
- **character auto-creates Character Pack canonical → drift detection hoạt động vs character visual/voice**
- **default character auto-selected khi mở video generation → user có thể đổi**
- **Digital Twin consent flow: face match verified → consent_verified = true → character usable**
- **character slots gating enforced per tier → over-limit shows upgrade CTA**
- **voice clone gắn liền character → TTS dùng đúng voice khi generate video**

---

## S13. AI Media & Video Studio Enhancements (Supplementary)

> **Ref**: PRD §29 (AI Production), §36 (Content Repurpose)

### S13.1 Smart Audio Processing

| Feature | Spec | Priority |
|---|---|---|
| **Silence removal** | Auto-detect silence > 1s, compress to 0.3s pause | v1 |
| **Filler word removal** | Detect "uh", "um", "à", "ờ" → remove or flag | v1 |
| **Audio enhancement** | Noise reduction, normalize volume, de-ess | v1 |
| **Background music** | Auto-suggest music matching content mood (royalty-free library) | v1 |
| **Audio ducking** | Auto-lower music volume during speech | v1 |

### S13.2 Trending Style Templates

| Template | Platforms | Description |
|---|---|---|
| Hook-Story-CTA | TikTok, Reels | 3-part structure with hook in first 3s |
| Product Showcase | TikTok Shop, Shopee | Product demo with price overlay + CTA |
| Green Screen React | TikTok, YouTube | Person reacts to background content |
| ASMR Unboxing | TikTok, YouTube | Close-up product unboxing with crisp audio |
| Before/After | Reels, TikTok | Split-screen transformation |
| Talking Head + B-Roll | YouTube | Interview-style with cutaway footage |

- Templates updated monthly based on trending formats
- User can save custom templates
- AI applies template style to raw footage automatically

### S13.3 Stock Integration

| Provider | Type | License |
|---|---|---|
| **Pexels** | Photos + Videos | Free (Pexels License) |
| **Unsplash** | Photos | Free (Unsplash License) |
| **Pixabay** | Photos + Videos + Audio | Free (Pixabay License) |

- In-app search within asset picker
- Auto-attribution (per license requirements)
- Downloaded assets cached in workspace library

### S13.4 AI Avatars

> **Đã integrated vào Character Builder** (§12B). Digital Twin type = AI avatar trained on user footage. AI Generated type = text-to-avatar.

- Text-to-avatar: generate talking head video from text script (via AI Generated Character type)
- Custom avatar / Digital Twin: user trains on their own footage (via Digital Twin Character type, Pro+ tier)
- Provider: HeyGen, D-ID API integration (xem ADR-010 media stack)
- Cost: 10-20 credits per minute of avatar video
- Ethical: labeled as AI-generated per EU AI Act (C2PA metadata)

### S13.5 Auto-Tagging & Asset Organization

| Feature | Spec |
|---|---|
| Auto-tag | AI analyzes uploaded assets → assigns tags (topic, mood, objects detected) |
| Smart folders | Auto-sort assets by: platform, date, project, content type |
| Duplicate detection | Content-based hashing → warn on duplicate upload |
| Usage tracking | Show where each asset was used (which content, which platform) |
| Expiry warning | Flag time-sensitive assets (e.g., seasonal, promotional) |

