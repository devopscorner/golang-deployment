package main

import (
	"github.com/devopscorner/golang-deployment/src/routes"
	"github.com/gin-gonic/gin"
)

func main() {
	router := gin.Default()
	routes.SetupRoutes(router)
}
