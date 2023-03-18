package view

import (
	"net/http"

	"github.com/devopscorner/golang-deployment/src/config"
	"github.com/gin-gonic/gin"
)

// ----- Error Response -----

func ErrorBadRequest(ctx *gin.Context, err error) {
	ctx.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
}

func ErrorInternalServer(ctx *gin.Context, err error) {
	ctx.JSON(http.StatusInternalServerError, gin.H{"error": err})
}

func ErrorInvalidId(ctx *gin.Context) {
	ctx.JSON(http.StatusBadRequest, gin.H{"error": config.ERR_INVALID_BOOK_ID})
}

func ErrorInvalidCredentials(ctx *gin.Context) {
	ctx.JSON(http.StatusUnauthorized, gin.H{"error": config.ERR_INVALID_CREDENTIALS})
}

func ErrorNotFound(ctx *gin.Context) {
	ctx.JSON(http.StatusNotFound, gin.H{"error": config.ERR_BOOK_NOT_FOUND})
}

func ErrorInvalidRequest(ctx *gin.Context) {
	ctx.JSON(http.StatusBadRequest, gin.H{"error": config.ERR_INVALID_REQUEST_PAYLOAD})
}

func ErrorUpdate(ctx *gin.Context) {
	ctx.JSON(http.StatusInternalServerError, gin.H{"error": config.ERR_UPDATE_BOOK})
}

func ErrorDelete(ctx *gin.Context) {
	ctx.JSON(http.StatusInternalServerError, gin.H{"error": config.ERR_DELETE_BOOK})
}
