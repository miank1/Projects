package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strings"
)

// Permissions structure to store include and exclude regions
type Permissions struct {
	Include []string
	Exclude []string
}

// Distributor structure to store distributor permissions
type Distributor struct {
	Name        string
	Permissions Permissions
}

// LoadDistributors loads distributor permissions from a CSV file
func LoadDistributors(filename string) ([]Distributor, error) {
	var distributors []Distributor

	file, err := os.Open(filename)
	if err != nil {
		return nil, err
	}
	defer file.Close()

	reader := csv.NewReader(file)
	lines, err := reader.ReadAll()
	if err != nil {
		return nil, err
	}

	for _, line := range lines {
		if len(line) >= 3 {
			name := line[0]
			include := strings.Split(line[1], ";")
			exclude := strings.Split(line[2], ";")

			distributor := Distributor{
				Name: name,
				Permissions: Permissions{
					Include: include,
					Exclude: exclude,
				},
			}

			distributors = append(distributors, distributor)
		}
	}

	return distributors, nil
}

// HasPermission checks if a distributor has permission to distribute in a given region
func HasPermission(distributor Distributor, region string) bool {
	for _, excl := range distributor.Permissions.Exclude {
		if strings.HasPrefix(region, excl) {
			return false
		}
	}

	for _, incl := range distributor.Permissions.Include {
		if strings.HasPrefix(region, incl) {
			return true
		}
	}

	return false
}

func main() {
	distributors, err := LoadDistributors("cities.csv")
	if err != nil {
		fmt.Println("Error loading distributors:", err)
		return
	}

	for _, distributor := range distributors {
		fmt.Printf("Checking permissions for %s:\n", distributor.Name)
		fmt.Printf("  Can distribute in CHICAGO-ILLINOIS-UNITEDSTATES: %t\n", HasPermission(distributor, "CHICAGO-ILLINOIS-UNITEDSTATES"))
		fmt.Printf("  Can distribute in CHENNAI-TAMILNADU-INDIA: %t\n", HasPermission(distributor, "CHENNAI-TAMILNADU-INDIA"))
		fmt.Printf("  Can distribute in BANGALORE-KARNATAKA-INDIA: %t\n", HasPermission(distributor, "BANGALORE-KARNATAKA-INDIA"))
		fmt.Printf("  Can distribute in KANPUR-UTTAR PRADESH-INDIA: %t\n", HasPermission(distributor, "KANPUR-UTTAR PRADESH-INDIA"))
		fmt.Printf("  Can distribute in AUSTIN-TEXAS-UNITEDSTATES: %t\n", HasPermission(distributor, "AUSTIN-TEXAS-UNITEDSTATES"))
		fmt.Println()
	}
}
