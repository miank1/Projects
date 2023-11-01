package tests

import (
	"accounts/handlers"
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestTransferHandler_1(t *testing.T) {
	// Create a new HTTP request with a JSON payload
	transferData := map[string]interface{}{
		"from":   "3d253e29-8785-464f-8fa0-9e4b57699db9",
		"to":     "17f904c1-806f-4252-9103-74e7a5d3e340",
		"amount": 200.0, // Transferring money more than the balance
	}
	reqBody, _ := json.Marshal(transferData)
	req, err := http.NewRequest("POST", "/transfer", bytes.NewBuffer(reqBody))
	if err != nil {
		t.Fatal(err)
	}

	req.Header.Set("Content-Type", "application/json")
	// Create a response recorder to record the response
	rr := httptest.NewRecorder()

	// Call the TransferHandler with the request and response recorder
	handlers.TransferHandler(rr, req)

	// Check the response status code
	if rr.Code == http.StatusBadRequest {
		fmt.Printf("Transferring more than the account balance ")
	} else {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, rr.Code)
		fmt.Printf("Response Body: %s\n", rr.Body.String())
	}

}
