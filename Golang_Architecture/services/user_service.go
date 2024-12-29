// services/user_service.go
package services

import (
	"errors"
	"myapp/interfaces"
	"myapp/models"
)

type userService struct {
	users []models.User
}

func NewUserService() interfaces.UserService {
	return &userService{
		users: []models.User{},
	}
}

func (s *userService) GetAllUsers() ([]models.User, error) {
	return s.users, nil
}

func (s *userService) GetUserByID(id int) (models.User, error) {
	for _, user := range s.users {
		if user.ID == id {
			return user, nil
		}
	}
	return models.User{}, errors.New("user not found")
}

func (s *userService) CreateUser(user models.User) (models.User, error) {
	s.users = append(s.users, user)
	return user, nil
}
