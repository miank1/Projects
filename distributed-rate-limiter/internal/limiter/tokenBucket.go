package limiter

import (
	"distributed-rate-limiter/internal/store"
	"time"
)

type TokenBucket struct {
	store    store.Store
	capacity int
	refill   int
}

// NewTokenBucket creates a new TokenBucket limiter
func NewTokenBucket(store store.Store, capacity, refill int) *TokenBucket {
	return &TokenBucket{
		store:    store,
		capacity: capacity,
		refill:   refill,
	}
}

func (tb *TokenBucket) Allow(key string) (bool, error) {
	entry, err := tb.store.Get(key)
	if err != nil && err != store.ErrKeyNotFound {
		return false, err
	}

	now := time.Now().Unix()

	if err == store.ErrKeyNotFound {
		err = tb.store.Set(key, store.Entry{
			Count:  tb.capacity - 1, // Use one token
			Expiry: now,
		})
		return err == nil, err
	}

	// Calculate token refill
	elapsed := now - entry.Expiry
	newTokens := int(elapsed) * tb.refill
	tokens := min(tb.capacity, entry.Count+newTokens)

	if tokens > 0 {
		err = tb.store.Set(key, store.Entry{
			Count:  tokens - 1,
			Expiry: now,
		})
		return err == nil, err
	}

	return false, nil
}
