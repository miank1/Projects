# Shopping Cart Example in Go

This is a simple shopping cart application written in Go. It fetches product prices from an external API and calculates the subtotal, tax, and total.

## Features
- Add products to the cart
- Retrieve product prices via a price API
- Calculate subtotal, tax (12.5%), and total payable

## Structure
- `main.go`: Entry point for the application
- `cart/`: Contains the shopping cart logic and tests
- `client/`: Contains the API client for fetching product prices and its tests
- `models/`: Defines the product model

## Instructions
1. Clone the repository.
2. Run the application using `go run main.go`.
3. Run tests using `go test ./...`.

## Assumptions
- Prices are fetched from the provided API.
- Tax rate is fixed at 12.5%.

## Design Considerations
- **Single Responsibility Principle**: Each struct is responsible for a single task.
- **Dependency Injection**: Allows for easy testing by injecting the `PriceFetcher` interface.

## Example Output

