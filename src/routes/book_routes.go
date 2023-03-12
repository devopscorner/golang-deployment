package routes

import (
	"fmt"
	"net/http"

	"github.com/devopscorner/golang-deployment/src/config"
	"github.com/devopscorner/golang-deployment/src/controller"
	"github.com/devopscorner/golang-deployment/src/driver"
	"github.com/gin-gonic/gin"
	validator "github.com/go-playground/validator/v10"
	"github.com/spf13/viper"
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
	router.POST("/login", func(c *gin.Context) {
		var loginRequest controller.LoginRequest
		if err := c.BindJSON(&loginRequest); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		validate := validator.New()
		if err := validate.Struct(loginRequest); err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		if loginRequest.Username != viper.GetString("AUTH_USERNAME") ||
			loginRequest.Password != viper.GetString("AUTH_PASSWORD") {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
			return
		}

		token, err := controller.CreateToken(viper.GetString("JWT_SECRET"), viper.GetString("AUTH_USERNAME"))
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, gin.H{"token": token})
	})

	api := router.Group("/v1")
	{
		// Book routes
		api.GET("/books", controller.GetAllBooks)
		api.GET("/books/:id", controller.GetBookByID)
		api.POST("/books", controller.CreateBook)
		api.PUT("/books/:id", controller.UpdateBook)
		api.DELETE("/books/:id", controller.DeleteBook)

	}

	// Run the server
	port := fmt.Sprintf(":%v", config.Port())
	router.Run(port)
}
