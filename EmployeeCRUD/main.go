package main

import (
	"fmt"
	"net/http"
	"strconv"
	"sync"

	"github.com/gin-gonic/gin"
)

var router *gin.Engine
var mu sync.RWMutex

type Employee struct {
	ID       int
	Name     string
	Position string
	Salary   float64
}

// EmpData manages employees in memory - map.
type EmpData struct {
	employees map[int]Employee
}

// NewEmployeeStore creates a new employee.
func NewEmployee() *EmpData {
	return &EmpData{
		employees: make(map[int]Employee),
	}
}

// Initialize the employee
var emp = NewEmployee()

func (e *EmpData) CreateEmployee(emp Employee) {
	mu.Lock()
	defer mu.Unlock()
	fmt.Println("Employee is ", emp)
	e.employees[emp.ID] = emp
}

func (e *EmpData) GetEmployeeByID(id int) (Employee, bool) {
	mu.Lock()
	defer mu.Unlock()

	emp, ok := e.employees[id]
	return emp, ok

}

func (e *EmpData) UpdateEmployee(id int, emp Employee) bool {
	mu.Lock()
	defer mu.Unlock()

	_, ok := e.employees[id]
	if !ok {
		return false
	}
	e.employees[id] = emp
	return true
}

func (e *EmpData) DeleteEmployee(id int) bool {
	mu.Lock()
	defer mu.Unlock()

	_, ok := e.employees[id]
	if !ok {
		return false
	}

	delete(e.employees, id)
	return true
}

// CreateEmployeeHandler handles the POST request to create a new employee.
func CreateEmployeeHandler(c *gin.Context) {
	var employee Employee
	if err := c.ShouldBindJSON(&employee); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	emp.CreateEmployee(employee)
	c.Status(http.StatusCreated)
}

// UpdateEmployeeHandler handles the PUT request to update an existing employee.
func UpdateEmployeeHandler(c *gin.Context) {
	id, _ := strconv.Atoi(c.Param("id"))

	var updatedEmployee Employee
	if err := c.ShouldBindJSON(&updatedEmployee); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	if !emp.UpdateEmployee(id, updatedEmployee) {
		c.JSON(http.StatusNotFound, gin.H{"error": "Employee not found"})
		return
	}

	c.Status(http.StatusOK)
}

// DeleteEmployeeHandler handles the DELETE request to delete an existing employee.
func DeleteEmployeeHandler(c *gin.Context) {
	id, _ := strconv.Atoi(c.Param("id"))

	if !emp.DeleteEmployee(id) {
		c.JSON(http.StatusNotFound, gin.H{"error": "Employee not found"})
		return
	}

	c.Status(http.StatusOK)
}

// ListEmployees returns a slice of employees with pagination.
func (s *EmpData) ListEmployees(page, pageSize int) []Employee {
	start := (page - 1) * pageSize
	end := page * pageSize
	if end > len(s.employees) {
		end = len(s.employees)
	}
	employees := make([]Employee, 0, pageSize)
	for _, employee := range s.employees {
		employees = append(employees, employee)
	}
	if start > len(employees) {
		start = len(employees)
	}
	return employees[start:end]
}

func ListEmployeesHandler(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	pageSize, _ := strconv.Atoi(c.DefaultQuery("pageSize", "10"))

	employees := emp.ListEmployees(page, pageSize)

	c.JSON(http.StatusOK, employees)
}

func main() {

	router = gin.Default()

	router.POST("employee", CreateEmployeeHandler)
	router.PUT("employee/:id", UpdateEmployeeHandler)
	router.DELETE("/employee/:id", DeleteEmployeeHandler)
	router.GET("employee", ListEmployeesHandler)

	router.Run("localhost:8080")
}
