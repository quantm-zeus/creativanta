package recipe

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"regexp"
	"strings"
	"sync"
	"time"
)

var (
	ErrPrivateMediaForbidden       = errors.New("recipe governance: private source media, raw footage, or private URLs are strictly forbidden in shared templates")
	ErrBiometricDataForbidden      = errors.New("recipe governance: biometric identity (voice samples, face embeddings) is strictly forbidden in shared templates")
	ErrCredentialsForbidden        = errors.New("recipe governance: credentials, tokens, or private secrets are strictly forbidden in shared templates")
	ErrCrossTenantIDForbidden      = errors.New("recipe governance: source tenant or foreign workspace IDs cannot be leaked in template payload")
	ErrMissingStyleSettings        = errors.New("recipe governance: style_workflow templates require non-empty style_settings")
	ErrEmptyLicenseNotice          = errors.New("recipe governance: published templates require an explicit license notice")
	ErrRecipeUnavailableForInstall = errors.New("recipe governance: recipe template is taken down, deprecated, or retired from installation")
	ErrRecipeAlreadyInstalled      = errors.New("recipe: recipe template is already installed in this workspace")
)

// Allowed plain style keys per database_schema.md §27.4 and Pack 04 §9.12.
var allowedStyleKeys = map[string]bool{
	"color_grade":      true,
	"caption_style":    true,
	"pacing":           true,
	"transitions":      true,
	"text_overlay":     true,
	"audio_mix":        true,
	"aspect_ratio":     true,
	"font_family":      true,
	"filter_lut":       true,
	"speed_curve":      true,
	"animation_preset": true,
	"effects":          true,
	"sound_design":     true,
	"framerate":        true,
}

var (
	forbiddenMediaPatterns = []*regexp.Regexp{
		regexp.MustCompile(`(?i)file://`),
		regexp.MustCompile(`(?i)localhost`),
		regexp.MustCompile(`(?i)127\.0\.0\.1`),
		regexp.MustCompile(`(?i)s3://[a-zA-Z0-9_\-\.]+/private`),
		regexp.MustCompile(`(?i)X-Amz-Signature=`),
		regexp.MustCompile(`(?i)X-Amz-Credential=`),
		regexp.MustCompile(`(?i)sig=[a-zA-Z0-9%]+`),
		regexp.MustCompile(`(?i)private_media`),
		regexp.MustCompile(`(?i)raw_footage`),
		regexp.MustCompile(`(?i)unconsented_footage`),
	}

	forbiddenBiometricPatterns = []*regexp.Regexp{
		regexp.MustCompile(`(?i)voice_sample`),
		regexp.MustCompile(`(?i)face_embedding`),
		regexp.MustCompile(`(?i)biometric`),
		regexp.MustCompile(`(?i)voice_clone_id`),
		regexp.MustCompile(`(?i)voice_print`),
		regexp.MustCompile(`(?i)face_landmark`),
		regexp.MustCompile(`(?i)actor_identity`),
	}

	forbiddenCredentialPatterns = []*regexp.Regexp{
		regexp.MustCompile(`(?i)bearer\s+[a-zA-Z0-9\-\._~+/]+=*`),
		regexp.MustCompile(`(?i)api_key`),
		regexp.MustCompile(`(?i)access_token`),
		regexp.MustCompile(`(?i)secret_key`),
		regexp.MustCompile(`(?i)private_key`),
		regexp.MustCompile(`(?i)password`),
	}
)

// ValidateStyleTemplatePayload enforces Acceptance Target 4:
// "No private source media in shared style template" and schema §27.4 governance rules.
func ValidateStyleTemplatePayload(kind string, payload *PortableSnapshot) error {
	if payload == nil {
		if kind == "style_workflow" {
			return ErrMissingStyleSettings
		}
		return nil
	}

	// For style_workflow templates (EF-07A & schema §27.4), strict schema_version and license_notice are enforced.
	if kind == "style_workflow" {
		if payload.SchemaVersion <= 0 {
			return errors.New("recipe governance: schema_version must be >= 1 for style_workflow templates")
		}
		if strings.TrimSpace(payload.LicenseNotice) == "" {
			return ErrEmptyLicenseNotice
		}
		if payload.StyleSettings == nil || len(payload.StyleSettings) == 0 {
			return ErrMissingStyleSettings
		}
	} else if payload.SchemaVersion > 0 && strings.TrimSpace(payload.LicenseNotice) == "" {
		return ErrEmptyLicenseNotice
	}

	// Serialize full payload for deep pattern inspection
	payloadBytes, err := json.Marshal(payload)
	if err != nil {
		return fmt.Errorf("recipe governance: marshal payload for audit: %w", err)
	}
	payloadStr := string(payloadBytes)

	// 1. Check forbidden private media patterns
	for _, pattern := range forbiddenMediaPatterns {
		if pattern.MatchString(payloadStr) {
			return fmt.Errorf("%w: matched pattern %q", ErrPrivateMediaForbidden, pattern.String())
		}
	}

	// 2. Check forbidden biometric identity patterns
	for _, pattern := range forbiddenBiometricPatterns {
		if pattern.MatchString(payloadStr) {
			return fmt.Errorf("%w: matched pattern %q", ErrBiometricDataForbidden, pattern.String())
		}
	}

	// 3. Check credentials and secrets
	for _, pattern := range forbiddenCredentialPatterns {
		if pattern.MatchString(payloadStr) {
			return fmt.Errorf("%w: matched credential pattern %q", ErrCredentialsForbidden, pattern.String())
		}
	}

	// 4. Style-specific validation for style_workflow
	if kind == "style_workflow" {
		if payload.StyleSettings == nil || len(payload.StyleSettings) == 0 {
			return ErrMissingStyleSettings
		}

		// Verify that all keys in style_settings are permitted plain style values
		for k, val := range payload.StyleSettings {
			if !allowedStyleKeys[k] {
				return fmt.Errorf("recipe governance: unauthorized style setting key %q (permitted: color_grade, caption_style, pacing, transitions, text_overlay, audio_mix, etc.)", k)
			}

			// Value must be primitive or structured config, not arbitrary scripts
			valStr := fmt.Sprintf("%v", val)
			for _, pat := range forbiddenMediaPatterns {
				if pat.MatchString(valStr) {
					return fmt.Errorf("%w: in setting %q", ErrPrivateMediaForbidden, k)
				}
			}
			for _, pat := range forbiddenBiometricPatterns {
				if pat.MatchString(valStr) {
					return fmt.Errorf("%w: in setting %q", ErrBiometricDataForbidden, k)
				}
			}
		}
	}

	return nil
}

// ClonedStylePackRecord represents a newly cloned, tenant-owned continuity style pack.
type ClonedStylePackRecord struct {
	ContinuityPackID string
	StylePackID      string
	WorkspaceID      string
	Name             string
	StyleSettings    map[string]any
	CreatedAt        time.Time
}

// ContinuityStylePackCloner abstracts tenant-owned continuity pack cloning (Acceptance Target 3).
type ContinuityStylePackCloner interface {
	CloneStylePack(ctx context.Context, destWorkspaceID, sourceRecipeTitle, licenseNotice string, styleSettings map[string]any) (string, string, error)
}

// InMemoryStylePackCloner stores cloned tenant packs in-memory for testing.
type InMemoryStylePackCloner struct {
	mu    sync.Mutex
	Packs map[string]*ClonedStylePackRecord // stylePackID -> record
}

func NewInMemoryStylePackCloner() *InMemoryStylePackCloner {
	return &InMemoryStylePackCloner{
		Packs: make(map[string]*ClonedStylePackRecord),
	}
}

func (c *InMemoryStylePackCloner) CloneStylePack(ctx context.Context, destWorkspaceID, sourceRecipeTitle, licenseNotice string, styleSettings map[string]any) (string, string, error) {
	c.mu.Lock()
	defer c.mu.Unlock()

	contPackID := newUUID()
	stylePackID := newUUID()
	now := time.Now().UTC()

	// Clone style settings into tenant pack
	clonedSettings := make(map[string]any)
	for k, v := range styleSettings {
		clonedSettings[k] = v
	}

	record := &ClonedStylePackRecord{
		ContinuityPackID: contPackID,
		StylePackID:      stylePackID,
		WorkspaceID:      destWorkspaceID,
		Name:             sourceRecipeTitle + " (Tenant Style Pack)",
		StyleSettings:    clonedSettings,
		CreatedAt:        now,
	}

	c.Packs[stylePackID] = record
	return contPackID, stylePackID, nil
}
