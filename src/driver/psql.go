package driver

import (
	"log"

	"github.com/devopscorner/golang-deployment/src/config"
	"github.com/devopscorner/golang-deployment/src/model"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
)

var DB_PSQL *gorm.DB

func ConnectPSQL() {
	_, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("error loading config: %v", err)
	}

	database, err := gorm.Open(sqlite.Open(config.DbDatabase()), &gorm.Config{})

	if err != nil {
		panic("Failed to connect to SQLite!")
	}

	// Migrate the schema
	database.AutoMigrate(&model.Book{})
	DB_PSQL = database
}
