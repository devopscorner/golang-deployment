package view

import (
	"net/http"

	"github.com/devopscorner/golang-deployment/src/model"
	"github.com/gin-gonic/gin"
)

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
