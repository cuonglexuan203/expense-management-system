package repositories

import (
	"context"

	"github.com/cuonglexuan203/dispatcher/internal/models"
)

type IEventRepository interface {
	FindDueEvents(ctx context.Context, limit int) ([]models.ScheduledEvent, error)
	ClaimEvent(ctx context.Context, eventID int) (bool, error)
}
