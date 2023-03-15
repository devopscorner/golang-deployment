package controller

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/devopscorner/golang-deployment/src/config"
	"github.com/devopscorner/golang-deployment/src/model"
	"github.com/devopscorner/golang-deployment/src/routes"
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

var (
	routerBook *gin.Engine
)

func TestBookController_Main() {
	gin.SetMode(gin.TestMode)
	config.LoadConfig()
	routerBook = gin.Default()
	routes.SetupRoutes(routerBook)
}

func TestBookController_GetAllBooks(t *testing.T) {
	// Set up the test request
	req, _ := http.NewRequest(http.MethodGet, "/v1/books", nil)

	// Make the request to the test server
	w := httptest.NewRecorder()
	routerBook.ServeHTTP(w, req)

	// Check the response code and body
	assert.Equal(t, http.StatusOK, w.Code)

	var books []model.Book
	err := json.Unmarshal(w.Body.Bytes(), &books)
	assert.NoError(t, err)

	assert.NotEmpty(t, books)
}

func TestBookController_GetBookByID(t *testing.T) {
	// Set up the test request
	req, _ := http.NewRequest(http.MethodGet, "/v1/books/1", nil)

	// Make the request to the test server
	w := httptest.NewRecorder()
	routerBook.ServeHTTP(w, req)

	// Check the response code and body
	assert.Equal(t, http.StatusOK, w.Code)

	var book model.Book
	err := json.Unmarshal(w.Body.Bytes(), &book)
	assert.NoError(t, err)

	assert.Equal(t, uint(1), book.ID)
	assert.Equal(t, "Test Book", book.Title)
	assert.Equal(t, "Test Author", book.Author)
	assert.Equal(t, 2021, book.Year)
}

func TestBookController_CreateBook(t *testing.T) {
	// Set up the test request
	book := model.Book{Title: "Test Book", Author: "Test Author", Year: 2021}
	jsonBook, _ := json.Marshal(book)
	req, _ := http.NewRequest(http.MethodPost, "/v1/books", bytes.NewBuffer(jsonBook))
	req.Header.Set("Content-Type", "application/json")

	// Make the request to the test server
	w := httptest.NewRecorder()
	routerBook.ServeHTTP(w, req)

	// Check the response code and body
	assert.Equal(t, http.StatusCreated, w.Code)

	var createdBook model.Book
	err := json.Unmarshal(w.Body.Bytes(), &createdBook)
	assert.NoError(t, err)

	assert.Equal(t, book.Title, createdBook.Title)
	assert.Equal(t, book.Author, createdBook.Author)
	assert.Equal(t, book.Year, createdBook.Year)
}

func TestBookController_UpdateBook(t *testing.T) {
	// Set up the test request
	book := model.Book{Title: "New Test Book", Author: "New Test Author", Year: 2022}
	jsonBook, _ := json.Marshal(book)
	req, _ := http.NewRequest(http.MethodPut, "/v1/books/1", bytes.NewBuffer(jsonBook))
	req.Header.Set("Content-Type", "application/json")

	// Make the request to the test server
	w := httptest.NewRecorder()
	routerBook.ServeHTTP(w, req)

	// Check the response code and body
	assert.Equal(t, http.StatusOK, w.Code)

	var updatedBook model.Book
	err := json.Unmarshal(w.Body.Bytes(), &updatedBook)
	assert.NoError(t, err)

	assert.Equal(t, uint(1), updatedBook.ID)
	assert.Equal(t, "New Test Book", updatedBook.Title)
	assert.Equal(t, "New Test Author", updatedBook.Author)
	assert.Equal(t, 2022, updatedBook.Year)
}

func TestBookController_DeleteBook(t *testing.T) {
	// Set up the test request
	req, _ := http.NewRequest(http.MethodDelete, "/v1/books/1", nil)

	// Make the request to the test server
	w := httptest.NewRecorder()
	routerBook.ServeHTTP(w, req)

	// Check the response code and body
	assert.Equal(t, http.StatusOK, w.Code)

	var deletedBook model.Book
	err := json.Unmarshal(w.Body.Bytes(), &deletedBook)
	assert.NoError(t, err)

	assert.Equal(t, uint(1), deletedBook.ID)
	assert.Equal(t, "New Test Book", deletedBook.Title)
	assert.Equal(t, "New Test Author", deletedBook.Author)
	assert.Equal(t, 2022, deletedBook.Year)
}
