package app

import (
	"log"
	"net/http"
)

func Start() {
	mux := http.NewServeMux()

	// Routes
	mux.HandleFunc("/greet", greet)
	mux.HandleFunc("/customers", getAllCustomers)

	// Server Start
	log.Fatal(http.ListenAndServe("localhost:8001", nil))
}
