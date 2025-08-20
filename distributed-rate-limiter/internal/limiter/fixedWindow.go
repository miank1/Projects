package limiter

import (
	"distributed-rate-limiter/internal/store"
	"time"
)

type FixedWindow struct {
	store  store.Store
	limit  int
	window time.Duration
}

func NewFixedWindow(store store.Store, limit int, window time.Duration) *FixedWindow {
	return &FixedWindow{
		store:  store,
		limit:  limit,
		window: window,
	}
}

func (fw *FixedWindow) Allow(key string) (bool, error) {
	now := time.Now().Unix()
	windowStart := now - int64(fw.window.Seconds())

	// Check if record exists
	entry, err := fw.store.Get(key)
	if err == store.ErrKeyNotFound || entry.Expiry <= windowStart {
		// New window → reset counter
		err = fw.store.Set(key, store.Entry{
			Count:  1,
			Expiry: now + int64(fw.window.Seconds()),
		})
		return err == nil, err
	}

	if err != nil {
		return false, err
	}

	// Same window → check count
	if entry.Count < fw.limit {
		entry.Count++
		err = fw.store.Set(key, entry)
		return err == nil, err
	}

	// Limit exceeded
	return false, nil
}
