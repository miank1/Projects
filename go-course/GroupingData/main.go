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
	var slice1 = []int{42, 43, 44, 45, 46, 47, 48, 49, 50, 51}

	for i, x := range slice1 {
		fmt.Println(i, "-->", x)
	}

	fmt.Println("Slice creation using composite literal")
	slice2 := []int{1, 2, 3, 4, 5}

	for i, x := range slice2 {
		fmt.Println(i, "-->", x)
	}
	fmt.Printf("slice type is %T\n", slice2)

	// Now create a slice out of the slice
	fmt.Println(slice1[:5])
	fmt.Println(slice1[5:])
	fmt.Println(slice1[2:7])
	fmt.Println(slice1[1:6])
	fmt.Println(slice1)

	// Append the slice
	slice1 = append(slice1, 52)
	fmt.Println(slice1)
	slice1 = append(slice1, 53, 54, 55)
	fmt.Println(slice1)
	y := []int{56, 57, 58, 59, 60}
	// Appending the slice with new slice
	slice1 = append(slice1, y...)
	fmt.Println(slice1)

	x := []int{42, 43, 44, 45, 46, 47, 48, 49, 50, 51}
	x = append(x[:3], x[6:]...)
	fmt.Println(x)

	// Map -Key string value - slice literal
	m1 := map[string][]string{
		`bond_james`: []string{`Shaken, not stirred`, `Martinis`, `Women`},
		`money_miss`: []string{`James_Bond`, `Literature`, `Computer Science`},
	}

	fmt.Println(m1)

	for k, v := range m1 {
		fmt.Println("This is the record for ", k)
		for i, v2 := range v {
			fmt.Println("\t", i, v2)
		}
	}

	m1[`HelloWorld`] = []string{`Hello`, `World`}

	for k, v := range m1 {
		fmt.Println("This is the record for ", k)
		for i, v2 := range v {
			fmt.Println("\t", i, v2)
		}
	}

	delete(m1, `HelloWorld`)
	for k, v := range m1 {
		fmt.Println("This is the record for ", k)
		for i, v2 := range v {
			fmt.Println("\t", i, v2)
		}
	}
}
