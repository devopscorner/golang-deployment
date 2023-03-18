package controller

import (
	"strconv"

	"github.com/devopscorner/golang-deployment/src/model"
	"github.com/devopscorner/golang-deployment/src/repository"
	"github.com/devopscorner/golang-deployment/src/view"
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
	view.ViewGetAllBooks(ctx, books)
}

// GET /books/:id
// Find a book
func GetBookByID(ctx *gin.Context) {
	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		view.ErrorInvalidId(ctx)
		return
	}

	book, err := repository.GetByID(strconv.Itoa(id))
	if err != nil {
		view.ErrorInternalServer(ctx, err)
		return
	}
	if book == nil {
		view.ErrorNotFound(ctx)
		return
	}
	view.ViewGetBookByID(ctx, book)
}

// POST /books
// Create new book
func CreateBook(ctx *gin.Context) {
	// Validate input
	var input CreateBookInput
	if err := ctx.ShouldBindJSON(&input); err != nil {
		view.ErrorBadRequest(ctx, err)
		return
	}

	book := model.Book{Title: input.Title, Author: input.Author, Year: input.Year}

	validate := validator.New()
	if err := validate.Struct(book); err != nil {
		view.ErrorBadRequest(ctx, err)
		return
	}

	err := repository.Create(&book)
	if err != nil {
		view.ErrorInternalServer(ctx, err)
		return
	}
	view.ViewCreateBook(ctx, book)
}

// PUT /books/:id
// Update a book
func UpdateBook(ctx *gin.Context) {
	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		view.ErrorInvalidId(ctx)
		return
	}

	book, err := repository.GetByID(strconv.Itoa(id))
	if err != nil {
		view.ErrorNotFound(ctx)
		return
	}

	if err := ctx.ShouldBindJSON(&book); err != nil {
		view.ErrorInvalidRequest(ctx)
		return
	}

	if err := repository.Update(book); err != nil {
		view.ErrorUpdate(ctx)
		return
	}

	view.ViewUpdateBook(ctx, book)
}

// DELETE /books/:id
// Delete a book
func DeleteBook(ctx *gin.Context) {
	id, err := strconv.Atoi(ctx.Param("id"))
	if err != nil {
		view.ErrorInvalidId(ctx)
		return
	}

	if err := repository.Delete(strconv.Itoa(id)); err != nil {
		view.ErrorDelete(ctx)
		return
	}

	view.ViewDeleteBook(ctx)
}
