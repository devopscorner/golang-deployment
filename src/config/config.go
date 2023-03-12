package config

import (
	"github.com/spf13/viper"
)

type Config struct {
	PortNumber   string
	DbName       string
	AuthUsername string
	AuthPassword string
	JwtSecret    string
}

func LoadConfig() (*Config, error) {
	viper.SetConfigFile(".env")
	viper.SetConfigType("env")
	viper.AutomaticEnv()

	if err := viper.ReadInConfig(); err != nil {
		return nil, err
	}

	viper.SetDefault("PORT", "8080")
	viper.SetDefault("DB_NAME", "go-bookstore.db")
	viper.SetDefault("AUTH_USERNAME", "devopscorner")
	viper.SetDefault("AUTH_PASSWORD", "DevOpsCorner@2023")
	viper.SetDefault("JWT_SECRET", "s3cr3t")

	config := &Config{
		PortNumber:   viper.GetString("PORT"),
		DbName:       viper.GetString("DB_NAME"),
		AuthUsername: viper.GetString("AUTH_USERNAME"),
		AuthPassword: viper.GetString("AUTH_PASSWORD"),
		JwtSecret:    viper.GetString("JWT_SECRET"),
	}

	return config, nil
}

func Port() string {
	config := &Config{
		PortNumber: viper.GetString("PORT"),
	}
	return config.PortNumber
}

func DbName() string {
	config := &Config{
		DbName: viper.GetString("DB_NAME"),
	}
	return config.DbName
}

func JWTIssuer() string {
	config := &Config{
		AuthUsername: viper.GetString("AUTH_USERNAME"),
	}
	return config.JwtSecret
}

func JWTSecret() string {
	config := &Config{
		JwtSecret: viper.GetString("JWT_SECRET"),
	}
	return config.JwtSecret
}
