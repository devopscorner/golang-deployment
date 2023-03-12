package routes

import (
	"fmt"
	"log"
	"net/http"

	"github.com/devopscorner/golang-deployment/src/config"
	"github.com/devopscorner/golang-deployment/src/controller"
	"github.com/devopscorner/golang-deployment/src/middleware"
	"github.com/devopscorner/golang-deployment/src/model"
	"github.com/devopscorner/golang-deployment/src/repository"
	"github.com/gin-gonic/gin"
	validator "github.com/go-playground/validator/v10"
	"gorm.io/gorm"
)

var db *gorm.DB

func SetupRoutes(router *gin.Engine) {
	cfg, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("error loading config: %v", err)
	}

	// Connect to database
	model.ConnectDatabase()

	bookRepo := repository.NewBookRepository(cfg, db)
	bookCtrl := controller.NewBookController(bookRepo)

	// Routes Healthcheck
	router.GET("/health", func(c *gin.Context) {
		c.String(http.StatusOK, "OK")
	})
	// Routes Welcome
	router.GET("/", func(c *gin.Context) {
		c.String(http.StatusOK, "Welcome to Simple API Bookstore!")
	})
	// Routes Login
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

		if !controller.ValidateCredentials(loginRequest.Username, loginRequest.Password) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": "Invalid credentials"})
			return
		}

		token, err := controller.CreateToken()
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}

		c.JSON(http.StatusOK, gin.H{"token": token})
	})

	auth := router.Group("/v1", middleware.AuthMiddleware())
	{
		auth.GET("/books", bookCtrl.GetAllBooks)
		auth.GET("/books/:id", bookCtrl.GetBookByID)
		auth.POST("/books", bookCtrl.CreateBook)
		auth.PUT("/books/:id", bookCtrl.UpdateBook)
		auth.DELETE("/books/:id", bookCtrl.DeleteBook)
	}

	// Run the server
	port := fmt.Sprintf(":%v", config.Port())
	router.Run(port)

	if err != nil {
		log.Fatalf("error running server: %v", err)
	}
}
