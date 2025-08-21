package store

import (
	"errors"
)

var (
	ErrKeyNotFound = errors.New("key not found")
	ErrKeyExists   = errors.New("key already exists")
	ErrNilEntry    = errors.New("entry cannot be nil")
)

// Entry represents a rate limit entry
type Entry struct {
	Count  int   // Number of requests
	Expiry int64 // Expiration timestamp
}

// Store defines the interface for rate limiter storage
type Store interface {
	// Get retrieves the entry for given key
	Get(key string) (*Entry, error)

	// Set stores an entry for given key
	Set(key string, entry *Entry) error

	// Delete removes an entry
	Delete(key string) error
}
