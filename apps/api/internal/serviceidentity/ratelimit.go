package serviceidentity

import (
	"sync"
	"time"
)

// RateLimiter implements a high-performance in-memory sliding-window rate limiter
// enforcing RULE-S24-002: 100 req/min read, 30 req/min write, 1000 req/min IP.
type RateLimiter struct {
	mu      sync.Mutex
	windows map[string][]time.Time
}

// NewRateLimiter creates a new thread-safe sliding window rate limiter.
func NewRateLimiter() *RateLimiter {
	return &RateLimiter{
		windows: make(map[string][]time.Time),
	}
}

// Check evaluates whether a request is allowed under the sliding window.
// key: unique identifier (e.g. "key:<api_key_id>:read", "ip:<client_ip>")
// limit: max requests per minute
// now: current time
func (rl *RateLimiter) Check(key string, limit int, now time.Time) RateLimitResult {
	rl.mu.Lock()
	defer rl.mu.Unlock()

	cutoff := now.Add(-1 * time.Minute)
	timestamps := rl.windows[key]

	// Prune timestamps older than 60 seconds
	var valid []time.Time
	for _, ts := range timestamps {
		if ts.After(cutoff) {
			valid = append(valid, ts)
		}
	}

	count := len(valid)
	windowStart := now
	if count > 0 {
		windowStart = valid[0]
	}
	resetAt := windowStart.Add(1 * time.Minute).Unix()

	if count >= limit {
		// Rate limit exceeded: calculate retry-after in seconds until oldest entry expires
		retryAfter := int(valid[0].Add(1*time.Minute).Sub(now).Seconds()) + 1
		if retryAfter < 1 {
			retryAfter = 1
		}
		rl.windows[key] = valid
		return RateLimitResult{
			Allowed:           false,
			Limit:             limit,
			Remaining:         0,
			ResetTimestamp:    resetAt,
			RetryAfterSeconds: retryAfter,
		}
	}

	// Request allowed: record timestamp
	valid = append(valid, now)
	rl.windows[key] = valid

	remaining := limit - len(valid)
	if remaining < 0 {
		remaining = 0
	}

	return RateLimitResult{
		Allowed:           true,
		Limit:             limit,
		Remaining:         remaining,
		ResetTimestamp:    resetAt,
		RetryAfterSeconds: 0,
	}
}

// Reset clears the rate limit state (useful for test isolation).
func (rl *RateLimiter) Reset() {
	rl.mu.Lock()
	defer rl.mu.Unlock()
	rl.windows = make(map[string][]time.Time)
}
