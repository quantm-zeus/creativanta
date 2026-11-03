package copilot

import (
	"context"
	"errors"
	"time"

	copilotv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/copilot/v1"
	"google.golang.org/protobuf/types/known/timestamppb"
)

var (
	ErrUnauthenticated          = errors.New("copilot: unauthenticated caller")
	ErrCrossTenantDenied        = errors.New("copilot: cross-tenant access strictly forbidden")
	ErrPermissionDenied         = errors.New("copilot: permission denied")
	ErrSessionNotFound          = errors.New("copilot: session not found")
	ErrQueryRequired            = errors.New("copilot: query text is required")
	ErrQuoteNotFound            = errors.New("copilot: quote not found or expired")
	ErrQuoteExpired             = errors.New("copilot: quote has expired. Please request a new quote")
	ErrQuoteAlreadyConsumed     = errors.New("copilot: quote has already been consumed")
	ErrActionNotConfirmed       = errors.New("copilot: action requires explicit quote confirmation before execution")
	ErrProductDeletionForbidden = errors.New("copilot: Bạn không có quyền xóa sản phẩm. Cần Admin+ role (product:delete).")
	ErrFinancialAccessDenied    = errors.New("copilot: Bạn không có quyền truy cập dữ liệu tài chính của workspace.")
)

// CallerContext represents authenticated caller identity and workspace tenant.
type CallerContext struct {
	UserID        string
	WorkspaceID   string
	WorkspaceRole string
}

type callerCtxKey struct{}

// WithCallerContext binds a CallerContext into a context.Context.
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

// StoredActionQuote tracks an AI credit quote preview.
type StoredActionQuote struct {
	QuoteID         string
	WorkspaceID     string
	UserID          string
	OperationType   string
	QuotedCredits   int64
	CostCeilingUSD  string
	Status          string // "pending", "confirmed", "cancelled", "expired"
	ExpiresAt       time.Time
	CreatedAt       time.Time
	ActionPreview   string
	TargetScriptID  string
	GeneratedScript string
}

// StoredActionCard represents an executable action within a message.
type StoredActionCard struct {
	ActionID             string
	ActionType           string
	Title                string
	Description          string
	RequiredPermission   string
	RequiresConfirmation bool
	Quote                *StoredActionQuote
	Parameters           map[string]string
}

// StoredDataCard represents structured evidence, analytics, or finance data.
type StoredDataCard struct {
	CardID          string
	Title           string
	Summary         string
	IsFinancial     bool
	IsRedacted      bool
	RedactionReason string
	SourceBadges    []string
	Metrics         map[string]string
}

// StoredMessage represents a single conversational turn.
type StoredMessage struct {
	MessageID        string
	SessionID        string
	Role             string // "user", "assistant", "system"
	Content          string
	ActionCards      []StoredActionCard
	DataCards        []StoredDataCard
	PendingQuote     *StoredActionQuote
	PermissionDenied bool
	DenialReason     string
	CreatedAt        time.Time
}

// StoredSession represents a persistent Copilot session per database_schema.md §19.12.
type StoredSession struct {
	SessionID        string
	WorkspaceID      string
	UserID           string
	Mode             string // creative, analytics, action, video_production, help
	ContextScope     string
	Messages         []StoredMessage
	TotalCreditsUsed string // numeric string e.g. "0.000000"
	EndedAt          *time.Time
	CreatedAt        time.Time
	UpdatedAt        time.Time
}

// DomainEvent represents a domain event emitted per domain_event_catalog.md §15.
type DomainEvent struct {
	EventType   string
	WorkspaceID string
	Payload     map[string]any
	OccurredAt  time.Time
}

// Helper conversions between domain structs and proto types

func ProtoToMode(m copilotv1.CopilotMode) string {
	switch m {
	case copilotv1.CopilotMode_COPILOT_MODE_CREATIVE:
		return "creative"
	case copilotv1.CopilotMode_COPILOT_MODE_ANALYTICS:
		return "analytics"
	case copilotv1.CopilotMode_COPILOT_MODE_ACTION:
		return "action"
	case copilotv1.CopilotMode_COPILOT_MODE_VIDEO_PRODUCTION:
		return "video_production"
	case copilotv1.CopilotMode_COPILOT_MODE_HELP:
		return "help"
	default:
		return "help"
	}
}

func ModeToProto(m string) copilotv1.CopilotMode {
	switch m {
	case "creative":
		return copilotv1.CopilotMode_COPILOT_MODE_CREATIVE
	case "analytics":
		return copilotv1.CopilotMode_COPILOT_MODE_ANALYTICS
	case "action":
		return copilotv1.CopilotMode_COPILOT_MODE_ACTION
	case "video_production":
		return copilotv1.CopilotMode_COPILOT_MODE_VIDEO_PRODUCTION
	case "help":
		return copilotv1.CopilotMode_COPILOT_MODE_HELP
	default:
		return copilotv1.CopilotMode_COPILOT_MODE_UNSPECIFIED
	}
}

func QuoteToProto(q *StoredActionQuote) *copilotv1.ActionQuote {
	if q == nil {
		return nil
	}
	var st copilotv1.ActionQuoteStatus
	switch q.Status {
	case "pending":
		st = copilotv1.ActionQuoteStatus_ACTION_QUOTE_STATUS_PENDING
	case "confirmed":
		st = copilotv1.ActionQuoteStatus_ACTION_QUOTE_STATUS_CONFIRMED
	case "cancelled":
		st = copilotv1.ActionQuoteStatus_ACTION_QUOTE_STATUS_CANCELLED
	case "expired":
		st = copilotv1.ActionQuoteStatus_ACTION_QUOTE_STATUS_EXPIRED
	default:
		st = copilotv1.ActionQuoteStatus_ACTION_QUOTE_STATUS_UNSPECIFIED
	}
	return &copilotv1.ActionQuote{
		QuoteId:        q.QuoteID,
		WorkspaceId:    q.WorkspaceID,
		OperationType:  q.OperationType,
		QuotedCredits:  q.QuotedCredits,
		CostCeilingUsd: q.CostCeilingUSD,
		Status:         st,
		ExpiresAt:      timestamppb.New(q.ExpiresAt),
		CreatedAt:      timestamppb.New(q.CreatedAt),
		ActionPreview:  q.ActionPreview,
	}
}

func MessageToProto(m *StoredMessage) *copilotv1.CopilotMessage {
	if m == nil {
		return nil
	}
	msg := &copilotv1.CopilotMessage{
		MessageId:        m.MessageID,
		SessionId:        m.SessionID,
		Role:             m.Role,
		Content:          m.Content,
		PermissionDenied: m.PermissionDenied,
		DenialReason:     m.DenialReason,
		CreatedAt:        timestamppb.New(m.CreatedAt),
		PendingQuote:     QuoteToProto(m.PendingQuote),
	}
	for _, ac := range m.ActionCards {
		msg.ActionCards = append(msg.ActionCards, &copilotv1.ActionCard{
			ActionId:             ac.ActionID,
			ActionType:           ac.ActionType,
			Title:                ac.Title,
			Description:          ac.Description,
			RequiredPermission:   ac.RequiredPermission,
			RequiresConfirmation: ac.RequiresConfirmation,
			Quote:                QuoteToProto(ac.Quote),
			Parameters:           ac.Parameters,
		})
	}
	for _, dc := range m.DataCards {
		msg.DataCards = append(msg.DataCards, &copilotv1.DataCard{
			CardId:          dc.CardID,
			Title:           dc.Title,
			Summary:         dc.Summary,
			IsFinancial:     dc.IsFinancial,
			IsRedacted:      dc.IsRedacted,
			RedactionReason: dc.RedactionReason,
			SourceBadges:    dc.SourceBadges,
			Metrics:         dc.Metrics,
		})
	}
	return msg
}

func SessionToProto(s *StoredSession) *copilotv1.CopilotSession {
	if s == nil {
		return nil
	}
	protoSession := &copilotv1.CopilotSession{
		SessionId:        s.SessionID,
		WorkspaceId:      s.WorkspaceID,
		UserId:           s.UserID,
		Mode:             ModeToProto(s.Mode),
		ContextScope:     s.ContextScope,
		TotalCreditsUsed: s.TotalCreditsUsed,
		CreatedAt:        timestamppb.New(s.CreatedAt),
		UpdatedAt:        timestamppb.New(s.UpdatedAt),
	}
	if s.EndedAt != nil {
		protoSession.EndedAt = timestamppb.New(*s.EndedAt)
	}
	for i := range s.Messages {
		protoSession.Messages = append(protoSession.Messages, MessageToProto(&s.Messages[i]))
	}
	return protoSession
}
