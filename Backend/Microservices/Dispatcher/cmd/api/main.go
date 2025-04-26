package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/cuonglexuan203/dispatcher/config"
	"github.com/cuonglexuan203/dispatcher/internal/api/middleware"
	"github.com/cuonglexuan203/dispatcher/internal/api/routes"
	"github.com/cuonglexuan203/dispatcher/internal/clients/backend"
	"github.com/cuonglexuan203/dispatcher/internal/firebase"
	"github.com/cuonglexuan203/dispatcher/internal/persistence"
	"github.com/cuonglexuan203/dispatcher/internal/scheduler"
	applogger "github.com/cuonglexuan203/dispatcher/pkg/logger"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

func main() {
	// --- Configuration ---
	cfg, err := config.LoadConfig(".")
	if err != nil {
		panic(fmt.Sprintf("Failed to load config: %v", err))
	}

	// --- Logger ---
	applogger.InitLogger(cfg.LogLevel, cfg.LogFileName, cfg.LogMaxSizeMB, cfg.LogMaxBackups, cfg.LogMaxAgeDays)
	defer applogger.Sync()
	logger := applogger.GetLogger()
	logger.Info("Logger initialized", zap.String("level", cfg.LogLevel))

	// --- Database ---
	db, err := persistence.InitDatabase(cfg)
	if err != nil {
		logger.Fatal("Failed to initialize database", zap.Error(err))
	}
	sqlDB, _ := db.DB()
	defer sqlDB.Close()

	// --- Firebase ---
	fcmService, err := firebase.InitFCM(cfg)
	if err != nil {
		logger.Fatal("Failed to initialize Firebase", zap.Error(err))
	}

	// --- Backend API Client ---
	backendClient, err := backend.NewBackendClient(cfg)
	if err != nil {
		logger.Fatal("Failed to initialize Backend API Client", zap.Error(err))
	}

	// --- Asynq Client ---
	asynqClient := scheduler.NewAsynqClient(cfg)
	defer asynqClient.Close()

	// --- Asynq Server ---
	asynqServer := scheduler.RunAsynqServer(cfg, fcmService, db, backendClient)

	// --- Gin Router ---
	if cfg.AppEnv == "production" {
		gin.SetMode(gin.ReleaseMode)
	}
	router := gin.New()

	// --- Global Middleware ---
	router.Use(middleware.Recovery())
	router.Use(middleware.RequestLogger())
	router.Use(middleware.CORSMiddleware(cfg))
	router.Use(middleware.ErrorHandler())

	// -- API Key Authentication ---
	apiGroup := router.Group("/api")
	apiGroup.Use(middleware.APIKeyAuth(cfg.ApiKey))

	// API Versioning & Routes
	v1Group := apiGroup.Group("/v1")
	{
		routes.SetupV1Routes(v1Group, fcmService, asynqClient, db, backendClient)
	}

	// --- Health Check ---
	router.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status": "UP",
		})
	})

	// --- HTTP Server ---
	srv := &http.Server{
		Addr:         ":" + cfg.Port,
		Handler:      router,
		ReadTimeout:  10 * time.Second,
		WriteTimeout: 10 * time.Second,
		IdleTimeout:  60 * time.Second,
	}

	// --- Start Server & Graceful Shutdown ---
	go func() {
		logger.Info("Starting HTTP server", zap.String("address", srv.Addr))
		if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
			logger.Fatal("Failed to start HTTP server", zap.Error(err))
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
	logger.Info("Shutting down server...")

	// Shutdown Asynq server first
	logger.Info("Stopping Asynq server...")
	asynqServer.Stop()
	asynqServer.Shutdown()
	logger.Info("Asynq server stopped.")

	// Shutdown HTTP server
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		logger.Fatal("HTTP server forced to shutdown", zap.Error(err))
	}

	logger.Info("HTTP server exiting")
}
