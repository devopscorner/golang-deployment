package model

import (
	"log"

	"github.com/devopscorner/golang-deployment/src/config"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

func ConnectDatabase() {
	_, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("error loading config: %v", err)
	}

	database, err := gorm.Open(sqlite.Open(config.DbName()), &gorm.Config{})

	if err != nil {
		panic("Failed to connect to database!")
	}

	database.AutoMigrate(&Book{})
}
