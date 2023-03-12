package model

type Book struct {
	ID     uint   `json:"id" gorm:"primary_key"`
	Title  string `json:"title" validate:"required"`
	Author string `json:"author" validate:"required"`
	Year   int    `json:"year" validate:"required,gte=0"`
}
