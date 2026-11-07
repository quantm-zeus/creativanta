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

	// 3. Admin Login without VPN mesh verification must fail closed, even if client claims VpnVerified=true.
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
	// Spoofed client-supplied VpnVerified=true without trusted transport VPN evidence must also fail closed (AUTH-05).
	_, err = svc.Login(context.Background(), connect.NewRequest(&adminv1.LoginRequest{
		Email:       "super@internal.creativanta.vn",
		Password:    password,
		TotpCode:    totp,
		VpnVerified: true,
		IpAddress:   "100.64.0.10",
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected PermissionDenied when client spoofs VpnVerified=true without transport VPN evidence, got %v", err)
	}
	// Non-Tailscale public peer IP in transport evidence must also fail closed.
	_, err = svc.Login(internaladmin.WithTrustedVPNTransport(context.Background(), "203.0.113.5"), connect.NewRequest(&adminv1.LoginRequest{
		Email:       "super@internal.creativanta.vn",
		Password:    password,
		TotpCode:    totp,
		VpnVerified: true,
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected PermissionDenied when transport peer IP is not in Tailscale/VPN range, got %v", err)
	}

	vpnCtx := internaladmin.WithTrustedVPNTransport(context.Background(), "100.64.0.10")

	// 4. Admin Login with invalid TOTP MFA code must fail closed.
	_, err = svc.Login(vpnCtx, connect.NewRequest(&adminv1.LoginRequest{
		Email:       "super@internal.creativanta.vn",
		Password:    password,
		TotpCode:    "000000",
		VpnVerified: true,
	}))
	if connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected PermissionDenied for invalid TOTP MFA code, got %v", err)
	}

	// 5. Valid VPN + password + TOTP MFA succeeds and issues an 8-hour admin session.
	loginResp, err := svc.Login(vpnCtx, connect.NewRequest(&adminv1.LoginRequest{
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
	analystLogin, err := svc.Login(vpnCtx, connect.NewRequest(&adminv1.LoginRequest{
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
	vpnCtx := internaladmin.WithTrustedVPNTransport(context.Background(), "100.64.0.10")
	supportLogin, err := svc.Login(vpnCtx, connect.NewRequest(&adminv1.LoginRequest{
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
	vpnCtx := internaladmin.WithTrustedVPNTransport(context.Background(), "100.64.0.10")
	contentLogin, err := svc.Login(vpnCtx, connect.NewRequest(&adminv1.LoginRequest{
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

	techLogin, err := svc.Login(vpnCtx, connect.NewRequest(&adminv1.LoginRequest{
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

func TestPrivilegedRoleBoundariesAndOperationalTools(t *testing.T) {
	reg, err := rbac.LoadCanonicalBindings(repoRoot(t))
	if err != nil {
		t.Fatalf("LoadCanonicalBindings: %v", err)
	}
	svc := internaladmin.NewService(reg)
	now := time.Date(2026, 11, 4, 10, 0, 0, 0, time.UTC)
	svc.Now = func() time.Time { return now }

	const (
		superID   = "90000000-0000-4000-8000-000000000001"
		opsID     = "90000000-0000-4000-8000-000000000002"
		contentID = "90000000-0000-4000-8000-000000000003"
		supportID = "90000000-0000-4000-8000-000000000004"
		techID    = "90000000-0000-4000-8000-000000000005"
		analystID = "90000000-0000-4000-8000-000000000006"
		password  = "Admin-Secret-Test-2026!"
		mfaSecret = "JBSWY3DPEHPK3PXP"
	)

	roles := []struct {
		id   string
		role string
	}{
		{superID, rbac.AdminRoleSuper},
		{opsID, rbac.AdminRoleOps},
		{contentID, rbac.AdminRoleContent},
		{supportID, rbac.AdminRoleSupport},
		{techID, rbac.AdminRoleTech},
		{analystID, rbac.AdminRoleAnalyst},
	}
	for _, r := range roles {
		if err := svc.RegisterAdmin(internaladmin.InternalAdminRecord{
			AdminID:      r.id,
			Email:        r.role + "@internal.creativanta.vn",
			FullName:     r.role + " Admin",
			PasswordHash: internaladmin.HashAdminPassword(password),
			AdminRole:    r.role,
			MFASecret:    mfaSecret,
			MFAEnabled:   true,
			Status:       "active",
		}); err != nil {
			t.Fatalf("RegisterAdmin %s: %v", r.role, err)
		}
	}

	ctx := context.Background()

	// 1. Jobs tool: Tech Admin and Super Admin CAN pause jobs, Content Admin CANNOT.
	job, err := svc.SeedBackgroundJob(internaladmin.BackgroundJobRecord{
		JobID:        "88888888-8888-4888-8888-888888888801",
		QueueName:    "video_rendering",
		Status:       "running",
		Payload:      map[string]any{"task": "render_video"},
		AttemptCount: 1,
	})
	if err != nil {
		t.Fatalf("SeedBackgroundJob: %v", err)
	}

	// Content Admin attempting PauseJob fails with ErrPrivilegedRoleBoundaryViolation
	if _, err := svc.PauseJob(ctx, job.JobID, "Trying to pause", contentID); !errors.Is(err, internaladmin.ErrPrivilegedRoleBoundaryViolation) {
		t.Fatalf("expected Content Admin to be blocked from PauseJob, got %v", err)
	}
	// Tech Admin can pause job
	pausedJob, err := svc.PauseJob(ctx, job.JobID, "Routine maintenance", techID)
	if err != nil {
		t.Fatalf("Tech Admin PauseJob failed: %v", err)
	}
	if pausedJob.Status != "paused" {
		t.Fatalf("expected job status paused, got %s", pausedJob.Status)
	}

	// 2. DLQ tool: DLQ retry and purge
	dlqItem, err := svc.SeedDLQItem(internaladmin.DLQItemRecord{
		DLQID:             "88888888-8888-4888-8888-888888888802",
		QueueName:         "webhooks",
		OriginalMessageID: "msg-12345",
		Status:            "pending",
		Payload:           map[string]any{"event": "tiktok_sync"},
		ErrorMessage:      "Connection timeout after 3 retries",
	})
	if err != nil {
		t.Fatalf("SeedDLQItem: %v", err)
	}

	// Support Admin attempting RetryDLQItem is blocked
	if _, err := svc.RetryDLQItem(ctx, dlqItem.DLQID, supportID); !errors.Is(err, internaladmin.ErrPrivilegedRoleBoundaryViolation) {
		t.Fatalf("expected Support Admin to be blocked from RetryDLQItem, got %v", err)
	}
	// Tech Admin retrying DLQ succeeds
	retriedDLQ, err := svc.RetryDLQItem(ctx, dlqItem.DLQID, techID)
	if err != nil {
		t.Fatalf("Tech Admin RetryDLQItem failed: %v", err)
	}
	if retriedDLQ.Status != "retrying" {
		t.Fatalf("expected dlq status retrying, got %s", retriedDLQ.Status)
	}

	// Purge requires reason and privileged role
	if _, err := svc.PurgeDLQItem(ctx, dlqItem.DLQID, "", techID); !errors.Is(err, internaladmin.ErrInvalidInput) {
		t.Fatalf("expected empty reason to be rejected on DLQ purge, got %v", err)
	}
	purgedDLQ, err := svc.PurgeDLQItem(ctx, dlqItem.DLQID, "Payload unrecoverable after investigation", techID)
	if err != nil {
		t.Fatalf("PurgeDLQItem failed: %v", err)
	}
	if purgedDLQ.Status != "purged" {
		t.Fatalf("expected purged status, got %s", purgedDLQ.Status)
	}
}

func TestHardBlockAppealAuditAndFalsePositiveClearance(t *testing.T) {
	reg, err := rbac.LoadCanonicalBindings(repoRoot(t))
	if err != nil {
		t.Fatalf("LoadCanonicalBindings: %v", err)
	}
	svc := internaladmin.NewService(reg)
	now := time.Date(2026, 11, 4, 11, 0, 0, 0, time.UTC)
	svc.Now = func() time.Time { return now }

	const (
		contentAdminID = "90000000-0000-4000-8000-000000000003"
		techAdminID    = "90000000-0000-4000-8000-000000000005"
		workspaceID    = "22222222-2222-4222-8222-222222222222"
		creatorUserID  = "33333333-3333-4333-8333-333333333333"
		caseID         = "77777777-7777-4777-8777-777777777701"
		password       = "Admin-Secret-Test-2026!"
		mfaSecret      = "JBSWY3DPEHPK3PXP"
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

	// 1. Seed a hard-blocked case: phishing/malware category (SAFE-2026-02)
	mc, err := svc.SeedModerationCase(internaladmin.ModerationCaseRecord{
		CaseID:        caseID,
		WorkspaceID:   workspaceID,
		ContentType:   "link_in_bio",
		ContentID:     "44444444-4444-4444-8444-444444444401",
		Category:      "phishing_malware",
		RiskScore:     98,
		FlaggedUserID: creatorUserID,
	})
	if err != nil {
		t.Fatalf("SeedModerationCase: %v", err)
	}
	if !mc.HardBlock {
		t.Fatalf("expected phishing_malware to be classified as HardBlock")
	}

	// 2. Creator attempts packaging override -> strictly rejected with ErrHardBlockNonOverridable
	if err := svc.AttemptWorkspacePackagingOverride(caseID, workspaceID, creatorUserID, rbac.RoleOwner, "Just a harmless link"); !errors.Is(err, internaladmin.ErrHardBlockNonOverridable) {
		t.Fatalf("expected ErrHardBlockNonOverridable on workspace packaging override, got %v", err)
	}

	// 3. Creator submits appeal with explanation and evidence reference
	updatedCase, appeal, err := svc.SubmitAppeal(context.Background(), caseID, workspaceID, creatorUserID, "Domain verified via Cloudflare DNS, not a phishing domain", "dns-txt-verification-proof-9912")
	if err != nil {
		t.Fatalf("SubmitAppeal failed: %v", err)
	}
	if updatedCase.AppealStatus != "pending" || appeal.Status != "pending" {
		t.Fatalf("expected appeal status pending, got case=%s appeal=%s", updatedCase.AppealStatus, appeal.Status)
	}

	// Verify moderation.case.appealed event was emitted
	events := svc.EmittedEvents()
	var foundAppealed bool
	for _, e := range events {
		if e.EventType == "moderation.case.appealed" {
			foundAppealed = true
			break
		}
	}
	if !foundAppealed {
		t.Fatalf("expected moderation.case.appealed event to be emitted")
	}

	// 4. Tech Admin attempts to review appeal -> rejected by privileged role boundary!
	if _, _, err := svc.ReviewAppeal(context.Background(), appeal.AppealID, techAdminID, "overturn", "Looks fine", "dns-proof"); !errors.Is(err, internaladmin.ErrPrivilegedRoleBoundaryViolation) {
		t.Fatalf("expected Tech Admin to be blocked from reviewing appeal, got %v", err)
	}

	// 5. Content Admin attempts to overturn hard-block WITHOUT documented evidence -> rejected by SAFE-2026-02
	if _, _, err := svc.ReviewAppeal(context.Background(), appeal.AppealID, contentAdminID, "overturn", "Looks fine", ""); !errors.Is(err, internaladmin.ErrFalsePositiveEvidenceRequired) {
		t.Fatalf("expected ErrFalsePositiveEvidenceRequired when overturning hard block without evidence, got %v", err)
	}

	// 6. Content Admin overturns hard-block WITH audited evidence and justification -> clears false positive!
	resolvedCase, resolvedAppeal, err := svc.ReviewAppeal(
		context.Background(),
		appeal.AppealID,
		contentAdminID,
		"overturn",
		"Confirmed false positive: Domain ownership verified via DNS TXT record and Google Safe Browsing clearance.",
		"dns-txt-verification-proof-9912",
	)
	if err != nil {
		t.Fatalf("ReviewAppeal false positive clearance failed: %v", err)
	}
	if !resolvedAppeal.FalsePositiveCleared || !resolvedCase.FalsePositiveCleared {
		t.Fatalf("expected FalsePositiveCleared=true, got appeal=%v case=%v", resolvedAppeal.FalsePositiveCleared, resolvedCase.FalsePositiveCleared)
	}
	if resolvedAppeal.Status != "overturned" || resolvedCase.Status != "approved" {
		t.Fatalf("expected appeal status overturned & case status approved, got %s / %s", resolvedAppeal.Status, resolvedCase.Status)
	}

	// Verify immutable audit log was created with full evidence
	auditLogs := svc.AuditLogs()
	var foundAudit bool
	for _, log := range auditLogs {
		if log.Action == "moderation.appeal.review" && log.TargetID == appeal.AppealID {
			foundAudit = true
			if log.AdminID != contentAdminID {
				t.Fatalf("expected audit AdminID=%s, got %s", contentAdminID, log.AdminID)
			}
			after := log.AfterState
			if after["false_positive_cleared"] != true {
				t.Fatalf("expected audit after_state false_positive_cleared=true")
			}
			break
		}
	}
	if !foundAudit {
		t.Fatalf("expected immutable audit log entry for moderation.appeal.review")
	}
}

func TestSupportToolsInternalNotesAndSLA(t *testing.T) {
	reg, err := rbac.LoadCanonicalBindings(repoRoot(t))
	if err != nil {
		t.Fatalf("LoadCanonicalBindings: %v", err)
	}
	svc := internaladmin.NewService(reg)
	now := time.Date(2026, 11, 4, 12, 0, 0, 0, time.UTC)
	svc.Now = func() time.Time { return now }

	const (
		supportAdminID = "90000000-0000-4000-8000-000000000004"
		workspaceID    = "22222222-2222-4222-8222-222222222222"
		creatorUserID  = "33333333-3333-4333-8333-333333333333"
		ticketID       = "66666666-6666-4666-8666-666666666601"
		password       = "Admin-Secret-Test-2026!"
		mfaSecret      = "JBSWY3DPEHPK3PXP"
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

	// 1. Create urgent support ticket -> SLA response due in 1h, resolution in 4h (RULE-S26-006)
	ticket, err := svc.CreateSupportTicket(context.Background(), internaladmin.SupportTicketRecord{
		TicketID:     ticketID,
		WorkspaceID:  workspaceID,
		UserID:       creatorUserID,
		TicketNumber: "TK-2026-0001",
		Subject:      "Publishing API timeout for live stream",
		Priority:     "urgent",
		Category:     "technical",
	}, "Live commerce stream is failing to broadcast")
	if err != nil {
		t.Fatalf("CreateSupportTicket failed: %v", err)
	}
	if ticket.SLAResponseDueAt.Sub(now) != 1*time.Hour {
		t.Fatalf("expected urgent SLA response due in 1h, got %v", ticket.SLAResponseDueAt.Sub(now))
	}
	if ticket.SLAResolutionDueAt.Sub(now) != 4*time.Hour {
		t.Fatalf("expected urgent SLA resolution due in 4h, got %v", ticket.SLAResolutionDueAt.Sub(now))
	}

	// 2. Support Admin adds public reply
	_, err = svc.AddSupportTicketMessage(context.Background(), ticketID, "admin", supportAdminID, "We are investigating the connector gateway.", false)
	if err != nil {
		t.Fatalf("AddSupportTicketMessage public failed: %v", err)
	}

	// 3. Support Admin adds internal note (is_internal_note = true)
	_, err = svc.AddSupportTicketMessage(context.Background(), ticketID, "admin", supportAdminID, "Note: Upstream TikTok API returning 504 on endpoint v2/live.", true)
	if err != nil {
		t.Fatalf("AddSupportTicketMessage internal note failed: %v", err)
	}

	// 4. Creator views ticket (isInternalAdmin = false) -> internal note MUST be filtered out!
	_, creatorMsgs, err := svc.GetSupportTicket(context.Background(), ticketID, false, workspaceID)
	if err != nil {
		t.Fatalf("GetSupportTicket creator view failed: %v", err)
	}
	for _, m := range creatorMsgs {
		if m.IsInternalNote {
			t.Fatalf("CRITICAL SECURITY: Creator view leaked internal support note!")
		}
	}
	if len(creatorMsgs) != 2 { // initial user message + public admin reply
		t.Fatalf("expected 2 public messages for creator, got %d", len(creatorMsgs))
	}

	// 5. Admin views ticket (isInternalAdmin = true) -> internal note is visible
	_, adminMsgs, err := svc.GetSupportTicket(context.Background(), ticketID, true, workspaceID)
	if err != nil {
		t.Fatalf("GetSupportTicket admin view failed: %v", err)
	}
	if len(adminMsgs) != 3 { // initial + public reply + internal note
		t.Fatalf("expected 3 total messages for admin, got %d", len(adminMsgs))
	}
}

func TestFraudDetectionAutoEscalationAndAction(t *testing.T) {
	reg, err := rbac.LoadCanonicalBindings(repoRoot(t))
	if err != nil {
		t.Fatalf("LoadCanonicalBindings: %v", err)
	}
	svc := internaladmin.NewService(reg)
	now := time.Date(2026, 11, 4, 13, 0, 0, 0, time.UTC)
	svc.Now = func() time.Time { return now }

	const (
		opsAdminID  = "90000000-0000-4000-8000-000000000002"
		techAdminID = "90000000-0000-4000-8000-000000000005"
		workspaceID = "22222222-2222-4222-8222-222222222222"
		freshCaseID = "55555555-5555-4555-8555-555555555501"
		staleCaseID = "55555555-5555-4555-8555-555555555502"
		password    = "Admin-Secret-Test-2026!"
		mfaSecret   = "JBSWY3DPEHPK3PXP"
	)

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

	// Seed fresh fraud case (detected 2 hours ago)
	_, _ = svc.SeedFraudCase(internaladmin.FraudCaseRecord{
		FraudCaseID:     freshCaseID,
		WorkspaceID:     workspaceID,
		SignalType:      "credit_velocity_spike",
		RiskScore:       75,
		DetectedAt:      now.Add(-2 * time.Hour),
		FinancialImpact: 12000000,
	})
	// Seed stale fraud case (detected 50 hours ago -> auto-escalation per RULE-S26-007)
	_, _ = svc.SeedFraudCase(internaladmin.FraudCaseRecord{
		FraudCaseID:     staleCaseID,
		WorkspaceID:     workspaceID,
		SignalType:      "referral_self_ring",
		RiskScore:       90,
		DetectedAt:      now.Add(-50 * time.Hour),
		FinancialImpact: 35000000,
	})

	cases, err := svc.ListFraudCases(context.Background(), "", 0)
	if err != nil {
		t.Fatalf("ListFraudCases failed: %v", err)
	}
	var freshEscalated, staleEscalated bool
	for _, c := range cases {
		if c.FraudCaseID == freshCaseID {
			freshEscalated = c.Escalated
		}
		if c.FraudCaseID == staleCaseID {
			staleEscalated = c.Escalated
		}
	}
	if freshEscalated {
		t.Fatalf("expected fresh case to not be escalated")
	}
	if !staleEscalated {
		t.Fatalf("expected >48h case to be auto-escalated (RULE-S26-007)")
	}

	// Tech Admin attempting ActionFraudCase is rejected by privileged boundary
	if _, err := svc.ActionFraudCase(context.Background(), staleCaseID, "confirmed_fraud", "credits_frozen", techAdminID, "Freezing"); !errors.Is(err, internaladmin.ErrPrivilegedRoleBoundaryViolation) {
		t.Fatalf("expected Tech Admin to be blocked from ActionFraudCase, got %v", err)
	}

	// Ops Admin actions fraud case -> confirms fraud and freezes credits
	actioned, err := svc.ActionFraudCase(context.Background(), staleCaseID, "confirmed_fraud", "credits_frozen", opsAdminID, "Confirmed self-referral loop using virtual credit cards.")
	if err != nil {
		t.Fatalf("ActionFraudCase failed: %v", err)
	}
	if actioned.Status != "confirmed_fraud" || actioned.ActionTaken != "credits_frozen" {
		t.Fatalf("expected confirmed_fraud with credits_frozen, got %s / %s", actioned.Status, actioned.ActionTaken)
	}
}

func TestTechnicalHealthStrictlySegregatedFromBusinessMetrics(t *testing.T) {
	reg, err := rbac.LoadCanonicalBindings(repoRoot(t))
	if err != nil {
		t.Fatalf("LoadCanonicalBindings: %v", err)
	}
	svc := internaladmin.NewService(reg)
	now := time.Date(2026, 11, 4, 14, 0, 0, 0, time.UTC)
	svc.Now = func() time.Time { return now }

	ctx := context.Background()

	// 1. Initial Operational Health
	opHealth, err := svc.GetOperationalHealth(ctx)
	if err != nil {
		t.Fatalf("GetOperationalHealth failed: %v", err)
	}
	if opHealth.SystemUptimePct != 99.98 || opHealth.TechnicalHealthScore != 98 {
		t.Fatalf("expected uptime 99.98%% and score 98, got uptime=%.2f score=%d", opHealth.SystemUptimePct, opHealth.TechnicalHealthScore)
	}

	// 2. Initial Business Metrics
	bizMetrics, err := svc.GetBusinessMetrics(ctx)
	if err != nil {
		t.Fatalf("GetBusinessMetrics failed: %v", err)
	}
	if bizMetrics.MRRMicroUnits != 52000000000 || bizMetrics.ChurnRatePct != 1.8 {
		t.Fatalf("expected MRR $52k and churn 1.8%%, got MRR=%d churn=%.2f", bizMetrics.MRRMicroUnits, bizMetrics.ChurnRatePct)
	}

	// 3. Mutate business metrics severely: MRR drops to 0, Churn spikes to 65%
	svc.SetBusinessMetrics(internaladmin.BusinessMetricsRecord{
		MRRMicroUnits:         0,
		ActiveWorkspacesCount: 10,
		NetRevenueMicroUnits:  -5000000000,
		ChurnRatePct:          65.0,
		CreditsConsumedTotal:  0,
		NewSignupsCount:       0,
		WindowLabel:           "30d",
		GeneratedAt:           now,
	})

	// 4. Invariant Assertion: Technical health MUST NOT change despite severe business drop!
	recheckedHealth, err := svc.GetOperationalHealth(ctx)
	if err != nil {
		t.Fatalf("rechecked GetOperationalHealth failed: %v", err)
	}
	if recheckedHealth.SystemUptimePct != 99.98 || recheckedHealth.TechnicalHealthScore != 98 || recheckedHealth.ErrorRatePct != 0.04 {
		t.Fatalf("CRITICAL CONTRACT VIOLATION: Business metrics change altered technical health! Got uptime=%.2f score=%d error=%.2f",
			recheckedHealth.SystemUptimePct, recheckedHealth.TechnicalHealthScore, recheckedHealth.ErrorRatePct)
	}
}

func TestAdminSessionExpiryAndAgeBounds(t *testing.T) {
	reg, err := rbac.LoadCanonicalBindings(repoRoot(t))
	if err != nil {
		t.Fatalf("LoadCanonicalBindings: %v", err)
	}
	svc := internaladmin.NewService(reg)
	now := time.Date(2026, 11, 7, 14, 0, 0, 0, time.UTC)
	svc.Now = func() time.Time { return now }

	adminID := "11111111-2222-4333-8444-555555555599"
	password := "AdminBoundedSession#2026!"
	mfaSecret := "JBSWY3DPEHPK3PXP"
	if err := svc.RegisterAdmin(internaladmin.InternalAdminRecord{
		AdminID:      adminID,
		Email:        "bounded@internal.creativanta.vn",
		FullName:     "Bounded Session Admin",
		PasswordHash: internaladmin.HashAdminPassword(password),
		AdminRole:    rbac.AdminRoleSuper,
		MFASecret:    mfaSecret,
		MFAEnabled:   true,
		Status:       "active",
	}); err != nil {
		t.Fatalf("RegisterAdmin: %v", err)
	}

	totp, err := internaladmin.GenerateTOTPCode(mfaSecret, now)
	if err != nil {
		t.Fatalf("GenerateTOTPCode: %v", err)
	}
	vpnCtx := internaladmin.WithTrustedVPNTransport(context.Background(), "100.64.0.42")
	loginResp, err := svc.Login(vpnCtx, connect.NewRequest(&adminv1.LoginRequest{
		Email:       "bounded@internal.creativanta.vn",
		Password:    password,
		TotpCode:    totp,
		VpnVerified: true,
	}))
	if err != nil {
		t.Fatalf("Login: %v", err)
	}
	sid := loginResp.Msg.GetSessionId().GetValue()
	rawToken := loginResp.Msg.GetSessionToken()
	tokenHash := internaladmin.HashSessionToken(rawToken)
	actorCtx := internaladmin.WithAdminActor(vpnCtx, internaladmin.AdminActorContext{
		SessionID:   sid,
		AdminID:     adminID,
		AdminRole:   rbac.AdminRoleSuper,
		VPNVerified: true,
		MFAVerified: true,
	})

	// Baseline: newly issued session (CreatedAt=now, ExpiresAt=now+8h) verifies cleanly on both transportauth.Verifier and RPC boundary.
	if _, err := svc.Verify(vpnCtx, rawToken); err != nil {
		t.Fatalf("baseline Verify failed: %v", err)
	}
	if _, err := svc.GetDashboard(actorCtx, connect.NewRequest(&adminv1.GetDashboardRequest{})); err != nil {
		t.Fatalf("baseline GetDashboard failed: %v", err)
	}

	makeSession := func(createdAt, expiresAt time.Time) internaladmin.AdminSessionRecord {
		return internaladmin.AdminSessionRecord{
			SessionID:   sid,
			AdminID:     adminID,
			AdminRole:   rbac.AdminRoleSuper,
			TokenHash:   tokenHash,
			IPAddress:   "100.64.0.42",
			UserAgent:   "BoundsTest",
			VPNVerified: true,
			MFAVerified: true,
			CreatedAt:   createdAt,
			ExpiresAt:   expiresAt,
		}
	}

	// Case 1: Zero/NULL ExpiresAt must be rejected (never treated as immortal).
	svc.RegisterAdminSession(makeSession(now, time.Time{}))
	if _, err := svc.Verify(vpnCtx, rawToken); !errors.Is(err, internaladmin.ErrAdminSessionExpired) {
		t.Fatalf("expected zero/NULL ExpiresAt to fail Verify with ErrAdminSessionExpired, got %v", err)
	}
	if _, err := svc.GetDashboard(actorCtx, connect.NewRequest(&adminv1.GetDashboardRequest{})); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected zero/NULL ExpiresAt to fail GetDashboard with Unauthenticated, got %v", err)
	}

	// Case 2: Zero CreatedAt must be rejected even if ExpiresAt is in the future.
	svc.RegisterAdminSession(makeSession(time.Time{}, now.Add(2*time.Hour)))
	if _, err := svc.Verify(vpnCtx, rawToken); !errors.Is(err, internaladmin.ErrAdminSessionExpired) {
		t.Fatalf("expected zero CreatedAt to fail Verify with ErrAdminSessionExpired, got %v", err)
	}
	if _, err := svc.GetDashboard(actorCtx, connect.NewRequest(&adminv1.GetDashboardRequest{})); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected zero CreatedAt to fail GetDashboard with Unauthenticated, got %v", err)
	}

	// Case 3: Session age >= 8h from CreatedAt must be rejected even if ExpiresAt is still in the future.
	svc.RegisterAdminSession(makeSession(now.Add(-9*time.Hour), now.Add(1*time.Hour)))
	if _, err := svc.Verify(vpnCtx, rawToken); !errors.Is(err, internaladmin.ErrAdminSessionExpired) {
		t.Fatalf("expected session older than 8h from CreatedAt to fail Verify with ErrAdminSessionExpired, got %v", err)
	}
	if _, err := svc.GetDashboard(actorCtx, connect.NewRequest(&adminv1.GetDashboardRequest{})); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected session older than 8h from CreatedAt to fail GetDashboard with Unauthenticated, got %v", err)
	}

	// Case 4: Session with ExpiresAt > CreatedAt + 8h must be rejected even when CreatedAt is fresh.
	svc.RegisterAdminSession(makeSession(now.Add(-10*time.Minute), now.Add(-10*time.Minute).Add(internaladmin.AdminSessionTTL+time.Minute)))
	if _, err := svc.Verify(vpnCtx, rawToken); !errors.Is(err, internaladmin.ErrAdminSessionExpired) {
		t.Fatalf("expected session with ExpiresAt > CreatedAt + 8h to fail Verify with ErrAdminSessionExpired, got %v", err)
	}
	if _, err := svc.GetDashboard(actorCtx, connect.NewRequest(&adminv1.GetDashboardRequest{})); connect.CodeOf(err) != connect.CodeUnauthenticated {
		t.Fatalf("expected session with ExpiresAt > CreatedAt + 8h to fail GetDashboard with Unauthenticated, got %v", err)
	}

	// Case 5: Session with ExpiresAt <= CreatedAt must be rejected.
	svc.RegisterAdminSession(makeSession(now, now))
	if _, err := svc.Verify(vpnCtx, rawToken); !errors.Is(err, internaladmin.ErrAdminSessionExpired) {
		t.Fatalf("expected session with ExpiresAt <= CreatedAt to fail Verify with ErrAdminSessionExpired, got %v", err)
	}

	// Restore valid timestamps and verify unverified VPN transport evidence is rejected.
	svc.RegisterAdminSession(makeSession(now, now.Add(internaladmin.AdminSessionTTL)))
	untrustedVPNCtx := internaladmin.WithTrustedVPNTransport(context.Background(), "203.0.113.99")
	if _, err := svc.Verify(untrustedVPNCtx, rawToken); !errors.Is(err, internaladmin.ErrVPNRequired) {
		t.Fatalf("expected non-VPN transport evidence to fail Verify with ErrVPNRequired, got %v", err)
	}
	untrustedActorCtx := internaladmin.WithAdminActor(untrustedVPNCtx, internaladmin.AdminActorContext{
		SessionID:   sid,
		AdminID:     adminID,
		AdminRole:   rbac.AdminRoleSuper,
		VPNVerified: true,
		MFAVerified: true,
	})
	if _, err := svc.GetDashboard(untrustedActorCtx, connect.NewRequest(&adminv1.GetDashboardRequest{})); connect.CodeOf(err) != connect.CodePermissionDenied {
		t.Fatalf("expected non-VPN transport evidence to fail GetDashboard with PermissionDenied, got %v", err)
	}
}
