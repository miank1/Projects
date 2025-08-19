package store

import "sync"

type Entry struct {
	Count  int
	Expiry int64
}

type MemoryStore struct {
	data map[string]Entry
	mu   sync.RWMutex
}

func NewMemoryStore() *MemoryStore {
	return &MemoryStore{data: make(map[string]Entry)}
}

func (s *MemoryStore) Get(key string) (Entry, bool) {
	s.mu.RLock()
	defer s.mu.RUnlock()
	val, ok := s.data[key]
	return val, ok
}

func (s *MemoryStore) Set(key string, val Entry) {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.data[key] = val
}
