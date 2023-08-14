package main

import "fmt"

type person struct {
	firstName  string
	lastName   string
	favFlaours []string
}

func main() {
	p1 := person{firstName: "John", lastName: "Mark", favFlaours: []string{
		"Plain Vanila",
		"Choclate IceCream",
	}}
	fmt.Println(p1)
	fmt.Printf("%#v", p1)
}
