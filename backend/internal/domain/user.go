package domain

import "time"

type User struct {
	ID          string    `json:"id" firestore:"-"`
	Email       string    `json:"email" firestore:"email"`
	DisplayName string    `json:"displayName" firestore:"displayName"`
	PhotoURL    string    `json:"photoURL,omitempty" firestore:"photoURL,omitempty"`
	FamilyIDs   []string  `json:"familyIds" firestore:"familyIds"`
	Settings    Settings  `json:"settings" firestore:"settings"`
	CreatedAt   time.Time `json:"createdAt" firestore:"createdAt"`
	UpdatedAt   time.Time `json:"updatedAt" firestore:"updatedAt"`
}

type Settings struct {
	DefaultChildID string `json:"defaultChildId,omitempty" firestore:"defaultChildId,omitempty"`
	Notifications  bool   `json:"notifications" firestore:"notifications"`
	Theme          string `json:"theme" firestore:"theme"`
}
