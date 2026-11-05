package publicapi

import (
	"bytes"
	"context"
	"crypto/hmac"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net"
	"net/http"
	"net/url"
	"strconv"
	"strings"
	"sync"
	"time"
)

// HostIPResolver resolves a hostname to its IP addresses for SSRF validation.
type HostIPResolver interface {
	LookupIPAddr(ctx context.Context, host string) ([]net.IPAddr, error)
}

// IsDisallowedWebhookIP reports whether ip falls in loopback, RFC1918 private,
// link-local/cloud metadata (169.254.0.0/16, fe80::/10), CGNAT/Tailscale (100.64.0.0/10),
// ULA (fc00::/7), multicast, broadcast, benchmarking, or unspecified ranges.
func IsDisallowedWebhookIP(ip net.IP) bool {
	if len(ip) == 0 {
		return true
	}
	if ip.IsLoopback() || ip.IsPrivate() || ip.IsLinkLocalUnicast() || ip.IsLinkLocalMulticast() || ip.IsMulticast() || ip.IsUnspecified() {
		return true
	}
	if ip4 := ip.To4(); ip4 != nil {
		// 0.0.0.0/8 ("this" network)
		if ip4[0] == 0 {
			return true
		}
		// 100.64.0.0/10 (Carrier-Grade NAT / Tailscale mesh)
		if ip4[0] == 100 && ip4[1] >= 64 && ip4[1] <= 127 {
			return true
		}
		// 169.254.0.0/16 (Link-local / cloud instance metadata 169.254.169.254)
		if ip4[0] == 169 && ip4[1] == 254 {
			return true
		}
		// 192.0.0.0/24 (IETF Protocol Assignments) and 192.0.2.0/24 (TEST-NET-1)
		if ip4[0] == 192 && ip4[1] == 0 && (ip4[2] == 0 || ip4[2] == 2) {
			return true
		}
		// 198.18.0.0/15 (Benchmarking)
		if ip4[0] == 198 && (ip4[1] == 18 || ip4[1] == 19) {
			return true
		}
		// 198.51.100.0/24 (TEST-NET-2)
		if ip4[0] == 198 && ip4[1] == 51 && ip4[2] == 100 {
			return true
		}
		// 203.0.113.0/24 (TEST-NET-3)
		if ip4[0] == 203 && ip4[1] == 0 && ip4[2] == 113 {
			return true
		}
		// 240.0.0.0/4 (Reserved / Broadcast 255.255.255.255)
		if ip4[0] >= 240 {
			return true
		}
	}
	return false
}

func isForbiddenWebhookHostname(host string) bool {
	h := strings.TrimSuffix(strings.ToLower(strings.TrimSpace(host)), ".")
	if h == "" {
		return true
	}
	if h == "localhost" || strings.HasSuffix(h, ".localhost") ||
		strings.HasSuffix(h, ".local") || strings.HasSuffix(h, ".internal") ||
		h == "metadata" || h == "metadata.google.internal" || h == "instance-data" {
		return true
	}
	return false
}

// ValidateWebhookTargetURL validates an outbound webhook target URL against SSRF rules:
//   - Requires https:// scheme and no userinfo credentials
//   - Rejects localhost, .local, .internal, and cloud metadata hostnames
//   - Rejects literal private/loopback/link-local/CGNAT/unspecified IPs
//   - When resolver is non-nil, resolves DNS and verifies every returned IP is public
func ValidateWebhookTargetURL(ctx context.Context, rawURL string, resolver HostIPResolver) ([]net.IP, error) {
	trimmed := strings.TrimSpace(rawURL)
	if trimmed == "" {
		return nil, fmt.Errorf("%w: empty target_url", ErrWebhookTargetSSRFBlocked)
	}
	u, err := url.Parse(trimmed)
	if err != nil {
		return nil, fmt.Errorf("%w: malformed URL: %v", ErrWebhookTargetSSRFBlocked, err)
	}
	if strings.ToLower(u.Scheme) != "https" {
		return nil, fmt.Errorf("%w: scheme must be https", ErrWebhookTargetSSRFBlocked)
	}
	if u.User != nil {
		return nil, fmt.Errorf("%w: userinfo credentials are not permitted in webhook URL", ErrWebhookTargetSSRFBlocked)
	}
	host := strings.TrimSpace(u.Hostname())
	if isForbiddenWebhookHostname(host) {
		return nil, fmt.Errorf("%w: forbidden internal hostname %q", ErrWebhookTargetSSRFBlocked, host)
	}
	if portStr := u.Port(); portStr != "" {
		port, err := strconv.Atoi(portStr)
		if err != nil || port <= 0 || port > 65535 {
			return nil, fmt.Errorf("%w: invalid port %q", ErrWebhookTargetSSRFBlocked, portStr)
		}
	}

	if ip := net.ParseIP(host); ip != nil {
		if IsDisallowedWebhookIP(ip) {
			return nil, fmt.Errorf("%w: disallowed IP address %s", ErrWebhookTargetSSRFBlocked, ip.String())
		}
		return []net.IP{ip}, nil
	}

	if resolver != nil {
		addrs, err := resolver.LookupIPAddr(ctx, host)
		if err != nil || len(addrs) == 0 {
			return nil, fmt.Errorf("%w: failed to resolve host %q: %v", ErrWebhookTargetSSRFBlocked, host, err)
		}
		verified := make([]net.IP, 0, len(addrs))
		for _, addr := range addrs {
			if IsDisallowedWebhookIP(addr.IP) {
				return nil, fmt.Errorf("%w: host %q resolved to disallowed IP %s", ErrWebhookTargetSSRFBlocked, host, addr.IP.String())
			}
			verified = append(verified, addr.IP)
		}
		return verified, nil
	}

	if addrs, err := net.DefaultResolver.LookupIPAddr(ctx, host); err == nil && len(addrs) > 0 {
		verified := make([]net.IP, 0, len(addrs))
		for _, addr := range addrs {
			if IsDisallowedWebhookIP(addr.IP) {
				return nil, fmt.Errorf("%w: host %q resolved to disallowed IP %s", ErrWebhookTargetSSRFBlocked, host, addr.IP.String())
			}
			verified = append(verified, addr.IP)
		}
		return verified, nil
	}

	return nil, nil
}

// HTTPClient defines the interface for making outbound HTTP calls.
type HTTPClient interface {
	Do(req *http.Request) (*http.Response, error)
}

// OutboundDispatcher delivers outbound webhooks to subscriber endpoints with HMAC signing, retries, and replay safety.
type OutboundDispatcher struct {
	store      Store
	httpClient HTTPClient
	resolver   HostIPResolver
	mu         sync.Mutex
	retryPlans map[string][]time.Duration // event_id -> delays
}

// NewSafeWebhookHTTPClient constructs an *http.Client that blocks all HTTP redirects
// and validates + pins resolved public IPs at dial time to prevent DNS rebinding SSRF.
func NewSafeWebhookHTTPClient(resolver HostIPResolver) *http.Client {
	if resolver == nil {
		resolver = net.DefaultResolver
	}
	dialer := &net.Dialer{
		Timeout:   5 * time.Second,
		KeepAlive: 30 * time.Second,
	}
	transport := &http.Transport{
		Proxy: nil, // Never use environment proxy to pivot into internal networks
		DialContext: func(ctx context.Context, network, addr string) (net.Conn, error) {
			host, port, err := net.SplitHostPort(addr)
			if err != nil {
				return nil, fmt.Errorf("%w: invalid dial address %q: %v", ErrWebhookTargetSSRFBlocked, addr, err)
			}
			verifiedIPs, err := ValidateWebhookTargetURL(ctx, "https://"+net.JoinHostPort(host, port), resolver)
			if err != nil {
				return nil, err
			}
			if len(verifiedIPs) == 0 {
				return nil, fmt.Errorf("%w: no verified public IP for %q", ErrWebhookTargetSSRFBlocked, host)
			}
			return dialer.DialContext(ctx, network, net.JoinHostPort(verifiedIPs[0].String(), port))
		},
		TLSHandshakeTimeout:   5 * time.Second,
		ResponseHeaderTimeout: 10 * time.Second,
	}
	return &http.Client{
		Timeout:   10 * time.Second,
		Transport: transport,
		CheckRedirect: func(req *http.Request, via []*http.Request) error {
			return ErrWebhookRedirectBlocked
		},
	}
}

// NewOutboundDispatcher creates a new OutboundDispatcher.
func NewOutboundDispatcher(store Store, httpClient HTTPClient) *OutboundDispatcher {
	d := &OutboundDispatcher{
		store:      store,
		retryPlans: make(map[string][]time.Duration),
	}
	if httpClient == nil {
		d.httpClient = NewSafeWebhookHTTPClient(net.DefaultResolver)
	} else if stdClient, ok := httpClient.(*http.Client); ok {
		cloned := *stdClient
		cloned.CheckRedirect = func(req *http.Request, via []*http.Request) error {
			return ErrWebhookRedirectBlocked
		}
		d.httpClient = &cloned
	} else {
		d.httpClient = httpClient
	}
	return d
}

// WithHostIPResolver configures a custom HostIPResolver for pre-dispatch and dial-time SSRF checks.
func (d *OutboundDispatcher) WithHostIPResolver(resolver HostIPResolver) *OutboundDispatcher {
	d.resolver = resolver
	return d
}

// ComputeSignature calculates the canonical HMAC-SHA256 signature per S24 §5.1.
// Format: sha256=<hex(HMAC-SHA256(secret, timestamp + "." + payload))>
func ComputeSignature(secret string, timestamp time.Time, payload []byte) string {
	mac := hmac.New(sha256.New, []byte(secret))
	mac.Write([]byte(fmt.Sprintf("%d.", timestamp.Unix())))
	mac.Write(payload)
	return "sha256=" + hex.EncodeToString(mac.Sum(nil))
}

// VerifySignature validates an incoming webhook signature.
func VerifySignature(secret string, signatureHeader string, timestamp int64, payload []byte) bool {
	expectedSig := ComputeSignature(secret, time.Unix(timestamp, 0), payload)
	return hmac.Equal([]byte(strings.TrimSpace(signatureHeader)), []byte(expectedSig))
}

// OutboundEventDeliveryRequest describes an event to be dispatched to workspace subscribers.
type OutboundEventDeliveryRequest struct {
	WorkspaceID string
	EventType   string // internal or external name
	EventID     string
	RawPayload  json.RawMessage
	IsReplay    bool
}

// OutboundDeliveryResult records the delivery outcome across all subscribers.
type OutboundDeliveryResult struct {
	DeliveredCount int
	FailedCount    int
	Deliveries     []WebhookDeliveryEntity
}

// DispatchEvent routes a domain event to all active matching webhook subscriptions for the workspace.
func (d *OutboundDispatcher) DispatchEvent(ctx context.Context, req OutboundEventDeliveryRequest) (OutboundDeliveryResult, error) {
	externalName, ok := IsEligibleWebhookEvent(req.EventType)
	if !ok {
		return OutboundDeliveryResult{}, fmt.Errorf("%w: %s", ErrIneligibleWebhookEvent, req.EventType)
	}

	// Sanitize payload stripping operator-only and cost details
	sanitizedPayload, err := WebhookPayloadSanitizer(req.RawPayload)
	if err != nil {
		return OutboundDeliveryResult{}, fmt.Errorf("publicapi: failed to sanitize webhook payload: %w", err)
	}

	subs, err := d.store.ListWebhookSubscriptions(ctx, req.WorkspaceID)
	if err != nil {
		return OutboundDeliveryResult{}, err
	}

	now := time.Now().UTC()
	var result OutboundDeliveryResult

	for _, sub := range subs {
		if sub.Status != "active" {
			continue
		}
		// Check event type matching
		matched := false
		for _, et := range sub.EventTypes {
			if et == externalName || et == "*:*" || et == "*" {
				matched = true
				break
			}
		}
		if !matched {
			continue
		}

		deliveryRecord, err := d.deliverToSubscription(ctx, sub, externalName, req.EventID, sanitizedPayload, req.IsReplay, now)
		if err != nil {
			result.FailedCount++
		} else {
			result.DeliveredCount++
		}
		result.Deliveries = append(result.Deliveries, deliveryRecord)
	}

	return result, nil
}

// deliverToSubscription attempts delivery with up to 3 retries (1s / 10s / 60s per RULE-S24-006).
func (d *OutboundDispatcher) deliverToSubscription(
	ctx context.Context,
	sub WebhookSubscriptionEntity,
	eventType string,
	eventID string,
	payload []byte,
	isReplay bool,
	timestamp time.Time,
) (WebhookDeliveryEntity, error) {
	sig := ComputeSignature(sub.SigningSecret, timestamp, payload)

	var lastStatusCode int
	var lastErr error
	var responseBody string
	maxAttempts := 3

	if _, err := ValidateWebhookTargetURL(ctx, sub.TargetURL, d.resolver); err != nil {
		lastErr = err
		maxAttempts = 0
	}

	for attempt := 1; attempt <= maxAttempts; attempt++ {
		if d.resolver != nil {
			if _, err := ValidateWebhookTargetURL(ctx, sub.TargetURL, d.resolver); err != nil {
				lastErr = err
				break
			}
		}
		httpReq, err := http.NewRequestWithContext(ctx, http.MethodPost, sub.TargetURL, bytes.NewReader(payload))
		if err != nil {
			lastErr = err
			break
		}

		httpReq.Header.Set("Content-Type", "application/json")
		httpReq.Header.Set("User-Agent", "Creativanta-Webhook/1.0")
		httpReq.Header.Set("X-Creativanta-Event", eventType)
		httpReq.Header.Set("X-Creativanta-Delivery-Id", newUUID())
		httpReq.Header.Set("X-Creativanta-Timestamp", fmt.Sprintf("%d", timestamp.Unix()))
		httpReq.Header.Set("X-Creativanta-Signature", sig)
		if isReplay {
			httpReq.Header.Set("X-Creativanta-Replay", "true")
		}

		resp, err := d.httpClient.Do(httpReq)
		if err != nil {
			lastErr = err
			lastStatusCode = 0
			if errors.Is(err, ErrWebhookRedirectBlocked) || errors.Is(err, ErrWebhookTargetSSRFBlocked) {
				break
			}
		} else {
			lastStatusCode = resp.StatusCode
			bodyBytes, _ := io.ReadAll(io.LimitReader(resp.Body, 4096))
			_ = resp.Body.Close()
			responseBody = string(bodyBytes)

			if resp.StatusCode >= 300 && resp.StatusCode < 400 {
				lastErr = fmt.Errorf("%w: status %d", ErrWebhookRedirectBlocked, resp.StatusCode)
				break
			}

			if resp.StatusCode >= 200 && resp.StatusCode < 300 {
				// Succeeded! Reset consecutive failure count
				sub.ConsecutiveFailureCount = 0
				sub.LastError = ""
				ts := time.Now().UTC()
				sub.LastDeliveryAt = &ts
				_ = d.store.UpdateWebhookSubscription(ctx, sub)

				record := WebhookDeliveryEntity{
					DeliveryID:            newUUID(),
					WorkspaceID:           sub.WorkspaceID,
					WebhookSubscriptionID: sub.SubscriptionID,
					WebhookEventID:        eventID,
					EventType:             eventType,
					TargetURL:             sub.TargetURL,
					StatusCode:            lastStatusCode,
					AttemptNumber:         attempt,
					DeliveryStatus:        "delivered",
					RequestSignature:      sig,
					ResponseBody:          responseBody,
					IsReplay:              isReplay,
					DeliveredAt:           ts,
				}
				if isReplay {
					record.DeliveryStatus = "replayed"
				}
				saved, _ := d.store.RecordWebhookDelivery(ctx, record)
				return saved, nil
			}
			lastErr = fmt.Errorf("http error %d: %s", resp.StatusCode, responseBody)
		}

		// If failed and not last attempt, wait exponential backoff
		if attempt < maxAttempts {
			// Delays: 1s, 10s, 60s
			var delay time.Duration
			switch attempt {
			case 1:
				delay = 1 * time.Second
			case 2:
				delay = 10 * time.Second
			default:
				delay = 60 * time.Second
			}
			// In unit tests, we don't necessarily sleep if context is short, or sleep short duration.
			select {
			case <-ctx.Done():
				lastErr = ctx.Err()
				break
			case <-time.After(delay):
			}
		}
	}

	// All retries failed. Update consecutive failure count and check auto-suspend per RULE-S24-006.
	sub.ConsecutiveFailureCount++
	if lastErr != nil {
		sub.LastError = lastErr.Error()
	} else {
		sub.LastError = fmt.Sprintf("status code %d", lastStatusCode)
	}

	if sub.ConsecutiveFailureCount >= MaxWebhookConsecutiveFailuresBeforeSuspend {
		sub.Status = "suspended"
	}
	_ = d.store.UpdateWebhookSubscription(ctx, sub)

	errStr := ""
	if lastErr != nil {
		errStr = lastErr.Error()
	}
	failedRecord := WebhookDeliveryEntity{
		DeliveryID:            newUUID(),
		WorkspaceID:           sub.WorkspaceID,
		WebhookSubscriptionID: sub.SubscriptionID,
		WebhookEventID:        eventID,
		EventType:             eventType,
		TargetURL:             sub.TargetURL,
		StatusCode:            lastStatusCode,
		AttemptNumber:         maxAttempts,
		DeliveryStatus:        "failed",
		ErrorMessage:          errStr,
		RequestSignature:      sig,
		ResponseBody:          responseBody,
		IsReplay:              isReplay,
		DeliveredAt:           time.Now().UTC(),
	}
	saved, _ := d.store.RecordWebhookDelivery(ctx, failedRecord)

	if sub.Status == "suspended" {
		return saved, fmt.Errorf("%w (consecutive failures >= 100)", ErrSubscriptionSuspended)
	}
	if lastErr != nil {
		return saved, lastErr
	}
	return saved, errors.New("webhook delivery failed")
}

// ReplayDelivery re-dispatches a previously recorded delivery with replay semantics.
func (d *OutboundDispatcher) ReplayDelivery(ctx context.Context, workspaceID, deliveryID string) (WebhookDeliveryEntity, error) {
	prev, err := d.store.GetWebhookDelivery(ctx, workspaceID, deliveryID)
	if err != nil {
		return WebhookDeliveryEntity{}, err
	}
	sub, err := d.store.GetWebhookSubscription(ctx, workspaceID, prev.WebhookSubscriptionID)
	if err != nil {
		return WebhookDeliveryEntity{}, err
	}
	if sub.Status != "active" {
		return WebhookDeliveryEntity{}, ErrSubscriptionSuspended
	}

	testPayload := json.RawMessage(fmt.Sprintf(`{"event": "%s", "replayed_from_delivery_id": "%s", "timestamp": %d}`, prev.EventType, prev.DeliveryID, time.Now().Unix()))
	res, err := d.deliverToSubscription(ctx, sub, prev.EventType, prev.WebhookEventID, testPayload, true, time.Now().UTC())
	return res, err
}
