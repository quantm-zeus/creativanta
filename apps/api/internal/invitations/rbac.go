package invitations

// WorkspaceRole mirrors the 7 canonical workspace roles in
// docs/04_contracts/database_schema.md §4.3 and
// docs/04_contracts/rbac_permission_matrix.md §2.1.
type WorkspaceRole string

const (
	RoleOwner       WorkspaceRole = "owner"
	RoleAdmin       WorkspaceRole = "admin"
	RoleManager     WorkspaceRole = "manager"
	RoleEditor      WorkspaceRole = "editor"
	RoleContributor WorkspaceRole = "contributor"
	RoleViewer      WorkspaceRole = "viewer"
	RoleExternal    WorkspaceRole = "external"
)

// PermissionKey mirrors exact canonical keys in
// docs/04_contracts/rbac_permission_matrix.md §2.1 and §2.16.
type PermissionKey string

const (
	PermWorkspaceSettingsManage PermissionKey = "workspace:settings:manage"
	PermWorkspaceMembersInvite  PermissionKey = "workspace:members:invite"
	PermWorkspaceMembersRemove  PermissionKey = "workspace:members:remove"
	PermWorkspaceRolesAssign    PermissionKey = "workspace:roles:assign"
	PermWorkspaceRead           PermissionKey = "workspace:read"
	PermUserSelf                PermissionKey = "user:self"
)

var roleRank = map[WorkspaceRole]int{
	RoleOwner:       7,
	RoleAdmin:       6,
	RoleManager:     5,
	RoleEditor:      4,
	RoleContributor: 3,
	RoleViewer:      2,
	RoleExternal:    1,
}

var rolePermissions = map[WorkspaceRole]map[PermissionKey]bool{
	RoleOwner: {
		PermWorkspaceSettingsManage: true,
		PermWorkspaceMembersInvite:  true,
		PermWorkspaceMembersRemove:  true,
		PermWorkspaceRolesAssign:    true,
		PermWorkspaceRead:           true,
		PermUserSelf:                true,
	},
	RoleAdmin: {
		PermWorkspaceSettingsManage: true,
		PermWorkspaceMembersInvite:  true,
		PermWorkspaceMembersRemove:  true,
		PermWorkspaceRolesAssign:    true,
		PermWorkspaceRead:           true,
		PermUserSelf:                true,
	},
	RoleManager: {
		PermWorkspaceMembersInvite: true,
		PermWorkspaceRead:          true,
		PermUserSelf:               true,
	},
	RoleEditor: {
		PermWorkspaceRead: true,
		PermUserSelf:      true,
	},
	RoleContributor: {
		PermWorkspaceRead: true,
		PermUserSelf:      true,
	},
	RoleViewer: {
		PermWorkspaceRead: true,
		PermUserSelf:      true,
	},
	RoleExternal: {
		PermUserSelf: true,
	},
}

// ValidWorkspaceRole returns true only for one of the 7 canonical workspace roles.
func ValidWorkspaceRole(role WorkspaceRole) bool {
	_, ok := roleRank[role]
	return ok
}

// ValidInvitableRole returns true only for the 6 non-owner canonical roles.
// Per docs/04_contracts/api_behavior_contracts.md §4 ("role excluding owner") and
// docs/04_contracts/database_schema.md §26.14 (idx_one_active_workspace_owner),
// workspace ownership can never be granted via invitation.
func ValidInvitableRole(role WorkspaceRole) bool {
	return ValidWorkspaceRole(role) && role != RoleOwner
}

// HasWorkspacePermission evaluates canonical workspace RBAC permissions fail-closed.
// Unknown roles or unknown permission keys always return false.
func HasWorkspacePermission(role WorkspaceRole, perm PermissionKey) bool {
	perms, ok := rolePermissions[role]
	if !ok {
		return false
	}
	return perms[perm]
}

// CanRoleInviteTarget enforces both workspace:members:invite and the canonical
// inviter -> invitee hierarchy:
//   - Owner (rank 7) -> Admin, Manager, Editor, Contributor, Viewer, External
//   - Admin (rank 6) -> Manager, Editor, Contributor, Viewer, External
//   - Manager (rank 5) -> Editor, Contributor, Viewer, External
//   - Editor / Contributor / Viewer / External -> none
//   - Target RoleOwner -> always false
func CanRoleInviteTarget(inviterRole, targetRole WorkspaceRole) bool {
	if !HasWorkspacePermission(inviterRole, PermWorkspaceMembersInvite) {
		return false
	}
	if !ValidInvitableRole(targetRole) {
		return false
	}
	return roleRank[inviterRole] > roleRank[targetRole]
}

// CanRoleResendInvitation enforces docs/02_features/platform/auth.md RULE-AUTH-005
// ("Expired invites can be re-sent by workspace Admin+") and
// docs/04_contracts/rpc_permission_bindings.csv (WorkspaceService/ResendInvite ->
// workspace:settings:manage, held only by Owner and Admin) plus the target role ceiling.
func CanRoleResendInvitation(actorRole, targetRole WorkspaceRole) bool {
	if !HasWorkspacePermission(actorRole, PermWorkspaceSettingsManage) {
		return false
	}
	return CanRoleInviteTarget(actorRole, targetRole)
}

// CanRoleCancelInvitation enforces workspace:settings:manage and strict
// target-role hierarchy so an actor cannot cancel an invitation above their own
// management ceiling.
//
// [CONFLICT: docs/04_contracts/rpc_permission_bindings.csv line 346 lists
// WorkspaceService/CancelInvite with permission_key=workspace:settings:manage
// and role_envelope=Manager+, while docs/04_contracts/rbac_permission_matrix.md §2.1
// grants workspace:settings:manage only to Owner and Admin — enforcing the exact
// named RBAC permission workspace:settings:manage fail-closed (Owner/Admin only)
// per AGENTS.md and docs/04_contracts/ precedence.]
func CanRoleCancelInvitation(actorRole, targetRole WorkspaceRole) bool {
	if !HasWorkspacePermission(actorRole, PermWorkspaceSettingsManage) {
		return false
	}
	return CanRoleInviteTarget(actorRole, targetRole)
}
