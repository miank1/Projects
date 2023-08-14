package main

import (
	"fmt"
	"log"
)

const version = "1.0.0"

type config struct {
	port int
	env  string
}

type application struct {
	config config
	logger *log.Logger
}

func main() {
	fmt.Println("Hello World ")
}
