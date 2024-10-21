package main

import (
	"shopping_cart/cart"
	"shopping_cart/client"
)

const (
	BaseAPIURL = "https://equalexperts.github.io/backend-take-home-test-data/"
)

func main() {
	apiClient := client.NewAPIClient(BaseAPIURL)

	// NewShoppingCart accepts an interface

	cart := cart.NewShoppingCart(apiClient)

	// Add Products
	cart.AddProduct("cornflakes", 1)
	cart.AddProduct("cornflakes", 1)
	cart.AddProduct("weetabix", 1)
	cart.AddProduct("weetabix", 1)

	cart.DisplayCart()

}
