package main

import "fmt"

func main() {

	d1 := deck{"1", "2"}
	fmt.Println(d1)
	cards := newDeck()
	hand, remainingDeck := deal(cards, 5)
	hand.print()
	remainingDeck.print()

}
