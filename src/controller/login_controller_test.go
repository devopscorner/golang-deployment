package controller

import (
	"bytes"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"

	"github.com/devopscorner/golang-deployment/src/config"
	"github.com/devopscorner/golang-deployment/src/controller"
	"github.com/devopscorner/golang-deployment/src/model"
	"github.com/devopscorner/golang-deployment/src/routes"
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
)

var (
	router *gin.Engine
)

func TestLoginController_Main() {
	gin.SetMode(gin.TestMode)
	config.Init()
	router = gin.Default()
	routes.SetupRoutes(router)
	code := m.Run()
	os.Exit(code)
}

func TestLoginController_CreateToken(t *testing.T) {
	// Set up the test request
	loginRequest := controller.LoginRequest{Username: "admin", Password: "password"}
	jsonRequest, _ := json.Marshal(loginRequest)
	req, _ := http.NewRequest(http.MethodPost, "/api/v1/login", bytes.NewBuffer(jsonRequest))
	req.Header.Set("Content-Type", "application/json")

	// Make the request to the test server
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	// Check the response code and body
	assert.Equal(t, http.StatusOK, w.Code)

	var responseBody map[string]string
	err := json.Unmarshal(w.Body.Bytes(), &responseBody)
	assert.NoError(t, err)

	assert.NotEmpty(t, responseBody["token"])
}
