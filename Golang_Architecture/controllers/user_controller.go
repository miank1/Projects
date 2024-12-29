// controllers/user_controller.go
package controllers

import (
	"encoding/json"
	"myapp/interfaces"
	"myapp/models"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
)

type UserController struct {
	UserService interfaces.UserService
}

func NewUserController(service interfaces.UserService) *UserController {
	return &UserController{
		UserService: service,
	}
}

func (uc *UserController) GetAllUsers(w http.ResponseWriter, r *http.Request) {
	users, _ := uc.UserService.GetAllUsers()
	json.NewEncoder(w).Encode(users)
}

func (uc *UserController) GetUserByID(w http.ResponseWriter, r *http.Request) {
	params := mux.Vars(r)
	id, _ := strconv.Atoi(params["id"])
	user, err := uc.UserService.GetUserByID(id)
	if err != nil {
		http.Error(w, err.Error(), http.StatusNotFound)
		return
	}
	json.NewEncoder(w).Encode(user)
}

func (uc *UserController) CreateUser(w http.ResponseWriter, r *http.Request) {
	var user models.User
	_ = json.NewDecoder(r.Body).Decode(&user)
	newUser, _ := uc.UserService.CreateUser(user)
	json.NewEncoder(w).Encode(newUser)
}
