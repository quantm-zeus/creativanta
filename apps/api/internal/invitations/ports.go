package invitations

import (
	"context"
	"fmt"
	"strings"
	"time"
)

// IdentityVerifier resolves a caller bearer token into a verified Clerk session
// and canonical provider user profile (issuer/audience/azp/JWKS/active session).
// Production requires a live Clerk verifier; unconfigured implementations fail closed.
type IdentityVerifier interface {
	VerifyActor(ctx context.Context, bearerToken string) (VerifiedClerkActor, error)
}

// CreateProviderInvitationInput carries server-validated parameters to Clerk's
// Organization Invitations API (docs/02_features/platform/auth.md line 192).
type CreateProviderInvitationInput struct {
	ClerkOrganizationID string
	WorkspaceID         string
	InviteeEmail        string
	Role                WorkspaceRole
	InviterUserID       string
	ExpiresAt           time.Time
	IdempotencyKey      string
}

// AcceptProviderInvitationInput carries verified actor + token parameters to
// synchronize invitation acceptance with Clerk.
type AcceptProviderInvitationInput struct {
	InvitationToken     string
	ClerkOrganizationID string
	ClerkUserID         string
	VerifiedEmail       string
}

// InvitationProvider abstracts Clerk Organization Invitations API operations.
// Clerk owns pending invitation records; Creativanta enforces the 7-day maximum
// age, inviter RBAC ceiling, email match, and cross-tenant org binding.
type InvitationProvider interface {
	CreateInvitation(ctx context.Context, in CreateProviderInvitationInput) (ProviderInvitation, error)
	ResolveInvitationToken(ctx context.Context, invitationToken string) (ProviderInvitation, error)
	GetInvitationByID(ctx context.Context, clerkOrganizationID, providerInvitationID string) (ProviderInvitation, error)
	MarkInvitationAccepted(ctx context.Context, in AcceptProviderInvitationInput) (ProviderInvitation, error)
	MarkInvitationDeclined(ctx context.Context, clerkOrganizationID, providerInvitationID, clerkUserID string) (ProviderInvitation, error)
	RevokeInvitation(ctx context.Context, clerkOrganizationID, providerInvitationID, actorUserID string) (ProviderInvitation, error)
}

// TxRepository represents an atomic database transaction scoped to the validated
// user/tenant context (in production: pgx/sqlc with SET LOCAL app.current_user_id
// and SET LOCAL app.current_tenant_id under NOBYPASSRLS app_user per
// docs/04_contracts/database_schema.md §1 & §4.3B).
type TxRepository interface {
	GetWorkspaceByID(ctx context.Context, workspaceID string) (WorkspaceRecord, bool, error)
	GetWorkspaceByClerkOrgID(ctx context.Context, clerkOrgID string) (WorkspaceRecord, bool, error)

	GetUserByClerkID(ctx context.Context, clerkID string) (UserRecord, bool, error)
	GetUserByID(ctx context.Context, userID string) (UserRecord, bool, error)
	UpsertVerifiedUser(ctx context.Context, user UserRecord) (UserRecord, bool, error) // bool = createdNow

	GetWorkspaceMember(ctx context.Context, workspaceID, userID string) (WorkspaceMemberRecord, bool, error)
	GetActiveMemberByEmail(ctx context.Context, workspaceID, normalizedEmail string) (WorkspaceMemberRecord, bool, error)
	UpsertWorkspaceMember(ctx context.Context, member WorkspaceMemberRecord) (WorkspaceMemberRecord, error)

	GetIdempotencyRecord(ctx context.Context, workspaceID, actorID, rpc, key string, now time.Time) (IdempotencyRecord, bool, error)
	SaveIdempotencyRecord(ctx context.Context, rec IdempotencyRecord) error

	HasProcessedWebhookEvent(ctx context.Context, workspaceID, externalEventID string) (bool, error)
	RecordProcessedWebhookEvent(ctx context.Context, workspaceID, externalEventID string, processedAt time.Time) error

	AppendAuditEvent(ctx context.Context, event AuditEventRecord) error
	AppendOutboxEvent(ctx context.Context, event DomainEventRecord) error
}

// Repository executes atomic domain mutations without holding database locks
// during external Clerk network I/O (docs/04_contracts/api_behavior_contracts.md §5).
type Repository interface {
	WithinTx(ctx context.Context, workspaceID, actorUserID string, fn func(tx TxRepository) error) error
}

// RuntimeGates explicitly tracks external and cross-slice prerequisites that
// prevent mounting production endpoints in P0-03.
type RuntimeGates struct {
	ClerkProviderConfigured bool // Live Clerk instance, JWKS, and Organization Invitations API secret
	DurableStorageReady     bool // Real PostgreSQL migrations + sqlc/pgx persistence (not in-memory)
	TenantRLSEnforced       bool // P0-04 ENABLE/FORCE RLS + app_user grants verified
	RPCBindingsReconciled   bool // rpc_permission_bindings.csv AcceptInvite/DeclineInvite/CancelInvite reconciled
}

// CheckProductionReadiness fails closed unless every external and phase gate
// required for production HTTP/Connect exposure is explicitly satisfied.
func (g RuntimeGates) CheckProductionReadiness() error {
	var missing []string
	if !g.ClerkProviderConfigured {
		missing = append(missing, "clerk_organization_invitations_api")
	}
	if !g.DurableStorageReady {
		missing = append(missing, "durable_postgresql_persistence")
	}
	if !g.TenantRLSEnforced {
		missing = append(missing, "p0_04_tenant_rls_and_grants")
	}
	if !g.RPCBindingsReconciled {
		missing = append(missing, "rpc_permission_bindings_reconciliation")
	}
	if len(missing) > 0 {
		return fmt.Errorf("%w: missing [%s]", ErrProductionGateOpen, strings.Join(missing, ", "))
	}
	return nil
}

// UnconfiguredIdentityVerifier is the default fail-closed IdentityVerifier when
// Clerk JWT/session verification is not wired.
type UnconfiguredIdentityVerifier struct{}

func (UnconfiguredIdentityVerifier) VerifyActor(context.Context, string) (VerifiedClerkActor, error) {
	return VerifiedClerkActor{}, fmt.Errorf("%w: Clerk identity verifier not configured", ErrDependencyUnconfigured)
}

// UnconfiguredInvitationProvider is the default fail-closed InvitationProvider
// when Clerk Organization Invitations API credentials are absent.
type UnconfiguredInvitationProvider struct{}

func (UnconfiguredInvitationProvider) CreateInvitation(context.Context, CreateProviderInvitationInput) (ProviderInvitation, error) {
	return ProviderInvitation{}, fmt.Errorf("%w: Clerk invitation provider not configured", ErrDependencyUnconfigured)
}

func (UnconfiguredInvitationProvider) ResolveInvitationToken(context.Context, string) (ProviderInvitation, error) {
	return ProviderInvitation{}, fmt.Errorf("%w: Clerk invitation provider not configured", ErrDependencyUnconfigured)
}

func (UnconfiguredInvitationProvider) GetInvitationByID(context.Context, string, string) (ProviderInvitation, error) {
	return ProviderInvitation{}, fmt.Errorf("%w: Clerk invitation provider not configured", ErrDependencyUnconfigured)
}

func (UnconfiguredInvitationProvider) MarkInvitationAccepted(context.Context, AcceptProviderInvitationInput) (ProviderInvitation, error) {
	return ProviderInvitation{}, fmt.Errorf("%w: Clerk invitation provider not configured", ErrDependencyUnconfigured)
}

func (UnconfiguredInvitationProvider) MarkInvitationDeclined(context.Context, string, string, string) (ProviderInvitation, error) {
	return ProviderInvitation{}, fmt.Errorf("%w: Clerk invitation provider not configured", ErrDependencyUnconfigured)
}

func (UnconfiguredInvitationProvider) RevokeInvitation(context.Context, string, string, string) (ProviderInvitation, error) {
	return ProviderInvitation{}, fmt.Errorf("%w: Clerk invitation provider not configured", ErrDependencyUnconfigured)
}

// UnconfiguredRepository is the default fail-closed Repository when durable
// PostgreSQL storage and P0-04 RLS are absent.
type UnconfiguredRepository struct{}

func (UnconfiguredRepository) WithinTx(context.Context, string, string, func(TxRepository) error) error {
	return fmt.Errorf("%w: durable PostgreSQL repository and P0-04 RLS not configured", ErrDependencyUnconfigured)
}
