package tasks

import (
	"context"
	"encoding/json"

	"github.com/cuonglexuan203/dispatcher/config"
	"github.com/cuonglexuan203/dispatcher/internal/api/models"
	"github.com/cuonglexuan203/dispatcher/internal/persistence/repositories"
	applogger "github.com/cuonglexuan203/dispatcher/pkg/logger"
	"github.com/hibiken/asynq"
	"go.uber.org/zap"
)

const (
	TypeEventPoll = "event:poll"
)

func NewPollEventTask() (*asynq.Task, error) {
	return asynq.NewTask(TypeEventPoll, nil), nil
}

// Event Poller
type EventPoller struct {
	cfg    config.Config
	repo   *repositories.EventRepository
	client *asynq.Client
}

func NewEventPoller(cfg config.Config, repo *repositories.EventRepository, client *asynq.Client) *EventPoller {
	return &EventPoller{
		cfg:    cfg,
		repo:   repo,
		client: client,
	}
}

func (p *EventPoller) HandlePoll(ctx context.Context, t *asynq.Task) error {
	logger := applogger.GetLogger()
	logger.Info("Polling for due events...")

	dueEvents, err := p.repo.FindDueEvents(ctx, p.cfg.EventBatchSize)
	if err != nil {
		logger.Error("Failed to find due events", zap.Error(err))
		return err
	}

	if len(dueEvents) == 0 {
		logger.Info("No due events found")
		return nil
	}

	logger.Info("Found due events", zap.Int("count", len(dueEvents)))
	claimedCount := 0

	for _, event := range dueEvents {
		claimed, err := p.repo.ClaimEvent(ctx, event.ID)
		if err != nil {
			logger.Error("Failed to claim event", zap.Int("event_id", event.ID), zap.Error(err))
			continue
		}

		if claimed {
			payload, err := json.Marshal(models.EventProcessingPayload{ScheduledEventID: event.ID})

			if err != nil {
				logger.Error("Failed to marshal event payload", zap.Int("event_id", event.ID), zap.Error(err))
				continue
			}

			taskInfo, err := p.client.EnqueueContext(
				ctx,
				asynq.NewTask(p.cfg.EventProcessingQueue, payload),
				asynq.Queue(p.cfg.EventProcessingQueue))
			if err != nil {
				logger.Error("Failed to enqueue event to processing", zap.Int("event_id", event.ID), zap.Error(err))
				continue
			}

			logger.Info("Successfully claimed and enqueued event for processing",
				zap.Int("event_id", event.ID),
				zap.String("task_id", taskInfo.ID))
			claimedCount++
		} else {
			logger.Info("Event already claimed", zap.Int("event_id", event.ID))
		}
	}

	logger.Info("Finished polling cycle", zap.Int("enqueued_count", claimedCount))
	return nil
}
