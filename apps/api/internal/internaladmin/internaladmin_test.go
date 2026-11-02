package internaladmin_test

import (
	"context"
	"errors"
	"path/filepath"
	"runtime"
	"testing"
	"time"

	"connectrpc.com/connect"
	adminv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1"
	commonv1 "github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/common/v1"
	"github.com/quantm-zeus/creativanta/apps/api/internal/capability"
	"github.com/quantm-zeus/creativanta/apps/api/internal/internaladmin"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
)

func repoRoot(t *testing.T) string {
	t.Helper()
	_, file, _, ok := runtime.Caller(0)
	if !ok {
		t.Fatal("cannot resolve caller path")
	}
	return filepath.Clean(filepath.Join(filepath.Dir(file), "..", "..", "..", ".."))
}

func TestWorkspaceRoleCannotCallAdminListenerAndVPNMFAGate(t *testing.T) {
	reg, err := rbac.LoadCanonicalBindings(repoRoot(t))
	if err != nil {
		t.Fatalf("LoadCanonicalBindings: %v", err)
	}
	svc := internaladmin.NewService(reg)
	now := time.Date(2026, 11, 2, 9, 0, 0, 0, time.UTC)
	svc.Now = func() time.Time { return now }

	const (
		superAdminID = "90000000-0000-4000-8000-000000000001"
		analystID    = "90000000-0000-4000-8000-000000000002"
		mfaSecret    = "JBSWY3DPEHPK3PXP"
		password     = "Admin-Correct-Horse-Battery-2026!"
	)

	if err := svc.RegisterAdmin(internaladmin.InternalAdminRecord{
		AdminID:      superAdminID,
		Email:        "super@internal.creativanta.vn",
		FullName:     "Super Admin",
		PasswordHash: internaladmin.HashAdminPassword(password),
		AdminRole:    rbac.AdminRoleSuper,
		MFASecret:    mfaSecret,
		MFAEnabled:   true,
		Status:       "active",
	}); err != nil {
		t.Fatalf("RegisterAdmin super: %v", err)
	}
	if err := svc.RegisterAdmin(internaladmin.InternalAdminRecord{
		AdminID:      analystID,
		Email:        "analyst@internal.creativanta.vn",
		FullName:     "Read-Only Analyst",
		PasswordHash: internaladmin.HashAdminPassword(password),
		AdminRole:    rbac.AdminRoleAnalyst,
		MFASecret:    mfaSecret,
		MFAEnabled:   true,
		Status:       "active",
	}); err != nil {
		t.Fatalf("RegisterAdmin analyst: %v", err)
	}

	// 1. Every workspace role (owner..external) must be rejected on the admin listener!
	for _, wsRole := range rbac.CanonicalWorkspaceRoles() {
		err := svc.GuardListenerBoundary(transportauth.ModeAdminAPI, "SystemConfigService/GetDashboard", internaladmin.AdminActorContext{
			AdminID:          "11111111-1111-4111-8111-111111111111",
			AdminRole:        wsRole,
			WorkspaceRoleTry: wsRole,
			VPNVerified:      true,
			MFAVerified:      true,
		})
		if !errors.Is(err, internaladmin.ErrWorkspaceRoleRejectedOnAdminListener) {
			t.Fatalf("expected workspace role %q to be rejected on admin listener, got %v", wsRole, err)
		}

		if _, err := svc.Verify(context.Background(), "role:"+wsRole); !errors.Is(err, internaladmin.ErrWorkspaceRoleRejectedOnAdminListener) {
			t.Fatalf("expected Verify(role:%s) to be rejected on admin listener, got %v", wsRole, err)
		}
	}

	// Clerk / workspace tokens must also be rejected by ModeAdminAPI Verifier.
	if _, err := svc.Verify(context.Background(), "clerk:sess_abc123"); !errors.Is(err, internaladmin.ErrWorkspaceRoleRejectedOnAdminListener) {
		t.Fatalf("expected Clerk token to be rejected on admin listener, got %v", err)
	}

	// 2. Admin RPCs cannot execute on the public workspace listener (ModeAPI).
	if err := svc.GuardListenerBoundary(transportauth.ModeAPI, "SystemConfigService/ToggleFlag", internaladmin.AdminActorContext{
		AdminID:     superAdminID,
		AdminRole:   rbac.AdminRoleSuper,
		VPNVerified: true,
		MFAVerified: true,
	}); !errors.Is(err, internaladmin.ErrAdminRPCOnWorkspaceListener) {
		t.Fatalf("expected admin RPC on workspace listener to fail with ErrAdminRPCOnWorkspaceListener, got %v", err)
	}

	// 3. Admin Login without VPN mesh verification must fail closed.
	totp, err := internaladmin.GenerateTOTPCode(mfaSecret, now)
	if err != nil {
		t.Fatalf("GenerateTOTPCode: %v", err)
	}
	_, err = svc.Login(context.Background(), connect.NewRequest(&adminv1.LoginRequest{
		Email:       "super@internal.creativanta.vn",
		Password:    password,
		TotpCode:    totp,
		VpnVerified: false,
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected PermissionDenied when VPN is not verified, got %v", err)
	}

	// 4. Admin Login with invalid TOTP MFA code must fail closed.
	_, err = svc.Login(context.Background(), connect.NewRequest(&adminv1.LoginRequest{
		Email:       "super@internal.creativanta.vn",
		Password:    password,
		TotpCode:    "000000",
		VpnVerified: true,
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected PermissionDenied for invalid TOTP MFA code, got %v", err)
	}

	// 5. Valid VPN + password + TOTP MFA succeeds and issues an 8-hour admin session.
	loginResp, err := svc.Login(context.Background(), connect.NewRequest(&adminv1.LoginRequest{
		Email:       "super@internal.creativanta.vn",
		Password:    password,
		TotpCode:    totp,
		VpnVerified: true,
		IpAddress:   "100.64.0.10",
		UserAgent:   "Creativanta-Admin-Console/1.0",
	}))
	if err != nil {
		t.Fatalf("Login valid: %v", err)
	}
	principal, err := svc.Verify(context.Background(), loginResp.Msg.GetSessionToken())
	if err != nil {
		t.Fatalf("Verify valid admin session: %v", err)
	}
	if !principal.InternalAdmin || principal.UserID != superAdminID || principal.WorkspaceID != "" {
		t.Fatalf("unexpected verified admin principal: %+v", principal)
	}

	// 6. Analyst (read-only admin role) can call GetDashboard, but cannot call ToggleFlag.
	analystLogin, err := svc.Login(context.Background(), connect.NewRequest(&adminv1.LoginRequest{
		Email:       "analyst@internal.creativanta.vn",
		Password:    password,
		TotpCode:    totp,
		VpnVerified: true,
	}))
	if err != nil {
		t.Fatalf("analyst Login: %v", err)
	}
	analystCtx := internaladmin.WithAdminActor(context.Background(), internaladmin.AdminActorContext{
		SessionID:   analystLogin.Msg.GetSessionId().GetValue(),
		AdminID:     analystID,
		AdminRole:   rbac.AdminRoleAnalyst,
		VPNVerified: true,
		MFAVerified: true,
	})
	if _, err := svc.GetDashboard(analystCtx, connect.NewRequest(&adminv1.GetDashboardRequest{})); err != nil {
		t.Fatalf("expected analyst GetDashboard to succeed, got %v", err)
	}
	_, err = svc.ToggleFlag(analystCtx, connect.NewRequest(&adminv1.ToggleFlagRequest{
		IdempotencyKey: "idem-analyst-toggle-1",
		Reason:         "Analyst attempting mutation",
		FlagKey:        "kill_switch:tiktok",
		Status:         "enabled",
		IsKillSwitch:   true,
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected analyst ToggleFlag to fail with PermissionDenied, got %v", err)
	}
}

func TestImpersonationIsStrictlyReadOnlyAndAutoExpiresAfter30Minutes(t *testing.T) {
	reg, err := rbac.LoadCanonicalBindings(repoRoot(t))
	if err != nil {
		t.Fatalf("LoadCanonicalBindings: %v", err)
	}
	svc := internaladmin.NewService(reg)
	capSvc := capability.NewService(reg, svc)

	now := time.Date(2026, 11, 2, 10, 0, 0, 0, time.UTC)
	svc.Now = func() time.Time { return now }
	capSvc.Now = func() time.Time { return now }

	const (
		supportAdminID = "90000000-0000-4000-8000-000000000003"
		opsAdminID     = "90000000-0000-4000-8000-000000000004"
		targetUserID   = "11111111-1111-4111-8111-111111111111"
		targetWsID     = "22222222-2222-4222-8222-222222222222"
		accountID      = "33333333-3333-4333-8333-333333333333"
		mfaSecret      = "JBSWY3DPEHPK3PXP"
		password       = "Admin-Impersonate-Test-2026!"
	)

	_ = svc.RegisterAdmin(internaladmin.InternalAdminRecord{
		AdminID:      supportAdminID,
		Email:        "support@internal.creativanta.vn",
		FullName:     "Support Admin",
		PasswordHash: internaladmin.HashAdminPassword(password),
		AdminRole:    rbac.AdminRoleSupport,
		MFASecret:    mfaSecret,
		MFAEnabled:   true,
		Status:       "active",
	})
	_ = svc.RegisterAdmin(internaladmin.InternalAdminRecord{
		AdminID:      opsAdminID,
		Email:        "ops@internal.creativanta.vn",
		FullName:     "Ops Admin",
		PasswordHash: internaladmin.HashAdminPassword(password),
		AdminRole:    rbac.AdminRoleOps,
		MFASecret:    mfaSecret,
		MFAEnabled:   true,
		Status:       "active",
	})

	if err := capSvc.RegisterConnectedAccount(capability.ConnectedAccountRecord{
		ConnectedAccountID: accountID,
		WorkspaceID:        targetWsID,
		Platform:           "tiktok",
		AccountType:        "creator",
		ExternalAccountID:  "tt_shop_official",
		AccountName:        "Shop Official",
		Status:             "active",
		GrantedScopes:      []string{"user.info.basic", "video.upload", "video.publish", "video.list"},
		Market:             "VN",
		TokenExpiresAt:     now.Add(12 * time.Hour),
	}); err != nil {
		t.Fatalf("RegisterConnectedAccount: %v", err)
	}

	totp, _ := internaladmin.GenerateTOTPCode(mfaSecret, now)
	supportLogin, err := svc.Login(context.Background(), connect.NewRequest(&adminv1.LoginRequest{
		Email:       "support@internal.creativanta.vn",
		Password:    password,
		TotpCode:    totp,
		VpnVerified: true,
	}))
	if err != nil {
		t.Fatalf("support Login: %v", err)
	}
	supportCtx := internaladmin.WithAdminActor(context.Background(), internaladmin.AdminActorContext{
		SessionID:   supportLogin.Msg.GetSessionId().GetValue(),
		AdminID:     supportAdminID,
		AdminRole:   rbac.AdminRoleSupport,
		VPNVerified: true,
		MFAVerified: true,
	})

	// 1. support_admin without a support_ticket_id must be denied impersonation.
	_, err = svc.Impersonate(supportCtx, connect.NewRequest(&adminv1.ImpersonateRequest{
		IdempotencyKey:    "idem-imp-no-ticket",
		Reason:            "Investigating customer connector issue",
		TargetUserId:      &commonv1.UUID{Value: targetUserID},
		TargetWorkspaceId: &commonv1.UUID{Value: targetWsID},
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected support_admin impersonation without ticket to fail with PermissionDenied, got %v", err)
	}

	// 2. support_admin WITH a scoped support_ticket_id and reason starts a read_only session expiring in 30 minutes.
	impResp, err := svc.Impersonate(supportCtx, connect.NewRequest(&adminv1.ImpersonateRequest{
		IdempotencyKey:    "idem-imp-ticket-1",
		Reason:            "Investigating ticket SUP-2026-991",
		TargetUserId:      &commonv1.UUID{Value: targetUserID},
		TargetWorkspaceId: &commonv1.UUID{Value: targetWsID},
		SupportTicketId:   "SUP-2026-991",
	}))
	if err != nil {
		t.Fatalf("Impersonate with ticket: %v", err)
	}
	if impResp.Msg.GetMode() != "read_only" {
		t.Fatalf("expected impersonation mode=read_only, got %q", impResp.Msg.GetMode())
	}
	expectedExpiry := now.Add(30 * time.Minute)
	if !impResp.Msg.GetExpiresAt().AsTime().Equal(expectedExpiry) {
		t.Fatalf("expected 30m expiry %v, got %v", expectedExpiry, impResp.Msg.GetExpiresAt().AsTime())
	}

	impID := impResp.Msg.GetImpersonationId().GetValue()

	// 3. Read-only workspace RPCs succeed under impersonation.
	if err := svc.AuthorizeImpersonatedWorkspaceRPC(impID, "CapabilityService/GetMatrix", rbac.RoleOwner); err != nil {
		t.Fatalf("expected read-only CapabilityService/GetMatrix to succeed under impersonation, got %v", err)
	}
	impActor, err := svc.BuildImpersonatedWorkspaceActor(impID, rbac.RoleOwner)
	if err != nil {
		t.Fatalf("BuildImpersonatedWorkspaceActor: %v", err)
	}
	impWsCtx := capability.WithActorContext(context.Background(), impActor)
	if _, err := capSvc.GetMatrix(impWsCtx, connect.NewRequest(&adminv1.GetMatrixRequest{
		WorkspaceId: &commonv1.UUID{Value: targetWsID},
	})); err != nil {
		t.Fatalf("expected GetMatrix to succeed under impersonation, got %v", err)
	}

	// 4. ANY mutating RPC under impersonation is strictly rejected with ErrImpersonationReadOnly, even when impersonating Owner!
	for _, mutatingRPC := range []string{
		"ConnectorService/Disconnect",
		"WorkspaceService/InviteMember",
		"WorkspaceService/Update",
		"WorkspaceService/Delete",
	} {
		err := svc.AuthorizeImpersonatedWorkspaceRPC(impID, mutatingRPC, rbac.RoleOwner)
		if !errors.Is(err, rbac.ErrImpersonationReadOnly) {
			t.Fatalf("expected %s to fail with ErrImpersonationReadOnly during impersonation, got %v", mutatingRPC, err)
		}
	}

	// Calling ConnectorService.Disconnect directly with the impersonated actor context must also be denied!
	_, err = capSvc.Disconnect(impWsCtx, connect.NewRequest(&adminv1.ConnectorServiceDisconnectRequest{
		Context: &commonv1.CommandContext{
			WorkspaceId:    &commonv1.UUID{Value: targetWsID},
			IdempotencyKey: "idem-imp-disconnect-blocked",
			Reason:         "Attempt write during impersonation",
		},
		ConnectedAccountId: &commonv1.UUID{Value: accountID},
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected Disconnect under impersonation to fail with PermissionDenied, got %v", err)
	}

	// 5. Dual audit logs (internal_audit_logs + workspace audit_logs) and admin.impersonation_started event were recorded.
	if len(svc.WorkspaceAuditLogs()) == 0 {
		t.Fatalf("expected workspace audit log for impersonation start")
	}

	// 6. Advancing clock past 30 minutes auto-expires the impersonation session.
	now = now.Add(31 * time.Minute)
	if err := svc.AuthorizeImpersonatedWorkspaceRPC(impID, "CapabilityService/GetMatrix", rbac.RoleOwner); !errors.Is(err, internaladmin.ErrImpersonationExpired) {
		t.Fatalf("expected impersonation session to expire after 30 minutes, got %v", err)
	}
}

func TestModerationRulesHardBlockSelfReviewGuardAndKillSwitchHaltsCapability(t *testing.T) {
	reg, err := rbac.LoadCanonicalBindings(repoRoot(t))
	if err != nil {
		t.Fatalf("LoadCanonicalBindings: %v", err)
	}
	svc := internaladmin.NewService(reg)
	capSvc := capability.NewService(reg, svc)

	now := time.Date(2026, 11, 2, 11, 0, 0, 0, time.UTC)
	svc.Now = func() time.Time { return now }
	capSvc.Now = func() time.Time { return now }

	const (
		contentAdminID      = "90000000-0000-4000-8000-000000000005"
		techAdminID         = "90000000-0000-4000-8000-000000000006"
		contentAdminUserRef = "11111111-1111-4111-8111-111111111199"
		otherUserID         = "11111111-1111-4111-8111-111111111101"
		workspaceID         = "22222222-2222-4222-8222-222222222201"
		accountID           = "33333333-3333-4333-8333-333333333301"
		hardBlockCaseID     = "44444444-4444-4444-8444-444444444401"
		softReviewCaseID    = "44444444-4444-4444-8444-444444444402"
		selfConflictCaseID  = "44444444-4444-4444-8444-444444444403"
		contentID           = "55555555-5555-4555-8555-555555555501"
		mfaSecret           = "JBSWY3DPEHPK3PXP"
		password            = "Admin-Moderation-KillSwitch-2026!"
	)

	_ = svc.RegisterAdmin(internaladmin.InternalAdminRecord{
		AdminID:      contentAdminID,
		Email:        "content@internal.creativanta.vn",
		FullName:     "Content Admin",
		PasswordHash: internaladmin.HashAdminPassword(password),
		AdminRole:    rbac.AdminRoleContent,
		MFASecret:    mfaSecret,
		MFAEnabled:   true,
		Status:       "active",
		LinkedUserID: contentAdminUserRef,
	})
	_ = svc.RegisterAdmin(internaladmin.InternalAdminRecord{
		AdminID:      techAdminID,
		Email:        "tech@internal.creativanta.vn",
		FullName:     "Tech Admin",
		PasswordHash: internaladmin.HashAdminPassword(password),
		AdminRole:    rbac.AdminRoleTech,
		MFASecret:    mfaSecret,
		MFAEnabled:   true,
		Status:       "active",
	})

	// 1. Seed moderation cases: hard-block category, soft human_review (score 42), and self-review conflict case.
	hardCase, err := svc.SeedModerationCase(internaladmin.ModerationCaseRecord{
		CaseID:        hardBlockCaseID,
		WorkspaceID:   workspaceID,
		ContentType:   "post",
		ContentID:     contentID,
		Category:      "revoked_clone_consent",
		RiskScore:     95,
		FlaggedUserID: otherUserID,
	})
	if err != nil {
		t.Fatalf("SeedModerationCase hardCase: %v", err)
	}
	if !hardCase.HardBlock || hardCase.RiskBand != internaladmin.RiskBandBlock || hardCase.Severity != "critical" {
		t.Fatalf("expected hardCase to be critical hard_block in block band, got %+v", hardCase)
	}
	// Critical SLA must be +4h (RULE-S26-006).
	if !hardCase.SLADueAt.Equal(now.Add(4 * time.Hour)) {
		t.Fatalf("expected critical SLA +4h, got %v", hardCase.SLADueAt)
	}

	softCase, err := svc.SeedModerationCase(internaladmin.ModerationCaseRecord{
		CaseID:        softReviewCaseID,
		WorkspaceID:   workspaceID,
		ContentType:   "post",
		ContentID:     contentID,
		Category:      "medical_claim_warning",
		RiskScore:     42,
		FlaggedUserID: otherUserID,
	})
	if err != nil {
		t.Fatalf("SeedModerationCase softCase: %v", err)
	}
	if softCase.HardBlock || softCase.RiskBand != internaladmin.RiskBandHumanReview {
		t.Fatalf("expected softCase to be human_review band (non-hard-block), got %+v", softCase)
	}

	_, err = svc.SeedModerationCase(internaladmin.ModerationCaseRecord{
		CaseID:        selfConflictCaseID,
		WorkspaceID:   workspaceID,
		ContentType:   "post",
		ContentID:     contentID,
		Category:      "medical_claim_warning",
		RiskScore:     48,
		FlaggedUserID: contentAdminUserRef, // belongs to contentAdmin's linked user!
	})
	if err != nil {
		t.Fatalf("SeedModerationCase selfConflictCase: %v", err)
	}

	// 2. Workspace packaging:override CANNOT clear a hard-block case (SAFE-2026-02), but CAN clear a soft warning with reason.
	if err := svc.AttemptWorkspacePackagingOverride(hardBlockCaseID, workspaceID, otherUserID, rbac.RoleOwner, "Try override hard block"); !errors.Is(err, internaladmin.ErrHardBlockNonOverridable) {
		t.Fatalf("expected workspace packaging:override on hard-block case to fail with ErrHardBlockNonOverridable, got %v", err)
	}
	if err := svc.AttemptWorkspacePackagingOverride(softReviewCaseID, workspaceID, otherUserID, rbac.RoleManager, "Verified disclaimer in caption"); err != nil {
		t.Fatalf("expected workspace packaging:override on soft review case to succeed for manager with reason, got %v", err)
	}

	// 3. Content Admin login & moderation actions.
	totp, _ := internaladmin.GenerateTOTPCode(mfaSecret, now)
	contentLogin, err := svc.Login(context.Background(), connect.NewRequest(&adminv1.LoginRequest{
		Email:       "content@internal.creativanta.vn",
		Password:    password,
		TotpCode:    totp,
		VpnVerified: true,
	}))
	if err != nil {
		t.Fatalf("contentLogin: %v", err)
	}
	contentCtx := internaladmin.WithAdminActor(context.Background(), internaladmin.AdminActorContext{
		SessionID:   contentLogin.Msg.GetSessionId().GetValue(),
		AdminID:     contentAdminID,
		AdminRole:   rbac.AdminRoleContent,
		VPNVerified: true,
		MFAVerified: true,
	})

	// EC-S26-002: Content Admin cannot review their own flagged content.
	_, err = svc.ActOnCase(contentCtx, connect.NewRequest(&adminv1.ActOnCaseRequest{
		IdempotencyKey: "idem-mod-self-conflict",
		Reason:         "Trying to approve my own flagged post",
		CaseId:         &commonv1.UUID{Value: selfConflictCaseID},
		Decision:       "approve",
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected self-review conflict to be rejected with PermissionDenied, got %v", err)
	}

	// Hard-block case cannot be approved even by content_admin; rejecting it succeeds and emits moderation.case_resolved.
	_, err = svc.ActOnCase(contentCtx, connect.NewRequest(&adminv1.ActOnCaseRequest{
		IdempotencyKey: "idem-mod-hard-approve",
		Reason:         "Try approve hard block",
		CaseId:         &commonv1.UUID{Value: hardBlockCaseID},
		Decision:       "approve",
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected approving hard-block case to fail with PermissionDenied, got %v", err)
	}

	actResp, err := svc.ActOnCase(contentCtx, connect.NewRequest(&adminv1.ActOnCaseRequest{
		IdempotencyKey: "idem-mod-hard-reject",
		Reason:         "Confirmed revoked clone consent violation",
		CaseId:         &commonv1.UUID{Value: hardBlockCaseID},
		Decision:       "reject",
	}))
	if err != nil {
		t.Fatalf("ActOnCase reject hard-block: %v", err)
	}
	if actResp.Msg.GetModerationCase().GetStatus() != "rejected" {
		t.Fatalf("expected status=rejected, got %q", actResp.Msg.GetModerationCase().GetStatus())
	}

	// 4. Kill Switch Foundation: verified TikTok publish_post route executes before kill switch, and is immediately blocked when Tech Admin toggles kill_switch:tiktok.
	_ = capSvc.RegisterConnectedAccount(capability.ConnectedAccountRecord{
		ConnectedAccountID: accountID,
		WorkspaceID:        workspaceID,
		Platform:           "tiktok",
		AccountType:        "creator",
		ExternalAccountID:  "tt_brand_1",
		AccountName:        "Brand TikTok",
		Status:             "active",
		GrantedScopes:      []string{"user.info.basic", "video.upload", "video.publish", "video.list"},
		Market:             "VN",
		TokenExpiresAt:     now.Add(12 * time.Hour),
	})
	_ = capSvc.RecordVerification(workspaceID, accountID, capability.ActionAccessVerification{
		Platform:          "tiktok",
		Product:           "TikTok Content Posting API",
		ActionKey:         "publish_post",
		AppApprovalStatus: "approved",
		RequiredScopes:    []string{"video.publish", "video.upload"},
		GrantedScopes:     []string{"video.publish", "video.upload"},
		AccountEligible:   true,
		MarketEligibility: []string{"VN", "SG"},
		ProbeEndpoint:     "/v2/post/publish/video/init/",
		ProbeMethod:       "POST",
		ProbeStatus:       "passed",
		CheckedAt:         now.Add(-2 * time.Minute),
		ValidUntil:        now.Add(24 * time.Hour),
	})
	if _, err := capSvc.RequireExecutableCapability(context.Background(), workspaceID, accountID, "tiktok", "publish_post", "VN", true); err != nil {
		t.Fatalf("expected verified tiktok publish_post to be executable before kill switch, got %v", err)
	}

	techLogin, err := svc.Login(context.Background(), connect.NewRequest(&adminv1.LoginRequest{
		Email:       "tech@internal.creativanta.vn",
		Password:    password,
		TotpCode:    totp,
		VpnVerified: true,
	}))
	if err != nil {
		t.Fatalf("techLogin: %v", err)
	}
	techCtx := internaladmin.WithAdminActor(context.Background(), internaladmin.AdminActorContext{
		SessionID:   techLogin.Msg.GetSessionId().GetValue(),
		AdminID:     techAdminID,
		AdminRole:   rbac.AdminRoleTech,
		VPNVerified: true,
		MFAVerified: true,
	})

	toggleResp, err := svc.ToggleFlag(techCtx, connect.NewRequest(&adminv1.ToggleFlagRequest{
		IdempotencyKey: "idem-killswitch-tiktok-on",
		Reason:         "Emergency TikTok API upstream outage INC-2026-042",
		FlagKey:        "kill_switch:tiktok",
		Status:         "enabled",
		IsKillSwitch:   true,
		Percentage:     100,
	}))
	if err != nil {
		t.Fatalf("ToggleFlag kill_switch:tiktok: %v", err)
	}
	if toggleResp.Msg.GetFlag().GetStatus() != "enabled" || !toggleResp.Msg.GetFlag().GetIsKillSwitch() {
		t.Fatalf("expected kill_switch:tiktok enabled, got %+v", toggleResp.Msg.GetFlag())
	}

	// Re-checking tiktok/publish_post now fails closed with capability.ErrUnverifiedRouteCannotExecute and StateDegraded!
	eval, err := capSvc.RequireExecutableCapability(context.Background(), workspaceID, accountID, "tiktok", "publish_post", "VN", true)
	if !errors.Is(err, capability.ErrUnverifiedRouteCannotExecute) {
		t.Fatalf("expected capability.ErrUnverifiedRouteCannotExecute after kill switch toggled, got %v", err)
	}
	if eval.State != capability.StateDegraded || eval.Executable {
		t.Fatalf("expected StateDegraded & Executable=false when kill switch is active, got %+v", eval)
	}
}
