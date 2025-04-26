package tasks

import (
	"context"
	"encoding/json"
	"fmt"
	"time"

	"github.com/cuonglexuan203/dispatcher/internal/clients/backend"
	"github.com/cuonglexuan203/dispatcher/internal/firebase"
	"github.com/hibiken/asynq"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

const (
	TypeNotificationSend = "notification:send"
)

type NotificationPayload struct {
	UserID string            `json:"user_id"`
	Title  string            `json:"title"`
	Body   string            `json:"body"`
	Data   map[string]string `json:"data,omitempty"`
}

func NewSendNotificationTask(payload NotificationPayload, processAt *time.Time, queue string) (*asynq.Task, error) {
	payloadBytes, err := json.Marshal(payload)
	if err != nil {
		return nil, fmt.Errorf("error marshaling payload: %w", err)
	}

	opts := []asynq.Option{
		asynq.Queue(queue),
		asynq.MaxRetry(5),
		// asynq.Timeout(2 * time.Minute),
	}

	if processAt != nil {
		opts = append(opts, asynq.ProcessAt(*processAt))
	}

	return asynq.NewTask(TypeNotificationSend, payloadBytes, opts...), nil
}

// -- Task Handler --
type NotificationTaskHandler struct {
	logger        *zap.Logger
	fcmService    *firebase.FCMService
	db            *gorm.DB
	backendClient *backend.BackendClient
}

func NewNotificationTaskHandler(
	logger *zap.Logger,
	fcmService *firebase.FCMService,
	db *gorm.DB,
	backendClient *backend.BackendClient) *NotificationTaskHandler {
	return &NotificationTaskHandler{
		logger:        logger,
		fcmService:    fcmService,
		db:            db,
		backendClient: backendClient,
	}
}

func (h *NotificationTaskHandler) HandleSendNotificationTask(ctx context.Context, t *asynq.Task) error {
	var payload NotificationPayload
	if err := json.Unmarshal(t.Payload(), &payload); err != nil {
		h.logger.Error("Failed to unmarshal notification task payload", zap.Error(err), zap.ByteString("payload", t.Payload()))
		return fmt.Errorf("failed to unmarshal payload: %w", err)
	}

	h.logger.Info("Processing notification task",
		zap.String("user_id", payload.UserID),
		zap.String("title", payload.Title),
		zap.String("asynq_task_id", t.ResultWriter().TaskID()))

	tokens, err := h.backendClient.GetUserDeviceTokens(ctx, payload.UserID)
	if err != nil {
		h.logger.Error("Failed to fetch device tokens from backend during task processing",
			zap.String("user_id", payload.UserID),
			zap.String("asynq_task_id", t.ResultWriter().TaskID()),
			zap.Error(err))

		return fmt.Errorf("failed to fetch device tokens for user %s: %w", payload.UserID, err)
	}

	if len(tokens) == 0 {
		h.logger.Info("No active device tokens found for user during task processing, task considered completed.",
			zap.String("user_id", payload.UserID),
			zap.String("asynq_task_id", t.ResultWriter().TaskID()))

		return nil
	}

	batchResponse, err := h.fcmService.SendMulticastNotification(ctx, tokens, payload.Title, payload.Body, payload.Data)
	if err != nil {
		h.logger.Error("Failed to send multicast notification via FCM during task processing (request level)",
			zap.String("user_id", payload.UserID),
			zap.String("asynq_task_id", t.ResultWriter().TaskID()),
			zap.Error(err))

		return fmt.Errorf("failed to send FCM multicast request for user %s: %w", payload.UserID, err)
	}

	if batchResponse.FailureCount > 0 {
		// errMsg := fmt.Sprintf("Completed with %d failures out of %d tokens",
		// 	batchResponse.FailureCount,
		// 	len(tokens))
		h.logger.Warn("Scheduled notification task completed with partial failures",
			zap.String("user_id", payload.UserID),
			zap.String("asynq_task_id", t.ResultWriter().TaskID()),
			zap.Int("success_count", batchResponse.SuccessCount),
			zap.Int("failure_count", batchResponse.FailureCount))
		return nil
	}

	h.logger.Info("Successfully processed notification task",
		zap.String("user_id", payload.UserID),
		zap.String("asynq_task_id", t.ResultWriter().TaskID()),
		zap.Int("success_count", batchResponse.SuccessCount))
	return nil
}
