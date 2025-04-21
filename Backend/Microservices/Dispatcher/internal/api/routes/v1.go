package routes

import (
	"github.com/cuonglexuan203/dispatcher/internal/api/handlers"
	"github.com/cuonglexuan203/dispatcher/internal/clients/backend"
	"github.com/cuonglexuan203/dispatcher/internal/firebase"
	"github.com/gin-gonic/gin"
	"github.com/hibiken/asynq"
	"gorm.io/gorm"
)

func SetupV1Routes(
	router *gin.RouterGroup,
	fcmService *firebase.FCMService,
	asynqClient *asynq.Client,
	db *gorm.DB,
	backendClient *backend.BackendClient) {
	// Init handlers
	notificationHandler := handlers.NewNotificationHandler(fcmService, backendClient)
	scheduleHandler := handlers.NewScheduleHandler(asynqClient, db, backendClient)

	// --- Notification Routes ---
	notificationRoutes := router.Group("/notifications")
	{
		notificationRoutes.POST("/send", notificationHandler.SendNotification)
		notificationRoutes.POST("/schedule", scheduleHandler.ScheduleNotification)
	}
}
