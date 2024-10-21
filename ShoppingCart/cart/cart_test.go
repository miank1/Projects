package cart

import (
	"errors"
	"testing"
)

type MockPriceFetcher struct {
	prices map[string]float64
}

func (m *MockPriceFetcher) FetchPrice(productName string) (float64, error) {
	if price, exists := m.prices[productName]; exists {
		return price, nil
	}
	return 0, errors.New("product not found")
}

func TestShoppingCart(t *testing.T) {
	mockFetcher := &MockPriceFetcher{
		prices: map[string]float64{
			"cornflakes": 2.52,
			"weetabix":   9.98,
		},
	}
	cart := NewShoppingCart(mockFetcher)

	// Add products to cart
	if err := cart.AddProduct("cornflakes", 1); err != nil {
		t.Errorf("unexpected error: %v", err)
	}
	if err := cart.AddProduct("cornflakes", 1); err != nil {
		t.Errorf("unexpected error: %v", err)
	}
	if err := cart.AddProduct("weetabix", 1); err != nil {
		t.Errorf("unexpected error: %v", err)
	}

	// Verify calculations
	expectedSubtotal := 15.02
	expectedTax := 1.88
	expectedTotal := 16.90

	if subtotal := cart.CalculateSubtotal(); subtotal != expectedSubtotal {
		t.Errorf("expected subtotal %.2f, got %.2f", expectedSubtotal, subtotal)
	}
	if tax := cart.CalculateTax(); tax != expectedTax {
		t.Errorf("expected tax %.2f, got %.2f", expectedTax, tax)
	}
	if total := cart.CalculateTotal(); total != expectedTotal {
		t.Errorf("expected total %.2f, got %.2f", expectedTotal, total)
	}
}
