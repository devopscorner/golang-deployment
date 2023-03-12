package middleware

import (
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/devopscorner/golang-deployment/src/config"
	"github.com/devopscorner/golang-deployment/src/middleware"
	"github.com/gin-gonic/gin"
	jwt "github.com/golang-jwt/jwt"
	"github.com/stretchr/testify/assert"
)

func TestAuthMiddleware(t *testing.T) {
	gin.SetMode(gin.TestMode)

	w := httptest.NewRecorder()
	c, r := gin.CreateTestContext(w)

	r.GET("/v1/books", middleware.AuthMiddleware(), func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{})
	})

	c.Request, _ = http.NewRequest(http.MethodGet, "/v1/books", nil)
	c.Request.Header.Set("Authorization", "Bearer "+generateToken())

	r.ServeHTTP(w, c.Request)

	assert.Equal(t, http.StatusOK, w.Code)
}

func generateToken() string {
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"user_id": "123",
	})
	tokenString, _ := token.SignedString([]byte(config.JWTSecret()))
	return tokenString
}
