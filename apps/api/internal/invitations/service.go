package invitations

import (
	"context"
	"crypto/sha256"
	"crypto/subtle"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"
)

// Options configures the isolated invitation domain Service.
type Options struct {
	Verifier   IdentityVerifier
	Provider   InvitationProvider
	Repository Repository
	Gates      RuntimeGates
	Clock      func() time.Time
	NewID      func(now time.Time) (string, error)
}

// Service enforces workspace invitation issuance, preview, acceptance,
// decline, cancellation, resend, and webhook membership reconciliation.
//
// Any nil or unconfigured dependency causes operations to FAIL CLOSED.
type Service struct {
	verifier IdentityVerifier
	provider InvitationProvider
	repo     Repository
	gates    RuntimeGates
	clock    func() time.Time
	newID    func(now time.Time) (string, error)
}

// NewService constructs a fail-closed invitation domain service.
func NewService(opts Options) *Service {
	clock := opts.Clock
	if clock == nil {
		clock = time.Now
	}
	newID := opts.NewID
	if newID == nil {
		newID = NewUUIDv7
	}
	return &Service{
		verifier: opts.Verifier,
		provider: opts.Provider,
		repo:     opts.Repository,
		gates:    opts.Gates,
		clock:    clock,
		newID:    newID,
	}
}

// CheckProductionReadiness verifies that neither nil/unconfigured adapters nor
// open external/phase gates exist before any transport layer may mount RPCs.
func (s *Service) CheckProductionReadiness() error {
	if s == nil || s.verifier == nil || s.provider == nil || s.repo == nil {
		return fmt.Errorf("%w: verifier, provider, and repository must be non-nil", ErrDependencyUnconfigured)
	}
	if _, ok := s.verifier.(UnconfiguredIdentityVerifier); ok {
		return fmt.Errorf("%w: IdentityVerifier is unconfigured", ErrDependencyUnconfigured)
	}
	if _, ok := s.provider.(UnconfiguredInvitationProvider); ok {
		return fmt.Errorf("%w: InvitationProvider is unconfigured", ErrDependencyUnconfigured)
	}
	if _, ok := s.repo.(UnconfiguredRepository); ok {
		return fmt.Errorf("%w: Repository is unconfigured", ErrDependencyUnconfigured)
	}
	return s.gates.CheckProductionReadiness()
}

// IssueInvitation validates inviter Clerk identity, active workspace membership,
// workspace:members:invite RBAC + strict downward role ceiling, <=7-day TTL, and
// idempotency before creating a Clerk organization invitation and recording
// canonical audit + outbox records.
func (s *Service) IssueInvitation(ctx context.Context, cmd IssueInvitationCommand) (IssueInvitationResult, error) {
	if err := s.checkContextAndDeps(ctx); err != nil {
		return IssueInvitationResult{}, err
	}
	if !validUUID(cmd.WorkspaceID) {
		return IssueInvitationResult{}, newValidationError("workspace_id", "must be a canonical non-nil UUID")
	}
	if err := validateCommandContext(cmd.Command, cmd.WorkspaceID); err != nil {
		return IssueInvitationResult{}, err
	}
	inviteeEmail, ok := normalizeEmail(cmd.Email)
	if !ok {
		return IssueInvitationResult{}, newDomainError(
			ErrInvalidInput,
			ErrCodeAuthInvalid001,
			StatusInvalidArgument,
			"Email không hợp lệ.",
			"Invalid invitee email format.",
		)
	}
	if cmd.Role == RoleOwner {
		return IssueInvitationResult{}, newDomainError(
			ErrRoleElevationDenied,
			ErrCodeSystemForbidden001,
			StatusPermissionDenied,
			"Không thể mời vai trò chủ sở hữu workspace.",
			"Workspace Owner role cannot be granted via invitation.",
		)
	}
	if !ValidInvitableRole(cmd.Role) {
		return IssueInvitationResult{}, newValidationError("role", "must be a canonical non-owner workspace role")
	}
	if cmd.TTL < 0 || cmd.TTL > MaxInvitationAge {
		return IssueInvitationResult{}, newValidationError("ttl", "invitation expiry must be between >0 and 7 days")
	}
	effectiveTTL := cmd.TTL
	if effectiveTTL == 0 {
		effectiveTTL = MaxInvitationAge
	}

	actor, actorEmail, err := s.verifyAuthenticatedActor(ctx, cmd.BearerToken, true)
	if err != nil {
		return IssueInvitationResult{}, err
	}
	if constantTimeEqualStrings(actorEmail, inviteeEmail) {
		return IssueInvitationResult{}, newDomainError(
			ErrSelfInvitationDenied,
			ErrCodeSystemInvalid001,
			StatusInvalidArgument,
			"Không thể tự gửi lời mời cho chính mình.",
			"Inviter cannot invite their own email address.",
		)
	}

	now := s.clock().UTC()
	expiresAt := now.Add(effectiveTTL)
	reqHash := hashStrings("IssueInvitation", cmd.WorkspaceID, inviteeEmail, string(cmd.Role), effectiveTTL.String())

	var (
		workspace    WorkspaceRecord
		inviterUser  UserRecord
		cachedResult *IssueInvitationResult
		idempRecID   string
	)

	err = s.repo.WithinTx(ctx, cmd.WorkspaceID, "", func(tx TxRepository) error {
		ws, found, txErr := tx.GetWorkspaceByID(ctx, cmd.WorkspaceID)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		if !found || !isActiveWorkspace(ws) {
			return notFoundOpaqueError()
		}
		workspace = ws

		u, found, txErr := tx.GetUserByClerkID(ctx, actor.ClerkID)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		if !found {
			return unauthenticatedError()
		}
		if err := ensureActiveUser(u); err != nil {
			return err
		}
		if uEmail, ok := normalizeEmail(u.Email); ok && constantTimeEqualStrings(uEmail, inviteeEmail) {
			return newDomainError(
				ErrSelfInvitationDenied,
				ErrCodeSystemInvalid001,
				StatusInvalidArgument,
				"Không thể tự gửi lời mời cho chính mình.",
				"Inviter cannot invite their own email address.",
			)
		}
		inviterUser = u

		member, found, txErr := tx.GetWorkspaceMember(ctx, workspace.WorkspaceID, inviterUser.UserID)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		if !found || member.Status != MembershipStatusActive {
			// Foreign workspace or revoked member -> opaque NOT_FOUND per api_behavior_contracts.md §5.
			return notFoundOpaqueError()
		}
		if err := enforceInviterAuthority(member.Role, cmd.Role); err != nil {
			return err
		}

		existingIdemp, hasIdemp, txErr := tx.GetIdempotencyRecord(ctx, workspace.WorkspaceID, inviterUser.UserID, RPCInviteMember, cmd.Command.IdempotencyKey, now)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		if hasIdemp {
			if !constantTimeEqualStrings(existingIdemp.RequestHash, reqHash) {
				return idempotencyConflictError()
			}
			switch existingIdemp.Status {
			case IdempotencyStatusCompleted:
				var out IssueInvitationResult
				if uErr := json.Unmarshal(existingIdemp.ResponsePayload, &out); uErr != nil {
					return internalError(uErr)
				}
				out.Replayed = true
				cachedResult = &out
				return nil
			case IdempotencyStatusProcessing:
				return idempotencyInProgressError()
			}
			idempRecID = existingIdemp.RecordID
		}

		if _, alreadyActive, txErr := tx.GetActiveMemberByEmail(ctx, workspace.WorkspaceID, inviteeEmail); txErr != nil {
			return wrapRepoError(txErr)
		} else if alreadyActive {
			return newDomainError(
				ErrAlreadyActiveMember,
				ErrCodeAuthConflict001,
				StatusAlreadyExists,
				"Email này đã là thành viên đang hoạt động của workspace.",
				"User with this email is already an active member of the workspace.",
			)
		}

		if idempRecID == "" {
			var idErr error
			idempRecID, idErr = s.newID(now)
			if idErr != nil {
				return internalError(idErr)
			}
		}
		return wrapRepoError(tx.SaveIdempotencyRecord(ctx, IdempotencyRecord{
			RecordID:       idempRecID,
			WorkspaceID:    workspace.WorkspaceID,
			ActorID:        inviterUser.UserID,
			RPC:            RPCInviteMember,
			IdempotencyKey: cmd.Command.IdempotencyKey,
			RequestHash:    reqHash,
			Status:         IdempotencyStatusProcessing,
			ExpiresAt:      now.Add(MinIdempotencyTTL),
			CreatedAt:      now,
		}))
	})
	if err != nil {
		return IssueInvitationResult{}, err
	}
	if cachedResult != nil {
		return *cachedResult, nil
	}
	if err := checkContext(ctx); err != nil {
		s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, inviterUser.UserID, RPCInviteMember, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
		return IssueInvitationResult{}, err
	}

	providerInv, provErr := s.provider.CreateInvitation(ctx, CreateProviderInvitationInput{
		ClerkOrganizationID: workspace.ClerkOrganizationID,
		WorkspaceID:         workspace.WorkspaceID,
		InviteeEmail:        inviteeEmail,
		Role:                cmd.Role,
		InviterUserID:       inviterUser.UserID,
		ExpiresAt:           expiresAt,
		IdempotencyKey:      cmd.Command.IdempotencyKey,
	})
	if provErr != nil {
		s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, inviterUser.UserID, RPCInviteMember, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
		return IssueInvitationResult{}, mapProviderCallError(ctx, provErr)
	}
	if err := checkContext(ctx); err != nil {
		return IssueInvitationResult{}, err
	}
	if providerInv.ProviderInvitationID == "" ||
		providerInv.ClerkOrganizationID != workspace.ClerkOrganizationID ||
		(providerInv.WorkspaceID != "" && providerInv.WorkspaceID != workspace.WorkspaceID) ||
		providerInv.Role != cmd.Role {
		s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, inviterUser.UserID, RPCInviteMember, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
		return IssueInvitationResult{}, internalError(errors.New("provider returned mismatched invitation metadata"))
	}

	effectiveExp := providerInv.EffectiveExpiry()
	if providerInv.CreatedAt.IsZero() {
		effectiveExp = expiresAt
	} else if effectiveExp.After(now.Add(MaxInvitationAge)) {
		effectiveExp = now.Add(MaxInvitationAge)
	}

	var finalResult IssueInvitationResult
	err = s.repo.WithinTx(ctx, workspace.WorkspaceID, inviterUser.UserID, func(tx TxRepository) error {
		ws, found, txErr := tx.GetWorkspaceByID(ctx, workspace.WorkspaceID)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		if !found || !isActiveWorkspace(ws) || ws.ClerkOrganizationID != workspace.ClerkOrganizationID {
			return notFoundOpaqueError()
		}
		member, found, txErr := tx.GetWorkspaceMember(ctx, workspace.WorkspaceID, inviterUser.UserID)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		if !found || member.Status != MembershipStatusActive {
			return notFoundOpaqueError()
		}
		if err := enforceInviterAuthority(member.Role, cmd.Role); err != nil {
			return err
		}

		auditID, idErr := s.newID(now)
		if idErr != nil {
			return internalError(idErr)
		}
		eventID, idErr := s.newID(now)
		if idErr != nil {
			return internalError(idErr)
		}
		corrID, idErr := s.resolveCorrelationID(cmd.Command.CorrelationID, now)
		if idErr != nil {
			return internalError(idErr)
		}

		if txErr := tx.AppendAuditEvent(ctx, AuditEventRecord{
			AuditEventID: auditID,
			WorkspaceID:  workspace.WorkspaceID,
			ActorUserID:  inviterUser.UserID,
			ActorType:    "user",
			Action:       "workspace.member.invited",
			ResourceType: "workspace",
			ResourceID:   workspace.WorkspaceID,
			Changes: map[string]any{
				"provider_invitation_id": providerInv.ProviderInvitationID,
				"invitee_email":          inviteeEmail,
				"role":                   string(cmd.Role),
				"expires_at":             effectiveExp.Format(time.RFC3339),
			},
			Reason:    cmd.Command.Reason,
			CreatedAt: now,
		}); txErr != nil {
			return wrapRepoError(txErr)
		}

		payloadBytes, mErr := json.Marshal(WorkspaceMemberInvitedPayload{
			WorkspaceID:  workspace.WorkspaceID,
			InviteeEmail: inviteeEmail,
			InvitedBy:    inviterUser.UserID,
			Role:         cmd.Role,
		})
		if mErr != nil {
			return internalError(mErr)
		}
		if txErr := tx.AppendOutboxEvent(ctx, DomainEventRecord{
			EventID:       eventID,
			EventType:     EventWorkspaceMemberInvited,
			AggregateType: "workspace",
			AggregateID:   workspace.WorkspaceID,
			WorkspaceID:   workspace.WorkspaceID,
			ActorID:       inviterUser.UserID,
			ActorType:     "user",
			Payload:       payloadBytes,
			CorrelationID: corrID,
			OccurredAt:    now,
			Version:       1,
		}); txErr != nil {
			return wrapRepoError(txErr)
		}

		finalResult = IssueInvitationResult{
			ProviderInvitationID: providerInv.ProviderInvitationID,
			WorkspaceID:          workspace.WorkspaceID,
			InviteeEmail:         inviteeEmail,
			Role:                 cmd.Role,
			InvitedBy:            inviterUser.UserID,
			ExpiresAt:            effectiveExp,
			AuditEventID:         auditID,
			Replayed:             false,
		}
		respBytes, mErr := json.Marshal(finalResult)
		if mErr != nil {
			return internalError(mErr)
		}
		return wrapRepoError(tx.SaveIdempotencyRecord(ctx, IdempotencyRecord{
			RecordID:        idempRecID,
			WorkspaceID:     workspace.WorkspaceID,
			ActorID:         inviterUser.UserID,
			RPC:             RPCInviteMember,
			IdempotencyKey:  cmd.Command.IdempotencyKey,
			RequestHash:     reqHash,
			Status:          IdempotencyStatusCompleted,
			ResponsePayload: respBytes,
			ResponseCode:    200,
			ExpiresAt:       now.Add(MinIdempotencyTTL),
			CreatedAt:       now,
		}))
	})
	if err != nil {
		return IssueInvitationResult{}, err
	}
	return finalResult, nil
}

// PreviewInvitation validates an invitation token, enforces the 7-day age ceiling,
// cross-tenant isolation, and inviter RBAC authority, and reports whether the
// visitor must complete new-user registration/email verification or can accept
// directly as an existing verified Clerk user (auth.md §Invite Acceptance, AC-5).
func (s *Service) PreviewInvitation(ctx context.Context, query PreviewInvitationQuery) (InvitationPreview, error) {
	if err := s.checkContextAndDeps(ctx); err != nil {
		return InvitationPreview{}, err
	}
	if !validOpaqueToken(query.InvitationToken, 16, 2048) {
		return InvitationPreview{}, invalidTokenError()
	}
	if query.ExpectedWorkspaceID != "" && !validUUID(query.ExpectedWorkspaceID) {
		return InvitationPreview{}, newValidationError("expected_workspace_id", "must be a canonical non-nil UUID")
	}

	inv, err := s.provider.ResolveInvitationToken(ctx, query.InvitationToken)
	if err != nil {
		return InvitationPreview{}, mapTokenResolveError(ctx, err)
	}
	if err := checkContext(ctx); err != nil {
		return InvitationPreview{}, err
	}

	now := s.clock().UTC()
	invEmail, err := validateResolvedInvitationShape(inv, query.ExpectedWorkspaceID, now)
	if err != nil {
		return InvitationPreview{}, err
	}
	if err := validateInvitationStateForPreviewOrDecline(inv, now); err != nil {
		return InvitationPreview{}, err
	}

	var (
		actor      VerifiedClerkActor
		actorEmail string
		hasActor   bool
	)
	if strings.TrimSpace(query.BearerToken) != "" {
		actor, actorEmail, err = s.verifyAuthenticatedActor(ctx, query.BearerToken, false)
		if err != nil {
			return InvitationPreview{}, err
		}
		if !constantTimeEqualStrings(actorEmail, invEmail) {
			return InvitationPreview{}, inviteeEmailMismatchError()
		}
		hasActor = true
	}

	var preview InvitationPreview
	err = s.repo.WithinTx(ctx, inv.WorkspaceID, "", func(tx TxRepository) error {
		ws, err := verifyWorkspaceAndInviterInTx(ctx, tx, inv)
		if err != nil {
			return err
		}
		flow := IdentityFlowRegistrationOrVerificationRequired
		emailVerifyReq := true
		onboardingReq := true

		if hasActor {
			existingUser, found, txErr := tx.GetUserByClerkID(ctx, actor.ClerkID)
			if txErr != nil {
				return wrapRepoError(txErr)
			}
			if found {
				if existingUser.Status == UserStatusSuspended || existingUser.Status == UserStatusDeleted {
					return accountSuspendedOrDeletedError()
				}
			}
			if !actor.EmailVerified {
				flow = IdentityFlowRegistrationOrVerificationRequired
				emailVerifyReq = true
				onboardingReq = true
			} else if found && existingUser.Status == UserStatusActive {
				flow = IdentityFlowExistingUser
				emailVerifyReq = false
				onboardingReq = false
			} else {
				flow = IdentityFlowNewUser
				emailVerifyReq = false
				onboardingReq = true
			}
		}

		preview = InvitationPreview{
			ProviderInvitationID:      inv.ProviderInvitationID,
			WorkspaceID:               ws.WorkspaceID,
			WorkspaceDisplayName:      ws.DisplayName,
			Role:                      inv.Role,
			ExpiresAt:                 inv.EffectiveExpiry(),
			IdentityFlow:              flow,
			EmailVerificationRequired: emailVerifyReq,
			OnboardingRequired:        onboardingReq,
		}
		return nil
	})
	if err != nil {
		return InvitationPreview{}, err
	}
	return preview, nil
}

// AcceptInvitation synchronizes verified Clerk user identity and workspace
// membership upon invitation acceptance, enforcing:
//   - Verified Clerk session + verified email matching invitation target (RULE-AUTH-001, AC-5)
//   - Strict cross-tenant workspace_id + clerk_organization_id matching
//   - Server-reverified inviter active membership & downward role ceiling (no client role trust)
//   - No role self-elevation or overwrite for already-active members
//   - 7-day maximum invitation age or shorter provider expiry (RULE-AUTH-005, EC-AUTH-004)
//   - Invalid / revoked / declined / expired link fail-closed rejection
//   - Request-level (api_idempotency_records) and domain-level idempotent acceptance
//   - New-vs-existing Clerk identity flow with synchronous user upsert before redirect
func (s *Service) AcceptInvitation(ctx context.Context, cmd AcceptInvitationCommand) (AcceptInvitationResult, error) {
	if err := s.checkContextAndDeps(ctx); err != nil {
		return AcceptInvitationResult{}, err
	}
	if !validOpaqueToken(cmd.InvitationToken, 16, 2048) {
		return AcceptInvitationResult{}, invalidTokenError()
	}
	if !validIdempotencyKey(cmd.Command.IdempotencyKey) {
		return AcceptInvitationResult{}, newValidationError("idempotency_key", "must be 1-255 printable characters")
	}
	if cmd.Command.WorkspaceID != "" && !validUUID(cmd.Command.WorkspaceID) {
		return AcceptInvitationResult{}, newValidationError("workspace_id", "must be a canonical non-nil UUID")
	}
	if len(cmd.Command.Reason) > 2000 {
		return AcceptInvitationResult{}, newValidationError("reason", "must not exceed 2000 characters")
	}

	actor, actorEmail, err := s.verifyAuthenticatedActor(ctx, cmd.BearerToken, true)
	if err != nil {
		return AcceptInvitationResult{}, err
	}

	inv, err := s.provider.ResolveInvitationToken(ctx, cmd.InvitationToken)
	if err != nil {
		return AcceptInvitationResult{}, mapTokenResolveError(ctx, err)
	}
	if err := checkContext(ctx); err != nil {
		return AcceptInvitationResult{}, err
	}

	now := s.clock().UTC()
	invEmail, err := validateResolvedInvitationShape(inv, cmd.Command.WorkspaceID, now)
	if err != nil {
		return AcceptInvitationResult{}, err
	}
	if !constantTimeEqualStrings(actorEmail, invEmail) {
		return AcceptInvitationResult{}, inviteeEmailMismatchError()
	}

	reqHash := hashStrings("AcceptInvitation", cmd.InvitationToken, cmd.Command.WorkspaceID)

	var (
		workspace       WorkspaceRecord
		replayedResult  *AcceptInvitationResult
		needsProviderOK bool
		idempActorID    string
		idempRecID      string
	)

	err = s.repo.WithinTx(ctx, inv.WorkspaceID, "", func(tx TxRepository) error {
		ws, err := verifyWorkspaceAndInviterInTx(ctx, tx, inv)
		if err != nil {
			return err
		}
		workspace = ws

		existingUser, userFound, txErr := tx.GetUserByClerkID(ctx, actor.ClerkID)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		if userFound {
			if existingUser.Status == UserStatusSuspended || existingUser.Status == UserStatusDeleted {
				return accountSuspendedOrDeletedError()
			}
			if inv.InviterUserID == existingUser.UserID {
				return newDomainError(
					ErrRoleElevationDenied,
					ErrCodeSystemForbidden001,
					StatusPermissionDenied,
					"Người gửi lời mời không thể tự chấp nhận lời mời của chính mình.",
					"Inviter cannot accept their own workspace invitation.",
				)
			}
			idempActorID = existingUser.UserID
		} else {
			idempActorID = deterministicClerkActorUUID(actor.ClerkID)
		}

		// Check request-level idempotency (both canonical user_id and deterministic pre-user ID).
		for _, candidateActorID := range uniqueNonEmpty(idempActorID, deterministicClerkActorUUID(actor.ClerkID)) {
			existingIdemp, hasIdemp, txErr := tx.GetIdempotencyRecord(ctx, workspace.WorkspaceID, candidateActorID, RPCAcceptInvite, cmd.Command.IdempotencyKey, now)
			if txErr != nil {
				return wrapRepoError(txErr)
			}
			if !hasIdemp {
				continue
			}
			if !constantTimeEqualStrings(existingIdemp.RequestHash, reqHash) {
				return idempotencyConflictError()
			}
			switch existingIdemp.Status {
			case IdempotencyStatusCompleted:
				var out AcceptInvitationResult
				if uErr := json.Unmarshal(existingIdemp.ResponsePayload, &out); uErr != nil {
					return internalError(uErr)
				}
				out.Replayed = true
				replayedResult = &out
				return nil
			case IdempotencyStatusProcessing:
				return idempotencyInProgressError()
			}
			idempActorID = candidateActorID
			idempRecID = existingIdemp.RecordID
		}

		// Check existing local membership before validating pending/accepted provider state
		// so domain-idempotent retries succeed cleanly while role self-elevation is blocked.
		if userFound {
			existingMember, hasMember, txErr := tx.GetWorkspaceMember(ctx, workspace.WorkspaceID, existingUser.UserID)
			if txErr != nil {
				return wrapRepoError(txErr)
			}
			if hasMember && existingMember.Status == MembershipStatusActive {
				if existingMember.Role != inv.Role {
					return newDomainError(
						ErrRoleElevationDenied,
						ErrCodeSystemForbidden001,
						StatusPermissionDenied,
						"Thành viên hiện tại không thể thay đổi hoặc nâng quyền qua liên kết lời mời.",
						"Existing active workspace members cannot change or elevate their role via an invitation link.",
					)
				}
				switch inv.Status {
				case ProviderInvitationRevoked:
					return revokedInviteError()
				case ProviderInvitationDeclined:
					return declinedInviteError()
				case ProviderInvitationExpired:
					return expiredInviteError(string(inv.Status))
				case ProviderInvitationPending:
					if !now.Before(inv.EffectiveExpiry()) {
						return expiredInviteError(string(inv.Status))
					}
				case ProviderInvitationAccepted:
					if inv.AcceptedByClerkID != "" && inv.AcceptedByClerkID != actor.ClerkID {
						return inviteeEmailMismatchError()
					}
				default:
					return internalError(fmt.Errorf("unknown provider invitation status %q", inv.Status))
				}

				flow := IdentityFlowExistingUser
				out := AcceptInvitationResult{
					Member:             existingMember,
					User:               existingUser,
					IdentityFlow:       flow,
					UserProvisionedNow: false,
					OnboardingRequired: false,
					Replayed:           true,
				}
				if idempRecID == "" {
					var idErr error
					idempRecID, idErr = s.newID(now)
					if idErr != nil {
						return internalError(idErr)
					}
				}
				respBytes, mErr := json.Marshal(out)
				if mErr != nil {
					return internalError(mErr)
				}
				if sErr := tx.SaveIdempotencyRecord(ctx, IdempotencyRecord{
					RecordID:        idempRecID,
					WorkspaceID:     workspace.WorkspaceID,
					ActorID:         existingUser.UserID,
					RPC:             RPCAcceptInvite,
					IdempotencyKey:  cmd.Command.IdempotencyKey,
					RequestHash:     reqHash,
					Status:          IdempotencyStatusCompleted,
					ResponsePayload: respBytes,
					ResponseCode:    200,
					ExpiresAt:       now.Add(MinIdempotencyTTL),
					CreatedAt:       now,
				}); sErr != nil {
					return wrapRepoError(sErr)
				}
				replayedResult = &out
				return nil
			}
		}

		// Invitee does not yet hold active local membership -> validate invitation status & 7d expiry.
		switch inv.Status {
		case ProviderInvitationRevoked:
			return revokedInviteError()
		case ProviderInvitationDeclined:
			return declinedInviteError()
		case ProviderInvitationExpired:
			return expiredInviteError(string(inv.Status))
		case ProviderInvitationAccepted:
			if inv.AcceptedByClerkID != "" && inv.AcceptedByClerkID != actor.ClerkID {
				return inviteeEmailMismatchError()
			}
			if !now.Before(inv.EffectiveExpiry()) {
				return expiredInviteError(string(inv.Status))
			}
			needsProviderOK = false
		case ProviderInvitationPending:
			if !now.Before(inv.EffectiveExpiry()) {
				return expiredInviteError(string(inv.Status))
			}
			needsProviderOK = true
		default:
			return internalError(fmt.Errorf("unknown provider invitation status %q", inv.Status))
		}

		if idempRecID == "" {
			var idErr error
			idempRecID, idErr = s.newID(now)
			if idErr != nil {
				return internalError(idErr)
			}
		}
		return wrapRepoError(tx.SaveIdempotencyRecord(ctx, IdempotencyRecord{
			RecordID:       idempRecID,
			WorkspaceID:    workspace.WorkspaceID,
			ActorID:        idempActorID,
			RPC:            RPCAcceptInvite,
			IdempotencyKey: cmd.Command.IdempotencyKey,
			RequestHash:    reqHash,
			Status:         IdempotencyStatusProcessing,
			ExpiresAt:      now.Add(MinIdempotencyTTL),
			CreatedAt:      now,
		}))
	})
	if err != nil {
		return AcceptInvitationResult{}, err
	}
	if replayedResult != nil {
		return *replayedResult, nil
	}
	if err := checkContext(ctx); err != nil {
		s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, idempActorID, RPCAcceptInvite, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
		return AcceptInvitationResult{}, err
	}

	acceptedInv := inv
	if needsProviderOK {
		acceptedInv, err = s.provider.MarkInvitationAccepted(ctx, AcceptProviderInvitationInput{
			InvitationToken:     cmd.InvitationToken,
			ClerkOrganizationID: workspace.ClerkOrganizationID,
			ClerkUserID:         actor.ClerkID,
			VerifiedEmail:       actorEmail,
		})
		if err != nil {
			s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, idempActorID, RPCAcceptInvite, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
			return AcceptInvitationResult{}, mapProviderAcceptError(ctx, err)
		}
		if err := checkContext(ctx); err != nil {
			return AcceptInvitationResult{}, err
		}
		if acceptedInv.ClerkOrganizationID != workspace.ClerkOrganizationID ||
			(acceptedInv.WorkspaceID != "" && acceptedInv.WorkspaceID != workspace.WorkspaceID) ||
			acceptedInv.Role != inv.Role ||
			acceptedInv.Status != ProviderInvitationAccepted {
			s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, idempActorID, RPCAcceptInvite, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
			return AcceptInvitationResult{}, internalError(errors.New("provider returned inconsistent accepted invitation state"))
		}
	}

	var finalResult AcceptInvitationResult
	err = s.repo.WithinTx(ctx, workspace.WorkspaceID, "", func(tx TxRepository) error {
		ws, err := verifyWorkspaceAndInviterInTx(ctx, tx, inv)
		if err != nil {
			return err
		}

		// Synchronously upsert verified Clerk user (auth.md line 67 & AC-1:
		// user.created webhook is reconciliation and must not block onboarding/join).
		existingUser, userExisted, txErr := tx.GetUserByClerkID(ctx, actor.ClerkID)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		wasPendingVerification := userExisted && existingUser.Status == UserStatusPendingVerification
		if userExisted && (existingUser.Status == UserStatusSuspended || existingUser.Status == UserStatusDeleted) {
			return accountSuspendedOrDeletedError()
		}

		userID := existingUser.UserID
		if !userExisted {
			var idErr error
			userID, idErr = s.newID(now)
			if idErr != nil {
				return internalError(idErr)
			}
		}
		if inv.InviterUserID == userID {
			return newDomainError(
				ErrRoleElevationDenied,
				ErrCodeSystemForbidden001,
				StatusPermissionDenied,
				"Người gửi lời mời không thể tự chấp nhận lời mời của chính mình.",
				"Inviter cannot accept their own workspace invitation.",
			)
		}

		sourceTS := actor.SourceUpdatedAt.UTC()
		if sourceTS.IsZero() {
			sourceTS = now
		}
		candidateUser := UserRecord{
			UserID:          userID,
			ClerkID:         actor.ClerkID,
			SourceUpdatedAt: &sourceTS,
			Email:           actorEmail,
			DisplayName:     actor.DisplayName,
			AvatarURL:       actor.AvatarURL,
			Status:          UserStatusActive,
			LastLoginAt:     &now,
			CreatedAt:       now,
			UpdatedAt:       now,
		}
		if userExisted {
			candidateUser.CreatedAt = existingUser.CreatedAt
			candidateUser.Locale = existingUser.Locale
			candidateUser.Timezone = existingUser.Timezone
			if existingUser.DisplayName != "" && candidateUser.DisplayName == "" {
				candidateUser.DisplayName = existingUser.DisplayName
			}
			if existingUser.AvatarURL != "" && candidateUser.AvatarURL == "" {
				candidateUser.AvatarURL = existingUser.AvatarURL
			}
			if existingUser.SourceUpdatedAt != nil && existingUser.SourceUpdatedAt.After(sourceTS) {
				candidateUser.SourceUpdatedAt = existingUser.SourceUpdatedAt
				candidateUser.Email = existingUser.Email
				candidateUser.DisplayName = existingUser.DisplayName
				candidateUser.AvatarURL = existingUser.AvatarURL
			}
		}

		syncedUser, createdNow, txErr := tx.UpsertVerifiedUser(ctx, candidateUser)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		isNewIdentityFlow := createdNow || !userExisted || wasPendingVerification
		flow := IdentityFlowExistingUser
		if isNewIdentityFlow {
			flow = IdentityFlowNewUser
		}

		corrID, idErr := s.resolveCorrelationID(cmd.Command.CorrelationID, now)
		if idErr != nil {
			return internalError(idErr)
		}

		if createdNow || wasPendingVerification {
			regMethod := strings.TrimSpace(actor.RegistrationMethod)
			if regMethod == "" {
				regMethod = "clerk_invite"
			}
			regPayload, mErr := json.Marshal(UserRegisteredPayload{
				UserID:             syncedUser.UserID,
				Email:              syncedUser.Email,
				RegistrationMethod: regMethod,
			})
			if mErr != nil {
				return internalError(mErr)
			}
			regEventID, idErr := s.newID(now)
			if idErr != nil {
				return internalError(idErr)
			}
			if txErr := tx.AppendOutboxEvent(ctx, DomainEventRecord{
				EventID:       regEventID,
				EventType:     EventUserRegistered,
				AggregateType: "user",
				AggregateID:   syncedUser.UserID,
				WorkspaceID:   ws.WorkspaceID,
				ActorID:       syncedUser.UserID,
				ActorType:     "user",
				Payload:       regPayload,
				CorrelationID: corrID,
				OccurredAt:    now,
				Version:       1,
			}); txErr != nil {
				return wrapRepoError(txErr)
			}
		}

		existingMember, hasMember, txErr := tx.GetWorkspaceMember(ctx, ws.WorkspaceID, syncedUser.UserID)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		if hasMember && existingMember.Status == MembershipStatusActive {
			if existingMember.Role != inv.Role {
				return newDomainError(
					ErrRoleElevationDenied,
					ErrCodeSystemForbidden001,
					StatusPermissionDenied,
					"Thành viên hiện tại không thể thay đổi hoặc nâng quyền qua liên kết lời mời.",
					"Existing active workspace members cannot change or elevate their role via an invitation link.",
				)
			}
			finalResult = AcceptInvitationResult{
				Member:             existingMember,
				User:               syncedUser,
				IdentityFlow:       IdentityFlowExistingUser,
				UserProvisionedNow: false,
				OnboardingRequired: false,
				Replayed:           true,
			}
		} else {
			memberID := existingMember.WorkspaceMemberID
			createdAt := now
			if hasMember && memberID != "" {
				createdAt = existingMember.CreatedAt
			} else {
				memberID, idErr = s.newID(now)
				if idErr != nil {
					return internalError(idErr)
				}
			}
			invSourceTS := acceptedInv.SourceUpdatedAt.UTC()
			if invSourceTS.IsZero() {
				invSourceTS = now
			}
			upsertedMember, txErr := tx.UpsertWorkspaceMember(ctx, WorkspaceMemberRecord{
				WorkspaceMemberID: memberID,
				ClerkMembershipID: acceptedInv.ClerkMembershipID,
				SourceUpdatedAt:   &invSourceTS,
				WorkspaceID:       ws.WorkspaceID,
				UserID:            syncedUser.UserID,
				Role:              inv.Role,
				Status:            MembershipStatusActive,
				InvitedBy:         inv.InviterUserID,
				JoinedAt:          now,
				CreatedAt:         createdAt,
				UpdatedAt:         now,
			})
			if txErr != nil {
				return wrapRepoError(txErr)
			}

			auditID, idErr := s.newID(now)
			if idErr != nil {
				return internalError(idErr)
			}
			if txErr := tx.AppendAuditEvent(ctx, AuditEventRecord{
				AuditEventID: auditID,
				WorkspaceID:  ws.WorkspaceID,
				ActorUserID:  syncedUser.UserID,
				ActorType:    "user",
				Action:       "workspace.invitation.accepted",
				ResourceType: "workspace_member",
				ResourceID:   upsertedMember.WorkspaceMemberID,
				Changes: map[string]any{
					"provider_invitation_id": inv.ProviderInvitationID,
					"role":                   string(inv.Role),
					"invited_by":             inv.InviterUserID,
					"identity_flow":          string(flow),
				},
				Reason:    cmd.Command.Reason,
				CreatedAt: now,
			}); txErr != nil {
				return wrapRepoError(txErr)
			}

			finalResult = AcceptInvitationResult{
				Member:             upsertedMember,
				User:               syncedUser,
				IdentityFlow:       flow,
				UserProvisionedNow: createdNow || wasPendingVerification,
				OnboardingRequired: isNewIdentityFlow,
				AuditEventID:       auditID,
				Replayed:           false,
			}
		}

		respBytes, mErr := json.Marshal(finalResult)
		if mErr != nil {
			return internalError(mErr)
		}
		if err := tx.SaveIdempotencyRecord(ctx, IdempotencyRecord{
			RecordID:        idempRecID,
			WorkspaceID:     ws.WorkspaceID,
			ActorID:         idempActorID,
			RPC:             RPCAcceptInvite,
			IdempotencyKey:  cmd.Command.IdempotencyKey,
			RequestHash:     reqHash,
			Status:          IdempotencyStatusCompleted,
			ResponsePayload: respBytes,
			ResponseCode:    200,
			ExpiresAt:       now.Add(MinIdempotencyTTL),
			CreatedAt:       now,
		}); err != nil {
			return wrapRepoError(err)
		}
		if syncedUser.UserID != idempActorID {
			mirrorID, idErr := s.newID(now)
			if idErr != nil {
				return internalError(idErr)
			}
			if err := tx.SaveIdempotencyRecord(ctx, IdempotencyRecord{
				RecordID:        mirrorID,
				WorkspaceID:     ws.WorkspaceID,
				ActorID:         syncedUser.UserID,
				RPC:             RPCAcceptInvite,
				IdempotencyKey:  cmd.Command.IdempotencyKey,
				RequestHash:     reqHash,
				Status:          IdempotencyStatusCompleted,
				ResponsePayload: respBytes,
				ResponseCode:    200,
				ExpiresAt:       now.Add(MinIdempotencyTTL),
				CreatedAt:       now,
			}); err != nil {
				return wrapRepoError(err)
			}
		}
		return nil
	})
	if err != nil {
		s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, idempActorID, RPCAcceptInvite, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
		return AcceptInvitationResult{}, err
	}
	return finalResult, nil
}

// DeclineInvitation allows the invited verified Clerk user (matching recipient
// email) to decline a pending non-expired invitation idempotently without
// creating any workspace_members record.
func (s *Service) DeclineInvitation(ctx context.Context, cmd DeclineInvitationCommand) (DeclineInvitationResult, error) {
	if err := s.checkContextAndDeps(ctx); err != nil {
		return DeclineInvitationResult{}, err
	}
	if !validOpaqueToken(cmd.InvitationToken, 16, 2048) {
		return DeclineInvitationResult{}, invalidTokenError()
	}
	if !validIdempotencyKey(cmd.Command.IdempotencyKey) {
		return DeclineInvitationResult{}, newValidationError("idempotency_key", "must be 1-255 printable characters")
	}
	if cmd.Command.WorkspaceID != "" && !validUUID(cmd.Command.WorkspaceID) {
		return DeclineInvitationResult{}, newValidationError("workspace_id", "must be a canonical non-nil UUID")
	}

	actor, actorEmail, err := s.verifyAuthenticatedActor(ctx, cmd.BearerToken, true)
	if err != nil {
		return DeclineInvitationResult{}, err
	}

	inv, err := s.provider.ResolveInvitationToken(ctx, cmd.InvitationToken)
	if err != nil {
		return DeclineInvitationResult{}, mapTokenResolveError(ctx, err)
	}
	if err := checkContext(ctx); err != nil {
		return DeclineInvitationResult{}, err
	}

	now := s.clock().UTC()
	invEmail, err := validateResolvedInvitationShape(inv, cmd.Command.WorkspaceID, now)
	if err != nil {
		return DeclineInvitationResult{}, err
	}
	if !constantTimeEqualStrings(actorEmail, invEmail) {
		return DeclineInvitationResult{}, inviteeEmailMismatchError()
	}

	reqHash := hashStrings("DeclineInvitation", cmd.InvitationToken, cmd.Command.WorkspaceID)
	actorID := deterministicClerkActorUUID(actor.ClerkID)

	var (
		workspace    WorkspaceRecord
		cachedResult *DeclineInvitationResult
		idempRecID   string
		auditActorID string
	)

	err = s.repo.WithinTx(ctx, inv.WorkspaceID, "", func(tx TxRepository) error {
		ws, err := verifyWorkspaceAndInviterInTx(ctx, tx, inv)
		if err != nil {
			return err
		}
		workspace = ws

		if u, found, txErr := tx.GetUserByClerkID(ctx, actor.ClerkID); txErr != nil {
			return wrapRepoError(txErr)
		} else if found {
			if u.Status == UserStatusSuspended || u.Status == UserStatusDeleted {
				return accountSuspendedOrDeletedError()
			}
			auditActorID = u.UserID
		}

		existingIdemp, hasIdemp, txErr := tx.GetIdempotencyRecord(ctx, ws.WorkspaceID, actorID, RPCDeclineInvite, cmd.Command.IdempotencyKey, now)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		if hasIdemp {
			if !constantTimeEqualStrings(existingIdemp.RequestHash, reqHash) {
				return idempotencyConflictError()
			}
			if existingIdemp.Status == IdempotencyStatusCompleted {
				var out DeclineInvitationResult
				if uErr := json.Unmarshal(existingIdemp.ResponsePayload, &out); uErr != nil {
					return internalError(uErr)
				}
				out.Replayed = true
				cachedResult = &out
				return nil
			}
			if existingIdemp.Status == IdempotencyStatusProcessing {
				return idempotencyInProgressError()
			}
			idempRecID = existingIdemp.RecordID
		}

		if inv.Status == ProviderInvitationDeclined {
			out := DeclineInvitationResult{
				ProviderInvitationID: inv.ProviderInvitationID,
				WorkspaceID:          ws.WorkspaceID,
				Status:               string(ProviderInvitationDeclined),
				Replayed:             true,
			}
			cachedResult = &out
			return nil
		}
		if err := validateInvitationStateForPreviewOrDecline(inv, now); err != nil {
			return err
		}

		if idempRecID == "" {
			var idErr error
			idempRecID, idErr = s.newID(now)
			if idErr != nil {
				return internalError(idErr)
			}
		}
		return wrapRepoError(tx.SaveIdempotencyRecord(ctx, IdempotencyRecord{
			RecordID:       idempRecID,
			WorkspaceID:    ws.WorkspaceID,
			ActorID:        actorID,
			RPC:            RPCDeclineInvite,
			IdempotencyKey: cmd.Command.IdempotencyKey,
			RequestHash:    reqHash,
			Status:         IdempotencyStatusProcessing,
			ExpiresAt:      now.Add(MinIdempotencyTTL),
			CreatedAt:      now,
		}))
	})
	if err != nil {
		return DeclineInvitationResult{}, err
	}
	if cachedResult != nil {
		return *cachedResult, nil
	}

	if _, err := s.provider.MarkInvitationDeclined(ctx, workspace.ClerkOrganizationID, inv.ProviderInvitationID, actor.ClerkID); err != nil {
		s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, actorID, RPCDeclineInvite, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
		return DeclineInvitationResult{}, mapProviderCallError(ctx, err)
	}

	var out DeclineInvitationResult
	err = s.repo.WithinTx(ctx, workspace.WorkspaceID, auditActorID, func(tx TxRepository) error {
		auditID, idErr := s.newID(now)
		if idErr != nil {
			return internalError(idErr)
		}
		if txErr := tx.AppendAuditEvent(ctx, AuditEventRecord{
			AuditEventID: auditID,
			WorkspaceID:  workspace.WorkspaceID,
			ActorUserID:  auditActorID,
			ActorType:    "user",
			Action:       "workspace.invitation.declined",
			ResourceType: "workspace",
			ResourceID:   workspace.WorkspaceID,
			Changes: map[string]any{
				"provider_invitation_id": inv.ProviderInvitationID,
			},
			Reason:    cmd.Command.Reason,
			CreatedAt: now,
		}); txErr != nil {
			return wrapRepoError(txErr)
		}
		out = DeclineInvitationResult{
			ProviderInvitationID: inv.ProviderInvitationID,
			WorkspaceID:          workspace.WorkspaceID,
			Status:               string(ProviderInvitationDeclined),
			AuditEventID:         auditID,
			Replayed:             false,
		}
		respBytes, mErr := json.Marshal(out)
		if mErr != nil {
			return internalError(mErr)
		}
		return wrapRepoError(tx.SaveIdempotencyRecord(ctx, IdempotencyRecord{
			RecordID:        idempRecID,
			WorkspaceID:     workspace.WorkspaceID,
			ActorID:         actorID,
			RPC:             RPCDeclineInvite,
			IdempotencyKey:  cmd.Command.IdempotencyKey,
			RequestHash:     reqHash,
			Status:          IdempotencyStatusCompleted,
			ResponsePayload: respBytes,
			ResponseCode:    200,
			ExpiresAt:       now.Add(MinIdempotencyTTL),
			CreatedAt:       now,
		}))
	})
	if err != nil {
		return DeclineInvitationResult{}, err
	}
	return out, nil
}

// RevokeInvitation cancels a pending invitation under workspace:settings:manage
// (Owner/Admin) with strict tenant and role-ceiling isolation.
func (s *Service) RevokeInvitation(ctx context.Context, cmd RevokeInvitationCommand) (RevokeInvitationResult, error) {
	if err := s.checkContextAndDeps(ctx); err != nil {
		return RevokeInvitationResult{}, err
	}
	if !validUUID(cmd.WorkspaceID) {
		return RevokeInvitationResult{}, newValidationError("workspace_id", "must be a canonical non-nil UUID")
	}
	if !validOpaqueToken(cmd.ProviderInvitationID, 3, 255) {
		return RevokeInvitationResult{}, newValidationError("provider_invitation_id", "must be a valid provider invitation identifier")
	}
	if err := validateCommandContext(cmd.Command, cmd.WorkspaceID); err != nil {
		return RevokeInvitationResult{}, err
	}

	actor, _, err := s.verifyAuthenticatedActor(ctx, cmd.BearerToken, true)
	if err != nil {
		return RevokeInvitationResult{}, err
	}

	now := s.clock().UTC()
	reqHash := hashStrings("RevokeInvitation", cmd.WorkspaceID, cmd.ProviderInvitationID)

	var (
		workspace    WorkspaceRecord
		actorUser    UserRecord
		actorRole    WorkspaceRole
		cachedResult *RevokeInvitationResult
		idempRecID   string
	)

	err = s.repo.WithinTx(ctx, cmd.WorkspaceID, "", func(tx TxRepository) error {
		ws, found, txErr := tx.GetWorkspaceByID(ctx, cmd.WorkspaceID)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		if !found || !isActiveWorkspace(ws) {
			return notFoundOpaqueError()
		}
		workspace = ws

		u, found, txErr := tx.GetUserByClerkID(ctx, actor.ClerkID)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		if !found {
			return unauthenticatedError()
		}
		if err := ensureActiveUser(u); err != nil {
			return err
		}
		actorUser = u

		member, found, txErr := tx.GetWorkspaceMember(ctx, ws.WorkspaceID, u.UserID)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		if !found || member.Status != MembershipStatusActive {
			return notFoundOpaqueError()
		}
		if !HasWorkspacePermission(member.Role, PermWorkspaceSettingsManage) {
			return newDomainError(
				ErrInviterNotAuthorized,
				ErrCodeSystemForbidden001,
				StatusPermissionDenied,
				"Bạn không có quyền hủy lời mời trong workspace này.",
				"Caller lacks workspace:settings:manage permission to cancel invitations.",
			)
		}
		actorRole = member.Role

		existingIdemp, hasIdemp, txErr := tx.GetIdempotencyRecord(ctx, ws.WorkspaceID, u.UserID, RPCCancelInvite, cmd.Command.IdempotencyKey, now)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		if hasIdemp {
			if !constantTimeEqualStrings(existingIdemp.RequestHash, reqHash) {
				return idempotencyConflictError()
			}
			if existingIdemp.Status == IdempotencyStatusCompleted {
				var out RevokeInvitationResult
				if uErr := json.Unmarshal(existingIdemp.ResponsePayload, &out); uErr != nil {
					return internalError(uErr)
				}
				out.Replayed = true
				cachedResult = &out
				return nil
			}
			if existingIdemp.Status == IdempotencyStatusProcessing {
				return idempotencyInProgressError()
			}
			idempRecID = existingIdemp.RecordID
		}
		if idempRecID == "" {
			var idErr error
			idempRecID, idErr = s.newID(now)
			if idErr != nil {
				return internalError(idErr)
			}
		}
		return wrapRepoError(tx.SaveIdempotencyRecord(ctx, IdempotencyRecord{
			RecordID:       idempRecID,
			WorkspaceID:    ws.WorkspaceID,
			ActorID:        u.UserID,
			RPC:            RPCCancelInvite,
			IdempotencyKey: cmd.Command.IdempotencyKey,
			RequestHash:    reqHash,
			Status:         IdempotencyStatusProcessing,
			ExpiresAt:      now.Add(MinIdempotencyTTL),
			CreatedAt:      now,
		}))
	})
	if err != nil {
		return RevokeInvitationResult{}, err
	}
	if cachedResult != nil {
		return *cachedResult, nil
	}

	inv, err := s.provider.GetInvitationByID(ctx, workspace.ClerkOrganizationID, cmd.ProviderInvitationID)
	if err != nil {
		s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, actorUser.UserID, RPCCancelInvite, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
		return RevokeInvitationResult{}, mapLookupInvitationError(ctx, err)
	}
	if inv.ClerkOrganizationID != workspace.ClerkOrganizationID || (inv.WorkspaceID != "" && inv.WorkspaceID != workspace.WorkspaceID) {
		s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, actorUser.UserID, RPCCancelInvite, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
		return RevokeInvitationResult{}, notFoundOpaqueError()
	}
	if !CanRoleCancelInvitation(actorRole, inv.Role) {
		s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, actorUser.UserID, RPCCancelInvite, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
		return RevokeInvitationResult{}, newDomainError(
			ErrRoleElevationDenied,
			ErrCodeSystemForbidden001,
			StatusPermissionDenied,
			"Bạn không có quyền hủy lời mời có vai trò ngang bằng hoặc cao hơn mình.",
			"Caller cannot cancel an invitation at or above their own workspace role.",
		)
	}
	if inv.Status == ProviderInvitationAccepted {
		s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, actorUser.UserID, RPCCancelInvite, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
		return RevokeInvitationResult{}, newPreconditionError(
			ErrInvitationRevoked,
			ErrCodeSystemInvalid001,
			"Lời mời này đã được chấp nhận, không thể hủy.",
			"Cannot cancel an invitation that has already been accepted.",
			string(inv.Status),
			string(ProviderInvitationRevoked),
			nil,
		)
	}

	if inv.Status != ProviderInvitationRevoked {
		if _, err := s.provider.RevokeInvitation(ctx, workspace.ClerkOrganizationID, cmd.ProviderInvitationID, actorUser.UserID); err != nil {
			s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, actorUser.UserID, RPCCancelInvite, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
			return RevokeInvitationResult{}, mapProviderCallError(ctx, err)
		}
	}

	var out RevokeInvitationResult
	err = s.repo.WithinTx(ctx, workspace.WorkspaceID, actorUser.UserID, func(tx TxRepository) error {
		auditID, idErr := s.newID(now)
		if idErr != nil {
			return internalError(idErr)
		}
		if txErr := tx.AppendAuditEvent(ctx, AuditEventRecord{
			AuditEventID: auditID,
			WorkspaceID:  workspace.WorkspaceID,
			ActorUserID:  actorUser.UserID,
			ActorType:    "user",
			Action:       "workspace.invitation.cancelled",
			ResourceType: "workspace",
			ResourceID:   workspace.WorkspaceID,
			Changes: map[string]any{
				"provider_invitation_id": cmd.ProviderInvitationID,
				"role":                   string(inv.Role),
			},
			Reason:    cmd.Command.Reason,
			CreatedAt: now,
		}); txErr != nil {
			return wrapRepoError(txErr)
		}
		out = RevokeInvitationResult{
			ProviderInvitationID: cmd.ProviderInvitationID,
			WorkspaceID:          workspace.WorkspaceID,
			Status:               string(ProviderInvitationRevoked),
			AuditEventID:         auditID,
			Replayed:             false,
		}
		respBytes, mErr := json.Marshal(out)
		if mErr != nil {
			return internalError(mErr)
		}
		return wrapRepoError(tx.SaveIdempotencyRecord(ctx, IdempotencyRecord{
			RecordID:        idempRecID,
			WorkspaceID:     workspace.WorkspaceID,
			ActorID:         actorUser.UserID,
			RPC:             RPCCancelInvite,
			IdempotencyKey:  cmd.Command.IdempotencyKey,
			RequestHash:     reqHash,
			Status:          IdempotencyStatusCompleted,
			ResponsePayload: respBytes,
			ResponseCode:    200,
			ExpiresAt:       now.Add(MinIdempotencyTTL),
			CreatedAt:       now,
		}))
	})
	if err != nil {
		return RevokeInvitationResult{}, err
	}
	return out, nil
}

// ResendInvitation re-sends an expired invitation with a fresh <=7-day expiry.
// Per docs/02_features/platform/auth.md RULE-AUTH-005 and EC-AUTH-004, expired
// links cannot be reused directly and can only be re-sent by workspace Admin+
// (Owner or Admin within their role ceiling).
func (s *Service) ResendInvitation(ctx context.Context, cmd ResendInvitationCommand) (IssueInvitationResult, error) {
	if err := s.checkContextAndDeps(ctx); err != nil {
		return IssueInvitationResult{}, err
	}
	if !validUUID(cmd.WorkspaceID) {
		return IssueInvitationResult{}, newValidationError("workspace_id", "must be a canonical non-nil UUID")
	}
	if !validOpaqueToken(cmd.ProviderInvitationID, 3, 255) {
		return IssueInvitationResult{}, newValidationError("provider_invitation_id", "must be a valid provider invitation identifier")
	}
	if err := validateCommandContext(cmd.Command, cmd.WorkspaceID); err != nil {
		return IssueInvitationResult{}, err
	}
	if cmd.TTL < 0 || cmd.TTL > MaxInvitationAge {
		return IssueInvitationResult{}, newValidationError("ttl", "invitation expiry must be between >0 and 7 days")
	}
	effectiveTTL := cmd.TTL
	if effectiveTTL == 0 {
		effectiveTTL = MaxInvitationAge
	}

	actor, _, err := s.verifyAuthenticatedActor(ctx, cmd.BearerToken, true)
	if err != nil {
		return IssueInvitationResult{}, err
	}

	now := s.clock().UTC()
	reqHash := hashStrings("ResendInvitation", cmd.WorkspaceID, cmd.ProviderInvitationID, effectiveTTL.String())

	var (
		workspace    WorkspaceRecord
		actorUser    UserRecord
		actorRole    WorkspaceRole
		cachedResult *IssueInvitationResult
		idempRecID   string
	)

	err = s.repo.WithinTx(ctx, cmd.WorkspaceID, "", func(tx TxRepository) error {
		ws, found, txErr := tx.GetWorkspaceByID(ctx, cmd.WorkspaceID)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		if !found || !isActiveWorkspace(ws) {
			return notFoundOpaqueError()
		}
		workspace = ws

		u, found, txErr := tx.GetUserByClerkID(ctx, actor.ClerkID)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		if !found {
			return unauthenticatedError()
		}
		if err := ensureActiveUser(u); err != nil {
			return err
		}
		actorUser = u

		member, found, txErr := tx.GetWorkspaceMember(ctx, ws.WorkspaceID, u.UserID)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		if !found || member.Status != MembershipStatusActive {
			return notFoundOpaqueError()
		}
		if !HasWorkspacePermission(member.Role, PermWorkspaceSettingsManage) {
			return newDomainError(
				ErrInviterNotAuthorized,
				ErrCodeSystemForbidden001,
				StatusPermissionDenied,
				"Chỉ quản trị viên workspace (Admin+) mới có thể gửi lại lời mời.",
				"Only workspace Admin or Owner can resend invitations (RULE-AUTH-005).",
			)
		}
		actorRole = member.Role

		existingIdemp, hasIdemp, txErr := tx.GetIdempotencyRecord(ctx, ws.WorkspaceID, u.UserID, RPCResendInvite, cmd.Command.IdempotencyKey, now)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		if hasIdemp {
			if !constantTimeEqualStrings(existingIdemp.RequestHash, reqHash) {
				return idempotencyConflictError()
			}
			if existingIdemp.Status == IdempotencyStatusCompleted {
				var out IssueInvitationResult
				if uErr := json.Unmarshal(existingIdemp.ResponsePayload, &out); uErr != nil {
					return internalError(uErr)
				}
				out.Replayed = true
				cachedResult = &out
				return nil
			}
			if existingIdemp.Status == IdempotencyStatusProcessing {
				return idempotencyInProgressError()
			}
			idempRecID = existingIdemp.RecordID
		}

		if idempRecID == "" {
			var idErr error
			idempRecID, idErr = s.newID(now)
			if idErr != nil {
				return internalError(idErr)
			}
		}
		return wrapRepoError(tx.SaveIdempotencyRecord(ctx, IdempotencyRecord{
			RecordID:       idempRecID,
			WorkspaceID:    ws.WorkspaceID,
			ActorID:        u.UserID,
			RPC:            RPCResendInvite,
			IdempotencyKey: cmd.Command.IdempotencyKey,
			RequestHash:    reqHash,
			Status:         IdempotencyStatusProcessing,
			ExpiresAt:      now.Add(MinIdempotencyTTL),
			CreatedAt:      now,
		}))
	})
	if err != nil {
		return IssueInvitationResult{}, err
	}
	if cachedResult != nil {
		return *cachedResult, nil
	}

	origInv, err := s.provider.GetInvitationByID(ctx, workspace.ClerkOrganizationID, cmd.ProviderInvitationID)
	if err != nil {
		s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, actorUser.UserID, RPCResendInvite, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
		return IssueInvitationResult{}, mapLookupInvitationError(ctx, err)
	}
	if origInv.ClerkOrganizationID != workspace.ClerkOrganizationID || (origInv.WorkspaceID != "" && origInv.WorkspaceID != workspace.WorkspaceID) {
		s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, actorUser.UserID, RPCResendInvite, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
		return IssueInvitationResult{}, notFoundOpaqueError()
	}
	if !CanRoleResendInvitation(actorRole, origInv.Role) {
		s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, actorUser.UserID, RPCResendInvite, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
		return IssueInvitationResult{}, newDomainError(
			ErrRoleElevationDenied,
			ErrCodeSystemForbidden001,
			StatusPermissionDenied,
			"Bạn không có quyền gửi lại lời mời cho vai trò này.",
			"Caller cannot resend an invitation at or above their own workspace role.",
		)
	}
	inviteeEmail, ok := normalizeEmail(origInv.InviteeEmail)
	if !ok {
		s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, actorUser.UserID, RPCResendInvite, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
		return IssueInvitationResult{}, internalError(errors.New("stored provider invitation has invalid email"))
	}
	isExpired := origInv.Status == ProviderInvitationExpired || !now.Before(origInv.EffectiveExpiry())
	if origInv.Status == ProviderInvitationAccepted || (!isExpired && origInv.Status != ProviderInvitationPending) {
		s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, actorUser.UserID, RPCResendInvite, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
		return IssueInvitationResult{}, newPreconditionError(
			ErrInvitationNotExpired,
			ErrCodeSystemInvalid001,
			"Không thể gửi lại lời mời ở trạng thái hiện tại.",
			"Invitation cannot be resent in its current state.",
			string(origInv.Status),
			"resend",
			[]string{string(ProviderInvitationExpired), string(ProviderInvitationPending)},
		)
	}

	if preErr := s.repo.WithinTx(ctx, workspace.WorkspaceID, actorUser.UserID, func(tx TxRepository) error {
		if _, alreadyActive, txErr := tx.GetActiveMemberByEmail(ctx, workspace.WorkspaceID, inviteeEmail); txErr != nil {
			return wrapRepoError(txErr)
		} else if alreadyActive {
			return newDomainError(
				ErrAlreadyActiveMember,
				ErrCodeAuthConflict001,
				StatusAlreadyExists,
				"Email này đã là thành viên đang hoạt động của workspace.",
				"User with this email is already an active member of the workspace.",
			)
		}
		return nil
	}); preErr != nil {
		s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, actorUser.UserID, RPCResendInvite, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
		return IssueInvitationResult{}, preErr
	}

	if origInv.Status == ProviderInvitationPending {
		_, _ = s.provider.RevokeInvitation(ctx, workspace.ClerkOrganizationID, origInv.ProviderInvitationID, actorUser.UserID)
	}

	expiresAt := now.Add(effectiveTTL)
	newInv, err := s.provider.CreateInvitation(ctx, CreateProviderInvitationInput{
		ClerkOrganizationID: workspace.ClerkOrganizationID,
		WorkspaceID:         workspace.WorkspaceID,
		InviteeEmail:        inviteeEmail,
		Role:                origInv.Role,
		InviterUserID:       actorUser.UserID,
		ExpiresAt:           expiresAt,
		IdempotencyKey:      cmd.Command.IdempotencyKey,
	})
	if err != nil {
		s.markIdempotencyFailedBestEffort(ctx, workspace.WorkspaceID, actorUser.UserID, RPCResendInvite, cmd.Command.IdempotencyKey, idempRecID, reqHash, now)
		return IssueInvitationResult{}, mapProviderCallError(ctx, err)
	}

	effectiveExp := newInv.EffectiveExpiry()
	if newInv.CreatedAt.IsZero() {
		effectiveExp = expiresAt
	}

	var finalResult IssueInvitationResult
	err = s.repo.WithinTx(ctx, workspace.WorkspaceID, actorUser.UserID, func(tx TxRepository) error {
		if _, alreadyActive, txErr := tx.GetActiveMemberByEmail(ctx, workspace.WorkspaceID, inviteeEmail); txErr != nil {
			return wrapRepoError(txErr)
		} else if alreadyActive {
			return newDomainError(
				ErrAlreadyActiveMember,
				ErrCodeAuthConflict001,
				StatusAlreadyExists,
				"Email này đã là thành viên đang hoạt động của workspace.",
				"User with this email is already an active member of the workspace.",
			)
		}

		auditID, idErr := s.newID(now)
		if idErr != nil {
			return internalError(idErr)
		}
		eventID, idErr := s.newID(now)
		if idErr != nil {
			return internalError(idErr)
		}
		corrID, idErr := s.resolveCorrelationID(cmd.Command.CorrelationID, now)
		if idErr != nil {
			return internalError(idErr)
		}

		if txErr := tx.AppendAuditEvent(ctx, AuditEventRecord{
			AuditEventID: auditID,
			WorkspaceID:  workspace.WorkspaceID,
			ActorUserID:  actorUser.UserID,
			ActorType:    "user",
			Action:       "workspace.invitation.resent",
			ResourceType: "workspace",
			ResourceID:   workspace.WorkspaceID,
			Changes: map[string]any{
				"previous_invitation_id": cmd.ProviderInvitationID,
				"provider_invitation_id": newInv.ProviderInvitationID,
				"invitee_email":          inviteeEmail,
				"role":                   string(origInv.Role),
				"expires_at":             effectiveExp.Format(time.RFC3339),
			},
			Reason:    cmd.Command.Reason,
			CreatedAt: now,
		}); txErr != nil {
			return wrapRepoError(txErr)
		}

		payloadBytes, mErr := json.Marshal(WorkspaceMemberInvitedPayload{
			WorkspaceID:  workspace.WorkspaceID,
			InviteeEmail: inviteeEmail,
			InvitedBy:    actorUser.UserID,
			Role:         origInv.Role,
		})
		if mErr != nil {
			return internalError(mErr)
		}
		if txErr := tx.AppendOutboxEvent(ctx, DomainEventRecord{
			EventID:       eventID,
			EventType:     EventWorkspaceMemberInvited,
			AggregateType: "workspace",
			AggregateID:   workspace.WorkspaceID,
			WorkspaceID:   workspace.WorkspaceID,
			ActorID:       actorUser.UserID,
			ActorType:     "user",
			Payload:       payloadBytes,
			CorrelationID: corrID,
			OccurredAt:    now,
			Version:       1,
		}); txErr != nil {
			return wrapRepoError(txErr)
		}

		finalResult = IssueInvitationResult{
			ProviderInvitationID: newInv.ProviderInvitationID,
			WorkspaceID:          workspace.WorkspaceID,
			InviteeEmail:         inviteeEmail,
			Role:                 origInv.Role,
			InvitedBy:            actorUser.UserID,
			ExpiresAt:            effectiveExp,
			AuditEventID:         auditID,
			Replayed:             false,
		}
		respBytes, mErr := json.Marshal(finalResult)
		if mErr != nil {
			return internalError(mErr)
		}
		return wrapRepoError(tx.SaveIdempotencyRecord(ctx, IdempotencyRecord{
			RecordID:        idempRecID,
			WorkspaceID:     workspace.WorkspaceID,
			ActorID:         actorUser.UserID,
			RPC:             RPCResendInvite,
			IdempotencyKey:  cmd.Command.IdempotencyKey,
			RequestHash:     reqHash,
			Status:          IdempotencyStatusCompleted,
			ResponsePayload: respBytes,
			ResponseCode:    200,
			ExpiresAt:       now.Add(MinIdempotencyTTL),
			CreatedAt:       now,
		}))
	})
	if err != nil {
		return IssueInvitationResult{}, err
	}
	return finalResult, nil
}

// ReconcileProviderMembership reconciles delayed or out-of-order Clerk webhook
// events (organizationMembership.created/updated/deleted and
// organizationInvitation.accepted) per docs/02_features/platform/auth.md lines 190-196:
//   - Deduplicates external_event_id per workspace.
//   - Maps ClerkOrganizationID only to an existing active workspace; NEVER
//     auto-creates a workspace from an unrecognized Clerk organization ID.
//   - Delayed webhooks after synchronous AcceptInvitation reconcile without
//     creating duplicate memberships.
//   - Out-of-order older create/update/accepted events NEVER resurrect a
//     removed member or overwrite newer local membership state.
func (s *Service) ReconcileProviderMembership(ctx context.Context, evt ProviderMembershipEvent) (ReconcileResult, error) {
	if err := checkContext(ctx); err != nil {
		return ReconcileResult{}, err
	}
	if s == nil || s.repo == nil {
		return ReconcileResult{}, fmt.Errorf("%w: repository is nil", ErrDependencyUnconfigured)
	}
	if _, ok := s.repo.(UnconfiguredRepository); ok {
		return ReconcileResult{}, fmt.Errorf("%w: repository is unconfigured", ErrDependencyUnconfigured)
	}
	if !validOpaqueToken(evt.ExternalEventID, 3, 255) {
		return ReconcileResult{}, newValidationError("external_event_id", "must be non-empty")
	}
	if !validOpaqueToken(evt.ClerkOrganizationID, 3, 255) {
		return ReconcileResult{}, newValidationError("clerk_organization_id", "must be non-empty")
	}
	if !validOpaqueToken(evt.ClerkUserID, 3, 255) {
		return ReconcileResult{}, newValidationError("clerk_user_id", "must be non-empty")
	}
	if evt.SourceUpdatedAt.IsZero() {
		return ReconcileResult{}, newValidationError("source_updated_at", "must be non-zero")
	}

	now := s.clock().UTC()
	sourceTS := evt.SourceUpdatedAt.UTC()

	var result ReconcileResult
	err := s.repo.WithinTx(ctx, "", "", func(tx TxRepository) error {
		ws, found, txErr := tx.GetWorkspaceByClerkOrgID(ctx, evt.ClerkOrganizationID)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		if !found || !isActiveWorkspace(ws) {
			// auth.md line 190: Never auto-create an arbitrary workspace from an unrecognized org ID.
			return notFoundOpaqueError()
		}

		alreadyDone, txErr := tx.HasProcessedWebhookEvent(ctx, ws.WorkspaceID, evt.ExternalEventID)
		if txErr != nil {
			return wrapRepoError(txErr)
		}
		if alreadyDone {
			result = ReconcileResult{Replayed: true, Reason: "duplicate_external_event_id"}
			return nil
		}

		user, userFound, txErr := tx.GetUserByClerkID(ctx, evt.ClerkUserID)
		if txErr != nil {
			return wrapRepoError(txErr)
		}

		switch evt.EventType {
		case ProviderEventMembershipDeleted:
			if !userFound {
				if err := tx.RecordProcessedWebhookEvent(ctx, ws.WorkspaceID, evt.ExternalEventID, now); err != nil {
					return wrapRepoError(err)
				}
				result = ReconcileResult{Ignored: true, Reason: "user_not_found"}
				return nil
			}
			member, hasMember, txErr := tx.GetWorkspaceMember(ctx, ws.WorkspaceID, user.UserID)
			if txErr != nil {
				return wrapRepoError(txErr)
			}
			if !hasMember {
				if err := tx.RecordProcessedWebhookEvent(ctx, ws.WorkspaceID, evt.ExternalEventID, now); err != nil {
					return wrapRepoError(err)
				}
				result = ReconcileResult{Ignored: true, Reason: "membership_not_found"}
				return nil
			}
			if member.SourceUpdatedAt != nil && sourceTS.Before(*member.SourceUpdatedAt) {
				if err := tx.RecordProcessedWebhookEvent(ctx, ws.WorkspaceID, evt.ExternalEventID, now); err != nil {
					return wrapRepoError(err)
				}
				result = ReconcileResult{Ignored: true, Reason: "stale_delete_event"}
				return nil
			}
			if member.Role == RoleOwner && ws.OwnerUserID == user.UserID {
				return newDomainError(
					ErrRoleElevationDenied,
					ErrCodeSystemForbidden001,
					StatusPermissionDenied,
					"Không thể xóa chủ sở hữu workspace đang hoạt động cuối cùng.",
					"Cannot remove the active workspace Owner without ownership transfer.",
				)
			}
			member.Status = MembershipStatusRemoved
			member.SourceUpdatedAt = &sourceTS
			member.UpdatedAt = now
			updated, txErr := tx.UpsertWorkspaceMember(ctx, member)
			if txErr != nil {
				return wrapRepoError(txErr)
			}
			if err := tx.RecordProcessedWebhookEvent(ctx, ws.WorkspaceID, evt.ExternalEventID, now); err != nil {
				return wrapRepoError(err)
			}
			result = ReconcileResult{Applied: true, Member: &updated}
			return nil

		case ProviderEventMembershipCreated, ProviderEventMembershipUpdated, ProviderEventInvitationAccepted:
			if !ValidWorkspaceRole(evt.Role) {
				return newValidationError("role", "invalid workspace role in provider event")
			}
			normEmail, emailOK := normalizeEmail(evt.Email)
			if !userFound {
				if !emailOK || !evt.EmailVerified {
					return newDomainError(
						ErrEmailNotVerified,
						ErrCodeAuthForbidden001,
						StatusFailedPrecondition,
						"Email chưa được xác minh cho sự kiện thành viên.",
						"Verified email is required before creating workspace membership.",
					)
				}
				uid, idErr := s.newID(now)
				if idErr != nil {
					return internalError(idErr)
				}
				syncedUser, _, uErr := tx.UpsertVerifiedUser(ctx, UserRecord{
					UserID:          uid,
					ClerkID:         evt.ClerkUserID,
					SourceUpdatedAt: &sourceTS,
					Email:           normEmail,
					DisplayName:     evt.DisplayName,
					Status:          UserStatusActive,
					CreatedAt:       now,
					UpdatedAt:       now,
				})
				if uErr != nil {
					return wrapRepoError(uErr)
				}
				user = syncedUser
			} else if user.Status == UserStatusSuspended || user.Status == UserStatusDeleted {
				return accountSuspendedOrDeletedError()
			}

			if evt.Role == RoleOwner && ws.OwnerUserID != user.UserID {
				return newDomainError(
					ErrRoleElevationDenied,
					ErrCodeSystemForbidden001,
					StatusPermissionDenied,
					"Không thể gán chủ sở hữu thứ hai qua webhook.",
					"Provider webhook cannot grant Owner role to a non-owner user.",
				)
			}

			if evt.InviterUserID != "" {
				if !validUUID(evt.InviterUserID) {
					return newValidationError("inviter_user_id", "must be a valid UUID")
				}
				inviterMem, hasInviter, iErr := tx.GetWorkspaceMember(ctx, ws.WorkspaceID, evt.InviterUserID)
				if iErr != nil {
					return wrapRepoError(iErr)
				}
				if !hasInviter || inviterMem.Status != MembershipStatusActive || !CanRoleInviteTarget(inviterMem.Role, evt.Role) {
					return newDomainError(
						ErrInviterNotAuthorized,
						ErrCodeSystemForbidden001,
						StatusPermissionDenied,
						"Người mời không có quyền hợp lệ cho vai trò này.",
						"Inviter lacks authority for the role in provider reconciliation event.",
					)
				}
			}

			existingMember, hasMember, txErr := tx.GetWorkspaceMember(ctx, ws.WorkspaceID, user.UserID)
			if txErr != nil {
				return wrapRepoError(txErr)
			}
			if hasMember {
				// auth.md line 194: NEVER resurrect a removed member from an older (or equal-timestamp) event,
				// and never overwrite newer local state with stale webhook payloads.
				if existingMember.Status == MembershipStatusRemoved {
					if existingMember.SourceUpdatedAt != nil && !sourceTS.After(*existingMember.SourceUpdatedAt) {
						if err := tx.RecordProcessedWebhookEvent(ctx, ws.WorkspaceID, evt.ExternalEventID, now); err != nil {
							return wrapRepoError(err)
						}
						result = ReconcileResult{Ignored: true, Reason: "never_resurrect_removed_member_from_older_event"}
						return nil
					}
					if evt.EventType == ProviderEventMembershipUpdated {
						if err := tx.RecordProcessedWebhookEvent(ctx, ws.WorkspaceID, evt.ExternalEventID, now); err != nil {
							return wrapRepoError(err)
						}
						result = ReconcileResult{Ignored: true, Reason: "update_cannot_resurrect_removed_member"}
						return nil
					}
				}
				if existingMember.SourceUpdatedAt != nil && sourceTS.Before(*existingMember.SourceUpdatedAt) {
					if err := tx.RecordProcessedWebhookEvent(ctx, ws.WorkspaceID, evt.ExternalEventID, now); err != nil {
						return wrapRepoError(err)
					}
					result = ReconcileResult{Ignored: true, Reason: "older_source_updated_at", Member: &existingMember}
					return nil
				}
				if existingMember.Status == MembershipStatusActive &&
					(evt.EventType == ProviderEventMembershipCreated || evt.EventType == ProviderEventInvitationAccepted) {
					// Delayed creation/acceptance webhook after synchronous AcceptInvitation:
					// attach ClerkMembershipID if missing, do not duplicate or alter newer local role.
					if existingMember.ClerkMembershipID == "" && evt.ClerkMembershipID != "" {
						existingMember.ClerkMembershipID = evt.ClerkMembershipID
						existingMember.UpdatedAt = now
						existingMember, txErr = tx.UpsertWorkspaceMember(ctx, existingMember)
						if txErr != nil {
							return wrapRepoError(txErr)
						}
					}
					if err := tx.RecordProcessedWebhookEvent(ctx, ws.WorkspaceID, evt.ExternalEventID, now); err != nil {
						return wrapRepoError(err)
					}
					result = ReconcileResult{Applied: false, Replayed: true, Reason: "already_synchronized", Member: &existingMember}
					return nil
				}
			}

			memberID := existingMember.WorkspaceMemberID
			createdAt := now
			joinedAt := now
			invitedBy := evt.InviterUserID
			if hasMember && memberID != "" {
				createdAt = existingMember.CreatedAt
				if existingMember.Status == MembershipStatusActive {
					joinedAt = existingMember.JoinedAt
				}
				if invitedBy == "" {
					invitedBy = existingMember.InvitedBy
				}
			} else {
				var idErr error
				memberID, idErr = s.newID(now)
				if idErr != nil {
					return internalError(idErr)
				}
			}
			clerkMemID := evt.ClerkMembershipID
			if clerkMemID == "" && hasMember {
				clerkMemID = existingMember.ClerkMembershipID
			}
			upserted, txErr := tx.UpsertWorkspaceMember(ctx, WorkspaceMemberRecord{
				WorkspaceMemberID: memberID,
				ClerkMembershipID: clerkMemID,
				SourceUpdatedAt:   &sourceTS,
				WorkspaceID:       ws.WorkspaceID,
				UserID:            user.UserID,
				Role:              evt.Role,
				Status:            MembershipStatusActive,
				InvitedBy:         invitedBy,
				JoinedAt:          joinedAt,
				CreatedAt:         createdAt,
				UpdatedAt:         now,
			})
			if txErr != nil {
				return wrapRepoError(txErr)
			}
			if err := tx.RecordProcessedWebhookEvent(ctx, ws.WorkspaceID, evt.ExternalEventID, now); err != nil {
				return wrapRepoError(err)
			}
			result = ReconcileResult{Applied: true, Member: &upserted}
			return nil

		default:
			return newValidationError("event_type", "unsupported provider membership event type")
		}
	})
	if err != nil {
		return ReconcileResult{}, err
	}
	return result, nil
}

func (s *Service) checkContextAndDeps(ctx context.Context) error {
	if err := checkContext(ctx); err != nil {
		return err
	}
	if s == nil || s.verifier == nil || s.provider == nil || s.repo == nil {
		return newDomainError(
			ErrDependencyUnconfigured,
			ErrCodeSystemInternal001,
			StatusInternal,
			"Dịch vụ lời mời chưa được cấu hình đầy đủ.",
			"Invitation domain dependencies are not configured.",
		)
	}
	return nil
}

func (s *Service) verifyAuthenticatedActor(ctx context.Context, bearerToken string, requireVerifiedEmail bool) (VerifiedClerkActor, string, error) {
	if !validOpaqueToken(bearerToken, 8, 8192) {
		return VerifiedClerkActor{}, "", unauthenticatedError()
	}
	actor, err := s.verifier.VerifyActor(ctx, bearerToken)
	if err != nil {
		if ctxErr := checkContext(ctx); ctxErr != nil {
			return VerifiedClerkActor{}, "", ctxErr
		}
		if errors.Is(err, ErrDependencyUnconfigured) {
			return VerifiedClerkActor{}, "", newDomainError(
				ErrDependencyUnconfigured,
				ErrCodeSystemInternal001,
				StatusInternal,
				"Trình xác thực danh tính chưa được cấu hình.",
				"Clerk identity verifier is not configured.",
			)
		}
		return VerifiedClerkActor{}, "", unauthenticatedError()
	}
	if err := checkContext(ctx); err != nil {
		return VerifiedClerkActor{}, "", err
	}
	if !validOpaqueToken(actor.ClerkID, 3, 255) || !validOpaqueToken(actor.SessionID, 3, 255) || !actor.SessionActive {
		return VerifiedClerkActor{}, "", unauthenticatedError()
	}
	email, ok := normalizeEmail(actor.Email)
	if !ok {
		return VerifiedClerkActor{}, "", newDomainError(
			ErrInvalidInput,
			ErrCodeAuthInvalid001,
			StatusInvalidArgument,
			"Email xác thực không hợp lệ.",
			"Verified Clerk identity is missing a valid email.",
		)
	}
	if requireVerifiedEmail && !actor.EmailVerified {
		return VerifiedClerkActor{}, "", newPreconditionError(
			ErrEmailNotVerified,
			ErrCodeAuthForbidden001,
			"Vui lòng xác minh địa chỉ email trước khi tham gia workspace.",
			"Email verification is required before joining or managing a workspace.",
			string(UserStatusPendingVerification),
			string(UserStatusActive),
			[]string{"verify_email"},
		)
	}
	return actor, email, nil
}

func validateCommandContext(cmd CommandContext, targetWorkspaceID string) error {
	if !validIdempotencyKey(cmd.IdempotencyKey) {
		return newValidationError("idempotency_key", "must be 1-255 printable characters")
	}
	if len(cmd.Reason) > 2000 {
		return newValidationError("reason", "must not exceed 2000 characters")
	}
	if cmd.CorrelationID != "" && !validUUID(cmd.CorrelationID) {
		return newValidationError("correlation_id", "must be a canonical non-nil UUID")
	}
	if cmd.WorkspaceID != "" {
		if !validUUID(cmd.WorkspaceID) {
			return newValidationError("workspace_id", "must be a canonical non-nil UUID")
		}
		if cmd.WorkspaceID != targetWorkspaceID {
			return crossTenantNotFoundError()
		}
	}
	return nil
}

func validateResolvedInvitationShape(inv ProviderInvitation, expectedWorkspaceID string, now time.Time) (string, error) {
	if !validOpaqueToken(inv.ProviderInvitationID, 3, 255) ||
		!validOpaqueToken(inv.ClerkOrganizationID, 3, 255) ||
		!validUUID(inv.WorkspaceID) ||
		!validUUID(inv.InviterUserID) {
		return "", invalidTokenError()
	}
	if expectedWorkspaceID != "" && expectedWorkspaceID != inv.WorkspaceID {
		return "", crossTenantNotFoundError()
	}
	email, ok := normalizeEmail(inv.InviteeEmail)
	if !ok {
		return "", invalidTokenError()
	}
	if inv.Role == RoleOwner || !ValidInvitableRole(inv.Role) {
		return "", newDomainError(
			ErrRoleElevationDenied,
			ErrCodeSystemForbidden001,
			StatusPermissionDenied,
			"Vai trò trên lời mời không hợp lệ hoặc không được phép gán.",
			"Invitation role is non-canonical or forbidden (Owner cannot be invited).",
		)
	}
	if inv.CreatedAt.IsZero() || inv.CreatedAt.After(now.Add(MaxClockSkew)) {
		return "", invalidTokenError()
	}
	if !inv.ExpiresAt.IsZero() && inv.ExpiresAt.Before(inv.CreatedAt) {
		return "", invalidTokenError()
	}
	return email, nil
}

func validateInvitationStateForPreviewOrDecline(inv ProviderInvitation, now time.Time) error {
	switch inv.Status {
	case ProviderInvitationRevoked:
		return revokedInviteError()
	case ProviderInvitationDeclined:
		return declinedInviteError()
	case ProviderInvitationExpired:
		return expiredInviteError(string(inv.Status))
	case ProviderInvitationAccepted:
		return newPreconditionError(
			ErrInvitationInvalidToken,
			ErrCodeSystemInvalid001,
			"Lời mời này đã được sử dụng.",
			"This invitation has already been accepted.",
			string(inv.Status),
			"preview_or_decline",
			nil,
		)
	case ProviderInvitationPending:
		if !now.Before(inv.EffectiveExpiry()) {
			return expiredInviteError(string(inv.Status))
		}
		return nil
	default:
		return invalidTokenError()
	}
}

func verifyWorkspaceAndInviterInTx(ctx context.Context, tx TxRepository, inv ProviderInvitation) (WorkspaceRecord, error) {
	ws, found, txErr := tx.GetWorkspaceByID(ctx, inv.WorkspaceID)
	if txErr != nil {
		return WorkspaceRecord{}, wrapRepoError(txErr)
	}
	if !found || !isActiveWorkspace(ws) || ws.ClerkOrganizationID != inv.ClerkOrganizationID {
		return WorkspaceRecord{}, crossTenantNotFoundError()
	}
	wsByOrg, orgFound, txErr := tx.GetWorkspaceByClerkOrgID(ctx, inv.ClerkOrganizationID)
	if txErr != nil {
		return WorkspaceRecord{}, wrapRepoError(txErr)
	}
	if !orgFound || wsByOrg.WorkspaceID != ws.WorkspaceID {
		return WorkspaceRecord{}, crossTenantNotFoundError()
	}

	inviterUser, uFound, txErr := tx.GetUserByID(ctx, inv.InviterUserID)
	if txErr != nil {
		return WorkspaceRecord{}, wrapRepoError(txErr)
	}
	if !uFound || inviterUser.Status != UserStatusActive {
		return WorkspaceRecord{}, newDomainError(
			ErrInviterNotAuthorized,
			ErrCodeSystemForbidden001,
			StatusPermissionDenied,
			"Người gửi lời mời không còn hoạt động hợp lệ.",
			"Inviter account is no longer active.",
		)
	}

	inviterMember, mFound, txErr := tx.GetWorkspaceMember(ctx, ws.WorkspaceID, inv.InviterUserID)
	if txErr != nil {
		return WorkspaceRecord{}, wrapRepoError(txErr)
	}
	if !mFound || inviterMember.Status != MembershipStatusActive {
		return WorkspaceRecord{}, newDomainError(
			ErrInviterNotAuthorized,
			ErrCodeSystemForbidden001,
			StatusPermissionDenied,
			"Người gửi lời mời không còn là thành viên hoạt động của workspace.",
			"Inviter is not an active member of the target workspace.",
		)
	}
	if err := enforceInviterAuthority(inviterMember.Role, inv.Role); err != nil {
		return WorkspaceRecord{}, err
	}
	return ws, nil
}

func enforceInviterAuthority(inviterRole, targetRole WorkspaceRole) error {
	if !HasWorkspacePermission(inviterRole, PermWorkspaceMembersInvite) {
		return newDomainError(
			ErrInviterNotAuthorized,
			ErrCodeSystemForbidden001,
			StatusPermissionDenied,
			"Bạn không có quyền mời thành viên vào workspace.",
			"Caller lacks workspace:members:invite permission.",
		)
	}
	if !CanRoleInviteTarget(inviterRole, targetRole) {
		return newDomainError(
			ErrRoleElevationDenied,
			ErrCodeSystemForbidden001,
			StatusPermissionDenied,
			"Không thể mời vai trò ngang bằng hoặc cao hơn quyền hạn của bạn.",
			"Inviter cannot grant a role equal to or higher than their own role.",
		)
	}
	return nil
}

func isActiveWorkspace(ws WorkspaceRecord) bool {
	return validUUID(ws.WorkspaceID) &&
		ws.Status == WorkspaceStatusActive &&
		ws.DeletedAt == nil &&
		validOpaqueToken(ws.ClerkOrganizationID, 3, 255)
}

func ensureActiveUser(u UserRecord) error {
	switch u.Status {
	case UserStatusActive:
		return nil
	case UserStatusSuspended, UserStatusDeleted:
		return accountSuspendedOrDeletedError()
	default:
		return unauthenticatedError()
	}
}

func (s *Service) resolveCorrelationID(candidate string, now time.Time) (string, error) {
	if candidate != "" && validUUID(candidate) {
		return candidate, nil
	}
	return s.newID(now)
}

func (s *Service) markIdempotencyFailedBestEffort(ctx context.Context, workspaceID, actorID, rpc, key, recID, reqHash string, now time.Time) {
	if s == nil || s.repo == nil || workspaceID == "" || actorID == "" || recID == "" {
		return
	}
	_ = s.repo.WithinTx(ctx, workspaceID, actorID, func(tx TxRepository) error {
		return tx.SaveIdempotencyRecord(ctx, IdempotencyRecord{
			RecordID:       recID,
			WorkspaceID:    workspaceID,
			ActorID:        actorID,
			RPC:            rpc,
			IdempotencyKey: key,
			RequestHash:    reqHash,
			Status:         IdempotencyStatusFailed,
			ExpiresAt:      now.Add(MinIdempotencyTTL),
			CreatedAt:      now,
		})
	})
}

func checkContext(ctx context.Context) error {
	if ctx == nil {
		return newDomainError(ErrInvalidInput, ErrCodeSystemInvalid001, StatusInvalidArgument, "Thiếu ngữ cảnh yêu cầu.", "Missing request context.")
	}
	if err := ctx.Err(); err != nil {
		if errors.Is(err, context.Canceled) {
			return newDomainError(err, ErrCodeSystemCanceled001, StatusCanceled, "Yêu cầu đã bị hủy.", "Request canceled.")
		}
		if errors.Is(err, context.DeadlineExceeded) {
			return newDomainError(err, ErrCodeSystemTimeout001, StatusDeadlineExceeded, "Yêu cầu hết thời gian chờ.", "Request deadline exceeded.")
		}
		return internalError(err)
	}
	return nil
}

func wrapRepoError(err error) error {
	if err == nil {
		return nil
	}
	var domErr *DomainError
	if errors.As(err, &domErr) {
		return domErr
	}
	if errors.Is(err, context.Canceled) {
		return newDomainError(err, ErrCodeSystemCanceled001, StatusCanceled, "Yêu cầu đã bị hủy.", "Request canceled.")
	}
	if errors.Is(err, context.DeadlineExceeded) {
		return newDomainError(err, ErrCodeSystemTimeout001, StatusDeadlineExceeded, "Yêu cầu hết thời gian chờ.", "Request deadline exceeded.")
	}
	if errors.Is(err, ErrDependencyUnconfigured) {
		return newDomainError(
			ErrDependencyUnconfigured,
			ErrCodeSystemInternal001,
			StatusInternal,
			"Kho lưu trữ bền vững và P0-04 RLS chưa được cấu hình.",
			"Durable PostgreSQL repository and P0-04 RLS are not configured.",
		)
	}
	return internalError(err)
}

func mapTokenResolveError(ctx context.Context, err error) error {
	if ctxErr := checkContext(ctx); ctxErr != nil {
		return ctxErr
	}
	if errors.Is(err, ErrDependencyUnconfigured) {
		return newDomainError(
			ErrDependencyUnconfigured,
			ErrCodeSystemInternal001,
			StatusInternal,
			"Nhà cung cấp lời mời Clerk chưa được cấu hình.",
			"Clerk invitation provider is not configured.",
		)
	}
	return invalidTokenError()
}

func mapLookupInvitationError(ctx context.Context, err error) error {
	if ctxErr := checkContext(ctx); ctxErr != nil {
		return ctxErr
	}
	if errors.Is(err, ErrDependencyUnconfigured) {
		return newDomainError(
			ErrDependencyUnconfigured,
			ErrCodeSystemInternal001,
			StatusInternal,
			"Nhà cung cấp lời mời Clerk chưa được cấu hình.",
			"Clerk invitation provider is not configured.",
		)
	}
	return notFoundOpaqueError()
}

func mapProviderAcceptError(ctx context.Context, err error) error {
	if ctxErr := checkContext(ctx); ctxErr != nil {
		return ctxErr
	}
	var domErr *DomainError
	if errors.As(err, &domErr) {
		return domErr
	}
	switch {
	case errors.Is(err, ErrDependencyUnconfigured):
		return newDomainError(ErrDependencyUnconfigured, ErrCodeSystemInternal001, StatusInternal, "Nhà cung cấp lời mời Clerk chưa được cấu hình.", "Clerk invitation provider is not configured.")
	case errors.Is(err, ErrInvitationExpired):
		return expiredInviteError(string(ProviderInvitationExpired))
	case errors.Is(err, ErrInvitationRevoked):
		return revokedInviteError()
	case errors.Is(err, ErrInvitationDeclined):
		return declinedInviteError()
	case errors.Is(err, ErrInviteeEmailMismatch):
		return inviteeEmailMismatchError()
	case errors.Is(err, ErrInvitationInvalidToken):
		return invalidTokenError()
	default:
		return internalError(err)
	}
}

func mapProviderCallError(ctx context.Context, err error) error {
	if ctxErr := checkContext(ctx); ctxErr != nil {
		return ctxErr
	}
	var domErr *DomainError
	if errors.As(err, &domErr) {
		return domErr
	}
	if errors.Is(err, ErrDependencyUnconfigured) {
		return newDomainError(ErrDependencyUnconfigured, ErrCodeSystemInternal001, StatusInternal, "Nhà cung cấp lời mời Clerk chưa được cấu hình.", "Clerk invitation provider is not configured.")
	}
	return internalError(err)
}

func unauthenticatedError() *DomainError {
	return newDomainError(
		ErrUnauthenticated,
		ErrCodeAuthForbidden001,
		StatusUnauthenticated,
		"Phiên đăng nhập chưa hợp lệ.",
		"Valid Clerk session is required.",
	)
}

func accountSuspendedOrDeletedError() *DomainError {
	return newDomainError(
		ErrAccountUnavailable,
		ErrCodeAuthForbidden002,
		StatusPermissionDenied,
		"Tài khoản đã bị tạm ngưng.",
		"Account is suspended or deactivated.",
	)
}

func notFoundOpaqueError() *DomainError {
	return newDomainError(
		ErrCrossTenantMismatch,
		ErrCodeSystemNotFound001,
		StatusNotFound,
		"Không tìm thấy tài nguyên.",
		"Resource not found.",
	)
}

func crossTenantNotFoundError() *DomainError {
	return newDomainError(
		ErrCrossTenantMismatch,
		ErrCodeSystemNotFound001,
		StatusNotFound,
		"Không tìm thấy tài nguyên.",
		"Resource not found.",
	)
}

func invalidTokenError() *DomainError {
	return newDomainError(
		ErrInvitationInvalidToken,
		ErrCodeSystemNotFound001,
		StatusNotFound,
		"Liên kết lời mời không hợp lệ hoặc không tồn tại.",
		"Invitation link is invalid or unavailable.",
	)
}

func expiredInviteError(currentState string) *DomainError {
	return newPreconditionError(
		ErrInvitationExpired,
		ErrCodeSystemInvalid001,
		ExpiredInviteMessageVI,
		ExpiredInviteMessageEN,
		currentState,
		string(ProviderInvitationAccepted),
		[]string{"request_new_invite_from_workspace_admin"},
	)
}

func revokedInviteError() *DomainError {
	return newPreconditionError(
		ErrInvitationRevoked,
		ErrCodeSystemInvalid001,
		"Liên kết lời mời này đã bị thu hồi.",
		"This invitation has been revoked by a workspace administrator.",
		string(ProviderInvitationRevoked),
		string(ProviderInvitationAccepted),
		nil,
	)
}

func declinedInviteError() *DomainError {
	return newPreconditionError(
		ErrInvitationDeclined,
		ErrCodeSystemInvalid001,
		"Lời mời này đã bị từ chối và không thể sử dụng lại.",
		"This invitation was already declined and cannot be accepted.",
		string(ProviderInvitationDeclined),
		string(ProviderInvitationAccepted),
		nil,
	)
}

func inviteeEmailMismatchError() *DomainError {
	return newDomainError(
		ErrInviteeEmailMismatch,
		ErrCodeSystemForbidden001,
		StatusPermissionDenied,
		"Email tài khoản đang đăng nhập không khớp với email nhận lời mời.",
		"Authenticated Clerk account email does not match the invited email address.",
	)
}

func idempotencyConflictError() *DomainError {
	return newDomainError(
		ErrIdempotencyConflict,
		ErrCodeSystemConflict001,
		StatusAlreadyExists,
		"Mã yêu cầu đã dùng cho nội dung khác. Vui lòng tải lại.",
		"Idempotency key reused with a different request payload.",
	)
}

func idempotencyInProgressError() *DomainError {
	return newDomainError(
		ErrIdempotencyInProgress,
		ErrCodeSystemConflict001,
		StatusAlreadyExists,
		"Yêu cầu đang được xử lý. Vui lòng chờ.",
		"An identical request with this idempotency key is currently processing.",
	)
}

func internalError(cause error) *DomainError {
	return newDomainError(
		cause,
		ErrCodeSystemInternal001,
		StatusInternal,
		"Lỗi hệ thống. Vui lòng thử lại sau.",
		"Internal server error.",
	)
}

func hashStrings(parts ...string) string {
	h := sha256.New()
	for _, p := range parts {
		var lenBuf [8]byte
		l := uint64(len(p))
		lenBuf[0] = byte(l >> 56)
		lenBuf[1] = byte(l >> 48)
		lenBuf[2] = byte(l >> 40)
		lenBuf[3] = byte(l >> 32)
		lenBuf[4] = byte(l >> 24)
		lenBuf[5] = byte(l >> 16)
		lenBuf[6] = byte(l >> 8)
		lenBuf[7] = byte(l)
		_, _ = h.Write(lenBuf[:])
		_, _ = h.Write([]byte(p))
	}
	return hex.EncodeToString(h.Sum(nil))
}

func deterministicClerkActorUUID(clerkID string) string {
	sum := sha256.Sum256([]byte("creativanta:invitations:clerk_actor:" + clerkID))
	b := sum[:16]
	b[6] = (b[6] & 0x0f) | 0x50 // version 5 style deterministic namespace hash
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x",
		b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

func constantTimeEqualStrings(a, b string) bool {
	if len(a) != len(b) {
		return false
	}
	return subtle.ConstantTimeCompare([]byte(a), []byte(b)) == 1
}

func uniqueNonEmpty(values ...string) []string {
	out := make([]string, 0, len(values))
	seen := make(map[string]struct{}, len(values))
	for _, v := range values {
		if v == "" {
			continue
		}
		if _, ok := seen[v]; ok {
			continue
		}
		seen[v] = struct{}{}
		out = append(out, v)
	}
	return out
}
