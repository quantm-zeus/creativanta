package script

import (
	"context"
	"errors"
	"strings"
	"time"

	contentv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/content/v1"
	"google.golang.org/protobuf/types/known/timestamppb"
)

var (
	ErrUnauthenticated                      = errors.New("script: unauthenticated caller")
	ErrCrossTenantDenied                    = errors.New("script: cross-tenant access strictly forbidden")
	ErrPermissionDenied                     = errors.New("script: permission denied")
	ErrScriptNotFound                       = errors.New("script: requested script not found")
	ErrTitleRequired                        = errors.New("script: title is required")
	ErrEmptyScenesBlockSubmission           = errors.New("script: script has empty scenes. Complete all scene content before submitting for approval (EC-M06-001)")
	ErrNoScenesBlockSubmission              = errors.New("script: script must have at least one scene before submitting for approval")
	ErrRejectionReasonRequired              = errors.New("script: rejection reason must be at least 10 characters. Please provide specific feedback (RULE-M06-002, EC-M06-002)")
	ErrStaleReviewConflict                  = errors.New("script: script was updated since you started reviewing. Please reload (EC-M06-003)")
	ErrApprovalStateNotPending              = errors.New("script: script is not in pending_approval state")
	ErrReadyForProductionPreconditionFailed = errors.New("script: ready for production requires approved lifecycle, approved review state, and complete asset brief (RULE-M06-005, RULE-M06-006)")
	ErrAssetBriefNotFound                   = errors.New("script: asset brief not found for script")
	ErrBriefIncomplete                      = errors.New("script: asset brief is incomplete (missing output_type, target_format, or continuity requirements)")
	ErrInvalidLifecycleTransition           = errors.New("script: invalid lifecycle state transition")
	ErrVersionNotFound                      = errors.New("script: script version not found")
)

// CallerContext represents caller credentials and workspace scope.
type CallerContext struct {
	UserID        string
	WorkspaceID   string
	WorkspaceRole string
}

type callerCtxKey struct{}

// WithCallerContext binds CallerContext into context.
func WithCallerContext(ctx context.Context, caller CallerContext) context.Context {
	return context.WithValue(ctx, callerCtxKey{}, caller)
}

// CallerFromContext retrieves CallerContext from ctx.
func CallerFromContext(ctx context.Context) (CallerContext, bool) {
	if ctx == nil {
		return CallerContext{}, false
	}
	c, ok := ctx.Value(callerCtxKey{}).(CallerContext)
	return c, ok
}

// StoredShot represents a shot within a scene (§6.6).
type StoredShot struct {
	ShotID          string
	SceneID         string
	WorkspaceID     string
	ShotIndex       int32
	ShotType        string
	Description     string
	DurationSeconds int32
	CreatedAt       time.Time
}

// StoredScene represents a structured scene (§6.6).
type StoredScene struct {
	SceneID         string
	ScriptID        string
	WorkspaceID     string
	SceneIndex      int32
	Description     string
	Content         string
	DurationSeconds int32
	VisualNotes     string
	AudioNotes      string
	ShotList        []StoredShot
	CreatedAt       time.Time
}

// StoredCtaBlock represents a CTA element.
type StoredCtaBlock struct {
	CtaID          string
	Text           string
	ButtonText     string
	DestinationURL string
	CtaType        string
}

// StoredDisclosureBlock represents a legal disclosure (RULE-M06-007).
type StoredDisclosureBlock struct {
	DisclosureID    string
	Text            string
	Platform        string
	IsDismissed     bool
	DismissedBy     string
	DismissedAt     *time.Time
	DismissalReason string
}

// StoredPublishTargetProfile represents social destination parameters.
type StoredPublishTargetProfile struct {
	Platform  string
	Format    string
	AccountID string
}

// StoredAssetBrief represents production handoff brief (§6.5).
type StoredAssetBrief struct {
	AssetBriefID               string
	WorkspaceID                string
	ScriptID                   string
	OutputType                 string
	TargetFormat               string
	TargetDurationSeconds      int32
	TargetPlatforms            []string
	ContinuityRequirementsJSON string
	BrandVoiceRequirementsJSON string
	ProductionInstructions     string
	Status                     contentv1.AssetBriefStatus
	CreatedAt                  time.Time
	UpdatedAt                  time.Time
	DeletedAt                  *time.Time
}

// StoredScriptVersion represents a snapshot version for compare/restore (A3).
type StoredScriptVersion struct {
	VersionID             string
	WorkspaceID           string
	ScriptID              string
	VersionIndex          int32
	Title                 string
	Scenes                []StoredScene
	CtaBlocks             []StoredCtaBlock
	DisclosureBlocks      []StoredDisclosureBlock
	DurationTargetSeconds int32
	LifecycleState        contentv1.ScriptLifecycleState
	ApprovalState         contentv1.ScriptApprovalState
	SnapshotReason        string
	CreatedBy             string
	CreatedAt             time.Time
}

// StoredApprovalRequest represents an operational approval record (§18.1).
type StoredApprovalRequest struct {
	RequestID       string
	WorkspaceID     string
	RequestType     string
	ObjectType      string
	ObjectID        string
	RequestedBy     string
	ApprovedBy      string
	Status          string
	Reason          string
	RejectionReason string
	ExpiresAt       *time.Time
	CreatedAt       time.Time
	UpdatedAt       time.Time
}

// StoredComment represents inline feedback.
type StoredComment struct {
	CommentID  string
	ScriptID   string
	UserID     string
	AuthorName string
	Content    string
	SceneIndex int32
	IsResolved bool
	CreatedAt  time.Time
}

// StoredScript represents the canonical script entity (§6.4).
type StoredScript struct {
	ScriptID              string
	WorkspaceID           string
	IdeaID                string
	SourceIdeaTitle       string
	Title                 string
	FormatType            string
	Scenes                []StoredScene
	CtaBlocks             []StoredCtaBlock
	DisclosureBlocks      []StoredDisclosureBlock
	DurationTargetSeconds int32
	LifecycleState        contentv1.ScriptLifecycleState
	ApprovalState         contentv1.ScriptApprovalState
	PublishTargetProfiles []StoredPublishTargetProfile
	ContinuityRefs        []string
	OfferProductHooks     []string
	RejectionReason       string
	VersionIndex          int32
	CreatedBy             string
	ApprovedBy            string
	CreatedAt             time.Time
	UpdatedAt             time.Time
	DeletedAt             *time.Time
}

// DomainEventRecord captures emitted events for verification.
type DomainEventRecord struct {
	EventType string
	ScriptID  string
	Payload   map[string]any
	EmittedAt time.Time
}

// --- Validation Helpers ---

// ValidateScenesForSubmission ensures ≥1 scene exists and all have non-empty content (EC-M06-001).
func ValidateScenesForSubmission(scenes []StoredScene) error {
	if len(scenes) == 0 {
		return ErrNoScenesBlockSubmission
	}
	for _, scene := range scenes {
		if strings.TrimSpace(scene.Content) == "" {
			return ErrEmptyScenesBlockSubmission
		}
	}
	return nil
}

// ValidateRejectionReason enforces ≥10 characters requirement (RULE-M06-002, EC-M06-002).
func ValidateRejectionReason(reason string) error {
	trimmed := strings.TrimSpace(reason)
	if len(trimmed) < 10 {
		return ErrRejectionReasonRequired
	}
	return nil
}

// IsAssetBriefComplete verifies that the Asset Brief has all required fields populated (RULE-M06-005).
func IsAssetBriefComplete(brief *StoredAssetBrief) bool {
	if brief == nil {
		return false
	}
	if strings.TrimSpace(brief.OutputType) == "" {
		return false
	}
	if strings.TrimSpace(brief.TargetFormat) == "" {
		return false
	}
	if brief.TargetDurationSeconds <= 0 {
		return false
	}
	if strings.TrimSpace(brief.ContinuityRequirementsJSON) == "" || brief.ContinuityRequirementsJSON == "{}" {
		return false
	}
	return true
}

// --- Protobuf Conversion Helpers ---

func (s *StoredScript) ToProto() *contentv1.Script {
	if s == nil {
		return nil
	}
	protoScenes := make([]*contentv1.Scene, len(s.Scenes))
	for i, sc := range s.Scenes {
		protoShots := make([]*contentv1.Shot, len(sc.ShotList))
		for j, sh := range sc.ShotList {
			protoShots[j] = &contentv1.Shot{
				ShotId:          sh.ShotID,
				SceneId:         sh.SceneID,
				WorkspaceId:     sh.WorkspaceID,
				ShotIndex:       sh.ShotIndex,
				ShotType:        sh.ShotType,
				Description:     sh.Description,
				DurationSeconds: sh.DurationSeconds,
				CreatedAt:       timestamppb.New(sh.CreatedAt),
			}
		}
		protoScenes[i] = &contentv1.Scene{
			SceneId:         sc.SceneID,
			ScriptId:        sc.ScriptID,
			WorkspaceId:     sc.WorkspaceID,
			SceneIndex:      sc.SceneIndex,
			Description:     sc.Description,
			Content:         sc.Content,
			DurationSeconds: sc.DurationSeconds,
			VisualNotes:     sc.VisualNotes,
			AudioNotes:      sc.AudioNotes,
			ShotList:        protoShots,
			CreatedAt:       timestamppb.New(sc.CreatedAt),
		}
	}

	protoCta := make([]*contentv1.CtaBlock, len(s.CtaBlocks))
	for i, c := range s.CtaBlocks {
		protoCta[i] = &contentv1.CtaBlock{
			CtaId:          c.CtaID,
			Text:           c.Text,
			ButtonText:     c.ButtonText,
			DestinationUrl: c.DestinationURL,
			CtaType:        c.CtaType,
		}
	}

	protoDisc := make([]*contentv1.DisclosureBlock, len(s.DisclosureBlocks))
	for i, d := range s.DisclosureBlocks {
		var dismissedAt *timestamppb.Timestamp
		if d.DismissedAt != nil {
			dismissedAt = timestamppb.New(*d.DismissedAt)
		}
		protoDisc[i] = &contentv1.DisclosureBlock{
			DisclosureId:    d.DisclosureID,
			Text:            d.Text,
			Platform:        d.Platform,
			IsDismissed:     d.IsDismissed,
			DismissedBy:     d.DismissedBy,
			DismissedAt:     dismissedAt,
			DismissalReason: d.DismissalReason,
		}
	}

	protoProfiles := make([]*contentv1.PublishTargetProfile, len(s.PublishTargetProfiles))
	for i, p := range s.PublishTargetProfiles {
		protoProfiles[i] = &contentv1.PublishTargetProfile{
			Platform:  p.Platform,
			Format:    p.Format,
			AccountId: p.AccountID,
		}
	}

	return &contentv1.Script{
		ScriptId:              s.ScriptID,
		WorkspaceId:           s.WorkspaceID,
		IdeaId:                s.IdeaID,
		SourceIdeaTitle:       s.SourceIdeaTitle,
		Title:                 s.Title,
		FormatType:            s.FormatType,
		Scenes:                protoScenes,
		CtaBlocks:             protoCta,
		DisclosureBlocks:      protoDisc,
		DurationTargetSeconds: s.DurationTargetSeconds,
		LifecycleState:        s.LifecycleState,
		ApprovalState:         s.ApprovalState,
		PublishTargetProfiles: protoProfiles,
		ContinuityRefs:        s.ContinuityRefs,
		OfferProductHooks:     s.OfferProductHooks,
		RejectionReason:       s.RejectionReason,
		VersionIndex:          s.VersionIndex,
		CreatedBy:             s.CreatedBy,
		ApprovedBy:            s.ApprovedBy,
		CreatedAt:             timestamppb.New(s.CreatedAt),
		UpdatedAt:             timestamppb.New(s.UpdatedAt),
	}
}

func (b *StoredAssetBrief) ToProto() *contentv1.AssetBrief {
	if b == nil {
		return nil
	}
	return &contentv1.AssetBrief{
		AssetBriefId:               b.AssetBriefID,
		WorkspaceId:                b.WorkspaceID,
		ScriptId:                   b.ScriptID,
		OutputType:                 b.OutputType,
		TargetFormat:               b.TargetFormat,
		TargetDurationSeconds:      b.TargetDurationSeconds,
		TargetPlatforms:            b.TargetPlatforms,
		ContinuityRequirementsJson: b.ContinuityRequirementsJSON,
		BrandVoiceRequirementsJson: b.BrandVoiceRequirementsJSON,
		ProductionInstructions:     b.ProductionInstructions,
		Status:                     b.Status,
		CreatedAt:                  timestamppb.New(b.CreatedAt),
		UpdatedAt:                  timestamppb.New(b.UpdatedAt),
	}
}

func (v *StoredScriptVersion) ToProto() *contentv1.ScriptVersion {
	if v == nil {
		return nil
	}
	protoScenes := make([]*contentv1.Scene, len(v.Scenes))
	for i, sc := range v.Scenes {
		protoScenes[i] = &contentv1.Scene{
			SceneId:         sc.SceneID,
			ScriptId:        sc.ScriptID,
			WorkspaceId:     sc.WorkspaceID,
			SceneIndex:      sc.SceneIndex,
			Description:     sc.Description,
			Content:         sc.Content,
			DurationSeconds: sc.DurationSeconds,
			VisualNotes:     sc.VisualNotes,
			AudioNotes:      sc.AudioNotes,
			CreatedAt:       timestamppb.New(sc.CreatedAt),
		}
	}
	protoCta := make([]*contentv1.CtaBlock, len(v.CtaBlocks))
	for i, c := range v.CtaBlocks {
		protoCta[i] = &contentv1.CtaBlock{
			CtaId:          c.CtaID,
			Text:           c.Text,
			ButtonText:     c.ButtonText,
			DestinationUrl: c.DestinationURL,
			CtaType:        c.CtaType,
		}
	}
	protoDisc := make([]*contentv1.DisclosureBlock, len(v.DisclosureBlocks))
	for i, d := range v.DisclosureBlocks {
		var dismissedAt *timestamppb.Timestamp
		if d.DismissedAt != nil {
			dismissedAt = timestamppb.New(*d.DismissedAt)
		}
		protoDisc[i] = &contentv1.DisclosureBlock{
			DisclosureId:    d.DisclosureID,
			Text:            d.Text,
			Platform:        d.Platform,
			IsDismissed:     d.IsDismissed,
			DismissedBy:     d.DismissedBy,
			DismissedAt:     dismissedAt,
			DismissalReason: d.DismissalReason,
		}
	}
	return &contentv1.ScriptVersion{
		VersionId:             v.VersionID,
		WorkspaceId:           v.WorkspaceID,
		ScriptId:              v.ScriptID,
		VersionIndex:          v.VersionIndex,
		Title:                 v.Title,
		Scenes:                protoScenes,
		CtaBlocks:             protoCta,
		DisclosureBlocks:      protoDisc,
		DurationTargetSeconds: v.DurationTargetSeconds,
		LifecycleState:        v.LifecycleState,
		ApprovalState:         v.ApprovalState,
		SnapshotReason:        v.SnapshotReason,
		CreatedBy:             v.CreatedBy,
		CreatedAt:             timestamppb.New(v.CreatedAt),
	}
}
