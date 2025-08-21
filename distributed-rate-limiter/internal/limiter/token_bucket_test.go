package limiter

import (
	"distributed-rate-limiter/internal/store"
	"testing"
	"time"
)

func TestTokenBucket(t *testing.T) {
	memStore := store.NewMemoryStore()
	tb := NewTokenBucket(memStore, 10, 100) // 10 tokens/sec, max 100 tokens

	tests := []struct {
		name     string
		wait     time.Duration
		attempts int
		want     bool
	}{
		{
			name:     "first request",
			attempts: 1,
			want:     true,
		},
		{
			name:     "burst under limit",
			attempts: 50,
			want:     true,
		},
		{
			name:     "exceed bucket size",
			attempts: 101,
			want:     false,
		},
		{
			name:     "refill after wait",
			wait:     time.Second,
			attempts: 1,
			want:     true,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			if tt.wait > 0 {
				time.Sleep(tt.wait)
			}

			var allowed bool
			var err error
			for i := 0; i < tt.attempts; i++ {
				allowed, err = tb.IsAllowed("test-key")
				if err != nil {
					t.Fatalf("unexpected error: %v", err)
				}
			}

			if allowed != tt.want {
				t.Errorf("got %v, want %v", allowed, tt.want)
			}
		})
	}
}
