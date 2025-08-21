package limiter

import (
	"distributed-rate-limiter/internal/store"
	"time"
)

type TokenBucket struct {
	store      store.Store
	rate       int // Tokens added per second
	bucketSize int // Maximum bucket capacity
}

func NewTokenBucket(store store.Store, rate int, bucketSize int) *TokenBucket {
	return &TokenBucket{
		store:      store,
		rate:       rate,
		bucketSize: bucketSize,
	}
}

func (tb *TokenBucket) IsAllowed(key string) (bool, error) {
	now := time.Now().Unix()

	entry, err := tb.store.Get(key)
	if err == store.ErrKeyNotFound {
		// First request, initialize bucket
		newEntry := &store.Entry{
			Count:  tb.bucketSize - 1, // Use one token
			Expiry: now + int64(tb.bucketSize/tb.rate),
		}
		return true, tb.store.Set(key, newEntry)
	}
	if err != nil {
		return false, err
	}

	// Calculate tokens to add based on elapsed time
	elapsed := now - entry.Expiry
	tokensToAdd := int(elapsed) * tb.rate

	// Update current token count
	currentTokens := min(tb.bucketSize, entry.Count+tokensToAdd)

	if currentTokens > 0 {
		// Update entry with new count and timestamp
		entry.Count = currentTokens - 1
		entry.Expiry = now
		return true, tb.store.Set(key, entry)
	}

	return false, nil
}

func (tb *TokenBucket) Reset(key string) error {
	return tb.store.Delete(key)
}

func min(a, b int) int {
	if a < b {
		return a
	}
	return b
}
