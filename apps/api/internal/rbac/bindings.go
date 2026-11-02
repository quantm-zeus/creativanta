package rbac

import (
	"context"
	"encoding/csv"
	"errors"
	"fmt"
	"io"
	"os"
	"path/filepath"
	"strings"
)

var (
	// ErrUnboundRPC is returned when an RPC is not registered in rpc_permission_bindings.csv.
	ErrUnboundRPC = errors.New("rbac: RPC has no canonical permission binding (fail-closed)")
	// ErrInvalidBindingCSV is returned when rpc_permission_bindings.csv is malformed or contains unknown keys.
	ErrInvalidBindingCSV = errors.New("rbac: invalid rpc_permission_bindings.csv contract")
)

// RPCBinding represents a single row in docs/04_contracts/rpc_permission_bindings.csv.
type RPCBinding struct {
	RPC            string
	PermissionKey  string
	BehaviorFamily string
	Module         string
	RoleEnvelope   string
}

// IsMutating reports whether the RPC mutates state based on its behavior_family or method name.
func (b RPCBinding) IsMutating() bool {
	switch b.BehaviorFamily {
	case "command", "external", "generation":
		return true
	case "query", "public":
		return false
	case "admin":
		// In admin family, read/list/get/export/verify methods are read-only; others mutate.
		method := b.RPC
		if idx := strings.LastIndex(method, "/"); idx >= 0 {
			method = method[idx+1:]
		}
		readPrefixes := []string{"Get", "List", "Search", "Export", "Verify", "Validate", "Check", "Inspect"}
		for _, p := range readPrefixes {
			if strings.HasPrefix(method, p) {
				return false
			}
		}
		return true
	default:
		return false
	}
}

// Registry holds the validated canonical RPC permission bindings.
type Registry struct {
	bindings map[string]RPCBinding
}

// PermissionChecker matches §5 of docs/04_contracts/rbac_permission_matrix.md.
type PermissionChecker interface {
	Require(ctx context.Context, rpc string, objectID string) error
}

type policyContextKey struct{}

// WithPolicyContext attaches PolicyContext to ctx for PermissionChecker.Require calls.
func WithPolicyContext(ctx context.Context, pctx PolicyContext) context.Context {
	return context.WithValue(ctx, policyContextKey{}, pctx)
}

// PolicyContextFromContext extracts PolicyContext from ctx.
func PolicyContextFromContext(ctx context.Context) (PolicyContext, bool) {
	if ctx == nil {
		return PolicyContext{}, false
	}
	pctx, ok := ctx.Value(policyContextKey{}).(PolicyContext)
	return pctx, ok
}

// LoadCanonicalBindings loads docs/04_contracts/rpc_permission_bindings.csv from repoRoot.
func LoadCanonicalBindings(repoRoot string) (*Registry, error) {
	path := filepath.Join(repoRoot, "docs", "04_contracts", "rpc_permission_bindings.csv")
	f, err := os.Open(path)
	if err != nil {
		return nil, fmt.Errorf("rbac: open bindings csv %q: %w", path, err)
	}
	defer f.Close()
	return LoadBindingsCSV(f)
}

// LoadBindingsCSV parses and validates rpc_permission_bindings.csv from an io.Reader.
func LoadBindingsCSV(r io.Reader) (*Registry, error) {
	reader := csv.NewReader(r)
	records, err := reader.ReadAll()
	if err != nil {
		return nil, fmt.Errorf("%w: %v", ErrInvalidBindingCSV, err)
	}
	if len(records) < 2 {
		return nil, fmt.Errorf("%w: empty bindings table", ErrInvalidBindingCSV)
	}

	header := records[0]
	expectedHeader := []string{"rpc", "permission_key", "behavior_family", "module", "role_envelope"}
	if len(header) != len(expectedHeader) {
		return nil, fmt.Errorf("%w: unexpected column count %d", ErrInvalidBindingCSV, len(header))
	}
	for i, col := range expectedHeader {
		if strings.TrimSpace(header[i]) != col {
			return nil, fmt.Errorf("%w: column %d expected %q got %q", ErrInvalidBindingCSV, i, col, header[i])
		}
	}

	bindings := make(map[string]RPCBinding, len(records)-1)
	for rowIdx, row := range records[1:] {
		if len(row) != 5 {
			return nil, fmt.Errorf("%w: line %d has %d columns", ErrInvalidBindingCSV, rowIdx+2, len(row))
		}
		b := RPCBinding{
			RPC:            strings.TrimSpace(row[0]),
			PermissionKey:  strings.TrimSpace(row[1]),
			BehaviorFamily: strings.TrimSpace(row[2]),
			Module:         strings.TrimSpace(row[3]),
			RoleEnvelope:   strings.TrimSpace(row[4]),
		}
		if b.RPC == "" || !strings.Contains(b.RPC, "/") {
			return nil, fmt.Errorf("%w: line %d invalid rpc %q", ErrInvalidBindingCSV, rowIdx+2, b.RPC)
		}
		if _, dup := bindings[b.RPC]; dup {
			return nil, fmt.Errorf("%w: line %d duplicate rpc %q", ErrInvalidBindingCSV, rowIdx+2, b.RPC)
		}
		if b.PermissionKey != "PUBLIC" {
			if b.BehaviorFamily == "admin" {
				if _, ok := adminPermissionMatrix[b.PermissionKey]; !ok {
					return nil, fmt.Errorf("%w: line %d (%s) unknown admin permission %q", ErrInvalidBindingCSV, rowIdx+2, b.RPC, b.PermissionKey)
				}
			} else {
				if _, ok := workspacePermissionMatrix[b.PermissionKey]; !ok {
					return nil, fmt.Errorf("%w: line %d (%s) unknown workspace permission %q", ErrInvalidBindingCSV, rowIdx+2, b.RPC, b.PermissionKey)
				}
			}
		}
		bindings[b.RPC] = b
	}

	return &Registry{bindings: bindings}, nil
}

// Count returns the number of loaded RPC bindings.
func (r *Registry) Count() int {
	if r == nil {
		return 0
	}
	return len(r.bindings)
}

// Lookup resolves the canonical RPCBinding for rpc (accepting either "Service/Method"
// or Connect full procedure "/creativanta.../Service/Method").
func (r *Registry) Lookup(rpc string) (RPCBinding, bool) {
	if r == nil {
		return RPCBinding{}, false
	}
	normalized := normalizeRPCName(rpc)
	b, ok := r.bindings[normalized]
	return b, ok
}

func normalizeRPCName(rpc string) string {
	trimmed := strings.TrimSpace(rpc)
	trimmed = strings.TrimPrefix(trimmed, "/")
	parts := strings.Split(trimmed, "/")
	if len(parts) == 2 {
		// If package prefix is present in parts[0], e.g., "creativanta.workspace.v1.WorkspaceService",
		// extract the final service identifier after the last dot.
		svc := parts[0]
		if dot := strings.LastIndex(svc, "."); dot >= 0 {
			svc = svc[dot+1:]
		}
		return svc + "/" + parts[1]
	}
	return trimmed
}

var workspaceRoleRank = map[string]int{
	RoleOwner:       7,
	RoleAdmin:       6,
	RoleManager:     5,
	RoleEditor:      4,
	RoleContributor: 3,
	RoleViewer:      2,
	RoleExternal:    1,
}

func checkRoleEnvelopeFloor(role, envelope string) error {
	rank, ok := workspaceRoleRank[role]
	if !ok {
		return fmt.Errorf("%w: %q", ErrUnknownRole, role)
	}
	switch envelope {
	case "Owner":
		if rank < workspaceRoleRank[RoleOwner] {
			return fmt.Errorf("%w: RPC envelope requires Owner, got %q", ErrPermissionDenied, role)
		}
	case "Admin+":
		if rank < workspaceRoleRank[RoleAdmin] {
			return fmt.Errorf("%w: RPC envelope requires Admin+, got %q", ErrPermissionDenied, role)
		}
	case "Manager+":
		if rank < workspaceRoleRank[RoleManager] {
			return fmt.Errorf("%w: RPC envelope requires Manager+, got %q", ErrPermissionDenied, role)
		}
	case "Editor+":
		if rank < workspaceRoleRank[RoleEditor] {
			return fmt.Errorf("%w: RPC envelope requires Editor+, got %q", ErrPermissionDenied, role)
		}
	case "Contributor+":
		if rank < workspaceRoleRank[RoleContributor] {
			return fmt.Errorf("%w: RPC envelope requires Contributor+, got %q", ErrPermissionDenied, role)
		}
	case "Viewer+", "Member":
		// Viewer+ or Member requires at least Viewer unless constrained external share is granted by matrix.
		if role == RoleExternal {
			// External is only allowed if the matrix cell itself is AccessAllow or AccessConstrained.
			return nil
		}
		if rank < workspaceRoleRank[RoleViewer] {
			return fmt.Errorf("%w: RPC envelope requires Member/Viewer+, got %q", ErrPermissionDenied, role)
		}
	}
	return nil
}

// Authorize checks whether pctx is permitted to invoke rpc according to rpc_permission_bindings.csv
// and rbac_permission_matrix.md. Missing or unknown RPCs fail closed with ErrUnboundRPC.
func (r *Registry) Authorize(rpc string, pctx PolicyContext) (RPCBinding, error) {
	b, ok := r.Lookup(rpc)
	if !ok {
		return RPCBinding{}, fmt.Errorf("%w: %q", ErrUnboundRPC, rpc)
	}

	if b.PermissionKey == "PUBLIC" {
		return b, nil
	}

	if b.BehaviorFamily == "admin" {
		if err := CheckAdminPermission(b.PermissionKey, pctx, b.IsMutating()); err != nil {
			return b, err
		}
		return b, nil
	}

	// Session-bootstrap / user:self RPCs (e.g. AuthService/ValidateSession, WorkspaceService/Create)
	// require an authenticated ActorUserID; when Role is not yet bound (pre-workspace bootstrap),
	// user:self is allowed for the authenticated user on their own identity.
	if b.PermissionKey == "user:self" && (b.RoleEnvelope == "JWT" || b.RoleEnvelope == "Self") && pctx.Role == "" {
		if strings.TrimSpace(pctx.ActorUserID) == "" {
			return b, fmt.Errorf("%w: authenticated user required for %s", ErrPermissionDenied, b.RPC)
		}
		if pctx.TargetOwnerUserID != "" && pctx.TargetOwnerUserID != pctx.ActorUserID {
			return b, fmt.Errorf("%w: user:self cannot access another user resource", ErrPermissionDenied)
		}
		if pctx.IsImpersonation && b.IsMutating() {
			return b, ErrImpersonationReadOnly
		}
		return b, nil
	}

	if err := CheckWorkspacePermission(b.PermissionKey, pctx); err != nil {
		return b, err
	}
	if err := checkRoleEnvelopeFloor(pctx.Role, b.RoleEnvelope); err != nil {
		return b, err
	}
	return b, nil
}

// Require implements PermissionChecker (§5 of rbac_permission_matrix.md).
func (r *Registry) Require(ctx context.Context, rpc string, objectID string) error {
	if ctx == nil {
		return ErrPermissionDenied
	}
	if err := ctx.Err(); err != nil {
		return err
	}
	pctx, ok := PolicyContextFromContext(ctx)
	if !ok {
		return fmt.Errorf("%w: missing PolicyContext in context for %s (object=%s)", ErrPermissionDenied, rpc, objectID)
	}
	_, err := r.Authorize(rpc, pctx)
	return err
}
