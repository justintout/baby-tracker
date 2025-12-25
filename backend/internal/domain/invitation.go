package domain

import "time"

type InvitationStatus string

const (
	InvitationStatusPending  InvitationStatus = "pending"
	InvitationStatusAccepted InvitationStatus = "accepted"
	InvitationStatusExpired  InvitationStatus = "expired"
	InvitationStatusRevoked  InvitationStatus = "revoked"
)

type Invitation struct {
	ID         string           `json:"id" firestore:"-"`
	FamilyID   string           `json:"familyId" firestore:"familyId"`
	Email      string           `json:"email" firestore:"email"`
	InvitedBy  string           `json:"invitedBy" firestore:"invitedBy"`
	Role       MemberRole       `json:"role" firestore:"role"`
	Token      string           `json:"token" firestore:"token"`
	Status     InvitationStatus `json:"status" firestore:"status"`
	CreatedAt  time.Time        `json:"createdAt" firestore:"createdAt"`
	ExpiresAt  time.Time        `json:"expiresAt" firestore:"expiresAt"`
	AcceptedAt *time.Time       `json:"acceptedAt,omitempty" firestore:"acceptedAt,omitempty"`
}
