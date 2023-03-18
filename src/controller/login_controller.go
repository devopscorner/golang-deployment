package controller

import (
	"errors"
	"time"

	"github.com/devopscorner/golang-deployment/src/config"
	"github.com/devopscorner/golang-deployment/src/view"
	"github.com/gin-gonic/gin"
	validator "github.com/go-playground/validator/v10"
	jwt "github.com/golang-jwt/jwt"
	"github.com/spf13/viper"
)

type LoginRequest struct {
	Username string `json:"username" binding:"required"`
	Password string `json:"password" binding:"required"`
}

var loginRequest LoginRequest

func LoginUser(ctx *gin.Context) {
	if err := ctx.BindJSON(&loginRequest); err != nil {
		view.ErrorBadRequest(ctx, err)
		return
	}

	validate := validator.New()
	if err := validate.Struct(loginRequest); err != nil {
		view.ErrorBadRequest(ctx, err)
		return
	}

	validCred := ValidateCredentials(loginRequest.Username, loginRequest.Password)
	if loginRequest.Username != validCred.username ||
		loginRequest.Password != viper.GetString("JWT_AUTH_PASSWORD") {
		view.ErrorInvalidCredentials(ctx)
		return
	}

	token, err := CreateToken(viper.GetString("JWT_SECRET"), viper.GetString("JWT_AUTH_USERNAME"))
	if err != nil {
		view.ErrorInternalServer(ctx, err)
		return
	}

	view.LoginToken(ctx, token)
}

func CreateToken(secret string, issuer string) (string, error) {
	// Set the expiration time to 1 hour from now
	expirationTime := time.Now().Add(time.Hour * 1).Unix()

	// Create the JWT claims
	claims := jwt.StandardClaims{
		Issuer:    config.JWTIssuer(),
		ExpiresAt: expirationTime,
	}

	// Create the JWT token with the claims and secret
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString([]byte(config.JWTSecret()))
	if err != nil {
		return "", errors.New("Failed to generate token")
	}

	return tokenString, nil
}

func ValidateCredentials(username string, password string) bool {
	return username == viper.GetString("JWT_AUTH_USERNAME") && password == viper.GetString("JWT_AUTH_PASSWORD")
}
