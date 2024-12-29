// interfaces/user_service_interface.go
package interfaces

import "myapp/models"

type UserService interface {
	GetAllUsers() ([]models.User, error)
	GetUserByID(id int) (models.User, error)
	CreateUser(user models.User) (models.User, error)
}
