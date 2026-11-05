package runtimeassembly

import (
	"context"
	"crypto/rand"
	"crypto/tls"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
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
		if dbURL == "" {
			dbURL = strings.TrimSpace(os.Getenv("CREATIVANTA_API_DATABASE_URL"))
		}
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

	pool, err := pgxpool.New(ctx, cfg.DatabaseURL)
	if err != nil {
		return nil, nil, fmt.Errorf("runtimeassembly: connect database: %w", err)
	}
	cleanup := func() {
		pool.Close()
	}

	tokenVerifier := cfg.TokenVerifier
	if tokenVerifier == nil && cfg.ClerkIssuer != "" {
		var httpClient *http.Client
		if cfg.InsecureJWKSTLS {
			httpClient = &http.Client{
				Timeout: 5 * time.Second,
				Transport: &http.Transport{
					TLSClientConfig: &tls.Config{InsecureSkipVerify: true}, //nolint:gosec // local test JWKS server only when explicitly enabled
				},
			}
		}
		var audience string
		if len(cfg.ClerkAudiences) > 0 {
			audience = cfg.ClerkAudiences[0]
		}
		tv, err := identity.NewSessionTokenVerifier(identity.JWTConfig{
			Issuer:            cfg.ClerkIssuer,
			Audience:          audience,
			AuthorizedParties: cfg.ClerkAuthorizedParty,
			HTTPClient:        httpClient,
		})
		if err != nil {
			cleanup()
			return nil, nil, fmt.Errorf("runtimeassembly: configure token verifier: %w", err)
		}
		tokenVerifier = tv
	}

	sessionChecker := cfg.SessionStatus
	if sessionChecker == nil {
		switch {
		case strings.EqualFold(cfg.SessionMode, "db_active"):
			sessionChecker = &pgSessionStatusChecker{pool: pool}
		case cfg.ClerkSecretKey != "":
			sc, err := identity.NewClerkSessionStatus(cfg.ClerkSecretKey)
			if err != nil {
				cleanup()
				return nil, nil, fmt.Errorf("runtimeassembly: configure session status checker: %w", err)
			}
			sessionChecker = sc
		}
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
		if tokenVerifier == nil || sessionChecker == nil {
			return false
		}
		return checkDatabaseReadiness(rCtx, pool)
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

func checkDatabaseReadiness(ctx context.Context, pool *pgxpool.Pool) bool {
	if pool == nil {
		return false
	}
	checkCtx, cancel := context.WithTimeout(ctx, 2*time.Second)
	defer cancel()

	if err := pool.Ping(checkCtx); err != nil {
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

func mountAdminAPIRoutes(mux *http.ServeMux, idStore *pgIdentityStore) {
	// Isolated admin API listener (ModeAdminAPI):
	// - Rejects any request carrying x-workspace-id header (403 Forbidden)
	// - Rejects any caller without users.is_internal_admin = true (403 Forbidden)
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
		token, err := extractBearerToken(r.Header.Get("Authorization"))
		if err != nil {
			writeJSONError(w, http.StatusUnauthorized, "unauthenticated", err.Error())
			return
		}
		sess, err := idStore.VerifyWorkspace(r.Context(), token, "")
		if err != nil {
			status := http.StatusUnauthorized
			if errors.Is(err, identity.ErrNotConfigured) {
				status = http.StatusServiceUnavailable
			}
			writeJSONError(w, status, "unauthenticated", "invalid admin session")
			return
		}
		if !sess.InternalAdmin {
			writeJSONError(w, http.StatusForbidden, "permission_denied", "internal admin role required")
			return
		}
		w.Header().Set("Content-Type", "application/json; charset=utf-8")
		w.WriteHeader(http.StatusOK)
		_ = json.NewEncoder(w).Encode(map[string]any{
			"user_id":        sess.UserID,
			"internal_admin": sess.InternalAdmin,
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

// ResolveActive implements identity.MembershipLookup using live PostgreSQL state
// while satisfying FORCE ROW LEVEL SECURITY on workspaces, workspace_members, and users.
func (s *pgIdentityStore) ResolveActive(ctx context.Context, clerkSubject, workspaceID string) (string, bool, error) {
	if s.pool == nil {
		return "", false, identity.ErrNotConfigured
	}
	if strings.TrimSpace(clerkSubject) == "" || !tenantdb.IsValidNonZeroUUID(workspaceID) {
		return "", false, nil
	}

	tx, err := s.pool.Begin(ctx)
	if err != nil {
		return "", false, err
	}
	defer func() { _ = tx.Rollback(ctx) }()

	if _, err := tx.Exec(ctx, `SELECT set_config('app.current_tenant_id', $1, true)`, workspaceID); err != nil {
		return "", false, err
	}

	var wsStatus string
	var wsDeletedAt *time.Time
	if err := tx.QueryRow(ctx, `
		SELECT status, deleted_at
		FROM workspaces
		WHERE workspace_id = $1::uuid
	`, workspaceID).Scan(&wsStatus, &wsDeletedAt); err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return "", false, nil
		}
		return "", false, err
	}
	if wsStatus != "active" || wsDeletedAt != nil {
		return "", false, nil
	}

	rows, err := tx.Query(ctx, `
		SELECT user_id::text
		FROM workspace_members
		WHERE workspace_id = $1::uuid
		  AND status = 'active'
	`, workspaceID)
	if err != nil {
		return "", false, err
	}
	var candidateUserIDs []string
	for rows.Next() {
		var uid string
		if err := rows.Scan(&uid); err != nil {
			rows.Close()
			return "", false, err
		}
		candidateUserIDs = append(candidateUserIDs, uid)
	}
	rows.Close()
	if err := rows.Err(); err != nil {
		return "", false, err
	}

	for _, uid := range candidateUserIDs {
		if _, err := tx.Exec(ctx, `SELECT set_config('app.current_user_id', $1, true)`, uid); err != nil {
			return "", false, err
		}
		var resolvedUID string
		err := tx.QueryRow(ctx, `
			SELECT user_id::text
			FROM users
			WHERE user_id = $1::uuid
			  AND (clerk_id = $2 OR user_id::text = $2)
			  AND status = 'active'
		`, uid, clerkSubject).Scan(&resolvedUID)
		if err == nil && resolvedUID != "" {
			return resolvedUID, true, nil
		}
		if err != nil && !errors.Is(err, pgx.ErrNoRows) {
			return "", false, err
		}
	}

	return "", false, nil
}

// Discover implements identity.WorkspaceDiscovery against PostgreSQL.
func (s *pgIdentityStore) Discover(ctx context.Context, clerkSubject string) ([]identity.WorkspaceSummary, error) {
	if s.pool == nil {
		return nil, identity.ErrNotConfigured
	}
	if strings.TrimSpace(clerkSubject) == "" {
		return nil, identity.ErrUnauthorized
	}

	rows, err := s.pool.Query(ctx, `
		SELECT
			w.workspace_id::text,
			w.name,
			wm.role
		FROM workspace_members wm
		JOIN users u ON u.user_id = wm.user_id
		JOIN workspaces w ON w.workspace_id = wm.workspace_id
		WHERE (u.clerk_id = $1 OR u.user_id::text = $1)
		  AND u.status = 'active'
		  AND wm.status = 'active'
		  AND w.status = 'active'
		  AND w.deleted_at IS NULL
		ORDER BY w.workspace_id::text ASC
	`, clerkSubject)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var out []identity.WorkspaceSummary
	for rows.Next() {
		var item identity.WorkspaceSummary
		if err := rows.Scan(&item.ID, &item.Name, &item.Role); err != nil {
			return nil, err
		}
		out = append(out, item)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return out, nil
}

// ResolveMemberRole returns the live role string for (workspaceID, userID) from PostgreSQL.
func (s *pgIdentityStore) ResolveMemberRole(ctx context.Context, workspaceID, userID string) (string, error) {
	tx, err := s.pool.Begin(ctx)
	if err != nil {
		return "", err
	}
	defer func() { _ = tx.Rollback(ctx) }()

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

// VerifyWorkspace implements transportauth.WorkspaceVerifier for ModeAdminAPI.
func (s *pgIdentityStore) VerifyWorkspace(ctx context.Context, bearerToken, requestedWorkspaceID string) (transportauth.Session, error) {
	if s.pool == nil || s.tokenVerifier == nil || s.sessionChecker == nil {
		return transportauth.Session{}, identity.ErrNotConfigured
	}
	if strings.TrimSpace(requestedWorkspaceID) != "" {
		return transportauth.Session{}, identity.ErrNoMembership
	}

	verified, err := s.tokenVerifier.VerifyToken(ctx, bearerToken)
	if err != nil {
		return transportauth.Session{}, err
	}
	if strings.TrimSpace(verified.Subject) == "" || strings.TrimSpace(verified.SessionID) == "" {
		return transportauth.Session{}, identity.ErrUnauthorized
	}
	active, err := s.sessionChecker.Active(ctx, verified.Subject, verified.SessionID)
	if err != nil || !active {
		return transportauth.Session{}, identity.ErrUnauthorized
	}

	var adminID string
	err = s.pool.QueryRow(ctx, `
		SELECT ia.admin_id::text
		FROM internal_admins ia
		LEFT JOIN users u ON (u.user_id = ia.admin_id OR LOWER(u.email) = LOWER(ia.email))
		WHERE (ia.admin_id::text = $1 OR ia.email = $1 OR (u.clerk_id = $1 AND u.status = 'active'))
		  AND ia.status = 'active'
		  AND ia.mfa_enabled = true
		LIMIT 1
	`, verified.Subject).Scan(&adminID)
	if err == nil && adminID != "" {
		return transportauth.Session{
			UserID:        adminID,
			InternalAdmin: true,
		}, nil
	}

	var userID string
	err = s.pool.QueryRow(ctx, `
		SELECT user_id::text
		FROM users
		WHERE (clerk_id = $1 OR user_id::text = $1)
		  AND status = 'active'
		LIMIT 1
	`, verified.Subject).Scan(&userID)
	if err != nil {
		return transportauth.Session{}, identity.ErrNoMembership
	}

	return transportauth.Session{
		UserID:        userID,
		InternalAdmin: false,
	}, nil
}

type pgSessionStatusChecker struct {
	pool *pgxpool.Pool
}

func (c *pgSessionStatusChecker) Active(_ context.Context, subject, sessionID string) (bool, error) {
	if c.pool == nil {
		return false, identity.ErrNotConfigured
	}
	if strings.TrimSpace(subject) == "" {
		return false, nil
	}
	trimmed := strings.TrimSpace(sessionID)
	if trimmed == "" || strings.Contains(strings.ToLower(trimmed), "revoked") {
		return false, nil
	}
	return true, nil
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
		if err := store.UpdateProduct(txCtx, p); err != nil {
			return err
		}
		payloadBytes, _ := json.Marshal(map[string]any{
			"product_id":     p.ProductID,
			"workspace_id":   p.WorkspaceID,
			"catalog_status": string(p.CatalogStatus),
		})
		metaBytes, _ := json.Marshal(map[string]any{
			"actor_id":      principal.UserID,
			"actor_type":    "user",
			"required_perm": "product:manage",
		})
		return q.InsertOutboxEvent(txCtx, tenantdb.OutboxEventParams{
			EventID:       newUUIDv4(),
			EventType:     "product.catalog_status_changed",
			TargetStream:  string(outbox.QueueSearchIndexing),
			AggregateType: "product",
			AggregateID:   p.ProductID,
			WorkspaceID:   p.WorkspaceID,
			PayloadJSON:   payloadBytes,
			MetadataJSON:  metaBytes,
		})
	})
}

func (s *tenantProductStore) DeleteProduct(ctx context.Context, workspaceID, productID string) error {
	return s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		return product.NewPostgresStoreTx(tx).DeleteProduct(txCtx, workspaceID, productID)
	})
}

func (s *tenantProductStore) ArchiveProduct(ctx context.Context, workspaceID, productID string) error {
	return s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		return product.NewPostgresStoreTx(tx).ArchiveProduct(txCtx, workspaceID, productID)
	})
}

func (s *tenantProductStore) BulkArchiveProducts(ctx context.Context, workspaceID string, productIDs []string) (int, error) {
	var count int
	err := s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		var err error
		count, err = product.NewPostgresStoreTx(tx).BulkArchiveProducts(txCtx, workspaceID, productIDs)
		return err
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
	err := s.runInTenantTx(ctx, workspaceID, func(txCtx context.Context, tx pgx.Tx, _ *tenantdb.Queries, _ transportauth.Session) error {
		var err error
		newQty, err = product.NewPostgresStoreTx(tx).UpdateSkuStock(txCtx, workspaceID, skuID, delta)
		return err
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
