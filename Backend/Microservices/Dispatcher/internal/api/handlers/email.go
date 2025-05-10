package handlers

import (
	"crypto/tls"
	"net/http"

	"github.com/cuonglexuan203/dispatcher/config"
	"github.com/cuonglexuan203/dispatcher/internal/api/models"
	applogger "github.com/cuonglexuan203/dispatcher/pkg/logger"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"gopkg.in/gomail.v2"
)

type EmailHandler struct {
	logger *zap.Logger
	cfg    config.Config
}

func NewEmailHandler(cfg config.Config) *EmailHandler {
	return &EmailHandler{
		logger: applogger.GetLogger(),
		cfg:    cfg,
	}
}

func (h *EmailHandler) SendEmail(c *gin.Context) {
	var req models.EmailRequest

	if err := c.ShouldBindJSON(&req); err != nil {
		h.logger.Error("Failed to bind JSON", zap.Error(err))

		c.JSON(http.StatusBadRequest, models.ErrorResponse{
			Error: "Invalid request payload",
		})
		return
	}

	m := gomail.NewMessage()
	m.SetHeader("From", h.cfg.SenderEmail)
	m.SetHeader("To", req.To)
	m.SetHeader("Subject", req.Subject)
	m.SetBody("text/html", req.HTMLBody)

	h.logger.Info("Host info", zap.String("SMTPHost", h.cfg.SMTPHost), zap.Int("SMTPPort", h.cfg.SMTPPort),
		zap.String("UserName", h.cfg.SMTPUserName), zap.String("Password", h.cfg.SMTPPassword), zap.String("SenderEmail", h.cfg.SenderEmail))

	d := gomail.NewDialer(h.cfg.SMTPHost, h.cfg.SMTPPort, h.cfg.SMTPUserName, h.cfg.SMTPPassword)

	if h.cfg.InsecureSkipVerify {
		d.TLSConfig = &tls.Config{
			InsecureSkipVerify: true,
		}
		h.logger.Warn("TLS InsecureSkipVerify is enabled for SMTP connection.")
	}

	if err := d.DialAndSend(m); err != nil {
		h.logger.Error("Failed to send email", zap.String("To", req.To), zap.Error(err))
		c.JSON(http.StatusInternalServerError, models.ErrorResponse{Error: "Failed to send email"})
		return
	}

	h.logger.Info("Email sent successfully", zap.String("To", req.To))
	c.JSON(http.StatusOK, models.SuccessResponse{Message: "Email sent successfully"})
}
