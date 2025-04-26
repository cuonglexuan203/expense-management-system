package common

type BaseEntity[T any] struct {
	ID T `gorm:"primaryKey;column:Id"`
}
