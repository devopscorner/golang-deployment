package driver

import (
	"log"

	"github.com/devopscorner/golang-deployment/src/config"
	"github.com/devopscorner/golang-deployment/src/model"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

var DB_PSQL *gorm.DB

func ConnectPSQL() {
	_, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("error loading config: %v", err)
	}

	// References:
	// https://gorm.io/docs/connecting_to_the_database.html
	DSN_HOST := "host=" + config.DbHost()
	DSN_PORT := "port=" + config.DbPort()
	DSN_USER := "user=" + config.DbUsername()
	DSN_PASSWORD := "user=" + config.DbPassword()
	DSN_DBNAME := "dbname=" + config.DbDatabase()

	dsn := DSN_HOST + " " + DSN_PORT + " " + DSN_USER + " " + DSN_PASSWORD + " " + DSN_DBNAME + "sslmode=disable TimeZone=Asia/Jakarta"

	database, err := gorm.Open(postgres.New(postgres.Config{
		DSN:                  dsn,
		PreferSimpleProtocol: true,
	}), &gorm.Config{})

	if err != nil {
		panic("Failed to connect to Postgres!")
	}

	// Migrate the schema
	database.AutoMigrate(&model.Book{})
	DB_PSQL = database
}
