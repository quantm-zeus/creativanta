package notification_test

import (
	"context"
	"testing"
	"time"

	"connectrpc.com/connect"
	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/notification"
)

const (
	ws1 = "11111111-1111-4000-8000-000000000001"
	ws2 = "22222222-2222-4000-8000-000000000002"
	u1  = "user-1111-4000-8000-000000000001"
	u2  = "user-2222-4000-8000-000000000002"
)

func setupTestService() *notification.Service {
	svc := notification.NewService(nil)

	// Seed notifications for ws1 / u1
	svc.SeedNotification(notification.StoredNotification{
		NotificationID: "notif-001",
		WorkspaceID:    ws1,
		UserID:         u1,
		Priority:       adminv1.NotificationPriority_NOTIFICATION_PRIORITY_NORMAL,
		Channel:        adminv1.NotificationChannel_NOTIFICATION_CHANNEL_IN_APP,
		Title:          "Chào mừng bạn đến với Creativanta",
		Body:           "Hoàn tất quy trình 5 bước để tối ưu hóa doanh thu.",
		CreatedAt:      time.Now().UTC().Add(-2 * time.Hour),
	})
	svc.SeedNotification(notification.StoredNotification{
		NotificationID: "notif-002",
		WorkspaceID:    ws1,
		UserID:         u1,
		Priority:       adminv1.NotificationPriority_NOTIFICATION_PRIORITY_URGENT,
		Channel:        adminv1.NotificationChannel_NOTIFICATION_CHANNEL_IN_APP,
		Title:          "Cảnh báo: Token TikTok Shop sắp hết hạn",
		Body:           "Vui lòng kết nối lại tài khoản để không gián đoạn đơn hàng.",
		CreatedAt:      time.Now().UTC().Add(-1 * time.Hour),
	})
	svc.SeedNotification(notification.StoredNotification{
		NotificationID: "notif-003",
		WorkspaceID:    ws1,
		UserID:         u1,
		Priority:       adminv1.NotificationPriority_NOTIFICATION_PRIORITY_HIGH,
		Channel:        adminv1.NotificationChannel_NOTIFICATION_CHANNEL_IN_APP,
		Title:          "Cơ hội xu hướng FMCG mới",
		Body:           "3 kịch bản video AI được đề xuất cho ngành hàng của bạn.",
		CreatedAt:      time.Now().UTC().Add(-30 * time.Minute),
	})

	// Seed notification for ws2 / u2 (cross-tenant / other user)
	svc.SeedNotification(notification.StoredNotification{
		NotificationID: "notif-cross-001",
		WorkspaceID:    ws2,
		UserID:         u2,
		Priority:       adminv1.NotificationPriority_NOTIFICATION_PRIORITY_URGENT,
		Channel:        adminv1.NotificationChannel_NOTIFICATION_CHANNEL_IN_APP,
		Title:          "Private Notification Workspace 2",
		Body:           "Strict isolation required.",
		CreatedAt:      time.Now().UTC(),
	})

	return svc
}

func TestScopedAccessAndTenantIsolation(t *testing.T) {
	svc := setupTestService()

	// 1. Unauthenticated request rejected
	ctxUnauth := context.Background()
	_, err := svc.List(ctxUnauth, connect.NewRequest(&adminv1.ListRequest{
		WorkspaceId: &commonv1.UUID{Value: ws1},
		UserId:      &commonv1.UUID{Value: u1},
	}))
	if err == nil || connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected Unauthenticated error, got %v", err)
	}

	// 2. Caller u1 in ws1 can list their notifications
	ctxU1 := notification.WithActorContext(context.Background(), notification.ActorContext{
		UserID:        u1,
		WorkspaceID:   ws1,
		WorkspaceRole: "owner",
	})
	resp, err := svc.List(ctxU1, connect.NewRequest(&adminv1.ListRequest{
		WorkspaceId: &commonv1.UUID{Value: ws1},
		UserId:      &commonv1.UUID{Value: u1},
	}))
	if err != nil {
		t.Fatalf("unexpected error: %v", err)
	}
	if len(resp.Msg.Notifications) != 3 {
		t.Fatalf("expected 3 notifications, got %d", len(resp.Msg.Notifications))
	}
	// Verify priority sorting: urgent first (notif-002), then high (notif-003), then normal (notif-001)
	if resp.Msg.Notifications[0].Priority != adminv1.NotificationPriority_NOTIFICATION_PRIORITY_URGENT {
		t.Errorf("expected top notification to be URGENT, got %v", resp.Msg.Notifications[0].Priority)
	}

	// 3. Negative test: Caller u1 attempting to list ws2 or u2 is denied
	_, err = svc.List(ctxU1, connect.NewRequest(&adminv1.ListRequest{
		WorkspaceId: &commonv1.UUID{Value: ws2},
		UserId:      &commonv1.UUID{Value: u2},
	}))
	if err == nil || connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected PermissionDenied for cross-tenant request, got %v", err)
	}

	// 4. Negative test: Caller u1 attempting to mark read notification belonging to ws2
	_, err = svc.MarkRead(ctxU1, connect.NewRequest(&adminv1.MarkReadRequest{
		WorkspaceId:    &commonv1.UUID{Value: ws1},
		UserId:         &commonv1.UUID{Value: u1},
		NotificationId: &commonv1.UUID{Value: "notif-cross-001"},
	}))
	if err == nil || connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected PermissionDenied for marking foreign notification, got %v", err)
	}
}

func TestPriorityOrderingAndUnreadCounts(t *testing.T) {
	svc := setupTestService()
	ctxU1 := notification.WithActorContext(context.Background(), notification.ActorContext{
		UserID:        u1,
		WorkspaceID:   ws1,
		WorkspaceRole: "editor",
	})

	countResp, err := svc.GetUnreadCount(ctxU1, connect.NewRequest(&adminv1.GetUnreadCountRequest{
		WorkspaceId: &commonv1.UUID{Value: ws1},
		UserId:      &commonv1.UUID{Value: u1},
	}))
	if err != nil {
		t.Fatalf("GetUnreadCount failed: %v", err)
	}
	if countResp.Msg.UnreadCount != 3 {
		t.Errorf("expected 3 unread notifications, got %d", countResp.Msg.UnreadCount)
	}
	if countResp.Msg.UrgentCount != 1 {
		t.Errorf("expected 1 urgent notification, got %d", countResp.Msg.UrgentCount)
	}
}

func TestMarkReadAndMarkAllRead(t *testing.T) {
	svc := setupTestService()
	ctxU1 := notification.WithActorContext(context.Background(), notification.ActorContext{
		UserID:        u1,
		WorkspaceID:   ws1,
		WorkspaceRole: "manager",
	})

	// Mark single read
	markResp, err := svc.MarkRead(ctxU1, connect.NewRequest(&adminv1.MarkReadRequest{
		WorkspaceId:    &commonv1.UUID{Value: ws1},
		UserId:         &commonv1.UUID{Value: u1},
		NotificationId: &commonv1.UUID{Value: "notif-002"},
	}))
	if err != nil {
		t.Fatalf("MarkRead failed: %v", err)
	}
	if !markResp.Msg.Success {
		t.Errorf("expected MarkRead success")
	}

	// Verify unread count is now 2 (0 urgent remaining)
	countResp, err := svc.GetUnreadCount(ctxU1, connect.NewRequest(&adminv1.GetUnreadCountRequest{
		WorkspaceId: &commonv1.UUID{Value: ws1},
		UserId:      &commonv1.UUID{Value: u1},
	}))
	if err != nil {
		t.Fatalf("GetUnreadCount failed: %v", err)
	}
	if countResp.Msg.UnreadCount != 2 {
		t.Errorf("expected 2 unread, got %d", countResp.Msg.UnreadCount)
	}
	if countResp.Msg.UrgentCount != 0 {
		t.Errorf("expected 0 urgent remaining, got %d", countResp.Msg.UrgentCount)
	}

	// Mark all read
	allReadResp, err := svc.MarkAllRead(ctxU1, connect.NewRequest(&adminv1.MarkAllReadRequest{
		WorkspaceId: &commonv1.UUID{Value: ws1},
		UserId:      &commonv1.UUID{Value: u1},
	}))
	if err != nil {
		t.Fatalf("MarkAllRead failed: %v", err)
	}
	if allReadResp.Msg.CountMarkedRead != 2 {
		t.Errorf("expected 2 items marked read, got %d", allReadResp.Msg.CountMarkedRead)
	}

	// Verify count is 0
	countResp, _ = svc.GetUnreadCount(ctxU1, connect.NewRequest(&adminv1.GetUnreadCountRequest{
		WorkspaceId: &commonv1.UUID{Value: ws1},
		UserId:      &commonv1.UUID{Value: u1},
	}))
	if countResp.Msg.UnreadCount != 0 {
		t.Errorf("expected 0 unread after MarkAllRead, got %d", countResp.Msg.UnreadCount)
	}
}

func TestDismissExcludesFromActiveList(t *testing.T) {
	svc := setupTestService()
	ctxU1 := notification.WithActorContext(context.Background(), notification.ActorContext{
		UserID:        u1,
		WorkspaceID:   ws1,
		WorkspaceRole: "owner",
	})

	// Dismiss notif-001
	dismissResp, err := svc.Dismiss(ctxU1, connect.NewRequest(&adminv1.DismissRequest{
		WorkspaceId:    &commonv1.UUID{Value: ws1},
		UserId:         &commonv1.UUID{Value: u1},
		NotificationId: &commonv1.UUID{Value: "notif-001"},
	}))
	if err != nil {
		t.Fatalf("Dismiss failed: %v", err)
	}
	if !dismissResp.Msg.Success {
		t.Errorf("expected Dismiss success")
	}

	// List should now return 2 items (notif-001 excluded)
	listResp, err := svc.List(ctxU1, connect.NewRequest(&adminv1.ListRequest{
		WorkspaceId: &commonv1.UUID{Value: ws1},
		UserId:      &commonv1.UUID{Value: u1},
	}))
	if err != nil {
		t.Fatalf("List failed: %v", err)
	}
	if len(listResp.Msg.Notifications) != 2 {
		t.Errorf("expected 2 active notifications after dismissal, got %d", len(listResp.Msg.Notifications))
	}
	for _, n := range listResp.Msg.Notifications {
		if n.NotificationId.Value == "notif-001" {
			t.Errorf("dismissed notification notif-001 should not be listed")
		}
	}
}

func TestPreferencesDefaultsAndUpdate(t *testing.T) {
	svc := setupTestService()
	ctxU1 := notification.WithActorContext(context.Background(), notification.ActorContext{
		UserID:        u1,
		WorkspaceID:   ws1,
		WorkspaceRole: "owner",
	})

	// Get default preferences
	prefResp, err := svc.GetPreferences(ctxU1, connect.NewRequest(&adminv1.GetPreferencesRequest{
		WorkspaceId: &commonv1.UUID{Value: ws1},
		UserId:      &commonv1.UUID{Value: u1},
	}))
	if err != nil {
		t.Fatalf("GetPreferences failed: %v", err)
	}
	if !prefResp.Msg.Preferences.InAppEnabled {
		t.Errorf("expected in_app_enabled=true by default")
	}
	if prefResp.Msg.Preferences.QuietHoursEnabled {
		t.Errorf("expected quiet_hours_enabled=false by default")
	}

	// Update preferences
	updatedPref := &adminv1.NotificationPreferences{
		EmailEnabled:      false,
		PushEnabled:       true,
		InAppEnabled:      true,
		QuietHoursEnabled: true,
		QuietHoursStart:   "23:00",
		QuietHoursEnd:     "06:30",
		DigestFrequency:   "weekly",
	}
	updResp, err := svc.UpdatePreferences(ctxU1, connect.NewRequest(&adminv1.UpdatePreferencesRequest{
		WorkspaceId: &commonv1.UUID{Value: ws1},
		UserId:      &commonv1.UUID{Value: u1},
		Preferences: updatedPref,
	}))
	if err != nil {
		t.Fatalf("UpdatePreferences failed: %v", err)
	}
	if updResp.Msg.Preferences.QuietHoursStart != "23:00" {
		t.Errorf("expected updated quiet hours start '23:00', got %s", updResp.Msg.Preferences.QuietHoursStart)
	}
}
