package limiter

import (
	"distributed-rate-limiter/internal/store"
	"sync"
	"time"
)

type FixedWindow struct {
	store  *store.MemoryStore
	limit  int
	window time.Duration
	mu     sync.Mutex
}

func NewFixedWindow(s *store.MemoryStore, limit int, window time.Duration) *FixedWindow {
	return &FixedWindow{
		store:  s,
		limit:  limit,
		window: window,
	}
}

func (fw *FixedWindow) Allow(user string) bool {
	fw.mu.Lock()
	defer fw.mu.Unlock()

	now := time.Now().Unix()

	// check if record exists
	entry, exists := fw.store.Get(user)
	if !exists || now > entry.Expiry {
		// new window → reset counter
		fw.store.Set(user, store.Entry{
			Count:  1,
			Expiry: now + int64(fw.window.Seconds()),
		})
		return true
	}

	// same window → check count
	if entry.Count < fw.limit {
		entry.Count++
		fw.store.Set(user, entry)
		return true
	}

	// limit exceeded
	return false
}
