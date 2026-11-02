package workspace

import (
	"context"
	"crypto/rand"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"regexp"
	"strings"
	"time"

	"github.com/quantm-zeus/creativanta/apps/api/internal/rbac"
	"github.com/quantm-zeus/creativanta/apps/api/internal/tenantdb"
)

var (
	// ErrInvalidInput is returned when request fields fail validation.
	ErrInvalidInput = errors.New("workspace: invalid request input (VALIDATION_ERROR_001)")
	// ErrIdempotencyConflict is returned when an idempotency key is reused with a different request payload.
	ErrIdempotencyConflict = errors.New("workspace: idempotency key reused with different payload (SYSTEM_CONFLICT_001)")
	// ErrCannotModifySelfRole is returned when a member attempts to change their own role directly.
	ErrCannotModifySelfRole = errors.New("workspace: cannot directly modify own role; owner must transfer ownership to another member")
	// ErrAdminCannotModifyOwner is returned when a non-owner Admin attempts to modify or remove an Owner.
	ErrAdminCannotModifyOwner = errors.New("workspace: admin cannot modify, promote to, or remove the owner role")
)

var slugPattern = regexp.MustCompile(`^[a-z0-9](?:[a-z0-9-]{1,98}[a-z0-9])?$`)

// RevocationHook is notified synchronously inside the commit path when a member's
// role is changed or membership is revoked, allowing any in-memory session/permission
// projection to be invalidated immediately before the RPC returns.
type RevocationHook interface {
	OnMemberRevoked(workspaceID, userID, memberID string)
	OnMemberRoleUpdated(workspaceID, userID, memberID, oldRole, newRole string)
}

// Service implements P0-04 WorkspaceService operations over tenantdb.WithTx and rbac.Registry.
type Service struct {
	Beginner       tenantdb.TxBeginner
	Bindings       *rbac.Registry
	RevocationHook RevocationHook
	IDGenerator    func() string
	Now            func() time.Time
}

// NewService constructs a P0-04 workspace Service.
func NewService(beginner tenantdb.TxBeginner, bindings *rbac.Registry) *Service {
	return &Service{
		Beginner:    beginner,
		Bindings:    bindings,
		IDGenerator: defaultUUIDv4,
		Now:         func() time.Time { return time.Now().UTC() },
	}
}

func defaultUUIDv4() string {
	var b [16]byte
	if _, err := rand.Read(b[:]); err != nil {
		panic(fmt.Sprintf("workspace: crypto/rand unavailable: %v", err))
	}
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

func hashRequest(parts ...string) string {
	h := sha256.New()
	for _, p := range parts {
		h.Write([]byte(p))
		h.Write([]byte{0})
	}
	return hex.EncodeToString(h.Sum(nil))
}

// CreateWorkspaceRequest is the input contract for WorkspaceService/Create.
type CreateWorkspaceRequest struct {
	ActorUserID    string
	IdempotencyKey string
	Name           string
	Slug           string
	DefaultMode    string
	EnabledModes   []string
	Locale         string
	Timezone       string
}

// Create executes WorkspaceService/Create inside WithUserBootstrapTx.
func (s *Service) Create(ctx context.Context, req CreateWorkspaceRequest) (WorkspaceProjection, error) {
	if s == nil || s.Beginner == nil || s.Bindings == nil {
		return WorkspaceProjection{}, tenantdb.ErrNilBeginner
	}
	if !tenantdb.IsValidNonZeroUUID(req.ActorUserID) {
		return WorkspaceProjection{}, fmt.Errorf("%w: invalid actor_user_id", ErrInvalidInput)
	}
	name := strings.TrimSpace(req.Name)
	slug := strings.TrimSpace(req.Slug)
	if len(name) < 2 || len(name) > 255 {
		return WorkspaceProjection{}, fmt.Errorf("%w: workspace name must be 2..255 chars", ErrInvalidInput)
	}
	if !slugPattern.MatchString(slug) {
		return WorkspaceProjection{}, fmt.Errorf("%w: invalid workspace slug %q", ErrInvalidInput, slug)
	}
	if strings.TrimSpace(req.IdempotencyKey) == "" || len(req.IdempotencyKey) > 255 {
		return WorkspaceProjection{}, fmt.Errorf("%w: idempotency_key required (1..255 chars)", ErrInvalidInput)
	}

	if _, err := s.Bindings.Authorize("WorkspaceService/Create", rbac.PolicyContext{
		ActorUserID: req.ActorUserID,
	}); err != nil {
		return WorkspaceProjection{}, err
	}

	initialCredits, err := tenantdb.ParseExactDecimal("30")
	if err != nil {
		return WorkspaceProjection{}, err
	}

	var out WorkspaceProjection
	err = tenantdb.WithUserBootstrapTx(ctx, s.Beginner, req.ActorUserID, func(txCtx context.Context, q *tenantdb.Queries) error {
		wsID := s.IDGenerator()
		memberID := s.IDGenerator()
		row, err := q.CreateWorkspace(txCtx, tenantdb.CreateWorkspaceParams{
			WorkspaceID:    wsID,
			Name:           name,
			Slug:           slug,
			OwnerUserID:    req.ActorUserID,
			DefaultMode:    req.DefaultMode,
			EnabledModes:   req.EnabledModes,
			Locale:         req.Locale,
			Timezone:       req.Timezone,
			InitialCredits: initialCredits,
			MonthlyLimit:   initialCredits,
			OwnerMemberID:  memberID,
		})
		if err != nil {
			return err
		}
		out = ProjectWorkspace(row)
		return nil
	})
	return out, err
}

// Get executes WorkspaceService/Get inside tenantdb.WithTx.
func (s *Service) Get(ctx context.Context, workspaceID, actorUserID string) (WorkspaceProjection, error) {
	if s == nil || s.Beginner == nil || s.Bindings == nil {
		return WorkspaceProjection{}, tenantdb.ErrNilBeginner
	}
	var out WorkspaceProjection
	err := tenantdb.WithTx(ctx, s.Beginner, tenantdb.Scope{
		WorkspaceID:             workspaceID,
		UserID:                  actorUserID,
		RequireActiveMembership: true,
	}, func(txCtx context.Context, q *tenantdb.Queries) error {
		sc, _ := tenantdb.ScopeFromContext(txCtx)
		if _, err := s.Bindings.Authorize("WorkspaceService/Get", rbac.PolicyContext{
			ActorUserID: actorUserID,
			WorkspaceID: workspaceID,
			Role:        sc.Role,
		}); err != nil {
			return err
		}
		row, err := q.GetWorkspace(txCtx, workspaceID)
		if err != nil {
			return err
		}
		out = ProjectWorkspace(row)
		return nil
	})
	return out, err
}

// ListMembers executes WorkspaceService/ListMembers inside tenantdb.WithTx.
func (s *Service) ListMembers(ctx context.Context, workspaceID, actorUserID string) ([]WorkspaceMemberProjection, error) {
	if s == nil || s.Beginner == nil || s.Bindings == nil {
		return nil, tenantdb.ErrNilBeginner
	}
	var out []WorkspaceMemberProjection
	err := tenantdb.WithTx(ctx, s.Beginner, tenantdb.Scope{
		WorkspaceID:             workspaceID,
		UserID:                  actorUserID,
		RequireActiveMembership: true,
	}, func(txCtx context.Context, q *tenantdb.Queries) error {
		sc, _ := tenantdb.ScopeFromContext(txCtx)
		if _, err := s.Bindings.Authorize("WorkspaceService/ListMembers", rbac.PolicyContext{
			ActorUserID: actorUserID,
			WorkspaceID: workspaceID,
			Role:        sc.Role,
		}); err != nil {
			return err
		}
		rows, err := q.ListWorkspaceMembers(txCtx, workspaceID)
		if err != nil {
			return err
		}
		out = make([]WorkspaceMemberProjection, 0, len(rows))
		for _, r := range rows {
			out = append(out, ProjectWorkspaceMember(r))
		}
		return nil
	})
	return out, err
}

// UpdateRoleRequest is the input contract for WorkspaceService/UpdateRole.
type UpdateRoleRequest struct {
	WorkspaceID    string
	ActorUserID    string
	IdempotencyKey string
	TargetMemberID string
	NewRole        string
	Reason         string
}

// UpdateRoleResult reports the updated member projection and whether the response was replayed.
type UpdateRoleResult struct {
	Member   WorkspaceMemberProjection `json:"member"`
	Replayed bool                      `json:"replayed"`
}

// UpdateRole executes WorkspaceService/UpdateRole inside tenantdb.WithTx, enforcing:
//   - Canonical RBAC (`workspace:roles:assign` -> Owner, Admin)
//   - Admin cannot modify an Owner or promote anyone to Owner (`ErrAdminCannotModifyOwner`)
//   - Last active Owner protection (`tenantdb.ErrLastOwnerProtected`)
//   - Atomic single-transaction ownership transfer when Owner promotes another active member to `owner`
//   - Synchronous notification of RevocationHook so permission projections update immediately
//   - Idempotency, audit_events, and event_outbox persistence in the same transaction
func (s *Service) UpdateRole(ctx context.Context, req UpdateRoleRequest) (UpdateRoleResult, error) {
	if s == nil || s.Beginner == nil || s.Bindings == nil {
		return UpdateRoleResult{}, tenantdb.ErrNilBeginner
	}
	if !tenantdb.IsValidNonZeroUUID(req.WorkspaceID) ||
		!tenantdb.IsValidNonZeroUUID(req.ActorUserID) ||
		!tenantdb.IsValidNonZeroUUID(req.TargetMemberID) {
		return UpdateRoleResult{}, fmt.Errorf("%w: invalid UUID in UpdateRoleRequest", ErrInvalidInput)
	}
	if !rbac.IsValidWorkspaceRole(req.NewRole) {
		return UpdateRoleResult{}, fmt.Errorf("%w: invalid workspace role %q", ErrInvalidInput, req.NewRole)
	}
	idemKey := strings.TrimSpace(req.IdempotencyKey)
	if idemKey == "" || len(idemKey) > 255 {
		return UpdateRoleResult{}, fmt.Errorf("%w: idempotency_key required (1..255 chars)", ErrInvalidInput)
	}

	reqHash := hashRequest("WorkspaceService/UpdateRole", req.WorkspaceID, req.TargetMemberID, req.NewRole)
	var result UpdateRoleResult
	var hookTargetUserID, hookOldRole string

	err := tenantdb.WithTx(ctx, s.Beginner, tenantdb.Scope{
		WorkspaceID:             req.WorkspaceID,
		UserID:                  req.ActorUserID,
		RequireActiveMembership: true,
	}, func(txCtx context.Context, q *tenantdb.Queries) error {
		sc, _ := tenantdb.ScopeFromContext(txCtx)
		if _, err := s.Bindings.Authorize("WorkspaceService/UpdateRole", rbac.PolicyContext{
			ActorUserID: req.ActorUserID,
			WorkspaceID: req.WorkspaceID,
			Role:        sc.Role,
		}); err != nil {
			return err
		}

		// Check idempotency inside the tenant transaction.
		existing, found, err := q.GetIdempotencyRecord(txCtx, req.WorkspaceID, req.ActorUserID, "WorkspaceService/UpdateRole", idemKey)
		if err != nil {
			return err
		}
		if found {
			if existing.RequestHash != reqHash {
				return ErrIdempotencyConflict
			}
			var cached WorkspaceMemberProjection
			if err := json.Unmarshal(existing.ResponsePayload, &cached); err != nil {
				return err
			}
			result = UpdateRoleResult{Member: cached, Replayed: true}
			return nil
		}

		target, err := q.GetWorkspaceMemberForUpdate(txCtx, req.WorkspaceID, req.TargetMemberID)
		if err != nil {
			return err
		}
		hookTargetUserID = target.UserID
		hookOldRole = target.Role

		// Cannot directly demote/change own role; Owner must transfer ownership to another member.
		if target.UserID == req.ActorUserID {
			if target.Role == rbac.RoleOwner && req.NewRole != rbac.RoleOwner {
				return tenantdb.ErrLastOwnerProtected
			}
			return ErrCannotModifySelfRole
		}

		// Admin cannot modify an Owner or promote anyone to Owner.
		if sc.Role != rbac.RoleOwner && (target.Role == rbac.RoleOwner || req.NewRole == rbac.RoleOwner) {
			return ErrAdminCannotModifyOwner
		}

		var updated tenantdb.WorkspaceMemberRow
		if req.NewRole == rbac.RoleOwner {
			// Atomic ownership transfer in a single transaction!
			updated, err = q.TransferWorkspaceOwnership(txCtx, req.WorkspaceID, req.ActorUserID, req.TargetMemberID, rbac.RoleAdmin)
			if err != nil {
				return err
			}
		} else {
			updated, err = q.UpdateWorkspaceMemberRole(txCtx, req.WorkspaceID, req.TargetMemberID, req.NewRole)
			if err != nil {
				return err
			}
		}

		proj := ProjectWorkspaceMember(updated)
		payloadBytes, err := MarshalSafeJSON(proj)
		if err != nil {
			return err
		}

		changesBytes, _ := json.Marshal(map[string]any{
			"role": map[string]string{
				"old": target.Role,
				"new": updated.Role,
			},
		})
		if err := q.InsertAuditEvent(txCtx, tenantdb.AuditEventParams{
			AuditEventID: s.IDGenerator(),
			WorkspaceID:  req.WorkspaceID,
			ActorUserID:  req.ActorUserID,
			ActorType:    "user",
			Action:       "workspace.member.role_updated",
			ResourceType: "workspace_member",
			ResourceID:   updated.MemberID,
			ChangesJSON:  changesBytes,
			Reason:       req.Reason,
		}); err != nil {
			return err
		}

		if err := q.InsertOutboxEvent(txCtx, tenantdb.OutboxEventParams{
			EventID:       s.IDGenerator(),
			EventType:     "identity.member.role_updated",
			TargetStream:  "notifications",
			AggregateType: "workspace_member",
			AggregateID:   updated.MemberID,
			WorkspaceID:   req.WorkspaceID,
			PayloadJSON:   payloadBytes,
		}); err != nil {
			return err
		}

		if err := q.SaveCompletedIdempotencyRecord(txCtx, tenantdb.IdempotencyRecord{
			RecordID:        s.IDGenerator(),
			WorkspaceID:     req.WorkspaceID,
			ActorID:         req.ActorUserID,
			RPC:             "WorkspaceService/UpdateRole",
			IdempotencyKey:  idemKey,
			RequestHash:     reqHash,
			ResponsePayload: payloadBytes,
			ResponseCode:    200,
			ExpiresAt:       s.Now().Add(24 * time.Hour),
		}); err != nil {
			return err
		}

		result = UpdateRoleResult{Member: proj, Replayed: false}
		return nil
	})
	if err != nil {
		return UpdateRoleResult{}, err
	}

	if !result.Replayed && s.RevocationHook != nil && hookTargetUserID != "" {
		s.RevocationHook.OnMemberRoleUpdated(req.WorkspaceID, hookTargetUserID, req.TargetMemberID, hookOldRole, req.NewRole)
	}
	return result, nil
}

// RemoveMemberRequest is the input contract for WorkspaceService/RemoveMember.
type RemoveMemberRequest struct {
	WorkspaceID    string
	ActorUserID    string
	IdempotencyKey string
	TargetMemberID string
	Reason         string
}

// RemoveMemberResult reports the revoked member projection and whether the response was replayed.
type RemoveMemberResult struct {
	Member   WorkspaceMemberProjection `json:"member"`
	Replayed bool                      `json:"replayed"`
}

// RemoveMember executes WorkspaceService/RemoveMember inside tenantdb.WithTx, enforcing:
//   - Canonical RBAC (`workspace:members:remove` -> Owner, Admin)
//   - Last active Owner protection (`tenantdb.ErrLastOwnerProtected`)
//   - Admin cannot remove an Owner (`ErrAdminCannotModifyOwner`)
//   - Immediate synchronous revocation in `workspace_members` (`status = 'revoked'`)
//   - Immediate RevocationHook notification so subsequent requests with an unexpired JWT fail closed
//   - Idempotency, audit_events, and event_outbox (`identity.member.removed`) in the same transaction
func (s *Service) RemoveMember(ctx context.Context, req RemoveMemberRequest) (RemoveMemberResult, error) {
	if s == nil || s.Beginner == nil || s.Bindings == nil {
		return RemoveMemberResult{}, tenantdb.ErrNilBeginner
	}
	if !tenantdb.IsValidNonZeroUUID(req.WorkspaceID) ||
		!tenantdb.IsValidNonZeroUUID(req.ActorUserID) ||
		!tenantdb.IsValidNonZeroUUID(req.TargetMemberID) {
		return RemoveMemberResult{}, fmt.Errorf("%w: invalid UUID in RemoveMemberRequest", ErrInvalidInput)
	}
	idemKey := strings.TrimSpace(req.IdempotencyKey)
	if idemKey == "" || len(idemKey) > 255 {
		return RemoveMemberResult{}, fmt.Errorf("%w: idempotency_key required (1..255 chars)", ErrInvalidInput)
	}

	reqHash := hashRequest("WorkspaceService/RemoveMember", req.WorkspaceID, req.TargetMemberID)
	var result RemoveMemberResult
	var revokedUserID string

	err := tenantdb.WithTx(ctx, s.Beginner, tenantdb.Scope{
		WorkspaceID:             req.WorkspaceID,
		UserID:                  req.ActorUserID,
		RequireActiveMembership: true,
	}, func(txCtx context.Context, q *tenantdb.Queries) error {
		sc, _ := tenantdb.ScopeFromContext(txCtx)
		if _, err := s.Bindings.Authorize("WorkspaceService/RemoveMember", rbac.PolicyContext{
			ActorUserID: req.ActorUserID,
			WorkspaceID: req.WorkspaceID,
			Role:        sc.Role,
		}); err != nil {
			return err
		}

		existing, found, err := q.GetIdempotencyRecord(txCtx, req.WorkspaceID, req.ActorUserID, "WorkspaceService/RemoveMember", idemKey)
		if err != nil {
			return err
		}
		if found {
			if existing.RequestHash != reqHash {
				return ErrIdempotencyConflict
			}
			var cached WorkspaceMemberProjection
			if err := json.Unmarshal(existing.ResponsePayload, &cached); err != nil {
				return err
			}
			result = RemoveMemberResult{Member: cached, Replayed: true}
			return nil
		}

		target, err := q.GetWorkspaceMemberForUpdate(txCtx, req.WorkspaceID, req.TargetMemberID)
		if err != nil {
			return err
		}
		if sc.Role != rbac.RoleOwner && target.Role == rbac.RoleOwner {
			return ErrAdminCannotModifyOwner
		}

		revoked, err := q.RevokeWorkspaceMember(txCtx, req.WorkspaceID, req.TargetMemberID)
		if err != nil {
			return err
		}
		revokedUserID = revoked.UserID

		proj := ProjectWorkspaceMember(revoked)
		payloadBytes, err := MarshalSafeJSON(proj)
		if err != nil {
			return err
		}

		changesBytes, _ := json.Marshal(map[string]any{
			"status": map[string]string{
				"old": target.Status,
				"new": "revoked",
			},
		})
		if err := q.InsertAuditEvent(txCtx, tenantdb.AuditEventParams{
			AuditEventID: s.IDGenerator(),
			WorkspaceID:  req.WorkspaceID,
			ActorUserID:  req.ActorUserID,
			ActorType:    "user",
			Action:       "workspace.member.removed",
			ResourceType: "workspace_member",
			ResourceID:   revoked.MemberID,
			ChangesJSON:  changesBytes,
			Reason:       req.Reason,
		}); err != nil {
			return err
		}

		if err := q.InsertOutboxEvent(txCtx, tenantdb.OutboxEventParams{
			EventID:       s.IDGenerator(),
			EventType:     "identity.member.removed",
			TargetStream:  "notifications",
			AggregateType: "workspace_member",
			AggregateID:   revoked.MemberID,
			WorkspaceID:   req.WorkspaceID,
			PayloadJSON:   payloadBytes,
		}); err != nil {
			return err
		}

		if err := q.SaveCompletedIdempotencyRecord(txCtx, tenantdb.IdempotencyRecord{
			RecordID:        s.IDGenerator(),
			WorkspaceID:     req.WorkspaceID,
			ActorID:         req.ActorUserID,
			RPC:             "WorkspaceService/RemoveMember",
			IdempotencyKey:  idemKey,
			RequestHash:     reqHash,
			ResponsePayload: payloadBytes,
			ResponseCode:    200,
			ExpiresAt:       s.Now().Add(24 * time.Hour),
		}); err != nil {
			return err
		}

		result = RemoveMemberResult{Member: proj, Replayed: false}
		return nil
	})
	if err != nil {
		return RemoveMemberResult{}, err
	}

	if !result.Replayed && s.RevocationHook != nil && revokedUserID != "" {
		s.RevocationHook.OnMemberRevoked(req.WorkspaceID, revokedUserID, req.TargetMemberID)
	}
	return result, nil
}

// ListSupportTicketMessagesSafe returns tenant-visible support ticket messages inside WithTx,
// enforcing RBAC (`support:own`), PostgreSQL RLS (`NOT is_internal_note`), and projection filtering.
func (s *Service) ListSupportTicketMessagesSafe(ctx context.Context, workspaceID, actorUserID, ticketOwnerUserID, ticketID string) ([]SupportTicketMessageProjection, error) {
	if s == nil || s.Beginner == nil || s.Bindings == nil {
		return nil, tenantdb.ErrNilBeginner
	}
	var out []SupportTicketMessageProjection
	err := tenantdb.WithTx(ctx, s.Beginner, tenantdb.Scope{
		WorkspaceID:             workspaceID,
		UserID:                  actorUserID,
		RequireActiveMembership: true,
	}, func(txCtx context.Context, q *tenantdb.Queries) error {
		sc, _ := tenantdb.ScopeFromContext(txCtx)
		if _, err := s.Bindings.Authorize("SupportService/GetTicket", rbac.PolicyContext{
			ActorUserID:       actorUserID,
			TargetOwnerUserID: ticketOwnerUserID,
			WorkspaceID:       workspaceID,
			Role:              sc.Role,
		}); err != nil {
			return err
		}
		rows, err := q.ListSupportTicketMessages(txCtx, workspaceID, ticketID)
		if err != nil {
			return err
		}
		out = ProjectSupportTicketMessages(rows)
		return nil
	})
	return out, err
}
