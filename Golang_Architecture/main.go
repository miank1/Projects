// main.go
package main

import (
	"log"
	"myapp/routes"
	"net/http"
)

func main() {
	router := routes.SetupRoutes()
	log.Fatal(http.ListenAndServe(":8080", router))
}
