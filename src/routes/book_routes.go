package routes

import (
	"fmt"
	"net/http"

	"github.com/devopscorner/golang-deployment/src/config"
	"github.com/devopscorner/golang-deployment/src/controller"
	"github.com/devopscorner/golang-deployment/src/driver"
	"github.com/devopscorner/golang-deployment/src/middleware"
	"github.com/gin-gonic/gin"
)

func SetupRoutes(router *gin.Engine) {
	// Load Config
	config.LoadConfig()

	// Connect to database
	driver.ConnectDatabase()

	// Routes Healthcheck
	router.GET("/health", func(c *gin.Context) {
		c.String(http.StatusOK, "OK")
	})
	// Routes Welcome
	router.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "Welcome to Simple API Bookstore!")
	})

	// Login route to create basic auth JWT token
	router.POST("/v1/login", controller.LoginUser)

	api := router.Group("/v1", middleware.AuthMiddleware())
	{
		// Book routes
		api.GET("/books", controller.GetAllBooks)
		api.GET("/books/:id", controller.GetBookByID)
		api.POST("/books", controller.CreateBook)
		api.PUT("/books/:id", controller.UpdateBook)
		api.DELETE("/books/:id", controller.DeleteBook)
	}

	// Run the server
	port := fmt.Sprintf(":%v", config.AppPort())
	router.Run(port)
}
