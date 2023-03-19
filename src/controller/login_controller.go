package controller

import (
	"github.com/devopscorner/golang-deployment/src/middleware"
	"github.com/devopscorner/golang-deployment/src/view"
	"github.com/gin-gonic/gin"
	validator "github.com/go-playground/validator/v10"
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

	validCred := middleware.ValidateCredentials(loginRequest.Username, loginRequest.Password)
	if validCred != true {
		view.ErrorInvalidCredentials(ctx)
		return
	}

	token, err := middleware.GenerateToken(viper.GetString("JWT_SECRET"), viper.GetString("JWT_AUTH_USERNAME"))
	if err != nil {
		view.ErrorInternalServer(ctx, err)
		return
	}

	view.LoginToken(ctx, token)
}
