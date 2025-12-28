# Baby Tracker

A mobile app for tracking newborn information with real-time sync between caregivers.

## Features

- **Tracking**: Feedings (breast/bottle/formula), diaper changes, sleep/naps, growth measurements
- **Growth charts**: Track weight, height, and head circumference over time
- **Insights**: Daily summaries and 7-day feeding trends with fl_chart visualizations
- **Multi-baby profiles**: Manage multiple children, switch between them easily
- **Multi-user sync**: Parents and caregivers share access in real-time
- **Quick entry**: One-tap buttons for fast logging
- **Passwordless auth**: Magic link email sign-in

## Tech Stack

| Component | Technology |
|-----------|------------|
| Mobile App | Flutter 3.38+ (iOS, Android, macOS) |
| Backend API | Go 1.24 on Google Cloud Run |
| Database | Firebase Firestore |
| Auth | Firebase Auth (magic link) |
| Storage | Firebase Storage |
| CI/CD | GitHub Actions |

## Project Structure

```
baby-tracker/
├── app/                    # Flutter mobile app
│   ├── lib/
│   │   ├── core/          # Theme, constants, utilities
│   │   ├── features/      # Feature modules
│   │   │   ├── auth/      # Magic link authentication
│   │   │   ├── tracking/  # Feeding, diaper, sleep tracking
│   │   │   ├── family/    # Family & child management
│   │   │   └── media/     # Photo & video capture
│   │   └── routing/       # GoRouter navigation
│   └── ios/               # iOS native config
├── backend/               # Go API server
│   ├── cmd/api/          # Entry point
│   ├── internal/
│   │   ├── config/       # Firebase config
│   │   ├── handler/      # HTTP handlers
│   │   ├── middleware/   # Auth middleware
│   │   └── router/       # Route definitions
│   └── scripts/          # Deployment scripts
├── firebase/             # Security rules & indexes
└── .github/workflows/    # CI/CD pipelines
```

## Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│  Flutter App    │────▶│  Firebase Auth  │     │   Cloud Run     │
│  (iOS/Android)  │     │  (Magic Link)   │     │   (Go API)      │
└────────┬────────┘     └─────────────────┘     └────────┬────────┘
         │                                               │
         │              ┌─────────────────┐              │
         └─────────────▶│    Firestore    │◀─────────────┘
                        │   (Real-time)   │
                        └─────────────────┘
```

- **Direct Firestore access** from Flutter for CRUD operations
- **Security rules** enforce access control at the database level
- **Go backend** handles privileged operations (invitations, media processing, exports)

## Development Setup

### Prerequisites

- Flutter SDK 3.38+
- Go 1.24+
- Firebase CLI (`npm install -g firebase-tools`)
- Xcode 16+ (for iOS)
- CocoaPods (`sudo gem install cocoapods`)

### Flutter App

```bash
cd app

# Install dependencies
flutter pub get

# Generate code (freezed, json_serializable, riverpod)
flutter pub run build_runner build

# Run on iOS Simulator
flutter run -d iPhone
```

### Go Backend

```bash
cd backend

# Set environment variables
export PORT=8080
export FIREBASE_PROJECT_ID=baby-tracker-88ca3
export GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account.json

# Run locally
go run ./cmd/api

# Test health endpoint
curl http://localhost:8080/health
```

### Firebase Emulators (optional)

```bash
firebase emulators:start
```

## API Endpoints

### Health
- `GET /health` - Server health status

### Authentication (requires Firebase token)
- `GET /api/v1/me` - Get current user info

### Coming Soon
- `POST /api/v1/families/{familyId}/invitations` - Create invitation
- `POST /api/v1/invitations/{token}/accept` - Accept invitation
- `POST /api/v1/media/upload-url` - Get signed upload URL
- `POST /api/v1/children/{childId}/export` - Generate data export

## Deployment

### Backend (Cloud Run)

Automated via GitHub Actions on push to `main`:

```
Push to main (backend/**) → Build Docker → Push to Artifact Registry → Deploy to Cloud Run
```

**Live URL:** https://baby-tracker-api-k4gfnqrzeq-uc.a.run.app

#### Manual Setup (one-time)

```bash
cd backend/scripts
./setup-github-deploy.sh
```

This sets up:
- Artifact Registry repository
- Service account with minimal permissions
- Workload Identity Federation (keyless GitHub auth)

Then add the output secrets to GitHub:
- `WIF_PROVIDER`
- `WIF_SERVICE_ACCOUNT`

### Firebase

```bash
# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Storage rules
firebase deploy --only storage
```

### App Distribution (Android Beta Testing)

Automated via GitHub Actions on push to `main` (when `app/**` changes):

```
Push to main (app/**) → Build APK → Upload to Firebase App Distribution → Testers notified
```

#### One-time Setup

1. **Enable App Distribution** in [Firebase Console](https://console.firebase.google.com/project/baby-tracker-88ca3/appdistribution)

2. **Create tester group** called `testers` and add tester emails

3. **Create Firebase service account:**
   ```bash
   # In Google Cloud Console, create a service account with these roles:
   # - Firebase App Distribution Admin
   # - Service Account User

   # Download the JSON key file
   ```

4. **Add GitHub secret:**
   - Go to repo Settings → Secrets → Actions
   - Add `FIREBASE_SERVICE_ACCOUNT` with the JSON key file contents

#### Manual Distribution

```bash
cd app

# Build release APK
flutter build apk --release

# Install Firebase CLI tools
npm install -g firebase-tools
firebase login

# Distribute to testers
firebase appdistribution:distribute \
  build/app/outputs/flutter-apk/app-release.apk \
  --app 1:865964287500:android:957d61901427ccd8d9f029 \
  --groups "testers" \
  --release-notes "Testing build"
```

#### How Testers Install

1. Tester receives email invite from Firebase
2. Downloads **Firebase App Tester** app from Play Store
3. Signs in with invited email
4. Installs the app directly from App Tester

## Environment Variables

### Backend (Cloud Run)
| Variable | Description |
|----------|-------------|
| `PORT` | Server port (default: 8080) |
| `FIREBASE_PROJECT_ID` | Firebase project ID |

### Flutter App
Firebase config is in `app/lib/firebase_options.dart` (generated by FlutterFire CLI).

## Testing

### Flutter
```bash
cd app
flutter test
```

### Backend
```bash
cd backend
go test ./...
```

## License

Proprietary - All rights reserved
