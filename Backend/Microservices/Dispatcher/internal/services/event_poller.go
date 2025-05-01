package services

import (
	"context"
	"encoding/json"
	"sync"
	"time"

	"github.com/cuonglexuan203/dispatcher/internal/models"
	"github.com/cuonglexuan203/dispatcher/internal/persistence/repositories"
	"github.com/redis/go-redis/v9"
	"go.uber.org/zap"
)

type EventProcessingPayload struct {
	ScheduledEventID int `json:"scheduled_event_id"`
}

type IEventPollerService interface {
	Start(ctx context.Context, wg *sync.WaitGroup)
}

type eventPollerService struct {
	repo         repositories.IEventRepository
	redisClient  *redis.Client
	logger       *zap.Logger
	queueName    string
	batchSize    int
	pollInterval time.Duration
}

func NewEventPollerService(
	repo repositories.IEventRepository,
	redisClient *redis.Client,
	logger *zap.Logger,
	queueName string,
	batchSize int,
	pollInterval time.Duration,
) IEventPollerService {
	return &eventPollerService{
		repo:         repo,
		redisClient:  redisClient,
		logger:       logger,
		queueName:    queueName,
		batchSize:    batchSize,
		pollInterval: pollInterval,
	}
}

func (s *eventPollerService) Start(ctx context.Context, wg *sync.WaitGroup) {
	s.logger.Info("Starting event poller service",
		zap.Duration("interval", s.pollInterval),
		zap.String("queue", s.queueName),
		zap.Int("batch_size", s.batchSize))

	wg.Add(1)

	go func() {
		defer wg.Done()
		ticker := time.NewTicker(s.pollInterval)
		defer ticker.Stop()

		for {
			select {
			case <-ticker.C:
				pollCtx, cancel := context.WithTimeout(ctx, s.pollInterval-time.Second)

				if err := s.pollAndEnqueue(pollCtx); err != nil {
					s.logger.Error("Polling cycle failed", zap.Error(err))
				}
				cancel()
			case <-ctx.Done():
				s.logger.Info("Stopping event poller service due to context cancellation")
				return
			}
		}
	}()
}

func (s *eventPollerService) pollAndEnqueue(ctx context.Context) error {
	s.logger.Info("Polling for due events...")

	dueEvents, err := s.repo.FindDueEvents(ctx, s.batchSize)
	if err != nil {
		s.logger.Error("Failed to find due events", zap.Error(err))
		return err
	}

	if len(dueEvents) == 0 {
		s.logger.Info("No due events found")
		return nil
	}

	s.logger.Info("Found due events", zap.Int("count", len(dueEvents)))

	// TODO: using sync.mutex or atomic operations to ensure thread safety
	claimedCount := 0
	var wg sync.WaitGroup

	for _, event := range dueEvents {
		wg.Add(1)

		go func(evt models.ScheduledEvent) {
			defer wg.Done()
			claimCtx, cancel := context.WithTimeout(ctx, 10*time.Second)
			defer cancel()

			claimed, err := s.repo.ClaimEvent(ctx, evt.ID)
			if err != nil {
				s.logger.Error("Failed to claim event", zap.Int("event_id", evt.ID), zap.Error(err))
				return
			}

			if claimed {
				payloadData := EventProcessingPayload{ScheduledEventID: evt.ID}
				payloadBytes, err := json.Marshal(payloadData)

				if err != nil {
					s.logger.Error("Failed to marshal event payload", zap.Int("event_id", evt.ID), zap.Error(err))

					// TODO: Un-claim the event (set status back to "Active" or "Error")

					return
				}

				cmdResult := s.redisClient.RPush(claimCtx, s.queueName, payloadBytes)

				if cmdResult.Err() != nil {
					s.logger.Error("Failed to RPUSH to Redis list",
						zap.Int("event_id", evt.ID),
						zap.String("queue", s.queueName),
						zap.Error(err))
					// TODO: Rollback DB status (set status back to "Active" or "Error")

					return
				}

				s.logger.Info("Successfully claimed and enqueued event",
					zap.Int("event_id", evt.ID))

				claimedCount++
			} else {
				s.logger.Debug("Event was already claimed", zap.Int("event_id", evt.ID))
			}
		}(event)
	}

	wg.Wait()
	s.logger.Info("Finished polling cycle processing", zap.Int("count", claimedCount))
	return nil
}
