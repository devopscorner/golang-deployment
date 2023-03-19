package view

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

// ----- View Response -----

func LoginToken(ctx *gin.Context, token string) {
	ctx.JSON(http.StatusOK, gin.H{"token": token})
}
