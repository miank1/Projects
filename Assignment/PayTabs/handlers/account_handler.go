package handlers

import (
	"accounts/models"
	"encoding/json"
	"net/http"
	"sync"
)

var accountsMutex sync.Mutex

func ListAccountsHandler(w http.ResponseWriter, r *http.Request) {
	accountsMutex.Lock()
	defer accountsMutex.Unlock()

	response, err := json.Marshal(models.Accounts)
	if err != nil {
		http.Error(w, "Error creating response", http.StatusInternalServerError)
		return
	}

	w.Header().Set("Content-Type", "application/json")
	w.Write(response)

}
