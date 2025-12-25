package handler

import (
	"net/http"

	"github.com/justintout/baby-tracker/backend/internal/middleware"
)

type HealthHandler struct{}

type healthResponse struct {
	Status  string `json:"status"`
	Version string `json:"version"`
}

type meResponse struct {
	UserID string `json:"userId"`
	Email  string `json:"email,omitempty"`
}

func (h *HealthHandler) Check(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, http.StatusOK, healthResponse{
		Status:  "healthy",
		Version: "0.1.0",
	})
}

// Me returns the authenticated user's info (for testing auth)
func (h *HealthHandler) Me(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r.Context())
	email := middleware.GetUserEmail(r.Context())

	writeJSON(w, http.StatusOK, meResponse{
		UserID: userID,
		Email:  email,
	})
}
