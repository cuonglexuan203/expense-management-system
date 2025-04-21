package handlers

import (
	"net/http"

	"github.com/cuonglexuan203/dispatcher/internal/api/models"
	"github.com/cuonglexuan203/dispatcher/internal/clients/backend"
	"github.com/cuonglexuan203/dispatcher/internal/firebase"
	applogger "github.com/cuonglexuan203/dispatcher/pkg/logger"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

type NotificationHandler struct {
	logger        *zap.Logger
	fcmService    *firebase.FCMService
	backendClient *backend.BackendClient
}

func NewNotificationHandler(fcmService *firebase.FCMService, backendClient *backend.BackendClient) *NotificationHandler {
	return &NotificationHandler{
		logger:        applogger.GetLogger(),
		fcmService:    fcmService,
		backendClient: backendClient,
	}
}

func (h *NotificationHandler) SendNotification(c *gin.Context) {
	var req models.SendNotificationRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		h.logger.Error("Failed to bind request body", zap.Error(err))
		c.JSON(http.StatusBadRequest, models.ErrorResponse{
			Error: "Invalid request" + err.Error(),
		})
		return
	}

	tokens, err := h.backendClient.GetUserDeviceTokens(c.Request.Context(), req.UserID)
	if err != nil {
		h.logger.Error("Failed to fetched device tokens from backend",
			zap.String("user_id", req.UserID),
			zap.Error(err))
		c.JSON(http.StatusBadGateway, models.ErrorResponse{Error: "Failed to communicate with backend service to get device tokens"})
		return
	}

	if len(tokens) == 0 {
		h.logger.Info("No active device tokens found for user, skipping notification send",
			zap.String("user_id", req.UserID))
		c.JSON(http.StatusOK, models.SuccessResponse{
			Message: "No active devices found for user.",
			Data:    models.SendNotificationResponse{Status: "No active devices found"},
		})
		return
	}

	batchResponse, err := h.fcmService.SendMulticastNotification(c.Request.Context(), tokens, req.Title, req.Body, req.Data)
	if err != nil {
		h.logger.Error("Failed to send multicast notification via FCM (request level)",
			zap.String("user_id", req.UserID),
			zap.Error(err))
		c.JSON(http.StatusInternalServerError, models.ErrorResponse{
			Error: "Failed to send notification due to FCM error",
		})
		return
	}

	statusMsg := "Notification sent."
	if batchResponse.FailureCount > 0 {
		statusMsg = "Notifications sent with some failures."
	}

	h.logger.Info("Direct notification send process completed",
		zap.String("user_id", req.UserID),
		zap.Int("success_count", int(batchResponse.SuccessCount)),
		zap.Int("failure_count", int(batchResponse.FailureCount)))

	c.JSON(http.StatusOK, models.SuccessResponse{
		Message: statusMsg,
		Data: models.SendNotificationResponse{
			Status:       statusMsg,
			SuccessCount: batchResponse.SuccessCount,
			FailureCount: batchResponse.FailureCount,
		},
	})
}
