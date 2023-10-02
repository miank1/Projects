package main

import (
	"encoding/json"
	"log"
	"net/http"
	"sync"

	"github.com/gorilla/mux"
)

// Car struct represents the car data.
type Car struct {
	ID       string `json:"id"`
	Make     string `json:"make"`
	Model    string `json:"model"`
	Year     int    `json:"year"`
	Package  int    `json:"package"`
	Color    string `json:"color"`
	Category string `json:"category"`
	Mileage  int    `json:"mileage"`
}

var (
	cars      = make(map[string]Car)
	carsMutex = &sync.Mutex{}
)

// getCarHandler handles GET requests to retrieve an existing car by ID.
func getCarHandler(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	carID := params["id"]

	carsMutex.Lock()
	defer carsMutex.Unlock()

	if car, exists := cars[carID]; exists {
		json.NewEncoder(w).Encode(car)
	} else {
		w.WriteHeader(http.StatusNotFound)
	}
}

// getCarsHandler handles GET requests to retrieve the list of all cars.
func getCarsHandler(w http.ResponseWriter, r *http.Request) {
	carsMutex.Lock()
	defer carsMutex.Unlock()

	carList := make([]Car, 0, len(cars))
	for _, car := range cars {
		carList = append(carList, car)
	}

	json.NewEncoder(w).Encode(carList)
}

// createCarHandler handles POST requests to create a new car.
func createCarHandler(w http.ResponseWriter, r *http.Request) {
	var newCar Car
	err := json.NewDecoder(r.Body).Decode(&newCar)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	carsMutex.Lock()
	defer carsMutex.Unlock()

	cars[newCar.ID] = newCar
	w.WriteHeader(http.StatusCreated)
}

// updateCarHandler handles PUT requests to update an existing car by ID.
func updateCarHandler(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	carID := params["id"]

	var updatedCar Car
	err := json.NewDecoder(r.Body).Decode(&updatedCar)
	if err != nil {
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	carsMutex.Lock()
	defer carsMutex.Unlock()

	if _, exists := cars[carID]; exists {
		cars[carID] = updatedCar
		w.WriteHeader(http.StatusOK)
	} else {
		w.WriteHeader(http.StatusNotFound)
	}
}

func main() {
	router := mux.NewRouter()

	router.HandleFunc("/cars/{id}", getCarHandler).Methods("GET")
	router.HandleFunc("/cars", getCarsHandler).Methods("GET")
	router.HandleFunc("/cars", createCarHandler).Methods("POST")
	router.HandleFunc("/cars/{id}", updateCarHandler).Methods("PUT")

	log.Println("Server is running on :8080")
	log.Fatal(http.ListenAndServe(":8080", router))
}
