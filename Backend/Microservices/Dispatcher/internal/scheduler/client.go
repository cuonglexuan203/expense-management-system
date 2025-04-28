package scheduler

import (
	"github.com/cuonglexuan203/dispatcher/config"
	applogger "github.com/cuonglexuan203/dispatcher/pkg/logger"
	"github.com/hibiken/asynq"
	"go.uber.org/zap"
)

func NewAsynqClient(cfg config.Config) *asynq.Client {
	logger := applogger.GetLogger()

	redisOpt := asynq.RedisClientOpt{
		Addr:     cfg.RedisAddr,
		Password: cfg.RedisPassword,
		DB:       cfg.RedisDB,
	}

	client := asynq.NewClient(redisOpt)
	logger.Info("Asynq client connected to Redis", zap.String("addr", cfg.RedisAddr), zap.Int("db", cfg.RedisDB))
	return client
}
