package store

import (
	"sync"
	"time"
)

type MemoryStore struct {
	mu    sync.RWMutex
	items map[string]*Entry
}

func NewMemoryStore() *MemoryStore {
	return &MemoryStore{
		items: make(map[string]*Entry),
	}
}

// Get retrieves an entry from memory store
func (ms *MemoryStore) Get(key string) (*Entry, error) {
	ms.mu.RLock()
	defer ms.mu.RUnlock()

	entry, exists := ms.items[key]
	if !exists {
		return nil, ErrKeyNotFound
	}

	// Check if entry has expired
	if time.Now().Unix() > entry.Expiry {
		delete(ms.items, key)
		return nil, ErrKeyNotFound
	}

	return entry, nil
}

// Set stores an entry in memory store
func (ms *MemoryStore) Set(key string, entry *Entry) error {
	if entry == nil {
		return ErrNilEntry
	}

	ms.mu.Lock()
	defer ms.mu.Unlock()

	ms.items[key] = entry
	return nil
}

// Delete removes an entry from memory store
func (ms *MemoryStore) Delete(key string) error {
	ms.mu.Lock()
	defer ms.mu.Unlock()

	delete(ms.items, key)
	return nil
}
