package limiter

import (
	"distributed-rate-limiter/internal/store"
	"time"
)

type LeakyBucket struct {
	store    store.Store
	capacity int // Maximum capacity of the bucket
	leakRate int // Rate at which tokens leak per second
}

func NewLeakyBucket(store store.Store, capacity, leakRate int) *LeakyBucket {
	return &LeakyBucket{
		store:    store,
		capacity: capacity,
		leakRate: leakRate,
	}
}

func (lb *LeakyBucket) IsAllowed(key string) (bool, error) {
	now := time.Now().Unix()

	entry, err := lb.store.Get(key)
	if err == store.ErrKeyNotFound {
		// First request, initialize bucket
		newEntry := &store.Entry{
			Count:  1,
			Expiry: now + int64(lb.capacity/lb.leakRate),
		}
		return true, lb.store.Set(key, newEntry)
	}
	if err != nil {
		return false, err
	}

	// Calculate leaked tokens since last request
	elapsed := now - entry.Expiry
	leaked := int(elapsed) * lb.leakRate
	currentLevel := max(0, entry.Count-leaked)

	// Check if bucket has space
	if currentLevel >= lb.capacity {
		return false, nil
	}

	// Add new request to bucket
	entry.Count = currentLevel + 1
	entry.Expiry = now

	return true, lb.store.Set(key, entry)
}

func (lb *LeakyBucket) Reset(key string) error {
	return lb.store.Delete(key)
}

func max(a, b int) int {
	if a > b {
		return a
	}
	return b
}
