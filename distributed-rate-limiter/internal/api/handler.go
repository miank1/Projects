package api

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"

	"distributed-rate-limiter/internal/limiter"
	"distributed-rate-limiter/internal/store"
)

var fixedLimiter limiter.Limiter

type RateLimiterConfig struct {
	Type      string        // "token" or "leaky" or "fixed"
	Capacity  int           // maximum number of requests
	Refill    int           // number of requests to refill
	Window    time.Duration // time window for the rate limit
	RedisAddr string        // Redis address
}

func DefaultConfig() RateLimiterConfig {
	return RateLimiterConfig{
		Type:      "token",
		Capacity:  100,
		Refill:    10,
		Window:    time.Second,
		RedisAddr: "localhost:6379",
	}
}

// NewRateLimiter creates a new rate limiter based on configuration
func NewRateLimiter(config RateLimiterConfig, store store.Store) (limiter.Limiter, error) {
	switch config.Type {
	case "token":
		return limiter.NewTokenBucket(store, config.Capacity, config.Refill), nil
	case "leaky":
		return limiter.NewLeakyBucket(store, config.Capacity, config.Refill), nil
	case "fixed":
		return limiter.NewFixedWindow(store, config.Capacity, config.Window), nil
	default:
		return nil, fmt.Errorf("unknown rate limiter type: %s", config.Type)
	}
}

func StartServer(config RateLimiterConfig) error {
	var err error
	var store store.Store

	if config.RedisAddr != "" {
		store, err = store.NewRedisStore(config.RedisAddr)
		if err != nil {
			log.Printf("Failed to connect to Redis: %v, falling back to memory store", err)
			store = store.NewMemoryStore()
		}
	} else {
		store = store.NewMemoryStore()
	}

	fixedLimiter, err = NewRateLimiter(config, store)
	if err != nil {
		return fmt.Errorf("failed to create rate limiter: %w", err)
	}

	http.HandleFunc("/acquire", acquireHandler)

	addr := ":8080"
	log.Printf("✅ API running on %s", addr)
	return http.ListenAndServe(addr, nil)
}

func acquireHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodGet {
		http.Error(w, "method not allowed", http.StatusMethodNotAllowed)
		return
	}

	key := r.URL.Query().Get("key")
	if key == "" {
		http.Error(w, "missing key", http.StatusBadRequest)
		return
	}

	allowed, err := fixedLimiter.Allow(key)
	if err != nil {
		log.Printf("Error checking rate limit: %v", err)
		http.Error(w, "internal server error", http.StatusInternalServerError)
		return
	}

	log.Printf("Request for key: %s, Allowed: %v", key, allowed)

	resp := map[string]interface{}{
		"key":     key,
		"allowed": allowed,
		"message": "✅ Request allowed",
	}

	if !allowed {
		resp["message"] = "❌ Rate limit exceeded"
	}

	w.Header().Set("Content-Type", "application/json")
	if err := json.NewEncoder(w).Encode(resp); err != nil {
		log.Printf("Error encoding response: %v", err)
	}
}
