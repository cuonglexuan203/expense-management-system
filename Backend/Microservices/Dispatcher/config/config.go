package config

import (
	"fmt"
	"strings"
	"time"

	v "github.com/spf13/viper"
)

type Config struct {
	AppEnv                        string        `mapstructure:"APP_ENV"`
	Port                          string        `mapstructure:"APP_PORT"`
	ApiKey                        string        `mapstructure:"APP_API_KEY"`
	LogLevel                      string        `mapstructure:"LOG_LEVEL"`
	LogFileName                   string        `mapstructure:"LOG_FILENAME"`
	LogMaxSizeMB                  int           `mapstructure:"LOG_MAX_SIZE_MB"`
	LogMaxBackups                 int           `mapstructure:"LOG_MAX_BACKUPS"`
	LogMaxAgeDays                 int           `mapstructure:"LOG_MAX_AGE_DAYS"`
	DBHost                        string        `mapstructure:"DB_HOST"`
	DBPort                        string        `mapstructure:"DB_PORT"`
	DBUser                        string        `mapstructure:"DB_USER"`
	DBPassword                    string        `mapstructure:"DB_PASSWORD"`
	DBName                        string        `mapstructure:"DB_NAME"`
	DBSSLMode                     string        `mapstructure:"DB_SSLMODE"`
	RedisAddr                     string        `mapstructure:"REDIS_ADDR"`
	RedisPassword                 string        `mapstructure:"REDIS_PASSWORD"`
	RedisDB                       int           `mapstructure:"REDIS_DB"`
	FirebaseServiceAccountKeyPath string        `mapstructure:"FIREBASE_SERVICE_ACCOUNT_KEY_PATH"`
	CorsAllowedOrigins            []string      `mapstructure:"CORS_ALLOWED_ORIGINS"`
	CorsAllowedMethods            []string      `mapstructure:"CORS_ALLOWED_METHODS"`
	CorsAllowedHeaders            []string      `mapstructure:"CORS_ALLOWED_HEADERS"`
	CorsMaxAge                    time.Duration `mapstructure:"CORS_MAX_AGE"`
	BackendApiUrl                 string        `mapstructure:"BACKEND_API_URL"`
	BackendApiKey                 string        `mapstructure:"BACKEND_API_KEY"`
}

func LoadConfig(path string) (config Config, err error) {
	viper := v.NewWithOptions(v.ExperimentalBindStruct())

	viper.AddConfigPath(path)
	viper.SetConfigFile(".env")
	// viper.SetConfigName("config")
	// viper.SetConfigType("yaml")

	viper.AutomaticEnv()
	viper.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))

	// Set default values
	viper.SetDefault("APP_PORT", "8081")
	viper.SetDefault("LOG_LEVEL", "info")
	viper.SetDefault("LOG_FILENAME", "./logs/app.log")
	viper.SetDefault("LOG_MAX_SIZE_MB", 100)
	viper.SetDefault("LOG_MAX_BACKUPS", 5)
	viper.SetDefault("LOG_MAX_AGE_DAYS", 7)
	viper.SetDefault("DB_SSLMODE", "disable")
	viper.SetDefault("REDIS_ADDR", "localhost:6379")
	viper.SetDefault("REDIS_DB", 0)
	viper.SetDefault("CORS_ALLOWED_ORIGINS", []string{"*"})
	viper.SetDefault("CORS_ALLOWED_METHODS", []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"})
	viper.SetDefault("CORS_ALLOWED_HEADERS", []string{"Accept", "Authorization", "Content-Type", "X-CSRF-Token", "X-API-KEY"})
	viper.SetDefault("CORS_MAX_AGE", 12*time.Hour)
	viper.SetDefault("BACKEND_API_URL", "http://localhost:5000")

	if err = viper.ReadInConfig(); err != nil {
		if _, ok := err.(v.ConfigFileNotFoundError); !ok {
			print("Config file not found, using environment variables")
			// return Config{}, fmt.Errorf("failed to read config file: %w", err)
		}
	}

	if err = viper.Unmarshal(&config); err != nil {
		return Config{}, fmt.Errorf("failed to unmarshal config: %w", err)
	}

	return
}
