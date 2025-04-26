package logger

import (
	"os"
	"path/filepath"

	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"gopkg.in/natefinch/lumberjack.v2"
)

var log *zap.Logger

func InitLogger(logLevel, logFile string, maxSizeMB, maxBackups, maxAgeDays int) {
	logDir := filepath.Dir(logFile)
	if _, err := os.Stat(logDir); os.IsNotExist(err) {
		os.MkdirAll(logDir, os.ModePerm)
	}

	// File writer with rotation
	fileWriter := zapcore.AddSync(&lumberjack.Logger{
		Filename:   logFile,
		MaxSize:    maxSizeMB,
		MaxBackups: maxBackups,
		MaxAge:     maxAgeDays,
		Compress:   true,
	})

	// Console writer
	consoleWriter := zapcore.AddSync(os.Stdout)

	// Log level
	level := zapcore.DebugLevel
	switch logLevel {
	case "info":
		level = zapcore.InfoLevel
	case "warn":
		level = zapcore.WarnLevel
	case "error":
		level = zapcore.ErrorLevel
	}

	// Encoder configuration
	encoderConfig := zap.NewProductionEncoderConfig()
	encoderConfig.EncodeTime = zapcore.ISO8601TimeEncoder
	encoderConfig.EncodeLevel = zapcore.CapitalLevelEncoder

	core := zapcore.NewTee(
		zapcore.NewCore(zapcore.NewJSONEncoder(encoderConfig), fileWriter, level),
		zapcore.NewCore(zapcore.NewConsoleEncoder(encoderConfig), consoleWriter, level),
	)

	// Create logger
	log = zap.New(core, zap.AddCaller(), zap.AddStacktrace(zap.ErrorLevel))
}

func GetLogger() *zap.Logger {
	if log == nil {
		l, _ := zap.NewProduction()
		return l
	}

	return log
}

func Sync() {
	if log != nil {
		log.Sync()
	}
}
