package main

import (
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
	rl := NewRateLimiter(10, 5*time.Second) // only six request with in 8 sec- once 8sec gets over then new 6 request.

	user := "alice"

	for i := 1; i <= 10; i++ {
		if rl.Allow(user) {
			fmt.Printf("Request %d: allowed\n", i)
		} else {
			fmt.Printf("Request %d: blocked\n", i)
		}
	}
	fmt.Println("---- Sleeping 6 seconds to reset window ----")
	time.Sleep(6 * time.Second)

	for i := 11; i <= 15; i++ {
		if rl.Allow(user) {
			fmt.Printf("Request %d: allowed\n", i)
		} else {
			fmt.Printf("Request %d: blocked\n", i)
		}
	}
}
