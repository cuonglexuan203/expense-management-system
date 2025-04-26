package scheduler

import (
	"context"
	"fmt"

	"github.com/cuonglexuan203/dispatcher/config"
	"github.com/cuonglexuan203/dispatcher/internal/clients/backend"
	"github.com/cuonglexuan203/dispatcher/internal/firebase"
	"github.com/cuonglexuan203/dispatcher/internal/scheduler/tasks"
	applogger "github.com/cuonglexuan203/dispatcher/pkg/logger"
	"github.com/hibiken/asynq"
	"go.uber.org/zap"
	"gorm.io/gorm"
)

func RunAsynqServer(
	cfg config.Config,
	fcmService *firebase.FCMService,
	db *gorm.DB,
	backendClient *backend.BackendClient) *asynq.Server {
	logger := applogger.GetLogger()
	redisOpt := asynq.RedisClientOpt{
		Addr:     cfg.RedisAddr,
		Password: cfg.RedisPassword,
		DB:       cfg.RedisDB,
	}

	srv := asynq.NewServer(
		redisOpt,
		asynq.Config{
			Concurrency: 10,
			Queues: map[string]int{
				"critical": 6,
				"default":  3,
				"low":      1,
			},
			ErrorHandler: asynq.ErrorHandlerFunc(func(ctx context.Context, task *asynq.Task, err error) {
				logger.Error("Asynq task processing error",
					zap.String("task_id", task.Type()),
					zap.ByteString("payload", task.Payload()),
					zap.Error(err),
				)
			}),
			Logger: NewAsynqZapAdapter(logger),
		},
	)

	mux := asynq.NewServeMux()

	// Register task handlers
	notificationTaskHandler := tasks.NewNotificationTaskHandler(logger, fcmService, db, backendClient)
	mux.HandleFunc(tasks.TypeNotificationSend, notificationTaskHandler.HandleSendNotificationTask)
	// End of task handlers registration

	logger.Info("Starting Asynq server...")

	go func() {
		if err := srv.Run(mux); err != nil {
			logger.Fatal("Could not run Asynq server", zap.Error(err))
		}
	}()

	logger.Info("Asynq server started")

	return srv
}

type AsynqZapAdapter struct {
	logger *zap.Logger
}

func NewAsynqZapAdapter(logger *zap.Logger) *AsynqZapAdapter {
	return &AsynqZapAdapter{logger: logger.WithOptions(zap.AddCallerSkip(1))}
}

func (a *AsynqZapAdapter) Debug(args ...interface{}) {
	a.logger.Debug(fmt.Sprint(args...))
}

func (a *AsynqZapAdapter) Info(args ...interface{}) {
	a.logger.Info(fmt.Sprint(args...))
}

func (a *AsynqZapAdapter) Warn(args ...interface{}) {
	a.logger.Warn(fmt.Sprint(args...))
}

func (a *AsynqZapAdapter) Error(args ...interface{}) {
	a.logger.Error(fmt.Sprint(args...))
}

func (a *AsynqZapAdapter) Fatal(args ...interface{}) {
	a.logger.Fatal(fmt.Sprint(args...))
}
