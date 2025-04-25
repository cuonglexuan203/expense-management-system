package models

import (
	"time"

	"gorm.io/gorm"
)

type ScheduledTask struct {
	gorm.Model
	AsynqTaskID string    `gorm:"uniqueIndex;not null"`
	TaskType    string    `gorm:"index;not null"`
	Payload     string    `gorm:"type:jsonb"`
	ScheduleAt  time.Time `gorm:"index"`
	Status      string    `gorm:"index;default:'PENDING'"` // PENDING, PROCESSING, COMPLETED, FAILED
	LastError   string
}
