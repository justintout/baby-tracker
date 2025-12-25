package middleware

import (
	"context"
	"net/http"
	"strings"

	"firebase.google.com/go/v4/auth"
)

type contextKey string

const (
	// UserIDKey is the context key for the authenticated user ID
	UserIDKey contextKey = "userId"
	// UserEmailKey is the context key for the authenticated user email
	UserEmailKey contextKey = "userEmail"
	// TokenKey is the context key for the verified Firebase token
	TokenKey contextKey = "token"
)

// FirebaseAuth creates a middleware that validates Firebase ID tokens
func FirebaseAuth(authClient *auth.Client) func(http.Handler) http.Handler {
	return func(next http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			authHeader := r.Header.Get("Authorization")
			if authHeader == "" {
				http.Error(w, `{"error":{"code":"UNAUTHORIZED","message":"Missing authorization header"}}`, http.StatusUnauthorized)
				return
			}

			// Extract token from "Bearer <token>"
			parts := strings.SplitN(authHeader, " ", 2)
			if len(parts) != 2 || !strings.EqualFold(parts[0], "bearer") {
				http.Error(w, `{"error":{"code":"UNAUTHORIZED","message":"Invalid authorization header format"}}`, http.StatusUnauthorized)
				return
			}
			idToken := parts[1]

			// Verify the ID token
			token, err := authClient.VerifyIDToken(r.Context(), idToken)
			if err != nil {
				http.Error(w, `{"error":{"code":"UNAUTHORIZED","message":"Invalid or expired token"}}`, http.StatusUnauthorized)
				return
			}

			// Add user info to context
			ctx := r.Context()
			ctx = context.WithValue(ctx, UserIDKey, token.UID)
			ctx = context.WithValue(ctx, TokenKey, token)

			// Add email if available
			if email, ok := token.Claims["email"].(string); ok {
				ctx = context.WithValue(ctx, UserEmailKey, email)
			}

			next.ServeHTTP(w, r.WithContext(ctx))
		})
	}
}

// GetUserID extracts the user ID from the request context
func GetUserID(ctx context.Context) string {
	if uid, ok := ctx.Value(UserIDKey).(string); ok {
		return uid
	}
	return ""
}

// GetUserEmail extracts the user email from the request context
func GetUserEmail(ctx context.Context) string {
	if email, ok := ctx.Value(UserEmailKey).(string); ok {
		return email
	}
	return ""
}

// GetToken extracts the verified token from the request context
func GetToken(ctx context.Context) *auth.Token {
	if token, ok := ctx.Value(TokenKey).(*auth.Token); ok {
		return token
	}
	return nil
}
