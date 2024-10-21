package client

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
)

type APIClient struct {
	baseURL string
}

func NewAPIClient(baseURL string) *APIClient {
	return &APIClient{
		baseURL: baseURL,
	}
}

func (client *APIClient) FetchPrice(productName string) (float64, error) {
	url := fmt.Sprintf("%s%s.json", client.baseURL, productName)

	resp, err := http.Get(url)
	if err != nil || resp.StatusCode != http.StatusOK {
		return 0, errors.New("error fetching product price")
	}

	defer resp.Body.Close()

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return 0, err
	}

	var data struct {
		Price float64 `json:"price"`
	}

	if err := json.Unmarshal(body, &data); err != nil {
		return 0, err
	}

	return data.Price, nil
}
