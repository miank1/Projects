package main

import (
	"database/sql"
	"fmt"
	"log"
	"net/http"
)

const (
	host     = "localhost"
	port     = 5432
	user     = "admin"
	password = "admin"
	dbname   = "test"
)

func connectToDatabase() bool {
	flag := false

	dsn := "root:your-password@tcp(127.0.0.1:3306)/"

	// Open a database connection
	db, err := sql.Open("mysql", dsn)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// Ping the database to check the connection
	err = db.Ping()
	if err != nil {
		log.Fatal(err)
	}

	fmt.Println("Connected to MySQL!")
	flag = true
	fmt.Println("Successfully connected to the database!")

	return flag

}

func main() {

	result := connectToDatabase()

	if result {

		mux := http.NewServeMux()
		// mux.HandleFunc("/", home)
		// mux.HandleFunc("/snippet", showSnippet)
		// mux.HandleFunc("/snippet/create", createSnippet)

		log.Println("Starting the server on: 4000")
		err := http.ListenAndServe(":4000", mux)
		log.Fatal(err)
	}
}
