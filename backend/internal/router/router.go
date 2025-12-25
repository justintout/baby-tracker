package router

import (
	"net/http"

	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/justintout/baby-tracker/backend/internal/handler"
)

func New(h *handler.Handler) http.Handler {
	r := chi.NewRouter()

	// Middleware
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)
	r.Use(middleware.RealIP)
	r.Use(middleware.RequestID)

	// Health check (unauthenticated)
	r.Get("/health", h.Health.Check)

	// API routes (will add auth middleware later)
	r.Route("/api/v1", func(r chi.Router) {
		// Invitation routes (to be added)
		// Media routes (to be added)
		// Export routes (to be added)
	})

	return r
}
