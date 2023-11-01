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

func TestTransferHandler(t *testing.T) {
	// Create a new HTTP request with a JSON payload
	transferData := map[string]interface{}{
		"from":   "fd796d75-1bcf-4a95-bf1a-f7b296adb79f",
		"to":     "ccd1e5cc-c798-4407-883f-f2c62e0d7106",
		"amount": 50.0,
	}
	reqBody, _ := json.Marshal(transferData)
	req, err := http.NewRequest("POST", "/transfer", bytes.NewBuffer(reqBody))
	if err != nil {
		t.Fatal(err)
	}

	// Create a response recorder to record the response
	rr := httptest.NewRecorder()

	// Call the TransferHandler with the request and response recorder
	handlers.TransferHandler(rr, req)

	// Check the response status code
	if rr.Code == http.StatusOK {
		fmt.Printf("Amount successfully transferred")
	} else {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, rr.Code)
	}
}

func TestTransferHandler_1(t *testing.T) {
	// Create a new HTTP request with a JSON payload
	transferData := map[string]interface{}{
		"from":   "3d253e29-8785-464f-8fa0-9e4b57699db9",
		"to":     "17f904c1-806f-4252-9103-74e7a5d3e340",
		"amount": 2000.0, // Transferring money more than the balance
	}
	reqBody, _ := json.Marshal(transferData)
	req, err := http.NewRequest("POST", "/transfer", bytes.NewBuffer(reqBody))
	if err != nil {
		t.Fatal(err)
	}

	// Create a response recorder to record the response
	rr := httptest.NewRecorder()

	// Call the TransferHandler with the request and response recorder
	handlers.TransferHandler(rr, req)

	// Check the response status code
	if rr.Code == http.StatusBadRequest {
		fmt.Printf("Transferring more than the account balance ")
	} else {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, rr.Code)
	}

}
