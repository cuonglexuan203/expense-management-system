package models

import (
	"database/sql"

	"github.com/cuonglexuan203/dispatcher/internal/models/common"
)

type ScheduledEvent struct {
	common.BaseEntity[int]
	common.AuditableEntity
	Status         string       `gorm:"column:Status"`
	NextOccurrence sql.NullTime `gorm:"column:NextOccurrence"`
}

func (ScheduledEvent) TableName() string {
	return "ScheduledEvents"
}
