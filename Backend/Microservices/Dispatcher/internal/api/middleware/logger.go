package middleware

import (
	"time"

	applogger "github.com/cuonglexuan203/dispatcher/pkg/logger"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

func RequestLogger() gin.HandlerFunc {
	logger := applogger.GetLogger()
	return func(c *gin.Context) {
		start := time.Now()
		path := c.Request.URL.Path
		raw := c.Request.URL.RawQuery

		c.Next()

		latency := time.Since(start)
		clientIP := c.ClientIP()
		method := c.Request.Method
		statusCode := c.Writer.Status()
		userAgent := c.Request.UserAgent()

		if raw != "" {
			path += "?" + raw
		}

		logFields := []zap.Field{
			zap.Int("status", statusCode),
			zap.String("method", method),
			zap.String("path", path),
			zap.String("ip", clientIP),
			zap.Duration("latency", latency),
			zap.String("user_agent", userAgent),
		}

		if len(c.Errors) > 0 {
			for _, err := range c.Errors {
				logFields = append(logFields, zap.Error(err.Err))
			}

			logger.Error("Request completed with errors", logFields...)
		} else {
			if statusCode > 500 {
				logger.Error("Server error", logFields...)
			} else if statusCode > 400 {
				logger.Warn("Client error", logFields...)
			} else {
				logger.Info("Request completed", logFields...)
			}
		}
	}
}
