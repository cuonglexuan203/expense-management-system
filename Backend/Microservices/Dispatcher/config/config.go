package config

import (
	"fmt"
	"strings"
	"time"

	v "github.com/spf13/viper"
)

type Config struct {
	AppEnv        string `mapstructure:"APP_ENV"`
	Port          string `mapstructure:"APP_PORT"`
	ApiKey        string `mapstructure:"APP_API_KEY"`
	LogLevel      string `mapstructure:"LOG_LEVEL"`
	LogFileName   string `mapstructure:"LOG_FILENAME"`
	LogMaxSizeMB  int    `mapstructure:"LOG_MAX_SIZE_MB"`
	LogMaxBackups int    `mapstructure:"LOG_MAX_BACKUPS"`
	LogMaxAgeDays int    `mapstructure:"LOG_MAX_AGE_DAYS"`

	// Database
	DBHost     string `mapstructure:"DB_HOST"`
	DBPort     string `mapstructure:"DB_PORT"`
	DBUser     string `mapstructure:"DB_USER"`
	DBPassword string `mapstructure:"DB_PASSWORD"`
	DBName     string `mapstructure:"DB_NAME"`
	DBSSLMode  string `mapstructure:"DB_SSLMODE"`

	// Redis
	RedisAddr         string        `mapstructure:"REDIS_ADDR"`
	RedisPassword     string        `mapstructure:"REDIS_PASSWORD"`
	RedisDB           int           `mapstructure:"REDIS_DB"`
	RedisPoolSize     int           `mapstructure:"REDIS_POOL_SIZE"`
	RedisMinIdleConns int           `mapstructure:"REDIS_MIN_IDLE_CONNS"`
	RedisPoolTimeout  time.Duration `mapstructure:"REDIS_POOL_TIMEOUT"`
	RedisIdleTimeout  time.Duration `mapstructure:"REDIS_IDLE_TIMEOUT"`

	// Firebase
	FirebaseServiceAccountKeyPath string `mapstructure:"FIREBASE_SERVICE_ACCOUNT_KEY_PATH"`

	CorsAllowedOrigins []string      `mapstructure:"CORS_ALLOWED_ORIGINS"`
	CorsAllowedMethods []string      `mapstructure:"CORS_ALLOWED_METHODS"`
	CorsAllowedHeaders []string      `mapstructure:"CORS_ALLOWED_HEADERS"`
	CorsMaxAge         time.Duration `mapstructure:"CORS_MAX_AGE"`

	// Backend API
	BackendApiUrl string `mapstructure:"BACKEND_API_URL"`
	BackendApiKey string `mapstructure:"BACKEND_API_KEY"`

	// Event poller config
	EventPollingInterval time.Duration `mapstructure:"EVENT_POLLING_INTERVAL"`
	EventProcessingQueue string        `mapstructure:"EVENT_PROCESSING_QUEUE"`
	EventBatchSize       int           `mapstructure:"EVENT_BATCH_SIZE"`

	// Email config
	SMTPHost           string `mapstructure:"SMTP_HOST"`
	SMTPPort           int    `mapstructure:"SMTP_PORT"`
	SMTPUserName       string `mapstructure:"SMTP_USERNAME"`
	SMTPPassword       string `mapstructure:"SMTP_PASSWORD"`
	SenderEmail        string `mapstructure:"SMTP_SENDER_EMAIL"`
	InsecureSkipVerify bool   `mapstructure:"SMTP_INSECURE_SKIP_VERIFY"`
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
	viper.SetDefault("REDIS_POOL_SIZE", 10)
	viper.SetDefault("REDIS_MIN_IDLE_CONNS", 2)
	viper.SetDefault("REDIS_POOL_TIMEOUT", "5s")
	viper.SetDefault("REDIS_IDLE_TIMEOUT", "5m")
	viper.SetDefault("CORS_ALLOWED_ORIGINS", []string{"*"})
	viper.SetDefault("CORS_ALLOWED_METHODS", []string{"GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"})
	viper.SetDefault("CORS_ALLOWED_HEADERS", []string{"Accept", "Authorization", "Content-Type", "X-CSRF-Token", "X-API-KEY"})
	viper.SetDefault("CORS_MAX_AGE", 12*time.Hour)
	viper.SetDefault("BACKEND_API_URL", "http://localhost:5000")
	viper.SetDefault("EVENT_POLLING_INTERVAL", 30*time.Second)
	viper.SetDefault("EVENT_PROCESSING_QUEUE", "event:processing")
	viper.SetDefault("EVENT_BATCH_SIZE", 100)
	viper.SetDefault("SMTP_HOST", "smtp.gmail.com")
	viper.SetDefault("SMTP_PORT", 587)
	viper.SetDefault("SMTP_SENDER_EMAIL", "EMS")
	viper.SetDefault("SMTP_INSECURE_SKIP_VERIFY", true)

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
