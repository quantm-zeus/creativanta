// Package notification implements the scoped in-app, push, and email notification
// system per database_schema.md §13.5 and M23 Part A / reporting_admin_billing.md.
package notification

import (
	"context"
	"crypto/rand"
	"encoding/hex"
	"errors"
	"fmt"
	"sort"
	"strings"
	"sync"
	"time"

	"connectrpc.com/connect"
	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1/adminv1connect"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"google.golang.org/protobuf/types/known/timestamppb"
)

var (
	ErrUnauthenticated      = errors.New("notification: unauthenticated caller")
	ErrPermissionDenied     = errors.New("notification: permission denied for workspace or user")
	ErrInvalidInput         = errors.New("notification: invalid input parameters")
	ErrNotificationNotFound = errors.New("notification: item not found")
)

// ActorContext defines the authenticated user & workspace context.
type ActorContext struct {
	UserID        string
	WorkspaceID   string
	WorkspaceRole string
	IsAdmin       bool
}

type actorCtxKey struct{}

// WithActorContext attaches an ActorContext to ctx.
func WithActorContext(ctx context.Context, actor ActorContext) context.Context {
	return context.WithValue(ctx, actorCtxKey{}, actor)
}

// ActorFromContext extracts ActorContext from ctx.
func ActorFromContext(ctx context.Context) (ActorContext, bool) {
	if ctx == nil {
		return ActorContext{}, false
	}
	a, ok := ctx.Value(actorCtxKey{}).(ActorContext)
	return a, ok
}

// StoredNotification models a row in notifications (§13.5).
type StoredNotification struct {
	NotificationID    string
	WorkspaceID       string
	UserID            string
	Priority          adminv1.NotificationPriority
	Channel           adminv1.NotificationChannel
	Title             string
	Body              string
	DeepLink          string
	ActionButtonsJSON string
	GroupedKey        string
	ReadAt            *time.Time
	DismissedAt       *time.Time
	DeliveredAt       *time.Time
	CreatedAt         time.Time
}

// StoredPreferences models user preferences.
type StoredPreferences struct {
	WorkspaceID       string
	UserID            string
	EmailEnabled      bool
	PushEnabled       bool
	InAppEnabled      bool
	QuietHoursEnabled bool
	QuietHoursStart   string
	QuietHoursEnd     string
	DigestFrequency   string
	UpdatedAt         time.Time
}

// Service provides NotificationService RPC implementation.
type Service struct {
	adminv1connect.UnimplementedNotificationServiceHandler
	mu            sync.RWMutex
	notifications map[string]*StoredNotification
	preferences   map[string]*StoredPreferences // key: workspaceID:userID
	bindings      *rbac.Registry
}

// NewService creates a new NotificationService instance.
func NewService(bindings *rbac.Registry) *Service {
	return &Service{
		notifications: make(map[string]*StoredNotification),
		preferences:   make(map[string]*StoredPreferences),
		bindings:      bindings,
	}
}

// SeedNotification adds a notification to the in-memory store (useful for tests/fixtures).
func (s *Service) SeedNotification(n StoredNotification) {
	s.mu.Lock()
	defer s.mu.Unlock()
	if n.NotificationID == "" {
		n.NotificationID = generateUUID()
	}
	if n.CreatedAt.IsZero() {
		n.CreatedAt = time.Now().UTC()
	}
	s.notifications[n.NotificationID] = &n
}

// validateActor verifies tenant boundary and user isolation.
func (s *Service) validateActor(ctx context.Context, requestedWorkspaceID, requestedUserID string) (ActorContext, error) {
	actor, ok := ActorFromContext(ctx)
	if !ok || actor.UserID == "" {
		return ActorContext{}, connect.NewError(connect.CodeUnauthenticated, ErrUnauthenticated)
	}

	// Normal users can only access their own user_id and their active workspace_id
	if !actor.IsAdmin {
		if requestedWorkspaceID != "" && requestedWorkspaceID != actor.WorkspaceID {
			return ActorContext{}, connect.NewError(connect.CodePermissionDenied, tenantdb.ErrScopeMismatch)
		}
		if requestedUserID != "" && requestedUserID != actor.UserID {
			return ActorContext{}, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
		}
	}
	return actor, nil
}

// List implements NotificationService/List.
func (s *Service) List(
	ctx context.Context,
	req *connect.Request[adminv1.ListRequest],
) (*connect.Response[adminv1.ListResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	wsID := ""
	if msg.WorkspaceId != nil {
		wsID = msg.WorkspaceId.Value
	}
	usrID := ""
	if msg.UserId != nil {
		usrID = msg.UserId.Value
	}

	actor, err := s.validateActor(ctx, wsID, usrID)
	if err != nil {
		return nil, err
	}
	targetWs := wsID
	if targetWs == "" {
		targetWs = actor.WorkspaceID
	}
	targetUser := usrID
	if targetUser == "" {
		targetUser = actor.UserID
	}

	s.mu.RLock()
	defer s.mu.RUnlock()

	var matched []*StoredNotification
	unreadCount := int32(0)

	for _, n := range s.notifications {
		// Strict isolation by workspace and user
		if n.WorkspaceID != targetWs || n.UserID != targetUser {
			continue
		}
		if n.ReadAt == nil {
			unreadCount++
		}
		// Skip dismissed notifications from list
		if n.DismissedAt != nil {
			continue
		}
		if msg.UnreadOnly && n.ReadAt != nil {
			continue
		}
		if msg.MinPriority != adminv1.NotificationPriority_NOTIFICATION_PRIORITY_UNSPECIFIED && n.Priority < msg.MinPriority {
			continue
		}
		matched = append(matched, n)
	}

	// Sort: priority descending (urgent first), then createdAt descending
	sort.Slice(matched, func(i, j int) bool {
		if matched[i].Priority != matched[j].Priority {
			return matched[i].Priority > matched[j].Priority
		}
		return matched[i].CreatedAt.After(matched[j].CreatedAt)
	})

	var items []*adminv1.NotificationItem
	for _, n := range matched {
		item := &adminv1.NotificationItem{
			NotificationId:    &commonv1.UUID{Value: n.NotificationID},
			WorkspaceId:       &commonv1.UUID{Value: n.WorkspaceID},
			UserId:            &commonv1.UUID{Value: n.UserID},
			Priority:          n.Priority,
			Channel:           n.Channel,
			Title:             n.Title,
			Body:              n.Body,
			DeepLink:          n.DeepLink,
			ActionButtonsJson: n.ActionButtonsJSON,
			GroupedKey:        n.GroupedKey,
			CreatedAt:         timestamppb.New(n.CreatedAt),
		}
		if n.ReadAt != nil {
			item.ReadAt = timestamppb.New(*n.ReadAt)
		}
		if n.DismissedAt != nil {
			item.DismissedAt = timestamppb.New(*n.DismissedAt)
		}
		if n.DeliveredAt != nil {
			item.DeliveredAt = timestamppb.New(*n.DeliveredAt)
		}
		items = append(items, item)
	}

	resp := &adminv1.ListResponse{
		Notifications: items,
		Pagination: &commonv1.PaginatedResponse{
			HasMore: false,
		},
		UnreadCount: unreadCount,
	}
	return connect.NewResponse(resp), nil
}

// MarkRead implements NotificationService/MarkRead.
func (s *Service) MarkRead(
	ctx context.Context,
	req *connect.Request[adminv1.MarkReadRequest],
) (*connect.Response[adminv1.MarkReadResponse], error) {
	msg := req.Msg
	if msg == nil || msg.NotificationId == nil || msg.NotificationId.Value == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	wsID := ""
	if msg.WorkspaceId != nil {
		wsID = msg.WorkspaceId.Value
	}
	usrID := ""
	if msg.UserId != nil {
		usrID = msg.UserId.Value
	}

	actor, err := s.validateActor(ctx, wsID, usrID)
	if err != nil {
		return nil, err
	}
	targetWs := wsID
	if targetWs == "" {
		targetWs = actor.WorkspaceID
	}
	targetUser := usrID
	if targetUser == "" {
		targetUser = actor.UserID
	}

	s.mu.Lock()
	defer s.mu.Unlock()

	n, exists := s.notifications[msg.NotificationId.Value]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrNotificationNotFound)
	}

	// Security check: cannot mark read notification of another workspace or user
	if n.WorkspaceID != targetWs || n.UserID != targetUser {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	now := time.Now().UTC()
	n.ReadAt = &now

	return connect.NewResponse(&adminv1.MarkReadResponse{
		Success: true,
		ReadAt:  timestamppb.New(now),
	}), nil
}

// MarkAllRead implements NotificationService/MarkAllRead.
func (s *Service) MarkAllRead(
	ctx context.Context,
	req *connect.Request[adminv1.MarkAllReadRequest],
) (*connect.Response[adminv1.MarkAllReadResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	wsID := ""
	if msg.WorkspaceId != nil {
		wsID = msg.WorkspaceId.Value
	}
	usrID := ""
	if msg.UserId != nil {
		usrID = msg.UserId.Value
	}

	actor, err := s.validateActor(ctx, wsID, usrID)
	if err != nil {
		return nil, err
	}
	targetWs := wsID
	if targetWs == "" {
		targetWs = actor.WorkspaceID
	}
	targetUser := usrID
	if targetUser == "" {
		targetUser = actor.UserID
	}

	s.mu.Lock()
	defer s.mu.Unlock()

	now := time.Now().UTC()
	count := int32(0)
	for _, n := range s.notifications {
		if n.WorkspaceID == targetWs && n.UserID == targetUser && n.ReadAt == nil {
			n.ReadAt = &now
			count++
		}
	}

	return connect.NewResponse(&adminv1.MarkAllReadResponse{
		CountMarkedRead: count,
		ReadAt:          timestamppb.New(now),
	}), nil
}

// Dismiss implements NotificationService/Dismiss.
func (s *Service) Dismiss(
	ctx context.Context,
	req *connect.Request[adminv1.DismissRequest],
) (*connect.Response[adminv1.DismissResponse], error) {
	msg := req.Msg
	if msg == nil || msg.NotificationId == nil || msg.NotificationId.Value == "" {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	wsID := ""
	if msg.WorkspaceId != nil {
		wsID = msg.WorkspaceId.Value
	}
	usrID := ""
	if msg.UserId != nil {
		usrID = msg.UserId.Value
	}

	actor, err := s.validateActor(ctx, wsID, usrID)
	if err != nil {
		return nil, err
	}
	targetWs := wsID
	if targetWs == "" {
		targetWs = actor.WorkspaceID
	}
	targetUser := usrID
	if targetUser == "" {
		targetUser = actor.UserID
	}

	s.mu.Lock()
	defer s.mu.Unlock()

	n, exists := s.notifications[msg.NotificationId.Value]
	if !exists {
		return nil, connect.NewError(connect.CodeNotFound, ErrNotificationNotFound)
	}

	if n.WorkspaceID != targetWs || n.UserID != targetUser {
		return nil, connect.NewError(connect.CodePermissionDenied, ErrPermissionDenied)
	}

	now := time.Now().UTC()
	n.DismissedAt = &now

	return connect.NewResponse(&adminv1.DismissResponse{
		Success:     true,
		DismissedAt: timestamppb.New(now),
	}), nil
}

// GetUnreadCount implements NotificationService/GetUnreadCount.
func (s *Service) GetUnreadCount(
	ctx context.Context,
	req *connect.Request[adminv1.GetUnreadCountRequest],
) (*connect.Response[adminv1.GetUnreadCountResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	wsID := ""
	if msg.WorkspaceId != nil {
		wsID = msg.WorkspaceId.Value
	}
	usrID := ""
	if msg.UserId != nil {
		usrID = msg.UserId.Value
	}

	actor, err := s.validateActor(ctx, wsID, usrID)
	if err != nil {
		return nil, err
	}
	targetWs := wsID
	if targetWs == "" {
		targetWs = actor.WorkspaceID
	}
	targetUser := usrID
	if targetUser == "" {
		targetUser = actor.UserID
	}

	s.mu.RLock()
	defer s.mu.RUnlock()

	unread := int32(0)
	urgent := int32(0)

	for _, n := range s.notifications {
		if n.WorkspaceID == targetWs && n.UserID == targetUser && n.ReadAt == nil && n.DismissedAt == nil {
			unread++
			if n.Priority == adminv1.NotificationPriority_NOTIFICATION_PRIORITY_URGENT {
				urgent++
			}
		}
	}

	return connect.NewResponse(&adminv1.GetUnreadCountResponse{
		UnreadCount: unread,
		UrgentCount: urgent,
	}), nil
}

// GetPreferences implements NotificationService/GetPreferences.
func (s *Service) GetPreferences(
	ctx context.Context,
	req *connect.Request[adminv1.GetPreferencesRequest],
) (*connect.Response[adminv1.GetPreferencesResponse], error) {
	msg := req.Msg
	if msg == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	wsID := ""
	if msg.WorkspaceId != nil {
		wsID = msg.WorkspaceId.Value
	}
	usrID := ""
	if msg.UserId != nil {
		usrID = msg.UserId.Value
	}

	actor, err := s.validateActor(ctx, wsID, usrID)
	if err != nil {
		return nil, err
	}
	targetWs := wsID
	if targetWs == "" {
		targetWs = actor.WorkspaceID
	}
	targetUser := usrID
	if targetUser == "" {
		targetUser = actor.UserID
	}

	key := targetWs + ":" + targetUser

	s.mu.RLock()
	pref, exists := s.preferences[key]
	s.mu.RUnlock()

	if !exists {
		// Defaults per business rules
		return connect.NewResponse(&adminv1.GetPreferencesResponse{
			Preferences: &adminv1.NotificationPreferences{
				EmailEnabled:      true,
				PushEnabled:       true,
				InAppEnabled:      true,
				QuietHoursEnabled: false,
				QuietHoursStart:   "22:00",
				QuietHoursEnd:     "07:00",
				DigestFrequency:   "daily",
			},
		}), nil
	}

	return connect.NewResponse(&adminv1.GetPreferencesResponse{
		Preferences: &adminv1.NotificationPreferences{
			EmailEnabled:      pref.EmailEnabled,
			PushEnabled:       pref.PushEnabled,
			InAppEnabled:      pref.InAppEnabled,
			QuietHoursEnabled: pref.QuietHoursEnabled,
			QuietHoursStart:   pref.QuietHoursStart,
			QuietHoursEnd:     pref.QuietHoursEnd,
			DigestFrequency:   pref.DigestFrequency,
		},
	}), nil
}

// UpdatePreferences implements NotificationService/UpdatePreferences.
func (s *Service) UpdatePreferences(
	ctx context.Context,
	req *connect.Request[adminv1.UpdatePreferencesRequest],
) (*connect.Response[adminv1.UpdatePreferencesResponse], error) {
	msg := req.Msg
	if msg == nil || msg.Preferences == nil {
		return nil, connect.NewError(connect.CodeInvalidArgument, ErrInvalidInput)
	}

	wsID := ""
	if msg.WorkspaceId != nil {
		wsID = msg.WorkspaceId.Value
	}
	usrID := ""
	if msg.UserId != nil {
		usrID = msg.UserId.Value
	}

	actor, err := s.validateActor(ctx, wsID, usrID)
	if err != nil {
		return nil, err
	}
	targetWs := wsID
	if targetWs == "" {
		targetWs = actor.WorkspaceID
	}
	targetUser := usrID
	if targetUser == "" {
		targetUser = actor.UserID
	}

	key := targetWs + ":" + targetUser
	now := time.Now().UTC()

	s.mu.Lock()
	defer s.mu.Unlock()

	pref := &StoredPreferences{
		WorkspaceID:       targetWs,
		UserID:            targetUser,
		EmailEnabled:      msg.Preferences.EmailEnabled,
		PushEnabled:       msg.Preferences.PushEnabled,
		InAppEnabled:      msg.Preferences.InAppEnabled,
		QuietHoursEnabled: msg.Preferences.QuietHoursEnabled,
		QuietHoursStart:   msg.Preferences.QuietHoursStart,
		QuietHoursEnd:     msg.Preferences.QuietHoursEnd,
		DigestFrequency:   msg.Preferences.DigestFrequency,
		UpdatedAt:         now,
	}
	s.preferences[key] = pref

	return connect.NewResponse(&adminv1.UpdatePreferencesResponse{
		Preferences: msg.Preferences,
		UpdatedAt:   timestamppb.New(now),
	}), nil
}

func generateUUID() string {
	b := make([]byte, 16)
	_, _ = rand.Read(b)
	b[6] = (b[6] & 0x0f) | 0x40 // RFC 4122 v4
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%s-%s-%s-%s-%s",
		hex.EncodeToString(b[0:4]),
		hex.EncodeToString(b[4:6]),
		hex.EncodeToString(b[6:8]),
		hex.EncodeToString(b[8:10]),
		hex.EncodeToString(b[10:16]),
	)
}

// SanitizeInput provides basic string trimming.
func SanitizeInput(s string) string {
	return strings.TrimSpace(s)
}
