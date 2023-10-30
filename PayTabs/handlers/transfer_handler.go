package handlers

import (
	"accounts/models"
	"encoding/json"
	"net/http"
)

func TransferHandler(w http.ResponseWriter, r *http.Request) {
	var transferRequest struct {
		From   string  `json:"from"`
		To     string  `json:"to"`
		Amount float64 `json:"amount"`
	}

	err := json.NewDecoder(r.Body).Decode(&transferRequest)
	if err != nil {
		http.Error(w, "Error parsing request", http.StatusBadRequest)
		return
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
