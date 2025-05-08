package main

import (
	"fmt"
	"log"
	"net/http"
)

func snippetView(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Display a specific snippet ..."))
}

func snippetCreate(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Create a new snippet"))
}

func home(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("Hello from SnippetBox"))
}

func main() {
	fmt.Println("Hello World !!!")

	mux := http.NewServeMux()
	mux.HandleFunc("/", home)

	mux.HandleFunc("/snippet/view", snippetView)
	mux.HandleFunc("/snippet/create", snippetCreate)
	log.Print("Starting server on :4000")
	err := http.ListenAndServe(":4000", mux)
	log.Fatal(err)
}
