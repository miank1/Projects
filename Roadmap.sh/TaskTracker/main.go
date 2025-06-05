package main

import (
	"fmt"
	"os"
)

type Tasks struct {
	list []string
}

const fileName = "tasks.json"

func main() {

	//tasks := Tasks{}
	var list []string

	for {

		if len(os.Args) < 2 {
			fmt.Println("Usage: task-cli <command> [arguments]")
			return
		}

		cmd := os.Args[1]

		switch cmd {
		case "add":
			if len(os.Args) < 3 {
				fmt.Println("Usage: task-cli add <task description>")
				return
			}
			description := os.Args[2]
			list = append(list, description)

		case "update":
			if len(os.Args) < 3 {
				fmt.Println("Usage: task-cli add <task description>")
				return
			}
			id := os.Args[2]
			newDescription := os.Args[3]

			list = append(list, newDescription)

		}

	}
}
