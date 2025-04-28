package redis

import (
	"context"
	"fmt"
	"time"

	"github.com/cuonglexuan203/dispatcher/config"
	"github.com/redis/go-redis/v9"
)

func NewRedisClient(cfg config.Config) (*redis.Client, error) {
	rdb := redis.NewClient(&redis.Options{
		Addr:            cfg.RedisAddr,
		Password:        cfg.RedisPassword,
		DB:              cfg.RedisDB,
		PoolSize:        cfg.RedisPoolSize,
		MinIdleConns:    cfg.RedisMinIdleConns,
		PoolTimeout:     cfg.RedisPoolTimeout,
		ConnMaxIdleTime: cfg.RedisIdleTimeout,
	})

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	if _, err := rdb.Ping(ctx).Result(); err != nil {
		return nil, fmt.Errorf("failed to connect to Redis at %s: %w", cfg.RedisAddr, err)
	}

	return rdb, nil
}
