package main

import (
	"distributed-rate-limiter/internal/api"
	"fmt"
	"sync"
	"time"
)

// RateLimiter stores user request counters
type RateLimiter struct {
	mu        sync.Mutex
	limit     int           // max requests
	window    time.Duration // time window
	userCount map[string]int
	resetTime map[string]time.Time
}

// NewRateLimiter creates a new limiter
func NewRateLimiter(limit int, window time.Duration) *RateLimiter {
	return &RateLimiter{
		limit:     limit, // 5 request in 10 seconds
		window:    window,
		userCount: make(map[string]int),
		resetTime: make(map[string]time.Time),
	}
}

// Allow checks if user request is allowed
func (rl *RateLimiter) Allow(user string) bool {
	rl.mu.Lock()
	defer rl.mu.Unlock()

	// reset window if expired - user time has exceeded check
	if time.Now().After(rl.resetTime[user]) {
		rl.userCount[user] = 0
		rl.resetTime[user] = time.Now().Add(rl.window)
	}

	if rl.userCount[user] < rl.limit {
		rl.userCount[user]++
		return true
	}
	return false
}

func main() {
	fmt.Println("Distributed Rate Limiter Service Starting...")

	api.StartServer()
}
