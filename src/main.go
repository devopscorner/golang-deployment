package main

import (
	"github.com/devopscorner/golang-deployment/src/routes"
	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()

	// Activate: Production Mode
	// gin.SetMode(gin.ReleaseMode)

	// Set Router
	routes.SetupRoutes(router)
}
