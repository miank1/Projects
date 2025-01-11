package main

import (
	"auth/database"
	"auth/handlers"

	"github.com/gorilla/mux"
)

func main() {

	database.Connect()

	router := mux.NewRouter()

	router.HandleFunc("/register", handlers.Register).Methods("POST")
	router.HandleFunc("/login", handlers.Login).Methods("POST")
	router.HandleFunc("/profile", handlers.Protected).Methods("GET")
}
