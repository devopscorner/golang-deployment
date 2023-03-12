package repository

import (
	"github.com/devopscorner/golang-deployment/src/config"
	"github.com/devopscorner/golang-deployment/src/model"
	"gorm.io/gorm"
)

type BookRepository interface {
	GetAll() ([]model.Book, error)
	GetByID(id string) (*model.Book, error)
	Create(book *model.Book) error
	Update(book *model.Book) error
	Delete(id string) error
}

type bookRepository struct {
	cfg *config.Config
	db  *gorm.DB
}

func NewBookRepository(cfg *config.Config, db *gorm.DB) *bookRepository {
	return &bookRepository{
		cfg: cfg,
		db:  db,
	}
}

func (r *bookRepository) GetAll() ([]model.Book, error) {
	var books []model.Book
	err := r.db.Find(&books)
	if err != nil {
		return nil, gorm.ErrRecordNotFound
	}
	return books, nil
}

func (r *bookRepository) GetByID(id string) (*model.Book, error) {
	var book model.Book
	err := r.db.First(&book, id).Error
	if err != nil {
		if err == gorm.ErrRecordNotFound {
			return nil, nil
		}
		return nil, err
	}
	return &book, nil
}

func (r *bookRepository) Create(book *model.Book) error {
	err := r.db.Create(&book)
	if err != nil {
		return gorm.ErrInvalidValue
	}
	return nil
}

func (r *bookRepository) Update(book *model.Book) error {
	err := r.db.Save(&book)
	if err != nil {
		return gorm.ErrInvalidValue
	}
	return nil
}

func (r *bookRepository) Delete(id string) error {
	err := r.db.Delete(&model.Book{}, id)
	if err != nil {
		return gorm.ErrInvalidValue
	}
	return nil
}
