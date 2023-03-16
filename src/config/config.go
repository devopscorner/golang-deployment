package config

import (
	"github.com/spf13/viper"
)

type Config struct {
	AppUrl          string
	AppPort         string
	DbConnection    string
	DbRegion        string
	DbHost          string
	DbPort          string
	DbDatabase      string
	DbUsername      string
	DbPassword      string
	JwtAuthUsername string
	JwtAuthPassword string
	JwtIssuer       string
	JwtSecret       string
}

func LoadConfig() (*Config, error) {
	viper.SetConfigFile(".env")
	viper.SetConfigType("env")
	viper.AutomaticEnv()

	if err := viper.ReadInConfig(); err != nil {
		return nil, err
	}

	viper.SetDefault("APP_URL", "http://localhost")
	viper.SetDefault("APP_PORT", "8080")
	viper.SetDefault("DB_CONNECTION", "sqlite")
	viper.SetDefault("DB_REGION", "us-west-2")
	viper.SetDefault("DB_HOST", "localhost")
	viper.SetDefault("DB_PORT", "")
	viper.SetDefault("DB_DATABASE", "go-bookstore")
	viper.SetDefault("DB_USERNAME", "root")
	viper.SetDefault("DB_PASSWORD", "")
	viper.SetDefault("JWT_AUTH_USERNAME", "devopscorner")
	viper.SetDefault("JWT_AUTH_PASSWORD", "DevOpsCorner@2023")
	viper.SetDefault("JWT_SECRET", "s3cr3t")

	config := &Config{
		AppUrl:          viper.GetString("APP_URL"),
		AppPort:         viper.GetString("APP_PORT"),
		DbConnection:    viper.GetString("DB_CONNECTION"),
		DbRegion:        viper.GetString("DB_REGION"),
		DbHost:          viper.GetString("DB_HOST"),
		DbPort:          viper.GetString("DB_PORT"),
		DbDatabase:      viper.GetString("DB_DATABASE"),
		DbUsername:      viper.GetString("DB_USERNAME"),
		DbPassword:      viper.GetString("DB_PASSWORD"),
		JwtAuthUsername: viper.GetString("JWT_AUTH_USERNAME"),
		JwtAuthPassword: viper.GetString("JWT_AUTH_PASSWORD"),
		JwtSecret:       viper.GetString("JWT_SECRET"),
	}

	return config, nil
}

func AppUrl() string {
	config := &Config{
		AppUrl: viper.GetString("APP_URL"),
	}
	return config.AppUrl
}

func AppPort() string {
	config := &Config{
		AppPort: viper.GetString("APP_PORT"),
	}
	return config.AppPort
}

func DbConnection() string {
	config := &Config{
		DbConnection: viper.GetString("DB_CONNECTION"),
	}
	return config.DbConnection
}

func DbRegion() string {
	config := &Config{
		DbRegion: viper.GetString("DB_REGION"),
	}
	return config.DbRegion
}

func DbHost() string {
	config := &Config{
		DbHost: viper.GetString("DB_HOST"),
	}
	return config.DbHost
}

func DbPort() string {
	config := &Config{
		DbPort: viper.GetString("DB_PORT"),
	}
	return config.DbPort
}

func DbDatabase() string {
	config := &Config{
		DbDatabase: viper.GetString("DB_DATABASE"),
	}
	return config.DbDatabase
}

func DbUsername() string {
	config := &Config{
		DbUsername: viper.GetString("DB_USERNAME"),
	}
	return config.DbUsername
}

func DbPassword() string {
	config := &Config{
		DbPassword: viper.GetString("DB_PASSWORD"),
	}
	return config.DbPassword
}

func JWTAuthUsername() string {
	config := &Config{
		JwtAuthUsername: viper.GetString("JWT_AUTH_USERNAME"),
	}
	return config.JwtAuthUsername
}

func JWTAuthPassword() string {
	config := &Config{
		JwtAuthPassword: viper.GetString("JWT_AUTH_PASSWORD"),
	}
	return config.JwtAuthPassword
}

func JWTIssuer() string {
	config := &Config{
		JwtIssuer: viper.GetString("JWT_AUTH_USERNAME"),
	}
	return config.JwtIssuer
}

func JWTSecret() string {
	config := &Config{
		JwtSecret: viper.GetString("JWT_SECRET"),
	}
	return config.JwtSecret
}
