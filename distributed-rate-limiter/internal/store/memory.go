package store

import (
	"sync"
	"time"
)

type Entry struct {
	Count  int
	Expiry int64
}

type MemoryStore struct {
	mu    sync.RWMutex
	items map[string]Entry
	ttl   time.Duration
}

func NewMemoryStore(opts ...StoreOption) *MemoryStore {
	ms := &MemoryStore{
		items: make(map[string]Entry),
		ttl:   time.Hour, // default TTL
	}

	for _, opt := range opts {
		opt(ms)
	}

	return ms
}

func (ms *MemoryStore) Get(key string) (Entry, error) {
	ms.mu.RLock()
	defer ms.mu.RUnlock()

	entry, exists := ms.items[key]
	if !exists {
		return Entry{}, ErrKeyNotFound
	}

	if !entry.IsValid() {
		delete(ms.items, key)
		return Entry{}, ErrKeyNotFound
	}

	return entry, nil
}

func (ms *MemoryStore) Set(key string, entry Entry) error {
	if !entry.IsValid() {
		return ErrInvalidEntry
	}

	ms.mu.Lock()
	defer ms.mu.Unlock()

	ms.items[key] = entry
	return nil
}

func (ms *MemoryStore) Delete(key string) error {
	ms.mu.Lock()
	defer ms.mu.Unlock()

	delete(ms.items, key)
	return nil
}

func (ms *MemoryStore) Clear() error {
	ms.mu.Lock()
	defer ms.mu.Unlock()

	ms.items = make(map[string]Entry)
	return nil
}

func (ms *MemoryStore) Close() error {
	return ms.Clear()
}

func (ms *MemoryStore) SetTTL(ttl time.Duration) {
	ms.ttl = ttl
}
