package api

import (
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"distributed-rate-limiter/internal/limiter"
	"distributed-rate-limiter/internal/store"
)

var fixedLimiter *limiter.FixedWindow

func StartServer() {
	// init memory store + fixed window limiter
	memStore := store.NewMemoryStore()
	fixedLimiter = limiter.NewFixedWindow(memStore, 5, 10*time.Second) // allow 5 reqs per window

	http.HandleFunc("/acquire", acquireHandler)

	fmt.Println("✅ API running on :8080")
	http.ListenAndServe(":8080", nil)
}

func acquireHandler(w http.ResponseWriter, r *http.Request) {
	key := r.URL.Query().Get("key")

	if key == "" {
		http.Error(w, "missing key", http.StatusBadRequest)
		return
	}

	allowed := fixedLimiter.Allow(key)

	fmt.Println("Request for key:", key, "Allowed:", allowed)
	resp := map[string]interface{}{
		"key":     key,
		"allowed": allowed,
	}

	if allowed {
		resp["message"] = "✅ Request allowed"
	} else {
		resp["message"] = "❌ Rate limit exceeded"
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(resp)
}
