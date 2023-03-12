package controller

import (
	"net/http"
	"strconv"

	"github.com/devopscorner/golang-deployment/src/model"
	"github.com/devopscorner/golang-deployment/src/repository"
	"github.com/gin-gonic/gin"
	validator "github.com/go-playground/validator/v10"
)

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

// GET /books
// Find all books
func GetAllBooks(ctx *gin.Context) {
	books := repository.GetAll()
	ctx.JSON(http.StatusOK, gin.H{"data": books})
}

// GET /books/:id
// Find a book
func GetBookByID(ctx *gin.Context) {
	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid book ID"})
		return
	}

	book, err := repository.GetByID(strconv.Itoa(id))
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	if book == nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": "Book not found!"})
		return
	}
	ctx.JSON(http.StatusOK, gin.H{"data": book})
}

// POST /books
// Create new book
func CreateBook(ctx *gin.Context) {
	// Validate input
	var input CreateBookInput
	if err := ctx.ShouldBindJSON(&input); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	book := model.Book{Title: input.Title, Author: input.Author, Year: input.Year}

	validate := validator.New()
	if err := validate.Struct(book); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	err := repository.Create(&book)
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	ctx.JSON(http.StatusCreated, gin.H{"data": book})
}

// PUT /books/:id
// Update a book
func UpdateBook(ctx *gin.Context) {
	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid book ID"})
		return
	}

	book, err := repository.GetByID(strconv.Itoa(id))
	if err != nil {
		ctx.JSON(http.StatusNotFound, gin.H{"error": "Book not found!"})
		return
	}

	if err := ctx.ShouldBindJSON(&book); err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
		return
	}

	if err := repository.Update(book); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update book"})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"data": book})
}

// DELETE /books/:id
// Delete a book
func DeleteBook(ctx *gin.Context) {
	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid book ID"})
		return
	}

	if err := repository.Delete(strconv.Itoa(id)); err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete book"})
		return
	}

	ctx.JSON(http.StatusOK, gin.H{"data": true})
}
