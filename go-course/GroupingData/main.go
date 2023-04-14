package main

import "fmt"

func main() {

	// create an array
	var arr [5]int
	arr[0] = 1
	arr[1] = 2
	arr[2] = 3
	arr[3] = 4
	arr[4] = 5

	for i, x := range arr {
		fmt.Println(i, "-->", x)
	}
	fmt.Println("Array creation using composite literal")
	arr1 := [5]int{1, 2, 3, 4, 5}

	for i, x := range arr1 {
		fmt.Println(i, "-->", x)
	}
	fmt.Printf("array type is %T\n", arr)

	// create a slice
	var slice1 = []int{1, 2, 3, 4, 5}

	for i, x := range slice1 {
		fmt.Println(i, "-->", x)
	}

	fmt.Println("Slice creation using composite literal")
	slice2 := []int{1, 2, 3, 4, 5}

	for i, x := range slice2 {
		fmt.Println(i, "-->", x)
	}
	fmt.Printf("slice type is %T\n", slice2)
}
