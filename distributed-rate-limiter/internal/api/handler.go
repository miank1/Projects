package api

import (
	"fmt"
	"net/http"
)

func StartServer() {

	// 	POST /acquire
	// Accepts a request to acquire a token for a given user/key. Returns success if
	// allowed, or rate-limit error if exceeded.
	fmt.Println("Starting API server on :8080")

	http.HandleFunc("/acquire", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintln(w, "Rate limiter placeholder: /acquire endpoint")
	})

	fmt.Println("✅ API running on :8080")
	http.ListenAndServe(":8080", nil)
}
