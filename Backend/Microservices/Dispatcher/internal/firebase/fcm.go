package firebase

import (
	"context"
	"fmt"

	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/messaging"
	"github.com/cuonglexuan203/dispatcher/config"
	applogger "github.com/cuonglexuan203/dispatcher/pkg/logger"
	"go.uber.org/zap"
	"google.golang.org/api/option"
)

type FCMService struct {
	app    *firebase.App
	client *messaging.Client
	logger *zap.Logger
}

func InitFCM(cfg config.Config) (*FCMService, error) {
	logger := applogger.GetLogger()
	opt := option.WithCredentialsFile(cfg.FirebaseServiceAccountKeyPath)
	app, err := firebase.NewApp(context.Background(), nil, opt)
	if err != nil {
		logger.Error("Error initializing Firebase Admin SDK", zap.Error(err))
		return nil, fmt.Errorf("error initializing Firebase app: %w", err)
	}

	client, err := app.Messaging(context.Background())
	if err != nil {
		logger.Error("Error getting Messaging client", zap.Error(err))
		return nil, fmt.Errorf("error getting Firebase Messaging client: %w", err)
	}

	logger.Info("Firebase Admin SDK initialized successfully")
	return &FCMService{
		app:    app,
		client: client,
		logger: logger,
	}, nil
}

func (s *FCMService) SendPushNotification(ctx context.Context, token string, title string, body string, data map[string]string) (string, error) {
	message := &messaging.Message{
		Notification: &messaging.Notification{
			Title: title,
			Body:  body,
		},
		Data:  data,
		Token: token,
	}

	response, err := s.client.Send(ctx, message)
	if err != nil {
		s.logger.Error("Error sending FCM message", zap.String("token", token), zap.Error(err))
		return "", fmt.Errorf("error sending FCM message: %w", err)
	}

	s.logger.Info("Successfully sent FCM message", zap.String("messageId", response), zap.String("token", token), zap.String("token", token))
	return response, nil
}

func (s *FCMService) SendMulticastNotification(
	ctx context.Context,
	tokens []string,
	title string,
	body string,
	data map[string]string) (*messaging.BatchResponse, error) {

	if len(tokens) == 0 {
		s.logger.Info("No tokens provided for multicast notification, skipping send.")
		return &messaging.BatchResponse{SuccessCount: 0, FailureCount: 0}, nil
	}

	if len(tokens) > 500 {
		s.logger.Warn("Attempting to send to more than 500 tokens. FCM may reject.",
			zap.Int("token_count", len(tokens)))
	}

	message := &messaging.MulticastMessage{
		Notification: &messaging.Notification{
			Title: title,
			Body:  body,
		},
		Data:   data,
		Tokens: tokens,
	}

	br, err := s.client.SendEachForMulticast(ctx, message)
	if err != nil {
		s.logger.Error("Error sending multicast FCM message (request level)",
			zap.Error(err),
			zap.Int("token_count", len(tokens)))
		return nil, fmt.Errorf("error sending multicast FCM message: %w", err)
	}

	if br.FailureCount > 0 {
		s.logger.Error("Some multicast FCM messages failed",
			zap.Int("success_count", br.SuccessCount),
			zap.Int("failure_count", br.FailureCount),
			zap.Int("total_tokens", len(tokens)))

		// for i, resp := range br.Responses {
		// 	if !resp.Success {
		// 		s.logger.Error("Failed token in multicast", zap.String("token", tokens[i]), zap.Error(resp.Error))
		// 	}
		// }
	} else {
		s.logger.Info("Successfully sent multicast FCM message",
			zap.Int("success_count", br.SuccessCount),
			zap.Int("total_tokens", len(tokens)))
	}

	return br, nil
}
