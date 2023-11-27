package main

import (
	"encoding/csv"
	"fmt"
	"os"
	"strings"
)

// Permission represents the include and exclude permissions for a distributor
type Permission struct {
	Include []string
	Exclude []string
}

// Distributor represents a distributor with its permissions
type Distributor struct {
	Name       string
	Permission Permission
}

// ReadPermissions reads the CSV file and returns a map of distributors and their permissions
func ReadPermissions(filename string) (map[string]Permission, error) {
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

	permissions := make(map[string]Permission)

	for _, line := range lines {
		distributor := line[0]
		include := strings.Split(line[1], "-")
		exclude := strings.Split(line[2], "-")

		permissions[distributor] = Permission{Include: include, Exclude: exclude}
	}

	return permissions, nil
}

// HasPermission checks if a distributor has permission to distribute in a given region
func HasPermission(distributor Distributor, region []string) bool {
	for _, excl := range distributor.Permission.Exclude {
		if contains(region, excl) {
			return false
		}
	}

	for _, incl := range distributor.Permission.Include {
		if !contains(region, incl) {
			return false
		}
	}

	return true
}

// contains checks if a string is present in a slice of strings
func contains(slice []string, s string) bool {
	for _, elem := range slice {
		if elem == s {
			return true
		}
	}
	return false
}

func main() {
	// Replace "permissions.csv" with the actual CSV file name
	permissions, err := ReadPermissions("cities.csv")
	if err != nil {
		fmt.Println("Error reading permissions:", err)
		return
	}

	// Example distributors
	distributor1 := Distributor{Name: "DISTRIBUTOR1", Permission: permissions["DISTRIBUTOR1"]}
	distributor2 := Distributor{Name: "DISTRIBUTOR2", Permission: permissions["DISTRIBUTOR2"]}
	distributor3 := Distributor{Name: "DISTRIBUTOR3", Permission: permissions["DISTRIBUTOR3"]}

	// Example regions
	chicago := []string{"CHICAGO", "ILLINOIS", "UNITEDSTATES"}
	chennai := []string{"CHENNAI", "TAMILNADU", "INDIA"}
	bangalore := []string{"BANGALORE", "KARNATAKA", "INDIA"}
	hubli := []string{"HUBLI", "KARNATAKA", "INDIA"}

	// Check permissions
	fmt.Println("DISTRIBUTOR1 in CHICAGO-ILLINOIS-UNITEDSTATES:", HasPermission(distributor1, chicago))
	fmt.Println("DISTRIBUTOR1 in CHENNAI-TAMILNADU-INDIA:", HasPermission(distributor1, chennai))       
	fmt.Println("DISTRIBUTOR1 in BANGALORE-KARNATAKA-INDIA:", HasPermission(distributor1, bangalore))   

	fmt.Println("DISTRIBUTOR2 in CHICAGO-ILLINOIS-UNITEDSTATES:", HasPermission(distributor2, chicago)) 
	fmt.Println("DISTRIBUTOR2 in CHENNAI-TAMILNADU-INDIA:", HasPermission(distributor2, chennai))       
	fmt.Println("DISTRIBUTOR2 in BANGALORE-KARNATAKA-INDIA:", HasPermission(distributor2, bangalore))   
	fmt.Println("DISTRIBUTOR3 in HUBLI-KARNATAKA-INDIA:", HasPermission(distributor3, hubli))           
}
