package backend

import (
	"context"
	"encoding/json"
	"fmt"
	"net/http"
	"net/url"
	"time"

	"github.com/cuonglexuan203/dispatcher/config"
	applogger "github.com/cuonglexuan203/dispatcher/pkg/logger"
	"go.uber.org/zap"
)

const (
	backendAPIKeyHeader = "X-API-KEY"
	defaultTimeout      = 10 * time.Second
)

// Endpoints
const (
	deviceTokens = "/api/v1/device-tokens/users/%s"
)

type BackendClient struct {
	httpClient *http.Client
	baseURL    string
	apiKey     string
	logger     *zap.Logger
}

func NewBackendClient(cfg config.Config) (*BackendClient, error) {
	logger := applogger.GetLogger().Named("BackendClient")

	if cfg.BackendApiUrl == "" {
		logger.Warn("Backend API URL is not configured.")
		return nil, fmt.Errorf("backend API URL is required")
	}

	if cfg.BackendApiKey == "" {
		logger.Warn("Backend API Key is not configured.")
	}

	if _, err := url.ParseRequestURI(cfg.BackendApiUrl); err != nil {
		logger.Error("Invalid Backend API URL", zap.String("url", cfg.BackendApiUrl), zap.Error(err))
		return nil, fmt.Errorf("invalid Backend API URL: %w", err)
	}

	return &BackendClient{
		httpClient: &http.Client{
			Timeout: defaultTimeout,
		},
		baseURL: cfg.BackendApiUrl,
		apiKey:  cfg.BackendApiKey,
		logger:  logger,
	}, nil
}

func (c *BackendClient) GetUserDeviceTokens(ctx context.Context, userID string) ([]string, error) {
	if c.baseURL == "" {
		return nil, fmt.Errorf("backend API URL is not configured")
	}

	endpoint := fmt.Sprintf(c.baseURL+deviceTokens, url.PathEscape(userID))

	req, err := http.NewRequestWithContext(ctx, http.MethodGet, endpoint, nil)
	if err != nil {
		c.logger.Error("Failed to create request for device tokens", zap.String("user_id", userID), zap.Error(err))
		return nil, fmt.Errorf("failed to create request: %w", err)
	}

	req.Header.Set("Accept", "application/json")
	if c.apiKey != "" {
		req.Header.Set(backendAPIKeyHeader, c.apiKey)
	} else {
		c.logger.Warn("Making backend API call without API key", zap.String("user_id", userID), zap.String("url", endpoint))
	}

	c.logger.Debug("Fetching device tokens from backend",
		zap.String("user_id", userID),
		zap.String("url", endpoint))

	resp, err := c.httpClient.Do(req)
	if err != nil {
		c.logger.Error("Failed to call backend API for device tokens",
			zap.String("user_id", userID),
			zap.String("url", endpoint),
			zap.Error(err))
		return nil, fmt.Errorf("backend API request failed: %w", err)
	}

	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		c.logger.Error("Backend API returned non-OK status for device tokens",
			zap.String("user_id", userID),
			zap.String("url", endpoint),
			zap.Int("status_code", resp.StatusCode))
		return nil, fmt.Errorf("backend API returned status %d", resp.StatusCode)
	}

	var tokens []string
	if err := json.NewDecoder(resp.Body).Decode(&tokens); err != nil {
		c.logger.Error("Failed to decode device tokens response form backend",
			zap.String("user_id", userID),
			zap.Error(err))

		return nil, fmt.Errorf("failed to decode backend response: %w", err)
	}

	c.logger.Info("Successfully fetched device tokens from backend",
		zap.String("user_id", userID),
		zap.Int("token_count", len(tokens)))

	return tokens, nil
}
