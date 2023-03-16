package main

import (
	"log"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/devopscorner/golang-deployment/src/config"
	"github.com/devopscorner/golang-deployment/src/routes"
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

var (
	router *gin.Engine
)

func TestMain(m *testing.M) {
	gin.SetMode(gin.TestMode)

	_, err := config.LoadConfig()
	if err != nil {
		log.Fatalf("error loading config: %v", err)
	}

	router = gin.Default()

	routes.SetupRoutes(router)

	w := httptest.NewRecorder()
	req, _ := http.NewRequest(http.MethodGet, "/v1/books", nil)
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
}

func TestBookstoreAPI(t *testing.T) {
	req, err := http.NewRequest(http.MethodGet, "/v1/books", nil)
	assert.NoError(t, err)

	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusUnauthorized, w.Code)

	req.Header.Set("Authorization", "Basic dGVzdHVzZXI6dGVzdHBhc3M=")
	w = httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
}
