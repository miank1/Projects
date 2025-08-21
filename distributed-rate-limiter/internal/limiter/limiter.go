package limiter

import (
	"sync"
	"time"
)

// Limiter implements a simple distributed rate limiter using token bucket algorithm.
type Limiter struct {
	rate      int           // tokens per interval
	interval  time.Duration // interval for token refill
	tokens    int
	lastCheck time.Time
	mu        sync.Mutex
}

// NewLimiter creates a new Limiter.
func NewLimiter(rate int, interval time.Duration) *Limiter {
	return &Limiter{
		rate:      rate,
		interval:  interval,
		tokens:    rate,
		lastCheck: time.Now(),
	}
}

// Allow checks if a request can proceed. Returns true if allowed, false otherwise.
func (l *Limiter) Allow() bool {
	l.mu.Lock()
	defer l.mu.Unlock()

	now := time.Now()
	elapsed := now.Sub(l.lastCheck)
	if elapsed >= l.interval {
		refills := int(elapsed / l.interval)
		l.tokens += refills * l.rate
		if l.tokens > l.rate {
			l.tokens = l.rate
		}
		l.lastCheck = now
	}

	if l.tokens > 0 {
		l.tokens--
		return true
	}
	return false
}

// RateLimiter defines the interface for rate limiting algorithms
type RateLimiter interface {
	// IsAllowed checks if the request should be allowed
	IsAllowed(key string) (bool, error)

	// Reset resets the rate limiter for the given key
	Reset(key string) error
}
