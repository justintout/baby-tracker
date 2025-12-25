package handler

import (
	"net/http"
)

type HealthHandler struct{}

type healthResponse struct {
	Status  string `json:"status"`
	Version string `json:"version"`
}

func (h *HealthHandler) Check(w http.ResponseWriter, r *http.Request) {
	writeJSON(w, http.StatusOK, healthResponse{
		Status:  "healthy",
		Version: "0.1.0",
	})
}
