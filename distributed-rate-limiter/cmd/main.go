package main

import (
	"context"
	"encoding/json"
	"log"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"distributed-rate-limiter/internal/config"
	"distributed-rate-limiter/internal/limiter"
	"distributed-rate-limiter/internal/store"
)

type Response struct {
	Allowed bool   `json:"allowed"`
	Message string `json:"message"`
}

func main() {
	cfg := config.DefaultConfig()

	// Initialize Redis store
	redisConfig := store.RedisConfig{
		Addr:    cfg.RedisAddr,
		Timeout: 5 * time.Second,
	}

	rateStore, err := store.NewRedisStore(redisConfig)
	if err != nil {
		log.Printf("Failed to connect to Redis: %v, falling back to memory store", err)
		//rateStore = store.NewMemoryStore()
	}
	defer rateStore.Close()

	// Create rate limiter
	rateLimiter := limiter.NewTokenBucket(rateStore, cfg.RateLimit, cfg.WindowSize)

	// Create server
	srv := &http.Server{
		Addr:         ":8080",
		ReadTimeout:  15 * time.Second,
		WriteTimeout: 15 * time.Second,
	}

	// Configure routes
	http.HandleFunc("/ratelimit", func(w http.ResponseWriter, r *http.Request) {
		clientID := r.Header.Get("X-Client-ID")
		if clientID == "" {
			http.Error(w, "Missing X-Client-ID header", http.StatusBadRequest)
			return
		}

		allowed, err := rateLimiter.IsAllowed(clientID)
		if err != nil {
			log.Printf("Rate limiter error: %v", err)
			http.Error(w, "Internal server error", http.StatusInternalServerError)
			return
		}

		resp := Response{
			Allowed: allowed,
			Message: "Request processed",
		}

		w.Header().Set("Content-Type", "application/json")
		if !allowed {
			w.WriteHeader(http.StatusTooManyRequests)
			resp.Message = "Rate limit exceeded"
		}

		json.NewEncoder(w).Encode(resp)
	})

	// Start server
	go func() {
		log.Printf("Server starting on %s", srv.Addr)
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			log.Fatalf("Server failed: %v", err)
		}
	}()

	// Graceful shutdown
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	log.Println("Shutting down server...")
	ctx, cancel := context.WithTimeout(context.Background(), 30*time.Second)
	defer cancel()

	if err := srv.Shutdown(ctx); err != nil {
		log.Fatalf("Server shutdown failed: %v", err)
	}
}
