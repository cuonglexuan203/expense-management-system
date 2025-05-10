package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"os/signal"
	"sync"
	"syscall"
	"time"

	"github.com/cuonglexuan203/dispatcher/config"
	"github.com/cuonglexuan203/dispatcher/internal/api/middleware"
	"github.com/cuonglexuan203/dispatcher/internal/api/routes"
	"github.com/cuonglexuan203/dispatcher/internal/clients/backend"
	"github.com/cuonglexuan203/dispatcher/internal/clients/redis"
	"github.com/cuonglexuan203/dispatcher/internal/firebase"
	"github.com/cuonglexuan203/dispatcher/internal/persistence"
	"github.com/cuonglexuan203/dispatcher/internal/persistence/repositories"
	"github.com/cuonglexuan203/dispatcher/internal/scheduler"
	"github.com/cuonglexuan203/dispatcher/internal/services"
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

	// Repository
	eventRepo := repositories.NewEventRepository(db)

	// Redis Client
	redisClient, err := redis.NewRedisClient(cfg)
	if err != nil {
		logger.Fatal("Failed to initialize Redis client", zap.Error(err))
	}
	defer redisClient.Close()
	logger.Info("Redis client initialized", zap.String("address", cfg.RedisAddr))

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

	// Asynq Scheduler
	// asynqScheduler := scheduler.RunAsynqScheduler(cfg)

	// --- Asynq Server ---
	asynqServer := scheduler.RunAsynqServer(cfg, fcmService, db, backendClient)

	// --- Event Poller Service ---
	eventPollerService := services.NewEventPollerService(
		eventRepo,
		redisClient,
		logger,
		cfg.EventProcessingQueue,
		cfg.EventBatchSize,
		cfg.EventPollingInterval)

	// --- Context for Graceful Shutdown ---
	mainCtx, cancel := context.WithCancel(context.Background())
	defer cancel()

	// --- WaitGroup for Graceful Shutfown ---
	var wg sync.WaitGroup

	// --- Start Event Poller ---
	eventPollerService.Start(mainCtx, &wg)

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
		routes.SetupV1Routes(v1Group, cfg, fcmService, asynqClient, db, backendClient)
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

	// --- Graceful Shutdown ---
	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit
	logger.Info("Shutting down server...")

	// 1. Signal background services to stop
	logger.Info("Signaling background services to stop...")
	cancel()

	// 2. Stop Asynq server first
	logger.Info("Stopping Asynq server...")
	asynqServer.Stop()
	asynqServer.Shutdown()
	logger.Info("Asynq server stopped.")

	// Shutdown Asynq scheduler
	// logger.Info("Stopping Asynq scheduler...")
	// asynqScheduler.Shutdown()
	// logger.Info("Asynq scheduler stopped.")

	// 3. Shutdown HTTP server
	logger.Info("Shutting down HTTP server...")
	httpShutdownCtx, httpCancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer httpCancel()
	if err := srv.Shutdown(httpShutdownCtx); err != nil {
		logger.Fatal("HTTP server forced to shutdown", zap.Error(err))
	} else {
		logger.Info("HTTP server gracefully stopped.")
	}

	// 4. Wait for background services to finish
	logger.Info("Waiting for background services to finish...")
	waitChan := make(chan struct{})
	go func() {
		wg.Wait()
		close(waitChan)
	}()

	select {
	case <-waitChan:
		logger.Info("All background services finished.")
	case <-time.After(15 * time.Second):
		logger.Warn("Timeout waiting for background services to finish.")
	}

	// 5. Close Redis, DB connections (deferred calls)
	logger.Info("Closing connections...")

	//
	logger.Info("HTTP server exiting")
}
