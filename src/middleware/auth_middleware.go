package middleware

import (
	"errors"
	"fmt"
	"net/http"
	"strings"
	"time"

	"github.com/devopscorner/golang-deployment/src/config"
	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt"
	"github.com/spf13/viper"
)

func AuthMiddleware() gin.HandlerFunc {
	return func(ctx *gin.Context) {
		authHeader := ctx.GetHeader("Authorization")
		if authHeader == "" {
			ctx.JSON(http.StatusUnauthorized, gin.H{"error": config.ERR_MISSING_AUTH_HEADER})
			ctx.Abort()
			return
		}

		authHeaderParts := strings.Split(authHeader, " ")
		if len(authHeaderParts) != 2 || strings.ToLower(authHeaderParts[0]) != "bearer" {
			ctx.JSON(http.StatusUnauthorized, gin.H{"error": config.ERR_MISSING_AUTH_HEADER})
			ctx.Abort()
			return
		}

		tokenString := authHeaderParts[1]
		token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, fmt.Errorf("Unexpected signing method: %v", token.Header["alg"])
			}
			return []byte(config.JWTSecret()), nil
		})

		if err != nil {
			ctx.JSON(http.StatusUnauthorized, gin.H{"error": config.ERR_INVALID_TOKEN})
			ctx.Abort()
			return
		}

		if !token.Valid {
			ctx.JSON(http.StatusUnauthorized, gin.H{"error": config.ERR_INVALID_TOKEN})
			ctx.Abort()
			return
		}

		ctx.Set("Issuer", token.Claims.(jwt.MapClaims)[config.JWTIssuer()])
		ctx.Next()
	}
}

func GenerateToken(secret string, issuer string) (string, error) {
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
