package identity

import (
	"context"
	"encoding/json"
	"errors"
	"io"
	"net/http"
	"strings"
	"time"
)

const clerkSessionAPI = "https://api.clerk.com/v1/sessions/"

// ClerkSessionStatus checks provider session state on each authorization. It
// does not positively cache revocation results.
type ClerkSessionStatus struct {
	endpoint      string
	authorization string
	client        *http.Client
}

func NewClerkSessionStatus(secret string) (*ClerkSessionStatus, error) {
	return NewClerkSessionStatusWithEndpoint(secret, clerkSessionAPI, nil)
}

func NewClerkSessionStatusWithEndpoint(secret, endpoint string, client *http.Client) (*ClerkSessionStatus, error) {
	if len(secret) < 12 || !strings.HasPrefix(secret, "sk_") || strings.ContainsAny(secret, " \t\r\n") {
		return nil, ErrNotConfigured
	}
	ep := strings.TrimSpace(endpoint)
	if ep == "" {
		ep = clerkSessionAPI
	}
	if !strings.HasPrefix(ep, "https://") {
		return nil, ErrNotConfigured
	}
	if !strings.HasSuffix(ep, "/") {
		ep += "/"
	}
	if client == nil {
		client = &http.Client{Timeout: 4 * time.Second, CheckRedirect: func(*http.Request, []*http.Request) error { return errors.New("session lookup redirect forbidden") }}
	}
	return &ClerkSessionStatus{
		endpoint:      ep,
		authorization: "Bearer " + secret,
		client:        client,
	}, nil
}

func (c *ClerkSessionStatus) Active(ctx context.Context, subject, sessionID string) (bool, error) {
	if c == nil || c.client == nil || c.authorization == "" || ctx == nil {
		return false, ErrNotConfigured
	}
	if !strings.HasPrefix(subject, "user_") || len(subject) > 255 || !strings.HasPrefix(sessionID, "sess_") || len(sessionID) > 255 {
		return false, ErrUnauthorized
	}
	for _, r := range sessionID {
		if (r < 'a' || r > 'z') && (r < 'A' || r > 'Z') && (r < '0' || r > '9') && r != '_' && r != '-' {
			return false, ErrUnauthorized
		}
	}
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, c.endpoint+sessionID, nil)
	if err != nil {
		return false, ErrUnauthorized
	}
	req.Header.Set("Authorization", c.authorization)
	req.Header.Set("Accept", "application/json")
	resp, err := c.client.Do(req)
	if err != nil {
		return false, err
	}
	defer resp.Body.Close()
	if resp.StatusCode == http.StatusNotFound {
		return false, nil
	}
	if resp.StatusCode != http.StatusOK {
		return false, ErrUnauthorized
	}
	b, err := io.ReadAll(io.LimitReader(resp.Body, 32_769))
	if err != nil {
		return false, err
	}
	if len(b) > 32_768 {
		return false, ErrUnauthorized
	}
	var session struct {
		ID       string `json:"id"`
		UserID   string `json:"user_id"`
		Status   string `json:"status"`
		ExpireAt int64  `json:"expire_at"`
	}
	if err := json.Unmarshal(b, &session); err != nil {
		return false, ErrUnauthorized
	}
	if session.ID != sessionID || session.UserID != subject || session.Status != "active" {
		return false, nil
	}
	if session.ExpireAt != 0 && session.ExpireAt <= time.Now().UnixMilli() {
		return false, nil
	}
	return true, nil
}
