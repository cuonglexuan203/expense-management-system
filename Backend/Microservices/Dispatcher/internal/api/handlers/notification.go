package handlers

import (
	"net/http"
	"strconv"

	apimodels "github.com/cuonglexuan203/dispatcher/internal/api/models"
	"github.com/cuonglexuan203/dispatcher/internal/clients/backend"
	"github.com/cuonglexuan203/dispatcher/internal/firebase"
	"github.com/cuonglexuan203/dispatcher/internal/models"
	"github.com/cuonglexuan203/dispatcher/internal/models/common"
	applogger "github.com/cuonglexuan203/dispatcher/pkg/logger"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

type NotificationHandler struct {
	logger        *zap.Logger
	fcmService    *firebase.FCMService
	backendClient *backend.BackendClient
	db            *gorm.DB
}

func NewNotificationHandler(
	fcmService *firebase.FCMService,
	backendClient *backend.BackendClient,
	db *gorm.DB) *NotificationHandler {
	return &NotificationHandler{
		logger:        applogger.GetLogger(),
		fcmService:    fcmService,
		backendClient: backendClient,
		db:            db,
	}
}

func (h *NotificationHandler) SendNotification(c *gin.Context) {
	var req apimodels.SendNotificationRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		h.logger.Error("Failed to bind request body", zap.Error(err))
		c.JSON(http.StatusBadRequest, apimodels.ErrorResponse{
			Error: "Invalid request" + err.Error(),
		})
		return
	}

	notificationID, _ := strconv.Atoi(req.Data["notification_id"])
	var notification models.Notification
	h.db.
		Where(&models.Notification{AuditableEntity: common.AuditableEntity{IsDeleted: false}}, "IsDeleted").
		First(&notification, notificationID)

	h.db.Model(&notification).Update("Status", "Processing")

	tokens, err := h.backendClient.GetUserDeviceTokens(c.Request.Context(), req.UserID)
	if err != nil {
		h.logger.Error("Failed to fetched device tokens from backend",
			zap.String("user_id", req.UserID),
			zap.Error(err))
		updateFailedNotificationStatus(h.db, &notification)
		c.JSON(http.StatusBadGateway, apimodels.ErrorResponse{Error: "Failed to communicate with backend service to get device tokens"})
		return
	}

	if len(tokens) == 0 {
		h.logger.Info("No active device tokens found for user, skipping notification send",
			zap.String("user_id", req.UserID))
		updateSentNotificationStatus(h.db, &notification)
		c.JSON(http.StatusOK, apimodels.SuccessResponse{
			Message: "No active devices found for user.",
			Data:    apimodels.SendNotificationResponse{Status: "No active devices found"},
		})
		return
	}

	batchResponse, err := h.fcmService.SendMulticastNotification(c.Request.Context(), tokens, req.Title, req.Body, req.Data)
	if err != nil {
		h.logger.Error("Failed to send multicast notification via FCM (request level)",
			zap.String("user_id", req.UserID),
			zap.Error(err))
		updateFailedNotificationStatus(h.db, &notification)
		c.JSON(http.StatusInternalServerError, apimodels.ErrorResponse{
			Error: "Failed to send notification due to FCM error",
		})
		return
	}
	updateSentNotificationStatus(h.db, &notification)

	statusMsg := "Notification sent."
	if batchResponse.FailureCount > 0 {
		statusMsg = "Notifications sent with some failures."
	}

	h.logger.Info("Direct notification send process completed",
		zap.String("user_id", req.UserID),
		zap.Int("success_count", int(batchResponse.SuccessCount)),
		zap.Int("failure_count", int(batchResponse.FailureCount)))

	c.JSON(http.StatusOK, apimodels.SuccessResponse{
		Message: statusMsg,
		Data: apimodels.SendNotificationResponse{
			Status:       statusMsg,
			SuccessCount: batchResponse.SuccessCount,
			FailureCount: batchResponse.FailureCount,
		},
	})
}

func updateFailedNotificationStatus(db *gorm.DB, notification *models.Notification) {
	db.Model(notification).Update("Status", "Failed")
}

func updateSentNotificationStatus(db *gorm.DB, notification *models.Notification) {
	db.Model(notification).Update("Status", "Sent")
}
