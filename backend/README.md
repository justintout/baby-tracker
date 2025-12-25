# Baby Tracker Backend

Go API server for the Baby Tracker application.

## Prerequisites

- Go 1.21+
- Firebase project with service account credentials

## Development

### Run locally

```bash
# Set environment variables
export PORT=8080
export FIREBASE_PROJECT_ID=your-project-id
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json

# Run the server
go run ./cmd/api
```

### Build

```bash
go build -o bin/server ./cmd/api
```

### Docker

```bash
docker build -t baby-tracker-api .
docker run -p 8080:8080 baby-tracker-api
```

## Project Structure

```
cmd/api/          # Application entry point
internal/
  config/         # Configuration loading
  domain/         # Business entities
  handler/        # HTTP handlers
  middleware/     # HTTP middleware
  repository/     # Data access layer
  service/        # Business logic
  router/         # Route definitions
pkg/
  firebase/       # Firebase SDK wrapper
  imaging/        # Image processing utilities
```

## API Endpoints

### Health Check
- `GET /health` - Server health status

### Invitations (Coming soon)
- `POST /api/v1/families/{familyId}/invitations` - Create invitation
- `POST /api/v1/invitations/{token}/accept` - Accept invitation
- `DELETE /api/v1/invitations/{invitationId}` - Revoke invitation

### Media (Coming soon)
- `POST /api/v1/media/upload-url` - Get signed upload URL
- `POST /api/v1/media/{mediaId}/process` - Process uploaded media

### Exports (Coming soon)
- `POST /api/v1/children/{childId}/export` - Generate data export
- `GET /api/v1/exports/{exportId}` - Download export
