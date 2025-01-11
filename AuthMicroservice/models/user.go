package models

type User struct {
	ID       uint   `json:"id"`
	Email    string `json:"email"`
	Password string `json:"password"`
}

func (u *User) Create() error {

}

func GetUserByEmail(email string) (User, error) {

}
