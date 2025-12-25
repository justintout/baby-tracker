package domain

import "time"

type Family struct {
	ID        string            `json:"id" firestore:"-"`
	Name      string            `json:"name" firestore:"name"`
	CreatedAt time.Time         `json:"createdAt" firestore:"createdAt"`
	CreatedBy string            `json:"createdBy" firestore:"createdBy"`
	MemberIDs []string          `json:"memberIds" firestore:"memberIds"`
	Members   map[string]Member `json:"members" firestore:"members"`
}

type Member struct {
	Role        MemberRole `json:"role" firestore:"role"`
	JoinedAt    time.Time  `json:"joinedAt" firestore:"joinedAt"`
	DisplayName string     `json:"displayName" firestore:"displayName"`
}

type MemberRole string

const (
	MemberRoleOwner     MemberRole = "owner"
	MemberRoleCaregiver MemberRole = "caregiver"
)
