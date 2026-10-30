---
layer: system
canonical: true
source_file: impl_d1_ai_provider_guide.md
last_verified: 2026-03-30
purpose: AI provider setup (Gemini, OpenAI, ElevenLabs, Veo), adapter interface pattern, error handling, and cost tracking
last_updated: 2026-10-30
---

# D1 — AI Provider Integration Guide

> **Upstream**: Pack 04 (AI/Media), Tech Stack ADR v4 (ADR-009, ADR-010, ADR-011)
> **v1 Providers**: Gemini (primary) + OpenAI (fallback) + ElevenLabs (TTS)
>
> **Note**: `tech_stack_adr.md` lists 8 strategic provider categories. This guide covers the **v1 implementation scope** — 3 primary providers (Gemini, OpenAI, ElevenLabs) plus specific model choices per category. Historical "(P2)" provider labels mean secondary adapter candidates, not the delivery phase. All owning feature requirements remain assigned by IMPLEMENTATION_ORDER.md; a candidate is enabled only after verification.

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

### 2.3 Cost estimation and provider activation

Use [Pricing §3](../01_business/pricing_and_credits.md#3-cost-based-credit-quotes) for the cost-based quote algorithm and [Credit accounting](../04_contracts/credit_accounting_contract.md) for durable execution. No hardcoded credit-cost YAML may bypass those contracts. Help/read-only included actions still enforce internal budgets.

Provider/model names in this guide are candidate adapter configurations, not confirmed available models. P0 records enabled=false until a current endpoint/model probe, permission check, supported dimensions and versioned rate card pass. Before enabling an embedding route, request exactly the schema vector dimension (768) and test it; changing dimension/model requires backfill and a new index, never mixed embeddings. All media/voice providers required by M07/M08 remain scope in P4; fallback becomes usable only after its own access/rate gate.

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
```go
// Internal adapter DTO sketches. Public/persisted fields remain owned by contracts.
type VideoGenRequest struct {
    Prompt string
    DurationSecs uint32
    AspectRatio string
    Style *string
    ReferenceImage []byte
    AudioMode AudioMode
    Quality Quality
}
type VideoGenResult struct {
    VideoURL string
    DurationSecs decimal.Decimal // Exact parse, persists NUMERIC(12,2).
    Resolution string
    CostUSD decimal.Decimal // Never convert provider money through float64.
    GenerationTimeMS uint64
}
```

---

## 6. Adapter Interface (Implementation Pattern)

```go
// Small context-aware interfaces; request/result types compile in each slice.
// decimal.Decimal is github.com/shopspring/decimal, pinned by P0.
type LLMProvider interface {
    Name() string
    SupportsFunctionCalling() bool
    SupportsStreaming() bool
    CostPer1MInput() decimal.Decimal
    CostPer1MOutput() decimal.Decimal
    Complete(context.Context, CompletionRequest) (CompletionResponse, error)
    Stream(context.Context, CompletionRequest, func(StreamChunk) error) error
    Embed(context.Context, []string) ([][]float32, error)
    HealthCheck(context.Context) error
}
// A streaming callback applies backpressure and propagates errors.
// Use the current request context; do not spawn detached goroutines for streams.
// Implement an adapter and verify capabilities/rates before enabling its route.
```

```go
type StreamChunk struct {
    DeltaText string
    IsFinal bool
    FinishReason *string
    Usage *TokenUsage
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
| Timeout after submission | Reconcile first | Unknown outcome; preserve effect/reservation identity; fallback only after safe resolution and authorized cost ceiling |
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
