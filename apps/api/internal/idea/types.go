package idea

import (
	"context"
	"errors"
	"math"
	"strings"
	"time"

	contentv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/content/v1"
	intelligencev1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/intelligence/v1"
)

var (
	ErrUnauthenticated            = errors.New("idea: unauthenticated caller")
	ErrCrossTenantDenied          = errors.New("idea: cross-tenant access strictly forbidden")
	ErrPermissionDenied           = errors.New("idea: permission denied")
	ErrIdeaNotFound               = errors.New("idea: requested idea not found")
	ErrTitleRequired              = errors.New("idea: title is required")
	ErrOrphanIdeaForbidden        = errors.New("idea: every idea must link back to at least one source ref (RULE-M05-001)")
	ErrInvalidStateTransition     = errors.New("idea: state transition violates canonical state machine (RULE-M05-002)")
	ErrConversionValidationFailed = errors.New("idea: idea needs at least a description and suggested format before converting to script (EC-M05-004)")
	ErrHourlyRateLimitExceeded    = errors.New("idea: rate limit exceeded: max 20 AI generations per hour per workspace (EC-M05-003)")
	ErrConcurrentConflict         = errors.New("idea: concurrent modification detected; please refresh and try again")
	ErrDuplicateIdeaWarning       = errors.New("idea: similar idea exists with embedding similarity > 0.85 (RULE-M05-005)")
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

// StoredIdeaSource represents a provenance link in table `idea_sources` (§6.2).
type StoredIdeaSource struct {
	SourceType    string // trend, opportunity, product, thread, comment_cluster, objection, offer, manual
	SourceID      string
	SourceTitle   string
	SourceURL     string
	IsArchived    bool
	ArchiveNotice string
}

// StoredHook represents a hook attached to an idea in table `hooks` (§6.3).
type StoredHook struct {
	HookID             string
	WorkspaceID        string
	IdeaID             string
	HookText           string
	HookType           contentv1.HookType
	EffectivenessScore float32
	UsageCount         int32
	Source             contentv1.HookSource
	CreatedAt          time.Time
	DeletedAt          *time.Time
}

// StoredIdea represents an idea in table `ideas` (§6.1).
type StoredIdea struct {
	IdeaID               string
	WorkspaceID          string
	Title                string
	Description          string
	AudienceIntent       string
	CreatorIntent        string
	SuggestedFormat      string
	SuggestedDirection   string
	Status               contentv1.IdeaStatus
	IdeaScore            float32
	ConvertedToType      string
	ConvertedToID        string
	CreatedBy            string
	Sources              []StoredIdeaSource
	Hooks                []StoredHook
	EmbeddingVector      []float32
	CreatedAt            time.Time
	UpdatedAt            time.Time
	DeletedAt            *time.Time
	SourceClass          intelligencev1.SourceClass
	Confidence           intelligencev1.ConfidenceBand
	RecommendedFormats   []string
	RecommendedPlatforms []string
	Angle                string
	HookSuggestion       string
}

// DuplicateMatch contains similarity scoring against existing ideas.
type DuplicateMatch struct {
	ExistingIdeaID    string
	ExistingIdeaTitle string
	SimilarityScore   float32
}

// DomainEvent models lightweight outbox events.
type DomainEvent struct {
	EventType   string
	WorkspaceID string
	Payload     map[string]any
	OccurredAt  time.Time
}

// ValidSourceTypes contains the canonical source types per RULE-M05-001.
var ValidSourceTypes = map[string]bool{
	"trend":           true,
	"opportunity":     true,
	"product":         true,
	"thread":          true,
	"comment_cluster": true,
	"objection":       true,
	"offer":           true,
	"manual":          true,
}

// ValidateStateTransition enforces canonical progression per RULE-M05-002:
// draft → candidate → selected → converted | archived; archived → draft.
func ValidateStateTransition(current, target contentv1.IdeaStatus) error {
	if current == target {
		return nil
	}

	switch current {
	case contentv1.IdeaStatus_IDEA_STATUS_DRAFT:
		if target == contentv1.IdeaStatus_IDEA_STATUS_CANDIDATE || target == contentv1.IdeaStatus_IDEA_STATUS_ARCHIVED {
			return nil
		}
	case contentv1.IdeaStatus_IDEA_STATUS_CANDIDATE:
		if target == contentv1.IdeaStatus_IDEA_STATUS_SELECTED || target == contentv1.IdeaStatus_IDEA_STATUS_ARCHIVED {
			return nil
		}
	case contentv1.IdeaStatus_IDEA_STATUS_SELECTED:
		if target == contentv1.IdeaStatus_IDEA_STATUS_CONVERTED || target == contentv1.IdeaStatus_IDEA_STATUS_ARCHIVED {
			return nil
		}
	case contentv1.IdeaStatus_IDEA_STATUS_ARCHIVED:
		if target == contentv1.IdeaStatus_IDEA_STATUS_DRAFT {
			return nil
		}
	case contentv1.IdeaStatus_IDEA_STATUS_CONVERTED:
		// Terminal converted state cannot be changed
		return ErrInvalidStateTransition
	}

	return ErrInvalidStateTransition
}

// CalculateCosineSimilarity computes the cosine similarity between two vector embeddings.
func CalculateCosineSimilarity(v1, v2 []float32) float32 {
	if len(v1) == 0 || len(v2) == 0 || len(v1) != len(v2) {
		return 0
	}
	var dotProduct, norm1, norm2 float64
	for i := 0; i < len(v1); i++ {
		dotProduct += float64(v1[i]) * float64(v2[i])
		norm1 += float64(v1[i]) * float64(v1[i])
		norm2 += float64(v2[i]) * float64(v2[i])
	}
	if norm1 == 0 || norm2 == 0 {
		return 0
	}
	sim := dotProduct / (math.Sqrt(norm1) * math.Sqrt(norm2))
	if sim > 1.0 {
		sim = 1.0
	} else if sim < -1.0 {
		sim = -1.0
	}
	return float32(sim)
}

// CalculateTextSimilarity computes lexical / semantic overlap between titles
// and provides a deterministic baseline similarity when vectors are synthetic.
func CalculateTextSimilarity(s1, s2 string) float32 {
	clean1 := strings.ToLower(strings.TrimSpace(s1))
	clean2 := strings.ToLower(strings.TrimSpace(s2))
	if clean1 == clean2 {
		return 1.0
	}
	if clean1 == "" || clean2 == "" {
		return 0.0
	}

	tokens1 := strings.Fields(clean1)
	tokens2 := strings.Fields(clean2)
	set1 := make(map[string]bool, len(tokens1))
	for _, t := range tokens1 {
		set1[t] = true
	}
	set2 := make(map[string]bool, len(tokens2))
	for _, t := range tokens2 {
		set2[t] = true
	}

	intersection := 0
	for t := range set1 {
		if set2[t] {
			intersection++
		}
	}
	union := len(set1) + len(set2) - intersection
	if union == 0 {
		return 0.0
	}

	jaccard := float32(intersection) / float32(union)

	// Check substring containment bonus (e.g. "skincare mùa hè" in "hướng dẫn skincare mùa hè")
	if strings.Contains(clean1, clean2) || strings.Contains(clean2, clean1) {
		if jaccard < 0.88 {
			jaccard = 0.88
		}
	}

	return jaccard
}
