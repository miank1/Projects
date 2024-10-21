package client

import (
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestAPIClient_FetchPrice(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		if r.URL.Path == "/cornflakes.json" {
			w.Write([]byte(`{"price": 2.52}`))
		} else {
			w.WriteHeader(http.StatusNotFound)
		}
	}))
	defer server.Close()

	client := NewAPIClient(server.URL)

	// Test valid product
	price, err := client.FetchPrice("cornflakes")
	if err != nil || price != 2.52 {
		t.Errorf("expected price 2.52, got %v, error: %v", price, err)
	}

	// Test invalid product
	_, err = client.FetchPrice("invalid")
	if err == nil {
		t.Errorf("expected error for invalid product")
	}
}
