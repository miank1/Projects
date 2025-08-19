package store

import "sync"

type MemoryStore struct {
	mu    sync.Mutex
	count map[string]int
}

func NewMemoryStore() *MemoryStore {
	return &MemoryStore{count: make(map[string]int)}
}

func (ms *MemoryStore) Increment(key string) (int, error) {
	ms.mu.Lock()
	defer ms.mu.Unlock()
	ms.count[key]++
	return ms.count[key], nil
}

func (ms *MemoryStore) Reset(key string) error {
	ms.mu.Lock()
	defer ms.mu.Unlock()
	ms.count[key] = 0
	return nil
}
