package rbac

import (
	"context"
	"errors"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

func repoRootDir(t *testing.T) string {
	t.Helper()
	return filepath.Join("..", "..", "..", "..")
}

func TestMatrixMatchesCanonicalMarkdownContractCellForCell(t *testing.T) {
	path := filepath.Join(repoRootDir(t), "docs", "04_contracts", "rbac_permission_matrix.md")
	rawBytes, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("read rbac_permission_matrix.md: %v", err)
	}
	lines := strings.Split(string(rawBytes), "\n")

	wsRoles := CanonicalWorkspaceRoles()
	admRoles := CanonicalAdminRoles()

	section := ""
	parsedWS := 0
	parsedAdmin := 0

	mapMarkdownSymbol := func(sym string) AccessDecision {
		switch sym {
		case "✅":
			return AccessAllow
		case "⚠️":
			return AccessConstrained
		default:
			return AccessDeny
		}
	}

	for _, line := range lines {
		switch {
		case strings.Contains(line, "## 2. Core Permission Matrix"):
			section = "ws"
		case strings.Contains(line, "## 3. Internal Admin RBAC"):
			section = "admin"
		case strings.HasPrefix(line, "## 4."):
			section = "end"
		}

		if !strings.HasPrefix(line, "|") || !strings.Contains(line, ":") || strings.Contains(line, "---") ||
			strings.Contains(line, "Permission") || strings.Contains(line, "Example") {
			continue
		}

		parts := strings.Split(strings.Trim(strings.TrimSpace(line), "|"), "|")
		for i := range parts {
			parts[i] = strings.Trim(strings.TrimSpace(parts[i]), "`")
		}
		perm := parts[0]
		if !strings.Contains(perm, ":") || strings.Contains(perm, " ") {
			continue
		}

		if section == "ws" {
			if len(parts)-1 != len(wsRoles) {
				t.Fatalf("permission %s has %d role columns, want %d", perm, len(parts)-1, len(wsRoles))
			}
			parsedWS++
			for i, role := range wsRoles {
				want := mapMarkdownSymbol(parts[i+1])
				got, err := LookupWorkspaceDecision(role, perm)
				if err != nil {
					t.Fatalf("LookupWorkspaceDecision(%q, %q) failed: %v", role, perm, err)
				}
				if got != want {
					t.Fatalf("mismatch for %s [%s]: got %v, want %v", perm, role, got, want)
				}
			}
		} else if section == "admin" {
			if len(parts)-1 != len(admRoles) {
				t.Fatalf("admin permission %s has %d role columns, want %d", perm, len(parts)-1, len(admRoles))
			}
			parsedAdmin++
			for i, role := range admRoles {
				want := mapMarkdownSymbol(parts[i+1])
				got, err := LookupAdminDecision(role, perm)
				if err != nil {
					t.Fatalf("LookupAdminDecision(%q, %q) failed: %v", role, perm, err)
				}
				if got != want {
					t.Fatalf("mismatch for %s [%s]: got %v, want %v", perm, role, got, want)
				}
			}
		}
	}

	if parsedWS != WorkspacePermissionCount() {
		t.Fatalf("parsed %d workspace permissions from markdown, matrix has %d", parsedWS, WorkspacePermissionCount())
	}
	if parsedAdmin != AdminPermissionCount() {
		t.Fatalf("parsed %d admin permissions from markdown, matrix has %d", parsedAdmin, AdminPermissionCount())
	}
}

func TestLoadAll1188RPCPermissionBindingsAndEnforceFailClosed(t *testing.T) {
	reg, err := LoadCanonicalBindings(repoRootDir(t))
	if err != nil {
		t.Fatalf("LoadCanonicalBindings failed: %v", err)
	}
	if reg.Count() != 1188 {
		t.Fatalf("expected 1,188 RPC permission bindings, got %d", reg.Count())
	}

	// Unbound RPC must fail closed.
	if _, err := reg.Authorize("NonExistentService/SecretMethod", PolicyContext{
		ActorUserID: "11111111-1111-4111-8111-111111111111",
		Role:        RoleOwner,
	}); !errors.Is(err, ErrUnboundRPC) {
		t.Fatalf("expected ErrUnboundRPC, got %v", err)
	}

	// Connect full procedure path normalization works.
	if _, err := reg.Authorize("/creativanta.workspace.v1.WorkspaceService/Get", PolicyContext{
		ActorUserID: "11111111-1111-4111-8111-111111111111",
		Role:        RoleViewer,
	}); err != nil {
		t.Fatalf("expected Viewer to be authorized for WorkspaceService/Get, got %v", err)
	}

	// Owner-only RPCs deny Admin and Manager.
	ownerOnlyRPCs := []string{
		"WorkspaceService/Delete",
		"BillingService/UpdateSubscription",
		"BillingService/PurchaseCredits",
	}
	for _, rpc := range ownerOnlyRPCs {
		if _, ok := reg.Lookup(rpc); !ok {
			continue
		}
		if _, err := reg.Authorize(rpc, PolicyContext{
			ActorUserID: "11111111-1111-4111-8111-111111111111",
			Role:        RoleAdmin,
		}); !errors.Is(err, ErrPermissionDenied) {
			t.Fatalf("expected Admin to be denied on Owner-only RPC %s, got %v", rpc, err)
		}
		if _, err := reg.Authorize(rpc, PolicyContext{
			ActorUserID: "11111111-1111-4111-8111-111111111111",
			Role:        RoleOwner,
		}); err != nil {
			t.Fatalf("expected Owner to be allowed on %s, got %v", rpc, err)
		}
	}

	// Member management RPCs: Manager can invite, but only Admin+ can UpdateRole or RemoveMember.
	if _, err := reg.Authorize("WorkspaceService/InviteMember", PolicyContext{
		ActorUserID: "11111111-1111-4111-8111-111111111111",
		Role:        RoleManager,
	}); err != nil {
		t.Fatalf("expected Manager to be allowed on WorkspaceService/InviteMember, got %v", err)
	}
	if _, err := reg.Authorize("WorkspaceService/UpdateRole", PolicyContext{
		ActorUserID: "11111111-1111-4111-8111-111111111111",
		Role:        RoleManager,
	}); !errors.Is(err, ErrPermissionDenied) {
		t.Fatalf("expected Manager to be denied on WorkspaceService/UpdateRole, got %v", err)
	}
	if _, err := reg.Authorize("WorkspaceService/RemoveMember", PolicyContext{
		ActorUserID: "11111111-1111-4111-8111-111111111111",
		Role:        RoleManager,
	}); !errors.Is(err, ErrPermissionDenied) {
		t.Fatalf("expected Manager to be denied on WorkspaceService/RemoveMember, got %v", err)
	}
}

func TestConstraintRulesExternalContributorApprovalAndImpersonation(t *testing.T) {
	reg, err := LoadCanonicalBindings(repoRootDir(t))
	if err != nil {
		t.Fatalf("LoadCanonicalBindings: %v", err)
	}

	// 1. External Collaborator: denied idea:read unless ObjectSharedExternally == true.
	if err := CheckWorkspacePermission("idea:read", PolicyContext{
		Role:                   RoleExternal,
		ObjectSharedExternally: false,
	}); !errors.Is(err, ErrPermissionDenied) {
		t.Fatalf("expected External without share to be denied idea:read, got %v", err)
	}
	if err := CheckWorkspacePermission("idea:read", PolicyContext{
		Role:                   RoleExternal,
		ObjectSharedExternally: true,
	}); err != nil {
		t.Fatalf("expected External with explicit share to be allowed idea:read, got %v", err)
	}
	// External is always denied financial/profit/order access even if ObjectSharedExternally == true.
	if err := CheckWorkspacePermission("profit:read", PolicyContext{
		Role:                   RoleExternal,
		ObjectSharedExternally: true,
	}); !errors.Is(err, ErrPermissionDenied) {
		t.Fatalf("expected External to be denied profit:read, got %v", err)
	}

	// 2. Contributor: script:edit requires IsObjectAuthor == true; asset:generate requires WithinContributorQuota == true.
	if err := CheckWorkspacePermission("script:edit", PolicyContext{
		Role:           RoleContributor,
		IsObjectAuthor: false,
	}); !errors.Is(err, ErrPermissionDenied) {
		t.Fatalf("expected Contributor editing another author script to be denied")
	}
	if err := CheckWorkspacePermission("script:edit", PolicyContext{
		Role:           RoleContributor,
		IsObjectAuthor: true,
	}); err != nil {
		t.Fatalf("expected Contributor editing own script to be allowed: %v", err)
	}

	// 3. user:self and support:own deny cross-user access even for Owner.
	if err := CheckWorkspacePermission("user:self", PolicyContext{
		ActorUserID:       "user-1",
		TargetOwnerUserID: "user-2",
		Role:              RoleOwner,
	}); !errors.Is(err, ErrPermissionDenied) {
		t.Fatalf("expected user:self cross-user access to be denied")
	}
	if err := CheckWorkspacePermission("support:own", PolicyContext{
		ActorUserID:       "user-1",
		TargetOwnerUserID: "user-2",
		Role:              RoleOwner,
	}); !errors.Is(err, ErrPermissionDenied) {
		t.Fatalf("expected support:own cross-user access to be denied")
	}

	// 4. Approval-required actions fail with ErrApprovalRequired when policy is active and not approved.
	if err := CheckWorkspacePermission("publish:execute", PolicyContext{
		Role:                 RoleManager,
		ApprovalPolicyActive: true,
		ApprovalGranted:      false,
	}); !errors.Is(err, ErrApprovalRequired) {
		t.Fatalf("expected ErrApprovalRequired for unapproved publish:execute, got %v", err)
	}
	if err := CheckWorkspacePermission("publish:execute", PolicyContext{
		Role:                 RoleManager,
		ApprovalPolicyActive: true,
		ApprovalGranted:      true,
	}); err != nil {
		t.Fatalf("expected approved publish:execute to succeed: %v", err)
	}

	// 5. Impersonation is strictly read-only for every role (including Owner and Super Admin).
	if err := CheckWorkspacePermission("script:create", PolicyContext{
		Role:            RoleOwner,
		IsImpersonation: true,
	}); !errors.Is(err, ErrImpersonationReadOnly) {
		t.Fatalf("expected ErrImpersonationReadOnly during workspace impersonation mutation, got %v", err)
	}
	if err := CheckAdminPermission("admin:user:suspend", PolicyContext{
		AdminRole:       AdminRoleSuper,
		IsImpersonation: true,
		AuditReason:     "test",
	}, true); !errors.Is(err, ErrImpersonationReadOnly) {
		t.Fatalf("expected ErrImpersonationReadOnly during admin impersonation mutation, got %v", err)
	}

	// 6. Workspace role cannot authenticate as Internal Admin role.
	if err := CheckAdminPermission("admin:user:read", PolicyContext{
		AdminRole: RoleOwner,
	}, false); !errors.Is(err, ErrUnknownRole) {
		t.Fatalf("expected workspace role to be rejected by CheckAdminPermission, got %v", err)
	}

	// 7. PermissionChecker.Require context integration.
	ctx := WithPolicyContext(context.Background(), PolicyContext{
		ActorUserID: "user-1",
		Role:        RoleAdmin,
	})
	if err := reg.Require(ctx, "WorkspaceService/UpdateRole", "member-1"); err != nil {
		t.Fatalf("PermissionChecker.Require failed for Admin on UpdateRole: %v", err)
	}
}
