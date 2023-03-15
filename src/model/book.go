package model

import "gorm.io/gorm"

// --------------------------------------
// SQLite, MySQL, Postgres
// --------------------------------------
// ORM: gorm.io/gorm
//      gorm.io/driver/sqlite

type Book struct {
	gorm.Model
	Title  string `json:"title" validate:"required"`
	Author string `json:"author" validate:"required"`
	Year   string `json:"year" validate:"required"`
}

// import "github.com/guregu/dynamo"

// --------------------------------------
// DynamoDB
// --------------------------------------
// ORM: github.com/guregu/dynamo

// type Book struct {
// 	ID     string `dynamo:"id"`
// 	Title  string `dynamo:"title" validate:"required"`
// 	Author string `dynamo:"author" validate:"required"`
// 	Year   string `dynamo:"year" validate:"required"`
// }
