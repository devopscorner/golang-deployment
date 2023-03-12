package main

import (
	"fmt"
	"log"

	"github.com/devopscorner/golang-deployment/src/config"
	"github.com/devopscorner/golang-deployment/src/model"
	"gorm.io/gorm"
)

var DB *gorm.DB

func main() {
	_, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("error loading config: %v", err)
	}

	MigrateBook(DB)
	fmt.Println("Sample books created successfully!")
}

func MigrateBook(db *gorm.DB) error {
	if err := db.AutoMigrate(&model.Book{}); err != nil {
		return err
	}

	books := []model.Book{
		{
			Title:  "The Great Gatsby",
			Author: "F. Scott Fitzgerald",
			Year:   1925,
		},
		{
			Title:  "To Kill a Mockingbird",
			Author: "Harper Lee",
			Year:   1960,
		},
		{
			Title:  "1984",
			Author: "George Orwell",
			Year:   1949,
		},
	}

	for _, book := range books {
		if err := db.Create(&book).Error; err != nil {
			fmt.Println("Failed to insert data!")
			return err
		}
	}

	return nil
}
