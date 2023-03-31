package app

import (
	"log"
	"net/http"

	"github.com/gorilla/mux"
)

func Start() {

	router := mux.NewRouter()

	// Routes
	router.HandleFunc("/greet", greet)
	router.HandleFunc("/customers", getAllCustomers)

	// Server Start
	log.Fatal(http.ListenAndServe("localhost:8000", router))
}
