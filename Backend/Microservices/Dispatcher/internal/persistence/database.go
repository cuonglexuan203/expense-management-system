package persistence

import (
	"fmt"
	"time"

	"github.com/cuonglexuan203/dispatcher/config"
	applogger "github.com/cuonglexuan203/dispatcher/pkg/logger"
	"go.uber.org/zap"
	"gorm.io/driver/postgres"
	"gorm.io/gorm"
	gormlogger "gorm.io/gorm/logger"
	"gorm.io/gorm/schema"
)

func InitDatabase(cfg config.Config) (*gorm.DB, error) {
	dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=%s TimeZone=UTC",
		cfg.DBHost, cfg.DBUser, cfg.DBPassword, cfg.DBName, cfg.DBPort, cfg.DBSSLMode)

	gormLogLevel := gormlogger.Silent
	if cfg.LogLevel == "debug" {
		gormLogLevel = gormlogger.Info
	}

	newLogger := gormlogger.New(
		zap.NewStdLog(applogger.GetLogger()),
		gormlogger.Config{
			SlowThreshold:             time.Second,
			LogLevel:                  gormLogLevel,
			IgnoreRecordNotFoundError: true,
			Colorful:                  false,
		},
	)

	db, err := gorm.Open(postgres.Open(dsn), &gorm.Config{
		Logger: newLogger,
		NamingStrategy: schema.NamingStrategy{
			NoLowerCase: true,
		},
	})

	if err != nil {
		applogger.GetLogger().Error("Failed to connect to database", zap.Error(err))
		return nil, err
	}

	applogger.GetLogger().Info("Database connection established")

	// Auto-migrate schema

	return db, nil
}
