package recipe

import (
	"context"
	"fmt"
	"strings"
	"unicode"

	"github.com/quantm-zeus/creativanta/apps/api/internal/workflow"
)

func titleCase(s string) string {
	s = strings.ToLower(strings.TrimSpace(s))
	if s == "" {
		return ""
	}
	r := []rune(s)
	r[0] = unicode.ToUpper(r[0])
	return string(r)
}

// CapabilityChecker evaluates whether a workspace meets a recipe's platform and capability requirements.
type CapabilityChecker interface {
	CheckEligibility(ctx context.Context, workspaceID string, requiredCapabilities []string) (bool, []MissingCapabilityExplanation, error)
}

// DefaultCapabilityChecker checks capabilities using the underlying workflow.CapabilityStatusProvider.
type DefaultCapabilityChecker struct {
	provider workflow.CapabilityStatusProvider
}

func NewCapabilityChecker(provider workflow.CapabilityStatusProvider) *DefaultCapabilityChecker {
	if provider == nil {
		provider = workflow.NewDefaultCapabilityProvider()
	}
	return &DefaultCapabilityChecker{provider: provider}
}

var _ CapabilityChecker = (*DefaultCapabilityChecker)(nil)

// CheckEligibility evaluates all required capabilities and explains any missing or degraded capabilities.
func (c *DefaultCapabilityChecker) CheckEligibility(ctx context.Context, workspaceID string, requiredCapabilities []string) (bool, []MissingCapabilityExplanation, error) {
	var missing []MissingCapabilityExplanation

	for _, capKey := range requiredCapabilities {
		capKey = strings.TrimSpace(capKey)
		if capKey == "" {
			continue
		}

		parts := strings.Split(capKey, ".")
		platform := parts[0]
		action := ""
		if len(parts) > 1 {
			action = strings.Join(parts[1:], ".")
		}

		status, err := c.provider.GetPlatformCapability(ctx, workspaceID, platform, action)
		if err != nil {
			return false, nil, fmt.Errorf("check capability %s: %w", capKey, err)
		}

		// Supported or native means ready for installation
		statusLower := strings.ToLower(status)
		if statusLower == "supported" || statusLower == "native" || statusLower == "active" {
			continue
		}

		// Capability is missing, unsupported, degraded, or manual fallback
		explanation := c.buildExplanation(capKey, platform, action, statusLower)
		missing = append(missing, explanation)
	}

	isEligible := len(missing) == 0
	return isEligible, missing, nil
}

func (c *DefaultCapabilityChecker) buildExplanation(capKey, platform, action, status string) MissingCapabilityExplanation {
	platformTitle := titleCase(platform)

	reason := fmt.Sprintf("Platform connector '%s' capability for '%s' is currently %s.", platformTitle, action, status)
	guidance := fmt.Sprintf("Connect or reactivate your %s account in Settings -> Integrations to enable this automation.", platformTitle)
	connectURL := fmt.Sprintf("/settings/integrations/%s", strings.ToLower(platform))

	switch strings.ToLower(platform) {
	case "shopee":
		reason = "This recipe requires an active Shopee connector with order synchronization capability."
		guidance = "Connect your Shopee seller store in Settings -> Integrations or browse alternative recipes."
	case "tiktok":
		reason = "This recipe requires TikTok Direct Publish or Video Sync capability."
		guidance = "Authorize your TikTok Creator or Business account in Integrations with publish permissions."
	case "youtube":
		reason = "This recipe requires YouTube Data API upload permissions."
		guidance = "Grant video upload scope to your connected YouTube Channel."
	case "instagram":
		reason = "This recipe requires Instagram Content Publishing API access."
		guidance = "Connect your Instagram Professional/Creator account linked to a Facebook Page."
	case "lazada":
		reason = "This recipe requires Lazada Open Platform order/product sync authorization."
		guidance = "Connect your Lazada merchant credentials in Settings -> Integrations."
	}

	return MissingCapabilityExplanation{
		CapabilityKey:      capKey,
		Platform:           platform,
		Reason:             reason,
		ResolutionGuidance: guidance,
		ConnectURL:         connectURL,
	}
}
