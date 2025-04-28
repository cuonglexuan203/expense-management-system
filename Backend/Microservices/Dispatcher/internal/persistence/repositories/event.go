package repositories

import (
	"context"
	"fmt"
	"time"

	"github.com/cuonglexuan203/dispatcher/internal/models"
	"gorm.io/gorm"
)

type EventRepository struct {
	db *gorm.DB
}

func NewEventRepository(db *gorm.DB) *EventRepository {
	return &EventRepository{
		db: db,
	}
}

func (r *EventRepository) FindDueEvents(ctx context.Context, limit int) ([]models.ScheduledEvent, error) {
	var events []models.ScheduledEvent
	now := time.Now().UTC()

	err := r.db.WithContext(ctx).
		Select("Id", "NextOccurrence", "Status").
		Where("\"Status\" = ? and \"NextOccurrence\" IS NOT NULL AND \"NextOccurrence\" <= ?", "Active", now).
		Order("\"NextOccurrence\" ASC").
		Limit(limit).
		Find(&events).Error

	if err != nil && err != gorm.ErrRecordNotFound {
		return nil, fmt.Errorf("failed to query due events: %w", err)
	}

	return events, nil
}

func (r *EventRepository) ClaimEvent(ctx context.Context, eventID int) (bool, error) {
	tx := r.db.WithContext(ctx).Begin()
	if tx.Error != nil {
		return false, fmt.Errorf("failed to begin transaction: %w", tx.Error)
	}

	defer tx.Rollback()

	result := tx.Model(&models.ScheduledEvent{}).
		Where("\"Id\" = ? AND \"Status\" = ?", eventID, "Active").
		Update("Status", "Queued")

	if result.Error != nil {
		return false, fmt.Errorf("failed to update event status: %w", result.Error)
	}

	if err := tx.Commit().Error; err != nil {
		return false, fmt.Errorf("failed to commit transaction: %w", err)
	}

	return result.RowsAffected == 1, nil
}
