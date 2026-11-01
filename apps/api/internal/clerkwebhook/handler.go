package clerkwebhook

import (
	"context"
	"encoding/json"
	"errors"
	"net/http"
)

// ProcessResult reports the outcome of handling a verified Clerk webhook event.
type ProcessResult struct {
	Duplicate bool
}

// EventProcessor persists and reconciles a cryptographically verified Clerk
// webhook event idempotently. Implementations must use durable storage for
// replay/deduplication rather than ephemeral in-memory state.
type EventProcessor interface {
	ProcessVerifiedEvent(ctx context.Context, evt VerifiedEvent) (ProcessResult, error)
}

// Handler is an HTTP handler for POST /webhooks/clerk. It fails closed when
// either Verifier or Processor is nil.
type Handler struct {
	Verifier  *Verifier
	Processor EventProcessor
}

type statusResponse struct {
	Status string `json:"status,omitempty"`
	Error  string `json:"error,omitempty"`
}

// NewHandler constructs a fail-closed Clerk webhook HTTP handler.
func NewHandler(verifier *Verifier, processor EventProcessor) (*Handler, error) {
	if verifier == nil || processor == nil {
		return nil, ErrNotConfigured
	}
	return &Handler{
		Verifier:  verifier,
		Processor: processor,
	}, nil
}

// ServeHTTP verifies the incoming Clerk webhook request and dispatches it to
// the configured durable EventProcessor.
func (h *Handler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	if h == nil || h.Verifier == nil || h.Processor == nil {
		writeJSON(w, http.StatusServiceUnavailable, statusResponse{Error: "not_configured"})
		return
	}
	if r == nil {
		writeJSON(w, http.StatusBadRequest, statusResponse{Error: "invalid_request"})
		return
	}
	if r.Method != http.MethodPost {
		w.Header().Set("Allow", http.MethodPost)
		writeJSON(w, http.StatusMethodNotAllowed, statusResponse{Error: "method_not_allowed"})
		return
	}

	evt, err := h.Verifier.VerifyRequest(r.Context(), r)
	if err != nil {
		switch {
		case errors.Is(err, ErrNotConfigured):
			writeJSON(w, http.StatusServiceUnavailable, statusResponse{Error: "not_configured"})
		case errors.Is(err, ErrMethodNotAllowed):
			w.Header().Set("Allow", http.MethodPost)
			writeJSON(w, http.StatusMethodNotAllowed, statusResponse{Error: "method_not_allowed"})
		case errors.Is(err, ErrBodyTooLarge):
			writeJSON(w, http.StatusRequestEntityTooLarge, statusResponse{Error: "body_too_large"})
		case errors.Is(err, ErrMissingHeaders),
			errors.Is(err, ErrDuplicateHeaders),
			errors.Is(err, ErrInvalidMessageID),
			errors.Is(err, ErrInvalidTimestamp),
			errors.Is(err, ErrExpiredTimestamp),
			errors.Is(err, ErrFutureTimestamp),
			errors.Is(err, ErrInvalidSignature):
			writeJSON(w, http.StatusUnauthorized, statusResponse{Error: "unauthorized_webhook"})
		case errors.Is(err, ErrUnsupportedEventType):
			writeJSON(w, http.StatusBadRequest, statusResponse{Error: "unsupported_event_type"})
		case errors.Is(err, ErrEmptyBody), errors.Is(err, ErrInvalidPayload):
			writeJSON(w, http.StatusBadRequest, statusResponse{Error: "invalid_payload"})
		default:
			writeJSON(w, http.StatusBadRequest, statusResponse{Error: "verification_failed"})
		}
		return
	}

	res, err := h.Processor.ProcessVerifiedEvent(r.Context(), evt)
	if err != nil {
		switch {
		case errors.Is(err, ErrNotConfigured):
			writeJSON(w, http.StatusServiceUnavailable, statusResponse{Error: "not_configured"})
		case errors.Is(err, ErrUnknownOrganization),
			errors.Is(err, ErrUnknownUser),
			errors.Is(err, ErrOwnerProtected),
			errors.Is(err, ErrInvalidPayload):
			writeJSON(w, http.StatusUnprocessableEntity, statusResponse{Error: "reconciliation_rejected"})
		default:
			writeJSON(w, http.StatusInternalServerError, statusResponse{Error: "processing_failed"})
		}
		return
	}

	if res.Duplicate {
		writeJSON(w, http.StatusOK, statusResponse{Status: "duplicate_ignored"})
		return
	}
	writeJSON(w, http.StatusOK, statusResponse{Status: "processed"})
}

func writeJSON(w http.ResponseWriter, statusCode int, payload statusResponse) {
	body, err := json.Marshal(payload)
	if err != nil {
		w.Header().Set("Content-Type", "application/json")
		w.Header().Set("Cache-Control", "no-store")
		w.Header().Set("X-Content-Type-Options", "nosniff")
		w.WriteHeader(http.StatusInternalServerError)
		_, _ = w.Write([]byte(`{"error":"internal_error"}`))
		return
	}
	w.Header().Set("Content-Type", "application/json")
	w.Header().Set("Cache-Control", "no-store")
	w.Header().Set("X-Content-Type-Options", "nosniff")
	w.WriteHeader(statusCode)
	_, _ = w.Write(body)
}
