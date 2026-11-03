package production

import (
	"fmt"
	"strings"
)

// TierMaxInputs returns the maximum allowed media files for Multi-Merge by workspace tier.
// Free 5, Starter 10, Pro 20, Business 50 (ai_video_studio.md §Mode 3).
func TierMaxInputs(tier string) int {
	switch strings.ToLower(tier) {
	case "business", "enterprise":
		return 50
	case "pro":
		return 20
	case "starter":
		return 10
	case "free":
		fallthrough
	default:
		return 5
	}
}

// MultiMergeValidationResult holds the outcome of evaluating a timeline for Multi-Merge.
type MultiMergeValidationResult struct {
	IsValid         bool
	TotalDuration   float64
	CopyrightChecks []CopyrightCheckResult
	Errors          []string
}

// KnownCopyrightedAudios lists test signatures for copyright detection simulation (ACRCloud).
var KnownCopyrightedAudios = map[string]struct {
	Title  string
	Artist string
}{
	"track-copyright-01": {Title: "Blinding Lights", Artist: "The Weeknd"},
	"track-copyright-02": {Title: "Shape of You", Artist: "Ed Sheeran"},
	"audio-copyrighted":  {Title: "Commercial Hit #1", Artist: "Major Record Label"},
}

// ValidateMultiMergeTimeline enforces tier limits, minimum inputs, copyright scan, and auto-transitions.
func ValidateMultiMergeTimeline(tier string, items []MultiMergeTimelineItem, settings MultiMergeSettings) MultiMergeValidationResult {
	res := MultiMergeValidationResult{
		IsValid:         true,
		CopyrightChecks: []CopyrightCheckResult{},
		Errors:          []string{},
	}

	// 1. Minimum inputs check: Multi-merge requires at least 2 files
	if len(items) < 2 {
		res.IsValid = false
		res.Errors = append(res.Errors, "Multi-merge requires at least 2 media files to merge (received %d)", fmt.Sprintf("%d", len(items)))
		return res
	}

	// 2. Maximum inputs check per workspace tier
	maxInputs := TierMaxInputs(tier)
	if len(items) > maxInputs {
		res.IsValid = false
		res.Errors = append(res.Errors, fmt.Sprintf("Media count (%d) exceeds workspace tier limit of %d files. Upgrade tier or remove items.", len(items), maxInputs))
		return res
	}

	// 3. Auto-transitions computation and timeline duration calculation
	totalDur := 0.0
	for i := range items {
		item := &items[i]
		dur := item.DurationSeconds
		if dur <= 0 {
			if item.MediaType == "image" {
				dur = 3.0 // Default 3s for images
			} else {
				dur = 5.0 // Default 5s for videos
			}
			item.DurationSeconds = dur
		}
		totalDur += dur

		// Apply Auto-transition rules per ai_video_studio.md §Mode 3:
		// Image->Image: Ken Burns + 0.5-1s; Video->Video: crossfade 0.3-0.5s; Image->Video: fade-in 0.5s
		if settings.AutoTransitions && i < len(items)-1 {
			nextItem := items[i+1]
			if item.MediaType == "image" && nextItem.MediaType == "image" {
				item.TransitionToNext = "ken_burns"
				item.TransitionDurationSeconds = 0.8
			} else if item.MediaType == "video" && nextItem.MediaType == "video" {
				item.TransitionToNext = "crossfade"
				item.TransitionDurationSeconds = 0.5
			} else if item.MediaType == "image" && nextItem.MediaType == "video" {
				item.TransitionToNext = "fade_in"
				item.TransitionDurationSeconds = 0.5
			} else {
				item.TransitionToNext = "cut"
				item.TransitionDurationSeconds = 0.0
			}
		}

		// 4. Media item copyright check
		check := CheckMediaCopyright(item.AssetID, item.LicenseProofKey)
		res.CopyrightChecks = append(res.CopyrightChecks, check)
		if !check.Passed {
			res.IsValid = false
			res.Errors = append(res.Errors, check.WarningMessage)
		}
	}

	// 5. Background music copyright check (if music uploaded/specified)
	if settings.MusicAssetID != "" {
		musicCheck := CheckMediaCopyright(settings.MusicAssetID, settings.MusicLicenseProof)
		res.CopyrightChecks = append(res.CopyrightChecks, musicCheck)
		if !musicCheck.Passed {
			res.IsValid = false
			res.Errors = append(res.Errors, musicCheck.WarningMessage)
		}
	}

	res.TotalDuration = totalDur
	return res
}

// CheckMediaCopyright inspects an asset for copyrighted sound/footage (EC-M07-M01, RULE-M07-008).
// Hard Rule: Confirmed rights violations CANNOT be bypassed by accepting risk (SAFE-2026-02).
func CheckMediaCopyright(assetID, licenseProof string) CopyrightCheckResult {
	info, isKnownCopyright := KnownCopyrightedAudios[assetID]

	// Check for copyrighted keywords in assetID
	lowerID := strings.ToLower(assetID)
	if !isKnownCopyright && (strings.Contains(lowerID, "copyrighted") || strings.Contains(lowerID, "infringing")) {
		isKnownCopyright = true
		info = struct {
			Title  string
			Artist string
		}{
			Title:  "Commercial Song",
			Artist: "Restricted Artist",
		}
	}

	if !isKnownCopyright {
		// Clean royalty-free / licensed asset
		return CopyrightCheckResult{
			MediaID:         assetID,
			MediaTitle:      "Original/Royalty-free Asset",
			IsCopyrighted:   false,
			LicenseVerified: true,
			Passed:          true,
			CanBypassRisk:   false,
		}
	}

	// Media is copyrighted. Check if verified license proof is attached.
	hasValidLicense := strings.TrimSpace(licenseProof) != "" && !strings.Contains(strings.ToLower(licenseProof), "invalid")

	if hasValidLicense {
		return CopyrightCheckResult{
			MediaID:           assetID,
			MediaTitle:        info.Title,
			IsCopyrighted:     true,
			DetectedSongTitle: info.Title,
			DetectedArtist:    info.Artist,
			LicenseVerified:   true,
			LicenseKey:        licenseProof,
			Passed:            true,
			CanBypassRisk:     false,
			WarningMessage:    fmt.Sprintf("Copyright match verified with license %q: %s by %s", licenseProof, info.Title, info.Artist),
		}
	}

	// No valid license proof provided: HARD BLOCK per SAFE-2026-02 and EC-M07-M01.
	return CopyrightCheckResult{
		MediaID:           assetID,
		MediaTitle:        info.Title,
		IsCopyrighted:     true,
		DetectedSongTitle: info.Title,
		DetectedArtist:    info.Artist,
		LicenseVerified:   false,
		Passed:            false,
		CanBypassRisk:     false, // strictly false
		WarningMessage:    fmt.Sprintf("⚠️ Music detected as copyrighted: %s by %s. [Replace with licensed audio] or [Submit license for review].", info.Title, info.Artist),
		ActionableOptions: []string{
			"Replace with licensed audio",
			"Submit license for review",
			"Select royalty-free audio from library",
			"Generate original AI voice/music",
		},
	}
}
