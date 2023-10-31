package tests

import (
	"accounts/handlers"
	"testing"
)

func TestTransfer(t *testing.T) {
	result := handlers.TransferHandler(5, 2)
	if result != 3 {
		t.Errorf("Expected 3, but got %d", result)
	}
}
