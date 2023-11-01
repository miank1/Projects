package handlers

import (
	"accounts/models"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

func TransferHandler(w http.ResponseWriter, r *http.Request) {
	var transferRequest struct {
		From   string  `json:"from"`
		To     string  `json:"to"`
		Amount float64 `json:"amount"`
	}

	body, err := io.ReadAll(r.Body)
	if err != nil {
		fmt.Println("Unable to unmarshal data")
	}

	// Unmarshal the JSON data into the struct
	err = json.Unmarshal(body, &transferRequest)
	if err != nil {
		fmt.Println("Unable to unmarshal data 1")
	}

	accountsMutex.Lock()
	defer accountsMutex.Unlock()

	// Validate the transfer

	fromAccount, toAccount := -1, -1
	for i, acc := range models.Accounts {
		if acc.ID == transferRequest.From {
			fromAccount = i
		} else if acc.ID == transferRequest.To {
			toAccount = i
		}
	}

	if fromAccount == -1 || toAccount == -1 || models.Accounts[fromAccount].Balance < transferRequest.Amount {
		http.Error(w, "Invalid transfer request", http.StatusBadRequest)
		return
	}

	// Perform the transfer
	models.Accounts[fromAccount].Balance -= transferRequest.Amount
	models.Accounts[toAccount].Balance += transferRequest.Amount

	w.WriteHeader(http.StatusOK)
}
