package middleware

import (
	"net/http"

	"github.com/cuonglexuan203/dispatcher/internal/api/models"
	applogger "github.com/cuonglexuan203/dispatcher/pkg/logger"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
)

func ErrorHandler() gin.HandlerFunc {
	logger := applogger.GetLogger()
	return func(c *gin.Context) {
		c.Next()

		if len(c.Errors) > 0 {
			for _, err := range c.Errors {
				logger.Error("Unhandled error during request", zap.Error(err.Err), zap.String("path", c.Request.URL.Path))
			}

			c.JSON(http.StatusInternalServerError, models.ErrorResponse{
				Error: "An internal server error occurred",
			})
		}
	}
}

func Recovery() gin.HandlerFunc {
	logger := applogger.GetLogger()
	return func(c *gin.Context) {
		defer func() {
			if err := recover(); err != nil {
				logger.Error("Panic recovered", zap.Any("error", err), zap.Stack("stack"))

				c.AbortWithStatusJSON(http.StatusInternalServerError, models.ErrorResponse{
					Error: "An internal server error occurred",
				})
			}
		}()
		c.Next()
	}
}
