package models

import (
	"time"

	"github.com/cuonglexuan203/dispatcher/internal/models/common"
)

type Notification struct {
	common.BaseEntity[int]
	common.AuditableEntity
	UserID      string    `gorm:"column:UserId"`
	Type        string    `gorm:"column:Type"`
	Title       string    `gorm:"column:Title"`
	Body        string    `gorm:"column:Body"`
	DataPayload string    `gorm:"column:DataPayload"`
	Status      string    `gorm:"column:Status"` // Values: Queued, Processing, Failed, Sent
	ProcessedAt time.Time `gorm:"column:ProcessedAt"`
}

func (Notification) TableName() string {
	return "Notifications"
}
