package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
)

type Customer struct {
	Name    string `json:"full_name"`
	City    string `json:"city"`
	ZipCode string `json:"zip_code"`
}

func main() {
	http.HandleFunc("/greet", greet)
	http.HandleFunc("/customers", getAllCustomers)
	log.Fatal(http.ListenAndServe("localhost:8001", nil))
}

func greet(w http.ResponseWriter, r *http.Request) {
	fmt.Print(w, "Hello World!!")
}

func getAllCustomers(w http.ResponseWriter, r *http.Request) {
	customers := []Customer{
		{Name: "Ashish", City: "New Delhi", ZipCode: "110075"},
		{Name: "Rob", City: "New Delhi", ZipCode: "110075"},
	}
	w.Header().Add("Content-Type", "application/json")
	json.NewEncoder(w).Encode(customers)
}
