package limiter

import (
	"distributed-rate-limiter/internal/store"
	"time"
)

type LeakyBucket struct {
	store    store.Store
	capacity int // Maximum bucket capacity
	rate     int // Rate at which tokens leak per second
}

func NewLeakyBucket(store store.Store, capacity, rate int) *LeakyBucket {
	return &LeakyBucket{
		store:    store,
		capacity: capacity,
		rate:     rate,
	}
}

func (lb *LeakyBucket) Allow(key string) (bool, error) {
	entry, err := lb.store.Get(key)
	now := time.Now().Unix()

	if err == store.ErrKeyNotFound {
		// Initialize new bucket
		err = lb.store.Set(key, store.Entry{
			Count:  1,
			Expiry: now,
		})
		return err == nil, err
	}

	if err != nil {
		return false, err
	}

	// Calculate leaked tokens
	elapsed := now - entry.Expiry
	leakedTokens := int(elapsed) * lb.rate
	currentLevel := max(0, entry.Count-leakedTokens)

	// Check if bucket has space
	if currentLevel >= lb.capacity {
		return false, nil
	}

	// Add new request to bucket
	err = lb.store.Set(key, store.Entry{
		Count:  currentLevel + 1,
		Expiry: now,
	})

	return err == nil, err
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
