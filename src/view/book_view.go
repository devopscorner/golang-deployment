package view

import (
	"net/http"

	"github.com/devopscorner/golang-deployment/src/model"
	"github.com/gin-gonic/gin"
)

// ----- Error Response -----

func ErrorBadRequest(ctx *gin.Context, err error) {
	ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
}

func ErrorInternalServer(ctx *gin.Context, err error) {
	ctx.JSON(http.StatusInternalServerError, gin.H{"error": err})
}

func ErrorInvalidId(ctx *gin.Context) {
	ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid book ID"})
}

func ErrorNotFound(ctx *gin.Context) {
	ctx.JSON(http.StatusNotFound, gin.H{"error": "Book not found!"})
}

func ErrorInvalidRequest(ctx *gin.Context) {
	ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request payload"})
}

func ErrorUpdate(ctx *gin.Context) {
	ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update book"})
}

func ErrorDelete(ctx *gin.Context) {
	ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete book"})
}

// ----- View Response -----

// GET /books
// Find all books
func ViewGetAllBooks(ctx *gin.Context, viewBooks []model.Book) {
	ctx.JSON(http.StatusOK, gin.H{"data": viewBooks})
}

// GET /books/:id
// Find a book
func ViewGetBookByID(ctx *gin.Context, viewBook *model.Book) {
	ctx.JSON(http.StatusOK, gin.H{"data": viewBook})
}

// POST /books
// Create new book
func ViewCreateBook(ctx *gin.Context, viewBook model.Book) {
	ctx.JSON(http.StatusCreated, gin.H{"data": viewBook})
}

// PUT /books/:id
// Update a book
func ViewUpdateBook(ctx *gin.Context, viewBook *model.Book) {
	ctx.JSON(http.StatusOK, gin.H{"data": viewBook})
}

// DELETE /books/:id
// Delete a book
func ViewDeleteBook(ctx *gin.Context) {
	ctx.JSON(http.StatusOK, gin.H{"data": true})
}
