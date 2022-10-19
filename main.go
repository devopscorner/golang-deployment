package main

import (
	"net/http"

	"github.com/devopscorner/golang-deployment/controllers"
	"github.com/devopscorner/golang-deployment/models"

	"github.com/gin-gonic/gin"
)

func main() {
	r := gin.Default()

	// Connect to database
	models.ConnectDatabase()

	// Routes
	r.GET("/health", func(c *gin.Context) {
		c.String(http.StatusOK, "OK")
	})
	r.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "Welcome to Simple API Bookstore!")
	})
	r.GET("/books", controllers.FindBooks)
	r.GET("/books/:id", controllers.FindBook)
	r.POST("/books", controllers.CreateBook)
	r.PATCH("/books/:id", controllers.UpdateBook)
	r.DELETE("/books/:id", controllers.DeleteBook)

	// Run the server
	r.Run(":8080")
}
