package main

import (
	"fmt"
	"log"

	"github.com/devopscorner/golang-deployment/src/config"
	"github.com/devopscorner/golang-deployment/src/driver"
	"github.com/devopscorner/golang-deployment/src/model"
	"gorm.io/gorm"
)

func main() {
	_, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("error loading config: %v", err)
	}

	// Connect to database
	driver.ConnectDatabase()

	MigrateBook(driver.DB)
	fmt.Println("Sample books created successfully!")
}

func MigrateBook(db *gorm.DB) error {
	if err := db.AutoMigrate(&model.Book{}); err != nil {
		return err
	}

	books := []model.Book{
		{Title: "The Great Gatsby", Author: "F. Scott Fitzgerald", Year: "1925"},
		{Title: "To Kill a Mockingbird", Author: "Harper Lee", Year: "1960"},
		{Title: "1984", Author: "George Orwell", Year: "1949"},
		{Title: "Animal Farm", Author: "George Orwell", Year: "1945"},
		{Title: "The Catcher in the Rye", Author: "J.D. Salinger", Year: "1951"},
		{Title: "One Hundred Years of Solitude", Author: "Gabriel Garcia Marquez", Year: "1967"},
		{Title: "Moby-Dick", Author: "Herman Melville", Year: "1851"},
		{Title: "Pride and Prejudice", Author: "Jane Austen", Year: "1813"},
	}

	for _, book := range books {
		if err := db.Create(&book).Error; err != nil {
			fmt.Println("Failed to insert data!")
			return err
		}
	}

	return nil
}
