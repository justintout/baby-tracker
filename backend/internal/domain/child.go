package domain

import "time"

type Child struct {
	ID        string    `json:"id" firestore:"-"`
	FamilyID  string    `json:"familyId" firestore:"-"` // Parent document reference
	Name      string    `json:"name" firestore:"name"`
	BirthDate time.Time `json:"birthDate" firestore:"birthDate"`
	PhotoURL  string    `json:"photoURL,omitempty" firestore:"photoURL,omitempty"`
	CreatedAt time.Time `json:"createdAt" firestore:"createdAt"`
	UpdatedAt time.Time `json:"updatedAt" firestore:"updatedAt"`
}
