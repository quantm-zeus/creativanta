package runtimeassembly

import (
	"context"
	"crypto/rand"
	"crypto/tls"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"net"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"

	"connectrpc.com/connect"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/admin/v1/adminv1connect"
	"github.com/quantm-zeus/creativanta/apps/api/gen/creativanta/commerce/v1/commercev1connect"
	"github.com/quantm-zeus/creativanta/apps/api/internal/bootstrap"
	"github.com/quantm-zeus/creativanta/apps/api/internal/capability"
	"github.com/quantm-zeus/creativanta/apps/api/internal/diagnostics"
	"github.com/quantm-zeus/creativanta/apps/api/internal/identity"
	"github.com/quantm-zeus/creativanta/apps/api/internal/internaladmin"
	"github.com/quantm-zeus/creativanta/apps/api/internal/outbox"
	"github.com/quantm-zeus/creativanta/apps/api/internal/product"
	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
	"github.com/quantm-zeus/creativanta/apps/api/internal/transportauth"
)

// Config holds the runtime assembly configuration for either the public API
// or the isolated internal admin API binary.
type Config struct {
	Role                 string
	DatabaseURL          string
	ClerkIssuer          string
	ClerkAudiences       []string
	ClerkAuthorizedParty []string
	ClerkSecretKey       string
	ClerkSessionURL      string
	SessionMode          string
	InsecureJWKSTLS      bool
	RBACBindingsCSVPath  string
	TokenVerifier        identity.TokenVerifier
	SessionStatus        identity.SessionStatus
}

// ConfigFromEnv loads runtime assembly configuration from process environment variables.
func ConfigFromEnv(role string) Config {
	var dbURL string
	switch role {
	case bootstrap.RoleAdminAPI:
		dbURL = strings.TrimSpace(os.Getenv("CREATIVANTA_ADMIN_DATABASE_URL"))
	default:
		dbURL = strings.TrimSpace(os.Getenv("CREATIVANTA_API_DATABASE_URL"))
		if dbURL == "" {
			dbURL = strings.TrimSpace(os.Getenv("DATABASE_URL"))
		}
	}

	return Config{
		Role:                 role,
		DatabaseURL:          dbURL,
		ClerkIssuer:          strings.TrimSpace(os.Getenv("CREATIVANTA_CLERK_ISSUER")),
		ClerkAudiences:       splitCSV(os.Getenv("CREATIVANTA_CLERK_AUDIENCE")),
		ClerkAuthorizedParty: splitCSV(os.Getenv("CREATIVANTA_CLERK_AUTHORIZED_PARTIES")),
		ClerkSecretKey:       strings.TrimSpace(os.Getenv("CREATIVANTA_CLERK_SECRET_KEY")),
		ClerkSessionURL:      strings.TrimSpace(os.Getenv("CREATIVANTA_CLERK_SESSION_URL")),
		SessionMode:          strings.TrimSpace(os.Getenv("CREATIVANTA_SESSION_MODE")),
		InsecureJWKSTLS:      strings.EqualFold(strings.TrimSpace(os.Getenv("CREATIVANTA_CLERK_JWKS_INSECURE_TLS")), "true"),
		RBACBindingsCSVPath:  strings.TrimSpace(os.Getenv("CREATIVANTA_RBAC_BINDINGS_CSV")),
	}
}

func splitCSV(raw string) []string {
	if strings.TrimSpace(raw) == "" {
		return nil
	}
	parts := strings.Split(raw, ",")
	out := make([]string, 0, len(parts))
	for _, p := range parts {
		if trimmed := strings.TrimSpace(p); trimmed != "" {
			out = append(out, trimmed)
		}
	}
	return out
}

// NewServerHandler constructs the HTTP handler and cleanup callback for role
// ("api" or "admin-api") using process environment variables.
// When unconfigured (no database URL), it returns a fail-closed handler where
// /healthz returns 200, /readyz returns 503, and all other routes return 404.
func NewServerHandler(ctx context.Context, role string) (http.Handler, func(), error) {
	return NewHandlerFromConfig(ctx, ConfigFromEnv(role))
}

// NewHandlerFromConfig constructs the runtime HTTP handler from explicit Config.
func NewHandlerFromConfig(ctx context.Context, cfg Config) (http.Handler, func(), error) {
	if strings.TrimSpace(cfg.DatabaseURL) == "" {
		h, err := bootstrap.NewHandler(cfg.Role, nil)
		if err != nil {
			return nil, nil, err
		}
		return h, func() {}, nil
	}

	if trimmedMode := strings.TrimSpace(cfg.SessionMode); trimmedMode != "" && !strings.EqualFold(trimmedMode, "clerk_live") {
		return nil, nil, fmt.Errorf("runtimeassembly: insecure session mode %q is forbidden; live Clerk session verification required", trimmedMode)
	}

	pool, err := pgxpool.New(ctx, cfg.DatabaseURL)
	if err != nil {
		return nil, nil, errors.New("runtimeassembly: invalid database configuration")
	}
	cleanup := func() {
		pool.Close()
	}

	if err := ValidateDatabaseRoleBoundary(ctx, pool, cfg.Role); err != nil {
		cleanup()
		return nil, nil, err
	}

	var clerkHTTPClient *http.Client
	if cfg.InsecureJWKSTLS {
		clerkHTTPClient = &http.Client{
			Timeout: 5 * time.Second,
			Transport: &http.Transport{
				TLSClientConfig: &tls.Config{InsecureSkipVerify: true}, //nolint:gosec // local test JWKS/session server only when explicitly enabled
			},
			CheckRedirect: func(*http.Request, []*http.Request) error {
				return errors.New("session/jwks lookup redirect forbidden")
			},
		}
	}

	tokenVerifier := cfg.TokenVerifier
	if tokenVerifier == nil && cfg.ClerkIssuer != "" {
		var audience string
		if len(cfg.ClerkAudiences) > 0 {
			audience = cfg.ClerkAudiences[0]
		}
		tv, err := identity.NewSessionTokenVerifier(identity.JWTConfig{
			Issuer:            cfg.ClerkIssuer,
			Audience:          audience,
			AuthorizedParties: cfg.ClerkAuthorizedParty,
			HTTPClient:        clerkHTTPClient,
		})
		if err != nil {
			cleanup()
			return nil, nil, fmt.Errorf("runtimeassembly: configure token verifier: %w", err)
		}
		tokenVerifier = tv
	}

	sessionChecker := cfg.SessionStatus
	if sessionChecker == nil && cfg.ClerkSecretKey != "" {
		sc, err := identity.NewClerkSessionStatusWithEndpoint(cfg.ClerkSecretKey, cfg.ClerkSessionURL, clerkHTTPClient)
		if err != nil {
			cleanup()
			return nil, nil, fmt.Errorf("runtimeassembly: configure session status checker: %w", err)
		}
		sessionChecker = sc
	}

	rbacRegistry, err := loadCanonicalRBACRegistry(cfg.RBACBindingsCSVPath)
	if err != nil {
		cleanup()
		return nil, nil, fmt.Errorf("runtimeassembly: load RBAC bindings: %w", err)
	}

	idStore := &pgIdentityStore{
		pool:           pool,
		tokenVerifier:  tokenVerifier,
		sessionChecker: sessionChecker,
	}

	readiness := func(rCtx context.Context) bool {
		if cfg.Role == bootstrap.RoleAPI && (tokenVerifier == nil || sessionChecker == nil) {
			return false
		}
		return CheckDatabaseReadiness(rCtx, pool, cfg.Role)
	}

	routes := http.NewServeMux()
	switch cfg.Role {
	case bootstrap.RoleAPI:
		if err := mountAPIRoutes(routes, pool, idStore, rbacRegistry); err != nil {
			cleanup()
			return nil, nil, err
		}
	case bootstrap.RoleAdminAPI:
		mountAdminAPIRoutes(routes, idStore)
	default:
		cleanup()
		return nil, nil, fmt.Errorf("runtimeassembly: unsupported role %q", cfg.Role)
	}

	h, err := bootstrap.NewHandlerWithRoutes(cfg.Role, readiness, routes)
	if err != nil {
		cleanup()
		return nil, nil, err
	}
	return h, cleanup, nil
}

var requiredCanonicalTables = []string{
	"workspaces",
	"users",
	"workspace_members",
	"products",
	"event_outbox",
	"consumer_inbox",
	"external_effects",
	"diagnostics_records",
}

// ValidateDatabaseRoleBoundary verifies that pool is connected using a narrow, least-privilege
// database login role appropriate for serviceRole ("api" or "admin-api").
// It rejects superusers, BYPASSRLS roles, CREATEDB/CREATEROLE roles, schema owners/migrators
// (CREATE privilege on schema public or ownership of tables in public), outbox_poller members,
// and cross-plane credentials (api must assume app_user only; admin-api must assume admin_user only).
func ValidateDatabaseRoleBoundary(ctx context.Context, pool *pgxpool.Pool, serviceRole string) error {
	if pool == nil {
		return errors.New("runtimeassembly: nil database pool")
	}
	switch serviceRole {
	case bootstrap.RoleAPI, bootstrap.RoleAdminAPI:
	default:
		return fmt.Errorf("runtimeassembly: unsupported service role %q", serviceRole)
	}

	checkCtx, cancel := context.WithTimeout(ctx, 2*time.Second)
	defer cancel()

	var (
		rolName               string
		rolSuper              bool
		rolBypassRLS          bool
		rolCreateDB           bool
		rolCreateRole         bool
		canCreateInPublic     bool
		ownsPublicTables      bool
		canAssumeAppUser      bool
		canAssumeAdminUser    bool
		canAssumeOutboxPoller bool
	)
	err := pool.QueryRow(checkCtx, `
		SELECT
			r.rolname,
			r.rolsuper,
			r.rolbypassrls,
			r.rolcreatedb,
			r.rolcreaterole,
			has_schema_privilege(current_user, 'public', 'CREATE') AS can_create_in_public,
			EXISTS (
				SELECT 1
				FROM pg_class c
				JOIN pg_namespace n ON n.oid = c.relnamespace
				WHERE n.nspname = 'public'
				  AND c.relkind = 'r'
				  AND pg_has_role(current_user, c.relowner, 'USAGE')
			) AS owns_public_tables,
			CASE
				WHEN EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_user')
				THEN pg_has_role(current_user, 'app_user', 'MEMBER')
				ELSE false
			END AS can_assume_app_user,
			CASE
				WHEN EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'admin_user')
				THEN pg_has_role(current_user, 'admin_user', 'MEMBER')
				ELSE false
			END AS can_assume_admin_user,
			CASE
				WHEN EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'outbox_poller')
				THEN pg_has_role(current_user, 'outbox_poller', 'MEMBER')
				ELSE false
			END AS can_assume_outbox_poller
		FROM pg_roles r
		WHERE r.rolname = current_user
	`).Scan(
		&rolName,
		&rolSuper,
		&rolBypassRLS,
		&rolCreateDB,
		&rolCreateRole,
		&canCreateInPublic,
		&ownsPublicTables,
		&canAssumeAppUser,
		&canAssumeAdminUser,
		&canAssumeOutboxPoller,
	)
	if err != nil {
		return fmt.Errorf("runtimeassembly: inspect database role boundary: %w", err)
	}
	if rolSuper {
		return fmt.Errorf("runtimeassembly: privileged superuser DB role %q is forbidden for runtime service %q", rolName, serviceRole)
	}
	if rolBypassRLS {
		return fmt.Errorf("runtimeassembly: BYPASSRLS DB role %q is forbidden for runtime service %q", rolName, serviceRole)
	}
	if rolCreateDB || rolCreateRole {
		return fmt.Errorf("runtimeassembly: elevated CREATEDB/CREATEROLE DB role %q is forbidden for runtime service %q", rolName, serviceRole)
	}
	if canCreateInPublic || ownsPublicTables {
		return fmt.Errorf("runtimeassembly: schema-owner/migrator DB role %q (CREATE on public or table ownership) is forbidden for runtime service %q", rolName, serviceRole)
	}
	if canAssumeOutboxPoller {
		return fmt.Errorf("runtimeassembly: outbox_poller membership on DB role %q is forbidden for HTTP service %q", rolName, serviceRole)
	}

	switch serviceRole {
	case bootstrap.RoleAPI:
		if !canAssumeAppUser {
			return fmt.Errorf("runtimeassembly: API DB role %q must be a member of app_user", rolName)
		}
		if canAssumeAdminUser {
			return fmt.Errorf("runtimeassembly: API DB role %q must not be a member of privileged admin_user", rolName)
		}
	case bootstrap.RoleAdminAPI:
		if !canAssumeAdminUser {
			return fmt.Errorf("runtimeassembly: admin-api DB role %q must be a member of admin_user", rolName)
		}
		if canAssumeAppUser {
			return fmt.Errorf("runtimeassembly: admin-api DB role %q must not share tenant app_user membership", rolName)
		}
	}
	return nil
}

// CheckDatabaseReadiness verifies database connectivity, least-privilege role separation,
// and ENABLE + FORCE ROW LEVEL SECURITY on canonical tenant tables.
func CheckDatabaseReadiness(ctx context.Context, pool *pgxpool.Pool, serviceRole string) bool {
	if pool == nil {
		return false
	}
	checkCtx, cancel := context.WithTimeout(ctx, 2*time.Second)
	defer cancel()

	if err := pool.Ping(checkCtx); err != nil {
		return false
	}
	if err := ValidateDatabaseRoleBoundary(checkCtx, pool, serviceRole); err != nil {
		return false
	}

	for _, tableName := range requiredCanonicalTables {
		var rlsEnabled, rlsForced bool
		err := pool.QueryRow(checkCtx, `
			SELECT c.relrowsecurity, c.relforcerowsecurity
			FROM pg_class c
			JOIN pg_namespace n ON n.oid = c.relnamespace
			WHERE n.nspname = 'public'
			  AND c.relname = $1
			  AND c.relkind = 'r'
		`, tableName).Scan(&rlsEnabled, &rlsForced)
		if err != nil || !rlsEnabled || !rlsForced {
			return false
		}
	}
	return true
}

func mountAPIRoutes(mux *http.ServeMux, pool *pgxpool.Pool, idStore *pgIdentityStore, rbacRegistry *rbac.Registry) error {
	resolver := identity.Resolver{
		Tokens:      idStore.tokenVerifier,
		Memberships: idStore,
		Sessions:    idStore.sessionChecker,
	}

	// 1. Authenticated workspace discovery endpoint (/api/workspaces/discovery)
	mux.HandleFunc("/api/workspaces/discovery", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodGet && r.Method != http.MethodPost {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
		token, err := extractBearerToken(r.Header.Get("Authorization"))
		if err != nil {
			writeJSONError(w, http.StatusUnauthorized, "unauthenticated", err.Error())
			return
		}
		workspaces, err := resolver.DiscoverWorkspaces(r.Context(), token)
		if err != nil {
			status := http.StatusUnauthorized
			if errors.Is(err, identity.ErrNotConfigured) {
				status = http.StatusServiceUnavailable
			}
			writeJSONError(w, status, "unauthenticated", "workspace discovery denied")
			return
		}
		w.Header().Set("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusOK)
		_ = json.NewEncoder(w).Encode(map[string]any{
			"workspaces": workspaces,
		})
	})

	// 2. Connect RPC interceptor chain:
	//    - transportauth.NewServerInterceptor verifies JWT + active session + x-workspace-id + active membership
	//    - newRBACAndActorInterceptor verifies live workspace role against rpc_permission_bindings.csv
	authInterceptor, err := transportauth.NewServerInterceptor(transportauth.Options{
		Mode:     transportauth.ModeAPI,
		Verifier: resolver,
	})
	if err != nil {
		return err
	}
	rbacInterceptor := newRBACAndActorInterceptor(idStore, rbacRegistry)
	interceptors := connect.WithInterceptors(authInterceptor, rbacInterceptor)

	// 3. Safe authenticated business RPCs backed by PostgreSQL + tenantdb.WithTx + RLS:
	//    - creativanta.commerce.v1.ProductService (products:read / products:write)
	//    - creativanta.admin.v1.DiagnosticsService (diagnostics:read / diagnostics:write)
	//    - creativanta.admin.v1.CapabilityService (capability:read / capability:write)
	//    Unsafe handlers (OrderService, WorkflowService, AgentService, VideoProductionService,
	//    PublishService, publicapi) remain unmounted while security/domain lanes remediate them.
	prodStore := &tenantProductStore{pool: pool}
	prodSvc := product.NewService(prodStore, nil, nil)
	prodPath, prodHandler := commercev1connect.NewProductServiceHandler(product.NewHandler(prodSvc), interceptors)
	mux.Handle(prodPath, prodHandler)

	rlsBeginner := &appUserTxBeginner{pool: pool}

	diagSvc := diagnostics.NewService(rbacRegistry, nil, nil)
	diagSvc.Beginner = rlsBeginner
	diagPath, diagHandler := adminv1connect.NewDiagnosticsServiceHandler(diagSvc, interceptors)
	mux.Handle(diagPath, diagHandler)

	capSvc := capability.NewService(rbacRegistry, nil)
	capSvc.Beginner = rlsBeginner
	capPath, capHandler := adminv1connect.NewCapabilityServiceHandler(capSvc, interceptors)
	mux.Handle(capPath, capHandler)
	return nil
}

func extractServerPeerIP(r *http.Request) string {
	if r == nil {
		return ""
	}
	if ev, ok := internaladmin.VPNTransportEvidenceFromContext(r.Context()); ok && strings.TrimSpace(ev.PeerIP) != "" {
		return strings.TrimSpace(ev.PeerIP)
	}
	raw := strings.TrimSpace(r.RemoteAddr)
	if raw == "" {
		return ""
	}
	if host, _, err := net.SplitHostPort(raw); err == nil {
		return strings.TrimSpace(host)
	}
	return raw
}

func mountAdminAPIRoutes(mux *http.ServeMux, idStore *pgIdentityStore) {
	// Isolated admin API listener (ModeAdminAPI):
	// - Rejects any request carrying x-workspace-id header (403 Forbidden)
	// - Requires verified VPN/Tailscale or loopback transport peer IP (403 Forbidden)
	// - Rejects workspace/user Clerk JWT tokens; requires an isolated MFA+VPN verified admin_sessions token
	// - Does NOT mount tenant services or unguarded AdminAuthService/Login (AUTH-05)
	mux.HandleFunc("/admin/v1/whoami", func(w http.ResponseWriter, r *http.Request) {
		if r.Method != http.MethodGet && r.Method != http.MethodPost {
			w.WriteHeader(http.StatusMethodNotAllowed)
			return
		}
		if strings.TrimSpace(r.Header.Get("x-workspace-id")) != "" {
			writeJSONError(w, http.StatusForbidden, "permission_denied", "admin API forbids x-workspace-id")
			return
		}
		peerIP := extractServerPeerIP(r)
		if !internaladmin.IsTailscaleOrLoopbackVPNPeerIP(peerIP) {
			writeJSONError(w, http.StatusForbidden, "permission_denied", "admin API requires verified VPN or loopback transport")
			return
		}
		if ev, hasEv := internaladmin.VPNTransportEvidenceFromContext(r.Context()); hasEv && (!ev.Verified || !internaladmin.IsTailscaleOrLoopbackVPNPeerIP(ev.PeerIP)) {
			writeJSONError(w, http.StatusForbidden, "permission_denied", "admin API requires verified VPN transport evidence")
			return
		}
		token, err := extractBearerToken(r.Header.Get("Authorization"))
		if err != nil {
			writeJSONError(w, http.StatusUnauthorized, "unauthenticated", err.Error())
			return
		}
		// Reject workspace/user JWT tokens on the isolated internal admin plane.
		if strings.Count(token, ".") == 2 {
			writeJSONError(w, http.StatusForbidden, "permission_denied", "workspace/user JWT tokens are forbidden on isolated admin API; MFA+VPN admin session required")
			return
		}
		verifyCtx := internaladmin.WithTrustedVPNTransport(r.Context(), peerIP)
		adminSess, err := idStore.VerifyAdminSession(verifyCtx, token)
		if err != nil {
			switch {
			case errors.Is(err, identity.ErrNotConfigured):
				writeJSONError(w, http.StatusServiceUnavailable, "unavailable", "admin session store not configured")
			case errors.Is(err, internaladmin.ErrPrivilegedRoleBoundaryViolation), errors.Is(err, internaladmin.ErrVPNRequired):
				writeJSONError(w, http.StatusForbidden, "permission_denied", "internal admin role and verified VPN transport required")
			default:
				writeJSONError(w, http.StatusUnauthorized, "unauthenticated", "invalid, revoked, or unverified admin session")
			}
			return
		}
		w.Header().Set("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusOK)
		_ = json.NewEncoder(w).Encode(map[string]any{
			"user_id":        adminSess.AdminID,
			"admin_id":       adminSess.AdminID,
			"session_id":     adminSess.SessionID,
			"admin_role":     adminSess.AdminRole,
			"internal_admin": true,
			"vpn_verified":   true,
			"mfa_verified":   true,
			"role":           bootstrap.RoleAdminAPI,
		})
	})
}

func newRBACAndActorInterceptor(idStore *pgIdentityStore, registry *rbac.Registry) connect.UnaryInterceptorFunc {
	return func(next connect.UnaryFunc) connect.UnaryFunc {
		return func(ctx context.Context, req connect.AnyRequest) (connect.AnyResponse, error) {
			principal, ok := transportauth.PrincipalFromContext(ctx)
			if !ok || principal.UserID == "" || principal.WorkspaceID == "" {
				return nil, connect.NewError(connect.CodeUnauthenticated, errors.New("missing authenticated workspace principal"))
			}

			role, err := idStore.ResolveMemberRole(ctx, principal.WorkspaceID, principal.UserID)
			if err != nil {
				return nil, connect.NewError(connect.CodePermissionDenied, errors.New("active workspace membership role not found"))
			}

			pctx := rbac.PolicyContext{
				ActorUserID: principal.UserID,
				WorkspaceID: principal.WorkspaceID,
				Role:        role,
			}
			if _, err := registry.Authorize(req.Spec().Procedure, pctx); err != nil {
				return nil, connect.NewError(connect.CodePermissionDenied, err)
			}

			ctx = rbac.WithPolicyContext(ctx, pctx)
			ctx = diagnostics.WithActorContext(ctx, diagnostics.ActorContext{
				UserID:           principal.UserID,
				WorkspaceID:      principal.WorkspaceID,
				WorkspaceRole:    role,
				WorkspaceActive:  true,
				MembershipActive: true,
			})
			ctx = capability.WithActorContext(ctx, capability.ActorContext{
				UserID:           principal.UserID,
				WorkspaceID:      principal.WorkspaceID,
				WorkspaceRole:    role,
				WorkspaceActive:  true,
				MembershipActive: true,
			})
			return next(ctx, req)
		}
	}
}

// =============================================================================
// PostgreSQL Identity, Membership, Discovery & Admin Verifier
// =============================================================================

type pgIdentityStore struct {
	pool           *pgxpool.Pool
	tokenVerifier  identity.TokenVerifier
	sessionChecker identity.SessionStatus
}

type verifiedAdminSession struct {
	AdminID   string
	SessionID string
	AdminRole string
}

// ResolveActive implements identity.MembershipLookup using live PostgreSQL state
// under app_user while satisfying FORCE ROW LEVEL SECURITY on workspaces, workspace_members, and users.
func (s *pgIdentityStore) ResolveActive(ctx context.Context, clerkSubject, workspaceID string) (string, bool, error) {
	if s.pool == nil {
		return "", false, identity.ErrNotConfigured
	}
	trimmedSubject := strings.TrimSpace(clerkSubject)
	if trimmedSubject == "" || !tenantdb.IsValidNonZeroUUID(workspaceID) {
		return "", false, nil
	}

	tx, err := s.pool.Begin(ctx)
	if err != nil {
		return "", false, err
	}
	defer func() { _ = tx.Rollback(ctx) }()

	if _, err := tx.Exec(ctx, `SET LOCAL ROLE app_user`); err != nil {
		return "", false, err
	}

	candidateUserUUID := ""
	if tenantdb.IsValidNonZeroUUID(trimmedSubject) {
		candidateUserUUID = trimmedSubject
	}
	if _, err := tx.Exec(ctx, `
		SELECT
			set_config('app.current_clerk_id', $1, true),
			set_config('app.current_user_id', $2, true),
			set_config('app.current_tenant_id', $3, true)
	`, trimmedSubject, candidateUserUUID, workspaceID); err != nil {
		return "", false, err
	}

	var resolvedUID string
	err = tx.QueryRow(ctx, `
		SELECT u.user_id::text
		FROM users u
		WHERE (u.clerk_id = $1 OR u.external_auth_id = $1 OR u.user_id::text = $1)
		  AND u.status = 'active'
		LIMIT 1
	`, trimmedSubject).Scan(&resolvedUID)
	if errors.Is(err, pgx.ErrNoRows) {
		return "", false, nil
	}
	if err != nil {
		return "", false, err
	}

	if _, err := tx.Exec(ctx, `
		SELECT
			set_config('app.current_user_id', $1, true),
			set_config('app.current_tenant_id', $2, true)
	`, resolvedUID, workspaceID); err != nil {
		return "", false, err
	}

	var activeUID string
	err = tx.QueryRow(ctx, `
		SELECT wm.user_id::text
		FROM workspace_members wm
		JOIN workspaces w ON w.workspace_id = wm.workspace_id
		WHERE wm.workspace_id = $1::uuid
		  AND wm.user_id = $2::uuid
		  AND wm.status = 'active'
		  AND w.status = 'active'
		  AND w.deleted_at IS NULL
		LIMIT 1
	`, workspaceID, resolvedUID).Scan(&activeUID)
	if errors.Is(err, pgx.ErrNoRows) {
		return "", false, nil
	}
	if err != nil {
		return "", false, err
	}
	if err := tx.Commit(ctx); err != nil {
		return "", false, err
	}
	return activeUID, true, nil
}

// Discover implements identity.WorkspaceDiscovery against PostgreSQL under app_user RLS.
func (s *pgIdentityStore) Discover(ctx context.Context, clerkSubject string) ([]identity.WorkspaceSummary, error) {
	if s.pool == nil {
		return nil, identity.ErrNotConfigured
	}
	trimmedSubject := strings.TrimSpace(clerkSubject)
	if trimmedSubject == "" {
		return nil, identity.ErrUnauthorized
	}

	tx, err := s.pool.Begin(ctx)
	if err != nil {
		return nil, err
	}
	defer func() { _ = tx.Rollback(ctx) }()

	if _, err := tx.Exec(ctx, `SET LOCAL ROLE app_user`); err != nil {
		return nil, err
	}

	candidateUserUUID := ""
	if tenantdb.IsValidNonZeroUUID(trimmedSubject) {
		candidateUserUUID = trimmedSubject
	}
	if _, err := tx.Exec(ctx, `
		SELECT
			set_config('app.current_clerk_id', $1, true),
			set_config('app.current_user_id', $2, true),
			set_config('app.current_tenant_id', '', true)
	`, trimmedSubject, candidateUserUUID); err != nil {
		return nil, err
	}

	var resolvedUID string
	err = tx.QueryRow(ctx, `
		SELECT u.user_id::text
		FROM users u
		WHERE (u.clerk_id = $1 OR u.external_auth_id = $1 OR u.user_id::text = $1)
		  AND u.status = 'active'
		LIMIT 1
	`, trimmedSubject).Scan(&resolvedUID)
	if errors.Is(err, pgx.ErrNoRows) {
		return []identity.WorkspaceSummary{}, nil
	}
	if err != nil {
		return nil, err
	}

	if _, err := tx.Exec(ctx, `
		SELECT
			set_config('app.current_user_id', $1, true),
			set_config('app.current_tenant_id', '', true)
	`, resolvedUID); err != nil {
		return nil, err
	}

	rows, err := tx.Query(ctx, `
		SELECT
			w.workspace_id::text,
			w.name,
			COALESCE(NULLIF(w.display_name, ''), w.name) AS display_name,
			wm.role,
			CASE
				WHEN w.default_mode::text <> 'creator' THEN w.default_mode::text
				ELSE COALESCE(NULLIF(w.default_operator_mode::text, ''), NULLIF(w.default_mode::text, ''), 'creator')
			END AS effective_mode
		FROM workspace_members wm
		JOIN workspaces w ON w.workspace_id = wm.workspace_id
		WHERE wm.user_id = $1::uuid
		  AND wm.status = 'active'
		  AND w.status = 'active'
		  AND w.deleted_at IS NULL
		ORDER BY COALESCE(NULLIF(w.display_name, ''), w.name) ASC, w.workspace_id::text ASC
	`, resolvedUID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	out := make([]identity.WorkspaceSummary, 0)
	for rows.Next() {
		var item identity.WorkspaceSummary
		if err := rows.Scan(&item.ID, &item.Name, &item.DisplayName, &item.Role, &item.DefaultMode); err != nil {
			return nil, err
		}
		item.DefaultOperatorMode = item.DefaultMode
		out = append(out, item)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	rows.Close()
	if err := tx.Commit(ctx); err != nil {
		return nil, err
	}
	return out, nil
}

// ResolveMemberRole returns the live role string for (workspaceID, userID) from PostgreSQL under app_user RLS.
func (s *pgIdentityStore) ResolveMemberRole(ctx context.Context, workspaceID, userID string) (string, error) {
	tx, err := s.pool.Begin(ctx)
	if err != nil {
		return "", err
	}
	defer func() { _ = tx.Rollback(ctx) }()

	if _, err := tx.Exec(ctx, `SET LOCAL ROLE app_user`); err != nil {
		return "", err
	}

	if _, err := tx.Exec(ctx, `
		SELECT
			set_config('app.current_tenant_id', $1, true),
			set_config('app.current_user_id', $2, true)
	`, workspaceID, userID); err != nil {
		return "", err
	}

	var roleStr string
	if err := tx.QueryRow(ctx, `
		SELECT wm.role
		FROM workspace_members wm
		JOIN workspaces w ON w.workspace_id = wm.workspace_id
		JOIN users u ON u.user_id = wm.user_id
		WHERE wm.workspace_id = $1::uuid
		  AND wm.user_id = $2::uuid
		  AND wm.status = 'active'
		  AND w.status = 'active'
		  AND w.deleted_at IS NULL
		  AND u.status = 'active'
	`, workspaceID, userID).Scan(&roleStr); err != nil {
		return "", err
	}
	return roleStr, nil
}

// VerifyAdminSession validates an isolated internal admin session token against admin_sessions
// and internal_admins under the admin_user database role, requiring VPN + MFA verification
// and bounding session age to at most 8 hours (AdminSessionTTL) from started_at with a non-NULL expired_at.
func (s *pgIdentityStore) VerifyAdminSession(ctx context.Context, sessionToken string) (verifiedAdminSession, error) {
	if s.pool == nil {
		return verifiedAdminSession{}, identity.ErrNotConfigured
	}
	if ev, hasEv := internaladmin.VPNTransportEvidenceFromContext(ctx); hasEv && (!ev.Verified || !internaladmin.IsTailscaleOrLoopbackVPNPeerIP(ev.PeerIP)) {
		return verifiedAdminSession{}, internaladmin.ErrVPNRequired
	}
	trimmed := strings.TrimSpace(sessionToken)
	if len(trimmed) < 16 || strings.Count(trimmed, ".") == 2 {
		return verifiedAdminSession{}, identity.ErrUnauthorized
	}

	tokenHash := internaladmin.HashSessionToken(trimmed)

	tx, err := s.pool.Begin(ctx)
	if err != nil {
		return verifiedAdminSession{}, err
	}
	defer func() { _ = tx.Rollback(ctx) }()

	if _, err := tx.Exec(ctx, `SET LOCAL ROLE admin_user`); err != nil {
		return verifiedAdminSession{}, err
	}

	var (
		adminID         string
		adminRole       string
		sessionID       string
		vpnVerified     bool
		mfaVerified     bool
		isRevoked       bool
		isExpiredOrUnbd bool
		adminStatus     string
		mfaEnabled      bool
		hasPasswordHash bool
	)
	err = tx.QueryRow(ctx, `
		SELECT
			ia.admin_id::text,
			ia.role,
			s.session_id::text,
			s.vpn_verified,
			s.mfa_verified,
			(s.revoked_at IS NOT NULL) AS is_revoked,
			(
				s.expired_at IS NULL
				OR s.expired_at <= NOW()
				OR s.expired_at <= s.started_at
				OR s.expired_at > s.started_at + INTERVAL '8 hours'
				OR s.started_at > NOW() + INTERVAL '1 minute'
				OR s.started_at + INTERVAL '8 hours' <= NOW()
			) AS is_expired_or_unbounded,
			ia.status,
			ia.mfa_enabled,
			(COALESCE(BTRIM(ia.password_hash), '') <> '') AS has_password_hash
		FROM admin_sessions s
		JOIN internal_admins ia ON ia.admin_id = s.admin_id
		WHERE s.session_token_hash = $1
		LIMIT 1
	`, tokenHash).Scan(
		&adminID,
		&adminRole,
		&sessionID,
		&vpnVerified,
		&mfaVerified,
		&isRevoked,
		&isExpiredOrUnbd,
		&adminStatus,
		&mfaEnabled,
		&hasPasswordHash,
	)
	if errors.Is(err, pgx.ErrNoRows) {
		return verifiedAdminSession{}, identity.ErrUnauthorized
	}
	if err != nil {
		return verifiedAdminSession{}, err
	}
	if isRevoked || isExpiredOrUnbd || !vpnVerified || !mfaVerified || !hasPasswordHash {
		return verifiedAdminSession{}, identity.ErrUnauthorized
	}
	if adminStatus != "active" || !mfaEnabled || !rbac.IsValidAdminRole(adminRole) {
		return verifiedAdminSession{}, internaladmin.ErrPrivilegedRoleBoundaryViolation
	}
	if err := tx.Commit(ctx); err != nil {
		return verifiedAdminSession{}, err
	}
	return verifiedAdminSession{
		AdminID:   adminID,
		SessionID: sessionID,
		AdminRole: adminRole,
	}, nil
}

// =============================================================================
// Tenant-scoped ProductService Store (runs inside tenantdb.WithTx + app_user RLS
// and enqueues canonical event_outbox rows atomically on product mutations)
// =============================================================================

type appUserTxBeginner struct {
	pool *pgxpool.Pool
	last pgx.Tx
}

func (b *appUserTxBeginner) Begin(ctx context.Context) (pgx.Tx, error) {
	tx, err := b.pool.Begin(ctx)
	if err != nil {
		return nil, err
	}
	if _, err := tx.Exec(ctx, `SET LOCAL ROLE app_user`); err != nil {
		_ = tx.Rollback(ctx)
		return nil, err
	}
	b.last = tx
	return tx, nil
}

type tenantProductStore struct {
	pool *pgxpool.Pool
}

var _ product.Store = (*tenantProductStore)(nil)

func (s *tenantProductStore) runInTenantTx(ctx context.Context, workspaceID string, fn func(txCtx context.Context, tx pgx.Tx, q *tenantdb.Queries, principal transportauth.Session) error) error {
	principal, ok := transportauth.PrincipalFromContext(ctx)
	if !ok || principal.UserID == "" || principal.WorkspaceID == "" {
		return errors.New("unauthenticated workspace context")
	}
	if workspaceID != "" && principal.WorkspaceID != workspaceID {
		return product.ErrProductNotFound
	}
	capturer := &appUserTxBeginner{pool: s.pool}
	return tenantdb.WithTx(ctx, capturer, tenantdb.Scope{
		WorkspaceID:             principal.WorkspaceID,
		UserID:                  principal.UserID,
		RequireActiveMembership: true,
	}, func(txCtx context.Context, q *tenantdb.Queries) error {
		return fn(txCtx, capturer.last, q, principal)
	})
}

func (s *tenantProductStore) CreateProduct(ctx context.Context, p *product.Product) error {
	if p == nil {
		return product.ErrInvalidInput
	}
	return s.runInTenantTx(ctx, p.WorkspaceID, func(txCtx context.Context, tx pgx.Tx, q *tenantdb.Queries, principal transportauth.Session) error {
		store := product.NewPostgresStoreTx(tx)
		if err := store.CreateProduct(txCtx, p); err != nil {
			return err
		}

		payloadBytes, err := json.Marshal(map[string]any{
			"product_id":     p.ProductID,
			"workspace_id":   p.WorkspaceID,
			"type":           string(p.ProductType),
			"title":          p.Title,
			"catalog_status": string(p.CatalogStatus),
			"sku_count":      len(p.SKUs),
		})
		if err != nil {
			return err
		}
		metaBytes, err := json.Marshal(map[string]any{
			"actor_id":      principal.UserID,
			"actor_type":    "user",
			"required_perm": "product:manage",
		})
		if err != nil {
			return err
		}
		if err := q.InsertOutboxEvent(txCtx, tenantdb.OutboxEventParams{
			EventID:       newUUIDv4(),
			EventType:     "product.created",
			TargetStream:  string(outbox.QueueSearchIndexing),
			AggregateType: "product",
			AggregateID:   p.ProductID,
			WorkspaceID:   p.WorkspaceID,
			PayloadJSON:   payloadBytes,
			MetadataJSON:  metaBytes,
		}); err != nil {
			return err
		}
		return q.InsertAuditEvent(txCtx, tenantdb.AuditEventParams{
			AuditEventID: newUUIDv4(),
			WorkspaceID:  p.WorkspaceID,
			ActorUserID:  principal.UserID,
			ActorType:    "user",
			Action:       "product.created",
			ResourceType: "product",
			ResourceID:   p.ProductID,
			ChangesJSON:  payloadBytes,
		})
	})
}

func (s *tenantProductStore) GetProduct(ctx context.Context, workspaceID, productID string) (*product.Product, error) {
	var out *product.Product
	err := s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		store := product.NewPostgresStoreTx(tx)
		var err error
		out, err = store.GetProduct(txCtx, workspaceID, productID)
		return err
	})
	return out, err
}

func (s *tenantProductStore) ListProducts(ctx context.Context, workspaceID string, filter product.ListFilter, limit, offset int) ([]*product.Product, int64, error) {
	var list []*product.Product
	var total int64
	err := s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		store := product.NewPostgresStoreTx(tx)
		var err error
		list, total, err = store.ListProducts(txCtx, workspaceID, filter, limit, offset)
		return err
	})
	return list, total, err
}

func (s *tenantProductStore) UpdateProduct(ctx context.Context, p *product.Product) error {
	if p == nil {
		return product.ErrInvalidInput
	}
	return s.runInTenantTx(ctx, p.WorkspaceID, func(txCtx context.Context, tx pgx.Tx, q *tenantdb.Queries, principal transportauth.Session) error {
		store := product.NewPostgresStoreTx(tx)
		prevStatus := p.PreviousCatalogStatus
		if prevStatus == "" {
			if existing, err := store.GetProduct(txCtx, p.WorkspaceID, p.ProductID); err == nil && existing != nil {
				prevStatus = existing.CatalogStatus
			}
		}
		if err := store.UpdateProduct(txCtx, p); err != nil {
			return err
		}
		if prevStatus != "" && prevStatus != p.CatalogStatus {
			payloadBytes, _ := json.Marshal(map[string]any{
				"product_id":     p.ProductID,
				"workspace_id":   p.WorkspaceID,
				"from":           prevStatus,
				"to":             string(p.CatalogStatus),
				"catalog_status": string(p.CatalogStatus),
			})
			metaBytes, _ := json.Marshal(map[string]any{
				"actor_id":      principal.UserID,
				"actor_type":    "user",
				"required_perm": "product:manage",
			})
			if err := q.InsertOutboxEvent(txCtx, tenantdb.OutboxEventParams{
				EventID:       newUUIDv4(),
				EventType:     "product.catalog_status_changed",
				TargetStream:  string(outbox.QueueSearchIndexing),
				AggregateType: "product",
				AggregateID:   p.ProductID,
				WorkspaceID:   p.WorkspaceID,
				PayloadJSON:   payloadBytes,
				MetadataJSON:  metaBytes,
			}); err != nil {
				return err
			}
		}
		return nil
	})
}

func (s *tenantProductStore) DeleteProduct(ctx context.Context, workspaceID, productID string) error {
	return s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		return product.NewPostgresStoreTx(tx).DeleteProduct(txCtx, workspaceID, productID)
	})
}

func (s *tenantProductStore) ArchiveProduct(ctx context.Context, workspaceID, productID string) error {
	return s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, q *tenantdb.Queries, principal transportauth.Session) error {
		store := product.NewPostgresStoreTx(tx)
		existing, err := store.GetProduct(txCtx, workspaceID, productID)
		if err != nil {
			return err
		}
		if err := store.ArchiveProduct(txCtx, workspaceID, productID); err != nil {
			return err
		}
		if existing.CatalogStatus != product.StatusArchived {
			payloadBytes, _ := json.Marshal(map[string]any{
				"product_id":     productID,
				"workspace_id":   workspaceID,
				"from":           existing.CatalogStatus,
				"to":             product.StatusArchived,
				"catalog_status": product.StatusArchived,
			})
			metaBytes, _ := json.Marshal(map[string]any{
				"actor_id":      principal.UserID,
				"actor_type":    "user",
				"required_perm": "product:manage",
			})
			if err := q.InsertOutboxEvent(txCtx, tenantdb.OutboxEventParams{
				EventID:       newUUIDv4(),
				EventType:     "product.catalog_status_changed",
				TargetStream:  string(outbox.QueueSearchIndexing),
				AggregateType: "product",
				AggregateID:   productID,
				WorkspaceID:   workspaceID,
				PayloadJSON:   payloadBytes,
				MetadataJSON:  metaBytes,
			}); err != nil {
				return err
			}
		}
		return nil
	})
}

func (s *tenantProductStore) BulkArchiveProducts(ctx context.Context, workspaceID string, productIDs []string) (int, error) {
	var count int
	err := s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, q *tenantdb.Queries, principal transportauth.Session) error {
		store := product.NewPostgresStoreTx(tx)
		type priorProductState struct {
			productID string
			status    string
		}
		var priorStates []priorProductState
		seen := make(map[string]struct{}, len(productIDs))
		for _, pid := range productIDs {
			if _, dup := seen[pid]; dup {
				continue
			}
			seen[pid] = struct{}{}
			if existing, err := store.GetProduct(txCtx, workspaceID, pid); err == nil && existing != nil && existing.CatalogStatus != product.StatusArchived {
				priorStates = append(priorStates, priorProductState{
					productID: existing.ProductID,
					status:    string(existing.CatalogStatus),
				})
			}
		}

		var err error
		count, err = store.BulkArchiveProducts(txCtx, workspaceID, productIDs)
		if err != nil {
			return err
		}

		for _, prior := range priorStates {
			payloadBytes, _ := json.Marshal(map[string]any{
				"product_id":     prior.productID,
				"workspace_id":   workspaceID,
				"from":           prior.status,
				"to":             product.StatusArchived,
				"catalog_status": product.StatusArchived,
			})
			metaBytes, _ := json.Marshal(map[string]any{
				"actor_id":      principal.UserID,
				"actor_type":    "user",
				"required_perm": "product:manage",
			})
			if err := q.InsertOutboxEvent(txCtx, tenantdb.OutboxEventParams{
				EventID:       newUUIDv4(),
				EventType:     "product.catalog_status_changed",
				TargetStream:  string(outbox.QueueSearchIndexing),
				AggregateType: "product",
				AggregateID:   prior.productID,
				WorkspaceID:   workspaceID,
				PayloadJSON:   payloadBytes,
				MetadataJSON:  metaBytes,
			}); err != nil {
				return err
			}
		}
		return nil
	})
	return count, err
}

func (s *tenantProductStore) FindProductByExternalID(ctx context.Context, workspaceID, platform, externalID, connectedAccountID string) (*product.Product, error) {
	var out *product.Product
	err := s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		var err error
		out, err = product.NewPostgresStoreTx(tx).FindProductByExternalID(txCtx, workspaceID, platform, externalID, connectedAccountID)
		return err
	})
	return out, err
}

func (s *tenantProductStore) CreateSku(ctx context.Context, sku *product.ProductSku) error {
	if sku == nil {
		return product.ErrInvalidInput
	}
	return s.runInTenantTx(ctx, sku.WorkspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		return product.NewPostgresStoreTx(tx).CreateSku(txCtx, sku)
	})
}

func (s *tenantProductStore) GetSku(ctx context.Context, workspaceID, skuID string) (*product.ProductSku, error) {
	var out *product.ProductSku
	err := s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		var err error
		out, err = product.NewPostgresStoreTx(tx).GetSku(txCtx, workspaceID, skuID)
		return err
	})
	return out, err
}

func (s *tenantProductStore) ListSkusByProduct(ctx context.Context, workspaceID, productID string) ([]product.ProductSku, error) {
	var out []product.ProductSku
	err := s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		var err error
		out, err = product.NewPostgresStoreTx(tx).ListSkusByProduct(txCtx, workspaceID, productID)
		return err
	})
	return out, err
}

func (s *tenantProductStore) UpdateSkuStock(ctx context.Context, workspaceID, skuID string, delta int32) (int32, error) {
	var newQty int32
	err := s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, q *tenantdb.Queries, principal transportauth.Session) error {
		var err error
		newQty, err = product.NewPostgresStoreTx(tx).UpdateSkuStock(txCtx, workspaceID, skuID, delta)
		if err != nil {
			return err
		}
		meta, _ := product.StockAdjustmentMetaFromContext(txCtx)
		reason := meta.Reason
		if reason == "" {
			reason = "manual_adjustment"
		}
		payloadBytes, _ := json.Marshal(map[string]any{
			"sku_id":       skuID,
			"workspace_id": workspaceID,
			"delta":        delta,
			"reason":       reason,
			"new_quantity": newQty,
		})
		metaBytes, _ := json.Marshal(map[string]any{
			"actor_id":      principal.UserID,
			"actor_type":    "user",
			"required_perm": "inventory:adjust",
		})
		if err := q.InsertOutboxEvent(txCtx, tenantdb.OutboxEventParams{
			EventID:       newUUIDv4(),
			EventType:     "inventory.stock_moved",
			TargetStream:  string(outbox.QueueAnalyticsEvents),
			AggregateType: "product_sku",
			AggregateID:   skuID,
			WorkspaceID:   workspaceID,
			PayloadJSON:   payloadBytes,
			MetadataJSON:  metaBytes,
		}); err != nil {
			return err
		}
		return q.InsertAuditEvent(txCtx, tenantdb.AuditEventParams{
			AuditEventID: newUUIDv4(),
			WorkspaceID:  workspaceID,
			ActorUserID:  principal.UserID,
			ActorType:    "user",
			Action:       "inventory.stock_moved",
			ResourceType: "product_sku",
			ResourceID:   skuID,
			ChangesJSON:  payloadBytes,
		})
	})
	return newQty, err
}

func (s *tenantProductStore) SetSkuAlertThreshold(ctx context.Context, workspaceID, skuID string, threshold int32) error {
	return s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		return product.NewPostgresStoreTx(tx).SetSkuAlertThreshold(txCtx, workspaceID, skuID, threshold)
	})
}

func (s *tenantProductStore) LinkContent(ctx context.Context, workspaceID, productID string, ref product.ContentRef) error {
	return s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		return product.NewPostgresStoreTx(tx).LinkContent(txCtx, workspaceID, productID, ref)
	})
}

func (s *tenantProductStore) GetLinkedContent(ctx context.Context, workspaceID, productID string) ([]product.ContentRef, error) {
	var out []product.ContentRef
	err := s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		var err error
		out, err = product.NewPostgresStoreTx(tx).GetLinkedContent(txCtx, workspaceID, productID)
		return err
	})
	return out, err
}

func (s *tenantProductStore) BatchTag(ctx context.Context, workspaceID string, productIDs []string, tagsToAdd []string, tagsToRemove []string) (int, error) {
	var count int
	err := s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		var err error
		count, err = product.NewPostgresStoreTx(tx).BatchTag(txCtx, workspaceID, productIDs, tagsToAdd, tagsToRemove)
		return err
	})
	return count, err
}

func (s *tenantProductStore) GetIdempotencyRecord(ctx context.Context, workspaceID, idempotencyKey string) (*product.IdempotencyRecord, error) {
	var out *product.IdempotencyRecord
	err := s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		var err error
		out, err = product.NewPostgresStoreTx(tx).GetIdempotencyRecord(txCtx, workspaceID, idempotencyKey)
		return err
	})
	return out, err
}

func (s *tenantProductStore) SaveIdempotencyRecord(ctx context.Context, rec product.IdempotencyRecord) error {
	return s.runInTenantTx(ctx, rec.WorkspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		return product.NewPostgresStoreTx(tx).SaveIdempotencyRecord(txCtx, rec)
	})
}

func (s *tenantProductStore) GetProductSalesSummary(ctx context.Context, workspaceID, productID string) (*product.ProductSalesSummary, error) {
	var out *product.ProductSalesSummary
	err := s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		var err error
		out, err = product.NewPostgresStoreTx(tx).GetProductSalesSummary(txCtx, workspaceID, productID)
		return err
	})
	return out, err
}

func (s *tenantProductStore) GetProductSalesChart(ctx context.Context, workspaceID, productID string, days int) ([]product.SalesChartDataPoint, error) {
	var out []product.SalesChartDataPoint
	err := s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		var err error
		out, err = product.NewPostgresStoreTx(tx).GetProductSalesChart(txCtx, workspaceID, productID, days)
		return err
	})
	return out, err
}

func (s *tenantProductStore) GetProductRank(ctx context.Context, workspaceID, productID string) (*product.ProductRankSummary, error) {
	var out *product.ProductRankSummary
	err := s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		var err error
		out, err = product.NewPostgresStoreTx(tx).GetProductRank(txCtx, workspaceID, productID)
		return err
	})
	return out, err
}

// =============================================================================
// Helpers
// =============================================================================

func extractBearerToken(headerValue string) (string, error) {
	raw := strings.TrimSpace(headerValue)
	if raw == "" {
		return "", errors.New("missing Authorization header")
	}
	parts := strings.Fields(raw)
	if len(parts) != 2 || !strings.EqualFold(parts[0], "Bearer") || strings.TrimSpace(parts[1]) == "" {
		return "", errors.New("Authorization header must be Bearer <token>")
	}
	return parts[1], nil
}

func writeJSONError(w http.ResponseWriter, status int, code, msg string) {
	w.Header().Set("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(status)
	_ = json.NewEncoder(w).Encode(map[string]any{
		"code":    code,
		"message": msg,
	})
}

func newUUIDv4() string {
	var b [16]byte
	_, _ = rand.Read(b[:])
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%s-%s-%s-%s-%s",
		hex.EncodeToString(b[0:4]),
		hex.EncodeToString(b[4:6]),
		hex.EncodeToString(b[6:8]),
		hex.EncodeToString(b[8:10]),
		hex.EncodeToString(b[10:16]),
	)
}

const fallbackRBACBindingsCSV = `rpc,permission_key,behavior_family,module,role_envelope
ProductService/List,product:read,query,M13,Member
ProductService/Get,product:read,query,M13,Member
ProductService/Create,product:manage,command,M13,Editor+
ProductService/Update,product:manage,command,M13,Editor+
ProductService/Delete,product:delete,command,M13,Admin+
ProductService/Archive,product:manage,command,M13,Editor+
ProductService/BulkArchive,product:manage,command,M13,Manager+
ProductService/UpdateStock,product:manage,command,M13,Editor+
ProductService/SetAlertThreshold,product:manage,command,M13,Editor+
ProductService/LinkContent,product:manage,command,M13,Editor+
ProductService/GetLinkedContent,product:read,query,M13,Member
ProductService/BatchTag,product:manage,command,M13,Editor+
DiagnosticsService/GetOverview,diagnostics:read,query,M23,Admin+
DiagnosticsService/GetHealthGrid,diagnostics:read,query,M23,Admin+
DiagnosticsService/ListIssues,diagnostics:read,query,M23,Admin+
DiagnosticsService/RunFullCheck,workspace:settings:manage,command,M23,Admin+
DiagnosticsService/ExecuteRepairStep,workspace:settings:manage,command,M23,Admin+
CapabilityService/GetMatrix,capability:read,query,M22,Member
CapabilityService/GetHealthScores,capability:read,query,M22,Member
CapabilityService/GetHistory,capability:read,query,M22,Manager+
CapabilityService/ListPolicyNotes,capability:read,query,M22,Member
CapabilityService/ListFallbackPaths,capability:read,query,M22,Member
CapabilityService/GetRecentIssues,capability:read,query,M22,Member
CapabilityService/GetSnapshots,capability:read,query,M22,Member
CapabilityService/GetSystemStatus,capability:read,query,M22,Member
`

func loadCanonicalRBACRegistry(explicitPath string) (*rbac.Registry, error) {
	candidates := []string{}
	if explicitPath != "" {
		candidates = append(candidates, explicitPath)
	}
	candidates = append(candidates,
		filepath.Join("docs", "04_contracts", "rpc_permission_bindings.csv"),
		filepath.Join("..", "..", "docs", "04_contracts", "rpc_permission_bindings.csv"),
		filepath.Join("..", "..", "..", "docs", "04_contracts", "rpc_permission_bindings.csv"),
		filepath.Join("..", "..", "..", "..", "docs", "04_contracts", "rpc_permission_bindings.csv"),
	)
	for _, p := range candidates {
		if f, err := os.Open(p); err == nil {
			reg, loadErr := rbac.LoadBindingsCSV(f)
			_ = f.Close()
			if loadErr == nil {
				return reg, nil
			}
		}
	}
	return rbac.LoadBindingsCSV(strings.NewReader(fallbackRBACBindingsCSV))
}
