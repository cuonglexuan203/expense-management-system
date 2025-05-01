package models

import "time"

// --- Notification Payloads ---
type SendNotificationRequest struct {
	UserID string            `json:"user_id" binding:"required"`
	Title  string            `json:"title" binding:"required"`
	Body   string            `json:"body" binding:"required"`
	Data   map[string]string `json:"data,omitempty"`
}

type SendNotificationResponse struct {
	Status       string `json:"status"`
	SuccessCount int    `json:"success_count,omitempty"`
	FailureCount int    `json:"failure_count,omitempty"`
}

// --- Scheduling Payloads ---
type ScheduleNotificationRequest struct {
	UserID     string            `json:"user_id" binding:"required"`
	Title      string            `json:"title" binding:"required"`
	Body       string            `json:"body" binding:"required"`
	Data       map[string]string `json:"data,omitempty"`
	ScheduleAt time.Time         `json:"schedule_at" binding:"required"` // RFC 3339 format
	Queue      string            `json:"queue,omitempty"`                // Optional: "critical", "default", "low". Default is "default"
}

type ScheduleNotificationResponse struct {
	TaskID string    `json:"task_id"`
	Status string    `json:"status"`
	RunAt  time.Time `json:"run_at"`
}
