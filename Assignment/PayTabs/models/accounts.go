package models

// Account represents the account structure from the JSON file.
type Account struct {
	ID      string  `json:"id"`
	Name    string  `json:"name"`
	Balance float64 `json:"balance"`
}

var Accounts []Account
