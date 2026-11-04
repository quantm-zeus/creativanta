package help

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"time"
)

var (
	ErrSupportTicketNotFound = errors.New("help: support ticket not found")
	ErrSupportUnauthorized   = errors.New("help: unauthorized access to support ticket")
	ErrInternalNoteForbidden = errors.New("help: internal notes are restricted to internal support admins")
	ErrInvalidCSATScore      = errors.New("help: CSAT satisfaction score must be between 1 and 5")
)

// SupportTicket models support_tickets (§17.8, legal_compliance.md §7).
type SupportTicket struct {
	TicketID            string         `json:"ticket_id"`
	WorkspaceID         string         `json:"workspace_id"`
	UserID              string         `json:"user_id"`
	TicketNumber        string         `json:"ticket_number"` // e.g. "TK-0001"
	Subject             string         `json:"subject"`
	Priority            string         `json:"priority"` // urgent, high, normal, low
	Status              string         `json:"status"`   // open, in_progress, awaiting_user, escalated, resolved, closed
	Category            string         `json:"category"` // billing, technical, account, content, feature_request
	AssignedAdminID     string         `json:"assigned_admin_id,omitempty"`
	PlanTier            string         `json:"plan_tier"` // free, starter, pro, business, enterprise
	SLAResponseDueAt    time.Time      `json:"sla_response_due_at"`
	SLAResolutionDueAt  time.Time      `json:"sla_resolution_due_at"`
	FirstRespondedAt    *time.Time     `json:"first_responded_at,omitempty"`
	ResolvedAt          *time.Time     `json:"resolved_at,omitempty"`
	IsSLABreached       bool           `json:"is_sla_breached"`
	BreachReason        string         `json:"breach_reason,omitempty"`
	EscalationLevel     string         `json:"escalation_level"` // L0, L1, L2, L3, L4
	CSATScore           int32          `json:"csat_score,omitempty"`
	CSATComment         string         `json:"csat_comment,omitempty"`
	AutoCapturedContext map[string]any `json:"auto_captured_context"`
	CreatedAt           time.Time      `json:"created_at"`
	UpdatedAt           time.Time      `json:"updated_at"`
}

// SupportMessage models support_ticket_messages (§17.9).
type SupportMessage struct {
	MessageID      string    `json:"message_id"`
	WorkspaceID    string    `json:"workspace_id"`
	TicketID       string    `json:"ticket_id"`
	AuthorType     string    `json:"author_type"` // user, admin, ai_bot, system
	AuthorID       string    `json:"author_id"`
	Body           string    `json:"body"`
	Attachments    []string  `json:"attachments"`
	IsInternalNote bool      `json:"is_internal_note"` // only visible to admins!
	CreatedAt      time.Time `json:"created_at"`
}

// SLABreachReport models SLA breach detection results.
type SLABreachReport struct {
	TicketID     string    `json:"ticket_id"`
	TicketNumber string    `json:"ticket_number"`
	PlanTier     string    `json:"plan_tier"`
	BreachType   string    `json:"breach_type"` // "first_response_breach", "resolution_breach"
	DueAt        time.Time `json:"due_at"`
	DetectedAt   time.Time `json:"detected_at"`
}

// ComputeTicketSLA calculates SLA deadlines based on plan tier per legal_compliance.md §7.2.
// Plan rules:
// - Free: 48h first response, 5 days (120h) resolution.
// - Starter: 24h first response, 3 days (72h) resolution.
// - Pro: 8h first response, 1 day (24h) resolution.
// - Business: 2h first response, 8h resolution.
// - Enterprise: 1h first response, 4h resolution.
func ComputeTicketSLA(planTier string, createdAt time.Time) (responseDue, resolutionDue time.Time) {
	switch strings.ToLower(strings.TrimSpace(planTier)) {
	case "enterprise":
		responseDue = createdAt.Add(1 * time.Hour)
		resolutionDue = createdAt.Add(4 * time.Hour)
	case "business":
		responseDue = createdAt.Add(2 * time.Hour)
		resolutionDue = createdAt.Add(8 * time.Hour)
	case "pro":
		responseDue = createdAt.Add(8 * time.Hour)
		resolutionDue = createdAt.Add(24 * time.Hour)
	case "starter":
		responseDue = createdAt.Add(24 * time.Hour)
		resolutionDue = createdAt.Add(72 * time.Hour)
	default: // Free / unassigned
		responseDue = createdAt.Add(48 * time.Hour)
		resolutionDue = createdAt.Add(120 * time.Hour)
	}
	return
}

// CreateSupportTicket creates a ticket with automated SLA deadlines per workspace tier.
func (s *Service) CreateSupportTicket(
	ctx context.Context,
	workspaceID, userID, planTier, subject, priority, category, initialMessage string,
	autoContext map[string]any,
) (*SupportTicket, *SupportMessage, error) {
	if strings.TrimSpace(workspaceID) == "" || strings.TrimSpace(userID) == "" || strings.TrimSpace(subject) == "" {
		return nil, nil, ErrInvalidInput
	}

	s.store.mu.Lock()
	defer s.store.mu.Unlock()

	now := time.Now().UTC()
	respDue, resDue := ComputeTicketSLA(planTier, now)

	ticketID := generateUUID()
	ticketNum := fmt.Sprintf("TK-%04d", len(s.store.supportTickets)+1)

	prio := strings.ToLower(strings.TrimSpace(priority))
	if prio == "" {
		prio = "normal"
	}
	cat := strings.ToLower(strings.TrimSpace(category))
	if cat == "" {
		cat = "technical"
	}

	ticket := &SupportTicket{
		TicketID:            ticketID,
		WorkspaceID:         workspaceID,
		UserID:              userID,
		TicketNumber:        ticketNum,
		Subject:             strings.TrimSpace(subject),
		Priority:            prio,
		Status:              "open",
		Category:            cat,
		PlanTier:            strings.ToLower(strings.TrimSpace(planTier)),
		SLAResponseDueAt:    respDue,
		SLAResolutionDueAt:  resDue,
		EscalationLevel:     "L0", // Initial chatbot/intake level (§7.3)
		AutoCapturedContext: autoContext,
		CreatedAt:           now,
		UpdatedAt:           now,
	}

	var firstMsg *SupportMessage
	if strings.TrimSpace(initialMessage) != "" {
		firstMsg = &SupportMessage{
			MessageID:      generateUUID(),
			WorkspaceID:    workspaceID,
			TicketID:       ticketID,
			AuthorType:     "user",
			AuthorID:       userID,
			Body:           strings.TrimSpace(initialMessage),
			IsInternalNote: false,
			CreatedAt:      now,
		}
		s.store.supportMessages[ticketID] = append(s.store.supportMessages[ticketID], firstMsg)
	}

	s.store.supportTickets[ticketID] = ticket
	return ticket, firstMsg, nil
}

// ReplySupportTicket adds a message to the support conversation.
// ENFORCES: Internal notes (isInternalNote=true) can ONLY be authored by internal admin callers.
func (s *Service) ReplySupportTicket(
	ctx context.Context,
	ticketID, workspaceID, authorType, authorID, body string,
	isInternalNote bool,
	isInternalAdmin bool,
) (*SupportMessage, error) {
	if strings.TrimSpace(body) == "" {
		return nil, ErrInvalidInput
	}
	if isInternalNote && !isInternalAdmin {
		return nil, ErrInternalNoteForbidden
	}

	s.store.mu.Lock()
	defer s.store.mu.Unlock()

	ticket, exists := s.store.supportTickets[ticketID]
	if !exists {
		return nil, ErrSupportTicketNotFound
	}
	if !isInternalAdmin && ticket.WorkspaceID != workspaceID {
		return nil, ErrSupportTicketNotFound
	}

	now := time.Now().UTC()
	msg := &SupportMessage{
		MessageID:      generateUUID(),
		WorkspaceID:    ticket.WorkspaceID,
		TicketID:       ticketID,
		AuthorType:     authorType,
		AuthorID:       authorID,
		Body:           strings.TrimSpace(body),
		IsInternalNote: isInternalNote,
		CreatedAt:      now,
	}

	// If this is the first response by an admin / agent, record first_responded_at
	if authorType == "admin" && ticket.FirstRespondedAt == nil && !isInternalNote {
		ticket.FirstRespondedAt = &now
		if ticket.Status == "open" {
			ticket.Status = "in_progress"
		}
	}

	ticket.UpdatedAt = now
	s.store.supportMessages[ticketID] = append(s.store.supportMessages[ticketID], msg)
	return msg, nil
}

// GetSupportTicket returns ticket details and messages.
// ACCEPTANCE CRITICAL: Internal note isolation
// When called by a workspace caller (isInternalAdmin = false), internal notes are strictly filtered out.
func (s *Service) GetSupportTicket(
	ctx context.Context,
	ticketID, workspaceID string,
	isInternalAdmin bool,
) (*SupportTicket, []*SupportMessage, error) {
	s.store.mu.RLock()
	defer s.store.mu.RUnlock()

	ticket, exists := s.store.supportTickets[ticketID]
	if !exists {
		return nil, nil, ErrSupportTicketNotFound
	}
	if !isInternalAdmin && ticket.WorkspaceID != workspaceID {
		return nil, nil, ErrSupportTicketNotFound
	}

	allMsgs := s.store.supportMessages[ticketID]
	var safeMsgs []*SupportMessage

	for _, m := range allMsgs {
		if !isInternalAdmin && m.IsInternalNote {
			// Strip internal admin notes from creator/workspace user view!
			continue
		}
		cp := *m
		safeMsgs = append(safeMsgs, &cp)
	}

	cpTicket := *ticket
	return &cpTicket, safeMsgs, nil
}

// CheckSLABreaches scans tickets and flags SLA breaches per legal_compliance.md §7.2.
func (s *Service) CheckSLABreaches(now time.Time) []SLABreachReport {
	s.store.mu.Lock()
	defer s.store.mu.Unlock()

	var breaches []SLABreachReport

	for _, ticket := range s.store.supportTickets {
		if ticket.Status == "resolved" || ticket.Status == "closed" {
			continue
		}

		// 1. Check First Response SLA
		if ticket.FirstRespondedAt == nil && now.After(ticket.SLAResponseDueAt) {
			ticket.IsSLABreached = true
			ticket.BreachReason = fmt.Sprintf("First response SLA breached (%s due at %s)", ticket.PlanTier, ticket.SLAResponseDueAt.Format(time.RFC3339))
			breaches = append(breaches, SLABreachReport{
				TicketID:     ticket.TicketID,
				TicketNumber: ticket.TicketNumber,
				PlanTier:     ticket.PlanTier,
				BreachType:   "first_response_breach",
				DueAt:        ticket.SLAResponseDueAt,
				DetectedAt:   now,
			})
		}

		// 2. Check Resolution SLA
		if now.After(ticket.SLAResolutionDueAt) {
			ticket.IsSLABreached = true
			ticket.BreachReason = fmt.Sprintf("Resolution SLA breached (%s due at %s)", ticket.PlanTier, ticket.SLAResolutionDueAt.Format(time.RFC3339))
			breaches = append(breaches, SLABreachReport{
				TicketID:     ticket.TicketID,
				TicketNumber: ticket.TicketNumber,
				PlanTier:     ticket.PlanTier,
				BreachType:   "resolution_breach",
				DueAt:        ticket.SLAResolutionDueAt,
				DetectedAt:   now,
			})
		}
	}

	return breaches
}

// EscalateSupportTicket escalates a support ticket along canonical escalation paths (§7.3).
// Levels: L0 (AI) -> L1 (Agent) -> L2 (Senior) -> L3 (Engineering) -> L4 (Management)
func (s *Service) EscalateSupportTicket(
	ctx context.Context,
	ticketID, targetLevel, reason, adminID string,
) (*SupportTicket, error) {
	lvl := strings.ToUpper(strings.TrimSpace(targetLevel))
	switch lvl {
	case "L1", "L2", "L3", "L4":
	default:
		return nil, fmt.Errorf("%w: invalid escalation level %s", ErrInvalidInput, targetLevel)
	}

	s.store.mu.Lock()
	defer s.store.mu.Unlock()

	ticket, exists := s.store.supportTickets[ticketID]
	if !exists {
		return nil, ErrSupportTicketNotFound
	}

	now := time.Now().UTC()
	ticket.EscalationLevel = lvl
	ticket.Status = "escalated"
	ticket.UpdatedAt = now

	// Append internal note logging the escalation
	s.store.supportMessages[ticketID] = append(s.store.supportMessages[ticketID], &SupportMessage{
		MessageID:      generateUUID(),
		WorkspaceID:    ticket.WorkspaceID,
		TicketID:       ticketID,
		AuthorType:     "admin",
		AuthorID:       adminID,
		Body:           fmt.Sprintf("[ESCALATION] Escalated to %s by admin %s. Reason: %s", lvl, adminID, reason),
		IsInternalNote: true,
		CreatedAt:      now,
	})

	cp := *ticket
	return &cp, nil
}

// CloseSupportTicket closes a support ticket and records customer satisfaction score (CSAT §7.1).
func (s *Service) CloseSupportTicket(
	ctx context.Context,
	ticketID, workspaceID string,
	csatScore int32,
	csatComment string,
	isInternalAdmin bool,
) (*SupportTicket, error) {
	if csatScore < 1 || csatScore > 5 {
		return nil, ErrInvalidCSATScore
	}

	s.store.mu.Lock()
	defer s.store.mu.Unlock()

	ticket, exists := s.store.supportTickets[ticketID]
	if !exists {
		return nil, ErrSupportTicketNotFound
	}
	if !isInternalAdmin && ticket.WorkspaceID != workspaceID {
		return nil, ErrSupportTicketNotFound
	}

	now := time.Now().UTC()
	ticket.Status = "closed"
	if ticket.ResolvedAt == nil {
		ticket.ResolvedAt = &now
	}
	ticket.CSATScore = csatScore
	ticket.CSATComment = strings.TrimSpace(csatComment)
	ticket.UpdatedAt = now

	cp := *ticket
	return &cp, nil
}
