package main

import (
	"accounts/handlers"
	"accounts/models"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"regexp"
)

func main() {

	resp, err := http.Get("https://git.io/Jm76h")
	if err != nil {
		fmt.Println("Error downloading JSON file:", err)
		return
	}
	defer resp.Body.Close()

	// Read and parse the JSON data
	data, err := io.ReadAll(resp.Body)
	if err != nil {
		fmt.Println("Error reading JSON data:", err)
		return
	}

	jsonString := string(data)
	jsonString = removeQuotesFromFloats(jsonString)

	if err := json.Unmarshal([]byte(jsonString), &models.Accounts); err != nil {
		fmt.Println("Error parsing JSON:", err)
		return
	}

	// Ingested accounts, ready to make transfers
	fmt.Println("Accounts ingested. Ready to make transfers.")

	// Define your HTTP endpoints
	http.HandleFunc("/listAccounts", handlers.ListAccountsHandler)
	http.HandleFunc("/transfer", handlers.TransferHandler)

	// Start the HTTP server
	log.Fatal(http.ListenAndServe(":8080", nil))

}

func removeQuotesFromFloats(jsonString string) string {
	// Regular expression to find and remove quotes around numeric values
	re := `(\d+\.\d+|\d+)`
	jsonString = regexp.MustCompile(`"(`+re+`)"`).ReplaceAllString(jsonString, `$1`)

	return jsonString
}
