package router

import (
	"net/http"

	"firebase.google.com/go/v4/auth"
	"github.com/go-chi/chi/v5"
	"github.com/go-chi/chi/v5/middleware"
	"github.com/justintout/baby-tracker/backend/internal/handler"
	authmw "github.com/justintout/baby-tracker/backend/internal/middleware"
)

func New(h *handler.Handler, authClient *auth.Client) http.Handler {
	r := chi.NewRouter()

	// Global middleware
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)
	r.Use(middleware.RealIP)
	r.Use(middleware.RequestID)

	// Health check (unauthenticated)
	r.Get("/health", h.Health.Check)

	// Protected API routes
	r.Route("/api/v1", func(r chi.Router) {
		r.Use(authmw.FirebaseAuth(authClient))

		// Invitation routes (to be added)
		// Media routes (to be added)
		// Export routes (to be added)

		// User info endpoint (for testing auth)
		r.Get("/me", h.Health.Me)
	})

	return r
}
