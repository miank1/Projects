package main

import "fmt"

const version = "1.0.0"

type config struct {
	port int
	env  string
}

func main() {
	fmt.Println("Hello World!")
}
