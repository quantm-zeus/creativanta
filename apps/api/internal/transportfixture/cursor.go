package transportfixture

import (
	"crypto/hmac"
	"crypto/sha256"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"strings"
	"time"
)

// CursorPayload encapsulates signed pagination metadata.
type CursorPayload struct {
	WorkspaceID string `json:"workspace_id"`
	Filter      string `json:"filter"`
	Sort        string `json:"sort"`
	Offset      int    `json:"offset"`
	ExpiresAt   int64  `json:"expires_at"`
}

// SignCursor creates an HMAC SHA256 signed, URL-safe base64 pagination cursor valid for 15 minutes.
func (s *Server) SignCursor(workspaceID, filter, sort string, offset int) (string, error) {
	expiry := time.Now().Add(15 * time.Minute).Unix()
	payload := CursorPayload{
		WorkspaceID: workspaceID,
		Filter:      filter,
		Sort:        sort,
		Offset:      offset,
		ExpiresAt:   expiry,
	}

	rawJSON, err := json.Marshal(payload)
	if err != nil {
		return "", fmt.Errorf("marshal cursor payload: %w", err)
	}

	mac := hmac.New(sha256.New, s.hmacSecret)
	mac.Write(rawJSON)
	sig := mac.Sum(nil)

	encodedPayload := base64.RawURLEncoding.EncodeToString(rawJSON)
	encodedSig := base64.RawURLEncoding.EncodeToString(sig)

	return fmt.Sprintf("%s.%s", encodedPayload, encodedSig), nil
}

// VerifyCursor validates an HMAC SHA256 cursor against signature, expiration, foreign workspace, and query bounds.
func (s *Server) VerifyCursor(token, currentWorkspaceID, currentFilter, currentSort string) (*CursorPayload, error) {
	if token == "" {
		return nil, errors.New("empty cursor")
	}

	parts := strings.Split(token, ".")
	if len(parts) != 2 {
		return nil, errors.New("invalid cursor token format")
	}

	rawJSON, err := base64.RawURLEncoding.DecodeString(parts[0])
	if err != nil {
		return nil, errors.New("invalid cursor payload encoding")
	}

	sig, err := base64.RawURLEncoding.DecodeString(parts[1])
	if err != nil {
		return nil, errors.New("invalid cursor signature encoding")
	}

	mac := hmac.New(sha256.New, s.hmacSecret)
	mac.Write(rawJSON)
	expectedSig := mac.Sum(nil)

	if !hmac.Equal(sig, expectedSig) {
		return nil, errors.New("cursor signature mismatch")
	}

	var payload CursorPayload
	if err := json.Unmarshal(rawJSON, &payload); err != nil {
		return nil, errors.New("invalid cursor payload structure")
	}

	if time.Now().Unix() > payload.ExpiresAt {
		return nil, errors.New("cursor expired")
	}

	if payload.WorkspaceID != currentWorkspaceID {
		return nil, errors.New("foreign workspace cursor rejected")
	}

	if payload.Filter != currentFilter || payload.Sort != currentSort {
		return nil, errors.New("cursor filter or sort parameter mismatch")
	}

	if payload.Offset < 0 {
		return nil, errors.New("invalid negative cursor offset")
	}

	return &payload, nil
}
