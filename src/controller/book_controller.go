package controller

import (
	"net/http"

	"github.com/devopscorner/golang-deployment/src/model"
	"github.com/devopscorner/golang-deployment/src/repository"
	"github.com/gin-gonic/gin"
	validator "github.com/go-playground/validator/v10"
)

type BookController interface {
	GetAllBooks(ctx *gin.Context)
	GetBookByID(ctx *gin.Context)
	CreateBook(ctx *gin.Context)
	UpdateBook(ctx *gin.Context)
	DeleteBook(ctx *gin.Context)
}

type bookController struct {
	repo repository.BookRepository
}

type CreateBookInput struct {
	Title  string `json:"title" binding:"required"`
	Author string `json:"author" binding:"required"`
	Year   string `json:"year" binding:"required"`
}

type UpdateBookInput struct {
	Title  string `json:"title"`
	Author string `json:"author"`
	Year   string `json:"year"`
}

func NewBookController(repo repository.BookRepository) *bookController {
	return &bookController{
		repo: repo,
	}
}

// GET /books
// Find all books
func (c *bookController) GetAllBooks(ctx *gin.Context) {
	books, err := c.repo.GetAll()
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, books)
}

// GET /books/:id
// Find a book
func (c *bookController) GetBookByID(ctx *gin.Context) {
	id := ctx.Param("id")
	book, err := c.repo.GetByID(id)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	if book == nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": "book not found"})
		return
	}
	ctx.JSON(http.StatusOK, book)
}

// POST /books
// Create new book
func (c *bookController) CreateBook(ctx *gin.Context) {
	// Validate input
	var input CreateBookInput
	if err := ctx.ShouldBindJSON(&input); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	var book model.Book
	err := ctx.ShouldBindJSON(&book)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	validate := validator.New()
	if err := validate.Struct(book); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err = c.repo.Create(&book)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, book)
}

// PATCH /books/:id
// Update a book
func (c *bookController) UpdateBook(ctx *gin.Context) {
	id := ctx.Param("id")
	var book model.Book
	err := ctx.ShouldBindJSON(&book)
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	validate := validator.New()
	if err := validate.Struct(book); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	existingBook, err := c.repo.GetByID(id)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	if existingBook == nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": "book not found"})
		return
	}
	err = c.repo.Update(&book)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusOK, book)
}

// DELETE /books/:id
// Delete a book
func (c *bookController) DeleteBook(ctx *gin.Context) {
	id := ctx.Param("id")
	existingBook, err := c.repo.GetByID(id)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	if existingBook == nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": "book not found"})
		return
	}
	err = c.repo.Delete(id)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.Status(http.StatusOK)
}
