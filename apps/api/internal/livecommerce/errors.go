package livecommerce

import (
	"errors"

	"connectrpc.com/connect"
)

var (
	ErrMissingTenant              = errors.New("livecommerce: missing workspace tenant identifier")
	ErrScopeMismatch              = errors.New("livecommerce: workspace tenant scope mismatch")
	ErrSessionNotFound            = errors.New("livecommerce: live session not found")
	ErrInvalidLifecycleTransition = errors.New("livecommerce: invalid live session lifecycle state transition")
	ErrSessionNotLive             = errors.New("livecommerce: session must be in live status for this operation")
	ErrCueNotFound                = errors.New("livecommerce: cue card not found")
	ErrHighlightNotFound          = errors.New("livecommerce: highlight not found")
	ErrInvalidTimeOffset          = errors.New("livecommerce: invalid start or end time offset")
	ErrMissingLineage             = errors.New("livecommerce: missing source lineage for derivative extraction")
	ErrMissingRecording           = errors.New("livecommerce: source recording asset is required for highlight extraction")
	ErrPermissionDenied           = errors.New("livecommerce: permission denied")
	ErrDuplicateCommand           = errors.New("livecommerce: duplicate command rejected")
	ErrInvalidAmount              = errors.New("livecommerce: invalid numeric money amount")
)

// MapErrorToConnect translates livecommerce domain errors into standard ConnectRPC codes.
func MapErrorToConnect(err error) error {
	if err == nil {
		return nil
	}
	switch {
	case errors.Is(err, ErrMissingTenant):
		return connect.NewError(connect.CodeUnauthenticated, err)
	case errors.Is(err, ErrScopeMismatch), errors.Is(err, ErrPermissionDenied):
		return connect.NewError(connect.CodePermissionDenied, err)
	case errors.Is(err, ErrSessionNotFound), errors.Is(err, ErrCueNotFound), errors.Is(err, ErrHighlightNotFound):
		return connect.NewError(connect.CodeNotFound, err)
	case errors.Is(err, ErrInvalidLifecycleTransition), errors.Is(err, ErrSessionNotLive):
		return connect.NewError(connect.CodeFailedPrecondition, err)
	case errors.Is(err, ErrInvalidTimeOffset), errors.Is(err, ErrMissingLineage), errors.Is(err, ErrMissingRecording), errors.Is(err, ErrInvalidAmount):
		return connect.NewError(connect.CodeInvalidArgument, err)
	case errors.Is(err, ErrDuplicateCommand):
		return connect.NewError(connect.CodeAlreadyExists, err)
	default:
		return connect.NewError(connect.CodeInternal, err)
	}
}
