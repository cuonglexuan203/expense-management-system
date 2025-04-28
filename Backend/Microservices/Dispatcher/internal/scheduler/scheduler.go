package scheduler

import (
	"fmt"

	"github.com/cuonglexuan203/dispatcher/config"
	"github.com/cuonglexuan203/dispatcher/internal/scheduler/tasks"
	applogger "github.com/cuonglexuan203/dispatcher/pkg/logger"
	"github.com/hibiken/asynq"
	"go.uber.org/zap"
)

func RunAsynqScheduler(
	cfg config.Config,
) *asynq.Scheduler {
	logger := applogger.GetLogger()
	redisOpt := asynq.RedisClientOpt{
		Addr:     cfg.RedisAddr,
		Password: cfg.RedisPassword,
		DB:       cfg.RedisDB,
	}

	scheduler := asynq.NewScheduler(
		redisOpt,
		&asynq.SchedulerOpts{
			LogLevel: asynq.InfoLevel,
		},
	)

	task, err := tasks.NewPollEventTask()
	if err != nil {
		logger.Error("Failed to create polling event task", zap.Error(err))
		return nil
	}

	// Register tasks
	taskID := "event_poller_singleton"
	entryID, err := scheduler.Register(
		fmt.Sprintf("@every %s", cfg.EventPollingInterval.String()),
		task,
		asynq.TaskID(taskID),
	)

	if err != nil {
		logger.Fatal("Failed to register polling event task (may already exist)", zap.Error(err))
	} else {
		logger.Info(
			"Registered polling event task",
			zap.String("task_id", taskID),
			zap.String("entry_id", entryID),
			zap.Duration("interval", cfg.EventPollingInterval),
			zap.String("queue_name", cfg.EventProcessingQueue))
	}

	go func() {
		if err := scheduler.Run(); err != nil {
			logger.Fatal("Could not run Asynq scheduler", zap.Error(err))
		}
	}()

	logger.Info("Asynq scheduler started")

	return scheduler
}
