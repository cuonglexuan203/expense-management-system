package handlers

import (
	"net/http"
	"time"

	"github.com/cuonglexuan203/dispatcher/internal/api/models"
	"github.com/cuonglexuan203/dispatcher/internal/clients/backend"
	"github.com/cuonglexuan203/dispatcher/internal/scheduler/tasks"
	applogger "github.com/cuonglexuan203/dispatcher/pkg/logger"
	"github.com/gin-gonic/gin"
	"github.com/hibiken/asynq"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

type ScheduleHandler struct {
	logger        *zap.Logger
	asynqClient   *asynq.Client
	db            *gorm.DB
	backendClient *backend.BackendClient
}

func NewScheduleHandler(
	asynqClient *asynq.Client,
	db *gorm.DB,
	backendClient *backend.BackendClient) *ScheduleHandler {
	return &ScheduleHandler{
		logger:        applogger.GetLogger(),
		asynqClient:   asynqClient,
		db:            db,
		backendClient: backendClient,
	}
}

func (h *ScheduleHandler) ScheduleNotification(c *gin.Context) {
	var req models.ScheduleNotificationRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		h.logger.Error("Failed to bind schedule request body", zap.Error(err))
		c.JSON(http.StatusBadRequest, models.ErrorResponse{Error: "Invalid request body" + err.Error()})
		return
	}

	if req.ScheduleAt.Before(time.Now().UTC()) {
		h.logger.Error("Attempted to schedule task in the past", zap.Time("schedule_at", req.ScheduleAt))
		c.JSON(http.StatusBadRequest, models.ErrorResponse{Error: "Schedule time must be in the future"})
		return
	}

	queue := req.Queue
	if queue == "" {
		queue = "default"
	}

	payload := tasks.NotificationPayload{
		UserID: req.UserID,
		Title:  req.Title,
		Body:   req.Body,
		Data:   req.Data,
	}

	task, err := tasks.NewSendNotificationTask(payload, &req.ScheduleAt, queue)
	if err != nil {
		h.logger.Error("Failed to create Asynq task", zap.Error(err))
		c.JSON(http.StatusInternalServerError, models.ErrorResponse{Error: "Failed to create scheduling task"})
		return
	}

	taskInfo, err := h.asynqClient.Enqueue(task)
	if err != nil {
		h.logger.Error("Failed to enqueue Asynq task", zap.Error(err), zap.String("queue", queue))
		c.JSON(http.StatusInternalServerError, models.ErrorResponse{Error: "Failed to schedule notification"})
		return
	}

	h.logger.Info("Notification task scheduled successfully",
		zap.String("asynq_task_id", taskInfo.ID),
		zap.String("user_id", req.UserID),
		zap.String("queue", taskInfo.Queue),
		zap.Time("schedule_at", req.ScheduleAt))

	c.JSON(http.StatusOK, models.SuccessResponse{
		Message: "Notification scheduled successfully",
		Data: models.ScheduleNotificationResponse{
			TaskID: taskInfo.ID,
			Status: "Scheduled",
			RunAt:  req.ScheduleAt,
		},
	})
}
