---
layer: system
canonical: true
source_file: impl_d1_ai_provider_guide.md
last_verified: 2026-03-30
purpose: AI provider setup (Gemini, OpenAI, ElevenLabs, Veo), adapter trait pattern, error handling, and cost tracking
---

# D1 — AI Provider Integration Guide

> **Upstream**: Pack 04 (AI/Media), Tech Stack ADR v3 (ADR-009, ADR-010, ADR-011)
> **v1 Providers**: Gemini (primary) + OpenAI (fallback) + ElevenLabs (TTS)
>
> **Note**: `tech_stack_adr.md` lists 8 strategic provider categories. This guide covers the **v1 implementation scope** — 3 primary providers (Gemini, OpenAI, ElevenLabs) plus specific model choices per category. Phase 2 providers (Kling, Whisper standalone, etc.) are listed with "(P2)" suffix and will be integrated when capacity allows.

---

## 1. v1 Provider Scope

| Category | Primary | Fallback | Purpose |
|---|---|---|---|
| **LLM** | Gemini 2.5 Flash | GPT-4o-mini | Copilot, trends, ideas, scripts, captions |
| **LLM (complex)** | Gemini 2.5 Pro | GPT-4o | Script gen, long analysis |
| **Video Gen** | Google Veo 3.1 | Kling 3.0 (P2) | AI video generation |
| **Image Gen** | Flux 2 Pro (Replicate) | GPT Image | Thumbnails, product images |
| **TTS** | ElevenLabs | Google Cloud TTS | Voice-over, voice clone |
| **STT** | Gemini Flash (audio input) | Whisper API | Transcription |
| **Embedding** | Gemini text-embedding-004 | — | Semantic search, similarity |
| **Moderation** | OpenAI Moderation (free) | Gemini safety | Content moderation |

---

## 2. Gemini Setup

### 2.1 API Configuration
```bash
GEMINI_API_KEY=AIza...
GEMINI_DEFAULT_MODEL=gemini-2.5-flash
GEMINI_PRO_MODEL=gemini-2.5-pro
GEMINI_EMBEDDING_MODEL=text-embedding-004
GEMINI_MAX_RETRIES=3
GEMINI_TIMEOUT_MS=30000
```

### 2.2 Task Routing (YAML Config)
```yaml
ai_routing:
  tasks:
    copilot_query:
      provider: gemini
      model: gemini-2.5-flash
      max_tokens: 4096
      temperature: 0.7
    
    script_generation:
      provider: gemini
      model: gemini-2.5-pro
      max_tokens: 8192
      temperature: 0.8
    
    trend_analysis:
      provider: gemini
      model: gemini-2.5-flash
      max_tokens: 2048
      temperature: 0.3
    
    caption_hashtag:
      provider: gemini
      model: gemini-2.5-flash
      max_tokens: 1024
      temperature: 0.5
    
    intent_classification:
      provider: gemini
      model: gemini-2.5-flash
      max_tokens: 256
      temperature: 0.1
    
    embedding:
      provider: gemini
      model: text-embedding-004
      dimensions: 768

  fallback_chain:
    - gemini
    - openai   # activated when gemini circuit breaks
  
  circuit_breaker:
    failure_threshold: 3
    reset_timeout_secs: 300
```

### 2.3 Credit Cost Table (per operation — default values)

> **Note**: These are default/baseline credit costs used by the AI routing config. The full credit pricing with tier-based ranges is in `01_business/pricing_and_credits.md` §3 (canonical source for pricing). Values here represent the standard-quality defaults; premium/HD variants cost more per the pricing doc.

```yaml
credit_costs:
  # LLM
  text_analysis: 1          # trend, intent, score
  caption_generation: 1     # hashtags, captions
  script_generation: 3      # full script with hooks
  copilot_query: 1          # conversational query
  copilot_action: 3         # action-executing query (range: 3–15 per pricing doc)
  long_analysis: 5          # competitor deep dive
  
  # Media
  image_generation: 5       # single image
  thumbnail_generation: 3   # thumbnail variant
  video_generation_per_5s: 10  # per 5 seconds
  tts_per_1000_chars: 2     # voice synthesis
  voice_clone_setup: 15     # one-time clone (midpoint of 10–20 range per BIZ-001)
  lip_sync_per_5s: 5        # lip sync processing
  
  # Analysis
  video_analysis_per_min: 3 # scene detection + ASR
  remix_analysis: 8         # full creative DNA
  
  # Zero-cost
  copilot_help: 0           # help queries
  copilot_analytics: 0      # analytics queries
  performance_coach: 0      # post-publish analysis
```

---

## 3. OpenAI Setup (Fallback)

```bash
OPENAI_API_KEY=sk-...
OPENAI_DEFAULT_MODEL=gpt-4o-mini
OPENAI_COMPLEX_MODEL=gpt-4o
OPENAI_MODERATION=text-moderation-latest
```

---

## 4. ElevenLabs Setup

```bash
ELEVENLABS_API_KEY=...
ELEVENLABS_DEFAULT_VOICE=onyx  # or Vietnamese voice ID
ELEVENLABS_MODEL=eleven_multilingual_v2
ELEVENLABS_MAX_CHARS_PER_REQUEST=5000
```

### Voice Clone Setup Flow:
1. User uploads 30s-5min audio sample
2. API uploads to ElevenLabs Professional clone
3. Returns voice_id → stored in `characters.voice_settings`
4. Clone requires consent verification (EU AI Act)

---

## 5. Veo 3.1 Setup (Video Generation)

```bash
GOOGLE_CLOUD_PROJECT=creativanta
VEO_API_ENDPOINT=https://generativelanguage.googleapis.com
VEO_MODEL=veo-3.1
VEO_MAX_DURATION_SECS=60
```

### Request/Response:
```rust
pub struct VideoGenRequest {
    pub prompt: String,
    pub duration_secs: u32,        // 5-60
    pub aspect_ratio: String,      // 16:9, 9:16, 1:1
    pub style: Option<String>,
    pub reference_image: Option<Vec<u8>>,
    pub audio_mode: AudioMode,     // Native, None
    pub quality: Quality,          // Standard, Premium
}

pub struct VideoGenResult {
    pub video_url: String,
    pub duration_secs: f32,       // in-memory only; persists as NUMERIC(12,2) in assets table
    pub resolution: String,
    pub cost_usd: f64,            // in-memory only; persists as NUMERIC(18,6) per DB-H-001
    pub generation_time_ms: u64,
}
```

---

## 6. Adapter Trait (Implementation Pattern)

```rust
// All providers implement this trait
#[async_trait]
pub trait LlmProvider: Send + Sync {
    fn name(&self) -> &str;
    fn supports_function_calling(&self) -> bool;
    fn supports_streaming(&self) -> bool;
    fn cost_per_1m_input(&self) -> f64;
    fn cost_per_1m_output(&self) -> f64;
    
    async fn complete(&self, req: CompletionRequest) -> Result<CompletionResponse>;
    async fn stream(&self, req: CompletionRequest) -> Result<Pin<Box<dyn Stream<Item = Result<StreamChunk>>>>>;
    async fn embed(&self, texts: Vec<String>) -> Result<Vec<Vec<f32>>>;
    async fn health_check(&self) -> bool;
}

// Adding a new provider = implement this trait + add to router config
// ~100-150 lines per provider adapter
```

```rust
pub struct StreamChunk {
    pub delta_text: String,
    pub is_final: bool,
    pub finish_reason: Option<String>,
    pub usage: Option<TokenUsage>,
}
```

---

## 7. Error Handling

| Error Type | Retry? | Action |
|---|---|---|
| 429 Rate Limited | Yes | Backoff per Retry-After header |
| 500/502/503 Server Error | Yes | Exponential backoff |
| 401 Auth Error | No | Rotate API key, alert admin |
| 400 Bad Request | No | Log, send to DLQ |
| Timeout (>30s) | Yes | Try fallback provider |
| Content Filter | No | Return to user with explanation |
| Quota Exceeded | No | Hard block, notify workspace admin |

---

## 8. Cost Tracking

Every AI call creates an `api_call_logs` record (TimescaleDB):
```sql
INSERT INTO api_call_logs (time, workspace_id, provider, model, operation, input_tokens, output_tokens, cost_usd, latency_ms, status)
VALUES (NOW(), $1, $2, $3, $4, $5, $6, $7, $8, $9);
```

Dashboard query: daily/weekly/monthly cost per workspace per provider.

---

## 9. Internal Cost Management & Margin Monitoring

> Source: Pricing/Credits Contract §3.7

### 9.1 AI Cost Tracking (Internal P&L)
- Every AI operation MUST track `actual_cost_usd` (real provider cost) alongside `credits_used` (user-charged)
- Monthly P&L dashboard (admin-only): credit revenue vs actual AI costs per operation type
- **Margin alert**: if margin < 30% on any operation type → trigger `system.alert_triggered` event → Finance Admin notified
- Per-workspace cost tracking: identify high-cost workspaces for optimization

### 9.2 Model Routing Optimization
- Route requests to cost-effective model first → fallback to premium model only if needed
- **Semantic cache**: cache LLM responses for similar prompts (embedding similarity > 0.95) → reduce API calls by ~20-30%
- **Batch processing**: group small requests when possible (e.g., batch caption generation)
- **Provider diversification**: never depend on single AI provider — circuit breaker ensures auto-failover
- **Token budgeting**: set max_tokens per task type to prevent runaway costs

### 9.3 Margin Health Dashboard (Internal Admin)

| Metric | Threshold | Alert |
|---|---|---|
| Per-operation margin | < 30% | Finance Admin notification |
| Monthly total AI cost | > 80% of credit revenue | P1 alert to Finance + Ops |
| Provider cost spike | > 50% increase week-over-week | Tech Admin notification |
| Cache hit rate | < 20% | Optimization review trigger |
| Average tokens/request | > 2x expected for task type | Model routing review |
