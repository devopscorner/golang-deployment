package repository

import (
	"github.com/devopscorner/golang-deployment/src/driver"
	"github.com/devopscorner/golang-deployment/src/model"
	"gorm.io/gorm"
)

func init() {
	// Connect to database
	driver.ConnectDatabase()
}

func GetAll() []model.Book {
	var books []model.Book
	driver.DB.Find(&books)
	return books
}

func GetByID(id string) (*model.Book, error) {
	var book model.Book
	err := driver.DB.First(&book, id).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, nil
		}
		return nil, err
	}
	return &book, nil
}

func Create(book *model.Book) error {
	return driver.DB.Create(&book).Error
}

func Update(book *model.Book) error {
	return driver.DB.Save(&book).Error
}

func Delete(id string) error {
	return driver.DB.Delete(&model.Book{}, id).Error
}
