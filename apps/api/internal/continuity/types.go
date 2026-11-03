package continuity

import (
	"errors"
	"time"

	contentv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/content/v1"
)

// Standard domain errors for Continuity OS (M08).
var (
	ErrCharacterNotFound           = errors.New("character not found")
	ErrPackNotFound                = errors.New("continuity pack not found")
	ErrConsentNotFound             = errors.New("consent record not found")
	ErrConsentRevoked              = errors.New("digital twin consent has been revoked")
	ErrConsentNotVerified          = errors.New("digital twin consent has not been verified")
	ErrConsentFaceMismatch         = errors.New("face in consent video does not match source footage")
	ErrSlotQuotaExceeded           = errors.New("character slot quota exceeded for workspace tier")
	ErrMultipleDefaultCharacters   = errors.New("workspace can only have one default character")
	ErrWizardStepSequenceViolation = errors.New("character creation wizard steps must be completed sequentially")
	ErrPreviewNotVerified          = errors.New("step 3 preview must be verified before saving character")
	ErrInvalidApprovedReference    = errors.New("approved reference missing canonical identifier or parent context")
	ErrInvalidPackName             = errors.New("continuity pack name cannot be empty")
	ErrInvalidCharacterName        = errors.New("character name cannot be empty")
	ErrInvalidTier                 = errors.New("invalid or unconfigured subscription tier")
	ErrUnauthenticated             = errors.New("unauthenticated request")
	ErrPermissionDenied            = errors.New("permission denied")
)

// Subscription tier slot limits per RULE-M08-003 and AC-M08-008.
const (
	SlotQuotaFree       = 1
	SlotQuotaStarter    = 2
	SlotQuotaPro        = 5
	SlotQuotaBusiness   = 15
	SlotQuotaEnterprise = -1 // Unlimited
)

// GetSlotQuota returns the character limit for a given tier string.
func GetSlotQuota(tier string) int {
	switch tier {
	case "free":
		return SlotQuotaFree
	case "starter":
		return SlotQuotaStarter
	case "pro":
		return SlotQuotaPro
	case "business":
		return SlotQuotaBusiness
	case "enterprise":
		return SlotQuotaEnterprise
	default:
		return SlotQuotaFree
	}
}

// CharacterDomain represents the domain model for characters.
type CharacterDomain struct {
	CharacterID         string
	WorkspaceID         string
	Name                string
	CharacterType       contentv1.CharacterType
	Description         string
	ReferenceImagesJSON string
	VoiceSettingsJSON   string
	VisualSettingsJSON  string
	ConsentVerified     bool
	ConsentRecordID     string
	IsDefault           bool
	Status              contentv1.CharacterStatus
	CharacterPackID     string
	CreatedAt           time.Time
	UpdatedAt           time.Time
	DeletedAt           *time.Time
}

// ContinuityPackDomain represents the domain model for continuity packs.
type ContinuityPackDomain struct {
	PackID              string
	WorkspaceID         string
	PackType            contentv1.PackType
	Name                string
	CharacterID         string
	ApprovedReferences  []*contentv1.ApprovedReference
	RulesSummary        string
	SettingsJSON        string
	AllowedUseScopeJSON string
	Version             int32
	ParentPackID        string
	Status              contentv1.PackStatus
	CreatedAt           time.Time
	UpdatedAt           time.Time
	DeletedAt           *time.Time
}

// PackVersionDomain represents an immutable point-in-time pack version.
type PackVersionDomain struct {
	VersionID           string
	WorkspaceID         string
	PackID              string
	VersionIndex        int32
	Name                string
	PackType            contentv1.PackType
	ApprovedReferences  []*contentv1.ApprovedReference
	RulesSummary        string
	SettingsJSON        string
	AllowedUseScopeJSON string
	Status              contentv1.PackStatus
	SnapshotReason      string
	CreatedBy           string
	CreatedAt           time.Time
}

// ConsentRecordDomain represents legally binding likeness consent.
type ConsentRecordDomain struct {
	ConsentID   string
	UserID      string
	WorkspaceID string
	ConsentType contentv1.ConsentType
	Version     string
	Granted     bool
	GrantedAt   *time.Time
	RevokedAt   *time.Time
	IPAddress   string
	UserAgent   string
	CreatedAt   time.Time
}

// WizardState tracks progression through the 4-step Character Builder wizard.
type WizardState struct {
	Step1TypeSelected bool
	Step2ProfileSetup bool
	Step3PreviewDone  bool
	PreviewVideoURL   string
}
