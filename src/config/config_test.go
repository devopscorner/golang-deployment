package config

import (
	"log"
	"os"
	"testing"

	"github.com/stretchr/testify/assert"
)

func TestLoadConfig(t *testing.T) {
	os.Setenv("APP_URL", "http://localhost")
	os.Setenv("APP_PORT", "8080")
	os.Setenv("DB_CONNECTION", "sqlite")
	os.Setenv("DB_REGION", "us-west-2")
	os.Setenv("DB_HOST", "localhost")
	os.Setenv("DB_PORT", "")
	os.Setenv("DB_DATABASE", "go-bookstore.db")
	os.Setenv("DB_USERNAME", "root")
	os.Setenv("DB_PASSWORD", "")
	os.Setenv("JWT_AUTH_USERNAME", "devopscorner")
	os.Setenv("JWT_AUTH_PASSWORD", "DevOpsCorner@2023")
	os.Setenv("JWT_SECRET", "s3cr3t")

	cfg, err := LoadConfig()
	if err != nil {
		log.Fatalf("error loading config: %v", err)
	}

	assert.NoError(t, err)
	assert.Equal(t, "http://localhost", cfg.AppUrl)
	assert.Equal(t, "8080", cfg.AppPort)
	assert.Equal(t, "us-west-2", cfg.DbRegion)
	assert.Equal(t, "sqlite", cfg.DbConnection)
	assert.Equal(t, "", cfg.DbPort)
	assert.Equal(t, "go-bookstore.db", cfg.DbDatabase)
	assert.Equal(t, "root", cfg.DbUsername)
	assert.Equal(t, "", cfg.DbPassword)
	assert.Equal(t, "devopscorner", cfg.JwtAuthUsername)
	assert.Equal(t, "DevOpsCorner@2023", cfg.JwtAuthPassword)
	assert.Equal(t, "s3cr3t", cfg.JwtSecret)
}
