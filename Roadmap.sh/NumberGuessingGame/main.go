package main

import (
	"fmt"
	"math/rand"
	"time"
)

func main() {

	fmt.Println("Welcome to the Number Guessing Game!")
	fmt.Println("I'm thinking of a number between 1 and 100.")
	rand.Seed(time.Now().UnixNano())

	// Generate a random number b/w 1 and 100
	randomNumber := rand.Intn(100) + 1
	fmt.Println("The computer has selected a number b/w 1 and 100 ")

	fmt.Println("You have 5 chances to guess the correct number.")

	fmt.Println("Please select difficulty level:")
	fmt.Println("1. Easy (10 chances)")
	fmt.Println("2. Medium (5 chances)")
	fmt.Println("3. Hard (3 chances)")

	var ch, chances int
	fmt.Println("Enter your choices: ")
	_, err := fmt.Scanln(&ch)
	if err != nil {
		fmt.Println("Error reading input:", err)
		return
	}
	if ch == 1 {
		fmt.Println("Great! You have selected the Easy difficulty level.")
	} else if ch == 2 {
		fmt.Println("Great! You have selected the Medium difficulty level.")
	} else {
		fmt.Println("Great! You have selected the Hard difficulty level.")
	}

	fmt.Println("Let's start the game!")

	var guessNo int
	for chances > 0 {
		fmt.Println("Enter your guess:")
		_, err := fmt.Scanln(&guessNo)
		if err != nil {
			fmt.Println("Error reading input:", err)
			return
		}

		if guessNo < 50 {

		}

	}
}
