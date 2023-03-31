package main

import (
	"log"
	"net/http"
)

func Start() {
	// Routes
	http.HandleFunc("/greet", greet)
	http.HandleFunc("/customers", getAllCustomers)

	// Server Start
	log.Fatal(http.ListenAndServe("localhost:8001", nil))
}
