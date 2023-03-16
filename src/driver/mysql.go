package driver

import (
	"log"

	"github.com/devopscorner/golang-deployment/src/config"
	"github.com/devopscorner/golang-deployment/src/model"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var DB_MySQL *gorm.DB

func ConnectMySQL() {
	_, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("error loading config: %v", err)
	}

	// References:
	// https://gorm.io/docs/connecting_to_the_database.html

	// Simple Connection
	dsn := "user:pass@tcp(" + config.DbHost() + ":" + config.DbPort() + ")/" + config.DbDatabase() + "?charset=utf8mb4&parseTime=True&loc=Local"
	database, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})

	// Advanced Connection
	// dsn := "gorm:gorm@tcp(" + config.DbHost() + ":" + config.DbPort() + ")/" + config.DbDatabase() + "?charset=utf8&parseTime=True&loc=Local"
	// database, err := gorm.Open(mysql.New(mysql.Config{
	// 	DSN:                       dsn,   // data source name
	// 	DefaultStringSize:         256,   // default size for string fields
	// 	DisableDatetimePrecision:  true,  // disable datetime precision, which not supported before MySQL 5.6
	// 	DontSupportRenameIndex:    true,  // drop & create when rename index, rename index not supported before MySQL 5.7, MariaDB
	// 	DontSupportRenameColumn:   true,  // `change` when rename column, rename column not supported before MySQL 8, MariaDB
	// 	SkipInitializeWithVersion: false, // auto configure based on currently MySQL version
	// }), &gorm.Config{})

	if err != nil {
		panic("Failed to connect to SQLite!")
	}

	// Migrate the schema
	database.AutoMigrate(&model.Book{})
	DB_MySQL = database
}
