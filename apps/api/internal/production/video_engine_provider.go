package production

import (
	"bytes"
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strings"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

// VideoEngineConfig configures the Creativanta Video Engine v1 HTTP adapter.
// See creativanta-video-engine/docs/API_CONTRACT.md for the canonical REST contract:
//   - POST /v1/compositions (201 Created)
//   - POST /v1/render-jobs  (202 Accepted, supports Idempotency-Key header)
//   - GET  /v1/jobs/{id}    (200 OK -> status: queued, processing, completed, failed, cancelled)
//   - POST /v1/jobs/{id}/cancel
//   - Webhook signature header: X-CVE-Signature: sha256=<hex_digest>
type VideoEngineConfig struct {
	BaseURL       string
	APIKey        string
	WebhookSecret string
	HTTPClient    *http.Client
	RateUSDPerSec tenantdb.ExactDecimal
}

// VideoEngineProvider implements VideoProvider against the Creativanta Video Engine REST API v1.
type VideoEngineProvider struct {
	cfg    VideoEngineConfig
	client *http.Client
	rate   tenantdb.ExactDecimal
}

// NewVideoEngineProvider creates a new VideoEngineProvider.
// If BaseURL or APIKey is empty, the provider remains unconfigured and fails closed
// with ErrProviderNotConfigured rather than fabricating output.
func NewVideoEngineProvider(cfg VideoEngineConfig) *VideoEngineProvider {
	client := cfg.HTTPClient
	if client == nil {
		client = &http.Client{Timeout: 10 * time.Second}
	}
	rate := cfg.RateUSDPerSec
	if rate.IsZero() {
		rate, _ = tenantdb.ParseExactDecimal("0.020000")
	}
	return &VideoEngineProvider{
		cfg:    cfg,
		client: client,
		rate:   rate,
	}
}

func (p *VideoEngineProvider) Name() string {
	return "video-engine"
}

func (p *VideoEngineProvider) CostRatePerSecondUSD() tenantdb.ExactDecimal {
	return p.rate
}

// IsConfigured reports whether BaseURL and APIKey are present.
func (p *VideoEngineProvider) IsConfigured() bool {
	return strings.TrimSpace(p.cfg.BaseURL) != "" && strings.TrimSpace(p.cfg.APIKey) != ""
}

type cveCreateCompositionRequest struct {
	Name            string         `json:"name"`
	AspectRatio     string         `json:"aspect_ratio"`
	DurationSeconds int            `json:"duration_seconds"`
	TimelineSpec    map[string]any `json:"timeline_spec"`
}

type cveCompositionResponse struct {
	ID     string `json:"id"`
	Status string `json:"status"`
}

type cveCreateRenderJobRequest struct {
	CompositionID string `json:"composition_id"`
	Preset        string `json:"preset,omitempty"`
}

type cveJobResponse struct {
	ID           string  `json:"id"`
	Status       string  `json:"status"`
	ProgressPct  int     `json:"progress_pct"`
	OutputURL    string  `json:"output_url"`
	ResultURL    string  `json:"result_url"`
	DurationSecs float64 `json:"duration_seconds"`
	Resolution   string  `json:"resolution"`
	ErrorCode    string  `json:"error_code"`
	ErrorMessage string  `json:"error_message"`
}

// Generate creates a composition and submits an asynchronous render job to the Video Engine.
// Because /v1/render-jobs returns 202 Accepted with status "queued" or "processing",
// CheckStatus returns "queued"/"processing" until the engine finishes rendering.
func (p *VideoEngineProvider) Generate(ctx context.Context, req ProviderGenRequest) (*ProviderGenResponse, error) {
	if !p.IsConfigured() {
		return nil, ErrProviderNotConfigured
	}
	baseURL := strings.TrimRight(strings.TrimSpace(p.cfg.BaseURL), "/")
	parsed, err := url.ParseRequestURI(baseURL)
	if err != nil || (parsed.Scheme != "http" && parsed.Scheme != "https") {
		return nil, fmt.Errorf("%w: invalid video engine base URL", ErrInvalidURL)
	}

	dur := req.DurationSeconds
	if dur <= 0 {
		dur = 15
	}
	aspect := req.AspectRatio
	if aspect == "" {
		aspect = "9:16"
	}

	// Step 1: POST /v1/compositions
	compPayload := cveCreateCompositionRequest{
		Name:            "studio-generation",
		AspectRatio:     aspect,
		DurationSeconds: dur,
		TimelineSpec: map[string]any{
			"prompt":            req.Prompt,
			"pipeline_strategy": req.PipelineStrategy,
			"reference_url":     req.ReferenceURL,
			"image_urls":        req.ImageURLs,
		},
	}
	compBody, err := json.Marshal(compPayload)
	if err != nil {
		return nil, fmt.Errorf("video-engine: marshal composition payload: %w", err)
	}

	compReq, err := http.NewRequestWithContext(ctx, http.MethodPost, baseURL+"/v1/compositions", bytes.NewReader(compBody))
	if err != nil {
		return nil, fmt.Errorf("video-engine: build composition request: %w", err)
	}
	compReq.Header.Set("Content-Type", "application/json")
	compReq.Header.Set("X-API-Key", p.cfg.APIKey)

	compResp, err := p.client.Do(compReq)
	if err != nil {
		return nil, err
	}
	defer compResp.Body.Close()

	compRespBytes, _ := io.ReadAll(io.LimitReader(compResp.Body, 1<<20))
	if compResp.StatusCode != http.StatusCreated && compResp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("video-engine: POST /v1/compositions returned status %d: %s", compResp.StatusCode, strings.TrimSpace(string(compRespBytes)))
	}

	var compParsed cveCompositionResponse
	if err := json.Unmarshal(compRespBytes, &compParsed); err != nil || strings.TrimSpace(compParsed.ID) == "" {
		return nil, fmt.Errorf("video-engine: invalid composition response: %w", err)
	}

	// Step 2: POST /v1/render-jobs (202 Accepted)
	renderPayload := cveCreateRenderJobRequest{
		CompositionID: compParsed.ID,
		Preset:        "1080p_h264",
	}
	renderBody, err := json.Marshal(renderPayload)
	if err != nil {
		return nil, fmt.Errorf("video-engine: marshal render-job payload: %w", err)
	}

	renderReq, err := http.NewRequestWithContext(ctx, http.MethodPost, baseURL+"/v1/render-jobs", bytes.NewReader(renderBody))
	if err != nil {
		return nil, fmt.Errorf("video-engine: build render-job request: %w", err)
	}
	renderReq.Header.Set("Content-Type", "application/json")
	renderReq.Header.Set("X-API-Key", p.cfg.APIKey)
	if strings.TrimSpace(req.IdempotencyKey) != "" {
		renderReq.Header.Set("Idempotency-Key", strings.TrimSpace(req.IdempotencyKey))
	}

	renderResp, err := p.client.Do(renderReq)
	if err != nil {
		// Once POST /v1/render-jobs has been dispatched, any network/transport error means
		// the server may have already accepted and started the render job.
		return nil, fmt.Errorf("%w: video-engine POST /v1/render-jobs transport failure: %w", ErrOutcomeUnknown, err)
	}
	defer renderResp.Body.Close()

	renderRespBytes, readErr := io.ReadAll(io.LimitReader(renderResp.Body, 1<<20))
	if renderResp.StatusCode != http.StatusAccepted && renderResp.StatusCode != http.StatusCreated && renderResp.StatusCode != http.StatusOK {
		if renderResp.StatusCode >= http.StatusInternalServerError || renderResp.StatusCode == http.StatusRequestTimeout {
			return nil, fmt.Errorf("%w: video-engine: POST /v1/render-jobs returned ambiguous server status %d: %s", ErrOutcomeUnknown, renderResp.StatusCode, strings.TrimSpace(string(renderRespBytes)))
		}
		return nil, fmt.Errorf("video-engine: POST /v1/render-jobs returned status %d: %s", renderResp.StatusCode, strings.TrimSpace(string(renderRespBytes)))
	}
	if readErr != nil {
		return nil, fmt.Errorf("%w: video-engine: failed reading 2xx render-job response body: %w", ErrOutcomeUnknown, readErr)
	}

	var jobParsed cveJobResponse
	if err := json.Unmarshal(renderRespBytes, &jobParsed); err != nil || strings.TrimSpace(jobParsed.ID) == "" {
		// Server returned 2xx (accepted the render job), so outcome is in-flight/unknown if payload cannot be decoded.
		return nil, fmt.Errorf("%w: video-engine: invalid render-job response after 2xx acceptance: %v", ErrOutcomeUnknown, err)
	}

	initStatus := strings.ToLower(strings.TrimSpace(jobParsed.Status))
	if initStatus == "" {
		initStatus = "queued"
	}

	durDec, _ := tenantdb.ParseExactDecimal(fmt.Sprintf("%d.000000", dur))
	cost, _ := durDec.MulFloor(p.rate)

	return &ProviderGenResponse{
		ProviderJobID: jobParsed.ID,
		InitialStatus: initStatus,
		EstimatedCost: cost,
	}, nil
}

// CheckStatus queries GET /v1/jobs/{id} on the Video Engine.
func (p *VideoEngineProvider) CheckStatus(ctx context.Context, providerJobID string) (*ProviderGenStatus, error) {
	if !p.IsConfigured() {
		return nil, ErrProviderNotConfigured
	}
	baseURL := strings.TrimRight(strings.TrimSpace(p.cfg.BaseURL), "/")
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, baseURL+"/v1/jobs/"+url.PathEscape(providerJobID), nil)
	if err != nil {
		return nil, fmt.Errorf("video-engine: build status request: %w", err)
	}
	req.Header.Set("X-API-Key", p.cfg.APIKey)

	resp, err := p.client.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	bodyBytes, _ := io.ReadAll(io.LimitReader(resp.Body, 1<<20))
	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("video-engine: GET /v1/jobs/%s returned status %d: %s", providerJobID, resp.StatusCode, strings.TrimSpace(string(bodyBytes)))
	}

	var parsed cveJobResponse
	if err := json.Unmarshal(bodyBytes, &parsed); err != nil {
		return nil, fmt.Errorf("video-engine: decode status response: %w", err)
	}

	normalizedStatus := normalizeVideoEngineStatus(parsed.Status)
	resURL := strings.TrimSpace(parsed.OutputURL)
	if resURL == "" {
		resURL = strings.TrimSpace(parsed.ResultURL)
	}
	durSecs := parsed.DurationSecs
	if durSecs <= 0 {
		durSecs = 15.0
	}
	durDec, _ := tenantdb.ParseExactDecimal(fmt.Sprintf("%.6f", durSecs))
	costUSD, _ := durDec.MulFloor(p.rate)
	resolution := parsed.Resolution
	if resolution == "" {
		resolution = "1080x1920"
	}

	return &ProviderGenStatus{
		ProviderJobID: providerJobID,
		Status:        normalizedStatus,
		ProgressPct:   parsed.ProgressPct,
		ResultURL:     resURL,
		DurationSecs:  durDec,
		Resolution:    resolution,
		CostUSD:       costUSD,
		ErrorCode:     parsed.ErrorCode,
		ErrorMessage:  parsed.ErrorMessage,
	}, nil
}

// Cancel submits POST /v1/jobs/{id}/cancel to the Video Engine.
func (p *VideoEngineProvider) Cancel(ctx context.Context, providerJobID string) error {
	if !p.IsConfigured() {
		return ErrProviderNotConfigured
	}
	baseURL := strings.TrimRight(strings.TrimSpace(p.cfg.BaseURL), "/")
	req, err := http.NewRequestWithContext(ctx, http.MethodPost, baseURL+"/v1/jobs/"+url.PathEscape(providerJobID)+"/cancel", nil)
	if err != nil {
		return err
	}
	req.Header.Set("X-API-Key", p.cfg.APIKey)

	resp, err := p.client.Do(req)
	if err != nil {
		return fmt.Errorf("%w: video-engine: cancel job %s transport error: %w", ErrOutcomeUnknown, providerJobID, err)
	}
	defer resp.Body.Close()
	bodyBytes, _ := io.ReadAll(io.LimitReader(resp.Body, 1<<20))
	if resp.StatusCode >= 400 {
		return fmt.Errorf("%w: video-engine: cancel job %s returned status %d: %s", ErrOutcomeUnknown, providerJobID, resp.StatusCode, strings.TrimSpace(string(bodyBytes)))
	}
	if resp.StatusCode == http.StatusAccepted {
		return fmt.Errorf("%w: video-engine: cancel job %s accepted (202) pending provider stop confirmation", ErrOutcomeUnknown, providerJobID)
	}
	if len(bytes.TrimSpace(bodyBytes)) > 0 {
		var parsed cveJobResponse
		if err := json.Unmarshal(bodyBytes, &parsed); err != nil {
			return fmt.Errorf("%w: video-engine: decode cancel response for %s: %v", ErrOutcomeUnknown, providerJobID, err)
		}
		if strings.TrimSpace(parsed.Status) != "" && normalizeVideoEngineStatus(parsed.Status) != "cancelled" {
			return fmt.Errorf("%w: video-engine: cancel job %s returned non-terminal status %q", ErrOutcomeUnknown, providerJobID, parsed.Status)
		}
	}
	return nil
}

// VerifyWebhookSignature verifies the X-CVE-Signature: sha256=<hex_digest> header
// against the raw webhook request body using constant-time HMAC comparison.
func (p *VideoEngineProvider) VerifyWebhookSignature(payload []byte, signatureHeader string) bool {
	secret := strings.TrimSpace(p.cfg.WebhookSecret)
	if secret == "" {
		return false
	}
	sig := strings.TrimSpace(signatureHeader)
	sig = strings.TrimPrefix(sig, "sha256=")
	providedMAC, err := hex.DecodeString(sig)
	if err != nil {
		return false
	}
	mac := hmac.New(sha256.New, []byte(secret))
	mac.Write(payload)
	expectedMAC := mac.Sum(nil)
	return hmac.Equal(providedMAC, expectedMAC)
}

func normalizeVideoEngineStatus(raw string) string {
	switch strings.ToLower(strings.TrimSpace(raw)) {
	case "queued", "pending":
		return "queued"
	case "processing", "rendering", "running", "in_progress":
		return "processing"
	case "completed", "succeeded", "done":
		return "completed"
	case "failed", "error":
		return "failed"
	case "cancelled", "canceled":
		return "cancelled"
	default:
		return "unknown"
	}
}
