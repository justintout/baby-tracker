package domain

import "time"

type EntryType string

const (
	EntryTypeFeeding EntryType = "feeding"
	EntryTypeDiaper  EntryType = "diaper"
	EntryTypeSleep   EntryType = "sleep"
)

type Entry struct {
	ID        string    `json:"id" firestore:"-"`
	FamilyID  string    `json:"familyId" firestore:"-"`  // Parent reference
	ChildID   string    `json:"childId" firestore:"-"`   // Parent reference
	Type      EntryType `json:"type" firestore:"type"`
	Timestamp time.Time `json:"timestamp" firestore:"timestamp"`
	CreatedAt time.Time `json:"createdAt" firestore:"createdAt"`
	CreatedBy string    `json:"createdBy" firestore:"createdBy"`
	UpdatedAt time.Time `json:"updatedAt" firestore:"updatedAt"`
	UpdatedBy string    `json:"updatedBy" firestore:"updatedBy"`
	Notes     string    `json:"notes,omitempty" firestore:"notes,omitempty"`
	MediaIDs  []string  `json:"mediaIds,omitempty" firestore:"mediaIds,omitempty"`

	// Feeding-specific fields
	FeedingType FeedingType `json:"feedingType,omitempty" firestore:"feedingType,omitempty"`
	Amount      *float64    `json:"amount,omitempty" firestore:"amount,omitempty"`   // ml or oz
	Duration    *int        `json:"duration,omitempty" firestore:"duration,omitempty"` // minutes

	// Diaper-specific fields
	DiaperType DiaperType `json:"diaperType,omitempty" firestore:"diaperType,omitempty"`

	// Sleep-specific fields
	EndTime *time.Time   `json:"endTime,omitempty" firestore:"endTime,omitempty"`
	Quality SleepQuality `json:"quality,omitempty" firestore:"quality,omitempty"`
}

type FeedingType string

const (
	FeedingTypeBreastLeft  FeedingType = "breast_left"
	FeedingTypeBreastRight FeedingType = "breast_right"
	FeedingTypeBottle      FeedingType = "bottle"
	FeedingTypeFormula     FeedingType = "formula"
)

type DiaperType string

const (
	DiaperTypeWet   DiaperType = "wet"
	DiaperTypeDirty DiaperType = "dirty"
	DiaperTypeBoth  DiaperType = "both"
)

type SleepQuality string

const (
	SleepQualityGood SleepQuality = "good"
	SleepQualityFair SleepQuality = "fair"
	SleepQualityPoor SleepQuality = "poor"
)
