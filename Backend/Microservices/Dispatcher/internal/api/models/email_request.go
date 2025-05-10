package models

type EmailRequest struct {
	To       string `json:"to" binding:"required,email"`
	Subject  string `json:"subject" binding:"required"`
	HTMLBody string `json:"html_body" binding:"required"`
}
