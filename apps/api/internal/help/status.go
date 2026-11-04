package help

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"errors"
	"strings"
	"time"
)

var (
	ErrIncidentNotFound   = errors.New("help: incident not found")
	ErrSubscriberNotFound = errors.New("help: subscriber not found with provided privacy token")
	ErrInvalidSubscriber  = errors.New("help: invalid subscriber target or channel")
	ErrPrivacyViolation   = errors.New("help: unauthorized attempt to read subscriber privacy records")
)

// MonitoredComponent models the 8 monitored components from §5.1.
type MonitoredComponent struct {
	ComponentID      string    `json:"component_id"`
	Name             string    `json:"name"`
	CheckIntervalSec int       `json:"check_interval_sec"`
	Status           string    `json:"status"` // operational, degraded_performance, partial_outage, major_outage, under_maintenance
	LatencyMs        int       `json:"latency_ms"`
	LastCheckAt      time.Time `json:"last_check_at"`
	Description      string    `json:"description"`
}

// IncidentRecord models platform incidents (§5.2, §17.10).
type IncidentRecord struct {
	IncidentID         string            `json:"incident_id"`
	Title              string            `json:"title"`
	Severity           string            `json:"severity"` // P0_critical, P1_high, P2_medium, P3_low
	Status             string            `json:"status"`   // detected, investigating, mitigated, resolved, post_mortem
	AffectedServices   []string          `json:"affected_services"`
	Updates            []IncidentUpdate  `json:"updates"`
	DetectedAt         time.Time         `json:"detected_at"`
	InitialUpdateDueAt time.Time         `json:"initial_update_due_at"`
	OngoingUpdateDueAt time.Time         `json:"ongoing_update_due_at"`
	MitigatedAt        *time.Time        `json:"mitigated_at,omitempty"`
	ResolvedAt         *time.Time        `json:"resolved_at,omitempty"`
	PostMortem         *PostMortemRecord `json:"post_mortem,omitempty"`
}

// IncidentUpdate models updates within an incident communication timeline.
type IncidentUpdate struct {
	UpdateID  string    `json:"update_id"`
	Status    string    `json:"status"`
	Message   string    `json:"message"`
	CreatedAt time.Time `json:"created_at"`
}

// PostMortemRecord models post-mortem reports (§5.2, §17.10).
type PostMortemRecord struct {
	PostMortemID string     `json:"post_mortem_id"`
	IncidentID   string     `json:"incident_id"`
	Summary      string     `json:"summary"`
	RootCause    string     `json:"root_cause"`
	ActionItems  []string   `json:"action_items"`
	DueAt        time.Time  `json:"due_at"`
	PublishedAt  *time.Time `json:"published_at,omitempty"`
	Published    bool       `json:"published"`
}

// StatusSubscriberRecord models status_subscribers (§5.4).
// Internal to the store; NEVER exposed directly on public status endpoints.
type StatusSubscriberRecord struct {
	SubscriberID     string
	Channel          string // "email", "webhook", "rss"
	Target           string // email or webhook URL
	PrivacyTokenHash string // SHA-256 hash of private management token
	Status           string // "active", "unsubscribed"
	ComponentFilter  []string
	CreatedAt        time.Time
	UnsubscribedAt   *time.Time
}

// PublicStatusResponse models the public-facing status response (§5, W097).
// PRIVACY INVARIANT: NEVER contains subscriber emails or contact information!
type PublicStatusResponse struct {
	OverallStatus         string               `json:"overall_status"`
	Components            []MonitoredComponent `json:"components"`
	ActiveIncidents       []IncidentRecord     `json:"active_incidents"`
	RecentIncidents       []IncidentRecord     `json:"recent_incidents"`
	TotalSubscribersCount int                  `json:"total_subscribers_count"` // Anonymized count only!
	LastUpdatedAt         time.Time            `json:"last_updated_at"`
}

// IncidentNotificationDispatch models the dispatch record for audit and delivery verification.
type IncidentNotificationDispatch struct {
	DispatchID     string    `json:"dispatch_id"`
	IncidentID     string    `json:"incident_id"`
	Severity       string    `json:"severity"`
	Message        string    `json:"message"`
	DispatchedAt   time.Time `json:"dispatched_at"`
	RecipientCount int       `json:"recipient_count"`
	Channels       []string  `json:"channels"`
}

// SubscribeStatusResult is returned when a user subscribes.
type SubscribeStatusResult struct {
	SubscriberID string `json:"subscriber_id"`
	PrivacyToken string `json:"privacy_token"` // Secret token returned ONLY ONCE upon subscription
	Channel      string `json:"channel"`
	Status       string `json:"status"`
}

func hashPrivacyToken(token string) string {
	h := sha256.Sum256([]byte(token))
	return hex.EncodeToString(h[:])
}

// ComputeIncidentSLAs calculates communication deadlines per §5.2.
// - P0 (Critical): initial update within 15 min, ongoing every 30 min, post-mortem within 48 hours.
// - P1 (Major): initial update within 30 min, ongoing every 1 hour, post-mortem within 5 days.
// - P2 (Minor): initial update within 4 hours, ongoing end-of-day.
func ComputeIncidentSLAs(severity string, detectedAt time.Time) (initialDue, ongoingDue, postMortemDue time.Time) {
	s := strings.ToUpper(strings.TrimSpace(severity))
	switch s {
	case "P0", "P0_CRITICAL":
		initialDue = detectedAt.Add(15 * time.Minute)
		ongoingDue = detectedAt.Add(30 * time.Minute)
		postMortemDue = detectedAt.Add(48 * time.Hour)
	case "P1", "P1_HIGH":
		initialDue = detectedAt.Add(30 * time.Minute)
		ongoingDue = detectedAt.Add(60 * time.Minute)
		postMortemDue = detectedAt.Add(5 * 24 * time.Hour)
	case "P2", "P2_MEDIUM":
		initialDue = detectedAt.Add(4 * time.Hour)
		ongoingDue = detectedAt.Add(12 * time.Hour)
		postMortemDue = detectedAt.Add(7 * 24 * time.Hour)
	default:
		initialDue = detectedAt.Add(12 * time.Hour)
		ongoingDue = detectedAt.Add(24 * time.Hour)
		postMortemDue = detectedAt.Add(14 * 24 * time.Hour)
	}
	return
}

// CreateIncident creates a new incident and initializes communication SLAs (§5.2).
func (s *Service) CreateIncident(
	ctx context.Context,
	title, severity string,
	affectedServices []string,
	initialMessage string,
) (*IncidentRecord, error) {
	if strings.TrimSpace(title) == "" || len(affectedServices) == 0 {
		return nil, ErrInvalidInput
	}

	s.store.mu.Lock()
	defer s.store.mu.Unlock()

	now := time.Now().UTC()
	initDue, ongoingDue, _ := ComputeIncidentSLAs(severity, now)

	incID := generateUUID()
	inc := &IncidentRecord{
		IncidentID:         incID,
		Title:              title,
		Severity:           severity,
		Status:             "investigating",
		AffectedServices:   affectedServices,
		DetectedAt:         now,
		InitialUpdateDueAt: initDue,
		OngoingUpdateDueAt: ongoingDue,
		Updates: []IncidentUpdate{
			{
				UpdateID:  generateUUID(),
				Status:    "investigating",
				Message:   initialMessage,
				CreatedAt: now,
			},
		},
	}

	// Update monitored component statuses
	for _, compID := range affectedServices {
		if comp, exists := s.store.statusComponents[compID]; exists {
			if strings.HasPrefix(strings.ToUpper(severity), "P0") {
				comp.Status = "major_outage"
			} else {
				comp.Status = "partial_outage"
			}
			comp.LastCheckAt = now
		}
	}

	s.store.statusIncidents[incID] = inc
	return inc, nil
}

// UpdateIncident adds an ongoing update to an incident and recalculates ongoing due time (§5.2).
func (s *Service) UpdateIncident(
	ctx context.Context,
	incidentID, status, message string,
) (*IncidentRecord, error) {
	s.store.mu.Lock()
	defer s.store.mu.Unlock()

	inc, exists := s.store.statusIncidents[incidentID]
	if !exists {
		return nil, ErrIncidentNotFound
	}

	now := time.Now().UTC()
	inc.Status = status
	inc.Updates = append(inc.Updates, IncidentUpdate{
		UpdateID:  generateUUID(),
		Status:    status,
		Message:   message,
		CreatedAt: now,
	})

	_, ongoingInterval, _ := ComputeIncidentSLAs(inc.Severity, now)
	inc.OngoingUpdateDueAt = ongoingInterval

	if status == "mitigated" {
		inc.MitigatedAt = &now
		for _, compID := range inc.AffectedServices {
			if comp, ok := s.store.statusComponents[compID]; ok {
				comp.Status = "degraded_performance"
			}
		}
	} else if status == "resolved" {
		inc.ResolvedAt = &now
		for _, compID := range inc.AffectedServices {
			if comp, ok := s.store.statusComponents[compID]; ok {
				comp.Status = "operational"
			}
		}
	}

	return inc, nil
}

// GetPublicStatus returns the current status page data.
// ACCEPTANCE TARGET 3: "subscription privacy"
// Invariant: The response contains component statuses, incident status, and anonymized subscriber counts.
// NO subscriber emails, webhook URLs, or subscriber identities are included in the returned payload.
func (s *Service) GetPublicStatus(ctx context.Context) (*PublicStatusResponse, error) {
	s.store.mu.RLock()
	defer s.store.mu.RUnlock()

	var components []MonitoredComponent
	overall := "operational"

	for _, c := range s.store.statusComponents {
		components = append(components, *c)
		if c.Status == "major_outage" {
			overall = "major_outage"
		} else if c.Status == "partial_outage" && overall != "major_outage" {
			overall = "partial_outage"
		} else if c.Status == "degraded_performance" && overall == "operational" {
			overall = "degraded_performance"
		}
	}

	var active []IncidentRecord
	var recent []IncidentRecord

	for _, inc := range s.store.statusIncidents {
		if inc.Status != "resolved" {
			active = append(active, *inc)
		} else {
			recent = append(recent, *inc)
		}
	}

	// Count active subscribers (anonymized integer only, no personal data)
	subCount := 0
	for _, sub := range s.store.statusSubscribers {
		if sub.Status == "active" {
			subCount++
		}
	}

	return &PublicStatusResponse{
		OverallStatus:         overall,
		Components:            components,
		ActiveIncidents:       active,
		RecentIncidents:       recent,
		TotalSubscribersCount: subCount,
		LastUpdatedAt:         time.Now().UTC(),
	}, nil
}

// SubscribeStatus registers a new subscriber for status updates (§5.4).
// Generates a secret privacy management token.
func (s *Service) SubscribeStatus(
	ctx context.Context,
	channel, target string,
	componentFilter []string,
) (*SubscribeStatusResult, error) {
	ch := strings.ToLower(strings.TrimSpace(channel))
	if ch != "email" && ch != "webhook" && ch != "rss" {
		return nil, ErrInvalidSubscriber
	}
	tgt := strings.TrimSpace(target)
	if tgt == "" && ch != "rss" {
		return nil, ErrInvalidSubscriber
	}

	s.store.mu.Lock()
	defer s.store.mu.Unlock()

	subID := generateUUID()
	privacyToken := generateUUID() + "-" + generateUUID()
	tokenHash := hashPrivacyToken(privacyToken)

	sub := &StatusSubscriberRecord{
		SubscriberID:     subID,
		Channel:          ch,
		Target:           tgt,
		PrivacyTokenHash: tokenHash,
		Status:           "active",
		ComponentFilter:  componentFilter,
		CreatedAt:        time.Now().UTC(),
	}

	s.store.statusSubscribers[subID] = sub

	return &SubscribeStatusResult{
		SubscriberID: subID,
		PrivacyToken: privacyToken,
		Channel:      ch,
		Status:       "active",
	}, nil
}

// UnsubscribeStatus unregisters a subscriber using their private token.
// Ensures subscription privacy: only the holder of the unhashed secret token can unsubscribe.
func (s *Service) UnsubscribeStatus(
	ctx context.Context,
	privacyToken string,
) (bool, error) {
	if strings.TrimSpace(privacyToken) == "" {
		return false, ErrInvalidInput
	}

	tokenHash := hashPrivacyToken(privacyToken)

	s.store.mu.Lock()
	defer s.store.mu.Unlock()

	for _, sub := range s.store.statusSubscribers {
		if sub.PrivacyTokenHash == tokenHash && sub.Status == "active" {
			now := time.Now().UTC()
			sub.Status = "unsubscribed"
			sub.UnsubscribedAt = &now
			return true, nil
		}
	}

	return false, ErrSubscriberNotFound
}

// DispatchIncidentNotification dispatches incident communications to subscribers (§5.2, §5.4).
// Dispatches without exposing subscriber details across consumers.
func (s *Service) DispatchIncidentNotification(
	ctx context.Context,
	incidentID, message, severity string,
) (*IncidentNotificationDispatch, error) {
	s.store.mu.Lock()
	defer s.store.mu.Unlock()

	inc, exists := s.store.statusIncidents[incidentID]
	if !exists {
		return nil, ErrIncidentNotFound
	}

	recipients := 0
	var channels []string
	channelSeen := make(map[string]bool)

	for _, sub := range s.store.statusSubscribers {
		if sub.Status != "active" {
			continue
		}
		// Match component filter if set
		if len(sub.ComponentFilter) > 0 {
			matched := false
			for _, ac := range inc.AffectedServices {
				for _, sc := range sub.ComponentFilter {
					if ac == sc {
						matched = true
						break
					}
				}
			}
			if !matched {
				continue
			}
		}

		recipients++
		if !channelSeen[sub.Channel] {
			channels = append(channels, sub.Channel)
			channelSeen[sub.Channel] = true
		}
	}

	dispatch := &IncidentNotificationDispatch{
		DispatchID:     generateUUID(),
		IncidentID:     incidentID,
		Severity:       severity,
		Message:        message,
		DispatchedAt:   time.Now().UTC(),
		RecipientCount: recipients,
		Channels:       channels,
	}

	s.store.incidentDispatches = append(s.store.incidentDispatches, dispatch)
	return dispatch, nil
}
