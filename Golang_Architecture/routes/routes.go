// routes/routes.go
package routes

import (
	"myapp/controllers"
	"myapp/services"

	"github.com/gorilla/mux"
)

func SetupRoutes() *mux.Router {
	router := mux.NewRouter()

	// Initialize the service and controller
	userService := services.NewUserService()
	userController := controllers.NewUserController(userService)

	// Define routes
	router.HandleFunc("/users", userController.GetAllUsers).Methods("GET")
	router.HandleFunc("/users/{id}", userController.GetUserByID).Methods("GET")
	router.HandleFunc("/users", userController.CreateUser).Methods("POST")

	return router
}
