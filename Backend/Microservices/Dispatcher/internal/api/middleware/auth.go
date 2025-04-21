package middleware

import (
	"net/http"

	"github.com/cuonglexuan203/dispatcher/internal/api/models"
	applogger "github.com/cuonglexuan203/dispatcher/pkg/logger"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

const ApiKeyHeader = "X-API-KEY"

func APIKeyAuth(expectedApiKey string) gin.HandlerFunc {
	logger := applogger.GetLogger()
	if expectedApiKey == "" {
		logger.Info("API Key is not set, skipping API key authentication")
		return func(c *gin.Context) {
			c.Next()
		}
	}

	return func(c *gin.Context) {
		apiKey := c.GetHeader(ApiKeyHeader)
		if apiKey == "" {
			logger.Warn("Missing API Key", zap.String("ip", c.ClientIP()))
			c.AbortWithStatusJSON(http.StatusUnauthorized, models.ErrorResponse{
				Error: "Unauthorized: Missing API Key",
			})
			return
		}

		if apiKey != expectedApiKey {
			logger.Warn("Invalid API Key", zap.String("ip", c.ClientIP()))
			c.AbortWithStatusJSON(http.StatusUnauthorized, models.ErrorResponse{
				Error: "Unauthorized: Invalid API Key",
			})
			return
		}

		c.Next()
	}
}
