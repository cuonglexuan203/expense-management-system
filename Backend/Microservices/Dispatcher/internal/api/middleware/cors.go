package middleware

import (
	"github.com/cuonglexuan203/dispatcher/config"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

func CORSMiddleware(cfg config.Config) gin.HandlerFunc {
	return cors.New(cors.Config{
		AllowOrigins:     cfg.CorsAllowedOrigins,
		AllowMethods:     cfg.CorsAllowedMethods,
		AllowHeaders:     cfg.CorsAllowedHeaders,
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: true,
		MaxAge:           cfg.CorsMaxAge,
	})
}
