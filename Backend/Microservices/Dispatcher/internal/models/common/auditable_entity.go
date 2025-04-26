package common

import "time"

type AuditableEntity struct {
	CreatedAt time.Time `gorm:"column:CreatedAt"`
	CreatedBy string    `gorm:"column:CreatedBy"`
	UpdatedAt time.Time `gorm:"column:ModifiedAt"`
	UpdatedBy string    `gorm:"column:ModifiedBy"`
	IsDeleted bool      `gorm:"column:IsDeleted"`
	DeletedAt time.Time `gorm:"column:DeletedAt"`
	DeletedBy string    `gorm:"column:DeletedBy"`
}
