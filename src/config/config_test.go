package config

import (
	"log"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestLoadConfig(t *testing.T) {
	os.Setenv("PORT", "8080")
	os.Setenv("DB_NAME", "go-bookstore.db")
	os.Setenv("AUTH_USERNAME", "devopscorner")
	os.Setenv("AUTH_PASSWORD", "DevOpsCorner@2023")
	os.Setenv("JWT_SECRET", "s3cr3t")

	cfg, err := LoadConfig()
	if err != nil {
		log.Fatalf("error loading config: %v", err)
	}

	assert.NoError(t, err)
	assert.Equal(t, "8080", cfg.PortNumber)
	assert.Equal(t, "go-bookstore.db", cfg.DbName)
	assert.Equal(t, "devopscorner", cfg.AuthUsername)
	assert.Equal(t, "DevOpsCorner@2023", cfg.AuthPassword)
	assert.Equal(t, "s3cr3t", cfg.JwtSecret)
}
