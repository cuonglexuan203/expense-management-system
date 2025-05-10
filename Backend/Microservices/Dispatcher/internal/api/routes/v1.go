package routes

import (
	"github.com/cuonglexuan203/dispatcher/config"
	"github.com/cuonglexuan203/dispatcher/internal/api/handlers"
	"github.com/cuonglexuan203/dispatcher/internal/clients/backend"
	"github.com/cuonglexuan203/dispatcher/internal/firebase"
	"github.com/gin-gonic/gin"
	"github.com/hibiken/asynq"
	"gorm.io/gorm"
)

func SetupV1Routes(
	router *gin.RouterGroup,
	cfg config.Config,
	fcmService *firebase.FCMService,
	asynqClient *asynq.Client,
	db *gorm.DB,
	backendClient *backend.BackendClient) {
	// Init handlers
	notificationHandler := handlers.NewNotificationHandler(fcmService, backendClient, db)
	scheduleHandler := handlers.NewScheduleHandler(asynqClient, db, backendClient)
	emailHandler := handlers.NewEmailHandler(cfg)

	// --- Notification Routes ---
	notificationRoutes := router.Group("/notifications")
	{
		notificationRoutes.POST("/send", notificationHandler.SendNotification)
		notificationRoutes.POST("/schedule", scheduleHandler.ScheduleNotification)
	}

	// -- Email Routes --
	emailRoutes := router.Group("/emails")
	{
		emailRoutes.POST("/send", emailHandler.SendEmail)
	}
}
