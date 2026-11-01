// Package invitations implements an isolated, fail-closed domain boundary for
// workspace invitation issuance, preview, acceptance, revocation, resend, and
// delayed/out-of-order provider membership reconciliation under P0-03.
//
// Production status: PARTIAL / NOT MOUNTED.
// No ConnectRPC or HTTP route is registered in cmd/api or cmd/admin-api by this
// package because the following gates remain open:
//  1. Live Clerk Organization Invitations API & production credentials (external gate).
//  2. Durable PostgreSQL sqlc/pgx persistence for invitations/idempotency/audit/outbox.
//  3. P0-04 PostgreSQL ENABLE/FORCE ROW LEVEL SECURITY, app_user grants, and
//     pre-selection discovery policy verification.
//  4. Contract reconciliation for screen-promoted RPC bindings (see [CONFLICT] notes below).
//
// Canonical source alignment and [CONFLICT] resolutions:
//   - Pending invitation ownership: Per docs/02_features/platform/auth.md
//     ("Clerk owns pending invitation records. The application enforces a
//     seven-day maximum invitation age or the provider's shorter expiry"), no
//     shadow workspace_invitations DB table or uncanonical schema columns are
//     invented. Local persisted types mirror docs/04_contracts/database_schema.md
//     (workspaces, users, workspace_members, audit_events, api_idempotency_records).
//   - [CONFLICT: docs/04_contracts/api_behavior_contracts.md §4 says
//     "WorkspaceService/InviteMember: workspace:members:invite; Manager can invite
//     Editor or below; Admin cannot grant Owner", while
//     docs/02_features/platform/reporting_admin_billing.md RULE-M23-A02 says
//     "Owner manages all; Admin manages Manager and below; Manager invites Editor
//     and below" — using strict downward delegation (Owner -> Admin..External,
//     Admin -> Manager..External, Manager -> Editor..External, Owner never
//     invitable) which satisfies both contracts fail-closed.]
//   - [CONFLICT: docs/04_contracts/rpc_permission_bindings.csv lines 344-345 bind
//     WorkspaceService/AcceptInvite and DeclineInvite to workspace:settings:manage
//     (Contributor+), whereas docs/02_features/platform/auth.md RULE-AUTH-005 and
//     AC-5 specify that an invited user holds no active membership in the target
//     workspace prior to accepting — authorizing acceptance at the domain boundary
//     via verified Clerk identity + verified matching email + server-validated
//     Clerk invitation token + server-reverified inviter role authority, while
//     keeping production RPC transport unmounted until the CSV binding is updated.]
package invitations
