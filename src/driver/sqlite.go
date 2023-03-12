package driver

import (
	"log"

	"github.com/devopscorner/golang-deployment/src/config"
	"github.com/devopscorner/golang-deployment/src/model"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

var DB *gorm.DB

func ConnectDatabase() {
	_, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("error loading config: %v", err)
	}

	database, err := gorm.Open(sqlite.Open(config.DbName()), &gorm.Config{})

	if err != nil {
		panic("Failed to connect to database!")
	}

	// Migrate the schema
	database.AutoMigrate(&model.Book{})

	DB = database
}
