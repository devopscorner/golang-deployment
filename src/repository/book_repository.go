package repository

import (
	"github.com/devopscorner/golang-deployment/src/config"
	"github.com/devopscorner/golang-deployment/src/driver"
	"github.com/devopscorner/golang-deployment/src/model"
	"github.com/guregu/dynamo"
	"gorm.io/gorm"
)

func init() {
	// Connect to database
	driver.ConnectDatabase()
}

func GetAll() []model.Book {
	var books []model.Book

	if config.DbConnection() == "dynamo" {
		driver.DYN.Table(config.DbDatabase()).Scan().All(&books)
	} else {
		driver.DB.Find(&books)
	}

	return books
}

func GetByID(id string) (*model.Book, error) {
	var book model.Book

	if config.DbConnection() == "dynamo" {
		err := driver.DYN.Table(config.DbDatabase()).Scan().Filter("'id' > ?", id).All(&book)
		if err != nil {
			if err == dynamo.ErrNotFound {
				return nil, nil
			}
			return nil, err
		}
	} else {
		err := driver.DB.First(&book, id).Error
		if err != nil {
			if err == gorm.ErrRecordNotFound {
				return nil, nil
			}
			return nil, err
		}
	}

	return &book, nil
}

func Create(book *model.Book) error {
	if config.DbConnection() == "dynamo" {
		// book.ID = fmt.Sprintf("%d", time.Now().UnixNano())
		return driver.DYN.Table(config.DbDatabase()).Put(book).Run()
	} else {
		return driver.DB.Create(&book).Error
	}
}

func Update(book *model.Book) error {
	if config.DbConnection() == "dynamo" {
		return driver.DYN.Table(config.DbDatabase()).Put(book).Run()
	} else {
		return driver.DB.Save(&book).Error
	}
}

func Delete(id string) error {
	if config.DbConnection() == "dynamo" {
		return driver.DYN.Table(config.DbDatabase()).Delete("id", id).Run()
	} else {
		return driver.DB.Delete(&model.Book{}, id).Error
	}
}
