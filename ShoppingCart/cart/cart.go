package cart

import (
	"fmt"
	"math"
	"shopping_cart/models"
)

const (
	TaxRate = 0.125
)

type ShoppingCart struct {
	Items        map[string]*models.Product
	priceFetcher PriceFetcher
}

// PriceFetcher interface to abstract price fetching mechanism
type PriceFetcher interface {
	FetchPrice(productName string) (float64, error)
}

func NewShoppingCart(fetcher PriceFetcher) *ShoppingCart {
	return &ShoppingCart{
		Items:        make(map[string]*models.Product),
		priceFetcher: fetcher,
	}
}

func (cart *ShoppingCart) AddProduct(productName string, quantity int) error {
	price, err := cart.priceFetcher.FetchPrice(productName)

	if err != nil {
		return err
	}

	if item, exists := cart.Items[productName]; exists {
		item.Quantity += quantity
	} else {
		cart.Items[productName] = &models.Product{
			Name:     productName,
			Price:    price,
			Quantity: quantity,
		}
	}

	return nil
}

// CalculateSubtotal calculates the subtotal of the cart
func (cart *ShoppingCart) CalculateSubtotal() float64 {
	subtotal := 0.0
	for _, item := range cart.Items {
		subtotal += item.Price * float64(item.Quantity)
	}
	return math.Round(subtotal)
}

func (cart *ShoppingCart) CalculateTax() float64 {
	return math.Round(cart.CalculateSubtotal() * TaxRate)
}

func (cart *ShoppingCart) CalculateTotal() float64 {
	return math.Round(cart.CalculateSubtotal() + cart.CalculateTax())
}

func (cart *ShoppingCart) DisplayCart() {
	for name, item := range cart.Items {
		fmt.Printf("Cart contains %d x %s @ %.2f each \n", item.Quantity, name, item.Price)

	}

	fmt.Printf("SubTotal: %.2f\n ", cart.CalculateSubtotal())
	fmt.Printf("Tax: %.2f\n ", cart.CalculateTax())
	fmt.Printf("Total: %.2f\n ", cart.CalculateTotal())
}
