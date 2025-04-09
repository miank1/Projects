package main

import (
	"fmt"
	"math/rand"
	"time"
)

func main() {

	fmt.Println("Welcome to the Number Guessing Game!")
	fmt.Println("I'm thinking of a number between 1 and 100.")
	time.Now().UnixNano()

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
		chances = 10
	} else if ch == 2 {
		fmt.Println("Great! You have selected the Medium difficulty level.")
		chances = 5
	} else {
		fmt.Println("Great! You have selected the Hard difficulty level.")
		chances = 3
	}

	fmt.Println("Let's start the game!")

	var guessNo, attemptUsed int

	for chances > 0 {
		fmt.Println("Enter your guess:")
		_, err := fmt.Scanln(&guessNo)
		if err != nil {
			fmt.Println("Error reading input:", err)
			return
		}

		attemptUsed++

		if guessNo == randomNumber {
			fmt.Printf("Congratulations! You guessed the correct number in %d attempts. \n", chances)
			break
		} else if guessNo < randomNumber {
			fmt.Printf("Incorrect! The number is greater than %d. \n", guessNo)
		} else {
			fmt.Printf("Incorrect! The number is less than %d. \n", guessNo)
		}
		chances--
	}

	if guessNo != randomNumber {
		fmt.Printf("😢 You've used all attempts. The correct number was %d.\n", randomNumber)
	}

}
