package store

import (
	"errors"
	"time"
)

var (
	// ErrKeyNotFound is returned when a key doesn't exist in the store
	ErrKeyNotFound = errors.New("key not found")
	// ErrInvalidEntry is returned when trying to store an invalid entry
	ErrInvalidEntry = errors.New("invalid entry")
)

// Entry represents a rate limit entry in the store
type Entry struct {
	Count  int   // Number of requests in the current window
	Expiry int64 // Unix timestamp when this entry expires
}

// IsValid checks if the entry is valid
func (e Entry) IsValid() bool {
	return e.Count >= 0 && e.Expiry > time.Now().Unix()
}

// Store defines the interface for rate limiter storage implementations
type Store interface {
	// Get retrieves an entry for the given key
	Get(key string) (Entry, error)

	// Set stores an entry for the given key
	Set(key string, entry Entry) error

	// Delete removes an entry from the store
	Delete(key string) error

	// Clear removes all entries from the store
	Clear() error

	// Close closes the store connection
	Close() error
}

// StoreOption defines a function to configure a store
type StoreOption func(Store) error

// WithTTL sets a time-to-live duration for entries
func WithTTL(ttl time.Duration) StoreOption {
	return func(s Store) error {
		if ttl <= 0 {
			return errors.New("TTL must be positive")
		}
		if configurable, ok := s.(interface{ SetTTL(time.Duration) }); ok {
			configurable.SetTTL(ttl)
		}
		return nil
	}
}
