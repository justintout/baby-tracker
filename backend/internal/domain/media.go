package domain

import "time"

type MediaType string

const (
	MediaTypePhoto MediaType = "photo"
	MediaTypeVideo MediaType = "video"
)

type UploadStatus string

const (
	UploadStatusPending    UploadStatus = "pending"
	UploadStatusProcessing UploadStatus = "processing"
	UploadStatusComplete   UploadStatus = "complete"
	UploadStatusFailed     UploadStatus = "failed"
)

type Media struct {
	ID           string       `json:"id" firestore:"-"`
	FamilyID     string       `json:"familyId" firestore:"-"`  // Parent reference
	ChildID      string       `json:"childId" firestore:"-"`   // Parent reference
	Type         MediaType    `json:"type" firestore:"type"`
	OriginalURL  string       `json:"originalUrl" firestore:"originalUrl"`
	ThumbnailURL string       `json:"thumbnailUrl,omitempty" firestore:"thumbnailUrl,omitempty"`
	Caption      string       `json:"caption,omitempty" firestore:"caption,omitempty"`
	Timestamp    time.Time    `json:"timestamp" firestore:"timestamp"`
	CreatedAt    time.Time    `json:"createdAt" firestore:"createdAt"`
	CreatedBy    string       `json:"createdBy" firestore:"createdBy"`
	EntryID      string       `json:"entryId,omitempty" firestore:"entryId,omitempty"`
	FileSize     int64        `json:"fileSize" firestore:"fileSize"`
	MimeType     string       `json:"mimeType" firestore:"mimeType"`
	UploadStatus UploadStatus `json:"uploadStatus" firestore:"uploadStatus"`
}
