package config

import (
	"context"

	firebase "firebase.google.com/go/v4"
	"firebase.google.com/go/v4/auth"
	"google.golang.org/api/option"
)

type FirebaseApp struct {
	App  *firebase.App
	Auth *auth.Client
}

// InitFirebase initializes the Firebase Admin SDK
// Uses GOOGLE_APPLICATION_CREDENTIALS environment variable for service account
func InitFirebase(ctx context.Context, projectID string) (*FirebaseApp, error) {
	var opts []option.ClientOption
	if projectID != "" {
		config := &firebase.Config{
			ProjectID: projectID,
		}
		app, err := firebase.NewApp(ctx, config, opts...)
		if err != nil {
			return nil, err
		}
		return initClients(ctx, app)
	}

	// Use default credentials (from GOOGLE_APPLICATION_CREDENTIALS)
	app, err := firebase.NewApp(ctx, nil, opts...)
	if err != nil {
		return nil, err
	}

	return initClients(ctx, app)
}

func initClients(ctx context.Context, app *firebase.App) (*FirebaseApp, error) {
	authClient, err := app.Auth(ctx)
	if err != nil {
		return nil, err
	}

	return &FirebaseApp{
		App:  app,
		Auth: authClient,
	}, nil
}
